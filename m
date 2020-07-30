Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9987823342D
	for <lists+kvm@lfdr.de>; Thu, 30 Jul 2020 16:20:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729075AbgG3OUS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 30 Jul 2020 10:20:18 -0400
Received: from szxga04-in.huawei.com ([45.249.212.190]:8861 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726772AbgG3OUR (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 30 Jul 2020 10:20:17 -0400
Received: from DGGEMS409-HUB.china.huawei.com (unknown [172.30.72.58])
        by Forcepoint Email with ESMTP id 45E8DC7AD72D78B946C1;
        Thu, 30 Jul 2020 22:19:58 +0800 (CST)
Received: from [127.0.0.1] (10.174.186.173) by DGGEMS409-HUB.china.huawei.com
 (10.3.19.209) with Microsoft SMTP Server id 14.3.487.0; Thu, 30 Jul 2020
 22:19:49 +0800
From:   Zhenyu Ye <yezhenyu2@huawei.com>
Subject: [Question] the check of ioeventfd collision in
 kvm_*assign_ioeventfd_idx
To:     <pbonzini@redhat.com>, <mst@redhat.com>, <gleb@redhat.com>,
        <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <kvm@vger.kernel.org>,
        <kvmarm@lists.cs.columbia.edu>,
        Xiexiangyou <xiexiangyou@huawei.com>, <ghaskins@novell.com>
Message-ID: <bbece68b-fb39-d599-9ba7-a8ee8be16525@huawei.com>
Date:   Thu, 30 Jul 2020 22:19:49 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.3.0
MIME-Version: 1.0
Content-Type: text/plain; charset="gbk"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.174.186.173]
X-CFilter-Loop: Reflected
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi all,

There are checks of ioeventfd collision in both kvm_assign_ioeventfd_idx()
and kvm_deassign_ioeventfd_idx(), however, with different logic.

In kvm_assign_ioeventfd_idx(), this is done by ioeventfd_check_collision():
---8<---
	if (_p->bus_idx == p->bus_idx &&
	    _p->addr == p->addr &&
	    (!_p->length || !p->length ||
	     (_p->length == p->length &&
	      (_p->wildcard || p->wildcard ||
	       _p->datamatch == p->datamatch))))
		// then we consider the two are the same
---8<---

The logic in kvm_deassign_ioeventfd_idx() is as follows:
---8<---
	if (p->bus_idx != bus_idx ||
	    p->eventfd != eventfd  ||
	    p->addr != args->addr  ||
	    p->length != args->len ||
	    p->wildcard != wildcard)
		continue;

	if (!p->wildcard && p->datamatch != args->datamatch)
		continue;

	// then we consider the two are the same
---8<---

As we can see, there is extra check of p->eventfd in

().  Why we don't check p->eventfd
in kvm_assign_ioeventfd_idx()? Or should we delete this in
kvm_deassign_ioeventfd_idx()?


Thanks,
Zhenyu

