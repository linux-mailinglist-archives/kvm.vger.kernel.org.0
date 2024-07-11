Return-Path: <kvm+bounces-21448-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id B26DE92F1E7
	for <lists+kvm@lfdr.de>; Fri, 12 Jul 2024 00:29:36 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id E4BE81C22AE2
	for <lists+kvm@lfdr.de>; Thu, 11 Jul 2024 22:29:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8FA221A38C3;
	Thu, 11 Jul 2024 22:28:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="iOQXpnpA"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 158221A2572
	for <kvm@vger.kernel.org>; Thu, 11 Jul 2024 22:28:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720736888; cv=none; b=e9opKwxNJ+2a596fJ1651TOJ47fBXtcDmZXZSR/u/DMK4w4xNwBgFowpz6GahRjVWt5d0WZIKu3DiIa6isWgTPT0CTqheJwheOS1VuDSEl9BXCjPc2idJScSRmmJHtlrp+ZoPZctdYfzf31B8og4wvvX/LVbPrMLtpDAQLag2lE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720736888; c=relaxed/simple;
	bh=UIuuI8pj3ZeyK5S9JQuOd5zsynrclPUOgJSVOjpDijA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=igbDUMSMoQEaqHoOuJJpAhOYAAuvWRGYm+s+mHqEIwdULQuXU6QTE7DVAqCyU3CydIV8mtP06sMxOBg1oRD2HYU9ouvOG7dqfjmMgCeJvWgLC4mi6TNXlVMRxPHyGv/aXnDlNS0ZsH+HAm8LxcS9c17cq3ZMwXuJZoJprfmBnJI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=iOQXpnpA; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1720736886;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=p5Ee96ulXxhjmi3RItKf8tKz5A6ffGeMgjDgibBuQZU=;
	b=iOQXpnpAy0R6ZVue+3f9Dah8PgHxTxykcdcxGPAobGK/c3pR5Ts5OBz9v6XRD75KXw/FBn
	S1Zjo/mnlWaGG08ZSkcecgSPo6iZknFdB12KnWFEwGtwB/vN1LCsZrdO2fjfGfqYhBJ7MY
	9K2T3cyNldocfqWD17HlVkd2eQfT1fM=
Received: from mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-425-fEqQouoeOpK14cdJxf_YVA-1; Thu,
 11 Jul 2024 18:28:04 -0400
X-MC-Unique: fEqQouoeOpK14cdJxf_YVA-1
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 9C61F19560BA;
	Thu, 11 Jul 2024 22:28:03 +0000 (UTC)
Received: from virtlab1023.lab.eng.rdu2.redhat.com (virtlab1023.lab.eng.rdu2.redhat.com [10.8.1.187])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id E46D419560AE;
	Thu, 11 Jul 2024 22:28:02 +0000 (UTC)
From: Paolo Bonzini <pbonzini@redhat.com>
To: linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org
Cc: seanjc@google.com,
	michael.roth@amd.com
Subject: [PATCH 09/12] KVM: guest_memfd: move check for already-populated page to common code
Date: Thu, 11 Jul 2024 18:27:52 -0400
Message-ID: <20240711222755.57476-10-pbonzini@redhat.com>
In-Reply-To: <20240711222755.57476-1-pbonzini@redhat.com>
References: <20240711222755.57476-1-pbonzini@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.12

Do not allow populating the same page twice with startup data.  In the
case of SEV-SNP, for example, the firmware does not allow it anyway,
since the launch-update operation is only possible on pages that are
still shared in the RMP.

Even if it worked, kvm_gmem_populate()'s callback is meant to have side
effects such as updating launch measurements, and updating the same
page twice is unlikely to have the desired results.

Races between calls to the ioctl are not possible because kvm_gmem_populate()
holds slots_lock and the VM should not be running.  But again, even if
this worked on other confidential computing technology, it doesn't matter
to guest_memfd.c whether this is an intentional attempt to do something
fishy, or missing synchronization in userspace, or even something
intentional.  One of the racers wins, and the page is initialized by
either kvm_gmem_prepare_folio() or kvm_gmem_populate().

Anyway, out of paranoia, adjust sev_gmem_post_populate() anyway to use
the same errno that kvm_gmem_populate() is using.

Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 arch/x86/kvm/svm/sev.c | 2 +-
 virt/kvm/guest_memfd.c | 7 +++++++
 2 files changed, 8 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index df8818759698..397ef9e70182 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -2213,7 +2213,7 @@ static int sev_gmem_post_populate(struct kvm *kvm, gfn_t gfn_start, kvm_pfn_t pf
 		if (ret || assigned) {
 			pr_debug("%s: Failed to ensure GFN 0x%llx RMP entry is initial shared state, ret: %d assigned: %d\n",
 				 __func__, gfn, ret, assigned);
-			ret = -EINVAL;
+			ret = ret ? -EINVAL : -EEXIST;
 			goto err;
 		}
 
diff --git a/virt/kvm/guest_memfd.c b/virt/kvm/guest_memfd.c
index 509360eefea5..266810bb91c9 100644
--- a/virt/kvm/guest_memfd.c
+++ b/virt/kvm/guest_memfd.c
@@ -650,6 +650,13 @@ long kvm_gmem_populate(struct kvm *kvm, gfn_t start_gfn, void __user *src, long
 			break;
 		}
 
+		if (folio_test_uptodate(folio)) {
+			folio_unlock(folio);
+			folio_put(folio);
+			ret = -EEXIST;
+			break;
+		}
+
 		folio_unlock(folio);
 		if (!IS_ALIGNED(gfn, (1 << max_order)) ||
 		    (npages - i) < (1 << max_order))
-- 
2.43.0



