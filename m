Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B78CE521D94
	for <lists+kvm@lfdr.de>; Tue, 10 May 2022 17:08:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345128AbiEJPMB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 10 May 2022 11:12:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51994 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346079AbiEJPLt (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 10 May 2022 11:11:49 -0400
Received: from mail-pj1-x102c.google.com (mail-pj1-x102c.google.com [IPv6:2607:f8b0:4864:20::102c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 929D025B055
        for <kvm@vger.kernel.org>; Tue, 10 May 2022 07:44:59 -0700 (PDT)
Received: by mail-pj1-x102c.google.com with SMTP id l7-20020a17090aaa8700b001dd1a5b9965so2331317pjq.2
        for <kvm@vger.kernel.org>; Tue, 10 May 2022 07:44:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=J+j65+g15fCsV+Woqx6SguatojsTFMU+fypv/4RCtgE=;
        b=UTKi9sbH4ZRyjDc/7lHYfVs9p+QExxFt9/+sbFXNine0VCZsiYBonNCzQr9PVXDNu9
         QWx7xX/dW3O0HVOK8KbAOsU0vj7r1WZj64aBaM42JQrWhvHplMFMlet/XWgeCe+fBX1M
         5/obDfisv/+8zQrzGAaXXgJovXZmvJPru63YyrKVxAY/He8u9DhzcDaIfLqwezGoPfCs
         Mt1bVCF6ZEdokq17J2DgC5oXLJTxjhB6jqeQ4DlifycFKhjIQ/WvF6CK0l2BQKFhniHg
         KnklIDO0Qq3yf1Y46nZtjYBZ9wcmnYlIZO62+aWAcG+vWvJbv9+tNUccgFmHuE7mM/hB
         pWow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=J+j65+g15fCsV+Woqx6SguatojsTFMU+fypv/4RCtgE=;
        b=A1vvEscJsi91yvJBhkMpSdP459i8Ef9W35zInZ1aiQh4tVa/il0bBU01aI4BwbUF55
         LjemZcsRTwzRefWFLWPeYPq9TAiSa8a2vafi50cm4JiHQ2711DYUkAC3VSt5GAb4po7p
         pHYJAzHKbF5sonavPkZszb2PYzLlbSRxj2RyO480Lb7qPVaeIkJA4eWKyzhpYUFsyuE2
         zUGfIlZuld3hTl7PYQ8r2pxn/eLFzi3sZtpwR+myn6lz+jQryUhL+im1Tg5VSACEcBSY
         /0fuKyxnKiMrUD0dCtYxFFsCFzxZixm0QtCFSeD0o9NaghI9CZPZU1kMv+q51aqWyje1
         6fJg==
X-Gm-Message-State: AOAM531BtbIdh7sZjtWy36xiTVAEcSAwYNwTj43k3P1NpiRHVPGLbClN
        2HULDu0gzfMFqY5wB9PECxdXDg==
X-Google-Smtp-Source: ABdhPJzNdRCklFLDmwhjIZK4nIKrvpEW7TlAilVB41p7zRwaLd6gMiqaPsg66tubxXerZRc5n5Z5XA==
X-Received: by 2002:a17:903:2312:b0:15e:a6c8:a313 with SMTP id d18-20020a170903231200b0015ea6c8a313mr20952499plh.122.1652193898495;
        Tue, 10 May 2022 07:44:58 -0700 (PDT)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id k22-20020a170902761600b0015e8d4eb1d4sm2181590pll.30.2022.05.10.07.44.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 10 May 2022 07:44:57 -0700 (PDT)
Date:   Tue, 10 May 2022 14:44:54 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Borislav Petkov <bp@alien8.de>
Cc:     Jon Kohler <jon@nutanix.com>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        "x86@kernel.org" <x86@kernel.org>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Josh Poimboeuf <jpoimboe@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Balbir Singh <sblbir@amazon.com>,
        Kim Phillips <kim.phillips@amd.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Kees Cook <keescook@chromium.org>,
        Waiman Long <longman@redhat.com>
Subject: Re: [PATCH v3] x86/speculation, KVM: only IBPB for
 switch_mm_always_ibpb on vCPU load
Message-ID: <Ynp6ZoQUwtlWPI0Z@google.com>
References: <645E4ED5-F6EE-4F8F-A990-81F19ED82BFA@nutanix.com>
 <Ymw9UZDpXym2vXJs@zn.tnic>
 <YmxKqpWFvdUv+GwJ@google.com>
 <YmxRnwSUBIkOIjLA@zn.tnic>
 <Ymxf2Jnmz5y4CHFN@google.com>
 <YmxlHBsxcIy8uYaB@zn.tnic>
 <YmxzdAbzJkvjXSAU@google.com>
 <Ym0GcKhPZxkcMCYp@zn.tnic>
 <4E46337F-79CB-4ADA-B8C0-009E7500EDF8@nutanix.com>
 <Ym1fGZIs6K7T6h3n@zn.tnic>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <Ym1fGZIs6K7T6h3n@zn.tnic>
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

On Sat, Apr 30, 2022, Borislav Petkov wrote:
> On Sat, Apr 30, 2022 at 02:50:35PM +0000, Jon Kohler wrote:
> > This is 100% a fair ask, I appreciate the diligence, as we’ve all been there
> > on the ‘other side’ of changes to complex areas and spend hours digging on
> > git history, LKML threads, SDM/APM, and other sources trying to derive
> > why the heck something is the way it is.
> 
> Yap, that's basically proving my point and why I want stuff to be
> properly documented so that the question "why was it done this way" can
> always be answered satisfactorily.
> 
> > AFAIK, the KVM IBPB is avoided when switching in between vCPUs
> > belonging to the same vmcs/vmcb (i.e. the same guest), e.g. you could 
> > have one VM highly oversubscribed to the host and you wouldn’t see
> > either the KVM IBPB or the switch_mm IBPB. All good. 
> > 
> > Reference vmx_vcpu_load_vmcs() and svm_vcpu_load() and the 
> > conditionals prior to the barrier.
> 
> So this is where something's still missing.
> 
> > However, the pain ramps up when you have a bunch of separate guests,
> > especially with a small amount of vCPUs per guest, so the switching is more
> > likely to be in between completely separate guests.
> 
> If the guests are completely separate, then it should fall into the
> switch_mm() case.
> 
> Unless it has something to do with, as I looked at the SVM side of
> things, the VMCBs:
> 
> 	if (sd->current_vmcb != svm->vmcb) {
> 
> So it is not only different guests but also within the same guest and
> when the VMCB of the vCPU is not the current one.

Yep.

> But then if VMCB of the vCPU is not the current, per-CPU VMCB, then that
> CPU ran another guest so in order for that other guest to attack the
> current guest, then its branch pred should be flushed.

That CPU ran a different _vCPU_, whether or not it ran a different guest, i.e. a
different security domain, is unknown.

> But I'm likely missing a virt aspect here so I'd let Sean explain what
> the rules are...

I don't think you're missing anything.  I think the original 15d45071523d ("KVM/x86:
Add IBPB support") was simply wrong.

As I see it:

  1. If the vCPUs belong to the same VM, they are in the same security domain and
     do not need an IPBP.

  2. If the vCPUs belong to different VMs, and each VM is in its own mm_struct,
     defer to switch_mm_irqs_off() to handle IBPB as an mm switch is guaranteed to
     occur prior to loading a vCPU belonging to a different VMs.
 
  3. If the vCPUs belong to different VMs, but multiple VMs share an mm_struct,
     then the security benefits of an IBPB when switching vCPUs are dubious, at best.

If we only consider #1 and #2, then KVM doesn't need an IBPB, period.

#3 is the only one that's a grey area.  I have no objection to omitting IBPB entirely
even in that case, because none of us can identify any tangible value in doing so.
