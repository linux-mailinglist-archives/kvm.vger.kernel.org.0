Return-Path: <kvm+bounces-8415-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 505E484F201
	for <lists+kvm@lfdr.de>; Fri,  9 Feb 2024 10:12:08 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id B96EC1F22508
	for <lists+kvm@lfdr.de>; Fri,  9 Feb 2024 09:12:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 285C4664D2;
	Fri,  9 Feb 2024 09:11:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="BwErevDm"
X-Original-To: kvm@vger.kernel.org
Received: from mail-ot1-f41.google.com (mail-ot1-f41.google.com [209.85.210.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D0CC2664D8;
	Fri,  9 Feb 2024 09:11:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707469915; cv=none; b=hib+/HbrLtjUtZ0RizzWtGZib20shVawyJVyu/kTv+6I6ZJRrttWMblPqDLSrOq6ghFW4XdJqFbvLIfPOwV9JImvwjMaB4KE+E7jwiNvi0N0BZwLMVIrt+npNUIgFGxYVHujYrMc7Chpb2CPUmopqjv7WfhdRotypzhEur2Vw+Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707469915; c=relaxed/simple;
	bh=ZAFsihb3M/bAq0syQwiiUvyBvzmIPevskZf5u2erS68=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=M0/X6zbV4dCuGKwRL48qUB8UXO42rAR6Qky3f861R6BJfyXPqlUJTvnVb4iJ68A55uR5AaT8FtOVfbNM9RcXyfUikFTmKi3Ap/DNunGhrN4XwMQ8+Pf25/SeoanHRpQ3nNVxdcNzw3pcqhjCR7487SVqoNI1jOZk2FudgKJOI0g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=BwErevDm; arc=none smtp.client-ip=209.85.210.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ot1-f41.google.com with SMTP id 46e09a7af769-6e2c402a5c2so381563a34.2;
        Fri, 09 Feb 2024 01:11:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1707469913; x=1708074713; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=LxyXAGgGrfeNy34o4rw1jwmZjpNeqct9+4wIMTyRvKI=;
        b=BwErevDmrXANUobgswkyW/90s2LxY123fZQMEwuv6noJekzQe8oz9E0VeaWxakNtWi
         ive+AWxLS0l+7AbzphAX36oGCUnj+kItC8efoSQ19Sj+GbItKJmKL4nk4kog8EzOvvr9
         DpmDfn1WVuiGFWDrWMqOkBUYam7BP+AJaN6qKbpWmBwysrlAxxYcL1z4Ta2jkdzyhgwn
         klsZl99U/zamNxWsc2SkCDS79H67+9LYGxS1H3e8y6xNqiPdjLEbhgDFloVv9dWLP3Lv
         Wf5auZh7N4NxXgnFyac/wgJ6wfa5t2m43a5rNzf/o3USvVQ2gvDzkLgcQ9OLaEA7ode0
         inwg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1707469913; x=1708074713;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=LxyXAGgGrfeNy34o4rw1jwmZjpNeqct9+4wIMTyRvKI=;
        b=m0UuzvcZh/s952uAi52ec8OjWaDb9o543CfODQZaneldA3ojvtUwE4+ZEBTmYpXcw8
         GNBF185FHo5kgNP6OKaQnDCKRftqCJ3vhyenR0Yz2ovNrzVxZQZ84xaLEYjhdN8mxazw
         e1S7UUWSIqiCBzitolKxj2+e4mo+ddso8UUP4chfIzVJOrDUVy70BZOVkJliFn9uGdgB
         9JAkVSu8UkhFoG/JreJSeR0+fYcTdv2bu05tq1v5xRdsz4YInCcXtdlxh4ZJZ2hQebLT
         VGIG3P9kDlwqSuRyV6Rtqh1yyS2sITgHSoDQnhRHh7uu1Zz8ktxIB/8PDllLkOWTGbPG
         wMAA==
X-Forwarded-Encrypted: i=1; AJvYcCVDHjwTFtjH45Dj0bivjzJDuir8h8ScT+EDU+1ufGAP2mziy6cYCzl+MM/FC9BU497QtxEnur8Wu4E/94x+04ZO0+8TFj8BDFfcRPvK0aNT7q02h0V+EMWkpCiLvzVlQA==
X-Gm-Message-State: AOJu0Ywp9PDaRBjYyKxGQACFvbxLVfriccIVYDObAUDWL0zKumoQBUoX
	rOyUzZelj+Mc+mw5cWUkIJMX/iiZMmK5UKP6UN8XIar6HAB2cIBz
X-Google-Smtp-Source: AGHT+IGcmytfLhFPegBL/6SAtwvaTgnR5fQUFdHgJo6Q2wspsRF4btaANrNXmauM6vRXjX9yxL/gWw==
X-Received: by 2002:a9d:7592:0:b0:6e2:b1b8:84c7 with SMTP id s18-20020a9d7592000000b006e2b1b884c7mr748994otk.17.1707469912911;
        Fri, 09 Feb 2024 01:11:52 -0800 (PST)
X-Forwarded-Encrypted: i=1; AJvYcCVKEs+ZzHCXAJAGHH6bSzYysqcGhmXYYuO3J7InQHWbz7ru+8zL9FzYLwO9GhlA0tw/acl/lYs3xPiH65/zsxoAQ+vOunmMdeJHj7fwM/7IYXS11Wbs/M5zRz5EFWAit+rW73a2VQG4xCIgTGUjXY82AdiRPTb/BavJVUTQGbV3aId10/C9+rVjQIpd1Sqv+goLw0U2es5OSA3dWuYu5H7d6q1pn6MwjszvCXwnamaxbAuWZvyYWownmRTeOrIzuI/+ZouL6nKh1dRZNCzbkzenpPqIA0lri7eCfEnpLGUSmDhy4bR7gdHEr2MhHc30t+XM2H24jxoeAD/txqPe/zWL8MvUSl69ZVEGcQKNNJ6fDjyFBPGZD7Q2/0JE/myZwW5iFPDzucesGj3v4iUc6Gk/lIsdO/3DaDrVpOb8Tk4ap7x5eab++yF7e1pnQgSA6kNfYSZA7kvMlw+hGoaFgZYDYEkSxXqNBeh1/zUpugm2h2n6a+WOGKyuzbfTM72zw7egy17LNvoMYibovcDaGQ1CqWgMjcNfN+R1vbsgD9BEUgLLhu9mWmXL
Received: from wheely.local0.net ([118.208.150.76])
        by smtp.gmail.com with ESMTPSA id cb1-20020a056a02070100b005c1ce3c960bsm1101742pgb.50.2024.02.09.01.11.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 09 Feb 2024 01:11:52 -0800 (PST)
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
Subject: [kvm-unit-tests PATCH v4 1/8] arch-run: Fix TRAP handler recursion to remove temporary files properly
Date: Fri,  9 Feb 2024 19:11:27 +1000
Message-ID: <20240209091134.600228-2-npiggin@gmail.com>
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

Migration files were not being removed when the QEMU process is
interrupted (e.g., with ^C). This is becaus the SIGINT propagates to the
bash TRAP handler, which recursively TRAPs due to the 'kill 0' in the
handler. This eventually crashes bash.

This can be observed by interrupting a long-running test program that is
run with MIGRATION=yes, /tmp/mig-helper-* files remain afterwards.

Removing TRAP recursion solves this problem and allows the EXIT handler
to run and clean up the files.

This also moves the trap handler before temp file creation, which closes
the small race between creation trap handler install.

Reviewed-by: Thomas Huth <thuth@redhat.com>
Signed-off-by: Nicholas Piggin <npiggin@gmail.com>
---
 scripts/arch-run.bash | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/scripts/arch-run.bash b/scripts/arch-run.bash
index d0864360..11d47a85 100644
--- a/scripts/arch-run.bash
+++ b/scripts/arch-run.bash
@@ -129,6 +129,9 @@ run_migration ()
 		return 77
 	fi
 
+	trap 'trap - TERM ; kill 0 ; exit 2' INT TERM
+	trap 'rm -f ${migout1} ${migsock} ${qmp1} ${qmp2} ${fifo}' RETURN EXIT
+
 	migsock=$(mktemp -u -t mig-helper-socket.XXXXXXXXXX)
 	migout1=$(mktemp -t mig-helper-stdout1.XXXXXXXXXX)
 	qmp1=$(mktemp -u -t mig-helper-qmp1.XXXXXXXXXX)
@@ -137,9 +140,6 @@ run_migration ()
 	qmpout1=/dev/null
 	qmpout2=/dev/null
 
-	trap 'kill 0; exit 2' INT TERM
-	trap 'rm -f ${migout1} ${migsock} ${qmp1} ${qmp2} ${fifo}' RETURN EXIT
-
 	eval "$@" -chardev socket,id=mon1,path=${qmp1},server=on,wait=off \
 		-mon chardev=mon1,mode=control | tee ${migout1} &
 	live_pid=`jobs -l %+ | grep "eval" | awk '{print$2}'`
@@ -209,11 +209,11 @@ run_panic ()
 		return 77
 	fi
 
-	qmp=$(mktemp -u -t panic-qmp.XXXXXXXXXX)
-
-	trap 'kill 0; exit 2' INT TERM
+	trap 'trap - TERM ; kill 0 ; exit 2' INT TERM
 	trap 'rm -f ${qmp}' RETURN EXIT
 
+	qmp=$(mktemp -u -t panic-qmp.XXXXXXXXXX)
+
 	# start VM stopped so we don't miss any events
 	eval "$@" -chardev socket,id=mon1,path=${qmp},server=on,wait=off \
 		-mon chardev=mon1,mode=control -S &
-- 
2.42.0


