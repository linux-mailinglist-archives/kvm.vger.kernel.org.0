Return-Path: <kvm+bounces-8417-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 0FCD084F207
	for <lists+kvm@lfdr.de>; Fri,  9 Feb 2024 10:12:36 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 3470D1C20E71
	for <lists+kvm@lfdr.de>; Fri,  9 Feb 2024 09:12:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4EE1467A16;
	Fri,  9 Feb 2024 09:12:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="d7qP7dF+"
X-Original-To: kvm@vger.kernel.org
Received: from mail-ot1-f49.google.com (mail-ot1-f49.google.com [209.85.210.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 10379679E7;
	Fri,  9 Feb 2024 09:12:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707469929; cv=none; b=BJcBB9oKYh6e84EERdS4z7j6xGqbcrMqEQcHMAXgN6xLjO+rh9VQcY2uU3PPVualM3jUMPSDBrHu/Unyb4yCqsmck8XJVX+H6ZWOsmmfAVTGnipLxyVX+SdqZGwEkAHMJMvmSQsZu9FC7ox1UK3W/9mjA39CyujpZyutXYkb+Pc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707469929; c=relaxed/simple;
	bh=skjZjXlI8C38ruEi2hlhX93rLEO4EIwDk56z9yMwflU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kj4smQTNQL4WHxqB1IzpUQkk9ZHYmx45nRw/TXLGG1XqcC3r4lccLlD9HK0+38SaD32jV9YWH5miSI9kcxTmR+Fbc1n0nyvkkbDKme/nEYPZsUGa8dH7vDGxiNiOSJ3IZ3DET761RetITEjbYVbge9j5r0pGH+/bSSXOI0F1M3s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=d7qP7dF+; arc=none smtp.client-ip=209.85.210.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ot1-f49.google.com with SMTP id 46e09a7af769-6e12f8506ccso323272a34.2;
        Fri, 09 Feb 2024 01:12:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1707469927; x=1708074727; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ueRelljhUpFIYjZZj8MkfM076AFkfPtPKMcEp6Rqelo=;
        b=d7qP7dF+u8IwTOyydCkGZvBDyNNM8SRX5tywoGLxMFb7P6ysAtgLIlC2pi3kbHvQKC
         wyyN+iE3FtCo1uzb3IMyVzflaMkO/eTkpZHIWz3azn9+73nIhwyIA7NlkCsUTtTcUvOT
         MTCIsqLFGHBpWgfWQmNssIdR8WmdHcJLDPdP57LWPicdr9hij5zUEzDM8ZHNZpASdWiq
         1Sht84ybEQK8F6tsKP3TyK3I6FCHpL+a8vAW/NdzCJYRl827ExY4QIy4D9J+rS7pRy6z
         7fn7ggMrciPsdll1N/C5CIX2qnzIAAH19xprb3OaFjQ4vc8M/FJ1vs/OJLAgkSWI+mlW
         n28w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1707469927; x=1708074727;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ueRelljhUpFIYjZZj8MkfM076AFkfPtPKMcEp6Rqelo=;
        b=fOEl0bjxmUEnKO9KCjkfyNk14m2e3tEuRXt1sI2p+0cQbILrnzhWqVP0s4GM/xzAeH
         IQj8yM5p28llvXIWPDyfiA332iXkD/tYKV+VNqPCokX4gl4DSLR/qPKmShCDvQTmy28H
         G7BcogYu57ymSM7H828fDuvJKwF0xl8mDuNLiEmAIU4+x2YKPMUr8xJgGzbuGnNallOm
         fCv2EiVQycak4Z128glUXD84Qr7xngwzG0Wg6vjg6p93yVk+ecKWh/EPPttO2ETBP5QW
         kvPwt315ZpIvUaYLNQJcvGL2QALjXFGi3vVJKvpgUHHzRfwmQxv9OLlbV7h+Ij+va/b/
         wWqw==
X-Forwarded-Encrypted: i=1; AJvYcCVky8Txeg1euH0Qit753h/D2JDFVvXkxX7wU3OMMn+zOxBcEPmbwSNIgf1rawiPACptEuCDnrJXvZmovfIxr57Clfli0YKlIeBzpr6TswOl6RV5reNvixD1NfVib+1TDg==
X-Gm-Message-State: AOJu0Yz+CUi01XeV/0HPOYVRUUMsLOTfercq2o+94qCTs7RUDVsOYm/X
	RzZ1oPK2Ta8VbhwkEi8Io7CuyWVpTZsrQiGEpGlIGB3ekLb8edoA
X-Google-Smtp-Source: AGHT+IG+uF1AVKltLLT/Mxy+BTg+RrPJAlXJIq8b820qvd3G5/GdkhJ+6IWxpDYFMlAC1NwZY+uNog==
X-Received: by 2002:a05:6830:2646:b0:6dc:9cb:bd76 with SMTP id f6-20020a056830264600b006dc09cbbd76mr792620otu.4.1707469927219;
        Fri, 09 Feb 2024 01:12:07 -0800 (PST)
X-Forwarded-Encrypted: i=1; AJvYcCWzWA83VkewDTZfCMZdk6G5YgheMq3t4JNWJCTTx5tmNSX/1gsPYIiH3qmJJq/ijinLpb3xeiH2zs443nSPQUpC0/Em/eeE7RoY4CHLfiXosNuS/3XgeKdOWIC5vELsZJATbQJwpPKfQrAO6jTEODObtJTizbk7H/mPboAdVVqcEZXaUUJ1i35iJVQQ8TdtU37SY4l4vA/HecyN0hGa4ZQftCxlT82HavH0PWHaEow8h9L//3jq2ViO6p3heq9tcsCsGDGWifqycdAeJ+NG+ZZJJKMPQtmF2rgY2/VimIYYSsdsigD8uaLiwOPw7UmRAKWGnWc5vZmpNzTmQfLXihvaHpkTSfTh7yoa65zAimrjVwsQgHs0YjUoUUWuAj9uMmBmpX3UuPk6qu6f5FgJpKJvRVgAcyzBf4Rodf1M7Cd2pAfF5wAiVnR5IDVF6VF4H+eehWMNzS3VqYzuE5TlrklgZg9CX4fK4r7Ikjgvg4oznWMvy/CcF4gKGTZUQi3spCoNRwXFsT1963QqFGp43gEXpqK/iBwlMrv+ntA9/McSpbkv+Y4icgFi
Received: from wheely.local0.net ([118.208.150.76])
        by smtp.gmail.com with ESMTPSA id cb1-20020a056a02070100b005c1ce3c960bsm1101742pgb.50.2024.02.09.01.12.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 09 Feb 2024 01:12:06 -0800 (PST)
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
Subject: [kvm-unit-tests PATCH v4 3/8] migration: use a more robust way to wait for background job
Date: Fri,  9 Feb 2024 19:11:29 +1000
Message-ID: <20240209091134.600228-4-npiggin@gmail.com>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20240209091134.600228-1-npiggin@gmail.com>
References: <20240209091134.600228-1-npiggin@gmail.com>
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

Reviewed-by: Thomas Huth <thuth@redhat.com>
Signed-off-by: Nicholas Piggin <npiggin@gmail.com>
---
 scripts/arch-run.bash | 15 +++++++++++----
 1 file changed, 11 insertions(+), 4 deletions(-)

diff --git a/scripts/arch-run.bash b/scripts/arch-run.bash
index c1dd67ab..9a5aaddc 100644
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


