Return-Path: <kvm+bounces-63351-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 31218C63809
	for <lists+kvm@lfdr.de>; Mon, 17 Nov 2025 11:21:29 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 13DCA3B20E6
	for <lists+kvm@lfdr.de>; Mon, 17 Nov 2025 10:21:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 308D132B9A8;
	Mon, 17 Nov 2025 10:19:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="PvEz8Wi5"
X-Original-To: kvm@vger.kernel.org
Received: from mail-qt1-f177.google.com (mail-qt1-f177.google.com [209.85.160.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A918532A3D7
	for <kvm@vger.kernel.org>; Mon, 17 Nov 2025 10:19:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763374749; cv=none; b=IGnZ6ALryMqv8tLjCkdy5fKKSAfYLOTz+115y3YDsGW8QlO1V7udS3HcdQKZNgL0Ua5sVXhzfxVCTeZWDFazr3MHDFiI2JpL6uIq3qiQ9hAbrp2pLSuw+KCi4Wcr7xImHnDMtpc0KEdTwe+sA8ElBh3xtzZ84pfj9kmiQcQ7zFQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763374749; c=relaxed/simple;
	bh=zPYvPpxWU6t3N3nrbTSIJZK1EyfAajwNVGCdUHzuU1s=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=l7SNxMsErVd0ec0GR5TlcnuVbTeso9qLHbm1Mxo4m/WCzm5tI5RNl1uJIp1Pdhgy4Zu0kn7K0YWuTc5B9igFjG5fKZsTjZBPDaXAPTF7QIpzpi3wu/OpfKynkFh11I7u/zXJiwsZsz7w7xvpe7+CXOhqLLYrsK04+aYWZj4n1cY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=PvEz8Wi5; arc=none smtp.client-ip=209.85.160.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-qt1-f177.google.com with SMTP id d75a77b69052e-4ee243b98caso166531cf.1
        for <kvm@vger.kernel.org>; Mon, 17 Nov 2025 02:19:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1763374745; x=1763979545; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=7dSZwG+Ut4tx3N9fD6TcZFfeIFY+rAbw7tsG6scq/hU=;
        b=PvEz8Wi59rvbf2ATlUse4yyiBSKBboHKN5rkNl/jwwqrQwSJxaSYA/v1hT3w6vFID2
         1NCFskJ5Rhv3MKzAKTibbRlzyUso4tQlWi9tWDwhv3NPsgpf3LQ/My8tg0n27FpxDD9D
         a/nRb+gexrpA35cbo3roPmzQMwZw0sqQYUj2YEo4E0KGcj4RS91ATQghi4yJqRTBbgHi
         N1bG+pI2RTnr3NpF0OKDpEQjeLrzUi0wew74Um9416hYw/JjrtvMPx99m79EujIHE09f
         rVoV54Gxkaf4mg1TBeIPK6C25uX3d+YkcJMnlt3YkhouuYJL75atTA3DlQ2BNcwPjiRP
         VX/g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763374745; x=1763979545;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=7dSZwG+Ut4tx3N9fD6TcZFfeIFY+rAbw7tsG6scq/hU=;
        b=XoiFIhP72ceqMYJ9Zz7MjAPa5+9fswEgG1yMsqZgI/ZbVG8m4VrqG2Zi8Deifq3tDE
         cWBXOGwO5b5K4zuRjtlc4NSBC1CC6qDjo559X+RAhNNRHeiGKllTYVF89H6KCpO7tnXN
         YfO6WkLuk5GMx2if5P/MBKyT8eU78fR+0vPhGwiHQ785Vms8JISqhV/2UsCQRe+jIJCA
         RAF00SfZIndxH2QHRQ3DBmJO3QLknIA25F7vwQVXJ4LHAawoIgxhifNB8RHNSHcnzbKI
         iNnHewIiyxB/4Hq139ediiG463xB2lY9q8aeTzAZYJudu34A2uqF96jSB+IkLSFIe/2D
         gG0w==
X-Forwarded-Encrypted: i=1; AJvYcCVcGvQv7IliLP0G37OUnzwMkp/Z1uOtPc4P+7nrBndnLzDuTUVfEZNBlL9tPRzgyEWcmAU=@vger.kernel.org
X-Gm-Message-State: AOJu0YyxlVM7T6lOefFgU0qM7ZnyC1FR4kf/Y3TkfRGSTqJjIwNwwcLY
	ojLmrLrvXXnB5Npe8w1YZetnYjDdwRpcOD2Hqu+d9n8rZDu+D+9zF97KTaX+O5XZD0g5rErtrbB
	rgulBXbzdM3AjOm8wz7jzOkIwDN5SIQkcT2dw944g
X-Gm-Gg: ASbGncsqbPv6Tdz8r/Or8rQ+vxDN7PV4aqKHlY9MwR91Bcpjn2v7t54yXmnMhJBIRk2
	TmpqnbYkH7+wGRjDLqpmogaqE8T51RnAtcF/6Nx5Aq2WxfhiDYHdf7yCc++7/U0i4c6yKJV77qw
	pjmcrTqsVGa8nQP8jgt/ffpPIhZ7y6egotKWibVQPwJvME41Ayiv0G5eXz93petbUy4GG8nlgGu
	6uOW6e+f23d/yn0kPKs5eY1V15EDUeKC//bxBJ0g8WRrfWhPzTLZ60Khafy6BqYmfVtL1bMtwnN
	c9+rLg==
X-Google-Smtp-Source: AGHT+IFNmczB2ds9iTzz5FRf7oU0BYqq8SdTaWadzkP1SRAFOc8Pnz8a3JfCCCKf6Zz2U+3uKM0Q8RAviooSDsFqVnQ=
X-Received: by 2002:a05:622a:9:b0:4ed:70d6:6618 with SMTP id
 d75a77b69052e-4ee0292790emr11283261cf.10.1763374745320; Mon, 17 Nov 2025
 02:19:05 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20251117091527.1119213-1-maz@kernel.org> <CA+EHjTzudrep2hEno4RPwh8H88txiVYFoU7AyJYVWG9SFSk87Q@mail.gmail.com>
 <867bvpt25u.wl-maz@kernel.org>
In-Reply-To: <867bvpt25u.wl-maz@kernel.org>
From: Fuad Tabba <tabba@google.com>
Date: Mon, 17 Nov 2025 10:18:28 +0000
X-Gm-Features: AWmQ_bkalvPmo1B-rqo9IVXjMt6TjFkbAXf4VPzF4RKYlhIEuPNWjQgsoTvi3Ag
Message-ID: <CA+EHjTyLGFUDbyr_B1uj5ZpxQA9ypCBy0ZUNRQ8M8VdLmXimnw@mail.gmail.com>
Subject: Re: [PATCH v3 0/5] KVM: arm64: Add LR overflow infrastructure (the
 dregs, the bad and the ugly)
To: Marc Zyngier <maz@kernel.org>
Cc: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, 
	kvm@vger.kernel.org, Joey Gouly <joey.gouly@arm.com>, 
	Suzuki K Poulose <suzuki.poulose@arm.com>, Oliver Upton <oupton@kernel.org>, 
	Zenghui Yu <yuzenghui@huawei.com>, Christoffer Dall <christoffer.dall@arm.com>, 
	Mark Brown <broonie@kernel.org>
Content-Type: text/plain; charset="UTF-8"

Hi Marc,

On Mon, 17 Nov 2025 at 09:54, Marc Zyngier <maz@kernel.org> wrote:
>
> Hi Fuad,
>
> On Mon, 17 Nov 2025 09:40:47 +0000,
> Fuad Tabba <tabba@google.com> wrote:
> >
> > Hi Marc,
> >
> > On Mon, 17 Nov 2025 at 09:15, Marc Zyngier <maz@kernel.org> wrote:
> > >
> > > This is a follow-up to the original series [1] (and fixes [2][3])
> > > with a bunch of bug-fixes and improvements. At least one patch has
> > > already been posted, but I thought I might repost it as part of a
> > > series, since I accumulated more stuff:
> >
> > I'd like to test this series as well. Do you have it applied in one of
> > your branches at
> > https://git.kernel.org/pub/scm/linux/kernel/git/maz/arm-platforms.git
> > , or which commit is it based on?
>
> I just pushed a new branch
>
> https://git.kernel.org/pub/scm/linux/kernel/git/maz/arm-platforms.git/log/?h=kvm-arm64/vgic-lr-overflow-fixes
>
> that is based on -rc5, kvmarm/next, kvmarm-fixes-6.18-rc3 plus these
> patches. Let me know how this fares for you.

Great! I've applied the pKVM patches on top of it. So far so good.
I'll test this series more thoroughly and review it as well. Stay tuned...

Cheers,
/fuad

>
> Thanks,
>
>         M.
>
> --
> Without deviation from the norm, progress is not possible.

