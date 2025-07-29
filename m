Return-Path: <kvm+bounces-53683-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 577F0B1557F
	for <lists+kvm@lfdr.de>; Wed, 30 Jul 2025 00:56:50 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 5184C7AEA33
	for <lists+kvm@lfdr.de>; Tue, 29 Jul 2025 22:55:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C74D1288C2B;
	Tue, 29 Jul 2025 22:55:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="w4EdbKiw"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f202.google.com (mail-pl1-f202.google.com [209.85.214.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7CD592874EA
	for <kvm@vger.kernel.org>; Tue, 29 Jul 2025 22:55:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753829736; cv=none; b=UiFH6QmZYxUterh6kdLRnSydFEIRMwmFZxFXLrXlYBH27ggAdq6N7Qs/46qJ+JVS12p89qiclHpNLylQhee73WBJjD2TnA9VDv27+2AyAAaw9+W5RyAuyp5OS07oZlHE125r1Up3SjlSnmcinIsUXB4UuuGX/BAl5pq1cH6bF9o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753829736; c=relaxed/simple;
	bh=WhA8GcOHwnrQQI7pcMt4+3KPgdAVeYE+NdluYFw+Lok=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=HAlZdOUzk1zkL6Aol/rF0+9fr23kDj+Ud2Iuhhx77Yo6nxDgwgrzWL8oI5bbYr3zEV39R0XAVBJQNvpVoGrK5UNGdqZakJs6jS9JZHdrc3+C5TIl+eGktqdD9wtLjT22FIwkIplQlHqXfQNCAz2sS6im0hut2rtX8VvibgYUVkM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=w4EdbKiw; arc=none smtp.client-ip=209.85.214.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pl1-f202.google.com with SMTP id d9443c01a7336-2400b28296fso40080395ad.1
        for <kvm@vger.kernel.org>; Tue, 29 Jul 2025 15:55:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1753829735; x=1754434535; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=LS+T/y+NsOpuW4oCoWoDJ8akduRknfqoGYJRkz33V1U=;
        b=w4EdbKiwW9b3JXJJfV3fmWB98ohg2hmCaxRfHcOPGsYLslOdqvDbhGJb0mfA3B5KSR
         TGYlBTNUmh/xQfwtOmuLnZLTfC5bxueahgOkiS+KzkWoiHWrUcNv3yX6jFYFqsiDR7gX
         fOD7G+GpVJ6RpVb8Z4UADjYurvFz1NyjJRnablTFXAEwedKjTd930H5fcyLJCaVsCuKy
         rsACzgIcVffPE8TcBBwFuvFvb1uXxNDsvS/Q3B1ZlvNbrC116kebSSwZ7REmhPxY8J+6
         PNzwNsjQolW3iBwV0yA+3Q2CB18DmS/RkJLiLGy/FJSovLJG4JWA3q9GONhigdj37/vt
         /Eeg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753829735; x=1754434535;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=LS+T/y+NsOpuW4oCoWoDJ8akduRknfqoGYJRkz33V1U=;
        b=VgvDWz+54wA9t1jVkFLVFognbeOXuFeVlwazN/OSd3fTRqV2J/6XbSGCIJP93S9KJD
         45q4xYNV6pnxluM9UGib695U7ho2abSbU3PlWTOrhcmhKDc/XjulkiMHUXzVHBB8gakf
         p0xSCi9MfrLxw9csKTNkJFRCDBYYqCiFi8zAUsr8OT50iYyMYLiEqUrR9a6nnB/2SgO2
         LBzQQ6HVDfjHOWIFQ29aAhuUvLDoOklla1K+sDOXojB3eZ9oviYUF2mheGq26idqVKai
         XfhFsSwuXLbSTQuzt6RLFjlIBcfzn/a/bosNacmzAtJoXmkLc7NBpdv8CQQCQXGxNr70
         25uQ==
X-Gm-Message-State: AOJu0YzQXq0Bg1G/+hz63Bt1QxiXIG0KgfIzpbnxOLsPmDNGnOkV3OY9
	CCd4mt38qSiyJjUsUuFFVfpssTpVJvcDJcI3hyLUzNG5b7/hLkTuf2H8y8ehCxKZd6uA6ePTLWO
	x3xfI5Q==
X-Google-Smtp-Source: AGHT+IHpmI5t9q8abNBgRyh5X76Xt5TR0J+JP8kdnFD/iZ18CSlsLse7XJRB4ca0uWJ63xXXHrffCkBn52o=
X-Received: from plbnb8.prod.google.com ([2002:a17:903:15c8:b0:23e:3914:f342])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:902:e890:b0:224:910:23f0
 with SMTP id d9443c01a7336-24096b3d823mr14938045ad.49.1753829734856; Tue, 29
 Jul 2025 15:55:34 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Tue, 29 Jul 2025 15:54:34 -0700
In-Reply-To: <20250729225455.670324-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250729225455.670324-1-seanjc@google.com>
X-Mailer: git-send-email 2.50.1.552.g942d659e1b-goog
Message-ID: <20250729225455.670324-4-seanjc@google.com>
Subject: [PATCH v17 03/24] KVM: x86: Select KVM_GENERIC_PRIVATE_MEM directly
 from KVM_SW_PROTECTED_VM
From: Sean Christopherson <seanjc@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>, Marc Zyngier <maz@kernel.org>, 
	Oliver Upton <oliver.upton@linux.dev>, Sean Christopherson <seanjc@google.com>
Cc: kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, 
	kvmarm@lists.linux.dev, linux-kernel@vger.kernel.org, 
	Ira Weiny <ira.weiny@intel.com>, Gavin Shan <gshan@redhat.com>, Shivank Garg <shivankg@amd.com>, 
	Vlastimil Babka <vbabka@suse.cz>, Xiaoyao Li <xiaoyao.li@intel.com>, 
	David Hildenbrand <david@redhat.com>, Fuad Tabba <tabba@google.com>, 
	Ackerley Tng <ackerleytng@google.com>, Tao Chan <chentao@kylinos.cn>, 
	James Houghton <jthoughton@google.com>
Content-Type: text/plain; charset="UTF-8"

Now that KVM_SW_PROTECTED_VM doesn't have a hidden dependency on KVM_X86,
select KVM_GENERIC_PRIVATE_MEM from within KVM_SW_PROTECTED_VM instead of
conditionally selecting it from KVM_X86.

No functional change intended.

Reviewed-by: Xiaoyao Li <xiaoyao.li@intel.com>
Reviewed-by: David Hildenbrand <david@redhat.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/Kconfig | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/kvm/Kconfig b/arch/x86/kvm/Kconfig
index 9895fc3cd901..402ba00fdf45 100644
--- a/arch/x86/kvm/Kconfig
+++ b/arch/x86/kvm/Kconfig
@@ -46,7 +46,6 @@ config KVM_X86
 	select HAVE_KVM_PM_NOTIFIER if PM
 	select KVM_GENERIC_HARDWARE_ENABLING
 	select KVM_GENERIC_PRE_FAULT_MEMORY
-	select KVM_GENERIC_PRIVATE_MEM if KVM_SW_PROTECTED_VM
 	select KVM_WERROR if WERROR
 
 config KVM
@@ -84,6 +83,7 @@ config KVM_SW_PROTECTED_VM
 	bool "Enable support for KVM software-protected VMs"
 	depends on EXPERT
 	depends on KVM_X86 && X86_64
+	select KVM_GENERIC_PRIVATE_MEM
 	help
 	  Enable support for KVM software-protected VMs.  Currently, software-
 	  protected VMs are purely a development and testing vehicle for
-- 
2.50.1.552.g942d659e1b-goog


