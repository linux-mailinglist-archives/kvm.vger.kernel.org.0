Return-Path: <kvm+bounces-47862-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 3C4ABAC6624
	for <lists+kvm@lfdr.de>; Wed, 28 May 2025 11:39:49 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 0BE601BA58D5
	for <lists+kvm@lfdr.de>; Wed, 28 May 2025 09:40:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C630827933E;
	Wed, 28 May 2025 09:39:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Rz0ddtiF"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f52.google.com (mail-pj1-f52.google.com [209.85.216.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9B99A278E60;
	Wed, 28 May 2025 09:39:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748425167; cv=none; b=q07Fr2DQPrXSHnNBudaU5zU7+2lcvrNoSLcQ89Xs02a0eRBlh4L6BVBxWHGpm+FrfiltRs0+RUTYQas9PmEw3jac6WNV3pEMiaFRlOeqVLByeLZ/lK6sVol2M9mEq/W2fF6YAz37SeKt7maQc0VlgJ/UBsIkSYOkHGsdNqjFWuA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748425167; c=relaxed/simple;
	bh=y4NzMxD9tmogr+AetKOa3VXWiWOLUF+6spJ2YgI8RsY=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=d/jOcDncrth8A9PXbDWjJn4Ta6u9QeF4PExu46N0fJw+9KxvLQ2nNPWIRUFrencDU5Bhw/bEEWNcBuMpDIcgHOHiesQx3fT40CQLwM8uLR5HRoifkQrmlCftY1zPlhWy1zqJIOhE4LS031BzKbKWLsgyuVMIqk395gp5RwwJjik=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Rz0ddtiF; arc=none smtp.client-ip=209.85.216.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pj1-f52.google.com with SMTP id 98e67ed59e1d1-311f6be42f1so37547a91.0;
        Wed, 28 May 2025 02:39:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1748425165; x=1749029965; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ZQBoysENhIbgW5/kLFhu2v5G6iCydX7mEkkhpaN14T0=;
        b=Rz0ddtiF85FovreUueojk0HHigqQKTsz06tTQa32/Sq9vmZnp/LxnW+L8dYn6zhrh1
         awWf3hm7MTwiTaGVPIuoifcvaadmsxL2ZWJe12TJDbM1xDfGew1h8h60YdBbRyUniHXx
         v8gDTz3K3eVvDScswnZP2/NhksvgRXx3HGknM4yo9HsWk5Q89Yi6yP+E52xbFsEROAMd
         IPHfCwxCx+uCV9Wne/tG1SdNzFbhApvPsMZsPMrHCpP3LaMmkPuKIDTbX0ovrL4yT6wn
         14n316aYxgaBMwEtuFrWdQVkamNxKs4Z+4dcJAy0Vwn5n0BBewLgeCj1JDnwV1+vwEo7
         AcKg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1748425165; x=1749029965;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ZQBoysENhIbgW5/kLFhu2v5G6iCydX7mEkkhpaN14T0=;
        b=kHijPsgQeEtHWaK+hC5aVdtMqAJaaL20yxv4lq25hmBon5DIyOCfRQ4aZ3qmUvbIu7
         Yagpv0bOFUIQsAFQWd5xe4V9xAnlVDTLP6PwHgTyczd7iWTy7dYX4T2GSXnNIYQwPq4L
         hfzZO3oEg9DqPmBJvkxN4CiXNCutKtJtxS9C7iejPiAocMbzWtkuLAggKBTzA15Wl6TM
         ufNea0iqOZnkFDYgpzIF3Lb8rKrbi/IwCbkvfoYk1MYMGC4Fhid0b7gK0bc1WxfYNSIk
         kKutEInZRHwsG1PDHvJRWS+ENaK7HdT2myrE7fc+WJt2wbxW2vxkjiHgspuG9FZMGXMc
         bf4g==
X-Forwarded-Encrypted: i=1; AJvYcCWIBczkzF24amG7+kZnVa5Qer7V1XH6E2wKqtNKuUFCeLeI30czmKXwowZnn6YbhVN/Sz8=@vger.kernel.org, AJvYcCWJJr8QHfo7vnfF3ZQ+fc48wDSRcPSTmzIWLBnAUjjIdo0bi4nC+l9eETRFc1Q3X50olvawvoXlFShTndF0LdA=@vger.kernel.org
X-Gm-Message-State: AOJu0YwMclseVYDs8yXfqQJm1OjDeBRANAZwph3SGICLbj85aqRrLIfl
	ISrNwl6NP777R6FCBBwzcKvYgRRurQsy+Qibgq5pZ6OyN6i6tYIlet2RUbOv7yRV7kf6iy5Hg1i
	ThGjj9+Xrnfcy4LWpxLS2gmcvqdiZheU=
X-Gm-Gg: ASbGncs5ck6SgfmBs0DqZB1qGxenep35fiwpI7b+Q9Tr1gc6AMbYbPVHtH9KMbg7DJ9
	qJFccVVw1cUsE0Cj/BZtTgruvVqBz3D2PmzvVJnT1yA8kKK+uV6euP64Q1KxALoB1mHR/X/MxPU
	8EtcjxPQKvqMNNE/1qGzP5Fr+Zwe5GXZde
X-Google-Smtp-Source: AGHT+IES7Q+itUfT5wFGMqq1cdttplKaNdUc32Nx59Bv5rwPOYXCpDB88AGK9vWYeBz/+WcV0xKa7x6/E1mxh1Z7838=
X-Received: by 2002:a17:90b:1e10:b0:311:488:f506 with SMTP id
 98e67ed59e1d1-311e1a122b4mr1202559a91.6.1748425164739; Wed, 28 May 2025
 02:39:24 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250528083431.1875345-1-pbonzini@redhat.com>
In-Reply-To: <20250528083431.1875345-1-pbonzini@redhat.com>
From: Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>
Date: Wed, 28 May 2025 11:39:12 +0200
X-Gm-Features: AX0GCFvBLnlzWD65XoPoEaCqR8aQRkKJqxadBtl2y6UrWx3JHjZf3XpuLM3RmeQ
Message-ID: <CANiq72nwM79eGSAt8FjKgoYCJd-bLeTojaQAtg3SECE28uByQQ@mail.gmail.com>
Subject: Re: [PATCH] rust: add helper for mutex_trylock
To: Paolo Bonzini <pbonzini@redhat.com>, Boqun Feng <boqun.feng@gmail.com>
Cc: linux-kernel@vger.kernel.org, kvm@vger.kernel.org, 
	rust-for-linux@vger.kernel.org, ojeda@kernel.org, 
	Stephen Rothwell <sfr@canb.auug.org.au>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, May 28, 2025 at 10:34=E2=80=AFAM Paolo Bonzini <pbonzini@redhat.com=
> wrote:
>
>         Ok to apply to the KVM tree?

Yeah, looks good to me, thanks!

Acked-by: Miguel Ojeda <ojeda@kernel.org>

Cc'ing Boqun just in case and so that he is aware. Boqun: this fixes a
Rust build error on the kvm branch which failed on merging into -next:

    https://lore.kernel.org/linux-next/20250528152832.3ce43330@canb.auug.or=
g.au/

Cheers,
Miguel

