Return-Path: <kvm+bounces-37168-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id C7D3DA26680
	for <lists+kvm@lfdr.de>; Mon,  3 Feb 2025 23:22:34 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 4CFF616597A
	for <lists+kvm@lfdr.de>; Mon,  3 Feb 2025 22:22:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 77FF02101BD;
	Mon,  3 Feb 2025 22:22:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="dkKuR4N0"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BBE701FF7CA
	for <kvm@vger.kernel.org>; Mon,  3 Feb 2025 22:22:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738621348; cv=none; b=DiNS8UQLcI+PssAslo7ajdplVBwAJRACNE2ZZmkkG0bRfpjFza6F2QScWpD8jiwlKeqD3B+KLfWuLU1n8i9ZFv1sepyN/ylun1bQG5hUUv1K9HpjyudK6B3snskhJRS/0OGp9ZcOuLrgLV4hSb2wL4skZapXI7emV6pnR3yqqzo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738621348; c=relaxed/simple;
	bh=YqD3RZ0M2iehtfo1xWoiI5ByTs+aCohE9EF5pyxmA+0=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=dII5dxL2d6u5vb6I0Wj0qKiX9VaVXnsZ1IIbeiMzQ82BwW+wy3oDao8Z9XohJCtVicwB215+Va1GzZuZZC7MnTIh0BE4mzyatUyWfcO1dmMQPeW35e+41mJtX8t5uokgR8e3jiD/UCW9ZaDaH4sRn0/GHyM4J/wDee9GQRq6IPM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=dkKuR4N0; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1738621345;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=nB3o37Oac6kH5hUcZJcd+W+A/0dY8NDzxfAxbBF16u0=;
	b=dkKuR4N0cPHB29HLJXIXwWfd6et+00O1Q8HVcV7DrHP55oGFgNpT9rDmgntkk5jpVm97YP
	mWoeSwKxbJOou/dOgv8axFuThbbLe6P1c7isHY6EdZi8s9z4cSYNvyJo5yqd1mx8hcTnGu
	gPM/KwY8OydajXxQcXOM+hHj703JPWg=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-649-McZc1ih2N2y6_Gi6OCoDdw-1; Mon, 03 Feb 2025 17:22:24 -0500
X-MC-Unique: McZc1ih2N2y6_Gi6OCoDdw-1
X-Mimecast-MFC-AGG-ID: McZc1ih2N2y6_Gi6OCoDdw
Received: by mail-wm1-f70.google.com with SMTP id 5b1f17b1804b1-43631d8d9c7so23641345e9.1
        for <kvm@vger.kernel.org>; Mon, 03 Feb 2025 14:22:24 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1738621343; x=1739226143;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=nB3o37Oac6kH5hUcZJcd+W+A/0dY8NDzxfAxbBF16u0=;
        b=j4bDBbs+8Cynew3FyoQY+bXe1r7DUcot6pn8CeNkknSAFuiSFqlxmum5pVPWH5qsQz
         jndeb7DxrohaSiTmGqerIC6vNLBQKLP4prxDssjkUCdOExDEtxnqkqKPBY105/ESc39B
         obh/kzrbK6nxaz3UjDlElkg7K9LKV+6Ynhz8CeRrA5FkDdbo9P4mNVEpE2WBeN4h42bB
         2iECeHBjNrLpBXwsBUArtNnlkQOrcXbcJYi1JXhr9Jv4EfwvSk+RFEitumvmdcy1G9ZC
         WchXxudWCWcZoKQov0rSrhV7ZUkKkkubdzarSKBGUlRDmxEUQIGn8wdPKf5+n/8cyNcx
         LQuA==
X-Gm-Message-State: AOJu0YxXUPCoKCGe5TpTycm5KS8dxK4V9/R62QPKWQlQARphl2q7OMQg
	nfvA2W1GfD7C4UY5iHCadbWF0DdmS2QmEpSNmQOICGtsz0nQRI10qGNHoEk6eKueJj+AcU4Lr3C
	r3gowuDPgCU2JeuQKieDoccaZdx+llFQk923tskzlaTW1Mzdrkg==
X-Gm-Gg: ASbGnctlQF9fM8INvY778SwmSpyMj3vRFa9don7yd87jQ7fcHB2fUBeGzJu0Qfjpcyy
	+uBQge3ZwCWdr60fDjleysVXxJNXiUs7K/UUmIiyG5SRK1W/C5NZluolw1Uhz55uRb1aB68O/wd
	komx3iE4fQmjQCYFVukluE0JpBMOpEvMKCw8lO4ABEfHLRnYVwNA6LIPWBLCeZ5lUk6oqG0UILL
	6t5hWkDAX5vWs/bckOtL9hZo/e9a3hYap1BlbfA1iQlcW1nDpTSK6RuJuyoU8tfkFM9XOttyQB3
	T4nMNw==
X-Received: by 2002:a05:600c:5347:b0:438:e521:1a4d with SMTP id 5b1f17b1804b1-43905f71a89mr6135545e9.5.1738621343004;
        Mon, 03 Feb 2025 14:22:23 -0800 (PST)
X-Google-Smtp-Source: AGHT+IGAH/W5hu0D32jTL4qwOO6xGL01jamVSHNmrzNCpw6ZBQisyMNmahw0XCcNu+AHyWghWTKStw==
X-Received: by 2002:a05:600c:5347:b0:438:e521:1a4d with SMTP id 5b1f17b1804b1-43905f71a89mr6135405e9.5.1738621342576;
        Mon, 03 Feb 2025 14:22:22 -0800 (PST)
Received: from [192.168.10.3] ([151.62.97.55])
        by smtp.googlemail.com with ESMTPSA id 5b1f17b1804b1-438e244ecd6sm172909045e9.28.2025.02.03.14.22.21
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 03 Feb 2025 14:22:22 -0800 (PST)
Message-ID: <60cef3e4-8e94-4cf1-92ae-34089e78a82d@redhat.com>
Date: Mon, 3 Feb 2025 23:22:20 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 3/3] KVM: x86: Decouple APICv activation state from
 apicv_inhibit_reasons
To: Sean Christopherson <seanjc@google.com>,
 "Naveen N Rao (AMD)" <naveen@kernel.org>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
 Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
 Vasant Hegde <vasant.hegde@amd.com>, Maxim Levitsky <mlevitsk@redhat.com>,
 Vitaly Kuznetsov <vkuznets@redhat.com>
References: <cover.1738595289.git.naveen@kernel.org>
 <405a98c2f21b9fe73eddbc35c80b60d6523db70c.1738595289.git.naveen@kernel.org>
 <Z6EOxxZA9XLdXvrA@google.com>
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
In-Reply-To: <Z6EOxxZA9XLdXvrA@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 2/3/25 19:45, Sean Christopherson wrote:
> Unless there's a very, very good reason to support a use case that generates
> ExtInts during boot, but _only_ during boot, and otherwise doesn't have any APICv
> ihibits, I'm leaning towards making SVM's IRQ window inhibit sticky, i.e. never
> clear it.

BIOS tends to use PIT, so that may be too much.  With respect to Naveen's report
of contention on apicv_update_lock, I would go with the sticky-bit idea but apply
it to APICV_INHIBIT_REASON_PIT_REINJ.

Plus, to avoid crazy ExtINT configurations, something like this:

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 3ec6197b1386..3e358d55b676 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1295,6 +1295,11 @@ enum kvm_apicv_inhibit {
  	 */
  	APICV_INHIBIT_REASON_LOGICAL_ID_ALIASED,
  
+	/*
+	 * AVIC is disabled because more than one vCPU has extint unmasked
+	 */
+	APICV_INHIBIT_REASON_EXTINT,
+
  	/*********************************************************/
  	/* INHIBITs that are relevant only to the Intel's APICv. */
  	/*********************************************************/
diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
index 71544b0f6301..33a5f4ef42bd 100644
--- a/arch/x86/kvm/lapic.c
+++ b/arch/x86/kvm/lapic.c
@@ -377,6 +377,7 @@ void kvm_recalculate_apic_map(struct kvm *kvm)
  	struct kvm_apic_map *new, *old = NULL;
  	struct kvm_vcpu *vcpu;
  	unsigned long i;
+	int extint_cnt = 0;
  	u32 max_id = 255; /* enough space for any xAPIC ID */
  	bool xapic_id_mismatch;
  	int r;
@@ -432,6 +433,8 @@ void kvm_recalculate_apic_map(struct kvm *kvm)
  		if (!kvm_apic_present(vcpu))
  			continue;
  
+		extint_cnt += kvm_apic_accept_pic_intr(vcpu);
+
  		r = kvm_recalculate_phys_map(new, vcpu, &xapic_id_mismatch);
  		if (r) {
  			kvfree(new);
@@ -457,6 +460,11 @@ void kvm_recalculate_apic_map(struct kvm *kvm)
  	else
  		kvm_clear_apicv_inhibit(kvm, APICV_INHIBIT_REASON_PHYSICAL_ID_ALIASED);
  
+	if (extint_cnt > 1)
+		kvm_set_apicv_inhibit(kvm, APICV_INHIBIT_REASON_EXTINT);
+	else
+		kvm_clear_apicv_inhibit(kvm, APICV_INHIBIT_REASON_EXTINT);
+
  	if (!new || new->logical_mode == KVM_APIC_MODE_MAP_DISABLED)
  		kvm_set_apicv_inhibit(kvm, APICV_INHIBIT_REASON_LOGICAL_ID_ALIASED);
  	else
diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
index 57ff79bc02a4..ba2fc7dd8ca2 100644
--- a/arch/x86/kvm/svm/svm.h
+++ b/arch/x86/kvm/svm/svm.h
@@ -676,6 +676,7 @@ extern struct kvm_x86_nested_ops svm_nested_ops;
  	BIT(APICV_INHIBIT_REASON_HYPERV) |		\
  	BIT(APICV_INHIBIT_REASON_NESTED) |		\
  	BIT(APICV_INHIBIT_REASON_IRQWIN) |		\
+	BIT(APICV_INHIBIT_REASON_EXTINT) |		\
  	BIT(APICV_INHIBIT_REASON_PIT_REINJ) |		\
  	BIT(APICV_INHIBIT_REASON_BLOCKIRQ) |		\
  	BIT(APICV_INHIBIT_REASON_SEV)      |		\


I don't love adding another inhibit reason but, together, these two should
remove the contention on apicv_update_lock.  Another idea could be to move
IRQWIN to per-vCPU reason but Maxim tells me that it's not so easy.

Paolo


