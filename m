Return-Path: <kvm+bounces-7818-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id D709B8468DA
	for <lists+kvm@lfdr.de>; Fri,  2 Feb 2024 08:02:44 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id F1FCD1C2263F
	for <lists+kvm@lfdr.de>; Fri,  2 Feb 2024 07:02:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 12F4018029;
	Fri,  2 Feb 2024 06:58:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="V8hFuEHF"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f169.google.com (mail-pl1-f169.google.com [209.85.214.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E18AD18030;
	Fri,  2 Feb 2024 06:58:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706857117; cv=none; b=HsJaJMfvKyshfpdJGDZvvOPjqPNC84mGj0jP/qbD6sIR64/rFWk6Dh5sIH0I40BcztENU+GpNOHUfajTS9f9J6N5hK7twGevR9pBfgb5nSHpN1+cuV830+pKK1Ep+Y12nXxN6qZ2cuL6D6xOvN5pXOyHGZHZiETpAtHivcRV+w8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706857117; c=relaxed/simple;
	bh=vZ3YMwX66EaqbN2ORZOVXLG/sa0Qdj2N0D2ckqa3J3g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Eif5tzWxlcZ4S3rmmXS94PElaBH6U1ftAmb2KCoHV7z9cx0I11Q6sUAYZV+FkeaSxRVnCci8LS8im4C2pQBbprk8atUfXhUzNXntYHNTaCoJq3Cufz7efdg7gqUIbh6cSv32yWEbFbJ/Z8tTQgsTO8vrN8vJPCiXvPzAV9GNHc0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=V8hFuEHF; arc=none smtp.client-ip=209.85.214.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pl1-f169.google.com with SMTP id d9443c01a7336-1d780a392fdso14972805ad.3;
        Thu, 01 Feb 2024 22:58:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1706857115; x=1707461915; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=csZzn8Tts4GDrY3qLQnkSR7QOMG8LbSslE35UizKPQ4=;
        b=V8hFuEHFAA38bYgjXPmLOFeiEbL2Ig3B4OFIf9tCdW2oJ41LnyvFsPHRwEaKvO8w2b
         Wzzas+cweOMFaAYV1Hw8grPX1K7yv5oZV5e8F6rzgbuYbRDvscNSo1u11lkDOJoSJCZ/
         2gVvDwjvf3vIP7kOncGLOWNO0VxrShYmZ+BOtBvegaQ7p/0duI/gpQvzXlk2cztNErGM
         WA5TFiVgEifQK3NMgdWrqh/Q5VBUbBgbxJIjdj7nQJiZNoQouXLenRs6UTxlVUtrTcuM
         TodtvlDgsjPGQC+8tKFOiHLjoiZy/mwJuV/2DH/ry25NINLYqcLqLWX2yQrkzhTEwHaL
         d1NQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1706857115; x=1707461915;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=csZzn8Tts4GDrY3qLQnkSR7QOMG8LbSslE35UizKPQ4=;
        b=FjVzduLI5re0NTaFQh7xsPzpXwfmBeNxzphZc9SrxSMpfTLQHuA5gfNLYhsb+DdpZN
         OsDFysNo5b5ui2nJvmZN7FeE6VvsKX4T3aPY0CfT/TF1pIJzY6HTZ3e7qoZYDLRaOJ1Y
         2z+syFUIOvQjBcXdPxSFAjj6TOo/ILFVEWhFkYSHnlmhiF4NtHAW5BRqcQqjLOlpvW+w
         nFggFC5WqOj8a8W4/S4wwIDBu86xOCHEnIhSMJc0CMeo1UJCPxpt1Rvaf2InRmfTR3ug
         cC0MZ0V0W94C61zf0hzENPN6tnA4iweNxnsS/4cINhEUKsU1p+kMg0MmOBIxf0XfABqG
         DbQA==
X-Gm-Message-State: AOJu0YyfMDADwMi0WRkwO2DUUS23SCSwEUrZq8Gyepq5uCikdZVnt50S
	Ox3Hw/hP3xXYzu8YoBcylGYh1TQkeOl2eQ10l5rRZDuJj6018fuE
X-Google-Smtp-Source: AGHT+IHQJovP9cuDfLX1LEk4K/alkVzLIkRzxJY+QcE5oL7Dd9yHKan4WRASlSMcGCHpHROzl2ZLRQ==
X-Received: by 2002:a17:902:784a:b0:1d7:67ed:f359 with SMTP id e10-20020a170902784a00b001d767edf359mr4716325pln.4.1706857115153;
        Thu, 01 Feb 2024 22:58:35 -0800 (PST)
X-Forwarded-Encrypted: i=0; AJvYcCVSwo2DhWJztWTa9U1WjnG2OEHk75aqypz9EENMaN9rCVjm2aNTvzqOjqreNJITShoHo9T7x+ko5qmg+0mV1bnB2ksDTXi9h0E+gKzF0gwzaPU7sZRfQKEE5GBwSp3vXM5daMc87iFTEbp+kKmWIGcoKllxbyyc7GHbbHP2MYk2R6FbS5cCICb3jeBoC95PLl3gQXdpeY3YdDjwN4gufC5UMsFyXUoMhxStsJ7LBtInri13Lv8ml/nw6NMfYwKBWGeEJ8tZYTOh8QEzFmsxwtypjQFDMaYc+rxpO3wB6cftW99sR9jBOzuqUTKG+KBI89qEH5I6L5LJLboUVYgjQm0h4CApMhlBMlEHF30OUwc1tiunLj3s1xlRislLrnE6gQk4nxX+bgKMbXi7ZyK+VprLwbV1fjrSnPLI+OjdwQoV5pGegIY6Uq6Z/3Mb2gELJE4vKhs+PHAA27nlDncGqIpzsXgCDW3i017CdB2wccIpLULEqbD1ub59rwYxNwXZYWe6tGz+X72qL8Y=
Received: from wheely.local0.net ([1.146.53.155])
        by smtp.gmail.com with ESMTPSA id d18-20020a170903209200b001d948adc19fsm905734plc.46.2024.02.01.22.58.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 01 Feb 2024 22:58:34 -0800 (PST)
From: Nicholas Piggin <npiggin@gmail.com>
To: Thomas Huth <thuth@redhat.com>
Cc: Nicholas Piggin <npiggin@gmail.com>,
	kvm@vger.kernel.org,
	Laurent Vivier <lvivier@redhat.com>,
	"Shaoqin Huang" <shahuang@redhat.com>,
	Andrew Jones <andrew.jones@linux.dev>,
	Nico Boehr <nrb@linux.ibm.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Alexandru Elisei <alexandru.elisei@arm.com>,
	Eric Auger <eric.auger@redhat.com>,
	Janosch Frank <frankja@linux.ibm.com>,
	Claudio Imbrenda <imbrenda@linux.ibm.com>,
	David Hildenbrand <david@redhat.com>,
	Marc Hartmayer <mhartmay@linux.ibm.com>,
	linuxppc-dev@lists.ozlabs.org,
	linux-s390@vger.kernel.org,
	kvmarm@lists.linux.dev
Subject: [kvm-unit-tests PATCH v2 4/9] migration: use a more robust way to wait for background job
Date: Fri,  2 Feb 2024 16:57:35 +1000
Message-ID: <20240202065740.68643-5-npiggin@gmail.com>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20240202065740.68643-1-npiggin@gmail.com>
References: <20240202065740.68643-1-npiggin@gmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Starting a pipeline of jobs in the background does not seem to have
a simple way to reliably find the pid of a particular process in the
pipeline (because not all processes are started when the shell
continues to execute).

The way PID of QEMU is derived can result in a failure waiting on a
PID that is not running. This is easier to hit with subsequent
multiple-migration support. Changing this to use $! by swapping the
pipeline for a fifo is more robust.

Signed-off-by: Nicholas Piggin <npiggin@gmail.com>
---
 scripts/arch-run.bash | 12 +++++++++---
 1 file changed, 9 insertions(+), 3 deletions(-)

diff --git a/scripts/arch-run.bash b/scripts/arch-run.bash
index cc7da7c5..8fbfc50c 100644
--- a/scripts/arch-run.bash
+++ b/scripts/arch-run.bash
@@ -131,6 +131,7 @@ run_migration ()
 
 	migsock=$(mktemp -u -t mig-helper-socket.XXXXXXXXXX)
 	migout1=$(mktemp -t mig-helper-stdout1.XXXXXXXXXX)
+	migout_fifo1=$(mktemp -u -t mig-helper-fifo-stdout1.XXXXXXXXXX)
 	qmp1=$(mktemp -u -t mig-helper-qmp1.XXXXXXXXXX)
 	qmp2=$(mktemp -u -t mig-helper-qmp2.XXXXXXXXXX)
 	fifo=$(mktemp -u -t mig-helper-fifo.XXXXXXXXXX)
@@ -143,8 +144,9 @@ run_migration ()
 	qmpout2=/dev/null
 
 	eval "$@" -chardev socket,id=mon1,path=${qmp1},server=on,wait=off \
-		-mon chardev=mon1,mode=control | tee ${migout1} &
-	live_pid=`jobs -l %+ | grep "eval" | awk '{print$2}'`
+		-mon chardev=mon1,mode=control > ${migout_fifo1} &
+	live_pid=$!
+	cat ${migout_fifo1} | tee ${migout1} &
 
 	# We have to use cat to open the named FIFO, because named FIFO's, unlike
 	# pipes, will block on open() until the other end is also opened, and that
@@ -152,7 +154,7 @@ run_migration ()
 	mkfifo ${fifo}
 	eval "$@" -chardev socket,id=mon2,path=${qmp2},server=on,wait=off \
 		-mon chardev=mon2,mode=control -incoming unix:${migsock} < <(cat ${fifo}) &
-	incoming_pid=`jobs -l %+ | awk '{print$2}'`
+	incoming_pid=$!
 
 	# The test must prompt the user to migrate, so wait for the "migrate" keyword
 	while ! grep -q -i "Now migrate the VM" < ${migout1} ; do
@@ -166,6 +168,10 @@ run_migration ()
 		sleep 1
 	done
 
+	# Wait until the destination has created the incoming and qmp sockets
+	while ! [ -S ${migsock} ] ; do sleep 0.1 ; done
+	while ! [ -S ${qmp2} ] ; do sleep 0.1 ; done
+
 	qmp ${qmp1} '"migrate", "arguments": { "uri": "unix:'${migsock}'" }' > ${qmpout1}
 
 	# Wait for the migration to complete
-- 
2.42.0


