Return-Path: <kvm+bounces-13642-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 83F878997EC
	for <lists+kvm@lfdr.de>; Fri,  5 Apr 2024 10:36:12 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 25479B215CC
	for <lists+kvm@lfdr.de>; Fri,  5 Apr 2024 08:36:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4364D15F30D;
	Fri,  5 Apr 2024 08:36:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="IMvC7oPg"
X-Original-To: kvm@vger.kernel.org
Received: from mail-oi1-f179.google.com (mail-oi1-f179.google.com [209.85.167.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F03CB3DB97
	for <kvm@vger.kernel.org>; Fri,  5 Apr 2024 08:35:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712306160; cv=none; b=HH4idr9Cw5RmejtW6vxP2SfnQrSpNuQB3Iuc5peCNL04U4qj6XY9MQeaUuQXLl7+B1QYDt7tzY4U8LgF+mAAS2PS2lcLcWXVjFKW62p8YCBtihXtWepE3jg21ZQkdspMsTutomyzHr5lmxMGJPOPLmlsURuwu2wHmvM/8Yu3h2U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712306160; c=relaxed/simple;
	bh=eU0P11mNN5RqGm96BEk3+GKar3bwphLove9iyvNuaS4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IhX7elx6rC5N8nc+pQ6vsTY7HwFgQxApE+XULt2V/J+eDcYWJ9TeH362nIHJqc0sal9bCRBxAyovUpjJac6NkdbW/MACMybSEctD5+dftKvvx+1495dXebCxHWI2P2qyoc+plQyZu1ec6fQ1C3qsKNCkjLDtK2EDF82QMEhjQUA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=IMvC7oPg; arc=none smtp.client-ip=209.85.167.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-oi1-f179.google.com with SMTP id 5614622812f47-3c5d9383118so868483b6e.1
        for <kvm@vger.kernel.org>; Fri, 05 Apr 2024 01:35:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1712306158; x=1712910958; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=2wkxgvl2lBcYYrU/QBID/gDLdeRQX9cHSJck6VIsk4M=;
        b=IMvC7oPggUa6X035cBzYLUUa0H2wcd3ssIZnSbHtizLjBuzCWKvBxX76Q1e3Lv08D5
         ZlZySPxxdq9DUaA1D9s0Lr6eNXi/oLdBlLIbvi7evxSSKlvHYkU2HKw2MBii/d/gYP0I
         +NbmLAWeoybZo67UEzi96jEsZ/bDU6sUoGX19hdG75EWaKJWkkkRIJGmDhRcCgOk8m1f
         ekMayWAug6uri+5t5LkdaODUtWFu5RRhCDEumUHerTb4mZAnqRu6pkc8yBsmbJE6zWc0
         jJ1v1h1SoGnT9CELgTWysKpbb/3MyHS8VnPNF2nCAnB4s7fJs3JEE+AXFj2W8nh/O5KG
         kiCw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1712306158; x=1712910958;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=2wkxgvl2lBcYYrU/QBID/gDLdeRQX9cHSJck6VIsk4M=;
        b=hlyk4TxkwNo6soFKk7opbglYdxNkDRfdcVju60MKQB/5gpQUcDnTKaMhmuNJqD5crU
         wL1x/8FPzeC9HYAHV2VSqsYH0HLaYhRSfXWRM8W5pytpxA+kLaDtzGfr8lALSyr0DIvD
         V+UOaowQztd/yBS4AY4Azm3Nl/jFGRBPxX0ZHHoPiIRU7wl4TRTVAmVepecdQmO67uc5
         BML1/3m1HZc4AahsjN/AzijvU3DChb1Cg+xccLQNAQ7ulgx00r0zEscMU8VNDU4xCrgJ
         SnqyEifDh7CGGDn7UtfumDrySQJJ2wNBNWZ8OQ0mqVpDwMNSroty/dszwN0ThC0eJHI6
         NB4A==
X-Forwarded-Encrypted: i=1; AJvYcCWCpG6iCQpjK/BYCbpNcPufNRBpm/5v4qHKnhIPuLr2IdlNCPsnSVUk6Mi7t29a2eKQynltVw13ZJrRANHgEjsfbBW/
X-Gm-Message-State: AOJu0YzlY0L7SQ/idVKTnBFXdtpwj9WCCcDNsqa23qIYzFF9/gwFUI9L
	l8GYKc7rllq6YGFH5aimb0UcRsQHOriVe1JnAN6SLlkRRf+Ij7qQ
X-Google-Smtp-Source: AGHT+IHeF5xwGRwVs7WDSnDlg791YkyJ/sdhiRw2D0J1EmpmyvkwrLKfq91/UNQJENVPB3rqo3jBgA==
X-Received: by 2002:a05:6358:5b17:b0:183:bdbb:3ad4 with SMTP id h23-20020a0563585b1700b00183bdbb3ad4mr885549rwf.2.1712306157795;
        Fri, 05 Apr 2024 01:35:57 -0700 (PDT)
Received: from wheely.local0.net (124-169-104-130.tpgi.com.au. [124.169.104.130])
        by smtp.gmail.com with ESMTPSA id y7-20020a63de47000000b005e838b99c96sm808638pgi.80.2024.04.05.01.35.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 05 Apr 2024 01:35:57 -0700 (PDT)
From: Nicholas Piggin <npiggin@gmail.com>
To: Thomas Huth <thuth@redhat.com>
Cc: Nicholas Piggin <npiggin@gmail.com>,
	Laurent Vivier <lvivier@redhat.com>,
	Andrew Jones <andrew.jones@linux.dev>,
	Paolo Bonzini <pbonzini@redhat.com>,
	linuxppc-dev@lists.ozlabs.org,
	kvm@vger.kernel.org
Subject: [kvm-unit-tests PATCH v8 02/35] arch-run: Keep infifo open
Date: Fri,  5 Apr 2024 18:35:03 +1000
Message-ID: <20240405083539.374995-3-npiggin@gmail.com>
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

The infifo fifo that is used to send characters to QEMU console is
only able to receive one character before the cat process exits.
Supporting interactions between test and harness involving multiple
characters requires the fifo to remain open.

The infifo is removed by the exit handler like other files and fifos
so it does not have to be removed explicitly.

With this we can let the cat out of the subshell, simplifying the
input pipeline.

Reviewed-by: Thomas Huth <thuth@redhat.com>
Signed-off-by: Nicholas Piggin <npiggin@gmail.com>
---
 scripts/arch-run.bash | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/scripts/arch-run.bash b/scripts/arch-run.bash
index e34d784c0..39419d4e2 100644
--- a/scripts/arch-run.bash
+++ b/scripts/arch-run.bash
@@ -158,6 +158,11 @@ run_migration ()
 	mkfifo ${src_outfifo}
 	mkfifo ${dst_outfifo}
 
+	# Holding both ends of the input fifo open prevents opens from
+	# blocking and readers getting EOF when a writer closes it.
+	mkfifo ${dst_infifo}
+	exec {dst_infifo_fd}<>${dst_infifo}
+
 	eval "$migcmdline" \
 		-chardev socket,id=mon,path=${src_qmp},server=on,wait=off \
 		-mon chardev=mon,mode=control > ${src_outfifo} &
@@ -191,14 +196,10 @@ run_migration ()
 
 do_migration ()
 {
-	# We have to use cat to open the named FIFO, because named FIFO's,
-	# unlike pipes, will block on open() until the other end is also
-	# opened, and that totally breaks QEMU...
-	mkfifo ${dst_infifo}
 	eval "$migcmdline" \
 		-chardev socket,id=mon,path=${dst_qmp},server=on,wait=off \
 		-mon chardev=mon,mode=control -incoming unix:${dst_incoming} \
-		< <(cat ${dst_infifo}) > ${dst_outfifo} &
+		< ${dst_infifo} > ${dst_outfifo} &
 	incoming_pid=$!
 	cat ${dst_outfifo} | tee ${dst_out} | filter_quiet_msgs &
 
@@ -245,7 +246,6 @@ do_migration ()
 
 	# keypress to dst so getchar completes and test continues
 	echo > ${dst_infifo}
-	rm ${dst_infifo}
 
 	# Wait for the incoming socket being removed, ready for next destination
 	while [ -S ${dst_incoming} ] ; do sleep 0.1 ; done
-- 
2.43.0


