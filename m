Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5744A665A7B
	for <lists+kvm@lfdr.de>; Wed, 11 Jan 2023 12:40:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231603AbjAKLkn (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 11 Jan 2023 06:40:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37766 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238209AbjAKLkD (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 11 Jan 2023 06:40:03 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 12D972AFD
        for <kvm@vger.kernel.org>; Wed, 11 Jan 2023 03:39:22 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C2C36B81AD3
        for <kvm@vger.kernel.org>; Wed, 11 Jan 2023 11:39:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6FB5EC433EF;
        Wed, 11 Jan 2023 11:39:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1673437159;
        bh=fo9Qg5i5zJ2ROT8P7R3Q3bCXwhSIdxzGySVAKM8a5/g=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=C1OtgBbfa4iGPLTALKhnlhxpUu0xDibBGnt63TPVDD60oI9Rwny6cH4S3WsOi8PdL
         YSGSd0BjvYCsXl1BahI60hz4Ai1NOAtvoOHlnGWNjfiyH1dOfd4oUirOI9GfHEIC0Q
         uYaM2CEMdcPAf+C3Ee20LykXfc/nfI0OFbmDhlm+fOagBJHTyjTbX0+bMT8tmPcaFF
         gOSItmmBl6DIQy9kTpuEmiehDyeIg55JBBqerm3+cV2+8XjSifB/q1b5js298A8jwc
         DiuCSeNs/KhQ7BawmdMTKs54ybJq1W3Sxvta2Bej9dJi915ZRgc7xeIJugrdXex+d1
         3uBeMHGd6mVeg==
Received: from disco-boy.misterjones.org ([51.254.78.96] helo=www.loen.fr)
        by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.95)
        (envelope-from <maz@kernel.org>)
        id 1pFZRs-000r0M-M6;
        Wed, 11 Jan 2023 11:39:17 +0000
MIME-Version: 1.0
Date:   Wed, 11 Jan 2023 11:39:16 +0000
From:   Marc Zyngier <maz@kernel.org>
To:     Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>
Cc:     catalin.marinas@arm.com, will@kernel.org,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        kvm@vger.kernel.org, scott@os.amperecomputing.com,
        Darren Hart <darren@os.amperecomputing.com>
Subject: Re: [PATCH 0/3] KVM: arm64: nv: Fixes for Nested Virtualization
 issues
In-Reply-To: <4d952300-0681-41ff-b416-38fbae4ebea6@os.amperecomputing.com>
References: <20220824060304.21128-1-gankulkarni@os.amperecomputing.com>
 <6171dc7c-5d83-d378-db9e-d94f27afe43a@os.amperecomputing.com>
 <87o7r6dpi8.wl-maz@kernel.org>
 <4d952300-0681-41ff-b416-38fbae4ebea6@os.amperecomputing.com>
User-Agent: Roundcube Webmail/1.4.13
Message-ID: <2169cc83d3015727f5f486844c8c4647@kernel.org>
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

On 2023-01-11 08:46, Ganapatrao Kulkarni wrote:
> On 11-01-2023 03:24 am, Marc Zyngier wrote:
>> On Tue, 10 Jan 2023 12:17:20 +0000,
>> Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com> wrote:
>>> 
>>> I am currently working around this with "nohlt" kernel param to
>>> NestedVM. Any suggestions to handle/fix this case/issue and avoid the
>>> slowness of booting of NestedVM with more cores?
>>> 
>>> Note: Guest-Hypervisor and NestedVM are using default kernel 
>>> installed
>>> using Fedora 36 iso.
>> 
>> Despite what I said earlier, I have a vague idea here, thanks to the
>> interesting call traces that you provided (this is really awesome work
>> BTW, given how hard it is to trace things across 3 different kernels).
>> 
>> We can slightly limit the impact of the prepare/finish sequence if the
>> guest hypervisor only accesses the active registers for SGIs/PPIs on
>> the vcpu that owns them, forbidding any cross-CPU-to-redistributor
>> access.
>> 
>> Something along these lines, which is only boot-tested. Let me know
>> how this fares for you.
>> 
>> Thanks,
>> 
>> 	M.
>> 
>> diff --git a/arch/arm64/kvm/vgic/vgic-mmio.c 
>> b/arch/arm64/kvm/vgic/vgic-mmio.c
>> index b32d434c1d4a..1cca45be5335 100644
>> --- a/arch/arm64/kvm/vgic/vgic-mmio.c
>> +++ b/arch/arm64/kvm/vgic/vgic-mmio.c
>> @@ -473,9 +473,10 @@ int vgic_uaccess_write_cpending(struct kvm_vcpu 
>> *vcpu,
>>    * active state can be overwritten when the VCPU's state is synced 
>> coming back
>>    * from the guest.
>>    *
>> - * For shared interrupts as well as GICv3 private interrupts, we have 
>> to
>> - * stop all the VCPUs because interrupts can be migrated while we 
>> don't hold
>> - * the IRQ locks and we don't want to be chasing moving targets.
>> + * For shared interrupts as well as GICv3 private interrupts accessed 
>> from the
>> + * non-owning CPU, we have to stop all the VCPUs because interrupts 
>> can be
>> + * migrated while we don't hold the IRQ locks and we don't want to be 
>> chasing
>> + * moving targets.
>>    *
>>    * For GICv2 private interrupts we don't have to do anything because
>>    * userspace accesses to the VGIC state already require all VCPUs to 
>> be
>> @@ -484,7 +485,8 @@ int vgic_uaccess_write_cpending(struct kvm_vcpu 
>> *vcpu,
>>    */
>>   static void vgic_access_active_prepare(struct kvm_vcpu *vcpu, u32 
>> intid)
>>   {
>> -	if (vcpu->kvm->arch.vgic.vgic_model == KVM_DEV_TYPE_ARM_VGIC_V3 ||
>> +	if ((vcpu->kvm->arch.vgic.vgic_model == KVM_DEV_TYPE_ARM_VGIC_V3 &&
>> +	     vcpu == kvm_get_running_vcpu()) ||
> 
> Thanks Marc for the patch!
> 
> I think, you mean not equal to?
> +           vcpu != kvm_get_running_vcpu()) ||

Yeah, exactly. I woke up this morning realising this patch was
*almost* right. Don't write patches like this after a long day
at work...

> With the change to not-equal, the issue is fixed and I could see the
> NestedVM booting is pretty fast with higher number of cores as well.

Good, thanks for testing it. I'll roll up an actual patch for that
and stick it in the monster queue.

Cheers,

        M.
-- 
Jazz is not dead. It just smells funny...
