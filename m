Return-Path: <kvm+bounces-40420-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 22A55A57211
	for <lists+kvm@lfdr.de>; Fri,  7 Mar 2025 20:38:08 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 5397A17729C
	for <lists+kvm@lfdr.de>; Fri,  7 Mar 2025 19:38:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C34A52561CC;
	Fri,  7 Mar 2025 19:37:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="B0Fl96Tm"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f47.google.com (mail-pj1-f47.google.com [209.85.216.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 65290255241
	for <kvm@vger.kernel.org>; Fri,  7 Mar 2025 19:37:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741376244; cv=none; b=Se51seWXlwxNlYs/rBT1aB76ggNq7App/dHQAAf3w8HhcnMH+pkbIcqfNUL4Q6JUHU0+TUe/1YAMYdIE1xW/N+0bjfN9H+1N32MnrxpfuJYKu7cs+WIyRxQUdjVX8wFBuq8TGyJ7a55fn2QwSUZs7vAtOlnYriD/e3wa5XZMtt8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741376244; c=relaxed/simple;
	bh=oIH8yj3UVV8IhXniF0UD9Iri92boehPiW+vAOQGJ/C4=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version:Content-Type; b=bwwDVe6JkOLz0qMa7k7Xi0t5nyhlediIUKvy1yGAdTtLL2fgmElWKiM58A79piokgPY3e79x6SUSYrw8436Smravqp/zgG4Euyr2IxQ6smuye3SW46ygDztOLGRqbkjymnzYzWLbgMZJ4/gXxavpejM05pLdN4q4KMxGCwcWyMc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=B0Fl96Tm; arc=none smtp.client-ip=209.85.216.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-pj1-f47.google.com with SMTP id 98e67ed59e1d1-2ff797f8f1bso2603375a91.3
        for <kvm@vger.kernel.org>; Fri, 07 Mar 2025 11:37:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1741376242; x=1741981042; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=9HouUG8niuHw8Sf2QTc63hh0W5B3dkdBWi71GrcJcio=;
        b=B0Fl96Tmalev3fBAu467gC40WZWBL9JQ4eigzvZcvz05PWebD6CzBPiPgKMJXnIb9S
         MEiKu7ZMdXLCOLe8aQNBEriLo2yEiNyI6bcKgblxooX1t1GGLaa/QYlwC2ncqu2nSTeN
         FKMUzLzMf1V4UuYOFX2OqjV3WYpXRfyDdQ6TzX6ItzqS8eY/Tzm6xD5icNpd1LGHt4HN
         RCOVkh/c+j4/zPeszF5DhMUWp9lFW3d4821KFjbfFCkvXeb8R5b7cCycSQaxSuZyEvS8
         /6RohFNtG6orG4LCEMX7iVJkUNe/KtaUiiiuUuID1xdMk+s1XkmSwDZuaWWB1oXpV1D7
         QYOA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1741376242; x=1741981042;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=9HouUG8niuHw8Sf2QTc63hh0W5B3dkdBWi71GrcJcio=;
        b=o850aOHTYvfbOpmoDM/jNfFrkA420jUhIsl4HPgqNfokc32CY8vptuvPn/NKOydN46
         HZiTXT5v+o/Z6kFlOLlKthcsmLWcATojFnsnj46y0GxufNCeda6DsSq2fPI0Sn3a0zCm
         bvjFuvpcbmU5p4+WUvijyCea0rks72DrT6WlbtKoDkBdgQj+7R6TeCkp3t0spskF1V0i
         YBjpup1STSXpFZQAyhAeU9At+6yCwE50GI5YX3UKA96/T3NaJwrpx7B9pOisJcQlUuoy
         wnqdnKy3GlQxM7g6vrRtVwRtehzxeYYblaDqYDTAj9N1H6BIwlmxYYRwuHzfKP7YtG09
         isCg==
X-Forwarded-Encrypted: i=1; AJvYcCWHXDm/8yO9AkyWwKsINFvPaHoaMZ56NZrdyAlOmTPmV3zp6J7Z0O+FWH0plST5vpChPRs=@vger.kernel.org
X-Gm-Message-State: AOJu0Yy55FwOGVfxCD8J1zcQNMujiJllcmphabQ8jq48eogSf2Ja462c
	ohB6gzZ/xML7JtOUS3nK0a6dFyNuMw3z5PDAwaq/LVOYlrN9P8gxsi0zGQsuMAg=
X-Gm-Gg: ASbGncsN1B2jlg49hpBNkw+OuIRdSHLw9VEQsY/XZp7kjXd5MqSJoSl/6mi25GijYnJ
	qO2o5lv9tFaqb4v13JV9ofJQfXqgyzjboJENvMXrLk5UJRQ8gVQ9rk08dqc8DO3faQC/Y4mm4NG
	n4rXbb1efK7dC7kwD1CnSKVvbRK4siu9PzQn4V0aQGlsKkSTSMHOXT2yYsWtwep5dXdGau+Ms9v
	QIqlTYuRe6pY+y+/ZyZrRJfHIrXt712Cp4laqSTNZkuYFH27NHhMg51UvfRtunvOVok2FjsLpVK
	A/7N8ukDsAmoIOU2Zacd2+/I2jLuKoGneP4c9Cg0mhNo
X-Google-Smtp-Source: AGHT+IFJS++w8dzKDaOiSNIqEF9LrcEsboBc4OQa3FNMlu4p0lXjJGWbKjKjpc9ao6Lot8C40MJZdA==
X-Received: by 2002:a17:90b:350d:b0:2fe:85f0:e115 with SMTP id 98e67ed59e1d1-2ff7cefbc61mr6158126a91.26.1741376242639;
        Fri, 07 Mar 2025 11:37:22 -0800 (PST)
Received: from pc.. ([38.39.164.180])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-2ff693739ecsm3821757a91.26.2025.03.07.11.37.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 07 Mar 2025 11:37:22 -0800 (PST)
From: Pierrick Bouvier <pierrick.bouvier@linaro.org>
To: qemu-devel@nongnu.org
Cc: alex.bennee@linaro.org,
	philmd@linaro.org,
	kvm@vger.kernel.org,
	richard.henderson@linaro.org,
	"Maciej S. Szmigiero" <maciej.szmigiero@oracle.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	manos.pitsidianakis@linaro.org,
	pierrick.bouvier@linaro.org,
	Marcelo Tosatti <mtosatti@redhat.com>
Subject: [PATCH v3 0/7] hw/hyperv: remove duplication compilation units
Date: Fri,  7 Mar 2025 11:37:05 -0800
Message-Id: <20250307193712.261415-1-pierrick.bouvier@linaro.org>
X-Mailer: git-send-email 2.39.5
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit

Work towards having a single binary, by removing duplicated object files.

hw/hyperv/hyperv.c was excluded at this time, because it depends on target
dependent symbols:
- from system/kvm.h
    - kvm_check_extension
    - kvm_vm_ioctl
- from exec/cpu-all.h | memory_ldst_phys.h.inc
    - ldq_phys

v2
- remove osdep from header
- use hardcoded buffer size for syndbg, assuming page size is always 4Kb.

v3
- fix assert for page size.

Pierrick Bouvier (7):
  hw/hyperv/hv-balloon-stub: common compilation unit
  hw/hyperv/hyperv.h: header cleanup
  hw/hyperv/vmbus: common compilation unit
  hw/hyperv/hyperv-proto: move SYNDBG definition from target/i386
  hw/hyperv/syndbg: common compilation unit
  hw/hyperv/balloon: common balloon compilation units
  hw/hyperv/hyperv_testdev: common compilation unit

 include/hw/hyperv/hyperv-proto.h | 12 ++++++++
 include/hw/hyperv/hyperv.h       |  3 +-
 target/i386/kvm/hyperv-proto.h   | 12 --------
 hw/hyperv/syndbg.c               | 10 +++++--
 hw/hyperv/vmbus.c                | 50 ++++++++++++++++----------------
 hw/hyperv/meson.build            |  9 +++---
 6 files changed, 51 insertions(+), 45 deletions(-)

-- 
2.39.5


