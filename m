Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 95789718FC3
	for <lists+kvm@lfdr.de>; Thu,  1 Jun 2023 02:56:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229741AbjFAA4b (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 31 May 2023 20:56:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33354 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229611AbjFAA4a (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 31 May 2023 20:56:30 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CDEFD125;
        Wed, 31 May 2023 17:56:27 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6760A63FF0;
        Thu,  1 Jun 2023 00:56:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 28E6BC433D2;
        Thu,  1 Jun 2023 00:56:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1685580986;
        bh=B0ORSrCb/4iweMpuDamOFn9kQ+8x2ov51pYiyR5GbYY=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=ctUVcJf8+7tg/gF/3pR1nEpdP1XxE09yyDh97ikwi53j+Mgwud8cnCeGOgg/VvCpI
         c/ZhlCgts0lcba1wJ9Rw2k+P6EyF+ln6v70WE8MFYzbqwZJgrspaezZS4/4pixiWDE
         PGtQhJ9FjbmSWhT1vbIg57ennnwhzul5TFUt7AeYt5GaF6czQJP2+XtCYtNXhOPa72
         ThlOHZoCSNoBq+41nd0VYLYsfE0gepGB9gD43DZfLSbWmDtCfV5zzxqrLifvTO5+HP
         p8xTIDarduhO52+xrzlRkKYR4qvIeM2RFVcbQQPLN+jGRkUA92zzyNwRKesSwOs/uh
         4RlXDnZlAZZVA==
Date:   Wed, 31 May 2023 17:56:24 -0700
From:   Josh Poimboeuf <jpoimboe@kernel.org>
To:     Andrew Cooper <andrew.cooper3@citrix.com>
Cc:     Jon Kohler <jon@nutanix.com>,
        Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        X86 ML <x86@kernel.org>, "H. Peter Anvin" <hpa@zytor.com>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        Pawan Gupta <pawan.kumar.gupta@linux.intel.com>,
        Daniel Sneddon <daniel.sneddon@linux.intel.com>,
        "kvm @ vger . kernel . org" <kvm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] KVM: VMX: remove LFENCE in vmx_spec_ctrl_restore_host()
Message-ID: <20230601005624.ou3iqfbpbsfy3j4e@treble>
References: <20230531150112.76156-1-jon@nutanix.com>
 <20230531231820.trrs2uugc24gegj4@treble>
 <F4BEBCAF-CBFC-4C3E-8B01-2ED84CF2E13A@nutanix.com>
 <20230601004202.63yulqs73kuh3ep6@treble>
 <846dd0c5-d431-e20e-fdb3-a4a26b6a22ca@citrix.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <846dd0c5-d431-e20e-fdb3-a4a26b6a22ca@citrix.com>
X-Spam-Status: No, score=-7.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Jun 01, 2023 at 01:50:48AM +0100, Andrew Cooper wrote:
> On 01/06/2023 1:42 am, Josh Poimboeuf wrote:
> > So each LFENCE has a distinct purpose.  That said, there are no indirect
> > branches or unbalanced RETs between them.
> 
> How lucky are you feeling?
> 
> You're in C at this point, which means the compiler could have emitted a
> call to mem{cpy,cmp}() in place of a simple assignment/comparison.

But it's only unbalanced RETs we're concerned about, per Intel.

-- 
Josh
