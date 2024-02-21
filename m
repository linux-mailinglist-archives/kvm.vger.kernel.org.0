Return-Path: <kvm+bounces-9245-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id D9F4385CEB6
	for <lists+kvm@lfdr.de>; Wed, 21 Feb 2024 04:28:51 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 8F9E528406E
	for <lists+kvm@lfdr.de>; Wed, 21 Feb 2024 03:28:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 06AF638DCC;
	Wed, 21 Feb 2024 03:28:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="AVdInWGg"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f170.google.com (mail-pl1-f170.google.com [209.85.214.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D212823C9;
	Wed, 21 Feb 2024 03:28:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708486124; cv=none; b=H+HvFJ3wfMfJYfEMJBAfHHUYRzkLh82kBmwwxexK7eRKRPR+PDcsyYQCg1G9QcXDmEjgJB6dW2NTkjvR7hgoREAiD1SYR+dAqsIyTqGZpeihAyPciqAfmcgNp+M26EDs7uuVYgOAcOy5zj4X8tyfMy1Wdh7JlPT2jIak9rmDc/0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708486124; c=relaxed/simple;
	bh=zWC/ztnXPY0Ut0zueLckM+4+xHH3S+YXXr6p5gm7W0Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=K6LAHqmVMj/K8mEJTELHuQv8i/OhOLQbXkE3hv4fPk5rgtqJg2eZwISmW8BGhHBHAk43eTKoNci+TDCH6DRe0ht+5CO/HnlZbBuTORQwZ5ixLssfY8FbSqhq1l//IWcSGeciFNsQZPkmaKjysMUusl+DWlM9TPYH5PdWO0VpPpQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=AVdInWGg; arc=none smtp.client-ip=209.85.214.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pl1-f170.google.com with SMTP id d9443c01a7336-1d932f6ccfaso51154665ad.1;
        Tue, 20 Feb 2024 19:28:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1708486122; x=1709090922; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=aML22p2QMiBfalmtqZDWpeCg6Y3ng+Yw7h/JELXYVmQ=;
        b=AVdInWGg0p3SrS3Ei85+5lsSHVLO7vnmpm3ghe0j6Dd4VsmOHnPF2puZse0t7ACEyO
         ijG+OeJ+hDHB3fP0QVkyiUR4QP3WZpGCqKsDD8wyDCoKvg/PUlt27A86q9U0SjZlYWHw
         4pLRnND0EYIOdfHl7rYe2yANmHJDczhCAwI3ZruWnsXhP+gwvLYQbxwXlCVYhWylQ3vP
         bFq/bQLU7N4RSUvBWvKekbpj+ygIg5PuYhZeFZ4oovg7tOGmpGhKGJcH5rroYcsXVgUV
         mjY8JILbTZe9vhXmEThUutM0X7PRF9ctpuplvm6pzDDOhlL02YFBIPdHaSb7f/4L6ona
         RBTA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1708486122; x=1709090922;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=aML22p2QMiBfalmtqZDWpeCg6Y3ng+Yw7h/JELXYVmQ=;
        b=FuRRiPoXiVOOYQCf40WO7H02z95r+HQx4m5EJbDw+JXR93jeB5V1fpTse+numxP+nH
         291MUcvPzsCOEufi38+2FVEiyQ4qkwBGxHVINvEzTS0zTIKKJei9TDwDxWj8tJyaHDzz
         /cXno0tN2rUtbmsUt7oGdfnq5qN2C75ShtnbcJRnCaMGKjH/lQKxHMkkpJ6RoX/d9EKc
         kqMkNsEmKdMRSi+1DDLJVbxDUAeq+b36xc1q0q0VQO/m74ViqMvc6lf3V7zjPYRyNyR8
         ebDGXNOmPsP54cTF29L5HP9FuRj+XkhW2XhWtBxaLxtbnm1JDaMmWMPAIzJpL2Jhowhp
         0YpA==
X-Forwarded-Encrypted: i=1; AJvYcCUdqrtLu+gTrBhckHWZTqcz6I9lNP3ZhaiM5D3s0106gVIfBq3Jut2oZfuyvb6OdBsopogSsakb4ei7VZbhrBqXU7fbZnfBBm4/CUe9EJMod/4w0AGQrMLTeybquLnrjQ==
X-Gm-Message-State: AOJu0YyAD+k74ja3pkNzb2sh6/2P4zXHqt2aGrAfxYRdh09IUNvZIThP
	CpX1Uix+Tz7nF+huoLF31SdvVhnlf+RMdxjMHWBZMsGWyeMNU0de
X-Google-Smtp-Source: AGHT+IHloA4lPV1h3NnRO9wb8wmRssFTGmRoI3MuzFAdRdZDmNqGWg7XAdoSic5qIBVsB6jy4FznyQ==
X-Received: by 2002:a17:902:7001:b0:1da:1e83:b961 with SMTP id y1-20020a170902700100b001da1e83b961mr14195507plk.63.1708486122293;
        Tue, 20 Feb 2024 19:28:42 -0800 (PST)
Received: from wheely.local0.net (220-235-194-103.tpgi.com.au. [220.235.194.103])
        by smtp.gmail.com with ESMTPSA id q7-20020a170902b10700b001dc214f7353sm1246457plr.249.2024.02.20.19.28.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 20 Feb 2024 19:28:42 -0800 (PST)
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
Subject: [kvm-unit-tests PATCH v5 3/8] migration: use a more robust way to wait for background job
Date: Wed, 21 Feb 2024 13:27:52 +1000
Message-ID: <20240221032757.454524-4-npiggin@gmail.com>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20240221032757.454524-1-npiggin@gmail.com>
References: <20240221032757.454524-1-npiggin@gmail.com>
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
index c1dd67abe..9a5aaddcc 100644
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


