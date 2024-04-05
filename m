Return-Path: <kvm+bounces-13690-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 593358998E4
	for <lists+kvm@lfdr.de>; Fri,  5 Apr 2024 11:04:19 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 0ED44281A46
	for <lists+kvm@lfdr.de>; Fri,  5 Apr 2024 09:04:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 98993160862;
	Fri,  5 Apr 2024 09:03:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="JvC8/iv5"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f173.google.com (mail-pf1-f173.google.com [209.85.210.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7BFE91607AC;
	Fri,  5 Apr 2024 09:03:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712307781; cv=none; b=DBi9vJjzxPDrnFPgfo8dlC/PjM2ZbcBQZkHj9lGQIO3UotGEWSlLikK41DRr3yepiMZWaKAayvmwc+amJ/AA+NnHdAPYJBNdhP8zFuKr+cnapVSrDML3yEwFKmpWSNeJ5OVHF683mgVTVFqp8vL4sr2zaQB2xaRPKdiolEE7eek=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712307781; c=relaxed/simple;
	bh=EAtbJa1uGcSNumSfbYbK82PzgPPN/6qFy0k8JsSEh2o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bzwu9RdY/Dwn0KBoh4jI2TabmgOv+K561ka1eYVzEqXf6XfgTPW6pIbmtXrt6D1r0jkpQaYJUZ6z6+F1CkaeW41gUzVooPL5YtZ9HAi4irskDnlmRLFLNDODIfP8Bw3evUKwAyt5GaT0HG7XidzEwmhiz4Wu4T7RhacWeHcE0XU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=JvC8/iv5; arc=none smtp.client-ip=209.85.210.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pf1-f173.google.com with SMTP id d2e1a72fcca58-6ed04c91c46so64875b3a.0;
        Fri, 05 Apr 2024 02:03:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1712307780; x=1712912580; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=gmkt4qhFZhSEnd+pxfVPyRti/r9TlYGWMJpmXepb5wo=;
        b=JvC8/iv5lYSL5c6P6jIPFfDER13h2xLmJfvgO+0OaNfTFWQzaAqptvMkfxga4OqrIJ
         G98tx+mCTMhA3uyLqnTmRdVhHkIftqDD5YwasSs52HY9oD4Z5WJW3KCuujNFEMAcGqPZ
         iPTNR4ZTOfDUoHVj86P3RS4j6Hz17wY3xhMOzCzzaSATNhZiLZPBfV1AVeloLVPDjwP9
         gxm4vfhr5L4jssEpFrwkGPbSgrho4ZJGugCyzxcxjwPseDvvEzVjQ1ZYlyyFWFQLoEAA
         jwOxga71N4TmvFUMOJN/8w1vWLISu79xUpLw/WI/SCDOF9t0tekYAaQJsOiO0YLiPuTq
         ya+A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1712307780; x=1712912580;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=gmkt4qhFZhSEnd+pxfVPyRti/r9TlYGWMJpmXepb5wo=;
        b=DQaNY27tbZ+F2m8jyRaiomZExoczDMe6m4X+LGkMAGBCwaAIAJtCM1YKLX4dExoiqp
         drogAMK+lUK/X+S7bobEmcuuPyeXknEugYrIFBZKZxQIHdZyA7ZqITKaShGsvkI/WMA9
         cGKOhsQl43d6SDq+59RzoOzN/nUVoH3CUjxki0Q+V0+HizMeg/bAzAiqowu5p2NG7dri
         ES8cVHXB7d2Zb9xHoLFzhP1cVBVtV/aAwtEhueLeXVfOlDeIm1YIHT9hE7YOOvkC5ZBS
         Dr6n1hvwJpow4hD5ECCtfEdKDZj0d+IoYaKf8coC773O2O8VXm/qA2lpFr/1NzyOYe0w
         cA2Q==
X-Forwarded-Encrypted: i=1; AJvYcCW6HRsiaL8bj3yHBTJkBQRK7Qetmu7j9tGokPtKygMEwSWXcGCiEJ+9+Kj/0klx9jcmq6mOO3PZcBYOJ5WCa/X17HEOofsxRCTSk4YA7AqjkKRe7yN17lyBMLqfvWrPrA==
X-Gm-Message-State: AOJu0YxdIEiFMzPY0vo/Uz8FQRPds4GINPl4OcsZF4nylXIBxgBdwj+9
	y/8FG74o9Eyw9Skp5w1OA2qFfMZODZw4kKxUEwu3SSyYryUqQYuR
X-Google-Smtp-Source: AGHT+IGL+jM7I5Xj0jEMVbIu9IEgKgrsozrrThogKrmDVWc//cKRXd3PlSR8uLhql0Pf8HhB7qsklg==
X-Received: by 2002:a05:6a00:98d:b0:6ea:d114:5ea1 with SMTP id u13-20020a056a00098d00b006ead1145ea1mr964542pfg.17.1712307779850;
        Fri, 05 Apr 2024 02:02:59 -0700 (PDT)
Received: from wheely.local0.net (124-169-104-130.tpgi.com.au. [124.169.104.130])
        by smtp.gmail.com with ESMTPSA id s12-20020a62e70c000000b006ecf25d0b8dsm995783pfh.184.2024.04.05.02.02.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 05 Apr 2024 02:02:59 -0700 (PDT)
From: Nicholas Piggin <npiggin@gmail.com>
To: Andrew Jones <andrew.jones@linux.dev>
Cc: Nicholas Piggin <npiggin@gmail.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Thomas Huth <thuth@redhat.com>,
	Alexandru Elisei <alexandru.elisei@arm.com>,
	Eric Auger <eric.auger@redhat.com>,
	Janosch Frank <frankja@linux.ibm.com>,
	Claudio Imbrenda <imbrenda@linux.ibm.com>,
	=?UTF-8?q?Nico=20B=C3=B6hr?= <nrb@linux.ibm.com>,
	David Hildenbrand <david@redhat.com>,
	Shaoqin Huang <shahuang@redhat.com>,
	Nikos Nikoleris <nikos.nikoleris@arm.com>,
	Nadav Amit <namit@vmware.com>,
	David Woodhouse <dwmw@amazon.co.uk>,
	Ricardo Koller <ricarkol@google.com>,
	rminmin <renmm6@chinaunicom.cn>,
	Gavin Shan <gshan@redhat.com>,
	Nina Schoetterl-Glausch <nsg@linux.ibm.com>,
	Sean Christopherson <seanjc@google.com>,
	kvm@vger.kernel.org,
	kvmarm@lists.linux.dev,
	kvm-riscv@lists.infradead.org,
	linux-s390@vger.kernel.org
Subject: [kvm-unit-tests RFC PATCH 13/17] shellcheck: Fix SC2294
Date: Fri,  5 Apr 2024 19:00:45 +1000
Message-ID: <20240405090052.375599-14-npiggin@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240405090052.375599-1-npiggin@gmail.com>
References: <20240405090052.375599-1-npiggin@gmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

  SC2294 (warning): eval negates the benefit of arrays. Drop eval to
  preserve whitespace/symbols (or eval as string).

No bug identified.

Signed-off-by: Nicholas Piggin <npiggin@gmail.com>
---
 scripts/arch-run.bash | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/scripts/arch-run.bash b/scripts/arch-run.bash
index 89a496014..ed440b4aa 100644
--- a/scripts/arch-run.bash
+++ b/scripts/arch-run.bash
@@ -179,7 +179,7 @@ run_migration ()
 	exec {src_infifo_fd}<>${src_infifo}
 	exec {dst_infifo_fd}<>${dst_infifo}
 
-	eval "${migcmdline[@]}" \
+	"${migcmdline[@]}" \
 		-chardev socket,id=mon,path=${src_qmp},server=on,wait=off \
 		-mon chardev=mon,mode=control \
 		< ${src_infifo} > ${src_outfifo} &
@@ -219,7 +219,7 @@ run_migration ()
 
 do_migration ()
 {
-	eval "${migcmdline[@]}" \
+	"${migcmdline[@]}" \
 		-chardev socket,id=mon,path=${dst_qmp},server=on,wait=off \
 		-mon chardev=mon,mode=control -incoming unix:${dst_incoming} \
 		< ${dst_infifo} > ${dst_outfifo} &
@@ -357,7 +357,7 @@ run_panic ()
 	qmp=$(mktemp -u -t panic-qmp.XXXXXXXXXX)
 
 	# start VM stopped so we don't miss any events
-	eval "$@" -chardev socket,id=mon,path=${qmp},server=on,wait=off \
+	"$@" -chardev socket,id=mon,path=${qmp},server=on,wait=off \
 		-mon chardev=mon,mode=control -S &
 
 	panic_event_count=$(qmp_events ${qmp} | jq -c 'select(.event == "GUEST_PANICKED")' | wc -l)
-- 
2.43.0


