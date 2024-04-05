Return-Path: <kvm+bounces-13649-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 0E4B88997F6
	for <lists+kvm@lfdr.de>; Fri,  5 Apr 2024 10:37:03 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 404A51C21140
	for <lists+kvm@lfdr.de>; Fri,  5 Apr 2024 08:37:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 463DB15FD01;
	Fri,  5 Apr 2024 08:36:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="J6zAiJWk"
X-Original-To: kvm@vger.kernel.org
Received: from mail-oo1-f41.google.com (mail-oo1-f41.google.com [209.85.161.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1C1A5145B09
	for <kvm@vger.kernel.org>; Fri,  5 Apr 2024 08:36:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.161.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712306186; cv=none; b=SVnYZheeccBG4BnqljEcI8aTx3eTQ98dtnOAeY0Ubj9b8BdmboKJoyaCX61c+SLakxVrG/RS4NbSCUkCE5QiRS+xyjyqRbrqSRrOtzor8rnWCG7grb8SRIdu9BO+qNgZdL9NTiSJ2UYB8+8MK52GInZv4EdKFLQJt88qipuFx1Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712306186; c=relaxed/simple;
	bh=E2mpoELH/BQZ6vr38yZBwyTJO7cJdzZIC+Uun/q1mqM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=M36dDO5oWCC0cFOPMoXhr9TxmHmCl4r9R8X31dEa3XOIcm61Q8no1QsIgw5o7efRhjFPD6riofRtOqA+xMI13esBHXFkK12PhhALc46Hc+nHVaJsgLAEHKpv1rt6AnSK/JhJh1qqBJvTjLNnjU/3CjHWy+H+TXZz9hOcSto2OP8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=J6zAiJWk; arc=none smtp.client-ip=209.85.161.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-oo1-f41.google.com with SMTP id 006d021491bc7-5a9ec68784cso484693eaf.2
        for <kvm@vger.kernel.org>; Fri, 05 Apr 2024 01:36:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1712306184; x=1712910984; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ioHEDmNSpPV3CVzPD4uBNP4il61ABDemBeuj9Mpla5o=;
        b=J6zAiJWkFOm14EnJOv3P6ljRyxbzu4Q/x0Fus6OR6WbX5/H5RQpw5crWY2uRV5/341
         wTPDWObvZbkSuSj3YU9+IAbvJdxGsy0li+0PWwgDtXMsMASZA2bTMtDSjj1vKUIdfnH6
         OXQK7pPjYU4TSPcuS5l/yKtFY1kZ174ZsMr/avsCX2Sk3VOVzdo3Ns5A+rhsD31k249d
         NffP4llAHjcqdJuG6IGqDjNP1QydBjN2uB3AE+1jIqoqJD48IoTiGtFnCQquQLRZxff+
         a7ukOMbaAHYu+C2EulTOe5y6sRNSiqNoJUT4Iez3gustQpXeb81fJ2TAZKLauv9w8pY9
         yztA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1712306184; x=1712910984;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ioHEDmNSpPV3CVzPD4uBNP4il61ABDemBeuj9Mpla5o=;
        b=ApebseKVycfkBwTmUxmgeHNH1pCRubz2T/CGzf8kZ8oR+LD/F68GQcJY2f1Z/HVK5D
         vvWLkJnt+OKK95cZii5bDAV7JG+/6tdcfE3BtJW+IH+9GNNG99w+g4/VoGvEx/g4dw4T
         BDrF2TLxcn3SfIva3j9CEEZFfH40/32URmwEni41mk1lYqnFd35iPEGt29QhbRojHmOT
         S739qzjl624VJNEuXR8w+IYf4alRaDifTVKLRoA0Q4ahGA8GB0quKbQHZPYZb0Dwc6+O
         zqt290SripDHT/TCAcXi54XTBJFYyJkNJ22a55MLnfRaGdzBli3WRfssIF0eR855SWrK
         5JxQ==
X-Forwarded-Encrypted: i=1; AJvYcCXTOA8er3dHFkjs3Ccx9+t/dg5BCP1kv7GRYZ4vMxDJcdkmGF88tEi5YJxNQ4DcGVSgGApPV6E863zc2RR3jocbYFYP
X-Gm-Message-State: AOJu0YySZskLO/SuG+XHVA65WBdxokGpi7iptQl48uUaZ5FuUc7h9LAz
	PvHYaGLEkBFJEcXFsZGDg3OiCdNZgXTpYIyHflGKeydHmNBKajut
X-Google-Smtp-Source: AGHT+IF/HaACcR4qwBCyzQ99yORab14e4gy1iZuirZT+0brU69P5CDX/Z1F9DVMKNiS9oaMyU2PpYg==
X-Received: by 2002:a05:6358:7a8f:b0:17e:b887:5558 with SMTP id f15-20020a0563587a8f00b0017eb8875558mr1009509rwg.7.1712306184087;
        Fri, 05 Apr 2024 01:36:24 -0700 (PDT)
Received: from wheely.local0.net (124-169-104-130.tpgi.com.au. [124.169.104.130])
        by smtp.gmail.com with ESMTPSA id y7-20020a63de47000000b005e838b99c96sm808638pgi.80.2024.04.05.01.36.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 05 Apr 2024 01:36:23 -0700 (PDT)
From: Nicholas Piggin <npiggin@gmail.com>
To: Thomas Huth <thuth@redhat.com>
Cc: Nicholas Piggin <npiggin@gmail.com>,
	Laurent Vivier <lvivier@redhat.com>,
	Andrew Jones <andrew.jones@linux.dev>,
	Paolo Bonzini <pbonzini@redhat.com>,
	linuxppc-dev@lists.ozlabs.org,
	kvm@vger.kernel.org
Subject: [kvm-unit-tests PATCH v8 09/35] powerpc: Fix stack backtrace termination
Date: Fri,  5 Apr 2024 18:35:10 +1000
Message-ID: <20240405083539.374995-10-npiggin@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240405083539.374995-1-npiggin@gmail.com>
References: <20240405083539.374995-1-npiggin@gmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The backtrace handler terminates when it sees a NULL caller address,
but the powerpc stack setup does not keep such a NULL caller frame
at the start of the stack.

This happens to work on pseries because the memory at 0 is mapped and
it contains 0 at the location of the return address pointer if it
were a stack frame. But this is fragile, and does not work with powernv
where address 0 contains firmware instructions.

Use the existing dummy frame on stack as the NULL caller, and create a
new frame on stack for the entry code.

Signed-off-by: Nicholas Piggin <npiggin@gmail.com>
---
 powerpc/cstart64.S | 15 +++++++++++++++
 1 file changed, 15 insertions(+)

diff --git a/powerpc/cstart64.S b/powerpc/cstart64.S
index e18ae9a22..80baabe8f 100644
--- a/powerpc/cstart64.S
+++ b/powerpc/cstart64.S
@@ -46,6 +46,21 @@ start:
 	add	r1, r1, r31
 	add	r2, r2, r31
 
+	/* Zero backpointers in initial stack frame so backtrace() stops */
+	li	r0,0
+	std	r0,0(r1)
+	std	r0,16(r1)
+
+	/*
+	 * Create entry frame of 64-bytes, same as the initial frame. A callee
+	 * may use the caller frame to store LR, and backtrace() termination
+	 * looks for return address == NULL, so the initial stack frame can't
+	 * be used to call C or else it could overwrite the zeroed LR save slot
+	 * and break backtrace termination.  This frame would be unnecessary if
+	 * backtrace looked for a zeroed frame address.
+	 */
+	stdu	r1,-64(r1)
+
 	/* save DTB pointer */
 	std	r3, 56(r1)
 
-- 
2.43.0


