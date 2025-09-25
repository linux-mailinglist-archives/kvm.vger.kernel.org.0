Return-Path: <kvm+bounces-58784-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 6E8E3BA0973
	for <lists+kvm@lfdr.de>; Thu, 25 Sep 2025 18:25:20 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 19B3D387D04
	for <lists+kvm@lfdr.de>; Thu, 25 Sep 2025 16:25:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 13FD7309F09;
	Thu, 25 Sep 2025 16:24:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="NnnRycWg"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yx1-f50.google.com (mail-yx1-f50.google.com [74.125.224.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5F3983054CE
	for <kvm@vger.kernel.org>; Thu, 25 Sep 2025 16:24:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.224.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758817477; cv=none; b=KJUvgwHov4k/a+pVFgEY8UNHTqKVT4h8ygLryG91m22GdUJUI7rIoirsi60UiArK/kTV9tRziLkos7brdArLtnO2jOTiLCW8eL9mJRYr/TLz0wafbEDEy6hIDfN0MigxVbqQzTh7My7HtV372nsoUi9Alkopwl3Fn81yylt8c14=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758817477; c=relaxed/simple;
	bh=8qUa6cA3znTxoOpGXfoo4TyTGGzRrVWFnP4eiBE3wkc=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=PUbe3Dqpp7tx/OPa0r374eEzhfbQSX2yW6A0gM/IueKgBGu0mKd1O8ptUV7F7IdWMt9R/Wb1kl4+mlCXyDz5PtYkdj4e5w73E7T3gpB2yLzRC9Uz2prXDBGDrkrZqIfsE0vxf0F6cWmG/LiWLA5GwSRyNzM8GebcaXSL7dRlUBI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=NnnRycWg; arc=none smtp.client-ip=74.125.224.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-yx1-f50.google.com with SMTP id 956f58d0204a3-635c9db8a16so60308d50.0
        for <kvm@vger.kernel.org>; Thu, 25 Sep 2025 09:24:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1758817474; x=1759422274; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=mFjmNLr/5g6yHzhx7AeEowYbwd8gsENi5VESj/oPYlo=;
        b=NnnRycWgBh9kRqu+LobSPN+Nmg5j0pjggneOBJJiMGyan14z5X2B8HehzaO0UFQVYP
         7M2IzIwv15BYUAn9LuEd3EMPlEGTUc3Pai+srNLAjVZjKSag3jYuwI+HBTvgeccP3L6E
         2zf/qnAy5n2u9ckOpzBy+Gb4qGWe7//KdIfMlFr+m1d8gQQKJrskLZ0DlwYBOQZ30ljE
         JSntSdFwOgO6dIGuLAJKYlFOHduumO3572UpvDUVYajRb+VXU/sXog0v8M7FsIr0Vk2q
         tsqVCCxK58a0V3H26C3ud545s7hiUtvGx+EilEoCpiG0wEepN6AYeqf1z09OyzZ9a7NB
         vLlg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758817474; x=1759422274;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=mFjmNLr/5g6yHzhx7AeEowYbwd8gsENi5VESj/oPYlo=;
        b=Fgi8B1e5gK+9OVeDEeCFx5X5ywxMFgBNWbswigrz+ITiwoksnwA3KYbeJhq2UjEuD3
         MXB6v8mx1s+5NwgSKLfyKC1zTLdxhPU7AGvolqn+AVfcyUGSENUKqhv0eKAYndehyr43
         YPTQfPKbROKxOrSPHwajV+QaJh1LeHSlCEEGNOg0NYCyj4s0BVIMOEGglWJ+H3S0LdeI
         Cy6aHcb2bjR3+aX1kuqlqIdKFQSrvZxBNLE+JfNnAa/CyIQbsdVe0wrO7WU+hozpcLbF
         FZ9OhKnqpEbqFK9HS4s05toDcQlvclzDKqzsFVjP6r3z2tXVm5ieR4LoGTt4DtCFmqPl
         PvUw==
X-Forwarded-Encrypted: i=1; AJvYcCX43fVMHeUKNU1T0SPzylO9iVTCXkzrS6XCK08QPNmUhxGJ+JfLXKZ5Ys3wqOuLQLr71Ns=@vger.kernel.org
X-Gm-Message-State: AOJu0YzTL3UFafM8UnATBTQ8FxJjJhlxLXydbAsToR7iLh4CYnfD99fh
	RX2EGnGS3/IeYNgWbt/onphn6bUm7MDsweI1HzkmrchqdrE4ZOpT6cc2kWBFyrUg/a8pfxYq57F
	+eOiZF/gTbz99nTX+Ogm5+ID3KKTV8HqOD8oPfBNJGQ==
X-Gm-Gg: ASbGncsDmUiDx9/P2An576CSDYI0Q+5XEi7OztPgwWHYdkH53VfBc6Wi4BwQn8zoXwE
	3per2g6bWWhe6aaBJqEaf73RjG/OELC5/1yT/01L5wzP6fZMBgmsJA0BQxqpIdxzC+1mX0DtRHc
	OWEaZ+dUI/sVggZAbjMssR88Ku8i6g/g3JdMqIIkk73r3U/mijAUumea1xHRtJjUxdf6G9IUtLI
	JpG+kHu
X-Google-Smtp-Source: AGHT+IE12IosBY1ByRI9crTKRkKTut/TYCvZHGTpRTLSzEBxrKqDsm+1ao3s/LRX5BcWQp38IEh1BgBa11rEQAK+vZU=
X-Received: by 2002:a53:ed11:0:b0:633:ab16:f82c with SMTP id
 956f58d0204a3-6361a7bf340mr2478091d50.18.1758817474111; Thu, 25 Sep 2025
 09:24:34 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250920140124.63046-1-mohamed@unpredictable.fr> <20250920140124.63046-4-mohamed@unpredictable.fr>
In-Reply-To: <20250920140124.63046-4-mohamed@unpredictable.fr>
From: Peter Maydell <peter.maydell@linaro.org>
Date: Thu, 25 Sep 2025 17:24:22 +0100
X-Gm-Features: AS18NWCWah7mgqpnrCZyELqD3G7reW_ZdwmZM5Jp0Wr6Jo1dbHsbHx-sqSJyajM
Message-ID: <CAFEAcA-398ZMeLUbHWyUw4np81mLikEn2PkQnFQMY4oY_iWRFA@mail.gmail.com>
Subject: Re: [PATCH v6 03/23] hw/arm: virt: add GICv2m for the case when ITS
 is not available
To: Mohamed Mediouni <mohamed@unpredictable.fr>
Cc: qemu-devel@nongnu.org, Shannon Zhao <shannon.zhaosl@gmail.com>, 
	Yanan Wang <wangyanan55@huawei.com>, Phil Dennis-Jordan <phil@philjordan.eu>, 
	=?UTF-8?Q?Daniel_P=2E_Berrang=C3=A9?= <berrange@redhat.com>, 
	=?UTF-8?B?TWFyYy1BbmRyw6kgTHVyZWF1?= <marcandre.lureau@redhat.com>, 
	Mads Ynddal <mads@ynddal.dk>, =?UTF-8?Q?Philippe_Mathieu=2DDaud=C3=A9?= <philmd@linaro.org>, 
	Cameron Esfahani <dirty@apple.com>, Paolo Bonzini <pbonzini@redhat.com>, Zhao Liu <zhao1.liu@intel.com>, 
	"Michael S. Tsirkin" <mst@redhat.com>, kvm@vger.kernel.org, Igor Mammedov <imammedo@redhat.com>, 
	qemu-arm@nongnu.org, Richard Henderson <richard.henderson@linaro.org>, 
	Roman Bolshakov <rbolshakov@ddn.com>, Pedro Barbuda <pbarbuda@microsoft.com>, 
	Alexander Graf <agraf@csgraf.de>, Sunil Muthuswamy <sunilmut@microsoft.com>, 
	Eduardo Habkost <eduardo@habkost.net>, Ani Sinha <anisinha@redhat.com>, 
	Marcel Apfelbaum <marcel.apfelbaum@gmail.com>, Pierrick Bouvier <pierrick.bouvier@linaro.org>
Content-Type: text/plain; charset="UTF-8"

On Sat, 20 Sept 2025 at 15:02, Mohamed Mediouni
<mohamed@unpredictable.fr> wrote:
>
> On Hypervisor.framework for macOS and WHPX for Windows, the provided environment is a GICv3 without ITS.
>
> As such, support a GICv3 w/ GICv2m for that scenario.
>
> Signed-off-by: Mohamed Mediouni <mohamed@unpredictable.fr>
>
> Reviewed-by: Pierrick Bouvier <pierrick.bouvier@linaro.org>
> ---
>  hw/arm/virt-acpi-build.c | 4 +++-
>  hw/arm/virt.c            | 8 ++++++++
>  include/hw/arm/virt.h    | 2 ++
>  3 files changed, 13 insertions(+), 1 deletion(-)

Looking at this I find myself wondering whether we need the
old-version back compat handling. The cases I think we have
at the moment are:

 (1) TCG, virt-6.1 and earlier: no_tcg_its is set
   -- you can have a gicv2 (always with a gicv2m)
   -- if you specify gic-version=3 you get a GICv3 without ITS
 (2) TCG, virt-6.2 and later:
   -- gic-version=2 still has gicv2m
   -- gic-version=3 by default gives you an ITS; if you also
      say its=off you get GICv3 with no ITS
   -- there is no case where we provide a GICv3 and are
      unable to provide an ITS for it
 (3) KVM (any version):
   -- gic-version=2 has a gicv2m
   -- gic-version=3 gives you an ITS by default; its=off
      will remove it
   -- there is no case where we provide a GICv3 and are
      unable to provide an ITS for it
 (4) HVF:
   -- only gic-version=2 works, you get a gicv2m

and I think what we want is:
 (a) if you explicitly disable the ITS (with its=off or via
     no_tcg_its) you get no ITS (and no gicv2m)
 (b) if you explicitly enable the ITS you should get an
     actual ITS or an error message
 (c) the default should be its=auto which gives
     you "ITS if we can, gicv2m if we can't".
     This is repurposing the its= property as "message signaled
     interrupt support", which is a little bit of a hack
     but I think OK if we're clear about it in the docs.
     (We could rename the property to "msi=(off,its,gicv2m,auto)"
     with back-compat support for "its=" but I don't know if
     that's worth the effort.)

And then that doesn't need any back-compat handling for pre-10.2
machine types or a "no_gicv3_with_gicv2m" flag, because for
10.1 and earlier there is no case that currently works and
which falls into category (c) and which doesn't give you an ITS.
(because we don't yet have hvf gicv3 implemented: that's a new
feature that never worked in 10.1.)

What do you think?

thanks
-- PMM

