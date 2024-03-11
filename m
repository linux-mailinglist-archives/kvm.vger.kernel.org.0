Return-Path: <kvm+bounces-11548-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id CE4CF87819F
	for <lists+kvm@lfdr.de>; Mon, 11 Mar 2024 15:29:18 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id E38EBB22E7E
	for <lists+kvm@lfdr.de>; Mon, 11 Mar 2024 14:29:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CEE3C405F9;
	Mon, 11 Mar 2024 14:29:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="RExG1A1X"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 89DD33FE28
	for <kvm@vger.kernel.org>; Mon, 11 Mar 2024 14:29:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710167346; cv=none; b=in/G5f8sumMU6fc/xEzuK6SWFZrkfMKuuLqaW/T/fE1WhqiXE7qj8HAOamWm6I6IdPfAkagcN1g+d6uowfL6/0zbobYjzauqgjbtOi5QCDOe3BrTS9KT7XMgKmKb2QsImGZeQG6qtdXbQBj4IqClfeD4RIiC0+FjcCPFTKRR5I0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710167346; c=relaxed/simple;
	bh=lvEhKayg87ynsa7PXZ0F/cNTCRohzPeuaH11cVWXK6M=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=BVjVtEgfxApQe27f3+cdqXbzMEkViLaZ5Lz1W53cNz3PuHBBgGlFsidrG0uxEQGnUWhrLj4zeL2Ep7u2E3Zgq/OZciXyN0XOomKDncZkFg86b2d69uCC1T4Jx0pXfMwhZldwlsasb9OvexvkAqb6V9S/X5xYcZopkAahHUqUavY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=RExG1A1X; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1710167343;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=ZxtSnVmFCjtRLTdczrScdrn0iS+cuZPH3UwwJwQHzJI=;
	b=RExG1A1XKoM7Zer6J3B+QxjkE0YGFaoU7s5U6Ni5aM1LkcDkoL4bln0P9nzMowLzIVoUkF
	+rfEusVmDZJb/HeJF//4qCOJUa7BcrqZFQDacUE9dzhNkW/0aipya1ZjUfxb3uO7ZuptTB
	xZbBnJlgCoJiS0HwMRsc3tCMXNH+eYs=
Received: from mail-ed1-f72.google.com (mail-ed1-f72.google.com
 [209.85.208.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-556-lp5EHWU2PKa3zdLul76HkQ-1; Mon, 11 Mar 2024 10:29:02 -0400
X-MC-Unique: lp5EHWU2PKa3zdLul76HkQ-1
Received: by mail-ed1-f72.google.com with SMTP id 4fb4d7f45d1cf-5684b839aafso1176056a12.2
        for <kvm@vger.kernel.org>; Mon, 11 Mar 2024 07:29:02 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1710167340; x=1710772140;
        h=content-transfer-encoding:in-reply-to:autocrypt:from:references:cc
         :to:content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ZxtSnVmFCjtRLTdczrScdrn0iS+cuZPH3UwwJwQHzJI=;
        b=j76AOZGvEF9ttEMAOfy5NO3far8anXF0jlizd2HMhDdHpIu+ypFUoBkBwOUPWDKvC8
         +i3zltBfyEAO4pWeTzdT0q5BZ9zib6JuSVjiBNKLNPRe2oGgH0oJjbgd3X4xrzzplTDz
         TCSsDl9FrqSFMxMnu3/25qG6cjTqaloGG2O4Ja7PAtDUMr5wmAgzyetvYFM6QGyglj/3
         sHuVRhyN8CX5EDslHz7UZ9JPCrVVOJMNXU/0JsaXevH663QJN+yfK3jKY2n7GZoCdfOR
         QZ6tJ99QUB6bYSTrzUEM+7zHA9gdPl7KUwjojVFKCjuXDxyjd3MZ/XM15qaQtAIQa3RR
         Dt3g==
X-Gm-Message-State: AOJu0YzdbmS0tvof55gqVVVALqbMUtLuZm1cDGyu0bXz2JAgX0sbV7+h
	eY5oPqcJkv7kNll04uNgLA542a8L/BAwwAJNZmOcmZCfg7ruwiRBduQPkhkActf0hMDuCvntZ4s
	F+w5sU3isE9CO0wgCOSjxNRsMY4ArPkkCHbUeCcm2SvcYklhkeSpAXWdpsw==
X-Received: by 2002:a50:f68e:0:b0:566:f733:45da with SMTP id d14-20020a50f68e000000b00566f73345damr4930088edn.22.1710167340186;
        Mon, 11 Mar 2024 07:29:00 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHhNYx2TxZ0JrLxCHUxHICYkeYhAsyLYmFN7fbEDJVvWbotrFyqyIRCEXJ8sqck/fYQPL/IGg==
X-Received: by 2002:a50:f68e:0:b0:566:f733:45da with SMTP id d14-20020a50f68e000000b00566f73345damr4930072edn.22.1710167339839;
        Mon, 11 Mar 2024 07:28:59 -0700 (PDT)
Received: from [192.168.10.81] ([151.49.77.21])
        by smtp.googlemail.com with ESMTPSA id k15-20020aa7c04f000000b0056864cde14dsm621950edo.68.2024.03.11.07.28.58
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 11 Mar 2024 07:28:58 -0700 (PDT)
Message-ID: <6309a608-6a8d-4793-bd1a-f77f7758d59f@redhat.com>
Date: Mon, 11 Mar 2024 15:28:56 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [GIT PULL] KVM: x86: Misc changes for 6.9
Content-Language: en-US
To: Sean Christopherson <seanjc@google.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20240308223702.1350851-1-seanjc@google.com>
 <20240308223702.1350851-4-seanjc@google.com>
From: Paolo Bonzini <pbonzini@redhat.com>
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
In-Reply-To: <20240308223702.1350851-4-seanjc@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 3/8/24 23:36, Sean Christopherson wrote:
> A variety of one-off cleanups and fixes, along with two medium sized series to
> (1) improve the "force immediate exit" code and (2) clean up the "vCPU preempted
> in-kernel" checks used for directed yield.
> 
> The following changes since commit 41bccc98fb7931d63d03f326a746ac4d429c1dd3:
> 
>    Linux 6.8-rc2 (2024-01-28 17:01:12 -0800)
> 
> are available in the Git repository at:
> 
>    https://github.com/kvm-x86/linux.git tags/kvm-x86-misc-6.9
> 
> for you to fetch changes up to 78ccfce774435a08d9c69ce434099166cc7952c8:
> 
>    KVM: SVM: Rename vmplX_ssp -> plX_ssp (2024-02-27 12:22:43 -0800)

Queued, thanks.

Paolo

> ----------------------------------------------------------------
> KVM x86 misc changes for 6.9:
> 
>   - Explicitly initialize a variety of on-stack variables in the emulator that
>     triggered KMSAN false positives (though in fairness in KMSAN, it's comically
>     difficult to see that the uninitialized memory is never truly consumed).
> 
>   - Fix the deubgregs ABI for 32-bit KVM, and clean up code related to reading
>     DR6 and DR7.
> 
>   - Rework the "force immediate exit" code so that vendor code ultimately
>     decides how and when to force the exit.  This allows VMX to further optimize
>     handling preemption timer exits, and allows SVM to avoid sending a duplicate
>     IPI (SVM also has a need to force an exit).
> 
>   - Fix a long-standing bug where kvm_has_noapic_vcpu could be left elevated if
>     vCPU creation ultimately failed, and add WARN to guard against similar bugs.
> 
>   - Provide a dedicated arch hook for checking if a different vCPU was in-kernel
>     (for directed yield), and simplify the logic for checking if the currently
>     loaded vCPU is in-kernel.
> 
>   - Misc cleanups and fixes.
> 
> ----------------------------------------------------------------
> John Allen (1):
>        KVM: SVM: Rename vmplX_ssp -> plX_ssp
> 
> Julian Stecklina (2):
>        KVM: x86: Clean up partially uninitialized integer in emulate_pop()
>        KVM: x86: rename push to emulate_push for consistency
> 
> Mathias Krause (1):
>        KVM: x86: Fix broken debugregs ABI for 32 bit kernels
> 
> Nikolay Borisov (1):
>        KVM: x86: Use mutex guards to eliminate __kvm_x86_vendor_init()
> 
> Sean Christopherson (14):
>        KVM: x86: Make kvm_get_dr() return a value, not use an out parameter
>        KVM: x86: Open code all direct reads to guest DR6 and DR7
>        KVM: x86: Plumb "force_immediate_exit" into kvm_entry() tracepoint
>        KVM: VMX: Re-enter guest in fastpath for "spurious" preemption timer exits
>        KVM: VMX: Handle forced exit due to preemption timer in fastpath
>        KVM: x86: Move handling of is_guest_mode() into fastpath exit handlers
>        KVM: VMX: Handle KVM-induced preemption timer exits in fastpath for L2
>        KVM: x86: Fully defer to vendor code to decide how to force immediate exit
>        KVM: x86: Move "KVM no-APIC vCPU" key management into local APIC code
>        KVM: x86: Sanity check that kvm_has_noapic_vcpu is zero at module_exit()
>        KVM: Add dedicated arch hook for querying if vCPU was preempted in-kernel
>        KVM: x86: Rely solely on preempted_in_kernel flag for directed yield
>        KVM: x86: Clean up directed yield API for "has pending interrupt"
>        KVM: Add a comment explaining the directed yield pending interrupt logic
> 
> Thomas Prescher (1):
>        KVM: x86/emulator: emulate movbe with operand-size prefix
> 
>   arch/x86/include/asm/kvm-x86-ops.h |   1 -
>   arch/x86/include/asm/kvm_host.h    |   8 +--
>   arch/x86/include/asm/svm.h         |   8 +--
>   arch/x86/kvm/emulate.c             |  45 +++++++--------
>   arch/x86/kvm/kvm_emulate.h         |   2 +-
>   arch/x86/kvm/lapic.c               |  27 ++++++++-
>   arch/x86/kvm/smm.c                 |  15 ++---
>   arch/x86/kvm/svm/svm.c             |  25 ++++-----
>   arch/x86/kvm/trace.h               |   9 ++-
>   arch/x86/kvm/vmx/nested.c          |   2 +-
>   arch/x86/kvm/vmx/vmx.c             |  85 +++++++++++++++++-----------
>   arch/x86/kvm/vmx/vmx.h             |   2 -
>   arch/x86/kvm/x86.c                 | 110 ++++++++++++-------------------------
>   include/linux/kvm_host.h           |   1 +
>   virt/kvm/kvm_main.c                |  21 ++++++-
>   15 files changed, 184 insertions(+), 177 deletions(-)
> 


