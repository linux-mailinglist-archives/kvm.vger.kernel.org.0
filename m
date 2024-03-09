Return-Path: <kvm+bounces-11454-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 30DDE877281
	for <lists+kvm@lfdr.de>; Sat,  9 Mar 2024 18:49:58 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 6B6DB1C2132D
	for <lists+kvm@lfdr.de>; Sat,  9 Mar 2024 17:49:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5A48D249ED;
	Sat,  9 Mar 2024 17:49:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wanadoo.fr header.i=@wanadoo.fr header.b="fBqUOdLc"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.smtpout.orange.fr (smtp-28.smtpout.orange.fr [80.12.242.28])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3504EBA4D
	for <kvm@vger.kernel.org>; Sat,  9 Mar 2024 17:49:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=80.12.242.28
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710006589; cv=none; b=cykqc/wBIW7t3Z8GRBEMRzgItSAM/Km1VLaNVPZhdAfzjt6JnZDzTdmRgldAu75sVgd9KmamFWVQxdt1y7ldC89hvOhIHhP+ygSxtR0XUEHXVZaHN3iYrZNR7SKlLyTnq5QZILRYEtO/peUm60sytABE3vN6DoHADI4zCNeC8K4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710006589; c=relaxed/simple;
	bh=ak74sgUl+aMNO+lsUKmolXguWnH/yTGMWgBb6ApRz8g=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=oKsPR+gOmKIOMt3W86zLbYzGsQPh/H0Su5DH2+RdVjcPAh1pFalRh5hY6FLYXGUF6wKxe/01KmWs7EltAkelQ1XS59bFBIKBI8rodgUp+5Yo6FeLRsXTEXKS6Of55uYtRfBBp8bXOjRIjZCMmUbZ0clnce7YhAfBqn+y8noDww8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wanadoo.fr; spf=pass smtp.mailfrom=wanadoo.fr; dkim=pass (2048-bit key) header.d=wanadoo.fr header.i=@wanadoo.fr header.b=fBqUOdLc; arc=none smtp.client-ip=80.12.242.28
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wanadoo.fr
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wanadoo.fr
Received: from fedora.home ([92.140.202.140])
	by smtp.orange.fr with ESMTPA
	id j0Idrpm7o3j4bj0IdrdmP9; Sat, 09 Mar 2024 18:15:58 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=wanadoo.fr;
	s=t20230301; t=1710004558;
	bh=twgFwiWdCdGqs18zIHruAf9EVb8e90jI3WiOBiux4bk=;
	h=From:To:Subject:Date:Message-ID:MIME-Version;
	b=fBqUOdLc/4+MFbFoxiZPHXzi2P2f5lifzbjAygl1kUrlkFzffsFX/9Lu1vDnuIB2D
	 KeUgqCxTTQDz1Y3CFVrbwL3qiRzR5iP2bnE0MyD01L2MMn76KmgxMzAlj7PPW4ySJG
	 yo1uMbZoI1246YMwi4ORWmdHycakc8GYyIHNo2hs2PqjAWMFMjQAYWUPYhfAImmWh6
	 RbW8oiU7jGzyi0MLJtYV7yf0ySSZb56/FqcZ2gP1Ct0Aqy/Rhr2wFP7xR3wN+rSqQ0
	 kx08y9GgKyxXyMuj8SULQGXCsuh8kYlC942CTQRi0XumF03uL8aVtz9iNeYxqnusst
	 IJwauTyteHjhQ==
X-ME-Helo: fedora.home
X-ME-Auth: Y2hyaXN0b3BoZS5qYWlsbGV0QHdhbmFkb28uZnI=
X-ME-Date: Sat, 09 Mar 2024 18:15:58 +0100
X-ME-IP: 92.140.202.140
From: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
To: Sean Christopherson <seanjc@google.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Ingo Molnar <mingo@redhat.com>,
	Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	x86@kernel.org,
	"H. Peter Anvin" <hpa@zytor.com>
Cc: linux-kernel@vger.kernel.org,
	kernel-janitors@vger.kernel.org,
	Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
	kvm@vger.kernel.org
Subject: [PATCH] KVM: SVM: Remove a useless zeroing of allocated memory
Date: Sat,  9 Mar 2024 18:15:45 +0100
Message-ID: <c7619a3d3cbb36463531a7c73ccbde9db587986c.1710004509.git.christophe.jaillet@wanadoo.fr>
X-Mailer: git-send-email 2.44.0
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Depending of the memory size needed, we clear or not the allocated memory.
This is not consistent.

So remove the zeroing of the memory in the __vmalloc() case.

Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
---
This is just a guess.

I don't know this code at all, but because of KVM, it is maybe safer to
clear the memory in both cases?
So, maybe it is better to use kzalloc() in the other path.
---
 arch/x86/kvm/svm/sev.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index 722186601c03..afd9485bef5a 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -434,7 +434,7 @@ static struct page **sev_pin_memory(struct kvm *kvm, unsigned long uaddr,
 	/* Avoid using vmalloc for smaller buffers. */
 	size = npages * sizeof(struct page *);
 	if (size > PAGE_SIZE)
-		pages = __vmalloc(size, GFP_KERNEL_ACCOUNT | __GFP_ZERO);
+		pages = __vmalloc(size, GFP_KERNEL_ACCOUNT);
 	else
 		pages = kmalloc(size, GFP_KERNEL_ACCOUNT);
 
-- 
2.44.0


