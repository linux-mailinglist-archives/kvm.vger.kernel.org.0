Return-Path: <kvm+bounces-67184-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 59925CFB31C
	for <lists+kvm@lfdr.de>; Tue, 06 Jan 2026 23:05:08 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 6664730638B1
	for <lists+kvm@lfdr.de>; Tue,  6 Jan 2026 22:04:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3D819278E47;
	Tue,  6 Jan 2026 22:04:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="xzJmI17C"
X-Original-To: kvm@vger.kernel.org
Received: from mail-vs1-f46.google.com (mail-vs1-f46.google.com [209.85.217.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BD9941D130E
	for <kvm@vger.kernel.org>; Tue,  6 Jan 2026 22:04:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.217.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767737064; cv=none; b=lc1FVQh2l4PBw5GcicPTADz8Phj1wA9zbWNfoUE85zDqxjJ1i/47yi1HiquLC9qa5jK2Y70zgq5c0G78igaeZ3yoUaT891zgmKwhoSLWdqUIIM1KWhfwWrXaJ3/ZW8QhHI/HC0oy5+HVt+0C6xJD6VvKnfxjzJx8riiTkFJGjdA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767737064; c=relaxed/simple;
	bh=huIVgs8A9Oq70zOBQsDz/wJCmn8YL+g8naEhx6e87as=;
	h=From:In-Reply-To:References:MIME-Version:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=XAL1wISM6JqkTAf7uKx7aaCiNe6rX7I3q3G+pVbmBVy00Pea+069Oxw0kLOf5qrrVSKDcCIoWhNfXSogyAebzelLyPjk5xfZ3dKlO7HoONGb4WKqcwVlp1dEo7clc5gFH0ehFHtVISTq3Cf/dsu2P/AqoWXG/gex9KnVczNA928=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=xzJmI17C; arc=none smtp.client-ip=209.85.217.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-vs1-f46.google.com with SMTP id ada2fe7eead31-5dfa9c01c54so877828137.0
        for <kvm@vger.kernel.org>; Tue, 06 Jan 2026 14:04:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1767737061; x=1768341861; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date
         :mime-version:references:in-reply-to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Q61/8LAR/I40rsHqIG5x8NW2OG9piOuPbVzsJ/gaxz0=;
        b=xzJmI17CZyKzI0UlxnixXm7bltZ1L+pLTT+YwL9S87Upwdg4fIw4aS2zC0zpcXS3NS
         IgdPFaARyc8Jqb1DBrqJDzvs3bejUNqVyYxWIZDPOiKVwdaEv2gPh5YttzEOnJMICPqV
         Fz6IDKyEa2szJsBZzld/BscWvgOZvpBH2Bpx0JULE3eQ8AmvnAzMf8NFB8z5A1OGhKVK
         CHIW1nQqUV/3EHW3saHhZcD/3MzQoqBkm1it9m6GiXvrWSTfgCgx8R1FvlSMcXq5/zqO
         HPHCIsxIQg9Gi5N/oJAmMUpA8XUlvMUTrf/teQhD0tXK192vJ7uMye+pD3t7BO9TXkPL
         huNQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767737061; x=1768341861;
        h=content-transfer-encoding:cc:to:subject:message-id:date
         :mime-version:references:in-reply-to:from:x-gm-gg:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=Q61/8LAR/I40rsHqIG5x8NW2OG9piOuPbVzsJ/gaxz0=;
        b=EbluEz+1CYfavrYjaBEnB+m62fQRklD6PkZ94LNE0Zzye56+8eFKM/JNS7OYCVzTzm
         LzIw6/jvcXNClMuA6vhaTAOq5tQk6AbW7H7LvXRbkl3pQqrqulkp/4AHrmzvXjW1blkD
         ED87mAsDY+Fpew7VVe0s6svyM1FCGuPPW/i5gzKOqm+w4u8gZ2941qgU8p1xUVdUqxiG
         lo9MniC2ZXCaQK6kGykM9nD4jPvEQoVRa4f13K6uRmC+XMbi85yKw1LUQFa7cnM095KU
         8Re7ihK73C5LZBfMjmJjeUYWpGABbUuTjGMleeJ8bUtJeV3VqQk/9avQLGuCPmj4mAyI
         d37g==
X-Forwarded-Encrypted: i=1; AJvYcCW+dw44w7CH3c+5/ODZ8qhr+W954kxoLelW3LpJXx6p13D077h+4ybVXvLcSzX6splfIXg=@vger.kernel.org
X-Gm-Message-State: AOJu0Yz4Y4XQD4IrFBIcL77fwOzGl1ihLWCT7IhD7D+BD+D93Li+NACr
	vYBu9j+mcT8dvhtYV0gZZcq+zb5PVpV8k7SlwyiKzkAMHR+WHfbMRerDz+Y5RM5tYySFPV91o+H
	/+aoysm+Lvch58O8NV4orRAYL2quq9ZcuCcjIOUn3
X-Gm-Gg: AY/fxX6uDnC53NNuPZ9w4jfTF34s9fL7I+HwBu+0zvnllyGV4OES+LkPVWeAx+BwvZn
	SBKOYX+zxjeeIOyirHOz8FbwsrEsrAFvxcEJ7ywwYRfJ5Qg1Rn+6EpexD3sS4K484OhCQuCMFfR
	iofLx7khp7VozsQ1LQceGrmddo0o5f9b5oV5ZWAO2d02NUVccuY42ZUsZVyYBKy3nK/O8ou8BNu
	f+KmW4QycAHPnstzG68dlwMHk56BuNnm8uphm/STCI68fLvIrRD6pccpgizrNHNIa/7XkrDkUFc
	Dq1m8qMKX+jQgiANxLrUFonf
X-Google-Smtp-Source: AGHT+IHcUi1lzdCXfJ82sn/YSRyrXkAce6rsD42v9BKCZikKKg0L6wdlo2MRripnKz65qmQdMDq5Oa3BVn7I6Y45o7k=
X-Received: by 2002:a05:6102:604b:b0:5ec:bf40:51e9 with SMTP id
 ada2fe7eead31-5ecbf4054a9mr102747137.29.1767737061324; Tue, 06 Jan 2026
 14:04:21 -0800 (PST)
Received: from 176938342045 named unknown by gmailapi.google.com with
 HTTPREST; Tue, 6 Jan 2026 14:04:20 -0800
Received: from 176938342045 named unknown by gmailapi.google.com with
 HTTPREST; Tue, 6 Jan 2026 14:04:20 -0800
From: Ackerley Tng <ackerleytng@google.com>
In-Reply-To: <aV2A39fXgzuM4Toa@google.com>
References: <20260106101646.24809-1-yan.y.zhao@intel.com> <CAGtprH-eEUzHDUB0CK2V162HHqvE8kT3bAacb6d3xDYJPwBiYA@mail.gmail.com>
 <CAEvNRgGG+xYhsz62foOrTeAxUCYxpCKCJnNgTAMYMV=w2eq+6Q@mail.gmail.com> <aV2A39fXgzuM4Toa@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Date: Tue, 6 Jan 2026 14:04:20 -0800
X-Gm-Features: AQt7F2r2JaKuW6RfxFrEND_E_UHoCOrX_sTvP0MgfLyMTQVp7rxMnjkZtPGaQs0
Message-ID: <CAEvNRgFOER_j61-3u2dEoYdFMPNKaVGEL_=o2WVHfBi8nN+T0A@mail.gmail.com>
Subject: Re: [PATCH v3 00/24] KVM: TDX huge page support for private memory
To: Sean Christopherson <seanjc@google.com>
Cc: Vishal Annapurve <vannapurve@google.com>, Yan Zhao <yan.y.zhao@intel.com>, pbonzini@redhat.com, 
	linux-kernel@vger.kernel.org, kvm@vger.kernel.org, x86@kernel.org, 
	rick.p.edgecombe@intel.com, dave.hansen@intel.com, kas@kernel.org, 
	tabba@google.com, michael.roth@amd.com, david@kernel.org, sagis@google.com, 
	vbabka@suse.cz, thomas.lendacky@amd.com, nik.borisov@suse.com, 
	pgonda@google.com, fan.du@intel.com, jun.miao@intel.com, 
	francescolavra.fl@gmail.com, jgross@suse.com, ira.weiny@intel.com, 
	isaku.yamahata@intel.com, xiaoyao.li@intel.com, kai.huang@intel.com, 
	binbin.wu@linux.intel.com, chao.p.peng@intel.com, chao.gao@intel.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Sean Christopherson <seanjc@google.com> writes:

> On Tue, Jan 06, 2026, Ackerley Tng wrote:
>> Vishal Annapurve <vannapurve@google.com> writes:
>>
>> > On Tue, Jan 6, 2026 at 2:19=E2=80=AFAM Yan Zhao <yan.y.zhao@intel.com>=
 wrote:
>> >>
>> >> - EPT mapping size and folio size
>> >>
>> >>   This series is built upon the rule in KVM that the mapping size in =
the
>> >>   KVM-managed secondary MMU is no larger than the backend folio size.
>> >>
>>
>> I'm not familiar with this rule and would like to find out more. Why is
>> this rule imposed?
>
> Because it's the only sane way to safely map memory into the guest? :-D
>
>> Is this rule there just because traditionally folio sizes also define th=
e
>> limit of contiguity, and so the mapping size must not be greater than fo=
lio
>> size in case the block of memory represented by the folio is not contigu=
ous?
>
> Pre-guest_memfd, KVM didn't care about folios.  KVM's mapping size was (a=
nd still
> is) strictly bound by the host mapping size.  That's handles contiguous a=
ddresses,
> but it _also_ handles contiguous protections (e.g. RWX) and other attribu=
tes.
>
>> In guest_memfd's case, even if the folio is split (just for refcount
>> tracking purposese on private to shared conversion), the memory is still
>> contiguous up to the original folio's size. Will the contiguity address
>> the concerns?
>
> Not really?  Why would the folio be split if the memory _and its attribut=
es_ are
> fully contiguous?  If the attributes are mixed, KVM must not create a map=
ping
> spanning mixed ranges, i.e. with multiple folios.

The folio can be split if any (or all) of the pages in a huge page range
are shared (in the CoCo sense). So in a 1G block of memory, even if the
attributes all read 0 (!KVM_MEMORY_ATTRIBUTE_PRIVATE), the folio
would be split, and the split folios are necessary for tracking users of
shared pages using struct page refcounts.

However the split folios in that 1G range are still fully contiguous.

The process of conversion will split the EPT entries soon after the
folios are split so the rule remains upheld.

I guess perhaps the question is, is it okay if the folios are smaller
than the mapping while conversion is in progress? Does the order matter
(split page table entries first vs split folios first)?

