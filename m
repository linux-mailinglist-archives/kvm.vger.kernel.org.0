Return-Path: <kvm+bounces-37019-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 03800A24619
	for <lists+kvm@lfdr.de>; Sat,  1 Feb 2025 02:15:11 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 7C68C164C97
	for <lists+kvm@lfdr.de>; Sat,  1 Feb 2025 01:15:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 561C213BAEE;
	Sat,  1 Feb 2025 01:14:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="xvy1Evqo"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f201.google.com (mail-pl1-f201.google.com [209.85.214.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1913F84D0F
	for <kvm@vger.kernel.org>; Sat,  1 Feb 2025 01:14:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738372452; cv=none; b=BoA1kVk6AY4hS2JIMFyE5/5v2st0x7vKdqsjwsfSL14Bi1BUuxBUJ/SVLc8f9EIxqT9tsz1DywELZTBvixHozYYUq/rNxpJUdspKdfwKwG1hVHCy/bHbkYlKFoYmmxyMTHXLyGc8LKLuh/j9FCBZ95e82RYm/S+0yWKUaY81c6c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738372452; c=relaxed/simple;
	bh=nQ+kS3OisfJcraTufDITt8+LXlQftkTYQ+rT/BSf7qk=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=Q2KPCw0QNoUPPpjUXIXkxvbbKHK2XqxIHalB2XM+mx3qlxYbH/QkFUhaddUaQDwETl4gznBv8InQrD+U+ccdzp5vxc6a6MGPAM237yLGq8HOLgHxOtLtvv181EMwDU99AE6sEFYcKGKqR5taoOhjJ3agt+z0YbIcC4tZ76rUSFU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=xvy1Evqo; arc=none smtp.client-ip=209.85.214.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pl1-f201.google.com with SMTP id d9443c01a7336-2161d5b3eb5so50280985ad.3
        for <kvm@vger.kernel.org>; Fri, 31 Jan 2025 17:14:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1738372450; x=1738977250; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=LJrvKjeAKyqO/F6ebF2NAkHhUdXXGXXObzqZ1bzPsRo=;
        b=xvy1Evqoy9wvNjsgLqUCcYfVDBx4Qo7DRJtaVpPw6H9V0VrRTpeh5nmKSETDpaCXTB
         5xukqFXz2BSKPeiFMPwR6XPe1X8zdRd4Ttr+Q1uH6ABnuj8Q/g2IvgiDN57+0lWcLYHU
         +k2oyKC23llG3b8NIaC5v/f5NSps+we29/cZvHT6SHw8tPDtC3OGmX0zsUD167GMOxAG
         u/b0VxsDSH7QHVbbyjs+v3TFtfF5A0yW4hyDtfvk60ztaaLTVKHhjZzNN8ITIIOImawe
         QgEUQnOep3ou/u088aT2MZ3/pRtso3VFTWigm1+spklPc3TN+NXYQMii3tp9zmecihKn
         vb4g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1738372450; x=1738977250;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=LJrvKjeAKyqO/F6ebF2NAkHhUdXXGXXObzqZ1bzPsRo=;
        b=MBVyqwZFoYzThVR5sb26jtggvYsXwyGwJp865cDVivtZtqZVFswFYMy9W+UgCBXA0s
         OK3c8d6h5ckS1pAwg5AUSvC98XEalCBzPqRRgaiLEK2S47215/NwFuseZnXHXGXlFPhI
         oztSo55M7QY88diCOYbnsg6HflxebXNV3iB17Oo65Mr4oaxvD+9zcCStbrNKtM8bCU4U
         zgenLHVTsujRAyKwVRnOvHWthLbiLhXRXJYG0feG1C828BDtRp4rgbLjhIGJzf9ICzVL
         2srwO2USQ4wrZ9adXrNJIuduRbS4TclvL/D3z6VpPNTeUpi54V7V6lqa6Fij+9+5temi
         FVwg==
X-Gm-Message-State: AOJu0YxD6YD496aTImY1axb1vZuo52Ij5prmyFzuu3GmuCNUtBVE3Hni
	9NaXlb5oYbMYT0QgDtRn1h8gBgvIdCj6ETAX9ivLRMVCS8DxcboxQlFoW8fMWEmE6Al3GMUKCPm
	bTQ==
X-Google-Smtp-Source: AGHT+IEYlUfqd6A5Aj96yRwdP4ZObhFRmvU9ZVL70lUJyS5rZhH4M3tJR1haMPbVdKWzhFgSF0mEex6ADm4=
X-Received: from pjbse7.prod.google.com ([2002:a17:90b:5187:b0:2ea:61ba:b8f7])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:902:e5c9:b0:216:7cbf:951f
 with SMTP id d9443c01a7336-21dd7d82d98mr211620785ad.21.1738372450219; Fri, 31
 Jan 2025 17:14:10 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Fri, 31 Jan 2025 17:13:59 -0800
In-Reply-To: <20250201011400.669483-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250201011400.669483-1-seanjc@google.com>
X-Mailer: git-send-email 2.48.1.362.g079036d154-goog
Message-ID: <20250201011400.669483-5-seanjc@google.com>
Subject: [PATCH 4/5] KVM: x86/xen: Bury xen_hvm_config behind CONFIG_KVM_XEN=y
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>, 
	David Woodhouse <dwmw2@infradead.org>, Paul Durrant <paul@xen.org>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	syzbot+cdeaeec70992eca2d920@syzkaller.appspotmail.com, 
	Joao Martins <joao.m.martins@oracle.com>, David Woodhouse <dwmw@amazon.co.uk>
Content-Type: text/plain; charset="UTF-8"

Now that all references to kvm_vcpu_arch.xen_hvm_config are wrapped with
CONFIG_KVM_XEN #ifdefs, bury the field itself behind CONFIG_KVM_XEN=y.

No functional change intended.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/include/asm/kvm_host.h | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 5193c3dfbce1..7f9e00004db2 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1402,8 +1402,6 @@ struct kvm_arch {
 	struct delayed_work kvmclock_update_work;
 	struct delayed_work kvmclock_sync_work;
 
-	struct kvm_xen_hvm_config xen_hvm_config;
-
 	/* reads protected by irq_srcu, writes by irq_lock */
 	struct hlist_head mask_notifier_list;
 
@@ -1413,6 +1411,7 @@ struct kvm_arch {
 
 #ifdef CONFIG_KVM_XEN
 	struct kvm_xen xen;
+	struct kvm_xen_hvm_config xen_hvm_config;
 #endif
 
 	bool backwards_tsc_observed;
-- 
2.48.1.362.g079036d154-goog


