Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6FFD261A3CB
	for <lists+kvm@lfdr.de>; Fri,  4 Nov 2022 23:01:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230073AbiKDWBB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 4 Nov 2022 18:01:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59008 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229873AbiKDWA7 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 4 Nov 2022 18:00:59 -0400
Received: from mail-oa1-x2a.google.com (mail-oa1-x2a.google.com [IPv6:2001:4860:4864:20::2a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C1D6CBE34
        for <kvm@vger.kernel.org>; Fri,  4 Nov 2022 15:00:56 -0700 (PDT)
Received: by mail-oa1-x2a.google.com with SMTP id 586e51a60fabf-13c2cfd1126so6960934fac.10
        for <kvm@vger.kernel.org>; Fri, 04 Nov 2022 15:00:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=9ru2O27KhwLVb1DWRXQb8XtQqCurqYDAL67PCWqMfqE=;
        b=p5z1DkIlfx8i6AFUMDT/HshPZbplUxGPOa98ZuyhLM+4EdBOr+wIzBhw2b2/4CxMEQ
         0+7AmUHdoOPEOw2BMwCbpy6N5TGdtONibPiVtSHpm44nafbKshwffZgG4/x7owqOjORU
         g7z6ub2sAkT+IrWAvrMFh6EKsZlR/WuMtYF1oLL8Dwt5cmUYxvPsYc5P6gDB5pgq6OFh
         yxlTHRxs2XWQweRJ42RypWc+ltWhJTqpFBH0d52eDjnWvdxJfrMd+/8LyuQfg7X5hh3M
         2ON9mWd+97DPM5nYE8ZazS7svxlZAl8gP6US0A38vxeXncc6JYPBL2a7925Sa62wG9Vd
         lEOA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=9ru2O27KhwLVb1DWRXQb8XtQqCurqYDAL67PCWqMfqE=;
        b=u+IDztXWHDGEPXkrfOuPC5UgxSgjT8dubNxXN8DpVK5dExhu5hr7ny6dWszL9n3YB/
         xa7Hu0hXSRRw3WWw05jT1JwK8btWRgTWuijOW2eT/lXcXatP9xt4t4Ba5rZemcdUdqRE
         0L8hq3pDa0VqM2/e7Z1R+IIAvlHYgiB9d60rqAZlzPCYPlX9bECNhBFRRZRiV7eTC8r/
         8x96N0s1Rx0fiXVsTPzcqFhN04/YI2Au6K65Wp6SWCyEL/aR56WmfezdLy6k+wvWrEaC
         XyOCv4sQuxVQui5JTo7PLBvi4G5hwQIeog1OmpKrqHrUR7KuILUeE++u2WTlLmUK3ii4
         FAHw==
X-Gm-Message-State: ACrzQf2Cy5AniEGLtBKhHJpajFJ1zcxV33aLplgKPwFLtEChNdxhYxJ6
        5/CYNOy3brtvipt9TIq9PQk1fJ1aMTUB47fKuKWL2g==
X-Google-Smtp-Source: AMsMyM4bGltVDYrrDGLU9k+sm/2cljesNpv6yCiTtOf7czHWrEhygAy+4nXAiY5LPqr5OsvB7nfwL42Xxb/PwWY2wq8=
X-Received: by 2002:a05:6871:8a3:b0:13b:18ef:e8df with SMTP id
 r35-20020a05687108a300b0013b18efe8dfmr22205078oaq.181.1667599255959; Fri, 04
 Nov 2022 15:00:55 -0700 (PDT)
MIME-Version: 1.0
References: <20221104213651.141057-1-kim.phillips@amd.com> <20221104213651.141057-4-kim.phillips@amd.com>
In-Reply-To: <20221104213651.141057-4-kim.phillips@amd.com>
From:   Jim Mattson <jmattson@google.com>
Date:   Fri, 4 Nov 2022 15:00:45 -0700
Message-ID: <CALMp9eSpKGCYK_1r3o326ui5RVoH73_RR5-LR2Div9Jm5zvk6A@mail.gmail.com>
Subject: Re: [PATCH 3/3] x86/speculation: Support Automatic IBRS under virtualization
To:     Kim Phillips <kim.phillips@amd.com>
Cc:     x86@kernel.org, Borislav Petkov <bp@alien8.de>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>,
        Joao Martins <joao.m.martins@oracle.com>,
        Jonathan Corbet <corbet@lwn.net>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        David Woodhouse <dwmw@amazon.co.uk>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Juergen Gross <jgross@suse.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Tony Luck <tony.luck@intel.com>,
        Babu Moger <Babu.Moger@amd.com>,
        Tom Lendacky <thomas.lendacky@amd.com>, kvm@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Nov 4, 2022 at 2:38 PM Kim Phillips <kim.phillips@amd.com> wrote:
>
> VM Guests may want to use Auto IBRS, so propagate the CPUID to them.
>
> Co-developed-by: Babu Moger <Babu.Moger@amd.com>
> Signed-off-by: Kim Phillips <kim.phillips@amd.com>

The APM says that, under AutoIBRS, CPL0 processes "have IBRS
protection." I'm taking this to mean only that indirect branches in
CPL0 are not subject to steering from a less privileged predictor
mode. This would imply that indirect branches executed at CPL0 in L1
could potentially be subject to steering by code running at CPL0 in
L2, since L1 and L2 share hardware predictor modes.

Fortunately, there is an IBPB when switching VMCBs in svm_vcpu_load().
But it might be worth noting that this is necessary for AutoIBRS to
work (unless it actually isn't).
