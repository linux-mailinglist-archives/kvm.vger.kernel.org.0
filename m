Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BFB944C1AB4
	for <lists+kvm@lfdr.de>; Wed, 23 Feb 2022 19:13:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243789AbiBWSN6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 23 Feb 2022 13:13:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44346 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243783AbiBWSN4 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 23 Feb 2022 13:13:56 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3811348315;
        Wed, 23 Feb 2022 10:13:29 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C83DD61580;
        Wed, 23 Feb 2022 18:13:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 138E8C340E7;
        Wed, 23 Feb 2022 18:13:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1645640008;
        bh=puW8dgOC6u58SDIMkZaeJA/5QfThrRACFwNlmW5mRnU=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=So3I9zMvNKYHhpDsnpmxh7H1xHymIHJtd0I1kFTMKLG3PcYYnkVIOgEvEVbOJP7Gp
         7zsdrFI0DtUsX5Vu0KX5cNfb8+J9nqNgLa/fA9/IO3FR1CGfGLIqgGpFdb27XmczlL
         a4/hDIjCMJt0DptTo2hW+PEA7JGrZDCqo5triI9Q1kEoGiP0xQTdzXgd2IUkHOJ716
         ugklpcYNY4F9G2vPdoA0+/ud4Cpx8bJV9xF2VwoSjOn9LWLHUYB5SmHzmr8+AGvS/6
         LbVmtF+30SRWWojGh6bMk/8or0GQsjt6lZ7GfhFVN4cc+DkmD1MnlqZnFPw58zoxJL
         +iNR9hqLLePAA==
Date:   Wed, 23 Feb 2022 11:13:23 -0700
From:   Nathan Chancellor <nathan@kernel.org>
To:     Sean Christopherson <seanjc@google.com>
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
Message-ID: <YhZ5Q8DNoGGWUBLh@dev-arch.archlinux-ax161>
References: <20220223162355.3174907-1-seanjc@google.com>
 <YhZuk8eA6rsDuJkd@dev-arch.archlinux-ax161>
 <YhZ16cMMcHQIvS9d@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YhZ16cMMcHQIvS9d@google.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Feb 23, 2022 at 05:59:05PM +0000, Sean Christopherson wrote:
> On Wed, Feb 23, 2022, Nathan Chancellor wrote:
> > Hi Sean,
> > 
> > On Wed, Feb 23, 2022 at 04:23:55PM +0000, Sean Christopherson wrote:
> > > Cast kvm_x86_ops.func to 'void *' when updating KVM static calls that are
> > > conditionally patched to __static_call_return0().  clang complains about
> > > using mismatching pointers in the ternary operator, which breaks the
> > > build when compiling with CONFIG_KVM_WERROR=y.
> > > 
> > >   >> arch/x86/include/asm/kvm-x86-ops.h:82:1: warning: pointer type mismatch
> > >   ('bool (*)(struct kvm_vcpu *)' and 'void *') [-Wpointer-type-mismatch]
> > > 
> > > Fixes: 5be2226f417d ("KVM: x86: allow defining return-0 static calls")
> > > Reported-by: Like Xu <like.xu.linux@gmail.com>
> > > Reported-by: kernel test robot <lkp@intel.com>
> > > Signed-off-by: Sean Christopherson <seanjc@google.com>
> > 
> > Thank you for the patch! Is this a bug in clang?
> 
> IMO, no.  I think it's completely reasonable for the compiler to complain that KVM
> is generating two different pointer types out of a ternary operator.
> 
> clang is somewhat inconsistent, though it may be deliberate.  clang doesn't complain
> about implicitly casting a 'void *' to another data type, e.g. this complies clean,
> where "data" is a 'void *'
> 
> 	struct kvm_vcpu *x = vcpu ? : data;

Right, I would assume this is deliberate. I think warning in this case
might be quite noisy, as the kernel implicitly converts 'void *' to
typed pointers for certain function pointer callbacks (although this
particular case is probably pretty rare).

> But changing it to a function on the lhs triggers the warn:
> 
> 	typeof(kvm_x86_ops.vcpu_run) x = kvm_x86_ops.vcpu_run ? : data;
> 
> Again, complaining in the function pointer case seems reasonable.

Ack, thank you for the clarification and explanation!

Cheers,
Nathan
