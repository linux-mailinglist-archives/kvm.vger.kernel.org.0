Return-Path: <kvm+bounces-13689-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id DFDB88998E2
	for <lists+kvm@lfdr.de>; Fri,  5 Apr 2024 11:04:14 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 7DB63B2277E
	for <lists+kvm@lfdr.de>; Fri,  5 Apr 2024 09:04:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CA2531607B4;
	Fri,  5 Apr 2024 09:02:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="MssTNjr2"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f176.google.com (mail-pf1-f176.google.com [209.85.210.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A0BFA16079A;
	Fri,  5 Apr 2024 09:02:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712307773; cv=none; b=If2JYyRcrji+c5VMC5Eg0r3hQKarxUNO4TpNUacC5N/uZt7qyvhEeA7nrW0M8xvQv+hJtOmx+Gh7PJIR7wqLTc9C89vKUwMpqCEvzm1n/eh4ENOzgU+4JbJnooRBf88LkHU0GPiFo9ugGWXTz3hBMW0iMBN8R/VDjQtFS3ouMSQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712307773; c=relaxed/simple;
	bh=6xB+wIQnOPLKF7pHbmVgFhJt61sfpiZqfgj5DzaM+0w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SF+pQjZ68wV63akNap4huvU4x6TfVuyH81yY6iPViFue17kmkw8h0ZX5sb+q5aJ6ifW0CIi5P0k/eHk+tUc8WEqCwOFFih03PGPHNauEOPEj+6jb/eohFGmQwzcOwri8EhXIzIYmqddRir2slMq9hMtdVvkT1Sx4lJNyyY0rPi0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=MssTNjr2; arc=none smtp.client-ip=209.85.210.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pf1-f176.google.com with SMTP id d2e1a72fcca58-6ecf8ebff50so787926b3a.1;
        Fri, 05 Apr 2024 02:02:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1712307771; x=1712912571; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=irIYlf5WoFbPGWpVJt4Aw1Uvp/IzdQOpW5w6SFgi17E=;
        b=MssTNjr2pA3qZgA6G9/JfVVfCxqhuMHhjUq1uhNYhy40rHpmjhU6kXcdDIoLZM/Z7+
         ZzVDilHyjKswx9FVMEiVFfFMuggvmOWn9SvwTJbdkoWIkr80ZigFQfE1SWg8fLYoMXSL
         DB1M4hu7w0L4+9wuhAP/2TGcj7BxTQG3VxyYzWtqFPv1HyA+/YcbnN84CIb+KbY5MhmP
         65t0bfFBbM/cD1dDSqp7z6wbg7Jk5qHlUlsCztbzpgS1OT17lHwKaPxzaDV5x8icC2Jm
         dkD2+zsJyuH2ege554W6TN/qZR2DhSs56wIUIvSxdhOe7XV/Yry1904S8zfGGONWRw3u
         LArA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1712307771; x=1712912571;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=irIYlf5WoFbPGWpVJt4Aw1Uvp/IzdQOpW5w6SFgi17E=;
        b=PudUPyJB73zfUNnqUyDAadFz/m5KebmASkIG0CA4z8RaM7AGYpBkiDbWh5xhiGt8os
         CgV0dUuBksk7ORkkl4/vbadC1k56fMEj9K2beXedxnNAnX7mfTDYnlb8awYSqBbNw8Tf
         XX92SXA1wf9SJe4ojNrFHIXZqkOacphfwjnVKjsbQiNM0uPUSLWYMEQO4eoj+ar7ZICI
         t8pYzd/ll2xJDUNwDesmvJXTqs72sv/dH0nnJ67xwdWPjlKOTE4OdEN76hQuJGOVSI7a
         j6zOHPwG0khQyOSb7DRVkBFlLfZFaUKJsn684Zha1Fx3sMZIJtXHfIQnrSk44DDJT+m3
         9Arw==
X-Forwarded-Encrypted: i=1; AJvYcCWp1DprKwbFvcLeZvtLoZ3Xk4eMQ1OytNdRHWAea8t94SRycLdMqcj2ZBiOxIHGxAEJwGXPPppjDyT4Jas/jKvEpEmtp0qvcNNqCsDOieQXuepRQtJ04qunVfCzQ5ehSQ==
X-Gm-Message-State: AOJu0YxW5NXGBhuCbzTD4WW+RvchNtHIPlbfL5xMbnWfRuEpohZ0q0h8
	XEUIV4NmPjFfZgk/Jfway2W3zxwDcvlsP7uISGYELHbimQs8xSSF
X-Google-Smtp-Source: AGHT+IElr9+azYHPCzUFeTz1EuYFHglVKOWVA4EowaDvaPKZHxot7h8o9eZbcs6oAHVCQxDmjIZ3Sw==
X-Received: by 2002:a05:6a20:2589:b0:1a5:6fd3:dff4 with SMTP id k9-20020a056a20258900b001a56fd3dff4mr1361769pzd.13.1712307770983;
        Fri, 05 Apr 2024 02:02:50 -0700 (PDT)
Received: from wheely.local0.net (124-169-104-130.tpgi.com.au. [124.169.104.130])
        by smtp.gmail.com with ESMTPSA id s12-20020a62e70c000000b006ecf25d0b8dsm995783pfh.184.2024.04.05.02.02.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 05 Apr 2024 02:02:50 -0700 (PDT)
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
Subject: [kvm-unit-tests RFC PATCH 12/17] shellcheck: Fix SC2124
Date: Fri,  5 Apr 2024 19:00:44 +1000
Message-ID: <20240405090052.375599-13-npiggin@gmail.com>
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

  SC2124 (warning): Assigning an array to a string! Assign as array, or
  use * instead of @ to concatenate.

Signed-off-by: Nicholas Piggin <npiggin@gmail.com>
---
 scripts/arch-run.bash | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/scripts/arch-run.bash b/scripts/arch-run.bash
index e5750cb98..89a496014 100644
--- a/scripts/arch-run.bash
+++ b/scripts/arch-run.bash
@@ -150,7 +150,7 @@ run_migration ()
 		return 77
 	fi
 
-	migcmdline=$@
+	migcmdline=("$@")
 
 	trap 'trap - TERM ; kill 0 ; exit 2' INT TERM
 	trap 'rm -f ${src_out} ${dst_out} ${src_outfifo} ${dst_outfifo} ${dst_incoming} ${src_qmp} ${dst_qmp} ${src_infifo} ${dst_infifo}' RETURN EXIT
@@ -179,7 +179,7 @@ run_migration ()
 	exec {src_infifo_fd}<>${src_infifo}
 	exec {dst_infifo_fd}<>${dst_infifo}
 
-	eval "$migcmdline" \
+	eval "${migcmdline[@]}" \
 		-chardev socket,id=mon,path=${src_qmp},server=on,wait=off \
 		-mon chardev=mon,mode=control \
 		< ${src_infifo} > ${src_outfifo} &
@@ -219,7 +219,7 @@ run_migration ()
 
 do_migration ()
 {
-	eval "$migcmdline" \
+	eval "${migcmdline[@]}" \
 		-chardev socket,id=mon,path=${dst_qmp},server=on,wait=off \
 		-mon chardev=mon,mode=control -incoming unix:${dst_incoming} \
 		< ${dst_infifo} > ${dst_outfifo} &
-- 
2.43.0


