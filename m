Return-Path: <kvm+bounces-19168-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 9BDDB901F39
	for <lists+kvm@lfdr.de>; Mon, 10 Jun 2024 12:23:06 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 718CFB28AE7
	for <lists+kvm@lfdr.de>; Mon, 10 Jun 2024 10:22:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7A2B480034;
	Mon, 10 Jun 2024 10:21:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="dyhZM/Rm"
X-Original-To: kvm@vger.kernel.org
Received: from mail-lf1-f54.google.com (mail-lf1-f54.google.com [209.85.167.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 211C17D3F0;
	Mon, 10 Jun 2024 10:21:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718014892; cv=none; b=FLT35B0lqF1ny7/QASlOMvw6PUa4R8eTho5loMZgBLV8JioML52dzOz5eM3Pg6ABFhidSsuoqYUcYjvho5kP4jgP4aTDcdsCLikmy4ZaJTfNxDkkXHWO4odzde1Bbslp/mHoeMpQgPDYMgFKEC/dnoxWT7q+TcT80ZyvdFCkif8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718014892; c=relaxed/simple;
	bh=JZT+a3gMm7LX5fmthY+7RJk9xN/fuL/DRlnnw7HuKpA=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=QD6BEG5G2bh0qmZXvxBSSLaLY4tA+uqFveIjyNPUpVeJ/BwqB2FRhgC8chLzgpryKYxtwO6OW+fVVpqBoAIukIiTv4cpJPMwtr/X8ZCds9BuqcR2Wh+3jpVZj9TiBpJBKC2CFHzLsF5XuPFASXaQ5ywT011S0cDwmRQWSZAELLo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=dyhZM/Rm; arc=none smtp.client-ip=209.85.167.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-lf1-f54.google.com with SMTP id 2adb3069b0e04-52c82101407so2422847e87.3;
        Mon, 10 Jun 2024 03:21:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1718014889; x=1718619689; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=PXpLAMRWKrEJAxhlnztpKOQCT6b3mNAcjXJNnKoGzl0=;
        b=dyhZM/RmKHcs+Ry9fehP1SAPhD6tJFf3dZVbWCThC/rnGWi6amBR5qKljfNnF6GE8z
         wPmNonM+6rC0psGN5hdOvRX/jSAQatFXNCI2MfufaIG4HZhDBcCNe2XOQRC4V2uROs3a
         9QzY0ZZ4S66Nh9hwfkZWWv02QqRpi9+mlgSheK9hhrGpZyWFmDjQJW8cvYxW1oTf55M9
         Iu8qahED6O1UJvV67CvgD89KqM6SMSo7CKUCPOp/g1WZvnhHrRGpsdQyEKYuqc0hBW37
         TGr2xVYyGOU4/GJ3Cc6jHgVUKj28ueDrBFYy7RcI3fAKJJJNFFIvuV0ITpdqNHAUktSs
         HLIg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1718014889; x=1718619689;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=PXpLAMRWKrEJAxhlnztpKOQCT6b3mNAcjXJNnKoGzl0=;
        b=odfcrzya15c0EXc90xY0+5Z/cEaorhw5iDUgHHzu4F9oaSs4bBXdaBgPE1C7CkXsaF
         G6rHamZJbcdESb9aQDEWhr02P53U1K+uWWoP+rWqfq6zU30FVD4o9luNmy7ezLYiTJGz
         u7NsXI7kOi7UUVygt92olBFVZVdjmS8NJwD3dz/6b/VDeT6ZPUeSGDKeytrnZus/SYOr
         XrVwccG1DAM6/VhXyyqGXTVMPCUiIZPLYALjAqGmUv26A8PaL+TTcT8AWy5gs6xQOXuq
         VROgAeMYyFJmB7E1rZ4ipNRCb423eV7xkgQ3XGhq+PeU+6iuI+12QFtAVzIlSXwtGc3z
         HQUQ==
X-Forwarded-Encrypted: i=1; AJvYcCUEUpfvhqiAyGlhGbFwgLgfP8FA5JDiw3uVwcXvpSTaYISUdFf1b1JXt3Xtzn5OfJADdXKzLQCuwYejU7YAGhVCWYIOqqTp8p+w/dDkCRxyepRGnGrN5NPWYQNqfmeXqMODckPdtO4/TV4zLFrjMsh3LUhCKjirvb7S
X-Gm-Message-State: AOJu0YyAvgSgIdO9TmryZxGBFiaNNKrERRJhPPA1iEqL7BS3v0jgWGw8
	3q/eRWOr9GOBtHcpMlhn2/izO5Fi0phruUFVNWyuZjsxx0pafpc/
X-Google-Smtp-Source: AGHT+IHJj4AaRNhrX7A2v/Kk6aeuS0bX16/27Qun+QcsTNsjyz064wpO/4XTT3yY1voEgsZC5VV9Fw==
X-Received: by 2002:ac2:4c82:0:b0:52c:8289:e891 with SMTP id 2adb3069b0e04-52c8289e9a0mr3434713e87.6.1718014889127;
        Mon, 10 Jun 2024 03:21:29 -0700 (PDT)
Received: from vasant-suse.fritz.box ([2001:9e8:ab68:af00:6f43:17ee:43bd:e0a9])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-a6f0d7b35d5sm290887766b.192.2024.06.10.03.21.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 10 Jun 2024 03:21:28 -0700 (PDT)
From: vsntk18@gmail.com
To: vsntk18@gmail.com
Cc: x86@kernel.org,
	Borislav.Petkov@amd.com,
	Dhaval.Giani@amd.com,
	ashish.kalra@amd.com,
	cfir@google.com,
	dan.j.williams@intel.com,
	dave.hansen@linux.intel.com,
	ebiederm@xmission.com,
	erdemaktas@google.com,
	hpa@zytor.com,
	jgross@suse.com,
	jroedel@suse.de,
	jslaby@suse.cz,
	keescook@chromium.org,
	kexec@lists.infradead.org,
	kvm@vger.kernel.org,
	linux-coco@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	luto@kernel.org,
	martin.b.radev@gmail.com,
	mhiramat@kernel.org,
	michael.roth@amd.com,
	mstunes@vmware.com,
	nivedita@alum.mit.edu,
	peterz@infradead.org,
	rientjes@google.com,
	seanjc@google.com,
	stable@vger.kernel.org,
	thomas.lendacky@amd.com,
	virtualization@lists.linux-foundation.org,
	vkarasulli@suse.de
Subject: [PATCH v6 03/10] x86/sev: Set GHCB data structure version
Date: Mon, 10 Jun 2024 12:21:06 +0200
Message-Id: <20240610102113.20969-4-vsntk18@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20240610102113.20969-1-vsntk18@gmail.com>
References: <20240610102113.20969-1-vsntk18@gmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Joerg Roedel <jroedel@suse.de>

It turned out that the GHCB->protocol field does not declare the
version of the guest-hypervisor communication protocol, but rather the
version of the GHCB data structure. Reflect that in the define used to
set the protocol field.

Signed-off-by: Joerg Roedel <jroedel@suse.de>
Signed-off-by: Vasant Karasulli <vkarasulli@suse.de>
---
 arch/x86/include/asm/sev.h   | 3 +++
 arch/x86/kernel/sev-shared.c | 2 +-
 2 files changed, 4 insertions(+), 1 deletion(-)

diff --git a/arch/x86/include/asm/sev.h b/arch/x86/include/asm/sev.h
index ca20cc4e5826..963d51dcf0e6 100644
--- a/arch/x86/include/asm/sev.h
+++ b/arch/x86/include/asm/sev.h
@@ -19,6 +19,9 @@
 #define GHCB_PROTOCOL_MAX	2ULL
 #define GHCB_DEFAULT_USAGE	0ULL
 
+/* Version of the GHCB data structure */
+#define GHCB_VERSION		1
+
 #define	VMGEXIT()			{ asm volatile("rep; vmmcall\n\r"); }
 
 struct boot_params;
diff --git a/arch/x86/kernel/sev-shared.c b/arch/x86/kernel/sev-shared.c
index f5717eddf75b..f63262a9c2a5 100644
--- a/arch/x86/kernel/sev-shared.c
+++ b/arch/x86/kernel/sev-shared.c
@@ -264,7 +264,7 @@ static enum es_result sev_es_ghcb_hv_call(struct ghcb *ghcb,
 					  u64 exit_info_2)
 {
 	/* Fill in protocol and format specifiers */
-	ghcb->protocol_version = ghcb_version;
+	ghcb->protocol_version = GHCB_VERSION;
 	ghcb->ghcb_usage       = GHCB_DEFAULT_USAGE;
 
 	ghcb_set_sw_exit_code(ghcb, exit_code);
-- 
2.34.1


