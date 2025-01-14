Return-Path: <kvm+bounces-35452-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 15AEAA113D2
	for <lists+kvm@lfdr.de>; Tue, 14 Jan 2025 23:06:58 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 698977A373F
	for <lists+kvm@lfdr.de>; Tue, 14 Jan 2025 22:06:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 99B3122577D;
	Tue, 14 Jan 2025 22:03:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="b/eYnuvh"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2F5172139A2
	for <kvm@vger.kernel.org>; Tue, 14 Jan 2025 22:03:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736892195; cv=none; b=nrtIRAWQi42kDeL+VyjxfIICA/pTya1Vf/zXi7JLqd5R76BpNikb6yoft+YEkgjcIAb6bufIitT0U4uo2UCiZeoLvQvFUQhC4mWX1xpZ0KqNbA0+T/fINh1YmLhEJJV37ohnaxRwFqOAx6+ZhZbf35dOuIjc2rMR0Va47GsJIIQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736892195; c=relaxed/simple;
	bh=iEB24mPXNOnmMhT7GqF5V2mxlZjcp6Sc1TJS8/Wv0qE=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=q3vlZheraV2qNjqP+Fwy2MMxaYwpKjX24PC+V+PgS1binQY+xeZuyb9ZGfGSmFPTZevHHV+8RgIpGASiBzAgBiwfDh824BK8t0Y8saOh9MirKpdjPWIhMyPn2wx8KwOT6QI6M1a28TakUzT4g6zeCyXQEDxN/tQXLpdG15yBL1Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=b/eYnuvh; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1736892193;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=+MvD4M913WVwzsF4WAIrvgtMmoaIS9H8PUn1UYGTDYw=;
	b=b/eYnuvh8SepL5C//y85hVhXQF9u6fR/tcwUR68ztYsG6/yvElKub7aiAGgfxcqgPeKu5O
	1XnLog27a+smmli6KgjSbUTxHxG2tfvRnULXu+ObFhF/ZhbT1+or30aW+bH7Wir3FUMuoA
	6VQo/2aG1xGUN0rfLpgt8ekGiBLTKv4=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-571-Oa-ThDKsNMmzGmnWvOF2Ow-1; Tue, 14 Jan 2025 17:03:10 -0500
X-MC-Unique: Oa-ThDKsNMmzGmnWvOF2Ow-1
X-Mimecast-MFC-AGG-ID: Oa-ThDKsNMmzGmnWvOF2Ow
Received: by mail-wm1-f72.google.com with SMTP id 5b1f17b1804b1-43628594d34so33698555e9.2
        for <kvm@vger.kernel.org>; Tue, 14 Jan 2025 14:03:10 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1736892189; x=1737496989;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=+MvD4M913WVwzsF4WAIrvgtMmoaIS9H8PUn1UYGTDYw=;
        b=OPEyf9qnqnwsVd1O2baPw0Q0o9t/ByM01hWFxMlckO6bmTQbU+ctmhM8DGII8qhyEg
         GUQCP1mymb+ABYrUZ792h/0LtUUxROnr/xzABLZ1MvDQNpL4uZeK7xBjtYXM/ZPbzSIW
         dBUbNR+7EwKfWmSlYRFs2N7Gm4Bhvb/lIKbtlnjl5Ch5Y9q4mv27+zlW3ktZx23w/4Nu
         VNTel/cL/Dl2Uok043aODAtCng59oj0PPq4smrPmdcmgzpmn/Y4CQlJAdGzu3X6ivQEb
         T6gvCm8R81jOdF+YQru0DB7UMwP5d5eEL6oX/fMLG8xhJjEEdETsExa5iS/Gh9cWYIhd
         JEOA==
X-Forwarded-Encrypted: i=1; AJvYcCXOfabpCivzZ7XROSQqOSZOieUMHVZoH+4pEzwtXYcMLFxOR8PI1ySYWYPPi4+3mnaP6uA=@vger.kernel.org
X-Gm-Message-State: AOJu0YwYGVXZGFU/2FPdkMBxlvDjsaRtGsg9Psu3o/euOVI9n3OEqACJ
	bYLnrrOQnUvVVL5PdFCrz8vxoZ29ZBWm58f8/RylP9A9aaBjxEPwkEDT6OXy+Cjarby9vcskcMo
	2hRoYpTZZx27tzVZk+jUttOWtCJOsXww3ZEH8yJc0UT0cwWzJJLvA1ggvgn3q
X-Gm-Gg: ASbGnctE4r80YpP6yjp7UtmLIK+NeEYYOaZzdxyJzHK0twCE6/7ze3MspLElycHQRIA
	/wpy0ht5pZTqy8hkwj3l2u/sHXM6XcpiOdBEM26g6I91RBx1eR0YpspUbameVFTE3ZAySs3ybNu
	9vPb3j8r592S4QczRYD4/3Cw9N2YxdYlXLt84oRSFnPbIAPJxidtLQmCuGnB5S5JUJQABGpmWnv
	0XsToIFdF4t9SKR4PNCnZKeJFp2BE8W14xwLXg5Qnn1poRBqkskxO5CrKow
X-Received: by 2002:a05:600c:314f:b0:435:9ed3:5688 with SMTP id 5b1f17b1804b1-436e26a1f79mr269319325e9.18.1736892189447;
        Tue, 14 Jan 2025 14:03:09 -0800 (PST)
X-Google-Smtp-Source: AGHT+IGKm8hhQYE4+E8qiCVhc4G2fcvrymf8/h3v8oo+/TYX5mviQN0KPyQ/jqniImUNBbtDn40Pjg==
X-Received: by 2002:a05:600c:314f:b0:435:9ed3:5688 with SMTP id 5b1f17b1804b1-436e26a1f79mr269319155e9.18.1736892189037;
        Tue, 14 Jan 2025 14:03:09 -0800 (PST)
Received: from [192.168.10.3] ([176.206.124.70])
        by smtp.googlemail.com with ESMTPSA id 5b1f17b1804b1-437c74bf02csm873935e9.17.2025.01.14.14.03.07
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 14 Jan 2025 14:03:08 -0800 (PST)
Message-ID: <277eeb7b-325e-4901-a466-09708560aee5@redhat.com>
Date: Tue, 14 Jan 2025 23:03:06 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 11/13] x86/virt/tdx: Add SEAMCALL wrappers for TD
 measurement of initial contents
To: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>,
 "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
 "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Cc: "Zhao, Yan Y" <yan.y.zhao@intel.com>,
 "sean.j.christopherson@intel.com" <sean.j.christopherson@intel.com>,
 "Huang, Kai" <kai.huang@intel.com>,
 "dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>,
 "Yamahata, Isaku" <isaku.yamahata@intel.com>
References: <20250101074959.412696-1-pbonzini@redhat.com>
 <20250101074959.412696-12-pbonzini@redhat.com>
 <a3813ab21be79ceed508293d22dd65fdacf9c096.camel@intel.com>
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
In-Reply-To: <a3813ab21be79ceed508293d22dd65fdacf9c096.camel@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 1/3/25 19:02, Edgecombe, Rick P wrote:
>> +u64 tdh_mr_extend(struct tdx_td *td, u64 gpa, u64 *rcx, u64 *rdx)
> 
> gpa should be type gpa_t to avoid bare u64 types.

gpa_t is defined in kvm_types.h, I am not sure arch/x86/virt should 
include it.

Paolo


