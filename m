Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 86DF54C1A5B
	for <lists+kvm@lfdr.de>; Wed, 23 Feb 2022 18:59:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243647AbiBWR7m (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 23 Feb 2022 12:59:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54600 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233876AbiBWR7i (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 23 Feb 2022 12:59:38 -0500
Received: from mail-pf1-x434.google.com (mail-pf1-x434.google.com [IPv6:2607:f8b0:4864:20::434])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 071FC3DA6F
        for <kvm@vger.kernel.org>; Wed, 23 Feb 2022 09:59:11 -0800 (PST)
Received: by mail-pf1-x434.google.com with SMTP id d17so16115399pfl.0
        for <kvm@vger.kernel.org>; Wed, 23 Feb 2022 09:59:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=i9ZmGUIwkyC7vjnII3cOeTZiB9a3MACRa2J9UXGI/ow=;
        b=XJHhTu/IhJCZ37/XrmsRBgCMoxE7LQi7Lo2Wi2s9PrXp0NKXlVd6zNTxZYdlTEDAqx
         L/j6e0Yamrbm7MLR3xgUc3Lw2+IT950x0WmnqU5OXUM//6aHcMBdwkA7rIK6YFT0JUhc
         sZvfycmuBlW+7vxVI4IDjx+/5a+Tmn8tspepbIAylqOg5aUfL+ulyJwBswjF0ItOtVKO
         97WUPmaUab1x3mwDYSGjTBxch3l8b3hxugErDO2pW1LUwJTeMVzMA6djZdYgR5ys3I6O
         QnwB+tBGJWUDAijMLK5HnyZoR8nHcsOuSTEBguK42TJ00sTtcT0wbBla4qArjLsIo/nN
         0v+g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=i9ZmGUIwkyC7vjnII3cOeTZiB9a3MACRa2J9UXGI/ow=;
        b=fgrCi5szHrmU6L1zR4DhpDse7ulHC8cUuTNO604aNm37Jv/f/T5xYZZpIwlN0hWuRh
         8PY8lTDvPDvknr7bJM6cT35KEDQ5ky7DFoMJ8sfU92/nO/ND8pFoqNRUC9VNC/xLgnVY
         iBlRXyajROSUF7QcmRmMN5HFbtpEwCyjSUV3CtFLq9ybptj3+MecY6GGkUFP/FFG3R0W
         RZJingh63jQReszAa071j1O9jOVm60svbfHx63m2qda907JjbSY7gqWeqOLz379RejtO
         METw2aBeXMa6MBPOYh2LNQX73VYI6x69Ehj8XK2C/8/d0hToJ2zEJzkisapZ/oQayeK0
         NBGA==
X-Gm-Message-State: AOAM530Vp1eiwvAyI2osZ1kP0Q0ClzPhWgXu6enA6lvLtApz/KcbV5HU
        YyTb2RGPWRQoUxCoqKCDMnEvzg==
X-Google-Smtp-Source: ABdhPJyWY8cS3LAxq9EqCzdtTUyda9OxIuVZO+b/1nALlGyO7RfH+5KzoRu/A7B8I7ghZ74CG6Bi7Q==
X-Received: by 2002:a05:6a00:174e:b0:4e1:7cfb:7a26 with SMTP id j14-20020a056a00174e00b004e17cfb7a26mr928875pfc.50.1645639150179;
        Wed, 23 Feb 2022 09:59:10 -0800 (PST)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id h27sm170144pgb.20.2022.02.23.09.59.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 23 Feb 2022 09:59:09 -0800 (PST)
Date:   Wed, 23 Feb 2022 17:59:05 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Nathan Chancellor <nathan@kernel.org>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Nick Desaulniers <ndesaulniers@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        llvm@lists.linux.dev, linux-kernel@vger.kernel.org,
        Like Xu <like.xu.linux@gmail.com>
Subject: Re: [PATCH] KVM: x86: Fix pointer mistmatch warning when patching
 RET0 static calls
Message-ID: <YhZ16cMMcHQIvS9d@google.com>
References: <20220223162355.3174907-1-seanjc@google.com>
 <YhZuk8eA6rsDuJkd@dev-arch.archlinux-ax161>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YhZuk8eA6rsDuJkd@dev-arch.archlinux-ax161>
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Feb 23, 2022, Nathan Chancellor wrote:
> Hi Sean,
> 
> On Wed, Feb 23, 2022 at 04:23:55PM +0000, Sean Christopherson wrote:
> > Cast kvm_x86_ops.func to 'void *' when updating KVM static calls that are
> > conditionally patched to __static_call_return0().  clang complains about
> > using mismatching pointers in the ternary operator, which breaks the
> > build when compiling with CONFIG_KVM_WERROR=y.
> > 
> >   >> arch/x86/include/asm/kvm-x86-ops.h:82:1: warning: pointer type mismatch
> >   ('bool (*)(struct kvm_vcpu *)' and 'void *') [-Wpointer-type-mismatch]
> > 
> > Fixes: 5be2226f417d ("KVM: x86: allow defining return-0 static calls")
> > Reported-by: Like Xu <like.xu.linux@gmail.com>
> > Reported-by: kernel test robot <lkp@intel.com>
> > Signed-off-by: Sean Christopherson <seanjc@google.com>
> 
> Thank you for the patch! Is this a bug in clang?

IMO, no.  I think it's completely reasonable for the compiler to complain that KVM
is generating two different pointer types out of a ternary operator.

clang is somewhat inconsistent, though it may be deliberate.  clang doesn't complain
about implicitly casting a 'void *' to another data type, e.g. this complies clean,
where "data" is a 'void *'

	struct kvm_vcpu *x = vcpu ? : data;

But changing it to a function on the lhs triggers the warn:

	typeof(kvm_x86_ops.vcpu_run) x = kvm_x86_ops.vcpu_run ? : data;

Again, complaining in the function pointer case seems reasonable.
