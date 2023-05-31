Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 631C0718E26
	for <lists+kvm@lfdr.de>; Thu,  1 Jun 2023 00:11:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230383AbjEaWLS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 31 May 2023 18:11:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34366 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230323AbjEaWLR (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 31 May 2023 18:11:17 -0400
Received: from mail-pl1-x633.google.com (mail-pl1-x633.google.com [IPv6:2607:f8b0:4864:20::633])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7B05A1A8;
        Wed, 31 May 2023 15:10:46 -0700 (PDT)
Received: by mail-pl1-x633.google.com with SMTP id d9443c01a7336-1b01d912924so1621995ad.1;
        Wed, 31 May 2023 15:10:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1685571045; x=1688163045;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=jxFmUEtMhjfhxHuV3izptzIg8x0o458VbsNC7Iu8cGM=;
        b=fX7f/UsuKcdp/VS+EYHgm7/mN/ehjiiXATTqPlvwY7alRPZspXouAPk9eP/XXF7fgI
         6eOSsRoW0X15FPscEmLHdH98+UhOzHukKM+frMpggBRZaL3mBpWGvObKtfBTvHO3Iso8
         KhnHlUCQ7fkfViw3NsUzu8Ohna1+BuSbtApkqO/xYWUWqjkgsPr/5xJg26eqtZ6Jsb0J
         d85g6dDLyoB+PZuKrkaQCXwcJZJr9Ayq3JEW+h/YW+JKzP2lFI6fnu0Ih5IfmJ3addjJ
         N8slD3ZW8hSNBwUW/IrOMX3YKY5joL2GjrzJV7VAuG/yEeOIaWEqI/HaLs4xye32vqqx
         J2LQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685571045; x=1688163045;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=jxFmUEtMhjfhxHuV3izptzIg8x0o458VbsNC7Iu8cGM=;
        b=PkKisQmz/mPN35V6Cfktmpm1GNwP8FIQisqhGWjGZ2dIPjkcGQBsQrQCM1uMPzSdU8
         xV8is5FZ/MXEL7ytJDdiKlMKsevmbySidIcTM3ldz+IB61+0SswyrlPu+lEGAmFWWpuo
         o9yVXR46tbXD6hk9dzAbDpVweL0hqZo77c4t6TLCrRcxhl1MVCMzLHHUcqCE5tXFEFEt
         6HtBCUdFB2sr/Ql8gC9tqXcbrqTXFDWV8KGGdyH7RMR28ueyuMxF1e+bv8Dqtrsm8F/V
         UgFBMhtW5KG9ZbKE6jXWvhvjKAaIpoD2ORXWA2q3i/+hUUtQ1ZyaHiuCkp+ObqyB7kXI
         gUcg==
X-Gm-Message-State: AC+VfDw2rLjCynI8mLScZm9q9bvYOloPH6gufCTs5EicWdcOp6hgUEYU
        KtlbZPKf2Gy1sOywvdaC4TJor3tiUZi5xw==
X-Google-Smtp-Source: ACHHUZ77U4dI6POrXwC2SVlJ+dfkSkj+Sg1WthMGv4VGs3cF85BjUsmr0/laUDtGXn7gBnLZlkmGzw==
X-Received: by 2002:a17:903:22c2:b0:1b0:5a41:db40 with SMTP id y2-20020a17090322c200b001b05a41db40mr7569930plg.50.1685571044810;
        Wed, 31 May 2023 15:10:44 -0700 (PDT)
Received: from localhost ([192.55.55.59])
        by smtp.gmail.com with ESMTPSA id h12-20020a170902f7cc00b001b008b3dee2sm1853732plw.287.2023.05.31.15.10.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 31 May 2023 15:10:44 -0700 (PDT)
Date:   Wed, 31 May 2023 15:10:42 -0700
From:   Isaku Yamahata <isaku.yamahata@gmail.com>
To:     Zhi Wang <zhi.wang.linux@gmail.com>
Cc:     isaku.yamahata@intel.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, isaku.yamahata@gmail.com,
        Paolo Bonzini <pbonzini@redhat.com>, erdemaktas@google.com,
        Sean Christopherson <seanjc@google.com>,
        Sagi Shahar <sagis@google.com>,
        David Matlack <dmatlack@google.com>,
        Kai Huang <kai.huang@intel.com>, chen.bo@intel.com
Subject: Re: [PATCH v14 003/113] KVM: x86/vmx: Refactor KVM VMX module
 init/exit functions
Message-ID: <20230531221042.GH1234772@ls.amr.corp.intel.com>
References: <cover.1685333727.git.isaku.yamahata@intel.com>
 <4ef61085333e97e0ae48c3d7603042b9801e3608.1685333727.git.isaku.yamahata@intel.com>
 <20230531093950.00007e7d.zhi.wang.linux@gmail.com>
 <20230531203012.GG1234772@ls.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20230531203012.GG1234772@ls.amr.corp.intel.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, May 31, 2023 at 01:30:12PM -0700,
Isaku Yamahata <isaku.yamahata@gmail.com> wrote:

> On Wed, May 31, 2023 at 09:57:18AM +0800,
> Zhi Wang <zhi.wang.linux@gmail.com> wrote:
> 
> > > +static int __init vt_init(void)
> > > +{
> > > +	unsigned int vcpu_size, vcpu_align;
> > > +	int r;
> > > +
> > > +	if (!kvm_is_vmx_supported())
> > > +		return -EOPNOTSUPP;
> > > +
> > > +	/*
> > > +	 * Note, hv_init_evmcs() touches only VMX knobs, i.e. there's nothing
> > > +	 * to unwind if a later step fails.
> > > +	 */
> > > +	hv_init_evmcs();
> > > +
> > > +	r = kvm_x86_vendor_init(&vt_init_ops);
> > > +	if (r)
> > > +		return r;
> > > +
> > > +	r = vmx_init();
> > > +	if (r)
> > > +		goto err_vmx_init;
> > > +
> > > +	/*
> > > +	 * Common KVM initialization _must_ come last, after this, /dev/kvm is
> > > +	 * exposed to userspace!
> > > +	 */
> > > +	vcpu_size = sizeof(struct vcpu_vmx);
> > > +	vcpu_align = __alignof__(struct vcpu_vmx);
> > > +	r = kvm_init(vcpu_size, vcpu_align, THIS_MODULE);
> > > +	if (r)
> > > +		goto err_kvm_init;
> > > +
> > > +	return 0;
> > > +
> > ---------------------------------
> > > +err_kvm_init:
> > > +	vmx_exit();
> > > +err_vmx_init:
> > > +	kvm_x86_vendor_exit();
> > > +	return r;
> > > +}
> > > +module_init(vt_init);
> > > +
> > ----------------------------------
> > > +static void vt_exit(void)
> > > +{
> > > +	kvm_exit();
> > > +	kvm_x86_vendor_exit();
> > > +	vmx_exit();
> > ----------------------------------
> > 
> > It seems the exiting sequences above are a little bit different with
> > each other (PS: It is not a prob introduced in this patch):
> > 
> > vmx_exit()
> > kvm_x86_vendor_exit()
> > ....
> > 
> > and
> > 
> > ...
> > kvm_x86_vnedor_exit()
> > vmx_exit()
> > 
> > I was wondering which one should be correct. Literally, the exiting
> > sequence would be in reversing order of the initialization sequence.
> 
> In theory, I think kvm_x86_vendor_exit() => vmx_exit() and
> vmx_init() => kvm_x86_vendor_exit() should be the right order.
> But in practice, it doesn't matter and I didn't want to touch the order with
> this patch series.

Here is the patch for it. But I'd like to hold the patch after this patch
series. 

From 02c425cb96c252eecbeaf8e57dd6afd7576931b1 Mon Sep 17 00:00:00 2001
Message-Id: <02c425cb96c252eecbeaf8e57dd6afd7576931b1.1685566207.git.isaku.yamahata@intel.com>
From: Isaku Yamahata <isaku.yamahata@intel.com>
Date: Wed, 31 May 2023 13:36:10 -0700
Subject: [PATCH] KVM: VMX: Reorder vmx initialization with kvm vendor
 initialization

To match vmx_exit cleanup.

Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
---
 arch/x86/kvm/vmx/main.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/arch/x86/kvm/vmx/main.c b/arch/x86/kvm/vmx/main.c
index 2e4667307458..a0586da86d81 100644
--- a/arch/x86/kvm/vmx/main.c
+++ b/arch/x86/kvm/vmx/main.c
@@ -1251,11 +1251,11 @@ static int __init vt_init(void)
 				   __alignof__(struct vcpu_tdx));
 	}
 
-	r = kvm_x86_vendor_init(&vt_init_ops);
+	r = vmx_init();
 	if (r)
-		return r;
+		goto err_vmx_init;
 
-	r = vmx_init();
+	r = kvm_x86_vendor_init(&vt_init_ops);
 	if (r)
 		goto err_vmx_init;
 
@@ -1270,9 +1270,9 @@ static int __init vt_init(void)
 	return 0;
 
 err_kvm_init:
-	vmx_exit();
-err_vmx_init:
 	kvm_x86_vendor_exit();
+err_vmx_init:
+	vmx_exit();
 	return r;
 }
 module_init(vt_init);
-- 
2.25.1




-- 
Isaku Yamahata <isaku.yamahata@gmail.com>
