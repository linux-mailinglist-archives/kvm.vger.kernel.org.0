Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2EE6A77D670
	for <lists+kvm@lfdr.de>; Wed, 16 Aug 2023 00:52:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240482AbjHOWwA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 15 Aug 2023 18:52:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43794 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240510AbjHOWvm (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 15 Aug 2023 18:51:42 -0400
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 791A62102
        for <kvm@vger.kernel.org>; Tue, 15 Aug 2023 15:51:38 -0700 (PDT)
Received: by mail-yb1-xb49.google.com with SMTP id 3f1490d57ef6-c8f360a07a2so4782435276.2
        for <kvm@vger.kernel.org>; Tue, 15 Aug 2023 15:51:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1692139897; x=1692744697;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=da5x2zPjHUkqaS3Zbb7k562EOODEMFwJRzvV+YQcZfo=;
        b=0RL0HKMCJSssEhetdjMpcQhOROKUNlGm5oBzIslOioGrgb5unKYFihVgtIhvZHyCFi
         3PdrTWwlqWLXiWll0UJeNJZ67ynprulz4rmIVgQeUxziRNDApsBD0JIZgMG2fdkmXg3+
         PxxDF7RrYhr82+cune2T6CIpQ8xgKaLJXcuBTXk04U/A/tAaijlMXO5C8CS+6xy/hyMA
         yGjpvSZGr0nCXGG8k02ZlwDW/1WKCKaAdlTorHyVMgGjrBKd1HMljXm6kjCWnA1atTv2
         p0Asp0ziKPaifFVdrCqXgjkCdKj6t453GXPK+I9ycLuHuNpyR5LlZp/wsR6F+b8B2Trh
         ok3w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1692139897; x=1692744697;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=da5x2zPjHUkqaS3Zbb7k562EOODEMFwJRzvV+YQcZfo=;
        b=cAS3EH7lpv1nbKapOqqZjZ50tX3jmHi+2R+185QdKIcyAQbwBOHV6b6EpNxVihDuml
         fYagV9aD1w7w3FmvnS4npYc4Yn9uOYsuErzFs23bnWGFhzj++I0JGlH/A5N2sEYwc6uz
         OOCxjglbBYXyBxKi6eWE6e9IDNcZX75/hHv9BaZtQ3Epw/CG43NxTHpcuTa0xCuRI1l7
         7Qii2V+M2j/MahX2wPf2PpOP5H5J04bBv1WuX1GQvGEMw+5cb2iRFo1Ps7Th3wDNTOpm
         Ud2kkKvy1TwUp7j1havOJ3u3Gqp96BPAPljsmTrXGw80e3Ks3eo7Xo7LNJUO9IVJ4JbI
         MdIQ==
X-Gm-Message-State: AOJu0YygLLtssH/JnvRzaTGFSvDsYOnhovliCTEDLNX9wvsIBAbXJ3r5
        eKpXEX4iHAet+pnOztPMFVDdUsc2Ey0=
X-Google-Smtp-Source: AGHT+IH98f7wG38RN37lhDSLWoEwCGnG6D7DEExm2nsd65irQrGyW9WeKZjyXe/0m6DVmKMct0wCNPT8XGY=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a5b:90e:0:b0:d6b:1a89:6673 with SMTP id
 a14-20020a5b090e000000b00d6b1a896673mr3233ybq.5.1692139897682; Tue, 15 Aug
 2023 15:51:37 -0700 (PDT)
Date:   Tue, 15 Aug 2023 15:51:36 -0700
In-Reply-To: <20230719024558.8539-3-guang.zeng@intel.com>
Mime-Version: 1.0
References: <20230719024558.8539-1-guang.zeng@intel.com> <20230719024558.8539-3-guang.zeng@intel.com>
Message-ID: <ZNwBeN8mGr1sJJ6i@google.com>
Subject: Re: [PATCH v2 2/8] KVM: x86: Use a new flag for branch instructions
From:   Sean Christopherson <seanjc@google.com>
To:     Zeng Guang <guang.zeng@intel.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        H Peter Anvin <hpa@zytor.com>, kvm@vger.kernel.org,
        x86@kernel.org, linux-kernel@vger.kernel.org,
        Binbin Wu <binbin.wu@linux.intel.com>
Content-Type: text/plain; charset="us-ascii"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Branch *targets*, not branch instructions.  

On Wed, Jul 19, 2023, Zeng Guang wrote:
> From: Binbin Wu <binbin.wu@linux.intel.com>
> 
> Use the new flag X86EMUL_F_BRANCH instead of X86EMUL_F_FETCH in
> assign_eip(), since strictly speaking it is not behavior of instruction
> fetch.

Eh, I'd just drop this paragraph, as evidenced by this code existing as-is for
years, we wouldn't introduce X86EMUL_F_BRANCH just because resolving a branch
target isn't strictly an instruction fetch.

> Another reason is to distinguish instruction fetch and execution of branch
> instruction for feature(s) that handle differently on them.

Similar to the shortlog, it's about computing the branch target, not executing a
branch instruction.  That distinction matters, e.g. a Jcc that is not taken will
*not* follow the branch target, but the instruction is still *executed*.  And there
exist instructions that compute branch targets, but aren't what most people would
typically consider a branch instruction, e.g. XBEGIN.

> Branch instruction is not data access instruction, so skip checking against
> execute-only code segment as instruction fetch.

Rather than call out individual use case, I would simply state that as of this
patch, X86EMUL_F_BRANCH and X86EMUL_F_FETCH are identical as far as KVM is
concernered.  That let's the reader know that (a) there's no intended change in
behavior and (b) that the intent is to effectively split all consumption of
X86EMUL_F_FETCH into (X86EMUL_F_FETCH | X86EMUL_F_BRANCH).

> Signed-off-by: Binbin Wu <binbin.wu@linux.intel.com>
> Signed-off-by: Zeng Guang <guang.zeng@intel.com>
> ---
>  arch/x86/kvm/emulate.c     | 5 +++--
>  arch/x86/kvm/kvm_emulate.h | 1 +
>  2 files changed, 4 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/x86/kvm/emulate.c b/arch/x86/kvm/emulate.c
> index 3ddfbc99fa4f..8e706d19ae45 100644
> --- a/arch/x86/kvm/emulate.c
> +++ b/arch/x86/kvm/emulate.c
> @@ -721,7 +721,8 @@ static __always_inline int __linearize(struct x86_emulate_ctxt *ctxt,
>  		    (flags & X86EMUL_F_WRITE))
>  			goto bad;
>  		/* unreadable code segment */
> -		if (!(flags & X86EMUL_F_FETCH) && (desc.type & 8) && !(desc.type & 2))
> +		if (!(flags & (X86EMUL_F_FETCH | X86EMUL_F_BRANCH))
> +			&& (desc.type & 8) && !(desc.type & 2))

Put the && on the first line, and align indendation.

		/* unreadable code segment */
		if (!(flags & (X86EMUL_F_FETCH | X86EMUL_F_BRANCH)) &&
		    (desc.type & 8) && !(desc.type & 2))
			goto bad;
