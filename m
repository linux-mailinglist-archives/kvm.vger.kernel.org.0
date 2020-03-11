Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6B38C181206
	for <lists+kvm@lfdr.de>; Wed, 11 Mar 2020 08:35:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728269AbgCKHfJ convert rfc822-to-8bit (ORCPT
        <rfc822;lists+kvm@lfdr.de>); Wed, 11 Mar 2020 03:35:09 -0400
Received: from szxga08-in.huawei.com ([45.249.212.255]:37010 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726160AbgCKHfJ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 11 Mar 2020 03:35:09 -0400
Received: from DGGEMM402-HUB.china.huawei.com (unknown [172.30.72.53])
        by Forcepoint Email with ESMTP id 8A9A3905D61B99ACD7FD;
        Wed, 11 Mar 2020 15:35:03 +0800 (CST)
Received: from DGGEMM421-HUB.china.huawei.com (10.1.198.38) by
 DGGEMM402-HUB.china.huawei.com (10.3.20.210) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Wed, 11 Mar 2020 15:35:02 +0800
Received: from DGGEMM528-MBX.china.huawei.com ([169.254.8.90]) by
 dggemm421-hub.china.huawei.com ([10.1.198.38]) with mapi id 14.03.0439.000;
 Wed, 11 Mar 2020 15:34:56 +0800
From:   "Zhoujian (jay)" <jianjay.zhou@huawei.com>
To:     zhukeqian <zhukeqian1@huawei.com>, Marc Zyngier <maz@kernel.org>
CC:     "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        James Morse <james.morse@arm.com>,
        Julien Thierry <julien.thierry.kdev@gmail.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        "Huangweidong (C)" <weidong.huang@huawei.com>,
        "wangxin (U)" <wangxinxin.wang@huawei.com>
Subject: RE: [RFC] KVM: arm64: support enabling dirty log graually in small
 chunks
Thread-Topic: [RFC] KVM: arm64: support enabling dirty log graually in small
 chunks
Thread-Index: AQHV9fES7bnu3RiLvUOZvoLEbVPgkKg/noOAgAFalYCAAFE+gIABLpcAgACIxzA=
Date:   Wed, 11 Mar 2020 07:34:55 +0000
Message-ID: <B2D15215269B544CADD246097EACE7474BB64495@DGGEMM528-MBX.china.huawei.com>
References: <20200309085727.1106-1-zhukeqian1@huawei.com>
 <4b85699ec1d354cc73f5302560231f86@misterjones.org>
 <64925c8b-af3d-beb5-bc9b-66ef1e47f92d@huawei.com>
 <a642a79ea9190542a9098e4c9dc5a9f2@kernel.org>
 <9ddefc54-dd5b-0555-0aaa-00a3a23febcf@huawei.com>
In-Reply-To: <9ddefc54-dd5b-0555-0aaa-00a3a23febcf@huawei.com>
Accept-Language: zh-CN, en-US
Content-Language: zh-CN
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.173.228.206]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-CFilter-Loop: Reflected
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



> -----Original Message-----
> From: zhukeqian
> Sent: Wednesday, March 11, 2020 3:20 PM
> To: Marc Zyngier <maz@kernel.org>
> Cc: kvmarm@lists.cs.columbia.edu; kvm@vger.kernel.org;
> linux-kernel@vger.kernel.org; linux-arm-kernel@lists.infradead.org; Zhoujian (jay)
> <jianjay.zhou@huawei.com>; Sean Christopherson
> <sean.j.christopherson@intel.com>; Paolo Bonzini <pbonzini@redhat.com>;
> James Morse <james.morse@arm.com>; Julien Thierry
> <julien.thierry.kdev@gmail.com>; Suzuki K Poulose <suzuki.poulose@arm.com>
> Subject: Re: [RFC] KVM: arm64: support enabling dirty log graually in small chunks
> 
> Hi Marc,
> 
> On 2020/3/10 21:16, Marc Zyngier wrote:
> > On 2020-03-10 08:26, zhukeqian wrote:
> >> Hi Marc,
> >>
> >> On 2020/3/9 19:45, Marc Zyngier wrote:
> >>> Kegian,
> >
> > [...]
> >
> >>> Is there a userspace counterpart to it?
> >>>
> >> As this KVM/x86 related changes have not been merged to mainline
> >> kernel, some little modification is needed on mainline Qemu.
> >
> > Could you please point me to these changes?
> I made some changes locally listed below.
> 
> However, Qemu can choose to enable KVM_DIRTY_LOG_INITIALLY_SET or not.
> Here I made no judgement on dirty_log_manual_caps because I just want to
> verify the optimization of this patch.
> 
> diff --git a/accel/kvm/kvm-all.c b/accel/kvm/kvm-all.c index
> 439a4efe52..1611f644a4 100644
> --- a/accel/kvm/kvm-all.c
> +++ b/accel/kvm/kvm-all.c
> @@ -2007,14 +2007,16 @@ static int kvm_init(MachineState *ms)
>      s->coalesced_pio = s->coalesced_mmio &&
>                         kvm_check_extension(s,
> KVM_CAP_COALESCED_PIO);
> 
> -    s->manual_dirty_log_protect =
> +    uint64_t dirty_log_manual_caps =
>          kvm_check_extension(s,
> KVM_CAP_MANUAL_DIRTY_LOG_PROTECT2);
> -    if (s->manual_dirty_log_protect) {
> -        ret = kvm_vm_enable_cap(s,
> KVM_CAP_MANUAL_DIRTY_LOG_PROTECT2, 0, 1);
> +    if (dirty_log_manual_caps) {
> +        ret = kvm_vm_enable_cap(s,
> KVM_CAP_MANUAL_DIRTY_LOG_PROTECT2, 0,
> +                                dirty_log_manual_caps);
>          if (ret) {
>              warn_report("Trying to enable
> KVM_CAP_MANUAL_DIRTY_LOG_PROTECT2 "
>                          "but failed.  Falling back to the legacy mode. ");
> -            s->manual_dirty_log_protect = false;
> +        } else {
> +            s->manual_dirty_log_protect = true;
>          }
>      }

FYI: I had submitted a patch to the Qemu community some days ago:
https://patchwork.kernel.org/patch/11419191/

> >
> >> As I tested this patch on a 128GB RAM Linux VM with no huge pages,
> >> the time of enabling dirty log will decrease obviously.
> >
> > I'm not sure how realistic that is. Not having huge pages tends to
> > lead to pretty bad performance in general...
> Sure, this has no effect on guests which are all of huge pages.
> 
> For my understanding, once a guest has normal pages (maybe are initialized at
> beginning or dissloved from huge pages), it can benefit from this patch.

Yes, I agree.



Regards,
Jay Zhou
