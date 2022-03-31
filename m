Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D43674ED098
	for <lists+kvm@lfdr.de>; Thu, 31 Mar 2022 02:03:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349269AbiCaAFN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 30 Mar 2022 20:05:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34326 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231937AbiCaAFK (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 30 Mar 2022 20:05:10 -0400
Received: from mail-pj1-x102e.google.com (mail-pj1-x102e.google.com [IPv6:2607:f8b0:4864:20::102e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8CA3DB22
        for <kvm@vger.kernel.org>; Wed, 30 Mar 2022 17:03:20 -0700 (PDT)
Received: by mail-pj1-x102e.google.com with SMTP id l4-20020a17090a49c400b001c6840df4a3so1927941pjm.0
        for <kvm@vger.kernel.org>; Wed, 30 Mar 2022 17:03:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=eK3xgJsSbOj4248lrzJGbFEJ5CxyDIG0aIJkQ/5Fx3I=;
        b=hjmOY7ws3z6W+WChFER7xW75B/O15SGRzs2GdsWRKER/RGDhs2J3uNG0K+gFINWJ0u
         9eLaS7137Hc12CYSRt2eD0A+htyallhS2P+eh7M7C8a396pvzpEZYKqD9R6+9cvHNcCj
         LG1wyJp288R7FfwIJsgdlrVSFKb1yk6ydvElVx+O/e/x4DTV8Q3yg76CG1qYzc95mlA4
         YpTONsqY9K4aDKA8aKYIxaJ6cmKiX6qm9GnPQPCwRHya1xvVrxTtCpYtUxZIutHRf9Nc
         B31bT/0tDe2j1rx7JLP43kUtpg68prkawVNJomrpgChAhndEv7sGJNrcm9KbrBo/ogjn
         4CHg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=eK3xgJsSbOj4248lrzJGbFEJ5CxyDIG0aIJkQ/5Fx3I=;
        b=vpYZo73tSIVlzhv2mSKON43V/mndUhdcBr7cHjjR1hkqx/Hy0Vl5HtEp5bvuPsgGxr
         NqAyDJf5p/7e76US77NfnuSbqmRLcF/FMKIUGwRoZIPUDKqKvOuk9AL++Q3/+wYrezEg
         w17PyU0zKft5U5ToNcWL8tfS5jV0M+E5byCjxqwJBKhe3+SMT3SIvs5IW7VcxD2p0BFJ
         WxHocTT8QrItAENc8lbJhIXMV7cA+BLv4FMipR7ECjMjN+HL5JHFj+KXJaRNIw2ec2ss
         hpyuhETw0y4gFFu3Uv67u2zCIjVcjBoknsL/mprsGsZEPEC+47s/GMG29LgG1fu9lUga
         QCRA==
X-Gm-Message-State: AOAM532MaoUJ+fvKSACk3pHEd8Z8rAyU+bLJ9SFhRJy5bxtkUCSbEYkp
        wbtqXzhodduh5vQi456Au3AY7rddNBuf1g==
X-Google-Smtp-Source: ABdhPJwN8lzxcvtEVo0aBOLKhLyP+tIh/WZx3bv4PUw2Mm70wcCv0Dsb3UEsLqtSfYT+U4DQx5bBcQ==
X-Received: by 2002:a17:902:d88a:b0:156:1609:1e62 with SMTP id b10-20020a170902d88a00b0015616091e62mr16346514plz.143.1648684999806;
        Wed, 30 Mar 2022 17:03:19 -0700 (PDT)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id g3-20020a056a001a0300b004fa65cbbf4esm25563516pfv.63.2022.03.30.17.03.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 30 Mar 2022 17:03:19 -0700 (PDT)
Date:   Thu, 31 Mar 2022 00:03:15 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Isaku Yamahata <isaku.yamahata@gmail.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, isaku.yamahata@intel.com,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jim Mattson <jmattson@google.com>, erdemaktas@google.com,
        Connor Kuehl <ckuehl@redhat.com>
Subject: Re: [RFC PATCH v5 008/104] KVM: TDX: Add a function to initialize
 TDX module
Message-ID: <YkTvw5OXTTFf7j4y@google.com>
References: <cover.1646422845.git.isaku.yamahata@intel.com>
 <b92217283fa96b85e9a683ca3fcf1b368cf8d1c4.1646422845.git.isaku.yamahata@intel.com>
 <05aecc5a-e8d2-b357-3bf1-3d0cb247c28d@redhat.com>
 <20220314194513.GD1964605@ls.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220314194513.GD1964605@ls.amr.corp.intel.com>
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

On Mon, Mar 14, 2022, Isaku Yamahata wrote:
> On Sun, Mar 13, 2022 at 03:03:40PM +0100,
> Paolo Bonzini <pbonzini@redhat.com> wrote:
> 
> > On 3/4/22 20:48, isaku.yamahata@intel.com wrote:
> > > +
> > > +	if (!tdx_module_initialized) {
> > > +		if (enable_tdx) {
> > > +			ret = __tdx_module_setup();
> > > +			if (ret)
> > > +				enable_tdx = false;
> > 
> > "enable_tdx = false" isn't great to do only when a VM is created.  Does it
> > make sense to anticipate this to the point when the kvm_intel.ko module is
> > loaded?
> 
> It's possible.  I have the following two reasons to chose to defer TDX module
> initialization until creating first TD.  Given those reasons, do you still want
> the initialization at loading kvm_intel.ko module?  If yes, I'll change it.

Yes, TDX module setup needs to be done at load time.  The loss of memory is
unfortunate, e.g. if the host is part of a pool that _might_ run TDX guests, but
the alternatives are worse.  If TDX fails to initialize, e.g. due to low mem,
then the host will be unable to run TDX guests despite saying "I support TDX".
Or this gem :-)

	/*
	 * TDH.SYS.KEY.CONFIG may fail with entropy error (which is
	 * a recoverable error).  Assume this is exceedingly rare and
	 * just return error if encountered instead of retrying.
	 */

The CPU overhead of initializing the TDX module is also non-trivial, and it
doesn't affect just this CPU, e.g. all CPUs need to do certain SEAMCALLs and at
least one WBINVD.  The can cause noisy neighbor problems.

> - memory over head: The initialization of TDX module requires to allocate
> physically contiguous memory whose size is about 0.43% of the system memory.
> If user don't use TD, it will be wasted.
> 
> - VMXON on all pCPUs: The TDX module initialization requires to enable VMX
> (VMXON) on all present pCPUs.  vmx_hardware_enable() which is called on creating
> guest does it.  It naturally fits with the TDX module initialization at creating
> first TD.  I wanted to avoid code to enable VMXON on loading the kvm_intel.ko.

That's a solvable problem, though making it work without exporting hardware_enable_all()
could get messy.
