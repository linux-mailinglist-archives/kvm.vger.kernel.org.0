Return-Path: <kvm+bounces-36585-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 4466CA1BF8D
	for <lists+kvm@lfdr.de>; Sat, 25 Jan 2025 01:09:13 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 89846168E6A
	for <lists+kvm@lfdr.de>; Sat, 25 Jan 2025 00:09:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 93C271C69D;
	Sat, 25 Jan 2025 00:09:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="gI7nB+Lf"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 52D16179BD
	for <kvm@vger.kernel.org>; Sat, 25 Jan 2025 00:09:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737763746; cv=none; b=UBlLaMqYCMcBk/76e9F6DFj/3UWLPtQ4gXG7/S6qDsfkQTxC8EPufLOyG4ID2k5bA9IEDkMu8tUuDzAKBOqTbslGFNo2qZrjir12MuuUJfbd8CKB30bn6eJjbJWGDs5hzLgCi61PMHouoOtdYaI5panRwL6n5Yw9p7TY3LmJsEY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737763746; c=relaxed/simple;
	bh=/Y5Md7Dfd8QuVpnQ6miCnMwO4USPxpBcanRAa/0DuAM=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=To5OleOVSgF2MmVXOXHAQ7JJcoWQ4Q9Eum8q+omdlX1OFbUaUqfbQU8ypLfbl3s7ZweyiVMxjX9UPiwkQT2DAnwfn2ro+el2z+lymZhec7uRaRudByFaSQismnfaXG9L2LXQayANtOThaQO5xKOeEYa+1u8aJZaJOUNT9nrwri0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=gI7nB+Lf; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1737763743;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=+3uKP8g8eLLTFdF1IwLHx+SHSz3PCMPEzmnoC64xqQk=;
	b=gI7nB+LfI7KqSUOIwf7VON0+aQ/nLzmRw+B8p3eft4KEkcI8aaJ+BUf8jY5OGcfPrT4zEL
	GZL+/KqjU7s98gFBHCvj7gRLZcRCy0HEd3Qjty12gS3Xzk+qL/j6YC/1AqTerL9E77zZhb
	9/rix647SQ4mFadVe5peg7Sv2BqZIHE=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-637-RQI3tHtnPiaNWIMdXK6Tng-1; Fri, 24 Jan 2025 19:08:32 -0500
X-MC-Unique: RQI3tHtnPiaNWIMdXK6Tng-1
X-Mimecast-MFC-AGG-ID: RQI3tHtnPiaNWIMdXK6Tng
Received: by mail-wm1-f70.google.com with SMTP id 5b1f17b1804b1-436379713baso12444445e9.2
        for <kvm@vger.kernel.org>; Fri, 24 Jan 2025 16:08:31 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1737763711; x=1738368511;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=+3uKP8g8eLLTFdF1IwLHx+SHSz3PCMPEzmnoC64xqQk=;
        b=s+E5PqnnWw+Xi9rM5Agzywh8Xgt+4r75t4AUJmaB09da/lm8hN8L7ePLB8uRkJpI62
         QGtqdD0psbNNwvgW6XlnTeRyEISxTy+ojyYVXFhCtfWrFwaadRY0tfqcpkCve0EXI/+v
         RCP64fsjgC354YkZ94+HGrzx2GIlzLwZG6snU0/1ffS4kHd4z/YV6DXrg7cxH8R+gv7f
         ZEtERrFkZ1FqgErOlfkKY0ApRGbjryvfAL4SSvdvU3olY6ni6YWJTSk+ZPUZmaA6+h9k
         +UWitLmRN6mukket9uJ1t2th7gHARtGzG2/veS6GNHZNK2MEbwgvVodoi5qy4TUY49x0
         QWXg==
X-Forwarded-Encrypted: i=1; AJvYcCXlwwHQYOLrZQkYS/g0u95DQ1T6qPA4SwIlRRBu0I+nE84Dc6iMgiTkX6vmoXcAj6Bj4yI=@vger.kernel.org
X-Gm-Message-State: AOJu0YzeiKGfC9wICeSteBUno91YBYTWnHhpqcD7usaGQzAsEmbvb4yC
	NTpIQbCI6WO5FoJBnjYfkFHlO7dYfhQEaGhSMzJgkqr46jEdaRztIaU2dowacAci3ehONROVOcc
	taD7YSZia/P8gf0uIiP5Ia7IO99edPOhxkuSr5rHJXeKUZBHNkQ==
X-Gm-Gg: ASbGncsFQPofvZFsiO69HVzwrKanmvggu4HkPeyj4Z28drDfeFp8fBMRUdFAPPixa0f
	zI0iEJP5/fx83dmn91oDlaAg80oyWlmn+uyrw8vJUhmQFj16IuK1z7w58l/rxHcP/8Iw2ILHTRo
	fmdNQU1TB/8fchvEebxruvv9yBsfLEZ/fH/MDbftTklMACzplj7IOH+u6CvEsLiermql7rz7HDK
	Xxuwi8ZH1RzOfck0i4Gf+jYSbYyMeEosyWNJLhEjX4bhESBDLKUVzqQkwWMq1o1mIvTteOqY1V4
	zQS1O/Yu
X-Received: by 2002:a05:600c:4e07:b0:434:a802:e99a with SMTP id 5b1f17b1804b1-438913bec32mr290921085e9.4.1737763710755;
        Fri, 24 Jan 2025 16:08:30 -0800 (PST)
X-Google-Smtp-Source: AGHT+IHHwQf+1d6P9WNGtcsm3P4YTP7VDB0bXFJTvbHUWA87Pk09vnWfPT4RuaCxFYTeTol6WEXmPQ==
X-Received: by 2002:a05:600c:4e07:b0:434:a802:e99a with SMTP id 5b1f17b1804b1-438913bec32mr290920995e9.4.1737763710403;
        Fri, 24 Jan 2025 16:08:30 -0800 (PST)
Received: from [192.168.10.82] ([151.95.59.125])
        by smtp.googlemail.com with ESMTPSA id 5b1f17b1804b1-438bd501c2dsm41680025e9.13.2025.01.24.16.08.29
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 24 Jan 2025 16:08:29 -0800 (PST)
Message-ID: <0188baf2-0bff-4b08-af1d-21815d4e3b42@redhat.com>
Date: Sat, 25 Jan 2025 01:08:28 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/2] KVM: x86: fix usage of kvm_lock in
 set_nx_huge_pages()
To: Sean Christopherson <seanjc@google.com>
Cc: linux-kernel@vger.kernel.org, kvm <kvm@vger.kernel.org>
References: <20250124191109.205955-1-pbonzini@redhat.com>
 <20250124191109.205955-2-pbonzini@redhat.com> <Z5Pz7Ga5UGt88zDc@google.com>
 <CABgObfa4TKcj-d3Spw+TAE7ZfO8wFGJebkW3jMyFY2TrKxMuSw@mail.gmail.com>
 <Z5QhGndjNwYdnIZF@google.com>
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
In-Reply-To: <Z5QhGndjNwYdnIZF@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 1/25/25 00:44, Sean Christopherson wrote:
>> I did try a long SRCU critical section and it was unreviewable. It
>> ends up a lot less manageable than just making the lock a leaf,
>> especially as the lock hierarchy spans multiple subsystems (static
>> key, KVM, cpufreq---thanks CPU hotplug lock...).
> 
> I'm not following.  If __kvmclock_cpufreq_notifier() and set_nx_huge_pages()
> switch to SRCU, then the deadlock goes away (it might even go away if just one
> of those two switches). [...] It would be single use in the it only
> protects pure reader of vm_list, but there are plenty of those users.

Yes, single use in the sense that only set_nx_huge_pages() really needs 
it.  kvm_lock doesn't produce any noticeable contention and as you noted 
sometimes you really need it even in pure readers.

> SRCU readers would only interact with kvm_destroy_vm() from a locking perspective,
> and if that's problematic then we would already have a plethora of issues.

Ah yeah, I missed that you cannot hold any lock when calling 
kvm_put_kvm().  So the waiting side is indeed a leaf and cannot block 
someone else.

Still from your patch (thanks!) I don't really like the special cases on 
taking SRCU vs. kvm_lock... It really seems like a job for a mutex or 
rwsem.  It keeps the complexity in the one place that is different (i.e. 
where a lock is taken inside the iteration) and everything else can just 
iterate normally.

Paolo


