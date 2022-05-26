Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B3FC25347A0
	for <lists+kvm@lfdr.de>; Thu, 26 May 2022 02:42:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344521AbiEZAmj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 25 May 2022 20:42:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60840 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244472AbiEZAmh (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 25 May 2022 20:42:37 -0400
Received: from mail-pf1-x42a.google.com (mail-pf1-x42a.google.com [IPv6:2607:f8b0:4864:20::42a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9F8C3A5ABD
        for <kvm@vger.kernel.org>; Wed, 25 May 2022 17:42:35 -0700 (PDT)
Received: by mail-pf1-x42a.google.com with SMTP id y1so400918pfr.6
        for <kvm@vger.kernel.org>; Wed, 25 May 2022 17:42:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=fY0pwDasrq+hRjmATMcQojEaPrvpzo0c/cewYgdoFdE=;
        b=qfofRs/eTHswEF/1OKt1RhCOxZEdZqsH/dQ3Ah/C2NHat9+ya5Ayyh0qXuBlF7Ogjx
         1Nt98Q52DvJZ50eNZPp4DpX0gJscVDO1Orhwb436nk14jX0gc077JunMqH88pMj89RBP
         2rRumAOf1JLNuTBPN6K1VykuiVeweWdhUooobJ/6lQy/UVAKbn7wrDfyOHGpmGpal+Zh
         LqIXOgC4EGaTvjPFvulFGuDA27pBHajIKsgh2Ogx/1wGmL9U45B96hnU2OIZIfykcbdU
         BtYIAlB2gpzRZl/i9LI77kEROHhy6n3lCaHU+1kpqWDU5MuXeg8CQl5ejk/aUv4oWAmZ
         fseA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=fY0pwDasrq+hRjmATMcQojEaPrvpzo0c/cewYgdoFdE=;
        b=WhS75bm8U6JgeqPf3BmAxEoLkbRTwV9WepAZEmtp4eSph2dHgxuLnQktQHtHKvCCL6
         TnxjLBM9O5dcyMS7DmhyTvm4zS/PhX82nibkOhpo+FsccZKCQDOO3h4wqN/NGvTsLUgv
         CUQIUlZVen7dlqZBWApfULuZbYz2Vpp69c8MHILTkN4+EWuGsviaGea0w8p4AiradRcH
         4HnFXGBWVuBvSMEpyWg8+dApkzqRQxklCwf7Kaw7lpgqICZO3xLdx1cmNBdGRTJWifhV
         2vMo7d4kamWclJPZLa+FBAfA8HvYxii6/GIH6mDpgRfXLf8Y1xLRCen9HFQiMTAHGS4o
         1pCA==
X-Gm-Message-State: AOAM5312LtM56KkoIbNJmvrjVBpdVxXtcfmN+di7y5imLUNg+jvqXipT
        Qg+PB/i7PWTAmCVUx/lzwjoQlw==
X-Google-Smtp-Source: ABdhPJwv37XxWZcWzFsMuo9RiXyWU/ZE5BuaGahcNSly21GjZTmQLec1BMusc0kymiEH1SQWHwAwfw==
X-Received: by 2002:a63:dc42:0:b0:3c5:e187:572 with SMTP id f2-20020a63dc42000000b003c5e1870572mr30940215pgj.82.1653525754866;
        Wed, 25 May 2022 17:42:34 -0700 (PDT)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id a10-20020a63e84a000000b003c5e836eddasm123780pgk.94.2022.05.25.17.42.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 25 May 2022 17:42:34 -0700 (PDT)
Date:   Thu, 26 May 2022 00:42:31 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Yuan Yao <yuan.yao@linux.intel.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Chenyi Qiang <chenyi.qiang@intel.com>,
        Lei Wang <lei4.wang@intel.com>
Subject: Re: [PATCH 1/2] KVM: VMX: Sanitize VM-Entry/VM-Exit control pairs at
 kvm_intel load time
Message-ID: <Yo7M95ILNsHSBtqj@google.com>
References: <20220525210447.2758436-1-seanjc@google.com>
 <20220525210447.2758436-2-seanjc@google.com>
 <20220525232744.e6g77merw7pita3s@yy-desk-7060>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220525232744.e6g77merw7pita3s@yy-desk-7060>
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

On Thu, May 26, 2022, Yuan Yao wrote:
> On Wed, May 25, 2022 at 09:04:46PM +0000, Sean Christopherson wrote:
> > @@ -2614,6 +2635,20 @@ static __init int setup_vmcs_config(struct vmcs_config *vmcs_conf,
> >  				&_vmentry_control) < 0)
> >  		return -EIO;
> >
> > +	for (i = 0; i < ARRAY_SIZE(vmcs_entry_exit_pairs); i++) {
> > +		u32 n_ctrl = vmcs_entry_exit_pairs[i].entry_control;
> > +		u32 x_ctrl = vmcs_entry_exit_pairs[i].exit_control;
> > +
> > +		if (!(_vmentry_control & n_ctrl) == !(_vmexit_control & x_ctrl))
> > +			continue;
> > +
> > +		pr_warn_once("Inconsistent VM-Entry/VM-Exit pair, entry = %x, exit = %x\n",
> > +			     _vmentry_control & n_ctrl, _vmexit_control & x_ctrl);
> 
> How about "n_ctrl, x_ctrl);" ? In 0/1 or 1/0 case this
> outputs all information of real inconsistent bits but not 0.

I thought about adding the stringified control name to the output (yay macros),
but opted for the simplest approach because this should be a very, very rare
event.  All the necessary info is there, it just takes a bit of leg work to get
from a single control bit to the related control name and finally to its pair.

I'm not totally against printing more info, but if we're going to bother doing so,
my vote is to print names instead of numbers.
