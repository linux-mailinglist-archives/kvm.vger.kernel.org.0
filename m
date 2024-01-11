Return-Path: <kvm+bounces-6076-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id B379982AED3
	for <lists+kvm@lfdr.de>; Thu, 11 Jan 2024 13:37:44 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 21A651F2457C
	for <lists+kvm@lfdr.de>; Thu, 11 Jan 2024 12:37:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E3B1015E90;
	Thu, 11 Jan 2024 12:37:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="pd0tUdbG"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wr1-f49.google.com (mail-wr1-f49.google.com [209.85.221.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6231315E85
	for <kvm@vger.kernel.org>; Thu, 11 Jan 2024 12:37:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-wr1-f49.google.com with SMTP id ffacd0b85a97d-336c8ab0b20so4620898f8f.1
        for <kvm@vger.kernel.org>; Thu, 11 Jan 2024 04:37:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1704976649; x=1705581449; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:user-agent
         :references:in-reply-to:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=XjWVrWLBuhexZhNzqcbaaji/ra/r9VF4ONEQ8D3AprU=;
        b=pd0tUdbGX6H81fjeB6duwdTFVGH+ZNZaq4df60SpxTiRILkPwi9tBFAgfnqdrnodF0
         wV3aZwTnHYV/4MPEEioz0v6+1gqkRe70uwm3v0rdGgahEC+Q6x+cQkNnY52y6mZfHupr
         3WKC4Zqy5h0m9Fl4huK3s7oxWxLvSUhkvpnNwRZpBaXkRGjMXDs+xVFRP80nw4Kh8S8e
         msNiHUtBlDmF99a7cPcLA0mKICu4FrbvFKeY5NBq1qO60MBmtaR3NJ7krFKR2QLTkXiG
         B184Kn6vcCbB/TR+ntmZqETr0yOn9WReOGfrXOJrutdnR7lzHBl2hsOjMK8nOyG332md
         0u2g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1704976649; x=1705581449;
        h=content-transfer-encoding:mime-version:message-id:date:user-agent
         :references:in-reply-to:subject:cc:to:from:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=XjWVrWLBuhexZhNzqcbaaji/ra/r9VF4ONEQ8D3AprU=;
        b=MoTusX9hb0bUgmjwdu0ZJEi5cRLEcv+kkZA5066NlfPnp+TQUaClr6dPBwZOjH7qcH
         4zgyO8PZXty5xxvIEmSt3kjAqlUmVN5EngMMe6Y6rv5l5FLmhqLJw09zM0G16WfM+DQc
         Qqe5mX0iUsOpTFrRt7dRZSQL9Bd/uA7WryjPX0f7eAn8gviEv9q99HZglkx8et31EG7D
         gbVK3gC0DI7N4112Jd05P5HBPvuXHIODolRVaLUUviPEhnxsK/dLPiCaUdX4U3dc/DkC
         lG0Iap0qpEd5fLcD1A1ege3NaP5ur/hNLDAKMHKVQ6dlsyuT7J6V1gvU3jBe1hSlm64o
         ZGEg==
X-Gm-Message-State: AOJu0YwLmtOSVEugSFAxuKmCfhSw9bJf9L4E6ZwMSWaWDQJ6Xfvnrp7g
	PEyKGkdOF6LEDEgCM+miPnOsp8HQ/7yxFA==
X-Google-Smtp-Source: AGHT+IFZRj0uozQ33Kz3/zEEIWAh2I8FM6ycWyYCYl25J9YmcIK8POHwIM0XSklNJwKChNuv51rsAg==
X-Received: by 2002:a5d:4d84:0:b0:336:6dad:2c71 with SMTP id b4-20020a5d4d84000000b003366dad2c71mr672153wru.111.1704976649448;
        Thu, 11 Jan 2024 04:37:29 -0800 (PST)
Received: from draig.lan ([85.9.250.243])
        by smtp.gmail.com with ESMTPSA id l4-20020adffe84000000b003375cf3b17dsm1130163wrr.42.2024.01.11.04.37.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 11 Jan 2024 04:37:29 -0800 (PST)
Received: from draig (localhost [IPv6:::1])
	by draig.lan (Postfix) with ESMTP id 93E4C5F7AD;
	Thu, 11 Jan 2024 12:37:28 +0000 (GMT)
From: =?utf-8?Q?Alex_Benn=C3=A9e?= <alex.bennee@linaro.org>
To: qemu-devel@nongnu.org
Cc: qemu-s390x@nongnu.org,  qemu-ppc@nongnu.org,  Richard Henderson
 <richard.henderson@linaro.org>,  Song Gao <gaosong@loongson.cn>,
  =?utf-8?Q?Marc-Andr=C3=A9?= Lureau <marcandre.lureau@redhat.com>,  David
 Hildenbrand
 <david@redhat.com>,  Aurelien Jarno <aurelien@aurel32.net>,  Yoshinori
 Sato <ysato@users.sourceforge.jp>,  Yanan Wang <wangyanan55@huawei.com>,
  Bin Meng <bin.meng@windriver.com>,  Laurent Vivier <lvivier@redhat.com>,
  Michael Rolnik <mrolnik@gmail.com>,  Alexandre Iooss <erdnaxe@crans.org>,
  David Woodhouse <dwmw2@infradead.org>,  Laurent Vivier
 <laurent@vivier.eu>,  Paolo Bonzini <pbonzini@redhat.com>,  Brian Cain
 <bcain@quicinc.com>,  Daniel Henrique Barboza <danielhb413@gmail.com>,
  Beraldo Leal <bleal@redhat.com>,  Paul Durrant <paul@xen.org>,  Mahmoud
 Mandour <ma.mandourr@gmail.com>,  Thomas Huth <thuth@redhat.com>,  Liu
 Zhiwei <zhiwei_liu@linux.alibaba.com>,  Cleber Rosa <crosa@redhat.com>,
  kvm@vger.kernel.org,  Peter Maydell <peter.maydell@linaro.org>,  Wainer
 dos Santos Moschetta <wainersm@redhat.com>,  qemu-arm@nongnu.org,  Weiwei
 Li <liwei1518@gmail.com>,  Philippe =?utf-8?Q?Mathieu-Daud=C3=A9?=
 <philmd@linaro.org>,
  John Snow <jsnow@redhat.com>,  Daniel Henrique Barboza
 <dbarboza@ventanamicro.com>,  Nicholas Piggin <npiggin@gmail.com>,  Palmer
 Dabbelt <palmer@dabbelt.com>,  Marcel Apfelbaum
 <marcel.apfelbaum@gmail.com>,  Ilya Leoshkevich <iii@linux.ibm.com>,
  =?utf-8?Q?C=C3=A9dric?= Le Goater <clg@kaod.org>,  "Edgar E. Iglesias"
 <edgar.iglesias@gmail.com>,  Eduardo Habkost <eduardo@habkost.net>,
  Pierrick Bouvier <pierrick.bouvier@linaro.org>,  qemu-riscv@nongnu.org,
  Alistair Francis <alistair.francis@wdc.com>
Subject: Re: [PATCH v2 00/43] testing and plugin updates for 9.0 (pre-PR)
In-Reply-To: <20240103173349.398526-1-alex.bennee@linaro.org> ("Alex
 =?utf-8?Q?Benn=C3=A9e=22's?=
	message of "Wed, 3 Jan 2024 17:33:06 +0000")
References: <20240103173349.398526-1-alex.bennee@linaro.org>
User-Agent: mu4e 1.11.27; emacs 29.1
Date: Thu, 11 Jan 2024 12:37:28 +0000
Message-ID: <87cyu8f3lj.fsf@draig.linaro.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

Alex Benn=C3=A9e <alex.bennee@linaro.org> writes:

> This brings in the first batch of testing updates for the next
> release. The main bulk of these is Daniel and Thomas' cleanups of the
> qtest timeouts and allowing meson control them. There are a few minor
> tweaks I've made to some avocado and gitlab tests.
>
> The big update is support for reading register values in TCG plugins.
> After feedback from Akihiko I've left all the smarts to the plugin and
> made the interface a simple "all the registers" dump. There is a
> follow on patch to make the register code a little more efficient by
> checking disassembly. However we can leave the door open for future
> API enhancements if the translator ever learns to reliably know when
> registers might be touched.
>
> v2
> --
>
>  - Review feedback for register API
>  - readthedocs update
>  - add expectation docs for plugins
>
> The following still need review:
>
>   docs/devel: document some plugin assumptions
>   docs/devel: lift example and plugin API sections up
>   contrib/plugins: optimise the register value tracking
>   contrib/plugins: extend execlog to track register changes
>   contrib/plugins: fix imatch
>   plugins: add an API to read registers
>   gdbstub: expose api to find registers
>   readthodocs: fully specify a build environment
>   gitlab: include microblazeel in testing
>   tests/avocado: use snapshot=3Don in kvm_xen_guest

Ping for final review? I'd at least like to get the testing stuff
cleared out of my tree.

--=20
Alex Benn=C3=A9e
Virtualisation Tech Lead @ Linaro

