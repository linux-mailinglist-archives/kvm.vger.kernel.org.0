Return-Path: <kvm+bounces-13681-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 7828B8998C6
	for <lists+kvm@lfdr.de>; Fri,  5 Apr 2024 11:02:10 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 11C6F1F24B8D
	for <lists+kvm@lfdr.de>; Fri,  5 Apr 2024 09:02:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 14A2215FD0D;
	Fri,  5 Apr 2024 09:01:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="UL3Pl01I"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f169.google.com (mail-pf1-f169.google.com [209.85.210.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E095915F338;
	Fri,  5 Apr 2024 09:01:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712307703; cv=none; b=JiCoqCj9x5GQylgiTkj/HYnQe9UrJ/nvP5I5qxnOcDdRq9zgLPzVHNP2c35bhEvln4ZjohlBZQ9eTDoITiuYQFxXVvWWt5IVjejDvCRfaQfna5MmHZMiUjSGOoY/2n3ezWtMObuoYFBTsWOMo/U6wxmzc/VRrClYpu+SKHZN63k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712307703; c=relaxed/simple;
	bh=506MTEjbVPXF8Zt3kJ2sS8cgtechUEV91w1R5KBhWo0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hnsVyehVWm71/iZ1Pjht/DrvV73OLtuxTzGchBSJwVn9CBYM3/uOPWjZWgvmgtJVS148DlugAP94Mz1r4+ZK5eswMbKZsmJQpd9t6usePVcxN7xC68OVfH0CdUPcyqxNmzBQ0ikao8aB/jIHj1NnAFiJf0tLMmXGoI/jMgjSPm0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=UL3Pl01I; arc=none smtp.client-ip=209.85.210.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pf1-f169.google.com with SMTP id d2e1a72fcca58-6eaf1a3e917so1667842b3a.2;
        Fri, 05 Apr 2024 02:01:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1712307701; x=1712912501; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=jWkgTiRHnk4W4aXSUXKYIpIrbIJtMcwldZh7NhaIyxs=;
        b=UL3Pl01IdWLplxzLv7vcwFfTyMHiJvqQx3U8ZDyeHDfhYfzobqYyZp3Se/Q8NCzXdv
         q/B37o6SmvPaHdN8U9Fwj0QCCy9qA7JtYmw/az+3q02wDFBFUWVpFX7cfNsXUppRsCwN
         6FGs77T0RHPGMk3iI+gXLG3wlfL/n6Z/hm0GbMQdeRjkUWWZ8OnbeVwg3+Q+ApvrYEFQ
         Ow9PaIMKRiEWUx8OpWM2RSrdCcYzMAW8vtLYnxG9CP1JiiMjAWskeyMc40sSzYyfhsBv
         NnLh3RC/AdMqL/uFNiMhSeM641oZ1z8ay5bqKEdwGMAPRYQx/LDCc4jH2gepT6yyjOdx
         j2HQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1712307701; x=1712912501;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=jWkgTiRHnk4W4aXSUXKYIpIrbIJtMcwldZh7NhaIyxs=;
        b=QYzeeffcnBAf1lgE7a1cFB3/VLjz4zIS1nRp+a7wl5TXgfoB1L/puXYfbVbnPZUkGP
         E2ap3323gYjfmLwl6mu1kc4qpuM/vHcS9nzCve0v0PrDfu5c5WfL5goZyAm5llHvOYCA
         RmyuANht8QI1eTlKCPs8PqtG89sbC3G8hoFTpuwb03qevFbNM0v/lMkUXHyNeeHlODg4
         eOPaM2XgcvRGsk2dfQSntF4SGcuaxaRd68mIz8SgR3KgH7f81+9uL64CpEP8HYzFPXnR
         FVbuVUgb6+5cslEeHFYZqsVwXl79+UHa/AjthhmE30kEVdzovlMmoZpO6LpTHjJ5fK8e
         gcuA==
X-Forwarded-Encrypted: i=1; AJvYcCVYQhWkLYlcfs3Mt5oZEABu5AWUkExCeBi6UE1U3nZqqqaJ4NCR48MD6mteBV8L4wsMIFjxvuUWpqryJp0Vwj7xhNlHJ/vAW/xkxljNYKPNxg+9DTSYgpAHbFQ5i1q4YA==
X-Gm-Message-State: AOJu0YzkARmZ7HADPsifiG8ASDNiPLObv4sifDuhsCnQeBbpqG7ZgQ8+
	qVF+biFSRddRPVpPSLtzY0Jjgwl1q9voRWD8mCiDgDNYcFGJ/lTG
X-Google-Smtp-Source: AGHT+IFKRylcUQSeLpH891qpaLSwfOXby/ZCFByKbFqJhH6RagTfsZsaWuVIt0y3x2KTtKSKRijqgw==
X-Received: by 2002:a05:6a20:5603:b0:1a3:69e9:2fc4 with SMTP id ir3-20020a056a20560300b001a369e92fc4mr759512pzc.22.1712307701154;
        Fri, 05 Apr 2024 02:01:41 -0700 (PDT)
Received: from wheely.local0.net (124-169-104-130.tpgi.com.au. [124.169.104.130])
        by smtp.gmail.com with ESMTPSA id s12-20020a62e70c000000b006ecf25d0b8dsm995783pfh.184.2024.04.05.02.01.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 05 Apr 2024 02:01:40 -0700 (PDT)
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
Subject: [kvm-unit-tests RFC PATCH 04/17] shellcheck: Fix SC2094
Date: Fri,  5 Apr 2024 19:00:36 +1000
Message-ID: <20240405090052.375599-5-npiggin@gmail.com>
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

  SC2094 (info): Make sure not to read and write the same file in the same
  pipeline.

This is not as clearly bad as overwriting an input file with >, but
could appended characters possibly be read in from the input
redirection?

Signed-off-by: Nicholas Piggin <npiggin@gmail.com>
---
 scripts/arch-run.bash | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/scripts/arch-run.bash b/scripts/arch-run.bash
index 1901a929f..472c31b08 100644
--- a/scripts/arch-run.bash
+++ b/scripts/arch-run.bash
@@ -492,6 +492,8 @@ env_file ()
 
 env_errata ()
 {
+	local new_env
+
 	if [ "$ACCEL" = "tcg" ]; then
 		export "ERRATA_FORCE=y"
 	elif [ "$ERRATATXT" ] && [ ! -f "$ERRATATXT" ]; then
@@ -500,7 +502,8 @@ env_errata ()
 	elif [ "$ERRATATXT" ]; then
 		env_generate_errata
 	fi
-	sort <(env | grep '^ERRATA_') <(grep '^ERRATA_' $KVM_UNIT_TESTS_ENV) | uniq -u >>$KVM_UNIT_TESTS_ENV
+	new_env=$(sort <(env | grep '^ERRATA_') <(grep '^ERRATA_' $KVM_UNIT_TESTS_ENV) | uniq -u)
+	echo "$new_env" >>$KVM_UNIT_TESTS_ENV
 }
 
 env_generate_errata ()
-- 
2.43.0


