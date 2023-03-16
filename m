Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 630B56BC3F0
	for <lists+kvm@lfdr.de>; Thu, 16 Mar 2023 03:45:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229701AbjCPCpX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 15 Mar 2023 22:45:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43286 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229556AbjCPCpV (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 15 Mar 2023 22:45:21 -0400
Received: from mail-pl1-x62f.google.com (mail-pl1-x62f.google.com [IPv6:2607:f8b0:4864:20::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D9B693CE1D;
        Wed, 15 Mar 2023 19:45:19 -0700 (PDT)
Received: by mail-pl1-x62f.google.com with SMTP id iw3so287935plb.6;
        Wed, 15 Mar 2023 19:45:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1678934719;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=Av+oX0XnbDdNARNcmN0g/sKvTcF1A2qXjoo1gbUEn+o=;
        b=TSOlPenQOpkkWNYzq2P9Xss496yyC1hfvDnQg/Whu6Z/ySk+ZrUohBciKvTwT5W1mZ
         F+53XH+fUZ8/emXjPKr0Rjue7Z+CvOX2O/HCkUDLrQBx3WjH1Ck3eE2gjfsLQro+gY0s
         Mnqjo9PPIn6dnyU+XYqX4n8DFkefoUk717fRKXBjSzx1LcrOS4b7BQ6FcJ0lEFrKnzRu
         x6NhaV48BtE1OEL1/G2ut0Qz3dxu9QTxiDr7fiY8C5Oek5GB8IApd/lweYITxy0o56PV
         VDxGS3PdFIgrLNEqje3c3RRADNyyzyDLDqzi7W7T0/Fw55zuPMnqvk4Qnn9GStExstZ2
         hG6A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678934719;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Av+oX0XnbDdNARNcmN0g/sKvTcF1A2qXjoo1gbUEn+o=;
        b=IyUAZJG/tEpt7SOD8SR7bZZU8jdaqPdWJgPq4FK7UG5F+JwVU9gM8HH65QGq/EuXlZ
         HDSu9EWcjKbX5yze7a0aeGUGsRjGLGML/ieKqOR7+GARAZBDGTO2ke6rKHL5MbWW1RhM
         1yCHwaNn/hIfQMwVHq3/zSnM0kJ+qhY3JKRDM/ywuty0hNuMkvjNkv0+6pcGb3eMna6s
         S6UEPE0E+GX5ecR5UkYl7F3zALFyP8XWJlsFrTGQqH5ZOWc+/0tiMeJxnF1ff6iMee0K
         Ba1fdVkkDzcb87MAmqQLMuHNau6hbsh9ZsLZByooUPMozjpeFynnEFxjNqZbXzoqzVAV
         lbnA==
X-Gm-Message-State: AO0yUKWar0xX7u/6SeQPhigmQmfPg1lTZuBj6XOk5g/++RcXXY6FmTBJ
        LjDg9uNfgJ5xeRRwJVIJsYE=
X-Google-Smtp-Source: AK7set8xm7nDqKehvLTCj4Tr3ZoXrci3aHs6MQE/gwPsjkrqR2h18M6L4QoBBSjK1afrPjludTGkJg==
X-Received: by 2002:a05:6a21:9983:b0:d6:bfc0:54e6 with SMTP id ve3-20020a056a21998300b000d6bfc054e6mr1784963pzb.53.1678934719087;
        Wed, 15 Mar 2023 19:45:19 -0700 (PDT)
Received: from localhost ([192.55.54.55])
        by smtp.gmail.com with ESMTPSA id u6-20020aa78386000000b005d3399efd80sm4176609pfm.136.2023.03.15.19.45.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 15 Mar 2023 19:45:18 -0700 (PDT)
Date:   Wed, 15 Mar 2023 19:45:16 -0700
From:   Isaku Yamahata <isaku.yamahata@gmail.com>
To:     Kai Huang <kai.huang@intel.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        linux-mm@kvack.org, dave.hansen@intel.com, peterz@infradead.org,
        tglx@linutronix.de, seanjc@google.com, pbonzini@redhat.com,
        dan.j.williams@intel.com, rafael.j.wysocki@intel.com,
        kirill.shutemov@linux.intel.com, ying.huang@intel.com,
        reinette.chatre@intel.com, len.brown@intel.com,
        tony.luck@intel.com, ak@linux.intel.com, isaku.yamahata@intel.com,
        chao.gao@intel.com, sathyanarayanan.kuppuswamy@linux.intel.com,
        david@redhat.com, bagasdotme@gmail.com, sagis@google.com,
        imammedo@redhat.com, isaku.yamahata@gmail.com
Subject: Re: [PATCH v10 05/16] x86/virt/tdx: Add skeleton to enable TDX on
 demand
Message-ID: <20230316024516.GA259042@ls.amr.corp.intel.com>
References: <cover.1678111292.git.kai.huang@intel.com>
 <f150316b975b5ca22c6c4016ffd90db79d657bbf.1678111292.git.kai.huang@intel.com>
 <20230316003102.GB197448@ls.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20230316003102.GB197448@ls.amr.corp.intel.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Mar 15, 2023 at 05:31:02PM -0700,
Isaku Yamahata <isaku.yamahata@gmail.com> wrote:

> On Tue, Mar 07, 2023 at 03:13:50AM +1300,
> Kai Huang <kai.huang@intel.com> wrote:
> 
> > +static int try_init_module_global(void)
> > +{
> > +	int ret;
> > +
> > +	/*
> > +	 * The TDX module global initialization only needs to be done
> > +	 * once on any cpu.
> > +	 */
> > +	spin_lock(&tdx_global_init_lock);
> 
> 
> If I use tdx_cpu_enable() via kvm hardware_enable_all(), this function is called
> in the context IPI callback and the lockdep complains.  Here is my patch to
> address it
> 
> From 0c4022ffe8cd68dfb455c418eb65538e4e100115 Mon Sep 17 00:00:00 2001
> Message-Id: <0c4022ffe8cd68dfb455c418eb65538e4e100115.1678926123.git.isaku.yamahata@intel.com>
> In-Reply-To: <d2aa2142665b8204b628232ab615c98090371c99.1678926122.git.isaku.yamahata@intel.com>
> References: <d2aa2142665b8204b628232ab615c98090371c99.1678926122.git.isaku.yamahata@intel.com>
> From: Isaku Yamahata <isaku.yamahata@intel.com>
> Date: Wed, 15 Mar 2023 14:26:37 -0700
> Subject: [PATCH] x86/virt/vmx/tdx: Use raw spin lock instead of spin lock
> 
> tdx_cpu_enable() can be called by IPI handler.  The lockdep complains about
> spin lock as follows.  Use raw spin lock.
> 
> =============================
> [ BUG: Invalid wait context ]
> 6.3.0-rc1-tdx-kvm-upstream+ #389 Not tainted
> -----------------------------
> swapper/154/0 is trying to lock:
> ffffffffa7875e58 (tdx_global_init_lock){....}-{3:3}, at: tdx_cpu_enable+0x67/0x180
> other info that might help us debug this:
> context-{2:2}
> no locks held by swapper/154/0.
> stack backtrace:
> Call Trace:
>  <IRQ>
>  dump_stack_lvl+0x64/0xb0
>  dump_stack+0x10/0x20
>  __lock_acquire+0x912/0xc30
>  lock_acquire.part.0+0x99/0x220
>  lock_acquire+0x60/0x170
>  _raw_spin_lock_irqsave+0x43/0x70
>  tdx_cpu_enable+0x67/0x180
>  vt_hardware_enable+0x3b/0x60
>  kvm_arch_hardware_enable+0xe7/0x2e0
>  hardware_enable_nolock+0x33/0x80
>  __flush_smp_call_function_queue+0xc4/0x590
>  generic_smp_call_function_single_interrupt+0x1a/0xb0
>  __sysvec_call_function+0x48/0x200
>  sysvec_call_function+0xad/0xd0
>  </IRQ>
> 
> Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
> ---
>  arch/x86/virt/vmx/tdx/tdx.c | 7 ++++---
>  1 file changed, 4 insertions(+), 3 deletions(-)
> 
> diff --git a/arch/x86/virt/vmx/tdx/tdx.c b/arch/x86/virt/vmx/tdx/tdx.c
> index 2ee37a5dedcf..e1c8ffad7406 100644
> --- a/arch/x86/virt/vmx/tdx/tdx.c
> +++ b/arch/x86/virt/vmx/tdx/tdx.c
> @@ -41,7 +41,7 @@ static u32 tdx_guest_keyid_start __ro_after_init;
>  static u32 tdx_nr_guest_keyids __ro_after_init;
>  
>  static unsigned int tdx_global_init_status;
> -static DEFINE_SPINLOCK(tdx_global_init_lock);
> +static DEFINE_RAW_SPINLOCK(tdx_global_init_lock);
>  #define TDX_GLOBAL_INIT_DONE	_BITUL(0)
>  #define TDX_GLOBAL_INIT_FAILED	_BITUL(1)
>  
> @@ -349,6 +349,7 @@ static void tdx_trace_seamcalls(u64 level)
>  
>  static int try_init_module_global(void)
>  {
> +	unsigned long flags;
>  	u64 tsx_ctrl;
>  	int ret;
>  
> @@ -356,7 +357,7 @@ static int try_init_module_global(void)
>  	 * The TDX module global initialization only needs to be done
>  	 * once on any cpu.
>  	 */
> -	spin_lock(&tdx_global_init_lock);
> +	raw_spin_lock_irqsave(&tdx_global_init_lock, flags);

As hardware_enable_all() uses cpus_read_lock(), irqsave isn't needed.
this line should be raw_spin_lock().
-- 
Isaku Yamahata <isaku.yamahata@gmail.com>
