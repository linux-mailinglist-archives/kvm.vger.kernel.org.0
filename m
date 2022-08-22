Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8831759BBF1
	for <lists+kvm@lfdr.de>; Mon, 22 Aug 2022 10:48:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233786AbiHVIsB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 22 Aug 2022 04:48:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56108 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233709AbiHVIr5 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 22 Aug 2022 04:47:57 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 147A52DA9A
        for <kvm@vger.kernel.org>; Mon, 22 Aug 2022 01:47:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1661158075;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=I4W0/Q6CKI1C/6ZS/LzkoVtWSqfZ4woltBoAnosrqTA=;
        b=HqI3cwzhStDRcw2FlujAT3ochJ7alLih1VzM9MtzxgzzfYCe8LeDgdqyC4Pt7PV312bA+D
        g5LGWdejxBQdGv6VsItb1BBzJ/BBxwiN17nsYQVtDIcTa3gCNIIV2AnJk9EzNxpc/OHbdm
        P+SUvhvPrpwXxJRFpgfJNbkFsgdWoOA=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-628-uwDPj071M6yUfbB9VjrHXg-1; Mon, 22 Aug 2022 04:47:53 -0400
X-MC-Unique: uwDPj071M6yUfbB9VjrHXg-1
Received: by mail-wr1-f70.google.com with SMTP id w20-20020adf8bd4000000b002237e71d4e4so1531723wra.21
        for <kvm@vger.kernel.org>; Mon, 22 Aug 2022 01:47:53 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=mime-version:message-id:date:references:in-reply-to:subject:cc:to
         :from:x-gm-message-state:from:to:cc;
        bh=I4W0/Q6CKI1C/6ZS/LzkoVtWSqfZ4woltBoAnosrqTA=;
        b=Tp7SOx5ZUOj94Ioy3R58lwjiEY4sNWEpTNU1ehPA6ckLblzciC8SuLT+VgpbpLMIJD
         mPCvfqHmO+YVGsJsNUb1r+EfsPCjbZ5VBy1DOySU0Y+CVj89Umq2Rb1w/UhK3BxgqSYD
         ofBMIOK90OCyxBPt+YVaZBb6EagV0KTOCzKkiRN7Jjq11dBJMRHbNL8CsAGAhY6lb5PC
         vhdZLZWmg8rQujuwfmy3XraRqMXVr7KiZ+mrpzi6rMmNUL2gGvMRb8s1HdQ/RFgeMfXV
         wgW5YuiBqNLZZkxHwMJIhG1hTQsz2bLNZ0nhi03mb2Wlc3bFzfOVZovnBvTeoYZ0Bj5B
         el8w==
X-Gm-Message-State: ACgBeo30skvVToDh6UiiW+6viBLMM7xHP4d3fD7PprrkGhyZCAAm2OU8
        SxAwyFLWMEjb/lDmi48jRqy6rW/i8E55pN1f8wJILazbRjiBN2XMJJQ3Bcc2BbW13NOIc8yiSWX
        7wZXITXUOGUso
X-Received: by 2002:adf:f9ce:0:b0:225:24ce:3c0b with SMTP id w14-20020adff9ce000000b0022524ce3c0bmr10172139wrr.416.1661158072562;
        Mon, 22 Aug 2022 01:47:52 -0700 (PDT)
X-Google-Smtp-Source: AA6agR4xWItbRuSv43/5fBPSAEiNY9RrXBEgy0ZH/39Um/aohh773XKd+0EHJH9wl9xuKs4FJSlEAg==
X-Received: by 2002:adf:f9ce:0:b0:225:24ce:3c0b with SMTP id w14-20020adff9ce000000b0022524ce3c0bmr10172123wrr.416.1661158072261;
        Mon, 22 Aug 2022 01:47:52 -0700 (PDT)
Received: from fedora (nat-2.ign.cz. [91.219.240.2])
        by smtp.gmail.com with ESMTPSA id h5-20020a05600c350500b003a6125562e1sm13961172wmq.46.2022.08.22.01.47.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 22 Aug 2022 01:47:51 -0700 (PDT)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     Sean Christopherson <seanjc@google.com>
Cc:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        Anirudh Rayabharam <anrayabh@linux.microsoft.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Maxim Levitsky <mlevitsk@redhat.com>,
        Nathan Chancellor <nathan@kernel.org>,
        Michael Kelley <mikelley@microsoft.com>,
        linux-hyperv@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v5 09/26] KVM: VMX: nVMX: Support TSC scaling and
 PERF_GLOBAL_CTRL with enlightened VMCS
In-Reply-To: <Yv/CME8B1ueOMY5M@google.com>
References: <20220802160756.339464-1-vkuznets@redhat.com>
 <20220802160756.339464-10-vkuznets@redhat.com>
 <Yv5zn4qTl0aiaQvh@google.com> <87sflssllu.fsf@redhat.com>
 <Yv/CME8B1ueOMY5M@google.com>
Date:   Mon, 22 Aug 2022 10:47:50 +0200
Message-ID: <87ilmkslzd.fsf@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Sean Christopherson <seanjc@google.com> writes:

> On Fri, Aug 19, 2022, Vitaly Kuznetsov wrote:
>> Sean Christopherson <seanjc@google.com> writes:
>> 
>> > On Tue, Aug 02, 2022, Vitaly Kuznetsov wrote:
>> >> +static u32 evmcs_get_unsupported_ctls(struct kvm_vcpu *vcpu,
>> >> +				      enum evmcs_unsupported_ctrl_type ctrl_type)
>> >> +{
>> >> +	struct kvm_vcpu_hv *hv_vcpu = to_hv_vcpu(vcpu);
>> >> +	enum evmcs_revision evmcs_rev = EVMCSv1_2016;
>> >> +
>> >> +	if (!hv_vcpu)
>> >
>> > This is a functiontal change, and I don't think it's correct either.  Previously,
>> > KVM would apply the EVMCSv1_2016 filter irrespective of whether or not
>> > vcpu->arch.hyperv is non-NULL.  nested_enable_evmcs() doesn't require a Hyper-V
>> > vCPU, and AFAICT nothing requires a Hyper-V vCPU to use eVMCS.
>> 
>> Indeed, this *is* correct after PATCH11 when we get rid of VMX feature
>> MSR filtering for KVM-on-Hyper-V as the remaining use for
>> evmcs_get_unsupported_ctls() is Hyper-V on KVM and hv_vcpu is not NULL
>> there.
>
> Hmm, nested_vmx_handle_enlightened_vmptrld() will fail without a Hyper-V vCPU, so
> filtering eVMCS control iff there's a Hyper-V vCPU makes sense.  But that's a guest
> visible change and should be a separate patch.
>

Yes, the change you suggested:

          if (hv_vcpu &&
              hv_vcpu->cpuid_cache.nested_eb & HV_X64_NESTED_EVMCS1_2022_UPDATE) 
			evmcs_rev = EVMCSv1_2022;

seems to keep the status quo so we can discuss dropping filtering when
!hv_vcpu separately.

> But that also raises the question of whether or not KVM should honor hyperv_enabled
> when filtering MSRs.  Same question for nested VM-Enter.  nested_enlightened_vmentry()
> will "fail" without an assist page, and the guest can't set the assist page without
> hyperv_enabled==true, but nothing prevents the host from stuffing the assist page.

The case sounds more like a misbehaving VMM to me. It would probably be
better to fail nested_enlightened_vmentry() immediately on !hyperv_enabled.

>
> And on a very related topic, the handling of kvm_hv_vcpu_init() in kvm_hv_set_cpuid()
> is buggy.  KVM will not report an error to userspace for KVM_SET_CPUID2 if allocation
> fails.  If a later operation successfully create a Hyper-V vCPU, KVM will chug along
> with Hyper-V enabled but without having cached the relevant Hyper-V
> CPUID info.

Indeed, that's probably because kvm_vcpu_after_set_cpuid() itself is
never supposed to fail and thus returns 'void'. I'm not up-to-date on
the discussion whether small allocations can actually fail (and whether
2832 bytes for 'struct kvm_vcpu_hv' is 'small') but propagating -ENOMEM
all the way up to VMM is likely the right way to go.

>
> Less important is that kvm_hv_set_cpuid() should also zero out the CPUID cache if
> Hyper-V is disabled.  I'm pretty sure sure all paths check hyperv_enabled before
> consuming cpuid_cache, but it's unnecessarily risky.

+1

>
> If we fix the kvm_hv_set_cpuid() allocation failure, then we can also guarantee
> that vcpu->arch.hyperv is non-NULL if vcpu->arch.hyperv_enabled==true.  And then
> we can add gate guest eVMCS flow on hyperv_enabled, and evmcs_get_unsupported_ctls()
> can then WARN if hv_vcpu is NULL.
>

Alternatively, we can just KVM_BUG_ON() in kvm_hv_set_cpuid() when
allocation fails, at least for the time being as the VM is likely
useless anyway.

> Assuming I'm not overlooking something, I'll fold in yet more patches.
>

Thanks for the thorough review here and don't hesitate to speak up when
you think it's too much of a change to do upon queueing)

-- 
Vitaly

