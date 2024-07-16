Return-Path: <kvm+bounces-21710-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 210129326F0
	for <lists+kvm@lfdr.de>; Tue, 16 Jul 2024 14:54:16 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 523D41C22871
	for <lists+kvm@lfdr.de>; Tue, 16 Jul 2024 12:54:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 873A419AA76;
	Tue, 16 Jul 2024 12:54:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="xYd4iMYo"
X-Original-To: kvm@vger.kernel.org
Received: from mail-ed1-f49.google.com (mail-ed1-f49.google.com [209.85.208.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EF564145345
	for <kvm@vger.kernel.org>; Tue, 16 Jul 2024 12:54:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721134447; cv=none; b=AJ+7JJApB6Uu+TtOc6lmVZ6SCxvz020A2yQZmq8emD7tLdIj3H3fdTyYK4L2m+2meDvs+5YuJDv2JbvXgtYJCxE9PifxvJ0JEZpdFW6HTEZLE9GFZUZl2LyVpFgmSLWX5Oh/SIT1qurrESU6O4eJwZ4Vf+Kc8h8uz4Z9YU0RulU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721134447; c=relaxed/simple;
	bh=AagZ3KSJPaQ2c5LcLGZyazeXbqsk/VVwT6q9IfbPTVc=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=lYNSIgEFBEmJq1J6mx/mYNpGIvBZuMLy/GUFxDY/x7tCpH5E1KbmdhornQS+D4eEdIhWzGMDS5qLPF9O2iBuIHRp6tfd/3X48P05peGo0dPJitFIJe+Wx5KGOoHO83AKxvzIaFOszFzWu2PtQ54FYZHtqAJg6+SnVMHxstrwLy8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=xYd4iMYo; arc=none smtp.client-ip=209.85.208.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-ed1-f49.google.com with SMTP id 4fb4d7f45d1cf-58b0dddab63so8438707a12.3
        for <kvm@vger.kernel.org>; Tue, 16 Jul 2024 05:54:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1721134444; x=1721739244; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=sqljEqn1C9apKy4t0qCyw2u/x/yBR1Iv52IL5ilLhCY=;
        b=xYd4iMYoFBP7q/YcVHFILKk6orxIC2TED0KeER8x4uE60LTAzbttmSKChfOAKvEg3p
         9oxdpqOr1TB1BgIRv8+0XpIS8DD4UfMOcXlJsPhh9fMU5uupZtM/5xcWvMvHonCxViSr
         sXCT8APpcUq70pSAZelxUbA1hxRhzCG81cgKTiEOAcUcNEUB93KHo/ikThx32Qb1gphc
         HykuZUyf/gquy9zt5rwYVa/1F9napzxSn2+10IVqU8sNanSEM+bZfHJz9xgUzhQ94krJ
         CnP+fpFj+FabF99uFT1Es2/qXhl8mYfUrMnCxavD4KY6sTcyAOPsKfABAY08h/lcUCc7
         3FCQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1721134444; x=1721739244;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=sqljEqn1C9apKy4t0qCyw2u/x/yBR1Iv52IL5ilLhCY=;
        b=qMKctltfXHr3wukgpet50KDpjJKQzXaasPu8GVs3LORgBegrTgVLeU5Qkmyx/Ce8mE
         T62G2V/x7Nc4P4ycjcpHq6hcUBd1NoaOKZJ3EgMAbud2qBT3DyGKsq1aZ+s5c0lN2rgm
         x/8XcrIMfUmm57Y26/MmMRAgf8oqGVO7yxXC9IyfiJs4xVsx2+ICTJzc/VMr4LhFPPrR
         NsPzwkxb3SLdX+hgIYRPCa5l7Eb5yEpvbJSOmlcLclMRRqkutwkVHuVSeabMObLP/+KC
         6M0v4AhnNtF+oCfdCNAfrlCErZHJ3j+qctScqkrTGiPVbEbBd9cMVi1jqnO5/0YXL+i4
         ydKQ==
X-Forwarded-Encrypted: i=1; AJvYcCXWTQJiYoOs4QqwfFjM6L3Dgehyz1Cm1IAPjQwpHinbUx6wEV3TLUS56HdlHepWF+vBD8xBbvKT0lCLgNofAq/EHZwA
X-Gm-Message-State: AOJu0Yx5pfxiUVY5aI8zRE0yc71pM4Kp9x7zLBddHJfWaUYwyH5zQy92
	pGGUlnZ0pY3gMfbF+1uu3Hxop33wWrHwcwwFmheoJIfga7Em1tkJGWeybh4NdK6YDY5/5uVcfwq
	tZxiGwGddAPtIoUWaOESBS3I6uQ4PV1ZULHU5wQ==
X-Google-Smtp-Source: AGHT+IH2Eliu1efySAYYHAHGXrPaDZry8xEgFbC6jwNndsueWrJca5sZiNONC9zsXBngKhCtvNx4kLRoixRPSKjI86Q=
X-Received: by 2002:a05:6402:1ed6:b0:599:73cf:b219 with SMTP id
 4fb4d7f45d1cf-59eef45de4cmr1413426a12.21.1721134444289; Tue, 16 Jul 2024
 05:54:04 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240716-pmu-v2-0-f3e3e4b2d3d5@daynix.com> <20240716-pmu-v2-4-f3e3e4b2d3d5@daynix.com>
 <CAFEAcA9trFnYaZbVehHhxET68QF=+X6GRsEh+zcavL-1DxDB4w@mail.gmail.com> <cdd5ce60-230f-48a1-bcf3-9591b8bede95@daynix.com>
In-Reply-To: <cdd5ce60-230f-48a1-bcf3-9591b8bede95@daynix.com>
From: Peter Maydell <peter.maydell@linaro.org>
Date: Tue, 16 Jul 2024 13:53:52 +0100
Message-ID: <CAFEAcA8qN3X2yaBjth=1a7kUCmYY32Ho9nG5e2tiL21QCw1DkA@mail.gmail.com>
Subject: Re: [PATCH v2 4/5] target/arm: Always add pmu property
To: Akihiko Odaki <akihiko.odaki@daynix.com>
Cc: Thomas Huth <thuth@redhat.com>, Laurent Vivier <lvivier@redhat.com>, 
	Paolo Bonzini <pbonzini@redhat.com>, qemu-arm@nongnu.org, qemu-devel@nongnu.org, 
	kvm@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

On Tue, 16 Jul 2024 at 12:36, Akihiko Odaki <akihiko.odaki@daynix.com> wrote:
>
> On 2024/07/16 20:32, Peter Maydell wrote:
> > On Tue, 16 Jul 2024 at 09:28, Akihiko Odaki <akihiko.odaki@daynix.com> wrote:
> > Before we do this we need to do something to forbid setting
> > the pmu property to true on CPUs which don't have it. That is:
> >
> >   * for CPUs which do have a PMU, we should default to present, and
> >     allow the user to turn it on and off with pmu=on/off
> >   * for CPUs which do not have a PMU, we should not let the user
> >     turn it on and off (either by not providing the property, or
> >     else by making the property-set method raise an error, or by
> >     having realize detect the discrepancy and raise an error)
>
> I don't think there is any reason to prohibit adding a PMU to a CPU that
> doesn't have when you allow to remove one. For example, neoverse-v1
> should always have PMU in the real world.

For example, the Cortex-M3 doesn't have a PMU anything like the
A-profile one, so we shouldn't allow the user to set pmu=on.
The Arm1176 doesn't have a PMU like the one we emulate, so we
shouldn't allow the user to turn it on. All the CPUs where it
is reasonable and architecturally valid to have a PMU set the
ARM_FEATURE_PMU bit, so there (by design) is no CPU where that
bit isn't set by default but could reasonably be enabled by
the user.

Conversely, the PMUv3 is architecturally optional, so it's not
unreasonable to allow the user to disable it even if the
real-hardware Neoverse-V1 doesn't provide that as a config
option in the RTL.

thanks
-- PMM

