Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7009C6EEA2A
	for <lists+kvm@lfdr.de>; Wed, 26 Apr 2023 00:02:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236297AbjDYWCB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 25 Apr 2023 18:02:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46382 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232817AbjDYWB7 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 25 Apr 2023 18:01:59 -0400
Received: from mail-pl1-x634.google.com (mail-pl1-x634.google.com [IPv6:2607:f8b0:4864:20::634])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0CDA3DE
        for <kvm@vger.kernel.org>; Tue, 25 Apr 2023 15:01:58 -0700 (PDT)
Received: by mail-pl1-x634.google.com with SMTP id d9443c01a7336-1a66911f5faso51610525ad.0
        for <kvm@vger.kernel.org>; Tue, 25 Apr 2023 15:01:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1682460117; x=1685052117;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=L8DPNyuyk2/u+aEgseKKlFNQ27d0QT6mpfVWpUBlqwY=;
        b=cO1943ed+PS9Mueux5UEXL+zcs07hWnyKhXuto5xtQxJrV7RWRfn+F8YSvhEOeA5V9
         YDOaV6JeGwRrR6XS9MSvFoHc9BnFN3e9Y7IBMhHPzTMfOKrd4cj5DnmY7OTINTRmFFlp
         mGdhVi/8HWhe8z4ELfJw9hLHOApOi8oc+GMm5L+diWE9lhNtbzl849UgPaEo6OG8SN8E
         feOrRFoy0jmIXL015jpFk3WwSGUTu1w8oMezBiIvPKk/2TbSQMXC/E0cdl7oj+WI1asF
         F3TPeZEKmBdN1zWvqLn2O4ym26sPXu31+Fyr78oJlMYjJxwFA9fe9mKef25OtKXR6aYI
         XZ0A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682460117; x=1685052117;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=L8DPNyuyk2/u+aEgseKKlFNQ27d0QT6mpfVWpUBlqwY=;
        b=hLvc6NJI6weg20vn3SaCWIEvcO+4zLdi1xNKoC2ajt22CI4nF3mX5+v0kAa7IAdDkj
         BfLhBljMpLc5tiyp1FmjQ0+ZGdkffUDTzg6RBIexXG4VVgeC5FRWPFwmz317kyp/IYTd
         gucd2NYcTlkKtJ7eBzyxEZSFx/oWJ12oJGFnb2beL9V30Xih8BxqLQQXOJmxbabwlZmX
         FtvIzOTeAFD7cTkrx2bYOVVVpv4aFTE04M3kCMiJkwKbN0LbzVLfDenV+vtbMQI14Yq2
         tgUPFfvUZj/uF+KRQTB5ZfMaEBPXpHT+dLOmjPeDYHnCqf+25q7Xq+XAe8ty4sx9MU7r
         xctw==
X-Gm-Message-State: AC+VfDw48W3FLrubaKXYAhHCtWCmo3Tn+JRtdeSuxl+WD1DoaZWcuuVm
        Oi098wLkTIUStLefHnbb0U+pexzYY9PPvIoGWmiuyw==
X-Google-Smtp-Source: ACHHUZ5PvKA3yqtp6okzk8XFv0JEK9ceBZZFly+9yscLyOUAIKN6f4iUG39sCTE5+NymUhna9sCxwQ==
X-Received: by 2002:a17:903:18c:b0:1a9:8ddd:8215 with SMTP id z12-20020a170903018c00b001a98ddd8215mr4209724plg.4.1682460117394;
        Tue, 25 Apr 2023 15:01:57 -0700 (PDT)
Received: from google.com (223.103.125.34.bc.googleusercontent.com. [34.125.103.223])
        by smtp.gmail.com with ESMTPSA id jd15-20020a170903260f00b001a97ffb87b7sm3033905plb.12.2023.04.25.15.01.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 25 Apr 2023 15:01:56 -0700 (PDT)
Date:   Tue, 25 Apr 2023 15:01:52 -0700
From:   David Matlack <dmatlack@google.com>
To:     Sean Christopherson <seanjc@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Jeremi Piotrowski <jpiotrowski@linux.microsoft.com>,
        Ben Gardon <bgardon@google.com>
Subject: Re: [PATCH v2] KVM: x86: Preserve TDP MMU roots until they are
 explicitly invalidated
Message-ID: <ZEhN0D1zZyRDeyYz@google.com>
References: <20230421214946.2571580-1-seanjc@google.com>
 <CALzav=f=TFoqpR5tPDPOujoO6Gix-+zL-sZyyZK27qJvGPP9dg@mail.gmail.com>
 <ZEM+09p7QBJR7DoI@google.com>
 <CALzav=cOB5rdwutrAa3eqFzHbdR-Dct0BAJWbExf1cTjUq2Mjw@mail.gmail.com>
 <ZEcglWoeGS3pc5kK@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZEcglWoeGS3pc5kK@google.com>
X-Spam-Status: No, score=-14.5 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,FSL_HELO_FAKE,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Apr 24, 2023 at 05:36:37PM -0700, Sean Christopherson wrote:
> On Mon, Apr 24, 2023, David Matlack wrote:
> > It'd be nice to keep around the lockdep assertion though for the other (and
> > future) callers. The cleanest options I can think of are:
> > 
> > 1. Pass in a bool "vm_teardown" kvm_tdp_mmu_invalidate_all_roots() and
> > use that to gate the lockdep assertion.
> > 2. Take the mmu_lock for read in kvm_mmu_uninit_tdp_mmu() and pass
> > down bool shared to kvm_tdp_mmu_invalidate_all_roots().
> > 
> > Both would satisfy your concern of not blocking teardown on the async
> > worker and my concern of keeping the lockdep check. I think I prefer
> > (1) since, as you point out, taking the mmu_lock at all is
> > unnecessary.
> 
> Hmm, another option:
> 
>  3. Refactor the code so that kvm_arch_init_vm() doesn't call
>     kvm_tdp_mmu_invalidate_all_roots() when VM creation fails, and then lockdep
>     can ignore on users_count==0 without hitting the false positive.
> 
> I like (2) the least.  Not sure I prefer (1) versus (3).  I dislike passing bools
> just to ignore lockdep, but reworking code for a "never hit in practice" edge case
> is arguably worse :-/

Agree (2) is the worst option. (3) seems potentially brittle (likely to
trigger a false-positive lockdep warning if the code ever gets
refactored back).

How about throwing some underscores at the problem?

diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
index 649e1773baf1..3e00afc31c71 100644
--- a/arch/x86/kvm/mmu/tdp_mmu.c
+++ b/arch/x86/kvm/mmu/tdp_mmu.c
@@ -38,6 +38,8 @@ static __always_inline bool kvm_lockdep_assert_mmu_lock_held(struct kvm *kvm,
 	return true;
 }
 
+static void __kvm_tdp_mmu_invalidate_all_roots(struct kvm *kvm);
+
 void kvm_mmu_uninit_tdp_mmu(struct kvm *kvm)
 {
 	/*
@@ -45,7 +47,7 @@ void kvm_mmu_uninit_tdp_mmu(struct kvm *kvm)
 	 * for zapping and thus puts the TDP MMU's reference to each root, i.e.
 	 * ultimately frees all roots.
 	 */
-	kvm_tdp_mmu_invalidate_all_roots(kvm);
+	__kvm_tdp_mmu_invalidate_all_roots(kvm);
 
 	/*
 	 * Destroying a workqueue also first flushes the workqueue, i.e. no
@@ -1004,7 +1006,7 @@ void kvm_tdp_mmu_zap_invalidated_roots(struct kvm *kvm)
  * Note, the asynchronous worker is gifted the TDP MMU's reference.
  * See kvm_tdp_mmu_get_vcpu_root_hpa().
  */
-void kvm_tdp_mmu_invalidate_all_roots(struct kvm *kvm)
+static void __kvm_tdp_mmu_invalidate_all_roots(struct kvm *kvm)
 {
 	struct kvm_mmu_page *root;
 
@@ -1026,6 +1028,12 @@ void kvm_tdp_mmu_invalidate_all_roots(struct kvm *kvm)
 	rcu_read_unlock();
 }
 
+void kvm_tdp_mmu_invalidate_all_roots(struct kvm *kvm)
+{
+	lockdep_assert_held_write(&kvm->mmu_lock);
+	__kvm_tdp_mmu_invalidate_all_roots(kvm);
+}
+
 /*
  * Installs a last-level SPTE to handle a TDP page fault.
  * (NPT/EPT violation/misconfiguration)
