Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EFD875AA162
	for <lists+kvm@lfdr.de>; Thu,  1 Sep 2022 23:13:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234011AbiIAVNg (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 1 Sep 2022 17:13:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51410 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234623AbiIAVNd (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 1 Sep 2022 17:13:33 -0400
Received: from mail-oa1-x30.google.com (mail-oa1-x30.google.com [IPv6:2001:4860:4864:20::30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C7ABA8E4C1
        for <kvm@vger.kernel.org>; Thu,  1 Sep 2022 14:13:32 -0700 (PDT)
Received: by mail-oa1-x30.google.com with SMTP id 586e51a60fabf-11e9a7135easo320297fac.6
        for <kvm@vger.kernel.org>; Thu, 01 Sep 2022 14:13:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date;
        bh=s3YP/G49fM/Y7AAkh3BQLrT9w+DYN0rWK2mog9WKUQI=;
        b=seTbvoadCOx8zLoFZ3UlN7zO9Qd2nQyjqfN6FbJRoAPWKoBxFfK99LZK2nESbZvQm4
         E1AyX7vSDbRY3+wZWnpuhh4Jfjq4ft3MGlymzc+PvFvDxev8cNYHKShpkFo/CIQVXPcL
         3gBGs33hTZngFpD1iYGlwsZUP+r98NPI5ZSXaVwGRCkmJabnjIldQgecxdcIRROPJYFd
         K2qIn8nm0Zg17/dCyXbtcVlNCVlyGhs5BgCw1ds/xUw0qwAa9Rq7kWatfb1izk1yjSAm
         NleTPRdgUEgFyOL2qpqZtbkVkXtfWymW78YkYUHWzATBuvwWBJtX53bFYxOtHnx3az4/
         p7UQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date;
        bh=s3YP/G49fM/Y7AAkh3BQLrT9w+DYN0rWK2mog9WKUQI=;
        b=rRwe23wSZoX5r9guOFED+FZHmYDMBxLQa42TEAc43IRekOK+VET9iP1XL9BrlYBOLE
         raL98ho/HEgpg7RlGU/Fq7f+oTD1KhzfN0hMJZC2lXfTCxawFfFo2UoSh+wPVayWiAE0
         Ea2l4jWA5LQH5v2K13zaVY45GSJCrpl3/UD1e9wanvRfNpM1u05WOBrz9z0TlGLo6NQT
         8DFEid8lDw+In1yXcBk0utKHQhBZMyKpfsayhGK1/MNNmMfLVO43Fw1/VcajxkCHmqZ1
         yoBR5oMHgjklxtZ+PbmadDR2AlWZNzEB2p4R507IM4sisMVfRUNzPd2rjYYq1dZtmhHL
         Bieg==
X-Gm-Message-State: ACgBeo32NmLpVv7O+s1cufDxzAMatStRaJKK/mKZhzRJ2w9vjlvX4svz
        j+pwOR6svGXRSaksYYgtqMOvBTCbWDjRv5GXtGVZRw==
X-Google-Smtp-Source: AA6agR7rI+mWvl/3lX7XXDOjn4pDkkVMOXENRZAXKurcVmgUPXFO3foZFRrFHQD7xMtM/oBbXhq4dO48ZF6cxIy9CpU=
X-Received: by 2002:a05:6870:5a5:b0:122:5662:bee6 with SMTP id
 m37-20020a05687005a500b001225662bee6mr579105oap.181.1662066811990; Thu, 01
 Sep 2022 14:13:31 -0700 (PDT)
MIME-Version: 1.0
References: <20220831211810.2575536-1-jmattson@google.com> <YxDfZwKAlH6KBhoH@google.com>
In-Reply-To: <YxDfZwKAlH6KBhoH@google.com>
From:   Jim Mattson <jmattson@google.com>
Date:   Thu, 1 Sep 2022 14:13:21 -0700
Message-ID: <CALMp9eQo9zYjh8xqtMp_JWOSMCd1cBuqbCo2KAPTLWaroB8MWw@mail.gmail.com>
Subject: Re: [PATCH v2] x86/cpufeatures: Add macros for Intel's new fast rep
 string features
To:     Sean Christopherson <seanjc@google.com>
Cc:     Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
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

On Thu, Sep 1, 2022 at 9:36 AM Sean Christopherson <seanjc@google.com> wrote:
>
> On Wed, Aug 31, 2022, Jim Mattson wrote:
> > KVM_GET_SUPPORTED_CPUID should reflect these host CPUID bits. The bits
>
> Why not provide the KVM support in the same patch/series?
>
Coming up.
