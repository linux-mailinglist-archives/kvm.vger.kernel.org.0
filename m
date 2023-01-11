Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A8AD2665CC2
	for <lists+kvm@lfdr.de>; Wed, 11 Jan 2023 14:39:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239246AbjAKNjZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 11 Jan 2023 08:39:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33060 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239209AbjAKNjH (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 11 Jan 2023 08:39:07 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0FBEB1ADAD
        for <kvm@vger.kernel.org>; Wed, 11 Jan 2023 05:36:40 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C501BB81BE6
        for <kvm@vger.kernel.org>; Wed, 11 Jan 2023 13:36:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6BAE8C433EF;
        Wed, 11 Jan 2023 13:36:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1673444197;
        bh=jmhq9ChkH2NfqzWnvmpx3kh3Vnp+p3wr2mRMyDf+7DI=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=bU0z/WMfvYKXzmujZknAssAgPbjR1WKv89ti7YI8qpGJLQ/8EpzUjf7wm5/JQw7sa
         OFsj129pM1cvw618L1MZAWFc7kuB7WmqjIGVjVSTyCNK2jb84kADMAQdzBuY9z+d+g
         z9bCmRt1aegtA4sbUlNJ37wwrMX4NOKoE06XhPe1Zt2ierjC/vcfdaXM15uOtAnatT
         dHVnZkw3BYZ8Q3cHlgl7iqUMHzEHv06LP9AJXVEEaIP2V85J5OGXSp9juuORbArXjL
         rWLj61/n+bskBJny2Rf/noHUdFprxkM3zAgWyRjE8Aixd4B3ZkvoRYvthrGFgrcPz5
         SEOkPs4uUs+KQ==
Received: from disco-boy.misterjones.org ([51.254.78.96] helo=www.loen.fr)
        by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.95)
        (envelope-from <maz@kernel.org>)
        id 1pFbHO-000sOo-Vh;
        Wed, 11 Jan 2023 13:36:35 +0000
MIME-Version: 1.0
Date:   Wed, 11 Jan 2023 13:36:34 +0000
From:   Marc Zyngier <maz@kernel.org>
To:     Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>
Cc:     catalin.marinas@arm.com, will@kernel.org,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        kvm@vger.kernel.org, scott@os.amperecomputing.com,
        Darren Hart <darren@os.amperecomputing.com>
Subject: Re: [PATCH 0/3] KVM: arm64: nv: Fixes for Nested Virtualization
 issues
In-Reply-To: <b3895df9-8094-5548-1633-0c6a405d1c0c@os.amperecomputing.com>
References: <20220824060304.21128-1-gankulkarni@os.amperecomputing.com>
 <6171dc7c-5d83-d378-db9e-d94f27afe43a@os.amperecomputing.com>
 <87o7r6dpi8.wl-maz@kernel.org>
 <4d952300-0681-41ff-b416-38fbae4ebea6@os.amperecomputing.com>
 <2169cc83d3015727f5f486844c8c4647@kernel.org>
 <b3895df9-8094-5548-1633-0c6a405d1c0c@os.amperecomputing.com>
User-Agent: Roundcube Webmail/1.4.13
Message-ID: <f0ef11fad6cef5d0e33238052a77670a@kernel.org>
X-Sender: maz@kernel.org
Content-Type: text/plain; charset=UTF-8;
 format=flowed
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 51.254.78.96
X-SA-Exim-Rcpt-To: gankulkarni@os.amperecomputing.com, catalin.marinas@arm.com, will@kernel.org, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, scott@os.amperecomputing.com, darren@os.amperecomputing.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 2023-01-11 12:46, Ganapatrao Kulkarni wrote:
> On 11-01-2023 05:09 pm, Marc Zyngier wrote:
>> On 2023-01-11 08:46, Ganapatrao Kulkarni wrote:
>>> On 11-01-2023 03:24 am, Marc Zyngier wrote:
>>>> On Tue, 10 Jan 2023 12:17:20 +0000,
>>>> Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com> wrote:
>>>>> 
>>>>> I am currently working around this with "nohlt" kernel param to
>>>>> NestedVM. Any suggestions to handle/fix this case/issue and avoid 
>>>>> the
>>>>> slowness of booting of NestedVM with more cores?
>>>>> 
>>>>> Note: Guest-Hypervisor and NestedVM are using default kernel 
>>>>> installed
>>>>> using Fedora 36 iso.
>>>> 
>>>> Despite what I said earlier, I have a vague idea here, thanks to the
>>>> interesting call traces that you provided (this is really awesome 
>>>> work
>>>> BTW, given how hard it is to trace things across 3 different 
>>>> kernels).
>>>> 
>>>> We can slightly limit the impact of the prepare/finish sequence if 
>>>> the
>>>> guest hypervisor only accesses the active registers for SGIs/PPIs on
>>>> the vcpu that owns them, forbidding any cross-CPU-to-redistributor
>>>> access.
>>>> 
>>>> Something along these lines, which is only boot-tested. Let me know
>>>> how this fares for you.
>>>> 
>>>> Thanks,
>>>> 
>>>>     M.
>>>> 
>>>> diff --git a/arch/arm64/kvm/vgic/vgic-mmio.c 
>>>> b/arch/arm64/kvm/vgic/vgic-mmio.c
>>>> index b32d434c1d4a..1cca45be5335 100644
>>>> --- a/arch/arm64/kvm/vgic/vgic-mmio.c
>>>> +++ b/arch/arm64/kvm/vgic/vgic-mmio.c
>>>> @@ -473,9 +473,10 @@ int vgic_uaccess_write_cpending(struct kvm_vcpu 
>>>> *vcpu,
>>>>    * active state can be overwritten when the VCPU's state is synced 
>>>> coming back
>>>>    * from the guest.
>>>>    *
>>>> - * For shared interrupts as well as GICv3 private interrupts, we 
>>>> have to
>>>> - * stop all the VCPUs because interrupts can be migrated while we 
>>>> don't hold
>>>> - * the IRQ locks and we don't want to be chasing moving targets.
>>>> + * For shared interrupts as well as GICv3 private interrupts 
>>>> accessed from the
>>>> + * non-owning CPU, we have to stop all the VCPUs because interrupts 
>>>> can be
>>>> + * migrated while we don't hold the IRQ locks and we don't want to 
>>>> be chasing
>>>> + * moving targets.
>>>>    *
>>>>    * For GICv2 private interrupts we don't have to do anything 
>>>> because
>>>>    * userspace accesses to the VGIC state already require all VCPUs 
>>>> to be
>>>> @@ -484,7 +485,8 @@ int vgic_uaccess_write_cpending(struct kvm_vcpu 
>>>> *vcpu,
>>>>    */
>>>>   static void vgic_access_active_prepare(struct kvm_vcpu *vcpu, u32 
>>>> intid)
>>>>   {
>>>> -    if (vcpu->kvm->arch.vgic.vgic_model == KVM_DEV_TYPE_ARM_VGIC_V3 
>>>> ||
>>>> +    if ((vcpu->kvm->arch.vgic.vgic_model == 
>>>> KVM_DEV_TYPE_ARM_VGIC_V3 &&
>>>> +         vcpu == kvm_get_running_vcpu()) ||
>>> 
>>> Thanks Marc for the patch!
>>> 
>>> I think, you mean not equal to?
>>> +           vcpu != kvm_get_running_vcpu()) ||
>> 
>> Yeah, exactly. I woke up this morning realising this patch was
>> *almost* right. Don't write patches like this after a long day
>> at work...
>> 
>>> With the change to not-equal, the issue is fixed and I could see the
>>> NestedVM booting is pretty fast with higher number of cores as well.
>> 
>> Good, thanks for testing it. I'll roll up an actual patch for that
>> and stick it in the monster queue.
> 
> Thanks, Please pull patch 3/3 also to nv-6.2 tree along with this
> patch. I will move my setup to nv-6.2 once these patches are in.

3/3 should already be in the branch, merged with the shadow
S2 fault handling.

         M.
-- 
Jazz is not dead. It just smells funny...
