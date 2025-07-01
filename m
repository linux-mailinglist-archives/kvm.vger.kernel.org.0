Return-Path: <kvm+bounces-51174-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 2DD35AEF48C
	for <lists+kvm@lfdr.de>; Tue,  1 Jul 2025 12:09:19 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id B72703B5B6B
	for <lists+kvm@lfdr.de>; Tue,  1 Jul 2025 10:06:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 76AB026FA58;
	Tue,  1 Jul 2025 10:05:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="nPWj4FZi"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yw1-f179.google.com (mail-yw1-f179.google.com [209.85.128.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F377526B956
	for <kvm@vger.kernel.org>; Tue,  1 Jul 2025 10:05:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751364332; cv=none; b=OCbnw3hLZeAJu80rlONIkD+nss0+nmLhk1kjP0JMUe1vaWyBuwWmHK/i6sAiogttuJRCZApeDsiBpowJz+ysLTiUtpVKa0JruzUs7c55ANLj/RdXXV8CzuwqW3Y98UGkx1MxFWNJvVwd4Us1IV/9eZrEKU+BlPXg9uMhtf3ly6I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751364332; c=relaxed/simple;
	bh=AZ/p9qSngzF8C8/OxzNQHEHGwzewSrYWBomnL17x9TU=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=WTtqn6LX4v06n7KwYOF0fJA/Gd4dbCk+xFnAHLUKJNa1U0sVmubBYttW29gYF+wfOOQ2V7nHXQsnX7L2hfXtth6X7UVUpy3QQQoaHcQXPiDUS8s4byX8+Dv0bucBgZQvuHqFWdcaO/YFatjQUFHiTsvkpZUMv+GHiKG6lMWk/uU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=nPWj4FZi; arc=none smtp.client-ip=209.85.128.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-yw1-f179.google.com with SMTP id 00721157ae682-714066c7bbbso60817867b3.3
        for <kvm@vger.kernel.org>; Tue, 01 Jul 2025 03:05:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1751364330; x=1751969130; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=8kfjRtLV5ssMj94wMWxrtiAx9c7qnsX2Z+NOkWxYACI=;
        b=nPWj4FZiLAuDWs5w6wN9NVDh6ANWNIsCF6xCkblFP+wOGJQF4Vptmef2niBZpZ1YEq
         hoakPH6zzoGOVE2CO65HFg6QxhG5U4CuVJdj4DDN4U5zQJkFFqtmRdsQGNKOzdVZvmvp
         kd7MX9ECGm3TyHnMnJK8QZI++WW/I7g/K6G5hVGDPV2a9FwaNlYPfzMPOoUvqESnWnd4
         dyQo4dVFrafULhUA6G1tV2jRaquazwbnJWNT4pXW1xOuRKxNlcaYcr3qxPI7Vqy9ppFI
         dey5R+KXQyBM+k53VJy8Jj5nhnITTtTVvGLBigpLE3r9HBMdsGlKp35Sri90aLxSVjB+
         u8zg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1751364330; x=1751969130;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=8kfjRtLV5ssMj94wMWxrtiAx9c7qnsX2Z+NOkWxYACI=;
        b=swCutCPyT9KJT3ihWrQidgWk0ZlJIxhfxBE32XBcfPIl8XVrogkcRmbq8s2bGlEPac
         j/dUoeg46ZbGqyUAc5eWb7Na617v0nTUR9Hy3kxe/yaHiTOG9IgwnOL0dGUxvH/jtoHj
         5i5zpDPFMrCIYOpntKhl/HjoSSkAjdDj4oB4Ae6HeV4phj04Wug/6YeU2wYRRJJDdCse
         SRWMxLoSbbQ9nHnoRcdyMQvPQBsx9goLsSb2im3+Ir0IYotyWYxZopYnWSYzBjPvf3Ke
         LINOjGYhMfT2IixKzD/BE+jB+56xnvmwc80gvTQy5ib6Kiv6Dv+Lga69iWEOJ9kGVPmM
         QwgA==
X-Forwarded-Encrypted: i=1; AJvYcCW48CqS1cYVYaaVtBro0l3RGem7vxvcnvK2UxALipHV9+WeDt6irkuigVk4p9wfYK5UVkM=@vger.kernel.org
X-Gm-Message-State: AOJu0YxjH5M4a2+c/hqbigILaj+0PgAO0Hyjv18DToBOvZ81XMAK8L9b
	5NOZ43dDgDXMgX5wReVsYqHW6MhhU2Cd4Rul6+0NzEjOEehnP71Zz49jmsjJEAO5QUURaFLi98q
	SUxhMDeEiuTyWpZ9Wi97CSCKW6GHRm93C0Z/S5Dt/Zg==
X-Gm-Gg: ASbGncuwu23BBBALvtGDr8lDN67enhtNqJZlsZKs20+98O1+6CLxIL6sce9m4FwOZra
	OoBPXJ6GqtuXQ2OOG3s0K+V+zyqywhbPiQ2k4qR1wqI2DncARxNoYcQ64kQPGhYbWd6TLzTODSz
	QuLyAHXJsDMyOqGu1+YOogLWxt835Erubj6HEAEqP8EfLi
X-Google-Smtp-Source: AGHT+IGOpIzUKfVZ51suWX9MeleA4XpykzcLNH+i6xXehvun3Xncgjy5GjPloXM/LCbq34wBW2AkLyClhKEvOdHIBxM=
X-Received: by 2002:a05:690c:6109:b0:711:9770:161f with SMTP id
 00721157ae682-7151715b6f0mr247333597b3.2.1751364329873; Tue, 01 Jul 2025
 03:05:29 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250623121845.7214-1-philmd@linaro.org> <20250623121845.7214-19-philmd@linaro.org>
In-Reply-To: <20250623121845.7214-19-philmd@linaro.org>
From: Peter Maydell <peter.maydell@linaro.org>
Date: Tue, 1 Jul 2025 11:05:18 +0100
X-Gm-Features: Ac12FXwOiStkTc29Xq_uInkklsV0tTSFUxB5oz_6xMzY-cgZwTpqcNIDDEe6VkY
Message-ID: <CAFEAcA_M+nXYL5HaN7QUUwWywJw8VaxU3T54YCMQsVd42PQ+PA@mail.gmail.com>
Subject: Re: [PATCH v3 18/26] hw/arm/virt: Only require TCG || QTest to use TrustZone
To: =?UTF-8?Q?Philippe_Mathieu=2DDaud=C3=A9?= <philmd@linaro.org>
Cc: qemu-devel@nongnu.org, Leif Lindholm <leif.lindholm@oss.qualcomm.com>, 
	qemu-arm@nongnu.org, =?UTF-8?Q?Daniel_P=2E_Berrang=C3=A9?= <berrange@redhat.com>, 
	Roman Bolshakov <rbolshakov@ddn.com>, Paolo Bonzini <pbonzini@redhat.com>, 
	Alexander Graf <agraf@csgraf.de>, Bernhard Beschow <shentey@gmail.com>, John Snow <jsnow@redhat.com>, 
	Thomas Huth <thuth@redhat.com>, =?UTF-8?B?TWFyYy1BbmRyw6kgTHVyZWF1?= <marcandre.lureau@redhat.com>, 
	kvm@vger.kernel.org, Eric Auger <eric.auger@redhat.com>, 
	Cameron Esfahani <dirty@apple.com>, Cleber Rosa <crosa@redhat.com>, 
	Radoslaw Biernacki <rad@semihalf.com>, Phil Dennis-Jordan <phil@philjordan.eu>, 
	Richard Henderson <richard.henderson@linaro.org>, =?UTF-8?B?QWxleCBCZW5uw6ll?= <alex.bennee@linaro.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, 23 Jun 2025 at 13:20, Philippe Mathieu-Daud=C3=A9 <philmd@linaro.or=
g> wrote:
>
> We only need TCG (or QTest) to use TrustZone, whether
> KVM or HVF are used is not relevant.
>
> Reported-by: Alex Benn=C3=A9e <alex.bennee@linaro.org>
> Signed-off-by: Philippe Mathieu-Daud=C3=A9 <philmd@linaro.org>
> Reviewed-by: Richard Henderson <richard.henderson@linaro.org>
> ---
>  hw/arm/virt.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/hw/arm/virt.c b/hw/arm/virt.c
> index 99fde5836c9..b49d8579161 100644
> --- a/hw/arm/virt.c
> +++ b/hw/arm/virt.c
> @@ -2203,7 +2203,7 @@ static void machvirt_init(MachineState *machine)
>          exit(1);
>      }
>
> -    if (vms->secure && (kvm_enabled() || hvf_enabled())) {
> +    if (vms->secure && !tcg_enabled() && !qtest_enabled()) {
>          error_report("mach-virt: %s does not support providing "
>                       "Security extensions (TrustZone) to the guest CPU",
>                       current_accel_name());

The change is fine, but the commit message is odd. You
only get to pick one accelerator. The reason for preferring
"fail unless accelerator A or B" over "fail if accelerator
C or D" is that if/when we add a new accelerator type E
we want the default to be "fail". Then the person implementing
the new accelerator can add E to the accept-list if they
implement support for an EL3 guest.

For the not-yet-implemented case of a hybrid hvf+TCG
accelerator, it's not clear what to do: in some cases
where we check the accelerator type you'll want it to
act like TCG, and sometimes like hvf.

I'll take these patches, with an updated commit message.

-- PMM

