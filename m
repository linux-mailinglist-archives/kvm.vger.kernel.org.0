Return-Path: <kvm+bounces-24476-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 7DD5A9560B8
	for <lists+kvm@lfdr.de>; Mon, 19 Aug 2024 03:09:14 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 0AF1DB21D91
	for <lists+kvm@lfdr.de>; Mon, 19 Aug 2024 01:09:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 204A11B960;
	Mon, 19 Aug 2024 01:09:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="iS4Ylxgy"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f195.google.com (mail-pf1-f195.google.com [209.85.210.195])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0A7CC1B5AA
	for <kvm@vger.kernel.org>; Mon, 19 Aug 2024 01:09:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.195
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724029745; cv=none; b=eP4HeTmT2ZABLwNr6mLmjcnZIVB1tHiZDaSyKjsbUk2OhkC2GmeML91WF6P/NKZ+aCaJTGsv4NN6XlLgR+508jostKLvhrBZ28kHoe6btbZ3BjmhAVf8GZeW3sBNlp00NdInpHwxKRinLxQ1F//5eO2AKBPIsl0XUE/Dl1auH74=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724029745; c=relaxed/simple;
	bh=4hklxyNUlvbMhY5isYEfK16mjKhTfZdZJYUzsuumq38=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=G96XPIezZyXliorNTmNmPyOiHopNYxAzki0uF36nmWz9mQYgibL9lAxaFaArsOvYt7glWwvfEQj/0ohP3RBW4LilWps8milcYbgY5LuCr1RK8NnDGYJyahjNNBXYGIm55scMR5d9zJPEDOu2UISxh7reY4Ull+qlf2gMNYgSssk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=iS4Ylxgy; arc=none smtp.client-ip=209.85.210.195
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pf1-f195.google.com with SMTP id d2e1a72fcca58-70d399da0b5so3295936b3a.3
        for <kvm@vger.kernel.org>; Sun, 18 Aug 2024 18:09:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1724029743; x=1724634543; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=gsKMTLFsabjdxtWobRt89f6wrjqfDU4EnRWT7bF37OA=;
        b=iS4YlxgyLmg+AyuT/ORZGZtp/Uy7nV8EXIsV6tvur08rwKt3cAa3iN8RB/c+/Gczqd
         nzLNtfaar/0XYO4eM/ytiBcleUYZA2tmLZRvUjKhkEJ2/gNxYO6GBPL8laSAKac/5VSQ
         NKylejn2Ig76loh/ChpS+K75sU0gs7MkDJL/0vAB1kbu+ZXHuYFij6JOTYljF/4h1Y9/
         v9gTPa3TdOP2r+8hCsjIh9Z/RVw7HSzub8P4UDxW2fJk5TEvXt9mvRS3zPAaY4/itflQ
         FbjCJgjAg9RQubh1awdMwzgFmv4ijUQqAhfoQuvVhXaD/D6bY6utcdewHq3A/bxFDQBW
         ZKhw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1724029743; x=1724634543;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=gsKMTLFsabjdxtWobRt89f6wrjqfDU4EnRWT7bF37OA=;
        b=DohMv9uIbZuCmZ/AYBJ4XUKxiDgB4VPCb9oqnqpYH1ArN1YWmSGdJXEVlKSYHy95Wm
         qWDQ47CgetF0OF1QNk1z5oqCbKvNuhk/Ln34q2qjoajG6Bg4Yvefh7WHdUnYEZfOp8P6
         IHJjq5fiDBoKoGmGhKYXjCQdI/cZbEEqyBPbchl1XusdCeeVVLSRVOnj6hnuBH4CRPYK
         iv7ibMvP+0xAVlQWIcXXYsiEMLVCAU1QpND6+4k43JRgsUT2Tcw3GVW8XJ17kzrYElRE
         WSo7nBBpHQdk1bupTtYlh2rv4yfINSY9RN8wn6u68Ktwds2dfGzAzTVR5cKxlTvuFEWD
         LK9w==
X-Gm-Message-State: AOJu0YzitwILdx3iPLA/hv7FpdXF76QrwNGaHVsfOdmAFZRWRlVoduGY
	6ec3RPwXCz9HuGAuaXYwDDJBRH/vSrVzh0dnfZ2Wue/AUWtQWD3izfzEYLYXB5Y=
X-Google-Smtp-Source: AGHT+IFDUgQsB68gJvkp+y+h0eUduZ5j/bVcFBQLlDtJ/7kT7CGg1LiqFY+qCCQgQK1MQz9GHHWo0g==
X-Received: by 2002:a05:6a00:2e1a:b0:710:e4db:a6fc with SMTP id d2e1a72fcca58-713c52441c9mr12016406b3a.27.1724029743153;
        Sun, 18 Aug 2024 18:09:03 -0700 (PDT)
Received: from localhost.localdomain ([45.63.58.14])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-7127aef44d6sm5722536b3a.130.2024.08.18.18.09.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 18 Aug 2024 18:09:02 -0700 (PDT)
From: Dongli Si <sidongli1997@gmail.com>
To: sidongli1997@gmail.com
Cc: kvm@vger.kernel.org
Subject: [PATCH kvmtool 4/4] x86: Disable Topology Extensions on AMD processors in cpuid
Date: Mon, 19 Aug 2024 09:08:54 +0800
Message-ID: <20240819010854.13931-1-sidongli1997@gmail.com>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240819010154.13808-1-sidongli1997@gmail.com>
References: <20240819010154.13808-1-sidongli1997@gmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

When running guest kernel 6.9 and later on AMD processors, dmesg reports:

[    0.001987] [Firmware Bug]: CPU   1: APIC ID mismatch. CPUID: 0x0000 APIC: 0x0001

This is because kvmtool does not support topoext but does not tell the guest,
causing the guest kernel to read the wrong Extended APIC ID.

Signed-off-by: Dongli Si <sidongli1997@gmail.com>
---
 x86/cpuid.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/x86/cpuid.c b/x86/cpuid.c
index f4347a8..fd23429 100644
--- a/x86/cpuid.c
+++ b/x86/cpuid.c
@@ -56,6 +56,9 @@ static void filter_cpuid(struct kvm_cpuid2 *kvm_cpuid, int cpu_id)
 			}
 			break;
 		}
+		case 0x80000001:
+			entry->ecx &= ~(1 << 22);
+			break;
 		default:
 			/* Keep the CPUID function as -is */
 			break;
-- 
2.44.0


