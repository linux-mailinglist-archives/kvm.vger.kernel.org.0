Return-Path: <kvm+bounces-22512-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 62ECF93F934
	for <lists+kvm@lfdr.de>; Mon, 29 Jul 2024 17:15:43 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 06A5F2833C2
	for <lists+kvm@lfdr.de>; Mon, 29 Jul 2024 15:15:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E7F8F154C0C;
	Mon, 29 Jul 2024 15:15:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="CFxDaIab"
X-Original-To: kvm@vger.kernel.org
Received: from mail-lj1-f170.google.com (mail-lj1-f170.google.com [209.85.208.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 67EDB1E4A2
	for <kvm@vger.kernel.org>; Mon, 29 Jul 2024 15:15:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722266136; cv=none; b=IcqrwNewhueg40ehPLA5ln8Idr4BgnSJgqjci/LXM1TTWR3uN7m2jjqPr8PkwnL4trwikz+tjWOmqYybd0LALF2ohwKy8jLhnnTbq3cKfGVpdLZ2xa/Pb8On3tW6saM3cvWU1SyB1zYccOH6kWozxBQmCOKgu5cNB9RG7Vd8uWk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722266136; c=relaxed/simple;
	bh=rOgmwIln/CNmyCh2hWKhzIw8YIxDDZtaydSHihaddhg=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=gZypawwmvQPP3tTBf+FsM8KHlozjCFhrjbNYwCBhTQkEmfab5Nl8H2vTUm1gp4l0cSDI3zSCenDc5R/LfZ46UZGddYoqhHs+Kfu8VbTFx76aVSyh4DQXOqOXXUOF/Ihjcy+dl+GZPrV3242npsZ3f9WQBJv1Dp7X5BoWOEztChA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=CFxDaIab; arc=none smtp.client-ip=209.85.208.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-lj1-f170.google.com with SMTP id 38308e7fff4ca-2f029e9c9cfso56738451fa.2
        for <kvm@vger.kernel.org>; Mon, 29 Jul 2024 08:15:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1722266133; x=1722870933; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=BKuqbZOXAboBHx1ox4X60UNfaU6nkT1ePbeK4FEBPyY=;
        b=CFxDaIabYolCHQeWnr3DwuWUQvIxFouo9WSBCXExvWRq+awt25+8fNIjHxoBtuq/qi
         dJbubiXmdz/WRIRN4yXCnkGGTygLggwup5mhAoPMn9oenAsRD8NsxcVzm8Tv8x9NrcVn
         GgLxLS311Z22rSQYokH0kj/FcazgMzgEr/GqJfXDUwPVrB7Ou8RqdgMvyswYM1k2lMqH
         4bMyHLQ3QqYdoUarrUtwQa/b3PJo4e2JqTPi9+rs453Vcjshy7IDWq8brUsVcCLA6/xa
         GZYwl/agXWZdK6QIpDjbP9MY+pW1FLpPg4hxd9tR/pVLvOKVKf+5ch8wxOBvJwk8zgwg
         OCBA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1722266133; x=1722870933;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=BKuqbZOXAboBHx1ox4X60UNfaU6nkT1ePbeK4FEBPyY=;
        b=ATCryqGZFFwNr1mxVVatGAVF6Kjl5Ylr+oNiYtina8tMKkEJpNY2MbxE1J5y40K6zG
         ix+Nqjvng6BOVLIS5+MioiV5csMf8edJoegw6VAKrDNwKp3cqGEGfJnR6U2PJX7felAc
         1Eknc7nIITtx6jNQXl+ehsk6xLkIoCRTjFk81luxnHSpMCSK5AtMPj7j7PsHs31FBqJZ
         o/PJVJIGKJjakKFfemb/v3l/QDAw2cm1F0g0S7/VkWTYsrrFFlGlUZldNQ21dxi4rPTY
         l8SJPO2hzUa3uqfLYijx1hCJZ1dmTSBjfRdcmQpSZ8sbDGdMNbmPCYn/1n7bHxfRr+Lr
         RXog==
X-Forwarded-Encrypted: i=1; AJvYcCVvdAAXuNXiG8BWWJBw+VWhOjbQYemRmnh//6uRQiqwTR/Ltr+rioyr6hUjesvu1A60b5miZMGlLDOe2IB05Guns10j
X-Gm-Message-State: AOJu0Yzrhw9SqXuwNROe/70XyFED6l63LwDUYtpFnzU/C50gGVg2Dlyz
	muNRxJgzhy0XB+44QHLo016ea5uzYGvlZwjXFBooREQyH3aDdhkzQxVQDinCQQBk2C/3H4nwApO
	nZ/8ElycqWeYPrTG8QSCaszvJevwFU57+as9jvA==
X-Google-Smtp-Source: AGHT+IH6NpqeyCy53Urzjt7DAz1mAGiYBBvjPwebwZmqBTOauCa8V/qyDGsSedppiqHaYqy8RMHdkT7z1Q9117GMDBw=
X-Received: by 2002:a2e:3208:0:b0:2ef:2422:dc21 with SMTP id
 38308e7fff4ca-2f12ee6322emr66771801fa.43.1722266132405; Mon, 29 Jul 2024
 08:15:32 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240720-pmu-v4-0-2a2b28f6b08f@daynix.com>
In-Reply-To: <20240720-pmu-v4-0-2a2b28f6b08f@daynix.com>
From: Peter Maydell <peter.maydell@linaro.org>
Date: Mon, 29 Jul 2024 16:15:21 +0100
Message-ID: <CAFEAcA-ReAnVnq3WCZGEvBhH03gmwANC8TaiwMx5K6y7wQGRZg@mail.gmail.com>
Subject: Re: [PATCH v4 0/6] target/arm/kvm: Report PMU unavailability
To: Akihiko Odaki <akihiko.odaki@daynix.com>
Cc: Thomas Huth <thuth@redhat.com>, Laurent Vivier <lvivier@redhat.com>, 
	Paolo Bonzini <pbonzini@redhat.com>, Cornelia Huck <cohuck@redhat.com>, qemu-arm@nongnu.org, 
	qemu-devel@nongnu.org, kvm@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

On Sat, 20 Jul 2024 at 10:31, Akihiko Odaki <akihiko.odaki@daynix.com> wrote:
>
> target/arm/kvm.c checked PMU availability but claimed PMU is
> available even if it is not. In fact, Asahi Linux supports KVM but lacks
> PMU support. Only advertise PMU availability only when it is really
> available.
>
> Fixes: dc40d45ebd8e ("target/arm/kvm: Move kvm_arm_get_host_cpu_features and unexport")
>
> Signed-off-by: Akihiko Odaki <akihiko.odaki@daynix.com>

> Akihiko Odaki (6):
>       target/arm/kvm: Set PMU for host only when available
>       target/arm/kvm: Do not silently remove PMU
>       target/arm: Always add pmu property for Armv7-A/R+
>       hvf: arm: Raise an exception for sysreg by default
>       hvf: arm: Properly disable PMU
>       hvf: arm: Do not advance PC when raising an exception

Thanks for this patchset; I've applied patches 1, 2, 4, 5 and 6
to target-arm.next, but I had comments about patch 3.
(Let me know if there's a dependency that 4-6 have on patch
3 that I've missed: but they look to me like they're
still OK to take without patch 3.)

-- PMM

