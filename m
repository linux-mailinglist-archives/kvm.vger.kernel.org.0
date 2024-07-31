Return-Path: <kvm+bounces-22749-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 1B1A1942B68
	for <lists+kvm@lfdr.de>; Wed, 31 Jul 2024 12:01:17 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 3E9241C2271A
	for <lists+kvm@lfdr.de>; Wed, 31 Jul 2024 10:01:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 508A01A8C17;
	Wed, 31 Jul 2024 10:01:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="UmFPTTsX"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 693714D8AD
	for <kvm@vger.kernel.org>; Wed, 31 Jul 2024 10:01:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722420069; cv=none; b=KATEeCcZlRXcMNew7gpSyl3IhH4pNzebzh/ZTY0InXFX+ucfsRI60+BdDHLZpt5M01UUqZ82KdRbclZPr3XbY/pRJaH5ZbSk6lrLJrZgTcsAL7KEQDvTi7rH7sjvBjFGBbS70is786hKa3/MtJ+ZXyf0Y+T+pICKngr4YUFlcCA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722420069; c=relaxed/simple;
	bh=bz8WKRSBvkejJV/4MG4GZjDWYVSK7s17GmbG+4Nw0hQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=CjOeiezAMi1L68t1HKY8Gz0UJ12q2v931DwqwSQLCu1OpXaiLE33uaRbqLBJlZ0V4tALFNgL3hw+JBNoNMWthG/StYR9QL6StPMUu83u1HHqsjMhKczN23xgWXEZXHEFzib6bv/lHPnyxZkulOW3aYKo990f5Pf4RO1rOFeAjCE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=UmFPTTsX; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1722420063;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=ptfHAQocJvEC9/HTADjzfeoNdnfaA3fzZXlSdYubYWA=;
	b=UmFPTTsXJc6EIqvUDXVkAx4/l2n02mnwJjLGgDXbMugYcGJb/8e3PdjYuLy5mQUOdG+GH2
	zH2BZHtLYu4mDJa4CqFhvri3QzN69Xc1VYc7grhgvKEbvl6h/CPN9UDhBW1a4OjWZQ57jm
	5Qh3K6n3ts4/DiY12TgdlP4ew902vL4=
Received: from mail-ej1-f69.google.com (mail-ej1-f69.google.com
 [209.85.218.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-117-3IRvRAr_O3ustZwVvSjSGw-1; Wed, 31 Jul 2024 06:01:01 -0400
X-MC-Unique: 3IRvRAr_O3ustZwVvSjSGw-1
Received: by mail-ej1-f69.google.com with SMTP id a640c23a62f3a-a7a9761bf6dso494609166b.3
        for <kvm@vger.kernel.org>; Wed, 31 Jul 2024 03:01:01 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1722420060; x=1723024860;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=ptfHAQocJvEC9/HTADjzfeoNdnfaA3fzZXlSdYubYWA=;
        b=Tom/fClXF+VSm7d6i20x0jLKZCjgWfQJ1pnoqVZ71w6Ot++zxs6ToCp1ZGIQFFDIJQ
         nqsF97p1IMLKrGFVnBlIr0W3FhTXLqsHFAD46G60VzxiTdw5eivY+xFBoeYeuDAh5Ufo
         4RVb3mdo0zPrextLYfDjvk6hNhjkr8lAT9ccXK9AGbmnvQwrS+CHCeYR2gVrKpjXT2Rw
         MRuPQobnwtmOsZDfZ9yg/ckMH5qGUFWGqMY6auXPM56wNevX/yHkwcO/z+4NF0tK1mJm
         QFjWHNN2M4yCgNFmH4EjOKAgtxoP837D9cebsZ92G6xWJZxX1FobktFBK6e031EYO2UE
         125w==
X-Gm-Message-State: AOJu0Yzvy6ALZCZy+XmmiomsNK62mfi+vDswIVYUreJWmptsFhZjy0R4
	51a/C8degbwUY1gsjbmmRG3H4S5iiAXBeytEgjhDh5Ue8D6ogREp6u4FqIr3EnfqwEj5lNJ6zxB
	4X2gmLaOS3IXhPnoS3m7PnjmVjuiMYF61znqnHIolZaP7XhyR6Q==
X-Received: by 2002:a17:907:a08c:b0:a7a:bc34:a4c8 with SMTP id a640c23a62f3a-a7d40176742mr674121066b.69.1722420060322;
        Wed, 31 Jul 2024 03:01:00 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFMM0YB/YDuXLlYlv95CjiE4hqQudl3QVM2PtNZ2I+p1BqLYp5t6uSoI7Nuq6E/jm1DjAdA2w==
X-Received: by 2002:a17:907:a08c:b0:a7a:bc34:a4c8 with SMTP id a640c23a62f3a-a7d40176742mr674118666b.69.1722420059761;
        Wed, 31 Jul 2024 03:00:59 -0700 (PDT)
Received: from [192.168.10.81] ([151.95.101.29])
        by smtp.googlemail.com with ESMTPSA id a640c23a62f3a-a7acab23639sm750039366b.9.2024.07.31.03.00.59
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 31 Jul 2024 03:00:59 -0700 (PDT)
Message-ID: <2e66f368-4502-4604-a98f-d8afb43413eb@redhat.com>
Date: Wed, 31 Jul 2024 12:00:58 +0200
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] KVM: x86/mmu: Conditionally call kvm_zap_obsolete_pages
To: Hao Peng <flyingpenghao@gmail.com>,
 Sean Christopherson <seanjc@google.com>
Cc: kvm@vger.kernel.org, Peng Hao <flyingpeng@tencent.com>
References: <20240730053215.33768-1-flyingpeng@tencent.com>
 <db00e68b-2b34-49e1-aa72-425a35534762@redhat.com>
 <ZqlMob2o-97KsB8t@google.com>
 <CAPm50aLGRrK12ZSJzYadqO7Z7hM25NyXPdCD1sg_dTPCKKhJ-w@mail.gmail.com>
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
In-Reply-To: <CAPm50aLGRrK12ZSJzYadqO7Z7hM25NyXPdCD1sg_dTPCKKhJ-w@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 7/31/24 11:09, Hao Peng wrote:
>> Yep.  And kvm_zap_obsolete_pages() is a relatively cheap nop if there are no
>> pages on active_mmu_pages.  E.g. we could check kvm_memslots_have_rmaps(), but I
>> don't see any point in doing so, as the existing code should be blazing fast
>> relative to the total cost of the zap.
> Here can be optimized by judging whether active_mmu_pages is empty,
> just like kvm_zap_obsolete_pages.
> Regardless of L0 kvm or L1 kvm, when tdp_mmu is enabled, the
> active_mmu_pages list will not be used.
> When ept=0 , the probability that active_mmu_pages is empty is also
> high, not every time
> kvm_zap_obsolete_pages is called.

So if anything you could check list_empty(&kvm->arch.active_mmu_pages) 
before the loop of kvm_zap_obsolete_pages(), similar to what is done in 
kvm_mmu_zap_oldest_mmu_pages().  I doubt it can have any practical 
benefit, though.

Paolo


