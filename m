Return-Path: <kvm+bounces-8394-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id DEF0384F086
	for <lists+kvm@lfdr.de>; Fri,  9 Feb 2024 08:02:30 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 53E6B1F21FCB
	for <lists+kvm@lfdr.de>; Fri,  9 Feb 2024 07:02:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9BFCB657AE;
	Fri,  9 Feb 2024 07:02:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="OibR6Mkt"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f179.google.com (mail-pl1-f179.google.com [209.85.214.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 709D9651B4;
	Fri,  9 Feb 2024 07:02:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707462142; cv=none; b=eZuvFUcNckXiTumMeZ+x0LbQxWTbD2m3G4R4vVe8LgWOIfJEb3NJ58SH79UBfRY6LXo9ZuQ/0Dhy30tyJ0WN3NcxRN7yK3UsyNC6Qu0Gf/00NtLjzF8wZlwiK8+VoBj6ZJXxFYejhxoNzoLIruBgmmubOwib3F8pntUZmYWKwao=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707462142; c=relaxed/simple;
	bh=btWNyJ/RiVRASaF6/39ABlcJIFLw0hx7QpaEdND75ag=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qXWJsDeABUloOHd+2s6NCYKY72ceILWPFKEVKxLtt8o4WJzNyO/+xawbrwTFbC6n1QyRMSUQtSJ/0cyWSqIj+CghDKuFkmyY1YUc0zdjJB1KPrqbheJZU4yTxNO+tGMHq8rBzU7J9+KKpGqbolFeSSzD2k3j44lJVSXES2QTAY8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=OibR6Mkt; arc=none smtp.client-ip=209.85.214.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pl1-f179.google.com with SMTP id d9443c01a7336-1d9bd8fa49eso5053325ad.1;
        Thu, 08 Feb 2024 23:02:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1707462141; x=1708066941; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=vH3i7c2rdDusoO9l0oYKXVEfYgOTk0BIl82whiOKoAA=;
        b=OibR6Mkt6HG1SeURSNAdtABpRMttQRcSqYZ87je2RpJMzgrkrnUAVBq8w8xEbIGBaX
         l4+GoEIyXwpw6etXG0ESQxyTIwdFlXJ6WKZUipIGgn578Dke6a/YizVfFOkb4kBPpEYX
         UCGEg15MROER+N0i4rwJ19oPzfQheGc8zVsKDIrduPoaR8Le+A80oXMiodtVnow17VrX
         rcDdzQPMzhzFugeKUsjYN99yrP4uE6Dfqf+D+D/lORc/5n6CjXCrU39ulGqRUeutYBTw
         aMZhCQreGYFshs+sd8G0nIAOkbFlqkAUz9GX9/ZQy0HjpAnwkEmxkuCcXvsRNsiTySzd
         Foxw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1707462141; x=1708066941;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=vH3i7c2rdDusoO9l0oYKXVEfYgOTk0BIl82whiOKoAA=;
        b=Miyuk7xsq2CdBuuGNQEBvG3F8YR9swHk6prCiUUEwzn8Y7n4kXCbmXGV7QfxYokhLg
         SUB+8IY7OEEKgOzJReGzaiIeOhYrlWRc33smVqmWwhEU2kcOYuHSX2KWDOgSLNq0ghy9
         f6UAwPT5y/OeGVu3YlO8eQhTE9Oqt6y5U7JeZg1OK7kOPiNJV66UpUf21P2gMVKHEuhG
         8G81Q7rhPmOEz4KuAt/pxovZScFC3PR78J94CU7vjBcLrSGvYPDXu8KUsk9LICgnbrNZ
         QF3l5rNXRUTb7HGsoz6hOhcshjohEO6utq9W2opNctTDepUvBvvo8YtNhHMo2xGlaB2n
         7yGA==
X-Forwarded-Encrypted: i=1; AJvYcCW2nmzwclteQQ3Kk//A7R+obNFwBTJYgmNeDrnKw6MBI/f/u5Ul1tJhGPtdcPLalkhXolXvReFUUvFZ/RpZu6DwMIUYV7pfcJL85lqzurVwtfLQTThWHznxUNgCgJuyRA==
X-Gm-Message-State: AOJu0YzyoyLyp1+nixZ/RUdsn08IEIckpnLebX9XD2kl4/FHiu4ouAuq
	G/4Ntz9KTPZglYhgZlJibCWkZ3e7D5o+B+OUg1/1c5iYPqKMZhL8
X-Google-Smtp-Source: AGHT+IFpcSgXgc2Pcdk1s+DGllDRanvp4qFa/hQemAtrKxUbxZjddPhfIOf9iXD5cVWfbfVbrQ/D5w==
X-Received: by 2002:a17:903:18e:b0:1d9:d300:a670 with SMTP id z14-20020a170903018e00b001d9d300a670mr877486plg.15.1707462140710;
        Thu, 08 Feb 2024 23:02:20 -0800 (PST)
X-Forwarded-Encrypted: i=1; AJvYcCWL7Y2HotGSsYV2teE21T1pi//Ty5QF4kXvFsWSIafNuJsAO3MdpE0xNs70oRHlkPzvlweKPlY/8NnoJ8Rsb8cukQkZw+68Z5QSNfUfNdmODTSgqvFjyszroItLiVTDAdeUhP9LFuIuX+Uju7ap+Lz1EMvexMEjb/B9p2DufbSDyBaJUkktaWqJP9nvgcFqgFg560PLWmmaa23cF6BVopZ1/UmkHIgJFimgDzVO1V7oFGPOVU5ql0AOYjueX9ujRNV4bF12YISbbSmk/s5JGaptqLnfCDz+eCPM31L6Z6qNuLePOq/7LKvdhpz0VQOH0pyizLsTq60z/7V6tTyyIJ9iFcEDCMSN+J823GoIPWzNLvMVtXrv+ua3FVf3eaNryFzlYO6TFJt0ZYrJMrYPX7BCvHnspo+9Pq2LJiNVd8JY3+fKt9h/h+beNkbL1k96JLlFMzGOyPPdfTWHRn88I/eqDVq/JFQkPn+Hll2fiMbqsZ8vDur/NYYW6n3grqy5i9qnk4H1YLx8Dyz+w0oSMAtp43SrwqkEnPDRbrzuPF/nMuSoHqeviQRI
Received: from wheely.local0.net ([1.146.102.26])
        by smtp.gmail.com with ESMTPSA id r10-20020a170903410a00b001d7284b9461sm839285pld.128.2024.02.08.23.02.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 08 Feb 2024 23:02:20 -0800 (PST)
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
	kvmarm@lists.linux.dev,
	kvm-riscv@lists.infradead.org
Subject: [kvm-unit-tests PATCH v3 3/8] migration: use a more robust way to wait for background job
Date: Fri,  9 Feb 2024 17:01:36 +1000
Message-ID: <20240209070141.421569-4-npiggin@gmail.com>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20240209070141.421569-1-npiggin@gmail.com>
References: <20240209070141.421569-1-npiggin@gmail.com>
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
 scripts/arch-run.bash | 15 +++++++++++----
 1 file changed, 11 insertions(+), 4 deletions(-)

diff --git a/scripts/arch-run.bash b/scripts/arch-run.bash
index 1e903e83..3689d7c2 100644
--- a/scripts/arch-run.bash
+++ b/scripts/arch-run.bash
@@ -130,19 +130,22 @@ run_migration ()
 	fi
 
 	trap 'trap - TERM ; kill 0 ; exit 2' INT TERM
-	trap 'rm -f ${migout1} ${migsock} ${qmp1} ${qmp2} ${fifo}' RETURN EXIT
+	trap 'rm -f ${migout1} ${migout_fifo1} ${migsock} ${qmp1} ${qmp2} ${fifo}' RETURN EXIT
 
 	migsock=$(mktemp -u -t mig-helper-socket.XXXXXXXXXX)
 	migout1=$(mktemp -t mig-helper-stdout1.XXXXXXXXXX)
+	migout_fifo1=$(mktemp -u -t mig-helper-fifo-stdout1.XXXXXXXXXX)
 	qmp1=$(mktemp -u -t mig-helper-qmp1.XXXXXXXXXX)
 	qmp2=$(mktemp -u -t mig-helper-qmp2.XXXXXXXXXX)
 	fifo=$(mktemp -u -t mig-helper-fifo.XXXXXXXXXX)
 	qmpout1=/dev/null
 	qmpout2=/dev/null
 
+	mkfifo ${migout_fifo1}
 	eval "$@" -chardev socket,id=mon1,path=${qmp1},server=on,wait=off \
-		-mon chardev=mon1,mode=control | tee ${migout1} &
-	live_pid=`jobs -l %+ | grep "eval" | awk '{print$2}'`
+		-mon chardev=mon1,mode=control > ${migout_fifo1} &
+	live_pid=$!
+	cat ${migout_fifo1} | tee ${migout1} &
 
 	# We have to use cat to open the named FIFO, because named FIFO's, unlike
 	# pipes, will block on open() until the other end is also opened, and that
@@ -150,7 +153,7 @@ run_migration ()
 	mkfifo ${fifo}
 	eval "$@" -chardev socket,id=mon2,path=${qmp2},server=on,wait=off \
 		-mon chardev=mon2,mode=control -incoming unix:${migsock} < <(cat ${fifo}) &
-	incoming_pid=`jobs -l %+ | awk '{print$2}'`
+	incoming_pid=$!
 
 	# The test must prompt the user to migrate, so wait for the "migrate" keyword
 	while ! grep -q -i "Now migrate the VM" < ${migout1} ; do
@@ -164,6 +167,10 @@ run_migration ()
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


