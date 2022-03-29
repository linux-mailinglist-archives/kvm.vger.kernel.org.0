Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 021224EB6B9
	for <lists+kvm@lfdr.de>; Wed, 30 Mar 2022 01:26:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240400AbiC2X2R (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 29 Mar 2022 19:28:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33706 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239126AbiC2X2O (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 29 Mar 2022 19:28:14 -0400
Received: from mail-pj1-x1029.google.com (mail-pj1-x1029.google.com [IPv6:2607:f8b0:4864:20::1029])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 49CF5186F95
        for <kvm@vger.kernel.org>; Tue, 29 Mar 2022 16:26:30 -0700 (PDT)
Received: by mail-pj1-x1029.google.com with SMTP id p4-20020a17090ad30400b001c7ca87c05bso392508pju.1
        for <kvm@vger.kernel.org>; Tue, 29 Mar 2022 16:26:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=FyT36mVFWHHmMaSNyNgttXeXWMR6GXiSODHEfHAzs+E=;
        b=ba0JAx2n4kkjoAQZJSqFJ69WwtL9z52owYSJ/KvYr9qfAEVMgIjcQHCDGPl6xQDA9F
         WoEhch7+l7DkM+nzyTxnQfvvtAqvX0ZgUlPGdQbz/iF99L0mJ8YzON6BFMsVkG3f0M6j
         ngfRX4ko8C/xzX0qHIRWhfrzT9fqYeJF1rkBO9TQ5vqXnGUf9qOlt7cUyvdwmXG8EQbJ
         D8mzrro8Jk5++JdkZPrPAEljZgGdhBE3F9w7DPw4v6duLNJ+IrMwnL+BCHDKfTXAE77T
         nWYiR792di2q+VxOaVkzWT+iuCGnfRCgI9r8MVIW6tZGcAVzKSgMZm0ClndvRxWcLRKx
         xlqA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=FyT36mVFWHHmMaSNyNgttXeXWMR6GXiSODHEfHAzs+E=;
        b=BUTCyVmZWBxr0BP57QULBFp8otZnNi2G0YtfmwwUK6ANHH8Nb8qob5jkpQ3en4B5hP
         c5j5OOIbXhIfjI1g67FHjFZq7g1N7tPKRw1WAW+PhzteZRIUF8Ma8UxL+PLYxZdkk7rD
         V0VG4UgdWZ1f0GZJQnEKf8c9mKxIHFxxTcNFqkH6tpC399Q8Qd+4H3rXUzqbonyhkoUw
         tVJaDsaIBOf+fJa7h11ooy1Ov5V4Q2Yy963kZR8I701H1zfX4nMuE8Dkwit4wvUr53Aj
         1PU4OqGPAdZH37YBj+SLtiGy6TCbfi0AiJ6BYbjwDKedESC3oi7/PZiZE+AJIfHVXUFX
         0hLA==
X-Gm-Message-State: AOAM533KHFgUsQxdPSz/m/U7cktdSWKvWuNrZSESHZ9uGb1dkf8bqD8d
        qAv0kmHKDK1GD3aFI/XyD1+SfA==
X-Google-Smtp-Source: ABdhPJwnOb3NjFRKz1nmRlqh+ZvHsNMeDbIoEzibgQi4hxNEPlUdqkFegwqHxwwedq2s7qqe61C/mA==
X-Received: by 2002:a17:902:d70e:b0:156:1b99:e909 with SMTP id w14-20020a170902d70e00b001561b99e909mr9037358ply.155.1648596389575;
        Tue, 29 Mar 2022 16:26:29 -0700 (PDT)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id t10-20020a056a00138a00b004fa9c9fda44sm21128713pfg.89.2022.03.29.16.26.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 29 Mar 2022 16:26:28 -0700 (PDT)
Date:   Tue, 29 Mar 2022 23:26:25 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Like Xu <like.xu.linux@gmail.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
        Jim Mattson <jmattson@google.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Joerg Roedel <joro@8bytes.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 1/4] KVM: x86: Move kvm_ops_static_call_update() to
 x86.c
Message-ID: <YkOVofVoJD6s1W7I@google.com>
References: <20220307115920.51099-1-likexu@tencent.com>
 <20220307115920.51099-2-likexu@tencent.com>
 <YkOPT7TJf74C2Wq8@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YkOPT7TJf74C2Wq8@google.com>
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Mar 29, 2022, Sean Christopherson wrote:
> On Mon, Mar 07, 2022, Like Xu wrote:
> > From: Like Xu <likexu@tencent.com>
> > 
> > The kvm_ops_static_call_update() is defined in kvm_host.h. That's
> > completely unnecessary, it should have exactly one caller,
> > kvm_arch_hardware_setup().  As a prep match, move
> > kvm_ops_static_call_update() to x86.c, then it can reference
> > the kvm_pmu_ops stuff.
> > 
> > Suggested-by: Sean Christopherson <seanjc@google.com>
> > Signed-off-by: Like Xu <likexu@tencent.com>
> > ---
> 
> Reviewed-by: Sean Christopherson <seanjc@google.com>

Actually, I take that back.  If we pass in @ops, and do some other minor tweaks
along the way, then we can make kvm_pmu_ops static.

I'll post a very compile-tested-only v3.1, trying to generate diffs against your
series is going to be painful due to conflicts.  The changes aren't big, just
annoying.

Below is the diff for this patch.  Then in patch 2, kvm_ops_update() adds a call
to kvm_pmu_ops_update().  Patch 3 just tweaks the call to use ops->pmu_ops instead
of ops->runtime_ops->pmu_ops.  Patch 4 becomes purely code shuffling (I think).

---
 arch/x86/kvm/x86.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 9cb8672aab92..99aa2d16845a 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -11595,8 +11595,10 @@ void kvm_arch_hardware_disable(void)
 	drop_user_return_notifiers();
 }

-static inline void kvm_ops_static_call_update(void)
+static inline void kvm_ops_update(struct kvm_x86_init_ops *ops)
 {
+	memcpy(&kvm_x86_ops, ops->runtime_ops, sizeof(kvm_x86_ops));
+
 #define __KVM_X86_OP(func) \
 	static_call_update(kvm_x86_##func, kvm_x86_ops.func);
 #define KVM_X86_OP(func) \
@@ -11623,8 +11625,7 @@ int kvm_arch_hardware_setup(void *opaque)
 	if (r != 0)
 		return r;

-	memcpy(&kvm_x86_ops, ops->runtime_ops, sizeof(kvm_x86_ops));
-	kvm_ops_static_call_update();
+	kvm_ops_update(ops);

 	kvm_register_perf_callbacks(ops->handle_intel_pt_intr);


base-commit: bd6b09f0754bea388a189d544ce11d83206579a2
--

