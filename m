Return-Path: <kvm+bounces-37873-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id C8BC6A30E96
	for <lists+kvm@lfdr.de>; Tue, 11 Feb 2025 15:41:03 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id E34E7188A54B
	for <lists+kvm@lfdr.de>; Tue, 11 Feb 2025 14:40:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4A4502512D7;
	Tue, 11 Feb 2025 14:39:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="LP0rlXMG"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 31B81250BE4;
	Tue, 11 Feb 2025 14:39:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739284791; cv=none; b=eHCizzMVQIFI2vOXXz8pi02pXBT4cMc0lpg+xIhKnivWuhhq+PF5bz5SZD4vfLe1odCDCMnuUwMNQ63e/CfLdwcLJwF7n85WTpKk44IONOkZxk/2FCD75ReQTVHs50oHZ3ePTIivX7OcpAlzpPK06Vcsad/uDHZpkzXudlf6aOY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739284791; c=relaxed/simple;
	bh=ulwfMWLqUipyPdhn0d5FcC7nI6gKuz6DeB1kG8AxMNs=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=DeZSFlSOA/+K7vsX/rhMT2r48RTeAUFYxkUoTm3duxKarY0oBM5o7/4ULqzNZUHdXh9Fyx7Z/VpYkAQQ4b8b4zS1SE6Lh3b9XhCeR5YRSHoHkYIYFHSLHxmLHeH5Fber3qi1pK7i/H0FLf/bFKhh4z7WK4jZMvAnf5nZ45CpwEY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=LP0rlXMG; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9565AC4CEE7;
	Tue, 11 Feb 2025 14:39:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1739284790;
	bh=ulwfMWLqUipyPdhn0d5FcC7nI6gKuz6DeB1kG8AxMNs=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=LP0rlXMGLRh/nqMxHiNqoW3AR21kS1Fp9qT49KQsF2pUrNVejxJH0ybGchsu4V9Yn
	 VHe7MwTywpcPkaSPnBBMiQabSecYn8rmK9ifvMqax7UvfZIllX1k3G+DHMJZ2CORpw
	 DSMSZaLMQXgYZXT0I5S1YWLagVEwuSmwGuwlBvwZM/LdOBldlKVD5IX43ldU6FkdYv
	 uFraiWubH/fSBDqImIWpaSHo3a9NCs99icA7CU/rq8E/8nSj9xiOSCLR6nLyjeTWnX
	 XO4u2XtdLAoA0150ckjC0QrgS7XMaRDqAWK9QzFPLqQriAe3twjX8lLY/dN6oLj6Ib
	 hzlYq24RdQp5Q==
Received: by mail-ej1-f51.google.com with SMTP id a640c23a62f3a-aaf900cc7fbso932822066b.3;
        Tue, 11 Feb 2025 06:39:50 -0800 (PST)
X-Forwarded-Encrypted: i=1; AJvYcCWUonT5ooSekcBd4ZZeHyGXfRVsMskLDU9HxBL9NNdG+dHGVVhrDdyX/9RpDVLqgjFhQ3E=@vger.kernel.org, AJvYcCXBoIc+/+Ko3i9kOFwPGU7wtf67q0n8aCLZ4AyBEPCKEx20s21pr6KwSZFw0X98ECQh3Pz+V1y5A6QIHNq4@vger.kernel.org
X-Gm-Message-State: AOJu0YyP1MKJwFkGFKIWbFX3A23JhgRPFGmp72Fq5lLkJBSeNOVVlZOT
	hFrUA9ll5coQhdNSF4yytimKdkdRmkqDbUNJxJedTj1nGDRB1up3BtIX7vMVFVugly+VHgTwc4l
	7ogE5ojN/iL0/jOkV9QTj2XpCD88=
X-Google-Smtp-Source: AGHT+IGLR5ULI7gGLte0l7vRhZ2ZWqb5CWOtTbE4sI1QcMB4fXVUok//FjZVBam+puAjUPcYnE1+qzleMg68ltPCw1E=
X-Received: by 2002:a17:907:9719:b0:ab6:e10e:2f5 with SMTP id
 a640c23a62f3a-ab789bf6ae5mr2003093166b.37.1739284789169; Tue, 11 Feb 2025
 06:39:49 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250211020118.3275874-1-maobibo@loongson.cn>
In-Reply-To: <20250211020118.3275874-1-maobibo@loongson.cn>
From: Huacai Chen <chenhuacai@kernel.org>
Date: Tue, 11 Feb 2025 22:39:38 +0800
X-Gmail-Original-Message-ID: <CAAhV-H4w1sC93ag45Jx8B21Db4QRN3Jgtd1hqmLPEX3iCcHiWQ@mail.gmail.com>
X-Gm-Features: AWEUYZnKR2iBOFeYKrnSINo32nx0jZbTx4gSoq7LUFeCrgBTWcFZ7G7vKb2B6iI
Message-ID: <CAAhV-H4w1sC93ag45Jx8B21Db4QRN3Jgtd1hqmLPEX3iCcHiWQ@mail.gmail.com>
Subject: Re: [PATCH v2 0/3] LoongArch: KVM: Some tiny code cleanup
To: Bibo Mao <maobibo@loongson.cn>
Cc: Tianrui Zhao <zhaotianrui@loongson.cn>, WANG Xuerui <kernel@xen0n.name>, kvm@vger.kernel.org, 
	loongarch@lists.linux.dev, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Series applied, thanks.

Huacai

On Tue, Feb 11, 2025 at 10:01=E2=80=AFAM Bibo Mao <maobibo@loongson.cn> wro=
te:
>
> There is some tiny code cleanup with VM context switch or vCPU context
> switch path, and it fixes typo issue about macro usage GCFG register.
>
> ---
>   v1 .. v2:
>     1. Remove comments about LOONGARCH_CSR_GCFG definition in header file=
.
>     2. Add notes why PRMD need be kernel mode when switch to VM.
> ---
> Bibo Mao (3):
>   LoongArch: KVM: Fix typo issue about GCFG feature detection
>   LoongArch: KVM: Remove duplicated cache attribute setting
>   LoongArch: KVM: Set host with kernel mode when switch to VM mode
>
>  arch/loongarch/kvm/main.c   | 4 ++--
>  arch/loongarch/kvm/switch.S | 2 +-
>  arch/loongarch/kvm/vcpu.c   | 3 ---
>  3 files changed, 3 insertions(+), 6 deletions(-)
>
>
> base-commit: a64dcfb451e254085a7daee5fe51bf22959d52d3
> --
> 2.39.3
>

