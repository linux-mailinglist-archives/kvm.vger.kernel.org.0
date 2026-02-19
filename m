Return-Path: <kvm+bounces-71309-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id 6E54HkqLlmm+hAIAu9opvQ
	(envelope-from <kvm+bounces-71309-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Thu, 19 Feb 2026 05:02:18 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id D4DC315BEE0
	for <lists+kvm@lfdr.de>; Thu, 19 Feb 2026 05:02:17 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id E2689302E421
	for <lists+kvm@lfdr.de>; Thu, 19 Feb 2026 04:02:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 787C128469B;
	Thu, 19 Feb 2026 04:02:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="ObxVuioa"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f180.google.com (mail-pl1-f180.google.com [209.85.214.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 778DE1990C7
	for <kvm@vger.kernel.org>; Thu, 19 Feb 2026 04:02:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771473730; cv=none; b=HWfsXagGdbU2ep8RGxuBv77I3pgYrcKKTttECfOGpY/J1aoW9Oz2P8WRAesb2VxL3aRsFuTyN3x9kb1aBxDX2UKlZKmEr9rEnxva7uB6WwKEhCx8urUu1aRU5OFJ8/CyjERzF4La3q4fkL0N9pr1RSYAj0yozly8lMY3nAPyZzM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771473730; c=relaxed/simple;
	bh=33oz8Two74SLR/hf+VRIYbH1Pwgm1rlXwQobW6+Vlsw=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=RgoKNOX+7i8wVjfXWtL1y2cEyVmmXNqHGWQ6QkSEsFUBfkbMZ5be3R9PpRYtTJrUjm075qCSc+imCF5zUrYQl39OEWHV/ZdOLDq0raGaqGcc1YkWAQ/BvF01qR6OR0LTSabPmaxuNZLEv4FgF85L+Us5IGVtyByvMr42599wrk8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=ObxVuioa; arc=none smtp.client-ip=209.85.214.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-pl1-f180.google.com with SMTP id d9443c01a7336-2aad1dc8856so2986205ad.1
        for <kvm@vger.kernel.org>; Wed, 18 Feb 2026 20:02:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1771473729; x=1772078529; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=g+k/37VNyM44S8IKpnLIeLYphIGYrb6n3z+1yI/fqF0=;
        b=ObxVuioaYI5wwv4mN8Lh4GjaLjQDVBF6NfDO/TcVVuhn9jYWLcmEZPO0mtEKgCihdV
         s1lN5wB2HQay+AoMXwLksQ502x6eEWNqB5wxAnmdjRbi7ANFaZofhnzqjyrhrqVPCtTE
         r2Yf1Ck8fhURsTrztlYNxZrDaauSyxQdDn4LVnQn1zEoNGfL8x0m5b1/YL31sY6Iz3Tr
         PTVa3z+yqZAIjdHrFyuoJGBzi9JiMdDbneQhy7xYFVExIz8MkgQPUs67ytjdY/LGOXAg
         DzQKxpAo5chwhB9H+oeAPGEgPht0F8ejZMFe6uQw23wF9cerzawREVb/wgCwQqMmFYE4
         tVdg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771473729; x=1772078529;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=g+k/37VNyM44S8IKpnLIeLYphIGYrb6n3z+1yI/fqF0=;
        b=UQ6s00sOxwS7Tt0rNK1GvFpEMPUWI5ff9id27/qn5dY64rEF0Ym8oz51eCc0Wc84f2
         n0OFjiCfA/5yvEKfJW7YtP9J1Ml5TCrWs3wYkilJrtQ7pRfKYIhhFh/tlU6Xsj2L+bYD
         CkwNl7vWNNyCXM6W0FH55pBuB/DECPGxiRhGdPjCsk7mXlEN2SBE2csczfGXPMXqofI2
         VuhjMVXf4WV5yr++rgFP72BQheMzOyOPXExulKAdkFUQYRTG7SDTCZSQbgPEWnWgBjhr
         k6TSCgTIHplZizhH6Cj/+Vy9u+IjeI9R20hH+N5N9yUC9XKHZVcZS6dymXtdKRnpIelQ
         b08A==
X-Forwarded-Encrypted: i=1; AJvYcCXSqob0xYP86zOm9Fei15FTRqKHvEyBswhhK7dMpEHAD0iv4dEKAfLyT6QXDRLYpQw0itM=@vger.kernel.org
X-Gm-Message-State: AOJu0Yzny8AvziRbewLUPVlcCEhoIi5ujLzHuQyoYqZxsHjPGvW8l7C0
	MpRVhnOawVdOOuJPBZnrHQIEZ5G+IgmkyIhNpYk3dKOjeLQeRyaKkbQNyBLRMjpauCQ=
X-Gm-Gg: AZuq6aIY71Xvn7oWJafX5QGn7Vl9sUh3/yqSq3cRAPMd2uL72aKNSTikOb8ejWDhWkd
	xXjfTecal+7imclFilx3H8bYS/d3/VPY8GZRyqi7q5pkDc1VI+WQstCiRyIsBSG4iquo8NLekQf
	VU+rW55heU2TjAUPbNsuFdcR+hB/I+415QNH6pURiDb1uXRO4xsHj2vqawDyckVwgkcaOGF4kIQ
	nZTZwL5C24J09OLMseiQcFoCxtQ8LcWPUiu/VdEDUC2XIKtC+MXOv+F1r/JJdYe/XTmXEisDDD6
	mWUIzYai+XRSA8+++y/R59orwDEzYB0ZfVoE+If+uMZ+DHSDsIjSz5ut5orZrS6fXh9Z4XPa+ZG
	2USo8OBW1nlyerBe8E93Zs09K/h8+BlMSFgWLRWb3TUnGVJVboYYGD5b3+LwlN15Qut9uVHgeGk
	aJ0r9PnJbqSpyLlkAsqIu7tvGjEGloz86KbvU3+xgh7t9s9uup3F4xx2HIw1HhrscUxYnbCr2Ru
	XVTH9Es/ZUiT+g=
X-Received: by 2002:a17:903:2284:b0:2a9:2ab2:e50d with SMTP id d9443c01a7336-2ad17586af9mr127169705ad.51.1771473728472;
        Wed, 18 Feb 2026 20:02:08 -0800 (PST)
Received: from pc.taild8403c.ts.net (216-71-219-44.dyn.novuscom.net. [216.71.219.44])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2ad1a73200asm147636225ad.36.2026.02.18.20.02.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 18 Feb 2026 20:02:07 -0800 (PST)
From: Pierrick Bouvier <pierrick.bouvier@linaro.org>
To: qemu-devel@nongnu.org
Cc: =?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>,
	Pierrick Bouvier <pierrick.bouvier@linaro.org>,
	Paolo Bonzini <pbonzini@redhat.com>,
	qemu-arm@nongnu.org,
	kvm@vger.kernel.org,
	Richard Henderson <richard.henderson@linaro.org>,
	=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
	anjo@rev.ng,
	Peter Maydell <peter.maydell@linaro.org>,
	Jim MacArthur <jim.macarthur@linaro.org>
Subject: [PATCH v4 00/14] target/arm: single-binary
Date: Wed, 18 Feb 2026 20:01:36 -0800
Message-ID: <20260219040150.2098396-1-pierrick.bouvier@linaro.org>
X-Mailer: git-send-email 2.47.3
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-1.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MID_CONTAINS_FROM(1.00)[];
	DMARC_POLICY_ALLOW(-0.50)[linaro.org,none];
	R_DKIM_ALLOW(-0.20)[linaro.org:s=google];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	DKIM_TRACE(0.00)[linaro.org:+];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-71309-lists,kvm=lfdr.de];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	FROM_HAS_DN(0.00)[];
	TO_DN_SOME(0.00)[];
	RCVD_COUNT_FIVE(0.00)[5];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[pierrick.bouvier@linaro.org,kvm@vger.kernel.org];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	NEURAL_HAM(-0.00)[-1.000];
	TAGGED_RCPT(0.00)[kvm];
	RCPT_COUNT_SEVEN(0.00)[11];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: D4DC315BEE0
X-Rspamd-Action: no action

This series continues cleaning target/arm, especially tcg folder.

For now, it contains some cleanups in headers, and it splits helpers per
category, thus removing several usage of TARGET_AARCH64.
First version was simply splitting 32 vs 64-bit helpers, and Richard asked
to split per sub category.

v4
--

- add two patches from Peter removing helper in non-tcg files
  20260216160349.3079657-1-peter.maydell@linaro.org
  This fixes build failure with kvm-only and xen-only builds on aarch64.
  I didn't split helper and gen_helper headers. If that really matters, it can
  be done in v5.

v3
--

- translate.h: missing vaddr replacement
- move tcg_use_softmmu to tcg/tcg-internal.h to avoid duplicating compilation
  units between system and user builds.
- eradicate TARGET_INSN_START_EXTRA_WORDS by calling tcg_gen_insn_start with
  additional 0 parameters if needed.

v2
--

- add missing kvm_enabled() in arm-qmp-cmds.c
- didn't extract arm_wfi for tcg/psci.c. If that's a hard requirement, I can do
  it in next version.
- restricted scope of series to helper headers, so we can validate things one
  step at a time. Series will keep on growing once all patches are reviewed.
- translate.h: use vaddr where appropriate, as asked by Richard.

Peter Maydell (2):
  target/arm: Move TCG-specific code out of debug_helper.c
  target/arm: Don't require helper prototypes in helper.c

Pierrick Bouvier (12):
  target/arm: extract helper-mve.h from helper.h
  target/arm: extract helper-a64.h from helper.h
  target/arm: extract helper-sve.h from helper.h
  target/arm: extract helper-sme.h from helper.h
  tcg: move tcg_use_softmmu to tcg/tcg-internal.h
  target/arm: move exec/helper-* plumbery to helper.h
  target/arm/tcg/psci.c: make compilation unit common
  target/arm/tcg/cpu-v7m.c: make compilation unit common
  target/arm/tcg/vec_helper.c: make compilation unit common
  target/arm/tcg/translate.h: replace target_ulong with vaddr
  target/arm/tcg/translate.h: replace target_long with int64_t
  include/tcg/tcg-op.h: eradicate TARGET_INSN_START_EXTRA_WORDS

 include/tcg/tcg-op-common.h                   |   8 +
 include/tcg/tcg-op.h                          |  29 -
 include/tcg/tcg.h                             |   6 -
 target/alpha/cpu-param.h                      |   2 -
 target/arm/cpu-param.h                        |   7 -
 target/arm/helper-a64.h                       |  14 +
 target/arm/helper-mve.h                       |  14 +
 target/arm/helper-sme.h                       |  14 +
 target/arm/helper-sve.h                       |  14 +
 target/arm/helper.h                           |  17 +-
 .../tcg/{helper-a64.h => helper-a64-defs.h}   |   0
 target/arm/tcg/{helper.h => helper-defs.h}    |   0
 .../tcg/{helper-mve.h => helper-mve-defs.h}   |   0
 .../tcg/{helper-sme.h => helper-sme-defs.h}   |   0
 .../tcg/{helper-sve.h => helper-sve-defs.h}   |   0
 target/arm/tcg/translate-a32.h                |   2 +-
 target/arm/tcg/translate.h                    |  22 +-
 target/arm/tcg/vec_internal.h                 |  49 ++
 target/avr/cpu-param.h                        |   2 -
 target/hexagon/cpu-param.h                    |   2 -
 target/hppa/cpu-param.h                       |   2 -
 target/i386/cpu-param.h                       |   2 -
 target/loongarch/cpu-param.h                  |   2 -
 target/m68k/cpu-param.h                       |   2 -
 target/microblaze/cpu-param.h                 |   2 -
 target/mips/cpu-param.h                       |   2 -
 target/or1k/cpu-param.h                       |   2 -
 target/ppc/cpu-param.h                        |   2 -
 target/riscv/cpu-param.h                      |   7 -
 target/rx/cpu-param.h                         |   2 -
 target/s390x/cpu-param.h                      |   2 -
 target/sh4/cpu-param.h                        |   2 -
 target/sparc/cpu-param.h                      |   2 -
 target/tricore/cpu-param.h                    |   2 -
 target/xtensa/cpu-param.h                     |   2 -
 tcg/tcg-internal.h                            |   6 +
 target/alpha/translate.c                      |   4 +-
 target/arm/debug_helper.c                     | 769 -----------------
 target/arm/helper.c                           |   5 +-
 target/arm/tcg/arith_helper.c                 |   4 +-
 target/arm/tcg/crypto_helper.c                |   4 +-
 target/arm/tcg/debug.c                        | 780 ++++++++++++++++++
 target/arm/tcg/gengvec64.c                    |   3 +-
 target/arm/tcg/helper-a64.c                   |   6 +-
 target/arm/tcg/hflags.c                       |   4 +-
 target/arm/tcg/m_helper.c                     |   2 +-
 target/arm/tcg/mte_helper.c                   |   3 +-
 target/arm/tcg/mve_helper.c                   |   6 +-
 target/arm/tcg/neon_helper.c                  |   4 +-
 target/arm/tcg/op_helper.c                    |   2 +-
 target/arm/tcg/pauth_helper.c                 |   3 +-
 target/arm/tcg/psci.c                         |   4 +-
 target/arm/tcg/sme_helper.c                   |   5 +-
 target/arm/tcg/sve_helper.c                   |   6 +-
 target/arm/tcg/tlb_helper.c                   |   4 +-
 target/arm/tcg/translate-a64.c                |   3 +
 target/arm/tcg/translate-mve.c                |   1 +
 target/arm/tcg/translate-sme.c                |   3 +
 target/arm/tcg/translate-sve.c                |   3 +
 target/arm/tcg/translate.c                    |  28 +-
 target/arm/tcg/vec_helper.c                   | 224 +----
 target/arm/tcg/vec_helper64.c                 | 142 ++++
 target/arm/tcg/vfp_helper.c                   |   4 +-
 target/avr/translate.c                        |   2 +-
 target/hexagon/translate.c                    |   2 +-
 target/i386/tcg/translate.c                   |   2 +-
 target/loongarch/tcg/translate.c              |   2 +-
 target/m68k/translate.c                       |   2 +-
 target/microblaze/translate.c                 |   2 +-
 target/or1k/translate.c                       |   2 +-
 target/ppc/translate.c                        |   2 +-
 target/rx/translate.c                         |   2 +-
 target/sh4/translate.c                        |   4 +-
 target/sparc/translate.c                      |   2 +-
 target/tricore/translate.c                    |   2 +-
 target/xtensa/translate.c                     |   2 +-
 tcg/tcg.c                                     |   4 -
 target/arm/tcg/meson.build                    |  13 +-
 78 files changed, 1165 insertions(+), 1149 deletions(-)
 create mode 100644 target/arm/helper-a64.h
 create mode 100644 target/arm/helper-mve.h
 create mode 100644 target/arm/helper-sme.h
 create mode 100644 target/arm/helper-sve.h
 rename target/arm/tcg/{helper-a64.h => helper-a64-defs.h} (100%)
 rename target/arm/tcg/{helper.h => helper-defs.h} (100%)
 rename target/arm/tcg/{helper-mve.h => helper-mve-defs.h} (100%)
 rename target/arm/tcg/{helper-sme.h => helper-sme-defs.h} (100%)
 rename target/arm/tcg/{helper-sve.h => helper-sve-defs.h} (100%)
 create mode 100644 target/arm/tcg/debug.c
 create mode 100644 target/arm/tcg/vec_helper64.c

-- 
2.47.3


