Return-Path: <kvm+bounces-10100-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id A8FC1869D27
	for <lists+kvm@lfdr.de>; Tue, 27 Feb 2024 18:08:04 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 64AA228D96F
	for <lists+kvm@lfdr.de>; Tue, 27 Feb 2024 17:08:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id ADDE4481BD;
	Tue, 27 Feb 2024 17:07:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="jbKvmj1z"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f180.google.com (mail-pg1-f180.google.com [209.85.215.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 841FD2032D;
	Tue, 27 Feb 2024 17:07:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709053673; cv=none; b=BPgxJ12Pwc2ozZcFOh41YKfklaP91zZbE4tU4xywCp3pvjZz1lFCJ93xAv1VyVyFy59ZEUOLtZYhtRfktQ7+jq//SqXBzFEGBLh70a+NsTAZVknPlA4nFJuSMADErKKZhCUWKLx6dA6dwJOeiqdO72nybuRBFP6VRn15liCE964=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709053673; c=relaxed/simple;
	bh=ZeJc8F1uJuWbjXK4VVGQdxZ+8idBvr+K++iQcOg5o38=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Q4pBYH+z0fvlA6l3nznE/12nU/2Kjju8EfF7bdR751jv0V71VMf0/dK4oCGv3Jm/5pePSTZOjzaTMjh6G+htd4C+bdOqmvyCjr3F8wGdrAOrJYLYVJcjihAVbIfGfmotDYvg2xwTdyFRspUOCTOyAGQdPFoiSaVsg9aSsFHzv8g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=jbKvmj1z; arc=none smtp.client-ip=209.85.215.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pg1-f180.google.com with SMTP id 41be03b00d2f7-5dbd519bde6so3707427a12.1;
        Tue, 27 Feb 2024 09:07:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1709053672; x=1709658472; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=99jfUjuSInpmxbhq4i5jzlqwDHbrA15fgcjI2V7Oals=;
        b=jbKvmj1zc9qWpdruJudh/hR+hxG3T9Bn4wnJi5RoUW4LWDrg+zZe3VIfvoCHx72TM6
         lzwe/jJqkppP7fOBoXuIFKNYyHWfzLxEusLGFSodTPM8UDFh4A3IZXw1IFwijZ+Xub3S
         yp+WpwUccC0e7XAOgGAtEqf/gRd3Eb2LhAtYnQF79z3hTEIpLF1uauoY4yqxYIggrlTI
         87JgK01u9N+n9emYQQdyQLZAu5Tzx/5laG7nOREaS4hFFAN1P3wsuNt61kjf2VuTMOh2
         baQc9y9zaPryCxdmKR8kNpo0Ar3gOhyV2bVl/5kRIjSWkJ0WB4q5Id8dk6+8LV5XgNxB
         Dl2w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1709053672; x=1709658472;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=99jfUjuSInpmxbhq4i5jzlqwDHbrA15fgcjI2V7Oals=;
        b=P/UE8tUrqz8ltYFQFRdVTUKvSzcUD0/QvSXh82hqwp4uJA+qpyRH0JkFz/uTYmxNWb
         XPXbZSUoGLYdpSFxQv7XdrHMNQw40qjG/Di4uGSRYgMVqskWJa6Mm8GJoHShn+qTJVtq
         dZu24JbAOCQKQuaRHkHMkUYeKhLv1Gnr3WhWDDW7e6u/kHw+CdruoBF1t4v5YR9S/XjF
         bdq/+IzelOXOpihwqSD0Y4BNj8lDZn0VW9GlPg8Uty/KmNxY32w4a9T3CTjzvabz7B3O
         /SvRVv1UaLgPmtwPVH+BPkeRt70o1mVvtPdnxvW0fGze3W8iFdNQiZ6Q62PfV54yGFKx
         rlmw==
X-Forwarded-Encrypted: i=1; AJvYcCVxYddWJDt3H2/qSLI2DDqF22A+rAWDMEyXmZ3pqFXjg/P+h7WgXFrfBpR4K/RS4hkg+jskgs3Jg3rNHOEKmF2Q04A9
X-Gm-Message-State: AOJu0YyzIRFlEH62VCPlrjqEgAM7zRnpjCl3bipcAOest1p0etXE2La1
	AO6uvY8yIIw5WZOjOKId3raRLY3JYgFlOfl+TZww1CTlu4Cwe9TfJW/z34EoCtJp3lcZuyhEpbq
	EFJVz/Q9q+7IWjQolH6Bo7aGjlUs=
X-Google-Smtp-Source: AGHT+IHTBLSoZTfa3M5/2UvGsTYIpeCfQhJ06lMLp5v4/09xfG85K0T6kpDQRVpfBDGQ03DtwlARkFL1clgMtD/yIFY=
X-Received: by 2002:a17:90b:8d8:b0:299:3e54:83fe with SMTP id
 ds24-20020a17090b08d800b002993e5483femr8471960pjb.36.1709053671772; Tue, 27
 Feb 2024 09:07:51 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240226143630.33643-1-jiangshanlai@gmail.com>
 <20240226143630.33643-16-jiangshanlai@gmail.com> <Zd34GHtHlnpPtg5v@infradead.org>
In-Reply-To: <Zd34GHtHlnpPtg5v@infradead.org>
From: Lai Jiangshan <jiangshanlai@gmail.com>
Date: Wed, 28 Feb 2024 01:07:40 +0800
Message-ID: <CAJhGHyDdsm3BT4fL3Z_H5-_m4VpDi9FnG6GCcrup6YfMr_MBCw@mail.gmail.com>
Subject: Re: [RFC PATCH 15/73] mm/vmalloc: Add a helper to reserve a
 contiguous and aligned kernel virtual area
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-kernel@vger.kernel.org, Hou Wenlong <houwenlong.hwl@antgroup.com>, 
	Lai Jiangshan <jiangshan.ljs@antgroup.com>, Linus Torvalds <torvalds@linux-foundation.org>, 
	Peter Zijlstra <peterz@infradead.org>, Sean Christopherson <seanjc@google.com>, 
	Thomas Gleixner <tglx@linutronix.de>, Borislav Petkov <bp@alien8.de>, Ingo Molnar <mingo@redhat.com>, 
	kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>, x86@kernel.org, 
	Kees Cook <keescook@chromium.org>, Juergen Gross <jgross@suse.com>, 
	Andrew Morton <akpm@linux-foundation.org>, Uladzislau Rezki <urezki@gmail.com>, 
	Lorenzo Stoakes <lstoakes@gmail.com>, linux-mm@kvack.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hello

On Tue, Feb 27, 2024 at 10:56=E2=80=AFPM Christoph Hellwig <hch@infradead.o=
rg> wrote:
>
> On Mon, Feb 26, 2024 at 10:35:32PM +0800, Lai Jiangshan wrote:
> > From: Hou Wenlong <houwenlong.hwl@antgroup.com>
> >
> > PVM needs to reserve a contiguous and aligned kernel virtual area for
>
> Who is "PVM", and why does it need aligned virtual memory space?

PVM stands for Pagetable-based Virtual Machine. It is a new pure
software-implemented virtualization solution. The details are in the
cover letter:
https://lore.kernel.org/lkml/20240226143630.33643-1-jiangshanlai@gmail.com/

I'm sorry for not CC'ing you on the cover letter (I haven't made/found a pr=
oper
script to generate all cc-recipients for the cover letter.) nor elaborating
the reason in the changelog.

One of the core designs in PVM is the "Exclusive address space separation",
with which in the higher half of the address spaces (where the most signifi=
cant
bits in the addresses are 1s), the address ranges that a PVM guest is
allowed are exclusive from the host kernel.  So PVM hypervisor has to use
get_vm_area_align() to reserve a huge range (normally 16T) with the
alignment 512G (PGDIR_SIZE) for all the guests to accommodate the
whole guest kernel space. The reserved range cannot be used by the
host.

The rationale of this core design is also in the cover letter.

Thanks
Lai

>
> > +extern struct vm_struct *get_vm_area_align(unsigned long size, unsigne=
d long align,
>
> No need for the extern here.
>

