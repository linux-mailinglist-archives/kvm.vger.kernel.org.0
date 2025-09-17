Return-Path: <kvm+bounces-57834-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 28B8FB7C500
	for <lists+kvm@lfdr.de>; Wed, 17 Sep 2025 13:56:39 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 5C79C463B67
	for <lists+kvm@lfdr.de>; Wed, 17 Sep 2025 09:29:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B88AA32D5CA;
	Wed, 17 Sep 2025 09:28:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=smartx-com.20230601.gappssmtp.com header.i=@smartx-com.20230601.gappssmtp.com header.b="sdvs0fDL"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f170.google.com (mail-pg1-f170.google.com [209.85.215.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 75110309EFE
	for <kvm@vger.kernel.org>; Wed, 17 Sep 2025 09:28:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758101327; cv=none; b=Gk2705ENvOhpQxlgvZYdGkWtAhddX4QidDEEbtLryROkzq7byrA0/TF9tdjxW07UeZX2KdfsVjUGxC1QqzO8LkA/65rOaDqZFIbtVbvVODWRdEjYfso2KjQ0BZxTqhSU5WIq12iF0MlLXUTNlJwtX1Mx6nDot0BMlvrip9ag+2I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758101327; c=relaxed/simple;
	bh=HomK9oR9q6PgZ6KTjkrL0ZAF4ixtQM3rr4sUa8Fd5OA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Fkz402ILBNY7VrVtR1YtDs8bXNA9HUWsoDfVbxImeF9tnvYoCwaegnH3abcvlY/XHMrzEjwbLVmbNn2pUD51U/3IFFjoYbkbwAWPq7yJ2dV38PjwcPLGP42fRYftdf8vQrvVXJd7pQZi1tkKoAqTja7UD+sBILypHq+hSYONEKM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=smartx.com; spf=none smtp.mailfrom=smartx.com; dkim=pass (2048-bit key) header.d=smartx-com.20230601.gappssmtp.com header.i=@smartx-com.20230601.gappssmtp.com header.b=sdvs0fDL; arc=none smtp.client-ip=209.85.215.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=smartx.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=smartx.com
Received: by mail-pg1-f170.google.com with SMTP id 41be03b00d2f7-b54b301d621so4361990a12.0
        for <kvm@vger.kernel.org>; Wed, 17 Sep 2025 02:28:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=smartx-com.20230601.gappssmtp.com; s=20230601; t=1758101326; x=1758706126; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=A/CvHxpYU6aT1JADHVD5nQ98mr1UgBNDG9QHGX5cLNQ=;
        b=sdvs0fDL+fmQRx4+XxxE3b9aXLyW1htEcXlyoM4Svot1JDLnZ8KzEZtzMP2j+A9KcH
         zew8ka7Cjiz6f0OmchCUAkBj5M+uIih4NnBIoqI40FgAxqsZF5KUA8qZ2/Hg1EP71/2v
         CGHZQzRGTCAJpXN1Clg7ughI6mIQaOLD654LBR1z7pi/ztn3w/aPS5dPRcIfsmpyNyf4
         c09stCP4lu9iS2noUc+WBr6FB18ftTE7jph3cCsja3wyoAba4qk7tA8EvgNQnbJJBtKo
         I2Y+a860saPGnJXwO3agqwwfbdaRjDbWl2De2o29Fc5ePUiLwO1UM2UBguKZIOHcLlI8
         MW6A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758101326; x=1758706126;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=A/CvHxpYU6aT1JADHVD5nQ98mr1UgBNDG9QHGX5cLNQ=;
        b=M1iF77GOkk8amkk2k0bgPAos5KcvqKcOp3cSwRbY5u5TAJmW3j5kLqX2sEk69KGb4S
         lI3DhZ45tt59OaQlffmuikD7GtmPrcm8Uk0UXcc8N9LI14C43SvhEITkrXW1idgz5SHg
         BO5/f1VV0EnQ19rBgejtlyYeUuivLiVraJDFfOO1XCWnNSYzJ8ZS85MaMym0NGmJyFii
         SWB65UC+cqK/efeAVQ0FDGsYXlEpicCelc8cptXcHUARTChR4PUG8l8yrDyvnrIBfK05
         fV7cqAt1YNLc4t5CenlFXi25n51If1N8HVHH5UYQmfXs5RZLr3zLd56hZvDfgpyH3iJq
         hPsQ==
X-Gm-Message-State: AOJu0Yz8CaLL/5RdL8DxLq5Z3GZZz1KtRUoYhL0DXEmICY3euU+sq2X8
	D29ADytw5mdUj9Qk3DO/ju6oejO5//fvtojUqD4Ki9a6sixwD3qMWyoWMJpSXlYY6vM=
X-Gm-Gg: ASbGncuzJh3jk31jcj74r0+cytjV1grHQTWO2A0igEvQf7tpTvUnvjjMcQddI4dfrdS
	pm/erX4yRyCuVWlnwzuMiNaiLtip1F+LR+J5jXTctVQBDQhg4VHc0WE+CcoLtt9xgAgn0TyJ/qm
	XWmMKUlV5pWD+c2WKZDcAs6dALaO5eIcGSBhV22/CXbepZ8JLtBGz/BRlUYVbGwjwGwjtGwh6fb
	JR5dtn/xwIYJ//uMdO3oGEM3suJ5lAFWrFJsfVLv52MVVxVbblXRrGlp94rzlyy5ZQKjAqeN6tF
	16ST+B6h5qquifcp/6IBd39VxF109w/dw5Pit5P0oEMGHKF3IVZo25XmKNR7XCjLZfVH8B14Tlo
	arbjxdgT4C+TAf00EK1mxenxNnsb++GSEi1DeTOZ4FXfuzQzouUM=
X-Google-Smtp-Source: AGHT+IFh/uBlLQN+Z64/3NY4nlJ9THrCXhkwHJPZh1q+BGnbJDaVlEFVI0umfFifgHpYECE5AHRbLA==
X-Received: by 2002:a17:903:1b2e:b0:24b:270e:56c7 with SMTP id d9443c01a7336-268119b2a8fmr20448045ad.7.1758101325500;
        Wed, 17 Sep 2025 02:28:45 -0700 (PDT)
Received: from localhost.localdomain ([193.246.161.124])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-25f4935db09sm137047885ad.61.2025.09.17.02.28.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 17 Sep 2025 02:28:45 -0700 (PDT)
From: Lei Chen <lei.chen@smartx.com>
To: Sean Christopherson <seanjc@google.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Ingo Molnar <mingo@redhat.com>,
	Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	x86@kernel.org,
	"H. Peter Anvin" <hpa@zytor.com>
Cc: kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH RESEND v1 3/3] KVM: x86: remove comment about ntp correction sync for
Date: Wed, 17 Sep 2025 17:28:24 +0800
Message-ID: <20250917092824.4070217-4-lei.chen@smartx.com>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20250917092824.4070217-1-lei.chen@smartx.com>
References: <20250917092824.4070217-1-lei.chen@smartx.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Since vcpu local clock is no longer affected by ntp,
remove comment about ntp correction sync for function
kvm_gen_kvmclock_update.

Signed-off-by: Lei Chen <lei.chen@smartx.com>
---
 arch/x86/kvm/x86.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index d526e9e285f1..f85611f59218 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -3399,9 +3399,7 @@ uint64_t kvm_get_wall_clock_epoch(struct kvm *kvm)
 /*
  * kvmclock updates which are isolated to a given vcpu, such as
  * vcpu->cpu migration, should not allow system_timestamp from
- * the rest of the vcpus to remain static. Otherwise ntp frequency
- * correction applies to one vcpu's system_timestamp but not
- * the others.
+ * the rest of the vcpus to remain static.
  *
  * So in those cases, request a kvmclock update for all vcpus.
  * The worst case for a remote vcpu to update its kvmclock
-- 
2.44.0


