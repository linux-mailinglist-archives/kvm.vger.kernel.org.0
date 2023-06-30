Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F0AC5744276
	for <lists+kvm@lfdr.de>; Fri, 30 Jun 2023 20:42:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229774AbjF3Smk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 30 Jun 2023 14:42:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46952 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232498AbjF3Smi (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 30 Jun 2023 14:42:38 -0400
Received: from mail-pf1-x42c.google.com (mail-pf1-x42c.google.com [IPv6:2607:f8b0:4864:20::42c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6E8EC3C26;
        Fri, 30 Jun 2023 11:42:37 -0700 (PDT)
Received: by mail-pf1-x42c.google.com with SMTP id d2e1a72fcca58-6687466137bso1746742b3a.0;
        Fri, 30 Jun 2023 11:42:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1688150557; x=1690742557;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=s90sSJDGZ4o69CYENWCxmFlyZZs5Y1mAusgwMiJFmQc=;
        b=qTdD+kQ/dZz9jFS4u5KBrSV1OOJAOhIlDM0dffuAP0q3sUhu/kxp8taqzzUmdZpudY
         c22eskJXTrN4HL16oes8igxcavJCz/amPw78uiR4IBRXlUFSHO6sCHH13SbUrTlmIPsg
         MbFxEY4ya8HuDWT4NfdtdKdqi+77XSdGXWebLa9+pMmjF9olCc/kuS2bY0Ejj4jrK+s9
         WC99WMEyGCsdIdaIoBGMD0/aVJ10bej66ILx9pklM69fAPeHlENKvBGOgThvqX2p7UOB
         bkCHri3FXlSAhTrsava4uloq6l8Y63TpLaQLLlB4QpNi4DhDALNbEUcGTDqNpRPb2x3x
         +knA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1688150557; x=1690742557;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=s90sSJDGZ4o69CYENWCxmFlyZZs5Y1mAusgwMiJFmQc=;
        b=WuzSuEd/JfngwL5rGpzr8te0PsV5YNmvR3+vX5RFhO4s6FJIRjXgJWsnML2tjHwPOV
         gzC/dJaIAgWhNJtwTeatOpXYoXT/xiPsic8RxCMmG+FQVANPBeUx1hMpAPyyX3CU0dkC
         bf1HHw2Bp1uIri2O/O3rZ7yxW/UGUZFRRpocfSTGn+br6JBOBcezWiiZjuH2fZv1KWZO
         LeiS6u7xBBj3/oh2zVpOe/SDuxncEGkBKzzKKPxGJsEgF1EaXt5br30wds8CgqhjPqXm
         G0S7eYR/hth8M+O/ll7bWkqQX2k3FgRDydMeXequ3J31oCrfq6ZaTrhB8BNqnAU5i5fx
         juWg==
X-Gm-Message-State: ABy/qLbNNTHNgOAjqyA7k5euOMb4vMw2q7WZPEIdpuOlVDGkJ5Of5Q6M
        l1L4IjySfQLNRDSVuKEQTVg=
X-Google-Smtp-Source: APBJJlEGsVVJrMfSJnWrKK8x9XhlvZ/lVjRS2VwnK4Qau3PCGMmGslkxKbq9jz3H2x84e9lAp+eoow==
X-Received: by 2002:a62:7b07:0:b0:682:57f0:7c00 with SMTP id w7-20020a627b07000000b0068257f07c00mr3143508pfc.3.1688150556680;
        Fri, 30 Jun 2023 11:42:36 -0700 (PDT)
Received: from localhost ([192.55.54.50])
        by smtp.gmail.com with ESMTPSA id j18-20020a62e912000000b00666add7f047sm10215681pfh.207.2023.06.30.11.42.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 30 Jun 2023 11:42:35 -0700 (PDT)
Date:   Fri, 30 Jun 2023 11:42:29 -0700
From:   Isaku Yamahata <isaku.yamahata@gmail.com>
To:     "Huang, Kai" <kai.huang@intel.com>
Cc:     "peterz@infradead.org" <peterz@infradead.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "Gao, Chao" <chao.gao@intel.com>,
        "Raj, Ashok" <ashok.raj@intel.com>,
        "Shahar, Sagi" <sagis@google.com>,
        "Hansen, Dave" <dave.hansen@intel.com>,
        "david@redhat.com" <david@redhat.com>,
        "bagasdotme@gmail.com" <bagasdotme@gmail.com>,
        "ak@linux.intel.com" <ak@linux.intel.com>,
        "Wysocki, Rafael J" <rafael.j.wysocki@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Chatre, Reinette" <reinette.chatre@intel.com>,
        "Christopherson,, Sean" <seanjc@google.com>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "Yamahata, Isaku" <isaku.yamahata@intel.com>,
        "nik.borisov@suse.com" <nik.borisov@suse.com>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "Luck, Tony" <tony.luck@intel.com>,
        "kirill.shutemov@linux.intel.com" <kirill.shutemov@linux.intel.com>,
        "hpa@zytor.com" <hpa@zytor.com>,
        "imammedo@redhat.com" <imammedo@redhat.com>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "bp@alien8.de" <bp@alien8.de>, "Brown, Len" <len.brown@intel.com>,
        "sathyanarayanan.kuppuswamy@linux.intel.com" 
        <sathyanarayanan.kuppuswamy@linux.intel.com>,
        "Huang, Ying" <ying.huang@intel.com>,
        "x86@kernel.org" <x86@kernel.org>,
        "Williams, Dan J" <dan.j.williams@intel.com>,
        isaku.yamahata@gmail.com
Subject: Re: [PATCH v12 07/22] x86/virt/tdx: Add skeleton to enable TDX on
 demand
Message-ID: <20230630184229.GG3436214@ls.amr.corp.intel.com>
References: <104d324cd68b12e14722ee5d85a660cccccd8892.1687784645.git.kai.huang@intel.com>
 <20230627095012.ln47s62pqzdrnb7x@box.shutemov.name>
 <d6a0fb32ebcdeb6c38ebe8e2b03f034f42360c0f.camel@intel.com>
 <20230627121853.ek5zr7sfiezfkfyj@box.shutemov.name>
 <9361abfa9bf22c2a1a4b25e5495bcccc5b8dcd43.camel@intel.com>
 <7b61715ad35d7b9916f55df72378e02e62c5cc4e.camel@intel.com>
 <20230628133541.GF2438817@hirez.programming.kicks-ass.net>
 <03def8b40a7db14f31d2ad67fb1a201e8ae8bce0.camel@intel.com>
 <20230630092232.GB2533791@hirez.programming.kicks-ass.net>
 <716cdf73799a5322cbe34c7f23d582f8a3ecf301.camel@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <716cdf73799a5322cbe34c7f23d582f8a3ecf301.camel@intel.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Jun 30, 2023 at 10:09:08AM +0000,
"Huang, Kai" <kai.huang@intel.com> wrote:

> On Fri, 2023-06-30 at 11:22 +0200, Peter Zijlstra wrote:
> > On Thu, Jun 29, 2023 at 12:15:13AM +0000, Huang, Kai wrote:
> > 
> > > > 	Can be called locally or through an IPI function call.
> > > > 
> > > 
> > > Thanks.  As in another reply, if using spinlock is OK, then I think we can say
> > > it will be called either locally or through an IPI function call.  Otherwise, we
> > > do via a new separate function tdx_global_init() and no lock is needed in that
> > > function.  The caller should call it properly.
> > 
> > IPI must use raw_spinlock_t. I'm ok with using raw_spinlock_t if there's
> > actual need for that, but the code as presented didn't -- in comments or
> > otherwise -- make it clear why it was as it was.
> 
> There's no hard requirement as I replied in another email.
> 
> Presumably you prefer the option to have a dedicated tdx_global_init() so we can
> avoid the raw_spinlock_t?

TDX KVM calls tdx_cpu_enable() in IPI context as KVM hardware_setup() callback.
tdx_cpu_enable() calls tdx_global_init().
-- 
Isaku Yamahata <isaku.yamahata@gmail.com>
