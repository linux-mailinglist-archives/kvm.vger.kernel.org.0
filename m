Return-Path: <kvm+bounces-59339-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 4C81BBB157A
	for <lists+kvm@lfdr.de>; Wed, 01 Oct 2025 19:18:07 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id B0D971946C29
	for <lists+kvm@lfdr.de>; Wed,  1 Oct 2025 17:18:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 73AE92D372E;
	Wed,  1 Oct 2025 17:17:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="fbmuVPMV"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f182.google.com (mail-pl1-f182.google.com [209.85.214.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 306261F4CBF
	for <kvm@vger.kernel.org>; Wed,  1 Oct 2025 17:17:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759339077; cv=none; b=gUoIUjZmGes0s+aslWqRMdfoAXRmllutEtFlSttdGRQzhfZ/6p/3eKVsuRnTc1H0T2ZWwa7SPl2c/M7VLYbnLQNNMBubEeIJ9HHxuNVkwpBhjF1azeU69TeWvst+FgsJbQXUofUtK38kkKuxRpPeQsd1mvuShr1og0qUe/G7AZU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759339077; c=relaxed/simple;
	bh=Am6LZIbCSVgY5Se1Wi0yNwFcMvrDpjvjfrYu+0BmiNA=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=tgwFIvNmKcllTqZPn4fljWmYtkqGXojDjzY1hvkPRwN7KC/2YxmxuU/IVyetwKgKdIuJwPLVTd59sQ4GjFK48J4ovEGsiVyjF3yENEcgfWHQXs3DzqGsjPmUucc9JG90fwTrU+m5lKmlB8CtEgJFnxAnxYq9J9ATDU9kYB6nnZM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=fbmuVPMV; arc=none smtp.client-ip=209.85.214.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-pl1-f182.google.com with SMTP id d9443c01a7336-27d67abd215so13165ad.0
        for <kvm@vger.kernel.org>; Wed, 01 Oct 2025 10:17:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1759339075; x=1759943875; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=1y2h5vASQKA3UCiJzkscyc1EFC5PFd9siEd1bqRvvXw=;
        b=fbmuVPMVZ0U1RZoG+4h3vXcvg10/pH1Uwe/Ix2hfrfJY/0UQbZ1U94tz0JDiD5ZxpK
         cBiakhYHAEhaeeiqndcdU00lb1FjP4q9vjR4KD8d+N2uOYamLCxMYfprybnaCoRhXtLR
         tm3lp6kEFu6+ZBV2Bfnd/KVoxo2ULHReAT/gl6c3Q4W7xk8Kmd3pUHRfqFicHXae6nCq
         vXqKiq8qQaGE4NRAUjCDBjqnJ4+g7ErMV7b8HYlN+yYrczDcSkxFmT18eXv/kDV5Q7Z4
         NLQdcno5s7UfqcMtd1w77HGxgNDCiKltujsDBB4qFWaRyg4AzGlZSGKFejizOGN7zEXG
         15Ig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759339075; x=1759943875;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=1y2h5vASQKA3UCiJzkscyc1EFC5PFd9siEd1bqRvvXw=;
        b=tnQSgO3cnhKUEZ0x/yfJwpYQoc0XBzHObxRS+JRGZf5B6b95FMbaEeeRxxresNiDfV
         6d3GgYQNq4xldCVuevR0zEtWbSm4vB4E7W5aQmPo2Fowg98pcGJt3IZm1vnkvFVnSHJs
         588YTrs56+MvsjhVs4XyYoIG2FbQbako/Buf8KYp2LeB6AXLBCbLGrIJ+JxzJVZMMmqT
         LUsUU5+L9SV9DVCClGwQvLpmMTktFfm3MRtg9W7xnVsw6Hg+orTd5j0vqGf0khVt7tL7
         DUjwGimYqKV6EgPcAseSK0JJjLq0Pu8TtOAwo2hA0WFxbas3SwR0yKjrzwfu3XVhJx9E
         hvew==
X-Forwarded-Encrypted: i=1; AJvYcCXAgDzhjL5sHbDPEcjw4ZufTNlOgw78A3P97/mmRM7IT12zV6MDF85XwfeNAMf8tWoeXS4=@vger.kernel.org
X-Gm-Message-State: AOJu0Yx0L/P4eVx9P+z6vANVFsbHZzVHtOiO/V9uTOZy2zz4XGjNHnM7
	hm1Lqlepe5wvHsgkgEUEImvBANFZ+89sE1skg5B1Dp/Kbn7qVjU/2riZncoxEOCn7WG/acEyTCs
	A9KAMO/hXhSoLd7rCf8PGJNX79nzY2ezGWs9geuNZ
X-Gm-Gg: ASbGncud6A+wrx+9O4WcS2pjrzid7WywLq3Lsg1rFSFw717AtgynNCpMRgW3Q8trF8C
	tML7RBG74+TKmMnGi5K9Tf8R6LCAOivbceoqp6WDVf9d54lbkxx8qoh4ZZ/975oLMe+dDs6v5yP
	bdZtQ9umY7f8PZXhGUKaDdLYR1faUxgAxml2/ebrCVGa7rHftuUY6DffB0hJ5ZhTjJT4KC012wm
	sLILS6mwGuW1o/GmmAooZ1AhdcrfxC138k/s4uUFQhgNHEX8SsDKN9a19Hq2X+s
X-Google-Smtp-Source: AGHT+IEc5YwjCgEyjWB8fCgIiAGbFywCUMBUm03Ih9N+XlFwOAjFHqrja3JrAWGFi1Rq4qqGQMM8IoASJRO0e7AT5hM=
X-Received: by 2002:a17:902:e744:b0:275:8110:7a4d with SMTP id
 d9443c01a7336-28e8d88536amr266855ad.0.1759339075033; Wed, 01 Oct 2025
 10:17:55 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250901160930.1785244-1-pbonzini@redhat.com> <20250901160930.1785244-5-pbonzini@redhat.com>
 <CAGtprH__G96uUmiDkK0iYM2miXb31vYje9aN+J=stJQqLUUXEg@mail.gmail.com>
 <74a390a1-42a7-4e6b-a76a-f88f49323c93@intel.com> <CAGtprH-mb0Cw+OzBj-gSWenA9kSJyu-xgXhsTjjzyY6Qi4E=aw@mail.gmail.com>
 <a2042a7b-2e12-4893-ac8d-50c0f77f26e9@intel.com>
In-Reply-To: <a2042a7b-2e12-4893-ac8d-50c0f77f26e9@intel.com>
From: Vishal Annapurve <vannapurve@google.com>
Date: Wed, 1 Oct 2025 10:17:42 -0700
X-Gm-Features: AS18NWBXpvVgjgMadlECNuwDjuYYFm9bGZUjR1YX4j5n77qq4tGA3oiOkJZz2YM
Message-ID: <CAGtprH_nTBdX-VtMQJM4-y8KcB_F4CnafqpDX7ktASwhO0sxAg@mail.gmail.com>
Subject: Re: [PATCH 4/7] x86/kexec: Disable kexec/kdump on platforms with TDX
 partial write erratum
To: Dave Hansen <dave.hansen@intel.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, linux-kernel@vger.kernel.org, kvm@vger.kernel.org, 
	bp@alien8.de, tglx@linutronix.de, peterz@infradead.org, mingo@redhat.com, 
	hpa@zytor.com, thomas.lendacky@amd.com, x86@kernel.org, kas@kernel.org, 
	rick.p.edgecombe@intel.com, dwmw@amazon.co.uk, kai.huang@intel.com, 
	seanjc@google.com, reinette.chatre@intel.com, isaku.yamahata@intel.com, 
	dan.j.williams@intel.com, ashish.kalra@amd.com, nik.borisov@suse.com, 
	chao.gao@intel.com, sagis@google.com, farrah.chen@intel.com, 
	Binbin Wu <binbin.wu@linux.intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Oct 1, 2025 at 7:32=E2=80=AFAM Dave Hansen <dave.hansen@intel.com> =
wrote:
>
> On 9/30/25 19:05, Vishal Annapurve wrote:
> ...
> >> Any workarounds are going to be slow and probably imperfect. That's no=
t
> >
> > Do we really need to deploy workarounds that are complex and slow to
> > get kdump working for the majority of the scenarios? Is there any
> > analysis done for the risk with imperfect and simpler workarounds vs
> > benefits of kdump functionality?
> >
> >> a great match for kdump. I'm perfectly happy waiting for fixed hardwar=
e
> >> from what I've seen.
> >
> > IIUC SPR/EMR - two CPU generations out there are impacted by this
> > erratum and just disabling kdump functionality IMO is not the best
> > solution here.
>
> That's an eminently reasonable position. But we're speaking in broad
> generalities and I'm unsure what you don't like about the status quo or
> how you'd like to see things change.

Looks like the decision to disable kdump was taken between [1] -> [2].
"The kernel currently doesn't track which page is TDX private memory.
It's not trivial to reset TDX private memory.  For simplicity, this
series simply disables kexec/kdump for such platforms.  This will be
enhanced in the future."

A patch [3] from the series[1], describes the issue as:
"This problem is triggered by "partial" writes where a write transaction
of less than cacheline lands at the memory controller.  The CPU does
these via non-temporal write instructions (like MOVNTI), or through
UC/WC memory mappings.  The issue can also be triggered away from the
CPU by devices doing partial writes via DMA."

And also mentions:
"Also note only the normal kexec needs to worry about this problem, but
not the crash kexec: 1) The kdump kernel only uses the special memory
reserved by the first kernel, and the reserved memory can never be used
by TDX in the first kernel; 2) The /proc/vmcore, which reflects the
first (crashed) kernel's memory, is only for read.  The read will never
"poison" TDX memory thus cause unexpected machine check (only partial
write does)."

What was the scenario that led to disabling kdump support altogether
given the above description?

[1] https://lore.kernel.org/lkml/cover.1727179214.git.kai.huang@intel.com/
[2] https://lore.kernel.org/all/cover.1741778537.git.kai.huang@intel.com/
[3] https://lore.kernel.org/lkml/6960ef6d7ee9398d164bf3997e6009df3e88cb67.1=
727179214.git.kai.huang@intel.com/

>
> Care to send along a patch representing the "best solution"? That should
> clear things up.
>

