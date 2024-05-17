Return-Path: <kvm+bounces-17647-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 8D16F8C8A54
	for <lists+kvm@lfdr.de>; Fri, 17 May 2024 18:52:06 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 19B7E1F24721
	for <lists+kvm@lfdr.de>; Fri, 17 May 2024 16:52:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0469513D8A5;
	Fri, 17 May 2024 16:51:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="dxOB64+G"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A158613D887
	for <kvm@vger.kernel.org>; Fri, 17 May 2024 16:51:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715964717; cv=none; b=i1z0ORFocNOgpIZ/NoDFyfO0LwKqar4ohIEglaTEtzV3MmB+JmRKkNOFmC06ZcC1kt7KegS5ysufh06J+fBMRTSH9gYI4gifLrrHXzVHamFbwwYfgnBqVPibRZ7BQIGeC9W95hqhk6evFSy3fjDWpmd24FN9Jk0VG0x5FfEgIY4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715964717; c=relaxed/simple;
	bh=nJDeAWSMGgSV0BCmPrBvmVRCISlfWJnMS59TFeIoaW4=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=kfca1dZkRKV2OiT5n2qC+ENVWlFsScj8yZON6BNYeV9oyBrv2npX76EET/19N7hDMelx7edqSR51UFajk2BEk46XWVbDnygbnbThPNAKh/kS5sEtpxMygNoL8DSsUibk1QPZCTeB+m7IOmX5DzsSQx7eHKHi2qNYwTOQ1U+FejM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=dxOB64+G; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1715964714;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=QaLkr3E2+4g4P9Qhu0RDI2xERQtUdx13qtBuZy3qY/M=;
	b=dxOB64+G7uWLTGlOc8yRw6nojeIqubNFrBW8sYO+wHPasW6xThY6pKIuIiqENieUoHG+Dz
	zDB63ZJSwOp+VuDkoXH2YqRBEW/5wB+2NIJss07RfhCOi7uBuXyZ7/ydeU14GgKGG7ACGe
	3ymMDogtKUXUOu2Ou2vFxHM0Y6T4X2A=
Received: from mail-ej1-f71.google.com (mail-ej1-f71.google.com
 [209.85.218.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-94-Kgq0ulKzMSulpARuJWQnSg-1; Fri, 17 May 2024 12:51:53 -0400
X-MC-Unique: Kgq0ulKzMSulpARuJWQnSg-1
Received: by mail-ej1-f71.google.com with SMTP id a640c23a62f3a-a59caea8836so628057366b.1
        for <kvm@vger.kernel.org>; Fri, 17 May 2024 09:51:53 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1715964712; x=1716569512;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=QaLkr3E2+4g4P9Qhu0RDI2xERQtUdx13qtBuZy3qY/M=;
        b=LjfYJXnywUG8+Kd5bswCsiJOYsLSsBvje6oVpjaHFuWJz4fBPUybNyY7HWdWFJaP3U
         XnVDu0Axd7mH1OZJIpJmwmufZsk6hhy3YIGUvWFVqt/WGrQMZx7ej8Mq/iPzchtc/k3k
         jfShb2TgGycQ4kub7HNZmz/lK4Y0gAMYCQVoHog5vPTsu898QkgmJF9N5kNO7TnDkHCp
         Y7bHt2wscilfNa81OSOgtKT0PM8fs2Eo6IBZKVKdmWJLhbSnWwSmiMUZq60JjSR27WqA
         mKhg/TUj90pXvxnTP8eyPAdPgomE1frNR7EMboann7fftHz56bO1YynphgSbPi5QeAxU
         /wDw==
X-Forwarded-Encrypted: i=1; AJvYcCV8tfMXLBjjVYjxUmQm5kZBT4Djr9jF/ezGZ+n20lanTKsSRtNcGXU9Fv1OZMGMkf62HEKVG8YpGtkddGCluLTMGwx7
X-Gm-Message-State: AOJu0YzQGLwvfOOjFLUT9d0QvSl+uY79guZqo95+NTF3KQkyuWY1hys5
	R8tQGV4HuFfXpXDnnuHnaLUmsqTzEL5L7A6+XlBW9Zkz/mNVHv/Wp4JnDlB46dt49CntDN3A4cz
	UIi1LO2Ku8mUB1Fa0KrJ/5wtC4dEt4eJBK0t+UWDRDt16OjZc2w==
X-Received: by 2002:a17:907:130f:b0:a5c:df6b:a9b5 with SMTP id a640c23a62f3a-a5cdf6bade3mr414456466b.59.1715964712251;
        Fri, 17 May 2024 09:51:52 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFpuBOnSqFKgCMManjP/w8LEoygbD1m3z9gUjwo4o5Sun9YN/hBzrpxVtU4MP/AK1D4S4WOXQ==
X-Received: by 2002:a17:907:130f:b0:a5c:df6b:a9b5 with SMTP id a640c23a62f3a-a5cdf6bade3mr414455766b.59.1715964711941;
        Fri, 17 May 2024 09:51:51 -0700 (PDT)
Received: from [192.168.10.81] ([151.95.155.52])
        by smtp.googlemail.com with ESMTPSA id a640c23a62f3a-a5a17b0195dsm1126073966b.184.2024.05.17.09.51.51
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 17 May 2024 09:51:51 -0700 (PDT)
Message-ID: <83c1b5c9-fcf3-41ba-94e8-f536ebb9581e@redhat.com>
Date: Fri, 17 May 2024 18:51:50 +0200
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] KVM: x86: Prevent L0 VMM from modifying L2 VM registers
 via ioctl
To: Liang Chen <liangchen.linux@gmail.com>
Cc: seanjc@google.com, kvm@vger.kernel.org,
 syzbot+988d9efcdf137bc05f66@syzkaller.appspotmail.com
References: <20240515080607.919497-1-liangchen.linux@gmail.com>
 <82c8c53b-56e8-45af-902a-a6b908e5a8b3@redhat.com>
 <CAKhg4t+=vMTaAfbetNZXfgUBiVZYo-tJK-BPX7RbL5kYJrFt=A@mail.gmail.com>
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
In-Reply-To: <CAKhg4t+=vMTaAfbetNZXfgUBiVZYo-tJK-BPX7RbL5kYJrFt=A@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 5/17/24 13:37, Liang Chen wrote:
>>
>> The attached cleaned up reproducer shows that the problem is simply that
>> EFLAGS.VM is set in 64-bit mode.  To fix it, it should be enough to do
>> a nested_vmx_vmexit(vcpu, EXIT_REASON_TRIPLE_FAULT, 0, 0); just like
>> a few lines below.
>>
> Yes, that was the situation we were trying to deal with. However, I am
> not quite sure if I fully understand the suggestion, "To fix it, it
> should be enough to do a nested_vmx_vmexit(vcpu,
> EXIT_REASON_TRIPLE_FAULT, 0, 0); just like a few lines below.". From
> what I see, "(vmx->nested.nested_run_pending, vcpu->kvm) == true" in
> __vmx_handle_exit can be a result of an invalid VMCS12 from L1 that
> somehow escaped checking when trapped into L0 in nested_vmx_run. It is
> not convenient to tell whether it was a result of userspace
> register_set ops, as we are discussing, or an invalid VMCS12 supplied
> by L1.

Right, KVM assumes that it can delegate the "Checks on Guest Segment 
Registers" to the processor if a field is copied straight from VMCS12 to 
VMCS02.  In this case the segments are not set up for virtual-8086 mode;
interestingly the manual seems to say that EFLAGS.VM wins over "IA-32e 
mode guest" is 1 for the purpose of checking guest state.  AMD's manual 
says that EFLAGS.VM is completely ignored in 64-bit mode instead.

I need to look more at the sequence of VMLAUNCH/RESUME, KVM_SET_MSR and 
the failed vmentry to understand exactly what the right fix is.

Paolo

> Additionally, nested_vmx_vmexit warns when
> 'vmx->nested.nested_run_pending is true,' saying that "trying to
> cancel vmlaunch/vmresume is a bug".


