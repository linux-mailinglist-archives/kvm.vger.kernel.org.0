Return-Path: <kvm+bounces-7497-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 77317842D1A
	for <lists+kvm@lfdr.de>; Tue, 30 Jan 2024 20:41:03 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 00E6E282E48
	for <lists+kvm@lfdr.de>; Tue, 30 Jan 2024 19:41:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D2F427B3FD;
	Tue, 30 Jan 2024 19:40:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=dabbelt-com.20230601.gappssmtp.com header.i=@dabbelt-com.20230601.gappssmtp.com header.b="NZ4ZH2Tz"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f171.google.com (mail-pg1-f171.google.com [209.85.215.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F3BED7B3F6
	for <kvm@vger.kernel.org>; Tue, 30 Jan 2024 19:40:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706643655; cv=none; b=jue1UTvfOB8PiKU+ofMijUh/BEee7wGD321OpaACnDIkXWH7moFn/Ip+uCQGn6U6vIXds9gFApZNFiHPNs1cg/ausevPHvKzoUF3WLnfh8X1OoFd/yRnNnbM4OYKLjQhca7ONrNNDNBHDAi4jk5tyGTNQ6TuAVxtOEjpc9bHJhU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706643655; c=relaxed/simple;
	bh=rC6SHJJOEh27ib1elTdvuAgGHYHDCk2hzZWvFEBeQoc=;
	h=Date:Subject:In-Reply-To:CC:From:To:Message-ID:Mime-Version:
	 Content-Type; b=kGgK5RhZT5IL6Ygf1Ao3t0NM58ZIL/iSttQYMDQFmTfsS2v2J+spuEwckpH+ymcM4t1XvlocBvw/zSY9l5z2Xgq6eAGCdReG+nsmrjaAU24gzJT0MSV+FwIU42g7VclCMdKFClmPzKqMTS/pE/locY1avtDRzkIPhNr+0T+hZKg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=dabbelt.com; spf=pass smtp.mailfrom=dabbelt.com; dkim=pass (2048-bit key) header.d=dabbelt-com.20230601.gappssmtp.com header.i=@dabbelt-com.20230601.gappssmtp.com header.b=NZ4ZH2Tz; arc=none smtp.client-ip=209.85.215.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=dabbelt.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=dabbelt.com
Received: by mail-pg1-f171.google.com with SMTP id 41be03b00d2f7-5ce942efda5so3178164a12.2
        for <kvm@vger.kernel.org>; Tue, 30 Jan 2024 11:40:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=dabbelt-com.20230601.gappssmtp.com; s=20230601; t=1706643653; x=1707248453; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:to:from:cc
         :in-reply-to:subject:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=9AW16PRokhMGl06KG1+mzOcMotYScHaSgwc9WRqUlNM=;
        b=NZ4ZH2Tz0lnkM2XeYmm1/yy0w0JfT1pAX2vJCNf+ApYlMXGkDaYAW2yjTq3ustcVEZ
         kcyEXR6iDT2Xnd06YsCqnE5kjkH08yMVUndrg2FPuTTk1Kf+UhjRTcNcEyo/MPsC6yh+
         yZfjfxD5jfZmmESrQpSmSIr4pU1l3BcwacSGwqdh5oC0yZ7xI+WKhzwFd4Ey2By51htW
         zJGoq3wlQL4zseFFq4lR0vPvjJNLdz1mqiPBIJfB6+dYiVSpuOO0tEfKe1BjcemjywEk
         uv63tYBhWHoOF3+dzBJq0qG9x5bs0KdsKlsWIfYeetzG9N9FRpRTec8L7ZaTEMZ1DbaR
         M+hw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1706643653; x=1707248453;
        h=content-transfer-encoding:mime-version:message-id:to:from:cc
         :in-reply-to:subject:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=9AW16PRokhMGl06KG1+mzOcMotYScHaSgwc9WRqUlNM=;
        b=JvFT6ppG0hEWyk3aIB2/QlgD5ly/bOnRo12bU2mc3TMV/ajxGWhtS777WC3hlGPs1i
         j00IPAF/lOslkXq66bSVu6SKjje6QNCM6WJDrrdl+AcGPDCRKyQylZ3IBsHpXjmd4awO
         q5ldtjeYy+QyAuNC88JehuToShqkZzutn9Qq4EngacVRyvpywTaB0GJg43INwTcqrmty
         iltFU9KQL9vtyPxoNvwTiQbWEkVGy3zohmkjC/zsDosuRL8yq4PS8luAkhK2Bse+sEDl
         B/03LkfKs63usl3sl+bthWamF43vHQ38vpb3c8H648BJAdCqamgeI4HTTVrbM5jfci6O
         vFtA==
X-Gm-Message-State: AOJu0Yw6gdkSFKHXpWjszIrxk8KXTHJacSYUWC3tCU4pLfNGOJEVuX4X
	L9spyyu9OlQZYNa4+ThcGFojlTuFDJwZcmTkP/MLVaVUPaobnk0mpLEX/WO8hN8=
X-Google-Smtp-Source: AGHT+IE2ABRPgbWZ1/MDn9OpRWpB/SaUaaTOUydu8QmhFKdM9K+7ePH7kuhrq0irpESYDV32az2H2g==
X-Received: by 2002:a05:6a21:920c:b0:19c:9ce0:6d87 with SMTP id tl12-20020a056a21920c00b0019c9ce06d87mr8460525pzb.0.1706643653109;
        Tue, 30 Jan 2024 11:40:53 -0800 (PST)
Received: from localhost ([12.44.203.122])
        by smtp.gmail.com with ESMTPSA id i26-20020a63541a000000b005cd78f13608sm8579092pgb.13.2024.01.30.11.40.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 30 Jan 2024 11:40:52 -0800 (PST)
Date: Tue, 30 Jan 2024 11:40:52 -0800 (PST)
X-Google-Original-Date: Tue, 30 Jan 2024 11:40:44 PST (-0800)
Subject:     Re: Call for GSoC/Outreachy internship project ideas
In-Reply-To: <CAJSP0QX9TQ-=PD7apOamXvGW29VwJPfVNN2X5BsFLFoP2g6USg@mail.gmail.com>
CC: qemu-devel@nongnu.org, kvm@vger.kernel.org, afaria@redhat.com,
  alex.bennee@linaro.org, eperezma@redhat.com, gmaglione@redhat.com, marcandre.lureau@redhat.com,
  rjones@redhat.com, sgarzare@redhat.com, imp@bsdimp.com, philmd@linaro.org, pbonzini@redhat.com,
  thuth@redhat.com, danielhb413@gmail.com, gaosong@loongson.cn, akihiko.odaki@daynix.com,
  shentey@gmail.com, npiggin@gmail.com, seanjc@google.com, Marc Zyngier <maz@kernel.org>
From: Palmer Dabbelt <palmer@dabbelt.com>
To: stefanha@gmail.com, Alistair Francis <Alistair.Francis@wdc.com>,
  dbarboza@ventanamicro.com
Message-ID: <mhng-bcb98ddd-c9a7-4bb9-b180-bf310a289eeb@palmer-ri-x1c9a>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0 (MHng)
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit

On Mon, 15 Jan 2024 08:32:59 PST (-0800), stefanha@gmail.com wrote:
> Dear QEMU and KVM communities,
> QEMU will apply for the Google Summer of Code and Outreachy internship
> programs again this year. Regular contributors can submit project
> ideas that they'd like to mentor by replying to this email before
> January 30th.

It's the 30th, sorry if this is late but I just saw it today.  +Alistair 
and Daniel, as I didn't sync up with anyone about this so not sure if 
someone else is looking already (we're not internally).

> Internship programs
> ---------------------------
> GSoC (https://summerofcode.withgoogle.com/) and Outreachy
> (https://www.outreachy.org/) offer paid open source remote work
> internships to eligible people wishing to participate in open source
> development. QEMU has been part of these internship programs for many
> years. Our mentors have enjoyed helping talented interns make their
> first open source contributions and some former interns continue to
> participate today.
>
> Who can mentor
> ----------------------
> Regular contributors to QEMU and KVM can participate as mentors.
> Mentorship involves about 5 hours of time commitment per week to
> communicate with the intern, review their patches, etc. Time is also
> required during the intern selection phase to communicate with
> applicants. Being a mentor is an opportunity to help someone get
> started in open source development, will give you experience with
> managing a project in a low-stakes environment, and a chance to
> explore interesting technical ideas that you may not have time to
> develop yourself.
>
> How to propose your idea
> ----------------------------------
> Reply to this email with the following project idea template filled in:
>
> === TITLE ===
>
> '''Summary:''' Short description of the project
>
> Detailed description of the project that explains the general idea,
> including a list of high-level tasks that will be completed by the
> project, and provides enough background for someone unfamiliar with
> the codebase to do research. Typically 2 or 3 paragraphs.
>
> '''Links:'''
> * Wiki links to relevant material
> * External links to mailing lists or web sites
>
> '''Details:'''
> * Skill level: beginner or intermediate or advanced
> * Language: C/Python/Rust/etc

I'm not 100% sure this is a sane GSoC idea, as it's a bit open ended and 
might have some tricky parts.  That said it's tripping some people up 
and as far as I know nobody's started looking at it, so I figrued I'd 
write something up.

I can try and dig up some more links if folks thing it's interesting, 
IIRC there's been a handful of bug reports related to very small loops 
that run ~10x slower when vectorized.  Large benchmarks like SPEC have 
also shown slowdowns.

---

=== RISC-V Vector TCG Frontend Optimization ===

'''Summary:''' The RISC-V vector extension has been implemented in QEMU, 
but we have some performance pathologies mapping it to existing TCG 
backends.  This project would aim to improve the performance of the 
RISC-V vector ISA's mappings to TCG.

The RISC-V TCG frontend (ie, decoding RISC-V instructions 
and emitting TCG calls to emulate them) has some inefficient mappings to 
TCG, which results in binaries that have vector instructions frequently 
performing worse than those without, sometimes even up to 10x slower.  
This causes various headaches for users, including running toolchain 
regressions and doing distro work.  This project's aim would be to bring 
the performance of vectorized RISC-V code to a similar level as the 
corresponding scalar code.

This will definitely require changing the RISC-V TCG frontend.  It's 
likely there is some remaining optimization work that can be done 
without adding TCG primitives, but it may be necessary to do some core 
TCG work in order to improve performance sufficiently.

'''Links:'''
* https://lists.gnu.org/archive/html/qemu-devel/2023-07/msg04495.html

'''Details'''
* Skill level: intermediate
* Language: C, RISC-V assembly

>
> More information
> ----------------------
> You can find out about the process we follow here:
> Video: https://www.youtube.com/watch?v=xNVCX7YMUL8
> Slides (PDF): https://vmsplice.net/~stefan/stefanha-kvm-forum-2016.pdf
>
> The QEMU wiki page for GSoC 2024 is now available:
> https://wiki.qemu.org/Google_Summer_of_Code_2024
>
> Thanks,
> Stefan

