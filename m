Return-Path: <kvm+bounces-15304-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 42B388AB0AB
	for <lists+kvm@lfdr.de>; Fri, 19 Apr 2024 16:23:57 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 78738B22F5C
	for <lists+kvm@lfdr.de>; Fri, 19 Apr 2024 14:23:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0B25F12D76B;
	Fri, 19 Apr 2024 14:23:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="RgMNgps3"
X-Original-To: kvm@vger.kernel.org
Received: from mail-qt1-f179.google.com (mail-qt1-f179.google.com [209.85.160.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DF33C12DD97
	for <kvm@vger.kernel.org>; Fri, 19 Apr 2024 14:23:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713536617; cv=none; b=hc295bE5V67AOUHDYwfv6wMF1wD175UVSBSCJdZWcZ3W1n8ljNzpbor15m06oICN6CfKJT/WYSJMReZqJQBTBm77AoryVXFAeXLoBzFd56X0F1wBq4bdpDXhbm3BEBCfBeaInxMUMJs79jz9ety5c32E6rEZBB+OiUWEp5qirFg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713536617; c=relaxed/simple;
	bh=1kpI/M6MXHf2A259DaYJe1s71xc46G3NDOVEEGYE+/8=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=ZSPw1lx61wIHbgfbCm3WoGJLk63KHQwdqO8k/MIsyoyd+oHYHOjiT4SUNscDaVJrARgzGACqPxLwZRv8/l3KZOpWT2QSYULocvHgkrMPu3FY1NiRS1HbjFFpMBVJT2q0OJTudgkfUOogtoMgTM4gh96Zo86O+WTuoJWt+3jE64U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=RgMNgps3; arc=none smtp.client-ip=209.85.160.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-qt1-f179.google.com with SMTP id d75a77b69052e-434b5abbb0dso289101cf.0
        for <kvm@vger.kernel.org>; Fri, 19 Apr 2024 07:23:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1713536615; x=1714141415; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=1kpI/M6MXHf2A259DaYJe1s71xc46G3NDOVEEGYE+/8=;
        b=RgMNgps3d+A3sjjtwW5R3RnbfMtEV+zAJgESmB+2g7wAXsLOCxN/GWrcsLSje0DL9s
         05pQg3TD3hKGVDh7XW8EqtQPhei+tlAdtMgj++UTd8UEmtlmSEr28qx41Ln2gxFh/MZn
         4v0Esm+su8Z/aHOZY23lPuKyPPCSKlAh6QA6L9EKibZVTOmSmP9hxa23CCIyCoX4b39c
         NGBH/ITOh7rPuVubPNxCugWCWjEy7Sz3wxZFkatQz9pcXo0HK0qpyiHIR3eJhio76TVA
         6AnU0M2gKnFCMjYz2OhT8b3VdsYPOATgowLJDNrBuJeQlCGkgFuQ7uKeNi5sKAy3/nPN
         fV1A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1713536615; x=1714141415;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=1kpI/M6MXHf2A259DaYJe1s71xc46G3NDOVEEGYE+/8=;
        b=stoaOAEyO/Tz8OFmCzKHkvqllUThzM9SlZooAYTXQI79lW/uy4BPeOCzHGF1W8j1Mg
         QY1YowGYq9VGJ2zQQDMCLOu9n2iBCy3H3I86mTSArul15tHtEstnV2xDYzaY8GAfVjP4
         Yrpx5pWdamUkMM2FT33KRW6iV33RKsXvMefDuHP/sGyVKlWl+YHKpZ40SobdCfgH2LzA
         Q7krMJrWNATXO0ZKzoaG/bKNShNFG+P2Yq/C9oB83kVgerEcmwcDuthx0KEpFQdGsAH6
         /iZnGlaVO3eQV/xPwFW8iibpoVXXotitE02NqpKNRJbRGCe8aYYUz7pO+g9ZXOgNaYHL
         9vCw==
X-Gm-Message-State: AOJu0YyqnioKxliAQsddYD3LbVoWH8A/h8IstDVuGhCmfM9GqGspi+gg
	R+Hhc/pvKGYI3B13pC6RaVzuhjWF/m1I989uny7Gj3aM4As46HBq43R5uLtTBSelV0fiRjK0u4N
	jpRgs60vgW7hYhNhUe/MUcWmNwBFmvp8tYK+G
X-Google-Smtp-Source: AGHT+IFvWAeEShrx7mj+kBqu9jzfKgaPpriDVMmFcu3fSDDgMD88toeAW4/cQERd5Zq87AlWKsqlymNI2M/wxI9j0XI=
X-Received: by 2002:a05:622a:5403:b0:437:c6c5:f30e with SMTP id
 en3-20020a05622a540300b00437c6c5f30emr250954qtb.17.1713536614736; Fri, 19 Apr
 2024 07:23:34 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240415154244.2840081-1-jackmanb@google.com> <20240419133953.GD3148@willie-the-truck>
In-Reply-To: <20240419133953.GD3148@willie-the-truck>
From: Brendan Jackman <jackmanb@google.com>
Date: Fri, 19 Apr 2024 16:23:21 +0200
Message-ID: <CA+i-1C1LOn19FcddyC5kV8idGQq5KDdAjWBo80ANpRGn8DCx3g@mail.gmail.com>
Subject: Re: [PATCH kvmtool] x86: Fix PIT2 init
To: Will Deacon <will@kernel.org>
Cc: kvm@vger.kernel.org, Julien Thierry <julien.thierry.kdev@gmail.com>
Content-Type: text/plain; charset="UTF-8"

On Fri, 19 Apr 2024 at 15:40, Will Deacon <will@kernel.org> wrote:
> Thanks for the patch, but I think we already fixed this in e73a6b29f1eb
> ("x86: Enable in-kernel irqchip before creating PIT"). Please can you
> check the latest kvmtool works for you?

Oh right, I had pulled from a bogus remote so my repo was stale.
Second time I've made this mistake this year...

Anyway yep, this looks good to me. Sorry for the noise!

Brendan

