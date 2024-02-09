Return-Path: <kvm+bounces-8449-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 5930384F953
	for <lists+kvm@lfdr.de>; Fri,  9 Feb 2024 17:08:39 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id E2B6B295228
	for <lists+kvm@lfdr.de>; Fri,  9 Feb 2024 16:08:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 749D1762C5;
	Fri,  9 Feb 2024 16:08:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=brainfault-org.20230601.gappssmtp.com header.i=@brainfault-org.20230601.gappssmtp.com header.b="dsjFcntU"
X-Original-To: kvm@vger.kernel.org
Received: from mail-il1-f177.google.com (mail-il1-f177.google.com [209.85.166.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1A56A692FC
	for <kvm@vger.kernel.org>; Fri,  9 Feb 2024 16:08:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707494910; cv=none; b=V1DEim1Psj7uB7Xs+M77Oq+T3gyHWCvaYeqQ4nAimz4qyZwbuI7JP0Rnb78jVJVkRbxwxjZqaxrs7zjB/VsK3mo/gr9H0kGIaza47g3rPzBJQEsksgoDNewvaIGatbCUgk+Ug3QjVSbYR308k0PKPA30TdUqEozCBPhBpaW5rIc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707494910; c=relaxed/simple;
	bh=q4AMtbqMWlX/OS5J0yZNzS2xaqo6tru3E7QaZJm0UNs=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=aAtGdqmoPS1jMIVt5uHw831gQMq4WohIcpQik+P36ZmFOCpAGkvdpo2HU8xc2wX20ti9eFOf0eLGjnTKhk+kMKQ1gqey1lNjquX2+xgK6Omu84ZmOroOZ/LUgX5vdSCtowsIgWC9reeAis2MXzw1XoFrHxzWnB/jTNcHBiM9+4g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=brainfault.org; spf=none smtp.mailfrom=brainfault.org; dkim=pass (2048-bit key) header.d=brainfault-org.20230601.gappssmtp.com header.i=@brainfault-org.20230601.gappssmtp.com header.b=dsjFcntU; arc=none smtp.client-ip=209.85.166.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=brainfault.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=brainfault.org
Received: by mail-il1-f177.google.com with SMTP id e9e14a558f8ab-363bdac74c6so2984415ab.2
        for <kvm@vger.kernel.org>; Fri, 09 Feb 2024 08:08:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=brainfault-org.20230601.gappssmtp.com; s=20230601; t=1707494908; x=1708099708; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=dtPLBbzjZUT/qOG6Yo9WvOQvfXAWlE2ItdHxREdxSVs=;
        b=dsjFcntUkLX4HTRu1V/KK8YT6I4w/haqBQWUIXWi6YLBj9LnFTDjWGKN/Ryidyj38h
         6Wb6sh5tcaZbXMNn6YpKdb6BpfyM8UKrbXSu6g5wZIIyMKUbIpAPCGrpz7rhIH0k3hGT
         /wyk5Ufhp6az52Q009GMESNsbtonsvSO+9waa9fAjD7lChXkhjg6xKK3qO8US27EaZSv
         CnQIKczirRBfgFddhcUpVb7Na6IPfIECtF+PO1pQ55pRY9vVIevJN0E0toxcoAZqb0Ai
         j49nuMTElp2GWfIrbCcnslFdf3eCRRFkRVTZkpU/a95wBu933FHa2TVsW2Lasx4B9umq
         z6JQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1707494908; x=1708099708;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=dtPLBbzjZUT/qOG6Yo9WvOQvfXAWlE2ItdHxREdxSVs=;
        b=ZV5ud8AOOlTgjLlrlD1fEhlK+ULExbpnwVJooaJkLQg9MYF4vSc3ij0RY7XKHUgmzH
         rK9TwrkYRVMgpjODzulqzjEgBdQkJZSMhBkn3iAvj6Yf+IeyFj66BmbRvsrsMWHItRkD
         H4KtKV+fTQIgJoemH5r+EZ5h8epkH6uW1+pwSDmCoQ5qBqQKZxksl7hYYG+iXEWYELtd
         4PkL+n5IUlFtASxIvWwcI8AaWYG+DRSeEPW5t8pY+g/oqKDy+C6LNqOpyZLY+hA8yprx
         o2+RN7CWwSOdO7L9wEcI1FGPHc0SCEAhx1MXranY2Xcwuo+4ijfnI7/ZvhPB5mwUt/Hf
         pixg==
X-Forwarded-Encrypted: i=1; AJvYcCX7WZxIUFHk6edWQSU6Sp1QOuHJi8IX36p/r2WXLBhy/owO6Wsz91XHXfs1kVmr+maEnZNjalGvch1DM2SxctqUV5GF
X-Gm-Message-State: AOJu0YzAL0KJ4cVSpHMy/BUesaSqj7Qar7WkIwvOabOE0ik7dXtmgcNO
	dQJ4VQILBD9f9guHPR2/SibwIxUsxjNsY5XAoQY2JZ74pQZOUTbt3wkXEDbqBym3S/n3B5uYF9/
	0Iwr1soVRNAn+rf5z1bk5O594mF0I1Sq721bjnQ==
X-Google-Smtp-Source: AGHT+IFtJ01s8UHyYjfjtz3TsBI5mD3Kx8Rd/d2nTPfifxIiqiPYl2X3K+FPVNtpaos54aQDa8V+dCskQKhTMKa2RYQ=
X-Received: by 2002:a92:d24a:0:b0:363:c3c2:594 with SMTP id
 v10-20020a92d24a000000b00363c3c20594mr2248865ilg.1.1707494908195; Fri, 09 Feb
 2024 08:08:28 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20231128145628.413414-1-apatel@ventanamicro.com> <170749352335.2620327.13138913157188078368.b4-ty@kernel.org>
In-Reply-To: <170749352335.2620327.13138913157188078368.b4-ty@kernel.org>
From: Anup Patel <anup@brainfault.org>
Date: Fri, 9 Feb 2024 21:38:15 +0530
Message-ID: <CAAhSdy3uVw6jh44s76UeJHMyMNr3Tqf5sZGi0pDJ7wjgX-jayQ@mail.gmail.com>
Subject: Re: [kvmtool PATCH 00/10] SBI debug console and few ISA extensions
To: Will Deacon <will@kernel.org>
Cc: Anup Patel <apatel@ventanamicro.com>, julien.thierry.kdev@gmail.com, maz@kernel.org, 
	catalin.marinas@arm.com, kernel-team@android.com, 
	kvm-riscv@lists.infradead.org, Andrew Jones <ajones@ventanamicro.com>, 
	kvm@vger.kernel.org, Atish Patra <atishp@atishpatra.org>, 
	Paolo Bonzini <pbonzini@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Feb 9, 2024 at 9:26=E2=80=AFPM Will Deacon <will@kernel.org> wrote:
>
> On Tue, 28 Nov 2023 20:26:18 +0530, Anup Patel wrote:
> > This series adds support for:
> > 1) ISA extensions: Zba, Zbs, Zicntr, Zihpm, Zicsr, Zifencei, Zicond,
> >    and Smstateen
> > 2) SBI debug console (DBCN) extension
> >
> > These patches can also be found in the riscv_zbx_zicntr_smstateen_condo=
ps_v1
> > branch at: https://github.com/avpatel/kvmtool.git
> >
> > [...]
>
> Applied to kvmtool (master), thanks!
>
> (I updated the headers to 6.7 separately)

Thanks Will.

>
> [02/10] riscv: Improve warning in generate_cpu_nodes()
>         https://git.kernel.org/will/kvmtool/c/fcb076756ab2
> [03/10] riscv: Make CPU_ISA_MAX_LEN depend upon isa_info_arr array size
>         https://git.kernel.org/will/kvmtool/c/7887b3989ac2
> [04/10] riscv: Add Zba and Zbs extension support
>         https://git.kernel.org/will/kvmtool/c/6331850d6bc0
> [05/10] riscv: Add Zicntr and Zihpm extension support
>         https://git.kernel.org/will/kvmtool/c/667685691c5d
> [06/10] riscv: Add Zicsr and Zifencei extension support
>         https://git.kernel.org/will/kvmtool/c/3436684940bc
> [07/10] riscv: Add Smstateen extension support
>         https://git.kernel.org/will/kvmtool/c/8d02d5a895c3
> [08/10] riscv: Add Zicond extension support
>         https://git.kernel.org/will/kvmtool/c/8cd71ca57fb0
> [09/10] riscv: Set mmu-type DT property based on satp_mode ONE_REG interf=
ace
>         https://git.kernel.org/will/kvmtool/c/ef89838e3760
> [10/10] riscv: Handle SBI DBCN calls from Guest/VM
>         https://git.kernel.org/will/kvmtool/c/4ddaa4249e0c
>
> Cheers,
> --
> Will
>
> https://fixes.arm64.dev
> https://next.arm64.dev
> https://will.arm64.dev

Regards,
Anup

