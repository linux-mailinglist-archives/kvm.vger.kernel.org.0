Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A3F0B4CAB80
	for <lists+kvm@lfdr.de>; Wed,  2 Mar 2022 18:25:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243787AbiCBR0D (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 2 Mar 2022 12:26:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55984 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243782AbiCBR0B (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 2 Mar 2022 12:26:01 -0500
Received: from mail-wm1-x32c.google.com (mail-wm1-x32c.google.com [IPv6:2a00:1450:4864:20::32c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F0C33CA335;
        Wed,  2 Mar 2022 09:25:17 -0800 (PST)
Received: by mail-wm1-x32c.google.com with SMTP id v2-20020a7bcb42000000b0037b9d960079so3794643wmj.0;
        Wed, 02 Mar 2022 09:25:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=scMECPVJvKWCeuo+NmK3nfH6s3a+5++URq1k1UJa884=;
        b=kVGf3CBMBjUbMbwFW4Krtbs1QANJRnl1THMG9j2+VAZDC3Qz1DT60HsxBleyaQ+edt
         psjBxLyN5j78pt+5F+gEKW1P18ky2+nkAOw8yk5KY3MKvzDHE5Sp9/gb7CYq9azohG/6
         hMVFdaF+XUold4fjH+monfN7fzF+gSqc+EhjvYSNRqN/fP/r+aoF7XfKuCUCUWpm0k6a
         Ecex2pCmwTFB63pdAqTVYPoWLrtHTQ10g/wfMLlc7Ie8sCvUivfapzuJhBGERvLdIuUa
         VNHj2MCcfz5qz+a1hVvJCHGgOyou7W4Km+BeOz720nZ+ypNFd43bnalzkyLPdO4rTu6d
         NTVg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:message-id:date:mime-version:user-agent
         :subject:content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=scMECPVJvKWCeuo+NmK3nfH6s3a+5++URq1k1UJa884=;
        b=CRf66lNrFIThvE9pD2+mCtY0FBagDHFooUjCVznREoCTuRwmuTymBmwVnlf55gSNQ/
         3t37C4zM9jMPTawuaphne1tYKQgk7SkqFz7imvJLHNrzOwxEktfj3VjyWNY2hzKkbnkY
         TWIA8dwiJsa04f6fwcbSFqsrvijk6lKgQNvggCobb83IzZQu2RQiOgAmWJZAwHwL+FHh
         XAzBd2owiVXK0oDBDyzY4Dmlds3PCksUdWKCFeL70HdXLyDNa4gbT+gaH+jLP3KWAoxc
         pd0lyz2UIP76fWlY5yfw48b69bruzuqG4huVSHHeBoeu0Ls3Y78T/+y8++wiQ02dpQmJ
         9WBg==
X-Gm-Message-State: AOAM533yHdPykDS9WS8T/TdRetJ6tf+gn+t9XKRspleMmq5HI91GkiWE
        JzBuZQ0nRhRBkU//A5uiNE8=
X-Google-Smtp-Source: ABdhPJxJF5IEm+ADEkTcILyrwPNI9pfbGqYF52Q9v3NRlksJG57u29HWKvv+JQj5TR0oPurhiorNgA==
X-Received: by 2002:a05:600c:4ec6:b0:352:cc24:1754 with SMTP id g6-20020a05600c4ec600b00352cc241754mr662508wmq.184.1646241916387;
        Wed, 02 Mar 2022 09:25:16 -0800 (PST)
Received: from ?IPV6:2001:b07:6468:f312:5e2c:eb9a:a8b6:fd3e? ([2001:b07:6468:f312:5e2c:eb9a:a8b6:fd3e])
        by smtp.googlemail.com with ESMTPSA id g6-20020a5d5406000000b001f049726044sm540244wrv.79.2022.03.02.09.25.14
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 02 Mar 2022 09:25:15 -0800 (PST)
Sender: Paolo Bonzini <paolo.bonzini@gmail.com>
Message-ID: <b9270432-4ee8-be8e-8aa1-4b09992f82b8@redhat.com>
Date:   Wed, 2 Mar 2022 18:25:14 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: [PATCH v3 22/28] KVM: x86/mmu: Zap defunct roots via asynchronous
 worker
Content-Language: en-US
To:     Sean Christopherson <seanjc@google.com>,
        Christian Borntraeger <borntraeger@linux.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        David Hildenbrand <david@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, David Matlack <dmatlack@google.com>,
        Ben Gardon <bgardon@google.com>,
        Mingwei Zhang <mizhang@google.com>
References: <20220226001546.360188-1-seanjc@google.com>
 <20220226001546.360188-23-seanjc@google.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <20220226001546.360188-23-seanjc@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.5 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
        HEADER_FROM_DIFFERENT_DOMAINS,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 2/26/22 01:15, Sean Christopherson wrote:
> Zap defunct roots, a.k.a. roots that have been invalidated after their
> last reference was initially dropped, asynchronously via the system work
> queue instead of forcing the work upon the unfortunate task that happened
> to drop the last reference.
> 
> If a vCPU task drops the last reference, the vCPU is effectively blocked
> by the host for the entire duration of the zap.  If the root being zapped
> happens be fully populated with 4kb leaf SPTEs, e.g. due to dirty logging
> being active, the zap can take several hundred seconds.  Unsurprisingly,
> most guests are unhappy if a vCPU disappears for hundreds of seconds.
> 
> E.g. running a synthetic selftest that triggers a vCPU root zap with
> ~64tb of guest memory and 4kb SPTEs blocks the vCPU for 900+ seconds.
> Offloading the zap to a worker drops the block time to <100ms.
> 
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---

Do we even need kvm_tdp_mmu_zap_invalidated_roots() now?  That is,
something like the following:

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index bd3625a875ef..5fd8bc858c6f 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -5698,6 +5698,16 @@ static void kvm_mmu_zap_all_fast(struct kvm *kvm)
  {
  	lockdep_assert_held(&kvm->slots_lock);
  
+	/*
+	 * kvm_tdp_mmu_invalidate_all_roots() needs a nonzero reference
+	 * count.  If we're dying, zap everything as it's going to happen
+	 * soon anyway.
+	 */
+	if (!refcount_read(&kvm->users_count)) {
+		kvm_mmu_zap_all(kvm);
+		return;
+	}
+
  	write_lock(&kvm->mmu_lock);
  	trace_kvm_mmu_zap_all_fast(kvm);
  
@@ -5732,20 +5742,6 @@ static void kvm_mmu_zap_all_fast(struct kvm *kvm)
  	kvm_zap_obsolete_pages(kvm);
  
  	write_unlock(&kvm->mmu_lock);
-
-	/*
-	 * Zap the invalidated TDP MMU roots, all SPTEs must be dropped before
-	 * returning to the caller, e.g. if the zap is in response to a memslot
-	 * deletion, mmu_notifier callbacks will be unable to reach the SPTEs
-	 * associated with the deleted memslot once the update completes, and
-	 * Deferring the zap until the final reference to the root is put would
-	 * lead to use-after-free.
-	 */
-	if (is_tdp_mmu_enabled(kvm)) {
-		read_lock(&kvm->mmu_lock);
-		kvm_tdp_mmu_zap_invalidated_roots(kvm);
-		read_unlock(&kvm->mmu_lock);
-	}
  }
  
  static bool kvm_has_zapped_obsolete_pages(struct kvm *kvm)
diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
index cd1bf68e7511..af9db5b8f713 100644
--- a/arch/x86/kvm/mmu/tdp_mmu.c
+++ b/arch/x86/kvm/mmu/tdp_mmu.c
@@ -142,10 +142,12 @@ void kvm_tdp_mmu_put_root(struct kvm *kvm, struct kvm_mmu_page *root,
  	WARN_ON(!root->tdp_mmu_page);
  
  	/*
-	 * The root now has refcount=0 and is valid.  Readers cannot acquire
-	 * a reference to it (they all visit valid roots only, except for
-	 * kvm_tdp_mmu_zap_invalidated_roots() which however does not acquire
-	 * any reference itself.
+	 * The root now has refcount=0.  It is valid, but readers already
+	 * cannot acquire a reference to it because kvm_tdp_mmu_get_root()
+	 * rejects it.  This remains true for the rest of the execution
+	 * of this function, because readers visit valid roots only
+	 * (except for tdp_mmu_zap_root_work(), which however operates only
+	 * on one specific root and does not acquire any reference itself).

  	 *
  	 * Even though there are flows that need to visit all roots for
  	 * correctness, they all take mmu_lock for write, so they cannot yet
@@ -996,103 +994,16 @@ void kvm_tdp_mmu_zap_all(struct kvm *kvm)
  	}
  }
  
-static struct kvm_mmu_page *next_invalidated_root(struct kvm *kvm,
-						  struct kvm_mmu_page *prev_root)
-{
-	struct kvm_mmu_page *next_root;
-
-	if (prev_root)
-		next_root = list_next_or_null_rcu(&kvm->arch.tdp_mmu_roots,
-						  &prev_root->link,
-						  typeof(*prev_root), link);
-	else
-		next_root = list_first_or_null_rcu(&kvm->arch.tdp_mmu_roots,
-						   typeof(*next_root), link);
-
-	while (next_root && !(next_root->role.invalid &&
-			      refcount_read(&next_root->tdp_mmu_root_count)))
-		next_root = list_next_or_null_rcu(&kvm->arch.tdp_mmu_roots,
-						  &next_root->link,
-						  typeof(*next_root), link);
-
-	return next_root;
-}
-
-/*
- * Zap all invalidated roots to ensure all SPTEs are dropped before the "fast
- * zap" completes.  Since kvm_tdp_mmu_invalidate_all_roots() has acquired a
- * reference to each invalidated root, roots will not be freed until after this
- * function drops the gifted reference, e.g. so that vCPUs don't get stuck with
- * tearing paging structures.
- */
-void kvm_tdp_mmu_zap_invalidated_roots(struct kvm *kvm)
-{
-	struct kvm_mmu_page *next_root;
-	struct kvm_mmu_page *root;
-
-	lockdep_assert_held_read(&kvm->mmu_lock);
-
-	rcu_read_lock();
-
-	root = next_invalidated_root(kvm, NULL);
-
-	while (root) {
-		next_root = next_invalidated_root(kvm, root);
-
-		rcu_read_unlock();
-
-		/*
-		 * Zap the root regardless of what marked it invalid, e.g. even
-		 * if the root was marked invalid by kvm_tdp_mmu_put_root() due
-		 * to its last reference being put.  All SPTEs must be dropped
-		 * before returning to the caller, e.g. if a memslot is deleted
-		 * or moved, the memslot's associated SPTEs are unreachable via
-		 * the mmu_notifier once the memslot update completes.
-		 *
-		 * A TLB flush is unnecessary, invalidated roots are guaranteed
-		 * to be unreachable by the guest (see kvm_tdp_mmu_put_root()
-		 * for more details), and unlike the legacy MMU, no vCPU kick
-		 * is needed to play nice with lockless shadow walks as the TDP
-		 * MMU protects its paging structures via RCU.  Note, zapping
-		 * will still flush on yield, but that's a minor performance
-		 * blip and not a functional issue.
-		 */
-		tdp_mmu_zap_root(kvm, root, true);
-
-		/*
-		 * Put the reference acquired in
-		 * kvm_tdp_mmu_invalidate_roots
-		 */
-		kvm_tdp_mmu_put_root(kvm, root, true);
-
-		root = next_root;
-
-		rcu_read_lock();
-	}
-
-	rcu_read_unlock();
-}
-
  /*
   * Mark each TDP MMU root as invalid to prevent vCPUs from reusing a root that
- * is about to be zapped, e.g. in response to a memslots update.  The caller is
- * responsible for invoking kvm_tdp_mmu_zap_invalidated_roots() to the actual
- * zapping.
- *
- * Take a reference on all roots to prevent the root from being freed before it
- * is zapped by this thread.  Freeing a root is not a correctness issue, but if
- * a vCPU drops the last reference to a root prior to the root being zapped, it
- * will get stuck with tearing down the entire paging structure.
- *
- * Get a reference even if the root is already invalid,
- * kvm_tdp_mmu_zap_invalidated_roots() assumes it was gifted a reference to all
- * invalid roots, e.g. there's no epoch to identify roots that were invalidated
- * by a previous call.  Roots stay on the list until the last reference is
- * dropped, so even though all invalid roots are zapped, a root may not go away
- * for quite some time, e.g. if a vCPU blocks across multiple memslot updates.
+ * is about to be zapped, e.g. in response to a memslots update.  The actual
+ * zapping is performed asynchronously, so a reference is taken on all roots
+ * as well as (once per root) on the struct kvm.
   *
- * Because mmu_lock is held for write, it should be impossible to observe a
- * root with zero refcount, i.e. the list of roots cannot be stale.
+ * Get a reference even if the root is already invalid, the asynchronous worker
+ * assumes it was gifted a reference to the root it processes.  Because mmu_lock
+ * is held for write, it should be impossible to observe a root with zero refcount,
+ * i.e. the list of roots cannot be stale.
   *
   * This has essentially the same effect for the TDP MMU
   * as updating mmu_valid_gen does for the shadow MMU.
@@ -1103,8 +1014,11 @@ void kvm_tdp_mmu_invalidate_all_roots(struct kvm *kvm)
  
  	lockdep_assert_held_write(&kvm->mmu_lock);
  	list_for_each_entry(root, &kvm->arch.tdp_mmu_roots, link) {
-		if (!WARN_ON_ONCE(!kvm_tdp_mmu_get_root(root)))
+		if (!WARN_ON_ONCE(!kvm_tdp_mmu_get_root(root))) {
  			root->role.invalid = true;
+			kvm_get_kvm(kvm);
+			tdp_mmu_schedule_zap_root(kvm, root);
+		}
  	}
  }
  

It passes a smoke test, and also resolves the debate on the fate of patch 1.

However, I think we now need a module_get/module_put when creating/destroying
a VM; the workers can outlive kvm_vm_release and therefore any reference
automatically taken by VFS's fops_get/fops_put.

Paolo
