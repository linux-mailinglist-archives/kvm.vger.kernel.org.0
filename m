Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9A25E71F155
	for <lists+kvm@lfdr.de>; Thu,  1 Jun 2023 20:05:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232421AbjFASFA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 1 Jun 2023 14:05:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47658 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232164AbjFASEx (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 1 Jun 2023 14:04:53 -0400
Received: from mail-pl1-x64a.google.com (mail-pl1-x64a.google.com [IPv6:2607:f8b0:4864:20::64a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6D88418C
        for <kvm@vger.kernel.org>; Thu,  1 Jun 2023 11:04:52 -0700 (PDT)
Received: by mail-pl1-x64a.google.com with SMTP id d9443c01a7336-1b031a8fbe5so5414575ad.2
        for <kvm@vger.kernel.org>; Thu, 01 Jun 2023 11:04:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1685642692; x=1688234692;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=efFhcI9QiJJlyiXbBpdpKvDvm23k7AyskbJFQ1uKZ7w=;
        b=qBMI7+8PByQ26gmjTNFpl5OS+p9zL4Bm8vUg1wsBHVDIMcf2t6c89urPLcbI/PxUGP
         131NtdXZg/BwyvSWQqyYDwHPhGflmy2+WkaGmE+muB8yG1NoSvSfozQr4CCgW+uWbeER
         2GV+aYCGMf3Rw5CNJrMJIVSvoCWPiN/RwHlMdm+sTMT55M3pLCyaholQqcz3wY0qcvHO
         8ymSDCLyRknAnkR6DPNzpu5jEu+Hb4YitGPw/sguqval3CxB9SThUCyOV0Rts3bzT4eH
         E4CyNUcvuspktTikCVPDMl9PqxOKWePCVYXd8p/VYUcThizQJJROGnVWgKE7wMZW9sJ8
         saYA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685642692; x=1688234692;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=efFhcI9QiJJlyiXbBpdpKvDvm23k7AyskbJFQ1uKZ7w=;
        b=akKF/Z58A/V7WtaknmT1nQmlnXGUFybMzRlfhyXkRWLYbZAT1LKBt4VTn6hGLEMiIV
         P8QcR+g9r/9rzcQO0tSwiE10gg/kFJnQGLWMfI4vbHk3nA+a34wZiUPriDbm6GAoBLAr
         lN+sO6RFgOzk3/1xwMPozbszi86iSqEEsJ3AEeJ3lNuD/HNesCbaX24f2au2NkvOM5YE
         ohp6wu+4VS0GdlXL7vKtTnSTaK/cn+aB9cDdPo6gMnhJ0DY+xEQaPJRazA92fFdn8bsB
         1ShObs9iBHuGKA6uH4eZZaA4JE7rUk1Z+6HREX5Lcg4BVl+78kshf+AW86GyNmMlyFpr
         XVdA==
X-Gm-Message-State: AC+VfDzJ+oIl7hk4L7efKUAT0pnQB+LGCmM6nUAhsvBxtrcRxGf9qRZz
        cDfrevas7S1QPkpk7WPjceaf0NhvkEQ=
X-Google-Smtp-Source: ACHHUZ70fHIYCH1V8hLAwmSV1wOcIYsKxXA/hGoZLaWx/5dd7PLqjgqJnn3MpQExpWKJIlEYEs7fpcsP0qs=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:903:2449:b0:1ae:83eb:eaa with SMTP id
 l9-20020a170903244900b001ae83eb0eaamr74757pls.0.1685642691862; Thu, 01 Jun
 2023 11:04:51 -0700 (PDT)
Date:   Thu, 1 Jun 2023 11:04:43 -0700
In-Reply-To: <af74ae7c-ae81-38ed-97bb-75e39088d4ef@maciej.szmigiero.name>
Mime-Version: 1.0
References: <be4ca192eb0c1e69a210db3009ca984e6a54ae69.1684495380.git.maciej.szmigiero@oracle.com>
 <ZGebCSwAA4W10atN@google.com> <af74ae7c-ae81-38ed-97bb-75e39088d4ef@maciej.szmigiero.name>
Message-ID: <ZHjdu2CQU8RytUr7@google.com>
Subject: Re: [PATCH] KVM: SVM: vNMI pending bit is V_NMI_PENDING_MASK not V_NMI_BLOCKING_MASK
From:   Sean Christopherson <seanjc@google.com>
To:     "Maciej S. Szmigiero" <mail@maciej.szmigiero.name>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Maxim Levitsky <mlevitsk@redhat.com>,
        Santosh Shukla <santosh.shukla@amd.com>, vkuznets@redhat.com,
        jmattson@google.com, thomas.lendacky@amd.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="us-ascii"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Jun 01, 2023, Maciej S. Szmigiero wrote:
> On 19.05.2023 17:51, Sean Christopherson wrote:
> > On Fri, May 19, 2023, Maciej S. Szmigiero wrote:
> > > From: "Maciej S. Szmigiero" <maciej.szmigiero@oracle.com>
> > > 
> > > While testing Hyper-V enabled Windows Server 2019 guests on Zen4 hardware
> > > I noticed that with vCPU count large enough (> 16) they sometimes froze at
> > > boot.
> > > With vCPU count of 64 they never booted successfully - suggesting some kind
> > > of a race condition.
> > > 
> > > Since adding "vnmi=0" module parameter made these guests boot successfully
> > > it was clear that the problem is most likely (v)NMI-related.
> > > 
> > > Running kvm-unit-tests quickly showed failing NMI-related tests cases, like
> > > "multiple nmi" and "pending nmi" from apic-split, x2apic and xapic tests
> > > and the NMI parts of eventinj test.
> > > 
> > > The issue was that once one NMI was being serviced no other NMI was allowed
> > > to be set pending (NMI limit = 0), which was traced to
> > > svm_is_vnmi_pending() wrongly testing for the "NMI blocked" flag rather
> > > than for the "NMI pending" flag.
> > > 
> > > Fix this by testing for the right flag in svm_is_vnmi_pending().
> > > Once this is done, the NMI-related kvm-unit-tests pass successfully and
> > > the Windows guest no longer freezes at boot.
> > > 
> > > Fixes: fa4c027a7956 ("KVM: x86: Add support for SVM's Virtual NMI")
> > > Signed-off-by: Maciej S. Szmigiero <maciej.szmigiero@oracle.com>
> > 
> > Reviewed-by: Sean Christopherson <seanjc@google.com>
> > 
> 
> I can't see this in kvm/kvm.git trees or the kvm-x86 ones on GitHub -
> is this patch planned to be picked up for -rc5 soon?
> 
> Technically, just knowing the final commit id would be sufficit for my
> purposes.

If Paolo doesn't pick it up by tomorrow, I'll apply it and send a fixes pull
request for -rc5.
