Return-Path: <kvm+bounces-9868-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 2BD568678BA
	for <lists+kvm@lfdr.de>; Mon, 26 Feb 2024 15:37:38 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 84380B21E75
	for <lists+kvm@lfdr.de>; Mon, 26 Feb 2024 14:37:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9E22412E1DC;
	Mon, 26 Feb 2024 14:34:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="fLpuLN5Y"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f181.google.com (mail-pl1-f181.google.com [209.85.214.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7B66D12DDA7;
	Mon, 26 Feb 2024 14:34:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708958091; cv=none; b=G8Q24qjqpqJb3uphXW64DfCV86gs3vfgbGLycCEs9Z2pRp/WAVu2fDbfC5AJ0sNr2eNsEv5vKOZH8xfzXGEfKnyc2352C1c8NelbGegAPBtTgF5PeKVRKP1ollvEn696sfAiNIisfT8aummpfnHiRez1t+I2BuusW/yLPH0FDmE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708958091; c=relaxed/simple;
	bh=4HJibg4PRRsH779ixU3qdR/j6+N7s9KUuHflN06BYVE=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=kwH613FYU1TfP8QvMNpEFB4kwxyDIyp4PMOpaGvKuqqdfRG4Fx5nhMYXDgYHK/yPEyj12LkoGhMSkLci1rdZgLVOqWuIf25P62QLfKBW9X2cu9BoUL0SOOz34WCkRbHNhYdy4RalKFvDcjKywVSpYHJw711tGf5ZYcLYTt7YWUs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=fLpuLN5Y; arc=none smtp.client-ip=209.85.214.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pl1-f181.google.com with SMTP id d9443c01a7336-1dbae7b8ff2so13449745ad.3;
        Mon, 26 Feb 2024 06:34:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1708958090; x=1709562890; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=N6gafMeoopfCc4UbDX3euhZiN9XGBKerCw9yP6s1L8E=;
        b=fLpuLN5YPeVGiwK5UeCYQxya43W8RxIHHfDVvxgz+BoRQds1rpDTFpYhmXymaNSIYr
         xzA9ggF6BvBYt/iOdNNw0x/uMJtpdNWmYubKpsortDKojCHKxeeB/y9i8wtuhwm/UroH
         P8CL/1ihRyyx1/gmIFA3tKSqZGBjDx/1oMyhD7v9J048x33prCLqh6fx07kSO5Gk2shF
         67QRqro6ZBCV0WJez6slaqqN4HKtuMpVzDa0xcQ69MwsfJtiVSEbsnOv2ggYSCf3AHQN
         NGPqgGxuBUBHRTLNFcRC9yns+9RgEj3CrXEWDcNL//L5RLZMJhLJEB+B0yfikPce23xx
         qpaQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1708958090; x=1709562890;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=N6gafMeoopfCc4UbDX3euhZiN9XGBKerCw9yP6s1L8E=;
        b=bzhfai4SKTfxx7B2m6m+vEbEetOiV87dPkuGK7ui2Mlp8n53Bo4DIFj1cfKsX5G2LJ
         jaOgoEjZYIwXFUD89cKUxaUVEHR4nmv1PcrDpis783aiuD4kU9dI81yaM5uG9y+yXiJ1
         wg4i6lTPnjobXAYqK+T6Mo59N2NKS59GBha/6Dei3nkyn+cT0j9u/YvUxZtsXJnFTQAv
         fgHl5Ve/YEWm5PLMyCZ76DRd2FDN9hvf4HvYVJk4mIL7i43HGhC9Dy6/xPA4brEEo1Bm
         SC6dyVdEXCwohVNNAl/J3/Gay0E57th2R3OfAFmC5CkCZGJSZ8zNUl6nxTEaK6aB3e/M
         zXDw==
X-Forwarded-Encrypted: i=1; AJvYcCVu7J7XSv002Fgg/PTwXHrvz2KTriQLkGAJLEgDoWqA081jyitj8yMBOkcr4P56TQhWk778VrjESjiTGxRXIVce0F+8
X-Gm-Message-State: AOJu0YwJug6K7hZ10FNuDazDi7fgr40FS//zHjQcRgKRu/oqHoUioST3
	AUSSb+2bndnuf9g+7UboLHbMe8ITX8xcH6pOy3PW5MR1GKi+JXZA440VsztP
X-Google-Smtp-Source: AGHT+IHPKYBy1wnyWdMqd8xjPMLrgijiqpGjuWnco7MDJmuvAkez4009E+wiByi32zY+jmJ4vFFMLA==
X-Received: by 2002:a17:903:249:b0:1d7:5d88:f993 with SMTP id j9-20020a170903024900b001d75d88f993mr7022274plh.41.1708958089624;
        Mon, 26 Feb 2024 06:34:49 -0800 (PST)
Received: from localhost ([47.254.32.37])
        by smtp.gmail.com with ESMTPSA id e6-20020a170902cf4600b001dcb18cd22esm534802plg.141.2024.02.26.06.34.49
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 26 Feb 2024 06:34:49 -0800 (PST)
From: Lai Jiangshan <jiangshanlai@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Lai Jiangshan <jiangshan.ljs@antgroup.com>,
	Hou Wenlong <houwenlong.hwl@antgroup.com>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Peter Zijlstra <peterz@infradead.org>,
	Sean Christopherson <seanjc@google.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Borislav Petkov <bp@alien8.de>,
	Ingo Molnar <mingo@redhat.com>,
	kvm@vger.kernel.org,
	Paolo Bonzini <pbonzini@redhat.com>,
	x86@kernel.org,
	Kees Cook <keescook@chromium.org>,
	Juergen Gross <jgross@suse.com>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	"H. Peter Anvin" <hpa@zytor.com>
Subject: [RFC PATCH 05/73] KVM: x86: Set 'vcpu->arch.exception.injected' as true before vendor callback
Date: Mon, 26 Feb 2024 22:35:22 +0800
Message-Id: <20240226143630.33643-6-jiangshanlai@gmail.com>
X-Mailer: git-send-email 2.19.1.6.gb485710b
In-Reply-To: <20240226143630.33643-1-jiangshanlai@gmail.com>
References: <20240226143630.33643-1-jiangshanlai@gmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Lai Jiangshan <jiangshan.ljs@antgroup.com>

For PVM, the exception is injected and delivered directly in the
callback before VM enter, so it will clear
'vcpu->arch.exception.injected'.  Therefore, if
'vcpu->arch.exception.injected' is set to true after the vendor
callback, it may inject the same exception repeatedly in PVM. To address
this, move the setting of 'vcpu->arch.exception.injected' to true before
the vendor callback in kvm_inject_exception(). This adjustment has no
influence on VMX/SVM, as they don't change it in their callbacks.

No functional change.

Signed-off-by: Lai Jiangshan <jiangshan.ljs@antgroup.com>
Signed-off-by: Hou Wenlong <houwenlong.hwl@antgroup.com>
---
 arch/x86/kvm/x86.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 1a3aaa7dafae..35ad6dd5eaf6 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -10137,6 +10137,7 @@ static void kvm_inject_exception(struct kvm_vcpu *vcpu)
 				vcpu->arch.exception.error_code,
 				vcpu->arch.exception.injected);
 
+	vcpu->arch.exception.injected = true;
 	static_call(kvm_x86_inject_exception)(vcpu);
 }
 
@@ -10288,7 +10289,6 @@ static int kvm_check_and_inject_events(struct kvm_vcpu *vcpu,
 		kvm_inject_exception(vcpu);
 
 		vcpu->arch.exception.pending = false;
-		vcpu->arch.exception.injected = true;
 
 		can_inject = false;
 	}
-- 
2.19.1.6.gb485710b


