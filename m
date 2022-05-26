Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5C48253518E
	for <lists+kvm@lfdr.de>; Thu, 26 May 2022 17:40:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345831AbiEZPkG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 26 May 2022 11:40:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45694 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347993AbiEZPj5 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 26 May 2022 11:39:57 -0400
Received: from mail-pl1-x62e.google.com (mail-pl1-x62e.google.com [IPv6:2607:f8b0:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 65D73C1EE4
        for <kvm@vger.kernel.org>; Thu, 26 May 2022 08:39:56 -0700 (PDT)
Received: by mail-pl1-x62e.google.com with SMTP id f18so1783109plg.0
        for <kvm@vger.kernel.org>; Thu, 26 May 2022 08:39:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=xyEiDgKsY1emWGoi/u6fO/EWbKTt6KbucfscPebyqB8=;
        b=Y5RsMyw7KbhCAFTkVbgxzBS/Gx1QP7m4QuuHPAC5fDZtZXnZzXq+9Nfx5rwzpir4nN
         JF9OBoKEJce9x03tfK6d8wVZcZs4O/eIUO1mUwclsPoQkWrqL+nADVvhefmqS1cdG8zR
         tXkSYhNpSP3aL72C+UgrgvDE5t0bexRKdRPH8=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=xyEiDgKsY1emWGoi/u6fO/EWbKTt6KbucfscPebyqB8=;
        b=3GDAQRd2g533f+s5E5Co2GvYLIhKiIPTeRijT58//fg50bxzDpxVXbzTHAvSx0dULj
         05HW7uVjO5o7bUPs+iXNGJDRLSphzS2xFBgkxYKqboOG/sNhAeNDwM/bnfdG8o8Oqh71
         tCW6w0ZWwftPOZByydUpCrqJJl/TehT2xLPwne4o+dMdSdxFjYT6wKrKZ7yHXpL8ylWO
         m1EPpYZcwdZFBGlmNFxc424JOCccLZsz5nKoXV8A9yrBkzlDVzRUydNL9v6Sw0VKjO8D
         5Qd4TZQoT147PctMi4WLXhd75IJPw1mZSth4nzePIgoFl2n5J5wZY7DmNdKAgWkW7ENS
         vLHA==
X-Gm-Message-State: AOAM533crk4qeQMDuIA4EfQZqYbH0K5xC3wLYcJ09eIH5mQy80M93plW
        ut9lFJb1BDVGZJ4KfbevtIFp5A==
X-Google-Smtp-Source: ABdhPJxQs1ACMjRnyzEXIdVpbdckj+t/do563ysPM0bTSfDEme9mmYKy5pPg8nua7Nz4fL95vX4Gkw==
X-Received: by 2002:a17:90b:1482:b0:1df:5b39:8a4 with SMTP id js2-20020a17090b148200b001df5b3908a4mr3249753pjb.233.1653579595775;
        Thu, 26 May 2022 08:39:55 -0700 (PDT)
Received: from www.outflux.net (smtp.outflux.net. [198.145.64.163])
        by smtp.gmail.com with ESMTPSA id m20-20020a17090a859400b001d952b8f728sm3860113pjn.2.2022.05.26.08.39.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 26 May 2022 08:39:54 -0700 (PDT)
Date:   Thu, 26 May 2022 08:39:52 -0700
From:   Kees Cook <keescook@chromium.org>
To:     Sean Christopherson <seanjc@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Robert Dinse <nanook@eskimo.com>
Subject: Re: [PATCH 2/4] KVM: x86: Harden _regs accesses to guard against
 buggy input
Message-ID: <202205260835.9BC23703@keescook>
References: <20220525222604.2810054-1-seanjc@google.com>
 <20220525222604.2810054-3-seanjc@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220525222604.2810054-3-seanjc@google.com>
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, May 25, 2022 at 10:26:02PM +0000, Sean Christopherson wrote:
> WARN and truncate the incoming GPR number/index when reading/writing GPRs
> in the emulator to guard against KVM bugs, e.g. to avoid out-of-bounds
> accesses to ctxt->_regs[] if KVM generates a bogus index.  Truncate the
> index instead of returning e.g. zero, as reg_write() returns a pointer
> to the register, i.e. returning zero would result in a NULL pointer
> dereference.  KVM could also force the index to any arbitrary GPR, but
> that's no better or worse, just different.
> 
> Open code the restriction to 16 registers; RIP is handled via _eip and
> should never be accessed through reg_read() or reg_write().  See the
> comments above the declarations of reg_read() and reg_write(), and the
> behavior of writeback_registers().  The horrific open coded mess will be
> cleaned up in a future commit.
> 
> There are no such bugs known to exist in the emulator, but determining
> that KVM is bug-free is not at all simple and requires a deep dive into
> the emulator.  The code is so convoluted that GCC-12 with the recently
> enable -Warray-bounds spits out a (suspected) false-positive:
> 
>   arch/x86/kvm/emulate.c:254:27: warning: array subscript 32 is above array
>                                  bounds of 'long unsigned int[17]' [-Warray-bounds]

I can confirm this is one of the instances of the now-isolated GCC 12
bug:
https://gcc.gnu.org/bugzilla/show_bug.cgi?id=105679

Regardless, I think the cleanup is still useful from a robustness
perspective.  Better to be as defensive as possible in KVM. :)

>     254 |         return ctxt->_regs[nr];
>         |                ~~~~~~~~~~~^~~~
>   In file included from arch/x86/kvm/emulate.c:23:
>   arch/x86/kvm/kvm_emulate.h: In function 'reg_rmw':
>   arch/x86/kvm/kvm_emulate.h:366:23: note: while referencing '_regs'
>     366 |         unsigned long _regs[NR_VCPU_REGS];
>         |                       ^~~~~
> 
> Link: https://lore.kernel.org/all/YofQlBrlx18J7h9Y@google.com
> Cc: Robert Dinse <nanook@eskimo.com>
> Cc: Kees Cook <keescook@chromium.org>
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>  arch/x86/kvm/emulate.c | 6 ++++++
>  1 file changed, 6 insertions(+)
> 
> diff --git a/arch/x86/kvm/emulate.c b/arch/x86/kvm/emulate.c
> index 7226a127ccb4..c58366ae4da2 100644
> --- a/arch/x86/kvm/emulate.c
> +++ b/arch/x86/kvm/emulate.c
> @@ -247,6 +247,9 @@ enum x86_transfer_type {
>  
>  static ulong reg_read(struct x86_emulate_ctxt *ctxt, unsigned nr)
>  {
> +	if (WARN_ON_ONCE(nr >= 16))
> +		nr &= 16 - 1;

Instead of doing a modulo here, what about forcing it into an "unused"
slot?

i.e. define _regs as an array of [16 + 1], and:

	if (WARN_ON_ONCE(nr >= 16)
		nr = 16;

Then there is both no out-of-bounds access, but also no weird "actual"
register indexed?

-Kees

-- 
Kees Cook
