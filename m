Return-Path: <kvm+bounces-64979-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ams.mirrors.kernel.org (ams.mirrors.kernel.org [213.196.21.55])
	by mail.lfdr.de (Postfix) with ESMTPS id 22A0CC95867
	for <lists+kvm@lfdr.de>; Mon, 01 Dec 2025 02:44:55 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ams.mirrors.kernel.org (Postfix) with ESMTPS id 97B6A34230D
	for <lists+kvm@lfdr.de>; Mon,  1 Dec 2025 01:44:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 26B85158DA3;
	Mon,  1 Dec 2025 01:44:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="O1EJhfMT"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f170.google.com (mail-pl1-f170.google.com [209.85.214.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EB07881AA8
	for <kvm@vger.kernel.org>; Mon,  1 Dec 2025 01:44:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764553487; cv=none; b=ePP0mxuZ7FZ29wHCGQyv8AiipDoXIOykm8da/AoU58maq8MneSY8ztAjYGEOqdE4lLT24r3rS/wosY8f+qtM38SarIJ3eGhvjZLlWSBx01Pd6bsHSMva/sYN0M2Zrp8eYcrksxu2kJqC/jbxrDPiK76ZTtV/nXrh+hinyETAVmo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764553487; c=relaxed/simple;
	bh=XXjK9G/6yVP87R7EES41vVBqCFfsiZh7q+9DV7eI7Lg=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=UjHrvsLZfVpjQn+3FJhNiC38v4qbVxVNwXWNfSaq4biauuQzW33l8wDX91UFg7bmpCVAlnXJYgBaFj8Ca6bu72Hwum3oNulbXhRAwq+D3h0MuCjFL1+wVLY2BmzTh7zvn8K280yp7phdEq17P4/TCgk5YDskw+ikG08qwJVO9qQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=O1EJhfMT; arc=none smtp.client-ip=209.85.214.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-pl1-f170.google.com with SMTP id d9443c01a7336-29852dafa7dso623415ad.1
        for <kvm@vger.kernel.org>; Sun, 30 Nov 2025 17:44:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1764553485; x=1765158285; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=XXjK9G/6yVP87R7EES41vVBqCFfsiZh7q+9DV7eI7Lg=;
        b=O1EJhfMTlBTBXs7FJtExvtTNPZ5yfp/RhLK+I5iXzmviQFhwFQVMavrfqrh75UDHU0
         k7tNzhlCHdsyPwJi7rvL93qw0zZqKUTaUvHda5XkFqzIIy65pW+URy1NmKLpJZG+fj8/
         zGogY9MimkCTKPF7PowVc5qIJv5nPn3EORb8kXnz+Fepw6Rp4oC7AbaP7fQQNlwlfzet
         1pnn2tbRKHgaFm6HOaD/gcOYBQLcNKOM/CGl4YuMQQlyFD2AlPwh5hAJuutBP7OCfOTt
         5f6+O2HiDWl87DgzObqz+Ru7ZThcNd2LbwezPv+MkHeHF3+PHS67M5sn6aIs7m3G6xcG
         rWAw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764553485; x=1765158285;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=XXjK9G/6yVP87R7EES41vVBqCFfsiZh7q+9DV7eI7Lg=;
        b=N8LPb9scs+fa02JavoYdIDvO5fqnQNQjAPEWAo0NW8sEAX/pzu8IMJc6LpDBItAyu0
         35XuxU7OVjaPrfXFuxD74x3ILDdizGK0GqYIGBhutM8+1dBWVhokGWRskrIkYeUB+6lC
         TG6VNmUhRQc5U3pVye4KoCniHp6V3NvMq1oNRNZkiF1T4UZiaOcJSj9Opto8+nxPo3J8
         FR7tJ6I38D/xy3LNO/8xe1VmWBBwHRCzUfKebIHTKthYXAjVQEvJUaT7HHApNU8+2k5h
         FV13kQypGqlTWEhwfTS1vCXFZVatMKHhgeUynwtW6sNi0Kv/9U13ix1/Gk8xX1FneSXu
         bYBw==
X-Forwarded-Encrypted: i=1; AJvYcCWsZ27PEVjSf6Jf7qCA7hjaG3B0PORxbK9e0LDmaevE0/MqJxtMKctDl+gN/CVQOpyyGoY=@vger.kernel.org
X-Gm-Message-State: AOJu0YyIgvgRJGWzOuREnxW/jZ14No/NS0/jVIUyTQWMpVi03gU7ScyR
	W1pMiq+w2nCCRnbqpr9XgF9LjlIkFO7kubBPZeBv91e6jJvul8xoWYaCiMu7bCfC9Wek6y0oRuN
	qEVxJHAHksaXFEdZ8BWCGxNpAy9L8WEOsjMLWBrlb
X-Gm-Gg: ASbGncspQIy/4Y9iiZ6jD7zavxhApe2lo+KPFEBWRfS3ZRK0sTFjK3YZCIYWSVhrdM7
	LeRcNxplsczpoa6EW4g0hZDSOX5X9EC5krGlp4PK4Bp2MDOqLiUdjyqRRHy75bwdKu31AW2t6AF
	YY3wF+pLApSOxOPHdeXcehs+chsE4ZeKvYxnXk9XODH0CljtTe8Xl0lmMv+t38weXuF5vAHF87f
	LMTMxs/HsldOZtvUVV3jvdEdIKzaUyM/Y9JDxXrNaeRkYaEOHKTksvPr293dBLhBJGyxtpv6oTs
	MLn3QexSxHPif461gkR5BBPshnmj
X-Google-Smtp-Source: AGHT+IGVdSi91XFWN15kFPtoKM7WWzNM62D2CelcHdnZr/ei9NXQxiXmZnu+94y9qAsgrliHk3AbI8g7Jygo19QMqI4=
X-Received: by 2002:a05:7022:f902:10b0:119:e55a:808c with SMTP id
 a92af1059eb24-11dc9c5d1f3mr233294c88.9.1764553484484; Sun, 30 Nov 2025
 17:44:44 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20251113230759.1562024-1-michael.roth@amd.com>
 <20251113230759.1562024-4-michael.roth@amd.com> <aR7bVKzM7rH/FSVh@yzhao56-desk.sh.intel.com>
 <20251121130144.u7eeaafonhcqf2bd@amd.com>
In-Reply-To: <20251121130144.u7eeaafonhcqf2bd@amd.com>
From: Vishal Annapurve <vannapurve@google.com>
Date: Sun, 30 Nov 2025 17:44:31 -0800
X-Gm-Features: AWmQ_bkAp7M4RY7KhmAYC2tjQ6Yi5K4jbimiP8co_ZGiovyYBjjsYMzWDYgBcYo
Message-ID: <CAGtprH8gznGJ6VObk8aShBn_XnhwDoUzyzTkaDAe+MyiNsJ-NA@mail.gmail.com>
Subject: Re: [PATCH 3/3] KVM: guest_memfd: GUP source pages prior to
 populating guest memory
To: Michael Roth <michael.roth@amd.com>
Cc: Yan Zhao <yan.y.zhao@intel.com>, kvm@vger.kernel.org, linux-coco@lists.linux.dev, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org, thomas.lendacky@amd.com, 
	pbonzini@redhat.com, seanjc@google.com, vbabka@suse.cz, ashish.kalra@amd.com, 
	liam.merwick@oracle.com, david@redhat.com, ackerleytng@google.com, 
	aik@amd.com, ira.weiny@intel.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Nov 21, 2025 at 5:02=E2=80=AFAM Michael Roth <michael.roth@amd.com>=
 wrote:
>
> >
> > Increasing GMEM_GUP_NPAGES to (1UL << PUD_ORDER) is probabaly not a goo=
d idea.
> >
> > Given both TDX/SNP map at 4KB granularity, why not just invoke post_pop=
ulate()
> > per 4KB while removing the max_order from post_populate() parameters, a=
s done
> > in Sean's sketch patch [1]?
>
> That's an option too, but SNP can make use of 2MB pages in the
> post-populate callback so I don't want to shut the door on that option
> just yet if it's not too much of a pain to work in. Given the guest BIOS
> lives primarily in 1 or 2 of these 2MB regions the benefits might be
> worthwhile, and SNP doesn't have a post-post-populate promotion path
> like TDX (at least, not one that would help much for guest boot times)

Given the small initial payload size, do you really think optimizing
for setting up huge page-aligned RMP entries is worthwhile?
The code becomes somewhat complex when trying to get this scenario
working and IIUC it depends on userspace-passed initial payload
regions aligning to the huge page size. What happens if userspace
tries to trigger snp_launch_update() for two unaligned regions within
the same huge page?

What Sean suggested earlier[1] seems relatively simpler to maintain.

[1] https://lore.kernel.org/kvm/aHEwT4X0RcfZzHlt@google.com/

>
> Thanks,
>
> Mike

