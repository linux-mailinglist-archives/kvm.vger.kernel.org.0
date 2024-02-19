Return-Path: <kvm+bounces-9084-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id B69F785A445
	for <lists+kvm@lfdr.de>; Mon, 19 Feb 2024 14:06:51 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 6D0882854B5
	for <lists+kvm@lfdr.de>; Mon, 19 Feb 2024 13:06:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6C64836122;
	Mon, 19 Feb 2024 13:06:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="C+MzW72Q"
X-Original-To: kvm@vger.kernel.org
Received: from mail-ed1-f46.google.com (mail-ed1-f46.google.com [209.85.208.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 264F236103
	for <kvm@vger.kernel.org>; Mon, 19 Feb 2024 13:06:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708347967; cv=none; b=cZ2Nt+vEEmqAfJrgvA3jnRw9Q06ZLAxPD8u+hZkLYqm8yfRLnfdTPGbrFemrKxhGjJckM1ias1dBu2AGm3A9Hw8hzmVWQPpGr1stUgmOhm0Jc/0ywGXfihyknjmlVQPywg5ZqUKdXN+5ao3AGhUFpn+akhRybGhLcrAZeJxAGmk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708347967; c=relaxed/simple;
	bh=lvJENqQxJwJ0qoNic8x/19fJ5CctFxYM4poH/XDfkd0=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=ErL4HnPmR/gbmWweMPqkffOvZ9i+QKtAGVUf+kl/hukfSE8J908ts2eNow84huy00id6AX/cFc6JRB0aTH3vbiq2ux2hv8rKXNWKnlRPqaGh3o5IeF0nym5HTKnYyQWLt33p/hwoYgQr57oKwmIgVVdLvSXNuPny3LRHr8e9CaE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=C+MzW72Q; arc=none smtp.client-ip=209.85.208.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-ed1-f46.google.com with SMTP id 4fb4d7f45d1cf-563d32ee33aso4207117a12.2
        for <kvm@vger.kernel.org>; Mon, 19 Feb 2024 05:06:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1708347961; x=1708952761; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=lvJENqQxJwJ0qoNic8x/19fJ5CctFxYM4poH/XDfkd0=;
        b=C+MzW72QzQIKOtQ6Q0FQpEdyi/ujvJ9KcAtflCQU1Vci+fIc77H1AyI7iz0lY3SkxZ
         mdTpum4HuCZfemZBrsGNwDggWdHjVy52eB1UOea6n0VVrdQwx8ZHqyZcrRGLxuH04xHi
         8YOMSXASWq7ruivvrvMbxk+DLg7kauKQTx4Rd8Z0r5VDCz4utHKWVMOSPFUNEPkpdp0+
         KJpcsQrwv+Phs+X6cm50EN1VPRrI0Gs4vqpg4HMf+a05L1mJEjJzk4Up1Wf+su++9VzP
         Oo15tTAA2RsDJYyuJxk80BNHS08qq5/eLDFR2+QEzZhl/8c9VpGQ15RMyLPu5u0a3b6X
         w7zg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1708347961; x=1708952761;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=lvJENqQxJwJ0qoNic8x/19fJ5CctFxYM4poH/XDfkd0=;
        b=Dkw92j8EpSG/0NIaWzIZUnVBxawdXkXLQv1SZzwkTDXm4stfg8v1OlmZJ2cE2QRZm1
         zY9OJZP/AgLXgr6FwQLWa/PoUomMs4DFk8FRE38A5Ho2m2hxm39bjOh1JvqZYIizfG/x
         4wRl9/Y1md8Nt9kheBhJEZ1NHDscxTCMs0D/RcJic3PCakiqQUtDReBzkMQcivchriJt
         Ca6ySfZyMin+FZR2nkKh8WJORlhscE0dgP3YIT3CfCJIOkTAY6a0FWuCgYrv56AbyLkg
         GKus7XIvs0DMk3WHK3IduPjnBXZ61c7zfHn/IEmCSbLrpyeJKx56t3F+yXwWPSpuCZNc
         n/JQ==
X-Forwarded-Encrypted: i=1; AJvYcCVmgITBwZb8AWJ9dRsVNsvfjfDTYork+wFkGIWZ3W/3XU5qLlSY2wJohNbnlwoRXQ3hzHngX6nyQTcr3xyerjxZXRbG
X-Gm-Message-State: AOJu0YwM7hq8ESbQjmKTNBx36WFnT7jLTfIDke3TvdX8AkTr/Y1hcUVq
	fJAjjs6i6dJheXBM79Sd3bHS82nMpSOHj9QKaljK7pe6ebMDIXKj3FXnAY5QMCyEFJpvF389uIR
	FxgoJ+IRxiR8ZcMDdhCF2Q/ZIWNo7+br52zuCnpQBYPOHR4TP
X-Google-Smtp-Source: AGHT+IG0a56R0m32KsH2yanNp4494mtviVMwKnua2tCjbQig49UxZQOlGaYhAEyFptZRFwQdkSNdXT8JhydyBGbdVmA=
X-Received: by 2002:aa7:df8e:0:b0:564:6b09:9300 with SMTP id
 b14-20020aa7df8e000000b005646b099300mr2051292edy.15.1708347961461; Mon, 19
 Feb 2024 05:06:01 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240216153517.49422-1-philmd@linaro.org> <20240216153517.49422-2-philmd@linaro.org>
 <bcfd3f9d-04e3-79c9-c15f-c3c8d7669bdb@eik.bme.hu> <2f8ec2e2-c4c7-48c3-9c3d-3e20bc3d6b9b@linaro.org>
 <b40fd79f-4d41-4e04-90c1-6f4b2fde811d@linaro.org> <00e2b898-3c5f-d19c-fddc-e657306e071f@eik.bme.hu>
 <2b9ea923-c4f9-4ee4-8ed2-ba9f62c15579@linaro.org> <6b5758d6-f464-2461-f9dd-71d2e15b610a@eik.bme.hu>
 <bc5929e4-1782-4719-8231-fe04a9719c40@ilande.co.uk>
In-Reply-To: <bc5929e4-1782-4719-8231-fe04a9719c40@ilande.co.uk>
From: Peter Maydell <peter.maydell@linaro.org>
Date: Mon, 19 Feb 2024 13:05:50 +0000
Message-ID: <CAFEAcA-Mvd4NVY2yDgNEdjZ_YPrN93PDZRyfCi7JyCjmPs4gAQ@mail.gmail.com>
Subject: Re: [PATCH 1/6] hw/arm: Inline sysbus_create_simple(PL110 / PL111)
To: Mark Cave-Ayland <mark.cave-ayland@ilande.co.uk>
Cc: BALATON Zoltan <balaton@eik.bme.hu>, =?UTF-8?Q?Philippe_Mathieu=2DDaud=C3=A9?= <philmd@linaro.org>, 
	qemu-devel@nongnu.org, =?UTF-8?Q?Daniel_P=2E_Berrang=C3=A9?= <berrange@redhat.com>, 
	Eduardo Habkost <eduardo@habkost.net>, qemu-arm@nongnu.org, kvm@vger.kernel.org, 
	Igor Mitsyanko <i.mitsyanko@gmail.com>, "Michael S. Tsirkin" <mst@redhat.com>, 
	Marcel Apfelbaum <marcel.apfelbaum@gmail.com>, Paolo Bonzini <pbonzini@redhat.com>, 
	Richard Henderson <richard.henderson@linaro.org>, Markus Armbruster <armbru@redhat.com>, 
	Manos Pitsidianakis <manos.pitsidianakis@linaro.org>
Content-Type: text/plain; charset="UTF-8"

On Mon, 19 Feb 2024 at 12:49, Mark Cave-Ayland
<mark.cave-ayland@ilande.co.uk> wrote:
>
> On 19/02/2024 12:00, BALATON Zoltan wrote:
> > For new people trying to contribute to QEMU QDev is overwhelming so having some way
> > to need less of it to do simple things would help them to get started.
>
> It depends what how you define "simple": for QEMU developers most people search for
> similar examples in the codebase and copy/paste them. I'd much rather have a slightly
> longer, but consistent API for setting properties rather than coming up with many
> special case wrappers that need to be maintained just to keep the line count down for
> "simplicity".
>
> I think that Phil's approach here is the best one for now, particularly given that it
> allows us to take another step towards heterogeneous machines. As the work in this
> area matures it might be that we can consider other approaches, but that's not a
> decision that can be made right now and so shouldn't be a reason to block this change.

Mmm. It's unfortunate that we're working with C, so we're a bit limited
in what tools we have to try to make a better and lower-boilerplate
interface for the "create, configure, realize and wire up devices" task.
(I think you could do much better in a higher level language...)
sysbus_create_simple() was handy at the time, but it doesn't work so
well for more complicated SoC-based boards. It's noticeable that
if you look at the code that uses it, it's almost entirely the older
and less maintained board models, especially those which don't actually
model an SoC and just have the board code create all the devices.

-- PMM

