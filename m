Return-Path: <kvm+bounces-56689-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id E9418B423CB
	for <lists+kvm@lfdr.de>; Wed,  3 Sep 2025 16:32:11 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id CBB7E1BC16C2
	for <lists+kvm@lfdr.de>; Wed,  3 Sep 2025 14:32:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B0F35202F70;
	Wed,  3 Sep 2025 14:31:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=brainfault-org.20230601.gappssmtp.com header.i=@brainfault-org.20230601.gappssmtp.com header.b="OO6D0bjv"
X-Original-To: kvm@vger.kernel.org
Received: from mail-il1-f178.google.com (mail-il1-f178.google.com [209.85.166.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 64B751E9B3A
	for <kvm@vger.kernel.org>; Wed,  3 Sep 2025 14:31:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756909911; cv=none; b=Bt9GimXkdbLV7cn+hY1cLxnaLwl9ubYmnSgdzB1MILXb8kAxzg4/BVU5H0O9NnGqp4bpQPcKmOoDQQ+JwoKIrW+eUlKvHQlF83wg6ekZ+gz9dYbA5PUgDMOwtVyZ9YPLfGzJ8HyrAmhauMdk4gz6SMBCdCICqKRBRmICQ81OclI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756909911; c=relaxed/simple;
	bh=dFJHOuSlomZMY1e1WhYT/9BjuUTdLl4qUfkdjnWwEdE=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=EAGMw2IqEqGw6FAfR8rY6dStPPLdUATcbqcK3G/RV7/MVFmUKDHtcf/OmK1+Ia7++ytaRlzoipcEATKkWned/X3vjdtrymC2w5T7JM2vc2jXIuAgMiLcMkmpm/muCMIK1f/qvpnnvDxNN4WBYwnp9+49bxLmBxx8DB0iVSsnOG8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=brainfault.org; spf=none smtp.mailfrom=brainfault.org; dkim=pass (2048-bit key) header.d=brainfault-org.20230601.gappssmtp.com header.i=@brainfault-org.20230601.gappssmtp.com header.b=OO6D0bjv; arc=none smtp.client-ip=209.85.166.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=brainfault.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=brainfault.org
Received: by mail-il1-f178.google.com with SMTP id e9e14a558f8ab-3f664c47aafso985995ab.0
        for <kvm@vger.kernel.org>; Wed, 03 Sep 2025 07:31:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=brainfault-org.20230601.gappssmtp.com; s=20230601; t=1756909909; x=1757514709; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=+xK1Ixt22UPQpRV6eJF15nySq1ENYn93GAeXzGVGJzQ=;
        b=OO6D0bjvsCNz4UDjJc/eT5GiK/c5J+Hxok4gpK5DlhwLVFp/jDdWosAR0he7yTlLMP
         G0OtHeQ0jLvw2FPtrRVnOyiflVyHps0HdBMYaZqXglvh8vADnJ1lgEM1k8YFHsoFkjSA
         vbkuvgwq1SheH2p7HotMXtBh0X7miwaXjKP5XsBqkssNoeuiOc17ydxcwo3wJXuura/i
         Jn3WqYjZ6ytUt//11QiXNCZFMy7ZPoxAFiZ7Fa0kmb/v2X91DCa29XysIjuzkWZiCyns
         9gn97QRkMgJ9tO3RnL7mjbWy0933idCIfYYoyissrdB4I8ngszURRBpkFLAF2IGTN2je
         n/Eg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756909909; x=1757514709;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=+xK1Ixt22UPQpRV6eJF15nySq1ENYn93GAeXzGVGJzQ=;
        b=riDVs4JIBvDM97ggLhZQ08OnfJlRuDuhRZ+N1BfQjkSaIVh1uh8aD3FHcyfEa9SsRT
         tkmha/xogVvtMSc9ENNJwnG5//cYw/Di4mheANv/+FScHnwbZ1lId3RMihrCBTGVaIPh
         Hd2GJUwsqXg4pR/r9hK/GT8vntaqExXuknntsJuIHh9ijciFUNIhbhHFMHM1Z3Igqnap
         s5hFAiF34F/LeiW52NTUss9WWE9G9bOElv4nfsFwifgKyuMEToI5XeN2e6Q4HgnJLE2q
         Dff5IvnhtPoGDB6JMYYlwlCEcLTo55G/FmdBle7TpZLapfwq4Lt0xaTzebm5Nm5wNf2k
         vkRw==
X-Forwarded-Encrypted: i=1; AJvYcCVkhKmXyGylOdy+I3mdxDZLUpWo/XGj7J3Kee1W5XDDC7s8NkI+FnqXSfvvOmlaUZWreos=@vger.kernel.org
X-Gm-Message-State: AOJu0YxWiKusvpJJ6jZTSWSJDHCM9rsnhpKGkFnp6NE7Ejuul9UEwIju
	wIpY/uk8BtUKsEJUklhk3h5D1IWinWWXBVSDGH1apc6fMaF3NIzxq3NrH5PvcfRLS46V7jDzydw
	GTgPNiPjVRQvGokFPM8YOMHk/AhksM3Fden+Pjx9Bec1Z9MWvS0Iv
X-Gm-Gg: ASbGncs+dOXkncPpk/NzsLLAkuBvMGVLtJ5LqejfN1nVuy+0a5GNho8gnTLMfghmH3n
	4/AqQeh5+RfU7nKKEWi+WVKVC45nM5GLcPn6HkVuTR2LSOsy5eyhY4MfOtDyNnKZDsrD1vniKXW
	Qk2CuMx3YUzricvi9FoMKRNAlJe7fwFkhTV5hJrUf7OPEu4+96CxB05F/Y5rYLrEc8uubVlXK02
	sGMJ/zsVBINU0ArSis6PbAH2chEdAR+6KGI6WShgQl0M07wSw9clIgq4I87sA==
X-Google-Smtp-Source: AGHT+IEdqptgFgnh5uv2GzzQGJFqAZUOszFTkmnyBR24wl/TgHUrHJeCtE9hinNDxe7tcZMD8cJExtpH41CpN+afzKw=
X-Received: by 2002:a92:ca4a:0:b0:3f2:1a77:4876 with SMTP id
 e9e14a558f8ab-3f4024cb129mr260307905ab.26.1756909909294; Wed, 03 Sep 2025
 07:31:49 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <cover.1756710918.git.dayss1224@gmail.com>
In-Reply-To: <cover.1756710918.git.dayss1224@gmail.com>
From: Anup Patel <anup@brainfault.org>
Date: Wed, 3 Sep 2025 20:01:37 +0530
X-Gm-Features: Ac12FXwG5rgdOIo0vaX3JEvtxdbhO8ebAqv0PdEvBcoUhtsHNdiKMQlA4BgxMFY
Message-ID: <CAAhSdy0DriNa-90QO_YgUbuxrjkDSQ_iTtNVG5ie0h09y2xSHA@mail.gmail.com>
Subject: Re: [PATCH v3 0/3] KVM: riscv: selftests: Enable supported test cases
To: dayss1224@gmail.com
Cc: pbonzini@redhat.com, shuah@kernel.org, atish.patra@linux.dev, 
	paul.walmsley@sifive.com, palmer@dabbelt.com, aou@eecs.berkeley.edu, 
	alex@ghiti.fr, kvm@vger.kernel.org, linux-kselftest@vger.kernel.org, 
	linux-kernel@vger.kernel.org, kvm-riscv@lists.infradead.org, 
	linux-riscv@lists.infradead.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Sep 1, 2025 at 1:06=E2=80=AFPM <dayss1224@gmail.com> wrote:
>
> From: Dong Yang <dayss1224@gmail.com>
>
> Add supported KVM test cases and fix the compilation dependencies.
> ---
> Changes in v3:
> - Reorder patches to fix build dependencies
> - Sort common supported test cases alphabetically
> - Move ucall_common.h include from common header to specific source files
>
> Changes in v2:
> - Delete some repeat KVM test cases on riscv
> - Add missing headers to fix the build for new RISC-V KVM selftests
>
> Dong Yang (1):
>   KVM: riscv: selftests: Add missing headers for new testcases
>
> Quan Zhou (2):
>   KVM: riscv: selftests: Use the existing RISCV_FENCE macro in
>     `rseq-riscv.h`
>   KVM: riscv: selftests: Add common supported test cases

Queued this series for Linux-6.18

Thanks,
Anup

