Return-Path: <kvm+bounces-64530-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id C8C1CC86393
	for <lists+kvm@lfdr.de>; Tue, 25 Nov 2025 18:34:15 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 81D443A6305
	for <lists+kvm@lfdr.de>; Tue, 25 Nov 2025 17:34:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 04911325728;
	Tue, 25 Nov 2025 17:34:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="JiOjAoNs";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="Wgimi4We"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 484823C38
	for <kvm@vger.kernel.org>; Tue, 25 Nov 2025 17:34:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764092049; cv=none; b=DtuPCEu/vp0VxCthObuZeiqW/Y/5cNnPwa8NgoYphgWp1rvf15u+FBZTx4R9VXJAYHuyk8qO+LPbGOPXIaGHLhhe40z3IscHff+8OcE0GwroefxcImrUSck5jDE0MkOU78/1pZwu1D8jIiUpr7yMS9PAPnWjgLzuRm/MiO5Qpx0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764092049; c=relaxed/simple;
	bh=Mk8dcs2rO/7Hvn+RAgfWE/SIDQ/R5dLIZx0Qlqe8aU8=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=m5bJuJVlozYGUiAC4oFXUTd0N+wy6knbZdKS+sJI+gmZnJo5TVs5sdsq/bd2cfPORIYzkltmyecJilFrVlxMWNfze6fsVqsMSvNfI0aQA5u941X7z7hu8KLQUrNKczAF4ThfTJfJpLTWIwTe5Di1BcJOmCkEKDczKY1o4DELpfo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=JiOjAoNs; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=Wgimi4We; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1764092046;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=UZcUjHGSx1Ld52Ks3CAtCK29QHcQY1zgka3na3wCtxc=;
	b=JiOjAoNsi1WlZ2WS6ngX6t1OquOkPJNHApO2KC1TijNeVy5GM+AxbaM6eDER8/5kWTEduU
	Dp4DseQOxgdIrRy3Wuhdo3v8MznNv2NgCGc+s3SM1j7juPd+fuwFLI11FGMGzstLiCT6ys
	GURzwW3lWtb+EBU0HnSi8fm4Xb0Cy9E=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-314-uJKJV8AUOtOEbGUREvmLSw-1; Tue, 25 Nov 2025 12:34:04 -0500
X-MC-Unique: uJKJV8AUOtOEbGUREvmLSw-1
X-Mimecast-MFC-AGG-ID: uJKJV8AUOtOEbGUREvmLSw_1764092043
Received: by mail-wm1-f71.google.com with SMTP id 5b1f17b1804b1-47777158a85so75713955e9.3
        for <kvm@vger.kernel.org>; Tue, 25 Nov 2025 09:34:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1764092042; x=1764696842; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=UZcUjHGSx1Ld52Ks3CAtCK29QHcQY1zgka3na3wCtxc=;
        b=Wgimi4WemL9iGBna1bKieHea7r4byTgjZ9DJBaqzuf0+93C54mNkiOeAllz7C/5MkQ
         /EevMitlTxt8GywQWroKalGVh41d0pTRH9HacwsWV9FEkZmYaDxEhgv1NcASK6ovU9sf
         Cbe7sDnkRqrq8W/eE0/8kvyQb5R8C4oYqBvQfEBGfGjF3t7NnbIYAqXvXxtz0hqskFw0
         9RXf3FLDssPkL0DDiOrNegACpoC1RbH3xXfqOi6FszAmd8qUO06NKbGc23I4ftnn837s
         V9wJu0JHyhKgXD7vcps6QZ/Bll+VkGttbk3Q+lOqoUMqMLrLFUTjAh2z48BGM+WJVhCc
         4qtg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764092042; x=1764696842;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=UZcUjHGSx1Ld52Ks3CAtCK29QHcQY1zgka3na3wCtxc=;
        b=rWjbe8UXGJ/6+GKvgrRihq432JBNHftSKUIKBKk0AZUlQRjXJUKki1orf4E18eQzXU
         FMFQ/NM4QJs1QTcQX+YfLqux0qYzuaICIZQBh9rT3ZWGfcvNFI7RO0JG0Q191URBhomF
         +s8ePIJfKW5pgb31wwe74HS8nRWPn9EGZ1ft/v2ACBbrrNj244rgHRCP1kOpgzK8OTmV
         VUgih199ddX2BanXt31Ox+6Eqq0e/xbIRKhLH+lVEEzM/2sgcpS+yN4cigADQdBwYbQU
         tjWlQp9m602A8RSSAov+CRE3glMKdHn462Tj8WhldCrf2ObC9QzYbxTunsYXAOdso1UG
         Osag==
X-Gm-Message-State: AOJu0YwVz4HrS/jW2FwKEKWBmRr/0SST6XRTY0y3TGO4Reex+1JA5Xnh
	jDmZBWQAwvruEq2b7wOa8vwqtvnmjLl4eqa9LLrbMXCMxSfPJBAG3zMo8240OQYtY0ITW3ZbHgo
	fQclwJ0Bv6jBw7t/pxFe/9xBLsBDKX0QVO8iDlhxaroscF9bobfFzDTFdygzp6A==
X-Gm-Gg: ASbGncvwBMGOIizL9+lRhFq7slZJRqiHNYpHWq8lycv6vcbcpcPBEN6CY86ZYSvJM+C
	uLx8mRfbCvcX4VZ9crDJgZA+FBXYe6kQR/OAs6JA1dNDDgmQxC/tQm56pzsMIHj+FVwKwwy8ONo
	6vxUDJqPqJuKVkONy5PIESV2DFKj5B1jFCxVWAp1oAFZgU8GJqScwei8CWmloOEjcEepwZ4lYzB
	EUgtskQwZF4xiSJz8rBmIQzc8HAhyJnN1jJUVc7+c7+KOfSbgIZvUJ4E99XSIfsyu1hY7wJsJON
	Hg/85t1gQMrwOZwRFDRIbtCxvF+q23mz4C6teyGLvdxpMvQ4dDHfJRJ3fWzQvymhcZZyMX8M6ir
	m+yZtLjTNMkFdc18hEvnzNrJ1nOnpIOtyABPbtprWBpT/4E5ndMtYnhOTDhQ2hQ3o7mQNMMiqW/
	MO
X-Received: by 2002:a05:600c:3592:b0:477:9b35:3e36 with SMTP id 5b1f17b1804b1-477c10c873amr181378585e9.2.1764092042625;
        Tue, 25 Nov 2025 09:34:02 -0800 (PST)
X-Google-Smtp-Source: AGHT+IFrXqhW0Hh9JDnQLGZ6KPO82kIbd4d+FXSWpjY1trKQQNtbjziknNjQwBhbEmfAkESb2bxO/g==
X-Received: by 2002:a05:600c:3592:b0:477:9b35:3e36 with SMTP id 5b1f17b1804b1-477c10c873amr181378375e9.2.1764092042204;
        Tue, 25 Nov 2025 09:34:02 -0800 (PST)
Received: from [192.168.10.81] ([176.206.119.13])
        by smtp.googlemail.com with ESMTPSA id 5b1f17b1804b1-4790adc601dsm620475e9.1.2025.11.25.09.34.00
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 25 Nov 2025 09:34:01 -0800 (PST)
Message-ID: <6221d5d6-6699-4bcd-9d35-a29829129f04@redhat.com>
Date: Tue, 25 Nov 2025 18:33:59 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [kvm-unit-tests PATCH v2 00/11] x86: xsave: Cleanups and AVX
 testing
To: Sean Christopherson <seanjc@google.com>
Cc: kvm@vger.kernel.org
References: <20251121180901.271486-1-seanjc@google.com>
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
In-Reply-To: <20251121180901.271486-1-seanjc@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 11/21/25 19:08, Sean Christopherson wrote:
> A "slightly" beefed up version of Paolo's patch to validate KVM's recently
> added AVX VMOVDQA emulation.
> 
> v1: https://lore.kernel.org/all/20251114003228.60592-1-pbonzini@redhat.com
> 
> Paolo Bonzini (1):
>    x86: xsave: Add testcase for emulation of AVX instructions
> 
> Sean Christopherson (10):
>    x86: xsave: Replace spaces with tabs
>    x86: xsave: Drop unnecessary and confusing uint64_t overrides
>    x64: xsave: Use non-safe write_cr4() when toggling OSXSAVE
>    x86: xsave: Add and use dedicated XCR0 read/write helpers
>    x86: xsave: Dedup XGETBV and XSETBV #UD tests
>    x86: xsave: Programmatically test more unsupported XCR accesses
>    x86: xsave: Define XFEATURE_MASK_<feature> bits in processor.h
>    x86: xsave: Always verify XCR0 is actually written
>    x86: xsave: Drop remaining indentation quirks and printf markers
>    x86: xsave: Verify XSETBV and XGETBV ignore RCX[63:32]
> 
>   lib/x86/processor.h |  62 ++++++++++
>   x86/xsave.c         | 270 +++++++++++++++++++++++++++++---------------
>   2 files changed, 239 insertions(+), 93 deletions(-)
> 
> 
> base-commit: f561b31d3dee01f8be58978be23bb0903543153d

Applied, thanks.

Paolo


