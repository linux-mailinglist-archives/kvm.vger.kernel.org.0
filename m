Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3CA4757CD83
	for <lists+kvm@lfdr.de>; Thu, 21 Jul 2022 16:24:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231557AbiGUOYR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 21 Jul 2022 10:24:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35748 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232084AbiGUOX5 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 21 Jul 2022 10:23:57 -0400
Received: from mail-pg1-x531.google.com (mail-pg1-x531.google.com [IPv6:2607:f8b0:4864:20::531])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 683D687230
        for <kvm@vger.kernel.org>; Thu, 21 Jul 2022 07:23:29 -0700 (PDT)
Received: by mail-pg1-x531.google.com with SMTP id f65so1794548pgc.12
        for <kvm@vger.kernel.org>; Thu, 21 Jul 2022 07:23:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=+AXEAzBDAylA1y7AtfdbuWZfXhKaTnP2VWbxbTQv7WU=;
        b=OLNZWnch3owi8weWQxmiTHnxtBpKloOg4TzzfeeRLj/JXUn5NeY1twxyZfUEcHcSPU
         xzljETnIfKE34QfldTZhaQ3CmHUdK9EyoXiYM8nr8TU5DziyN9spo4SIM2pwEQskj2Ze
         +qNyW7oH6WfLVD5fpvgrBnFk4f4YmI9HANLT4SgPcDD6o9AhiZC37gwgvFXpXRjILSYC
         SahzbyFzBpUbndkuAHqmS7u6dsSl5MRPftvbGGB9vwQZPPXwtE/kw3HxhP66vU8jh5SG
         NRJcVc6ZjA+qlFydvkfAakRogM06qATIgzLlRQhHR/oiyGkeB0/KPYOrOqaPKrg75kFI
         4TOg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=+AXEAzBDAylA1y7AtfdbuWZfXhKaTnP2VWbxbTQv7WU=;
        b=6OYo4x/N4hc+iw1/mxUaAwybZW8wGfiei3Agd5735reYmxKS96e60VMukc95E4EzH8
         8tUUFJX3uGwPOgTONM8TThsnYdqGJute+R77qrxvz9E78lLFzlJladFi9O0uCYExqFvN
         0vEiYy2cMfqkkt+dsKhHQMhfw4lXPQKB06bT9wbI3DC6Z54z/M0m6w7ty9AJNPcpQ3lr
         WlbQF8AC+cF8KOq5Hh7Y72yhUYxstWem9Y+Pnnv0YCGRqBtQVuNMLIzd1xW8l6PWMari
         nggLaZ8j5bC2nV7EmG/JyqYOd0twjuo5gVYI2ntepcjpYpxY/jUcd6qmMMbqw0YDOYaR
         ZUdA==
X-Gm-Message-State: AJIora+ZevpCtEZIqbb3auzQCTm/1pLRQqp0mUXNcpfXOmuE0bY+0wjB
        ATc7CH1K0IPTesNaG+3bt3bV4De0MQqRWg==
X-Google-Smtp-Source: AGRyM1vPaPXFEL7aLcvH5h7PMtLewWmEXarrUep19ky+YKaCyxZr5biGB+M1/9Jgczv6Dxujzxwd/w==
X-Received: by 2002:a63:fc16:0:b0:415:18c4:75a7 with SMTP id j22-20020a63fc16000000b0041518c475a7mr38116570pgi.351.1658413407892;
        Thu, 21 Jul 2022 07:23:27 -0700 (PDT)
Received: from google.com (123.65.230.35.bc.googleusercontent.com. [35.230.65.123])
        by smtp.gmail.com with ESMTPSA id p127-20020a622985000000b00528d3d7194dsm1902591pfp.4.2022.07.21.07.23.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 21 Jul 2022 07:23:27 -0700 (PDT)
Date:   Thu, 21 Jul 2022 14:23:23 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Maxim Levitsky <mlevitsk@redhat.com>
Cc:     kvm@vger.kernel.org, x86@kernel.org,
        Kees Cook <keescook@chromium.org>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        linux-kernel@vger.kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        Borislav Petkov <bp@alien8.de>, Joerg Roedel <joro@8bytes.org>,
        Ingo Molnar <mingo@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>
Subject: Re: [PATCH v2 02/11] KVM: x86: emulator: introduce
 update_emulation_mode
Message-ID: <YtlhWzUA/oPis8iI@google.com>
References: <20220621150902.46126-1-mlevitsk@redhat.com>
 <20220621150902.46126-3-mlevitsk@redhat.com>
 <YtiTeZQ/n0LPTV/W@google.com>
 <4c6deb603ba5b9fbc7e7c30d429190ed5517e97b.camel@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4c6deb603ba5b9fbc7e7c30d429190ed5517e97b.camel@redhat.com>
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Jul 21, 2022, Maxim Levitsky wrote:
> On Wed, 2022-07-20 at 23:44 +0000, Sean Christopherson wrote:
> > On Tue, Jun 21, 2022, Maxim Levitsky wrote:
> > > +	if (!ctxt->ops->get_cr(ctxt, 0) & X86_CR0_PE) {
> > > +		/* Real mode. cpu must not have long mode active */
> > > +		if (efer & EFER_LMA)
> > > +			return X86EMUL_UNHANDLEABLE;
> > 
> > If we hit this, is there any hope of X86EMUL_UNHANDLEABLE doing the right thing?
> > Ah, SMM and the ability to swizzle SMRAM state.  Bummer.  I was hoping we could
> > just bug the VM.
> 
> I just tried to be a good citizen here, it is probably impossible to hit this case.
> (RSM ignores LMA bit in the EFER in the SMRAM).

The reason I asked is because if all of the X86EMUL_UNHANDLEABLE paths are impossible
then my preference would be to refactor this slightly to:

	static int emulator_calc_cpu_mode(const struct x86_emulate_ctxt *ctxt)

and return the mode instead of success/failure, and turn those checks into:

	KVM_EMULATOR_BUG_ON(efer & EFER_LMA);

with the callers being:

	ctxt->mode = emulator_calc_cpu_mode(ctxt);

But I think this one:

	if (!ctxt->ops->get_segment(ctxt, &selector, &cs, &base3, VCPU_SREG_CS))
		return X86EMUL_UNHANDLEABLE;

is reachable in the em_rsm() case :-/
