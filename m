Return-Path: <kvm+bounces-51230-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id F1DFAAF068A
	for <lists+kvm@lfdr.de>; Wed,  2 Jul 2025 00:27:08 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 159F21C06736
	for <lists+kvm@lfdr.de>; Tue,  1 Jul 2025 22:27:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7AFB3302079;
	Tue,  1 Jul 2025 22:26:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="O6Z+ocx+"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f202.google.com (mail-pf1-f202.google.com [209.85.210.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 270B01465A1
	for <kvm@vger.kernel.org>; Tue,  1 Jul 2025 22:26:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751408818; cv=none; b=pAavIWMUsyWm18757eaiZIe0+V51jrKTw5q1rgc0Ry0VDdYIr8KFP/VX5WpAyU2dZiVVjW0zxNIkZQPzA9NA5m1Dp7o4WXmCUXGxXJxMXsdDny6QHr4UzcNFgvc/vz91jCRmD/XlUCKMghsomJUKpRXifjeemNmxhXVQ38EDHoc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751408818; c=relaxed/simple;
	bh=LTQiT/kSGQUrfAjR7KvtzE/kVJJZn83D2wZSid5uuRE=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=r1pTJO7natITN9tAYSK9sn7yryYs4kGV3I3RMtAQvJwDjSW6SXBTTP6Ca3lzGq0COt1RqBWGB4bkIqZe/4tZgQ8iQsJwyeU82gYmRV/Vgy9uVvlw3LmJPtFPWywzw9GHPc65p/+R8xPJ2cIoM4/0tTSu0WJ4TvpiWBp00DjjpHM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--ackerleytng.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=O6Z+ocx+; arc=none smtp.client-ip=209.85.210.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--ackerleytng.bounces.google.com
Received: by mail-pf1-f202.google.com with SMTP id d2e1a72fcca58-748efefedb5so7570398b3a.2
        for <kvm@vger.kernel.org>; Tue, 01 Jul 2025 15:26:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1751408816; x=1752013616; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=if06mz/YNprPhrtrokC99c0nmz46eya3jf2C2awARNM=;
        b=O6Z+ocx+EKRmf638tV0K9Enm47o2SdEWxF0ieCj5Z1lHH/bMjhuAxd0SvVhdHVGH34
         Cbi08lao+2a40EwoGy9s48sVDB7j8r+nQfKNUOSMkdA89clTINKcqcbE33UtDKFWrOAg
         pQMtldLHOlR3FLgtk15Vf4V64t5K45uIaWB3TQz/e+F0lxzirsl6Y7VgC4dH29nyW9DJ
         nVuF1EJSfUvhyDg/VCZl7IwJRH9yrULYgCwMN/EzWnFQzwK0o3D2f20m3YSDmUu252oJ
         TBPiMFhoMNi4Rz5X2XftTZ3J91rpT1S24DoAuXBw490yAcyZG/xo3yhi/PMupCYVEzrl
         roYQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1751408816; x=1752013616;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=if06mz/YNprPhrtrokC99c0nmz46eya3jf2C2awARNM=;
        b=DBwUJojc8iPitGvDw9h0fB448u+MHmGsyDRiGQWQUbvTvXcHKp6fdwK3XpzR3x+Etc
         aokiQzuKZ+e1vc+6Y3kpPt7ZQUjf1Mb8ooynx4nAwO+imgeVBr5Z8sP/TbSR4Vy0mdlA
         ZPdopwQAnrzGYaaEr1lKyiuuxikpieuzQMMgT5I05RE8MJFeNmMnL/LOuGNmVwxtUyqE
         wZim1wR+v1DKDLE2/4BKLFUwYxl25QKf+l9bKRolE94H7egAmMFPoz8658+J+7F0UFRD
         +ypQ6u/uHh5frwbUehZEbhKTypr65WGezaqPo75ggNgkeo8HB2Alpx0M7HwBGYr91zfo
         +JlA==
X-Forwarded-Encrypted: i=1; AJvYcCWgk9hw5y8dWoOMXmbKTPy9WAMMnFZspLodB7V3mUQbvvziyvmk8gfunNYzje7Q7b7TWuE=@vger.kernel.org
X-Gm-Message-State: AOJu0YwTslvEHPol46qU7vqUT+Rw4gDBFgBlrLDogWsAgEAzFPuVmR2G
	kNLQ8WnmspdPLyQKhjO9EYrCFH4bkTjRiWJOD44iYcRBWSFV44yCmLimSAxzIv9y/p1oJ8xHeCD
	0h7n4txTb4bsFKBNndNCxy52ocA==
X-Google-Smtp-Source: AGHT+IGLoOZSSASXF+RgSPj49v/Cmn3psfTnX8AgH3OfgaZayDmaGkU2y4fh14C48AYoDPHuIAFX+lIGSLw9lPaKgQ==
X-Received: from pfbbe23.prod.google.com ([2002:a05:6a00:1f17:b0:748:fb38:1909])
 (user=ackerleytng job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6a00:2d91:b0:742:aecc:c47c with SMTP id d2e1a72fcca58-74b50e8daeemr609338b3a.7.1751408816382;
 Tue, 01 Jul 2025 15:26:56 -0700 (PDT)
Date: Tue, 01 Jul 2025 15:26:55 -0700
In-Reply-To: <diqzplej4llh.fsf@ackerleytng-ctop.c.googlers.com>
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
 <diqzplej4llh.fsf@ackerleytng-ctop.c.googlers.com>
Message-ID: <diqzh5zv4keo.fsf@ackerleytng-ctop.c.googlers.com>
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

Ackerley Tng <ackerleytng@google.com> writes:

> Yan Zhao <yan.y.zhao@intel.com> writes:
>
>> On Mon, Jun 30, 2025 at 12:25:49PM -0700, Ackerley Tng wrote:
>>> "Edgecombe, Rick P" <rick.p.edgecombe@intel.com> writes:
>>> 
>>> > On Mon, 2025-06-30 at 19:13 +0800, Yan Zhao wrote:
>>> >> > > ok! Lets go f/g. Unless Yan objects.
>>> >> I'm ok with f/g. But I have two implementation specific questions:
>>> >> 
>>> >> 1. How to set the HWPoison bit in TDX?
>>> 
>>> I was thinking to set the HWpoison flag based on page type. If regular
>>> 4K page, set the flag. If THP page (not (yet) supported by guest_memfd),
>>> set the has_hwpoison flag, and if HugeTLB page, call
>>> folio_set_hugetlb_hwpoison().
>> Could you elaborate on how to call folio_set_hugetlb_hwpoison()?
>>
>
> Sorry I meant "in TDX" as in the part of the kernel that performs the
> unmap. I'm assuming something like
>
> int ret = tdx_do_unmap(page)
> if (ret)
> 	set_hwpoison_based_on_folio_type(page_folio(page))
>
> And set_hwpoison_based_on_folio_type() would have to be written to know
> how to set the HWpoison flag based on type of the folio.
>
> I think I might have used the wrong terminology elsewhere. Sorry about
> that. I don't mean to call folio_set_hugetlb_hwpoison() from within the
> TDX module. I meant to set HWpoison in the kernel, based on return value
> to the kernel from the TDX module.
>
>>> But if we go with Rick's suggestion below, then we don't have to figure
>>> this out.
>>> 
>>> >> 2. Should we set this bit for non-guest-memfd pages (e.g. for S-EPT pages) ?
>>> >
>>> > Argh, I guess we can keep the existing ref count based approach for the other
>>> > types of TDX owned pages?
>>> >
>>> 
>>> Wait TDX can only use guest_memfd pages, right? Even if TDX can use
>>> non-guest_memfd pages, why not also set HWpoison for non-guest_memfd
>>> pages?
>> As in https://lore.kernel.org/all/aGJxU95VvQvQ3bj6@yzhao56-desk.sh.intel.com/,
>> I don't find a proper interface for TDX to set HWpoison bit on non-guset_memfd
>> pages.
>>
>> Neither memory_failure() nor memory_failure_queue() seem fit.

Missed out a response on this.

Vishal explained to me that non-guest_memfd pages can be used by TDX for
the TDX module itself.

For those, I think it's still okay to set HWpoison, because the kernel
page freeing process will leak HWpoison-ed pages. free_pages_prepare()
will check for HWpoison and skip freeing:

__folio_put() ->
  free_frozen_pages() ->
    __free_frozen_pages() ->
      free_pages_prepare()

