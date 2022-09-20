Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7E5345BEF3B
	for <lists+kvm@lfdr.de>; Tue, 20 Sep 2022 23:36:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230355AbiITVgt (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 20 Sep 2022 17:36:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35922 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229881AbiITVgr (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 20 Sep 2022 17:36:47 -0400
Received: from mail-oa1-x30.google.com (mail-oa1-x30.google.com [IPv6:2001:4860:4864:20::30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 89FD257277
        for <kvm@vger.kernel.org>; Tue, 20 Sep 2022 14:36:46 -0700 (PDT)
Received: by mail-oa1-x30.google.com with SMTP id 586e51a60fabf-127d10b4f19so6256972fac.9
        for <kvm@vger.kernel.org>; Tue, 20 Sep 2022 14:36:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date;
        bh=XoMiaJ0ZvgZywuSj8As4b/u6fRIu1q967RYoCs+uobM=;
        b=YSULUqQeSC9ZjJb8PTF53cHyQ07TOJ9ekcAinjYmbpU5Iqp+IH32IEUpW1ivSIKL/C
         kFX2dTaRhIUxZ4+1T+uLZgMld1L3mLG3jN/vwI6c5IuUJiq1uikj+sFFeJZmE6Izx88b
         cTYsPMZ8I2IkjxfMQrCdStja3LBnatyPqwmxRXWrwl2JfyfMR7lPjtywb88wUIpYWsJ1
         1KwRg0mOy9LDNERt0ejtTuT8JX75CdKIfNxB9oPe5d+IS66uWnzbQoeCeuCOZx47yQEC
         CSezUB2Ln04kA95Gt39/GLkxglq5Mv2pnoMldCy2Qs6PxcSECkT98wD+G1GKX1GzKY+a
         fnSw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date;
        bh=XoMiaJ0ZvgZywuSj8As4b/u6fRIu1q967RYoCs+uobM=;
        b=DZbZPxM/pYtAGE7L4QO4AS9T7vqJkmtQHzWT727GtHHI0pnrpftJTIuGAztPuzyE76
         s2g7hhfGTnwuCE7qTnn9SMCZj4YubVkOVO8isIKcuSnK7kCxzgxF4WPJYpaqx4yLIGac
         yXYgEHZIuRNMWqrapjGDAJhBpAtDoUYXVA5hUEg4fpbPklrSApkegtDK+d2lOAG/bAig
         uBJv2o1MhiNwm4Y4BmcqADwK0Ff4ymnPLfcDuP73SO5ZC93C4TkFNmzRZwpOxRd1n0iu
         r1VWUtvIeoW0TI+5NQXuAVoYHUa5pnKVv1f6EPa6qsP8uJVOGfyHU5iFj3qc8R6t7KO0
         GLlg==
X-Gm-Message-State: ACrzQf2U+j3Rncqf6KwNybd7iFWLIwgPkx3hvm5SjSfywY04le0smlp7
        gOAjS7z4QDvkfvzXhEZh//ugoWE23fKdp9PD+Tujcg==
X-Google-Smtp-Source: AMsMyM6BR6gP6kTk7WmzE+QAuPHf0Sr9v1D4TerCC8nIej7mZDJssF4fEPx7srTDKCD/u2dUDvJfg8JWM89LuSZg9N0=
X-Received: by 2002:a05:6870:5250:b0:127:4360:a00b with SMTP id
 o16-20020a056870525000b001274360a00bmr3262604oai.13.1663709805673; Tue, 20
 Sep 2022 14:36:45 -0700 (PDT)
MIME-Version: 1.0
References: <20220920205922.1564814-1-jmattson@google.com> <Yyot34LGkFR2/j5f@zn.tnic>
In-Reply-To: <Yyot34LGkFR2/j5f@zn.tnic>
From:   Jim Mattson <jmattson@google.com>
Date:   Tue, 20 Sep 2022 14:36:34 -0700
Message-ID: <CALMp9eQijCKS-E_OWJkxdqAur3BthciOWEtEPH5YKd0-HJiQQA@mail.gmail.com>
Subject: Re: [PATCH v2 0/3] KVM: EFER.LMSLE cleanup
To:     Borislav Petkov <bp@alien8.de>
Cc:     Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>,
        Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
        "H . Peter Anvin" <hpa@zytor.com>,
        Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
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

On Tue, Sep 20, 2022 at 2:17 PM Borislav Petkov <bp@alien8.de> wrote:
>
> On Tue, Sep 20, 2022 at 01:59:19PM -0700, Jim Mattson wrote:
> > Jim Mattson (3):
> >   Revert "KVM: SVM: Allow EFER.LMSLE to be set with nested svm"
> >   x86/cpufeatures: Introduce X86_FEATURE_NO_LMSLE
> >   KVM: SVM: Unconditionally enumerate EferLmsleUnsupported
>
> Why do you need those two if you revert the hack? After the revert,
> anything that tries to set LMSLE should get a #GP anyway, no?

Reporting that CPUID bit gives us the right to raise #GP. AMD CPUs
(going way back) that don't report EferLmsleUnsupported do not raise
#GP.
