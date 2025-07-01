Return-Path: <kvm+bounces-51228-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 2DA37AF0622
	for <lists+kvm@lfdr.de>; Wed,  2 Jul 2025 00:01:28 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 21D861C07FA5
	for <lists+kvm@lfdr.de>; Tue,  1 Jul 2025 22:01:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E9F8A27FB25;
	Tue,  1 Jul 2025 22:01:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="ZHz+0HE4"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f202.google.com (mail-pf1-f202.google.com [209.85.210.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BF1F372621
	for <kvm@vger.kernel.org>; Tue,  1 Jul 2025 22:01:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751407278; cv=none; b=lJARmZRc1g8tHHzyrOFPW1Loeux0ijWm/Jby5DsX3jpJwad7VAuPrg0Jy0TPZBk8xFkpJZrpz8Mdqyw/hTB4kmKjZZIGDnLaDp9u4CfehTs+70eD5sSnPcXDF+4IVJvMaXl4HXhdmWmDYi++XHC5O0HK9/m9OBVIMdIaUdj3uu4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751407278; c=relaxed/simple;
	bh=ym4G6ufKkIWzagLIfI+OhFmb/6iNAI1xtHVDilZhmaw=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=Z0q1OCJf5KLWbowutC1mZEHjySxcOrgl/4x8JOuj4J5Rt/xznvp4Mpd7+9RgtNuoCMNUHRf+uh8klYbZKU/6U8sk8HpKcqVbDIPtaet2pXik2pCeQu+WXDnkG6FGW5yO6sxbj3zNAtlA3xf+Gu+aJGzFZh+gJPOPTIFj/uvQfLI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--ackerleytng.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=ZHz+0HE4; arc=none smtp.client-ip=209.85.210.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--ackerleytng.bounces.google.com
Received: by mail-pf1-f202.google.com with SMTP id d2e1a72fcca58-748764d84feso5867812b3a.2
        for <kvm@vger.kernel.org>; Tue, 01 Jul 2025 15:01:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1751407276; x=1752012076; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=sZpSfMGCY39joD2VC5bXg87sm6OUeYjHe/LMyzT4YGA=;
        b=ZHz+0HE42hZqtmU9rg2tJEY2N2iuOH72Kq0J9aUOgxRXbBufm+KN9q65AMUkjhpkNF
         s4lRyv4/diVr61Waahi8gmZ5eYItKwm85Xdm+M3CvrS8dQZqlwepjKxy6i1fMphJlkJ8
         bOxuDFc9jP6WSNNgVdqDM5nImMcebBKXs8MsIP1LZQrSfbHGWZH2CVLLPeiucXrSTmRF
         Dr8RZEnbZz2B3RdaF7mtJxGN7L0J8hYkfgTG3R5RP3C3yZQ2Tn1UspkVVw7WTq6Zjhm4
         m3fiASrRpGGAIGCqf28TZ1BaxD5eHUO9v0uismIfsbr8frJr+8iPn2cbErThb2p49n5E
         7UwA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1751407276; x=1752012076;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=sZpSfMGCY39joD2VC5bXg87sm6OUeYjHe/LMyzT4YGA=;
        b=JIIzgAGDE2P4a8Sf5+/MhjI4wQKobn1XVG8hlqwTdBWUVfkdVQV7pUhMyjZSsn3ugS
         UzWkgDCmYsNc4437Mu6BWVNUmB7HaR4bHDBwMNKWJ0oVKCZEnv6Nuv/rRYAA/7w3vXIE
         jRmm2Kyv6meOR1KEMPcSLnlRFGcOH26F5vS156a8ee+WpepDuVXsWt3PZe8JSpeCLSx6
         oBLdcgASNEiF/NUMOm7Jz2zgSrYnj6GzPoFz1iXFv6xERUjc/ObT1KVf7iNRZVXFORPM
         udzMYXadM8m4e72b8xmLnNRrsyHg1cPHRzBUDEsvbd2fbbI5z0awyFBSskaPRR62nu5S
         T2sg==
X-Forwarded-Encrypted: i=1; AJvYcCX4UibPtaHh5A4PR8qEBOApkTE/EtbxvXMItlXr7nz4xmFjfkca5IGxaEuozZBmNRqtkjk=@vger.kernel.org
X-Gm-Message-State: AOJu0YwDlRCI0W7fnwrMgCS91SSoqmviTOcPfpkqV82cb/gvus3xHYw5
	4YJf0kvrOFdmZDEeEZAAuI5WNY0HpqNIDnmj2CwKnRIuhPAn8Zb84f0NOrInUG878g8iLGIReZH
	JEO32BrB9smZLmhQofzSXA7TNYA==
X-Google-Smtp-Source: AGHT+IEd9keGJPvtO1uRbJlDNElYmO2f0J3qSttebwAES17DT1AOdOkvIO1LIuYSPiK3tQDScGLMbN+3Qhbuix38Cw==
X-Received: from pfbbk11.prod.google.com ([2002:aa7:830b:0:b0:748:f98a:d97b])
 (user=ackerleytng job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6a21:618f:b0:216:1ea0:a51a with SMTP id adf61e73a8af0-222d7f25634mr1088275637.38.1751407276143;
 Tue, 01 Jul 2025 15:01:16 -0700 (PDT)
Date: Tue, 01 Jul 2025 15:01:14 -0700
In-Reply-To: <aGNtA+E9FT0Q2OUZ@yzhao56-desk.sh.intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <diqz34bolnta.fsf@ackerleytng-ctop.c.googlers.com>
 <a3cace55ee878fefc50c68bb2b1fa38851a67dd8.camel@intel.com>
 <diqzms9vju5j.fsf@ackerleytng-ctop.c.googlers.com> <447bae3b7f5f2439b0cb4eb77976d9be843f689b.camel@intel.com>
 <zlxgzuoqwrbuf54wfqycnuxzxz2yduqtsjinr5uq4ss7iuk2rt@qaaolzwsy6ki>
 <4cbdfd3128a6dcc67df41b47336a4479a07bf1bd.camel@intel.com>
 <diqz5xghjca4.fsf@ackerleytng-ctop.c.googlers.com> <aGJxU95VvQvQ3bj6@yzhao56-desk.sh.intel.com>
 <a40d2c0105652dfcc01169775d6852bd4729c0a3.camel@intel.com>
 <diqzms9pjaki.fsf@ackerleytng-ctop.c.googlers.com> <aGNtA+E9FT0Q2OUZ@yzhao56-desk.sh.intel.com>
Message-ID: <diqzplej4llh.fsf@ackerleytng-ctop.c.googlers.com>
Subject: Re: [RFC PATCH 08/21] KVM: TDX: Increase/decrease folio ref for huge pages
From: Ackerley Tng <ackerleytng@google.com>
To: Yan Zhao <yan.y.zhao@intel.com>
Cc: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>, 
	"Shutemov, Kirill" <kirill.shutemov@intel.com>, "Li, Xiaoyao" <xiaoyao.li@intel.com>, 
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>, "Hansen, Dave" <dave.hansen@intel.com>, 
	"david@redhat.com" <david@redhat.com>, "thomas.lendacky@amd.com" <thomas.lendacky@amd.com>, 
	"tabba@google.com" <tabba@google.com>, "vbabka@suse.cz" <vbabka@suse.cz>, 
	"quic_eberman@quicinc.com" <quic_eberman@quicinc.com>, "michael.roth@amd.com" <michael.roth@amd.com>, 
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "seanjc@google.com" <seanjc@google.com>, 
	"Peng, Chao P" <chao.p.peng@intel.com>, "Du, Fan" <fan.du@intel.com>, 
	"Yamahata, Isaku" <isaku.yamahata@intel.com>, "pbonzini@redhat.com" <pbonzini@redhat.com>, 
	"binbin.wu@linux.intel.com" <binbin.wu@linux.intel.com>, "Weiny, Ira" <ira.weiny@intel.com>, 
	"Li, Zhiquan1" <zhiquan1.li@intel.com>, "Annapurve, Vishal" <vannapurve@google.com>, 
	"jroedel@suse.de" <jroedel@suse.de>, "Miao, Jun" <jun.miao@intel.com>, 
	"pgonda@google.com" <pgonda@google.com>, "x86@kernel.org" <x86@kernel.org>
Content-Type: text/plain; charset="UTF-8"

Yan Zhao <yan.y.zhao@intel.com> writes:

> On Mon, Jun 30, 2025 at 12:25:49PM -0700, Ackerley Tng wrote:
>> "Edgecombe, Rick P" <rick.p.edgecombe@intel.com> writes:
>> 
>> > On Mon, 2025-06-30 at 19:13 +0800, Yan Zhao wrote:
>> >> > > ok! Lets go f/g. Unless Yan objects.
>> >> I'm ok with f/g. But I have two implementation specific questions:
>> >> 
>> >> 1. How to set the HWPoison bit in TDX?
>> 
>> I was thinking to set the HWpoison flag based on page type. If regular
>> 4K page, set the flag. If THP page (not (yet) supported by guest_memfd),
>> set the has_hwpoison flag, and if HugeTLB page, call
>> folio_set_hugetlb_hwpoison().
> Could you elaborate on how to call folio_set_hugetlb_hwpoison()?
>

Sorry I meant "in TDX" as in the part of the kernel that performs the
unmap. I'm assuming something like

int ret = tdx_do_unmap(page)
if (ret)
	set_hwpoison_based_on_folio_type(page_folio(page))

And set_hwpoison_based_on_folio_type() would have to be written to know
how to set the HWpoison flag based on type of the folio.

I think I might have used the wrong terminology elsewhere. Sorry about
that. I don't mean to call folio_set_hugetlb_hwpoison() from within the
TDX module. I meant to set HWpoison in the kernel, based on return value
to the kernel from the TDX module.

>> But if we go with Rick's suggestion below, then we don't have to figure
>> this out.
>> 
>> >> 2. Should we set this bit for non-guest-memfd pages (e.g. for S-EPT pages) ?
>> >
>> > Argh, I guess we can keep the existing ref count based approach for the other
>> > types of TDX owned pages?
>> >
>> 
>> Wait TDX can only use guest_memfd pages, right? Even if TDX can use
>> non-guest_memfd pages, why not also set HWpoison for non-guest_memfd
>> pages?
> As in https://lore.kernel.org/all/aGJxU95VvQvQ3bj6@yzhao56-desk.sh.intel.com/,
> I don't find a proper interface for TDX to set HWpoison bit on non-guset_memfd
> pages.
>
> Neither memory_failure() nor memory_failure_queue() seem fit.

