Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EE3DC233F30
	for <lists+kvm@lfdr.de>; Fri, 31 Jul 2020 08:39:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731375AbgGaGjp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 31 Jul 2020 02:39:45 -0400
Received: from szxga04-in.huawei.com ([45.249.212.190]:8865 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1731224AbgGaGjo (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 31 Jul 2020 02:39:44 -0400
Received: from DGGEMS408-HUB.china.huawei.com (unknown [172.30.72.58])
        by Forcepoint Email with ESMTP id DD9B19CED4C9D6C8A047;
        Fri, 31 Jul 2020 14:39:37 +0800 (CST)
Received: from [127.0.0.1] (10.174.186.173) by DGGEMS408-HUB.china.huawei.com
 (10.3.19.208) with Microsoft SMTP Server id 14.3.487.0; Fri, 31 Jul 2020
 14:39:30 +0800
Subject: Re: [Question] the check of ioeventfd collision in
 kvm_*assign_ioeventfd_idx
To:     Paolo Bonzini <pbonzini@redhat.com>
CC:     "S. Tsirkin, Michael" <mst@redhat.com>, <gleb@redhat.com>,
        <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <kvm@vger.kernel.org>,
        <kvmarm@lists.cs.columbia.edu>,
        Xiexiangyou <xiexiangyou@huawei.com>
References: <bbece68b-fb39-d599-9ba7-a8ee8be16525@huawei.com>
 <CABgObfbFXYodCeGWSnKw0j_n2-QLxpnD_Uyc5r-_ApXv=x+qmw@mail.gmail.com>
From:   Zhenyu Ye <yezhenyu2@huawei.com>
Message-ID: <4aa75d90-f2d2-888c-8970-02a41f3733e4@huawei.com>
Date:   Fri, 31 Jul 2020 14:39:29 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.3.0
MIME-Version: 1.0
In-Reply-To: <CABgObfbFXYodCeGWSnKw0j_n2-QLxpnD_Uyc5r-_ApXv=x+qmw@mail.gmail.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.174.186.173]
X-CFilter-Loop: Reflected
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 2020/7/31 2:03, Paolo Bonzini wrote:
> Yes, I think it's not needed. Probably the deassign check can be turned into an assertion?
> 
> Paolo
> 

I think we can do this in the same function, and turnt he check of
p->eventfd into assertion in kvm_deassign_ioeventfd_idx(). Just like:

---8<---
static inline struct _ioeventfd *
get_ioeventfd(struct kvm *kvm, enum kvm_bus bus_idx,
              struct kvm_ioeventfd *args)
{
        static struct _ioeventfd *_p;
        bool wildcard = !(args->flags & KVM_IOEVENTFD_FLAG_DATAMATCH);

        list_for_each_entry(_p, &kvm->ioeventfds, list)
                if (_p->bus_idx == bus_idx &&
                    _p->addr == args->addr &&
                    (!_p->length || !args->len ||
                     (_p->length == args->len &&
                      (_p->wildcard || wildcard ||
                       _p->datamatch == args->datamatch))))
                        return _p;

        return NULL;
}

kvm_deassign_ioeventfd_idx() {
	...
	p = get_ioeventfd(kvm, bus_idx, args);
	if (p) {
		assert(p->eventfd == eventfd);
		...
	}

---8<----

This may be easier to understand (keep the same logic in assign/deassign).

I will send a formal patch soon.

Thanks,
Zhenyu


> Il gio 30 lug 2020, 16:36 Zhenyu Ye <yezhenyu2@huawei.com <mailto:yezhenyu2@huawei.com>> ha scritto:
> 
>     Hi all,
> 
>     There are checks of ioeventfd collision in both kvm_assign_ioeventfd_idx()
>     and kvm_deassign_ioeventfd_idx(), however, with different logic.
> 
>     In kvm_assign_ioeventfd_idx(), this is done by ioeventfd_check_collision():
>     ---8<---
>             if (_p->bus_idx == p->bus_idx &&
>                 _p->addr == p->addr &&
>                 (!_p->length || !p->length ||
>                  (_p->length == p->length &&
>                   (_p->wildcard || p->wildcard ||
>                    _p->datamatch == p->datamatch))))
>                     // then we consider the two are the same
>     ---8<---
> 
>     The logic in kvm_deassign_ioeventfd_idx() is as follows:
>     ---8<---
>             if (p->bus_idx != bus_idx ||
>                 p->eventfd != eventfd  ||
>                 p->addr != args->addr  ||
>                 p->length != args->len ||
>                 p->wildcard != wildcard)
>                     continue;
> 
>             if (!p->wildcard && p->datamatch != args->datamatch)
>                     continue;
> 
>             // then we consider the two are the same
>     ---8<---
> 
>     As we can see, there is extra check of p->eventfd in
> 
>     ().  Why we don't check p->eventfd
>     in kvm_assign_ioeventfd_idx()? Or should we delete this in
>     kvm_deassign_ioeventfd_idx()?
> 
> 
>     Thanks,
>     Zhenyu
> 

