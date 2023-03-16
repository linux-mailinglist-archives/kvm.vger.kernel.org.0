Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DE0D46BC27E
	for <lists+kvm@lfdr.de>; Thu, 16 Mar 2023 01:31:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233006AbjCPAbH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 15 Mar 2023 20:31:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33622 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231701AbjCPAbG (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 15 Mar 2023 20:31:06 -0400
Received: from mail-pg1-x534.google.com (mail-pg1-x534.google.com [IPv6:2607:f8b0:4864:20::534])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4FD7F88DAF;
        Wed, 15 Mar 2023 17:31:05 -0700 (PDT)
Received: by mail-pg1-x534.google.com with SMTP id s17so30476pgv.4;
        Wed, 15 Mar 2023 17:31:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1678926665;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=9KhrkJGSUOYiiVfotnNQfrQRu80N+GO4LCzY8Gnj/3w=;
        b=WB/xmzCsZRZtBIneo/AO01OwGLTrzzIQLgaUwzbND73RDg+PHC/zVOVnq3CrJHOlSc
         ++cFP2P+wFQzuZ+g4e04Dyj8WZQ+4n96gQNzpFvGmSzaWeTUsAdiTRyQbOpZKqVxn+oY
         yDP1LnIiYSeyvlhR53U5wE9LM2tyWJj94g4OSGAygyMlAbKEQ71n8+B5ZowXN07WRJXa
         NMD2sh4JrrS4pFPy59RNoGDrvKU+oRHnx49Dh2cg8t6dfAi5HnruloXaNPpXQISEiyCz
         HERy92y62Nn80x7R9As/vuFZlznBDV6PYVD/9oUjdujytkNa9Ym3pRrTqDKxVqRJGsZf
         WWSQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678926665;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=9KhrkJGSUOYiiVfotnNQfrQRu80N+GO4LCzY8Gnj/3w=;
        b=js+Cl8h99J0yPqmReJpu0tKaVSlXPJJlD04vbQtHDXUVhba02JrO9s/Xk0Rj0b9v5+
         K9/N35FGiTXjL8LT7hFQPhKroUlIBcb0/Oj1cKdRbmjEF/e0/+65/6D9SCXZK3zUnRqu
         HCj57iwRyWnbypOX3NYbsk57efGFIcoReggH9OXM26i1NXUala6izbTp2REe4GULThYn
         wVz+pSbcmbrJb02EiDE+fR4l5ZkF8MC8dKcHCU4xjzjoAe/Fy2JJ5WXkau5eWG6EJYT7
         6DTweOp9AijE1S4wPKlbiI+Ls66NdyBvcFkXk073L1tvs8CL9txpNo9ECw1+8vEVmsI6
         0Llg==
X-Gm-Message-State: AO0yUKVUjZ4Y+rn8qfBYx7fgmDq8v+PcTllfj6GbnnUpTG94PhmTGEsg
        1OpN4jydK+2GLlMAOBTwg9o=
X-Google-Smtp-Source: AK7set/esHi5avqDM2fH/I0qVxsmqc3WYu3IkEKKVsSeLWv7mYXWdyRBXofbNOj9imT11r//7zi6Ow==
X-Received: by 2002:aa7:9591:0:b0:625:290:e303 with SMTP id z17-20020aa79591000000b006250290e303mr1504683pfj.14.1678926664681;
        Wed, 15 Mar 2023 17:31:04 -0700 (PDT)
Received: from localhost ([192.55.54.55])
        by smtp.gmail.com with ESMTPSA id e4-20020a62ee04000000b00587fda4a260sm4100324pfi.9.2023.03.15.17.31.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 15 Mar 2023 17:31:04 -0700 (PDT)
Date:   Wed, 15 Mar 2023 17:31:02 -0700
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
Message-ID: <20230316003102.GB197448@ls.amr.corp.intel.com>
References: <cover.1678111292.git.kai.huang@intel.com>
 <f150316b975b5ca22c6c4016ffd90db79d657bbf.1678111292.git.kai.huang@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <f150316b975b5ca22c6c4016ffd90db79d657bbf.1678111292.git.kai.huang@intel.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Mar 07, 2023 at 03:13:50AM +1300,
Kai Huang <kai.huang@intel.com> wrote:

> +static int try_init_module_global(void)
> +{
> +	int ret;
> +
> +	/*
> +	 * The TDX module global initialization only needs to be done
> +	 * once on any cpu.
> +	 */
> +	spin_lock(&tdx_global_init_lock);


If I use tdx_cpu_enable() via kvm hardware_enable_all(), this function is called
in the context IPI callback and the lockdep complains.  Here is my patch to
address it

From 0c4022ffe8cd68dfb455c418eb65538e4e100115 Mon Sep 17 00:00:00 2001
Message-Id: <0c4022ffe8cd68dfb455c418eb65538e4e100115.1678926123.git.isaku.yamahata@intel.com>
In-Reply-To: <d2aa2142665b8204b628232ab615c98090371c99.1678926122.git.isaku.yamahata@intel.com>
References: <d2aa2142665b8204b628232ab615c98090371c99.1678926122.git.isaku.yamahata@intel.com>
From: Isaku Yamahata <isaku.yamahata@intel.com>
Date: Wed, 15 Mar 2023 14:26:37 -0700
Subject: [PATCH] x86/virt/vmx/tdx: Use raw spin lock instead of spin lock

tdx_cpu_enable() can be called by IPI handler.  The lockdep complains about
spin lock as follows.  Use raw spin lock.

=============================
[ BUG: Invalid wait context ]
6.3.0-rc1-tdx-kvm-upstream+ #389 Not tainted
-----------------------------
swapper/154/0 is trying to lock:
ffffffffa7875e58 (tdx_global_init_lock){....}-{3:3}, at: tdx_cpu_enable+0x67/0x180
other info that might help us debug this:
context-{2:2}
no locks held by swapper/154/0.
stack backtrace:
Call Trace:
 <IRQ>
 dump_stack_lvl+0x64/0xb0
 dump_stack+0x10/0x20
 __lock_acquire+0x912/0xc30
 lock_acquire.part.0+0x99/0x220
 lock_acquire+0x60/0x170
 _raw_spin_lock_irqsave+0x43/0x70
 tdx_cpu_enable+0x67/0x180
 vt_hardware_enable+0x3b/0x60
 kvm_arch_hardware_enable+0xe7/0x2e0
 hardware_enable_nolock+0x33/0x80
 __flush_smp_call_function_queue+0xc4/0x590
 generic_smp_call_function_single_interrupt+0x1a/0xb0
 __sysvec_call_function+0x48/0x200
 sysvec_call_function+0xad/0xd0
 </IRQ>

Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
---
 arch/x86/virt/vmx/tdx/tdx.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/arch/x86/virt/vmx/tdx/tdx.c b/arch/x86/virt/vmx/tdx/tdx.c
index 2ee37a5dedcf..e1c8ffad7406 100644
--- a/arch/x86/virt/vmx/tdx/tdx.c
+++ b/arch/x86/virt/vmx/tdx/tdx.c
@@ -41,7 +41,7 @@ static u32 tdx_guest_keyid_start __ro_after_init;
 static u32 tdx_nr_guest_keyids __ro_after_init;
 
 static unsigned int tdx_global_init_status;
-static DEFINE_SPINLOCK(tdx_global_init_lock);
+static DEFINE_RAW_SPINLOCK(tdx_global_init_lock);
 #define TDX_GLOBAL_INIT_DONE	_BITUL(0)
 #define TDX_GLOBAL_INIT_FAILED	_BITUL(1)
 
@@ -349,6 +349,7 @@ static void tdx_trace_seamcalls(u64 level)
 
 static int try_init_module_global(void)
 {
+	unsigned long flags;
 	u64 tsx_ctrl;
 	int ret;
 
@@ -356,7 +357,7 @@ static int try_init_module_global(void)
 	 * The TDX module global initialization only needs to be done
 	 * once on any cpu.
 	 */
-	spin_lock(&tdx_global_init_lock);
+	raw_spin_lock_irqsave(&tdx_global_init_lock, flags);
 
 	if (tdx_global_init_status & TDX_GLOBAL_INIT_DONE) {
 		ret = tdx_global_init_status & TDX_GLOBAL_INIT_FAILED ?
@@ -373,7 +374,7 @@ static int try_init_module_global(void)
 	if (ret)
 		tdx_global_init_status |= TDX_GLOBAL_INIT_FAILED;
 out:
-	spin_unlock(&tdx_global_init_lock);
+	raw_spin_unlock_irqrestore(&tdx_global_init_lock, flags);
 
 	if (ret) {
 		if (trace_boot_seamcalls)
-- 
2.25.1


-- 
Isaku Yamahata <isaku.yamahata@gmail.com>
