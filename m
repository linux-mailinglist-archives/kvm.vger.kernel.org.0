Return-Path: <kvm+bounces-13641-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 831F98997EB
	for <lists+kvm@lfdr.de>; Fri,  5 Apr 2024 10:36:07 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 136DAB2190C
	for <lists+kvm@lfdr.de>; Fri,  5 Apr 2024 08:36:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4AFA741C66;
	Fri,  5 Apr 2024 08:35:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="B0m1dDBo"
X-Original-To: kvm@vger.kernel.org
Received: from mail-ot1-f47.google.com (mail-ot1-f47.google.com [209.85.210.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 07A463DB97
	for <kvm@vger.kernel.org>; Fri,  5 Apr 2024 08:35:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712306156; cv=none; b=RG980qWWvLdZZgBuUSGQfrs2TqCrdXin/gDE9ma6/DJXeQWnt357jiHb2JPcGd2iNwHscwY2sxneN49XBU7G2BYP6cHjnvOpHXs72978OFw4ZbqivJedIiQYTNQt48jLYJ13RthXKWRiqr+HhzOy0AyC11qTEyLSCHoGiq1d8hM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712306156; c=relaxed/simple;
	bh=C71a5qU6m9i7MBLZTyIoOq8lIDVAp909KFIrW6co4ck=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BzdEACZI7dtkeOXtLlSGA9MbFICryTkkm669FBb/HNJAcdFIb0g3y+hZjVHj3hDPgSPNwh+0BYETbLvxo9IAxw3qtirbY9q075dpcaedceVqee+XSIc/1bJG496LVypEBQFAZlsroLppu+U5hI8dzukx+htTGYGheWlEn47bh6I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=B0m1dDBo; arc=none smtp.client-ip=209.85.210.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ot1-f47.google.com with SMTP id 46e09a7af769-6e6ff4e1e97so1075191a34.3
        for <kvm@vger.kernel.org>; Fri, 05 Apr 2024 01:35:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1712306154; x=1712910954; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=GvdWm/EbdtyEDjLrieOZV8NQclxoYIlpjbHpwiUxG74=;
        b=B0m1dDBobDFkTjXWGpiY7367iOWR0VnTzxlC6btoftKQusGPLmn+O7pV84gDPZ905+
         YICU3KEx067tAd3vOQ4EdnrHXXa6X5ONvQpfnb5+OHjM8ig3libXJVc6QAEctYH6nxaZ
         98fiRGQP0ajAtEdPJc7n/Xqu0wFG+8MLNDOJ5m/rdIih53MkRw/T59MP96ZhWYTtJ74V
         NtTlJvNXg0E8mUqVtFj5xXT0UN8OBIcb8+wYx0KGGVARBPQy9X6l1+Fns+IGOoGKnvKX
         HIu8Mw5nQ2JeiBLHJj+ajRF1ZraeyCMHjzuGBakdLoFpTZNCfz91ZHo1KJlHax70BUX4
         Fyqg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1712306154; x=1712910954;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=GvdWm/EbdtyEDjLrieOZV8NQclxoYIlpjbHpwiUxG74=;
        b=Qo7PQU2jrLHR/8NJqATiu79qBoa5lhIXT6MwDg3h/PlLYrPf7k2813Q/SAUvIHQH/o
         QxUOTGXwi8Bx6xuS9nrgttUkim8E8w5olAi75yf6IsC2bxEvWUSqO6y315zlsDvYVpl+
         gufNilry2Kc8DqylG9cCk8IDVTcYWuJz7fYCpTr1mfAZ43z0Wi3Q7hVvgJunrHMrly02
         Bke9vKhK07GcmgsLCR16Ldvlhnu2AED1+go6Qf7ziDToyJ254aF/jSPyhJdgWlYp7YRj
         LBULkEeYiPyXaEn96S86U8oDhUM5gwwDQ/dcWrpuGxD64J99VTf6QA3D8us5wtAIKHz/
         sLVg==
X-Forwarded-Encrypted: i=1; AJvYcCXaR/rs0Sq91OZOoquRExjGk5OwQyULGcb05GEGp3i7895nm/1VnpDdW8Zjusxmx7gSxP9txl2hJBSMCFGOJmnZlOgm
X-Gm-Message-State: AOJu0YwP54DKl/lCSD9r8thjD7E/vkvxRrqRhuoIO9wNnwrjJFAaQGzA
	bvSF6cJUfv2fmTyH54yeWQMylKgqaDdja7j3aWMWbzw9N+CbpWHIMuhNstZf
X-Google-Smtp-Source: AGHT+IH82UhfFuAIgRLwTFl0nZz0Yzsgd5XfOtV6vE6Hjh/yxelgsV5p6fAAYYF1vGNcDF50X+CIaQ==
X-Received: by 2002:a9d:7f19:0:b0:6e9:e442:1588 with SMTP id j25-20020a9d7f19000000b006e9e4421588mr858662otq.8.1712306154017;
        Fri, 05 Apr 2024 01:35:54 -0700 (PDT)
Received: from wheely.local0.net (124-169-104-130.tpgi.com.au. [124.169.104.130])
        by smtp.gmail.com with ESMTPSA id y7-20020a63de47000000b005e838b99c96sm808638pgi.80.2024.04.05.01.35.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 05 Apr 2024 01:35:53 -0700 (PDT)
From: Nicholas Piggin <npiggin@gmail.com>
To: Thomas Huth <thuth@redhat.com>
Cc: Nicholas Piggin <npiggin@gmail.com>,
	Laurent Vivier <lvivier@redhat.com>,
	Andrew Jones <andrew.jones@linux.dev>,
	Paolo Bonzini <pbonzini@redhat.com>,
	linuxppc-dev@lists.ozlabs.org,
	kvm@vger.kernel.org
Subject: [kvm-unit-tests PATCH v8 01/35] arch-run: Add functions to help handle migration directives from test
Date: Fri,  5 Apr 2024 18:35:02 +1000
Message-ID: <20240405083539.374995-2-npiggin@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240405083539.374995-1-npiggin@gmail.com>
References: <20240405083539.374995-1-npiggin@gmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The migration harness will be expanded to deal with more commands
from the test, moving these checks into functions helps keep things
managable.

Reviewed-by: Thomas Huth <thuth@redhat.com>
Signed-off-by: Nicholas Piggin <npiggin@gmail.com>
---
 scripts/arch-run.bash | 20 +++++++++++++++-----
 1 file changed, 15 insertions(+), 5 deletions(-)

diff --git a/scripts/arch-run.bash b/scripts/arch-run.bash
index 413f3eda8..e34d784c0 100644
--- a/scripts/arch-run.bash
+++ b/scripts/arch-run.bash
@@ -122,6 +122,16 @@ qmp_events ()
 		jq -c 'select(has("event"))'
 }
 
+filter_quiet_msgs ()
+{
+	grep -v "Now migrate the VM (quiet)"
+}
+
+seen_migrate_msg ()
+{
+	grep -q -e "Now migrate the VM" < $1
+}
+
 run_migration ()
 {
 	if ! command -v ncat >/dev/null 2>&1; then
@@ -152,7 +162,7 @@ run_migration ()
 		-chardev socket,id=mon,path=${src_qmp},server=on,wait=off \
 		-mon chardev=mon,mode=control > ${src_outfifo} &
 	live_pid=$!
-	cat ${src_outfifo} | tee ${src_out} | grep -v "Now migrate the VM (quiet)" &
+	cat ${src_outfifo} | tee ${src_out} | filter_quiet_msgs &
 
 	# Start the first destination QEMU machine in advance of the test
 	# reaching the migration point, since we expect at least one migration.
@@ -162,7 +172,7 @@ run_migration ()
 
 	while ps -p ${live_pid} > /dev/null ; do
 		# Wait for test exit or further migration messages.
-		if ! grep -q -i "Now migrate the VM" < ${src_out} ; then
+		if ! seen_migrate_msg ${src_out} ;  then
 			sleep 0.1
 		else
 			do_migration || return $?
@@ -190,11 +200,11 @@ do_migration ()
 		-mon chardev=mon,mode=control -incoming unix:${dst_incoming} \
 		< <(cat ${dst_infifo}) > ${dst_outfifo} &
 	incoming_pid=$!
-	cat ${dst_outfifo} | tee ${dst_out} | grep -v "Now migrate the VM (quiet)" &
+	cat ${dst_outfifo} | tee ${dst_out} | filter_quiet_msgs &
 
 	# The test must prompt the user to migrate, so wait for the
-	# "Now migrate VM" console message.
-	while ! grep -q -i "Now migrate the VM" < ${src_out} ; do
+	# "Now migrate VM" or similar console message.
+	while ! seen_migrate_msg ${src_out} ; do
 		if ! ps -p ${live_pid} > /dev/null ; then
 			echo "ERROR: Test exit before migration point." >&2
 			echo > ${dst_infifo}
-- 
2.43.0


