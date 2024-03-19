Return-Path: <kvm+bounces-12084-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 747FB87F8A5
	for <lists+kvm@lfdr.de>; Tue, 19 Mar 2024 09:00:34 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 2C8D61F21C63
	for <lists+kvm@lfdr.de>; Tue, 19 Mar 2024 08:00:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7B82F54729;
	Tue, 19 Mar 2024 08:00:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="FvfuVBDm"
X-Original-To: kvm@vger.kernel.org
Received: from mail-ot1-f45.google.com (mail-ot1-f45.google.com [209.85.210.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 53471537E5
	for <kvm@vger.kernel.org>; Tue, 19 Mar 2024 08:00:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710835206; cv=none; b=Kf96ZmjFhNcegwr5OihUGSTYO9fCqKVn0WqcQwqRQZQvQVLrYBe4/mEufleruzWzVzW17zd9pqaStl8AbkfyID1k99if0cx/LysuoRVmEmyN0vZkqUZLITCHsgz3iLUH7etuWLjEjP3+gGr7Y9PaDGtIYMmC/TToC37QA+LwiIs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710835206; c=relaxed/simple;
	bh=bNHf9kA6kU6uCSpg/oW5IWy+zb3cEOOp1JXZxF+Jgbo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=g6X5jTDALlFk9mBDbDwbBepG8HhWFE3KE2wahOJY65lLPVlx2WA3dDjO4xPq1QESwn4JHIkS7BnX69QLkyTVKVYifHvP/W1aX4yGsTCukXND5loPOqZEdNm2kdxwIGajO+zh2kHo/FHplm46LGO+TnPHtlrWPSLLbkM/jSEUx8M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=FvfuVBDm; arc=none smtp.client-ip=209.85.210.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ot1-f45.google.com with SMTP id 46e09a7af769-6e695b7391dso780396a34.1
        for <kvm@vger.kernel.org>; Tue, 19 Mar 2024 01:00:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1710835204; x=1711440004; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Een3HCEHuSXtESOmVVoN9fReFwtOgW3Iul9yQ4dmcnU=;
        b=FvfuVBDm4C6kPh/3gqxs36WJ6StoxzU0SG02xjIiDmf7oRvxgdoVO8Qf5Rbxd7oYZK
         54BfUWEzsYranbZQX0t5VbHqM+eYoCDwAwBwj49d4Hrz1Hq+TXRZiIhZWn6p4Jv7SOIG
         EnoWkij3uqW3C9TxNcTN+K2DlHy/LiVu4i2twJp4aC1skiBkX6yfHo4WxNyASEjWPIt1
         ooRvrosdBc1Bozqv9xqEyhJEH+rE51JvHYrQd4qGfo8Sb5Hzekg9JcJkIkFWGi3CtoeY
         quew6pZ4PlelqhALnm+L80XAw486NtFV0G6YpxJ/3ffQQTJuRQjekoXqJgERj+FQNyKv
         GP1g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1710835204; x=1711440004;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Een3HCEHuSXtESOmVVoN9fReFwtOgW3Iul9yQ4dmcnU=;
        b=k9feM7mEMQy65aLMZwAsHmdEoPQKBQDmNIqinCuaYcGN4pvmuiuioLkHeOA/W1C4k5
         AbCh7gEbsE2WQcAgDRmIsS30MGDPuahspzMVQeiduXxoHUZrQGYCRdzV2jSL1KkU9CEN
         P8/3K4ORWZyxvh3rVkfpY376zfbpRT7wB4QMGcL0QZop3iyV5f5LQ8GffFmV7R/QFGjg
         dysQw2xhiwQfpKOTLZxEbCc3L1+9DUhcbOrHjEcm2/lTDJzwpmTbyFqPAHfE6CIM11f4
         NWNJzrdtMRm7+VbiOrDh2dA5zF3oCLbyYcJlnxMekFNbsye5U3r8h/EGAZDSq/iFNKKy
         jUrQ==
X-Forwarded-Encrypted: i=1; AJvYcCVUamIYbLipj1JwVMkQIR6652+vAW/Htg3adOErX1viYfm4GTklCejuISD1mROyVg8UgSlZhjmy7bkL3CVB9UpZ2kg2
X-Gm-Message-State: AOJu0YzNpdXhxcfQdzduYaAfKEw5TGW1P2PBKSFSAAiVJcOQRV0diG9u
	xXFky4vjfiqzQ9NzQRhEHYJJzOK9tE0qvHJPi60w2bW5t4ShwAd7
X-Google-Smtp-Source: AGHT+IE6pXL3TbQuF53EpPTbvzqyaweI3wiT6cAyH+5pKuELD5LZX4DmnMUsiZUZa3mX+J/Y3Z8pRQ==
X-Received: by 2002:a05:6870:b6a6:b0:222:342a:10fd with SMTP id cy38-20020a056870b6a600b00222342a10fdmr17760520oab.5.1710835204416;
        Tue, 19 Mar 2024 01:00:04 -0700 (PDT)
Received: from wheely.local0.net (193-116-208-39.tpgi.com.au. [193.116.208.39])
        by smtp.gmail.com with ESMTPSA id q23-20020a62ae17000000b006e5c464c0a9sm9121283pff.23.2024.03.19.01.00.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 19 Mar 2024 01:00:04 -0700 (PDT)
From: Nicholas Piggin <npiggin@gmail.com>
To: Thomas Huth <thuth@redhat.com>
Cc: Nicholas Piggin <npiggin@gmail.com>,
	Laurent Vivier <lvivier@redhat.com>,
	Andrew Jones <andrew.jones@linux.dev>,
	Paolo Bonzini <pbonzini@redhat.com>,
	linuxppc-dev@lists.ozlabs.org,
	kvm@vger.kernel.org
Subject: [kvm-unit-tests PATCH v7 08/35] powerpc: Fix KVM caps on POWER9 hosts
Date: Tue, 19 Mar 2024 17:58:59 +1000
Message-ID: <20240319075926.2422707-9-npiggin@gmail.com>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20240319075926.2422707-1-npiggin@gmail.com>
References: <20240319075926.2422707-1-npiggin@gmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

KVM does not like to run on POWER9 hosts without cap-ccf-assist=off.

Reviewed-by: Thomas Huth <thuth@redhat.com>
Signed-off-by: Nicholas Piggin <npiggin@gmail.com>
---
 powerpc/run | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/powerpc/run b/powerpc/run
index e469f1eb3..5cdb94194 100755
--- a/powerpc/run
+++ b/powerpc/run
@@ -24,6 +24,8 @@ M+=",accel=$ACCEL$ACCEL_PROPS"
 
 if [[ "$ACCEL" == "tcg" ]] ; then
 	M+=",cap-cfpc=broken,cap-sbbc=broken,cap-ibs=broken,cap-ccf-assist=off"
+elif [[ "$ACCEL" == "kvm" ]] ; then
+	M+=",cap-ccf-assist=off"
 fi
 
 command="$qemu -nodefaults $M -bios $FIRMWARE"
-- 
2.42.0


