Return-Path: <kvm+bounces-13804-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 100F689AADB
	for <lists+kvm@lfdr.de>; Sat,  6 Apr 2024 14:40:01 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id C1DE9282152
	for <lists+kvm@lfdr.de>; Sat,  6 Apr 2024 12:39:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AD1512E83C;
	Sat,  6 Apr 2024 12:39:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="El25NFkq"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f178.google.com (mail-pf1-f178.google.com [209.85.210.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9A9B12869B;
	Sat,  6 Apr 2024 12:39:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712407195; cv=none; b=DJbFLBdYgA9V7mFMrJx3BIY7NoxcqyspXRBbIUWRJK9xEH4eaEqSfSPcvC3siIEJ9o4GsS9eTV7/duypYmEA+eHyEmRke1a4Ocj1Bpx3uCP6ft1dTjMWJ0nwzgUsxQ7u7K9A77SZJbjJSjCLj7ZnVY0V23jipYGmJrck5vyJQJQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712407195; c=relaxed/simple;
	bh=67jvvc1FuFkl4RrldOCyNHxO0KEc+8WgPwVH/pFMsu4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jnsRLr6vOaY4U5sG6sDdmsLdY0PPqtWQV9wuerON10ww7SJEtpmjl6UDgrDObepf8nlDDnN6lZOPyka2PAZY7zYyy4zQA91xbc5c5pGAPMh8tuAipWeyR98uEKoisMRcOYkZzEbzWLmgkY+HQ2w1dJi0AFuIMFxHw5OvoWUTARg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=El25NFkq; arc=none smtp.client-ip=209.85.210.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pf1-f178.google.com with SMTP id d2e1a72fcca58-6ea9a60f7f5so2625080b3a.3;
        Sat, 06 Apr 2024 05:39:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1712407194; x=1713011994; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=8Amd09WCoNGafmrfuk2tT2hw4+gKyq5hmdDwUgtaokg=;
        b=El25NFkqx2wAK4Asz7Y6yS1et/w/43SBRdWMN1GgvbSIY8Wr5o0w9GX2J0T2hx38di
         2H0cfpXr6trHBtzTerrYmjAtjHMHVfEdN45BDajqDrYVoYEIClLdMNXqua4CXFHYI8Gv
         4ctk8FCFsuZf1eXgxBJOSdTQ7iTLocLR+XAFL9ezhKrKZah/in6QOPmOcpk+NF0Mm/eR
         jIn7tDmoqAikQZ2igdasmyN12lrZcDICgprF/nYR3kNb9gXDaLvT3gF28tFrLf0qMIOs
         NvewHlEB31STaE2Fe+ojrj7cdKxrIiKy208RwGt37qGoj5lXSuvNJ8b1AOzqEUlDLbk7
         BUvQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1712407194; x=1713011994;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=8Amd09WCoNGafmrfuk2tT2hw4+gKyq5hmdDwUgtaokg=;
        b=nTp8xMW29Itxthxzo29C0cLp70qhR17zDdpr4VLYre7KndDdLrLOjoj3ziQ3tuxbG/
         0NXN13gte9Nk5oYta7bCtHB9YcX8Gq0pNXVp+z6BL9U/hN05aEPX2/4FXSauPj1Wqego
         Zkw/AqGeuTTcT05YMrZxU+roebBoF6a3UAb5SAfDvH56unSTwNxyHSF20d4J76KT4G0f
         c67OHDoJvjfmO6iWbiKyfvE8KXBvVr1+b2/wIQaGKxwh7Ii3OT0tJ3j5zakTXU+wb98k
         Qd0EFYnJY1JiKuDgHbQW/mmOpnHo+H05//zGYzqCANT8Jli2ic/0W/nqgqHjNLaDe2rI
         LvbQ==
X-Forwarded-Encrypted: i=1; AJvYcCXinZf1MIDB3raMitaIY5yOC9ah+Qm35UHIaIIdghs7yCjuYDqE5Cfzuht9LdNg91FupcyqFe0VdwvwNxXNUc23v4/rWc66GY5DvvGa4U9WFeLH2shndqkQrFYldHjhmQ==
X-Gm-Message-State: AOJu0YzeOTvzIX8F9PTGWnij+DNjGHMP4HiubERub8AVx1OSQjul6KUC
	kTMdm/P9vs2vOdAcg0yy8kJsvDq8/fe2O5Oev8EGhLVTgl9kwf5V
X-Google-Smtp-Source: AGHT+IGZi4czmCZZqDl75or3p6dCfsMOJaFJfy8Q9bSre2VzGKWSZ+VsWeTYQuMIiFbE4hVRMt9PTQ==
X-Received: by 2002:a05:6a20:c90c:b0:1a3:ae18:f1e4 with SMTP id gx12-20020a056a20c90c00b001a3ae18f1e4mr3511345pzb.34.1712407193831;
        Sat, 06 Apr 2024 05:39:53 -0700 (PDT)
Received: from wheely.local0.net (124-169-104-130.tpgi.com.au. [124.169.104.130])
        by smtp.gmail.com with ESMTPSA id nt5-20020a17090b248500b002a279a86e7asm5050576pjb.7.2024.04.06.05.39.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 06 Apr 2024 05:39:53 -0700 (PDT)
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
Subject: [RFC kvm-unit-tests PATCH v2 07/14] shellcheck: Fix SC2143
Date: Sat,  6 Apr 2024 22:38:16 +1000
Message-ID: <20240406123833.406488-8-npiggin@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240406123833.406488-1-npiggin@gmail.com>
References: <20240406123833.406488-1-npiggin@gmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

  SC2143 (style): Use ! grep -q instead of comparing output with
  [ -z .. ].

Not a bug.

Reviewed-by: Andrew Jones <andrew.jones@linux.dev>
Signed-off-by: Nicholas Piggin <npiggin@gmail.com>
---
 scripts/arch-run.bash | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/scripts/arch-run.bash b/scripts/arch-run.bash
index ae4b06679..cd75405c8 100644
--- a/scripts/arch-run.bash
+++ b/scripts/arch-run.bash
@@ -61,7 +61,11 @@ run_qemu ()
 		# Even when ret==1 (unittest success) if we also got stderr
 		# logs, then we assume a QEMU failure. Otherwise we translate
 		# status of 1 to 0 (SUCCESS)
-		if [ -z "$(echo "$errors" | grep -vi warning)" ]; then
+	        if [ "$errors" ]; then
+			if ! grep -qvi warning <<<"$errors" ; then
+				ret=0
+			fi
+		else
 			ret=0
 		fi
 	fi
-- 
2.43.0


