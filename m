Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C59A65BEF0B
	for <lists+kvm@lfdr.de>; Tue, 20 Sep 2022 23:17:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229815AbiITVR2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 20 Sep 2022 17:17:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48736 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229779AbiITVR0 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 20 Sep 2022 17:17:26 -0400
Received: from mail-pj1-x1033.google.com (mail-pj1-x1033.google.com [IPv6:2607:f8b0:4864:20::1033])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BF1225F7F8
        for <kvm@vger.kernel.org>; Tue, 20 Sep 2022 14:17:25 -0700 (PDT)
Received: by mail-pj1-x1033.google.com with SMTP id x1-20020a17090ab00100b001fda21bbc90so12114423pjq.3
        for <kvm@vger.kernel.org>; Tue, 20 Sep 2022 14:17:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date;
        bh=X5c1uNML4oxlQT8wxUGSkWtxl1WkAxhMPgBfQlf4Pqk=;
        b=HMac9i6JXJ3weUDPCDtmc+igpODFiVs8o7JnijdUsYOC7PZPZnl0ZMIJ6GZUDq8aIZ
         R3fTVVW9RtqYHAXpKl1Gp9ERpCZA8ZVX+/VOV6HGJPR3RKMi7rfWGXdMIQ3PFqwI4OnS
         JsASvdGtnnUTEpNzVJrXIjlYCpuKwXpcfBuL2hNmVRkKZW+aRxMPVSPyfhC4od/E4W8I
         CZq9gVguR37MVXX5xuU7PlGcf2iliyY0E5bTHn5UccnNMFXMRDsdE7DTxXMjJIouEUNN
         tNRb7YOuNfhi6kVteiQJMsLv01+rFRp9D3SHVtSczimNR98XRX/MpSAm0gsEAxA+LeIv
         xoxg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date;
        bh=X5c1uNML4oxlQT8wxUGSkWtxl1WkAxhMPgBfQlf4Pqk=;
        b=NbDCdW/PcE+9CcEvfTAz3JVbuWwYIvN4qwcfx5xacVEdQCCgbEWouh8Bh1RxH09Kpz
         k4uikWEu/BYPCUirLCYoBsumktEaQb4w0Tx89onmC7bmiKM5A8yrg1+OWkbKw8MJJFAA
         MGVMkzneu+k5vs4bFHX+RdNeE0yfpaDGWbTbCsZRDmRoeUMBQ3wB3ExX+wVpGSrPKjNf
         JfTct8YloNF3CTzvuUgeFCJEnjg5HGmfA0zgSpVSORWaJsj50X0F03C2yRISetmQGST5
         lbivUgvW9O/cynCkx/xD0rruR15shZfQefbsSLznKcHSYcsCY97K7ehcucCR5URpk+Jw
         8oYQ==
X-Gm-Message-State: ACrzQf3RU1KH06mZa2XWYl2+/KLXN3TEzGi6MosyVOWpQWmeAv+eRsy/
        VZWJz/XplIcI37dKMv/+I+JGTg==
X-Google-Smtp-Source: AMsMyM7k7MR0k+9aLn/EsWiOCfYr7qLQxb/oyQf7h94mse2UWMUcHBuDxjzbDiB3lqzbhFhiU9tl5A==
X-Received: by 2002:a17:90b:2398:b0:200:a861:2e86 with SMTP id mr24-20020a17090b239800b00200a8612e86mr5875289pjb.233.1663708645175;
        Tue, 20 Sep 2022 14:17:25 -0700 (PDT)
Received: from google.com (223.103.125.34.bc.googleusercontent.com. [34.125.103.223])
        by smtp.gmail.com with ESMTPSA id t11-20020a17090340cb00b00172951ddb12sm372304pld.42.2022.09.20.14.17.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 20 Sep 2022 14:17:24 -0700 (PDT)
Date:   Tue, 20 Sep 2022 14:17:20 -0700
From:   David Matlack <dmatlack@google.com>
To:     Isaku Yamahata <isaku.yamahata@gmail.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        kvm list <kvm@vger.kernel.org>,
        Kai Huang <kai.huang@intel.com>, Peter Xu <peterx@redhat.com>
Subject: Re: [PATCH v2 08/10] KVM: x86/mmu: Split out TDP MMU page fault
 handling
Message-ID: <Yyot4L75h2ShPSaG@google.com>
References: <20220826231227.4096391-1-dmatlack@google.com>
 <20220826231227.4096391-9-dmatlack@google.com>
 <20220830235708.GB2711697@ls.amr.corp.intel.com>
 <CALzav=fg8xonNUkbFcep6kcVcBGtsp2RRW0_NKUL8DhdbQbRPA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CALzav=fg8xonNUkbFcep6kcVcBGtsp2RRW0_NKUL8DhdbQbRPA@mail.gmail.com>
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Sep 01, 2022 at 09:50:10AM -0700, David Matlack wrote:
> On Tue, Aug 30, 2022 at 4:57 PM Isaku Yamahata <isaku.yamahata@gmail.com> wrote:
> > On Fri, Aug 26, 2022 at 04:12:25PM -0700, David Matlack <dmatlack@google.com> wrote:
> > >  int kvm_tdp_page_fault(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault)
> > >  {
> > >       /*
> > > @@ -4355,6 +4384,11 @@ int kvm_tdp_page_fault(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault)
> > >               }
> > >       }
> > >
> > > +#ifdef CONFIG_X86_64
> > > +     if (tdp_mmu_enabled)
> > > +             return kvm_tdp_mmu_page_fault(vcpu, fault);
> > > +#endif
> > > +
> > >       return direct_page_fault(vcpu, fault);
> > >  }
> >
> > Now we mostly duplicated page_fault method.  We can go one step further.
> > kvm->arch.mmu.page_fault can be set for each case.  Maybe we can do it later
> > if necessary.
> 
> Hm, interesting idea. We would have to refactor the MTRR max_level
> code in kvm_tdp_page_fault() into a helper function, but otherwise
> that idea would work. I will give it a try in the next version.

So I took a stab at this. Refactoring the max_level adjustment for MTRRs
into a helper function is easy of course. But changing page_fault also
requires changes in kvm_mmu_do_page_fault() for CONFIG_RETPOLINE and
fault->is_tdp. I'm not saying it's not possible (it definitely is) but
it's not trivial to do it in a clean way, so I suggest we table this for
the time being.
