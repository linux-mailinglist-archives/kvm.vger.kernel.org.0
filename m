Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B6B2B4F8B0F
	for <lists+kvm@lfdr.de>; Fri,  8 Apr 2022 02:56:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233019AbiDHAql (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 7 Apr 2022 20:46:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50700 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233008AbiDHAqh (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 7 Apr 2022 20:46:37 -0400
Received: from mail-pg1-x533.google.com (mail-pg1-x533.google.com [IPv6:2607:f8b0:4864:20::533])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 22B0960CDE;
        Thu,  7 Apr 2022 17:44:33 -0700 (PDT)
Received: by mail-pg1-x533.google.com with SMTP id t4so6421091pgc.1;
        Thu, 07 Apr 2022 17:44:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=Bv8b36R/JYSKrjInAZ8YiQDmdZkHb/0Vx7ZZQr7wN9w=;
        b=FE1F7tzli7WL4l6VnR9bc1kj3unM1hEzEe5CcNlNniQoTJ3l7dkFGNALbE6fDfdSmR
         qIVvhWuUX0Gw9cZ/w39gB1PlsdSLotrdHuqacckLzHVspgRA5kanxLLTLuM9kbliDdGk
         6+0178qjHV0v1np3ML8om1zdnMOZeMKU7gPCT9pgYgV5pEQm0tRBmRzkCjBRGjHxx3q/
         1ZUv8aXuwGJsnNx9YyXheL8cBwuzY+HPYL8rNEKcgncv0pMo5Il4TdeuLm2vVo1ie2Wd
         QP9lrEUC5ARQ3lwecQ/Tf4sSkI9wc7GFQEIPusF9Qcq1CUSUiyF6mXyQRH9eTp99/V/V
         h0ew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=Bv8b36R/JYSKrjInAZ8YiQDmdZkHb/0Vx7ZZQr7wN9w=;
        b=yaGulZh7P5cFIKTRsmo74dC/LSRrGkQya8EmzTyJPXBeLVaQTGySRFlb5FAOX8Lf/e
         ZC7yokKm7QORAal+BYvxSPcMwKIT3xkbDwKuJ1eXtg2KxsqbeRlGB7rYqLpyHjmj8bwN
         R+V6RdxreNQy/+hhtFkWDBevvV5aGizzvgFz75J9+2G+Z/yQKW8se7uCax+oiVUO7047
         s6xzEsjRUSrS35ANmLx+FrRHmQUwBstIaRFi4zydVbSSyWX23+wp68yi/xF5XUCH6nAF
         s1wUZmrnnF/dp0diLTWwrbj9hSnShY1lUDhag84VEcGoeab8d216ktHID6ZGhJkLROS2
         4CpA==
X-Gm-Message-State: AOAM531V1i8JvmHOjH44rKuJHLs5gBINoV+3+ckiVsvaJzM1fh9dYRFr
        geqmuY9o9qeCNKt7nOUbZaY=
X-Google-Smtp-Source: ABdhPJz7h2A2pWT1bc5EVaRDjDNCRUYUrXBytPNhRjGEVbo3bQ8+vgVkv4w5hKuKp4PWLiRsDCkcuw==
X-Received: by 2002:a05:6a00:2484:b0:4fa:997e:3290 with SMTP id c4-20020a056a00248400b004fa997e3290mr16810645pfv.37.1649378672571;
        Thu, 07 Apr 2022 17:44:32 -0700 (PDT)
Received: from localhost ([192.55.54.52])
        by smtp.gmail.com with ESMTPSA id oa16-20020a17090b1bd000b001c72b632222sm10335976pjb.32.2022.04.07.17.44.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 07 Apr 2022 17:44:32 -0700 (PDT)
Date:   Thu, 7 Apr 2022 17:44:29 -0700
From:   Isaku Yamahata <isaku.yamahata@gmail.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     isaku.yamahata@intel.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, isaku.yamahata@gmail.com,
        Jim Mattson <jmattson@google.com>, erdemaktas@google.com,
        Connor Kuehl <ckuehl@redhat.com>,
        Sean Christopherson <seanjc@google.com>
Subject: Re: [RFC PATCH v5 020/104] KVM: TDX: allocate per-package mutex
Message-ID: <20220408004429.GA2864606@ls.amr.corp.intel.com>
References: <cover.1646422845.git.isaku.yamahata@intel.com>
 <f7b44d1d5a61f788294c399b63b505b3ff4d301b.1646422845.git.isaku.yamahata@intel.com>
 <25257849-8e1a-17ff-5008-bb2d1efecf80@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <25257849-8e1a-17ff-5008-bb2d1efecf80@redhat.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Apr 05, 2022 at 02:39:51PM +0200,
Paolo Bonzini <pbonzini@redhat.com> wrote:

> On 3/4/22 20:48, isaku.yamahata@intel.com wrote:
> > From: Isaku Yamahata <isaku.yamahata@intel.com>
> > 
> > Several TDX SEAMCALLs are per-package scope (concretely per memory
> > controller) and they need to be serialized per-package.  Allocate mutex for
> > it.
> > 
> > Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
> > ---
> >   arch/x86/kvm/vmx/main.c    |  8 +++++++-
> >   arch/x86/kvm/vmx/tdx.c     | 18 ++++++++++++++++++
> >   arch/x86/kvm/vmx/x86_ops.h |  2 ++
> >   3 files changed, 27 insertions(+), 1 deletion(-)
> 
> Please define here the lock/unlock functions as well:
> 
> static inline int tdx_mng_key_lock(void)
> {
> 	int cpu = get_cpu();
> 	cur_pkg = topology_physical_package_id(cpu);
> 
> 	mutex_lock(&tdx_mng_key_config_lock[cur_pkg]);
> 	return cur_pkg;
> }
> 
> static inline void tdx_mng_key_unlock(int cur_pkg)
> {
> 	mutex_unlock(&tdx_mng_key_config_lock[cur_pkg]);
> 	put_cpu();
> }

Sure, will do in the next respoin.
-- 
Isaku Yamahata <isaku.yamahata@gmail.com>
