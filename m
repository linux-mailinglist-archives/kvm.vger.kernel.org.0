Return-Path: <kvm+bounces-42948-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id B48CEA81063
	for <lists+kvm@lfdr.de>; Tue,  8 Apr 2025 17:43:23 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id A85018A710F
	for <lists+kvm@lfdr.de>; Tue,  8 Apr 2025 15:36:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EC524227BA4;
	Tue,  8 Apr 2025 15:36:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="C1naJIFX"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ECC5C1DF25D
	for <kvm@vger.kernel.org>; Tue,  8 Apr 2025 15:36:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744126578; cv=none; b=YgIdFjtlVnVXbJ+iBHlkE7d71PP3OYtapd7MmNMIgXR+5uInzYAGofk7/5cuXo2v28roB5paRUClQiYgUem4Kz23TB2Tsn70B0IoE3FLd3qTd5uhqWhdLHfUvwsalw0hII5zMw2RJsOAwlrlIcENKTSZKZW7uVq4Y1OOgTqMzd0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744126578; c=relaxed/simple;
	bh=Xs/XjcttaFPRmUdxVhc3/sQTi3nkYB6aqjy0l4SI6pU=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=K857EojwRCgteA5L/t4gqv3qxj3MZDZ8fCjTh2zjKki4bM+wUeZOihuG/tRs9e0ThmxWEqBm+biuT2ObBglJOmrqk7S1LYJeLk23IC7YnDAyVFmLnfVMkzP08pp1gd2BlT6stBScq2TxrHd3VESpOqS3XhyBN7pWwJKfzd0ad0o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=C1naJIFX; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1744126574;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=YTBNt1CwXBSDZTNU10kbF8egg0Ys8FbtNvMxIwm6ip8=;
	b=C1naJIFXSewaU1xP3N/E3SLEizw6uz5zHYKsToBDG3XiuVzhqVMxXlj5DFpMxvpx38qMM9
	4D93pMaAapGdCl9agypVYYuad6iEDyKDPPDcTEAcEKfOFqfHPwW7ZRs+jgxBulR/YpRc5M
	v8FjcweMdvExg4vsYw8KI/9W2z+UOS4=
Received: from mail-ed1-f69.google.com (mail-ed1-f69.google.com
 [209.85.208.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-591-94SY_PyMNi-b3ZWrTee2Hg-1; Tue, 08 Apr 2025 11:36:13 -0400
X-MC-Unique: 94SY_PyMNi-b3ZWrTee2Hg-1
X-Mimecast-MFC-AGG-ID: 94SY_PyMNi-b3ZWrTee2Hg_1744126572
Received: by mail-ed1-f69.google.com with SMTP id 4fb4d7f45d1cf-5e5c808e777so5206893a12.0
        for <kvm@vger.kernel.org>; Tue, 08 Apr 2025 08:36:13 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1744126572; x=1744731372;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=YTBNt1CwXBSDZTNU10kbF8egg0Ys8FbtNvMxIwm6ip8=;
        b=CXc6D+CW5CwrDnsu5g/dA2vzgjp/jgx14Bm1MZfHHXnl8wBfFa/nRggfxjwntr9Eci
         AUrFF0XMlsIKVLSSbTPl6tn59OSvVHD5FjAwezZaRlsvqQ58/lq2MJVM1CFr+jeabgKX
         NWH+/xD1ptt65apHRPp6Vq8cwkUImpMzR1VsnFR2pfyIfelDOClOXfm88pkrJUyD+Hs4
         enR6Zomx5mzOVmr5w/ExRCb+/DxdMG2dSEkquTTfGsmpQBv4ud5ugYuNoZwfK3CXRmVI
         4bjguh2rL/SjaiMKo4e7x9jy0R3YM+Q6JZRQOR0YrJjmRyv9gOTRm4p6XRSg2CvaOAfc
         mmjA==
X-Gm-Message-State: AOJu0YxWyXp94cmWPMwhciXtnlnCuo8Sbsy05UaIYbLqF2VfTjpNW7p2
	x3yIjYCspcyJTh9lufauOefmDKidYD5EhS0gll6WnoiXNAARV5vA6pKS6AAMnZlY+jvwoweUGSX
	jvKwA6gmQgK77F6/LZYy8B31EpitcHSKu0iR4hqMbbNzX3Ez1aA==
X-Gm-Gg: ASbGncuLMOz5JU2sup9cbOFOU+darK8CQfIc3vZSncewdSrPVac2tcEpX4kVD1/cz8y
	sXd9lceg7WYvExmmJnUlgMDnvuHLYuerW6k52nt5g95O3JT7/UkaDyalSKPtP7Xkxo0F88+2bmS
	gsrqxyFTXFH3ZUUqdTogPD265ZqNtA7PDejm2avIptPREGZa82A1ZqeELr5olCxooRbhKIlB0JQ
	FIDAWAVD0Cwy5P0rtY5F+mz+VHK4fxwWz7A65vZhUSSuBXR/DZPIyQVpM3eAfNuaFiQynMFn/RR
	Cyieqr7F5L2fR8n97c9+
X-Received: by 2002:a05:6402:2811:b0:5e5:debf:3f09 with SMTP id 4fb4d7f45d1cf-5f0b470dd5bmr16957727a12.27.1744126572008;
        Tue, 08 Apr 2025 08:36:12 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFlDJOV658Mr/mpu3LCxQ2o6S+eJmVJQOjrA2LmrM4eXfxNUJEGKBDKi4ah7r2uAHqoACCiWg==
X-Received: by 2002:a05:6402:2811:b0:5e5:debf:3f09 with SMTP id 4fb4d7f45d1cf-5f0b470dd5bmr16957690a12.27.1744126571542;
        Tue, 08 Apr 2025 08:36:11 -0700 (PDT)
Received: from [192.168.10.48] ([151.49.197.100])
        by smtp.googlemail.com with ESMTPSA id 4fb4d7f45d1cf-5f1549b3fd0sm2321795a12.35.2025.04.08.08.36.10
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 08 Apr 2025 08:36:10 -0700 (PDT)
Message-ID: <42386a37-9c7f-4f9a-a95f-15236ae29481@redhat.com>
Date: Tue, 8 Apr 2025 17:36:08 +0200
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 00/67] KVM: iommu: Overhaul device posted IRQs support
To: Sean Christopherson <seanjc@google.com>, Joerg Roedel <joro@8bytes.org>,
 David Woodhouse <dwmw2@infradead.org>, Lu Baolu <baolu.lu@linux.intel.com>
Cc: kvm@vger.kernel.org, iommu@lists.linux.dev, linux-kernel@vger.kernel.org,
 Maxim Levitsky <mlevitsk@redhat.com>,
 Joao Martins <joao.m.martins@oracle.com>, David Matlack <dmatlack@google.com>
References: <20250404193923.1413163-1-seanjc@google.com>
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
In-Reply-To: <20250404193923.1413163-1-seanjc@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 4/4/25 21:38, Sean Christopherson wrote:
> TL;DR: Overhaul device posted interrupts in KVM and IOMMU, and AVIC in
>         general.  This needs more testing on AMD with device posted IRQs.
> 
> This applies on the small series that adds a enable_device_posted_irqs
> module param (the prep work for that is also prep work for this):
> 
>     https://lore.kernel.org/all/20250401161804.842968-1-seanjc@google.com
> 
> Fix a variety of bugs related to device posted IRQs, especially on the
> AMD side, and clean up KVM's implementation, which IMO is in the running
> for Most Convoluted Code in KVM.
> 
> Stating the obvious, this series is comically large.  I'm posting it as a
> single series, at least for the first round of reviews, to build the
> (mostly) full picture of the end goal (it's not the true end goal; there's
> still more cleanups that can be done).  And because properly testing most
> of the code would be futile until almost the end of the series (so. many.
> bugs.).
> 
> Batch #1 (patches 1-10) fixes bugs of varying severity.

I started reviewing these, I guess patches 1-7 could be queued for 6.15? 
  And maybe also patch 2 from 
https://lore.kernel.org/all/20250401161804.842968-1-seanjc@google.com/.

Paolo

> Batch #2 is mostly SVM specific:
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
> fixes (I don't want to add the WARNs earlier; I don't any point in adding
> WARNs in code that's known to be broken).
> 
> Batch #6 is yet more SVM/AVIC cleanups, with the specific goal of configuring
> IRTEs to generate GA log interrupts if and only if KVM actually needs a wake
> event.
> 
> This series is well tested except for one notable gap: I was not able to
> fully test the AMD IOMMU changes.  Long story short, getting upstream
> kernels into our full test environments is practically infeasible.  And
> exposing a device or VF on systems that are available to developers is a
> bit of a mess.
> 
> The device the selftest (see the last patch) uses is an internel test VF
> that's hosted on a smart NIC using non-production (test-only) firmware.
> Unfortunately, only some of our developer systems have the right NIC, and
> for unknown reasons I couldn't get the test firmware to install cleanly on
> Rome systems.  I was able to get it functional on Milan (and Intel CPUs),
> but APIC virtualization is disabled on Milan.  Thanks to KVM's force_avic
> I could test the KVM flows, but the IOMMU was having none of my attempts
> to force enable APIC virtualization against its will.
> 
> Through hackery (see the penultimate patch), I was able to gain a decent
> amount of confidence in the IOMMU changes (and the interface between KVM
> and the IOMMU).
> 
> For initial development of the series, I also cobbled together a "mock"
> IRQ bypass device, to allow testing in a VM.
> 
>    https://github.com/sean-jc/linux.git x86/mock_irqbypass_producer
> 
> Note, the diffstat is misleading due to the last two DO NOT MERGE patches
> adding 1k+ LoC.  Without those, this series removes ~80 LoC (substantially
> more if comments are ignored).
> 
>    21 files changed, 577 insertions(+), 655 deletions(-)
> 
> Maxim Levitsky (2):
>    KVM: SVM: Add enable_ipiv param, never set IsRunning if disabled
>    KVM: SVM: Disable (x2)AVIC IPI virtualization if CPU has erratum #1235
> 
> Sean Christopherson (65):
>    KVM: SVM: Allocate IR data using atomic allocation
>    KVM: x86: Reset IRTE to host control if *new* route isn't postable
>    KVM: x86: Explicitly treat routing entry type changes as changes
>    KVM: x86: Take irqfds.lock when adding/deleting IRQ bypass producer
>    iommu/amd: Return an error if vCPU affinity is set for non-vCPU IRTE
>    iommu/amd: WARN if KVM attempts to set vCPU affinity without posted
>      intrrupts
>    KVM: SVM: WARN if an invalid posted interrupt IRTE entry is added
>    KVM: x86: Pass new routing entries and irqfd when updating IRTEs
>    KVM: SVM: Track per-vCPU IRTEs using kvm_kernel_irqfd structure
>    KVM: SVM: Delete IRTE link from previous vCPU before setting new IRTE
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
>    iommu/amd: KVM: SVM: Delete now-unused cached/previous GA tag fields
>    iommu/amd: KVM: SVM: Pass NULL @vcpu_info to indicate "not guest mode"
>    KVM: SVM: Get vCPU info for IRTE using new routing entry
>    KVM: SVM: Stop walking list of routing table entries when updating
>      IRTE
>    KVM: VMX: Stop walking list of routing table entries when updating
>      IRTE
>    KVM: SVM: Extract SVM specific code out of get_pi_vcpu_info()
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
>    *** DO NOT MERGE *** iommu/amd: Hack to fake IRQ posting support
>    *** DO NOT MERGE *** KVM: selftests: WIP posted interrupts test
> 
>   arch/x86/include/asm/irq_remapping.h          |  17 +-
>   arch/x86/include/asm/kvm-x86-ops.h            |   2 +-
>   arch/x86/include/asm/kvm_host.h               |  20 +-
>   arch/x86/include/asm/svm.h                    |  13 +-
>   arch/x86/kvm/svm/avic.c                       | 707 ++++++++----------
>   arch/x86/kvm/svm/svm.c                        |   6 +
>   arch/x86/kvm/svm/svm.h                        |  24 +-
>   arch/x86/kvm/trace.h                          |  19 +-
>   arch/x86/kvm/vmx/capabilities.h               |   1 -
>   arch/x86/kvm/vmx/main.c                       |   2 +-
>   arch/x86/kvm/vmx/posted_intr.c                | 150 ++--
>   arch/x86/kvm/vmx/posted_intr.h                |  11 +-
>   arch/x86/kvm/vmx/vmx.c                        |   2 -
>   arch/x86/kvm/x86.c                            | 124 ++-
>   drivers/iommu/amd/amd_iommu_types.h           |   1 -
>   drivers/iommu/amd/init.c                      |   8 +-
>   drivers/iommu/amd/iommu.c                     | 171 +++--
>   drivers/iommu/intel/irq_remapping.c           |  10 +-
>   include/linux/amd-iommu.h                     |  25 +-
>   include/linux/kvm_host.h                      |   9 +-
>   include/linux/kvm_irqfd.h                     |   4 +
>   tools/testing/selftests/kvm/Makefile.kvm      |   2 +
>   .../selftests/kvm/include/vfio_pci_util.h     | 149 ++++
>   .../selftests/kvm/include/x86/processor.h     |  21 +
>   .../testing/selftests/kvm/lib/vfio_pci_util.c | 201 +++++
>   tools/testing/selftests/kvm/mercury_device.h  | 118 +++
>   tools/testing/selftests/kvm/vfio_irq_test.c   | 429 +++++++++++
>   virt/kvm/eventfd.c                            |  22 +-
>   28 files changed, 1610 insertions(+), 658 deletions(-)
>   create mode 100644 tools/testing/selftests/kvm/include/vfio_pci_util.h
>   create mode 100644 tools/testing/selftests/kvm/lib/vfio_pci_util.c
>   create mode 100644 tools/testing/selftests/kvm/mercury_device.h
>   create mode 100644 tools/testing/selftests/kvm/vfio_irq_test.c
> 
> 
> base-commit: 5f9f498ea14ffe15390aa46fb85375e7c901bce3


