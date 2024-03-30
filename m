Return-Path: <kvm+bounces-13156-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 7D8AF892D67
	for <lists+kvm@lfdr.de>; Sat, 30 Mar 2024 22:02:00 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id D8781B2182A
	for <lists+kvm@lfdr.de>; Sat, 30 Mar 2024 21:01:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 213984B5CD;
	Sat, 30 Mar 2024 21:01:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="exwnZ8KZ"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D095843ADA
	for <kvm@vger.kernel.org>; Sat, 30 Mar 2024 21:01:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711832506; cv=none; b=GC+a1j2DNqhys6llZw68pevOkGIxaAJD+byyY8rMNad12IibksAnCLMAvdAd7wPNOdcaOvDBpsnJsdwsZjNIunY/xwnCwC7LkaTQdf16CGLUIZaRw2Vy2JO0siHo6mL088BMF7qzbEu5MDMPsABNbJX7qaY5tunEMpcGD62zXk0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711832506; c=relaxed/simple;
	bh=+sVaxRP9koJKMlgsM79KsaeETdqLzifuShLZ62f6aLs=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=n7hd/apOCpvDDZdBSu0778OpnvChP39rejsRj+VEGp4isHDC41VpXw/Fbxg5XjvQApNA37ukuev2H/JZNo1Ifvs8vzSpATGghFBJsxi9YMCsqWsFNMHhgH6ZDt8mJ6jeefuoBiMF1Pz4mvVc9WmJ5HHquVPtjmf2hL6eBR2lX6k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=exwnZ8KZ; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1711832503;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=3aR1QfAUho179PK9ExgLrz9xfYuI8M+7PWwcDQKY80w=;
	b=exwnZ8KZxPHLtReqseT5rRA3hHVb+ogXdRR0CTb/vI0ykKP/Yt/1wHyyb0CkGfbELj1WWz
	ybkApI6qfuNil23YsQAyNhLdHwJBbY2sEnCcrJa6WMm7Lky3dLSDLJJwwsILykyJJE3ouF
	JeifG7EfOvthaZHSqlPIaj0SUHYOO+0=
Received: from mail-ej1-f69.google.com (mail-ej1-f69.google.com
 [209.85.218.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-140-hF_JVh-rOGWwbLxqs-a86A-1; Sat, 30 Mar 2024 17:01:42 -0400
X-MC-Unique: hF_JVh-rOGWwbLxqs-a86A-1
Received: by mail-ej1-f69.google.com with SMTP id a640c23a62f3a-a46bae02169so343857466b.1
        for <kvm@vger.kernel.org>; Sat, 30 Mar 2024 14:01:41 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1711832499; x=1712437299;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=3aR1QfAUho179PK9ExgLrz9xfYuI8M+7PWwcDQKY80w=;
        b=di+woCwYhafQXrkdDsB00EyGfYk408npmlJ2D2iZyl7qiR5AnmRw1eJOulKRfp05AO
         PWRgX5i7+l/yqlnEB+MRrenzh+kyijoVZeyrl6+TCgyFitCmSnt9OfaIxDRiMwiTBquM
         pedJmc250c6FUCvMfMxQumCdwbKUDyShylP1FY8i/ycYS5kns70ak5zhXYlPYbUNJMit
         T0zsvTc+iyZwLCdYglrREX4NcZPMwabqJguWyYuw36QVW9pt5WXBL/1UDXeTSGJoRu+B
         GDrtBMUoWL+IQCuVidHRyk8lr6dG8qt2hH+PFwKyoz7sL4tqKlqrtZqFOk8j5olOxbFg
         UoJQ==
X-Forwarded-Encrypted: i=1; AJvYcCX+Y5gTdu9tQabjc8OBV2BuRPWzQ1mBw6v6OaJCxiAMLqX5WTQkc/NwF4WcMVStDwHYpxq2LoC5sMqU//dANj4ZWn7v
X-Gm-Message-State: AOJu0YxIAf26qtXtkIjMaYc7DAvpAeE6NZnEvp0D8XAQK7f7DVrddvl1
	zAKJKCW50Hbs7PU/diCQhOY//WwgK/jcp8iktY3+oEziDexC4yOYTifJU1oZ/fke6kwe3130bG5
	cxERYWlqzZnAGW6ROc69OF0kZLU4AppW1DuXvO+2XWseRW4iSdKsrOVg/Bg==
X-Received: by 2002:a17:906:ca57:b0:a46:852e:2a63 with SMTP id jx23-20020a170906ca5700b00a46852e2a63mr4759116ejb.29.1711832499444;
        Sat, 30 Mar 2024 14:01:39 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGjYcQ/p/ZWPvUybSYRA9ioGIQldmtvB4OHml9EDdOMi31JHX8p4fWJUmWvRXNJIZ92pNVhYw==
X-Received: by 2002:a17:906:ca57:b0:a46:852e:2a63 with SMTP id jx23-20020a170906ca5700b00a46852e2a63mr4759076ejb.29.1711832499005;
        Sat, 30 Mar 2024 14:01:39 -0700 (PDT)
Received: from [192.168.10.4] ([151.95.49.219])
        by smtp.googlemail.com with ESMTPSA id ef14-20020a17090697ce00b00a4e44f724e8sm1398812ejb.186.2024.03.30.14.01.36
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 30 Mar 2024 14:01:38 -0700 (PDT)
Message-ID: <67685ec7-ca61-43f1-8ecd-120ec137e93a@redhat.com>
Date: Sat, 30 Mar 2024 22:01:35 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v12 18/29] KVM: SEV: Use a VMSA physical address variable
 for populating VMCB
To: Michael Roth <michael.roth@amd.com>, kvm@vger.kernel.org
Cc: linux-coco@lists.linux.dev, linux-mm@kvack.org,
 linux-crypto@vger.kernel.org, x86@kernel.org, linux-kernel@vger.kernel.org,
 tglx@linutronix.de, mingo@redhat.com, jroedel@suse.de,
 thomas.lendacky@amd.com, hpa@zytor.com, ardb@kernel.org, seanjc@google.com,
 vkuznets@redhat.com, jmattson@google.com, luto@kernel.org,
 dave.hansen@linux.intel.com, slp@redhat.com, pgonda@google.com,
 peterz@infradead.org, srinivas.pandruvada@linux.intel.com,
 rientjes@google.com, dovmurik@linux.ibm.com, tobin@ibm.com, bp@alien8.de,
 vbabka@suse.cz, kirill@shutemov.name, ak@linux.intel.com,
 tony.luck@intel.com, sathyanarayanan.kuppuswamy@linux.intel.com,
 alpergun@google.com, jarkko@kernel.org, ashish.kalra@amd.com,
 nikunj.dadhania@amd.com, pankaj.gupta@amd.com, liam.merwick@oracle.com
References: <20240329225835.400662-1-michael.roth@amd.com>
 <20240329225835.400662-19-michael.roth@amd.com>
From: Paolo Bonzini <pbonzini@redhat.com>
Content-Language: en-US
Autocrypt: addr=pbonzini@redhat.com; keydata=
 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
In-Reply-To: <20240329225835.400662-19-michael.roth@amd.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 3/29/24 23:58, Michael Roth wrote:
> From: Tom Lendacky<thomas.lendacky@amd.com>
> 
> In preparation to support SEV-SNP AP Creation, use a variable that holds
> the VMSA physical address rather than converting the virtual address.
> This will allow SEV-SNP AP Creation to set the new physical address that
> will be used should the vCPU reset path be taken.
> 
> Signed-off-by: Tom Lendacky<thomas.lendacky@amd.com>
> Signed-off-by: Ashish Kalra<ashish.kalra@amd.com>
> Signed-off-by: Michael Roth<michael.roth@amd.com>
> ---

I'll get back to this one after Easter, but it looks like Sean had some 
objections at https://lore.kernel.org/lkml/ZeCqnq7dLcJI41O9@google.com/.

Paolo


