Return-Path: <kvm+bounces-37144-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id DC259A26210
	for <lists+kvm@lfdr.de>; Mon,  3 Feb 2025 19:16:08 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 5E4D4166FEA
	for <lists+kvm@lfdr.de>; Mon,  3 Feb 2025 18:16:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1D37520E305;
	Mon,  3 Feb 2025 18:15:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="SMGmkK9Z"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A9766B667
	for <kvm@vger.kernel.org>; Mon,  3 Feb 2025 18:15:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738606526; cv=none; b=if/1RPVIsyX++/08Bd+qfiJ/ZHq44FQrdRY/1c68QmgYe7lsIP82I89Xp+Auk9P8ErZjacIAaz/r8QuUZukwU4RIm/PkEeIV0lYughDiIx3j0ABbyVu6sEytPD9ij5KCMB6RgnVafoa+Y44NhwdQHBepRCLOHzV1v96971jt5WM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738606526; c=relaxed/simple;
	bh=DjGzGdvg8lc3S8c3N5PX0BSx5HEtRnZZSFrDYdptq/g=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=b8z2bCnmuz0UjFhYkkMIToZ+R3tycR1xEqGfjMlwVcX560KTTtWiz0gfOG/r66QTH6hLH6Vg+kWRVDgky3G0hpYgD1gfP6iO9TdBe39+xN7+MQolohJA2vu+WbNOcNKaDIeydOcnxisIxB9a8ZUdmNzGYU+HbDUfrKijSbJKWRM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=SMGmkK9Z; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1738606523;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=ERF8dmEQGHJVHf4szwBA/PuACgIVSUu9BmSPbvt4GZc=;
	b=SMGmkK9ZUpSiHCRSGFzX/V+NcdojBO9n1m3zJrlUHASdtMB4seFKBWoGDCG1kG+se4/TfM
	ExVJV0zM/6pbjBE5y7ZmcrjOZ4Ab4XEkh5dSx4bVkVPYh9d2w8G6j+Xf5QtEJdNBUQ1a4g
	DcVR9mk4ucqgc0JAZezh4a8UzDxHyNM=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-496-z1EYG3TKOiGj76Zft6aFUg-1; Mon, 03 Feb 2025 13:15:20 -0500
X-MC-Unique: z1EYG3TKOiGj76Zft6aFUg-1
X-Mimecast-MFC-AGG-ID: z1EYG3TKOiGj76Zft6aFUg
Received: by mail-wr1-f71.google.com with SMTP id ffacd0b85a97d-385d52591d6so2009259f8f.1
        for <kvm@vger.kernel.org>; Mon, 03 Feb 2025 10:15:20 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1738606519; x=1739211319;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=ERF8dmEQGHJVHf4szwBA/PuACgIVSUu9BmSPbvt4GZc=;
        b=g2OCikK5jpE1NfkYiONyjjX8iwsQuhncQcuwbYc+xq+Ak9JVZ3pamc+1erceiWGxwE
         2RdW/x/rZwjy0gI9yISWziEbWliQBN5SGbiGcvYGm8AaeKE+IidHQfheGZi7+8Eye6w3
         w00U5q8oIwfj4cz/Oti51x026U66Mmm8Qw+p6FO6cVpGzCCsV3Ws5/eBUE0beLjyJyOh
         qyVSRSAbGKceXPjzafQItAf3lYAD9S2gToUEmcs/nQXAuhPF6dM1mPf/2k2l5c/jZCON
         kS3T5fDG9LvMfW5NevDlWS67vfnAIzY4yDPxO+AozwpnQxXZDFioiMR2khVqhFTeDYqT
         OtAQ==
X-Forwarded-Encrypted: i=1; AJvYcCVIA+oqnyEpndIt+gd64lwURLjcXc3aWHaFBJsQuE4ypDEoYFiK6QwYTbBEKumIN1NTSck=@vger.kernel.org
X-Gm-Message-State: AOJu0YzCDRSz5jRZ5JT2LUTd7xAxlk9criTmpLrOyXl3OtysgnhUcM6D
	5Ui+dVgGLqQK3pdDNuap08jVYgttyp9FWOxKK/6gpuF1op2UKLaXPx2tIhXINsM9mvalnO3WIFN
	q2bPQPm0E0V2jCj+qrOQb86fmAdM2INEUYlYEDMvxL8Uo2i1ucg==
X-Gm-Gg: ASbGncu/618jBUZR1XDzvxtmUpmIXdC+729HsiKxEBv+FoSkbvDZQ2XgFZy3Nc+/k78
	OeQ6lzaJ9QoltnuPhfQQTHOO+UqWBM5n0HXlZgP4Jojy5IeyFeg2wnoOoUx0dDu1Ii9IaPK55t9
	Wznc6ucB16KmDp8+iFzg746TLL1CevJWS066Bo+cx9ctGhAo7xlVaJeXFy+1TBWfgbVL8DbE1zJ
	0wUYWKJUqT7CG//y2SDMjutYt7AADCzc3EA5wEBcRGyx9+igeCT48Ke+4lYz5fX03iLqXV7HQQ8
	LSz2oA==
X-Received: by 2002:a05:6000:1fa6:b0:385:df17:2148 with SMTP id ffacd0b85a97d-38da53da590mr217217f8f.20.1738606518985;
        Mon, 03 Feb 2025 10:15:18 -0800 (PST)
X-Google-Smtp-Source: AGHT+IGVHivnAr77z1I6fHQzEsVljcDP6WfD456NiIpuInK14RTqPRFNYIiz1fCjtEa4ynUK3OSuJQ==
X-Received: by 2002:a05:6000:1fa6:b0:385:df17:2148 with SMTP id ffacd0b85a97d-38da53da590mr217201f8f.20.1738606518630;
        Mon, 03 Feb 2025 10:15:18 -0800 (PST)
Received: from [192.168.10.3] ([151.62.97.55])
        by smtp.googlemail.com with ESMTPSA id ffacd0b85a97d-38c5c0eccc3sm13658344f8f.18.2025.02.03.10.15.17
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 03 Feb 2025 10:15:17 -0800 (PST)
Message-ID: <5f2ce1a7-e62e-4f43-a033-7353aaaef763@redhat.com>
Date: Mon, 3 Feb 2025 19:15:16 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v7 51/52] i386/tdx: Validate phys_bits against host value
To: Xiaoyao Li <xiaoyao.li@intel.com>
Cc: =?UTF-8?Q?Daniel_P=2E_Berrang=C3=A9?= <berrange@redhat.com>,
 =?UTF-8?Q?Philippe_Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
 Igor Mammedov <imammedo@redhat.com>, Zhao Liu <zhao1.liu@intel.com>,
 "Michael S. Tsirkin" <mst@redhat.com>, Eric Blake <eblake@redhat.com>,
 Markus Armbruster <armbru@redhat.com>,
 Peter Maydell <peter.maydell@linaro.org>,
 Marcelo Tosatti <mtosatti@redhat.com>, Huacai Chen <chenhuacai@kernel.org>,
 Rick Edgecombe <rick.p.edgecombe@intel.com>,
 Francesco Lavra <francescolavra.fl@gmail.com>, qemu-devel@nongnu.org,
 kvm@vger.kernel.org
References: <20250124132048.3229049-1-xiaoyao.li@intel.com>
 <20250124132048.3229049-52-xiaoyao.li@intel.com>
 <CABgObfb5ruVO2sxLCbZobiaqX-3h9Q+UKOZnp_hhxfJA=T-OJA@mail.gmail.com>
 <774945ce-04e2-42d5-83fc-97ad08647101@intel.com>
From: Paolo Bonzini <pbonzini@redhat.com>
Content-Language: en-US
Autocrypt: addr=pbonzini@redhat.com; keydata=
 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
In-Reply-To: <774945ce-04e2-42d5-83fc-97ad08647101@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 2/2/25 15:39, Xiaoyao Li wrote:
> On 2/1/2025 2:27 AM, Paolo Bonzini wrote:
>> On Fri, Jan 24, 2025 at 2:40 PM Xiaoyao Li <xiaoyao.li@intel.com> wrote:
>>>
>>> For TDX guest, the phys_bits is not configurable and can only be
>>> host/native value.
>>>
>>> Validate phys_bits inside tdx_check_features().
>>
>> Hi Xiaoyao,
>>
>> to avoid
>>
>> qemu-kvm: TDX requires guest CPU physical bits (48) to match host CPU
>> physical bits (52)
>>
>> I need options like
>>
>> -cpu host,phys-bits=52,guest-phys-bits=52,host-phys-bits-limit=52,- 
>> kvm-asyncpf-int
>>
>> to start a TDX guest, is that intentional?
> 
> "-cpu host" should be sufficient and should not hit the error.
> 
> why did you get "guest CPU physical bits (48)"?

Nevermind - I got it from the RHEL machine types.  The fix (which does not have
to be included upstream, though I would not complain) is

diff --git a/target/i386/kvm/tdx.c b/target/i386/kvm/tdx.c
index e0ab41bcb7b..7aca8219405 100644
--- a/target/i386/kvm/tdx.c
+++ b/target/i386/kvm/tdx.c
@@ -444,6 +444,7 @@ static void tdx_cpu_instance_init(X86ConfidentialGuest *cg, CPUState *cpu)
      X86CPU *x86cpu = X86_CPU(cpu);
  
      object_property_set_bool(OBJECT(cpu), "pmu", false, &error_abort);
+    object_property_set_bool(OBJECT(cpu), "host-phys-bits-limit", 0, &error_abort);
  
      /* invtsc is fixed1 for TD guest */
      object_property_set_bool(OBJECT(cpu), "invtsc", true, &error_abort);

but it also needs the patch at
https://lore.kernel.org/qemu-devel/20250203114132.259155-1-pbonzini@redhat.com/T/.

With these two changes, QEMU accepts "-cpu host" just fine.

Paolo


