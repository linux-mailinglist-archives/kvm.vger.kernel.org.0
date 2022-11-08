Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CFB3B621D24
	for <lists+kvm@lfdr.de>; Tue,  8 Nov 2022 20:44:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229638AbiKHToE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 8 Nov 2022 14:44:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43300 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229464AbiKHToB (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 8 Nov 2022 14:44:01 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D9BDB1F61D;
        Tue,  8 Nov 2022 11:44:00 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 473A061778;
        Tue,  8 Nov 2022 19:44:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3ABEEC433C1;
        Tue,  8 Nov 2022 19:43:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1667936639;
        bh=TDfsayD9ryRTKjmv0QhM0LrZ1U9kaiTGn71emQM6pQs=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=YHAHMJ2IkPUtqZ2sYM6jpbMgr73KvofUpOrvu5VF+KvBViIKE8xX/Bj5ppBFxQyGz
         qVHjK39G+6QLkA8Kn8tbX7PuznMbCo88naPNtrU8ZrFXz/xbd9I1AeNP5T0Zi+UrKx
         UbMMnKDQWJjFbwEpt4YxVzL/V7c2rdVFgN5Xf7QB8DwlfS8v/uyneyqhwrkXq2upFa
         4scOfvTod85bk1OYq+Ih6m99zPHu/BMO9NpF0Hgkhxdfm89LfZepELWLIzgXogMWMM
         9T2+JclwKyDY1pbAJhBUfD5xohxXU4GpD67Ec7DVN/qK8f+MjkPkth2WPSpbnj4lfw
         B9RvBeafIPq6w==
Date:   Tue, 8 Nov 2022 12:43:57 -0700
From:   Nathan Chancellor <nathan@kernel.org>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        thomas.lendacky@amd.com, andrew.cooper3@citrix.com,
        peterz@infradead.org, jmattson@google.com, seanjc@google.com
Subject: Re: [PATCH v2 0/8] KVM: SVM: fixes for vmentry code
Message-ID: <Y2qxfcHC6OgBdfl8@dev-arch.thelio-3990X>
References: <20221108151532.1377783-1-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221108151532.1377783-1-pbonzini@redhat.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Nov 08, 2022 at 10:15:24AM -0500, Paolo Bonzini wrote:
> This series comprises two related fixes:
> 
> - the FILL_RETURN_BUFFER macro in -next needs to access percpu data,
>   hence the GS segment base needs to be loaded before FILL_RETURN_BUFFER.
>   This means moving guest vmload/vmsave and host vmload to assembly
>   (patches 5 and 6).
> 
> - because AMD wants the OS to set STIBP to 1 before executing the
>   return thunk (un)training sequence, IA32_SPEC_CTRL must be restored
>   before UNTRAIN_RET, too.  This must also be moved to assembly and,
>   for consistency, the guest SPEC_CTRL is also loaded in there
>   (patch 7).
> 
> Neither is particularly hard, however because of 32-bit systems one needs
> to keep the number of arguments to __svm_vcpu_run to three or fewer.
> One is taken for whether IA32_SPEC_CTRL is intercepted, and one for the
> host save area, so all accesses to the vcpu_svm struct have to be done
> from assembly too.  This is done in patches 2 to 4, and it turns out
> not to be that bad; in fact I think the code is simpler than before
> after these prerequisites, and even at the end of the series it is not
> much harder to follow despite doing a lot more stuff.  Care has been
> taken to keep the "normal" and SEV-ES code as similar as possible,
> even though the latter would not hit the three argument barrier.
> 
> The above summary leaves out the more mundane patches 1 and 8.  The
> former introduces a separate asm-offsets.c file for KVM, so that
> kernel/asm-offsets.c does not have to do ugly includes with ../ paths.
> The latter is dead code removal.
> 
> Thanks,
> 
> Paolo
> 
> v1->v2: use a separate asm-offsets.c file instead of hacking around
> 	the arch/x86/kvm/svm/svm.h file; this could have been done
> 	also with just a "#ifndef COMPILE_OFFSETS", but Sean's
> 	suggestion is cleaner and there is a precedent in
> 	drivers/memory/ for private asm-offsets files
> 
> 	keep preparatory cleanups together at the beginning of the
> 	series
> 
> 	move SPEC_CTRL save/restore out of line [Jim]
> 
> Paolo Bonzini (8):
>   KVM: x86: use a separate asm-offsets.c file
>   KVM: SVM: replace regs argument of __svm_vcpu_run with vcpu_svm
>   KVM: SVM: adjust register allocation for __svm_vcpu_run
>   KVM: SVM: retrieve VMCB from assembly
>   KVM: SVM: move guest vmsave/vmload to assembly
>   KVM: SVM: restore host save area from assembly
>   KVM: SVM: move MSR_IA32_SPEC_CTRL save/restore to assembly
>   x86, KVM: remove unnecessary argument to x86_virt_spec_ctrl and
>     callers
> 
>  arch/x86/include/asm/spec-ctrl.h |  10 +-
>  arch/x86/kernel/asm-offsets.c    |   6 -
>  arch/x86/kernel/cpu/bugs.c       |  15 +-
>  arch/x86/kvm/Makefile            |  12 ++
>  arch/x86/kvm/kvm-asm-offsets.c   |  28 ++++
>  arch/x86/kvm/svm/svm.c           |  53 +++----
>  arch/x86/kvm/svm/svm.h           |   4 +-
>  arch/x86/kvm/svm/svm_ops.h       |   5 -
>  arch/x86/kvm/svm/vmenter.S       | 241 ++++++++++++++++++++++++-------
>  arch/x86/kvm/vmx/vmenter.S       |   2 +-
>  10 files changed, 259 insertions(+), 117 deletions(-)
>  create mode 100644 arch/x86/kvm/kvm-asm-offsets.c
> 
> -- 
> 2.31.1
> 
> 

I applied this series on next-20221108, which has the call depth
tracking patches, and I no longer see the panic when starting a guest on
my AMD test system and I can still start a simple nested guest without
any problems, which is about the extent of my regular KVM testing.  I
did test the same kernel on my Intel systems and saw no problems there
but that seems expected given the diffstat. Thank you for the quick
response and fixes!

Tested-by: Nathan Chancellor <nathan@kernel.org>

One small nit I noticed: kvm-asm-offsets.h should be added to a
.gitignore file in arch/x86/kvm.

$ git status --short
?? arch/x86/kvm/kvm-asm-offsets.h

Cheers,
Nathan
