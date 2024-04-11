Return-Path: <kvm+bounces-14352-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 186518A2131
	for <lists+kvm@lfdr.de>; Thu, 11 Apr 2024 23:56:54 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id C922C288C8D
	for <lists+kvm@lfdr.de>; Thu, 11 Apr 2024 21:56:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C17C43CF72;
	Thu, 11 Apr 2024 21:56:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="ffomuWUC"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f202.google.com (mail-pg1-f202.google.com [209.85.215.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C9C74D53C
	for <kvm@vger.kernel.org>; Thu, 11 Apr 2024 21:56:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712872602; cv=none; b=UYS7AEJHDPrcER7qIDQDa3p/xpvHYWKNr/V8V/2qtSISZTzyxYc41ILoLIPh/X/0ohTd3ca9CG2newQEpCQJ8Y7L7ZQ45SzDDj9r6ak/3y2GISXNRgBwX/he/QzGRC6YOb9XSpChe58bNOsqKasYa+4YsU5XMWCyf/Ld0czU8cE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712872602; c=relaxed/simple;
	bh=5IskHx1Alp47+xsPcKeN3SCTGFddMnlcEHREVJpqLRY=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=PxHzFsHmJ+epsxG6F40DJesBJIldX/EoO+NH/ezKLUr0ld+5PFXoBBv8jV9pZt2ilUoIhZ80toCdw6RjQHNSfs8HyrWfGHiapDRRxB5Qfas22D/O2kDoaNNzaKk2o5J2k5JqBr3GRZxfwaYMuVuY2qQFau+xQ/ZFTAsWmJLNULY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=ffomuWUC; arc=none smtp.client-ip=209.85.215.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pg1-f202.google.com with SMTP id 41be03b00d2f7-5c65e666609so275172a12.1
        for <kvm@vger.kernel.org>; Thu, 11 Apr 2024 14:56:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1712872600; x=1713477400; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=2l7nkr1/AkcgDi+i114FYV92kBj0GcgXVLsLHaB4i3Q=;
        b=ffomuWUC57kRC245jJ56gKBxolzmpFuvunAO9TsWS0ivrYTLgWPk+GCsXGuJfxqJDJ
         uXpkH4vGXaRZ1ZPH4IxtKHgZHb3Hilll9pR+mDnV6TcU+vlS0DSZpZy1V4Dymb6fIHG2
         trpgoZBy3YnHSOqVnEqkKwrKTf8SfheH6x2v1Hxp72m+ctRYAxy9VFXJwjlo6N7fLfgE
         Dkoys1PDB4CU5CHfq/6iGUipLWCw1CoNa+SMEub2PQ7XU6pK+KBlO1Bxxnr1OFs4XHeQ
         wwoT9xXlZWq6YzsCIDT11Z1lOUHI23TWIEz6hlazTsx8zddu7uuOagTYlyLqNcGBrgRa
         38mg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1712872600; x=1713477400;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=2l7nkr1/AkcgDi+i114FYV92kBj0GcgXVLsLHaB4i3Q=;
        b=N/81Ak3zJc8B6pDqNNjb42oIpFnIDMkwnNTfn+1BHmIOfCnX8OGq7ztHOXYR8u+ScB
         lAxYtDHuR5GFH0Nz2GnrnS0r2q+3LFtWqaB+V7OpZEbZCF13b8vG38PaWTMGkD8mcQQ+
         nGBTXtn60L6eDXJp5GRUU2gZqrQC+X+Vqkb8n4ZBmFFy6//3jvwqbNOLIv3n65ft6Dpa
         SBZzWRGimJKy5YtWLh1uLAZX8z8j/fgcwxR5sCXGXD8m6qERWkir/A6ANeYVFm2E0oG4
         WSVOoNUIXUGaOjOhmy5ggHOm4gAKSOxmK4r5uXmuoNhHXNzBAbz3oPVPFJgXktj2g+cM
         Q5pA==
X-Forwarded-Encrypted: i=1; AJvYcCUN90WfDiTveyLv1F/T47CcJ/eJlUIk+QVjxstSTSMaHYsv68YPK3zu97JLhNIcnlJ2c+C5dzAGL86y4V3p104Ay4PU
X-Gm-Message-State: AOJu0YyHx8EdAy5FhIZYA+gIdKYrsm/d/cNKa9ArTWG7RK7pmriEkdV0
	GD6SjAGqZnq80YZOwtVXDoYOODExw6ACTh8iqAgXfdbXBxtLzsSO6Tdsy+PJLFX6xo45U9QqlLZ
	CiA==
X-Google-Smtp-Source: AGHT+IGkE+X2zxbr1hHNUpWg21uobjE0x+B1Mp3y6MyplpSZTK7tHQrQsbMRcsPEdX3tPdwzxY1iWabyoHQ=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a63:7157:0:b0:5f0:5034:1c21 with SMTP id
 b23-20020a637157000000b005f050341c21mr2010pgn.12.1712872599915; Thu, 11 Apr
 2024 14:56:39 -0700 (PDT)
Date: Thu, 11 Apr 2024 14:56:38 -0700
In-Reply-To: <20240126085444.324918-37-xiong.y.zhang@linux.intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240126085444.324918-1-xiong.y.zhang@linux.intel.com> <20240126085444.324918-37-xiong.y.zhang@linux.intel.com>
Message-ID: <Zhhclu4VP3DDiPJM@google.com>
Subject: Re: [RFC PATCH 36/41] KVM: x86/pmu: Intercept FIXED_CTR_CTRL MSR
From: Sean Christopherson <seanjc@google.com>
To: Xiong Zhang <xiong.y.zhang@linux.intel.com>
Cc: pbonzini@redhat.com, peterz@infradead.org, mizhang@google.com, 
	kan.liang@intel.com, zhenyuw@linux.intel.com, dapeng1.mi@linux.intel.com, 
	jmattson@google.com, kvm@vger.kernel.org, linux-perf-users@vger.kernel.org, 
	linux-kernel@vger.kernel.org, zhiyuan.lv@intel.com, eranian@google.com, 
	irogers@google.com, samantha.alt@intel.com, like.xu.linux@gmail.com, 
	chao.gao@intel.com, Xiong Zhang <xiong.y.zhang@intel.com>
Content-Type: text/plain; charset="us-ascii"

On Fri, Jan 26, 2024, Xiong Zhang wrote:
> From: Xiong Zhang <xiong.y.zhang@intel.com>
> 
> Fixed counters control MSR are still intercepted for the purpose of
> security, i.e., preventing guest from using unallowed Fixed Counter
> to steal information or take advantages of any CPU errata.

Same comments as earlier patches.  Don't introduce bugs and then immediately fix
said bugs.

