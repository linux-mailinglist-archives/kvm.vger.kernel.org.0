Return-Path: <kvm+bounces-13809-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 16CD489AAE7
	for <lists+kvm@lfdr.de>; Sat,  6 Apr 2024 14:40:47 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id BF2ED1F21A86
	for <lists+kvm@lfdr.de>; Sat,  6 Apr 2024 12:40:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 32BE42E64C;
	Sat,  6 Apr 2024 12:40:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="m+4qc/Kv"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f172.google.com (mail-pg1-f172.google.com [209.85.215.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 610E72869B;
	Sat,  6 Apr 2024 12:40:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712407240; cv=none; b=NPE7W3OrOV7KaRaQYvK7Y/RnjZiibU4v9WjEDDJt8ZdrDztkan2dnVrd0Fzx80SchMXBqg2GTyCpPFSK74aINNzPyelAHUp+uk5XQxQBPXlOq/7MQuCedcVfX/IG/5T8kSJezhfPouDZ3xhCoJWlIKFTG8oy1+bG+lCQvxTDE/M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712407240; c=relaxed/simple;
	bh=gGUa3K9zILUvgF5PKH8SMZ/qnhdZyUnL8GXR2wj6lXM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bijAuF0ujk4Ooukj6IG8pnocn92LC/xdWL6U3AIIp/s/MX70mCmoF3P3rU9JCvIt2mTrkRWXNU6TmjPhUYL+uMuT8YJQRxZ8IuVJHA7CPmoic0vbPgx3jCq/p1xkR8nM6rUwlx2bYsB/MS6VTNjK15Qw2/15jM6qZKl54STk0Xs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=m+4qc/Kv; arc=none smtp.client-ip=209.85.215.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pg1-f172.google.com with SMTP id 41be03b00d2f7-5e4613f2b56so2685907a12.1;
        Sat, 06 Apr 2024 05:40:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1712407238; x=1713012038; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=2eRtFguiVvn3b4AxH0QU+OXVRgeLtifhqAQZ/pJYpnQ=;
        b=m+4qc/Kv76lMdfngJiY86fUd/6PtHbxCQYZfc0ADkF28vXC8XoeyqBjlm2E9VWvFxb
         4b/urcvC3hQ/oDTLFrR/ooBaKLQD9PgFGjS8JsPl9GmzXtJGv/a2NlBXd5PM/1u6IVgW
         G9yQnciTHw9mWqpEu0TkbDOf2zP7W8+ZiKGQzskVh8oNOCOyRjzhKI8RE0CZ8Wsd3UK0
         SKu+YDiwA5PJ0XB3yqzf8fXLTzDkjPjDGr1CaL5vtPI0Ox5v0nOiTdmOPxUjKtLd7UcQ
         ia79JbxCtksxEdltvziXH81IDB+8fn9c3j3qHjf7HZQ7RTCEDx6UAFXf0bbP/qjm3G/u
         8rjA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1712407238; x=1713012038;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=2eRtFguiVvn3b4AxH0QU+OXVRgeLtifhqAQZ/pJYpnQ=;
        b=nVR3zsDOECsEco6IS4drxk1PJDaJd1cKoaPtWCGXraZONQniTMQbhDgiqj9Jj9xpgS
         rj2E/UNeOOCqGmDUtCAZPwDIJXnKRPi2LPfCKdIwbJOuSOVjtqX3IXnw0+huzO9dgZxd
         D+N8gk07WVGsQAYCdUjQlZpFm9baUBeSxnx5PDJt3mQDLsElFz+Uk6dPp440+3DLSSVQ
         cMo9MeVgFekg8+O9EeCgOixaTEmD8qPBukq2Z0vnKZb3lUYk79eHhF29LzRfGQ9xTCnk
         uBfarDzOQEPbBF9B8AaH9XB2pM2zTBWKHtVKWi0kCJaj63sEpXP8Eh9I0zgZmP/5xbT2
         vN6w==
X-Forwarded-Encrypted: i=1; AJvYcCUh6GVXR3Cfc62warXhiGlaKt+sKe+0cZxiXVm7J4S5GMECKhtvhkeKP0/plo1m27F/+2sJWpE2E3aMfz+iEtlCFSz1Jk87KmYCuYwXL60BQEnAl1z6uITlx+p1rn0YFg==
X-Gm-Message-State: AOJu0Yz9mBr+Gg+LIA8HmpD/VATf5iLdS/d4ECjmxmg1ZiTq7i8tn+yE
	kU4tbX8IsXOACWXAH1Pe9zD9jD2fIFjTiH2+CHc6lF8AJdPRMQQ+
X-Google-Smtp-Source: AGHT+IFRwkbTF8lHFVWUWdHITKOoyi+cM/zQNImgd0YNfpYQL2AebNpOitSBxxkyLMi56+NDz70TCQ==
X-Received: by 2002:a05:6a20:1587:b0:1a3:9fa6:74f6 with SMTP id h7-20020a056a20158700b001a39fa674f6mr4468400pzj.58.1712407237671;
        Sat, 06 Apr 2024 05:40:37 -0700 (PDT)
Received: from wheely.local0.net (124-169-104-130.tpgi.com.au. [124.169.104.130])
        by smtp.gmail.com with ESMTPSA id nt5-20020a17090b248500b002a279a86e7asm5050576pjb.7.2024.04.06.05.40.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 06 Apr 2024 05:40:37 -0700 (PDT)
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
Subject: [RFC kvm-unit-tests PATCH v2 12/14] shellcheck: Fix SC2178
Date: Sat,  6 Apr 2024 22:38:21 +1000
Message-ID: <20240406123833.406488-13-npiggin@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240406123833.406488-1-npiggin@gmail.com>
References: <20240406123833.406488-1-npiggin@gmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

  SC2178 (warning): Variable was used as an array but is now assigned a
  string.

No bug identified.

Reviewed-by: Andrew Jones <andrew.jones@linux.dev>
Signed-off-by: Nicholas Piggin <npiggin@gmail.com>
---
 arm/efi/run   | 2 +-
 riscv/efi/run | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/arm/efi/run b/arm/efi/run
index cf6d34b0b..8f41fc02d 100755
--- a/arm/efi/run
+++ b/arm/efi/run
@@ -44,7 +44,7 @@ qemu_args=()
 cmd_args=()
 while (( "$#" )); do
 	if [ "$1" = "-append" ]; then
-		cmd_args=$2
+		cmd_args=("$2")
 		shift 2
 	else
 		qemu_args+=("$1")
diff --git a/riscv/efi/run b/riscv/efi/run
index cce068694..5a72683a6 100755
--- a/riscv/efi/run
+++ b/riscv/efi/run
@@ -47,7 +47,7 @@ qemu_args=()
 cmd_args=()
 while (( "$#" )); do
 	if [ "$1" = "-append" ]; then
-		cmd_args=$2
+		cmd_args=("$2")
 		shift 2
 	else
 		qemu_args+=("$1")
-- 
2.43.0


