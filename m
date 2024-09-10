Return-Path: <kvm+bounces-26297-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 82DD7973D17
	for <lists+kvm@lfdr.de>; Tue, 10 Sep 2024 18:21:59 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 743121F266C6
	for <lists+kvm@lfdr.de>; Tue, 10 Sep 2024 16:21:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AC3CE19FA65;
	Tue, 10 Sep 2024 16:21:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="ZWJoOXSk"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 730062AE69
	for <kvm@vger.kernel.org>; Tue, 10 Sep 2024 16:21:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725985301; cv=none; b=AF+o6WQcTCx8uK+9n+/5ZFL+1YcFbaPBbMmuC40Og0u0gCgpF1SirOE8sbg+sJfQdNSUPHjW6od6O/6fK3ed20kfyUnkJKwcHEFaNk2Anl4/6nKNHHgCbAkljIJlU01+3xo3KzwvjkK+4T5awWuxzJZpUmHh0Ueg2J+FpG/bBc8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725985301; c=relaxed/simple;
	bh=DyidiYEAcbfTyuUHHhcnYRi8E0WHk7B/7uIjm6sptPk=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=BEJKGN8PBIvtZVRjPsKV1l7PX0lLsa0KdDXyu6GSZPhzIHhf9w/LFZXO9FCa9n4oaksuNETft7N6yVrV/1jNbW86GPNubSxgIl+xytIFnhXgDz80gj0viJvlmncDGCmM4PqgoStaF7BYOQ2RJ1khC7ZSezbvJrAlvziCRUnmxnw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=ZWJoOXSk; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1725985299;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=s8TVBQ0I08Tj5jYNymQGICf2X7mYiEujftSoeD9b/Po=;
	b=ZWJoOXSk7be447iuK+SuHpoO9AGJG0wpiDw8zyV4TkfvEc74WIZ7rFo3PtNCf1E9xdA7Xp
	I0mMvO5uKb7XAHkrvs2q5pPTBHppJ4romLdUPJZu3L2OrWZI31wEUy89AMko0O7J3VENe2
	3ShvhOq16G/l8iDMty+P8EYcG3VA7Ao=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-626--JjihT0HMaeeEV-0WgoTOQ-1; Tue, 10 Sep 2024 12:21:38 -0400
X-MC-Unique: -JjihT0HMaeeEV-0WgoTOQ-1
Received: by mail-wr1-f71.google.com with SMTP id ffacd0b85a97d-374b981dd62so525600f8f.3
        for <kvm@vger.kernel.org>; Tue, 10 Sep 2024 09:21:38 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1725985297; x=1726590097;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=s8TVBQ0I08Tj5jYNymQGICf2X7mYiEujftSoeD9b/Po=;
        b=IDZ5ACnJN5HeRNaTk6iobSc++a/TWEGbZffx6xISXTQjBl90f4FOCl951P1jwHZmEY
         JVme5K3jOdVnWkJYDPMG6u4GXhPlyquhDcSDC5B+TvgTQ7TRT7wwBSZKR4mELZaO521l
         aauU7gwa8VZRsGVLUaM0Be+etyzhTq02R0EAuiDpVI3frPPOHexaeG0yCqwi8eEIoiUd
         CwyRYJGt24HZ9+ePpYw9+GYJdpM5q8SKjo75BNW5EUGzPozgFJ13yNtmiBYiF/hck6NY
         ebEcNUaTP2oQlT1ay7jo3rS64zeYtCmURxEIHyuAx8VATx8RHNFHDT8b+muXlJLTIkHo
         iZuA==
X-Forwarded-Encrypted: i=1; AJvYcCVbno2thk2UWx/U0eNvaDH5/Gpoi13EioumfPntTQ9WlHjMqqVJqUtEzVnqcDXMAW1Pauc=@vger.kernel.org
X-Gm-Message-State: AOJu0Yzja1AChMMQ6yZt7NyXZPAXBTZnl2aEEQPfJbF7JdvKbNllLbt0
	c7Y1CEpC37TBq+O6jJf3f4ebAbT/IarubMmyT3SKPZOiOXTWnh/VOGWZ2/qVStX7nakL/lCHN+6
	oH90t0uKv5pNvqugJmmxQlYemSw3kmRlLSPhcuFOQAo9NXQL0wg==
X-Received: by 2002:adf:cd0e:0:b0:373:54c:26a4 with SMTP id ffacd0b85a97d-378b0800883mr132979f8f.54.1725985297008;
        Tue, 10 Sep 2024 09:21:37 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHyikXUDElkxyl3l58LusqOkABEeXkU1MA1VTWp2y9al5aPVZSzK5eGzj+rDerXEjPVqdl5eQ==
X-Received: by 2002:adf:cd0e:0:b0:373:54c:26a4 with SMTP id ffacd0b85a97d-378b0800883mr132960f8f.54.1725985296508;
        Tue, 10 Sep 2024 09:21:36 -0700 (PDT)
Received: from [192.168.10.81] ([151.95.101.29])
        by smtp.googlemail.com with ESMTPSA id ffacd0b85a97d-378956d365fsm9357063f8f.82.2024.09.10.09.21.35
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 10 Sep 2024 09:21:36 -0700 (PDT)
Message-ID: <0b8577af-222f-4195-8d75-d8cc5fcf6cda@redhat.com>
Date: Tue, 10 Sep 2024 18:21:33 +0200
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 02/25] KVM: TDX: Define TDX architectural definitions
To: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>,
 "Li, Xiaoyao" <xiaoyao.li@intel.com>,
 "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
 "seanjc@google.com" <seanjc@google.com>
Cc: "Yamahata, Isaku" <isaku.yamahata@intel.com>,
 "sean.j.christopherson@intel.com" <sean.j.christopherson@intel.com>,
 "tony.lindgren@linux.intel.com" <tony.lindgren@linux.intel.com>,
 "Huang, Kai" <kai.huang@intel.com>,
 "isaku.yamahata@gmail.com" <isaku.yamahata@gmail.com>,
 "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
References: <20240812224820.34826-1-rick.p.edgecombe@intel.com>
 <20240812224820.34826-3-rick.p.edgecombe@intel.com>
 <4eb4a26e-ebad-478e-9635-93f7fbed103b@intel.com>
 <4de6d1fa5f72274af51d063dc17726625de535ac.camel@intel.com>
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
In-Reply-To: <4de6d1fa5f72274af51d063dc17726625de535ac.camel@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 8/29/24 21:46, Edgecombe, Rick P wrote:
>> This leads to another topic that defining all the TDX structure in this
>> patch seems unfriendly for review. It seems better to put the
>> introduction of definition and its user in a single patch.
>
> Yea.

I don't know, it's easier to check a single patch against the manual.  I 
don't have any objection to leaving everything here instead of 
scattering it over multiple patches, in fact I think I prefer it.

Paolo


