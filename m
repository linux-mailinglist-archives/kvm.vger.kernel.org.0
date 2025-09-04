Return-Path: <kvm+bounces-56805-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 8A34BB4357F
	for <lists+kvm@lfdr.de>; Thu,  4 Sep 2025 10:20:52 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 572FF16F425
	for <lists+kvm@lfdr.de>; Thu,  4 Sep 2025 08:20:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 53D1F2C11F1;
	Thu,  4 Sep 2025 08:20:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="KqqCBMnD"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 750A62C11C9;
	Thu,  4 Sep 2025 08:20:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756974040; cv=none; b=EHeepf3L7hZFar6zDDsLFTkDin4cyvs8Z6hwERq3ushTJTmlBMQSlNXlzZ2zUmvtz1tkZr22rFSLZnz8c6x/f+HBEO3eFcH4bH9H/DRmX+n3uiF0c7VfflJ8YJhBc4xVz2423TDNDm2Xe8pNlyjlaopookwwCtFCUo9qMu5RAgw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756974040; c=relaxed/simple;
	bh=E/uXjtRmkLmNWxnlDCw0CKhl5d3ycTzBEGah+pZZG60=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Rg7DOvfZPsUGd5cb6i4+oS9OSjZJ+AX8l/XEc7+H59ILGjtjSMBFWqaGr72OTeyNM6JOXuL4HEqWuPzqdhwJf/MNZcPnxLcm3sbBH6XWlRT8mUHYQ3t514ChqZMIDbZKo69eADMV07UE9fUuJLqW76kEtvl7x7BsZR7nC3nO5zY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=KqqCBMnD; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 267BAC4CEF8;
	Thu,  4 Sep 2025 08:20:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1756974040;
	bh=E/uXjtRmkLmNWxnlDCw0CKhl5d3ycTzBEGah+pZZG60=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=KqqCBMnDPDme7cNPhAslqYiZtDfFK07Hdwq+nNPShaGNbzw1iySrcsxmWiw8b3mXX
	 mUni9v82wen+gY8vSWCdOkeadysLVo1BINUN6DJ6fPpBznk409MAPFn+AfzLU8P5Q5
	 QVujMnJs+Oo+vkLM2DN+ey1ICBF1PdbBDtwX53juy2uzXQ/S4fWXweZ351Ih7SkyjJ
	 m7ANfaf7wYpwt2pLRPb5a1PnBYWeFOHsy63LakobGkDaiyGpEQT3UlWziFIjtPuLRn
	 mGj34/jNAgmZ/GGZGO+86qrWS+bndJSAIUgasA9gv8V3wPsq+4aCOHuV1DAjIMgPi+
	 yQlsI4Fce0kWQ==
Received: by mail-ej1-f41.google.com with SMTP id a640c23a62f3a-b0454d63802so118338066b.2;
        Thu, 04 Sep 2025 01:20:40 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AJvYcCVVQxAkp3TCik99sqV65Qx+Wae2TmYbd1Y9DOMYGVHTGeS42D07mLpy9t7GA+P4kJ9OpHL+p22jwDW3n9dA@vger.kernel.org, AJvYcCXrYCi12TmBAXjV5u6Crt1aXFQ5fUaCjl3jEBq4tzUWIxV5195Ad/4vEbugl3RQNAPReOs=@vger.kernel.org
X-Gm-Message-State: AOJu0YzMxbgwJgztQ45AbfJlUjXmFeeOEE7p0X1tonvHBTb91q3wxN+b
	uedirrEL0cxiBvATH5nLdW3q6813lJsArc2hXzCIP4NdPxtnJ0LZTBdKDoVbJ8n+xn2Gu3wMZRT
	L586pCc6CvWjyM6ag6s+BqVBlu7nJ6bk=
X-Google-Smtp-Source: AGHT+IGykX2kjpwbJSz2Df4Q0dC+COJpNbeU+7c1CUdwCq32YXgec8hSk5QMYiD/hWmRbZ9Libc//QGLnc87pKR/9tM=
X-Received: by 2002:a17:907:940a:b0:afe:f8cb:f8bc with SMTP id
 a640c23a62f3a-b01d9732721mr1839905166b.35.1756974038671; Thu, 04 Sep 2025
 01:20:38 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <462e346b-424d-263d-19a8-766d578d9781@loongson.cn> <20250904081356.1310984-1-cuitao@kylinos.cn>
In-Reply-To: <20250904081356.1310984-1-cuitao@kylinos.cn>
From: Huacai Chen <chenhuacai@kernel.org>
Date: Thu, 4 Sep 2025 16:20:26 +0800
X-Gmail-Original-Message-ID: <CAAhV-H4QDs+zruvKVkDgWnMoObhoHiWOL7x4=Q2PRTnnqkNnsw@mail.gmail.com>
X-Gm-Features: Ac12FXyzzZrpldD23M0o6vMPkPUzHye1yDSCXQYfZAqAKOkke_zz16jNhRDVV0s
Message-ID: <CAAhV-H4QDs+zruvKVkDgWnMoObhoHiWOL7x4=Q2PRTnnqkNnsw@mail.gmail.com>
Subject: Re: [PATCH] LoongArch: KVM: remove unused returns.
To: cuitao <cuitao@kylinos.cn>
Cc: yangtiezhu@loongson.cn, kernel@xen0n.name, kvm@vger.kernel.org, 
	linux-kernel@vger.kernel.org, loongarch@lists.linux.dev, maobibo@loongson.cn, 
	zhaotianrui@loongson.cn
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Sep 4, 2025 at 4:14=E2=80=AFPM cuitao <cuitao@kylinos.cn> wrote:
>
> Thanks for the review.
>
> My initial idea was to remove the switch-case structure.
> However, after checking the case value KVM_FEATURE_STEAL_TIME,
> I found there are 13 parallel definitions=E2=80=94and it is unclear when
> this part of the development will be completed later. Therefore,
> I temporarily retained the switch-case structure.
>
> Now, I have updated the patch according to your suggestion:
> - Replaced `switch` with `if` since there is only one case.
> - Removed the redundant semicolon after the block.
>
> Please see the updated patch below.
It has been applied, don't make useless effort.
https://github.com/chenhuacai/linux/commit/f5d35375a6546bcc5d0993e3a48cdbc3=
a7217544

Huacai

>
> Thanks,
> Tiezhu

