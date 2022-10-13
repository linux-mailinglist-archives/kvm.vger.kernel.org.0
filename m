Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1879A5FE3F6
	for <lists+kvm@lfdr.de>; Thu, 13 Oct 2022 23:13:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230071AbiJMVNY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 13 Oct 2022 17:13:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53916 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230058AbiJMVNT (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 13 Oct 2022 17:13:19 -0400
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A24A5191D42
        for <kvm@vger.kernel.org>; Thu, 13 Oct 2022 14:12:57 -0700 (PDT)
Received: by mail-yb1-xb4a.google.com with SMTP id f9-20020a25b089000000b006be298e2a8dso2585211ybj.20
        for <kvm@vger.kernel.org>; Thu, 13 Oct 2022 14:12:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:reply-to:from:to:cc:subject:date
         :message-id:reply-to;
        bh=BR8P37dIvaTzFUy4lljy43WBv5S0DCgP55/AwwfIul8=;
        b=CCO6wUnaRGcTstghOOGYPgobIQnpiUGsYX/hCr5+qDry/5v3Aund/1oMz7QmAiJ9Rc
         qHtK5CFnvyCSLEQwMgXznejUx9u+4wkGV8aoLCND0rOJeaKdeTe+kjeevWvOX3W3ZDap
         UtKRvvUyA6hYauHJYsNI8BHgtt6mO7R/Hr28mdLgdPebppsjoR5A+R8QYNujc3nOIPvm
         ZreplDyFfEtuvnJvSnH1L0+SYE42Lygeuk0bChDkmHAKdIUNA8mNcCi2rJSjF9uHjyRX
         s1BTh4U1dK1fd+RGvcHWbK/w6QqxqeLgE7Bzr1z0J+GXsMUXg/E2UGmmcphr0UDIkrmR
         HDVg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:reply-to:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=BR8P37dIvaTzFUy4lljy43WBv5S0DCgP55/AwwfIul8=;
        b=gwTVnjEE2vjsjTMjSyGBmLU6ELZZlXNSWTz3VNJpMzP+MJqBGApaAkFIf2+5laR8K8
         QIOZkud8b9PondLBulWY3oW9SdLMpHVb3y7R5sSh1jwxx1b8shAR2mhccfFBC/kihDrU
         wQZhqHl7Srz66CWaMjIjXWc8cN5B1iChPMS2Eg5anZZiv5yIAMe9RL6N8OGNRYw2WTyP
         pHUk6DNSEs92pT7Bb2YtG67lK3Rb77y9u62StdE046z6yUuGBzPhSGS5MsxMlKGaXiQi
         W4Cc2XaYZb/Ek68QoIkAUebQTVivfneeQm9tJfF84ncjNTx4gvqyjVslDjdM6zYiWlKa
         hrFQ==
X-Gm-Message-State: ACrzQf1SYCrxcAthNiQTgDFmdiJECP9pB+EBq/Wu1qvA4iAievwPDrTm
        H2y5VSIk145qhy2tLXVuHGoZ1BaGpkM=
X-Google-Smtp-Source: AMsMyM5LbnzAqbPMUXUd7XT5kRqUCn/x5Q7YTZS7zNDZ3dH5rXweKKHifdxs21L0r4AlnVY0kMB8XcRQ6V0=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a25:344e:0:b0:6c1:40e4:5a3b with SMTP id
 b75-20020a25344e000000b006c140e45a3bmr1712215yba.423.1665695562532; Thu, 13
 Oct 2022 14:12:42 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Thu, 13 Oct 2022 21:12:20 +0000
In-Reply-To: <20221013211234.1318131-1-seanjc@google.com>
Mime-Version: 1.0
References: <20221013211234.1318131-1-seanjc@google.com>
X-Mailer: git-send-email 2.38.0.413.g74048e4d9e-goog
Message-ID: <20221013211234.1318131-3-seanjc@google.com>
Subject: [PATCH v2 02/16] KVM: Reject attempts to consume or refresh inactive gfn_to_pfn_cache
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
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Reject kvm_gpc_check() and kvm_gpc_refresh() if the cache is inactive.
Not checking the active flag during refresh is particularly egregious, as
KVM can end up with a valid, inactive cache, which can lead to a variety
of use-after-free bugs, e.g. consuming a NULL kernel pointer or missing
an mmu_notifier invalidation due to the cache not being on the list of
gfns to invalidate.

Note, "active" needs to be set if and only if the cache is on the list
of caches, i.e. is reachable via mmu_notifier events.  If a relevant
mmu_notifier event occurs while the cache is "active" but not on the
list, KVM will not acquire the cache's lock and so will not serailize
the mmu_notifier event with active users and/or kvm_gpc_refresh().

A race between KVM_XEN_ATTR_TYPE_SHARED_INFO and KVM_XEN_HVM_EVTCHN_SEND
can be exploited to trigger the bug.

1. Deactivate shinfo cache:

kvm_xen_hvm_set_attr
case KVM_XEN_ATTR_TYPE_SHARED_INFO
 kvm_gpc_deactivate
  kvm_gpc_unmap
   gpc->valid =3D false
   gpc->khva =3D NULL
  gpc->active =3D false

Result: active =3D false, valid =3D false

2. Cause cache refresh:

kvm_arch_vm_ioctl
case KVM_XEN_HVM_EVTCHN_SEND
 kvm_xen_hvm_evtchn_send
  kvm_xen_set_evtchn
   kvm_xen_set_evtchn_fast
    kvm_gpc_check
    return -EWOULDBLOCK because !gpc->valid
   kvm_xen_set_evtchn_fast
    return -EWOULDBLOCK
   kvm_gpc_refresh
    hva_to_pfn_retry
     gpc->valid =3D true
     gpc->khva =3D not NULL

Result: active =3D false, valid =3D true

3. Race ioctl KVM_XEN_HVM_EVTCHN_SEND against ioctl
KVM_XEN_ATTR_TYPE_SHARED_INFO:

kvm_arch_vm_ioctl
case KVM_XEN_HVM_EVTCHN_SEND
 kvm_xen_hvm_evtchn_send
  kvm_xen_set_evtchn
   kvm_xen_set_evtchn_fast
    read_lock gpc->lock
                                          kvm_xen_hvm_set_attr case
                                          KVM_XEN_ATTR_TYPE_SHARED_INFO
                                           mutex_lock kvm->lock
                                           kvm_xen_shared_info_init
                                            kvm_gpc_activate
                                             gpc->khva =3D NULL
    kvm_gpc_check
     [ Check passes because gpc->valid is
       still true, even though gpc->khva
       is already NULL. ]
    shinfo =3D gpc->khva
    pending_bits =3D shinfo->evtchn_pending
    CRASH: test_and_set_bit(..., pending_bits)

Fixes: 982ed0de4753 ("KVM: Reinstate gfn_to_pfn_cache with invalidation sup=
port")
Cc: stable@vger.kernel.org
Reported-by: : Michal Luczaj <mhal@rbox.co>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 virt/kvm/pfncache.c | 41 ++++++++++++++++++++++++++++++++++-------
 1 file changed, 34 insertions(+), 7 deletions(-)

diff --git a/virt/kvm/pfncache.c b/virt/kvm/pfncache.c
index 08f97cf97264..346e47f15572 100644
--- a/virt/kvm/pfncache.c
+++ b/virt/kvm/pfncache.c
@@ -81,6 +81,9 @@ bool kvm_gfn_to_pfn_cache_check(struct kvm *kvm, struct g=
fn_to_pfn_cache *gpc,
 {
 	struct kvm_memslots *slots =3D kvm_memslots(kvm);
=20
+	if (!gpc->active)
+		return false;
+
 	if ((gpa & ~PAGE_MASK) + len > PAGE_SIZE)
 		return false;
=20
@@ -240,10 +243,11 @@ int kvm_gfn_to_pfn_cache_refresh(struct kvm *kvm, str=
uct gfn_to_pfn_cache *gpc,
 {
 	struct kvm_memslots *slots =3D kvm_memslots(kvm);
 	unsigned long page_offset =3D gpa & ~PAGE_MASK;
-	kvm_pfn_t old_pfn, new_pfn;
+	bool unmap_old =3D false;
 	unsigned long old_uhva;
+	kvm_pfn_t old_pfn;
 	void *old_khva;
-	int ret =3D 0;
+	int ret;
=20
 	/*
 	 * If must fit within a single page. The 'len' argument is
@@ -261,6 +265,11 @@ int kvm_gfn_to_pfn_cache_refresh(struct kvm *kvm, stru=
ct gfn_to_pfn_cache *gpc,
=20
 	write_lock_irq(&gpc->lock);
=20
+	if (!gpc->active) {
+		ret =3D -EINVAL;
+		goto out_unlock;
+	}
+
 	old_pfn =3D gpc->pfn;
 	old_khva =3D gpc->khva - offset_in_page(gpc->khva);
 	old_uhva =3D gpc->uhva;
@@ -291,6 +300,7 @@ int kvm_gfn_to_pfn_cache_refresh(struct kvm *kvm, struc=
t gfn_to_pfn_cache *gpc,
 		/* If the HVA=E2=86=92PFN mapping was already valid, don't unmap it. */
 		old_pfn =3D KVM_PFN_ERR_FAULT;
 		old_khva =3D NULL;
+		ret =3D 0;
 	}
=20
  out:
@@ -305,14 +315,15 @@ int kvm_gfn_to_pfn_cache_refresh(struct kvm *kvm, str=
uct gfn_to_pfn_cache *gpc,
 		gpc->khva =3D NULL;
 	}
=20
-	/* Snapshot the new pfn before dropping the lock! */
-	new_pfn =3D gpc->pfn;
+	/* Detect a pfn change before dropping the lock! */
+	unmap_old =3D (old_pfn !=3D gpc->pfn);
=20
+out_unlock:
 	write_unlock_irq(&gpc->lock);
=20
 	mutex_unlock(&gpc->refresh_lock);
=20
-	if (old_pfn !=3D new_pfn)
+	if (unmap_old)
 		gpc_unmap_khva(kvm, old_pfn, old_khva);
=20
 	return ret;
@@ -366,11 +377,19 @@ int kvm_gpc_activate(struct kvm *kvm, struct gfn_to_p=
fn_cache *gpc,
 		gpc->vcpu =3D vcpu;
 		gpc->usage =3D usage;
 		gpc->valid =3D false;
-		gpc->active =3D true;
=20
 		spin_lock(&kvm->gpc_lock);
 		list_add(&gpc->list, &kvm->gpc_list);
 		spin_unlock(&kvm->gpc_lock);
+
+		/*
+		 * Activate the cache after adding it to the list, a concurrent
+		 * refresh must not establish a mapping until the cache is
+		 * reachable by mmu_notifier events.
+		 */
+		write_lock_irq(&gpc->lock);
+		gpc->active =3D true;
+		write_unlock_irq(&gpc->lock);
 	}
 	return kvm_gfn_to_pfn_cache_refresh(kvm, gpc, gpa, len);
 }
@@ -379,12 +398,20 @@ EXPORT_SYMBOL_GPL(kvm_gpc_activate);
 void kvm_gpc_deactivate(struct kvm *kvm, struct gfn_to_pfn_cache *gpc)
 {
 	if (gpc->active) {
+		/*
+		 * Deactivate the cache before removing it from the list, KVM
+		 * must stall mmu_notifier events until all users go away, i.e.
+		 * until gpc->lock is dropped and refresh is guaranteed to fail.
+		 */
+		write_lock_irq(&gpc->lock);
+		gpc->active =3D false;
+		write_unlock_irq(&gpc->lock);
+
 		spin_lock(&kvm->gpc_lock);
 		list_del(&gpc->list);
 		spin_unlock(&kvm->gpc_lock);
=20
 		kvm_gfn_to_pfn_cache_unmap(kvm, gpc);
-		gpc->active =3D false;
 	}
 }
 EXPORT_SYMBOL_GPL(kvm_gpc_deactivate);
--=20
2.38.0.413.g74048e4d9e-goog

