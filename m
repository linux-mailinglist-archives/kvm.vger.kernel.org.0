Return-Path: <kvm+bounces-55715-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 2F847B35066
	for <lists+kvm@lfdr.de>; Tue, 26 Aug 2025 02:41:51 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 0B9D7177F93
	for <lists+kvm@lfdr.de>; Tue, 26 Aug 2025 00:41:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0FFD82C15BC;
	Tue, 26 Aug 2025 00:40:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="R0qYleyY"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f202.google.com (mail-pl1-f202.google.com [209.85.214.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7CB3229B78D
	for <kvm@vger.kernel.org>; Tue, 26 Aug 2025 00:40:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756168824; cv=none; b=qRiX9xLitGmsxOhX15gSKseI9eiWa15Auie6EYoryZmuNsZRp0YO0TnOhR8mra8Xy8aGzJ/UKkz07o25dtyd4Y10qhUfVeWyxm+5+u9DqsHTHVCq65+mP78zBW0j4FRblA58LTAwqhImO1IO65JuMh51+ouNlpHMzUKUveLepLs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756168824; c=relaxed/simple;
	bh=GSD2okLRLxrD4e5YapBpGLuGmP9plExtQIHqvDp2aik=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=af6w/xon/uVvgHEC/yPbDmLcLLkLbo6Mncjumts7931Ys8kUbrcW+w13qBk4T1OymVTpkoNHO2XwOxTVUBRlZc3Z/GktYZc0l8haBjFVNUGYzjKDRHJ6NvfFAwu2b8GDtB1unKRqHUhdkMo9iiQHaCxPcSLJOPLUKNH4P6eHQFo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=R0qYleyY; arc=none smtp.client-ip=209.85.214.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pl1-f202.google.com with SMTP id d9443c01a7336-246364842e7so84762265ad.1
        for <kvm@vger.kernel.org>; Mon, 25 Aug 2025 17:40:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1756168821; x=1756773621; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=Ich+F/WfOl90g4mC/WhzhSp8nc7SXERneaucsAgJ2BU=;
        b=R0qYleyYg9l/UXt6sCk5R8VMWSzWwLUFkwpifLvLNJvVRWZzydXFJQs8B0sfRJ1PV3
         0MEHY+s4va/3gBCAKA5MIs7i3kNcW0j/JSYVGmS2LWCt5urGYRBZMZs3QbhcS/xD4Y8X
         /wuI+Wd519AlRbzkADR1eHAk+u6dk0VpRITSsfVWItsbqKzuXjOsoukgCaYROLkljph2
         owsv+QU0fbFOuDEJcFTXdFn2q09Ire2QqGI8tfpPSu9I/w/2wgrdUt95daY8tAqn6+6e
         GjjD8KAhBcC46l2Js2oe81PZlwWsxG4AYTV6gaPmvuoGpRlo1NaTYU1vzuO+7sKB7M23
         qSvw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756168821; x=1756773621;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Ich+F/WfOl90g4mC/WhzhSp8nc7SXERneaucsAgJ2BU=;
        b=WCP/tXvNdsJvwQtgj0P9evl1Ya1NvIdxqDQvNAoiU6N+QUOo8vM2a+qvxePFKRlXTk
         nXUgbQeSA33WpGVN6CghYFYLtxhzpJzI2dqE1eJAnJbakppybDrvDdVgo63rbBCRo/Mp
         R3XAlxAJnlyv9IeTzAKMK+d48Z83ZUaovcEtKspoWfzi2XKRWTeBhU21KPaCPisyqbFV
         6NxRGCDFInrWAe4VSlYBFZ0PGNSOcz5yApidPfOH5EtzLaBh1BDITP7OvL7Z4t/3CwGl
         c4XzIvFVKZZ/y4jT+yo7OIvcqMGMS3ZKfBeeb1h/vcAqpzeN3fkJkkL/rw+vmv6aT6tq
         zJ9Q==
X-Gm-Message-State: AOJu0YzT4w/dphaCMaR3esDrUL/KPIp29MvbOAVH4njmFqNUHW8F9KmB
	wxuo8+FRCNOE2FPLXId6BlvP/hdtW9gD+jGdc0wuzsaztaLT/gXvBA9juK12ReodsKYREK6Sj5z
	y3iz6lQ==
X-Google-Smtp-Source: AGHT+IG4vW/5MigHa/TBX8oRMlCra808eIipbqtMQjYVG19uVixcDoW82lYMlF7bL879fI0AObWue9cr2PY=
X-Received: from pjyr7.prod.google.com ([2002:a17:90a:e187:b0:312:ea08:fa64])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:903:1a45:b0:246:ddd6:f8b9
 with SMTP id d9443c01a7336-246ddd6fd04mr66484515ad.43.1756168820938; Mon, 25
 Aug 2025 17:40:20 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Mon, 25 Aug 2025 17:40:11 -0700
In-Reply-To: <20250826004012.3835150-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250826004012.3835150-1-seanjc@google.com>
X-Mailer: git-send-email 2.51.0.261.g7ce5a0a67e-goog
Message-ID: <20250826004012.3835150-4-seanjc@google.com>
Subject: [PATCH 3/3] KVM: x86/mmu: Don't register a sigkill callback for NX
 hugepage recovery tasks
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>, 
	"Michael S. Tsirkin" <mst@redhat.com>, Jason Wang <jasowang@redhat.com>
Cc: kvm@vger.kernel.org, virtualization@lists.linux.dev, 
	netdev@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Content-Type: text/plain; charset="UTF-8"

Don't register a sigkill callback with vhost_task when creating NX hugepage
recovery threads now that said callback is optional.  In addition to
removing what is effectively dead code, not registering a sigkill "handler"
also guards against improper use of vhost_task_wake().

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/mmu/mmu.c | 7 +------
 1 file changed, 1 insertion(+), 6 deletions(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index d11730467fd4..dd90cf8a8170 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -7677,10 +7677,6 @@ static void kvm_recover_nx_huge_pages(struct kvm *kvm)
 	srcu_read_unlock(&kvm->srcu, rcu_idx);
 }
 
-static void kvm_nx_huge_page_recovery_worker_kill(void *data)
-{
-}
-
 static bool kvm_nx_huge_page_recovery_worker(void *data)
 {
 	struct kvm *kvm = data;
@@ -7713,8 +7709,7 @@ static int kvm_mmu_start_lpage_recovery(struct once *once)
 	struct vhost_task *nx_thread;
 
 	kvm->arch.nx_huge_page_last = get_jiffies_64();
-	nx_thread = vhost_task_create(kvm_nx_huge_page_recovery_worker,
-				      kvm_nx_huge_page_recovery_worker_kill,
+	nx_thread = vhost_task_create(kvm_nx_huge_page_recovery_worker, NULL,
 				      kvm, "kvm-nx-lpage-recovery");
 
 	if (IS_ERR(nx_thread))
-- 
2.51.0.261.g7ce5a0a67e-goog


