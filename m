Return-Path: <kvm+bounces-39895-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id D270CA4C6F0
	for <lists+kvm@lfdr.de>; Mon,  3 Mar 2025 17:25:56 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id CF5D918864FF
	for <lists+kvm@lfdr.de>; Mon,  3 Mar 2025 16:23:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9BCF123314E;
	Mon,  3 Mar 2025 16:15:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="biH1rgV8"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 03FE7217F29
	for <kvm@vger.kernel.org>; Mon,  3 Mar 2025 16:15:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741018514; cv=none; b=CKGnXPZ0YBI4W45JhXGl3OcIsIz8YXmItqMMQEE28eb9L3FWPcywV/34ZxztTXYbQ7tqggdvBCKYJe0BVDtLXeqPpu8kqoJaUdU4cR8so7mECFeBlZzQG9RBBudp5+WwoB5uYywL8wvUU3Jx/aAk3VlEEpEYDtutVkV7I8F1Vy8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741018514; c=relaxed/simple;
	bh=UHQ8vhqpcHN8q/bjgM47x/48IdLOuS9bmUiOoTqRB0g=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=j1spDG5u7PC7WcHfxwLbZQevHj26NE1TELkRu9TeTSoxZW996R11PljPxUBGFrhsTPBmBuYKR/aLwQXhKPyk2Fp3391Kdh7/NWoIYweGIudMjKn0g/or1EeTlLdYxML7wKbBgqJoRNie1M87le8CSV8Vj0rX1/o3yFzSOn9Oamo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=biH1rgV8; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1741018512;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=WO88smOWWthJK1QxqR+UAV6MapZrHQRhHnvW1gpMXWw=;
	b=biH1rgV8BJsPSyQXm/2HcMi7ILpZa4SCYxPUqkoA8vAw438/v3VfQpbsA3rZ9C711x312s
	+iDhcbgxR6ucxMaVJ30LMXzmriUEpx55r6q7vfu9LeOWB7j4+b6XBuvie0YAv5+PxBIt76
	YgK5/Hn5id3jAyufKfozsugZ78n+oco=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-550-AvaUYCa2NI2d_svE83R67A-1; Mon, 03 Mar 2025 11:15:01 -0500
X-MC-Unique: AvaUYCa2NI2d_svE83R67A-1
X-Mimecast-MFC-AGG-ID: AvaUYCa2NI2d_svE83R67A_1741018500
Received: by mail-wm1-f72.google.com with SMTP id 5b1f17b1804b1-43995bff469so32182935e9.2
        for <kvm@vger.kernel.org>; Mon, 03 Mar 2025 08:15:00 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1741018498; x=1741623298;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=WO88smOWWthJK1QxqR+UAV6MapZrHQRhHnvW1gpMXWw=;
        b=qlP3vdloUqBcCE2zUJ6NoCM+pLUAdclK0Ig8T63EhM8cSpgnt7oWga1kduyWugvc8z
         FaLeZ+1ejZBO1xXDbI+P+Kj2Pnm6cuQ+m2KdY8L1iAo5d8e0sF3bfbMqr6HFCNNTnQFt
         k4aFpFpqMbbt/0k7mUk9NWFJfaE1D1Y4TxbOcD+vg3QRaduXgEgawmup8Bh4ihLyan65
         1IyWKWFIvOUlAOoBR/RhDtz/t3/ePDl0/nkbufrWyVdLM36mXtDBFW6MzrPZ4R+qenBJ
         mPOMzG4T+Ldb60VTLepzneL13v0zdNtOOnt6LMBaGX1mUOsisCv9g7eRNZ4vs3A2IxHx
         a7DA==
X-Forwarded-Encrypted: i=1; AJvYcCWIVV0chYNZ4NjhYDGFrcW9cJBFy+nPL76PDIkDeLCLpZ5cXXJpvOJmLjsYb2ix2+HbEbI=@vger.kernel.org
X-Gm-Message-State: AOJu0YzbD2x13NK5E+THtO52gTRgCRYQjOLU4vOE1kwjDEsGqgfskMVU
	FxbTDzSq2DonoU/dnBv/P0B8syKCuDv7EV9V92Lun/+bMbLwPHXjyz7x0BJG9ph9afsQzQo5ctZ
	QMbN/0gXs8dtG6uepwzFTsqSLz3MA2c8VqNLUV0bxk2ILI30wViMJc9aGwC4i
X-Gm-Gg: ASbGncv2eES7ip4OPjhLacT89c53K+K4igCzJSc8/N8mOgXnjip4RVHfxsTkfrr0m2R
	gSkOMBXHDUjQlETvEHaQ6TGMXsn6HuQJQ1hgTXBLQkcE9FmMyxS9adYwmjgWaGxvQsPB31kUVfH
	X8yw6sQAbdpMTgUfdIhdh47rpEb9nCs6H4Ag5Nbmnio+e9CFj4rRH3Y3pN6u+aQaLySKoX5uDRz
	31b59HNcqO5af3C2E6H5gCn7nAUVr6iGYQ36/smUB38gT/HNMFCDK+IxCo7/Cwg3n4AjicX4CW0
	yJcqiKlBqCtud9J95Lw=
X-Received: by 2002:a05:6000:2c6:b0:390:fbdd:994d with SMTP id ffacd0b85a97d-390fbdd9a80mr6260761f8f.27.1741018498639;
        Mon, 03 Mar 2025 08:14:58 -0800 (PST)
X-Google-Smtp-Source: AGHT+IEQO/4LZPvr+KBbaM6MmSATu11kI0bnGEOwBJkKY+mu0Xb1tr6Q858LFXwRFMGNTPMbamnurA==
X-Received: by 2002:a05:6000:2c6:b0:390:fbdd:994d with SMTP id ffacd0b85a97d-390fbdd9a80mr6260747f8f.27.1741018498286;
        Mon, 03 Mar 2025 08:14:58 -0800 (PST)
Received: from [192.168.10.27] ([151.95.119.44])
        by smtp.googlemail.com with ESMTPSA id ffacd0b85a97d-390e47b7d12sm15207850f8f.58.2025.03.03.08.14.56
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 03 Mar 2025 08:14:56 -0800 (PST)
Message-ID: <530fd31f-923b-4337-a9fb-76715eadc338@redhat.com>
Date: Mon, 3 Mar 2025 17:14:55 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 4/4] KVM: TDX: Always honor guest PAT on TDX enabled
 platforms
To: Yan Zhao <yan.y.zhao@intel.com>
Cc: linux-kernel@vger.kernel.org, kvm@vger.kernel.org, seanjc@google.com
References: <20250301073428.2435768-1-pbonzini@redhat.com>
 <20250301073428.2435768-5-pbonzini@redhat.com>
 <Z8UGIryFjJ+msO6i@yzhao56-desk.sh.intel.com>
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
In-Reply-To: <Z8UGIryFjJ+msO6i@yzhao56-desk.sh.intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 3/3/25 02:30, Yan Zhao wrote:
>>   	kvm->arch.has_protected_state = true;
>>   	kvm->arch.has_private_mem = true;
>> +	kvm->arch.disabled_quirks |= KVM_X86_QUIRK_EPT_IGNORE_GUEST_PAT;
> Though the quirk is disabled by default in KVM in tdx_vm_init() for TDs, the
> kvm->arch.disabled_quirks can be overwritten by a userspace specified value in
> kvm_vm_ioctl_enable_cap().
> "kvm->arch.disabled_quirks = cap->args[0] & kvm_caps.supported_quirks;"
> 
> So, when an old userspace tries to disable other quirks on this new KVM, it may
> accidentally turn KVM_X86_QUIRK_EPT_IGNORE_GUEST_PAT into enabled for TDs, which
> would cause SEPT being zapped when (de)attaching non-coherent devices.

Yeah, sorry about that - Xiaoyao also pointed it out and I should have 
noticed it---or marked the patches as RFC which they were.

> Could we force KVM_X86_QUIRK_EPT_IGNORE_GUEST_PAT to be disabled for TDs?
> 
> e.g.
> 
> tdx_vm_init
>     kvm->arch.always_disabled_quirks |= KVM_X86_QUIRK_EPT_IGNORE_GUEST_PAT;
> 
> static inline bool kvm_check_has_quirk(struct kvm *kvm, u64 quirk)
> {
>          WARN_ON_ONCE(kvm->arch.always_disabled_quirk & kvm_caps.force_enabled_quirks);
> 
>          u64 disabled_quirks = kvm->arch.always_disabled_quirk | kvm->arch.disabled_quirks;
>          return !(disabled_quirks & quirk) |
>                 (kvm_caps.force_enabled_quirks & quirk);
> }

We can change KVM_ENABLE_CAP(KVM_X86_DISABLE_QUIRKS), as well as 
QUIRKS2, to use "|=" instead of "=".

While this is technically a change in the API, the current 
implementation is just awful and I hope that no one is relying on it! 
This way, the "always_disabled_quirks" are not needed.

If the "|=" idea doesn't work out I agree that 
kvm->arch.always_disabled_quirk is needed.

Sending v3 shortly...

Paolo


