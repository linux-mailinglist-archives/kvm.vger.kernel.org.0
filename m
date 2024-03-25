Return-Path: <kvm+bounces-12623-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id DD16D88B2FE
	for <lists+kvm@lfdr.de>; Mon, 25 Mar 2024 22:42:10 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 69B5D1FA009C
	for <lists+kvm@lfdr.de>; Mon, 25 Mar 2024 21:42:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A03C66FE2A;
	Mon, 25 Mar 2024 21:41:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="jYIp0by4"
X-Original-To: kvm@vger.kernel.org
Received: from mail-ed1-f51.google.com (mail-ed1-f51.google.com [209.85.208.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 35CFA6F533
	for <kvm@vger.kernel.org>; Mon, 25 Mar 2024 21:41:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711402909; cv=none; b=SQ+UY3XvIWn/t3thgJzvsUdyiaqn328qlGS2WM1EpLEbF3KVzm0GP0lJU4k71QrnepFYCb6U1aQUu3WSEwlxDiyCoPnykio1SMjdfNnJ+H7dreQlf5nL0XIjSGNR9uYrhrTuYIpOdOWzuoSyyVuWpDYTb9JpAyiQAol2WQeLBAY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711402909; c=relaxed/simple;
	bh=hD9XsIBzAV/bPhZwOQmQep3NyRgaTjUJYFuVVNQO7Yw=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=UDiRcJs+nmLRZWK1Phv5YET7ryYgLRFZW4a5nj0iacE4hEUFSiWKXWmNmAQJGrRcvlawVIM+xV8WtUCCXlENUI6GtdF3NmF+D0QDpeBzKnRFJq+dOGGXMw0iJshKWhs8Ifb/9nb0OpXlFYqsnDEns8h8H+Vms4bDW3Jklu1cVbc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=jYIp0by4; arc=none smtp.client-ip=209.85.208.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-ed1-f51.google.com with SMTP id 4fb4d7f45d1cf-56c1a50b004so2652a12.0
        for <kvm@vger.kernel.org>; Mon, 25 Mar 2024 14:41:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1711402906; x=1712007706; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=O/KboFRJyODJZyWJydsADn20bl4YX3uVsNj1S+g1jiA=;
        b=jYIp0by4RD9yx8iqDLdDhq7bozzs5ImXfzfVIyurahnTYqKNA8NpOkkwK5Ih7jS5WN
         a/KKp5qwN+tfCs4eWb2XgEQpw3G4zzFwF71mEQS2++87NKl+x709eq3esV1HxbwrzFnG
         gTWACJXfsjJ27HeH5sfcBbFt9TI37vdZqaP8bo4aIuhINPlCjxNl09va5SprMhvGBf+i
         +gNbsv8J8p1VTXM4S9yrFjtq+VG4l2jH35/6nmk0MS/KsDdKYqKQV2o3k8tmEs1pl0bw
         tSG6O/aQ0nzUqXkL6XD0X8O1jLtiJwypqHNfJmo+jC1BSIpCT9eLFVBI/3+YXcqkK/7I
         9oLg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1711402906; x=1712007706;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=O/KboFRJyODJZyWJydsADn20bl4YX3uVsNj1S+g1jiA=;
        b=wggOgKXtO9Ka1yQV3i411YKhG1suC4I91Bk9ph4sTqgulj1Gmdr4mAzYHPb8AmiFDf
         f/WvNprhrIz/FPxMGRr4vJ7f+XnS3ilwu4vBvN2Qp6rsTHCtKWLISctL2Kkdz9oX8g5Y
         +e4Ioiaq5RsvjVeES4KbRt31zpn/6veg4KS4dPVY9JXyCyw2bUDp3znPs8m7tizbDWqk
         Rm8/PjIspObS+/FOBrfP/JNz1zNms0DonPNdmx1EJGpnQM9A6LchIyT0KzRBw+deeAJ2
         wbO8Y/Yxs3NC9ZHvl6zVqwiPb89IX5cqE4gp0BgyMimSVt/TRmvblDJJbH1lN08BA8dL
         obHw==
X-Forwarded-Encrypted: i=1; AJvYcCUN+Vy/NpbZSrqUmK3t+EC58KEkDR2767VSmpYklY9zOmoOQeagjx8Ds8cNS5iQrqEM0CBF98v5bWa2dlReV4DcYFn5
X-Gm-Message-State: AOJu0Yw55ATZMXdAMJxJ/S7TaF841vPTo0hJy30SfDI5YLsaMrRaOLVj
	DvlkXsIXJKQsU1kABlkh/ZnHZaBGdFnrSYdnXM4ywwq+ssMfzAhPTVqHaRjxq+RWmfS46UIBqaJ
	0f4/F0IpdsJ7IA+S/9jnZq4lOR6fajZxiapv+
X-Google-Smtp-Source: AGHT+IHgkwX8y9U03a0Hq2u9cOn7hIzoMZsLqoGAIZkeovc4m2XkeHedXDRkFuGzeQSfjLbAnvGesQj0WAvl+cOCr+U=
X-Received: by 2002:aa7:c44d:0:b0:568:7767:14fd with SMTP id
 n13-20020aa7c44d000000b00568776714fdmr27919edr.7.1711402906313; Mon, 25 Mar
 2024 14:41:46 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240103031409.2504051-1-dapeng1.mi@linux.intel.com> <20240103031409.2504051-3-dapeng1.mi@linux.intel.com>
In-Reply-To: <20240103031409.2504051-3-dapeng1.mi@linux.intel.com>
From: Jim Mattson <jmattson@google.com>
Date: Mon, 25 Mar 2024 14:41:31 -0700
Message-ID: <CALMp9eSsF22203ZR6o+qMxySDrPpjVNYe-nBRjf1vSRq9aBLDA@mail.gmail.com>
Subject: Re: [kvm-unit-tests Patch v3 02/11] x86: pmu: Enlarge cnt[] length to
 64 in check_counters_many()
To: Dapeng Mi <dapeng1.mi@linux.intel.com>
Cc: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org, 
	linux-kernel@vger.kernel.org, Zhenyu Wang <zhenyuw@linux.intel.com>, 
	Zhang Xiong <xiong.y.zhang@intel.com>, Mingwei Zhang <mizhang@google.com>, 
	Like Xu <like.xu.linux@gmail.com>, Jinrong Liang <cloudliang@tencent.com>, 
	Dapeng Mi <dapeng1.mi@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Jan 2, 2024 at 7:09=E2=80=AFPM Dapeng Mi <dapeng1.mi@linux.intel.co=
m> wrote:
>
> Considering there are already 8 GP counters and 4 fixed counters on
> latest Intel processors, like Sapphire Rapids. The original cnt[] array
> length 10 is definitely not enough to cover all supported PMU counters on=
 these
> new processors even through currently KVM only supports 3 fixed counters
> at most. This would cause out of bound memory access and may trigger
> false alarm on PMU counter validation
>
> It's probably more and more GP and fixed counters are introduced in the
> future and then directly extends the cnt[] array length to 64 once and
> for all.
>
> Signed-off-by: Dapeng Mi <dapeng1.mi@linux.intel.com>
> ---
>  x86/pmu.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/x86/pmu.c b/x86/pmu.c
> index 0def28695c70..a13b8a8398c6 100644
> --- a/x86/pmu.c
> +++ b/x86/pmu.c
> @@ -254,7 +254,7 @@ static void check_fixed_counters(void)
>
>  static void check_counters_many(void)
>  {
> -       pmu_counter_t cnt[10];
> +       pmu_counter_t cnt[64];

I think 48 should be sufficient, based on the layout of
IA32_PERF_GLOBAL_CTRL and IA32_PERF_GLOBAL_STATUS.

In any event, let's bump this up!

Reviewed-by: Jim Mattson <jmattson@google.com>

