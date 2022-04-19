Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EBD5C50725F
	for <lists+kvm@lfdr.de>; Tue, 19 Apr 2022 17:58:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354133AbiDSP7t (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 19 Apr 2022 11:59:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59796 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351075AbiDSP7s (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 19 Apr 2022 11:59:48 -0400
Received: from mail-pf1-x431.google.com (mail-pf1-x431.google.com [IPv6:2607:f8b0:4864:20::431])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A955523BC4
        for <kvm@vger.kernel.org>; Tue, 19 Apr 2022 08:57:05 -0700 (PDT)
Received: by mail-pf1-x431.google.com with SMTP id x80so48958pfc.1
        for <kvm@vger.kernel.org>; Tue, 19 Apr 2022 08:57:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=2IVJA9h4AsV7fdP5RR4o8gCQ+ZpBOfmpsTUUjgtfTgk=;
        b=X9M83V5D8lhzOXWTQBMWIi+QSOTYARshN+qmDjkRjIDjplwOZAVSl9n4QYiwBU6kkT
         uAajHveSR72AVT03JMZU+boOtanRqh6VxmcneLJpDY/mREC5tXkm31+8JzdYCF2VXPRh
         LHR+bYDlO/6FURSkM09GIT6h7V91j6RpsjR7vXqh6bIv/xOFNTrkxE8rXLcWCm/nwUhh
         OXHuWgdziSX/MmCcAN+GHYLn0CW0tvOY9KpbF1/CXeg15SpIxy//maouD8nXopFFyQuH
         9nodT9suzU9URBViF4DGa0AC/hG/GwUIYv7v/AJM/Z7+UhzvtCfJ0A8hxwHdH/a5/d7g
         trog==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=2IVJA9h4AsV7fdP5RR4o8gCQ+ZpBOfmpsTUUjgtfTgk=;
        b=T8KBgV+CmGHmw7k3iwp0inonAmsv3wzmUfd2OquLM3/QZ511XFg2JISA/VpFPlb4q7
         vBDsdSraW2/1YRRduG3VGDSV8DIHImZ5uKAmk6xIMG63Zaf1+rTb7FkRRIfNoQPlQXFd
         rnBQs4yII6CFSUjqXI18kYK34/QDakhC75D15zi7HGbZPcGFdgZCGVWfHhNT7KkvclcT
         4Ld6EQ8+ZOPMEGgOR3VbJmwhF6k62k6jfkCnQi6FWO/zLO3D7DJCLHCg3/XB1H00am9N
         EpwZN9sUan9WDB7/5pKOwzVWU1HHThkJ+6ie/7/L9qXstnevPiIuCeQ16mEiJiIgyp1+
         NFvQ==
X-Gm-Message-State: AOAM531FdBQiECBs/30IcM2tdVSsbO17Ih8P6HRA2QiXx8QXvpuBiBsU
        CwaOd43WfiQuHeDevRyk2wf8yayy/87mVQ==
X-Google-Smtp-Source: ABdhPJzWe4VX/mMeEzkWHWvRah65F9AEwBCNvqZ54IZOLOY6jsc/BWNoLgMC+MBr8DiCYP0HKu9ctQ==
X-Received: by 2002:a62:1b91:0:b0:50a:64d0:58a2 with SMTP id b139-20020a621b91000000b0050a64d058a2mr14100337pfb.38.1650383824998;
        Tue, 19 Apr 2022 08:57:04 -0700 (PDT)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id m17-20020a17090a859100b001bc20ddcc67sm19986662pjn.34.2022.04.19.08.57.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 19 Apr 2022 08:57:04 -0700 (PDT)
Date:   Tue, 19 Apr 2022 15:57:00 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Maxim Levitsky <mlevitsk@redhat.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Gaoning Pan <pgn@zju.edu.cn>,
        Yongkang Jia <kangel@zju.edu.cn>
Subject: Re: [PATCH 2/4] KVM: nVMX: Defer APICv updates while L2 is active
 until L1 is active
Message-ID: <Yl7bzNi9HjbgIAQ5@google.com>
References: <20220416034249.2609491-1-seanjc@google.com>
 <20220416034249.2609491-3-seanjc@google.com>
 <227adbe6e8d82ad4c5a803c117d4231808a0e451.camel@redhat.com>
 <Yl2FXfCjvkNgM4w3@google.com>
 <8b2ff3dc317db18c8128381d5d62057a90f68265.camel@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8b2ff3dc317db18c8128381d5d62057a90f68265.camel@redhat.com>
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

On Tue, Apr 19, 2022, Maxim Levitsky wrote:
> On Mon, 2022-04-18 at 15:35 +0000, Sean Christopherson wrote:
> > On Mon, Apr 18, 2022, Maxim Levitsky wrote:
> > > On Sat, 2022-04-16 at 03:42 +0000, Sean Christopherson wrote:
> > > When L2 uses APICv/AVIC, we just safely passthrough its usage to the real hardware.
> > > 
> > > If we were to to need to inhibit it, we would have to emulate APICv/AVIC so that L1 would
> > > still think that it can use it - thankfully there is no need for that.
> > 
> > What if L1 passes through IRQs and all MSRs to L2? 

...

> - vmcs02 can't have APICv enabled, because passthrough of interrupts thankfully
>   conflicts with APICv (virtual interrupt delivery depends on intercepting interrupts)
>   and even if that was false, it would have contained L2's APICv settings which should
>   continue to work as usual.

Ah, this was the critical piece I was forgetting.  I'll tweak the changelog and
post a new version.

Thanks!
