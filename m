Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B6DC217EEB9
	for <lists+kvm@lfdr.de>; Tue, 10 Mar 2020 03:38:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726833AbgCJCiV convert rfc822-to-8bit (ORCPT
        <rfc822;lists+kvm@lfdr.de>); Mon, 9 Mar 2020 22:38:21 -0400
Received: from szxga08-in.huawei.com ([45.249.212.255]:46238 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725845AbgCJCiU (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 9 Mar 2020 22:38:20 -0400
Received: from DGGEMM405-HUB.china.huawei.com (unknown [172.30.72.55])
        by Forcepoint Email with ESMTP id 481785740B42A67CB5F8;
        Tue, 10 Mar 2020 10:38:18 +0800 (CST)
Received: from dggeme703-chm.china.huawei.com (10.1.199.99) by
 DGGEMM405-HUB.china.huawei.com (10.3.20.213) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Tue, 10 Mar 2020 10:38:16 +0800
Received: from dggeme753-chm.china.huawei.com (10.3.19.99) by
 dggeme703-chm.china.huawei.com (10.1.199.99) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.1713.5; Tue, 10 Mar 2020 10:38:16 +0800
Received: from dggeme753-chm.china.huawei.com ([10.7.64.70]) by
 dggeme753-chm.china.huawei.com ([10.7.64.70]) with mapi id 15.01.1713.004;
 Tue, 10 Mar 2020 10:38:16 +0800
From:   linmiaohe <linmiaohe@huawei.com>
To:     Vitaly Kuznetsov <vkuznets@redhat.com>
CC:     Paolo Bonzini <pbonzini@redhat.com>,
        Jim Mattson <jmattson@google.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Liran Alon <liran.alon@oracle.com>
Subject: Re[PATCH 3/6] KVM: nVMX: properly handle errors in
 nested_vmx_handle_enlightened_vmptrld()
Thread-Topic: Re[PATCH 3/6] KVM: nVMX: properly handle errors in
 nested_vmx_handle_enlightened_vmptrld()
Thread-Index: AdX2g+kg61+qMhM5ThKDU/fibqij4w==
Date:   Tue, 10 Mar 2020 02:38:16 +0000
Message-ID: <a65dcb60347c4300a0a1f53c9f25792c@huawei.com>
Accept-Language: en-US
Content-Language: zh-CN
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.173.221.158]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-CFilter-Loop: Reflected
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi:
Vitaly Kuznetsov <vkuznets@redhat.com> writes:
>nested_vmx_handle_enlightened_vmptrld() fails in two cases:
>- when we fail to kvm_vcpu_map() the supplied GPA
>- when revision_id is incorrect.
>Genuine Hyper-V raises #UD in the former case (at least with *some* incorrect GPAs) and does VMfailInvalid() in the later. KVM doesn't do anything so L1 just gets stuck retrying the same faulty VMLAUNCH.
>
>nested_vmx_handle_enlightened_vmptrld() has two call sites:
>nested_vmx_run() and nested_get_vmcs12_pages(). The former needs to queue do much: the failure there happens after migration when L2 was running (and
>L1 did something weird like wrote to VP assist page from a different vCPU), just kill L1 with KVM_EXIT_INTERNAL_ERROR.
>
>Reported-by: Miaohe Lin <linmiaohe@huawei.com>
>Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>

Thanks for fixing this issue!:) The code looks fine for and it should works as far as I can say.
Reviewed-by: Miaohe Lin <linmiaohe@huawei.com>

