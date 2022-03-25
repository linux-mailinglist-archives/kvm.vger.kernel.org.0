Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3057A4E7DFD
	for <lists+kvm@lfdr.de>; Sat, 26 Mar 2022 01:23:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232173AbiCYUYS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 25 Mar 2022 16:24:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53014 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232168AbiCYUYR (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 25 Mar 2022 16:24:17 -0400
Received: from mail-pg1-x536.google.com (mail-pg1-x536.google.com [IPv6:2607:f8b0:4864:20::536])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 26C4766CBD
        for <kvm@vger.kernel.org>; Fri, 25 Mar 2022 13:22:42 -0700 (PDT)
Received: by mail-pg1-x536.google.com with SMTP id w21so7297602pgm.7
        for <kvm@vger.kernel.org>; Fri, 25 Mar 2022 13:22:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=cSxVhb71z+Ee83vpaUYArlMABtaVLB8rzZSlwyaMw5Y=;
        b=KOZWScWPx5LRthiYDgPnYHcm3/Fe4PAO4T9J+5Ol7Lm1rlbLvP/B0+KyVQD0rTaF4p
         wv1DwFSBGhrVba45FhNgBzQR9lUWbJdjYBQFxGsFehV0gt2yQaxXxse/HodR5w2iwy3A
         HXijCz6A3szsLmM4fRii8V1p21M+LerdSCjeJ6TLY6BTSHwXIF/eM81Hm54tc57e+vc7
         RYZquCLfJGxGsk2HVd54V83PUA0kNwSwY8lXY4Yri9PDAMlQAjHnFHHh+sKoNVrjLLvm
         bWUBTDaW95QQFMlT8iHYvpphTo4tRtUP2EFSiLdeeEiIJdX0sROyhBDyPYgj7qbhA+nP
         Zu7Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=cSxVhb71z+Ee83vpaUYArlMABtaVLB8rzZSlwyaMw5Y=;
        b=EvJZwzHk+lGlvI7vc+j2TDNBgBPaQk8prh4edYOM83/wXsLsm4ReErW5I/wDSZP3nm
         SBV/IJbad/gKYAaM+l+rJpo0GNZJ7WKYimQhrtjOey/8VQKLr8Evii7+UAxivgBUcoYs
         l6QiGA7AcYEX72hVvPh9cPnlAuNQS6FGnWjJs4ICy5/QlWB+1eAbVpVtO+SrJs8ESMG+
         38JLk2mgZ9IR+TtAn3ibgBsPfdCfIk3zW7hr0lgXKdR4YZ8y6eSeKWqf0HJo8zD4hQGy
         aiMbKCWBNbZ2oG9BGzyU2McqrHgvpQ9iDOOj1LQfNAvcMQr1j4vkskl6pKL04sEVvPLK
         69DQ==
X-Gm-Message-State: AOAM533MbfBDM0L7yGpJRu2pOIoWVhgUCOuY6WVXYSw1mrJpqsxVqyKW
        i31n5n1ND65nZqRfBPuywOwpeA==
X-Google-Smtp-Source: ABdhPJzsYhW4Lj1IXnf4NIGQcY6MlWE3y8J/vp4aaF0mlpwG6vx59jXFeTzBbZah9AjymJqdXjJkyg==
X-Received: by 2002:a63:4859:0:b0:381:ede3:9af0 with SMTP id x25-20020a634859000000b00381ede39af0mr1013244pgk.87.1648239761482;
        Fri, 25 Mar 2022 13:22:41 -0700 (PDT)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id gb5-20020a17090b060500b001c6d46f7e75sm13815829pjb.30.2022.03.25.13.22.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 25 Mar 2022 13:22:40 -0700 (PDT)
Date:   Fri, 25 Mar 2022 20:22:37 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>
Subject: Re: [FYI PATCH] Revert "KVM: x86/mmu: Zap only TDP MMU leafs in
 kvm_zap_gfn_range()"
Message-ID: <Yj4kjRSuBDfupRqW@google.com>
References: <20220318164833.2745138-1-pbonzini@redhat.com>
 <d6367754-7782-7c29-e756-ac02dbd4520b@redhat.com>
 <Yj0FYSC2sT4k/ELl@google.com>
 <78e3f054-829e-b00d-6c65-9ae622f301df@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <78e3f054-829e-b00d-6c65-9ae622f301df@redhat.com>
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

On Fri, Mar 25, 2022, Paolo Bonzini wrote:
> On 3/25/22 00:57, Sean Christopherson wrote:
> > Can I have 1-2 weeks to try and root cause and fix the underlying issue before
> > sending reverts to Linus?  I really don't want to paper over a TLB flushing bug
> > or an off-by-one bug, and I really, really don't want to end up with another
> > scenario where KVM zaps everything just because.
> 
> Well, too late...  I didn't want to send a pull request that was broken,

Ah, I didn't see that it was in the initial pull request, thought it was only in
kvm/next.  I'll send a full patch.

> Mingwei provided a convincing reason for the breakage.

No, the side effects are completely benign, and arguably desirable.  The issue is
that KVM loses a pending TLB flush if there are multiple roots.
