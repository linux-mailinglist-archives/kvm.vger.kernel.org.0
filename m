Return-Path: <kvm+bounces-4375-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 6E680811B47
	for <lists+kvm@lfdr.de>; Wed, 13 Dec 2023 18:36:03 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id DE5E9B20D6E
	for <lists+kvm@lfdr.de>; Wed, 13 Dec 2023 17:36:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7DADD56B7C;
	Wed, 13 Dec 2023 17:35:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="KAbtQHOv"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 39BDFB0
	for <kvm@vger.kernel.org>; Wed, 13 Dec 2023 09:35:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1702488945;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=ZI5vco6PWgJtc3JoTVRWQROHjU+p2avOcErV9v922iw=;
	b=KAbtQHOvL7VHny3fCsFUhi8bM+1UUN/pJHLFF3AH2Y/aQaN/H7X1oM/Y7m8qEWdxild3HW
	zsBADTzc3T4y+CHQYEX7DJu3U2RSYLVN1VMKIrq9bQ14vY4bPfHtDLa0hGo3t7u2q/w3gm
	Sdfj2cnXHAZc++te/rHQ3q6ezUtFI2k=
Received: from mail-lf1-f69.google.com (mail-lf1-f69.google.com
 [209.85.167.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-310-LdJavq2NOtefYqmIo67hTw-1; Wed, 13 Dec 2023 12:35:43 -0500
X-MC-Unique: LdJavq2NOtefYqmIo67hTw-1
Received: by mail-lf1-f69.google.com with SMTP id 2adb3069b0e04-50c1e669bf2so6440961e87.1
        for <kvm@vger.kernel.org>; Wed, 13 Dec 2023 09:35:43 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1702488942; x=1703093742;
        h=content-transfer-encoding:in-reply-to:autocrypt:from:references:cc
         :to:content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ZI5vco6PWgJtc3JoTVRWQROHjU+p2avOcErV9v922iw=;
        b=MRPZeZLNwYIDanvMXiJwRW5BmYIRQo5opclSGVsJo6p7kkNLbMiQ6ZXNXg4O0Q+Xti
         3w29kju+HoXegF6BU6NnHs0WYuvJA4uoN079FdeEbAOGzn1p5p/baWl4/hXxd5sEH+fR
         znjpOpIJcXhROBkrl91xXw8igNN2sqLlQB57cY0c6GdkqfxH2dCaY/jJXhVzsX+uv+dZ
         rQJFeXrL5/cxO8HHiOE6fkgpcjqGdBOCifnS7NLK3+FXAqPNAEkeVNgMniS5kBDQOj4x
         yNsOKYsLIzdOmC4ybr0cggOfnlEyODKQ6Om6lxf0MBRYJkuivkrsq0YBL4Yp08fdr/Rc
         MrHQ==
X-Gm-Message-State: AOJu0Yw/ad8y24xcdgkXz5y4Cltp1zH7pw5N8++3x6lu7lkPA+auvM2N
	BU9qyLsiRzL6am++/amHa26bgUVnRsECmiyzwC5Spvo1hI99I158g3vw2ipi3vap4sZ1z2HD/pq
	l0GC2Y46xxHVQ
X-Received: by 2002:a05:6512:2385:b0:50b:f509:a2d3 with SMTP id c5-20020a056512238500b0050bf509a2d3mr5654289lfv.43.1702488942412;
        Wed, 13 Dec 2023 09:35:42 -0800 (PST)
X-Google-Smtp-Source: AGHT+IGfk8baDYcfEvOfdRyazgNm5STYlR8fJYNeGgxe6yeh3SUZzGnCwld8+CCbn45sJYfQ28B4Ew==
X-Received: by 2002:a05:6512:2385:b0:50b:f509:a2d3 with SMTP id c5-20020a056512238500b0050bf509a2d3mr5654258lfv.43.1702488942051;
        Wed, 13 Dec 2023 09:35:42 -0800 (PST)
Received: from ?IPV6:2001:b07:6468:f312:63a7:c72e:ea0e:6045? ([2001:b07:6468:f312:63a7:c72e:ea0e:6045])
        by smtp.googlemail.com with ESMTPSA id vs4-20020a170907a58400b00a22fb8901c4sm1312645ejc.12.2023.12.13.09.35.38
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 13 Dec 2023 09:35:41 -0800 (PST)
Message-ID: <e4b8326b-5b7b-4004-b0e1-b60e63bdcdd1@redhat.com>
Date: Wed, 13 Dec 2023 18:35:35 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v10 04/50] x86/cpufeatures: Add SEV-SNP CPU feature
Content-Language: en-US
To: Borislav Petkov <bp@alien8.de>, Michael Roth <michael.roth@amd.com>
Cc: kvm@vger.kernel.org, linux-coco@lists.linux.dev, linux-mm@kvack.org,
 linux-crypto@vger.kernel.org, x86@kernel.org, linux-kernel@vger.kernel.org,
 tglx@linutronix.de, mingo@redhat.com, jroedel@suse.de,
 thomas.lendacky@amd.com, hpa@zytor.com, ardb@kernel.org, seanjc@google.com,
 vkuznets@redhat.com, jmattson@google.com, luto@kernel.org,
 dave.hansen@linux.intel.com, slp@redhat.com, pgonda@google.com,
 peterz@infradead.org, srinivas.pandruvada@linux.intel.com,
 rientjes@google.com, dovmurik@linux.ibm.com, tobin@ibm.com, vbabka@suse.cz,
 kirill@shutemov.name, ak@linux.intel.com, tony.luck@intel.com,
 marcorr@google.com, sathyanarayanan.kuppuswamy@linux.intel.com,
 alpergun@google.com, jarkko@kernel.org, ashish.kalra@amd.com,
 nikunj.dadhania@amd.com, pankaj.gupta@amd.com, liam.merwick@oracle.com,
 zhi.a.wang@intel.com, Brijesh Singh <brijesh.singh@amd.com>,
 Jarkko Sakkinen <jarkko@profian.com>
References: <20231016132819.1002933-1-michael.roth@amd.com>
 <20231016132819.1002933-5-michael.roth@amd.com>
 <0b2eb374-356c-46c6-9c4a-9512fbfece7a@redhat.com>
 <20231213131324.GDZXmt9LsMmJZyzCJw@fat_crate.local>
 <40915dc3-4083-4b9f-bc64-7542833566e1@redhat.com>
 <20231213133628.GEZXmzXFwA1p+crH/5@fat_crate.local>
 <9ac2311c-9ccc-4468-9b26-6cb0872e207f@redhat.com>
 <20231213134945.GFZXm2eTkd+IfdsjVE@fat_crate.local>
 <b4aab361-4494-4a4b-b180-d7df05fd3d5b@redhat.com>
 <20231213154107.GGZXnQkxEuw6dJfbc7@fat_crate.local>
From: Paolo Bonzini <pbonzini@redhat.com>
Autocrypt: addr=pbonzini@redhat.com; keydata=
 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
In-Reply-To: <20231213154107.GGZXnQkxEuw6dJfbc7@fat_crate.local>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 12/13/23 16:41, Borislav Petkov wrote:
> On Wed, Dec 13, 2023 at 03:18:17PM +0100, Paolo Bonzini wrote:
>> Surely we can agree that cpu_feature_enabled(X86_FEATURE_SEV_SNP) has nothing
>> to do with SEV-SNP host patches being present?
> 
> It does - we're sanitizing the meaning of a CPUID flag present in
> /proc/cpuinfo, see here:
> 
> https://git.kernel.org/tip/79c603ee43b2674fba0257803bab265147821955
>
>> And that therefore retpolines are preferred even without any SEV-SNP
>> support in KVM?
> 
> No, automatic IBRS should be disabled when SNP is enabled. Not CPUID
> present - enabled.

Ok, so the root cause of the problem is commit message/patch ordering:

1) patch 4 should have unconditionally cleared the feature (until the 
initialization code comes around in patch 6); and it should have 
mentioned in the commit message that we don't want X86_FEATURE_SEV_SNP 
to be set, unless SNP can be enabled via MSR_AMD64_SYSCFG.

2) possibly, the commit message of patch 5 could have said something 
like "at this point in the kernel SNP is never enabled".

3) Patch 23 should have been placed before the SNP initialization, 
because as things stand the patches (mildly) break bisectability.

> We clear that bit on a couple of occasions in the SNP
> host patchset if we determine that SNP host support is not possible so
> 4/50 needs to go together with the rest to mean something.

Understood now.  With the patch ordering and commit message edits I 
suggested above, indeed I would not have picked up patch 4.

But with your explanation, I would even say that "4/50 needs to go 
together with the rest" *for correctness*, not just to mean something.

Paolo


