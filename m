Return-Path: <kvm+bounces-32349-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 0171D9D5C02
	for <lists+kvm@lfdr.de>; Fri, 22 Nov 2024 10:34:25 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id B5E90284B5E
	for <lists+kvm@lfdr.de>; Fri, 22 Nov 2024 09:34:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AB7831D9A5F;
	Fri, 22 Nov 2024 09:34:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Ilu9xL9S"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ACF3B16DEB3
	for <kvm@vger.kernel.org>; Fri, 22 Nov 2024 09:34:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732268045; cv=none; b=CETelc+TG1JcH4HlQOyLXvV7EzYtU3F1otaB1wpV/7zIb8KgcbKGndOSu/a77lPG9gHwezQq0xqW3FrZqKGzJXc6cMM06E4mQP1I8F8xQrhEn5undySi5X5LuUKyQIiCpwvK+xRmrLyvNjBgGmqTiR+yA/N7yManCOue74KArzg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732268045; c=relaxed/simple;
	bh=/Ietlm2M38XkX0/kNUuz/YArcCY5PSsSsF6zo5gkfDs=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=jr+kaA1XuK7DVZYqTf6A8Cbm8nxvtALzIopsM7+EUmXmkyRBh5zkQMHFJ1w1pLMfHYMc19SzOLZL7yPHzO9lnw5ozp3R4vbkvHTcLbsenfcDnjdqdKlyZKpkLb5bbW/nmf9vsDn38k2dy69Mz8m9o1o9KPZRAGFjzMXi+SI7HJ8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Ilu9xL9S; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1732268042;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=UhrnamlKMhk/hOtaEby7mW+uh6C+Y32a0RErHwVTWt8=;
	b=Ilu9xL9SJfOhougVrK5bmreXcHQpOwt6TMVCLEtRZRaPTUmB0fOnxzYL1E73k0ahxl1nAE
	uhey3oA0FpEOHN/U/4f3dwRPfzPnEkv7aO+FFDe/jNI3CV8cr3eBQXPReIlEMuE2N7kg6u
	VVysESggLvwhnwwBtxqNJKmt/62f6TI=
Received: from mail-ej1-f72.google.com (mail-ej1-f72.google.com
 [209.85.218.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-232-0dSF1wspOkGPAjxLAQ7LGw-1; Fri, 22 Nov 2024 04:33:59 -0500
X-MC-Unique: 0dSF1wspOkGPAjxLAQ7LGw-1
X-Mimecast-MFC-AGG-ID: 0dSF1wspOkGPAjxLAQ7LGw
Received: by mail-ej1-f72.google.com with SMTP id a640c23a62f3a-a9a157d028aso118179166b.2
        for <kvm@vger.kernel.org>; Fri, 22 Nov 2024 01:33:59 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1732268038; x=1732872838;
        h=mime-version:message-id:date:references:in-reply-to:subject:cc:to
         :from:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=UhrnamlKMhk/hOtaEby7mW+uh6C+Y32a0RErHwVTWt8=;
        b=rITdp4FP0GJe2oAR95bR5qv952PxWNj7+59AGDhzG8Vjk6ZemZJGkSWaxgUdepuLHo
         5FHSN+T2YVWs4hsRWty2OKkv8kN5zvkjI8Fs/yAxTNLiglOSjStjN3ftf/jtP7jfapNl
         VmyGJjF1ex1qoWON/VGAXKxgZ6s/q3g7XWUnW07aoFiSPa4XSJAxcs5xKxY8u+9FHgF4
         LXPake6VesEKNHVl+CpUppHhcOSRBbydOHapm3qTmZu8JcDxxQT6fYLiQpNXcFFO/Z5L
         3/KsdIM3ay+TmqjCv9xPINz4WIKL8WGxvO8wcPDD1hEGzlcTnd2MTdP4yiJDhBUzC/UB
         9IKA==
X-Forwarded-Encrypted: i=1; AJvYcCULMvMt34K4nsHgrY/vdqfC384BF93nVseADSUL3nYEvsq5aBRVSM7UlauiSN1o3Bat6eY=@vger.kernel.org
X-Gm-Message-State: AOJu0YyawcrRJFHW7FSm0A3B+8mVfSwViPDOYFAziZYr5KqUqAJlTpRW
	2gkC4uRBQyCO8M1NZk5IFdYAjHkVV0Nh8febgFoIJnYo7x9bldNYK0+f6hEx/IVARsDYwYVm4uN
	EtkcfGNX0ezl0fdVodDi4GfE1JeanJoXX/OR7crLyn/gIw4uH8Q==
X-Gm-Gg: ASbGnct2XKv88uni0qPrYO3wKPSNJfikqPHnz+FA8J/DsG33nFAVmVHWwn1fs0FapmN
	tIXJAj/cHkeYA2ycZJoxixjovTLWDjvoo7TwJnBRXiYqfyGNHf+3Ur6fZ+KpsflPYTpPqx/nBqo
	WylZ6OUT6Llv+xBFxnRHDE7jeWQDt+XKm2KynDkUg1vOkQeEOmx2oqIlvmpe5/3vxy9HBHRyMzH
	4s2PmUTYmE1sAs1tLiI0YjH/iZe/rWUf+mD2YM2fDSc
X-Received: by 2002:a17:906:3096:b0:aa5:1d68:1f45 with SMTP id a640c23a62f3a-aa51d682049mr58566366b.10.1732268038179;
        Fri, 22 Nov 2024 01:33:58 -0800 (PST)
X-Google-Smtp-Source: AGHT+IGFYv7zR6qFmsckcecsvksi7MmCXzK7rX4iEUTBXVqGAocHOTO1fd8ZK0DR8K9GcVlM9+7Tpg==
X-Received: by 2002:a17:906:3096:b0:aa5:1d68:1f45 with SMTP id a640c23a62f3a-aa51d682049mr58563666b.10.1732268037704;
        Fri, 22 Nov 2024 01:33:57 -0800 (PST)
Received: from fedora (g2.ign.cz. [91.219.240.8])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-aa50b28fd61sm75159966b.5.2024.11.22.01.33.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 22 Nov 2024 01:33:57 -0800 (PST)
From: Vitaly Kuznetsov <vkuznets@redhat.com>
To: kalyazin@amazon.com
Cc: pbonzini@redhat.com, seanjc@google.com, tglx@linutronix.de,
 mingo@redhat.com, bp@alien8.de, dave.hansen@linux.intel.com,
 hpa@zytor.com, kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
 david@redhat.com, peterx@redhat.com, oleg@redhat.com, gshan@redhat.com,
 graf@amazon.de, jgowans@amazon.com, roypat@amazon.co.uk,
 derekmn@amazon.com, nsaenz@amazon.es, xmarcalx@amazon.com
Subject: Re: [PATCH] KVM: x86: async_pf: check earlier if can deliver async pf
In-Reply-To: <f8faa85e-24e6-4105-ab83-87b1b8c4bd56@amazon.com>
References: <20241118130403.23184-1-kalyazin@amazon.com>
 <87h684ctlg.fsf@redhat.com>
 <f8faa85e-24e6-4105-ab83-87b1b8c4bd56@amazon.com>
Date: Fri, 22 Nov 2024 10:33:55 +0100
Message-ID: <878qtbvcho.fsf@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain

Nikita Kalyazin <kalyazin@amazon.com> writes:

> On 18/11/2024 17:58, Vitaly Kuznetsov wrote:
>> Nikita Kalyazin <kalyazin@amazon.com> writes:
>> 
>>> On x86, async pagefault events can only be delivered if the page fault
>>> was triggered by guest userspace, not kernel.  This is because
>>> the guest may be in non-sleepable context and will not be able
>>> to reschedule.
>> 
>> We used to set KVM_ASYNC_PF_SEND_ALWAYS for Linux guests before
>> 
>> commit 3a7c8fafd1b42adea229fd204132f6a2fb3cd2d9
>> Author: Thomas Gleixner <tglx@linutronix.de>
>> Date:   Fri Apr 24 09:57:56 2020 +0200
>> 
>>      x86/kvm: Restrict ASYNC_PF to user space
>> 
>> but KVM side of the feature is kind of still there, namely
>> 
>> kvm_pv_enable_async_pf() sets
>> 
>>      vcpu->arch.apf.send_user_only = !(data & KVM_ASYNC_PF_SEND_ALWAYS);
>> 
>> and then we check it in
>> 
>> kvm_can_deliver_async_pf():
>> 
>>       if (vcpu->arch.apf.send_user_only &&
>>           kvm_x86_call(get_cpl)(vcpu) == 0)
>>               return false;
>> 
>> and this can still be used by some legacy guests I suppose. How about
>> we start with removing this completely? It does not matter if some
>> legacy guest wants to get an APF for CPL0, we are never obliged to
>> actually use the mechanism.
>
> If I understand you correctly, the change you propose is rather 
> orthogonal to the original one as the check is performed after the work 
> has been already allocated (in kvm_setup_async_pf).  Would you expect 
> tangible savings from omitting the send_user_only check?
>

No, I don't expect any performance benefits. Basically, I was referring
to the description of your patch: "On x86, async pagefault events can
only be delivered if the page fault was triggered by guest userspace,
not kernel" and strictly speaking this is not true today as we still
support KVM_ASYNC_PF_SEND_ALWAYS in KVM. Yes, modern Linux guest don't
use it but the flag is there. Basically, my suggestion is to start with
a cleanup (untested):

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 6d9f763a7bb9..d0906830a9fb 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -974,7 +974,6 @@ struct kvm_vcpu_arch {
                u64 msr_int_val; /* MSR_KVM_ASYNC_PF_INT */
                u16 vec;
                u32 id;
-               bool send_user_only;
                u32 host_apf_flags;
                bool delivery_as_pf_vmexit;
                bool pageready_pending;
diff --git a/arch/x86/include/uapi/asm/kvm_para.h b/arch/x86/include/uapi/asm/kvm_para.h
index a1efa7907a0b..5558a1ec3dc9 100644
--- a/arch/x86/include/uapi/asm/kvm_para.h
+++ b/arch/x86/include/uapi/asm/kvm_para.h
@@ -87,7 +87,7 @@ struct kvm_clock_pairing {
 #define KVM_MAX_MMU_OP_BATCH           32
 
 #define KVM_ASYNC_PF_ENABLED                   (1 << 0)
-#define KVM_ASYNC_PF_SEND_ALWAYS               (1 << 1)
+#define KVM_ASYNC_PF_SEND_ALWAYS               (1 << 1) /* deprecated */
 #define KVM_ASYNC_PF_DELIVERY_AS_PF_VMEXIT     (1 << 2)
 #define KVM_ASYNC_PF_DELIVERY_AS_INT           (1 << 3)
 
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 83fe0a78146f..cd15e738ca9b 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -3585,7 +3585,6 @@ static int kvm_pv_enable_async_pf(struct kvm_vcpu *vcpu, u64 data)
                                        sizeof(u64)))
                return 1;
 
-       vcpu->arch.apf.send_user_only = !(data & KVM_ASYNC_PF_SEND_ALWAYS);
        vcpu->arch.apf.delivery_as_pf_vmexit = data & KVM_ASYNC_PF_DELIVERY_AS_PF_VMEXIT;
 
        kvm_async_pf_wakeup_all(vcpu);
@@ -13374,8 +13373,7 @@ static bool kvm_can_deliver_async_pf(struct kvm_vcpu *vcpu)
        if (!kvm_pv_async_pf_enabled(vcpu))
                return false;
 
-       if (vcpu->arch.apf.send_user_only &&
-           kvm_x86_call(get_cpl)(vcpu) == 0)
+       if (kvm_x86_call(get_cpl)(vcpu) == 0)
                return false;
 
        if (is_guest_mode(vcpu)) {

-- 
Vitaly


