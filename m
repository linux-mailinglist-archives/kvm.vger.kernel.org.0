Return-Path: <kvm+bounces-63056-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [IPv6:2605:f480:58:1:0:1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id 4AA39C5A4A6
	for <lists+kvm@lfdr.de>; Thu, 13 Nov 2025 23:14:30 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 1E73C4E3101
	for <lists+kvm@lfdr.de>; Thu, 13 Nov 2025 22:14:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CEC15325729;
	Thu, 13 Nov 2025 22:14:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="q6Ilp+n7"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f53.google.com (mail-wm1-f53.google.com [209.85.128.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2901A2C0293
	for <kvm@vger.kernel.org>; Thu, 13 Nov 2025 22:14:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763072064; cv=none; b=DqNLaWlizG9DuNLWyZQSCBoHarYjNg0JqtvmhkusIPZPnjUmdNg3zqoP2MPmvh8rICSH3lT1cCtrfAQRghIRGUdNFek34oJ/r0VRMBEmjGSd+93L5ztQ4+SIT9Xz0rrmXzWtKTu7V0GT0Sa0/AytGkkFIfVB2HgmqOQBW0PysEM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763072064; c=relaxed/simple;
	bh=vg2n9jgyf6Un8yroS0eZ9RJEclmxHEAIxafM2FtYloU=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=B5QReJ0OYRrHF1DEdx5hHpXKGEt8t9mBsBcFGdgQH+WQZse+UaaJ2rIWqAKptqa+GGg/9jp6EblGD9ams5mmmxPBcNh8nHSKrpMU3wVX9eEOkjkcEEmTyWjX+zGQBXVQoKwI0R6rVnWZYU+Q7TaGk3o3WNIM/ZW4pjv9bWlFnQ8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=q6Ilp+n7; arc=none smtp.client-ip=209.85.128.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-wm1-f53.google.com with SMTP id 5b1f17b1804b1-4770d4df4deso7945e9.1
        for <kvm@vger.kernel.org>; Thu, 13 Nov 2025 14:14:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1763072060; x=1763676860; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=f7JRornaiplk0uZKMqz9STwhUMyLeMRJwxelXDphyMs=;
        b=q6Ilp+n7pTN4+s4aQsfVwd8VdZlJEgIq9zdYAR/33q19ER0geRYo1QEysrFMwV2E3l
         pXWZBeQxzsFBvjBEyAoWSqnJcCpWaA1WiOwjXHZgAxuLQfeSKWo3wy94l5EfwuOjQ0DR
         C0EnayLvOwdjaCa7dJeaR743KyE4+C+scFCHI+NDi2azRKiJcp1JfhDPaDk/coIb3fAa
         fEERTY6L9K253ca9ik2xF0Zxx2SZpjGWvq6wmDzVXj7kV7Vid2VPyfuPHgDbyYHvNOM3
         YyYriFbnqgeb0ZFOhN7rYO8GMMACLXRFkX2fO6hsSD/6lYR4PKJzcIRH88qHDTxWTwPQ
         U1oQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763072060; x=1763676860;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=f7JRornaiplk0uZKMqz9STwhUMyLeMRJwxelXDphyMs=;
        b=cBINxKw7AdDoOdHsefImjtoCwBKj9qiR/9Q4I0/ZkNDfHryEGkYzYXKAfmgLsYtEeH
         hJUYiPZBAZHC5Q5CP1P3kYDi45JnOFeiKfmybqn0nQX0ksUj2IftSwBjMaHkLJLe241w
         pIzure3fICgCeGITAxSew1CMP/Oadd0hQB6w9ED/4iY9nyYoFH2eH9Vp7k87TRIE7NrU
         9iaIdEbDDlh6vJxckOz89q7ssJtdc092HpLsrBu7qaIQ//Nrn4LimuP8nWouHqr3KM3o
         SaNkjoPe6iahmHhRa07Pl/w2s1T6Iuv9A7faCoWx1EYWpqnnNFiD9tdo9iq24Ie0+vBZ
         2UDA==
X-Forwarded-Encrypted: i=1; AJvYcCV23fVWcrYKjQQaZ4C4gWJ9QEUfitBvSaeA4UTkk21HnyVDJl+RSjvuhTWbs9Vd4sWazEM=@vger.kernel.org
X-Gm-Message-State: AOJu0Yw/5KgxETq/CKuODs/AGoud3zCJQ4/KfOk3oQt2OHWVStszMl2Z
	NTNsrd84Oig5BaBWsJk+ucXWoNvJXGuMXpyLqTcwCVoyEqSTDye21gd1bEUbMoYVLuf7GrFBIeW
	xIWCZAcorBlHq/sobZ54oK7+O3T3cwIKq2ke6q2Es
X-Gm-Gg: ASbGnctmMa4Rw2/wPjGELsYhyCiS76ZVc1BbyQKOEeCl0JqqAqtGbLBhDznIJ/sOfro
	i0v8MPbxuK3JoN+UVcU1xE0yResB9FdnthrWXAug8KtXriR7EYbKh5cFdvzTgfx+G7FuV9w2y4/
	YonWbNzYUnxVi67vwvBsKkeAg8RUiwJBdxs7BodbvXqLimTP2/OPmGOvBNKNHaF66/BfCDUMr3G
	k7cB4UDSVqGZAQY857HAGNNy3wibD1yLzLV7HasUafAIwRPUBtk4vBZzuRmxXI35cPnRCjWoz1+
	okZBWIG8umzXSVZkvD69W5JSUQ==
X-Google-Smtp-Source: AGHT+IH1dTN9h9lNDnRTlh4UyFd6aH1+EDMlfhkx9gNk7p2AjcKqv19bBUUeTsmBJjRKqPU2Xh2SmzFkyX1KkJheFqs=
X-Received: by 2002:a7b:cc99:0:b0:477:772e:9b76 with SMTP id
 5b1f17b1804b1-47790b11bbdmr102735e9.7.1763072060296; Thu, 13 Nov 2025
 14:14:20 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20251013185903.1372553-1-jiaqiyan@google.com> <176305834766.2137300.8747261213603076982.b4-ty@kernel.org>
In-Reply-To: <176305834766.2137300.8747261213603076982.b4-ty@kernel.org>
From: Jiaqi Yan <jiaqiyan@google.com>
Date: Thu, 13 Nov 2025 14:14:08 -0800
X-Gm-Features: AWmQ_bk6n8j-0ORtQ1jAf-pM3nvvAf6VB8V4V3Ju58iczpjKI42PYMXub9cNtfk
Message-ID: <CACw3F51cxSgd-=D46A6X6GptEZS8-JZ_MnB_yK_ZR1wktunYRA@mail.gmail.com>
Subject: Re: [PATCH v4 0/3] VMM can handle guest SEA via KVM_EXIT_ARM_SEA
To: Oliver Upton <oupton@kernel.org>, oliver.upton@linux.dev
Cc: maz@kernel.org, duenwen@google.com, rananta@google.com, 
	jthoughton@google.com, vsethi@nvidia.com, joey.gouly@arm.com, 
	suzuki.poulose@arm.com, yuzenghui@huawei.com, catalin.marinas@arm.com, 
	will@kernel.org, pbonzini@redhat.com, corbet@lwn.net, shuah@kernel.org, 
	kvm@vger.kernel.org, kvmarm@lists.linux.dev, 
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, 
	linux-doc@vger.kernel.org, linux-kselftest@vger.kernel.org, 
	Jason Gunthorpe <jgg@ziepe.ca>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Nov 13, 2025 at 1:06=E2=80=AFPM Oliver Upton <oupton@kernel.org> wr=
ote:
>
> On Mon, 13 Oct 2025 18:59:00 +0000, Jiaqi Yan wrote:
> > Problem
> > =3D=3D=3D=3D=3D=3D=3D
> >
> > When host APEI is unable to claim a synchronous external abort (SEA)
> > during guest abort, today KVM directly injects an asynchronous SError
> > into the VCPU then resumes it. The injected SError usually results in
> > unpleasant guest kernel panic.
> >
> > [...]
>
> I've gone ahead and done some cleanups, especially around documentation.
>
> Applied to next, thanks!

Many thanks, Oliver!

I assume I still need to send out v5 with typo fixed, comments
addressed, and your cleanups applied? If so, what specific tag/release
you want me to rebase v5 onto?

>
> [1/3] KVM: arm64: VM exit to userspace to handle SEA
>       https://git.kernel.org/kvmarm/kvmarm/c/ad9c62bd8946
> [2/3] KVM: selftests: Test for KVM_EXIT_ARM_SEA
>       https://git.kernel.org/kvmarm/kvmarm/c/feee9ef7ac16
> [3/3] Documentation: kvm: new UAPI for handling SEA
>       https://git.kernel.org/kvmarm/kvmarm/c/4debb5e8952e
>
> --
> Best,
> Oliver

