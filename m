Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 32CF34F9CEC
	for <lists+kvm@lfdr.de>; Fri,  8 Apr 2022 20:39:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238902AbiDHSlB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 8 Apr 2022 14:41:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44588 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238878AbiDHSky (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 8 Apr 2022 14:40:54 -0400
Received: from mail-pg1-x536.google.com (mail-pg1-x536.google.com [IPv6:2607:f8b0:4864:20::536])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0EB4476585;
        Fri,  8 Apr 2022 11:38:50 -0700 (PDT)
Received: by mail-pg1-x536.google.com with SMTP id q142so8441669pgq.9;
        Fri, 08 Apr 2022 11:38:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=kKGKZuSpYFN37tCG4CcIHU7+d9wEn83BskzEwQsLfrQ=;
        b=Zbwlo1H8+ZlJmoZIVtHazGl96gDb2dUENvySNvgZVl3hDqaWhmJ1EH8DQKQ1MrNJDh
         eQqd3G4XgU91qDmn6YYM40TmLk/S8HuH3SUn3HzUKWjOZka2JJE9o9TJF+mjHkFUkEpj
         IdUdamR8NT05UTdpzWsm6rPeiHZ5ko2503qAcBe2FsiwX/sQ/GDSOfEWTyoErCQ1Jzuo
         fwXfvgUEiBssi2PcKS9qJ8a7HeKn+bF/K8aa6f5ZAsmEo87k+k/Q9DUr7f1gv6N8I9ZA
         3bMp11ysXwIGBfLdE0acU0DZNpqo7ybMf+EAxb1JCWQTQzbqtf/LPudj+Rn090MHbsgE
         UyNA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=kKGKZuSpYFN37tCG4CcIHU7+d9wEn83BskzEwQsLfrQ=;
        b=S6RMs0EE8ceeAUkQlOFlJ/944PRnd7fnJQfYhbIOJbNRmUaPLDatBWoVLKXYyG3nL/
         xQEYyZsmzHYx69clYMquphWBOuCYgUNbNRe0X4dEJnYik/hfZu4nh7QRj95pzP2nk5KA
         OjSIi1G/x/xm740sei1vDPQksetV3vify1DVVzlx35hrlULMg85ZEOhHSnWvKVNwiKF5
         X1QjuEgxiGYyZVMBLENSax8ydPJnClUjoQwh+dASTVWBT9liV7Visdcgoum2AdtIrqx2
         8Xkpip5vNb4r8gMNGX+BiThzP8H5n7oCJ5NFAmxAYWqIyNJztO/FxdaimrTRyeDv2biI
         fLMg==
X-Gm-Message-State: AOAM532IHE+DC/vc13XfQ/hfLT4aEosnOS/m2CtljSNjSXXErZBrGQ+m
        pX4IvV2VYo8DoWfRYBNh2wA=
X-Google-Smtp-Source: ABdhPJwWvCeq1v7/DCTMwPxRS6kD3AmeHD9zIlblaKqiKk633UzIAN1sJuKreKzCS8m9MU15WnKISw==
X-Received: by 2002:a63:6a0a:0:b0:398:6fb4:33c2 with SMTP id f10-20020a636a0a000000b003986fb433c2mr16900822pgc.151.1649443129394;
        Fri, 08 Apr 2022 11:38:49 -0700 (PDT)
Received: from localhost ([192.55.54.52])
        by smtp.gmail.com with ESMTPSA id e11-20020a056a001a8b00b004fab740dbddsm27094392pfv.105.2022.04.08.11.38.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 08 Apr 2022 11:38:48 -0700 (PDT)
Date:   Fri, 8 Apr 2022 11:38:47 -0700
From:   Isaku Yamahata <isaku.yamahata@gmail.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Kai Huang <kai.huang@intel.com>, isaku.yamahata@intel.com,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        isaku.yamahata@gmail.com, Jim Mattson <jmattson@google.com>,
        erdemaktas@google.com, Connor Kuehl <ckuehl@redhat.com>,
        Sean Christopherson <seanjc@google.com>
Subject: Re: [RFC PATCH v5 037/104] KVM: x86/mmu: Allow non-zero init value
 for shadow PTE
Message-ID: <20220408183847.GB857847@ls.amr.corp.intel.com>
References: <cover.1646422845.git.isaku.yamahata@intel.com>
 <b74b3660f9d16deafe83f2670539a8287bef988f.1646422845.git.isaku.yamahata@intel.com>
 <968de4765e63d8255ae1b3ac7062ffdca64706e4.camel@intel.com>
 <3cfffe9a29e53ae58dc59d0af3d52128babde79f.camel@intel.com>
 <1474e665-c619-1a01-3a28-51894161e316@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1474e665-c619-1a01-3a28-51894161e316@redhat.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Apr 05, 2022 at 04:14:25PM +0200,
Paolo Bonzini <pbonzini@redhat.com> wrote:

> On 4/1/22 09:13, Kai Huang wrote:
> > Btw, I think the relevant part of TDP MMU change should be included in this
> > patch too otherwise TDP MMU is broken with this patch.
> 
> I agree.
> 
> Paolo
> 
> > Actually in this series legacy MMU is not supported to work with TDX, so above
> > change to legacy MMU doesn't matter actually.  Instead, TDP MMU change should be
> > here.

Sure, will reorganize it in the next respin.
-- 
Isaku Yamahata <isaku.yamahata@gmail.com>
