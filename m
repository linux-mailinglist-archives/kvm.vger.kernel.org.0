Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 77B5A598733
	for <lists+kvm@lfdr.de>; Thu, 18 Aug 2022 17:17:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344229AbiHRPOi (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 18 Aug 2022 11:14:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51776 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344248AbiHRPOO (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 18 Aug 2022 11:14:14 -0400
Received: from mail-pl1-x630.google.com (mail-pl1-x630.google.com [IPv6:2607:f8b0:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 36543101E8
        for <kvm@vger.kernel.org>; Thu, 18 Aug 2022 08:14:13 -0700 (PDT)
Received: by mail-pl1-x630.google.com with SMTP id w14so1748815plp.9
        for <kvm@vger.kernel.org>; Thu, 18 Aug 2022 08:14:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc;
        bh=OB3CiFphujl95/ikK08Kwi2ZSaKPWn5t2tIbw4ADKb4=;
        b=MoRQzBYpqTjN4SKXMnU8Gpx1idcrpgx7tNmrtPEoRwv2We84uBjuxrdmq8fgw3o6Jq
         rhWGHTd+9fKQxjtxeveD6pZd+iyRS6bsVNh3NuvDMRjorvfpT708Xs5M3rC1WhjUlbTG
         SuP+vhpZqN+vV1x/nANcanuXt1EETfPXXD8QeYskz11vu/2e4/xFVyWfqqAzh+HDAkIg
         2aCW124CDujPgylRppn4HbcD/YFjsul+KxtgkFja1FWFeNemiUVQL11B/+0nbOKP2Q9t
         DqNH5df8HBSc1fxHbQIfUpAhmBQ9jJG4h0ZnSr5I+iCfyIwJK319NV71kuSwoG1/kY81
         j8mw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc;
        bh=OB3CiFphujl95/ikK08Kwi2ZSaKPWn5t2tIbw4ADKb4=;
        b=fHigQcIgwIjtLla+bFJ2tilysIhCsOEvQcsS/ypCuUiTOgd96pd4dN9e7+6zfNWoe6
         tlp2GRFGeOWuK3zZCi9feCvOGMr44LIwm5AoW5SEPNTNaIz/FH19SELJamEvBvpD/afM
         HAGg337WSf8yfoL9X39psm2c/lS5hXC4DMVStoXYORZ0pgHsml9ULDncdbu2vSt6Al8n
         EXpBjvjf2GwtskDYYCU+ONZsTaB8+txs/pAePRMwM7JTz1u/hnIu+kcl1FfMGVP2GfnZ
         AHmKvGiNcnpH382e0biM/7MBI1yW2lu3P+87BJ7+e5Pyd0aCUWNMnocdiAUnQw7WXjuj
         SWbw==
X-Gm-Message-State: ACgBeo006JK/KimUZlSdhZBCXj2tSrRkbP4vkblEyWwhDB8SARBbCNHF
        0fdaU9TxE8AnDKT2xt5YTigY/w==
X-Google-Smtp-Source: AA6agR4VL90LrNjDhIEWa1qfqaZidElIQRHhTojkDkxNcgkza16BHoEv97dS7nqEJj1crC25CK3RMw==
X-Received: by 2002:a17:90b:3849:b0:1f4:89bb:14dc with SMTP id nl9-20020a17090b384900b001f489bb14dcmr3665168pjb.144.1660835652623;
        Thu, 18 Aug 2022 08:14:12 -0700 (PDT)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id y17-20020a17090322d100b00172938b2376sm1554793plg.74.2022.08.18.08.14.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 18 Aug 2022 08:14:10 -0700 (PDT)
Date:   Thu, 18 Aug 2022 15:14:06 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Vitaly Kuznetsov <vkuznets@redhat.com>
Cc:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        Anirudh Rayabharam <anrayabh@linux.microsoft.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Maxim Levitsky <mlevitsk@redhat.com>,
        Nathan Chancellor <nathan@kernel.org>,
        Michael Kelley <mikelley@microsoft.com>,
        linux-hyperv@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v5 01/26] KVM: x86: hyper-v: Expose access to debug MSRs
 in the partition privilege flags
Message-ID: <Yv5XPnSRwKduznWI@google.com>
References: <20220802160756.339464-1-vkuznets@redhat.com>
 <20220802160756.339464-2-vkuznets@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220802160756.339464-2-vkuznets@redhat.com>
X-Spam-Status: No, score=-14.4 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,FSL_HELO_FAKE,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Aug 02, 2022, Vitaly Kuznetsov wrote:
> For some features, Hyper-V spec defines two separate CPUID bits: one
> listing whether the feature is supported or not and another one showing
> whether guest partition was granted access to the feature ("partition
> privilege mask"). 'Debug MSRs available' is one of such features. Add
> the missing 'access' bit.
> 
> Note: hv_check_msr_access() deliberately keeps checking
> HV_FEATURE_DEBUG_MSRS_AVAILABLE bit instead of the new HV_ACCESS_DEBUG_MSRS
> to not break existing VMMs (QEMU) which only expose one bit. Normally, VMMs
> should set either both these bits or none.

This is not the right approach long term.  If KVM absolutely cannot unconditionally
switch to checking HV_ACCESS_DEBUG_MSRS because it would break QEMU users, then we
should add a quirk, but sweeping the whole thing under the rug is wrong.
