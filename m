Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 26125A0A8D
	for <lists+kvm@lfdr.de>; Wed, 28 Aug 2019 21:37:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726896AbfH1Thb (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 28 Aug 2019 15:37:31 -0400
Received: from smtp-fw-33001.amazon.com ([207.171.190.10]:63712 "EHLO
        smtp-fw-33001.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726591AbfH1Thb (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 28 Aug 2019 15:37:31 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.de; i=@amazon.de; q=dns/txt; s=amazon201209;
  t=1567021050; x=1598557050;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:mime-version:content-transfer-encoding;
  bh=0/zETLT6OxlsuzV2h4cI2jALLd91yg4iSxzLtVcgnvs=;
  b=VCY2K4RrpK6UMEW21DASV1UktYIj5ssljwK8Itd6VWYX+5QoOnKDt8xp
   3WRMAgRzNO5EKVVNV/YGaFdUIX43dAZrWgqUFHEWyPeWw36ucIS2o+xvX
   guVuIWp+iFLvjIy9xRgJhwxCGvj3I+UwHf2KcSa9LZihelPwjpgpWEctC
   s=;
X-IronPort-AV: E=Sophos;i="5.64,442,1559520000"; 
   d="scan'208";a="824873404"
Received: from sea3-co-svc-lb6-vlan2.sea.amazon.com (HELO email-inbound-relay-2c-168cbb73.us-west-2.amazon.com) ([10.47.22.34])
  by smtp-border-fw-out-33001.sea14.amazon.com with ESMTP; 28 Aug 2019 19:37:28 +0000
Received: from EX13MTAUEA001.ant.amazon.com (pdx4-ws-svc-p6-lb7-vlan2.pdx.amazon.com [10.170.41.162])
        by email-inbound-relay-2c-168cbb73.us-west-2.amazon.com (Postfix) with ESMTPS id 33854A269C;
        Wed, 28 Aug 2019 19:37:28 +0000 (UTC)
Received: from EX13D01EUA002.ant.amazon.com (10.43.165.199) by
 EX13MTAUEA001.ant.amazon.com (10.43.61.82) with Microsoft SMTP Server (TLS)
 id 15.0.1367.3; Wed, 28 Aug 2019 19:37:27 +0000
Received: from EX13D20UWC001.ant.amazon.com (10.43.162.244) by
 EX13D01EUA002.ant.amazon.com (10.43.165.199) with Microsoft SMTP Server (TLS)
 id 15.0.1367.3; Wed, 28 Aug 2019 19:37:26 +0000
Received: from EX13D20UWC001.ant.amazon.com ([10.43.162.244]) by
 EX13D20UWC001.ant.amazon.com ([10.43.162.244]) with mapi id 15.00.1367.000;
 Wed, 28 Aug 2019 19:37:25 +0000
From:   "Graf (AWS), Alexander" <graf@amazon.de>
To:     "Suthikulpanit, Suravee" <Suravee.Suthikulpanit@amd.com>
CC:     "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "rkrcmar@redhat.com" <rkrcmar@redhat.com>,
        "joro@8bytes.org" <joro@8bytes.org>,
        "Schoenherr, Jan H." <jschoenh@amazon.de>,
        "Raslan, KarimAllah" <karahmed@amazon.de>,
        "Lukaszewicz, Rimas" <rimasluk@amazon.com>,
        "Grimm, Jon" <Jon.Grimm@amd.com>
Subject: Re: [PATCH v2 11/15] svm: Temporary deactivate AVIC during ExtINT
 handling
Thread-Topic: [PATCH v2 11/15] svm: Temporary deactivate AVIC during ExtINT
 handling
Thread-Index: AQHVU4YZx2GIhsHgJkOSwpBQnjkrXqcCTLuAgA5zxoCAAEh7gA==
Date:   Wed, 28 Aug 2019 19:37:24 +0000
Message-ID: <82C8A08D-6CB3-4268-BF79-802E1015E365@amazon.de>
References: <1565886293-115836-1-git-send-email-suravee.suthikulpanit@amd.com>
 <1565886293-115836-12-git-send-email-suravee.suthikulpanit@amd.com>
 <1ed5bf9c-177e-b41c-b5ac-4c76155ead2a@amazon.com>,<5aaef6f4-4bee-4cc4-8eb0-d9b4c412988b@amd.com>
In-Reply-To: <5aaef6f4-4bee-4cc4-8eb0-d9b4c412988b@amd.com>
Accept-Language: en-US
Content-Language: de-DE
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-exchange-transport-fromentityheader: Hosted
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



> Am 28.08.2019 um 17:19 schrieb Suthikulpanit, Suravee <Suravee.Suthikulpa=
nit@amd.com>:
> =

> Alex,
> =

>> On 8/19/19 5:35 AM, Alexander Graf wrote:
>> =

>> =

>>> On 15.08.19 18:25, Suthikulpanit, Suravee wrote:
>>> AMD AVIC does not support ExtINT. Therefore, AVIC must be temporary
>>> deactivated and fall back to using legacy interrupt injection via vINTR
>>> and interrupt window.
>>> =

>>> Signed-off-by: Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
>>> ---
>>>   arch/x86/kvm/svm.c | 49 =

>>> +++++++++++++++++++++++++++++++++++++++++++++----
>>>   1 file changed, 45 insertions(+), 4 deletions(-)
>>> =

>>> diff --git a/arch/x86/kvm/svm.c b/arch/x86/kvm/svm.c
>>> index cfa4b13..4690351 100644
>>> --- a/arch/x86/kvm/svm.c
>>> +++ b/arch/x86/kvm/svm.c
>>> @@ -384,6 +384,7 @@ struct amd_svm_iommu_ir {
>>>   static void svm_set_cr0(struct kvm_vcpu *vcpu, unsigned long cr0);
>>>   static void svm_flush_tlb(struct kvm_vcpu *vcpu, bool invalidate_gpa);
>>>   static void svm_complete_interrupts(struct vcpu_svm *svm);
>>> +static void svm_request_activate_avic(struct kvm_vcpu *vcpu);
>>>   static bool svm_get_enable_apicv(struct kvm *kvm);
>>>   static inline void avic_post_state_restore(struct kvm_vcpu *vcpu);
>>> @@ -4494,6 +4495,15 @@ static int interrupt_window_interception(struct =

>>> vcpu_svm *svm)
>>>   {
>>>       kvm_make_request(KVM_REQ_EVENT, &svm->vcpu);
>>>       svm_clear_vintr(svm);
>>> +
>>> +    /*
>>> +     * For AVIC, the only reason to end up here is ExtINTs.
>>> +     * In this case AVIC was temporarily disabled for
>>> +     * requesting the IRQ window and we have to re-enable it.
>>> +     */
>>> +    if (svm_get_enable_apicv(svm->vcpu.kvm))
>>> +        svm_request_activate_avic(&svm->vcpu);
>> =

>> Would it make sense to add a trace point here and to the other call =

>> sites, so that it becomes obvious in a trace when and why exactly avic =

>> was active/inactive?
>> =

>> The trace point could add additional information on the why.
> =

> Sure, sounds good.
> =

>>> ....
>>> @@ -5522,9 +5558,6 @@ static void enable_irq_window(struct kvm_vcpu =

>>> *vcpu)
>>>   {
>>>       struct vcpu_svm *svm =3D to_svm(vcpu);
>>> -    if (kvm_vcpu_apicv_active(vcpu))
>>> -        return;
>>> -
>>>       /*
>>>        * In case GIF=3D0 we can't rely on the CPU to tell us when GIF =

>>> becomes
>>>        * 1, because that's a separate STGI/VMRUN intercept.  The next =

>>> time we
>>> @@ -5534,6 +5567,14 @@ static void enable_irq_window(struct kvm_vcpu =

>>> *vcpu)
>>>        * window under the assumption that the hardware will set the GIF.
>>>        */
>>>       if ((vgif_enabled(svm) || gif_set(svm)) && nested_svm_intr(svm)) {
>>> +        /*
>>> +         * IRQ window is not needed when AVIC is enabled,
>>> +         * unless we have pending ExtINT since it cannot be injected
>>> +         * via AVIC. In such case, we need to temporarily disable AVIC,
>>> +         * and fallback to injecting IRQ via V_IRQ.
>>> +         */
>>> +        if (kvm_vcpu_apicv_active(vcpu))
>>> +            svm_request_deactivate_avic(&svm->vcpu);
>> =

>> Did you test AVIC with nesting? Did you actually run across this issue =

>> there?
> =

> Currently, we have not claimed that AVIC is supported w/ nested VM. =

> That's why we have not enabled AVIC by default yet. We will be looking =

> more into that next.

If it's not supported, please suspend it when we enter a nested guest then?=
 In that case, the above change is also unnecessary, as it only affects nes=
ted guests, no?

Alex

> =

> Suravee



Amazon Development Center Germany GmbH
Krausenstr. 38
10117 Berlin
Geschaeftsfuehrung: Christian Schlaeger, Ralf Herbrich
Eingetragen am Amtsgericht Charlottenburg unter HRB 149173 B
Sitz: Berlin
Ust-ID: DE 289 237 879



