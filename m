Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 81730535582
	for <lists+kvm@lfdr.de>; Thu, 26 May 2022 23:35:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244143AbiEZVfJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 26 May 2022 17:35:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52582 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349154AbiEZVfI (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 26 May 2022 17:35:08 -0400
Received: from mail-pj1-x1029.google.com (mail-pj1-x1029.google.com [IPv6:2607:f8b0:4864:20::1029])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 76A33C1EC0
        for <kvm@vger.kernel.org>; Thu, 26 May 2022 14:35:07 -0700 (PDT)
Received: by mail-pj1-x1029.google.com with SMTP id gz24so2894177pjb.2
        for <kvm@vger.kernel.org>; Thu, 26 May 2022 14:35:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=Ps3rawoSWC/it4y6dQ5wsGYhp9yrFt3MHXORhqDfylw=;
        b=J4QwXySm0FJ4pZkEFIwaOJRNdMEWqjoPUfIdvss0oDROz3t6t+POWBXXPL5ILLnR2k
         OTsgFcHq5NDEljf0vTX6r5vVzxGsq4qlw+QBasZOptplqkHHeDNWkx6MXBMKpTez2w1X
         BfTqzrSz/nV7Utt+cXazsHix/D1/PHLrH071OQdpZ37WFjk+aycNDMUSpK9sArxKDfaE
         3gD/0UpCt2TolugIInhXmSPfF740c2mRxTd/8v/kqBSq2ZSGs15fgfmcB9NHE3jDdG2X
         uVmDDYvgYz1khX0V4+Jr7RjUBP2BR5fZLvMSrVXiavnyZyZbvubg8yh00+YzHhC0dnVM
         /ebQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=Ps3rawoSWC/it4y6dQ5wsGYhp9yrFt3MHXORhqDfylw=;
        b=5jNPV8LEpT2Qfv4n+QLpRp0X5b4N50CjxQUGASGTy73jLv2WHYi5zGMaJMmDs0C96e
         gbgfx0yaGB/9B5bKDtG1QCUAJ3P0/iVDgdMICWFmyRgLfMuzh7Re8WYOvVqnvZImR3NY
         p7uZhGDXCgqt34m0FBc6StBwCZClbsio8ryzYefgyeR8X7LRU1GahR20NW8BQihzm2J5
         ZA95+UFFwFyfez4S81z4ZU3WFU2DIuKkVHx4eV+7wgZE6NRLseHWUF2xNAE5Bs8BVBOH
         AFJYDOCA5ZbO4AUiq5ZXTDrRzyFHY2EL9Udq7H0vsrKwDiSRxerSL0094cI3mQRJ9I4x
         Wnlg==
X-Gm-Message-State: AOAM531sgUcy59Dvgpu2sgpwfgLZj1iZr4N7JrTq0brt6mEehRaFU+nY
        r9ySCrNW8CmN9CfZmOJirtSI3g==
X-Google-Smtp-Source: ABdhPJxKo/nh9B7qBYXgWNYTcLxoD/M3nwN0MLuE2g2sW6Lv2TIAPNV4NTMGIW3muGPi6Rs5QsyOAA==
X-Received: by 2002:a17:902:c94c:b0:162:2b70:110f with SMTP id i12-20020a170902c94c00b001622b70110fmr20126687pla.127.1653600906757;
        Thu, 26 May 2022 14:35:06 -0700 (PDT)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id p4-20020a170902eac400b001635dc81415sm2025134pld.289.2022.05.26.14.35.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 26 May 2022 14:35:06 -0700 (PDT)
Date:   Thu, 26 May 2022 21:35:02 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Chenyi Qiang <chenyi.qiang@intel.com>,
        Lei Wang <lei4.wang@intel.com>
Subject: Re: [PATCH 1/2] KVM: VMX: Sanitize VM-Entry/VM-Exit control pairs at
 kvm_intel load time
Message-ID: <Yo/yhiVl++FTSa3S@google.com>
References: <20220525210447.2758436-1-seanjc@google.com>
 <20220525210447.2758436-2-seanjc@google.com>
 <8baca98e-63d6-f7dd-067b-05f8e0dc381f@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8baca98e-63d6-f7dd-067b-05f8e0dc381f@redhat.com>
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, May 26, 2022, Paolo Bonzini wrote:
> On 5/25/22 23:04, Sean Christopherson wrote:
> > +#define VMCS_ENTRY_EXIT_PAIR(name, entry_action, exit_action) \
> > +	{ VM_ENTRY_##entry_action##_##name, VM_EXIT_##exit_action##_##name }
> > +
> >   static __init int setup_vmcs_config(struct vmcs_config *vmcs_conf,
> >   				    struct vmx_capability *vmx_cap)
> >   {
> > @@ -2473,6 +2476,24 @@ static __init int setup_vmcs_config(struct vmcs_config *vmcs_conf,
> >   	u64 _cpu_based_3rd_exec_control = 0;
> >   	u32 _vmexit_control = 0;
> >   	u32 _vmentry_control = 0;
> > +	int i;
> > +
> > +	/*
> > +	 * LOAD/SAVE_DEBUG_CONTROLS are absent because both are mandatory.
> > +	 * SAVE_IA32_PAT and SAVE_IA32_EFER are absent because KVM always
> > +	 * intercepts writes to PAT and EFER, i.e. never enables those controls.
> > +	 */
> > +	struct {
> > +		u32 entry_control;
> > +		u32 exit_control;
> > +	} vmcs_entry_exit_pairs[] = {
> > +		VMCS_ENTRY_EXIT_PAIR(IA32_PERF_GLOBAL_CTRL, LOAD, LOAD),
> > +		VMCS_ENTRY_EXIT_PAIR(IA32_PAT, LOAD, LOAD),
> > +		VMCS_ENTRY_EXIT_PAIR(IA32_EFER, LOAD, LOAD),
> > +		VMCS_ENTRY_EXIT_PAIR(BNDCFGS, LOAD, CLEAR),
> > +		VMCS_ENTRY_EXIT_PAIR(IA32_RTIT_CTL, LOAD, CLEAR),
> > +		VMCS_ENTRY_EXIT_PAIR(IA32_LBR_CTL, LOAD, CLEAR),
> 
> No macros please, it's just as clear to expand them especially since the
> #define is far from the struct definition.

It's not for clarity, it's to prevent plopping an EXIT control into the ENTRY
slot and vice versa.  I have a hell of a time trying to visually differentiate
those, and a buggy pair isn't guaranteed to be detected at runtime, e.g. if both
are swapped, all bets are off, and if one is duplicated, odds the warn may or may
not show up unless hardware actually supports at least one of the controls, if not
both.

With this, swapping LOAD and LOAD is obviously a nop, and swapping LOAD and CLEAR
will generate a compiler error.

FWIW, I did originally have the array declared as static __initdata immediately
after the #define.  I moved away from that because __initdata doesn't play nice
with const, but then of course I forgot to add back the "const".  /facepalm
