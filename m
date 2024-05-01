Return-Path: <kvm+bounces-16334-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 1BF988B893C
	for <lists+kvm@lfdr.de>; Wed,  1 May 2024 13:30:51 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 46E991C2174A
	for <lists+kvm@lfdr.de>; Wed,  1 May 2024 11:30:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DB6D5770F4;
	Wed,  1 May 2024 11:30:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="gwQrTu3S"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f174.google.com (mail-pl1-f174.google.com [209.85.214.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CEF1764A98;
	Wed,  1 May 2024 11:30:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714563045; cv=none; b=MvrgpKpx4rEmSTRvH29ifE66QuoasA3SPXxVArUdTpFmfYneQYBeZd5Z+8Yklwb8Fm6koNzrUxpKN6c+d1HZLM9R12dBeCRKeGisdBqurHkWallVb3/ssO7BOfwEDZt8ZUiDLUrzfQZOYu8rBSNuKZ9VgaNmPf0KpyYDwOact+I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714563045; c=relaxed/simple;
	bh=FFft7ygHb4sNew26D/dJgFST62xDvyHht1DMBSvtx6w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=s3UlJPmt+g6g/Omzq/VP5OwVll6OkWBVRpSee0xown0rVUtBJ/H1EpV2wdva/X8XqznqaRAXh3u1piLdLZ9PSOCbXWNgpPHDLF/w66VhSXttXyxkLDElBGeY9NDulInmNw9wloqlMxnoNY/eEngdEy7RQKrEP4V+uKIs6SBcMUo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=gwQrTu3S; arc=none smtp.client-ip=209.85.214.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pl1-f174.google.com with SMTP id d9443c01a7336-1e4bf0b3e06so66450745ad.1;
        Wed, 01 May 2024 04:30:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1714563043; x=1715167843; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=DtN3qRr/BJ5ghrfuBVmkjt4OGFVHY6H/GotGGIKP5Pw=;
        b=gwQrTu3SxETFCZdPQURwWuhGq6AOx0NvqKW1yEeBoF3RuPjKnxuL9ZuSu1zR9cQfjz
         grxf377hjZ55FoBm/fI8hDTqoqSidq013gzvq2UACtdAvcGYRglEmmKt0kd3ZNwZfc4J
         t4gF//8GBZU9m7wvcTqNRdRWs6+evc360Cbs9jKEUYVY2/G87yd5g2szuigf13r7z24C
         vUagjdWGpusPdVIyG46SXuek1Kqd8MIpGHXC/Ie4nygCOHVHkIKvKHpd9RCuW3p805sl
         lRh1luIoiujdyy7nntx5E7mZsR7lekTOBL+bhOJIGZoyhbdW2Tg6aQ+rRJ/bAkxPB8IO
         cIpw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1714563043; x=1715167843;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=DtN3qRr/BJ5ghrfuBVmkjt4OGFVHY6H/GotGGIKP5Pw=;
        b=hQKcfW39f9fuhn8Wx/kUkFDtSMoB7ivqi35NYCr6KPX/wJnakBptwd0LkTAVWZcBQF
         ZCfmWS35fT7NNQSIc7Zzc+SOS+X3CvI7FBVIQjCcia17tvHyRsaGpUp9GYJScel7WxDi
         IFlTVGtdSNXMproS8VSKxf/pCx4d94rg/zykcZkffrZSLlqO6WgS3oLg2ilOTnC6sOd+
         ALSh4dgPWfmISuS1YNBWNAmq8rAn03NdwfTQvphMVvcsCLRq3CF2wsXgdyGsHG12r9kv
         KCmN153p9CAqHlh3RJgr6GsjRWA/SX+EXj0g1njQ3A/4YT65sofjaxXodEMpRTnVOM3F
         1o9Q==
X-Forwarded-Encrypted: i=1; AJvYcCWfAtXfaZSUXtOldV2jeuHTADwIOxI0lHCzwR2p7O7t9PE1mA9fZIOzeY0RemO1NbUrYzQzPPdJpXwlgfvJGENaE65LOuzpIIDTJz9G124yLL3ojXNFwGpthqQMTcXYIw==
X-Gm-Message-State: AOJu0YyJDUbMPWIoSm3NaVxcNVWEBg7SUm65QaoJI2fWEFUBrpE2hlrv
	BNSxsCTx8VYf2tdQjAkTwcEG54n4Fa7PdEi/id32SG0Tc4MZeWWJ
X-Google-Smtp-Source: AGHT+IHV5oYZmLZqhk7vquCKub62gii9ohDvIT5N0GBLR7bQIFTMvArnXy34z/49jHpv24YnONJaaw==
X-Received: by 2002:a17:902:d506:b0:1eb:2fa0:c56f with SMTP id b6-20020a170902d50600b001eb2fa0c56fmr2440147plg.35.1714563043212;
        Wed, 01 May 2024 04:30:43 -0700 (PDT)
Received: from wheely.local0.net ([1.146.40.196])
        by smtp.gmail.com with ESMTPSA id y22-20020a17090264d600b001ec64b128dasm2267150pli.129.2024.05.01.04.30.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 01 May 2024 04:30:42 -0700 (PDT)
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
Subject: [kvm-unit-tests PATCH v3 4/5] shellcheck: Fix SC2294
Date: Wed,  1 May 2024 21:29:33 +1000
Message-ID: <20240501112938.931452-5-npiggin@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240501112938.931452-1-npiggin@gmail.com>
References: <20240501112938.931452-1-npiggin@gmail.com>
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

Reviewed-by: Andrew Jones <andrew.jones@linux.dev>
Signed-off-by: Nicholas Piggin <npiggin@gmail.com>
---
 scripts/arch-run.bash | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/scripts/arch-run.bash b/scripts/arch-run.bash
index 95b6fa64d..98d29b671 100644
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


