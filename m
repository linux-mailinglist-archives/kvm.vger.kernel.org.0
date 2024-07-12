Return-Path: <kvm+bounces-21520-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 0EBDE92FD51
	for <lists+kvm@lfdr.de>; Fri, 12 Jul 2024 17:14:26 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id ACDB91F20F9C
	for <lists+kvm@lfdr.de>; Fri, 12 Jul 2024 15:14:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AB18E175563;
	Fri, 12 Jul 2024 15:13:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="VAaIEFTp"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f201.google.com (mail-pg1-f201.google.com [209.85.215.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8D3221741FA
	for <kvm@vger.kernel.org>; Fri, 12 Jul 2024 15:13:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720797223; cv=none; b=fg6ySMxQsBESNO1HXJSAOGX6ymkZojjaWUA7StmaJ+EjDZJRejR1KufT2DxT1VEhiNFYoEGQgDJ0zpdf4xEOMmIkI0LvhQIAnUZUzak7eoXEjegEMidzBmF5587eJb32z8uotaM+T/ZgpwOAQl63xUh0MG+MJqHdwWok4WgrlPI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720797223; c=relaxed/simple;
	bh=BUzUp5RWHqaySVY5+BeOJD2jf/JigFe4Y+aXQC4Sk6g=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=M+ZvFKryl4pIlnCSiS1YWy++RET0J7ospyi15IAjmBX+HneorNfmBafgYdhRvFBhAOJc5+RjIqtuGcFWH935yytclyqb7uPPfgpkrUwdN3y0TUt12bD6YtOsnesXEDWVd7oY78FC8uO8Qm5aTT2/n8KjjB2aEzTSHCiFC64i2to=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=VAaIEFTp; arc=none smtp.client-ip=209.85.215.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pg1-f201.google.com with SMTP id 41be03b00d2f7-78006198b43so1589086a12.0
        for <kvm@vger.kernel.org>; Fri, 12 Jul 2024 08:13:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1720797222; x=1721402022; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=xhil9fMKdOmNNY/hw6eHjeaj/nT3knlY7TdVcvRm4IE=;
        b=VAaIEFTp18j1yt0awEGjyi3hVxwnrmekeh8nwZ33E41yTegnnGTu5Is9jw3CT3TkEy
         hhiZSqog1H4YvrNTFi95rXfxmkgPOvMS+urUpMd4/DUOFh6NGMORvO2ZpBlsdkdc7hDQ
         xsdAzng7vU5ON1R1APCiraC2kcf2JKc/vF/0NO+UwIGtnRMEghjy7s06zD81J84qva9F
         6+8SSl93aa2TIMQR4Lic9S69I/uP+upeyTWmVfPHc0iGNATNdd/yys5PyfoOoNAMHp2n
         2y1lIDd8ILA8OGh9HaSEBibPmL176bHlG4Q4waBr8YZsHsXB4HmjjBO1wjZaF+kBA+C4
         0JvQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1720797222; x=1721402022;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=xhil9fMKdOmNNY/hw6eHjeaj/nT3knlY7TdVcvRm4IE=;
        b=P0UR9q1NBXtklkeU5PmpU2N5P+R0FDIDpbREgavMhcR2aalMlxsEzFELj9IHmsyT/O
         dopbc/pwK+UVrnjjoWx4MQT0FxaB6wZyFTK9mXDK3u7yG6g68b6zhYcHfgtKBO7Cv1pe
         TVWIgSrR7Ne45s0XRnfdr8w9DrGJq3+m3MNuOv0udQ08RP9qx7r7WMyoN+vXrVkVc4XV
         vJDv1edW9acU09hRUJvaiZ2Fnh/QEWPoRsBgkg+5AV2Fw+inIgFD40mWj+Gr9NAlTVL2
         9QHLiYSXoZLDSpOFOgD1naDg8Rdu5+C2iV6WWBQYJPoGV0vZEuG/GK5fTIGnV6qXKviU
         Fg1g==
X-Gm-Message-State: AOJu0YxHmqslJ5BkhWlRXxpjfnikgPEdDl/fzYLJPwxUCKHUlz8IlGcV
	FMRDbWwn8iTC1V+Wsw3aAius7frf1st7ywAouOYsAN42DrhJmjcXXRSUzBcjbFweFKv9IaOa22W
	omQ==
X-Google-Smtp-Source: AGHT+IHuT8K9rOPRCiT1msZ0/9yu35XkKU/imCLWZDOybsPwvXfpkO4uEj7EHjAiqcRPow2eblVNuQyIq1c=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a63:3759:0:b0:6e7:95d3:b35c with SMTP id
 41be03b00d2f7-77db673944fmr23291a12.5.1720797221803; Fri, 12 Jul 2024
 08:13:41 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Fri, 12 Jul 2024 08:13:35 -0700
In-Reply-To: <20240712151335.1242633-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240712151335.1242633-1-seanjc@google.com>
X-Mailer: git-send-email 2.45.2.993.g49e7a77208-goog
Message-ID: <20240712151335.1242633-3-seanjc@google.com>
Subject: [PATCH 2/2] KVM: x86/mmu: Clean up make_huge_page_split_spte()
 definition and intro
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	David Matlack <dmatlack@google.com>
Content-Type: text/plain; charset="UTF-8"

Tweak the definition of make_huge_page_split_spte() to eliminate an
unnecessarily long line, and opportunistically initialize child_spte to
make it more obvious that the child is directly derived from the huge
parent.

No functional change intended.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/mmu/spte.c | 8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)

diff --git a/arch/x86/kvm/mmu/spte.c b/arch/x86/kvm/mmu/spte.c
index bc55e3b26045..10390eecd85d 100644
--- a/arch/x86/kvm/mmu/spte.c
+++ b/arch/x86/kvm/mmu/spte.c
@@ -291,15 +291,13 @@ static u64 make_spte_executable(u64 spte)
  * This is used during huge page splitting to build the SPTEs that make up the
  * new page table.
  */
-u64 make_huge_page_split_spte(struct kvm *kvm, u64 huge_spte, union kvm_mmu_page_role role,
-			      int index)
+u64 make_huge_page_split_spte(struct kvm *kvm, u64 huge_spte,
+			      union kvm_mmu_page_role role, int index)
 {
-	u64 child_spte;
+	u64 child_spte = huge_spte;
 
 	KVM_BUG_ON(!is_shadow_present_pte(huge_spte) || !is_large_pte(huge_spte), kvm);
 
-	child_spte = huge_spte;
-
 	/*
 	 * The child_spte already has the base address of the huge page being
 	 * split. So we just have to OR in the offset to the page at the next
-- 
2.45.2.993.g49e7a77208-goog


