Return-Path: <kvm+bounces-37198-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 2543CA268C1
	for <lists+kvm@lfdr.de>; Tue,  4 Feb 2025 01:43:31 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id EFFBA7A3169
	for <lists+kvm@lfdr.de>; Tue,  4 Feb 2025 00:42:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0893A15666B;
	Tue,  4 Feb 2025 00:41:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="rOeGVNsq"
X-Original-To: kvm@vger.kernel.org
Received: from mail-ua1-f73.google.com (mail-ua1-f73.google.com [209.85.222.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DBB2513A265
	for <kvm@vger.kernel.org>; Tue,  4 Feb 2025 00:41:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738629663; cv=none; b=fHSpDjiN76nihExVVCrDRXe8on6MNQ36iyybw+/qjdn3csvH2+UPcN2iEdPCn0OD2nx+kbXUDl36QgaL45BEQL2v2Mx8MP78YHx2tWbUld9LKueNyido9Dnob2+gE7sOjl/jrg5CcFmTUlgpfdK0CpzpwDkUZOgi92Qam3uN72I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738629663; c=relaxed/simple;
	bh=gKWMm2etwru6nxao/XwThnbqHsLiE1msJPSwlLVbyq4=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=gV6dmUFVgyQVMCLijWms124/t/fiysWGMGIPFknok6sINpIMRNoYY/i2FC2VZ7C2eLxt0fc1pldRk01HJK3/Lm0Cf8a9ywB4P61eoslE/atwog2qj2uGn8gnPkWKewmNIVUMXeZPVr0XIiwmInMB/GiegM3MEdIXCUjqXISeE/s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--jthoughton.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=rOeGVNsq; arc=none smtp.client-ip=209.85.222.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--jthoughton.bounces.google.com
Received: by mail-ua1-f73.google.com with SMTP id a1e0cc1a2514c-866dc5ac247so132241.2
        for <kvm@vger.kernel.org>; Mon, 03 Feb 2025 16:41:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1738629660; x=1739234460; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=evkb5L1+Bb/XCjZRw4KhkzBAPm7Ic3vYQhlj6o4qwVc=;
        b=rOeGVNsqQl3XOgiNQzqB9MdFEGkWxtTnqV2/kx31I/odULvyHRXjapi2hBWTxYoh6V
         vuBDrjaPGQE6tSk0XWBzcwLK0mCHetmlfjhXqxEyIIPN1A9aCoLnr9PeXYnDQBQP28eY
         2GumGNPlxw1Sa2hMbdXVkPeObDztxOBq8SFWETU+E5JuHjsQAkWPFrf62oy/Vh5Zy6UK
         ezGbkw0Mq8dZEehcxsXhLnoVJCG7Q3TIg99fSCGM6Qc5rUhXkQsemnv+ytTdHPN9djxo
         voWJH2Frin2oTF6tyV+qYMIA2p1WNC5T8nR4vH6HPT+0c13e9hRx0ZOe84uqosh7Znkp
         oDRQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1738629660; x=1739234460;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=evkb5L1+Bb/XCjZRw4KhkzBAPm7Ic3vYQhlj6o4qwVc=;
        b=Uhjf3FBQXFokpGswhkyzlOQi2ih+9EmEQny8Dem8sn8Lou0ji6uuFqV4XR6IugyNXa
         GlKnUQrXREDOzXwvwr1qwf1+x3KUtPicw/nmOjTYkcijvF0fsT96HFN/ONmjL9nOjZU1
         DUxQnfme38hMOeJwA5wK752Bee6XcoJBR4pdaGYxiKtifSRR9nRn5Gzxo07xOhZPIwvD
         pEwrAQdYYJ3w/CqBdwG9NtoMp5OurSBq3NJO1WF93cxc/yuFryIZiolsNqa7LMVWekPz
         4hBLvGRlZB+v/pre/p1aWymvi2lYMpztMIielaq7Dc4XA3xfMeMzUZoNTAfvjlpqSfyk
         r17A==
X-Forwarded-Encrypted: i=1; AJvYcCXOTt7pzw4AC5XL6j9ic1DoduNeWiKHrTELTUhcH39Dmy7hbkyordfbf4hr7FdhOUSaSss=@vger.kernel.org
X-Gm-Message-State: AOJu0Yz1s5eURbFXua4tOTTVAQ9rc4u4frUnAms6to9fAg3AC1sqZD3V
	13qbOcgY6kcJ1mt2mveZ7EXSIxSbs/VhN9r55IKWxUqqh/rwb2wzo/r7Z2ohUpZ6yqVhHqJTxOT
	MqIrh+AiM4HOxzl3Pjg==
X-Google-Smtp-Source: AGHT+IGU8DrUd67RaNBXFdA4LIHF4vKSiFY0NavTZMn7WxDHSLQeFzRZ+wePcvzz/rTJd7HD6bj8y/+Yhz70nz8T
X-Received: from uabib8.prod.google.com ([2002:a05:6130:1c88:b0:857:38b8:a246])
 (user=jthoughton job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6102:534b:b0:4b2:ad82:133a with SMTP id ada2fe7eead31-4b9a5300d5emr19705292137.25.1738629660712;
 Mon, 03 Feb 2025 16:41:00 -0800 (PST)
Date: Tue,  4 Feb 2025 00:40:34 +0000
In-Reply-To: <20250204004038.1680123-1-jthoughton@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250204004038.1680123-1-jthoughton@google.com>
X-Mailer: git-send-email 2.48.1.362.g079036d154-goog
Message-ID: <20250204004038.1680123-8-jthoughton@google.com>
Subject: [PATCH v9 07/11] KVM: x86/mmu: Only check gfn age in shadow MMU if
 indirect_shadow_pages > 0
From: James Houghton <jthoughton@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: David Matlack <dmatlack@google.com>, David Rientjes <rientjes@google.com>, 
	James Houghton <jthoughton@google.com>, Marc Zyngier <maz@kernel.org>, 
	Oliver Upton <oliver.upton@linux.dev>, Wei Xu <weixugc@google.com>, Yu Zhao <yuzhao@google.com>, 
	Axel Rasmussen <axelrasmussen@google.com>, kvm@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

When aging SPTEs and the TDP MMU is enabled, process the shadow MMU if and
only if the VM has at least one shadow page, as opposed to checking if the
VM has rmaps.  Checking for rmaps will effectively yield a false positive
if the VM ran nested TDP VMs in the past, but is not currently doing so.

Signed-off-by: James Houghton <jthoughton@google.com>
Acked-by: Yu Zhao <yuzhao@google.com>
---
 arch/x86/kvm/mmu/mmu.c | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 4a9de4b330d7..f75779d8d6fd 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -1588,6 +1588,11 @@ static bool kvm_rmap_age_gfn_range(struct kvm *kvm,
 	return young;
 }
 
+static bool kvm_may_have_shadow_mmu_sptes(struct kvm *kvm)
+{
+	return !tdp_mmu_enabled || READ_ONCE(kvm->arch.indirect_shadow_pages);
+}
+
 bool kvm_age_gfn(struct kvm *kvm, struct kvm_gfn_range *range)
 {
 	bool young = false;
@@ -1595,7 +1600,7 @@ bool kvm_age_gfn(struct kvm *kvm, struct kvm_gfn_range *range)
 	if (tdp_mmu_enabled)
 		young = kvm_tdp_mmu_age_gfn_range(kvm, range);
 
-	if (kvm_memslots_have_rmaps(kvm)) {
+	if (kvm_may_have_shadow_mmu_sptes(kvm)) {
 		write_lock(&kvm->mmu_lock);
 		young |= kvm_rmap_age_gfn_range(kvm, range, false);
 		write_unlock(&kvm->mmu_lock);
@@ -1611,7 +1616,7 @@ bool kvm_test_age_gfn(struct kvm *kvm, struct kvm_gfn_range *range)
 	if (tdp_mmu_enabled)
 		young = kvm_tdp_mmu_test_age_gfn(kvm, range);
 
-	if (!young && kvm_memslots_have_rmaps(kvm)) {
+	if (!young && kvm_may_have_shadow_mmu_sptes(kvm)) {
 		write_lock(&kvm->mmu_lock);
 		young |= kvm_rmap_age_gfn_range(kvm, range, true);
 		write_unlock(&kvm->mmu_lock);
-- 
2.48.1.362.g079036d154-goog


