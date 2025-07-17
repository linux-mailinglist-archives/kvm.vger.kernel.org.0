Return-Path: <kvm+bounces-52734-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id BB654B08C6F
	for <lists+kvm@lfdr.de>; Thu, 17 Jul 2025 14:05:55 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id E46C17BC8FA
	for <lists+kvm@lfdr.de>; Thu, 17 Jul 2025 12:03:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 07BB729DB96;
	Thu, 17 Jul 2025 12:04:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=brainfault-org.20230601.gappssmtp.com header.i=@brainfault-org.20230601.gappssmtp.com header.b="lO8fYnlR"
X-Original-To: kvm@vger.kernel.org
Received: from mail-io1-f46.google.com (mail-io1-f46.google.com [209.85.166.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DAE5329CB43
	for <kvm@vger.kernel.org>; Thu, 17 Jul 2025 12:04:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752753880; cv=none; b=PrO/MGU3cHAe0GO20tWn1JQ74FITYxMzFWC7AT+713W9wAA+xLfM7Pm4QuYWqFNFXLK2wiL5oa65lpklIdhqI0bu/j5u2TyBv7U+mBBDSrrZ1FLGMLe5V8eW1tFv52F0XFaGg7zm07cCmwGFqeRZMCAp467KcfLSF82TYHvoGLM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752753880; c=relaxed/simple;
	bh=V5qX50zWv2Vid5uaus2ISEQNzjkiBmKlVbxYGNc1y7E=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=MhJQFFUhHTIqDsHORAKqvHSwNXj5kl/yCu8oaceo9ZnwINq3Mu7kdhLZjX0SITbzNJwGPzKRjFjPoFcLsVos/WKtOKPgoMexhN+lIGXP1Im2FP7rMkPSFDgVW3/jkjbjgFMduTmpiUj3zmnuSMgw4zzHI9/L3BRETV8aHMe6B6E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=brainfault.org; spf=none smtp.mailfrom=brainfault.org; dkim=pass (2048-bit key) header.d=brainfault-org.20230601.gappssmtp.com header.i=@brainfault-org.20230601.gappssmtp.com header.b=lO8fYnlR; arc=none smtp.client-ip=209.85.166.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=brainfault.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=brainfault.org
Received: by mail-io1-f46.google.com with SMTP id ca18e2360f4ac-8733548c627so32172439f.3
        for <kvm@vger.kernel.org>; Thu, 17 Jul 2025 05:04:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=brainfault-org.20230601.gappssmtp.com; s=20230601; t=1752753878; x=1753358678; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=+QcVJX052LEXBJv99aAWEE5wFktIbYwNU2eZQCUhFGg=;
        b=lO8fYnlRjZHpqv1a+xswxqggfHtBaVbClZRJI5TySzEyI7M1wkfoqHd7pHuyuTNPRQ
         Usg+hamVt3n6MskK9fAHohfWv0YvXKENPTaMge7Nob4RnOPCWoW0upEvmq98vm0BeTx4
         tZsBhCtsg2j5/BvyLPz18lqDdUSA27O8DAHq4fF7tekyG/PtMBlWvyFaPUZGh7jckCIl
         p4zz9HnDgqyGigrfLAJYU7xx8HJ+cCGZo1IRfNXJga+QKF+CheY2oVeaCk8C/gUXN7Pg
         0NPEjTSJhnimJuVQbpIvSiLNHq6ENneO66vzToHQh4zNlkaXp72JtGHOhOKhetltq2bV
         2CNA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1752753878; x=1753358678;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=+QcVJX052LEXBJv99aAWEE5wFktIbYwNU2eZQCUhFGg=;
        b=o2mJfXiMQzyJDssZ8ANzlxB1SzyKy4lPtNFGiLIH5LyUNVm6S01/b+DJVJ5La1tfOC
         2ZlNdtmPZyCnTIgWqt6/DUIzy+yxwqirF3vHpzBIgocT94/1h9aE48aXtl4UgKBNgc0F
         y3Ic8ORJwyLArMb8Ur3a7aovs+zYJpuQxB9vko8+gLy/zcy/vbh3vwoUEGDCou2g+D9W
         ODKVvSrQgYnS554zXIaJChY4+P0sPKf+rUFnApX0fNFPCNawtIToxSWZkQJ+sv9if2Ji
         Yeyhp69oYf2t9osQUV85yp0kUgWoTlyF9kjJazsRIP8PXxNgsX0THmmzF5Yc3VVSVxkh
         N5Hw==
X-Forwarded-Encrypted: i=1; AJvYcCXCu3eDdjtDArzFYF8FmcqPpZwAiNVqQWaUwgFytJSAFLqKanbKflXMkR85T4xR0i02UkA=@vger.kernel.org
X-Gm-Message-State: AOJu0YytM7trDWZpiYCNeRqHIH3CRM5FomsUqVNve/F+hdXBLhQwTOww
	/+xvjVPLadzfzkmxePKhW3Wmx6Yxq9/rpsth710LEMAtGbFHlY4sz+lomVGMHGiCTT/pLxNN5lz
	914gRcB9UXyFiePjK1H49Zpp5e4W9+OxDF5jWcyUWIw==
X-Gm-Gg: ASbGnctX5+jOCUkpvve/MfHRyKXY3gxdA2AQ/8rZz8Sotc7NBZbSflP3Jw6Cs6mkfCV
	bxqIPO66FEXkAC8bE33aMDeHjm0z/tw91y7z52nxVShU37N95d9EPartrnGjhlXldd31/C5dkWx
	Ck45tIhVD8QaOtnEAxT4gnaoAfBPapOchGqh2iEeXHA2pVCsHdKf/XDvcpU9wQk3CFpu3/bPAgN
	4mP
X-Google-Smtp-Source: AGHT+IHUjN0WtpcP4Ro+lSCJYUTyuKmTlKwKgPzpi8LVsCv5TFEcqprpyTpUikU7+qtzrB5+BO+NiFTYY7tWuiIfMM8=
X-Received: by 2002:a05:6602:7185:b0:875:bbf0:8bf with SMTP id
 ca18e2360f4ac-87c01356e4emr274220339f.5.1752753877857; Thu, 17 Jul 2025
 05:04:37 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <cover.1750164414.git.zhouquan@iscas.ac.cn>
In-Reply-To: <cover.1750164414.git.zhouquan@iscas.ac.cn>
From: Anup Patel <anup@brainfault.org>
Date: Thu, 17 Jul 2025 17:34:18 +0530
X-Gm-Features: Ac12FXwbyEoUlz3T8TSIi03E9WKp7zPs9qMqtNqR8ejTADSP2ePNd_lJkM8wKLc
Message-ID: <CAAhSdy3gYp7uc6ddpNxHhSQDRFDBMiUW3EOf695U77C2JH=HhA@mail.gmail.com>
Subject: Re: [PATCH 0/5] RISC-V: KVM: Allow zicop/bfloat16 exts for guest
To: zhouquan@iscas.ac.cn
Cc: ajones@ventanamicro.com, atishp@atishpatra.org, paul.walmsley@sifive.com, 
	palmer@dabbelt.com, linux-kernel@vger.kernel.org, 
	linux-riscv@lists.infradead.org, kvm@vger.kernel.org, 
	kvm-riscv@lists.infradead.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Jun 17, 2025 at 6:48=E2=80=AFPM <zhouquan@iscas.ac.cn> wrote:
>
> From: Quan Zhou <zhouquan@iscas.ac.cn>
>
> Advertise zicop/bfloat16 extensions to KVM guest when underlying
> host supports it, and add them to get-reg-list test.
>
> Quan Zhou (5):
>   RISC-V: KVM: Provide UAPI for Zicbop block size
>   RISC-V: KVM: Allow Zicbop extension for Guest/VM
>   RISC-V: KVM: Allow bfloat16 extension for Guest/VM
>   KVM: riscv: selftests: Add Zicbop extension to get-reg-list test
>   KVM: riscv: selftests: Add bfloat16 extension to get-reg-list test

Please send v2 of this series addressing Drew's comments.

Regards,
Anup

