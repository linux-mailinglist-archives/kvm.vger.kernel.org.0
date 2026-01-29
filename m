Return-Path: <kvm+bounces-69580-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id qHTKBC+ae2nOGAIAu9opvQ
	(envelope-from <kvm+bounces-69580-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Thu, 29 Jan 2026 18:34:39 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 6E79DB2F60
	for <lists+kvm@lfdr.de>; Thu, 29 Jan 2026 18:34:38 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id A21E230581AF
	for <lists+kvm@lfdr.de>; Thu, 29 Jan 2026 17:29:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2D5F734DB7F;
	Thu, 29 Jan 2026 17:29:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="wHwIu2Vl"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f51.google.com (mail-wm1-f51.google.com [209.85.128.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 52E0034D903
	for <kvm@vger.kernel.org>; Thu, 29 Jan 2026 17:29:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769707788; cv=none; b=dTj9BAuqrBC/Rm4EwWYJw9XOP2BEXxWJfDPAOQrIZrZmkZtPA8Tz/KlMTGyeRrAlQBccHGoJ1SebtgIVuP4VzVd38vkUSwynwYIjtpc4Bo3rpXrgZ82wEbaS0msm4AVlFxY8nOE1gsFURJHJnLJZOgJH+J8sf4ch4JCWDkMBvFk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769707788; c=relaxed/simple;
	bh=be866/Yp5BAQJMoBK98y8dBJLQ2gHvccZfOQ5Qw+jAY=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=EDDVQ062v2VILgQDux2vqgwkFL8lJWv5nAizMa0CqHlO/hENeVvl+eCPJLHNP34oNcoJrkfFFYooOu6l6emkbGZT+7E+ipE6xY7rJOfrSlA5InpMb26knU4oI2n1zagMaTyA40PFIOIZ35m7IHf4ZOpcFSaoFpG8V1ChFH+QNg0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=wHwIu2Vl; arc=none smtp.client-ip=209.85.128.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-wm1-f51.google.com with SMTP id 5b1f17b1804b1-4806d23e9f1so14181875e9.2
        for <kvm@vger.kernel.org>; Thu, 29 Jan 2026 09:29:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1769707785; x=1770312585; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:user-agent
         :references:in-reply-to:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=be866/Yp5BAQJMoBK98y8dBJLQ2gHvccZfOQ5Qw+jAY=;
        b=wHwIu2VlC51zeYSWrFup//yLPuyf8rJC3TBNiTTLUi0VzqQrupIgBaCJ/AzM2VxAmw
         Zg1Xi0BlHaY/jdGN8iIeD2Rydh/xwPBTyM/STgtUm8+90oPOJJNXvvG72yJfnKVUB5nE
         p8ZOBFbd34St+Ip0pfYaPSUEpFxBTY9pdfhF3+XBsB1amjfdtVK/8UjhRPue+rnh51ur
         FflmD70zt4F2+5ZZBcN163zATMyhb8zTFn47J1Zok6xknh1nHlH/WjTZ2S4b2leHxWLM
         bM4dLlD92K6ZDAdLyNddhrbwye141vcvymhr7mqc3BrBJPy3km2AfQNFEBJaZBTY9ypa
         bKqw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769707785; x=1770312585;
        h=content-transfer-encoding:mime-version:message-id:date:user-agent
         :references:in-reply-to:subject:cc:to:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=be866/Yp5BAQJMoBK98y8dBJLQ2gHvccZfOQ5Qw+jAY=;
        b=RvQsEXk0psZGNBEW1WmuprDJo/urxbQ9chXFORvAFn5UqRocSf960DrmrYth0aSGqA
         8Mnn3Hiv9kYH8BNZk/uqtk3D/llNWIgbEyLaNofcT7ljPxp4IJwxEoKpFxjC9FFQHsfH
         Dwu0XIKwNmsAMZBuAS+NNb+XBFJDoDkbmNpVgvM2OCP7wZgkCLYZ+PVS+Xey08EKFwlO
         Sz/ILhgrnfeNYqcZ0Via8sOOC3dilzWGRA6raL4U/R/lO7ltQAizvit4g/fYArnVyOwG
         pTkEQfi+iYjl/esecKtC43fGi/LRhCGc40TxMI2hAQE/InzfVLuTpbnBiZxx5FgA4ZcQ
         5x9w==
X-Forwarded-Encrypted: i=1; AJvYcCXbEOWhUTqLzhqLyMt1nmArgj6m9uv6O3+EGO+XMtEjbvHyyZr4vbH/CtanSDbmoMsZpLY=@vger.kernel.org
X-Gm-Message-State: AOJu0YwpcNOOuyzmuX2mUZ3WCQGNeKeuT2KI2RcgmZn05n1UGft1bMgb
	qppyddRL/uBcOk/ajy87Y4DdZx4P1cIHXiOLi3o6XYGb7eoedah8pvDTEOqzb7QyhC8=
X-Gm-Gg: AZuq6aKccMGn5TReX8klII3z05KMvrF3FwpwaYL3tTMK/BdXp3fnQjqCSpuz3mSAWzR
	ZZoliofJoMq/dqZh6N+PzcQ9lvpFcKo8j+W5r2281xVxEB+HvHdY8/zD6ioNv7ruu/vKXhS18eV
	ZiZceO7z3OnKK0SRNeDMcyYyh81ASsepLLhgxk/r8fLtcT+laG548Jmy1CaVU/yjmu/M735hkb2
	xPDEaDbew5Ia7atBJDhSgnhmO1kDpdl7/67jLL+zcvpUMjqpmcKMUKV+ySTOq8I8qX9p5771+f+
	YLDV7/SuBN2aJXWP7aq7S2tD4Xyynkj292tLP1UzFi48IzXuZ5oLNm1n602Gx4EN4dwpkS9a5tN
	nBpirARrDR6NCLe281AY3xAMjPWatzHwdRmaXXyUaBqhgSCR7ANPuiHKOiUXQYHxxBgPe5TGE6D
	OKUVCwf69MkG4=
X-Received: by 2002:a05:600c:350b:b0:47a:935f:61a0 with SMTP id 5b1f17b1804b1-48069b9a017mr121874905e9.0.1769707784613;
        Thu, 29 Jan 2026 09:29:44 -0800 (PST)
Received: from draig.lan ([185.124.0.126])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-482da8eba27sm66755e9.6.2026.01.29.09.29.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 29 Jan 2026 09:29:43 -0800 (PST)
Received: from draig (localhost [IPv6:::1])
	by draig.lan (Postfix) with ESMTP id 067175F878;
	Thu, 29 Jan 2026 17:29:43 +0000 (GMT)
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
Subject: Re: [PATCH v9 04/30] arm64/fpsimd: Check enable bit for FA64 when
 saving EFI state
In-Reply-To: <76bf33a0-968d-4b99-a157-3eef076af69d@sirena.org.uk> (Mark
	Brown's message of "Thu, 29 Jan 2026 16:41:05 +0000")
References: <20251223-kvm-arm64-sme-v9-0-8be3867cb883@kernel.org>
	<20251223-kvm-arm64-sme-v9-4-8be3867cb883@kernel.org>
	<87343o8jay.fsf@draig.linaro.org>
	<76bf33a0-968d-4b99-a157-3eef076af69d@sirena.org.uk>
User-Agent: mu4e 1.14.0-pre1; emacs 30.1
Date: Thu, 29 Jan 2026 17:29:42 +0000
Message-ID: <87wm1072ex.fsf@draig.linaro.org>
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
	TAGGED_FROM(0.00)[bounces-69580-lists,kvm=lfdr.de];
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
	DBL_BLOCKED_OPENRESOLVER(0.00)[linaro.org:dkim,sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns,draig.linaro.org:mid]
X-Rspamd-Queue-Id: 6E79DB2F60
X-Rspamd-Action: no action

Mark Brown <broonie@kernel.org> writes:

> On Thu, Jan 29, 2026 at 04:39:33PM +0000, Alex Benn=C3=A9e wrote:
>> Mark Brown <broonie@kernel.org> writes:
>
>> > Currently when deciding if we need to save FFR when in streaming mode =
prior
>> > to EFI calls we check if FA64 is supported by the system. Since KVM gu=
est
>> > support will mean that FA64 might be enabled and disabled at runtime s=
witch
>> > to checking if traps for FA64 are enabled in SMCR_EL1 instead.
>
>> This is conflicting with the now merged 63de2b3859ba1 (arm64/efi: Remove
>> unneeded SVE/SME fallback preserve/store handling) so I think this patch
>> can now be dropped?
>
> Yes, this should go away in the next rebase.

Everything else applies cleanly though so thats good ;-)

--=20
Alex Benn=C3=A9e
Virtualisation Tech Lead @ Linaro

