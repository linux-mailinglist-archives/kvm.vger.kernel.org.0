Return-Path: <kvm+bounces-4176-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 1EE9F80EA5C
	for <lists+kvm@lfdr.de>; Tue, 12 Dec 2023 12:27:58 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 500051C20B03
	for <lists+kvm@lfdr.de>; Tue, 12 Dec 2023 11:27:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 805865D4A1;
	Tue, 12 Dec 2023 11:27:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="Tou9RAUv"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-x333.google.com (mail-wm1-x333.google.com [IPv6:2a00:1450:4864:20::333])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F2C47D5
	for <kvm@vger.kernel.org>; Tue, 12 Dec 2023 03:27:47 -0800 (PST)
Received: by mail-wm1-x333.google.com with SMTP id 5b1f17b1804b1-40c2c65e6aaso56783815e9.2
        for <kvm@vger.kernel.org>; Tue, 12 Dec 2023 03:27:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1702380466; x=1702985266; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:user-agent
         :references:in-reply-to:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=mcp/OytcLOup8WRnpM/gaBcyxEN7ujaDuhjYFgetfTs=;
        b=Tou9RAUveG+vrNcVMW4h7ZqPQBlcGTXNkp9/nr+fX8UbkGGmm8ZlDWGQKyFmgibRCa
         LJNp/fwHG/IfZz/mbK1+K+nOko/XEuPEzmGSwr+eIIG3moGt0EJ3HdtZ2QVCBMfCI31q
         ml6+PwaxCIMdq/H6s3kpJWE8BTj9L9Z+ZF7z2ConaOqP/7+V9ZZBhfpXnKMZZN9cvwKU
         I4islD2KjmJaRB5Y8eDC80I28TsDBpbWzsPGqj+WjHwgBfCW8ItvF02iUpOi6mZf8Hea
         Tgu4UUubnirXk/joBsem6QXl0U4K6XUWVh9+kBpchTqlbbiiNberpZMynmrVMpVrsHlR
         eXFA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1702380466; x=1702985266;
        h=content-transfer-encoding:mime-version:message-id:date:user-agent
         :references:in-reply-to:subject:cc:to:from:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=mcp/OytcLOup8WRnpM/gaBcyxEN7ujaDuhjYFgetfTs=;
        b=i9H+olCSknFp+6rHyPvPfNRxd8um1gO+pGdxXibVKG2W6mlPnu0N04M806nzookfJT
         iLf7S+JsOrmDQJbU1AxNK+wduRUvA/oycJzFLQNOvZtgHl9AK/6LZlAf27PJieW3ucfz
         krxObz8cOHzpBTDZFRgmB9yCj/Gze5RyBf85EcFJHwuubxJ767e7K1pcAOF+TgSeU4og
         9LlSC7K0Ctw7Wkfhq0dmStWgu6mjCVmfXCdusPBFUXUoJ8VVN0JGGRDnnBsdyilSzgCJ
         GQqnr1l0cefkX/48NR4TjVmAGQTDmKdr2+36NcxaA+UEXHe2U9sAVH16/JMAKeqxLDdE
         wtbw==
X-Gm-Message-State: AOJu0YwprKaJTr/m7c+7aqE7Zh1ucHkm6Dmt0d8Q08DVlnxOfpAx4xTI
	+S3WuClP9G+TyXsuaw9U5vSpUA==
X-Google-Smtp-Source: AGHT+IE8h4+LLk/UBoDqLQ3w3Jekdh03nWKXycS/0ClkgTkV435VTOpEJ0xNaeiRILW91PJKuQyoUg==
X-Received: by 2002:a1c:7404:0:b0:40c:357e:273 with SMTP id p4-20020a1c7404000000b0040c357e0273mr2889449wmc.142.1702380466209;
        Tue, 12 Dec 2023 03:27:46 -0800 (PST)
Received: from draig.lan ([85.9.250.243])
        by smtp.gmail.com with ESMTPSA id bd21-20020a05600c1f1500b0040c25abd724sm18701332wmb.9.2023.12.12.03.27.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 12 Dec 2023 03:27:45 -0800 (PST)
Received: from draig (localhost [IPv6:::1])
	by draig.lan (Postfix) with ESMTP id 847E45F7D3;
	Tue, 12 Dec 2023 11:27:45 +0000 (GMT)
From: =?utf-8?Q?Alex_Benn=C3=A9e?= <alex.bennee@linaro.org>
To: Akihiko Odaki <akihiko.odaki@daynix.com>
Cc: Cleber Rosa <crosa@redhat.com>,  qemu-devel@nongnu.org,  Jiaxun Yang
 <jiaxun.yang@flygoat.com>,  Radoslaw Biernacki <rad@semihalf.com>,  Paul
 Durrant <paul@xen.org>,  Leif Lindholm <quic_llindhol@quicinc.com>,  Peter
 Maydell <peter.maydell@linaro.org>,  Paolo Bonzini <pbonzini@redhat.com>,
  kvm@vger.kernel.org,  qemu-arm@nongnu.org,  Philippe =?utf-8?Q?Mathieu-D?=
 =?utf-8?Q?aud=C3=A9?=
 <philmd@linaro.org>,  Beraldo Leal <bleal@redhat.com>,  Wainer dos Santos
 Moschetta <wainersm@redhat.com>,  Sriram Yagnaraman
 <sriram.yagnaraman@est.tech>,  Marcin Juszkiewicz
 <marcin.juszkiewicz@linaro.org>,  David Woodhouse <dwmw2@infradead.org>,
  Eric Auger <eric.auger@redhat.com>
Subject: Re: [PATCH 03/10] tests/avocado/intel_iommu.py: increase timeout
In-Reply-To: <947ad8b2-14fe-456b-b914-6e1c86dc27e4@daynix.com> (Akihiko
	Odaki's message of "Tue, 12 Dec 2023 17:18:29 +0900")
References: <20231208190911.102879-1-crosa@redhat.com>
	<20231208190911.102879-4-crosa@redhat.com>
	<8734w8fzbc.fsf@draig.linaro.org>
	<947ad8b2-14fe-456b-b914-6e1c86dc27e4@daynix.com>
User-Agent: mu4e 1.11.26; emacs 29.1
Date: Tue, 12 Dec 2023 11:27:45 +0000
Message-ID: <877cljek3y.fsf@draig.linaro.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

Akihiko Odaki <akihiko.odaki@daynix.com> writes:

> On 2023/12/12 2:01, Alex Benn=C3=A9e wrote:
>> Cleber Rosa <crosa@redhat.com> writes:
>>=20
>>> Based on many runs, the average run time for these 4 tests is around
>>> 250 seconds, with 320 seconds being the ceiling.  In any way, the
>>> default 120 seconds timeout is inappropriate in my experience.
>> I would rather see these tests updated to fix:
>>   - Don't use such an old Fedora 31 image
>>   - Avoid updating image packages (when will RH stop serving them?)
>>   - The "test" is a fairly basic check of dmesg/sysfs output
>> I think building a buildroot image with the tools pre-installed
>> (with
>> perhaps more testing) would be a better use of our limited test time.
>
> That's what tests/avocado/netdev-ethtool.py does, but I don't like it
> much because building a buildroot image takes long and results in a
> somewhat big binary blob.
>
> I rather prefer to have some script that runs mkosi[1] to make an
> image; it downloads packages from distributor so it will take much
> less than using buildroot. The CI system can run the script and cache
> the image.

I'm all more smaller more directed test cases and I'm less worried about
exactly how things are built. I only use buildroot personally because
I'm familiar with it and it makes it easy to build testcases for
multiple architectures.

> [1] https://github.com/systemd/mkosi

If that works for you go for it ;-)

--=20
Alex Benn=C3=A9e
Virtualisation Tech Lead @ Linaro

