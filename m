Return-Path: <kvm+bounces-13554-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 9E9AD8986F6
	for <lists+kvm@lfdr.de>; Thu,  4 Apr 2024 14:15:51 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 54CCF1F286EC
	for <lists+kvm@lfdr.de>; Thu,  4 Apr 2024 12:15:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8660212AADF;
	Thu,  4 Apr 2024 12:13:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="IZgWebtV"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B711483CDE
	for <kvm@vger.kernel.org>; Thu,  4 Apr 2024 12:13:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712232819; cv=none; b=hJz3DrQlshUyJ003IknkOV4qTDON5XjnfRtpgK+VjRk7RFd0tgZgJYWDySNYbxjc3FJoBKRsgdWKoIqrgMwejkD+gj0e9A5ByOoYP6Skazq5gYxAZXJRpWzXpG1MRVdHLcg5DyJXruWR9gyEvu3mMfSlPGgrcwa3/3Wa430qwv8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712232819; c=relaxed/simple;
	bh=1HRECsLzpudYICwwyJivQE4L+YfEF9d+04mRJ4qb7VA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=n/Ir7jI5VI/uGGiNfQCgGO1+s82preG+zS83rprjm5cviDOK3WBQPdIHPxSCWWtyJvSVZ9b7INuiJ+2FA1hpFeWIxPCkomeiinziwyn/po5RrkuukxRHqAT6X1DHIi2+H3VsuErXpVJ4Rd6DDsom/3Z61dAHEA+6xjveIIRLRI0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=IZgWebtV; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1712232815;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=RCpgeCQEn1bWv/88mbnuGvqPh+brtkbTB2wyKpfP2MU=;
	b=IZgWebtV20OY8t+ETanrHNugPfaJFMACsU6ERNci0kE16+IEmJipZ2+ID/LHnV91ciLdo1
	jYtObVyxmJH5Y5kEFGpssXjYRCRSqFUM/K0UXjLt70GCohWgQe3pg+n4FuAlGpJ84ntWe5
	PDYNSppTGR6UkwkPEkz7po3fQbvAR7k=
Received: from mimecast-mx02.redhat.com (mx-ext.redhat.com [66.187.233.73])
 by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-197-7Ij2b4xDNfWrMucrinYP9g-1; Thu,
 04 Apr 2024 08:13:31 -0400
X-MC-Unique: 7Ij2b4xDNfWrMucrinYP9g-1
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com [10.11.54.9])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id DFC81383CCEA;
	Thu,  4 Apr 2024 12:13:30 +0000 (UTC)
Received: from virtlab701.virt.lab.eng.bos.redhat.com (virtlab701.virt.lab.eng.bos.redhat.com [10.19.152.228])
	by smtp.corp.redhat.com (Postfix) with ESMTP id BEED9492BC6;
	Thu,  4 Apr 2024 12:13:30 +0000 (UTC)
From: Paolo Bonzini <pbonzini@redhat.com>
To: linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org
Cc: michael.roth@amd.com,
	isaku.yamahata@intel.com
Subject: [PATCH v5 13/17] KVM: SEV: allow SEV-ES DebugSwap again
Date: Thu,  4 Apr 2024 08:13:23 -0400
Message-ID: <20240404121327.3107131-14-pbonzini@redhat.com>
In-Reply-To: <20240404121327.3107131-1-pbonzini@redhat.com>
References: <20240404121327.3107131-1-pbonzini@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.9

The DebugSwap feature of SEV-ES provides a way for confidential guests
to use data breakpoints.  Its status is record in VMSA, and therefore
attestation signatures depend on whether it is enabled or not.  In order
to avoid invalidating the signatures depending on the host machine, it
was disabled by default (see commit 5abf6dceb066, "SEV: disable SEV-ES
DebugSwap by default", 2024-03-09).

However, we now have a new API to create SEV VMs that allows enabling
DebugSwap based on what the user tells KVM to do, and we also changed the
legacy KVM_SEV_ES_INIT API to never enable DebugSwap.  It is therefore
possible to re-enable the feature without breaking compatibility with
kernels that pre-date the introduction of DebugSwap, so go ahead.

Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 arch/x86/kvm/svm/sev.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index 2f20270be93b..022d92fb4b85 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -45,7 +45,7 @@ static bool sev_es_enabled = true;
 module_param_named(sev_es, sev_es_enabled, bool, 0444);
 
 /* enable/disable SEV-ES DebugSwap support */
-static bool sev_es_debug_swap_enabled = false;
+static bool sev_es_debug_swap_enabled = true;
 module_param_named(debug_swap, sev_es_debug_swap_enabled, bool, 0444);
 static u64 sev_supported_vmsa_features;
 
-- 
2.43.0



