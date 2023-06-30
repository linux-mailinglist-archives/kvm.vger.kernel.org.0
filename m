Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CB847744297
	for <lists+kvm@lfdr.de>; Fri, 30 Jun 2023 21:05:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231657AbjF3TFU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 30 Jun 2023 15:05:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54962 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229496AbjF3TFS (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 30 Jun 2023 15:05:18 -0400
Received: from mail-pl1-x62e.google.com (mail-pl1-x62e.google.com [IPv6:2607:f8b0:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4EA0C3C07;
        Fri, 30 Jun 2023 12:05:17 -0700 (PDT)
Received: by mail-pl1-x62e.google.com with SMTP id d9443c01a7336-1b80b3431d2so12644515ad.1;
        Fri, 30 Jun 2023 12:05:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1688151917; x=1690743917;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=RJ/Bjj7UgFLjyJ/XPY4F5cdR2P4V5WLUlrEluwuFUbY=;
        b=K1koUZFo0z2kww6jx8agSY7s7GelmnNWGN7z+m+ALsYncM0sZW4Q+/9qTRtbZqhoAF
         3Tnj1P3xyjGIoBsYD3HrI27Zenv5sM/vTqIFmPaSyeAU/DVrAESWWFC/V4SaR7krLxpe
         QT5s4cByIfjEnzAK3ecXY3m8rVde4aku2dVRKvNSTxuYV9SlttJk4+2wL5TGaHlyuwRP
         rjNbrsJhwOJnavpjggxaUsD4lwueuF9SzB4eKmvKOWDleCcOBhfbf5pvxedVx8tKxE5f
         /6QrIJz4WxeRswPa5SyYZTOX9KPSQHp8cq7fs35Jm2zqDGexrNXB9iW+M8JXaFyYPTU2
         uOWA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1688151917; x=1690743917;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=RJ/Bjj7UgFLjyJ/XPY4F5cdR2P4V5WLUlrEluwuFUbY=;
        b=GMHPSr7bHcwPXXFLHb8tH6ikgtxPLYSopXwhUlBto7ioAkBgxnz5julRyY44V/IIi0
         S1/JZL8T1S3R2oIjD7ZRbR626nY5reuAzQJrWfLWyrI30a8R4tasQsVZAFoeCCh3juGE
         nXoSYABm993oPldqfImTjWp+a1wWYg+SoTBwGBbZX6hXhxN9SLJHhj4gyxMdLmUOCNvl
         +xweRCfE1+Y2c8g3Aat0AK6/cOm9dTDSxPlEi0Ctrkoo3O7+e8/N3S7GlVOB7e5wW4nM
         yr26WyzOzDXZ3u1FM5s8qESe2X1sNn7HRuYkbdO+NAeeg4PmkbF1t+NEMa1r/FZutNLu
         RHJw==
X-Gm-Message-State: ABy/qLaFzODGxzqBUN0TycSQf3nrCJw9C54t8uZci/JSUyUj1Co4AODt
        N18MPW3eAwByQLRXk/2wZfE=
X-Google-Smtp-Source: APBJJlGHdBhyZXUGWy/18tPYJ1kuhxdereLGB5aBXAE7gxcBR5uxqgaOff8fiHHqGA99JxOl4KkHFQ==
X-Received: by 2002:a17:902:cecf:b0:1b2:1942:9106 with SMTP id d15-20020a170902cecf00b001b219429106mr3075288plg.64.1688151916582;
        Fri, 30 Jun 2023 12:05:16 -0700 (PDT)
Received: from localhost ([192.55.54.50])
        by smtp.gmail.com with ESMTPSA id t4-20020a1709028c8400b001b83db0bcf2sm4651034plo.141.2023.06.30.12.05.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 30 Jun 2023 12:05:15 -0700 (PDT)
Date:   Fri, 30 Jun 2023 12:05:14 -0700
From:   Isaku Yamahata <isaku.yamahata@gmail.com>
To:     Peter Zijlstra <peterz@infradead.org>
Cc:     "Huang, Kai" <kai.huang@intel.com>,
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
Subject: Re: [PATCH v12 07/22] x86/virt/tdx: Add skeleton to enable TDX on
 demand
Message-ID: <20230630190514.GH3436214@ls.amr.corp.intel.com>
References: <cover.1687784645.git.kai.huang@intel.com>
 <104d324cd68b12e14722ee5d85a660cccccd8892.1687784645.git.kai.huang@intel.com>
 <20230628131717.GE2438817@hirez.programming.kicks-ass.net>
 <0c9639db604a0670eeae5343d456e43d06b35d39.camel@intel.com>
 <20230630092615.GD2533791@hirez.programming.kicks-ass.net>
 <2659d6eef84f008635ba300f4712501ac88cef2c.camel@intel.com>
 <20230630183020.GA4253@hirez.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20230630183020.GA4253@hirez.programming.kicks-ass.net>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Jun 30, 2023 at 08:30:20PM +0200,
Peter Zijlstra <peterz@infradead.org> wrote:

> On Fri, Jun 30, 2023 at 09:55:32AM +0000, Huang, Kai wrote:
> > On Fri, 2023-06-30 at 11:26 +0200, Peter Zijlstra wrote:
> > > On Thu, Jun 29, 2023 at 12:10:00AM +0000, Huang, Kai wrote:
> > > > On Wed, 2023-06-28 at 15:17 +0200, Peter Zijlstra wrote:
> > > > > On Tue, Jun 27, 2023 at 02:12:37AM +1200, Kai Huang wrote:
> > > > > > +EXPORT_SYMBOL_GPL(tdx_cpu_enable);
> > > > > 
> > > > > I can't find a single caller of this.. why is this exported?
> > > > 
> > > > It's for KVM TDX patch to use, which isn't in this series.
> > > > 
> > > > I'll remove the export.  KVM TDX series can export it.
> > > 
> > > Fair enough; where will the KVM TDX series call this? Earlier there was
> > > talk about doing it at kvm module load time -- but I objected (and still
> > > do object) to that.
> > > 
> > > What's the current plan?
> > > 
> > 
> > The direction is still doing it during module load (not my series anyway).  But
> > this can be a separate discussion with KVM maintainers involved.
> 
> They all on Cc afaict.
> 
> > I understand you have concern that you don't want to have the memory & cpu time
> > wasted on enabling TDX by default.  For that we can have a kernel command line
> > to disable TDX once for all (we can even make it default).
> 
> That's insane, I don't want to totally disable it. I want it done at
> guard creation. Do the whole TDX setup the moment you actually create a
> TDX guast.
> 
> Totally killing TDX is stupid, just about as stupid as doing it on
> module load (which equates to always doing it).
> 
> > Also, KVM will have a module parameter 'enable_tdx'.  I am hoping this could
> > reduce your concern too.
> 
> I don't get this obsession with doing at module load time :/

The KVM maintainers prefer the initialization on kvm_intel.ko loading time. [1]
I can change enable_tdx parameter for kvm_intel.ko instead of boolean.
Something like

enable_tdx
        ondemand: on-demand initialization when creating the first TDX guest
        onload:   initialize TDX module when loading kvm_intel.ko
        disable:  disable TDX support
        

[1] https://lore.kernel.org/lkml/YkTvw5OXTTFf7j4y@google.com/
-- 
Isaku Yamahata <isaku.yamahata@gmail.com>
