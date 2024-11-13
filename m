Return-Path: <kvm+bounces-31788-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 85FFF9C7ACB
	for <lists+kvm@lfdr.de>; Wed, 13 Nov 2024 19:14:09 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 453E828B2D0
	for <lists+kvm@lfdr.de>; Wed, 13 Nov 2024 18:14:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F3101204953;
	Wed, 13 Nov 2024 18:11:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Sw/FLJlX"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7000720124C
	for <kvm@vger.kernel.org>; Wed, 13 Nov 2024 18:11:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731521483; cv=none; b=P98kBrkzqMlv+Z1reR5poCKIcQxxwCUn2J1zhdZs8grlBvV5CrTNMl8mofvEy8Bl6bq9wFz8FLdBbcsVQa5rLP3sCi2JGVme7ulmZpVmuzae8lZNqpCE2sAbUJmHE4bh4LVRFLcxx+dJJa3A42+WkEOvh8adtufc3KXqD9YqFfw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731521483; c=relaxed/simple;
	bh=nFomwVWpL1apqmVcqtYyIf35yAUOULx4wV+j+EqR/TQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Bcc/ectcZbFm0rEjz8kvkXZfV4p2eE2gOXwRkwqscfU7HSmlnI9uGOrKlyC5jJXHj76symTb0cQ/Ixf8xqz55kB5H6zmOJ5EtH1aaMx5aJfN/kODq04Fp1c4NuDNkDb57hvwLAnKBpBWDEwJuGBZ/DxkUNsyuqzUUPqAIot1Yic=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Sw/FLJlX; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1731521480;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=0YxfwgFTLzupDkk+ne1gwmOE+mfnRoLpiNTNWB7//10=;
	b=Sw/FLJlXk1XMim1QDdC1j4Sy+V0sYA2qfqO4LWnVnonWLzWbe1lc0S6z7AC3OQ1HO8rbWy
	au6zLYwyNNGMTnweZ+/MrYd5odXWAnSnD1cVY4p4kJ30G1vlI34k/djY1lBWOx7fzPVbJz
	XNqHA8oHWjQzwykoTz6ZWHLqseXdswg=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-389-4XDSmX9XO8yyFXw7qaqe7g-1; Wed, 13 Nov 2024 13:11:19 -0500
X-MC-Unique: 4XDSmX9XO8yyFXw7qaqe7g-1
X-Mimecast-MFC-AGG-ID: 4XDSmX9XO8yyFXw7qaqe7g
Received: by mail-wm1-f72.google.com with SMTP id 5b1f17b1804b1-43152cd2843so47298025e9.3
        for <kvm@vger.kernel.org>; Wed, 13 Nov 2024 10:11:19 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1731521478; x=1732126278;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=0YxfwgFTLzupDkk+ne1gwmOE+mfnRoLpiNTNWB7//10=;
        b=GNS4GXbqgSpE5ULL2Rk1+4YStDkKSMgTMmSSaa+iPK7FuOZwRDeUrvVUXx+hCs3OnX
         oQnrS6ZRgsPA8xmBE5jO7KgcNzpeVh8jnLhVURPZT/dYLsM5ZEu+jNCPjB+g24VKn6kj
         aZIHRtPeCDCeNJrgq3Kq0oOm0wfqhNMsQRKSrxICnReSIwr2dfFDH+iokFZSUYGntqO4
         F1JiY+nnXnIb9owW992Do96f+VbrjJCRWlMlnA3R5a0Q4l9mIDr92jlVNxq9ZczveVFe
         KWuUsQIKad7bqodSmYwXmbRhSBy22XKpSK6NiFFy96vTNg+X1uDtvXbJ0ogtRbT1Sliv
         /isQ==
X-Forwarded-Encrypted: i=1; AJvYcCVswg+p0rBoeymSEX2p9tvhdppST+bSFEWuawjjJ0kfd+zayO92s1dpp6lmi1bxmRlYpzw=@vger.kernel.org
X-Gm-Message-State: AOJu0YzJ8scJdTxJ7jrQnQJZKjtH16mPF8snS+mwQE02wOQgtWppSafG
	/J51X4xx7zkUnzPHGTzqgISWmswPCuPvj1U4Rs3gWudQjYCT8rLd5LY90I95U+qAXseTtM7XxiB
	+lpIZfmqIloENMpN7dL8myBPUHNwjQuijF0hI7rMdTvrs0QDhvw==
X-Received: by 2002:a05:6000:470f:b0:382:6d2:2aa9 with SMTP id ffacd0b85a97d-3820833ab47mr5676233f8f.37.1731521478003;
        Wed, 13 Nov 2024 10:11:18 -0800 (PST)
X-Google-Smtp-Source: AGHT+IG/tazobe7GwAJVavzhuXfFhy7pRxGJgNBF0T2pVOsD0Pp4IqH4neTWDhou5gY9cocs+igfKw==
X-Received: by 2002:a05:6000:470f:b0:382:6d2:2aa9 with SMTP id ffacd0b85a97d-3820833ab47mr5676215f8f.37.1731521477623;
        Wed, 13 Nov 2024 10:11:17 -0800 (PST)
Received: from [192.168.10.47] ([151.49.84.243])
        by smtp.googlemail.com with ESMTPSA id ffacd0b85a97d-381ed9ea587sm19302499f8f.78.2024.11.13.10.11.16
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 13 Nov 2024 10:11:17 -0800 (PST)
Message-ID: <b772f6e7-e506-4f87-98d1-5cbe59402b2b@redhat.com>
Date: Wed, 13 Nov 2024 19:11:16 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] i386/kvm: Fix kvm_enable_x2apic link error in non-KVM
 builds
To: Phil Dennis-Jordan <phil@philjordan.eu>, qemu-devel@nongnu.org,
 kvm@vger.kernel.org, mtosatti@redhat.com
Cc: santosh.shukla@amd.com, suravee.suthikulpanit@amd.com
References: <20241113144923.41225-1-phil@philjordan.eu>
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
In-Reply-To: <20241113144923.41225-1-phil@philjordan.eu>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 11/13/24 15:49, Phil Dennis-Jordan wrote:
> It appears that existing call sites for the kvm_enable_x2apic()
> function rely on the compiler eliding the calls during optimisation
> when building with KVM disabled, or on platforms other than Linux,
> where that function is declared but not defined.
> 
> This fragile reliance recently broke down when commit b12cb38 added
> a new call site which apparently failed to be optimised away when
> building QEMU on macOS with clang, resulting in a link error.
> 
> This change moves the function declaration into the existing
> #if CONFIG_KVM
> block in the same header file, while the corresponding
> #else
> block now #defines the symbol as 0, same as for various other
> KVM-specific query functions.
> 
> Signed-off-by: Phil Dennis-Jordan <phil@philjordan.eu>

Nevermind, this actually rung a bell and seems to be the same as
this commit from last year:

commit c04cfb4596ad5032a9869a8f77fe9114ca8af9e0
Author: Daniel Hoffman <dhoff749@gmail.com>
Date:   Sun Nov 19 12:31:16 2023 -0800

     hw/i386: fix short-circuit logic with non-optimizing builds
     
     `kvm_enabled()` is compiled down to `0` and short-circuit logic is
     used to remove references to undefined symbols at the compile stage.
     Some build configurations with some compilers don't attempt to
     simplify this logic down in some cases (the pattern appears to be
     that the literal false must be the first term) and this was causing
     some builds to emit references to undefined symbols.
     
     An example of such a configuration is clang 16.0.6 with the following
     configure: ./configure --enable-debug --without-default-features
     --target-list=x86_64-softmmu --enable-tcg-interpreter
     
     Signed-off-by: Daniel Hoffman <dhoff749@gmail.com>
     Message-Id: <20231119203116.3027230-1-dhoff749@gmail.com>
     Reviewed-by: Michael S. Tsirkin <mst@redhat.com>
     Signed-off-by: Michael S. Tsirkin <mst@redhat.com>

So, this should work:

diff --git a/hw/i386/amd_iommu.c b/hw/i386/amd_iommu.c
index 13af7211e11..af0f4da1f69 100644
--- a/hw/i386/amd_iommu.c
+++ b/hw/i386/amd_iommu.c
@@ -1657,9 +1657,11 @@ static void amdvi_sysbus_realize(DeviceState *dev, Error **errp)
          error_report("AMD IOMMU with x2APIC confguration requires xtsup=on");
          exit(EXIT_FAILURE);
      }
-    if (s->xtsup && kvm_irqchip_is_split() && !kvm_enable_x2apic()) {
-        error_report("AMD IOMMU xtsup=on requires support on the KVM side");
-        exit(EXIT_FAILURE);
+    if (s->xtsup) {
+        if (kvm_irqchip_is_split() && !kvm_enable_x2apic()) {
+            error_report("AMD IOMMU xtsup=on requires support on the KVM side");
+            exit(EXIT_FAILURE);
+        }
      }
  
      pci_setup_iommu(bus, &amdvi_iommu_ops, s);


It's admittedly a bit brittle, but it's already done in the neighboring
hw/i386/intel_iommu.c so I guess it's okay.

Paolo


