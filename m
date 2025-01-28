Return-Path: <kvm+bounces-36784-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id C6917A20D3F
	for <lists+kvm@lfdr.de>; Tue, 28 Jan 2025 16:41:59 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id B393A3A3EBA
	for <lists+kvm@lfdr.de>; Tue, 28 Jan 2025 15:41:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 229501D5AAD;
	Tue, 28 Jan 2025 15:41:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="PIo0CM26"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ACCB51A2387
	for <kvm@vger.kernel.org>; Tue, 28 Jan 2025 15:41:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738078912; cv=none; b=BQneFJlk67/Dm9UPMmpzVTRaiuhxKMmzCKeUPlZimKfZ6+B5nr8h/BQObPGS+5k4ULGuM6XUDZjn3iPtt66mpGMlPNFtx+o5M0snkBB1dWbYt6wSWjiYq01HvNp3VORh6IeDMHFdvcnBc5ZLV208vDJQBSCH0Hl3mq/+d9wBaYA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738078912; c=relaxed/simple;
	bh=rKnxtCj4PMLlCaWZ99dlMUSfh6A5en5jmHeNNRRfxgI=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=FRuhoDBmQjKds3XFp4a/QpXHcCHKeJ/8hdiidp1rIM1WIQVbjbLZbDWRDTyKL+8+vv4pzJzpb4UWXv18AMfTXsejrttH3KcMVmXki4FcIQyDQT3y9mvYDRyOqMu2sYJguSv9A7Z+ZAPP7VIqglp3RdDz0dRITAVZefHo24RQ2rY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=PIo0CM26; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1738078909;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=k73+ePZvJwg+asv5ryh/70D1PG8qoC0cBjzVRH7Sok8=;
	b=PIo0CM26CYrinWPFEvbcA6tzYoB8PA9VM7a8sS6UWo+sN9GuF1i7hKwNX7GrOC1Pdhx2EL
	wUPiDoWJjEwUbb2Ozlf9ssrXXU/rjD8OoyBC7iDePSGWOhH5fAnEsPO8fe2RZLZ7GRu2fh
	xIh6yoAsBCr40gp88B4mtmj/C+4eF2M=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-272-CoaKGMrSPeauRHJyBw6-jQ-1; Tue, 28 Jan 2025 10:41:46 -0500
X-MC-Unique: CoaKGMrSPeauRHJyBw6-jQ-1
X-Mimecast-MFC-AGG-ID: CoaKGMrSPeauRHJyBw6-jQ
Received: by mail-wr1-f69.google.com with SMTP id ffacd0b85a97d-385e49efd59so2224603f8f.0
        for <kvm@vger.kernel.org>; Tue, 28 Jan 2025 07:41:45 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1738078903; x=1738683703;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=k73+ePZvJwg+asv5ryh/70D1PG8qoC0cBjzVRH7Sok8=;
        b=BzpdQFkFHtKXTTpy0i4BcoqYXN3/+Vid6YiVThJ2JIFOp1zekugkyrfK9qld8s/q3Y
         iS9Z83lnkMWRBkUU/M4mgVV7A67GQ2osIpy/GvJA15GziXTbvK9xUxlv45hd1Z6YqFM/
         HVwZ1EC0siomxuF8pl6hKVwecSOav5yxSCPq8ceO/r145ZLPzgrjUPySeAhziCnAZ/5V
         UiLLopTIMSIeb9R3dN6LTLcP2VwgDVON/7kQX7tcJ8qrhNYaP3ZYt+Ozw+C2s9MisJSQ
         cjsAH0eZ5YiiySI7TfwoFemWqa3SVLgm2tfrZV3MHZlvuBWUNZVfNPb3JcUzMqOWByoE
         nrPA==
X-Gm-Message-State: AOJu0YxqOeZPSE+kdM6kyS7uXeMdKfsuTw7/iTik8MmqCrMan53gs9F+
	QpSubIuQxD3ZPAP3cF1noAD/Ajd+5ZDx8gHjbNGGFclfd1Ks7ekZKf7XqbiFEfhZtGZz+DsieZF
	/wnm7YRwsdRJeLbf8UFYKvdtcCL9yqFw4iOQcj+CVPzfX0DzJqA==
X-Gm-Gg: ASbGncv7hkD3jWv/lqSEs8h6rFHdVYcgBsbqs/qvsKb4tTZvOxYH2tepdLeN5JwlwvI
	FaF+rbC4yv1+6wvo/RltaoIXWJ95UNuSaWuo8ZnaXefH72QKZWiQmmt5yw5W7fIZ3bBe+vYu5f6
	1F40ImikJm9d2VAMEv36UGISZzgyco+KEOU0egfY615SdTyW0gfipUjAaBupf01y1D2Ngh+2/lX
	KIkwx86OYUlisb0xQ/c6En0r6BHZ7+HZuBtmrJBOBa2jfw/7BSzEbindcPw3xUCebjkCNuCPg3+
	kgG9kkY=
X-Received: by 2002:a05:6000:2ac:b0:38b:dc3d:e4be with SMTP id ffacd0b85a97d-38bf59f0309mr50514792f8f.51.1738078903486;
        Tue, 28 Jan 2025 07:41:43 -0800 (PST)
X-Google-Smtp-Source: AGHT+IGYuQet8DX/TfdKSByKAHxHjKQUGou8aFo7HN2gC1ypQyEsOEM6vmQbJcZ/qnkSOYNTlfE9/w==
X-Received: by 2002:a05:6000:2ac:b0:38b:dc3d:e4be with SMTP id ffacd0b85a97d-38bf59f0309mr50514769f8f.51.1738078903173;
        Tue, 28 Jan 2025 07:41:43 -0800 (PST)
Received: from [192.168.10.3] ([151.95.59.125])
        by smtp.googlemail.com with ESMTPSA id ffacd0b85a97d-38c2a1761ffsm14197749f8f.7.2025.01.28.07.41.41
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 28 Jan 2025 07:41:42 -0800 (PST)
Message-ID: <a0d9ad95-ea69-45dc-a07f-b6dc43e9731e@redhat.com>
Date: Tue, 28 Jan 2025 16:41:41 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] KVM: x86/mmu: Ensure NX huge page recovery thread is
 alive before waking
To: Keith Busch <kbusch@kernel.org>, Sean Christopherson <seanjc@google.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20250124234623.3609069-1-seanjc@google.com>
 <Z5RkcB_wf5Y74BUM@kbusch-mbp> <Z5e4w7IlEEk2cpH-@google.com>
 <Z5fO5bac8ohqUH1D@kbusch-mbp>
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
In-Reply-To: <Z5fO5bac8ohqUH1D@kbusch-mbp>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 1/27/25 19:22, Keith Busch wrote:
>> It's not clear to me that calling vhost_task_wake() before vhost_task_start() is
>> allowed, which is why I deliberately waited until the task was started to make it
>> visible.  Though FWIW, doing "vhost_task_wake(nx_thread)" before vhost_task_start()
>> doesn't explode.
>
> Hm, it does look questionable to try to wake a process that hadn't been
> started yet, but I think it may be okay: task state will be TASK_NEW
> before vhost_task_start(), which looks like will cause wake_up_process()
> to do nothing.

Yes, it's okay because both wake_up_new_task() and try_to_wake_up() take
p->pi_lock.  try_to_wake_up() does not match either bit in TASK_NORMAL
(which is TASK_INTERRUPTIBLE | TASK_UNINTERRUPTIBLE) and does nothing.

I'm queuing the patch with the store before vhost_task_start, and
acquire/release instead of just READ_ONCE/WRITE_ONCE.

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 74c20dbb92da..6d5708146384 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -7127,7 +7127,8 @@ static void kvm_wake_nx_recovery_thread(struct kvm *kvm)
  	 * may not be valid even though the VM is globally visible.  Do nothing,
  	 * as such a VM can't have any possible NX huge pages.
  	 */
-	struct vhost_task *nx_thread = READ_ONCE(kvm->arch.nx_huge_page_recovery_thread);
+	struct vhost_task *nx_thread =
+		smp_load_acquire(&kvm->arch.nx_huge_page_recovery_thread);
  
  	if (nx_thread)
  		vhost_task_wake(nx_thread);
@@ -7474,10 +7475,10 @@ static void kvm_mmu_start_lpage_recovery(struct once *once)
  	if (!nx_thread)
  		return;
  
-	vhost_task_start(nx_thread);
+	/* Make the task visible only once it is fully created. */
+	smp_store_release(&kvm->arch.nx_huge_page_recovery_thread, nx_thread);
  
-	/* Make the task visible only once it is fully started. */
-	WRITE_ONCE(kvm->arch.nx_huge_page_recovery_thread, nx_thread);
+	vhost_task_start(nx_thread);
  }
  
  int kvm_mmu_post_init_vm(struct kvm *kvm)


