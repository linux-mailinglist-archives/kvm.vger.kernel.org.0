Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 54846748F73
	for <lists+kvm@lfdr.de>; Wed,  5 Jul 2023 22:56:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230157AbjGEU44 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 5 Jul 2023 16:56:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55920 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229532AbjGEU4y (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 5 Jul 2023 16:56:54 -0400
Received: from mail-pl1-x630.google.com (mail-pl1-x630.google.com [IPv6:2607:f8b0:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ED6CF11D;
        Wed,  5 Jul 2023 13:56:53 -0700 (PDT)
Received: by mail-pl1-x630.google.com with SMTP id d9443c01a7336-1b8b4749013so5803615ad.2;
        Wed, 05 Jul 2023 13:56:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1688590613; x=1691182613;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=ovzEbDAGJ3+ZjzcYiibK38OFMjmG360mQnBH1xSJlPk=;
        b=MqB/Cx7O1eM1d9pgvNMoEsucDpppcyx1oBo1eJOHnUH/YPkxddkx5hl0nZHaNFEI5c
         G6ps1xaj4ET6AI9UAOkC08vDCnuoU/mCYSlutjyo55YiTgIId4xDh6OOhzRZF357P7Mw
         9NoA7XRB6pVwOyxXzAScmJ0ktaQWLpntLhjDUD0rFzU9CGxVsuznMwjuIrq7/3X6x+2G
         o455gZcnGVOoykXm6kNg2Efj5rRIc52hj1oRr9OmtjbV6PgJoooFgHb/pzvaw9JKho2B
         Gf/hNeKmeJz6Zhz7ilOCVjkgwFPgeWPC8olAqtXzFYskQORQKSMO0l3RWQGHl6O9WPRW
         e9qA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1688590613; x=1691182613;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ovzEbDAGJ3+ZjzcYiibK38OFMjmG360mQnBH1xSJlPk=;
        b=T7fA2pVPkv++rp1UzxkEjP2DYKbjep8iGv5oX3xD8snNWBhHrAsQcVSLG0neYl/KXt
         W/SiCWGLVEgAINhPjh31Fmxvx+lKA9ZkkFNZsx820Kw/LwUDbypLGFC1+ZOy+Icygni2
         xMiahR9x3xHIJuqiPGGn/CppPuT2MXfPnuMf7n310hbKjS89SULPrvIQ69OqSBvRXl6I
         B5kivNRTw/h1BV0MINOnqmdDcojIjxuQsfBWA6jNcb4Q3bUggTsr0w4H2v4rl98oCGIG
         iQQBQUwwVYhGhs6VROxZDAfWaEZbV7mwX6e/zRKWDXrt9/1aU4+MQfW2ah4WBZZl9jIS
         FL3w==
X-Gm-Message-State: ABy/qLakjcFpBcfJHaEeFtiUy/bmmkWMBi3xRxq7a1Pr3btgF325tQgS
        1jhw69oCojJbSQLMWAcHmrU=
X-Google-Smtp-Source: APBJJlEeMt/Iu5iAHsjfGQ7mflNzscvdOd5j6NwpGC/RfdnC/J4hNkVbWBefWE+XhpRumWZ5+EOT3Q==
X-Received: by 2002:a17:902:d486:b0:1b2:fa8:d9c9 with SMTP id c6-20020a170902d48600b001b20fa8d9c9mr59542plg.49.1688590613062;
        Wed, 05 Jul 2023 13:56:53 -0700 (PDT)
Received: from localhost ([192.55.54.50])
        by smtp.gmail.com with ESMTPSA id x18-20020a170902ec9200b001b022f2aa12sm14405060plg.239.2023.07.05.13.56.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 05 Jul 2023 13:56:52 -0700 (PDT)
Date:   Wed, 5 Jul 2023 13:56:50 -0700
From:   Isaku Yamahata <isaku.yamahata@gmail.com>
To:     "Huang, Kai" <kai.huang@intel.com>
Cc:     "peterz@infradead.org" <peterz@infradead.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "Raj, Ashok" <ashok.raj@intel.com>,
        "Luck, Tony" <tony.luck@intel.com>,
        "david@redhat.com" <david@redhat.com>,
        "bagasdotme@gmail.com" <bagasdotme@gmail.com>,
        "Hansen, Dave" <dave.hansen@intel.com>,
        "ak@linux.intel.com" <ak@linux.intel.com>,
        "Wysocki, Rafael J" <rafael.j.wysocki@intel.com>,
        "kirill.shutemov@linux.intel.com" <kirill.shutemov@linux.intel.com>,
        "Chatre, Reinette" <reinette.chatre@intel.com>,
        "Christopherson,, Sean" <seanjc@google.com>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "Yamahata, Isaku" <isaku.yamahata@intel.com>,
        "nik.borisov@suse.com" <nik.borisov@suse.com>,
        "hpa@zytor.com" <hpa@zytor.com>, "Shahar, Sagi" <sagis@google.com>,
        "imammedo@redhat.com" <imammedo@redhat.com>,
        "bp@alien8.de" <bp@alien8.de>, "Gao, Chao" <chao.gao@intel.com>,
        "Brown, Len" <len.brown@intel.com>,
        "sathyanarayanan.kuppuswamy@linux.intel.com" 
        <sathyanarayanan.kuppuswamy@linux.intel.com>,
        "Huang, Ying" <ying.huang@intel.com>,
        "Williams, Dan J" <dan.j.williams@intel.com>,
        "x86@kernel.org" <x86@kernel.org>, isaku.yamahata@gmail.com
Subject: Re: [PATCH v12 20/22] x86/virt/tdx: Allow SEAMCALL to handle #UD and
 #GP
Message-ID: <20230705205650.GJ3436214@ls.amr.corp.intel.com>
References: <20230628203823.GR38236@hirez.programming.kicks-ass.net>
 <42e13ccf7f27a68c0dd64640eed378c38ef40967.camel@intel.com>
 <20230630100659.GF2533791@hirez.programming.kicks-ass.net>
 <20230630102141.GA2534364@hirez.programming.kicks-ass.net>
 <20230630120650.GB2534364@hirez.programming.kicks-ass.net>
 <fdd81fbd2424d8da04f98d156668cad5e73c740b.camel@intel.com>
 <20230705102137.GX4253@hirez.programming.kicks-ass.net>
 <ab3dea02892920cd6640a31a9c846afd6c6a9d54.camel@intel.com>
 <20230705121921.GZ4253@hirez.programming.kicks-ass.net>
 <3bef89e1bc5935625483cc5bf339c13f643c2c29.camel@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <3bef89e1bc5935625483cc5bf339c13f643c2c29.camel@intel.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Jul 05, 2023 at 12:53:58PM +0000,
"Huang, Kai" <kai.huang@intel.com> wrote:

> On Wed, 2023-07-05 at 14:19 +0200, Peter Zijlstra wrote:
> > On Wed, Jul 05, 2023 at 11:34:53AM +0000, Huang, Kai wrote:
> > 
> > > Yeah I think from long-term's view, since SEAMCALLs to support live migration
> > > pretty much uses all RCX/RDX/R8-R15 as input/output, it seems reasonable to
> > > unify all of them, although I guess there might be some special handling to
> > > VP.VMCALL and/or VP.ENTER, e.g., below:
> > > 
> > >         /* TDVMCALL leaf return code is in R10 */                              
> > >         movq %r10, %rax
> > > 
> > > So long-termly, I don't have objection to that.  But my thinking is for the
> > > first version of TDX host support, we don't have to support all SEAMCALLs but
> > > only those involved in basic TDX support. 
> > 
> > Since those calls are out now, we should look at them now, there is no
> > point in delaying the pain. That then gives us two options:
> > 
> >  - we accept them and their wonky calling convention and our code should
> >    be ready for it.
> > 
> >  - we reject them and send the TDX team a message to please try again
> >    but with a saner calling convention.
> > 
> > Sticking our head in the sand and pretending like they don't exist isn't
> > really a viable option at this point.
> 
> OK.  I'll work on this.
> 
> But I think even we want to unify __tdx_module_call() and __tdx_hypercall(), the
> first step should be making __tdx_module_call() look like __tdx_hypercall()?  I
> mean from organizing patchset's point of view, we cannot just do in one big
> patch but need to split into small patches with each doing one thing.
> 
> By thinking is perhaps we can organize this way:
> 
>  1) Patch(es) to make TDX_MODULE_CALL macro / __tdx_module_call() look like
> __tdx_hypercall().
>  2) Add SEAMCALL support based on TDX_MODULE_CALL, e.g., implement __seamcall().
>  3) Unify __tdx_module_call()/__seamcall() with __tdx_hypercall().
> 
> Does this look good?
> 
> Btw, I've already part 1) based on your code, and sent the patches to Kirill for
> review.  Should I sent them out first?
> 
> > 
> > > Also, the new SEAMCALLs to handle live migration all seem to have below
> > > statement:
> > > 
> > > 	AVX, AVX2	May be reset to the architectural INIT state
> > > 	and
> > > 	AVX512
> > > 	state
> > > 
> > > Which means those SEAMCALLs need to preserve AVX* states too?
> > 
> > Yes, we need to ensure the userspace 'FPU' state is saved before
> > we call them. But I _think_ that KVM already does much of that.
> 
> Let me look into this.

KVM VCPU_RUN ioctl saves/restores FPU state by kvm_load_guest_fpu() and
kvm_put_guest_fpu() which calls fpu_swap_kvm_fpstate().
Other KVM ioctls doesn't modify FPU.  Because some SEAMCALLs related for live
migration don't preserve FPU state, we need explicit save/restore of FPU state.

-- 
Isaku Yamahata <isaku.yamahata@gmail.com>
