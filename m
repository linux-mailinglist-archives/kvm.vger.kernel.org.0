Return-Path: <kvm+bounces-65209-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 11168C9F2EF
	for <lists+kvm@lfdr.de>; Wed, 03 Dec 2025 14:49:12 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id BEF0B3A4A2F
	for <lists+kvm@lfdr.de>; Wed,  3 Dec 2025 13:49:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0E1382FB62A;
	Wed,  3 Dec 2025 13:49:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="cOyi/Lmg"
X-Original-To: kvm@vger.kernel.org
Received: from mail-ed1-f46.google.com (mail-ed1-f46.google.com [209.85.208.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4A01C2E0930
	for <kvm@vger.kernel.org>; Wed,  3 Dec 2025 13:49:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764769743; cv=none; b=OXgnJi5BWD1cgerbOp1iY+GaZH0k74P6vzl63Ffd/CYfvtKK62eA5G4koW2BN1SGVAwcgetCfSK/vYyQQycNtCPUfya77jGLR7LdLLVZT3DpfAKgYpp3hyyiEP+s9mtx/hSVPDqKeY3I7Z1RzGRgGOnIyYrDPM7QB9qnAfJDHdc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764769743; c=relaxed/simple;
	bh=jmr9CMhPNuIwLusGsK+Icdbl7+fFM9A6NnpePj3yJo4=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=lW33OzSwDqwcdOQHz9WKhZQwlL9P5i6h9MpSEgzBvQYTh5NcZ2p9sdrbFmY+Y7ECeDsoUItKfJj3W3yYInKGvlN8DSeHghBrXoerT2BG++RTK/S1uL4eR3Pp7GORkNlUs1exvFOF84QaGpuqsmJKp90AmHxo6L5juk64eUrjQKY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=cOyi/Lmg; arc=none smtp.client-ip=209.85.208.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Received: by mail-ed1-f46.google.com with SMTP id 4fb4d7f45d1cf-64080ccf749so9941059a12.2
        for <kvm@vger.kernel.org>; Wed, 03 Dec 2025 05:49:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1764769740; x=1765374540; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=OP/1yrwUeq+oZ+kPLHWhUXAOqFCK1RgwC5hRZX13SR8=;
        b=cOyi/LmghlJvgme7nAsK+5xGDk16r8O/zd0sFzkHWWEO40xJCyxJ54PBGYFCNWMIWw
         QMNjkcQ07j++9wtD/3dCC1K13Tc1EsjvOCiPxyjwW00DHdCliNAwiYOB2rDm5r/qRRAX
         0o8uS8M1/Jpj454WXBk3UeodnV9TU4rhpMTif2xFh7kVw9m0apqAUjkeXr4t/EUV5SDp
         hvGh253HRQYOtEmhIVdhKV79Hs1YIk9zeM51mGGBAtmCYp00MpucrPxdfhPJwTsoo4ZP
         nr9Wtf4FgUZYMygOZ808DYZmhhatcZ0nRUeSuJ2wkBiVYGcPl+zr3EbY1dSzQaSKTbev
         OomQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764769740; x=1765374540;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=OP/1yrwUeq+oZ+kPLHWhUXAOqFCK1RgwC5hRZX13SR8=;
        b=SbQ+yGQB6GBLQUwJghgibUe+QM+FJgf5HixYcFm8cBFSB/Hf4ofQquwRi/1stXT98Q
         ke4vVgysqg6nyUAigSnUEAnFG4CAHmTMNZzVpMTtuVqRPhIbDxqWdGHsP1HKOUODkiGf
         JezyfyujeoWzT+1THXI+pXf0TNQ/SORTPj9Ck4tV1WggwtUFJYMagT2td+sShFRYbKNT
         VlQlgFCYV/AVW2TltbzbpgBDF5Ts8P/s9XbqdYFXzJ8jUbeZIUDcVXQHuBhrPK1sqo+3
         tz+ZLZzBaMzKNRJ5ImGS1O2G11Hoj1PR7h2khXMa8Wk7ztIt/GHVLOenAqOeqxkfuMcs
         01iQ==
X-Gm-Message-State: AOJu0YzvlHFlHBpDuMufnIL8Qu9lZ4T2eDxWslX+p/hfFxjTYHO3CpyO
	A5aDcola34GN+zpWb4OP1qasjjk5KzDxZl9ib85Jbdt5a+XmtV4mtVH8+xafDXO+4rc=
X-Gm-Gg: ASbGncv9eYe4RNbgqAvKoFpR8NVBQEzFPt9sHB+I6BhG0f4Bfu7oq3sXDk9JZyomKnk
	vebWNjf8hQnNg29VsY72BOHCHonN1Jw8exe3UzNA3n4uceudGrIMp5pAWyMpNak8DvW1ZuofgGl
	kgi/MFaPUqppptvYDJCFDytbakD7osRoIiIHnpBtf5k2TCzqCStLAX0rxBjP3xqZlZf7CQgHyNb
	3idjNBi4EifILsoMKPRDOhCH/CeWORCd+Bhs3GxI7x9hJOhai52287YjsgsE4m827/Z4Y4NOIeb
	KSCEolCgDM46u975Sjlt4CSEzm0pmm2f8Oqir7L9ItnQt4G393t12rQ64yFCGSF7ytFQyDAz1+T
	A/FOMkdK2bvPAM03llCN9XlPUolCVpCnfYWkMrSFcoc2nYNAjOyUwac5EJ2maFRM8x8InDGcZ2f
	MtxulcXluC0SH2qlHFMR7Aqn0TBKP4sP9bPkgxgA==
X-Google-Smtp-Source: AGHT+IEG5FQk+PE9WK0CW5uSQerVP7kEeZ4logANfkeZP+oIZv8G0KQKZdHIZ2BXgUv2JPICmb+fnw==
X-Received: by 2002:a05:6402:254b:b0:640:b31a:8439 with SMTP id 4fb4d7f45d1cf-6479c415686mr2167018a12.12.1764769739612;
        Wed, 03 Dec 2025 05:48:59 -0800 (PST)
Received: from [192.168.0.20] (nborisov.ddns.nbis.net. [109.121.139.124])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-647510508e1sm18495343a12.27.2025.12.03.05.48.58
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 03 Dec 2025 05:48:59 -0800 (PST)
Message-ID: <89d5876f-625b-43a6-bcad-d8caa4cbda2b@suse.com>
Date: Wed, 3 Dec 2025 15:48:57 +0200
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 07/16] x86/virt/tdx: Add tdx_alloc/free_page() helpers
To: Kiryl Shutsemau <kas@kernel.org>,
 "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
Cc: "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
 "linux-coco@lists.linux.dev" <linux-coco@lists.linux.dev>,
 "Huang, Kai" <kai.huang@intel.com>, "Li, Xiaoyao" <xiaoyao.li@intel.com>,
 "Hansen, Dave" <dave.hansen@intel.com>, "Zhao, Yan Y"
 <yan.y.zhao@intel.com>, "Wu, Binbin" <binbin.wu@intel.com>,
 "seanjc@google.com" <seanjc@google.com>, "mingo@redhat.com"
 <mingo@redhat.com>, "pbonzini@redhat.com" <pbonzini@redhat.com>,
 "tglx@linutronix.de" <tglx@linutronix.de>,
 "Yamahata, Isaku" <isaku.yamahata@intel.com>,
 "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
 "Annapurve, Vishal" <vannapurve@google.com>, "Gao, Chao"
 <chao.gao@intel.com>, "bp@alien8.de" <bp@alien8.de>,
 "x86@kernel.org" <x86@kernel.org>
References: <20251121005125.417831-1-rick.p.edgecombe@intel.com>
 <20251121005125.417831-8-rick.p.edgecombe@intel.com>
 <dde56556-7611-4adf-9015-5bdf1a016786@suse.com>
 <730de4be289ed7e3550d40170ea7d67e5d37458f.camel@intel.com>
 <f080efe3-6bf4-4631-9018-2dbf546c25fb@suse.com>
 <0274cee22d90cbfd2b26c52b864cde6dba04fc60.camel@intel.com>
 <7xbqq2uplwkc36q6jyorxe6u3fboka3snwar6parado5ysz25o@qrstyzh3okgh>
Content-Language: en-US
From: Nikolay Borisov <nik.borisov@suse.com>
Autocrypt: addr=nik.borisov@suse.com; keydata=
 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
In-Reply-To: <7xbqq2uplwkc36q6jyorxe6u3fboka3snwar6parado5ysz25o@qrstyzh3okgh>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit



On 3.12.25 г. 15:46 ч., Kiryl Shutsemau wrote:
> On Tue, Dec 02, 2025 at 08:02:38PM +0000, Edgecombe, Rick P wrote:
>> On Tue, 2025-12-02 at 09:38 +0200, Nikolay Borisov wrote:
>>>> Yea, it could be simpler if it was always guaranteed to be 2 pages. But it
>>>> was
>>>> my understanding that it would not be a fixed size. Can you point to what
>>>> docs
>>>> makes you think that?
>>>
>>> Looking at the PHYMEM.PAMT.ADD ABI spec the pages being added are always
>>> put into pair in rdx/r8. So e.g. looking into tdh_phymem_pamt_add rcx is
>>> set to a 2mb page, and subsequently we have the memcpy which simply sets
>>> the rdx/r8 input argument registers, no ? Or am I misunderstanding the
>>> code?
>>
>> Hmm, you are totally right. The docs specify the size of the 4k entries, but
>> doesn't specify that Dynamic PAMT is supposed to provide larger sizes in the
>> other registers. A reasonable reading could assume 2 pages always, and the usage
>> of the other registers seems like an assumption.
>>
>> Kirill, any history here?
> 
> There was a plan to future prove DPAMT by allowing PAMT descriptor to
> grow in the future. The concrete approach was not settled last time I
> checked. This code was my attempt to accommodate it. I don't know if it
> fits the current plan.
> 

Considering this, I'd opt for the simplest possible approach that works 
_now_. If in the future there are changes to the ABI let's introduce 
them incrementally when their time comes.

