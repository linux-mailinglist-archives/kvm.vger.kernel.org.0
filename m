Return-Path: <kvm+bounces-28351-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 6D419997590
	for <lists+kvm@lfdr.de>; Wed,  9 Oct 2024 21:25:52 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 02A4C1F237E4
	for <lists+kvm@lfdr.de>; Wed,  9 Oct 2024 19:25:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9897B1E261A;
	Wed,  9 Oct 2024 19:23:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="DVYWPHMc"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f201.google.com (mail-pg1-f201.google.com [209.85.215.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6D4571E22F8
	for <kvm@vger.kernel.org>; Wed,  9 Oct 2024 19:23:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728501835; cv=none; b=n+2VTVXMJgG/lsCO2D3nqH/KNiGNLyMqdGxgCDa5NHUtD12d4lc5z34FQlVR6bVqEGCBoar2VbXIUbHnnCX5fxVGIWUqfcSN4kCw5lLocSN5zuCK4v7+w/HeiOKlFMHKYtmXkJtwZPJkr2NUPiPx2FqeIlT7S/MXIPkjgnCIb98=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728501835; c=relaxed/simple;
	bh=i1AfRS5ndMXdqtCSQluoP1BVzX/y9mDGJV2x5I9dvrk=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=HUqrDleKxIP2lsJgoEAkn5//dr7u/h06EZrzAcAEOM4y7URrhDZZhxu4GBPmsW6B49AwaPj7iFm0RKt6JwehQ75qiMpT2Hk4cIfyNOgEEzpIsK+Qtyx8rbXLMBDozkEpYM5LwS/rwxXfY0VFB/cgJy62roW7KzvMmMIZ8hHCPM8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=DVYWPHMc; arc=none smtp.client-ip=209.85.215.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pg1-f201.google.com with SMTP id 41be03b00d2f7-5e4df21f22dso213913a12.0
        for <kvm@vger.kernel.org>; Wed, 09 Oct 2024 12:23:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1728501834; x=1729106634; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=i9BdalRrINJVrDcrtezLTinwXxj+SPewGxzSEbZM+70=;
        b=DVYWPHMcgr3JY2kq13sSYz2oBipEHg8tcrEXVGQKjdH0jizU7rp9g0/wbaRdyG/S2V
         28fUE0aY8zZaBnKzfiyGwKNXaqWNGNCXLzSwvnUfMqYipBh0VnifuFBI9bkOKiqvDh49
         rbKMXeUGI8YPq1kC4zGbZ+52ejP52V93IreckftUuDwWmMunYKYiBFydhgLjJusWXzv9
         Prn3qo5VriiEkRS7xPdhQVM+Vwol9ZkpR6MZejDQYEvtqkfby1dBEX9cErPOledlRNT5
         +kigCtEcJ5vZVWMc+R/j3L4EZWEpDlsxVcVp59C1gldC3P76PFw/x2Iv5X90VLOeCKAK
         7snQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1728501834; x=1729106634;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=i9BdalRrINJVrDcrtezLTinwXxj+SPewGxzSEbZM+70=;
        b=thLaXcPE+uwJiH/kVccQSGKpdXpsSjyoKEA6fsw2njoZtXmgG1hhKghSby6/B+qzbP
         fi6vkeEjVLBQ/T7ZKzUkvn0Jjmct+TTMfeKRaRTi3aFumzRMZGq7PYoRvcpwVZtgUsoA
         vXdZU2uctsJdGyttPZMyLasOR0yZQ5wBahOVx7LcYM7PL0rh6c5md9XvHKFarik+P31v
         Em+JFetGygM8X/lAKqppyuk8+K4OtBktWTxJfbd5BkWpGjas94VQBKcuMg3uI4ydEEsE
         Jh4zMdpsJcNGG9DAbQ9GA41EV3mBHn2fb+ao8bYVlSiutVHL4MUf5bs2U6gAYjMEdzYI
         NpYg==
X-Gm-Message-State: AOJu0YyZQW3nBo0QzKK2N/hF8t5/ZLDR8pJnNUKOGLbyLJU9DbxzqQ/6
	ccmt1q/whwCk1rpv4ijYSkRk5P32pT/rr0kwQpZz6euKDVa02v5zD8nWVZ/8DfWS8Kd0quJ/tEH
	rRQ==
X-Google-Smtp-Source: AGHT+IGdx+V3bQgWDNAJK6Wy1vX01P4om5Fw6X1AQADID6XkrRPdfHX3uXvEWSRXRAwVh5niEzh7Nqh+YL4=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:9d:3983:ac13:c240])
 (user=seanjc job=sendgmr) by 2002:a63:b208:0:b0:7a1:6a6b:4a5b with SMTP id
 41be03b00d2f7-7ea3f892d1cmr649a12.2.1728501833564; Wed, 09 Oct 2024 12:23:53
 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Wed,  9 Oct 2024 12:23:45 -0700
In-Reply-To: <20241009192345.1148353-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20241009192345.1148353-1-seanjc@google.com>
X-Mailer: git-send-email 2.47.0.rc1.288.g06298d1525-goog
Message-ID: <20241009192345.1148353-4-seanjc@google.com>
Subject: [PATCH 3/3] KVM: x86: Clean up documentation for KVM_X86_QUIRK_SLOT_ZAP_ALL
From: Sean Christopherson <seanjc@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>, Sean Christopherson <seanjc@google.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Yan Zhao <yan.y.zhao@intel.com>
Content-Type: text/plain; charset="UTF-8"

Massage the documentation for KVM_X86_QUIRK_SLOT_ZAP_ALL to call out that
it applies to moved memslots as well as deleted memslots, to avoid KVM's
"fast zap" terminology (which has no meaning for userspace), and to reword
the documented targeted zap behavior to specifically say that KVM _may_
zap a subset of all SPTEs.  As evidenced by the fix to zap non-leafs SPTEs
with gPTEs, formally documenting KVM's exact internal behavior is risky
and unnecessary.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 Documentation/virt/kvm/api.rst | 16 +++++++++-------
 1 file changed, 9 insertions(+), 7 deletions(-)

diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
index e32471977d0a..edc070c6e19b 100644
--- a/Documentation/virt/kvm/api.rst
+++ b/Documentation/virt/kvm/api.rst
@@ -8098,13 +8098,15 @@ KVM_X86_QUIRK_MWAIT_NEVER_UD_FAULTS By default, KVM emulates MONITOR/MWAIT (if
                                     KVM_X86_QUIRK_MISC_ENABLE_NO_MWAIT is
                                     disabled.
 
-KVM_X86_QUIRK_SLOT_ZAP_ALL          By default, KVM invalidates all SPTEs in
-                                    fast way for memslot deletion when VM type
-                                    is KVM_X86_DEFAULT_VM.
-                                    When this quirk is disabled or when VM type
-                                    is other than KVM_X86_DEFAULT_VM, KVM zaps
-                                    only leaf SPTEs that are within the range of
-                                    the memslot being deleted.
+KVM_X86_QUIRK_SLOT_ZAP_ALL          By default, for KVM_X86_DEFAULT_VM VMs, KVM
+                                    invalidates all SPTEs in all memslots and
+                                    address spaces when a memslot is deleted or
+                                    moved.  When this quirk is disabled (or the
+                                    VM type isn't KVM_X86_DEFAULT_VM), KVM only
+                                    ensures the backing memory of the deleted
+                                    or moved memslot isn't reachable, i.e KVM
+                                    _may_ invalidate only SPTEs related to the
+                                    memslot.
 =================================== ============================================
 
 7.32 KVM_CAP_MAX_VCPU_ID
-- 
2.47.0.rc1.288.g06298d1525-goog


