Return-Path: <kvm+bounces-4079-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id A78F980D2C8
	for <lists+kvm@lfdr.de>; Mon, 11 Dec 2023 17:52:10 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 2BC25B21309
	for <lists+kvm@lfdr.de>; Mon, 11 Dec 2023 16:52:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2B3C84CDEB;
	Mon, 11 Dec 2023 16:52:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="wqqtfZuQ"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-x335.google.com (mail-wm1-x335.google.com [IPv6:2a00:1450:4864:20::335])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DABFABF
	for <kvm@vger.kernel.org>; Mon, 11 Dec 2023 08:51:56 -0800 (PST)
Received: by mail-wm1-x335.google.com with SMTP id 5b1f17b1804b1-40c339d2b88so33211735e9.3
        for <kvm@vger.kernel.org>; Mon, 11 Dec 2023 08:51:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1702313515; x=1702918315; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:user-agent
         :references:in-reply-to:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=NB+xTPLZXpkLiiKkOdT5pTm+XqCQmG6DDHrgwX5/f/k=;
        b=wqqtfZuQp3MLDZCDlk1ofbmdfFLqYQ2c/HlKyue7dyjofw9+SCyaRNfjrUI44Fo1OS
         rlmg/tHAAdppKacbFA4kjoDGZNbeZD86JuUhbhoFJYbAPwMDeWuZ5egIpjNmOABaSWB6
         zEoyz1XaXK4c7VjVPXVcyoc9QpMuI29CFAIXvpHQR5ntnynj3TiYesT2J2bntL1GJ9G9
         KZvN5E+zCTAFMO9+cPTbAn/i6eDd6bcF2Rl1m9k1W1EAw1jUzp/OyM4bXVGHitQcsxCB
         Zv5wxYqgtV+QS8fVh9Y77y/4O5iyY1khyhoUkppABnLVtWd1ph9YAmjzR0Xmjk7AGgHT
         ofww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1702313515; x=1702918315;
        h=content-transfer-encoding:mime-version:message-id:date:user-agent
         :references:in-reply-to:subject:cc:to:from:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=NB+xTPLZXpkLiiKkOdT5pTm+XqCQmG6DDHrgwX5/f/k=;
        b=cVTkURBpVBEgwUMNDt/a3N+wX4IR04ohe9675Yn8t+m8K+sQFf96IB5bZdlLNUo/mq
         fn3mepyxO8UzMaA7r0U0K2QMOixAOd85iDIIwq1O2AAN/19AZ0W3jsoMEnna5jDL1X3I
         9aJyPCAA77UIl0NjnDz6Feh/Q25rULDIsTxcNprkAgyidKPQN8HwqSrMSuo/BXSMB7fr
         MW/Tl5ocmIH8hYw+Yx0PsnPWQOROpxxZPxfQ7jiEEqRp/fOKEZ5v8YnwRQI+RaS7DeIq
         QjfiqsgZe1f/G0aOZpMvNMafI7a/hCCxZ2pzjRIdSmZFIKPOpAVZTjSNvkP5f3TVBgv4
         2Kbg==
X-Gm-Message-State: AOJu0YwAL+S9uqqHdhIVYQNcX0YqEi6WsTzbyc1Us7UPlXTk7b9rZD+/
	T8KtvQLvDRnTc/zuhQtvrp4lVA==
X-Google-Smtp-Source: AGHT+IG/E9r8AwAUQR/2cAquO/bnR2/jR44nUgtoXgw+QoC5FxbG37RGgw+QF5x6j6pxwjEQIS+UmA==
X-Received: by 2002:a05:600c:444a:b0:40c:4857:e000 with SMTP id v10-20020a05600c444a00b0040c4857e000mr970778wmn.46.1702313515304;
        Mon, 11 Dec 2023 08:51:55 -0800 (PST)
Received: from draig.lan ([85.9.250.243])
        by smtp.gmail.com with ESMTPSA id b16-20020a05600c4e1000b0040c310abc4bsm13905683wmq.43.2023.12.11.08.51.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 11 Dec 2023 08:51:55 -0800 (PST)
Received: from draig (localhost [IPv6:::1])
	by draig.lan (Postfix) with ESMTP id 9E39E5FBC6;
	Mon, 11 Dec 2023 16:51:54 +0000 (GMT)
From: =?utf-8?Q?Alex_Benn=C3=A9e?= <alex.bennee@linaro.org>
To: Cleber Rosa <crosa@redhat.com>
Cc: qemu-devel@nongnu.org,  Jiaxun Yang <jiaxun.yang@flygoat.com>,  Radoslaw
 Biernacki <rad@semihalf.com>,  Paul Durrant <paul@xen.org>,  Akihiko Odaki
 <akihiko.odaki@daynix.com>,  Leif Lindholm <quic_llindhol@quicinc.com>,
  Peter Maydell <peter.maydell@linaro.org>,  Paolo Bonzini
 <pbonzini@redhat.com>,  kvm@vger.kernel.org,  qemu-arm@nongnu.org,
  Philippe =?utf-8?Q?Mathieu-Daud=C3=A9?= <philmd@linaro.org>,  Beraldo Leal
 <bleal@redhat.com>,  Wainer dos Santos Moschetta <wainersm@redhat.com>,
  Sriram Yagnaraman <sriram.yagnaraman@est.tech>,  Marcin Juszkiewicz
 <marcin.juszkiewicz@linaro.org>,  David Woodhouse <dwmw2@infradead.org>
Subject: Re: [PATCH 01/10] tests/avocado: mips: fallback to HTTP given
 certificate expiration
In-Reply-To: <20231208190911.102879-2-crosa@redhat.com> (Cleber Rosa's message
	of "Fri, 8 Dec 2023 14:09:02 -0500")
References: <20231208190911.102879-1-crosa@redhat.com>
	<20231208190911.102879-2-crosa@redhat.com>
User-Agent: mu4e 1.11.26; emacs 29.1
Date: Mon, 11 Dec 2023 16:51:54 +0000
Message-ID: <878r60fzrp.fsf@draig.linaro.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

Cleber Rosa <crosa@redhat.com> writes:

> The SSL certificate installed at mipsdistros.mips.com has expired:
>
>  0 s:CN =3D mipsdistros.mips.com
>  i:C =3D US, O =3D Amazon, OU =3D Server CA 1B, CN =3D Amazon
>  a:PKEY: rsaEncryption, 2048 (bit); sigalg: RSA-SHA256
>  v:NotBefore: Dec 23 00:00:00 2019 GMT; NotAfter: Jan 23 12:00:00 2021 GMT
>
> Because this project has no control over that certificate and host,
> this falls back to plain HTTP instead.  The integrity of the
> downloaded files can be guaranteed by the existing hashes for those
> files (which are not modified here).
>
> Signed-off-by: Cleber Rosa <crosa@redhat.com>

Reviewed-by: Alex Benn=C3=A9e <alex.bennee@linaro.org>


--=20
Alex Benn=C3=A9e
Virtualisation Tech Lead @ Linaro

