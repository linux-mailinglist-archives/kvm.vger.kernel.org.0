Return-Path: <kvm+bounces-32205-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 6ED159D4214
	for <lists+kvm@lfdr.de>; Wed, 20 Nov 2024 19:34:53 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 35211282734
	for <lists+kvm@lfdr.de>; Wed, 20 Nov 2024 18:34:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 13DB81BC068;
	Wed, 20 Nov 2024 18:34:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="JksuflpP"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yw1-f202.google.com (mail-yw1-f202.google.com [209.85.128.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DDB81156879
	for <kvm@vger.kernel.org>; Wed, 20 Nov 2024 18:34:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732127662; cv=none; b=mj5UZD12oXsG5/V+jveLgEys/UdCJtD/n3DungCX42FBkkyKFOi5zisnPB0esL7rASlKntcD4zZPwHFPE27Ri+BkDztCZ/oJUJoB4ngUNeVG/A9KV9zIbehi1OvldG2PDk6iRc3oMpLtTKJ+jxsQhxEQZ/GxbxAMM1ztURVYwb4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732127662; c=relaxed/simple;
	bh=0hdYlPl5kdxITeyO/ldXg8jFICnnm/O/reo7eK65D30=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=aMCeQL5NiFKFceYqRmprQMTF//0SIm6XXk4CkrGlNa8Rscmq8YAv2GfOXUy8OqxIryZ5vd+uHO5tOowCwFsjOrsPrttbQDoztfrVuClyNc67ierEddTTmXzqjnAuIyW6UxxJNFT+15IQT9eBkGYA0qkgAN9IUGyIZF6N0IGVnN4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=JksuflpP; arc=none smtp.client-ip=209.85.128.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-yw1-f202.google.com with SMTP id 00721157ae682-6e9d6636498so95253067b3.2
        for <kvm@vger.kernel.org>; Wed, 20 Nov 2024 10:34:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1732127660; x=1732732460; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=Shk5YfZWIn8Bu2YoYX+m4i77URe0OKtBvNQtklX8oko=;
        b=JksuflpP0X520U2xNrsEdKRpXdC3HAvI5jr3UKcQUK5iWNPHS3LYdhEBlA13/bSqru
         Sx6CzVxU3s3TA0xIQ00s/wB2gH30t7IhyEI3G4XwxmzgzsTU/7w7RzgBYvyo1+HJIjB5
         gsITyt3hwJwKRJK2qBzEgYLYk+493y3cSRnPsRJ1HsMML3BDZevJXwPJLcL4ObI59/wI
         8XwFT4D7jiqcc0JjZFUVcLgzi1uAMEtWSnT7TS9031+D5bu8fGwoNpXilAcXh2Hw+Ebs
         yaX93zjlIoIhUhEOhECjzwFTIXTNyTVDZtLSup1m72AJaRYw3Ap00MBwBdXC2h/vDBMw
         3Uig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1732127660; x=1732732460;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Shk5YfZWIn8Bu2YoYX+m4i77URe0OKtBvNQtklX8oko=;
        b=I0HEaLswsz6EFwSEdc0ZpW6666dx7mRvJ23xI9s5zykMHEGAXAkdVRsq1vU5mK91Bk
         ib41r5WXG0FW0bldtbiq89gwPZRJLVh+AcV+YnimM5VF5VMpEKzrT51lbrmG5ukNY8py
         bQ16aTJwb2JGubPUT76WvZ1/7FaXj4upQK7+yJwxBK97GxzUKamxU9jju9MykbHDklDN
         5CHyHhePyrvxI8gxaik5JE9O3r1h7KzQI18ED0vg7LEJ47SNlNaly43JEbtOQ87JRseQ
         Rkw6RqTiTKABPQNJG3ijE00i2v23iST4dwUJD+zLLcv6i/nBKaKnKHSPXhQCnRlnKARO
         7ejw==
X-Forwarded-Encrypted: i=1; AJvYcCWuuwrJ2wmzX5M8S48hBKMRb/8igXPluGVKFDtQB/1NeXnumfmp53SWqU+zLcajZfH/t6Y=@vger.kernel.org
X-Gm-Message-State: AOJu0YydAgBJ/m6JGgHl9cxmZ9GHZZecBBAEfAkI13BBz1j3QMT7ZAf6
	eMwr/FjX5Eqg+8Jsop0eI/YGtxPfinyCcKhApCqeKMnFPY/LXaVGfmpPrN6+mpd1WUpcvuU9+/T
	hvw==
X-Google-Smtp-Source: AGHT+IGFsJ+zg5lKx6s1J17TzwGaH5HlpDBXYOqJF08NC3M/54KnNON9WXJ42ZjtHdvxB0LAWQzYddinkOg=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:9d:3983:ac13:c240])
 (user=seanjc job=sendgmr) by 2002:a05:690c:2f85:b0:6e2:1713:bdb5 with SMTP id
 00721157ae682-6eebd275a61mr17917b3.5.1732127660016; Wed, 20 Nov 2024 10:34:20
 -0800 (PST)
Date: Wed, 20 Nov 2024 10:34:18 -0800
In-Reply-To: <d99691ff-906d-4209-9636-4b18915e1afc@linux.intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240801045907.4010984-1-mizhang@google.com> <d99691ff-906d-4209-9636-4b18915e1afc@linux.intel.com>
Message-ID: <Zz4rqqexdOkmHHAX@google.com>
Subject: Re: [RFC PATCH v3 00/58] Mediated Passthrough vPMU 3.0 for x86
From: Sean Christopherson <seanjc@google.com>
To: Dapeng Mi <dapeng1.mi@linux.intel.com>
Cc: Mingwei Zhang <mizhang@google.com>, Paolo Bonzini <pbonzini@redhat.com>, 
	Xiong Zhang <xiong.y.zhang@intel.com>, Kan Liang <kan.liang@intel.com>, 
	Zhenyu Wang <zhenyuw@linux.intel.com>, Manali Shukla <manali.shukla@amd.com>, 
	Sandipan Das <sandipan.das@amd.com>, Jim Mattson <jmattson@google.com>, 
	Stephane Eranian <eranian@google.com>, Ian Rogers <irogers@google.com>, 
	Namhyung Kim <namhyung@kernel.org>, gce-passthrou-pmu-dev@google.com, 
	Samantha Alt <samantha.alt@intel.com>, Zhiyuan Lv <zhiyuan.lv@intel.com>, 
	Yanfei Xu <yanfei.xu@intel.com>, Like Xu <like.xu.linux@gmail.com>, 
	Peter Zijlstra <peterz@infradead.org>, Raghavendra Rao Ananta <rananta@google.com>, kvm@vger.kernel.org, 
	linux-perf-users@vger.kernel.org
Content-Type: text/plain; charset="us-ascii"

On Wed, Nov 20, 2024, Dapeng Mi wrote:
> Hi Sean,
> 
> Do you think we can remove the "RFC" tag in next version patchset? You and
> Peter have reviewed the proposal thoroughly (Thanks for your reviewing
> efforts) and it seems there are no hard obstacles besides the
> implementation details? Thanks.

No objection on my end.

