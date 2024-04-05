Return-Path: <kvm+bounces-13693-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 968278998EB
	for <lists+kvm@lfdr.de>; Fri,  5 Apr 2024 11:04:38 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id C768B1C20FD7
	for <lists+kvm@lfdr.de>; Fri,  5 Apr 2024 09:04:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 566AA15FD04;
	Fri,  5 Apr 2024 09:03:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="FocAB8rP"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f172.google.com (mail-pf1-f172.google.com [209.85.210.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 482A915FCFA;
	Fri,  5 Apr 2024 09:03:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712307810; cv=none; b=ms7jSBVQ9Yl7FxuQymqMsymeb9N32NNOkCLU2PHFbbupLSV6xlfp6x2vW5HKngiZHTY2mi3GA759FrCUW9LwfwjzhFkZHXbd+EBrA0LlGg+vHi3dRvLqtCStV3QRGtwOFTO6rYzIW+ofMqBJekxfwVI2pZpMGHdLo0hQ3eXPPMI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712307810; c=relaxed/simple;
	bh=OSqsyeBYuUgPPx4PzD0nDj2h27raEgPA3BttTW7g4bQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GIn3F6NkcrwyOshdPES88jgYACJ7BhB4zvSlMFPQsgHhBNxI0SIr6P3gTK1yNQKo1+9FM9neUcSdkuqoHf6J8RgYcPCHU/68ON5vEKTNjqNo78k+lzcSFe24V5ZF4BpoAy1EuzbwcDI5Tigwr8GY2zo1xMqlFNv9nHBbK25Ujqo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=FocAB8rP; arc=none smtp.client-ip=209.85.210.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pf1-f172.google.com with SMTP id d2e1a72fcca58-6ed01c63657so224425b3a.2;
        Fri, 05 Apr 2024 02:03:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1712307808; x=1712912608; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=N6QzAi7vCknWCSn8NS2P26SXGhMEhJFXPF1hl6gc7nk=;
        b=FocAB8rP5rEpwbB/W0NR+jRmBewH4nqtgdL04BVhYumwWsNx+p09WA3tPEc9m6riV0
         0z10mbDNPPQ4PdLIFltRDE66Gl+uGRwtzPJr9fY11+NILPBo/m25WTelIKkp7Ikfy5ZI
         e6T27Z5yk4QZqPTEkK1kxtX3CLo3gigGlxbqREWiPGPLs5yRN84Ng9Bv/iQBeEW3UrUP
         QPc6/+NyQ0BvWYF0waE/6Ir1ZdtGPdzKVwb8LLPcU9OyGuqUXBVzRp/UsOqzOJh2V/9h
         /dBeX3M1yob99ToXUOcSH+qaN55BFE7ArGq9VslRfwkLGUrz5vJD6iCv0ikS8O07MBPS
         0jiw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1712307808; x=1712912608;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=N6QzAi7vCknWCSn8NS2P26SXGhMEhJFXPF1hl6gc7nk=;
        b=umE11aO04e+M/m1NGgd6s50Ba9Khq5Z76ZfMa8wdb+uQaYYZ+GLX/1b541Zm7ORcty
         LAWFcIs26TDvlh4UjKAX+pIpWyRZKJp3ryuNt0NZEjoZbLHVv3KJFxm4lnwMHWsugIYp
         BFTsxt68cNeEVVHoX+V1CJRlm0iWML4Iq0/pJOiRxEC41ZTNyTvS1s/iSUI+bOf8L4YO
         ExFwMbo+y/7c5rUpQD5jgsVDxmroWE8QGg2ay8YrK3WPkTAfb+89QaxJlxmvB3Tpg5MW
         04IIaAYfDZdGs4TpvM9rbkCuvh+iqLiSLN2wPBLkHQ/rFYN5oWqlq3fSwNLgbMIlkHBH
         mCNg==
X-Forwarded-Encrypted: i=1; AJvYcCVa6GauFYQEkP1K6zife+ETV0OcXmjjo80Qk4DE7wZwfIc/wJWaeyaRXVdotiyo2w24L9ox1XNSHG4knPrPIR4xwlidAPwzQhpnkc7FEqhdJrLKtNbotFpJiWdTrZnZZg==
X-Gm-Message-State: AOJu0YxQ1SzwbJut4Ovi/c8gHgD72LdaZDFf8PidcWfx8xWs4bA3Z2Zb
	uG9rgDSERvqxHWL6ObkIGLb5UN4b/Wnp22L6AdivF1o0cpB3VU/k
X-Google-Smtp-Source: AGHT+IEIbvzhR4Vb46KhNonnfT+UvilCqW0L9youNLHT1B8fzSApy5lkKFatECJ6OHe0njlNIb7qaA==
X-Received: by 2002:a05:6a00:809:b0:6ea:f392:bce9 with SMTP id m9-20020a056a00080900b006eaf392bce9mr862456pfk.15.1712307808567;
        Fri, 05 Apr 2024 02:03:28 -0700 (PDT)
Received: from wheely.local0.net (124-169-104-130.tpgi.com.au. [124.169.104.130])
        by smtp.gmail.com with ESMTPSA id s12-20020a62e70c000000b006ecf25d0b8dsm995783pfh.184.2024.04.05.02.03.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 05 Apr 2024 02:03:28 -0700 (PDT)
From: Nicholas Piggin <npiggin@gmail.com>
To: Andrew Jones <andrew.jones@linux.dev>
Cc: Nicholas Piggin <npiggin@gmail.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Thomas Huth <thuth@redhat.com>,
	Alexandru Elisei <alexandru.elisei@arm.com>,
	Eric Auger <eric.auger@redhat.com>,
	Janosch Frank <frankja@linux.ibm.com>,
	Claudio Imbrenda <imbrenda@linux.ibm.com>,
	=?UTF-8?q?Nico=20B=C3=B6hr?= <nrb@linux.ibm.com>,
	David Hildenbrand <david@redhat.com>,
	Shaoqin Huang <shahuang@redhat.com>,
	Nikos Nikoleris <nikos.nikoleris@arm.com>,
	Nadav Amit <namit@vmware.com>,
	David Woodhouse <dwmw@amazon.co.uk>,
	Ricardo Koller <ricarkol@google.com>,
	rminmin <renmm6@chinaunicom.cn>,
	Gavin Shan <gshan@redhat.com>,
	Nina Schoetterl-Glausch <nsg@linux.ibm.com>,
	Sean Christopherson <seanjc@google.com>,
	kvm@vger.kernel.org,
	kvmarm@lists.linux.dev,
	kvm-riscv@lists.infradead.org,
	linux-s390@vger.kernel.org
Subject: [kvm-unit-tests RFC PATCH 16/17] shellcheck: Fix SC2153
Date: Fri,  5 Apr 2024 19:00:48 +1000
Message-ID: <20240405090052.375599-17-npiggin@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240405090052.375599-1-npiggin@gmail.com>
References: <20240405090052.375599-1-npiggin@gmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

  SC2153 (info): Possible misspelling: ACCEL may not be assigned. Did
  you mean accel?

Looks like a bug?

Signed-off-by: Nicholas Piggin <npiggin@gmail.com>
---
 scripts/s390x/func.bash | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/scripts/s390x/func.bash b/scripts/s390x/func.bash
index 6c75e89ae..fa47d0191 100644
--- a/scripts/s390x/func.bash
+++ b/scripts/s390x/func.bash
@@ -21,7 +21,7 @@ function arch_cmd_s390x()
 	"$cmd" "$testname" "$groups" "$smp" "$kernel" "$opts" "$arch" "$check" "$accel" "$timeout"
 
 	# run PV test case
-	if [ "$ACCEL" = 'tcg' ] || grep -q "migration" <<< "$groups"; then
+	if [ "$accel" = 'tcg' ] || grep -q "migration" <<< "$groups"; then
 		return
 	fi
 	kernel=${kernel%.elf}.pv.bin
-- 
2.43.0


