Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 189F64CC31F
	for <lists+kvm@lfdr.de>; Thu,  3 Mar 2022 17:45:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235126AbiCCQqB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 3 Mar 2022 11:46:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50924 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234982AbiCCQqB (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 3 Mar 2022 11:46:01 -0500
Received: from mail-pj1-x1029.google.com (mail-pj1-x1029.google.com [IPv6:2607:f8b0:4864:20::1029])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1BE2D144F7E
        for <kvm@vger.kernel.org>; Thu,  3 Mar 2022 08:45:15 -0800 (PST)
Received: by mail-pj1-x1029.google.com with SMTP id g7-20020a17090a708700b001bb78857ccdso8165338pjk.1
        for <kvm@vger.kernel.org>; Thu, 03 Mar 2022 08:45:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=g6+Bgscz4A12mtjsMs2UGiNk6pdRuPkr9UQuc3y7nc4=;
        b=oFnWiTvJ7+c7OphCYdoEr/zfe/hDyOuPHj1U1yVNirUQ3v7uMUGsvZQwofnmTdOu5U
         f86AAbzgmNsb0Sex7o+t/MRHpEgnnRcP0agFJcaEUdzukYcqFM6Alv4QukuzSAz6I2RR
         QdmLjWjdwYXSbHYu5marH3Cx+X8b7Y3Bgf7EcwurJF19SdEmsBAkxUSFx/wsQ48orP5A
         QAwnQ8i/KT5hlhDxPI1abC2+rCCpROMR64SMdOKmBEmH3ptuMidqhZjdq2nCLb6LHpm6
         K7z+s1qSlwPNWZ4CzkUpA67wKgGExLeJTg2AxhUCpyQrf4bjEH69moZr3g5nCD8LeHy2
         xzSA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=g6+Bgscz4A12mtjsMs2UGiNk6pdRuPkr9UQuc3y7nc4=;
        b=bGhgPgj8Yne1PAIzblZ83YUvw8SsyKRSkUu/Y5cto/zizWfEiTgdgXK6ME1psYz3d4
         AYK/nl4xO/mswCoyO+WrhuobK8Wvxr8UrPh/UMdgW1w/fwq3rKKk2p31GVEgbajHuS+j
         bqSfm+rRUX28Ri/NQ4orUvauIitg1lMdfUwqlJv3zj3ORh5532AVoj1kcLk7R7XoxpxA
         UQnn9DHDJdEtcviw/l1fufPE9XTTRjGFBbpVKXMMqneOk8Gdmu+Od7tRfmW0ZinTj1RZ
         Zc2Kepb3RUuygX3ehhuLmBEIFjn2F/+OIZf80+h9e7Md9CB96oyjd9HZm4hniAzpNrOH
         xaug==
X-Gm-Message-State: AOAM531vOBtZEvHxBTKnI2Kkq66Lv5KwyCco0tx/b5nnQBu9fmDLqSpq
        IBmPH31qRsuOGk3Ex/pEZuE3Yg==
X-Google-Smtp-Source: ABdhPJwt8WS4EciJxvgfW2RxOhUaNmalWWPviWMa9nDBW3nOq9iy3kCckWM8qMrbYhr53r0WMJpIHA==
X-Received: by 2002:a17:90b:fd8:b0:1bd:1308:1288 with SMTP id gd24-20020a17090b0fd800b001bd13081288mr6171722pjb.201.1646325914366;
        Thu, 03 Mar 2022 08:45:14 -0800 (PST)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id k17-20020aa788d1000000b004f359a0a896sm3050231pff.169.2022.03.03.08.45.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 03 Mar 2022 08:45:13 -0800 (PST)
Date:   Thu, 3 Mar 2022 16:45:10 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Mingwei Zhang <mizhang@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Christian Borntraeger <borntraeger@linux.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        David Hildenbrand <david@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, David Matlack <dmatlack@google.com>,
        Ben Gardon <bgardon@google.com>
Subject: Re: [PATCH v3 04/28] KVM: x86/mmu: Formalize TDP MMU's (unintended?)
 deferred TLB flush logic
Message-ID: <YiDwlljj3LN7WEmB@google.com>
References: <20220226001546.360188-1-seanjc@google.com>
 <20220226001546.360188-5-seanjc@google.com>
 <YiAE4ju0a3MWXr31@google.com>
 <YiAH6UfSDyHeMP+s@google.com>
 <YiAXy+I1GcyZ7iFJ@google.com>
 <YiAcvswAIrMi+iXS@google.com>
 <YiBJGmFCdSZwkiTw@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YiBJGmFCdSZwkiTw@google.com>
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

On Thu, Mar 03, 2022, Mingwei Zhang wrote:
> On Thu, Mar 03, 2022, Sean Christopherson wrote:
> > Heh, if SVM's ASID management wasn't a mess[*], it'd be totally fine.  The idea,
> > and what EPT architectures mandates, is that each TDP root is associated with an
> > ASID.  So even though there may be stale entries in the TLB for a root, because
> > that root is no longer used those stale entries are unreachable.  And if KVM ever
> > happens to reallocate the same physical page for a root, that's ok because KVM must
> > be paranoid and flush that root (see code comment in this patch).
> > 
> > What we're missing on SVM is proper ASID handling.  If KVM uses ASIDs the way AMD
> > intends them to be used, then this works as intended because each root is again
> > associated with a specific ASID, and KVM just needs to flush when (re)allocating
> > a root and when reusing an ASID (which it already handles).
> > 
> > [*] https://lore.kernel.org/all/Yh%2FJdHphCLOm4evG@google.com
> 
> Oh, putting AMD issues aside for now.
> 
> I think I might be too narrow down to the zapping logic previously. So,
> I originally think anytime we want to zap, we have to do the following
> things in strict order:
> 
> 1) zap SPTEs.
> 2) flush TLBs.
> 3) flush cache (AMD SEV only).
> 4) deallocate shadow pages.

Not necessarily.  1-3 are actually all optional.  E.g. for #1, if KVM somehow
knew that the host didn't care about A/D bits (no writeback needed, no LRU info
needed), then KVM could skip straight to freeing the shadow pages when destroying
a VM.

Flushing the TLB before freeing pages is optional because KVM only needs to ensure
the guest can no longer access the memory.  E.g. at kvm_mmu_notifier_release(),
because KVM disallows KVM_RUN from a different mm, KVM knows that the guest will
never run again and so can skip the TLB flushes.

For the TLB, that does mean KVM needs to flush when using an ASID/EPT4 for the
first time, but KVM needs to do that regardless to guard against a different
hypervisor being loaded previously (where a "different" hypervisor could very
well be an older, buggier version of KVM).

> However, if you have already invalidated EPTP (pgd ptr), then step 2)
> becomes optional, since those stale TLBs are no longer useable by the
> guest due to the change of ASID.

Mostly.  It doesn't require an "invalidated EPTP", just a different EPT4A (or
ASID on SVM).

> Am I understanding the point correctly? So, for all invalidated roots,
> the assumption is that we have already called "kvm_reload_rmote_mmus()",
> which basically update the ASID.

No, the assumption (though I'd describe it a requirement) is that vCPUs can no
longer consume the TLB entries.  That could be due to a reload, but as above it
could also be due to KVM knowing KVM_RUN is unreachable.
