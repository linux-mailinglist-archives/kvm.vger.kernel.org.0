Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5EA3A6CF7D3
	for <lists+kvm@lfdr.de>; Thu, 30 Mar 2023 01:56:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231302AbjC2X4j (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 29 Mar 2023 19:56:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56816 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229649AbjC2X4i (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 29 Mar 2023 19:56:38 -0400
Received: from mail-pg1-x529.google.com (mail-pg1-x529.google.com [IPv6:2607:f8b0:4864:20::529])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 649A859DA;
        Wed, 29 Mar 2023 16:56:37 -0700 (PDT)
Received: by mail-pg1-x529.google.com with SMTP id d8so10331730pgm.3;
        Wed, 29 Mar 2023 16:56:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1680134197;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=5We3k9UA49v5O3fyX9LJ8ISvv6lxMpEYgfyeu3RPTdw=;
        b=TJogS+i7Hup52eD4lclymJO8wexA4nvo15fSnj4DOfS4KX0tpIKIadJhRLuB6ZRG0a
         5DkfbzSLEeDv/jJmK5pZmaNJWZ/umlyh438nKK/riR/SwqRDlx0oZQNELDLV2syVG4BQ
         uBlbbVLtwp7EaLDpe2JNwimuZXn4kv+5B4NWqH8U1bIr4wkiV4O/FLfFqd8n1cxAA5bZ
         sRYUGIHJehZ1K8t5S6Cu+o2qUPbyx5rt1eMGScHG3SP60BYT/c2QgRXjTszBch/u8Yis
         fzAf999PMOddT+6Vs51YLaZeQf+zqkwyUGInAX0Q2jhLtZoZUDX69T999G2H3nm+PF/u
         tZxg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680134197;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=5We3k9UA49v5O3fyX9LJ8ISvv6lxMpEYgfyeu3RPTdw=;
        b=Gn0z81UnZ8W4x6qylzgSaZk0PvG722dOwJ/4qJ2srkddFOMCx6eVQ68jDXl4pUBTMG
         zrrgNV9+9I4tGEnp3vyopgcsjBuYFRK15PE7MxiLTbMjz40jQ/Pj7IU5UvVJlf9rk6hM
         ZNVRVlXW/xfau0q5Rn4Ta2Ndi+ISMH5qYx8mjqlIcXmKSX35JMLSeRjCqulSwklFOTi3
         gIeNvSqqMbnUtOchZ3OfQkNRaX6NU68YTq0MgHV7Oet8iauIQOynEhGAb/FNUrs9Rvkr
         f82reC5V1Hr/zAKG/skKUZRjw9VlBuUSSwXKhUpDkCRO6OJeEtzJWg1QZTeXvQw8OE0L
         /VXQ==
X-Gm-Message-State: AAQBX9eWRbWIveWUIObmz6U9jIjqmzj9Nh2SuKj7I7vT6H81Y+agArZv
        oG+zNjaNGBKjRuLpinqZ0O/tBPACDkw=
X-Google-Smtp-Source: AKy350abUW8wlAg+HfwnumJri20NeizgyBjSjdfHF+ZypoyjDOV2g5TUcnvmW4/Jz47cg+uqgX3ZkQ==
X-Received: by 2002:a62:63c2:0:b0:62d:8376:3712 with SMTP id x185-20020a6263c2000000b0062d83763712mr9450878pfb.28.1680134196727;
        Wed, 29 Mar 2023 16:56:36 -0700 (PDT)
Received: from localhost ([192.55.54.55])
        by smtp.gmail.com with ESMTPSA id d9-20020aa78e49000000b005cd81a74821sm19824926pfr.152.2023.03.29.16.56.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 29 Mar 2023 16:56:36 -0700 (PDT)
Date:   Wed, 29 Mar 2023 16:56:34 -0700
From:   Isaku Yamahata <isaku.yamahata@gmail.com>
To:     Xu Yilun <yilun.xu@intel.com>
Cc:     isaku.yamahata@intel.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, isaku.yamahata@gmail.com,
        Paolo Bonzini <pbonzini@redhat.com>, erdemaktas@google.com,
        Sean Christopherson <seanjc@google.com>,
        Sagi Shahar <sagis@google.com>,
        David Matlack <dmatlack@google.com>,
        Kai Huang <kai.huang@intel.com>,
        Zhi Wang <zhi.wang.linux@gmail.com>,
        Chao Gao <chao.gao@intel.com>
Subject: Re: [PATCH v13 039/113] KVM: x86/mmu: Assume guest MMIOs are shared
Message-ID: <20230329235634.GA1112017@ls.amr.corp.intel.com>
References: <cover.1678643051.git.isaku.yamahata@intel.com>
 <80912a430d4642acf85c454e97c8320f96e4b737.1678643052.git.isaku.yamahata@intel.com>
 <ZCJTUIJsaJDNjcPP@yilunxu-OptiPlex-7050>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <ZCJTUIJsaJDNjcPP@yilunxu-OptiPlex-7050>
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Mar 28, 2023 at 10:39:12AM +0800,
Xu Yilun <yilun.xu@intel.com> wrote:

> On 2023-03-12 at 10:56:03 -0700, isaku.yamahata@intel.com wrote:
> > From: Chao Gao <chao.gao@intel.com>
> > 
> > Current TD guest doesn't invoke MAP_GPA to convert MMIO range to shared
> > before accessing it. It implies that current TD guest assumes MMIOs are
> > shared.
> > 
> > When TD tries to access assigned device's MMIO as shared, an EPT violation
> 
> Seems the patch is dealing with emulated MMIO, not assigned device's MMIO.

That's right. Here I'm discussing about virtual device. Will drop "assigned"
word.


> > is raised first. kvm_mem_is_private() checks the page shared or private
> > attribute against the access type (shared bit in GPA). Then since no
> > MAP_GPA is called for the MMIO, KVM thinks the MMIO is private and refuses
> > shared access and doesn't set up shared EPT. Then KVM returns to TD and TD
> > just retries and this causes an infinite loop.
> > 
> > Instead of requiring guest to invoke MAP_GPA for MMIOs, assume guest MMIOs
> > are shared in KVM as well and don't expect explicit calls of MAP_GAP for
> > guest MMIOs (i.e., GPAs either have no kvm_memory_slot or are backed by
> > host MMIOs). So, allow shared access to guest MMIOs and move the page type
> > check after the corresponding pfn is available.
> 
> Didn't see the movement.
> 
> Seems the commit message needs update.

Will update.


> > Signed-off-by: Chao Gao <chao.gao@intel.com>
> > ---
> >  arch/x86/kvm/mmu/mmu.c | 7 ++++++-
> >  1 file changed, 6 insertions(+), 1 deletion(-)
> > 
> > diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> > index 5883ab95ff07..ce8a896a3cfa 100644
> > --- a/arch/x86/kvm/mmu/mmu.c
> > +++ b/arch/x86/kvm/mmu/mmu.c
> > @@ -4314,7 +4314,12 @@ static int __kvm_faultin_pfn(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault
> >  			return RET_PF_EMULATE;
> >  	}
> >  
> > -	if (fault->is_private != kvm_mem_is_private(vcpu->kvm, fault->gfn))
> > +	/*
> > +	 * !fault->slot means MMIO.  Don't require explicit GPA conversion for
> > +	 * MMIO because MMIO is assigned at the boot time.
> > +	 */
> > +	if (fault->slot &&
> 
> This only exempts emulated MMIO, how about the passthrough device's MMIO?

This patch is for virtual MMIO.  If physical device is assigned to shared
region, KVM memory slot is assigned.  EPT entry is setup to point to the HPA.
-- 
Isaku Yamahata <isaku.yamahata@gmail.com>
