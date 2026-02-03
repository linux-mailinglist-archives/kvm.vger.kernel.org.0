Return-Path: <kvm+bounces-70012-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id WP8hCS3zgWkMNAMAu9opvQ
	(envelope-from <kvm+bounces-70012-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Tue, 03 Feb 2026 14:07:57 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id B7945D9AC0
	for <lists+kvm@lfdr.de>; Tue, 03 Feb 2026 14:07:56 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 48DAC30D5948
	for <lists+kvm@lfdr.de>; Tue,  3 Feb 2026 13:00:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 253AA34BA42;
	Tue,  3 Feb 2026 13:00:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="Jq1nVgbE"
X-Original-To: kvm@vger.kernel.org
Received: from mail-ed1-f46.google.com (mail-ed1-f46.google.com [209.85.208.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D6C1434A3C1
	for <kvm@vger.kernel.org>; Tue,  3 Feb 2026 13:00:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770123633; cv=none; b=QBrsv49mi7iDniJwowB7EZJQLL/g0UQzmlIYZ4Ft+YZICbbfZpJiNymnvxpl1Pd2pbnR0gUyIokqe1sBChuO61WMeHJtV0lN2WbYwSqnvYiYcmWCFtm7s11KnFAn/YhmUOYqkOtKX04pOQtj+zY+/GhvWahonk0VHDfOr6/UmNs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770123633; c=relaxed/simple;
	bh=QfrRwcFVbs7HXzfXIJF1G4CMBzqUTb6IXs918LJA2kU=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=cYmBXS+8/1UmgncTefaYEMk24lpRgg00yGDYgA4ozbnj3NdGYEnDhq26mWlSSXq8U67Ff18zUrftbi7DiDFU4nfCpaVd9ikewoPgJRvTF2yLnnkVc6mtgTiG73DDAYzdzSebFgh9694KROP2xcv5MZD9sfoib3CQFFtRxwTiETs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=Jq1nVgbE; arc=none smtp.client-ip=209.85.208.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-ed1-f46.google.com with SMTP id 4fb4d7f45d1cf-65807298140so9401538a12.2
        for <kvm@vger.kernel.org>; Tue, 03 Feb 2026 05:00:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1770123630; x=1770728430; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:user-agent
         :references:in-reply-to:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=QfrRwcFVbs7HXzfXIJF1G4CMBzqUTb6IXs918LJA2kU=;
        b=Jq1nVgbEc+QRabvwNxsoLVixZKeiz+URccT9hmLyh3PN3UI10sq5mJ22vC4Frf/nCa
         Kxh5bdG/hqXZ3KUTYO+ZMqio6iYJSy5VMhevnvhLpYQJ22ChR++nZ0zmoZXZXRbtRcVY
         6WajfEKdp+z5NbuFfZcHPM8I2JGFPFddBnh0qN7Lb0Oa0X9V23GlteZla79cY2xLMbxN
         3GQpxwqRduDa4n+ftM4gkrMkm0+zG8Agie6+D1ECW6CESzw9dstQPvN7jeYOrGqp4xjA
         YMtm/b0j2DEgJzZtYxrEdpx2ODT8lTkvkQbKjLV83l43AIh5UQma089ZXLJLMgjbWQfM
         Secg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770123630; x=1770728430;
        h=content-transfer-encoding:mime-version:message-id:date:user-agent
         :references:in-reply-to:subject:cc:to:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=QfrRwcFVbs7HXzfXIJF1G4CMBzqUTb6IXs918LJA2kU=;
        b=Mt7InJ4H83E7HxctZTs1d/qpxC92Krpz3zLghLLsrlAT7X56GBuzeK/ze+WqMXTQMq
         2lJC/CbgOJm5aSEPXco8fe+ie9or6tT+9fbkmlhLj05qWhUxZda4f6z4v4MUeYil0Tnd
         8TXf55qZckIwoI1xzQhurct/jN2l1LYGMyClTYROp3+Rpy6EGv9UmatuA4AUsSxi1p5Z
         wkXf5iy2nDNpPC5rjfuAsTT388k6mTPNO6lIiPh+zeSBUHiWon76pXvXsvZ9zkwlgxCu
         O9jsyjWEMRq4/q0kJgjp1pKC0121R3CJhRI1th9Jb1vjTBvu+FkLjI7A5mJejUIelYKL
         m2DA==
X-Forwarded-Encrypted: i=1; AJvYcCUhkncQdsCOnmvm9TBRPVbhv2H6UO3T5RTMJU9aKRjmfagXCdZ55pp7iE73LwbSuJ+/wM4=@vger.kernel.org
X-Gm-Message-State: AOJu0Yxb2V0qxK6GtIxkVHbg8dNPDHlqw1pN9Q8gTjnq61Kwe+cP2HKK
	qM5Ke1TcEiSLCyrrBS7WjpptcIyfIWqthDbBaZCS5DJaRodSLgxygoPEieLf5ZurhSg=
X-Gm-Gg: AZuq6aJJQX8imqNZ1q6z9B2rRk2pkhdTz6mow7WEqREVq2CqVzk1sPZ6iuopX9Yajxe
	tzpJqdaNDdx5agnMmyC0CllCb9w7lBS1GzMqJqVsLqR0C5ujGI6lDDVcPJ318hnMBhEiySZlp8f
	WNj+/kYD9shbrTNFCglnTFJdSyTPsRBdy5LtrNzgdH8SGqGZeehxpH3IkP+6yWi8Re4t+r8ffbJ
	waVyIUT3CQLyS4SCpkmm9/1zPcW30NKyU4OSQveCyWh4ylEKNWS9ou6e5E+e57XwctNfcghWRhc
	Wk33ASo5TsZEOe/wWBWwjIEMaaLAC7wO+cvboWHdO/rkDMtlSB0Q9V6oPDDK2RtVgzvf7R863S5
	tjdvKTYvccXUOO+a+LHnlLLVTGJu9zhAAg7D1TQpzRhbrw4WnTzAo/EhJLyfKMT6GMbVM/RCRAu
	9n8vO7mPrhMAQ=
X-Received: by 2002:a17:907:1b20:b0:b86:f558:ecad with SMTP id a640c23a62f3a-b8dff5260f2mr877455366b.7.1770123628657;
        Tue, 03 Feb 2026 05:00:28 -0800 (PST)
Received: from draig.lan ([185.124.0.126])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-b8dbf1c5b38sm1024503866b.53.2026.02.03.05.00.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 03 Feb 2026 05:00:28 -0800 (PST)
Received: from draig (localhost [IPv6:::1])
	by draig.lan (Postfix) with ESMTP id 1C5C05F841;
	Tue, 03 Feb 2026 13:00:27 +0000 (GMT)
From: =?utf-8?Q?Alex_Benn=C3=A9e?= <alex.bennee@linaro.org>
To: Mark Brown <broonie@kernel.org>
Cc: Marc Zyngier <maz@kernel.org>,  Joey Gouly <joey.gouly@arm.com>,
  Catalin Marinas <catalin.marinas@arm.com>,  Suzuki K Poulose
 <suzuki.poulose@arm.com>,  Will Deacon <will@kernel.org>,  Paolo Bonzini
 <pbonzini@redhat.com>,  Jonathan Corbet <corbet@lwn.net>,  Shuah Khan
 <shuah@kernel.org>,  Oliver Upton <oupton@kernel.org>,  Dave Martin
 <Dave.Martin@arm.com>,  Fuad Tabba <tabba@google.com>,  Mark Rutland
 <mark.rutland@arm.com>,  Ben Horgan <ben.horgan@arm.com>,
  linux-arm-kernel@lists.infradead.org,  kvmarm@lists.linux.dev,
  linux-kernel@vger.kernel.org,  kvm@vger.kernel.org,
  linux-doc@vger.kernel.org,  linux-kselftest@vger.kernel.org,  Peter
 Maydell <peter.maydell@linaro.org>,  Eric Auger <eric.auger@redhat.com>
Subject: Re: [PATCH v9 01/30] arm64/sysreg: Update SMIDR_EL1 to DDI0601 2025-06
In-Reply-To: <20251223-kvm-arm64-sme-v9-1-8be3867cb883@kernel.org> (Mark
	Brown's message of "Tue, 23 Dec 2025 01:20:55 +0000")
References: <20251223-kvm-arm64-sme-v9-0-8be3867cb883@kernel.org>
	<20251223-kvm-arm64-sme-v9-1-8be3867cb883@kernel.org>
User-Agent: mu4e 1.14.0-pre1; emacs 30.1
Date: Tue, 03 Feb 2026 13:00:27 +0000
Message-ID: <87o6m6nfro.fsf@draig.linaro.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[linaro.org,none];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	R_DKIM_ALLOW(-0.20)[linaro.org:s=google];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	MIME_TRACE(0.00)[0:+];
	RCPT_COUNT_TWELVE(0.00)[22];
	TAGGED_FROM(0.00)[bounces-70012-lists,kvm=lfdr.de];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	DKIM_TRACE(0.00)[linaro.org:+];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	FROM_HAS_DN(0.00)[];
	TO_DN_SOME(0.00)[];
	RCVD_COUNT_FIVE(0.00)[6];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[alex.bennee@linaro.org,kvm@vger.kernel.org];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	NEURAL_HAM(-0.00)[-1.000];
	TAGGED_RCPT(0.00)[kvm];
	MID_RHS_MATCH_FROMTLD(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[draig.linaro.org:mid,linaro.org:email,linaro.org:dkim,sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: B7945D9AC0
X-Rspamd-Action: no action

Mark Brown <broonie@kernel.org> writes:

> Update the definiton of SMIDR_EL1 in the sysreg definition to reflect the
> information in DD0601 2025-06. This includes somewhat more generic ways of
> describing the sharing of SMCUs, more information on supported priorities
> and provides additional resolution for describing affinity groups.
>
> Signed-off-by: Mark Brown <broonie@kernel.org>

Reviewed-by: Alex Benn=C3=A9e <alex.bennee@linaro.org>

--=20
Alex Benn=C3=A9e
Virtualisation Tech Lead @ Linaro

