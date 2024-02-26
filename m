Return-Path: <kvm+bounces-9821-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 4C6158670F2
	for <lists+kvm@lfdr.de>; Mon, 26 Feb 2024 11:28:55 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id B0B221F2B36D
	for <lists+kvm@lfdr.de>; Mon, 26 Feb 2024 10:28:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8AF845DF0E;
	Mon, 26 Feb 2024 10:13:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="UQKEayPQ"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f169.google.com (mail-pf1-f169.google.com [209.85.210.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5D93E5D909
	for <kvm@vger.kernel.org>; Mon, 26 Feb 2024 10:13:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708942425; cv=none; b=QXHSxce1pi9ercXs3YH8BhMXvwfdl2rOKB0fNVSJP2SOoL6KOf3SZV7SILdlTzB/Ngoq7v5KXRIWQBYPZaEtcn8YlI5ANMXByZ9LLv7GBm0JMAXWfTWtfiYKtnRLGK2AEmiuu7LebivnRiFpoI9opQM2U8xWccUKI//ISfhGDWg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708942425; c=relaxed/simple;
	bh=fEplahtBUWD+Ds5mnK//zyYHLYBR0i/opmQpMg2/b9M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LE14avQmsK9ahIh3BIjHqo9ZuII2wqpbV0Qd7OvfGbGKL+L2m2l/6HpABBX5rd5/1LBPYBEdlLZInoU1D2ZZs9ngcLzLomusL3SplNzFX6Yag5Fva1oR3izh0EUc0UhtNKT9hEgSAxoU7Ri9AL4jygIN1p9k2oa7vKaj/5UKSrI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=UQKEayPQ; arc=none smtp.client-ip=209.85.210.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pf1-f169.google.com with SMTP id d2e1a72fcca58-6e4d869b019so1190475b3a.0
        for <kvm@vger.kernel.org>; Mon, 26 Feb 2024 02:13:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1708942424; x=1709547224; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=mYxWqQyihqZ/xKRwoD0QjakwL6RSMHUw8t/Bhqm9gTk=;
        b=UQKEayPQwm9ujoBFn4nGQuLerG5QUlY3O6DNG8pSG1ITjzHEqrz8/UbqcVzlXGD3qx
         AsXQOivBm+mgOmZI/sZBAs/KnYZdw333pIjjK4IaU4iYhG3o0uhK8VVGr1hHbKNUwwk7
         MVVvlhY+paSuk/+zpPPYYacHzYVq4faik+HQDGny6clS3EkIEvsRb8/fWGgcaBLKbo9Z
         9wVPeiXQsf/Lk2e2l9/lB7S4wEr/BQzgWZ6KSzPW18OUxg9ZwloBXGdtXLSainr/DKld
         u2B+ox1LZw8HqYW47BtUQNaaBT7wjNuLU+53+Jufy6REqDOzAlOT+eIY1blpKWrXR2fH
         GBGw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1708942424; x=1709547224;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=mYxWqQyihqZ/xKRwoD0QjakwL6RSMHUw8t/Bhqm9gTk=;
        b=MjrdnLa3oQQUe46OBj/wFTbHT3JEQ6gyic/HaLEUrLypMlbuWcqWvdUkxFMPsK60de
         uHaEJS6UrClCVEQWWheHVNNBUBLCaRRx7pau0M89b+LeBJN2KTjC5gPkK2h5tr/N72A7
         3Hencypj02FHCvGWsn6RuHDteasPuOtivWdlmDwdu53fVEQooCfI9hrCSqhvDpoB6Io/
         4wsZyldG7C0ssHm27l5G69eBIPujhpSVfuBqto77v4wyBlhqANOOhjzuO3TAX6tJxGWa
         awU5ggIYZGcjnSPYoKQt1jBw6DX4NFWLI8jSu/K+E2qMHPIZebfX/HNsdU1WdwzYPVki
         BdOw==
X-Forwarded-Encrypted: i=1; AJvYcCUGN/ziXySAHQu4HXr40Mu4cKLMSttfKu+qv4V78KxEJMDTA2cC7u484JPNIKcsUVrjVjPzCkobXkFLkckusP2QS38n
X-Gm-Message-State: AOJu0YxqPRtGdtVb6kkcxW2Gp/pisiTDcVfqt3m6t3udITt5Cyq+c0gC
	BLC1XVRACz8i7GF7Dx9j6Xml7tbPK5cE5XzqT9iKXUeO0KudXK+v
X-Google-Smtp-Source: AGHT+IF+aElZ5vCFE85E+S1Tlkgpap6+INIPVdRCZ/aeWMo6oorSbE8xMpmhMtAwtEdFoYVKCrmUlg==
X-Received: by 2002:aa7:8a54:0:b0:6e1:3dd3:3c89 with SMTP id n20-20020aa78a54000000b006e13dd33c89mr5073901pfa.11.1708942423783;
        Mon, 26 Feb 2024 02:13:43 -0800 (PST)
Received: from wheely.local0.net (220-235-194-103.tpgi.com.au. [220.235.194.103])
        by smtp.gmail.com with ESMTPSA id x24-20020aa784d8000000b006e463414493sm3626693pfn.105.2024.02.26.02.13.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 26 Feb 2024 02:13:43 -0800 (PST)
From: Nicholas Piggin <npiggin@gmail.com>
To: Thomas Huth <thuth@redhat.com>
Cc: Nicholas Piggin <npiggin@gmail.com>,
	Laurent Vivier <lvivier@redhat.com>,
	Andrew Jones <andrew.jones@linux.dev>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Joel Stanley <joel@jms.id.au>,
	linuxppc-dev@lists.ozlabs.org,
	kvm@vger.kernel.org
Subject: [kvm-unit-tests PATCH 17/32] arch-run: Fix handling multiple exit status messages
Date: Mon, 26 Feb 2024 20:12:03 +1000
Message-ID: <20240226101218.1472843-18-npiggin@gmail.com>
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

In SMP tests, it's possible for multiple CPUs to print an exit
message if they abort concurrently, confusing the harness:

  EXIT: STATUS=127

  EXIT: STATUS=127
  scripts/arch-run.bash: line 85: [: too many arguments
  scripts/arch-run.bash: line 93: return: too many arguments

lib/arch code should probably serialise this to prevent it, but
at the moment not all do. So make the parser handle this by
just looking at the first EXIT.

Cc: Paolo Bonzini <pbonzini@redhat.com>
Cc: Thomas Huth <thuth@redhat.com>
Cc: Andrew Jones <andrew.jones@linux.dev>
Cc: kvm@vger.kernel.org
Signed-off-by: Nicholas Piggin <npiggin@gmail.com>
---
 scripts/arch-run.bash | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/scripts/arch-run.bash b/scripts/arch-run.bash
index 5c7e72036..4af670f1c 100644
--- a/scripts/arch-run.bash
+++ b/scripts/arch-run.bash
@@ -79,7 +79,7 @@ run_qemu_status ()
 	exec {stdout}>&-
 
 	if [ $ret -eq 1 ]; then
-		testret=$(grep '^EXIT: ' <<<"$lines" | sed 's/.*STATUS=\([0-9][0-9]*\).*/\1/')
+		testret=$(grep '^EXIT: ' <<<"$lines" | head -n1 | sed 's/.*STATUS=\([0-9][0-9]*\).*/\1/')
 		if [ "$testret" ]; then
 			if [ $testret -eq 1 ]; then
 				ret=0
-- 
2.42.0


