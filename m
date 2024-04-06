Return-Path: <kvm+bounces-13795-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id D805A89AAB8
	for <lists+kvm@lfdr.de>; Sat,  6 Apr 2024 14:25:24 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 4B1151F21AB3
	for <lists+kvm@lfdr.de>; Sat,  6 Apr 2024 12:25:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8443E2E645;
	Sat,  6 Apr 2024 12:25:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="hM4B1TxU"
X-Original-To: kvm@vger.kernel.org
Received: from mail-ot1-f50.google.com (mail-ot1-f50.google.com [209.85.210.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5089F1EB48;
	Sat,  6 Apr 2024 12:25:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712406316; cv=none; b=EA/8j8iHGpH+7LvygnGRj93LpQgXBZ04lrn1NnWm3LFwg+YV/AAATDH08UwYoNX3z2QAiSCLZFYM6Ce/0vq4ZpUAcwU8/mLXl77li26HB9Kf0osYoWA8fJGFsF9pc+y0x1wAhCSTcBmPGXzZ/dzcha2sMn5G/J3o5w0K7VkXSxo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712406316; c=relaxed/simple;
	bh=Q+eBoy/MFKQuds7bZTpcG4/XovpckV3SPTeBQ3aXuYA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Y1/Muzhd3PuH0aZSUuSVEfzX0KT6q+zwRVDv07RHivcW4E+omS8rTlK8/IvNM/KjKN1pbqSMLwH7jgDpZw1QV76o/ZYN8neEpQHfa9lyZ5oJj7JdJrAhQiBpF42HPQV+LIdJspVSAatQB+KjAuXvp1gF8cNhiKR4J1CU7On0SGA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=hM4B1TxU; arc=none smtp.client-ip=209.85.210.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ot1-f50.google.com with SMTP id 46e09a7af769-6e9f3cff7bdso1442756a34.1;
        Sat, 06 Apr 2024 05:25:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1712406314; x=1713011114; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=GtrgcjAXxyl9IcRCUQpzTPmKOZ9sQrlIWm2leuvIbQ4=;
        b=hM4B1TxUyHuM2rywu+Nwy9ozakhe1p/BmPxsK9FTzOhOU/7G7mJBELflGD8K3KTAUE
         4smyPmvnkgTiKXeuTA/g4X4j8psF1JuWeCAMNqaEciSkh/Rcp3Ho37wojbH1aYs93gve
         kJtaMbJrI/djjUv5bca9RITsssHKn84ec5YyjrQfuyUbT2fgF9y3N9pyVoZqv33CHvEH
         iiZ539xxJbvjiwvXTHKGNoPE8saIixizR/VdeqIMqnYQTWX4X3TQ/vDgYARJOLRpNO11
         6n3GNKnNpsxFaTS4x6aJKpb68JEpKI+Q+CsuRI4LxyBQHofhUkLIblS+bSLpmBeacWWO
         M6QQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1712406314; x=1713011114;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=GtrgcjAXxyl9IcRCUQpzTPmKOZ9sQrlIWm2leuvIbQ4=;
        b=ueFq6Rrz+GrmJDp6DHvPpCbGB3h/hNox2gq5LZHA2J8gDD3r0uyeZpn5y3EADw5rgp
         JqBuhqLFs5TZN1bh3Fufr4rh90Smeuf9p3DVzeDJV4Upvh3DfJ0nX2+8sanfpvhesa2J
         OsKPWhc3Zt6157POi15sf/5Q3cW+Fk+yHdHZ6iToJhOvk2QSvlBn9sPFXqsMJfZEXyt+
         z/4MJPKaKb7RB50p6AabsbGSXhOIvRKMiqrpqEe9UlIzCZ+z6FA08iH5br15FnMFlrSR
         A5eZgJ41uyrXQIBYp4ItgWHw1bLe7gx9YFRraki8iYScXrjUE8/aU3ECYq05d7hqXv/x
         3zYQ==
X-Forwarded-Encrypted: i=1; AJvYcCXGG/eOTaPL3sW6nv04bQ49nLG4tI+K7X2SJaUi5DGBDa+K4MGRqZah521vJpW/x2jv3es24i1m9qcND7NywkwG2qFpIoLuo1nlWjnPrHkfEzOPneeqVCSKkzwYUNcgWw==
X-Gm-Message-State: AOJu0YwCYbY+CMLJkbkSmvFR+TWJgIrVBE6Xq5uQoMpwoNmfJfYjqO9o
	ATlXaWggi2p/eM308+b1BBHBW1i4SbWTle98em64H3+tL6a+QWRP
X-Google-Smtp-Source: AGHT+IHE7+2OFtft9EyXmh1fPnN0myNepRSS8xrjXZnuY+TaYVaeFGrzs6ySqC69HvlgodJ9XcXorw==
X-Received: by 2002:a05:6870:4724:b0:22e:df68:ebcf with SMTP id b36-20020a056870472400b0022edf68ebcfmr3838890oaq.56.1712406314211;
        Sat, 06 Apr 2024 05:25:14 -0700 (PDT)
Received: from wheely.local0.net (124-169-104-130.tpgi.com.au. [124.169.104.130])
        by smtp.gmail.com with ESMTPSA id g14-20020aa7874e000000b006e69a142458sm3091392pfo.213.2024.04.06.05.25.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 06 Apr 2024 05:25:13 -0700 (PDT)
From: Nicholas Piggin <npiggin@gmail.com>
To: Thomas Huth <thuth@redhat.com>
Cc: Nicholas Piggin <npiggin@gmail.com>,
	Janosch Frank <frankja@linux.ibm.com>,
	Claudio Imbrenda <imbrenda@linux.ibm.com>,
	=?UTF-8?q?Nico=20B=C3=B6hr?= <nrb@linux.ibm.com>,
	David Hildenbrand <david@redhat.com>,
	Andrew Jones <andrew.jones@linux.dev>,
	linux-s390@vger.kernel.org,
	kvm@vger.kernel.org
Subject: [kvm-unit-tests PATCH 1/2] s390x: Fix misspelt variable name in func.bash
Date: Sat,  6 Apr 2024 22:24:53 +1000
Message-ID: <20240406122456.405139-2-npiggin@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240406122456.405139-1-npiggin@gmail.com>
References: <20240406122456.405139-1-npiggin@gmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The if statement is intended to run non-migration tests with PV on KVM.
With the misspelling, they are run on KVM or TCG.

Reported-by: shellcheck SC2153
Reviewed-by: Andrew Jones <andrew.jones@linux.dev>
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


