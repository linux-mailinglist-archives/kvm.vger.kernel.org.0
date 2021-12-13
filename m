Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CB316472C87
	for <lists+kvm@lfdr.de>; Mon, 13 Dec 2021 13:45:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234244AbhLMMp4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 13 Dec 2021 07:45:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43286 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231649AbhLMMpy (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 13 Dec 2021 07:45:54 -0500
Received: from mail-ed1-x534.google.com (mail-ed1-x534.google.com [IPv6:2a00:1450:4864:20::534])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CAD77C061574;
        Mon, 13 Dec 2021 04:45:53 -0800 (PST)
Received: by mail-ed1-x534.google.com with SMTP id l25so52052553eda.11;
        Mon, 13 Dec 2021 04:45:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=uG7G4oTlj1kZ6bR9KXEkUB/36kR857FRM8BO3kXuCKE=;
        b=OC0icbW5DzwIwnNUf/Ll3Ev87gq+8OI/9larpvGEn9nGskMfWCmK3mEpUv4k40eJXW
         900wOxU0rnlJZaYRczL/z7dExMv/U94YFTMuiQFma45wdz3cBqLsGgoXu6ZzALraKQHB
         B33PzSbcaTP5cy8/VvEeaLZ1ePRAneywQc4exsMLWesncigiYiM+HDCwoqpZyJUTwTLZ
         ZxC4OOLiW0Co+c8D1ISibywfS58sQqiHmXtHQt0QrEJHD96Z4/6//LoFKZH0m5ITCrMQ
         0dHYjpcN7Zq8MtnsFC6ameQE4koZWAsouOExmDSl0oGqcHRQeoznkg05nXRdDMyi7gMw
         QePw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:message-id:date:mime-version:user-agent
         :subject:content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=uG7G4oTlj1kZ6bR9KXEkUB/36kR857FRM8BO3kXuCKE=;
        b=qqWb0hNHy8c5+i1hzHp96EGcgP8jJTl5+fqW1bboCyG18UY7aFNfs+TAz4tSsJ66pp
         +d7syGrM4DSIUn7r/CDrURKqD+0OHHqtX1EJvzol0bxDp/Wz6btwE7TfupVr6xa1g/qz
         yPAB6IAJ1M2H5GRD7GX9O4fRLJFCHnXc67vfokDjb1ZrMQuLJ83x1ExNAH5Zot/uWV45
         DVU+dsF0D7c0ZHEUBJr1vLLDfraVKFbfpUymFoe/vu5yvS5+sP+OafbK173JQ1xnVf4j
         Y83TYVRA2GAhR3aY+wWc1mAJSlusblQhPTkAU+zbiYj8jq6MMnKPEkAoyIZjNav3x0nD
         EXTw==
X-Gm-Message-State: AOAM5307SziGb6eDPFksMarvxnhUGUMufAcwmO5Ye0JeaDhT/TL0Joaa
        Ack/hYZjSu7jpXXRxz7J1P4=
X-Google-Smtp-Source: ABdhPJwkZ3NBUWpL/xh4TKzNN4/XnrS3IvFu3x0uqtN8rlg3toaJHZKYU2WOx8VdlRKtIAGiqiDkfw==
X-Received: by 2002:a05:6402:154:: with SMTP id s20mr67258471edu.148.1639399552332;
        Mon, 13 Dec 2021 04:45:52 -0800 (PST)
Received: from ?IPV6:2001:b07:6468:f312:63a7:c72e:ea0e:6045? ([2001:b07:6468:f312:63a7:c72e:ea0e:6045])
        by smtp.googlemail.com with ESMTPSA id o17sm36279ejj.162.2021.12.13.04.45.50
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 13 Dec 2021 04:45:51 -0800 (PST)
Sender: Paolo Bonzini <paolo.bonzini@gmail.com>
Message-ID: <16c938e2-2427-c8dd-94a1-eba8f967283b@redhat.com>
Date:   Mon, 13 Dec 2021 13:45:49 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.2.0
Subject: Re: [PATCH 02/19] x86/fpu: Prepare KVM for dynamically enabled states
Content-Language: en-US
To:     Thomas Gleixner <tglx@linutronix.de>,
        Yang Zhong <yang.zhong@intel.com>, x86@kernel.org,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        mingo@redhat.com, bp@alien8.de, dave.hansen@linux.intel.com
Cc:     seanjc@google.com, jun.nakajima@intel.com, kevin.tian@intel.com,
        jing2.liu@linux.intel.com, jing2.liu@intel.com
References: <20211208000359.2853257-1-yang.zhong@intel.com>
 <20211208000359.2853257-3-yang.zhong@intel.com>
 <dae6cc09-2464-f1f5-c909-2374d33c75b5@redhat.com> <878rwovhnh.ffs@tglx>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <878rwovhnh.ffs@tglx>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 12/13/21 13:00, Thomas Gleixner wrote:
> On Mon, Dec 13 2021 at 10:12, Paolo Bonzini wrote:
>> On 12/8/21 01:03, Yang Zhong wrote:
>>>     - user_xfeatures
>>>
>>>       Track which features are currently enabled for the vCPU
>>
>> Please rename to alloc_xfeatures
> 
> That name makes no sense at all. This has nothing to do with alloc.

Isn't that the features for which space is currently allocated?

fpstate_realloc does

+	if (guest_fpu) {
+		newfps->is_guest = true;
+		newfps->is_confidential = curfps->is_confidential;
+		guest_fpu->user_xfeatures |= xfeatures;
+	}
+

and kvm_check_guest_realloc_fpstate does


+		if ((guest_fpu->user_xfeatures & request) != request) {
+			vcpu->arch.guest_fpu.realloc_request |= request;
+			return true;
+		}

Reading "user_xfeatures" in there is cryptic, it seems like it's 
something related to the userspace thread or group that has invoked the 
KVM ioctl.  If it's renamed to alloc_xfeatures, then this:

+		missing = request & ~guest_fpu->alloc_xfeatures;
+		if (missing) {
+			vcpu->arch.guest_fpu.realloc_request |= missing;
+			return true;
+		}

makes it obvious that the allocation is for features that are requested 
but haven't been allocated in the xstate yet.

>>>     - user_perm
>>>
>>>       Copied from guest_perm of the group leader thread. The first
>>>       vCPU which does the copy locks the guest_perm
>>
>> Please rename to perm_xfeatures.
> 
> All of that is following the naming conventions in the FPU code related
> to permissions etc.

perm or guest_perm is just fine as well; but user_perm is not (there's 
no preexisting reference to user_perm in the code, in fact, as far as I 
can see).

>>>     - realloc_request
>>>
>>>       KVM sets this field to request dynamically-enabled features
>>>       which require reallocation of @fpstate
>>
>> This field should be in vcpu->arch, and there is no need for
>> fpu_guest_realloc_fpstate.  Rename __xfd_enable_feature to
>> fpu_enable_xfd_feature and add it to the public API, then just do
>>
>> 	if (unlikely(vcpu->arch.xfd_realloc_request)) {
>> 		u64 request = vcpu->arch.xfd_realloc_request;
>> 		ret = fpu_enable_xfd(request, enter_guest);
>> 	}
>>
>> to kvm_put_guest_fpu.
> 
> Why? Yet another export of FPU internals just because?

It's one function more and one field less.  I prefer another export of 
FPU internals, to a write to a random field with undocumented invariants.

For example, why WARN_ON_ONCE if enter_guest == true?  If you enter the 
guest after the host has restored MSR_IA32_XFD with KVM_SET_MSR, the 
WARN_ON_ONCE can actually fire.  It would be just fine to skip the 
reallocation until enter_guest == false, which is you actually XSAVE 
into the guest_fpu.

As an aside, realloc_request (if it survives, see below) shouldn't be 
added until patch 6.

> Also what clears the reallocation request and what is the @enter_guest
> argument supposed to help with?

Nothing---make it

  	if (unlikely(vcpu->arch.xfd_realloc_request)) {
  		u64 request = vcpu->arch.xfd_realloc_request;
  		ret = fpu_enable_xfd(request, &vcpu->arch.guest_fpu);
		if (!ret)
			vcpu->arch.xfd_realloc_request = 0;
  	}

but in fact, I'm not sure why the request has to be delayed at all.  The 
obvious implementation of a write to XFD, after all the validity checks, 
is just

	/* This function just calls xfd_enable_feature.  */
	r = fpu_guest_alloc_xfeatures(&vcpu->arch.guest_fpu,
				      vcpu->arch.xcr0 & ~xfd);
	/*
	 * An error means that userspace has screwed up by not doing
	 * arch_prctl(ARCH_REQ_XCOMP_GUEST_PERM).  If we are here coming
	 * from a ioctl fail it, if the guest has done WRMSR or XSETBV
	 * it will inject a #GP.
	 */
	if (r < 0)
		return 1;

	vcpu->arch.xfd = xfd;

with none of the kvm_check_guest_realloc_fpstate or KVM_EXIT_FPU_REALLOC 
business.  No field and a simple, self-contained external API.  The same 
code works for __kvm_set_xcr as well, just with "xcr0 & ~vcpu->arch.xfd" 
as the second argument instead.

(Maybe I'm missing why KVM_EXIT_FPU_REALLOC is needed, but I'm not 
ashamed to say that, given that new userspace API was added with 
documentation or tests.  The only comment in the code is:

+		/*
+		 * Check if fpstate reallocate is required. If yes, then
+		 * let the fpu core do reallocation and update xfd;
+		 * otherwise, update xfd here.
+		 */
+		if (kvm_check_guest_realloc_fpstate(vcpu, data)) {
+			vcpu->run->exit_reason = KVM_EXIT_FPU_REALLOC;
+			vcpu->arch.complete_userspace_io =
+				kvm_skip_emulated_instruction;
+			return KVM_MSR_RET_USERSPACE;
+		}
+

which has nothing to do with the actual content of either 
kvm_check_guest_realloc_fpstate or the "then" branch.  Userspace can 
just do ARCH_REQ_XCOMP_GUEST_PERM based on the guest CPUID, before 
KVM_SET_CPUID2, KVM_SET_MSR or KVM_SET_XCR).

Paolo
