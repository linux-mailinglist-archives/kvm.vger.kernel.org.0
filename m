Return-Path: <kvm+bounces-54522-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 0BF17B2287F
	for <lists+kvm@lfdr.de>; Tue, 12 Aug 2025 15:31:10 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 3BDD02A792C
	for <lists+kvm@lfdr.de>; Tue, 12 Aug 2025 13:24:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EA8142836A0;
	Tue, 12 Aug 2025 13:22:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ventanamicro.com header.i=@ventanamicro.com header.b="Ckh5bYhw"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f41.google.com (mail-wm1-f41.google.com [209.85.128.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5FD6A27FB3C
	for <kvm@vger.kernel.org>; Tue, 12 Aug 2025 13:22:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755004976; cv=none; b=Ij/C7TuEA7jDhw9tdqlekEUzGh+pBAYoiQlnK+f6SHg9qQT8BFQXNfZ0hnol5/Rj76jlrBaad22AKyC4CaRNJCIMgDCFQucvJEP/+AELAoaxgiYFbVZTiZVAl7R497KNtrOMvZyaEd8uaniCIPW/04+OG/6DgIru0wskmqe2hcY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755004976; c=relaxed/simple;
	bh=Rc0fSOx4ODT+niej0z9sfBuk37BOAGSBh4g04bdKLEE=;
	h=Mime-Version:Content-Type:Date:Message-Id:Cc:To:From:Subject:
	 References:In-Reply-To; b=COTPUbxz/Rb45l7XshAS8/gFG2vwX/oH3UK38g4vNShhPCbFPalddQV2YJP+0ygVS0RssUrx9Z3jjniT7ldUxHr3q0r+17WJydUdZUICyMZh99Kuk16Pd2J+rV1W3jF51JB3tApn6vrHgpys3eZXrmvVoQ0Pf2CrvjbO0Us5fjg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ventanamicro.com; spf=pass smtp.mailfrom=ventanamicro.com; dkim=pass (2048-bit key) header.d=ventanamicro.com header.i=@ventanamicro.com header.b=Ckh5bYhw; arc=none smtp.client-ip=209.85.128.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ventanamicro.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ventanamicro.com
Received: by mail-wm1-f41.google.com with SMTP id 5b1f17b1804b1-459dff22d0cso3887595e9.0
        for <kvm@vger.kernel.org>; Tue, 12 Aug 2025 06:22:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ventanamicro.com; s=google; t=1755004973; x=1755609773; darn=vger.kernel.org;
        h=in-reply-to:references:subject:from:to:cc:message-id:date
         :content-transfer-encoding:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=9B+m7y7gtFTTGyBFc0gL8TaOwTzdqm4Gs9PW5eoUpxg=;
        b=Ckh5bYhwf/WZaDalDmOxheSfMGh8HgZL6604VbXFmRPnfGuOKIqptGunxMUNDQl0DP
         cGhZ7c/XQ7bfHy49cPbEEZSejqoukzEX3jofk4o0S42CqDhkMoNd4sfPYoUr+XbE8O9J
         iwSplD49sBQV/vG7ZTQDLZC+9XXrD8w7Ebm21e+4z7u2VhYaBL8KTLwlxdMo4QZ3yXza
         qlE2yXNDeDXB4kE6maBZDgLsigqPjvkSkq2z01K5WwgAgGmU0t8B9gJOZCf6Ol9ujkMy
         wMMEV7/qAFgTKt7Lee0HLq/uS50UWFAK8j/20UIelsp/jpzViDqI+zWIWhL4tceVtl5Y
         4lYg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755004973; x=1755609773;
        h=in-reply-to:references:subject:from:to:cc:message-id:date
         :content-transfer-encoding:mime-version:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=9B+m7y7gtFTTGyBFc0gL8TaOwTzdqm4Gs9PW5eoUpxg=;
        b=FhGQQQg+QaMXu8sCSDqlXLO7obHG9/o6Yj/Dw/No542elryvC66Ht9KdV90ory0hB2
         qc3mQDa/HMrrgTTCfQHSzK/No1XlFBy9gX9JEEzOCQ1DDD0SMMbcCfHG+IZMEK2y9ktD
         LufEqhIV8A6TfsRCrWlyXF0Z6jTJDhnKRnp3RznwoAzha9y6IyeF6MOie4BJYjpcVFZX
         vKy3zpQuyBBEnpFOtzFwe45KOMxmq5+0YarUC32jj8PSY94zNAmGdn4Y6Bm2GB6clemc
         e7WEUqkAOxeFK2YuoXYlGBMi9CjrOzhqDqqW7YW/J28lV3uDLSDz0JjpFDFBKPxKQxa1
         5mAg==
X-Forwarded-Encrypted: i=1; AJvYcCXiUNmCF6ER4gbVNB2LnRyDOkRRvFwCRX4dW6W80BoKUTM1cL6baAafdvBJVCEh7bqy1a8=@vger.kernel.org
X-Gm-Message-State: AOJu0YzZ+ZTQS+aKLaS3RetsJKWNuK9DuctG1tW4ijXB69ultWFFAlHN
	+8hNFpG43xKJTLB/oJECzh0hX7vtXz0BdeME3UuEPKTSaEeVF6d2lVk8rcbRYfIFBjM=
X-Gm-Gg: ASbGncvj0ygwrS85Yr1M2ncANDyGjkLRiFG5y3NZXoqYhdTfoiKf5dhQRFF5OZi+dHY
	AoQRL3fRSoDitVNHi/HLWDk+dZLf3Eaoqk/GKeI/3ZyiA3d8DspqA94f0pn2hax1Req/oN6jHAl
	Qw5SIY1SxaeqSPUgbMnAbxUAhwP6bDVj6A9yZjrrE4KUqwyY0DVomB1y/d2Hr3X82lVw5Z1KLSR
	YMXIm7yAfx1zemnD9hbNuOonX5Ijk2ECz3Mey+3teugXpKE1ZdmiKwFtNlXnSwRJhPinMClUUQn
	VRXo8EAuyrXvLa7gkNYwLHGdvVCps2DCGJiFpRrNdtwPCk+r8Abll0A1QhYf/253jx0exM2iNc9
	v7/qXYtJ+gu2cISBDta0kSmU86Tf3Qw==
X-Google-Smtp-Source: AGHT+IE2d/O56DZUtoh12B2LgxGIZeb1yHos8UKAErVtVVQ4j+I6Ktyv6mqGKISnmKVi1pnhPfvJHQ==
X-Received: by 2002:a05:600c:1ca1:b0:459:ddd6:1cbf with SMTP id 5b1f17b1804b1-45a157b70b9mr736355e9.0.1755004972582;
        Tue, 12 Aug 2025 06:22:52 -0700 (PDT)
Received: from localhost ([2a02:8308:a00c:e200:8113:2b11:8f42:672f])
        by smtp.gmail.com with UTF8SMTPSA id ffacd0b85a97d-3b79c453d6esm44093096f8f.37.2025.08.12.06.22.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 12 Aug 2025 06:22:52 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Tue, 12 Aug 2025 15:22:51 +0200
Message-Id: <DC0HC9ORWWX1.1LUBWVHPGFK95@ventanamicro.com>
Cc: <alex@ghiti.fr>, <anup@brainfault.org>, <aou@eecs.berkeley.edu>,
 <atish.patra@linux.dev>, <guoren@linux.alibaba.com>,
 <kvm-riscv@lists.infradead.org>, <kvm@vger.kernel.org>,
 <linux-kernel@vger.kernel.org>, <linux-riscv-bounces@lists.infradead.org>,
 <linux-riscv@lists.infradead.org>, <palmer@dabbelt.com>,
 <paul.walmsley@sifive.com>
To: <fangyu.yu@linux.alibaba.com>
From: =?utf-8?q?Radim_Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@ventanamicro.com>
Subject: Re: [PATCH] RISC-V: KVM: Using user-mode pte within
 kvm_riscv_gstage_ioremap
References: <DBX0JNR61UNM.Z42YERAKRFR8@ventanamicro.com>
 <20250809032020.51380-1-fangyu.yu@linux.alibaba.com>
In-Reply-To: <20250809032020.51380-1-fangyu.yu@linux.alibaba.com>

2025-08-09T11:20:20+08:00, <fangyu.yu@linux.alibaba.com>:
>>> From: Fangyu Yu <fangyu.yu@linux.alibaba.com>
>>> According to the RISC-V Privileged Architecture Spec, for G-stage addre=
ss
>>> translation, all memory accesses are considered to be user-level access=
es
>>> as though executed in Umode.
>>
>>What implementation are you using?  I would have assume that the
>>original code was tested on QEMU, so we might have a bug there.
>>
>
> This issue can be reproduced using QEMU.
> Since kvm has registered the MMIO Bus for IMSIC gpa, when a guest
> page fault occurs, it will call the imsic_mmio_write function,the
> guest irq will be written to the guest interrupt file by kvm.

Oh, so the interrupts were "just" slower.  Great job catching that!

>>> ---
>>> diff --git a/arch/riscv/kvm/mmu.c b/arch/riscv/kvm/mmu.c
>>> @@ -359,8 +360,11 @@ int kvm_riscv_gstage_ioremap(struct kvm *kvm, gpa_=
t gpa,
>>> +		pte =3D pte_mkdirty(pte);
>>
>>Is it necessary to dirty the pte?
>>
>>It was dirtied before, so it definitely doesn't hurt,
>
> Make pte dirty is necessary(for hardware without Svadu), and here is
> the first time to make this pte dirty.

Right, we would get a pointless trap otherwise,

Thanks.

