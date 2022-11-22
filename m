Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 68D2263449D
	for <lists+kvm@lfdr.de>; Tue, 22 Nov 2022 20:32:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234869AbiKVTcr (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 22 Nov 2022 14:32:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53786 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234871AbiKVTcY (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 22 Nov 2022 14:32:24 -0500
Received: from mail-pg1-x535.google.com (mail-pg1-x535.google.com [IPv6:2607:f8b0:4864:20::535])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D3BC29DBA6
        for <kvm@vger.kernel.org>; Tue, 22 Nov 2022 11:31:49 -0800 (PST)
Received: by mail-pg1-x535.google.com with SMTP id v3so14903736pgh.4
        for <kvm@vger.kernel.org>; Tue, 22 Nov 2022 11:31:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=siXftGv8ycXrMRraGh3XeU6UKcxAd+GukaGf1635NmA=;
        b=GASSlv0OoBHyhUZ3KS/fwCsfs7Jig2vXCU1qaEKmESBDmEIt1VtkDZ9AAC5dGybsAX
         LQ9Vvf2KkUpnEtoH6/6g320s0QsDrkjOa0pSGCpyy6Qu2qPyVvs45HeBmvPoibRnusaU
         tgyJEA4JkyC6uFROTJ2sSabgEOuSfYRUnn1Ky97/AV+Yo7TEJapcEghis5cmDGiNR/QA
         PR0MHcFFKA/LOJYGNoh72+ZPUzPoL8SzZNi9T1akV11xop1A9LbCrD7S1cvL12K5Aeff
         pOZ/JfyChc1IDiDEy/SVrf2j2zTsXskVuD9Juqhzk+1vYSxO8jg9/ni/A9ASsuX7WAx+
         7TCQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=siXftGv8ycXrMRraGh3XeU6UKcxAd+GukaGf1635NmA=;
        b=Q/O1BF7CcfwagYvevN2f3FDDm+ysxHAuLsEvelJ63gMwuKXyey69Dy9eYhVs0BsESc
         iBpe84rvDAMKiP2IKeL2vnD0DfFBBM7nw+SAWN1wXn98/u/N0oNsKXEycgl1YxHYEenM
         bvSEHB7qOTTPY5+YbeV1w71RGLY/XY2qGJeXDbE1al0lj6on/JQto6WVrS1mpm/EtHIF
         d22gDKcDrGbeLRaX5a6Z/mRQ2/woKoC3tL/wCDhPtHrQR62tvwY8lncYD0/ZKaLHcIV0
         rRT+twEFZ/wfnk8SVKW7fasGtQpegoj1E58wg765ZVwUMav2veJVa4y1cWcnSpB2LdQH
         pTUQ==
X-Gm-Message-State: ANoB5pmszvrIGtnifDtCHTI6NbBM4jB6dSIlGyUq96V8irE85dRzCvZX
        dB5zEK6u/GqOJjXJSaGbf/aLEA==
X-Google-Smtp-Source: AA0mqf7ksi6xnXTmcjIJCDhYhx70OWpjNJdfDF1pfmrBdIFzUVxRoF/w+K9uQSCTT8eYiFfpB+3BZg==
X-Received: by 2002:aa7:9057:0:b0:573:1d31:2b78 with SMTP id n23-20020aa79057000000b005731d312b78mr7551599pfo.61.1669145500962;
        Tue, 22 Nov 2022 11:31:40 -0800 (PST)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id o14-20020a170902d4ce00b00186acb14c4asm12529380plg.67.2022.11.22.11.31.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 22 Nov 2022 11:31:40 -0800 (PST)
Date:   Tue, 22 Nov 2022 19:31:36 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Peter Zijlstra <peterz@infradead.org>
Cc:     Thomas Gleixner <tglx@linutronix.de>,
        Kai Huang <kai.huang@intel.com>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, linux-mm@kvack.org, pbonzini@redhat.com,
        dave.hansen@intel.com, dan.j.williams@intel.com,
        rafael.j.wysocki@intel.com, kirill.shutemov@linux.intel.com,
        ying.huang@intel.com, reinette.chatre@intel.com,
        len.brown@intel.com, tony.luck@intel.com, ak@linux.intel.com,
        isaku.yamahata@intel.com, chao.gao@intel.com,
        sathyanarayanan.kuppuswamy@linux.intel.com, bagasdotme@gmail.com,
        sagis@google.com, imammedo@redhat.com
Subject: Re: [PATCH v7 06/20] x86/virt/tdx: Shut down TDX module in case of
 error
Message-ID: <Y30jmKOOsvtzt6UT@google.com>
References: <cover.1668988357.git.kai.huang@intel.com>
 <48505089b645019a734d85c2c29f3c8ae2dbd6bd.1668988357.git.kai.huang@intel.com>
 <Y3yUdcJjrY2LhUWJ@hirez.programming.kicks-ass.net>
 <87bkozgham.ffs@tglx>
 <Y30dujuXC8wlLwoQ@hirez.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y30dujuXC8wlLwoQ@hirez.programming.kicks-ass.net>
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

On Tue, Nov 22, 2022, Peter Zijlstra wrote:
> On Tue, Nov 22, 2022 at 04:06:25PM +0100, Thomas Gleixner wrote:
> > On Tue, Nov 22 2022 at 10:20, Peter Zijlstra wrote:
> > 
> > > On Mon, Nov 21, 2022 at 01:26:28PM +1300, Kai Huang wrote:
> > >
> > >> Shutting down the TDX module requires calling TDH.SYS.LP.SHUTDOWN on all
> > >> BIOS-enabled CPUs, and the SEMACALL can run concurrently on different
> > >> CPUs.  Implement a mechanism to run SEAMCALL concurrently on all online
> > >> CPUs and use it to shut down the module.  Later logical-cpu scope module
> > >> initialization will use it too.
> > >
> > > Uhh, those requirements ^ are not met by this:
> > 
> >   Can run concurrently != Must run concurrently
> >  
> > The documentation clearly says "can run concurrently" as quoted above.
> 
> The next sentense says: "Implement a mechanism to run SEAMCALL
> concurrently" -- it does not.
> 
> Anyway, since we're all in agreement there is no such requirement at
> all, a schedule_on_each_cpu() might be more appropriate, there is no
> reason to use IPIs and spin-waiting for any of this.

Backing up a bit, what's the reason for _any_ of this?  The changelog says

  It's pointless to leave the TDX module in some middle state.

but IMO it's just as pointless to do a shutdown unless the kernel benefits in
some meaningful way.  And IIUC, TDH.SYS.LP.SHUTDOWN does nothing more than change
the SEAM VMCS.HOST_RIP to point to an error trampoline.  E.g. it's not like doing
a shutdown lets the kernel reclaim memory that was gifted to the TDX module.

In other words, this is just a really expensive way of changing a function pointer,
and the only way it would ever benefit the kernel is if there is a kernel bug that
leads to trying to use TDX after a fatal error.  And even then, the only difference
seems to be that subsequent bogus SEAMCALLs would get a more unique error message.
