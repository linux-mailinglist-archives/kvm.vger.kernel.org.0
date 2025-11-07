Return-Path: <kvm+bounces-62283-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [142.0.200.124])
	by mail.lfdr.de (Postfix) with ESMTPS id 826B8C3F5AA
	for <lists+kvm@lfdr.de>; Fri, 07 Nov 2025 11:13:47 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 875A34ED8CA
	for <lists+kvm@lfdr.de>; Fri,  7 Nov 2025 10:13:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6D451302768;
	Fri,  7 Nov 2025 10:13:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ORzl9Ttm"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 812BB302142
	for <kvm@vger.kernel.org>; Fri,  7 Nov 2025 10:13:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762510415; cv=none; b=QjD6o9axWnDwayRCj9qkhMZZ7FUuSG5oSnMQHBY76Aql6YgmgAYJNec3Eh2pCYnXEjNvU3yBDoHSV7ZvVPpfo9tfz+yNkqL5VxiKVUDc/sGA8aLcGG+bj0Nfhx9b8FbMusuZhrGn3oEWd14RJovROTtlETdZ3sEcBs5nj6l25SU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762510415; c=relaxed/simple;
	bh=OGshpqcs1YvljdbZBs4NQqzOW1YzzqsZt8BfUaOPWY8=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=tksB5NvWc2C3ss9Cs0FsceXmdDry/wZdw48SkMQIVS23p2j6B3j/FdmjONOIo67oVAeWx3phZBIuCu7XBjCOcR0Vfem63CJO6FmW4PO0/ZlT3UKFr7lFZgooaxplHfD4ags2LzhZ38hgaJFmoIu4WAyedS1vEpHEV0P25dpWNbc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ORzl9Ttm; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 349DFC4AF0C
	for <kvm@vger.kernel.org>; Fri,  7 Nov 2025 10:13:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1762510415;
	bh=OGshpqcs1YvljdbZBs4NQqzOW1YzzqsZt8BfUaOPWY8=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=ORzl9Ttmz800bs6Y3Gz4IJR4J8svpSc8mZPRPmJciXDsh5lH+4enXcP5XmvB8cWpx
	 Bknj+gebjuRy5sJsYJwvedeasd2UccI0vRvf5+srZYBScFPdiJk4UyZoPJDX5e417Y
	 uzbOy5UXjSbSpeNiJTvzo8gqvAAxqfhK8MdW7hi4DBKslkj22Xj37dcGSzdoG9Lb77
	 d/DnUzQOhX5v+jpcMAkfoj+hK1UzjhHWEuuZkkV+yQ+jzncT56bThutSPR7+xyQ5c6
	 9WW0Fdq5owYgNNfq7v7FzqZRrTVaG7YFGhBaEHwWbEU3sG43dUB71fKIAD1rGfM3bG
	 pXseKMd4qFeHQ==
Received: by mail-ed1-f45.google.com with SMTP id 4fb4d7f45d1cf-640ca678745so1012605a12.2
        for <kvm@vger.kernel.org>; Fri, 07 Nov 2025 02:13:35 -0800 (PST)
X-Forwarded-Encrypted: i=1; AJvYcCW5aFGBEb3kZZyjTAOv9hEzYtswi3E1eQk1b3rsA2k2033VdE+5+ZPfJzF+p36/hhbeIdw=@vger.kernel.org
X-Gm-Message-State: AOJu0Yxv+NX94VpnlhkbYciP1D6yxR3sRYvO8exr9tGWhQyG0sPuJNmO
	oHWX1RHF9huNq//voWiOcoAoyK7ApeSfWw3RQ+gjGyCQIBN0/NrbRTKiMkGMFv7CDDAR9vpBxnx
	1w9dYhN+0EkGfVbKgG2svXJ0+5mSVKnM=
X-Google-Smtp-Source: AGHT+IGJ9V/JQkTy0+fgCgt349C4363n7tsGZkHo3CZh519KFUKouqIns+HiecBdH84g1hnG+TsedjrB/PAjCC7/frA=
X-Received: by 2002:a17:906:9f84:b0:b70:be0b:6ba8 with SMTP id
 a640c23a62f3a-b72c0d77caamr285981866b.61.1762510413841; Fri, 07 Nov 2025
 02:13:33 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20251024072001.3164600-1-maobibo@loongson.cn>
In-Reply-To: <20251024072001.3164600-1-maobibo@loongson.cn>
From: Huacai Chen <chenhuacai@kernel.org>
Date: Fri, 7 Nov 2025 18:13:31 +0800
X-Gmail-Original-Message-ID: <CAAhV-H69wDWRoJEspck722fpRAeuS__7vWcGz1nEU5kDuz+Lww@mail.gmail.com>
X-Gm-Features: AWmQ_bnnlZ0vnXXi7bLnzpFH5--xXP0QsVHebyebKIoTmY54c8nzJiNGtrW3fG0
Message-ID: <CAAhV-H69wDWRoJEspck722fpRAeuS__7vWcGz1nEU5kDuz+Lww@mail.gmail.com>
Subject: Re: [PATCH 0/2] LoongArch: KVM: Restore guest PMU if it is enabled
To: Bibo Mao <maobibo@loongson.cn>
Cc: Xianglai Li <lixianglai@loongson.cn>, Song Gao <gaosong@loongson.cn>, kvm@vger.kernel.org, 
	loongarch@lists.linux.dev, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Applied, thanks.

Huacai

On Fri, Oct 24, 2025 at 3:20=E2=80=AFPM Bibo Mao <maobibo@loongson.cn> wrot=
e:
>
> On LoongArch system, guest PMU hardware is shared by guest and host
> and PMU interrupt is separated. PMU is pass-through to VM, and there is
> PMU context switch when exit to host and return to guest.
>
> There is optimiation to check whether PMU is enabled by guest. If not,
> it is not necessary to return to guest. However it is enabled, PMU
> context for guest need switch on. Now KVM_REQ_PMU notification is set
> on vcpu context switch, however it is missing if there is no vcpu context
> switch and PMU is used by guest VM.
>
> Also there is code cleanup about PMU checking on vCPU sched-on callback,
> since it is already checked on VM exit entry or VM PMU CSR access abort
> routine.
>
> Bibo Mao (2):
>   LoongArch: KVM: Restore guest PMU if it is enabled
>   LoongArch: KVM: Skip PMU checking on vCPU context switch
>
>  arch/loongarch/kvm/vcpu.c | 19 +++++++++----------
>  1 file changed, 9 insertions(+), 10 deletions(-)
>
>
> base-commit: 6fab32bb6508abbb8b7b1c5498e44f0c32320ed5
> --
> 2.39.3
>

