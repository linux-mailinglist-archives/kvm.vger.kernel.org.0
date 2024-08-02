Return-Path: <kvm+bounces-23148-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 4B0739464A2
	for <lists+kvm@lfdr.de>; Fri,  2 Aug 2024 22:50:54 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 7578A1C2176B
	for <lists+kvm@lfdr.de>; Fri,  2 Aug 2024 20:50:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B1CE9130E4B;
	Fri,  2 Aug 2024 20:50:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="xx0tKsh8"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yb1-f202.google.com (mail-yb1-f202.google.com [209.85.219.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 80D0D78C60
	for <kvm@vger.kernel.org>; Fri,  2 Aug 2024 20:50:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722631811; cv=none; b=HhQqjaFE7WmxHK7FTLnixk9nFUvt5a/tu1D1agjuYKUz1LBuT9y6NHTsTi1RIthtcrTpoEWJ5gv8J5+qQv0yuG1VVGyoJJXtKr7QKcOOy6kJoi6eQUgSh0T5MYP98U2KlKSZtR88WQ/pdXGm5WFp4PrWHWC3vhdC8/fe+/UB8wk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722631811; c=relaxed/simple;
	bh=+/UuIDHcRQ8bBgQBKufiTQ6/NBfl7hp7XC+v3gwl3TA=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=P1Y/573H/DX/t/+7l+LuGJq/nnJEy1monFF0lMT55u1yJAao5UnAaL83+dNUdQuEmlidvxYcjvjMVpQDru2j4/laV+xqhZQhQXL5XD0v0lorOybBB/FB2sbILb50Itd/KALNXB3f/h7QMsLSwOnf20t4LOsc01BLZE1R4GhqMfU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=xx0tKsh8; arc=none smtp.client-ip=209.85.219.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-yb1-f202.google.com with SMTP id 3f1490d57ef6-e035f7b5976so9622906276.0
        for <kvm@vger.kernel.org>; Fri, 02 Aug 2024 13:50:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1722631809; x=1723236609; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=vhgy4am0UvUSmvRzeDG6pp/0Zly8gx1T1Ec+frofWT0=;
        b=xx0tKsh8e+50cNuu6P6wuUE/Ded+CesEjVmTUyuWnSnPhGAXRUKY1TktSE+pagsYjo
         NM2ZFW5CB7criwjQMDMjsmP3NWJneMwhvBTTglGrwudMQbx8LsLVlcpd/OhTEJyXaQZD
         2JCflIkZ6i9QJCAwApZzrBSqR/byxVO+0aq0DW6+ieLYqwpNKlZpGkFBeByGofw7Je72
         XIhks/TazxLoMJJcJp8ne1H5heW2X+OQDXg+V3W0guIbuEp41JFgn7dbhJdFJtqd1DpL
         VD4EPFPwx8pvNjHJR2EbNByqfuEzlq1VOhKTd3mKgaWMhL0mOry8EQj98OSo3UjAd1zr
         Fw+Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1722631809; x=1723236609;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=vhgy4am0UvUSmvRzeDG6pp/0Zly8gx1T1Ec+frofWT0=;
        b=FwM9/rgeQLgaSx72M1wKfmNUt7vz7+6TpZTQQA03jg0hWZoy+G4JRxp0bbuUN6niCE
         Tfk3wiUr0RlLHjsWzpqz56IB95CxZsh7byI//Rf5ppaWMoGHRNLG0PNc866RqXSX1GXP
         lM/USwdc/wYI6sc21CyAop6PTa6X7F+ADkIGkhhgrOOSrPhV/uPACMwVAZh6EeUDXofB
         PTu2LevCyR4vwiLd7rtQ7w3Ja1crR7Vh4PHp6ORKe8P1ZOJao8YQy6uMUGAq5UUOgWjx
         cb3MWonZ0oRmXyvTjNMgCXqnRFwNbcoDE7rDwHHiGZPSA6x3DemQ66MMuaPdngAUnfTc
         Zw9Q==
X-Gm-Message-State: AOJu0Yw8YUjls9gSYw0USpIhhmd162NGF83JPybcKgDsTcwrrtkTtRBI
	09OPuH9tcnVrmgq5Rd0pRDXu3wHNhqugH9LSu9tUGS3kB/8UHfhf8/4M/46Q3jx1P2tggMQY7xl
	ULA==
X-Google-Smtp-Source: AGHT+IFaG/omRB7AizNm6kEMBOCZAmcvGUoqJ2zKlTWS8jxj1A+cn3Aj6JsUZ4pDJBVCXzSy0rcuzzTc+Cc=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a25:86:0:b0:e0b:a34d:f223 with SMTP id
 3f1490d57ef6-e0bd5b96ecemr44386276.5.1722631809493; Fri, 02 Aug 2024 13:50:09
 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Fri,  2 Aug 2024 13:49:59 -0700
In-Reply-To: <20240802205003.353672-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240802205003.353672-1-seanjc@google.com>
X-Mailer: git-send-email 2.46.0.rc2.264.g509ed76dc8-goog
Message-ID: <20240802205003.353672-3-seanjc@google.com>
Subject: [PATCH 2/6] KVM: Assert slots_lock is held in  __kvm_set_memory_region()
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

Add a proper lockdep assertion in __kvm_set_memory_region() instead of
relying on a function comment.  Opportunistically delete the entire
function comment as the API doesn't allocate memory or select a gfn,
and the "mostly for framebuffers" comment hasn't been true for a very long
time.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 virt/kvm/kvm_main.c | 10 ++--------
 1 file changed, 2 insertions(+), 8 deletions(-)

diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 0557d663b69b..f202bdbfca9e 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -1973,14 +1973,6 @@ static bool kvm_check_memslot_overlap(struct kvm_memslots *slots, int id,
 	return false;
 }
 
-/*
- * Allocate some memory and give it an address in the guest physical address
- * space.
- *
- * Discontiguous memory is allowed, mostly for framebuffers.
- *
- * Must be called holding kvm->slots_lock for write.
- */
 int __kvm_set_memory_region(struct kvm *kvm,
 			    const struct kvm_userspace_memory_region2 *mem)
 {
@@ -1992,6 +1984,8 @@ int __kvm_set_memory_region(struct kvm *kvm,
 	int as_id, id;
 	int r;
 
+	lockdep_assert_held(&kvm->slots_lock);
+
 	r = check_memory_region_flags(kvm, mem);
 	if (r)
 		return r;
-- 
2.46.0.rc2.264.g509ed76dc8-goog


