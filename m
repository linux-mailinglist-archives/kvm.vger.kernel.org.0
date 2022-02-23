Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CE7774C1B3B
	for <lists+kvm@lfdr.de>; Wed, 23 Feb 2022 19:56:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244074AbiBWS5D (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 23 Feb 2022 13:57:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42632 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244068AbiBWS5C (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 23 Feb 2022 13:57:02 -0500
Received: from mail-pf1-x42b.google.com (mail-pf1-x42b.google.com [IPv6:2607:f8b0:4864:20::42b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D242638AB
        for <kvm@vger.kernel.org>; Wed, 23 Feb 2022 10:56:33 -0800 (PST)
Received: by mail-pf1-x42b.google.com with SMTP id p8so16240556pfh.8
        for <kvm@vger.kernel.org>; Wed, 23 Feb 2022 10:56:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=WO10LZXV2/UIWFExeWc5y4Axog2LtDZPkQsLOSvWfIQ=;
        b=D8TkVS0SFNlR75Wec0ztTxmXYaKBMsKoUqb/Nhs2hNUiK/oaDz71s6bWwqHwBV1Wjz
         cslgksXqAs492hjk4W5fOe6HJmIx2jOGr42dklLADLnuAj6O7rlxzR4je1EbsPrOP8wk
         weGsjLeFnSuR/7vT+UaNHlsfv8241RQA0ZB5g3tenBZ3jhcHWHEPO1lvjP6HPgoGmptr
         iscT1tlwsb64dhL/wSDAaCJ/0x3uLXRTToo1xd1dpg2OSIUJMis8ITDrAWCTvY2C72SG
         xThZMVdYqHwxBZkQnHbX5lJxFn9v35CY9ZtkqKIMMIPzO/6GSf6aJeMr/VWZ4lkhrzKF
         +BNg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=WO10LZXV2/UIWFExeWc5y4Axog2LtDZPkQsLOSvWfIQ=;
        b=uCmI0rG0EOqqKAFqWSEgP2CTMvPKLVElalJme815W1n2tSU7iw5wkM8gsKHuZe9BEE
         QhtJ1YvvX4k6jr74Ti2+/kahokNuxxGwSDDsNGVkBYX8Sw+Oo2GJWZkkf6fMk0VwUar7
         ThNZrNHF6wNQlirNmk35uj5PtEj83a0M40pgoPWMrEHvZI3CBggof6kzrNA2HZA0C05f
         OhsxZVkMiiBh5C456qeCegG2llnWHYdx1/WVkOx4l1EZRrHfuKlDL1LilUiP+ITtjO3I
         A6Dd8ktbKjTaHnZbZICP/wkB0BzKHh0e8qWgSxRov2LXvDkFjct/gmHDaZWJ1fN68DuB
         M+dQ==
X-Gm-Message-State: AOAM532lcMMiVQNygrxI1h3rpUkoacVNUrnHTlhzlZIslZ5FBmtZjyoS
        HgeK1Slp8TBXdlGawRdB3vLGzA==
X-Google-Smtp-Source: ABdhPJxWzseRIGwjKlr0g3XO7WPLxpsY657PyUA0i4zsqM9a8QWHzQK5Zdw5cIoRSvIs8eDmqn0I2g==
X-Received: by 2002:a63:31ce:0:b0:34e:4052:1bce with SMTP id x197-20020a6331ce000000b0034e40521bcemr735240pgx.459.1645642592668;
        Wed, 23 Feb 2022 10:56:32 -0800 (PST)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id i11sm231887pgs.58.2022.02.23.10.56.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 23 Feb 2022 10:56:31 -0800 (PST)
Date:   Wed, 23 Feb 2022 18:56:28 +0000
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
Message-ID: <YhaDXDfLBQtkmbtV@google.com>
References: <20220223162355.3174907-1-seanjc@google.com>
 <YhZuk8eA6rsDuJkd@dev-arch.archlinux-ax161>
 <YhZ16cMMcHQIvS9d@google.com>
 <YhZ5Q8DNoGGWUBLh@dev-arch.archlinux-ax161>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <YhZ5Q8DNoGGWUBLh@dev-arch.archlinux-ax161>
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
> On Wed, Feb 23, 2022 at 05:59:05PM +0000, Sean Christopherson wrote:
> > On Wed, Feb 23, 2022, Nathan Chancellor wrote:
> > > Hi Sean,
> > > 
> > > On Wed, Feb 23, 2022 at 04:23:55PM +0000, Sean Christopherson wrote:
> > > > Cast kvm_x86_ops.func to 'void *' when updating KVM static calls that are
> > > > conditionally patched to __static_call_return0().  clang complains about
> > > > using mismatching pointers in the ternary operator, which breaks the
> > > > build when compiling with CONFIG_KVM_WERROR=y.
> > > > 
> > > >   >> arch/x86/include/asm/kvm-x86-ops.h:82:1: warning: pointer type mismatch
> > > >   ('bool (*)(struct kvm_vcpu *)' and 'void *') [-Wpointer-type-mismatch]
> > > > 
> > > > Fixes: 5be2226f417d ("KVM: x86: allow defining return-0 static calls")
> > > > Reported-by: Like Xu <like.xu.linux@gmail.com>
> > > > Reported-by: kernel test robot <lkp@intel.com>
> > > > Signed-off-by: Sean Christopherson <seanjc@google.com>
> > > 
> > > Thank you for the patch! Is this a bug in clang?
> > 
> > IMO, no.  I think it's completely reasonable for the compiler to complain that KVM
> > is generating two different pointer types out of a ternary operator.
> > 
> > clang is somewhat inconsistent, though it may be deliberate.  clang doesn't complain
> > about implicitly casting a 'void *' to another data type, e.g. this complies clean,
> > where "data" is a 'void *'
> > 
> > 	struct kvm_vcpu *x = vcpu ? : data;
> 
> Right, I would assume this is deliberate. I think warning in this case
> might be quite noisy, as the kernel implicitly converts 'void *' to
> typed pointers for certain function pointer callbacks (although this
> particular case is probably pretty rare).

Aha!  Looks like clang's behavior is correct, assuming a function is not considered
an "object".  From C99 "6.5.15 Conditional operator":

  One of the following shall hold for the second and third operands:
    — both operands have arithmetic type;
    — both operands have the same structure or union type;
    — both operands have void type;
    — both operands are pointers to qualified or unqualified versions of compatible types;
    — one operand is a pointer and the other is a null pointer constant; or
    — one operand is a pointer to an object or incomplete type and the other is a pointer to a
      qualified or unqualified version of void.

That last case would explain why clang warns about a function pointer but not a
object pointer when the third operand is a 'void *'.
