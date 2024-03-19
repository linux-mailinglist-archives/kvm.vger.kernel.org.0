Return-Path: <kvm+bounces-12078-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 610F087F89E
	for <lists+kvm@lfdr.de>; Tue, 19 Mar 2024 08:59:58 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 112E11F21A70
	for <lists+kvm@lfdr.de>; Tue, 19 Mar 2024 07:59:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5FC68537E4;
	Tue, 19 Mar 2024 07:59:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="bxkKsj52"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f180.google.com (mail-pf1-f180.google.com [209.85.210.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3BC501E536
	for <kvm@vger.kernel.org>; Tue, 19 Mar 2024 07:59:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710835184; cv=none; b=q/IqBcmPS3DSxKes+AcdxJseSr28G5k1O5VLS+3PbpyOYO37ZQrnbske16WdyzbWrMQ3pSLgECuCxXwWzvHtgVMkMaUgFrk352Q8BBcdGyNEQJnUZTkS61zmylSB5zhPSj1a3TeRSEn6w7BnEfxWYb4dweqffk8aqM7JdlN7XvM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710835184; c=relaxed/simple;
	bh=ZgOcK5cD8kLAqBUEPjtFMxI6gSSG9wYMLdUeIcNG/PA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=p7nfjNPtRhFSwPNIFOPV04mn+WtqoP1EOYCY0ZcPCN4RH56HH4xitZCO682Mu/c9UTe3t0px8DwsH6T74z2BGT2aCXxst+RwLMV+VY/nhGOTTD4rEZ/zqkj9TvREu7NyEFUJvgzgGf/1hr4yxoaGSZbF1Ny8aYQ9ZVU7Bu0QilY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=bxkKsj52; arc=none smtp.client-ip=209.85.210.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pf1-f180.google.com with SMTP id d2e1a72fcca58-6e6b6e000a4so3798043b3a.0
        for <kvm@vger.kernel.org>; Tue, 19 Mar 2024 00:59:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1710835182; x=1711439982; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=7znwqTVB8+8L1jJIfaQ7a8vMZg63pFuyoiAqB5ObgC4=;
        b=bxkKsj52Ir1AvaSwUZMNmU6M0Aav2dCjBx0ICOrK/HqpKVrcohAjfDBv8nuf+MCc/g
         5TCSZ4EPSS25YdWBc55z5T4LVzUTutGNtxO375S18wM0aEHWp8cLDsRQvEEAi/DccPcb
         ixItfjrMDPD2VODCwLL7MarJPrWRWhugg+R0yABASIKdKWWJStWHI4X1hV79xYy7hl8S
         3gZm9YBzTntdHWMKqD9TrnMrRN3Ep3Y81I9L7GDWu9zvWUZoTPv8WyOpeHggonwhUjLx
         xJWGjHTd6ON0OA7+PWUK5MQ4LQU6NFV55Wp+x4nTFnWVC+dXjVQD5QBowZI34NCH3xZ4
         NRqg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1710835182; x=1711439982;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=7znwqTVB8+8L1jJIfaQ7a8vMZg63pFuyoiAqB5ObgC4=;
        b=KuIdMKCh/1G6qUAz7Xe9r/UZDIRCT2ng+t2jLq9Cp3r8/6oORYGrMGJBh3hwUzQ4IO
         PwS82abtYGPYRqYiVx+teyLTCtFleOx+zxw3sZhpOeud8Qt5m4o1rcuUaGPup2Xtv9ov
         6xd2dWnV7wi+qq8y6sn/HLSOaoYE7s4zBayos2Q4PjTEg9slZ+HWIB77DaEiKEsdMCcW
         ILcjDMa02R+9OJLYB7x8IrVwqWNIdENHQ24Ar9hJUzqIgBiOxou+Yun8HcxsrwVVv7R/
         IO2MniFzCtJboQ7Atu/iWTR6agFdZvTaDNgwFNQtFvGk1BScn1rrpxDQeSM4Q24vPQ/4
         /lhQ==
X-Forwarded-Encrypted: i=1; AJvYcCU28jjrxIWhz14g32rGFJ4t9TDAg8w/kpgavrKKEtA0XlSwIs2bhmMD5oIdnjRhLIlTBXaQ4NBSdzpQqYvyrHAxqbVR
X-Gm-Message-State: AOJu0YzZklzgudOhJ9rEYTFkSMI4SM3d3jyH92Hkz6BPRj5uV3IvlGej
	AOKfZWIIvG8fbru/fukxqZ/Y+b+LjUrnY5H/PO+bTEv80jwkj7WM
X-Google-Smtp-Source: AGHT+IE4j+Tvbeu58NluMV0rzs1CQ2K9gXa/2zH3LKie41jBP9/lGyR0R3vWNoE8F5Vdq7v8pF2U6Q==
X-Received: by 2002:a05:6a21:3115:b0:1a3:647b:b892 with SMTP id yz21-20020a056a21311500b001a3647bb892mr2682650pzb.15.1710835182535;
        Tue, 19 Mar 2024 00:59:42 -0700 (PDT)
Received: from wheely.local0.net (193-116-208-39.tpgi.com.au. [193.116.208.39])
        by smtp.gmail.com with ESMTPSA id q23-20020a62ae17000000b006e5c464c0a9sm9121283pff.23.2024.03.19.00.59.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 19 Mar 2024 00:59:42 -0700 (PDT)
From: Nicholas Piggin <npiggin@gmail.com>
To: Thomas Huth <thuth@redhat.com>
Cc: Nicholas Piggin <npiggin@gmail.com>,
	Laurent Vivier <lvivier@redhat.com>,
	Andrew Jones <andrew.jones@linux.dev>,
	Paolo Bonzini <pbonzini@redhat.com>,
	linuxppc-dev@lists.ozlabs.org,
	kvm@vger.kernel.org
Subject: [kvm-unit-tests PATCH v7 02/35] arch-run: Keep infifo open
Date: Tue, 19 Mar 2024 17:58:53 +1000
Message-ID: <20240319075926.2422707-3-npiggin@gmail.com>
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
2.42.0


