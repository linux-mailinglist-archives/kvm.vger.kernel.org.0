Return-Path: <kvm+bounces-40072-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id E012CA4EBE4
	for <lists+kvm@lfdr.de>; Tue,  4 Mar 2025 19:37:40 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 72A7F18857FF
	for <lists+kvm@lfdr.de>; Tue,  4 Mar 2025 18:33:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 77F682054E0;
	Tue,  4 Mar 2025 18:24:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="fryNdUH8"
X-Original-To: kvm@vger.kernel.org
Received: from beeline3.cc.itu.edu.tr (beeline3.cc.itu.edu.tr [160.75.25.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E3DED1EDA1F
	for <kvm@vger.kernel.org>; Tue,  4 Mar 2025 18:24:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=160.75.25.117
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741112680; cv=pass; b=OSUu2SFpEbwGNqeqFqpt2JMlBgDuyC9ibWbCG/SA/odEqkMPyeNueTRLNJY6YhdM0BXIHr8ERfi9Fe051QlQAbNSC/2YJ5dOlBJBe24J+Cjf0XU3nu7kWXhs81d1/YXGCIesaGY50ryom13zAzeWviN8Um/GcFndo6x2c38GXWA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741112680; c=relaxed/simple;
	bh=/ej80E7fEmOiXCG0edfmWSRHo8xkFIG8fEhkazypN4E=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=gXKKRveh3w2OJmxkQ37DucKr9+bRiNYrUFUbfUoAAgUs1lzP05fDHqt5UoJDcoSPO2HkJSRNlvuKtBJaAGhhFA2GaMp0Rx34JW9MIn8JUng73L+Ow9kz052ej2iNk4YfAmtWpH9N3hrBP6gA4n/CFhBCz5z5eIwKI4JRZXjYoPo=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=none smtp.mailfrom=cc.itu.edu.tr; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=fryNdUH8; arc=none smtp.client-ip=170.10.129.124; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; arc=pass smtp.client-ip=160.75.25.117
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=cc.itu.edu.tr
Received: from lesvatest1.cc.itu.edu.tr (lesvatest1.cc.itu.edu.tr [10.146.128.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-256) server-signature RSA-PSS (2048 bits))
	(No client certificate requested)
	by beeline3.cc.itu.edu.tr (Postfix) with ESMTPS id 637AF40CECAB
	for <kvm@vger.kernel.org>; Tue,  4 Mar 2025 21:24:37 +0300 (+03)
X-Envelope-From: <root@cc.itu.edu.tr>
Received: from lesva1.cc.itu.edu.tr (unknown [160.75.70.79])
	by lesvatest1.cc.itu.edu.tr (Postfix) with ESMTP id 4Z6h8b0CfxzG3JZ
	for <kvm@vger.kernel.org>; Tue,  4 Mar 2025 19:34:07 +0300 (+03)
Received: by le1 (Postfix, from userid 0)
	id DF3BC42734; Tue,  4 Mar 2025 19:33:56 +0300 (+03)
Authentication-Results: lesva1.cc.itu.edu.tr;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=fryNdUH8
X-Envelope-From: <linux-kernel+bounces-541363-bozkiru=itu.edu.tr@vger.kernel.org>
Authentication-Results: lesva2.cc.itu.edu.tr;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=fryNdUH8
Received: from fgw1.itu.edu.tr (fgw1.itu.edu.tr [160.75.25.103])
	by le2 (Postfix) with ESMTP id DDAC942E54
	for <bozkiru@itu.edu.tr>; Mon,  3 Mar 2025 13:25:39 +0300 (+03)
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by fgw1.itu.edu.tr (Postfix) with SMTP id 93DEC3064C07
	for <bozkiru@itu.edu.tr>; Mon,  3 Mar 2025 13:25:39 +0300 (+03)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id DE564166C09
	for <bozkiru@itu.edu.tr>; Mon,  3 Mar 2025 10:25:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 662791F239B;
	Mon,  3 Mar 2025 10:25:25 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DFBD31F1525
	for <linux-kernel@vger.kernel.org>; Mon,  3 Mar 2025 10:25:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740997521; cv=none; b=HOd5LRhlbeI4P7M8ZNcXhtdsZo54JmnWJT56TLDL57SQl534X1MGJ3m1G1b1l7hJIMuk29lr/ZKFW4pEyMvIPAABfA/9B2xFd5GQ10kffUU/mfApt5jA+QID/R6q5JxweEfoRpD41URRFWAdJfO6JKrg3ImEi89vbewg3gcbc+M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740997521; c=relaxed/simple;
	bh=/ej80E7fEmOiXCG0edfmWSRHo8xkFIG8fEhkazypN4E=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=P8pv/fTppW9eXUMbVxKfkXusddelx47NwX0JWSH4EaS8TosmDtA6lB9rHV4+LxLIybqt6j7s1Wb1BLzv31KeZNggIlyl8LZWZcz1N3GUVwRA05MC3YQkm4WQwMtYz+gV06EdIo3G2Rt6KQYIuRx5UUzAk/dTz0ho2vLm4oCSj+Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=fryNdUH8; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1740997518;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=TrKzv35DZjV35KvtzHUKUqHwEc+skHulVpKIiaH0xSg=;
	b=fryNdUH8PgPcWZnwQM2S12KeWLrTpYjF9dTA6dLy6qYUbirtGdAghgHG2rWbCdIww0uijg
	oYo6aJpbPXftaK61+BsgLfuVEPX9l8qxSOQiZ3ocj68ny+OpnMYt+YSh7rso1EdcPrV9Cb
	iUEIFGRNNUW3lIFng+3adTkHHzve7Zc=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-645-x6K6jIRAON-juSXDpbQIBA-1; Mon, 03 Mar 2025 05:25:12 -0500
X-MC-Unique: x6K6jIRAON-juSXDpbQIBA-1
X-Mimecast-MFC-AGG-ID: x6K6jIRAON-juSXDpbQIBA_1740997511
Received: by mail-wr1-f72.google.com with SMTP id ffacd0b85a97d-390f11e6fdbso1149322f8f.0
        for <linux-kernel@vger.kernel.org>; Mon, 03 Mar 2025 02:25:12 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1740997511; x=1741602311;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=TrKzv35DZjV35KvtzHUKUqHwEc+skHulVpKIiaH0xSg=;
        b=LbMIphSS2+EbrAkxbbufGCy7yvbzK0dWXQ90txxc11YK4tX7iChjBEuKce0Fn3eh9/
         85mqIHch9pQ5YrvJWdDkzDHxZGR4czwecG4s6NTBhbspZCM2km0irM6UAcn5SBqMO5qO
         Hafolwc5FRAScmpfBVyIBD7YInmF+lECmynCu39B6pp8MZLo8KeH4UX7+1YPx3G9UD7o
         Ig6VYNTZDP+bP7Zw2uPC0z0FRZ0sWGqacZzm0Wj+UezAU8nRbcQrI8EyFFQKMYfsmo0R
         MiSNNoOWojmFp/S08vjJCsnx1Wy6wmS7D3y01K7PC8dtmHBF6hnEE4yi61T9IFx7xk5d
         dgzg==
X-Forwarded-Encrypted: i=1; AJvYcCWLtTqSdCWII71CRUBvUM9zBMbqX0y9ewz4axZ8qI7qYptXP4oHKamB8xhUbkoexQ3u4XDueWlDTWvccf8=@vger.kernel.org
X-Gm-Message-State: AOJu0YzFCqVIQLgnkui90WjwvGgpRlNJzyBU3hvdEDQzytdJ9qTpjPLl
	zHsq+624rtFaGhEfEc2comCtpUoSHHgA7Oy3qOW6llIS1pObL2wHP7VPh3LI83s45c4kYOXz4kG
	b+aAVhk4wPz4CfRsRv9K0w0J3jyEOy8ISk3zf8xHMwoy6LKtYZnDdtOhDbsJerg==
X-Gm-Gg: ASbGncvK3XKeHhQbsGHTcldLgY+wtN1ktBXhEY5pGrBjZfHZxV7rOF0JbxxcMatyjtW
	Dtzj7mdQkp7LQ4G06FzyuUM1e2gk9NbzOErWQwLEdW8HF3FXs94luRIF07c5axG9ocYbBu34s7G
	YH7g25TdnYATFh63h0E3C/CVqDpmStna9Oh061IFbmThsFmHENkByL+oyGXL81/FnwpLbXUaivh
	3x6KgerCip6Ei4Om8Zg+WZ/IsPy7fAcZwmwxVcu80LhebU+da88x3PR8PJ1sQKIknHO6+DuS1I9
	91JBVcBUDtHG2nqPZSM=
X-Received: by 2002:a5d:5f81:0:b0:390:f607:9656 with SMTP id ffacd0b85a97d-390f60796f9mr8129017f8f.34.1740997511098;
        Mon, 03 Mar 2025 02:25:11 -0800 (PST)
X-Google-Smtp-Source: AGHT+IG8JPrmyld9of7zduHKshilPng6cArXdQbF0Bz4Ey1KeSVNMKTj1pzN69el5Z/nX9jXjAwrfA==
X-Received: by 2002:a5d:5f81:0:b0:390:f607:9656 with SMTP id ffacd0b85a97d-390f60796f9mr8128994f8f.34.1740997510738;
        Mon, 03 Mar 2025 02:25:10 -0800 (PST)
Received: from [192.168.10.48] ([151.95.119.44])
        by smtp.googlemail.com with ESMTPSA id ffacd0b85a97d-390e4796517sm13839957f8f.5.2025.03.03.02.25.09
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 03 Mar 2025 02:25:10 -0800 (PST)
Message-ID: <1e077351-6fc4-4106-b4fe-a36b8be75233@redhat.com>
Date: Mon, 3 Mar 2025 11:25:08 +0100
Precedence: bulk
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 0/3] KVM: x86: Introduce quirk
 KVM_X86_QUIRK_EPT_IGNORE_GUEST_PAT
To: Yan Zhao <yan.y.zhao@intel.com>
Cc: seanjc@google.com, rick.p.edgecombe@intel.com, kevin.tian@intel.com,
 linux-kernel@vger.kernel.org, kvm@vger.kernel.org
References: <20250224070716.31360-1-yan.y.zhao@intel.com>
 <ecbc1c50-fad2-4346-a440-10fbc328162b@redhat.com>
 <Z8UBpC76CyxCIRiU@yzhao56-desk.sh.intel.com>
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
In-Reply-To: <Z8UBpC76CyxCIRiU@yzhao56-desk.sh.intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ITU-Libra-ESVA-Information: Please contact Istanbul Teknik Universitesi for more information
X-ITU-Libra-ESVA-ID: 4Z6h8b0CfxzG3JZ
X-ITU-Libra-ESVA: No virus found
X-ITU-Libra-ESVA-From: root@cc.itu.edu.tr
X-ITU-Libra-ESVA-Watermark: 1741717362.7247@h3V0KmH9bFs2NKrjbaXEVw
X-ITU-MailScanner-SpamCheck: not spam

On 3/3/25 02:11, Yan Zhao wrote:
>> the main issue with this series is that the quirk is not disabled only for
>> TDX VMs, but for *all* VMs if TDX is available.
> Yes, once TDX is enabled, the quirk is disabled for all VMs.
> My thought is that on TDX as a new platform, users have the option to update
> guest software to address bugs caused by incorrect guest PAT settings.
> 
> If you think it's a must to support old unmodifiable non-TDX VMs on TDX
> platforms, then it's indeed an issue of this series.

Yeah, unfortunately I think we need to keep the quirk for old VMs.  But 
I think the code changes needed to do so are small and good to have anyway.

>> There are two concepts here:
>>
>> - which quirks can be disabled
>>
>> - which quirks are active
>>
>> I agree with making the first vendor-dependent, but for a different reason:
>> the new KVM_X86_QUIRK_EPT_IGNORE_GUEST_PAT must be hidden if self-snoop is
>> not present.
>
> I think it's a good idea to make KVM_X86_QUIRK_EPT_IGNORE_GUEST_PAT out of
> KVM_CAP_DISABLE_QUIRKS2, so that the quirk is always enabled when self-snoop is
> not present as userspace has no way to disable this quirk.
> 
> However, this seems to contradict your point below, especially since it is even
> present on AMD platforms.
> 
> "we need to expose the quirk anyway in KVM_CAP_DISABLE_QUIRKS2, so that
> userspace knows that KVM is *aware* of a particular issue",  "even if disabling
> it has no effect, userspace may want to know that it can rely on the problematic
> behavior not being present".

There are four cases:

* quirk cannot be disabled: example, "ignore guest PAT" on 
non-self-snoop machines: the quirk must not be in KVM_CAP_DISABLE_QUIRKS2

* quirk can be disabled: the quirk must be in KVM_CAP_DISABLE_QUIRKS2

* quirk is always disabled: right now we're always exposing those in 
KVM_CAP_DISABLE_QUIRKS2, so we should keep that behavior.  If desired we 
could add a capability like KVM_CAP_DISABLED_QUIRKS

* for some VMs, quirk is always disabled: this is the case also for the 
zap_all quirk that you have previously introduced.  Right now there's no 
way to query it, but KVM_CAP_DISABLED_QUIRKS would also cover this.  If 
KVM_CAP_DISABLED_QUIRKS was introduced, zap_all could be added too.

> So, could we also expose KVM_X86_QUIRK_EPT_IGNORE_GUEST_PAT in
> KVM_CAP_DISABLE_QUIRKS2 on Intel platforms without self-snoop, but ensure that
> disabling the quirk has no effect?

To keep the API clear, disabling the quirk should *always* have the 
effect of going to the non-quirky behavior.  Which may be no effect at 
all if the non-quirky behavior is the only one---but the important thing 
is that you don't want the quirky/buggy/non-architectural behavior after 
a successful KVM_ENABLE_CAP(KVM_CAP_DISABLE_QUIRKS2).

There is a pre-existing bug in that I think 
KVM_ENABLE_CAP(KVM_CAP_DISABLE_QUIRKS2) should be cumulative, i.e. 
should not allow re-enabling a previously-disabled quirk.  I think we 
can change that without worrying about breaking userspace there, as the 
current behavior is the most surprising.

>> As to the second, we already have an example of a quirk that is also active,
>> though we don't represent that in kvm->arch.disabled_quirks: that's
>> KVM_X86_QUIRK_CD_NW_CLEARED which is for AMD only and is effectively always
>> disabled on Intel platforms.  For those cases, we need to expose the quirk
> I also have a concern about this one. Please find my comments in v2.

Ok, I'll reply there too.

>> anyway in KVM_CAP_DISABLE_QUIRKS2, so that userspace knows that KVM is
>> *aware* of a particular issue.  In other words, even if disabling it has no
>> effect, userspace may want to know that it can rely on the problematic
>> behavior not being present.
>>
>> I'm testing an alternative series and will post it shortly.
>   
> Thanks a lot for helping with refining the patches!

Thanks to you and sorry that the patches weren't of the best quality - I 
mostly wanted to start the discussion on the userspace API side before 
the beginning of the week in your time zone.

Paolo



