Return-Path: <kvm+bounces-9243-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 3640E85CEB2
	for <lists+kvm@lfdr.de>; Wed, 21 Feb 2024 04:28:39 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 59D0F1C21EEE
	for <lists+kvm@lfdr.de>; Wed, 21 Feb 2024 03:28:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B555534CD5;
	Wed, 21 Feb 2024 03:28:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="C5s2ov7P"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f181.google.com (mail-pl1-f181.google.com [209.85.214.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 89AAF2E3FE;
	Wed, 21 Feb 2024 03:28:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708486110; cv=none; b=nWnNyXfL+WdaoxwUOgT+WaBF/JUIhTDI5Cib35ag20dgkkh6VOznDIYWbg19DL5JBnQUSi5iSxdO6GA5PwlOGQUhoSM7pw8AhEGeokmp7Xu+AAAE2K8kX3ONZS3g1SdJTu4nKiXNG1zLjQeNJ0dEunNa7vaYscezhEDyCZTx2Cw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708486110; c=relaxed/simple;
	bh=2LO805GcRBB/AS3N3iJ/k5e5Yj6b0xPw/uYIJm4sYGk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XfLpGvERwVnWUY/DKjGrAwnhRbdHKaSSjXzHE+bNu3r3rko3Pehroc2jAEJKEyLjhZs/MB+w379LEa0Uged2YfGmjlIMkzfPgaC6cYVF12O6IwUgJ+NNqqhgtmSKhN17C/GJGODgVDkAaIE5dTvegU+1eLCd/AdiEcbfR1WeAQA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=C5s2ov7P; arc=none smtp.client-ip=209.85.214.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pl1-f181.google.com with SMTP id d9443c01a7336-1d944e8f367so50031055ad.0;
        Tue, 20 Feb 2024 19:28:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1708486108; x=1709090908; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=evUoa/UNV/oB4oPRxAOsnBRrgjlX2PtlMy4jxi9Yd70=;
        b=C5s2ov7PAMYdUNvHU5lbaliD5g/y0U/a4PplRNRiSFUZ7dIlvRDzgcwCHKbWaAqI06
         dZwc8GelHqJucMf4JCK1Sirxdo4YTyyBD4Gbs2N98hyuCZOkOqd3ed3ZCQZeCscn2rSr
         ww1kPMEDiHgiamtTDyRoucXxn3gmYmWmh+AgfOM+VFFMpjxotdJozDPEjkAPLRZJEQ6K
         4GSuWdPaMbNaOt0fQGJuYyVtI8R1LMsZyMDnWUOeS0LPLRktchL6dimYRa69fF0T8UM+
         v49gJXJ0Q72uDIAs+h2QusS53WX4r+ijKwSk0cwDu1oLtvSzely9tDc0CQ/imMF9MXX7
         HM5A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1708486108; x=1709090908;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=evUoa/UNV/oB4oPRxAOsnBRrgjlX2PtlMy4jxi9Yd70=;
        b=qZisdxo7azMfy4Z9qpzn7ujTBSmSXYL6F9LDmayB0lqzPvCTDZtbJt4ioAkCOYcicQ
         YPzWStgQqv/+Zpk2DsSs8zBlAvKyKbheJrJ2OvZd05FSISq5TLMGKXNUBIdTIVEZ6RdU
         F+AZhnrLKkMjQFfEg1kZYzX48vKkgC2cArnGqSdgrTD5BaSpS2nICm2d2OQeDrVBBHMs
         N2Xx4tpPVnG1v8w3YVlCsn6s4F+inf7OO5lr97hd1vvfRFfnaQGgdSbJGBshaOBPE3nW
         y6wqYbNfIvOBnqZIRcroqY24+hDpKdZpAUg8X/+/IONLmvp+kYg5F2NcAQhl5lxmslnw
         uJPA==
X-Forwarded-Encrypted: i=1; AJvYcCXbe+ERwLqmCgLHA37e2ApkNdpEt8c9cD4YUS9iPre4w3TYtNbqggg89o747JzImcAwQiITP55o6FvQgJEiLoH9KiOG7k+2PwaCao6+09kTvELohpid19cvXmL4dHabfg==
X-Gm-Message-State: AOJu0YxcljcwO6fR9Z64kt85izu+w1jhEg0DMuiAJINxMsQLmYMBztFW
	mJaIRSbvsqdsnAGi5MM6BTtzRQECIh5ULdEYDdsphB9G0qb/H6sh
X-Google-Smtp-Source: AGHT+IHLUAJXOt//4pQmY07Vj7IwKrIV54Fyb24iOQkYYZFJyUxY99z1JgYADhvTB6IxvrnEmb4LgA==
X-Received: by 2002:a17:902:6806:b0:1db:e7dc:302f with SMTP id h6-20020a170902680600b001dbe7dc302fmr6474108plk.17.1708486107833;
        Tue, 20 Feb 2024 19:28:27 -0800 (PST)
Received: from wheely.local0.net (220-235-194-103.tpgi.com.au. [220.235.194.103])
        by smtp.gmail.com with ESMTPSA id q7-20020a170902b10700b001dc214f7353sm1246457plr.249.2024.02.20.19.28.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 20 Feb 2024 19:28:27 -0800 (PST)
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
Subject: [kvm-unit-tests PATCH v5 1/8] arch-run: Fix TRAP handler recursion to remove temporary files properly
Date: Wed, 21 Feb 2024 13:27:50 +1000
Message-ID: <20240221032757.454524-2-npiggin@gmail.com>
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
index d0864360a..11d47a85c 100644
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


