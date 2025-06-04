Return-Path: <kvm+bounces-48431-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 027E8ACE2D2
	for <lists+kvm@lfdr.de>; Wed,  4 Jun 2025 19:12:12 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id B103516EC36
	for <lists+kvm@lfdr.de>; Wed,  4 Jun 2025 17:12:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A179D1F4179;
	Wed,  4 Jun 2025 17:12:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Cu/H6v4i"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F10E41EB1AA
	for <kvm@vger.kernel.org>; Wed,  4 Jun 2025 17:12:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749057124; cv=none; b=KpIIciadBYjWKzkTMOngmDQrZBndf9wvmPQw/ZKhnhPEUiGV8mjUGj6KAVYXiglWkYyVDNGPyR5Do70TX1OOQxp0ENfKBqyzL7qqm7tgyFa1gcX72YAJ2EwGb9ZrJeWom0hozC+08WFgyoqjdSVV6r9HzARRuaRuCPLhyTBOe9Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749057124; c=relaxed/simple;
	bh=HiHytsPGnbds4NKPpbjAmG1nUz+qlL9ytwVZGIeGhZ4=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=iq0FHCAG6viM9rUv22sPU6edAtxMphXPpj4HAh6k0j8XnDPudskyYcECM9dOl/WKxDWUMfJUOVtc7RmKLTyXAG3tqV99qYX7mHOGYxfGZl6yzBVCgYcgjza8py2LrDU8ERsoL1AZNdfeqJFl4CkKkYT2dkH2urcu6aNcFoxmkCE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Cu/H6v4i; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1749057121;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=fDmYKcTik3HdHnbp9kttCgGiDzVQ6UMn5CSkP0a5vfo=;
	b=Cu/H6v4iVnb8FrabmZuFgGpHItjUiia1/klpMIJqMWIvXftY+tu/6ByZYmNss7S57I7vS+
	XuMsZ6ApEiGg2xUYWALvh0m96Kxcg4ooOqUeOQr9xblRcfv/RklBbo0kmn10gRrAEAonIH
	J4yUeqq2VGpl8CwBAaacBFonTt3oUeE=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-384-RAgl2vL4PdqsQ0HVfYoZFg-1; Wed, 04 Jun 2025 13:11:58 -0400
X-MC-Unique: RAgl2vL4PdqsQ0HVfYoZFg-1
X-Mimecast-MFC-AGG-ID: RAgl2vL4PdqsQ0HVfYoZFg_1749057117
Received: by mail-wm1-f72.google.com with SMTP id 5b1f17b1804b1-451deff247cso5889785e9.1
        for <kvm@vger.kernel.org>; Wed, 04 Jun 2025 10:11:58 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1749057117; x=1749661917;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=fDmYKcTik3HdHnbp9kttCgGiDzVQ6UMn5CSkP0a5vfo=;
        b=EnhVtcVAO3toc6+y7I0SRl8+yAD9NdD7o5ofjul9Fgm7xlJQZ7nkCzn4KB+LwCJ+Fg
         nvPeNvwlJBCKyMHgfEMLjEW7h5IAsMJcyRbkQj/DzSnb10tOSwp7IF6C2PXyHHgrcAOK
         7Xfku66MLVjlySboGBd0FadRWba9Wqi6tNn0zTBRmVZpL+AAkanKHBkqUF7owUSqrcbD
         cMpGeAWwPMuL2VGbkLECP3Hnbwo2wnj9CXPHKIPGQStNK//ng5GV3QMxM3yCqAAoPT7g
         fv65ZJfhkaiRr0/RO0OZiQYe2NOd/xsowun2bOp1mhfNV23EY56YuDwtaT1x73RV1GBb
         20Hw==
X-Gm-Message-State: AOJu0Yxh7mKOF+IIb7ikDjDRVT1tzwMKhIJHM7v7b131c7j0o/eIECKR
	75hNlyLL849c+RR+HKwJmlLT4Q0zCStOPF9qE0LH9eANLfu+ZrulLxqNdljegmR8X2EbPDeYnMA
	H2I8DNO4gLnSPsp601V5MyuD+ro9/1sVfjGNqR7iY+MfHQXAUAUpqXA==
X-Gm-Gg: ASbGnct732fIev1TJ63YAG8sxmsfxgcUCzqU1IkIhe8N7//w3AVFTM0J2lglHm1UGQq
	2oI/JdJ1XSB1qSIdaexw2N4TTeFy75OM49jWjbzgcdFHVeUtz5+QLSUPdfWgKL5dhKjwvsQENDP
	ez0x6Qr6F+zXjaV+dogOOUY3D/KFtecZGagSsh9juDkDatWXLycWz2g4axa/ItmYHhiQtukWSIe
	beCXcQy6JUiBYTa6MY0RCZQGwKW8SkeBzTEvUzQsdaBhv4RO149dHdP+FCcZiSwr4sWKsZ5S4Fx
	NCc6BC2rcI9M7oIFGTbORWY4
X-Received: by 2002:a05:600c:3b1f:b0:448:d54a:ca23 with SMTP id 5b1f17b1804b1-451f8854e92mr3973375e9.8.1749057116974;
        Wed, 04 Jun 2025 10:11:56 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEspzn/21MdE4chVnb4+euJWwR2y7B8B3JjYm3OBvogR9YRRy0pD1DwLpOBJ/z0MGIz3j6UVw==
X-Received: by 2002:a05:600c:3b1f:b0:448:d54a:ca23 with SMTP id 5b1f17b1804b1-451f8854e92mr3973065e9.8.1749057116433;
        Wed, 04 Jun 2025 10:11:56 -0700 (PDT)
Received: from [192.168.10.81] ([151.49.64.79])
        by smtp.googlemail.com with ESMTPSA id ffacd0b85a97d-3a4efe6ca08sm23102833f8f.33.2025.06.04.10.11.54
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 04 Jun 2025 10:11:55 -0700 (PDT)
Message-ID: <8b57d98d-aa53-40d9-ac5e-3f9b74643b38@redhat.com>
Date: Wed, 4 Jun 2025 19:11:54 +0200
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 00/59] KVM: iommu: Overhaul device posted IRQs support
To: Sean Christopherson <seanjc@google.com>, Joerg Roedel <joro@8bytes.org>,
 David Woodhouse <dwmw2@infradead.org>, Lu Baolu <baolu.lu@linux.intel.com>
Cc: kvm@vger.kernel.org, iommu@lists.linux.dev, linux-kernel@vger.kernel.org,
 Sairaj Kodilkar <sarunkod@amd.com>, Vasant Hegde <vasant.hegde@amd.com>,
 Maxim Levitsky <mlevitsk@redhat.com>,
 Joao Martins <joao.m.martins@oracle.com>,
 Francesco Lavra <francescolavra.fl@gmail.com>,
 David Matlack <dmatlack@google.com>
References: <20250523010004.3240643-1-seanjc@google.com>
From: Paolo Bonzini <pbonzini@redhat.com>
Content-Language: en-US
Autocrypt: addr=pbonzini@redhat.com; keydata=
 xsEhBFRCcBIBDqDGsz4K0zZun3jh+U6Z9wNGLKQ0kSFyjN38gMqU1SfP+TUNQepFHb/Gc0E2
 CxXPkIBTvYY+ZPkoTh5xF9oS1jqI8iRLzouzF8yXs3QjQIZ2SfuCxSVwlV65jotcjD2FTN04
 hVopm9llFijNZpVIOGUTqzM4U55sdsCcZUluWM6x4HSOdw5F5Utxfp1wOjD/v92Lrax0hjiX
 DResHSt48q+8FrZzY+AUbkUS+Jm34qjswdrgsC5uxeVcLkBgWLmov2kMaMROT0YmFY6A3m1S
 P/kXmHDXxhe23gKb3dgwxUTpENDBGcfEzrzilWueOeUWiOcWuFOed/C3SyijBx3Av/lbCsHU
 Vx6pMycNTdzU1BuAroB+Y3mNEuW56Yd44jlInzG2UOwt9XjjdKkJZ1g0P9dwptwLEgTEd3Fo
 UdhAQyRXGYO8oROiuh+RZ1lXp6AQ4ZjoyH8WLfTLf5g1EKCTc4C1sy1vQSdzIRu3rBIjAvnC
 tGZADei1IExLqB3uzXKzZ1BZ+Z8hnt2og9hb7H0y8diYfEk2w3R7wEr+Ehk5NQsT2MPI2QBd
 wEv1/Aj1DgUHZAHzG1QN9S8wNWQ6K9DqHZTBnI1hUlkp22zCSHK/6FwUCuYp1zcAEQEAAc0j
 UGFvbG8gQm9uemluaSA8cGJvbnppbmlAcmVkaGF0LmNvbT7CwU0EEwECACMFAlRCcBICGwMH
 CwkIBwMCAQYVCAIJCgsEFgIDAQIeAQIXgAAKCRB+FRAMzTZpsbceDp9IIN6BIA0Ol7MoB15E
 11kRz/ewzryFY54tQlMnd4xxfH8MTQ/mm9I482YoSwPMdcWFAKnUX6Yo30tbLiNB8hzaHeRj
 jx12K+ptqYbg+cevgOtbLAlL9kNgLLcsGqC2829jBCUTVeMSZDrzS97ole/YEez2qFpPnTV0
 VrRWClWVfYh+JfzpXmgyhbkuwUxNFk421s4Ajp3d8nPPFUGgBG5HOxzkAm7xb1cjAuJ+oi/K
 CHfkuN+fLZl/u3E/fw7vvOESApLU5o0icVXeakfSz0LsygEnekDbxPnE5af/9FEkXJD5EoYG
 SEahaEtgNrR4qsyxyAGYgZlS70vkSSYJ+iT2rrwEiDlo31MzRo6Ba2FfHBSJ7lcYdPT7bbk9
 AO3hlNMhNdUhoQv7M5HsnqZ6unvSHOKmReNaS9egAGdRN0/GPDWr9wroyJ65ZNQsHl9nXBqE
 AukZNr5oJO5vxrYiAuuTSd6UI/xFkjtkzltG3mw5ao2bBpk/V/YuePrJsnPFHG7NhizrxttB
 nTuOSCMo45pfHQ+XYd5K1+Cv/NzZFNWscm5htJ0HznY+oOsZvHTyGz3v91pn51dkRYN0otqr
 bQ4tlFFuVjArBZcapSIe6NV8C4cEiSTOwE0EVEJx7gEIAMeHcVzuv2bp9HlWDp6+RkZe+vtl
 KwAHplb/WH59j2wyG8V6i33+6MlSSJMOFnYUCCL77bucx9uImI5nX24PIlqT+zasVEEVGSRF
 m8dgkcJDB7Tps0IkNrUi4yof3B3shR+vMY3i3Ip0e41zKx0CvlAhMOo6otaHmcxr35sWq1Jk
 tLkbn3wG+fPQCVudJJECvVQ//UAthSSEklA50QtD2sBkmQ14ZryEyTHQ+E42K3j2IUmOLriF
 dNr9NvE1QGmGyIcbw2NIVEBOK/GWxkS5+dmxM2iD4Jdaf2nSn3jlHjEXoPwpMs0KZsgdU0pP
 JQzMUMwmB1wM8JxovFlPYrhNT9MAEQEAAcLBMwQYAQIACQUCVEJx7gIbDAAKCRB+FRAMzTZp
 sadRDqCctLmYICZu4GSnie4lKXl+HqlLanpVMOoFNnWs9oRP47MbE2wv8OaYh5pNR9VVgyhD
 OG0AU7oidG36OeUlrFDTfnPYYSF/mPCxHttosyt8O5kabxnIPv2URuAxDByz+iVbL+RjKaGM
 GDph56ZTswlx75nZVtIukqzLAQ5fa8OALSGum0cFi4ptZUOhDNz1onz61klD6z3MODi0sBZN
 Aj6guB2L/+2ZwElZEeRBERRd/uommlYuToAXfNRdUwrwl9gRMiA0WSyTb190zneRRDfpSK5d
 usXnM/O+kr3Dm+Ui+UioPf6wgbn3T0o6I5BhVhs4h4hWmIW7iNhPjX1iybXfmb1gAFfjtHfL
 xRUr64svXpyfJMScIQtBAm0ihWPltXkyITA92ngCmPdHa6M1hMh4RDX+Jf1fiWubzp1voAg0
 JBrdmNZSQDz0iKmSrx8xkoXYfA3bgtFN8WJH2xgFL28XnqY4M6dLhJwV3z08tPSRqYFm4NMP
 dRsn0/7oymhneL8RthIvjDDQ5ktUjMe8LtHr70OZE/TT88qvEdhiIVUogHdo4qBrk41+gGQh
 b906Dudw5YhTJFU3nC6bbF2nrLlB4C/XSiH76ZvqzV0Z/cAMBo5NF/w=
In-Reply-To: <20250523010004.3240643-1-seanjc@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 5/23/25 02:59, Sean Christopherson wrote:
> TL;DR: Overhaul device posted interrupts in KVM and IOMMU, and AVIC in
>         general.
> 
> This applies on the series to add CONFIG_KVM_IOAPIC (and to kill irq_comm.c):
> 
>    https://lore.kernel.org/all/20250519232808.2745331-1-seanjc@google.com
> 
> Fix a variety of bugs related to device posted IRQs, especially on the
> AMD side, and clean up KVM's implementation (this series actually removes
> more code than it adds).
> 
> Stating the obvious, this series is comically large.  Though it's smaller than
> v1! (Ignoring that I cheated by moving 15 patches to a prep series, and that
> Paolo already grabbed several patches).
> 
> Sairaj, I applied your Tested-by somewhat sparingly, as some of the patches
> changed (most notably "Consolidate IRTE update when toggling AVIC on/off").
> Please holler if you want me to remove/add any tags.  And when you get time,
> I'd greatly appreciate a sanity check!
> 
> Batch #1 is mostly SVM specific:
> 
>   - Cleans up various warts and bugs in the IRTE tracking
>   - Fixes AVIC to not reject large VMs (honor KVM's ABI)
>   - Wire up AVIC to enable_ipiv to support disabling IPI virtualization while
>     still utilizing device posted interrupts, and to workaround erratum #1235.
> 
> Batch #3 overhauls the guts of IRQ bypass in KVM, and moves the vast majority
> of the logic to common x86; only the code that needs to communicate with the
> IOMMU is truly vendor specific.
> 
> Batch #4 is more SVM/AVIC cleanups that are made possible by batch #3.
> 
> Batch #5 adds WARNs and drops dead code after all the previous cleanups and
> fixes (I don't want to add the WARNs earlier; I don't see any point in adding
> WARNs in code that's known to be broken).
> 
> Batch #6 is yet more SVM/AVIC cleanups, with the specific goal of configuring
> IRTEs to generate GA log interrupts if and only if KVM actually needs a wake
> event.

Looks good - it's not even that different from v1.  Thanks!

Paolo

> v2:
>   - Drop patches that were already merged.
>   - Move code into irq.c, not x86.c. [Paolo]
>   - Collect review/testing tags. [Sairaj, Vasant]
>   - Sqaush fixup for a comment that was added in the prior patch. [Sairaj]
>   - Rewrote the changelog for "Delete IRTE link from previous vCPU irrespective
>     of new routing". [Sairaj]
>   - Actually drop "struct amd_svm_iommu_ir" and all usage in "Track per-vCPU
>     IRTEs using kvm_kernel_irqfd structure" (the previous version was getting
>     hilarious lucky with struct offsets). [Sairaj]
>   - Drop unused params from kvm_pi_update_irte() and pi_update_irte(). [Sairaj]
>   - Document the rules and behavior of amd_iommu_update_ga(). [Joerg]
>   - Fix a changelog typo. [Paolo]
>   - Document that GALogIntr isn't cached, i.e. can be safely updated without
>     an invalidation. [Joao, Vasant]
>   - Rework avic_vcpu_{load,put}() to use an enumerated parameter instead of a
>     series of booleans. [Paolo]
>   - Drop a redundant "&& new". [Francesco]
>   - Drop the *** DO NOT MERGE *** testing hack patches.
> 
> v1: https://lore.kernel.org/all/20250404193923.1413163-1-seanjc@google.com
> 
> Maxim Levitsky (2):
>    KVM: SVM: Add enable_ipiv param, never set IsRunning if disabled
>    KVM: SVM: Disable (x2)AVIC IPI virtualization if CPU has erratum #1235
> 
> Sean Christopherson (57):
>    KVM: x86: Pass new routing entries and irqfd when updating IRTEs
>    KVM: SVM: Track per-vCPU IRTEs using kvm_kernel_irqfd structure
>    KVM: SVM: Delete IRTE link from previous vCPU before setting new IRTE
>    iommu/amd: KVM: SVM: Delete now-unused cached/previous GA tag fields
>    KVM: SVM: Delete IRTE link from previous vCPU irrespective of new
>      routing
>    KVM: SVM: Drop pointless masking of default APIC base when setting
>      V_APIC_BAR
>    KVM: SVM: Drop pointless masking of kernel page pa's with AVIC HPA
>      masks
>    KVM: SVM: Add helper to deduplicate code for getting AVIC backing page
>    KVM: SVM: Drop vcpu_svm's pointless avic_backing_page field
>    KVM: SVM: Inhibit AVIC if ID is too big instead of rejecting vCPU
>      creation
>    KVM: SVM: Drop redundant check in AVIC code on ID during vCPU creation
>    KVM: SVM: Track AVIC tables as natively sized pointers, not "struct
>      pages"
>    KVM: SVM: Drop superfluous "cache" of AVIC Physical ID entry pointer
>    KVM: VMX: Move enable_ipiv knob to common x86
>    KVM: VMX: Suppress PI notifications whenever the vCPU is put
>    KVM: SVM: Add a comment to explain why avic_vcpu_blocking() ignores
>      IRQ blocking
>    iommu/amd: KVM: SVM: Use pi_desc_addr to derive ga_root_ptr
>    iommu/amd: KVM: SVM: Pass NULL @vcpu_info to indicate "not guest mode"
>    KVM: SVM: Stop walking list of routing table entries when updating
>      IRTE
>    KVM: VMX: Stop walking list of routing table entries when updating
>      IRTE
>    KVM: SVM: Extract SVM specific code out of get_pi_vcpu_info()
>    KVM: x86: Move IRQ routing/delivery APIs from x86.c => irq.c
>    KVM: x86: Nullify irqfd->producer after updating IRTEs
>    KVM: x86: Dedup AVIC vs. PI code for identifying target vCPU
>    KVM: x86: Move posted interrupt tracepoint to common code
>    KVM: SVM: Clean up return handling in avic_pi_update_irte()
>    iommu: KVM: Split "struct vcpu_data" into separate AMD vs. Intel
>      structs
>    KVM: Don't WARN if updating IRQ bypass route fails
>    KVM: Fold kvm_arch_irqfd_route_changed() into
>      kvm_arch_update_irqfd_routing()
>    KVM: x86: Track irq_bypass_vcpu in common x86 code
>    KVM: x86: Skip IOMMU IRTE updates if there's no old or new vCPU being
>      targeted
>    KVM: x86: Don't update IRTE entries when old and new routes were !MSI
>    KVM: SVM: Revert IRTE to legacy mode if IOMMU doesn't provide IR
>      metadata
>    KVM: SVM: Take and hold ir_list_lock across IRTE updates in IOMMU
>    iommu/amd: Document which IRTE fields amd_iommu_update_ga() can modify
>    iommu/amd: KVM: SVM: Infer IsRun from validity of pCPU destination
>    iommu/amd: Factor out helper for manipulating IRTE GA/CPU info
>    iommu/amd: KVM: SVM: Set pCPU info in IRTE when setting vCPU affinity
>    iommu/amd: KVM: SVM: Add IRTE metadata to affined vCPU's list if AVIC
>      is inhibited
>    KVM: SVM: Don't check for assigned device(s) when updating affinity
>    KVM: SVM: Don't check for assigned device(s) when activating AVIC
>    KVM: SVM: WARN if (de)activating guest mode in IOMMU fails
>    KVM: SVM: Process all IRTEs on affinity change even if one update
>      fails
>    KVM: SVM: WARN if updating IRTE GA fields in IOMMU fails
>    KVM: x86: Drop superfluous "has assigned device" check in
>      kvm_pi_update_irte()
>    KVM: x86: WARN if IRQ bypass isn't supported in kvm_pi_update_irte()
>    KVM: x86: WARN if IRQ bypass routing is updated without in-kernel
>      local APIC
>    KVM: SVM: WARN if ir_list is non-empty at vCPU free
>    KVM: x86: Decouple device assignment from IRQ bypass
>    KVM: VMX: WARN if VT-d Posted IRQs aren't possible when starting IRQ
>      bypass
>    KVM: SVM: Use vcpu_idx, not vcpu_id, for GA log tag/metadata
>    iommu/amd: WARN if KVM calls GA IRTE helpers without virtual APIC
>      support
>    KVM: SVM: Fold avic_set_pi_irte_mode() into its sole caller
>    KVM: SVM: Don't check vCPU's blocking status when toggling AVIC on/off
>    KVM: SVM: Consolidate IRTE update when toggling AVIC on/off
>    iommu/amd: KVM: SVM: Allow KVM to control need for GA log interrupts
>    KVM: SVM: Generate GA log IRQs only if the associated vCPUs is
>      blocking
> 
>   arch/x86/include/asm/irq_remapping.h |  17 +-
>   arch/x86/include/asm/kvm-x86-ops.h   |   2 +-
>   arch/x86/include/asm/kvm_host.h      |  20 +-
>   arch/x86/include/asm/svm.h           |  13 +-
>   arch/x86/kvm/irq.c                   | 140 ++++++
>   arch/x86/kvm/svm/avic.c              | 702 ++++++++++++---------------
>   arch/x86/kvm/svm/svm.c               |   4 +
>   arch/x86/kvm/svm/svm.h               |  32 +-
>   arch/x86/kvm/trace.h                 |  19 +-
>   arch/x86/kvm/vmx/capabilities.h      |   1 -
>   arch/x86/kvm/vmx/main.c              |   2 +-
>   arch/x86/kvm/vmx/posted_intr.c       | 140 ++----
>   arch/x86/kvm/vmx/posted_intr.h       |  10 +-
>   arch/x86/kvm/vmx/vmx.c               |   2 -
>   arch/x86/kvm/x86.c                   |  90 +---
>   drivers/iommu/amd/amd_iommu_types.h  |   1 -
>   drivers/iommu/amd/iommu.c            | 125 +++--
>   drivers/iommu/intel/irq_remapping.c  |  10 +-
>   include/linux/amd-iommu.h            |  25 +-
>   include/linux/kvm_host.h             |   9 +-
>   include/linux/kvm_irqfd.h            |   4 +
>   virt/kvm/eventfd.c                   |  22 +-
>   22 files changed, 672 insertions(+), 718 deletions(-)
> 
> 
> base-commit: 3debd5461fba1dcb33e732b16153da0cf5d0c251


