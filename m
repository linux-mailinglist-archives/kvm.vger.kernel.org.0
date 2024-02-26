Return-Path: <kvm+bounces-9781-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 365F8866FBD
	for <lists+kvm@lfdr.de>; Mon, 26 Feb 2024 11:02:56 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id E3E92288E7C
	for <lists+kvm@lfdr.de>; Mon, 26 Feb 2024 10:02:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 52B2F5D8EF;
	Mon, 26 Feb 2024 09:38:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="c5V7GA/r"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f169.google.com (mail-pg1-f169.google.com [209.85.215.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 316FA5D75D;
	Mon, 26 Feb 2024 09:38:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708940335; cv=none; b=Cs+/OOeM2QTvQ1zUpo2Hub/r/BcPxuOHQYofGOyhM5XpmTeSWa2vhwwjp98lzIOy34jmDBt6jPlq1e20YVKtwGy+EGfWz395X5xvnksfeGjwrrBHyUIbQCgc1V2lv7IWzCnntWloEGnV3g58RqqjzUiYQaelRspGxe7SyFFZSBU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708940335; c=relaxed/simple;
	bh=01++PoAiahxeiEZNtxpYl/vmuayxoq+N5H5tupQgni4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GNFV7irpKeTwRZ9ZdQhtZw3wMYLxum6R3hViBJQbJRKPkqeSeWKI+COauoOKZM1KrvD3wd7ABGcbMajAU1HPxYKV2bFQGqhNvKWcUkQQwSVKfoEjSlTTEplC63G4iaNgXIh7vvhJ9Rfyssfl7sEnTSJcMBzz+DGVLZHC8Cgcq2E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=c5V7GA/r; arc=none smtp.client-ip=209.85.215.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pg1-f169.google.com with SMTP id 41be03b00d2f7-5dc949f998fso1889232a12.3;
        Mon, 26 Feb 2024 01:38:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1708940333; x=1709545133; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=6vnjHCFtfaL9mXwWGPHpDHfEXciN5WUW1+wFbKGrPaI=;
        b=c5V7GA/r6UNl3YbOuMMKJ7TzcN9/Cy1mfJdYagk45BSywKsM2AmgBWLcXBCabAoBMV
         mVZNsNRZzujM62ftXkWFTtf9v83V5ft8RndQcUA/h9a3Ws4u6ArXZYhWbkvdYmc5hs8W
         9hmbeOXFFzTBprXK24407lPU8cv18AsdcgawNwzSaraXkROvtYhM1Qp7bGeiuFhcL9AD
         00/cJghattlvL/wrP2V9pfc0m4fChgDyNSUhzg9ep/jBQwz7rhVTi45y2nIezV7UzOcT
         vuXaBlI7Lb8edrEGqCgCMQUSxfuQMAQjXOoLhnP0OXeNDohcsrMzsI7dq3ncvpIHfAsU
         GqGw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1708940333; x=1709545133;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=6vnjHCFtfaL9mXwWGPHpDHfEXciN5WUW1+wFbKGrPaI=;
        b=h8zuJFSFIRUmhJv3kKDmzpdSvEaDACqCwBTMZIK7bS1UjovPTSYBuIhQuMZ5lCZ1fg
         KEoZ/UWUvDRiX6mEBuGxXDxhKe0AfoQgbngcRfR86oEtSULNfHKdZ2bn9ykHBaLmxMNz
         nc+lkRY5VlM2nIcd0YIYdrtYD/mdYd1rvaPzw5e2CZgMaErwyylakAVtrvQRdCcpmYqm
         yGs9U0vEbugcGfJmluTXhcuhxi99iXMMemdMaoIr5hzXBLvnZRFUvXUdAralEkkVrfvb
         02oBqjGEK7tpiBVyGDB/DntzdMgjwSsYXdzv7aVhk7sDVd3ynys7X3fXraXc+b6N1d/c
         KoRg==
X-Forwarded-Encrypted: i=1; AJvYcCUUUHklPi03E8RlIHxMMi8f7nLsqoxFFuFLYBLsvCIMFREygDN199WhtVpoIbojhJZYh3A+/t2Ql53wRfp3TBM9WwwyNVqZi48aIWxPJDKQYKJgu2l5t0d+3ZdqBng6qA==
X-Gm-Message-State: AOJu0YxjEZO+avkAQq1u9T64WUjH3TS6B+zwrc2a4C6wSFLRDm52t5aq
	4WXyAgCnlQvc9qLB7pSTZItyFIH6GWo030nx9DQsEWK9JiYoGlO5
X-Google-Smtp-Source: AGHT+IG2EnUxjMz0a/WUt7Yj1hLPi5khQWrO2IMM+XfUlR+14mHZyrTHTnCdcYQxIaN+sjSzMymj9g==
X-Received: by 2002:a17:90a:9913:b0:29a:11b6:a333 with SMTP id b19-20020a17090a991300b0029a11b6a333mr4192571pjp.15.1708940333437;
        Mon, 26 Feb 2024 01:38:53 -0800 (PST)
Received: from wheely.local0.net (220-235-194-103.tpgi.com.au. [220.235.194.103])
        by smtp.gmail.com with ESMTPSA id pa3-20020a17090b264300b0029929ec25fesm6036782pjb.27.2024.02.26.01.38.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 26 Feb 2024 01:38:53 -0800 (PST)
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
	linux-s390@vger.kernel.org
Subject: [kvm-unit-tests PATCH 1/7] arch-run: Keep infifo open
Date: Mon, 26 Feb 2024 19:38:26 +1000
Message-ID: <20240226093832.1468383-2-npiggin@gmail.com>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20240226093832.1468383-1-npiggin@gmail.com>
References: <20240226093832.1468383-1-npiggin@gmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The infifo fifo that is used to send characters to QEMU console is
only able to receive one character before the cat process exits.
Supporting interactions between test and harness involving multiple
characters requires the fifo to remain open.

This also allows us to let the cat out of the bag, simplifying the
input pipeline.

Signed-off-by: Nicholas Piggin <npiggin@gmail.com>
---
 scripts/arch-run.bash | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/scripts/arch-run.bash b/scripts/arch-run.bash
index 6daef3218..e5b36a07b 100644
--- a/scripts/arch-run.bash
+++ b/scripts/arch-run.bash
@@ -158,6 +158,11 @@ run_migration ()
 	mkfifo ${src_outfifo}
 	mkfifo ${dst_outfifo}
 
+	# Holding both ends of the input fifo open prevents opens from
+	# blocking and readers getting EOF when a writer closes it.
+	mkfifo ${dst_infifo}
+	exec {dst_infifo_fd}<>${dst_infifo}
+
 	eval "$migcmdline" \
 		-chardev socket,id=mon,path=${src_qmp},server=on,wait=off \
 		-mon chardev=mon,mode=control > ${src_outfifo} &
@@ -191,14 +196,10 @@ run_migration ()
 
 do_migration ()
 {
-	# We have to use cat to open the named FIFO, because named FIFO's,
-	# unlike pipes, will block on open() until the other end is also
-	# opened, and that totally breaks QEMU...
-	mkfifo ${dst_infifo}
 	eval "$migcmdline" \
 		-chardev socket,id=mon,path=${dst_qmp},server=on,wait=off \
 		-mon chardev=mon,mode=control -incoming unix:${dst_incoming} \
-		< <(cat ${dst_infifo}) > ${dst_outfifo} &
+		< ${dst_infifo} > ${dst_outfifo} &
 	incoming_pid=$!
 	cat ${dst_outfifo} | tee ${dst_out} | filter_quiet_msgs &
 
@@ -245,7 +246,6 @@ do_migration ()
 
 	# keypress to dst so getchar completes and test continues
 	echo > ${dst_infifo}
-	rm ${dst_infifo}
 
 	# Ensure the incoming socket is removed, ready for next destination
 	if [ -S ${dst_incoming} ] ; then
-- 
2.42.0


