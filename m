Return-Path: <kvm+bounces-26316-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 179F6973D86
	for <lists+kvm@lfdr.de>; Tue, 10 Sep 2024 18:42:23 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id C33BA1F287FE
	for <lists+kvm@lfdr.de>; Tue, 10 Sep 2024 16:42:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 106841A0732;
	Tue, 10 Sep 2024 16:42:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="iNVeOQpC"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A7BE614F12C
	for <kvm@vger.kernel.org>; Tue, 10 Sep 2024 16:42:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725986531; cv=none; b=lEJK9VWBvQFJzxaJR/pBG1hKISZok0An2uOiePDTkF0KLlioayAtexzDXmk+EuMv9HS7iLo941tQyvOWd7qYTiKjRmjow9Wbw04BZG8fNIwgwAmnXtUkQdCmg6yrOTC/Ac10O2Mjok1Z10fp/7NuOgQnAnDlOjM9V+V/1iO//b4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725986531; c=relaxed/simple;
	bh=q09SknjQVdFpkrE3yq9C68KlMoqAspF5lEqpJV8ImuU=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=OLNdB8UvKhXQB3RSYFdZ68xEOBfvCan+A1q291l0Z0TYXiLrQrkJdzxdV4di1v8uawKbj1Yd1wvqisIPXeixH4x3eV3oQE+AlaUTWYPXLREHO08V/xeuaHXYRZ+oPJ4fH2yH9lWTQXu6hCCFOL2SIyU3vnvEywiCq38vvMkoauI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=iNVeOQpC; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1725986528;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=gSCliin7kZlAB/1vvsAa5dIXyMklenlQRdOikBm/ZMY=;
	b=iNVeOQpClPa5qPvrbOV+WX53Eph0vy7yOhFLR4cwNgZ7NVt1KZ8wlhRFY96UJeEG6ix46n
	VfuhGhhYnRYSMosp0lP2Y0S11/G1n1s/9ETMynetylbqNQ4DhhizfsU98In3kFZI1cUJMd
	F4KFUrXIg7X9mcHeB512sbYZe43DyaQ=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-693-_KU2EWyDPhCdv8olPgkA0Q-1; Tue, 10 Sep 2024 12:42:07 -0400
X-MC-Unique: _KU2EWyDPhCdv8olPgkA0Q-1
Received: by mail-wm1-f69.google.com with SMTP id 5b1f17b1804b1-42cb827e9b6so7951315e9.0
        for <kvm@vger.kernel.org>; Tue, 10 Sep 2024 09:42:07 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1725986526; x=1726591326;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=gSCliin7kZlAB/1vvsAa5dIXyMklenlQRdOikBm/ZMY=;
        b=RGmchXMVWbz30RIeY5BBHFXyc2Ca7fE/G1GgAdcaPgRMcEcQdgx87sp0MofYltmD1O
         zASmTfgiZ7FanDz277zUlAP2qcrFIttt10ouvryFeihEDV4BTiqF1fTZIkEAJx85h+QL
         tjpnIq441aIIWGZWXhT6MZg/xxTJ3PjKdscHdiqTP19pSfGSnKM+pxlKy3GCAgnVbo58
         vIZPj7v9lcwIBBo36HtshMUiti2jJG7OXzEv55LqVWecnrvekwbKVp4Kd4ncUqF9VVaX
         YoCG8S7T7Tv9MlbxoZJit1WE3lNPsEtG1HEdt/3BgdgNHEKPieY0hLOJjhog77uRTfkF
         JlJQ==
X-Forwarded-Encrypted: i=1; AJvYcCWNuZXn3P1kJr9I4+e2+PkjZM+9q8cDYaq7uWwYsg4TqgYX44GEBijWVG8bH794HxWjOWo=@vger.kernel.org
X-Gm-Message-State: AOJu0YxcX/H8f8P/BLUC3ZmvFBrlLso+i/zd76WU9S6hqakXSYfmX63b
	Zzy4WUpQqQfoyXSLLMLnYac5+de/ZUDCYifh2yuwxHelPTErYuymP7bDnUeOMbPMkRMgC1LePAM
	2az3ci61q6T2JzxAMMjsp0+jabXas2Uch9Unf3kv+C3VutTQmTA==
X-Received: by 2002:adf:e6c1:0:b0:374:ccb0:66c7 with SMTP id ffacd0b85a97d-378b07ac8e3mr204783f8f.16.1725986526107;
        Tue, 10 Sep 2024 09:42:06 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFTUTrXm7HJoIzhHQqxGzM9BogPova2ShDIqPagrR1d28d+Ilsp9eix1trTmUCkdp1aA/u6bg==
X-Received: by 2002:adf:e6c1:0:b0:374:ccb0:66c7 with SMTP id ffacd0b85a97d-378b07ac8e3mr204759f8f.16.1725986525552;
        Tue, 10 Sep 2024 09:42:05 -0700 (PDT)
Received: from [192.168.10.81] ([151.95.101.29])
        by smtp.googlemail.com with ESMTPSA id ffacd0b85a97d-3789564b02asm9507268f8f.4.2024.09.10.09.42.03
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 10 Sep 2024 09:42:04 -0700 (PDT)
Message-ID: <99b3b6f1-f70a-4fa7-9ebf-0532bd0c8002@redhat.com>
Date: Tue, 10 Sep 2024 18:42:02 +0200
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 07/25] KVM: TDX: Add helper functions to allocate/free TDX
 private host key id
To: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>,
 "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
 "seanjc@google.com" <seanjc@google.com>
Cc: "Li, Xiaoyao" <xiaoyao.li@intel.com>,
 "Yamahata, Isaku" <isaku.yamahata@intel.com>,
 "tony.lindgren@linux.intel.com" <tony.lindgren@linux.intel.com>,
 "Huang, Kai" <kai.huang@intel.com>,
 "isaku.yamahata@gmail.com" <isaku.yamahata@gmail.com>,
 "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
References: <20240812224820.34826-1-rick.p.edgecombe@intel.com>
 <20240812224820.34826-8-rick.p.edgecombe@intel.com>
 <661e790f-7ed8-46ce-9f7c-9776de7127a8@redhat.com>
 <e5dd31c924e8be70d817fe71e69d40053ae7f15a.camel@intel.com>
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
In-Reply-To: <e5dd31c924e8be70d817fe71e69d40053ae7f15a.camel@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 9/10/24 18:39, Edgecombe, Rick P wrote:
>>> Use this range of HKIDs reserved for guest use with the kernel's IDA
>>> allocator library helper to create a mini TDX HKID allocator that can be
>>> called when setting up a TD. This way it can have an exclusive HKID, as is
>>> required. This allocator will be used in future changes.
>> This is basically what Dave was asking for, isn't it?
> This patch has the allocator in KVM code, and the keyid ranges exported from
> arch/x86. Per the discussion with Dave we will export the allocator functions
> and keep the keyid ranges in arch/x86 code.

Yes, I meant this is the code and it just has to be moved to arch/x86. 
The only other function that is needed is a wrapper for ida_is_empty(), 
which is used in tdx_offline_cpu():

         /* No TD is running.  Allow any cpu to be offline. */
         if (ida_is_empty(&tdx_guest_keyid_pool))
                 return 0;

Paolo


