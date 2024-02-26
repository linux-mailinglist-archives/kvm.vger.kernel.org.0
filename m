Return-Path: <kvm+bounces-9814-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 19BD9867240
	for <lists+kvm@lfdr.de>; Mon, 26 Feb 2024 11:56:26 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id E3038B240DB
	for <lists+kvm@lfdr.de>; Mon, 26 Feb 2024 10:27:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 510E95C604;
	Mon, 26 Feb 2024 10:13:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="WVSCWhzp"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f171.google.com (mail-pf1-f171.google.com [209.85.210.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 25AD121A0D
	for <kvm@vger.kernel.org>; Mon, 26 Feb 2024 10:13:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708942398; cv=none; b=br8B5Pt+H3LkzSjZDZTLcZgyya+PUzjUCtYnoa0Q1W/N1jjJGD/OJesrcSjKuUBOyOuZj8yLkYrm1QrUcnVGQ5S4lHB85cNLLwrch/YWjRV0FPeTDqHi+tOc33Y+ztchzQP0e+4UCgFPb8LRTLSQQDAB/jUzziak2R7snkYfViY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708942398; c=relaxed/simple;
	bh=QenBdDBZWxbnmcZ6ZW5/HoKdKk5FqQL7GaoZPDX6IIQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OkJ9dcTXJZfagqO9a50K6/0FdpObljPY2YPP/ltaBGylDbIrYx++1m4A39l5OKigebSyGten66tEzYDF5BJqEvS2K/f4JZzI5Q9jEs+lDOjYa3xSvMJlxBobU3t9YiVCHo8WULp700CuSudzzTbbB7J+Iega+UlSasW4hJu1n5w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=WVSCWhzp; arc=none smtp.client-ip=209.85.210.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pf1-f171.google.com with SMTP id d2e1a72fcca58-6e4670921a4so1450875b3a.0
        for <kvm@vger.kernel.org>; Mon, 26 Feb 2024 02:13:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1708942396; x=1709547196; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=wzMbIs3gJ3U5zsDc5LA3bRRA3z8B3P/c5K9+wo8IYO0=;
        b=WVSCWhzpC8J2mkog1TJfiikBwceuvDZmmqg/SKEpxXZoaXYyY+lL+3E+nCiLlfi+AN
         q6Z6rmeF8cD+LxGhq5zkIpBQHtWaxzePaA4ti0+8JMRr82DYceUxlR6+Uzwom0efPRyI
         rFtog0aYL8arWAw1uSoTGaJqlsFmcpAZzN5ptt/y4zpvuX86itDZLb5C9HwPBOyqwIWs
         L4mGyPNOgqjMOMd9kms40PJ9pHFHwi3TaipR8N+ECqjHdteXwUwqVPaCwq4m7d/WtM7c
         OwXh1BFkRSgc8tnIFutwJqcgfMcgXGGA6fmnhAd5eBjIuqEvea3kRewolw2nr+rWoghP
         Y0Yw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1708942396; x=1709547196;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=wzMbIs3gJ3U5zsDc5LA3bRRA3z8B3P/c5K9+wo8IYO0=;
        b=GEj5wTWU1bRX3zaGyJDrPexLRa2phkR0iprq7VGjEVdd4bdFsp98uOZoUxtm7mB8U5
         FG6Ggd1s9xJHa/NfGFX4aDdBXB4kdcVshwgYlONpUxBrZDDn06cnjh7+ElWw7gulybed
         t8B/A/0nAmO152a4F4qF5Ot+1w0VVLbJ2mEuOnFZIFUpMVANTIw3aIULB1SS0mndnMPF
         OensomgrHZqmohnd742H9J5uW+42ua7j+dNtdImsDBb2/c5LQJ8NQhVwA2kEj92t6V95
         0dZrjzVVUFY0NjuMNogpbTN+SGhqFsaTfVS98vWmzanQggEFasrFqRoQX3LQzapaJaPs
         QN9w==
X-Forwarded-Encrypted: i=1; AJvYcCUXICIHF7Qx4Am93XSG0ZHLNnREgxE0KxknKg2nRizZk+tfKm3mtnxv3KeYvUuakEo+Lj4I7iyuL93JbFP3yPF/LgRy
X-Gm-Message-State: AOJu0YzIeQf96PUBqqA4N8hu4DTMK1DOp3Nm2AQQd2Os2DaARXcYVkCA
	7KBAFleaBKJIR3oBJHCBZRp3OpJcSHXbhWsNr2N+EzMdwSxKqpgu
X-Google-Smtp-Source: AGHT+IGyoivjogRgGhhisbrK5W13r/wcaKqQ74eXnDeW7mVKgvAo2Cmj7WGfqlnuQGa7jYEqzuKqWg==
X-Received: by 2002:a05:6a00:23cc:b0:6e4:cdb2:636f with SMTP id g12-20020a056a0023cc00b006e4cdb2636fmr9145539pfc.4.1708942394954;
        Mon, 26 Feb 2024 02:13:14 -0800 (PST)
Received: from wheely.local0.net (220-235-194-103.tpgi.com.au. [220.235.194.103])
        by smtp.gmail.com with ESMTPSA id x24-20020aa784d8000000b006e463414493sm3626693pfn.105.2024.02.26.02.13.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 26 Feb 2024 02:13:14 -0800 (PST)
From: Nicholas Piggin <npiggin@gmail.com>
To: Thomas Huth <thuth@redhat.com>
Cc: Nicholas Piggin <npiggin@gmail.com>,
	Laurent Vivier <lvivier@redhat.com>,
	Andrew Jones <andrew.jones@linux.dev>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Joel Stanley <joel@jms.id.au>,
	linuxppc-dev@lists.ozlabs.org,
	kvm@vger.kernel.org
Subject: [kvm-unit-tests PATCH 10/32] scripts: Accommodate powerpc powernv machine differences
Date: Mon, 26 Feb 2024 20:11:56 +1000
Message-ID: <20240226101218.1472843-11-npiggin@gmail.com>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20240226101218.1472843-1-npiggin@gmail.com>
References: <20240226101218.1472843-1-npiggin@gmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The QEMU powerpc powernv machine has minor differences that must be
accommodated for in output parsing:

- Summary parsing must search more lines of output for the summary
  line, to accommodate OPAL message on shutdown.
- Premature failure testing must tolerate case differences in kernel
  load error message.

Acked-by: Thomas Huth <thuth@redhat.com>
Signed-off-by: Nicholas Piggin <npiggin@gmail.com>
---
 scripts/runtime.bash | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/scripts/runtime.bash b/scripts/runtime.bash
index 8f9672d0d..bb32c0d10 100644
--- a/scripts/runtime.bash
+++ b/scripts/runtime.bash
@@ -9,7 +9,7 @@ FAIL() { echo -ne "\e[31mFAIL\e[0m"; }
 extract_summary()
 {
     local cr=$'\r'
-    tail -3 | grep '^SUMMARY: ' | sed 's/^SUMMARY: /(/;s/'"$cr"'\{0,1\}$/)/'
+    tail -5 | grep '^SUMMARY: ' | sed 's/^SUMMARY: /(/;s/'"$cr"'\{0,1\}$/)/'
 }
 
 # We assume that QEMU is going to work if it tried to load the kernel
@@ -18,7 +18,7 @@ premature_failure()
     local log="$(eval "$(get_cmdline _NO_FILE_4Uhere_)" 2>&1)"
 
     echo "$log" | grep "_NO_FILE_4Uhere_" |
-        grep -q -e "could not \(load\|open\) kernel" -e "error loading" &&
+        grep -q -e "[Cc]ould not \(load\|open\) kernel" -e "error loading" &&
         return 1
 
     RUNTIME_log_stderr <<< "$log"
-- 
2.42.0


