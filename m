Return-Path: <kvm+bounces-47721-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 53666AC42CA
	for <lists+kvm@lfdr.de>; Mon, 26 May 2025 18:12:38 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id BA8F23B97E7
	for <lists+kvm@lfdr.de>; Mon, 26 May 2025 16:12:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CBE03226D1A;
	Mon, 26 May 2025 16:12:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="KnsyQG16"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 63AE82110E
	for <kvm@vger.kernel.org>; Mon, 26 May 2025 16:12:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748275951; cv=none; b=eELyk5iJQAc/41N88J33bbfXYZjbkEBpfEqwGGVJgjGc6zisEIpKY+VCV1mafbJsH2Es3TPI+rxqUIOBZjARb4rIOKMyOiCaz+u9nyP7gVVsUgsAXlYD3gsBCzILdIx8GlnpDy1ZFZ4ywLHAQmWVr9+a2c/UmivUyIeXKCPfUsI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748275951; c=relaxed/simple;
	bh=GlhNQJ0x8kHPssgV37W4A6yEztB8Tyucxnj78Nmqd/w=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Ye4vodZzPD/i1KKCR5rHdq8H1gQ0Hl1SoNiJbJuJ1JEn2jk5wJQPGxmZPFVEzcpBy0Mig/+48ZfkA9Ka10PxQ04XHbi4KTF2rpyu8BhIVItBGoLPNIyfZOgaEcGIJYwcSvncYfF34nY0YmRgziKES108JmVuf7P0B5GxuyIzUsY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=KnsyQG16; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1748275948;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=SMfSof+ktGe44h/Yry05m8e6gpqdF+0MQ1BO8hsKn5w=;
	b=KnsyQG16OHlOzpER2F2wenH6FjIRovf/IFOHpd0mEOiXk8/kBxUAl+SYBoF00n3biWTPVq
	aT279NVA5+81+d4IXvmAf0tuCGUHHnY0XM5nKzh8BYgcaufJVZy9k3QKxYK3DNSO1NWsgd
	OBtooqeZ8CZjz4FYL8aJlCD5aL03u1M=
Received: from mail-ed1-f70.google.com (mail-ed1-f70.google.com
 [209.85.208.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-295-V9nWy-4RPwqocayxvWHlNw-1; Mon, 26 May 2025 12:12:26 -0400
X-MC-Unique: V9nWy-4RPwqocayxvWHlNw-1
X-Mimecast-MFC-AGG-ID: V9nWy-4RPwqocayxvWHlNw_1748275945
Received: by mail-ed1-f70.google.com with SMTP id 4fb4d7f45d1cf-6023b016d4fso2455748a12.3
        for <kvm@vger.kernel.org>; Mon, 26 May 2025 09:12:26 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1748275945; x=1748880745;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=SMfSof+ktGe44h/Yry05m8e6gpqdF+0MQ1BO8hsKn5w=;
        b=UYM0axab27pUTMUMgVRvg1ImfIVhTn+l1e7DRJ2fHvoO09fb4z2sumF1M9A3mb4URV
         6e3Rg0qbPHmcmRmMNbN48xVZ+GfCv+OuFsgBOzpyBPwXj6vuHAaGbDcG4VCojhUS9m5b
         RrZ6hxfWMXCTtlur673cTWen6V7zCEYcpeVqzII/EfREZptkl5XBJsZ68MUVBFx3D+tm
         A0ohwI/c6l8VRXVWjRjGEyIr6IfDpeH+W5DAM/4OGGSsnlyWvulTQwkDezM7F8lJqd0M
         2L8D8MlKiS33C7F2CwfoUX2Kefkt5Nj7k2ZuPUxhyM7l1bEvKT5yLWcuIenSjYedd9tk
         NEcA==
X-Forwarded-Encrypted: i=1; AJvYcCXPa6/vZrr9VzPmyJb/tZa4EFVsaAFguul8EuzF3dOEhAubF3ti4ZD/s+Dg7y2NMdZ1v18=@vger.kernel.org
X-Gm-Message-State: AOJu0YyG9ydEVb5UN+PrCYRnAEqvaLxOy9cfkSg9kj72IdSr34DUtnDq
	0Gux1LA4YupmZvhUD2ujVtZyLk8GIJd7+yW21MkvNY59diETF4D9CgXLLpS+lzpCqZoVHbzoFMZ
	EmG+WbZDNYCR+3W2+0O5CJOHyKsyBEpRWQPK2xOvpk3z6xBo6gweF1w==
X-Gm-Gg: ASbGncvqqfk6DdJBFGTNWpADh8Ag4oUTHVLycHJ04d6Tpv9ei6WFOfT1LhDPSh9vk3U
	6r2fLeoLdWMA2O5j0qdo8LlKKZHRfhirgdxhyhjDkInj0Ho4abOPk4o9jt4GfSuJgn+tMJBS6fV
	tNogc6zSa9P3iuPwQzgJbhahNpJXqwTOgqdAdYTpioKnHvAPRSswve73uPn+3UTe8Qs0Ul4FuA4
	s51FkZXaLcMfPtNIy568yaknYAuu8Wj1plcsDG/BlY6nVMoZH/hhVouCyOfxb7xhKv7IRwbcyLh
	jjc5gW/qEckZKF2p
X-Received: by 2002:a05:6402:13cf:b0:601:31e6:6983 with SMTP id 4fb4d7f45d1cf-602db4afef8mr6668114a12.29.1748275945326;
        Mon, 26 May 2025 09:12:25 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGX8xslheOCDpMwwmLJ1kqAn1eD3qkBKwcHIhqfCzPzl5x2QcmbLtdU1mfX0UavWl/oGtfeXg==
X-Received: by 2002:a05:6402:13cf:b0:601:31e6:6983 with SMTP id 4fb4d7f45d1cf-602db4afef8mr6668084a12.29.1748275945006;
        Mon, 26 May 2025 09:12:25 -0700 (PDT)
Received: from [192.168.182.123] ([151.95.46.79])
        by smtp.googlemail.com with ESMTPSA id 4fb4d7f45d1cf-6049d482cc7sm2021832a12.19.2025.05.26.09.12.23
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 26 May 2025 09:12:24 -0700 (PDT)
Message-ID: <e994b189-d155-44d0-ae7d-78e72f3ae0de@redhat.com>
Date: Mon, 26 May 2025 18:12:22 +0200
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v9 00/55] QEMU TDX support
To: Xiaoyao Li <xiaoyao.li@intel.com>,
 =?UTF-8?Q?Daniel_P=2E_Berrang=C3=A9?= <berrange@redhat.com>
Cc: "Michael S. Tsirkin" <mst@redhat.com>,
 Markus Armbruster <armbru@redhat.com>,
 Francesco Lavra <francescolavra.fl@gmail.com>,
 Marcelo Tosatti <mtosatti@redhat.com>, kvm@vger.kernel.org,
 qemu-devel@nongnu.org, =?UTF-8?Q?Philippe_Mathieu-Daud=C3=A9?=
 <philmd@linaro.org>, Zhao Liu <zhao1.liu@intel.com>,
 Rick Edgecombe <rick.p.edgecombe@intel.com>
References: <20250508150002.689633-1-xiaoyao.li@intel.com>
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
In-Reply-To: <20250508150002.689633-1-xiaoyao.li@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 5/8/25 16:59, Xiaoyao Li wrote:
> This is the v9 series of TDX QEMU enabling. The series is also available
> at github:
> https://github.com/intel-staging/qemu-tdx/tree/tdx-qemu-upstream-v9
> 
> Note, this series has a dependency on
> https://lore.kernel.org/qemu-devel/20241217123932.948789-1-xiaoyao.li@intel.com/
> 
> =============
> Changes in v9
> 
> Comparing to v8, no big change in v9.
> 
> V9 mainly collects Reviewed-by tags from Daniel and Zhao Liu (Thanks to
> their review!) and v9 does some small change according to the review
> feedback of them. Please see the individual patch for the detailed
> change history.

Queued, thanks for your patience - this was a huge effort.

I'll wait until the kernel side is picked up and then send the pull request.

Paolo


