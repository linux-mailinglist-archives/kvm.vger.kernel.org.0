Return-Path: <kvm+bounces-65086-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 19713C9A7D1
	for <lists+kvm@lfdr.de>; Tue, 02 Dec 2025 08:38:48 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 432AA3A6011
	for <lists+kvm@lfdr.de>; Tue,  2 Dec 2025 07:38:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BD00830147E;
	Tue,  2 Dec 2025 07:38:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="U2GdwKOz"
X-Original-To: kvm@vger.kernel.org
Received: from mail-ej1-f44.google.com (mail-ej1-f44.google.com [209.85.218.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DF4AC2989B7
	for <kvm@vger.kernel.org>; Tue,  2 Dec 2025 07:38:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764661116; cv=none; b=SsuxZJrYlZmJSiZnYKGmhpGTFI8AJ0ngDDwGR6JOOvZc89rNMPm6c7IvNe/p6cuwsAMOyoaRhicOVgyeZo1xwpwm1nTvJHoXvJJrjiJMyVblY/YoDt2qD6r+BScXsQHhcIFBAE0q/fqshTWt5ibFw+ihfz3UhbwzZv/IWgdnZHs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764661116; c=relaxed/simple;
	bh=4E/W44qqTBRv0TQzeYVdX2Moxoxip2C8MoLpYBH0BmY=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=lpdoOy068c/jBOFAGkvtKuwVvpK8Gkkx3Y63N2oI98st3DjpNVGFE+LeLDQ7rGPRWLOpB2rCJs/AFvFGe5qj5mFiSHtawjuOxLsZFbW1OHO4tF5yxeyga+5pDdYz4u5Y5uC49FaaGK9pONClV/ShH/kfDvHCPOlSzo9XypSy/b4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=U2GdwKOz; arc=none smtp.client-ip=209.85.218.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Received: by mail-ej1-f44.google.com with SMTP id a640c23a62f3a-b762de65c07so181799166b.2
        for <kvm@vger.kernel.org>; Mon, 01 Dec 2025 23:38:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1764661113; x=1765265913; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=rwWt/QUCCb26C45zQDIVmRAtE3lRFaqXY9u8FfiIcg4=;
        b=U2GdwKOzyB7rLVFiexuruh7qjiAAC1GHcTVf0w6erR6+WhHfK42JN8q/+hKfmVyumz
         497WY8sUzPSYyKYWVUzLJ3bERB2xnE2lbqKk0A+zAB3jYbregGPUaUVOZ219hXGczcwC
         kIOg47G5PJeHUuYDgSekELunY7HHPzmibpj7yIJDQmH/NQUEL7P6+svT7PnO52mqWqGR
         EhhSjVaicxNKYjMNecMGFHTxtmO/Qs6J84/UuB/LVslxHDwKCQyXI0LZO1LsDL8ElwLE
         e+N0IeRjZIACmi05ZaHbFlDb2IzDmOlT7xSXhw7q93Qt1MR+Hbwvx3xsOIzy5KgWjoQc
         h0GA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764661113; x=1765265913;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=rwWt/QUCCb26C45zQDIVmRAtE3lRFaqXY9u8FfiIcg4=;
        b=hdp6F4Wr+cgKUS1eNvUtzc/1EQHl7aBTroUAeXUVaMUbVEa+ImyLHokf6QPQT5nTlL
         H1cozG+4DcK0Y+1TjX2NKI/WHhXRjcCB683dWbt4vBR9DgdZrIbql8Lhmau6Nx+Wy0Ew
         sq3geJTx0okClQVifI5YXrhk1fSOFalaIF2B02ZlGP717GVAUeeu60Gm3hJxvYlq0UGq
         0lx2hWjt0hzz7UyqssJHqip5k+bM/qJu8mpD37mZxh5ts9g1dsH6pZHXb7jskZrkwnGJ
         A7WWKgDqxbIYh9YBokNs6neEOoNmlH+6mwVUbeWW97HvQ8z3ZUXk6IaGo8pKK61sArK9
         JkXg==
X-Forwarded-Encrypted: i=1; AJvYcCW0QjU9FkOBjbOFm4masCqIRWP6QLBr9iBlLWZleoUcI57foBr3IIOEUc3ozjQrHQL4YuY=@vger.kernel.org
X-Gm-Message-State: AOJu0YwFRWPOlgSphVOIRZ6gxj4VsyJ2VJa0xaygMwascOqMMrF7F4KN
	l+TrMmudcvBGv9+hQ2Uu5FuEIisRDR/5fWce+gu1dHVl4IiY+IbKUcEd0Lya34KHGnE=
X-Gm-Gg: ASbGncs99fl4qM3o4ryNdKZXYgSwM7mel8QyTk79SPL+9GU80ZAe8OzUFlWjFrXgUKs
	xAgv0oZtOlhDkADkLHF4dSNMfRfvYEz4IjBhYMZeayTe+qfuACgPeBTerEwhN7MEJGQ2yfNbgiN
	R6tBPX8ARIaA6GzP4ZRe2cgh/yrv1k5P/DjAiPS5LuEUsQgfUow+6Uhch+jvPBG2FmirWC1QoW9
	K+XcwMocSo0A6y1OsI46Cgw64RGWIdXU6Ju52eOJTfXlBcs0WzvvK7BAAf2HZsmUPqa78TONZA3
	1zdHyoJmQVEyuZ5ZrQPM8isoxIT5cIOWwYasnryoOIVODkEIFvLh2E8EOMvN5bQKpYQeD1Xs9VM
	6oIz0AI5VsaidJasc3aIG98MlHLmufSEsEKsFuqjR2viODIIDTM52JRrhpD36P2X+Ns8SAY7j2r
	5TTvCbEi+liGzFL76T8aa2w/4iaR+iv3zHQ6uhfg==
X-Google-Smtp-Source: AGHT+IHKBFxfELi4JmOopPa1lP4A5954tvejn7U7ySqIJ3TuahJFohf39stVP8u0j1wJvJpADlmN5Q==
X-Received: by 2002:a17:907:7ba1:b0:b76:b7fe:3198 with SMTP id a640c23a62f3a-b76c5514685mr3428869566b.26.1764661113144;
        Mon, 01 Dec 2025 23:38:33 -0800 (PST)
Received: from [192.168.0.20] (nborisov.ddns.nbis.net. [109.121.139.124])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-b76f5a5f979sm1422853766b.69.2025.12.01.23.38.31
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 01 Dec 2025 23:38:32 -0800 (PST)
Message-ID: <f080efe3-6bf4-4631-9018-2dbf546c25fb@suse.com>
Date: Tue, 2 Dec 2025 09:38:30 +0200
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 07/16] x86/virt/tdx: Add tdx_alloc/free_page() helpers
To: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>,
 "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
 "linux-coco@lists.linux.dev" <linux-coco@lists.linux.dev>,
 "Huang, Kai" <kai.huang@intel.com>, "Li, Xiaoyao" <xiaoyao.li@intel.com>,
 "Hansen, Dave" <dave.hansen@intel.com>, "Zhao, Yan Y"
 <yan.y.zhao@intel.com>, "Wu, Binbin" <binbin.wu@intel.com>,
 "kas@kernel.org" <kas@kernel.org>, "seanjc@google.com" <seanjc@google.com>,
 "mingo@redhat.com" <mingo@redhat.com>,
 "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
 "tglx@linutronix.de" <tglx@linutronix.de>,
 "Yamahata, Isaku" <isaku.yamahata@intel.com>,
 "pbonzini@redhat.com" <pbonzini@redhat.com>,
 "Annapurve, Vishal" <vannapurve@google.com>, "Gao, Chao"
 <chao.gao@intel.com>, "bp@alien8.de" <bp@alien8.de>,
 "x86@kernel.org" <x86@kernel.org>
References: <20251121005125.417831-1-rick.p.edgecombe@intel.com>
 <20251121005125.417831-8-rick.p.edgecombe@intel.com>
 <dde56556-7611-4adf-9015-5bdf1a016786@suse.com>
 <730de4be289ed7e3550d40170ea7d67e5d37458f.camel@intel.com>
From: Nikolay Borisov <nik.borisov@suse.com>
Content-Language: en-US
Autocrypt: addr=nik.borisov@suse.com; keydata=
 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
In-Reply-To: <730de4be289ed7e3550d40170ea7d67e5d37458f.camel@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit



On 2.12.25 г. 0:39 ч., Edgecombe, Rick P wrote:
> On Thu, 2025-11-27 at 18:11 +0200, Nikolay Borisov wrote:
>>> +/* Number PAMT pages to be provided to TDX module per 2M region of PA */
>>> +static int tdx_dpamt_entry_pages(void)
>>> +{
>>> +	if (!tdx_supports_dynamic_pamt(&tdx_sysinfo))
>>> +		return 0;
>>> +
>>> +	return tdx_sysinfo.tdmr.pamt_4k_entry_size * PTRS_PER_PTE /
>>> PAGE_SIZE;
>>> +}
>>
>> Isn't this guaranteed to return 2 always as per the ABI? Can't the
>> allocation of the 2 pages be moved closer to where it's used - in
>> tdh_phymem_pamt_add which will simplify things a bit?
> 
> Yea, it could be simpler if it was always guaranteed to be 2 pages. But it was
> my understanding that it would not be a fixed size. Can you point to what docs
> makes you think that?

Looking at the PHYMEM.PAMT.ADD ABI spec the pages being added are always 
put into pair in rdx/r8. So e.g. looking into tdh_phymem_pamt_add rcx is 
set to a 2mb page, and subsequently we have the memcpy which simply sets 
the rdx/r8 input argument registers, no ? Or am I misunderstanding the 
code?
> 
> Another option would be to ask TDX folks to make it fixed, and then require an
> opt-in for it to be expanded later if needed. I would have to check on them on
> the reasoning for it being dynamic sized. I'm not sure if it is *that*
> complicated at this point though. Once there is more than one, the loops becomes
> tempting. And if we loop over 2 we could easily loop over n.


