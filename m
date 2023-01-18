Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5452B672330
	for <lists+kvm@lfdr.de>; Wed, 18 Jan 2023 17:28:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230166AbjARQ2b (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 18 Jan 2023 11:28:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57318 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230143AbjARQ2E (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 18 Jan 2023 11:28:04 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4F84D5866C
        for <kvm@vger.kernel.org>; Wed, 18 Jan 2023 08:25:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1674059112;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=dD050lmzP4QOj50Y6kl8JDI+p6Vx+v1KEXu0Q9ihSpg=;
        b=A0aISmNzsxxNz9cieIDwH3gnhXwHfsmTXceQPHCFWTqzB/OS/t/0TN9GxZXcKx/+id3uj0
        GbAZn07EnrP2UISUBkvGcAFBLSJPiVR3OVm7w5T2SejB+jBgwtuJlLG1f0O+HdFYlXNhK8
        AZQKc17aGjtuzRESz2nWyvXVPtanyLQ=
Received: from mail-ej1-f71.google.com (mail-ej1-f71.google.com
 [209.85.218.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-608-HEMxkwQXNxmxqPJ3sYQtgw-1; Wed, 18 Jan 2023 11:25:11 -0500
X-MC-Unique: HEMxkwQXNxmxqPJ3sYQtgw-1
Received: by mail-ej1-f71.google.com with SMTP id nb4-20020a1709071c8400b0084d4712780bso20675606ejc.18
        for <kvm@vger.kernel.org>; Wed, 18 Jan 2023 08:25:09 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=mime-version:message-id:date:references:in-reply-to:subject:cc:to
         :from:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=dD050lmzP4QOj50Y6kl8JDI+p6Vx+v1KEXu0Q9ihSpg=;
        b=w7UvvwDdc98tGi3MZt0ydS2HjE85tEdT7YgK1W/3AG277nWfA6X6fypslfhxMGt79X
         VxBn1So37re9JsAC7k5jIEVnydxBBPRlUzT3Xo2S09Riv37tFPFrWM80nvWkohLdphzz
         ouMImRvU/I83k82Ki1pOC1ltKABjqSy1TjT5B1sjwtHH7f4Kx+gdnmyzxARoYmlvZcbx
         KLOB+oQ05eZO+bHQyVmKSJOcXhasoLzavWjB5901FDSM3gDxC0FFQ/3lVTAfZpw1P2w/
         CFc98pRjXrPB1NBN2qj5Q/hsaDKU/M7nFsPIZueqgpvKogFE4J85lRtl8NtSfW4rQd96
         jHIA==
X-Gm-Message-State: AFqh2kql8Ehs4758kFeMyRkEhYR4rgH4F+tFAyweMKN1IrwfzLVleRG7
        dvoGAboI+eMc4xkHbg844LLkM+lbBWqgf9U66Hhl6jrBKRU6zDt1Of0o8hA2rUwXNkEAm67eGPX
        82AoqsBi1f4jT
X-Received: by 2002:a05:6402:3496:b0:499:70a8:f91d with SMTP id v22-20020a056402349600b0049970a8f91dmr9841829edc.2.1674059108232;
        Wed, 18 Jan 2023 08:25:08 -0800 (PST)
X-Google-Smtp-Source: AMrXdXv84Khiptx2PQjDtOC2B84/w029Ii1Ev/tWlNi26Pfwazj2W2fGCki5R6mUehAH/W18HaY3JQ==
X-Received: by 2002:a05:6402:3496:b0:499:70a8:f91d with SMTP id v22-20020a056402349600b0049970a8f91dmr9841814edc.2.1674059108026;
        Wed, 18 Jan 2023 08:25:08 -0800 (PST)
Received: from ovpn-194-7.brq.redhat.com (nat-2.ign.cz. [91.219.240.2])
        by smtp.gmail.com with ESMTPSA id a11-20020aa7d74b000000b0049e08f781e3sm4692805eds.3.2023.01.18.08.25.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 18 Jan 2023 08:25:07 -0800 (PST)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     Sean Christopherson <seanjc@google.com>
Cc:     Alexandru Matei <alexandru.matei@uipath.com>,
        Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
        Mihai Petrisor <mihai.petrisor@uipath.com>,
        Viorel Canja <viorel.canja@uipath.com>
Subject: Re: [PATCH] KVM: VMX: Fix crash due to uninitialized current_vmcs
In-Reply-To: <Y8gclHES8KXiXHV2@google.com>
References: <20230118141348.828-1-alexandru.matei@uipath.com>
 <Y8gT/DNwUvaDjfeW@google.com> <87bkmves2d.fsf@ovpn-194-7.brq.redhat.com>
 <Y8gclHES8KXiXHV2@google.com>
Date:   Wed, 18 Jan 2023 17:25:06 +0100
Message-ID: <878rhzerod.fsf@ovpn-194-7.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Sean Christopherson <seanjc@google.com> writes:

> On Wed, Jan 18, 2023, Vitaly Kuznetsov wrote:
>> Sean Christopherson <seanjc@google.com> writes:
>> 
>> > On Wed, Jan 18, 2023, Alexandru Matei wrote:
>> >> KVM enables 'Enlightened VMCS' and 'Enlightened MSR Bitmap' when running as
>> >> a nested hypervisor on top of Hyper-V. When MSR bitmap is updated,
>> >> evmcs_touch_msr_bitmap function uses current_vmcs per-cpu variable to mark
>> >> that the msr bitmap was changed.
>> >> 
>> >> vmx_vcpu_create() modifies the msr bitmap via vmx_disable_intercept_for_msr
>> >> -> vmx_msr_bitmap_l01_changed which in the end calls this function. The
>> >> function checks for current_vmcs if it is null but the check is
>> >> insufficient because current_vmcs is not initialized. Because of this, the
>> >> code might incorrectly write to the structure pointed by current_vmcs value
>> >> left by another task. Preemption is not disabled so the current task can
>> >> also be preempted and moved to another CPU while current_vmcs is accessed
>> >> multiple times from evmcs_touch_msr_bitmap() which leads to crash.
>> >> 
>> >> To fix this problem, this patch moves vmx_disable_intercept_for_msr calls
>> >> before init_vmcs call in __vmx_vcpu_reset(), as ->vcpu_reset() is invoked
>> >> after the vCPU is properly loaded via ->vcpu_load() and current_vmcs is
>> >> initialized.
>> >
>> > IMO, moving the calls is a band-aid and doesn't address the underlying bug.  I
>> > don't see any reason why the Hyper-V code should use a per-cpu pointer in this
>> > case.  It makes sense when replacing VMX sequences that operate on the VMCS, e.g.
>> > VMREAD, VMWRITE, etc., but for operations that aren't direct replacements for VMX
>> > instructions I think we should have a rule that Hyper-V isn't allowed to touch the
>> > per-cpu pointer.
>> >
>> > E.g. in this case it's trivial to pass down the target (completely untested).
>> >
>> > Vitaly?
>> 
>> Mid-air collision detected) I've just suggested a very similar approach
>> but instead of 'vmx->vmcs01.vmcs' I've suggested using
>> 'vmx->loaded_vmcs->vmcs': in case we're running L2 and loaded VMCS is
>> 'vmcs02', I think we still need to touch the clean field indicating that
>> MSR-Bitmap has changed. Equally untested :-)
>
> Three reasons to use vmcs01 directly:
>
>   1. I don't want to require loaded_vmcs to be set.  E.g. in the problematic
>      flows, this 
>
> 	vmx->loaded_vmcs = &vmx->vmcs01;
>
>      comes after the calls to vmx_disable_intercept_for_msr().
>
>   2. KVM on Hyper-V doesn't use the bitmaps for L2 (evmcs02):
>
> 	/*
> 	 * Use Hyper-V 'Enlightened MSR Bitmap' feature when KVM runs as a
> 	 * nested (L1) hypervisor and Hyper-V in L0 supports it. Enable the
> 	 * feature only for vmcs01, KVM currently isn't equipped to realize any
> 	 * performance benefits from enabling it for vmcs02.
> 	 */
> 	if (IS_ENABLED(CONFIG_HYPERV) && static_branch_unlikely(&enable_evmcs) &&
> 	    (ms_hyperv.nested_features & HV_X64_NESTED_MSR_BITMAP)) {
> 		struct hv_enlightened_vmcs *evmcs = (void *)vmx->vmcs01.vmcs;
>
> 		evmcs->hv_enlightenments_control.msr_bitmap = 1;
> 	}

Oh, indeed, I've forgotten this. I'm fine with 'vmx->vmcs01' then but
let's leave a comment (which I've going to also forget about, but still)
that eMSR bitmap is an L1-only feature.

>
>   3. KVM's manipulation of MSR bitmaps typically happens _only_ for vmcs01,
>      e.g. the caller is vmx_msr_bitmap_l01_changed().  The nested case is a 
>      special snowflake.
>

-- 
Vitaly

