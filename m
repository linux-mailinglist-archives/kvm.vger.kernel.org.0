Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C278E54B33D
	for <lists+kvm@lfdr.de>; Tue, 14 Jun 2022 16:34:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344934AbiFNObg (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 14 Jun 2022 10:31:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52170 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344364AbiFNObd (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 14 Jun 2022 10:31:33 -0400
Received: from mail-pl1-x631.google.com (mail-pl1-x631.google.com [IPv6:2607:f8b0:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 11FB5396BC
        for <kvm@vger.kernel.org>; Tue, 14 Jun 2022 07:31:33 -0700 (PDT)
Received: by mail-pl1-x631.google.com with SMTP id i1so7902641plg.7
        for <kvm@vger.kernel.org>; Tue, 14 Jun 2022 07:31:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=8wgnDbW6NGQNGKOrZNLtKpgaJzK7o8Ip4VysdMD2fJo=;
        b=h9FRnHKHUsz5BuVrVVD4chBYaw1pIKvY6OGId4hNo59q52AS95tAEtTZGpCR52o+H1
         XjJEDblkPdPP/p74VQkeRhn70ZeP5grzOx2U21UqKToKdr7C2GSLdnthmxRIi88uOsun
         wFGODbHHMtgEOhsDpBTSI8QQD3H80oJrGcnyaT04U4gOAHVA4+JWC7RFb9SOl1GXzYCB
         rSUSyfT6P2rfB5mEJDVN6IVquonTii5PpI8Z5TOeDQqc9p9r3vxzAFhdCxy0ed7Qi//X
         gpC+Ph6H24yvEziAn6fkbeBHmp2Cz1cRLcQBEc+YTip0UazS4jGf5fi2avPm8Cnve8Km
         wnVg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=8wgnDbW6NGQNGKOrZNLtKpgaJzK7o8Ip4VysdMD2fJo=;
        b=1eMF9xk5uwxAo9DBW5w0it+usywNm8x23blU7PvyHJjo1NP6lORNz/IAU8Ng4vBLDw
         NM24aBMVmJtc52f7OqK/QV+mPT90U0qOROkpHJK0GmildotQwFeGNAPxnNMQqlq1iGGK
         BrKoa6R1s8HTlPG+p8/BIzDyczqa3Pg2a8QrHuruUuQtZVXT1tSrUNlD2zGTqf5I1PK4
         OVJFic7Ac1D1zwrLjYkKdEnea6OEe8Rq4nUQAF+5QEVGXmUaJSklzQeGD+iqOriuTmhN
         llR8ag3whBChLwmZrSxTVrCQfCcyu7UejUoFeEhR4EqjqwvS/nmB5XFnmajQBmhHcTcZ
         GYsw==
X-Gm-Message-State: AJIora/PxzXOOeTvngk7bYCbrwlBSau89uSBpEtsjGcBaertjTCZrJ6G
        ZsB4LWN/PaKSgn+btCddgyonIQ==
X-Google-Smtp-Source: AGRyM1tjyXRgWoodAOm08P85asq1len4o2tsDgTGN9csMEnGsrMwvf3L4n9XVEdupJgZwENX///vKw==
X-Received: by 2002:a17:90b:4c4c:b0:1e8:6f9a:b642 with SMTP id np12-20020a17090b4c4c00b001e86f9ab642mr4914312pjb.21.1655217092296;
        Tue, 14 Jun 2022 07:31:32 -0700 (PDT)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id z1-20020a626501000000b0050dc7628183sm7874342pfb.93.2022.06.14.07.31.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 Jun 2022 07:31:31 -0700 (PDT)
Date:   Tue, 14 Jun 2022 14:31:28 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Lai Jiangshan <jiangshanlai@gmail.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        "open list:KERNEL VIRTUAL MACHINE FOR MIPS (KVM/mips)" 
        <kvm@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/8] KVM: x86/mmu: Drop unused CMPXCHG macro from
 paging_tmpl.h
Message-ID: <YqibwNj8ihL3vbel@google.com>
References: <20220613225723.2734132-1-seanjc@google.com>
 <20220613225723.2734132-2-seanjc@google.com>
 <CAJhGHyDjFCJdRjdV-W5+reg-3jiwJAqeCQ7A-vdUqt+dToJBdA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAJhGHyDjFCJdRjdV-W5+reg-3jiwJAqeCQ7A-vdUqt+dToJBdA@mail.gmail.com>
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

On Tue, Jun 14, 2022, Lai Jiangshan wrote:
> On Tue, Jun 14, 2022 at 6:59 AM Sean Christopherson <seanjc@google.com> wrote:
> >
> > Drop the CMPXCHG macro from paging_tmpl.h, it's no longer used now that
> > KVM uses a common uaccess helper to do 8-byte CMPXCHG.
> >
> > Fixes: f122dfe44768 ("KVM: x86: Use __try_cmpxchg_user() to update guest PTE A/D bits")
> > Signed-off-by: Sean Christopherson <seanjc@google.com>
> 
> 
> In https://lore.kernel.org/lkml/20220605063417.308311-2-jiangshanlai@gmail.com/
> two other unused macros are also removed.

I'd prefer to keep them around as it allows using them to generate the other masks
that are used.

My apologies for colliding with your series, I saw it flash by but didn't look at
what it contained.  If it's ok with you, I'll grab patches 1-3 from your series,
tweak patch 1 to drop only CMPXCH, and send them as the basis of v2 for the rest
of the patches in this series.
