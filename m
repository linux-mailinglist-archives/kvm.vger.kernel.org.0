Return-Path: <kvm+bounces-7701-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 8FED5845723
	for <lists+kvm@lfdr.de>; Thu,  1 Feb 2024 13:14:38 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 17F8A1F22A5C
	for <lists+kvm@lfdr.de>; Thu,  1 Feb 2024 12:14:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1EBB341C87;
	Thu,  1 Feb 2024 12:13:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="StV2GgUM"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wr1-f54.google.com (mail-wr1-f54.google.com [209.85.221.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 593204D9EC
	for <kvm@vger.kernel.org>; Thu,  1 Feb 2024 12:13:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706789605; cv=none; b=OK5nSvBhQzR5CVbddQETCJzAKtsqds9OJlWlqcPUxlRJVBoyIm/SGGAw6/zpvs1nI7tnoaX7FDeeJXePUC0oJSGlRa/0qYBT1wQbugFO/xem+c/hsv84negDo+aZ+z9w2wrcoYcacfPW7P2q/mx9VcEbRg9+jWsjKLbe5OLf3cs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706789605; c=relaxed/simple;
	bh=Pm2CkR7h144hZiXTINW5zbFqQULQArX7GhL1mc1iYgY=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=iRVqEHygJG5QBNs6+vDbNY1TVX6eFvmiIx53K2W52yMxHLqJsSPZDSIbx1Dn+6lkAYHfMPUjwIDEK5HcnN19P30YbCcQSbjW1zqxK2VaBp6TE3knWRomhR/b/gp/2emaaqzYgPneydEl9ZpGayoKQcS9WVxPL6n5VUIMNaJIllk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=StV2GgUM; arc=none smtp.client-ip=209.85.221.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-wr1-f54.google.com with SMTP id ffacd0b85a97d-33b0e5d1e89so574275f8f.0
        for <kvm@vger.kernel.org>; Thu, 01 Feb 2024 04:13:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1706789601; x=1707394401; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:user-agent
         :references:in-reply-to:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Zn+/ye7RxQyRlRw4WUUebXTDcinacfZIyX6zTAbaIn4=;
        b=StV2GgUM3EUbNcVkPT1NhDcDKx7sm3Bbm6SGWb5w8CZTWpUeb/FnUNnFkl5OS1GGdh
         mvObiwSkTtLT0mT9wTNi7rM2NrE2g6LF3ca20fnrAwSJReAV/feWCuTMNDs8//GSDeNK
         UAThbrVRrfRgvM+nsW+ucNMnPrpVRvL/VetKnYLeg6ODiue2hrLbfnnJK4LyDdIQucQU
         PMuV/5A5KoNSD9AayLZfPDFqfczhRUBAujBuxzKnq8dvQIEBsv6UC+ONPncz3X2Yawxu
         KPtbMlGoo9N00/9MGV1DsEJ/nI0TpxKECoxtnT/SOAAWeZrd0ZL+3VKf3gW4Fbss7EnU
         fsPA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1706789601; x=1707394401;
        h=content-transfer-encoding:mime-version:message-id:date:user-agent
         :references:in-reply-to:subject:cc:to:from:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=Zn+/ye7RxQyRlRw4WUUebXTDcinacfZIyX6zTAbaIn4=;
        b=Wmfi1C9eaOjAo5/Z39RtaFOFwCqKx91QXbKXhPJk9JLI3Ilcz1d0AoXaKYBmhjzgv/
         Au6L12lecG79EcXNgOSlGDtb1fveRyMZyc/uR0tK1qC11jUzvrKWzipO020fr/61af2c
         O/ExEa8s22tvAE10azDz2FjuOge2WDWsHs+x4UqZ/KbAG7rw+XiUkdCPJ7k/le1fdOB+
         jmuJAMBO60F3A87lJG0WplF4HgKRPBIbmhcG9RUAju3t6XPHdyQDDl1jX8xI9fVZI6AM
         1V7MCdJs7nhKKdSYkCxqCXqSZsKjlmPZ6VeWy+Tk9fKTOeII4ZL87yyGtFk34W2n5Get
         Vutg==
X-Gm-Message-State: AOJu0YxiFK9GOndKsEyUul3sj9P+ARrz27IJhIQU8qfhMMSzxyzqLiYh
	jDqQtaNEAwI05zC/a/JDAuToxs+V0G8YY8UeojLmWV/hJJWkOSthI3MvkUhayUY=
X-Google-Smtp-Source: AGHT+IGB+c/lx7/rnRNnfJu4qEBVda7ddx4u1ulU2BJtZyQ/78w2aLdMTk84i0f+BuwBtVoebq2VoA==
X-Received: by 2002:a5d:4447:0:b0:33b:3b3:f486 with SMTP id x7-20020a5d4447000000b0033b03b3f486mr1480105wrr.35.1706789601434;
        Thu, 01 Feb 2024 04:13:21 -0800 (PST)
X-Forwarded-Encrypted: i=0; AJvYcCW7NpIoj1nuyTbHJHNrUV1q1+a+ZoQR0ItTb3f/oQYUUZVrgXtgpm3dkNBK5rXiaKfVm8BWuAMykidDaVGuytEQcsOmVz3tGkXSERqR4dwFZKUnUCzV73xTpbE83xBeiETdeImZKHNIH6ea+u4r6lVOZSFjWhHnzVp9uavqI3sa+2ZzA94ITDsauWVt6gD9CopbZ0pS6h8LhBE5Dwaz1HFO7jCKyf0EdxrfYQVVBBXTB8ee/iZHtx2qomM0/TuuO8QrspDq/Ztpwq+MqHo2qezd/bng15nSGVZqYvQYNb3PR4834i+tTqsm9P4SoH4PR10YH7An0ikm/TzFFu6yR0qqV5bmi3WZQfTygoiUa09D1v4g56ixhODzhl3OFwHuZOldnZKzaOQb1NYUBew36RPn5udbwnYJERL4+FHQ39t0eyJeIjq1CjBMeHkCOHWQd8lT+ECKM0BwVOgobJZ+MO5BC5F2R9WAhzYWzVw2aVjP7OypX/LJmZaiDMyl0ONRtF1pOw87XGLmtR1qnmwragJTwVAL9leH5V+n5Hj9DZIajRpdJBR/tuUbXmRLdQVbxG/BikYO6RFDZmQUfLuSVk1Bzein4A9LnBD/jncArDmdsKk94Q0RnTT996Gohnki8u6WvdJauVFrxqB2gYoTqXswVn9p6XJufLoBtCnCRA8vzHJdfUufve46X8awnnSXqr7pHZSQidZcSh0sL/FJMrw3tHKBC0HlP3kNx6GDIV8ZjTXbOgpQmMeEyB9SHxJG1eMMmtY/tRdiGEOa5LOMzkbFsPv9twF4L0Lh6y0P8bJE6LrdA21AWQ++jemdxkcjh21HGKKozF9yNEwCCJfFBdJuJWHaaNpUTR/3r+OelPo8N6aCRzO+nFCvPhFDUUv2YLtNzDrJsouhblvhfhnRNVg/Y7K3plK+Wey+gm7jyw0hfg3kAbOIR/O1MWv7BcpJeKz1iG
 bIYk94twoIFM6+aoGniZxwXfBzBiioRQSkd5j4D5FRUEeyW5f+BYSNn9Vi9A0R+u+gK0gf3uxfmLo4Z2yTaC1KSKjbsaIlxiCI+5DJCOceZnk14NZZKJVofGzfzzlNqczLaZOnw8uxrudRktM9ecWFOZvMZ6C6ZcgmvxCaqkQPYr9HzE9B7lXSZ++cy5whD3U0pdEQGuLpYZ9U17w4b22FnOeL/8OZLjS8br6ktHWkGqKhg6AKd+HxvzIpiZy2W/07Q20R/H2+tCBoNDKoNu4It9y5FrykveU=
Received: from draig.lan ([85.9.250.243])
        by smtp.gmail.com with ESMTPSA id u18-20020a5d4352000000b003392b1ebf5csm15989811wrr.59.2024.02.01.04.13.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 01 Feb 2024 04:13:20 -0800 (PST)
Received: from draig (localhost [IPv6:::1])
	by draig.lan (Postfix) with ESMTP id EDD6A5F7AF;
	Thu,  1 Feb 2024 12:13:19 +0000 (GMT)
From: =?utf-8?Q?Alex_Benn=C3=A9e?= <alex.bennee@linaro.org>
To: qemu-devel@nongnu.org
Cc: Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,  "Edgar E. Iglesias"
 <edgar.iglesias@gmail.com>,  Philippe =?utf-8?Q?Mathieu-Daud=C3=A9?=
 <philmd@linaro.org>,
  Michael Rolnik <mrolnik@gmail.com>,  =?utf-8?Q?Marc-Andr=C3=A9?= Lureau
 <marcandre.lureau@redhat.com>,  Laurent Vivier <lvivier@redhat.com>,
  kvm@vger.kernel.org,  Yoshinori Sato <ysato@users.sourceforge.jp>,
  Pierrick Bouvier <pierrick.bouvier@linaro.org>,  Palmer Dabbelt
 <palmer@dabbelt.com>,  Liu Zhiwei <zhiwei_liu@linux.alibaba.com>,  Laurent
 Vivier <laurent@vivier.eu>,  Yanan Wang <wangyanan55@huawei.com>,
  qemu-ppc@nongnu.org,  Weiwei Li <liwei1518@gmail.com>,
  qemu-s390x@nongnu.org,  =?utf-8?Q?C=C3=A9dric?= Le Goater <clg@kaod.org>,
  Peter Maydell
 <peter.maydell@linaro.org>,  Alexandre Iooss <erdnaxe@crans.org>,  John
 Snow <jsnow@redhat.com>,  Mahmoud Mandour <ma.mandourr@gmail.com>,  Wainer
 dos Santos Moschetta <wainersm@redhat.com>,  Richard Henderson
 <richard.henderson@linaro.org>,  Ilya Leoshkevich <iii@linux.ibm.com>,
  Alistair Francis <alistair.francis@wdc.com>,  David Woodhouse
 <dwmw2@infradead.org>,  Cleber Rosa <crosa@redhat.com>,  Beraldo Leal
 <bleal@redhat.com>,  Bin Meng <bin.meng@windriver.com>,  Nicholas Piggin
 <npiggin@gmail.com>,  Aurelien Jarno <aurelien@aurel32.net>,  Daniel
 Henrique Barboza <danielhb413@gmail.com>,  Daniel Henrique Barboza
 <dbarboza@ventanamicro.com>,  Thomas Huth <thuth@redhat.com>,  David
 Hildenbrand <david@redhat.com>,  qemu-riscv@nongnu.org,
  qemu-arm@nongnu.org,  Paolo Bonzini <pbonzini@redhat.com>,  Song Gao
 <gaosong@loongson.cn>,  Eduardo Habkost <eduardo@habkost.net>,  Brian Cain
 <bcain@quicinc.com>,  Paul Durrant <paul@xen.org>
Subject: Re: [PATCH v3 00/21] plugin updates (register access) for 9.0
 (pre-PR?)
In-Reply-To: <20240122145610.413836-1-alex.bennee@linaro.org> ("Alex
 =?utf-8?Q?Benn=C3=A9e=22's?=
	message of "Mon, 22 Jan 2024 14:55:49 +0000")
References: <20240122145610.413836-1-alex.bennee@linaro.org>
User-Agent: mu4e 1.11.27; emacs 29.1
Date: Thu, 01 Feb 2024 12:13:19 +0000
Message-ID: <871q9wmlgg.fsf@draig.linaro.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

Alex Benn=C3=A9e <alex.bennee@linaro.org> writes:

> Akihiko requested the register support not be merged in its current
> state so it's time for another round of review. I've made a few tweaks
> to simplify the register and CPU tracking code in execlog and removed
> some stale API functions. However from my point of view its ready to
> merge.
>
> v3
> --
>   - split from testing bits (merged)
>   - removed unused api funcs
>   - keep CPUs in a GArray instead of doing by hand
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
>   contrib/plugins: extend execlog to track register changes
>   gdbstub: expose api to find registers

Gentle ping. I'm ready to merge but more review was requested:


--=20
Alex Benn=C3=A9e
Virtualisation Tech Lead @ Linaro

