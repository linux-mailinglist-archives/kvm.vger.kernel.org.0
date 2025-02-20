Return-Path: <kvm+bounces-38686-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id C1F49A3D9AB
	for <lists+kvm@lfdr.de>; Thu, 20 Feb 2025 13:18:22 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id D14B7189E71E
	for <lists+kvm@lfdr.de>; Thu, 20 Feb 2025 12:18:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 166851F55FA;
	Thu, 20 Feb 2025 12:18:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=brainfault-org.20230601.gappssmtp.com header.i=@brainfault-org.20230601.gappssmtp.com header.b="SF0fAFAs"
X-Original-To: kvm@vger.kernel.org
Received: from mail-io1-f50.google.com (mail-io1-f50.google.com [209.85.166.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B22E61F428C
	for <kvm@vger.kernel.org>; Thu, 20 Feb 2025 12:18:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740053883; cv=none; b=Ykkc1qO3G8xVqWb9OJi+RzhY5Yx3FLI0q+1ID4KQdCL8f28TB1YxZ+QyYwchnlc7sP0bpIWT8xK80H/yOMh5a3oRflH9aBIl8NI2PwQXd81CTiFV1by/9X2P5hQIBZAgZWO3dyODw+jUdHLhgRwVio6hLVMRJf4iireTRWW2iXM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740053883; c=relaxed/simple;
	bh=6m3pn5teB6D33EiP9PjyRNzHejwBzfVH65xximy5EQU=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=p3BFETxeyPfPldzs1jF12PK6XGuJw8PkTZdSyIOoOmpe8PBXZfTuZEym1A/Rv7PfbEFjNkUrsacAd6Hx8PVe9IMWQUzfyf5RIH0HBr4hatbnP1O4JkzM2p8+SPDLqPE7oSIYzg11jwrGXe0XQKex7DvAavIm6r2EuHXZLb0RVaI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=brainfault.org; spf=none smtp.mailfrom=brainfault.org; dkim=pass (2048-bit key) header.d=brainfault-org.20230601.gappssmtp.com header.i=@brainfault-org.20230601.gappssmtp.com header.b=SF0fAFAs; arc=none smtp.client-ip=209.85.166.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=brainfault.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=brainfault.org
Received: by mail-io1-f50.google.com with SMTP id ca18e2360f4ac-855a095094fso22242439f.1
        for <kvm@vger.kernel.org>; Thu, 20 Feb 2025 04:18:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=brainfault-org.20230601.gappssmtp.com; s=20230601; t=1740053881; x=1740658681; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=rmI+w9rW7xuxQgzQY4zgyZiBf+VpYD43wlkF4w4/Fxk=;
        b=SF0fAFAss56S5/kldJcO5bNJILxkssyS1ga/tzhkdUQFpBVB590jWwLiJ7+E/iAuQU
         3JGWKPr81N7OzTonmnzjWbQqGsxt/mHQyDEBAG2Hr/+1aOON3SIX8PppB8LcXfoLqQwP
         vKkT8Ald8KMtl9lkMRI2B0j/83OK6smXaFF8vr8SCA9fkSXNh8DpG5uOZJ813LUTNvnc
         iC1BLBzzb+W0sa0z1wDPV2Yr7Y9ZC+9MutpF+5yUvTXEIJojFqC/QWA8ZivI0IlamuAi
         xtf428dOypj71Ev8mcTG3ZvvDS4+h3CcwX5HyQuohPeE4NQlI/Y71jx1O7K6aJ77H9RY
         EldQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1740053881; x=1740658681;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=rmI+w9rW7xuxQgzQY4zgyZiBf+VpYD43wlkF4w4/Fxk=;
        b=rAdzur/fgWgAqfWJPwjufo37HipFJckkENs1z0TAXrD7QDBDRH9RFDG/7n8y19RP+A
         RUvXUNzOH3By4/zKjgHECZRpSBLAaGvjEfg3Uvly72ttImvkMvOGF4MDP1/XUcyXCW3J
         lQiusZFMXF/yjbHXcrmEJ6slYcMHjeI5f+NHCsLg0g1DsHt2gzohxrgNM1IglVq/M2bC
         HTOod4jMasjb/b8mWZaOGW8uGbXBk2oGLXuWc2WbBltdG+PMhE4IvC8iteN341WOr0/s
         km4r0lPekB5kirHzYs0esMhZTMtq4if5Qk0JbIZSYFuc8mjbllUe1Vo2pVzk/zbZlMq5
         Lbfw==
X-Gm-Message-State: AOJu0YwsOpWa9P/fmTcjJ0nJqWoOItU1AOakFmxnGlor/ALIQizRA0SS
	LR7/FIWbJi16TEs1HZ+brq9SkTkGc1lNjdmef/b5Tn5sPVNKSD3Jd+J7oK2gevYZv8dkrjECNMl
	yaaod/pGwvOkMWlsFgYXhJ7dJPuiwx7NuMXGL4w==
X-Gm-Gg: ASbGncta0r4buL1JIh/bBxnBIEwYThbEuYFAa3veI6ky+plSkVJGXVdlUof3paOz/oE
	1DBx6AnXtnKlOOO6Xnrz8G48CKBobWWJ9HMU/CrQ5KtfxdyjVU5+46aEEwMkVTjqxeYAFDjegHw
	==
X-Google-Smtp-Source: AGHT+IHL3+9MtLF5+UaRybyEp8BV4Gc3bjSjy3kw4hdoypBWleJFfSGz7eyOLjRCOfAS7PzLJ2idDqWgGFTRfAm5dPo=
X-Received: by 2002:a05:6e02:152d:b0:3d1:9236:ca52 with SMTP id
 e9e14a558f8ab-3d2b5131279mr59896385ab.0.1740053880695; Thu, 20 Feb 2025
 04:18:00 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250217084506.18763-7-ajones@ventanamicro.com>
In-Reply-To: <20250217084506.18763-7-ajones@ventanamicro.com>
From: Anup Patel <anup@brainfault.org>
Date: Thu, 20 Feb 2025 17:47:49 +0530
X-Gm-Features: AWEUYZmV63eOiG44RnPBMnqx1Uo6sIZHLWWs9x29seXyEVn1h53Dh8XbVUUsj0U
Message-ID: <CAAhSdy0cqoN5MehwDtQEtK7EYSTXPekwYEJWgPvAK+Y4uk=40Q@mail.gmail.com>
Subject: Re: [PATCH 0/5] riscv: KVM: Fix a few SBI issues
To: Andrew Jones <ajones@ventanamicro.com>
Cc: kvm@vger.kernel.org, kvm-riscv@lists.infradead.org, 
	linux-riscv@lists.infradead.org, linux-kernel@vger.kernel.org, 
	atishp@atishpatra.org, paul.walmsley@sifive.com, palmer@dabbelt.com, 
	aou@eecs.berkeley.edu, cleger@rivosinc.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Feb 17, 2025 at 2:15=E2=80=AFPM Andrew Jones <ajones@ventanamicro.c=
om> wrote:
>
> Fix issues found with kvm-unit-tests[1], which is currently focused
> on SBI.
>
> [1] https://gitlab.com/jones-drew/kvm-unit-tests/-/commits/riscv/sbi
>
> Andrew Jones (5):
>   riscv: KVM: Fix hart suspend status check
>   riscv: KVM: Fix hart suspend_type use
>   riscv: KVM: Fix SBI IPI error generation
>   riscv: KVM: Fix SBI TIME error generation
>   riscv: KVM: Fix SBI sleep_type use

Queued these fixes for Linux-6.14-rcX.

Regards,
Anup

>
>  arch/riscv/kvm/vcpu_sbi_hsm.c     | 11 ++++++-----
>  arch/riscv/kvm/vcpu_sbi_replace.c | 15 ++++++++++++---
>  arch/riscv/kvm/vcpu_sbi_system.c  |  3 ++-
>  3 files changed, 20 insertions(+), 9 deletions(-)
>
> --
> 2.48.1
>

