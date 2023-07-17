Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A03A57569E7
	for <lists+kvm@lfdr.de>; Mon, 17 Jul 2023 19:13:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229904AbjGQRM7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 17 Jul 2023 13:12:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34556 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230405AbjGQRMn (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 17 Jul 2023 13:12:43 -0400
Received: from mail-pl1-x635.google.com (mail-pl1-x635.google.com [IPv6:2607:f8b0:4864:20::635])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5706E1B5;
        Mon, 17 Jul 2023 10:12:41 -0700 (PDT)
Received: by mail-pl1-x635.google.com with SMTP id d9443c01a7336-1bb1baf55f5so25365515ad.0;
        Mon, 17 Jul 2023 10:12:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1689613961; x=1692205961;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=Su4c46X8cRa6PHlO4wAUnjVZ+C+9OAGrRoJ7Aqgs5cU=;
        b=WhyYIPZO2p/YK6SgdYh6KiwmnlwFGuP6x4o8fFwfjzP+k6nWK6x2EQrcUhIMLtG4Mx
         Whm04pBT4llFHDRUKvbjL0pDnzPiWOCd/ANwoVihiOr3NeNeZHJRYz0SiP5iIDYNIjJg
         PmgNSHJFfg1lwtCaKM591/qkZ/cYCDZ1TjeOybC+bVwttAqPs6U1Fmle4dPAXzrMlTGS
         Z6SA5nrmWax6/N8LUJOUjn4e2BsXzJeu0Ksg/n6Joopb4MpWdOyoV/pkAb/95N1JFM5c
         X6LeAWmt4mA3kiYVq5eRRer7lQUjtG2K7gtpBKq+38Dq2qO1PxQn/EY9BL/t/YMzuFUl
         GRpQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1689613961; x=1692205961;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Su4c46X8cRa6PHlO4wAUnjVZ+C+9OAGrRoJ7Aqgs5cU=;
        b=X70VBmRqRHBgjXsHMlk/Sw7cpn5uX7zTa7j+QKZAI1WgIbbdKpj4kHFMn5qk3ADD0v
         QDTL9X+19KKsi+CLcm5ZkHJL73aKwNVDfpx74GKk06Gi0UBMjspCgo8Qy3Ufas5Sp3fU
         MNkk1IkS8gDiq0zKX+buuZAI4ZuR0Po1+QtIzW23M2zMcDrrmv+yZAgyD9tQU+zbiGwz
         t9UxHhxvHmxeYzwDTnGSEvmGsKu0hPpOTUtcFVVF19zImqg3PUgt8oX9kE/1sJzWPFT2
         RcImfmeZQ4fDZKpXcs5rrNjUjkC4GRYz2M8n9ExaKcUfT+1dNAn9O0bSNbplVP9UHsl2
         Ii3Q==
X-Gm-Message-State: ABy/qLaGESUUwe4s17WxxSvzc8huoysC3xenTFqWeuVpOoViyzAKbs6q
        eXdCIRPm+3ZryBoGMKJzGiVH0Iv2ehc=
X-Google-Smtp-Source: APBJJlFKrg3zrMVnT4y3lM3F/XIOZCnHovdC25gxGLpXATGcGi9mXUoOJGZ6EIElYox6qUlWKCmNIg==
X-Received: by 2002:a17:902:e550:b0:1b8:7e53:704 with SMTP id n16-20020a170902e55000b001b87e530704mr14859904plf.27.1689613960688;
        Mon, 17 Jul 2023 10:12:40 -0700 (PDT)
Received: from localhost ([192.55.54.50])
        by smtp.gmail.com with ESMTPSA id j17-20020a170902da9100b001b9d88a4d1asm112268plx.289.2023.07.17.10.12.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 17 Jul 2023 10:12:40 -0700 (PDT)
Date:   Mon, 17 Jul 2023 10:12:38 -0700
From:   Isaku Yamahata <isaku.yamahata@gmail.com>
To:     "Wen, Qian" <qian.wen@intel.com>
Cc:     isaku.yamahata@intel.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, isaku.yamahata@gmail.com,
        Paolo Bonzini <pbonzini@redhat.com>, erdemaktas@google.com,
        Sean Christopherson <seanjc@google.com>,
        Sagi Shahar <sagis@google.com>,
        David Matlack <dmatlack@google.com>,
        Kai Huang <kai.huang@intel.com>,
        Zhi Wang <zhi.wang.linux@gmail.com>, chen.bo@intel.com
Subject: Re: [PATCH v14 072/113] KVM: TDX: handle vcpu migration over logical
 processor
Message-ID: <20230717171238.GA25699@ls.amr.corp.intel.com>
References: <cover.1685333727.git.isaku.yamahata@intel.com>
 <7a57603a0668ec51a7ac324ab3d1a8acb9863e7b.1685333728.git.isaku.yamahata@intel.com>
 <48951fc1-4e98-b32a-af4f-343b7ea2d44d@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <48951fc1-4e98-b32a-af4f-343b7ea2d44d@intel.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Jul 12, 2023 at 02:08:15PM +0800,
"Wen, Qian" <qian.wen@intel.com> wrote:

> On 5/29/2023 12:19 PM, isaku.yamahata@intel.com wrote:
> > From: Isaku Yamahata <isaku.yamahata@intel.com>
> > 
> > For vcpu migration, in the case of VMX, VMCS is flushed on the source pcpu,
> > and load it on the target pcpu.  There are corresponding TDX SEAMCALL APIs,
> > call them on vcpu migration.  The logic is mostly same as VMX except the
> > TDX SEAMCALLs are used.
> > 
> > When shutting down the machine, (VMX or TDX) vcpus needs to be shutdown on
> > each pcpu.  Do the similar for TDX with TDX SEAMCALL APIs.
> > 
> > Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
> > ---
> >  arch/x86/kvm/vmx/main.c    |  32 ++++++-
> >  arch/x86/kvm/vmx/tdx.c     | 168 +++++++++++++++++++++++++++++++++++++
> >  arch/x86/kvm/vmx/tdx.h     |   2 +
> >  arch/x86/kvm/vmx/x86_ops.h |   4 +
> >  4 files changed, 203 insertions(+), 3 deletions(-)
> > 
> > diff --git a/arch/x86/kvm/vmx/main.c b/arch/x86/kvm/vmx/main.c
> > index 17fb1515e56a..29ebd171dbe3 100644
> 
> ...
> 
> > @@ -455,6 +606,19 @@ void tdx_vcpu_free(struct kvm_vcpu *vcpu)
> >  		return;
> >  	}
> >  
> > +	/*
> > +	 * kvm_free_vcpus()
> > +	 *   -> kvm_unload_vcpu_mmu()
> > +	 *
> > +	 * does vcpu_load() for every vcpu after they already disassociated
> > +	 * from the per cpu list when tdx_vm_teardown(). So we need to
> > +	 * disassociate them again, otherwise the freed vcpu data will be
> > +	 * accessed when do list_{del,add}() on associated_tdvcpus list
> > +	 * later.
> > +	 */
> 
> Nit: kvm_free_vcpus() and tdx_vm_teardown() are typos? I don't find these functions.

kvm_free_vcpus() => kvm_destroy_vcpus()
tdx_vm_teardown() => tdx_mmu_release_hkid()

Will fix the comment.
-- 
Isaku Yamahata <isaku.yamahata@gmail.com>
