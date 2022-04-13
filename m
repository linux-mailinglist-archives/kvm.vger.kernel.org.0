Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E46304FFE6B
	for <lists+kvm@lfdr.de>; Wed, 13 Apr 2022 21:04:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233412AbiDMTHB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 13 Apr 2022 15:07:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34752 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233535AbiDMTG5 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 13 Apr 2022 15:06:57 -0400
Received: from mail-pl1-x636.google.com (mail-pl1-x636.google.com [IPv6:2607:f8b0:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1D50D3B3E4
        for <kvm@vger.kernel.org>; Wed, 13 Apr 2022 12:04:35 -0700 (PDT)
Received: by mail-pl1-x636.google.com with SMTP id n8so2758954plh.1
        for <kvm@vger.kernel.org>; Wed, 13 Apr 2022 12:04:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=gb8PaDl/8AaAA3ALt4x+MGUvMpYMJexkBesQ3kkm790=;
        b=Gl2VTBrIBLsYOrtH+rQwwYBPvYV8YjzD8phT28/nW1t5up/m7WuusTR8AeOai6Pcly
         IiA8x/3b+8lhCuVpepgJRAGpVfgD/yciFXucKXBJ8I94LCHax51N7tT/QOBjxLCn28nR
         deh4jy/5QVpppJ7aNlsjEVPZMbR6EuXgPxu6iASpGPmW7M426xFpMh3LpEQyCAHTXzrJ
         DCRZI8a29XTIDE8Z0jB92076uQZHzGR/ptASmHoYDYoAL4xhlmwsHjxMkazfe8ycfDfa
         8Q4lrt1/BobXWG3utFiuvBpCFI3W8In+tz/bO/uyTM8GUMheQM6aFnHRlv8wRz3LetmI
         75nw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=gb8PaDl/8AaAA3ALt4x+MGUvMpYMJexkBesQ3kkm790=;
        b=SNSW0tlfxkTlN6cfbWLVA4HX61KV5dEUjmVAtZ1NxSdSpvYQI4D7PLWxFoZd81ZJul
         C3oyW5jtBrPrkFMjvzQ4QfVbfMbcQ3HsvYCCfgdx5KOKR5gG1J3LH8U2EoL1zM5QS8Hi
         GykcjSMPhmd4XoqOVAP+C+CpNNIYzj5Eq/NiJftQtvKKxd5qc92bg59m7Pn9yiDYRqRs
         eUx5F3OuYC8C0YhMNCuGvT7t/vieVsHqN0sSth6CcMLROTV103ojP3JJgE6dzDThNj5o
         Foh16MBNK5yHRMifu8HvPSusJjZWLEFPm7siux6ta0/hMfLK2NBkW0qP+EjjLEGKctoA
         1SZQ==
X-Gm-Message-State: AOAM5320Xc9yYByP+kiKhebrrhFGxwUOsTq/bGyY4Wwg7+qOakKCBxdG
        5roBTyvcfY0+0e6QdhH8waFqiA==
X-Google-Smtp-Source: ABdhPJyKos4QQR+iMFOwwO+2M7alxxXZVnh9eVeiNumynKWUh6m7nnhhKzu5U3IrLP6m0j+MLdEW0A==
X-Received: by 2002:a17:902:d5d7:b0:156:1968:8b2f with SMTP id g23-20020a170902d5d700b0015619688b2fmr43837188plh.97.1649876674352;
        Wed, 13 Apr 2022 12:04:34 -0700 (PDT)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id y3-20020a63de43000000b0039d1172b90fsm6894440pgi.76.2022.04.13.12.04.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 13 Apr 2022 12:04:33 -0700 (PDT)
Date:   Wed, 13 Apr 2022 19:04:30 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Varad Gautam <varad.gautam@suse.com>
Cc:     kvm@vger.kernel.org, pbonzini@redhat.com, drjones@redhat.com,
        marcorr@google.com, zxwang42@gmail.com, erdemaktas@google.com,
        rientjes@google.com, brijesh.singh@amd.com,
        Thomas.Lendacky@amd.com, jroedel@suse.de, bp@suse.de
Subject: Re: [kvm-unit-tests PATCH v2 01/10] x86: Move ap_init() to smp.c
Message-ID: <Ylcevp5kxoTNIB6S@google.com>
References: <20220412173407.13637-1-varad.gautam@suse.com>
 <20220412173407.13637-2-varad.gautam@suse.com>
 <YlcZ83yz9eoBjmEt@google.com>
 <Ylcckbw3XXxcJiTL@google.com>
 <YlcdefdD4eqlL8U9@google.com>
 <YlceG2R7fH8+XxE/@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YlceG2R7fH8+XxE/@google.com>
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

On Wed, Apr 13, 2022, Sean Christopherson wrote:
> On Wed, Apr 13, 2022, Sean Christopherson wrote:
> > On Wed, Apr 13, 2022, Sean Christopherson wrote:
> > > On Wed, Apr 13, 2022, Sean Christopherson wrote:
> > > > On Tue, Apr 12, 2022, Varad Gautam wrote:
> > > > > @@ -142,3 +143,26 @@ void smp_reset_apic(void)
> > > > >  
> > > > >  	atomic_inc(&active_cpus);
> > > > >  }
> > > > > +
> > > > > +void ap_init(void)
> > 
> > Sorry for chaining these, I keep understanding more things as I read through the
> > end of the series.  Hopefully this is the last one.
> > 
> > Can this be named setup_efi_rm_trampoline()?  Or whatever best matches the name
> > we decide on.  I keep thinking APs bounce through this to do their initialization,
> > but it's the BSP doing setup to prep waking the APs.
> 
> Well that didn't take long.  Just realized this isn't unique to EFI, and it also
> does the waking.  Maybe wake_aps()?  That makes smp_init() even more confusing
> (I keep thinking that it wakes APs...), but IMO smp_init() is the one that needs
> a new name.

*sigh*  Ignore the last complaint about smp_init(), it does do SMP initialization
by sending IPIs.  We should really change that, but that's a future problem.
