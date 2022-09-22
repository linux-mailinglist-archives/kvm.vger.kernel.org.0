Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 86A655E66FA
	for <lists+kvm@lfdr.de>; Thu, 22 Sep 2022 17:23:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232087AbiIVPXw (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 22 Sep 2022 11:23:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49352 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232026AbiIVPXu (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 22 Sep 2022 11:23:50 -0400
Received: from mail-pj1-x102c.google.com (mail-pj1-x102c.google.com [IPv6:2607:f8b0:4864:20::102c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2C07FF8593
        for <kvm@vger.kernel.org>; Thu, 22 Sep 2022 08:23:49 -0700 (PDT)
Received: by mail-pj1-x102c.google.com with SMTP id go6so10121698pjb.2
        for <kvm@vger.kernel.org>; Thu, 22 Sep 2022 08:23:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date;
        bh=4hng9hD+p8EXRULnhypgit8nkIBrMiyFlLkFJQuqnXc=;
        b=hAZG3ucwHKwhSmqY9M0JepTbrCdrwuxIOlZAN4MIln08/ZYtOmSZIrjXhu83r9WToT
         cL4m3YiaaRpB5np/geOW4TqgYMpojuvlBsmci8MYwYZRR/YxSAJkQsub7kwBn51uAC7E
         RQODedh13sgSTsAKYla0DDIkncCfopXkXlxRG2iT8OMqVnIZmcTmodDqPFA8iJ7Sant6
         DsSxnevUh4wBlBFd6KOZhMUaa15TaA7/eHJOPNUg1f5o9mcjWHnSAqrXWD/M4shdG+rk
         LKY1oOltcI5nJuGYX8cloZDuOJJnEvd3MfSvLe5rOZYYAVszuwj0Z/bQW0FGrOJbfcSc
         tRdw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date;
        bh=4hng9hD+p8EXRULnhypgit8nkIBrMiyFlLkFJQuqnXc=;
        b=20FRhspO0H80MpJj5I6VlhmLa6T49grUJoBv42KSY4R0n4L4nNDe8SDe3TZnA1HurO
         94JDURCqhtqY3e8lSY2QXbsAhVRbRJ7J5qFTri8Gw1sr4jtKB0GxO6pCguLXnAywea3B
         naQ7XItu3xXI8zBV+a4d2djRiIbTTrufF7h0TnO17Mj+S6t7IOq2Zdn3qeOKn9JrRhGX
         JFrlkdxCUXYbqKzawA/srwEIavwW1lc0nk87rNd4Z3bk/8HPw2hR3s7ba/4lJgNkjJqA
         FuZlbn1dwVgKrnZGlSLq3N0ctwVzwi1D6bhoo0UMnKlJzbtw+aOpiLHdgA5s0LXIBCRv
         oBDg==
X-Gm-Message-State: ACrzQf2iUjKGX2/UMZDESCNx+2Ly/d1Q39D/3E5NV6cEvUSYIpegqw0N
        AOqbo1uSbt218ghYpSFpeaqziQ==
X-Google-Smtp-Source: AMsMyM6D+AGe91n2NZ575lPSmGsw6EyKNHU4hFvUJeis6VvODRCrcbGL9qsraoDtCgAxRQCSlX7f5w==
X-Received: by 2002:a17:902:f394:b0:176:b7b7:2 with SMTP id f20-20020a170902f39400b00176b7b70002mr3709012ple.57.1663860228501;
        Thu, 22 Sep 2022 08:23:48 -0700 (PDT)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id 13-20020a62140d000000b0053e93aa8fb9sm4579212pfu.71.2022.09.22.08.23.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 22 Sep 2022 08:23:48 -0700 (PDT)
Date:   Thu, 22 Sep 2022 15:23:44 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Vitaly Kuznetsov <vkuznets@redhat.com>
Cc:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Michael Kelley <mikelley@microsoft.com>,
        Siddharth Chandrasekaran <sidcha@amazon.de>,
        Yuan Yao <yuan.yao@linux.intel.com>,
        Maxim Levitsky <mlevitsk@redhat.com>,
        linux-hyperv@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v10 02/39] KVM: x86: hyper-v: Resurrect dedicated
 KVM_REQ_HV_TLB_FLUSH flag
Message-ID: <Yyx+AJLacVzOdtBr@google.com>
References: <20220921152436.3673454-1-vkuznets@redhat.com>
 <20220921152436.3673454-3-vkuznets@redhat.com>
 <Yys6b1ZqYbw9Umyu@google.com>
 <877d1voiuz.fsf@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <877d1voiuz.fsf@redhat.com>
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Sep 22, 2022, Vitaly Kuznetsov wrote:
> Now let's get to VMX and the point of my confusion (and thanks in
> advance for educating me!):
> AFAIU, when EPT is in use:
>  KVM_REQ_TLB_FLUSH_CURRENT == invept
>  KVM_REQ_TLB_FLUSH_GUEST = invvpid
> 
> For "normal" mappings (which are mapped on both stages) this is the same
> thing as they're 'tagged' with both VPID and 'EPT root'. The question is
> what's left. Given your comment, do I understand correctly that in case
> of an invalid mapping in the guest (GVA doesn't resolve to a GPA), this
> will only be tagged with VPID but not with 'EPT root' (as the CPU never
> reached to the second translation stage)? We certainly can't ignore
> these. Another (probably pure theoretical question) is what are the
> mappings which are tagged with 'EPT root' but don't have a VPID tag?

Intel puts mappings into three categories, which for non-root mode equates to:

  linear         == GVA => GPA
  guest-physical == GPA => HPA
  combined       == GVA => HPA

and essentially the categories that consume the GVA are tagged with the VPID
(linear and combined), and categories that consume the GPA are tagged with the
EPTP address (guest-physical and combined).

> Are these the mapping which happen when e.g. vCPU has paging disabled?

No, these mappings can be created at all times.  Even with CR0.PG=1, the guest
can generate GPAs without going through a GVA=>GPA translation, e.g. the page tables
themselves, RTIT (Intel PT) addresses, etc...  And even for combined/full
translations, the CPU can insert TLB entries for just the GPA=>HPA part.

E.g. when a page is allocated by/for userspace, the kernel will zero the page using
the kernel's direct map, but userspace will access the page via a different GVA.
I.e. the guest effectively aliases GPA(x) with GVA(k) and GVA(u).  By inserting
the GPA(x) => HPA(y) into the TLB, when guest userspace access GVA(u), the CPU
encounters a TLB miss on GVA(u) => GPA(x), but gets a TLB hit on GPA(x) => HPA(y).

Separating EPT flushes from VPID (and PCID) flushes allows the CPU to retain
the partial TLB entries, e.g. a host change in the EPT tables will result in the
guest-physical and combined mappings being invalidated, but linear mappings can
be kept.

I'm 99% certain AMD also caches partial entries, e.g. see the blurb on INVLPGA
not affecting NPT translations, AMD just doesn't provide a way for the host to
flush _only_ NPT translations.  Maybe the performance benefits weren't significant
enough to justify the extra complexity?

> These are probably unrelated to Hyper-V TLB flushing.
> 
> To preserve the 'small' optimization, we can probably move 
>  kvm_clear_request(KVM_REQ_HV_TLB_FLUSH, vcpu);
> 
> to nested_svm_transition_tlb_flush() or, in case this sounds too
> hackish

Move it to svm_flush_tlb_current(), because the justification is that on SVM,
flushing "current" TLB entries also flushes "guest" TLB entries due to the more
coarse-grained ASID-based TLB flush.  E.g.

diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index dd599afc85f5..a86b41503723 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -3737,6 +3737,13 @@ static void svm_flush_tlb_current(struct kvm_vcpu *vcpu)
 {
        struct vcpu_svm *svm = to_svm(vcpu);
 
+       /*
+        * Unlike VMX, SVM doesn't provide a way to flush only NPT TLB entries.
+        * A TLB flush for the current ASID flushes both "host" and "guest" TLB
+        * entries, and thus is a superset of Hyper-V's fine grained flushing.
+        */
+       kvm_hv_vcpu_purge_flush_tlb(vcpu);
+
        /*
         * Flush only the current ASID even if the TLB flush was invoked via
         * kvm_flush_remote_tlbs().  Although flushing remote TLBs requires all

> we can drop it for now and add it to the (already overfull)
> bucket of the "optimize nested_svm_transition_tlb_flush()".

I think even long term, purging Hyper-V's FIFO in svm_flush_tlb_current() is the
correct/desired behavior.  This doesn't really have anything to do with nSVM,
it's all about SVM not providing a way to flush only NPT entries.
