Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 212CE5255CD
	for <lists+kvm@lfdr.de>; Thu, 12 May 2022 21:35:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1358093AbiELTfY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 12 May 2022 15:35:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44458 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344183AbiELTfX (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 12 May 2022 15:35:23 -0400
Received: from mail-pj1-x1031.google.com (mail-pj1-x1031.google.com [IPv6:2607:f8b0:4864:20::1031])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C7C012469DB
        for <kvm@vger.kernel.org>; Thu, 12 May 2022 12:35:21 -0700 (PDT)
Received: by mail-pj1-x1031.google.com with SMTP id c1-20020a17090a558100b001dca2694f23so5784989pji.3
        for <kvm@vger.kernel.org>; Thu, 12 May 2022 12:35:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=kfZN6PXN3cDIj6QUSkzpmoXvq4z3A1Hj8dUVdgbk/LI=;
        b=TDmXlRACyP52L1jGPGFOWL4byOhwal0rhKM+xO441dFXS3IuZdPlDV85V5K1j0yrPA
         odDZ67qDA2O6O3JFbd+WH0LQpcmMhogaJYT+wq/7HszRntXNVPXDeSk1gG08QzZRQRIW
         CHlDNPl4fMOaoqiWI8Phe4dM/4zcQY5u3Nc6eAWh3jfJg4zIRCPnUCYXUMs3QEhDX84q
         gu+blpAY5EDrIJRk0oKEA6r2HJYVePEmNySaN4Th6TkiPfm4w+kWRDX7DllWMSaIN2l8
         6kGOMXnjEhn5ERdzY4qMgzI+UhM3IbSbengxwejfbRcVwb/k2PpeHOn5zgF1HWH89dza
         nEwg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=kfZN6PXN3cDIj6QUSkzpmoXvq4z3A1Hj8dUVdgbk/LI=;
        b=Vt/b1uUxwL4qY4/1+wg+JvzB7UMQC4JWZUeyb1ZApGOYxidA2/f+SNEvPRHRVvbb+L
         gf24LwQSQrAFJzFo+XYSH/ICfYtZR7Q9eGwU4yG2HYvtb8kE5jAdfZ1BnPkjgB3RbJKv
         fwPoqXoePxl4X4nYBahRTAwTUOygoDV09+xgO/Zwce2X/4atM4TQTpu+FeUDkhj5q9RM
         jsvMLbjch1QEvsDAQV6SrSdGIGMdznK6Y0r6zsSMcFaqKZs1h5Ncc8GzX+o3l2Q9aJpv
         8iSPmNL8O/KBC44/L3EGqA2BJB/ecisewCAxv4jzKymMhaeDQFRaD0zuvo6/eqdWNsfv
         YeqQ==
X-Gm-Message-State: AOAM532d2OJCP6k4puvuSf5wnfwugqC5HvJ202Rz0uCEkNNpVjIfG0dg
        pWq6c1olyXPUbviFRxBPfe38Zw==
X-Google-Smtp-Source: ABdhPJy3B0WgQXyYcsYlyM8zhsfQkOrQ9Ynae+lWMuPFoAySH0P8tBiO77yZ9vYieIinOyRTKKEsyA==
X-Received: by 2002:a17:903:22cb:b0:15e:d715:1bd8 with SMTP id y11-20020a17090322cb00b0015ed7151bd8mr1319276plg.159.1652384121012;
        Thu, 12 May 2022 12:35:21 -0700 (PDT)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id p187-20020a62d0c4000000b0050dc7628135sm226616pfg.15.2022.05.12.12.35.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 12 May 2022 12:35:20 -0700 (PDT)
Date:   Thu, 12 May 2022 19:35:16 +0000
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
        Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>,
        Kees Cook <keescook@chromium.org>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Josh Poimboeuf <jpoimboe@redhat.com>,
        Kim Phillips <kim.phillips@amd.com>,
        Lukas Bulwahn <lukas.bulwahn@gmail.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Ashok Raj <ashok.raj@intel.com>,
        KarimAllah Ahmed <karahmed@amazon.de>,
        David Woodhouse <dwmw@amazon.co.uk>, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Waiman Long <longman@redhat.com>
Subject: Re: [PATCH v4] x86/speculation, KVM: remove IBPB on vCPU load
Message-ID: <Yn1hdHgMVuni/GEx@google.com>
References: <20220512184514.15742-1-jon@nutanix.com>
 <Yn1fjAqFoszWz500@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Yn1fjAqFoszWz500@google.com>
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

On Thu, May 12, 2022, Sean Christopherson wrote:
> On Thu, May 12, 2022, Jon Kohler wrote:
> > Remove IBPB that is done on KVM vCPU load, as the guest-to-guest
> > attack surface is already covered by switch_mm_irqs_off() ->
> > cond_mitigation().
> > 
> > The original commit 15d45071523d ("KVM/x86: Add IBPB support") was simply
> > wrong in its guest-to-guest design intention. There are three scenarios
> > at play here:
> 
> Jim pointed offline that there's a case we didn't consider.  When switching between
> vCPUs in the same VM, an IBPB may be warranted as the tasks in the VM may be in
> different security domains.  E.g. the guest will not get a notification that vCPU0 is
> being swapped out for vCPU1 on a single pCPU.
> 
> So, sadly, after all that, I think the IBPB needs to stay.  But the documentation
> most definitely needs to be updated.
> 
> A per-VM capability to skip the IBPB may be warranted, e.g. for container-like
> use cases where a single VM is running a single workload.

Ah, actually, the IBPB can be skipped if the vCPUs have different mm_structs,
because then the IBPB is fully redundant with respect to any IBPB performed by
switch_mm_irqs_off().  Hrm, though it might need a KVM or per-VM knob, e.g. just
because the VMM doesn't want IBPB doesn't mean the guest doesn't want IBPB.

That would also sidestep the largely theoretical question of whether vCPUs from
different VMs but the same address space are in the same security domain.  It doesn't
matter, because even if they are in the same domain, KVM still needs to do IBPB.
