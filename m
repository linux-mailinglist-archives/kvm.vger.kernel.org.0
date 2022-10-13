Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 82D995FE402
	for <lists+kvm@lfdr.de>; Thu, 13 Oct 2022 23:14:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230170AbiJMVOS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 13 Oct 2022 17:14:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54868 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230149AbiJMVNl (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 13 Oct 2022 17:13:41 -0400
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 617B719375E
        for <kvm@vger.kernel.org>; Thu, 13 Oct 2022 14:13:36 -0700 (PDT)
Received: by mail-yb1-xb49.google.com with SMTP id a2-20020a5b0ec2000000b006c108ecf390so2560206ybs.9
        for <kvm@vger.kernel.org>; Thu, 13 Oct 2022 14:13:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:reply-to:from:to:cc:subject:date
         :message-id:reply-to;
        bh=N+ZLsWQWrbTeNoSHVahwYLBX7L/YFHf5HDS9U7VFCCo=;
        b=FsxHbjOHYqiWQWKvKcoWJWpwm1TWzvwZwM7umrP8lrQyx512BCB/aj9APV57S1zRKv
         M3W57j19MhZJuBdQgrGaDEbFXEI0b50MpiTMzR8NLjjzCIOQALgZrDczMsSpRlULzv9X
         piO072IEBzh3t59bPz1frM+5kgdt7pNZCO4/PenZkNJ4BFmJssUs+ksH47Qq5hTKhhnO
         0xQKj3lupz+pNlcziUvEtCWa97qMpPZXn/BWiqQbftslhGY9+YKuUbNoGp9dcsq3iDGL
         MJaUwH9n0jjDAttouYARLnARPc7rxM55KeHAEkG6JjJ60M4n7eO+ZlBv9dyPh1DaSjWS
         VrAA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:reply-to:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=N+ZLsWQWrbTeNoSHVahwYLBX7L/YFHf5HDS9U7VFCCo=;
        b=IiHr7WQ/0XWTN+z0K/aOhHS8PVex2r87EM9r01Z4+AJ51xZh3wqOERFAR+LDh68EvM
         cZKB8uQKdl3l7yjdV4KiS15kXzpYvgAqO470ALzHWRYuaL3bfD/YRH6bDy7mRkJj7oEA
         OGUIZPhYx3hF0yNdP4LCjTLzEZss2HCHVAqj/Y8voHRK0huWWVOORPFpYzjao58bbpd0
         7+kFrS4VrNEiQDfHZbKNLeRcv9yzmzgQ5AVcU6ySejoXLGJbFyMl/cSEWdlLsZ2JQpAg
         yfXyW9CkTSmnmRwvTfm9gMp3GBwfFpwfMzEEuHDd+jpI7X9ZHDTpHYkHdKmNbm5sD/nj
         Ctqw==
X-Gm-Message-State: ACrzQf0xP/kz0BrJwVIFpXeH9zj4ePXYU8L8qlr3Ntq7/IgyeERqH6AP
        9PCmlYaO5MnUA3Lgx/R/gYixH5c3znU=
X-Google-Smtp-Source: AMsMyM5fAIdbSS3Hmw2vGAg48UHVyralf3ztielCGIwvgHhlrNWhnbQ7znQZsDmv9sJolUSIaLw1Hetf928=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a81:99cf:0:b0:360:b7bd:64de with SMTP id
 q198-20020a8199cf000000b00360b7bd64demr1839403ywg.91.1665695577390; Thu, 13
 Oct 2022 14:12:57 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Thu, 13 Oct 2022 21:12:29 +0000
In-Reply-To: <20221013211234.1318131-1-seanjc@google.com>
Mime-Version: 1.0
References: <20221013211234.1318131-1-seanjc@google.com>
X-Mailer: git-send-email 2.38.0.413.g74048e4d9e-goog
Message-ID: <20221013211234.1318131-12-seanjc@google.com>
Subject: [PATCH v2 11/16] KVM: Drop KVM's API to allow temprorarily unmapping
 gfn=>pfn cache
From:   Sean Christopherson <seanjc@google.com>
To:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Michal Luczaj <mhal@rbox.co>,
        David Woodhouse <dwmw2@infradead.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Drop kvm_gpc_unmap() as it has no users and unclear requirements.  The
API was added as part of the original gfn_to_pfn_cache support, but its
sole usage[*] was never merged.  Fold the guts of kvm_gpc_unmap() into
the deactivate path and drop the API.  Omit acquiring refresh_lock as
as concurrent calls to kvm_gpc_deactivate() are not allowed (this is
not enforced, e.g. via lockdep. due to it being called during vCPU
destruction).

If/when temporary unmapping makes a comeback, the desirable behavior is
likely to restrict temporary unmapping to vCPU-exclusive mappings and
require the vcpu->mutex be held to serialize unmap.  Use of the
refresh_lock to protect unmapping was somewhat specuatively added by
commit 93984f19e7bc ("KVM: Fully serialize gfn=3D>pfn cache refresh via
mutex") to guard against concurrent unmaps, but the primary use case of
the temporary unmap, nested virtualization[*], doesn't actually need or
want concurrent unmaps.

[*] https://lore.kernel.org/all/20211210163625.2886-7-dwmw2@infradead.org

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 include/linux/kvm_host.h | 12 -----------
 virt/kvm/pfncache.c      | 44 +++++++++++++++-------------------------
 2 files changed, 16 insertions(+), 40 deletions(-)

diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index b63d2abbef56..22cf43389954 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -1315,18 +1315,6 @@ bool kvm_gpc_check(struct gfn_to_pfn_cache *gpc, gpa=
_t gpa);
  */
 int kvm_gpc_refresh(struct gfn_to_pfn_cache *gpc, gpa_t gpa);
=20
-/**
- * kvm_gpc_unmap - temporarily unmap a gfn_to_pfn_cache.
- *
- * @kvm:	   pointer to kvm instance.
- * @gpc:	   struct gfn_to_pfn_cache object.
- *
- * This unmaps the referenced page. The cache is left in the invalid state
- * but at least the mapping from GPA to userspace HVA will remain cached
- * and can be reused on a subsequent refresh.
- */
-void kvm_gpc_unmap(struct kvm *kvm, struct gfn_to_pfn_cache *gpc);
-
 /**
  * kvm_gpc_deactivate - deactivate and unlink a gfn_to_pfn_cache.
  *
diff --git a/virt/kvm/pfncache.c b/virt/kvm/pfncache.c
index 432b150bd9f1..62b47feed36c 100644
--- a/virt/kvm/pfncache.c
+++ b/virt/kvm/pfncache.c
@@ -328,33 +328,6 @@ int kvm_gpc_refresh(struct gfn_to_pfn_cache *gpc, gpa_=
t gpa)
 }
 EXPORT_SYMBOL_GPL(kvm_gpc_refresh);
=20
-void kvm_gpc_unmap(struct kvm *kvm, struct gfn_to_pfn_cache *gpc)
-{
-	void *old_khva;
-	kvm_pfn_t old_pfn;
-
-	mutex_lock(&gpc->refresh_lock);
-	write_lock_irq(&gpc->lock);
-
-	gpc->valid =3D false;
-
-	old_khva =3D gpc->khva - offset_in_page(gpc->khva);
-	old_pfn =3D gpc->pfn;
-
-	/*
-	 * We can leave the GPA =E2=86=92 uHVA map cache intact but the PFN
-	 * lookup will need to be redone even for the same page.
-	 */
-	gpc->khva =3D NULL;
-	gpc->pfn =3D KVM_PFN_ERR_FAULT;
-
-	write_unlock_irq(&gpc->lock);
-	mutex_unlock(&gpc->refresh_lock);
-
-	gpc_unmap_khva(old_pfn, old_khva);
-}
-EXPORT_SYMBOL_GPL(kvm_gpc_unmap);
-
 void kvm_gpc_init(struct gfn_to_pfn_cache *gpc, struct kvm *kvm,
 		  struct kvm_vcpu *vcpu, enum pfn_cache_usage usage,
 		  unsigned long len)
@@ -402,6 +375,8 @@ EXPORT_SYMBOL_GPL(kvm_gpc_activate);
 void kvm_gpc_deactivate(struct gfn_to_pfn_cache *gpc)
 {
 	struct kvm *kvm =3D gpc->kvm;
+	kvm_pfn_t old_pfn;
+	void *old_khva;
=20
 	if (gpc->active) {
 		/*
@@ -411,13 +386,26 @@ void kvm_gpc_deactivate(struct gfn_to_pfn_cache *gpc)
 		 */
 		write_lock_irq(&gpc->lock);
 		gpc->active =3D false;
+		gpc->valid =3D false;
+
+		/*
+		 * Leave the GPA =3D> uHVA cache intact, it's protected by the
+		 * memslot generation.  The PFN lookup needs to be redone every
+		 * time as mmu_notifier protection is lost when the cache is
+		 * removed from the VM's gpc_list.
+		 */
+		old_khva =3D gpc->khva - offset_in_page(gpc->khva);
+		gpc->khva =3D NULL;
+
+		old_pfn =3D gpc->pfn;
+		gpc->pfn =3D KVM_PFN_ERR_FAULT;
 		write_unlock_irq(&gpc->lock);
=20
 		spin_lock(&kvm->gpc_lock);
 		list_del(&gpc->list);
 		spin_unlock(&kvm->gpc_lock);
=20
-		kvm_gpc_unmap(kvm, gpc);
+		gpc_unmap_khva(old_pfn, old_khva);
 	}
 }
 EXPORT_SYMBOL_GPL(kvm_gpc_deactivate);
--=20
2.38.0.413.g74048e4d9e-goog

