Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BBDC5518ED4
	for <lists+kvm@lfdr.de>; Tue,  3 May 2022 22:30:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236981AbiECUdk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 3 May 2022 16:33:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42076 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235700AbiECUdi (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 3 May 2022 16:33:38 -0400
Received: from mail-pl1-x62e.google.com (mail-pl1-x62e.google.com [IPv6:2607:f8b0:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CE5503334F
        for <kvm@vger.kernel.org>; Tue,  3 May 2022 13:30:04 -0700 (PDT)
Received: by mail-pl1-x62e.google.com with SMTP id d22so5781645plr.9
        for <kvm@vger.kernel.org>; Tue, 03 May 2022 13:30:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=UKldj2ojYtyqPeKh4PVtsxyTk7al05BV94PM0wJKBzg=;
        b=inZcEUwn9WmtrG6/V+Y1CJh3EJ2oEii8LKrVvLLNtn3RstXFUjZyelDbCG2zrAtVS7
         ZNkv9EcZsIVg0BbtFKLLchaEPVaub+HhD39R8N6T20pSrfsYABGLOFWkpPnapCyOcs0S
         o7VdKe453Q+oI5GD31jU0HwEcic8IvzmhpiCPEx0QDygqMN98E+l/pu7W3jKk0Fkjw04
         uZ0WaJU6Fl0Ty0TNzBOb3X/D+RjcCA5pcyvfSDm0BXeBjDWxVCXyFZ3D+YZ+YGIpKAEG
         r5PTRy1cR8UH+X0CwN4YxFLyUI+jH/PoUZXvu+18hv8sjdd9o6qQtDfMMLGyTdmP1V+H
         umtw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=UKldj2ojYtyqPeKh4PVtsxyTk7al05BV94PM0wJKBzg=;
        b=RxMYUT1t156xX2/xAECLmrKTSe4S6ljZc04ww/X1/h1cxCa2dOpb0sCMbWOetwnFrJ
         YNaN3tS1itFNi5da0nPbeI0HI57F6VzfoybHSOmWJVRfa7N2Ry3FVJZfTId3fneqZ876
         qAdh6NynPGIyM0ARerti3gzf/O6A+y+the4SxLW+Xr2tS9kMRi+tld8jzqk0YigavQ5v
         AIVqqtcDBr4i0lbifl+2HmkOhKEkNiI4LwWC8mmDsdjz1xQrmCZsZFDDvz6ePg7lKVBO
         seXdsj9AX4hQx/M+lq9AHrv/QSbWp9wNg+iph6u9qZ5+UXagc+3R2smS8Sls8jkB8h+3
         0k2g==
X-Gm-Message-State: AOAM533m6Crjx5WSjMYev+iRnamMyQFXscCk+Sdc6yGNV1QGtv7SjqKf
        NNm1n8wn9g+cebrshY7tbhTLwA==
X-Google-Smtp-Source: ABdhPJwGKBnwB+Tadgfgl2yTv6w4gYUnMXeCRfyU0xKBwq5aYUrNWquV8ygIHmuv325jJ0PEcyVijg==
X-Received: by 2002:a17:902:82c9:b0:15d:3a76:936f with SMTP id u9-20020a17090282c900b0015d3a76936fmr18113344plz.139.1651609803949;
        Tue, 03 May 2022 13:30:03 -0700 (PDT)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id g25-20020a62e319000000b0050dc7628168sm6715181pfh.66.2022.05.03.13.30.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 03 May 2022 13:30:03 -0700 (PDT)
Date:   Tue, 3 May 2022 20:30:00 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Maxim Levitsky <mlevitsk@redhat.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Ben Gardon <bgardon@google.com>,
        David Matlack <dmatlack@google.com>
Subject: Re: [PATCH] KVM: x86/mmu: Do not create SPTEs for GFNs that exceed
 host.MAXPHYADDR
Message-ID: <YnGQyE60lHD7wusA@google.com>
References: <Ymv5TR76RNvFBQhz@google.com>
 <e5864cb4-cce8-bd32-04b0-ecb60c058d0b@redhat.com>
 <YmwL87h6klEC4UKV@google.com>
 <ac2001e66957edc8a3af2413b78478c15898f86c.camel@redhat.com>
 <f3ffad3aa8476156f369ff1d4c33f3e127b47d0c.camel@redhat.com>
 <82d1a5364f1cc479da3762b046d22f136db167e3.camel@redhat.com>
 <af15fd31f73e8a956da50db6104e690f9d308dad.camel@redhat.com>
 <YnAMKtfAeoydHr3x@google.com>
 <e11c21e99e7c4ac758b4417e0ae66d3a2f1fe663.camel@redhat.com>
 <cbd4709bb499874c60986083489e17c93b48d003.camel@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cbd4709bb499874c60986083489e17c93b48d003.camel@redhat.com>
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

On Tue, May 03, 2022, Maxim Levitsky wrote:
> On Tue, 2022-05-03 at 12:12 +0300, Maxim Levitsky wrote:
> > On Mon, 2022-05-02 at 16:51 +0000, Sean Christopherson wrote:
> > > On Mon, May 02, 2022, Maxim Levitsky wrote:
> > > > On Mon, 2022-05-02 at 10:59 +0300, Maxim Levitsky wrote:
> > > > > > > Also I can reproduce it all the way to 5.14 kernel (last kernel I have installed in this VM).
> > > > > > > 
> > > > > > > I tested kvm/queue as of today, sadly I still see the warning.
> > > > > > 
> > > > > > Due to a race, the above statements are out of order ;-)
> > > > > 
> > > > > So futher investigation shows that the trigger for this *is* cpu_pm=on :(
> > > > > 
> > > > > So this is enough to trigger the warning when run in the guest:
> > > > > 
> > > > > qemu-system-x86_64  -nodefaults  -vnc none -serial stdio -machine accel=kvm
> > > > > -kernel x86/dummy.flat -machine kernel-irqchip=on -smp 8 -m 1g -cpu host
> > > > > -overcommit cpu-pm=on

...

> > > > All right, at least that was because I removed the '-device isa-debug-exit,iobase=0xf4,iosize=0x4',
> > > > which is apparently used by KVM unit tests to signal exit from the VM.
> > > 
> > > Can you provide your QEMU command line for running your L1 VM?  And your L0 and L1
> > > Kconfigs too?  I've tried both the dummy and ipi_stress tests on a variety of hardware,
> > > kernels, QEMUs, etc..., with no luck.
> > 
> > So now both L0 and L1 run almost pure kvm/queue)
> > (commit 2764011106d0436cb44702cfb0981339d68c3509)
> > 
> > I have some local patches but they are not relevant to KVM at all, more
> > like various tweaks to sensors, a sad hack for yet another regression
> > in AMDGPU, etc.
> > 
> > The config and qemu command line attached.
> > 
> > AVIC disabled in L0, L0 qemu is from master upstream.
> > Bug reproduces too well IMHO, almost always.
> > 
> > For reference the warning is printed in L1's dmesg.
> 
> Tested this without any preemption in L0 and L1 - bug still reproduces just fine.
> (kvm/queue)

Well, I officially give up, I'm out of ideas to try and repro this on my end.  To
try and narrow the search, maybe try processing "all" possible gfns and see if that
makes the leak go away?

diff --git a/arch/x86/kvm/mmu.h b/arch/x86/kvm/mmu.h
index 7e258cc94152..a354490939ec 100644
--- a/arch/x86/kvm/mmu.h
+++ b/arch/x86/kvm/mmu.h
@@ -84,9 +84,7 @@ static inline gfn_t kvm_mmu_max_gfn(void)
         * than hardware's real MAXPHYADDR.  Using the host MAXPHYADDR
         * disallows such SPTEs entirely and simplifies the TDP MMU.
         */
-       int max_gpa_bits = likely(tdp_enabled) ? shadow_phys_bits : 52;
-
-       return (1ULL << (max_gpa_bits - PAGE_SHIFT)) - 1;
+       return (1ULL << (52 - PAGE_SHIFT)) - 1;
 }

 static inline u8 kvm_get_shadow_phys_bits(void)

