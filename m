Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5DE5A667F04
	for <lists+kvm@lfdr.de>; Thu, 12 Jan 2023 20:26:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240499AbjALT0A (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 12 Jan 2023 14:26:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48678 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234650AbjALTZd (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 12 Jan 2023 14:25:33 -0500
Received: from mail-pl1-x62e.google.com (mail-pl1-x62e.google.com [IPv6:2607:f8b0:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B7C0D43E4B
        for <kvm@vger.kernel.org>; Thu, 12 Jan 2023 11:17:08 -0800 (PST)
Received: by mail-pl1-x62e.google.com with SMTP id d9so21174352pll.9
        for <kvm@vger.kernel.org>; Thu, 12 Jan 2023 11:17:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=L8pKt/QSiUf+5HhlcM1I4j8eJilEtgi3Hvsov9rJT7Y=;
        b=TU1GUllP50CJgx1fOXFdI7yGQtscskF1O8hTUcO+W5TIGSXFzrzp2z3LmVKo8wc9w/
         JAi/Y9eHm8XhB652iygEXzCy+ReBDhJIHmL7s2ISpG9mD2iNFzntI2d55+aRGuxakajs
         OMh3NskuD3OlaGnEUR43BaAOps1TtentWiSzm5/EklbbSd0+NTieZQtRMWdOA3GEABb6
         orbdQklB08zd6PRJRwJS5JX+owpXrHN/KjOaPS4cvSDzxUAMXZ5NYN/wVrLsD+ROQkfU
         CahlsnV55mlHsoG0RiQX5MGIbVwOcxCqQ4UKWrTR9X8jJ+lRlVwDdnZzFZwJ3sWKm1zz
         Pt0g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=L8pKt/QSiUf+5HhlcM1I4j8eJilEtgi3Hvsov9rJT7Y=;
        b=wlmc1uMhC8YqsCIwMU6NBn+Pa3m1PqE5xdxT+wjdPEUrLRIKwiCrSH6j3h/i6zSZB7
         Z9913G6xGWPkOov+GgfGyI+jQbtXAb0dlq17qReDle7LrPSpm35JweuQMYfCkh+avIWV
         Lp+6B0yyycSJIhmco5x54PRO8cA/+CppeYZopZOga7u51rmEeyFrn6Glrwns3e3YdFTW
         x1aE7eoW2tkYjSxGV1iyR929rNL/ECVmTnf5w53iF/opgbtTLpb+RureIv8RgcDpQhC1
         V8IA04jqlRPgJ6q7fVgI7NdIVnTlGpCQIKj2rQ9ZSS9ZdpXG1cPdxEpO0zJta5rtdhHG
         PqGw==
X-Gm-Message-State: AFqh2kpuySa4yKEOcB9oJ+cksCJAzXMrMvx/7z61OfzwuO5si0GN0JcM
        cgFGZTqUWiCutDzHj6pkGYl3nQ==
X-Google-Smtp-Source: AMrXdXsJH1eI7cNML3x5kequyDjr1+PrpfXdtcooAJ0ts65b9zPMGAT+wqkZlUVjrvHxulwv7CHpdQ==
X-Received: by 2002:a17:903:2115:b0:189:aa51:e27f with SMTP id o21-20020a170903211500b00189aa51e27fmr6555216ple.44.1673551028094;
        Thu, 12 Jan 2023 11:17:08 -0800 (PST)
Received: from google.com (33.5.83.34.bc.googleusercontent.com. [34.83.5.33])
        by smtp.gmail.com with ESMTPSA id e5-20020a17090301c500b00188fadb71ecsm12639218plh.16.2023.01.12.11.17.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 12 Jan 2023 11:17:07 -0800 (PST)
Date:   Thu, 12 Jan 2023 19:17:03 +0000
From:   Mingwei Zhang <mizhang@google.com>
To:     "Chang S. Bae" <chang.seok.bae@intel.com>
Cc:     Aaron Lewis <aaronlewis@google.com>,
        "Christopherson,, Sean" <seanjc@google.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "jmattson@google.com" <jmattson@google.com>,
        Thomas Gleixner <tglx@linutronix.de>, "bp@suse.de" <bp@suse.de>
Subject: Re: [PATCH v2 1/6] KVM: x86: Clear all supported MPX xfeatures if
 they are not all set
Message-ID: <Y8Bcr9VBA/VLjAwd@google.com>
References: <20221230162442.3781098-1-aaronlewis@google.com>
 <20221230162442.3781098-2-aaronlewis@google.com>
 <Y7R36wsXn3JqwfEv@google.com>
 <CAAAPnDHff-2XFdAgKdfTQnG_a4TCVqWN9wxEhUtiOfiOVMuRWA@mail.gmail.com>
 <c87904cb-ce6d-1cf4-5b58-4d588660e20f@intel.com>
 <Y8BPs2269itL+WQe@google.com>
 <a1308e46-c319-fb73-1fde-eb3b071c10e8@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <a1308e46-c319-fb73-1fde-eb3b071c10e8@intel.com>
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

On Thu, Jan 12, 2023, Chang S. Bae wrote:
> On 1/12/2023 10:21 AM, Mingwei Zhang wrote:
> > 
> > Hmm. Given that XFEATURE_XTILE_DATA is a dynamic feature, that means
> > XFEATURE_XTILE_CFG could be set without XFEATURE_XTILE_DATA.
> 
> No, XCR0 is different from the IA32_XFD MSR. Check this in the SDM -- Vol.1
> 13.3 "Enabling the XSAVE Feature Set and XSAVE-Enabled Features":
> 
> "In addition, executing the XSETBV instruction causes a general-
>  protection fault (#GP) if ECX = 0 and EAX[17] ≠ EAX[18] (TILECFG and
>  TILEDATA must be enabled together). This implies that the value of
>  XCR0[18:17] is always either 00b or 11b."
> 
> Thanks,
> Chang

Hmm. Make sense. The proper execution of XSETBV was the key point of the
patch. But the permitted_xcr0 and supported_xcr0 seems never used
directly as the parameter of XSETBV, but only for size calculation.

One more question: I am very confused by the implementation of
xstate_get_guest_group_perm(). It seems fetching the xfeatures from the
host process (&current->group_leader->thread.fpu). Is this intentional?
Does that mean in order to enable AMX in the guest we have to enable it
on the host process first?
