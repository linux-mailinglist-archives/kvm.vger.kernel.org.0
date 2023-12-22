Return-Path: <kvm+bounces-5151-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 3291E81CAF1
	for <lists+kvm@lfdr.de>; Fri, 22 Dec 2023 14:51:42 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id DF7D82877CE
	for <lists+kvm@lfdr.de>; Fri, 22 Dec 2023 13:51:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CBAC819BD3;
	Fri, 22 Dec 2023 13:51:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="f/CNdh2Z"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f53.google.com (mail-pj1-f53.google.com [209.85.216.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DB2651A70A;
	Fri, 22 Dec 2023 13:51:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pj1-f53.google.com with SMTP id 98e67ed59e1d1-28be8ebcdc1so1265760a91.0;
        Fri, 22 Dec 2023 05:51:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1703253094; x=1703857894; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=csZzn8Tts4GDrY3qLQnkSR7QOMG8LbSslE35UizKPQ4=;
        b=f/CNdh2ZVc3WLff92U/mTywGkaKRYeo0L5jbYgnFz4fmVd1YM53KhigUsS6lIRDaFO
         lPw5VskIoEBO+g5Qb4BC9jqEscDA6k3j2O3p6Zvw48QTtyKGMRPJWvYCgnbEg5aEUiGP
         bQGUrXk9L2qOvQ8SsNQwP+8YEhvq3WRGb7RLT4NhaCOQG0JUBePU50GsdM9GtgRSZiUs
         q4d65hOqHs0coy3yHJEMHAdo9yA+cKYsa6u8lt19M48tk2JEEIRVb6oP3GTOtOGjCLyH
         1fQIf7Uk0dDPfsmIHBtLo3TOQF3yWkLVpofzD0G52bMLq3/kRW8l1v5sj5y3wE89exEz
         EMUQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1703253094; x=1703857894;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=csZzn8Tts4GDrY3qLQnkSR7QOMG8LbSslE35UizKPQ4=;
        b=nDYfTugyVRDdHEarOjp8+x2M9cpemkCW/NS2GHgkJZybB58YGqikx23MkrJE+BSDk2
         zK/I9BdKlgwrVRu2mXmly1Cj10xPj2z6snR8tbgaLHmUeX+va51PopUlbErMFL5hc+lS
         GKAyikcNSd+hwfxjhW7XSiwuDylVLfEIcLs1rm0Y/f7JJq9eD1wWHyviHk57Cz8OCUfw
         5LSDYq04HurGzbNQ4Slx1Y3ZcliPrmNHGHDrjC6T12VghK2nHOww+BGst+J0Bxe6Hcnp
         Oc9AgJwbDljWKaiRXV42EsLZgv04eBNu52e57SYpfrvuTRMjiXhejJR7EmjK6SiqFm7G
         cGsQ==
X-Gm-Message-State: AOJu0YxQOdWRtPnY1/wZungpW7WiB9Yqv+irwcHQP4sLp/uaRLeg2+vC
	We2S+rNdiCimJWNE+KXoJgI=
X-Google-Smtp-Source: AGHT+IE6JiPXZ1JzgMGiiikrcjbc4fNoco/0elFrP5j2RkHuY2dRuJka6YReTK90dppqCxw0PpOIIA==
X-Received: by 2002:a17:90b:33c5:b0:28c:d84:f77e with SMTP id lk5-20020a17090b33c500b0028c0d84f77emr440214pjb.21.1703253094258;
        Fri, 22 Dec 2023 05:51:34 -0800 (PST)
Received: from wheely.local0.net ([203.220.145.68])
        by smtp.gmail.com with ESMTPSA id n12-20020a17090ac68c00b0028ae54d988esm3629280pjt.48.2023.12.22.05.51.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 22 Dec 2023 05:51:33 -0800 (PST)
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
	linuxppc-dev@lists.ozlabs.org,
	linux-s390@vger.kernel.org,
	kvmarm@lists.linux.dev
Subject: [kvm-unit-tests PATCH 4/9] migration: use a more robust way to wait for background job
Date: Fri, 22 Dec 2023 23:50:43 +1000
Message-ID: <20231222135048.1924672-5-npiggin@gmail.com>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231222135048.1924672-1-npiggin@gmail.com>
References: <20231222135048.1924672-1-npiggin@gmail.com>
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


