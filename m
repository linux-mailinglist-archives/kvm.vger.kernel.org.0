Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C154F3995BD
	for <lists+kvm@lfdr.de>; Thu,  3 Jun 2021 00:08:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229761AbhFBWK1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 2 Jun 2021 18:10:27 -0400
Received: from mail-pj1-f42.google.com ([209.85.216.42]:34693 "EHLO
        mail-pj1-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229583AbhFBWK1 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 2 Jun 2021 18:10:27 -0400
Received: by mail-pj1-f42.google.com with SMTP id g6-20020a17090adac6b029015d1a9a6f1aso2285731pjx.1
        for <kvm@vger.kernel.org>; Wed, 02 Jun 2021 15:08:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=uYs0Sxp8Sy73eeh5FIi2PBG1V/3yb9REY1eEkFzXkvg=;
        b=fUk0AN3TZocnKupxpFytCVvLNDx2P+WnbxjtE6IfKbkK7kEii0By42gvoIcjAKCfIA
         kLdXG9vN3Qk901Pu9ANJt7E33MziTDdJDcrRpangq3MACaAtmjYY7mpwlHIne3wdk7Dc
         hMukGXLuzzPwjQyw02l8IndzzmWFwSkT46jc1zaEElXfdca6gI7e+9IROC0R34xGjYog
         qT7THaa0+0tXO5dad8YKLcPA6JgQyd60xt5Uf0Svuk3R7abEvHhHK94nIarEARQXZSN/
         YrCV1aSEGCsKSHh6N3vao0Hmo/NoU8fRkbx6JdFjf2QQ18jzg+4K3iat6QxDWcL1ig0x
         j07Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=uYs0Sxp8Sy73eeh5FIi2PBG1V/3yb9REY1eEkFzXkvg=;
        b=pr0wHpeQQeerx/4CiXYSgMffFZw18Rxq0ofd2Gd4cSVmFf9ILtlPoIEOUytodaJKTf
         gPixhrQ28g0g8uzoCCFhlLsN3NR5p2LoxH6vtF4c0YtBBcPE17q8znPGhmk9kQRKzzDi
         yXvywwrjqXxNeqsm3u/mqrya70lWooAG7WyZZLFQitSvrYmffIeW6STgPIMKHVBU1MWH
         gqZ1IE2QDRD/jM8Cc1aDdT3s5U7+DKB9wYC789l+zHXJabLnyJ29MZnM7SmJGZ+pMrWo
         EWmQ9Ac6sT2EELKpTTYO6JQDsTk2sWIVS6ukju+oS6S1CdMpDBa1ad3Vwoffc6HyKSxV
         ix4g==
X-Gm-Message-State: AOAM532++C2x6OXwJFjjs3Gn/uc6O85mB15khx1NJNHg3dRIKTKrWHYu
        By2iT82pCPpb2wMnIQmuXMCtAA==
X-Google-Smtp-Source: ABdhPJwMvfdpjjJ6qovbOXgJRhCSiMC2kz5bLxpaBxvtzZAaCzqCZZHR+wOipPP1xSGdVuStuwnyCg==
X-Received: by 2002:a17:902:da8a:b029:f1:f2a1:cfe4 with SMTP id j10-20020a170902da8ab02900f1f2a1cfe4mr32574742plx.46.1622671663334;
        Wed, 02 Jun 2021 15:07:43 -0700 (PDT)
Received: from google.com (240.111.247.35.bc.googleusercontent.com. [35.247.111.240])
        by smtp.gmail.com with ESMTPSA id k10sm471700pfu.175.2021.06.02.15.07.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 02 Jun 2021 15:07:42 -0700 (PDT)
Date:   Wed, 2 Jun 2021 22:07:38 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Lai Jiangshan <laijs@linux.alibaba.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Lai Jiangshan <jiangshanlai@gmail.com>,
        linux-kernel@vger.kernel.org,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        Maxim Levitsky <mlevitsk@redhat.com>, kvm@vger.kernel.org
Subject: Re: [PATCH] KVM: X86: fix tlb_flush_guest()
Message-ID: <YLgBKh43SRvjKeB1@google.com>
References: <20210527023922.2017-1-jiangshanlai@gmail.com>
 <78ad9dff-9a20-c17f-cd8f-931090834133@redhat.com>
 <YK/FGYejaIu6EzSn@google.com>
 <YK/FbFzKhZEmI40C@google.com>
 <YK/y3QgSg+aYk9Z+@google.com>
 <fc0f8b39-11a9-da21-dc5b-fc9695292556@linux.alibaba.com>
 <YLefHNgePAs+lPQJ@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YLefHNgePAs+lPQJ@google.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Jun 02, 2021, Sean Christopherson wrote:
> On Fri, May 28, 2021, Lai Jiangshan wrote:
> > 
> > 
> > On 2021/5/28 03:28, Sean Christopherson wrote:
> > > On Thu, May 27, 2021, Sean Christopherson wrote:
> > > > > KVM_REQ_MMU_RELOAD is overkill, nuking the shadow page tables will completely
> > > > > offset the performance gains of the paravirtualized flush.
> > > 
> > > Argh, I take that back.  The PV KVM_VCPU_FLUSH_TLB flag doesn't distinguish
> > > between flushing a specific mm and flushing the entire TLB.  The HyperV usage
> > > (via KVM_REQ) also throws everything into a single bucket.  A full RELOAD still
> > > isn't necessary as KVM just needs to sync all roots, not blast them away.  For
> > > previous roots, KVM doesn't have a mechanism to defer the sync, so the immediate
> > > fix will need to unload those roots.
> > > 
> > > And looking at KVM's other flows, __kvm_mmu_new_pgd() and kvm_set_cr3() are also
> > > broken with respect to previous roots.  E.g. if the guest does a MOV CR3 that
> > > flushes the entire TLB, followed by a MOV CR3 with PCID_NOFLUSH=1, KVM will fail
> > > to sync the MMU on the second flush even though the guest can technically rely
> > > on the first MOV CR3 to have synchronized any previous changes relative to the
> > > fisrt MOV CR3.
> > 
> > Could you elaborate the problem please?
> > When can a MOV CR3 that needs to flush the entire TLB if PCID is enabled?
> 
> Scratch that, I was wrong.  The SDM explicitly states that other PCIDs don't
> need to be flushed if CR4.PCIDE=1.

*sigh*

I was partially right.  If the guest does

  1: MOV    B, %rax
     MOV %rax, %cr3

  2: <modify PTEs in B>

  3: MOV    A, %rax
     MOV %rax, %cr3
 
  4: MOV    B, %rax
     BTS  $63, %rax
     MOV %rax, %cr3

where A and B are CR3 values with the same PCID, then KVM will fail to sync B at
step (4) due to PCID_NOFLUSH, even though the guest can technically rely on
its modifications at step (2) to become visible at step (3) when the PCID is
flushed on CR3 load.

So it's not a full TLB flush, rather a flush of the PCID, which can theoretically
impact previous CR3 values.
