Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 456A152563C
	for <lists+kvm@lfdr.de>; Thu, 12 May 2022 22:07:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1358298AbiELUH1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 12 May 2022 16:07:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59958 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1358284AbiELUHW (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 12 May 2022 16:07:22 -0400
Received: from mail-pj1-x102b.google.com (mail-pj1-x102b.google.com [IPv6:2607:f8b0:4864:20::102b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DA1C4694A9
        for <kvm@vger.kernel.org>; Thu, 12 May 2022 13:07:21 -0700 (PDT)
Received: by mail-pj1-x102b.google.com with SMTP id l11-20020a17090a49cb00b001d923a9ca99so5866747pjm.1
        for <kvm@vger.kernel.org>; Thu, 12 May 2022 13:07:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=iOAKB7vKEZEg22vxCywimbh0xLHgxT/3D2j+uYXG4Rw=;
        b=CxfhAMbbtns0lTpJyPbLHoLtAWBjF+jQgBLSV3SbRZEEkp7AM6u3irkMLYD7+aJc/z
         YQhlkbqq6wKSwFd7w80FpEAONky2GqoH8nE2S3+bcyCMIoH/p7pn0NpxfrUvqTPe+WbH
         rvFIUheu+Lc4+9Qkbs+wm+v0Tp+6pvFz5apm7CRjYolOOW0olf5gDDh6jQPMbZ11KJAn
         bYfg1Su6uVO9Syc3E4/QPVVxpPdusdNaw3PsaEHhAnaAkzZdVHaA5g5l0ajZSW1ht2m0
         d/ixsrgV4wsESqC5ala+wpcPi4pC9M+IlXiSgAAyaBpnavYCDSVgUULfV9TSr/VFUoMh
         Qzjw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=iOAKB7vKEZEg22vxCywimbh0xLHgxT/3D2j+uYXG4Rw=;
        b=ze8Qs9/GuFieXcXGAhjattjyfOsZB9sZaZ8e9NwbxLUAyT31pgCNSDGKvBHZvqVLiZ
         gr4jjMk34iyB/MZsxjwwkEh99lSpsuA1fXFXC/Ay92s2bvNkuzgptGnmp/f9Fo5mEY2F
         nL34gbyH8Xq9k5wbWsfuSCpnRXjBrXWiMAYSSR8GrjU3KiJXaoVZEEiGgn1oZ8a1SCMI
         MyIojAwVA0OdkIwUd4OqjDBIXYeDwd/xdRlV4aK3si1xTnundlmtp98Md1p4MQ3n4xQe
         fP+bPiLZhg4K/tafdKiOXvLryk33DsUq5dSZFPbc8Pq9Y4GxojI7coEpnHjAeH/i44ZK
         gN2w==
X-Gm-Message-State: AOAM530md35rCDUa8TG2CgvdwGcKiS66NdJ4jfO9t3DJWS6qbcptR4Nc
        Yurr3RcEL0fJmfKI1aJJtsj2PA==
X-Google-Smtp-Source: ABdhPJxOmTlyzaTn4bymcAxWFx36Ddbx15+sd8m0ORb3FZP4+kKbKdkSJg5+bNTXL+fdLezImQvSPg==
X-Received: by 2002:a17:902:ec04:b0:160:8bce:b073 with SMTP id l4-20020a170902ec0400b001608bceb073mr1119286pld.127.1652386041149;
        Thu, 12 May 2022 13:07:21 -0700 (PDT)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id b11-20020a170902650b00b0015e8d4eb1c4sm341131plk.14.2022.05.12.13.07.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 12 May 2022 13:07:20 -0700 (PDT)
Date:   Thu, 12 May 2022 20:07:17 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Jon Kohler <jon@nutanix.com>
Cc:     Jonathan Corbet <corbet@lwn.net>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        X86 ML <x86@kernel.org>, "H. Peter Anvin" <hpa@zytor.com>,
        Kees Cook <keescook@chromium.org>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Josh Poimboeuf <jpoimboe@redhat.com>,
        Kim Phillips <kim.phillips@amd.com>,
        Lukas Bulwahn <lukas.bulwahn@gmail.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Ashok Raj <ashok.raj@intel.com>,
        KarimAllah Ahmed <karahmed@amazon.de>,
        David Woodhouse <dwmw@amazon.co.uk>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        "kvm @ vger . kernel . org" <kvm@vger.kernel.org>,
        Waiman Long <longman@redhat.com>
Subject: Re: [PATCH v4] x86/speculation, KVM: remove IBPB on vCPU load
Message-ID: <Yn1o9ZfsQutXXdQS@google.com>
References: <20220512184514.15742-1-jon@nutanix.com>
 <Yn1fjAqFoszWz500@google.com>
 <Yn1hdHgMVuni/GEx@google.com>
 <07BEC8B1-469C-4E36-AE92-90BFDF93B2C4@nutanix.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <07BEC8B1-469C-4E36-AE92-90BFDF93B2C4@nutanix.com>
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, May 12, 2022, Jon Kohler wrote:
> 
> 
> > On May 12, 2022, at 3:35 PM, Sean Christopherson <seanjc@google.com> wrote:
> > 
> > On Thu, May 12, 2022, Sean Christopherson wrote:
> >> On Thu, May 12, 2022, Jon Kohler wrote:
> >>> Remove IBPB that is done on KVM vCPU load, as the guest-to-guest
> >>> attack surface is already covered by switch_mm_irqs_off() ->
> >>> cond_mitigation().
> >>> 
> >>> The original commit 15d45071523d ("KVM/x86: Add IBPB support") was simply
> >>> wrong in its guest-to-guest design intention. There are three scenarios
> >>> at play here:
> >> 
> >> Jim pointed offline that there's a case we didn't consider.  When switching between
> >> vCPUs in the same VM, an IBPB may be warranted as the tasks in the VM may be in
> >> different security domains.  E.g. the guest will not get a notification that vCPU0 is
> >> being swapped out for vCPU1 on a single pCPU.
> >> 
> >> So, sadly, after all that, I think the IBPB needs to stay.  But the documentation
> >> most definitely needs to be updated.
> >> 
> >> A per-VM capability to skip the IBPB may be warranted, e.g. for container-like
> >> use cases where a single VM is running a single workload.
> > 
> > Ah, actually, the IBPB can be skipped if the vCPUs have different mm_structs,
> > because then the IBPB is fully redundant with respect to any IBPB performed by
> > switch_mm_irqs_off().  Hrm, though it might need a KVM or per-VM knob, e.g. just
> > because the VMM doesn't want IBPB doesn't mean the guest doesn't want IBPB.
> > 
> > That would also sidestep the largely theoretical question of whether vCPUs from
> > different VMs but the same address space are in the same security domain.  It doesn't
> > matter, because even if they are in the same domain, KVM still needs to do IBPB.
> 
> So should we go back to the earlier approach where we have it be only 
> IBPB on always_ibpb? Or what?
> 
> At minimum, we need to fix the unilateral-ness of all of this :) since we’re
> IBPB’ing even when the user did not explicitly tell us to.

I think we need separate controls for the guest.  E.g. if the userspace VMM is
sufficiently hardened then it can run without "do IBPB" flag, but that doesn't
mean that the entire guest it's running is sufficiently hardened.

> That said, since I just re-read the documentation today, it does specifically
> suggest that if the guest wants to protect *itself* it should turn on IBPB or
> STIBP (or other mitigations galore), so I think we end up having to think
> about what our “contract” is with users who host their workloads on
> KVM - are they expecting us to protect them in any/all cases?
> 
> Said another way, the internal guest areas of concern aren’t something
> the kernel would always be able to A) identify far in advance and B)
> always solve on the users behalf. There is an argument to be made
> that the guest needs to deal with its own house, yea?

The issue is that the guest won't get a notification if vCPU0 is replaced with
vCPU1 on the same physical CPU, thus the guest doesn't get an opportunity to emit
IBPB.  Since the host doesn't know whether or not the guest wants IBPB, unless the
owner of the host is also the owner of the guest workload, the safe approach is to
assume the guest is vulnerable.
