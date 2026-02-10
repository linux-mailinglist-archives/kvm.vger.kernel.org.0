Return-Path: <kvm+bounces-70783-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id WJzlNPmRi2n/WAAAu9opvQ
	(envelope-from <kvm+bounces-70783-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Tue, 10 Feb 2026 21:15:53 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [IPv6:2600:3c09:e001:a7::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 79E5D11EEF9
	for <lists+kvm@lfdr.de>; Tue, 10 Feb 2026 21:15:53 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id 40AEF30186B1
	for <lists+kvm@lfdr.de>; Tue, 10 Feb 2026 20:15:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6C1BB32E745;
	Tue, 10 Feb 2026 20:15:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="aZaIAaBa"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f172.google.com (mail-pg1-f172.google.com [209.85.215.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7916125B1DA
	for <kvm@vger.kernel.org>; Tue, 10 Feb 2026 20:15:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770754547; cv=none; b=TxpetBBpbCBt0/xcZR1d8w9Wj61U5yYiRv8goREtPh9RXIv9UHWwQ2inJrLuf+/1y8/hh1g3sNgX82bz3FW1BPoDiep0gCccMfleLmkNcRqSQeTcz3anNUj56BDWEtiNyHgr3tEyd23soHEDp5cKUymF+K24lQp64uGuYKiawGQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770754547; c=relaxed/simple;
	bh=ENCOm5pKoxKcbUojV7OvrvhxjS6StazE8+SVMUkX9xM=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=jUA6lZdaEYQ2DoEvltGkZeLs2kl3Ndmfm3FHxwQwkSJcd2+dLfkfR4FSXhEmQV1GFDpvroFHbcpnbPhQxGEsuKyqHD2Ma8pBVvqK2HViAHrqRBOuDxWMN2gdLqNgznrx1E1W8hOjFl9zCj1Fes0hF5tfejvb6Ommh3j7hOsCJyw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=aZaIAaBa; arc=none smtp.client-ip=209.85.215.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-pg1-f172.google.com with SMTP id 41be03b00d2f7-c0c24d0f4ceso1617322a12.1
        for <kvm@vger.kernel.org>; Tue, 10 Feb 2026 12:15:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1770754546; x=1771359346; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=sIWUOqnZLyGKePk6QDBiFdhDuhnslcwsH8LlDsj2/ZI=;
        b=aZaIAaBaq13bTxKwoVz6+AiXJqRXNXBiGifkNuwQjdVniskF96pOdrP91gS3bQ3KjH
         j13tXEYpvzqGaY+IX7HOZHSfNUCDR3xP03YwYcA7zYJEmSnz6oYaUOBl8m5TAkhnpPLZ
         O02DhSsRbfCExWL8kgZddDxNKNlxbWzuGoPF1a09h5RaxTeS97542oMIGoAwlCyxeiov
         v88c1mCkrslBhXEir+r1aGqxqA4JbnTiRcBftjA0DgA62+KCT3tCZmhcWlDQO5E612Rd
         yRNmcH66bY4Kcje4rWoVFuUKK5aiU0lNN+DuYwwcT0yDQ66PfTs2Ks9A7AZkERNR+k2i
         M16A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770754546; x=1771359346;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=sIWUOqnZLyGKePk6QDBiFdhDuhnslcwsH8LlDsj2/ZI=;
        b=MLsQEit+Du3HsTJ/QrSnBzWA2d6w2di9pHs+XbV9xbqOVi21mny7zNI+GfwCjGo+Bi
         7T4+AMhWZxHh9O5j4Q3Vvmjv7LtrYf9ekOGkfwDslImVQnH3bi3bFNa03zYmDo3VIy7T
         Fk1E0M6IkS/poLdt43MU8YyuS8gA/NjdHgcqkxoeN3NmxIJpWJdqCgunr7JFZjaW8SYR
         Fv0xex5jaQ98fHubrVWgYgBDJb2lrLdKOr1sa0+N8jNo5MqW1CF6/Dnk5QgGnmKH3+31
         qDQWcy7h66+sGYqMabKXVzW1cQaztZccNDB4TDM1znwDEFMHeYtkZh5O5LDIIwZV8+wv
         kqsQ==
X-Forwarded-Encrypted: i=1; AJvYcCWjRV+XKGEOryYYVcARyhl8TlyiKHfxHqL2X6dXZ6O2kKEjsJCrh5GKZ4tqyiIk0WEVb1o=@vger.kernel.org
X-Gm-Message-State: AOJu0YyOxanwZZ/tr/iSOJm4gkq/D/dJvkbegTceyTpEXozn0+m/MiEg
	+jAiqlOh6dTdheyiVMJrHDo3Tbp9Wzzh294cHLKTT7ArcOjl42a+i2RRvf0SUCmIJV4=
X-Gm-Gg: AZuq6aLH2TCWHq5XMx2AdJsRFkOoo+2gYaowjYa2XH80n5/X3eANaLgkhqg6d3/mwTv
	9u4GpTCz6xKnm5xJVN3InzCHYFPGnoCDy63YpvxQO1WAnhdWh+sv0ie7lAyAHsaxatrDcr7ImP7
	CW61044Ak6JvvwLOaUBygK4m0VZQSESFMmJBvkjJoIDzDDuTDuB7Tq3ipXymhy3PpI+rIlHVZEQ
	0oVKBVU8ovMkdR4OI2wevULxRpTz3zCpFWgOAjzJQ6lcvF0ggWsulTlU3/I1dsNFihjTZZ5tKu+
	XqX7TV4pFdhFb9vBTfMwxwiJNZ/oeGGtceJ6vJsZXnK95w3yRwffqhtXLnBGRrsVJQQMtBoVnxf
	TRpILWBh0UdTRdKfr5WR8QNmGQYWDYNYg/RuFI8fmonL8VitfyvS/IT9eU5W3bLOjuTEKHY+c74
	YvTuF9KLeItavFfS02cqihwjNd5zSVDN8hHMHdHwlu/5TLmb2/CORusrYdyfOLrkf1assMnwGoy
	njf
X-Received: by 2002:a17:902:d48a:b0:2a9:43a9:d367 with SMTP id d9443c01a7336-2ab27f57751mr2999185ad.51.1770754545632;
        Tue, 10 Feb 2026 12:15:45 -0800 (PST)
Received: from pc.taild8403c.ts.net (216-71-219-44.dyn.novuscom.net. [216.71.219.44])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2ab0b392cb5sm38523225ad.70.2026.02.10.12.15.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 10 Feb 2026 12:15:45 -0800 (PST)
From: Pierrick Bouvier <pierrick.bouvier@linaro.org>
To: qemu-devel@nongnu.org
Cc: anjo@rev.ng,
	Jim MacArthur <jim.macarthur@linaro.org>,
	kvm@vger.kernel.org,
	Paolo Bonzini <pbonzini@redhat.com>,
	=?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>,
	=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
	Pierrick Bouvier <pierrick.bouvier@linaro.org>,
	Peter Maydell <peter.maydell@linaro.org>,
	qemu-arm@nongnu.org,
	Richard Henderson <richard.henderson@linaro.org>
Subject: [PATCH v3 00/12] target/arm: single-binary
Date: Tue, 10 Feb 2026 12:15:28 -0800
Message-ID: <20260210201540.1405424-1-pierrick.bouvier@linaro.org>
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
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c09:e001:a7::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	DKIM_TRACE(0.00)[linaro.org:+];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-70783-lists,kvm=lfdr.de];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	FROM_HAS_DN(0.00)[];
	TO_DN_SOME(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[pierrick.bouvier@linaro.org,kvm@vger.kernel.org];
	ASN(0.00)[asn:63949, ipnet:2600:3c09::/32, country:SG];
	RCVD_COUNT_FIVE(0.00)[5];
	TAGGED_RCPT(0.00)[kvm];
	RCPT_COUNT_SEVEN(0.00)[11];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[linaro.org:mid,linaro.org:dkim,sto.lore.kernel.org:helo,sto.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: 79E5D11EEF9
X-Rspamd-Action: no action

This series continues cleaning target/arm, especially tcg folder.

For now, it contains some cleanups in headers, and it splits helpers per
category, thus removing several usage of TARGET_AARCH64.
First version was simply splitting 32 vs 64-bit helpers, and Richard asked
to split per sub category.

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
 include/tcg/tcg-op.h                          |  29 ---
 include/tcg/tcg.h                             |   6 -
 target/alpha/cpu-param.h                      |   2 -
 target/arm/cpu-param.h                        |   7 -
 target/arm/helper-a64.h                       |  14 ++
 target/arm/helper-mve.h                       |  14 ++
 target/arm/helper-sme.h                       |  14 ++
 target/arm/helper-sve.h                       |  14 ++
 target/arm/helper.h                           |  17 +-
 .../tcg/{helper-a64.h => helper-a64-defs.h}   |   0
 target/arm/tcg/{helper.h => helper-defs.h}    |   0
 .../tcg/{helper-mve.h => helper-mve-defs.h}   |   0
 .../tcg/{helper-sme.h => helper-sme-defs.h}   |   0
 .../tcg/{helper-sve.h => helper-sve-defs.h}   |   0
 target/arm/tcg/translate-a32.h                |   2 +-
 target/arm/tcg/translate.h                    |  22 +-
 target/arm/tcg/vec_internal.h                 |  49 ++++
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
 target/arm/debug_helper.c                     |   4 +-
 target/arm/helper.c                           |   5 +-
 target/arm/tcg/arith_helper.c                 |   4 +-
 target/arm/tcg/crypto_helper.c                |   4 +-
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
 target/arm/tcg/translate.c                    |  25 +-
 target/arm/tcg/vec_helper.c                   | 224 ++----------------
 target/arm/tcg/vec_helper64.c                 | 142 +++++++++++
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
 target/arm/tcg/meson.build                    |  11 +-
 77 files changed, 383 insertions(+), 381 deletions(-)
 create mode 100644 target/arm/helper-a64.h
 create mode 100644 target/arm/helper-mve.h
 create mode 100644 target/arm/helper-sme.h
 create mode 100644 target/arm/helper-sve.h
 rename target/arm/tcg/{helper-a64.h => helper-a64-defs.h} (100%)
 rename target/arm/tcg/{helper.h => helper-defs.h} (100%)
 rename target/arm/tcg/{helper-mve.h => helper-mve-defs.h} (100%)
 rename target/arm/tcg/{helper-sme.h => helper-sme-defs.h} (100%)
 rename target/arm/tcg/{helper-sve.h => helper-sve-defs.h} (100%)
 create mode 100644 target/arm/tcg/vec_helper64.c

-- 
2.47.3


