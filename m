Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 14F87470E19
	for <lists+kvm@lfdr.de>; Fri, 10 Dec 2021 23:41:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243773AbhLJWpB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 10 Dec 2021 17:45:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59832 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243624AbhLJWpA (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 10 Dec 2021 17:45:00 -0500
Received: from mail-ed1-x52f.google.com (mail-ed1-x52f.google.com [IPv6:2a00:1450:4864:20::52f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 398CDC061746;
        Fri, 10 Dec 2021 14:41:25 -0800 (PST)
Received: by mail-ed1-x52f.google.com with SMTP id g14so33525342edb.8;
        Fri, 10 Dec 2021 14:41:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=Iy4z+x4q0lS2+KD8bMNwWvDh4rqiXsqu5MkQhFPmH/k=;
        b=D+Tn27EEZ5zGwVhnuvYSATR3GRvWVhP7BbYJkscXHgdLrbO9n+gmdpEp4UDN81XyFz
         1/VfyjvCxBuC/0dlfduEPfDloIQkVERp3EKzR+LKFBPh+LPO11MajvyBB6FPXZz3u3lB
         4N7MiPtzHrCgqdUyp38MZBu24HAsVLAiSxAC/OruOlV0u3s97BbbukG5b5LyYwvvxYCy
         WYHCNCOSJFPVkkbJIgfaBpZkZielqWELbwcXZziMzNUf22Feg8KYQOFyCK5OqdDbFC27
         fp8UrRGsCOZSiyi1biiQk7EwNWYQVypabvq/nKZQaYS81GFOHW88PJetO6cToOioCvQK
         F6TA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:message-id:date:mime-version:user-agent
         :subject:content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=Iy4z+x4q0lS2+KD8bMNwWvDh4rqiXsqu5MkQhFPmH/k=;
        b=gfwGU/0E5oOVi5IwuEeOCjYXkMXSkt93jY82qaevvkaHSj74ex1akN73Jo3M9r80U7
         8NH252EG5PEHze1unLuHpv8Y7eAanhl73vZC3W1UcjN9jEbb0WY6cXGepesxdJ2ZFHWD
         Kl/mtHqcYJZmm8SJeUV6VkbtrHrAHd7D+iI5OShuLL6H91ezJPy8fvFxk1Hiz2vtWnnk
         gR6DoeEOlYqWWEaS4ekbRZvnG/UuROhd2acPcMbfJ2JRlpT05vmE9EOoC8ojOEIRyeEN
         pELI1wgtEnXBuNhWYe6CESnfql15YI5unSLEhShfkD7rI7KOPQrAifGmx3R/I0vIHY6z
         6Mng==
X-Gm-Message-State: AOAM533N1k+Y0GfhVzmJAKmCkvkVmhTtz0FaXm1AIcFvpAXSAFBQkloV
        IQq4o+NO5VQE3M6junDQMuw=
X-Google-Smtp-Source: ABdhPJwr+Zb7BGljYVeH6SG133VT4K2TCRkFcdaEgwOfxJYMhT1eJs1KT/Cy3F6Y6TAA4gHNgRGmJA==
X-Received: by 2002:a17:907:60d6:: with SMTP id hv22mr27868660ejc.503.1639176083813;
        Fri, 10 Dec 2021 14:41:23 -0800 (PST)
Received: from ?IPV6:2001:b07:6468:f312:63a7:c72e:ea0e:6045? ([2001:b07:6468:f312:63a7:c72e:ea0e:6045])
        by smtp.googlemail.com with ESMTPSA id p19sm2007846ejn.97.2021.12.10.14.41.19
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 10 Dec 2021 14:41:23 -0800 (PST)
Sender: Paolo Bonzini <paolo.bonzini@gmail.com>
Message-ID: <57313f38-5b2b-e352-7502-1a3a70fa4ef1@redhat.com>
Date:   Fri, 10 Dec 2021 23:41:14 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.2.0
Subject: Re: [PATCH] KVM: x86: Inject #UD on "unsupported" hypercall if
 patching fails
Content-Language: en-US
To:     Sean Christopherson <seanjc@google.com>
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Hou Wenlong <houwenlong93@linux.alibaba.com>
References: <20211210222903.3417968-1-seanjc@google.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <20211210222903.3417968-1-seanjc@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 12/10/21 23:29, Sean Christopherson wrote:
> Inject a #UD if patching in the correct hypercall fails, e.g. due to
> emulator_write_emulated() failing because RIP is mapped not-writable by
> the guest.  The guest is likely doomed in any case, but observing a #UD
> in the guest is far friendlier to debug/triage than a !WRITABLE #PF with
> CR2 pointing at the RIP of the faulting instruction.
> 
> Ideally, KVM wouldn't patch at all; it's the guest's responsibility to
> identify and use the correct hypercall instruction (VMCALL vs. VMMCALL).
> Sadly, older Linux kernels prior to commit c1118b3602c2 ("x86: kvm: use
> alternatives for VMCALL vs. VMMCALL if kernel text is read-only") do the
> wrong thing and blindly use VMCALL, i.e. removing the patching would
> break running VMs with older kernels.
> 
> One could argue that KVM should be "fixed" to ignore guest paging
> protections instead of injecting #UD, but patching in the first place was
> a mistake as it was a hack-a-fix for a guest bug.

Sort of.  I agree that patching is awful, but I'm not sure about 
injecting #UD vs. just doing the hypercall; the original reason for the 
patching was to allow Intel<->AMD cross-vendor migration to work somewhat.

That in turn promoted Linux's ill-conceived sloppiness of just using 
vmcall, which lasted until commit c1118b3602c2.

> There are myriad fatal
> issues with KVM's patching:
> 
>    1. Patches using an emulated guest write, which will fail if RIP is not
>       mapped writable.  This is the issue being mitigated.
> 
>    2. Doesn't ensure the write is "atomic", e.g. a hypercall that splits a
>       page boundary will be handled as two separate writes, which means
>       that a partial, corrupted instruction can be observed by a vCPU.

Only the third bytes differs between VMCALL and VMMCALL so that's not 
really a problem.  (Apparently what happened is that Microsoft asked 
Intel to use 0xc1 like AMD, and VMware asked AMD to use 0xd9 like Intel, 
or something like that; and they ended up swapping opcodes.  But this 
may be an urban legend, no matter how plausible).

The big ones are 1 and 4.

Thanks,

Paolo

>    3. Doesn't serialize other CPU cores after updating the code stream.
> 
>    4. Completely fails to account for the case where KVM is emulating due
>       to invalid guest state with unrestricted_guest=0.  Patching and
>       retrying the instruction will result in vCPU getting stuck in an
>       infinite loop.
> 
> But, the "support" _so_ awful, especially #1, that there's practically
> zero chance that a modern guest kernel can rely on KVM to patch the guest.
> So, rather than proliferate KVM's bad behavior any further than the
> absolute minimum needed for backwards compatibility, just try to make it
> suck a little less.

