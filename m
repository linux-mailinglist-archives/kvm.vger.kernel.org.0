Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 802CC4CC897
	for <lists+kvm@lfdr.de>; Thu,  3 Mar 2022 23:08:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234523AbiCCWJB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 3 Mar 2022 17:09:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55724 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233943AbiCCWJA (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 3 Mar 2022 17:09:00 -0500
Received: from mail-pl1-x62c.google.com (mail-pl1-x62c.google.com [IPv6:2607:f8b0:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AF9B63DA49
        for <kvm@vger.kernel.org>; Thu,  3 Mar 2022 14:08:13 -0800 (PST)
Received: by mail-pl1-x62c.google.com with SMTP id e13so6021002plh.3
        for <kvm@vger.kernel.org>; Thu, 03 Mar 2022 14:08:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=W/TzNiPeigL0ybLFFuG1hFcpyfv81UUM7woffq6f+EE=;
        b=MMHEBXueAzqDEsE5wiiM5H+gGRnExkrrDKWkUaSEsk8DUCsdP27CLVo1vaTeJagjSr
         CiSEEsg3qJYJhHI+vrnS5A90omkj8FP4rq2zSR/D4ysjtAigzqxd7qwbyD4sPZ02KMNP
         K1eiuAfmfwVG6l7GIMdKYvviXNx51N2HchR1qs5UwuIIDSFUegSoQvUBgRARyBt3uRwU
         N8Ejvgj3Eg3iYS5s35YWhFr+571WFqfNXsmYNCP/gtaJI350Ui9f6V5AQrAz34Mtarl9
         WLyBVNlYcqmvorwlbfpNrLd1eejIvs5IcScpPf/nleW6qvKLVUuwBtRKlAyYSME2X5Yi
         8GEQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=W/TzNiPeigL0ybLFFuG1hFcpyfv81UUM7woffq6f+EE=;
        b=xvF4SMsHVBqiVWjmsbdLP9LgQ2D6DxRIkHnAqCw9yZsCnWOf62xIGbUSw2pFb6DP3O
         QOQsMWb/OUM/ir+no3SHwbu2QTILoaSkFrfQrMHOFLPhr9MGg0abOAAZlPNbtI29WuKj
         XPL6u4h5tje7IFGG8dl7TAosWFqpnW6e4W9kTqMLW7alIZpEWVOC9RGgBtzzpbjJ5swF
         bepONPRyHxjqnE60tjXLE3k56rduoy5K6mU6opTrlkOohtvFTs891owsRkDzqsLam9EA
         J323voCWkL2SDDg0xv6Z9LAeH8aLjxE1Yqe0otRExdn9stRs0PsvLtpH2uSTLwmqY1vl
         GFfQ==
X-Gm-Message-State: AOAM5306nyVfknhN72+sdx45Pv3GMmWLCqUqPPJTAHblNUyYSyrEDoUX
        97pL0pRMnV8vNikxWxLAErZX6g==
X-Google-Smtp-Source: ABdhPJy8b6qcW2LqSXVR4nuKQ0P9aVRPzmLSKf1goQOakMcT/YeEL9h873IMeVWnAPnqEkLCQTihJg==
X-Received: by 2002:a17:90a:20a:b0:1be:e850:1a37 with SMTP id c10-20020a17090a020a00b001bee8501a37mr7569061pjc.28.1646345292897;
        Thu, 03 Mar 2022 14:08:12 -0800 (PST)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id m20-20020a634c54000000b003739af127c9sm2889926pgl.70.2022.03.03.14.08.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 03 Mar 2022 14:08:12 -0800 (PST)
Date:   Thu, 3 Mar 2022 22:08:08 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        David Hildenbrand <david@redhat.com>,
        David Matlack <dmatlack@google.com>,
        Ben Gardon <bgardon@google.com>,
        Mingwei Zhang <mizhang@google.com>
Subject: Re: [PATCH v4 24/30] KVM: x86/mmu: Zap defunct roots via
 asynchronous worker
Message-ID: <YiE8SH4Sn1zzRZwe@google.com>
References: <20220303193842.370645-1-pbonzini@redhat.com>
 <20220303193842.370645-25-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220303193842.370645-25-pbonzini@redhat.com>
X-Spam-Status: No, score=-18.1 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Mar 03, 2022, Paolo Bonzini wrote:
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
> Co-developed-by: Sean Christopherson <seanjc@google.com>
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> Reviewed-by: Ben Gardon <bgardon@google.com>
> Message-Id: <20220226001546.360188-23-seanjc@google.com>
> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
> ---
>  arch/x86/kvm/mmu/tdp_mmu.c | 15 +++++++++++++--
>  1 file changed, 13 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
> index e24a1bff9218..2456f880508d 100644
> --- a/arch/x86/kvm/mmu/tdp_mmu.c
> +++ b/arch/x86/kvm/mmu/tdp_mmu.c
> @@ -170,13 +170,24 @@ void kvm_tdp_mmu_put_root(struct kvm *kvm, struct kvm_mmu_page *root,
>  	 */
>  	if (!kvm_tdp_root_mark_invalid(root)) {
>  		refcount_set(&root->tdp_mmu_root_count, 1);
> -		tdp_mmu_zap_root(kvm, root, shared);
>  
>  		/*
> -		 * Give back the reference that was added back above.  We now
> +		 * If the struct kvm is alive, we might as well zap the root
> +		 * in a worker.  The worker takes ownership of the reference we
> +		 * just added to root and is flushed before the struct kvm dies.

Not a fan of the "we might as well zap the root in a worker", IMO we should require
going forward that invalidated, reachable TDP MMU roots are always zapped in a worker

> +		 */
> +		if (likely(refcount_read(&kvm->users_count))) {
> +			tdp_mmu_schedule_zap_root(kvm, root);

Regarding the need for kvm_tdp_mmu_invalidate_all_roots() to guard against
re-queueing a root for zapping, this is the point where it becomes functionally
problematic.  When "fast zap" was the only user of tdp_mmu_schedule_zap_root(),
re-queueing was benign as the work struct was guaranteed to not be currently
queued.  But this code runs outside of slots_lock, and so a root that was "put"
but hasn't finished zapping can be observed and re-queued by the "fast zap.

I think it makes sense to create a rule/invariant that an invalidated TDP MMU root
_must_ be zapped via the work queue.  Then 

I.e. do this as fixup:

diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
index 40bf861b622a..cff4f2102a63 100644
--- a/arch/x86/kvm/mmu/tdp_mmu.c
+++ b/arch/x86/kvm/mmu/tdp_mmu.c
@@ -1019,8 +1019,9 @@ void kvm_tdp_mmu_zap_invalidated_roots(struct kvm *kvm)
  * of invalidated roots; the list is effectively the list of work items in
  * the workqueue.
  *
- * Skip roots that are already queued for zapping, flushing the work queue will
- * ensure invalidated roots are zapped regardless of when they were queued.
+ * Skip roots that are already invalid and thus queued for zapping, flushing
+ * the work queue will ensure invalid roots are zapped regardless of when they
+ * were queued.
  *
  * Because mmu_lock is held for write, it should be impossible to observe a
  * root with zero refcount,* i.e. the list of roots cannot be stale.
@@ -1034,13 +1035,12 @@ void kvm_tdp_mmu_invalidate_all_roots(struct kvm *kvm)

        lockdep_assert_held_write(&kvm->mmu_lock);
        list_for_each_entry(root, &kvm->arch.tdp_mmu_roots, link) {
-               if (root->tdp_mmu_async_data)
+               if (kvm_tdp_root_mark_invalid(root))
                        continue;

                if (WARN_ON_ONCE(!kvm_tdp_mmu_get_root(root)))
                        continue;

-               root->role.invalid = true;
                tdp_mmu_schedule_zap_root(kvm, root);
        }
 }

> +			return;
> +		}
> +
> +		/*
> +		 * The struct kvm is being destroyed, zap synchronously and give
> +		 * back immediately the reference that was added above.  We now
>  		 * know that the root is invalid, so go ahead and free it if
>  		 * no one has taken a reference in the meanwhile.
>  		 */
> +		tdp_mmu_zap_root(kvm, root, shared);
>  		if (!refcount_dec_and_test(&root->tdp_mmu_root_count))
>  			return;
>  	}
> -- 
> 2.31.1
> 
>
