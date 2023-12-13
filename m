Return-Path: <kvm+bounces-4329-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id ADFE38111C9
	for <lists+kvm@lfdr.de>; Wed, 13 Dec 2023 13:51:04 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id D256C1C20ACC
	for <lists+kvm@lfdr.de>; Wed, 13 Dec 2023 12:51:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E1AA92C19C;
	Wed, 13 Dec 2023 12:50:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Zyre5Dyq"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0620C112
	for <kvm@vger.kernel.org>; Wed, 13 Dec 2023 04:50:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1702471808;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=L53V/B5rMe96aC7XL7PLksvfyfKnOaNV78+sYgsMyoE=;
	b=Zyre5DyqMQbgAq7cl5nGNJDFQCtr4XO2yM2eWXU/D0hhBRPafSxa5uAO2fRbDEt8bAzHeg
	ymxF2+T7C1aFPn84hXA4Ew092/Udh8Dk8zClsR15UeLtD6COB7+Z8TbfZr9uUFA0Aslzea
	8ym7gZjA/by1S1EfcYhNlJuwVogJrNU=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-88-MnFXkRyEPnmVO5tvmLxrZA-1; Wed, 13 Dec 2023 07:50:07 -0500
X-MC-Unique: MnFXkRyEPnmVO5tvmLxrZA-1
Received: by mail-wm1-f69.google.com with SMTP id 5b1f17b1804b1-40c421f2686so24953285e9.1
        for <kvm@vger.kernel.org>; Wed, 13 Dec 2023 04:50:06 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1702471806; x=1703076606;
        h=content-transfer-encoding:in-reply-to:autocrypt:from:references:cc
         :to:content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=L53V/B5rMe96aC7XL7PLksvfyfKnOaNV78+sYgsMyoE=;
        b=S0YtTeRqNpRCwMIah9ZGg4MApvB0r7XAfGgAgbjzQcFEIlP/7mV76f7BvrwhpyI7bE
         tY8vSFjaKnQEXwZZi8Bw+qE7kkc4j6ZnaAL2dy4fU08qIt8+8FI3fmoLt5GcR7/A5kg8
         6vETUiWYaInmiUe8E4utLoHfT/gg/8MswEMwyOa1gu15Y8EjpqxToBgtSbSJ5y06kJF3
         BAYM5I/y0N3il0NIRzvT1vzjn6DRmFFKo+yLBgNQtrcR0izQ/NX59NlTxUqx7XxJATYz
         SLmgd85XdUK80jdEUNqrRm98z2wn2L15WF0d/9+HU5LtNxbpd64/jIN6cUqrnfjRFK8I
         RlEA==
X-Gm-Message-State: AOJu0YyR4yfsJl52TSvDXkl4XWPv8bIu/+JbLBT9COpxG77yuOouVmm+
	SHncI7FVCm7h7DMGIyvRdP/ehZ6ekKX5fSmm8hem00IrtK/X3hzyYgKfPCOO3H7Gk5m1iZ5GjZd
	7rZQ8cTmsssoW
X-Received: by 2002:a05:600c:348e:b0:40c:32b3:f294 with SMTP id a14-20020a05600c348e00b0040c32b3f294mr2156456wmq.318.1702471805736;
        Wed, 13 Dec 2023 04:50:05 -0800 (PST)
X-Google-Smtp-Source: AGHT+IG1VR0Uo3Jw+upFUMG6CccPX7W5J+yMKTI/ryCu+dLrWoYxSW4ekledWb92O7Y8EtzJsc4FCw==
X-Received: by 2002:a05:600c:348e:b0:40c:32b3:f294 with SMTP id a14-20020a05600c348e00b0040c32b3f294mr2156434wmq.318.1702471805333;
        Wed, 13 Dec 2023 04:50:05 -0800 (PST)
Received: from ?IPV6:2001:b07:6468:f312:63a7:c72e:ea0e:6045? ([2001:b07:6468:f312:63a7:c72e:ea0e:6045])
        by smtp.googlemail.com with ESMTPSA id w18-20020a5d5452000000b00336367631efsm2399896wrv.65.2023.12.13.04.50.01
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 13 Dec 2023 04:50:04 -0800 (PST)
Message-ID: <e094dc8b-6758-4dd8-89a5-8aab05b2626b@redhat.com>
Date: Wed, 13 Dec 2023 13:50:00 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v10 03/50] KVM: SEV: Do not intercept accesses to
 MSR_IA32_XSS for SEV-ES guests
Content-Language: en-US
To: Michael Roth <michael.roth@amd.com>, kvm@vger.kernel.org
Cc: linux-coco@lists.linux.dev, linux-mm@kvack.org,
 linux-crypto@vger.kernel.org, x86@kernel.org, linux-kernel@vger.kernel.org,
 tglx@linutronix.de, mingo@redhat.com, jroedel@suse.de,
 thomas.lendacky@amd.com, hpa@zytor.com, ardb@kernel.org, seanjc@google.com,
 vkuznets@redhat.com, jmattson@google.com, luto@kernel.org,
 dave.hansen@linux.intel.com, slp@redhat.com, pgonda@google.com,
 peterz@infradead.org, srinivas.pandruvada@linux.intel.com,
 rientjes@google.com, dovmurik@linux.ibm.com, tobin@ibm.com, bp@alien8.de,
 vbabka@suse.cz, kirill@shutemov.name, ak@linux.intel.com,
 tony.luck@intel.com, marcorr@google.com,
 sathyanarayanan.kuppuswamy@linux.intel.com, alpergun@google.com,
 jarkko@kernel.org, ashish.kalra@amd.com, nikunj.dadhania@amd.com,
 pankaj.gupta@amd.com, liam.merwick@oracle.com, zhi.a.wang@intel.com,
 Alexey Kardashevskiy <aik@amd.com>
References: <20231016132819.1002933-1-michael.roth@amd.com>
 <20231016132819.1002933-4-michael.roth@amd.com>
From: Paolo Bonzini <pbonzini@redhat.com>
Autocrypt: addr=pbonzini@redhat.com; keydata=
 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
In-Reply-To: <20231016132819.1002933-4-michael.roth@amd.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 10/16/23 15:27, Michael Roth wrote:
> Address this by disabling intercepts of MSR_IA32_XSS for SEV-ES guests
> if the host/guest configuration allows it. If the host/guest
> configuration doesn't allow for MSR_IA32_XSS, leave it intercepted so
> that it can be caught by the existing checks in
> kvm_{set,get}_msr_common() if the guest still attempts to access it.

This is wrong, because it allows the guest to do untrapped writes to
MSR_IA32_XSS and therefore (via XRSTORS) to MSRs that the host might not
save or restore.

If the processor cannot let the host validate writes to MSR_IA32_XSS,
KVM simply cannot expose XSAVES to SEV-ES (and SEV-SNP) guests.

Because SVM doesn't provide a way to disable just XSAVES in the guest,
all that KVM can do is keep on trapping MSR_IA32_XSS (which the guest
shouldn't read or write to).  In other words the crash on accesses to
MSR_IA32_XSS is not a bug but a feature (of the hypervisor, that
wants/needs to protect itself just as much as the guest wants to).

The bug is that there is no API to tell userspace "do not enable this
and that CPUID for SEV guests", there is only the extremely limited
KVM_GET_SUPPORTED_CPUID system ioctl.

For now, all we can do is document our wishes, with which userspace had
better comply.  Please send a patch to QEMU that makes it obey.

Paolo

--------------------------- 8< -----------------------
 From 303e66472ddf54c2a945588b133d34eaab291257 Mon Sep 17 00:00:00 2001
From: Paolo Bonzini <pbonzini@redhat.com>
Date: Wed, 13 Dec 2023 07:45:08 -0500
Subject: [PATCH] Documentation: KVM: suggest disabling XSAVES on SEV-ES guests

When intercepts are enabled for MSR_IA32_XSS, the host will swap in/out
the guest-defined values while context-switching to/from guest mode.
However, in the case of SEV-ES, vcpu->arch.guest_state_protected is set,
so the guest-defined value is effectively ignored when switching to
guest mode with the understanding that the VMSA will handle swapping
in/out this register state.

However, SVM is still configured to intercept these accesses for SEV-ES
guests, so the values in the initial MSR_IA32_XSS are effectively
read-only, and a guest will experience undefined behavior if it actually
tries to write to this MSR. Fortunately, only CET/shadowstack makes use
of this register on SEV-ES-capable systems currently, which isn't yet
widely used, but this may become more of an issue in the future.

Additionally, enabling intercepts of MSR_IA32_XSS results in #VC
exceptions in the guest in certain paths that can lead to unexpected #VC
nesting levels. One example is SEV-SNP guests when handling #VC
exceptions for CPUID instructions involving leaf 0xD, subleaf 0x1, since
they will access MSR_IA32_XSS as part of servicing the CPUID #VC, then
generate another #VC when accessing MSR_IA32_XSS, which can lead to
guest crashes if an NMI occurs at that point in time. Running perf on a
guest while it is issuing such a sequence is one example where these can
be problematic.

Unfortunately, there is not really a way to fix this issue; allowing
unfiltered access to MSR_IA32_XSS also lets the guest write (via
XRSTORS) MSRs that the host might not be ready to save or restore.
Because SVM doesn't provide a way to disable just XSAVES in the guest,
all that KVM can do to protect itself is keep on trapping MSR_IA32_XSS.
Userspace has to comply and not enable XSAVES in CPUID, so that the
guest has no business accessing MSR_IA32_XSS at all.

Unfortunately^2, there is no API to tell userspace "do not enable this
and that CPUID for SEV guests", there is only the extremely limited
KVM_GET_SUPPORTED_CPUID system ioctl.  So all we can do for now is
document it.

Reported-by: Michael Roth <michael.roth@amd.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>

diff --git a/Documentation/virt/kvm/x86/errata.rst b/Documentation/virt/kvm/x86/errata.rst
index 49a05f24747b..0c91916c0164 100644
--- a/Documentation/virt/kvm/x86/errata.rst
+++ b/Documentation/virt/kvm/x86/errata.rst
@@ -33,6 +33,15 @@ Note however that any software (e.g ``WIN87EM.DLL``) expecting these features
  to be present likely predates these CPUID feature bits, and therefore
  doesn't know to check for them anyway.
  
+Encrypted guests
+~~~~~~~~~~~~~~~~
+
+For SEV-ES guests, it is impossible for KVM to validate writes for MSRs that
+are part of the VMSA.  In the case of MSR_IA32_XSS, however, KVM needs to
+validate writes to the MSR in order to prevent the guest from using XRSTORS
+to overwrite host MSRs.  Therefore, the XSAVES feature should never be exposed
+to SEV-ES guests.
+
  Nested virtualization features
  ------------------------------
  


