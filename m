Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 54E9F636B1F
	for <lists+kvm@lfdr.de>; Wed, 23 Nov 2022 21:31:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239897AbiKWUbV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 23 Nov 2022 15:31:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54940 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235333AbiKWUbF (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 23 Nov 2022 15:31:05 -0500
Received: from mail-pj1-x1034.google.com (mail-pj1-x1034.google.com [IPv6:2607:f8b0:4864:20::1034])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3A592B6B1C
        for <kvm@vger.kernel.org>; Wed, 23 Nov 2022 12:26:32 -0800 (PST)
Received: by mail-pj1-x1034.google.com with SMTP id g5so1656870pjd.4
        for <kvm@vger.kernel.org>; Wed, 23 Nov 2022 12:26:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=943spnH6W3PunjgtbQ7TAbDF+Dbwfg6HK/3avNoQ3To=;
        b=QA1O3+gFRPOt4wk7D8xtvSrlfFrWua+TX7M47T5LFgktR0gfzJNsCdpWGLLq/JNCqS
         hFap/7um0/Tfrr4zYfb290lrAMZCwQe87Wm9dq2CXs4ydD6I72DBR4aG/ek0x8PKC5O4
         5OUoK7+uyNrL1a4PV2UdfosLj0iLVZfuxboT33e8u6KxMcwCO1J1+HMxxu1XTPFyWQXd
         bPz+b9GP2UQgIjTCrry4DTljlhbGPRVIrHnE/A0Y92EDpvfefna43oInGuVOPu93HWB4
         gJ4SKGBqsAphzLqGQhiyDYsCvAroua7NB7V73hmG5RxjYTDYbUD8LFUaNNMW/SZETl0F
         xLFQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=943spnH6W3PunjgtbQ7TAbDF+Dbwfg6HK/3avNoQ3To=;
        b=zobKZ44ZkMIKwm6LCQtbbmGfY4efZbX7Bl//jSBbHqa1LjmSPp9K/ukUEITSFT6Dtw
         jFOxyKYG23pppb5kxrYmRiUVyZK3e3uUIBFkQr3KdVjGgb+UrKjTJ0oK6pF2r+E06FIV
         6gpRmVEi5m6cixQ6NPsFP7PZRQInJJT4+agRxew7/FoN3qvpREmgj0QJAJSkzGllP4+A
         OyFdg0HlZdoEqd3VBp+ZKejPpvQ6MuFMclMR4BcMM0YvgFdioEeIla/xbHevtqvqLVJu
         ilS5s56nVVjrFqauX2c0xrzhV2v/6OSo2DhTdpstxJVkXJy7fItk8JLCzjK/I+6Qehd0
         PV3A==
X-Gm-Message-State: ANoB5plN03N799/yhmUwIZcEBIolL98QH4IsmVtO4D+8ipkcYK7gz7ot
        ZRHXvkAQSE42C9yz29oH6H8f1w==
X-Google-Smtp-Source: AA0mqf49A48IQeFmD7JlsM6FW5dXSjCac6ITgAElrFH84MjAP99qsBZP1BqiXClcNr4oOPnSKyl+yg==
X-Received: by 2002:a17:90a:7003:b0:212:f169:140e with SMTP id f3-20020a17090a700300b00212f169140emr31373407pjk.215.1669235191354;
        Wed, 23 Nov 2022 12:26:31 -0800 (PST)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id y15-20020aa79aef000000b00565cbad9616sm13065886pfp.6.2022.11.23.12.26.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 23 Nov 2022 12:26:31 -0800 (PST)
Date:   Wed, 23 Nov 2022 20:26:27 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     David Woodhouse <dwmw2@infradead.org>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
        mhal@rbox.co
Subject: Re: [PATCH 2/4] KVM: x86/xen: Compatibility fixes for shared
 runstate area
Message-ID: <Y36B811dDGwP6ce9@google.com>
References: <20221119094659.11868-1-dwmw2@infradead.org>
 <20221119094659.11868-2-dwmw2@infradead.org>
 <Y35kwZeS1pXGLNFg@google.com>
 <176c0c26fda9481a4e04c99289bb240a9b3c1ccd.camel@infradead.org>
 <Y351Oz8mrGcaAUMg@google.com>
 <cf0cb246dd25790a839a5cb2188290f680df5d44.camel@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cf0cb246dd25790a839a5cb2188290f680df5d44.camel@infradead.org>
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

On Wed, Nov 23, 2022, David Woodhouse wrote:
> On Wed, 2022-11-23 at 19:32 +0000, Sean Christopherson wrote:
> > Right.  Might be worth adding a comment at some point to call out that disabling
> > IRQs may not be strictly required for all users, but it's done for simplicity.
> > Ah, if/when we add kvm_gpc_lock(), that would be the perfect place to document
> > the behavior.
> 
> Yeah. Or perhaps the kvm_gpc_lock() should go with that 'not required
> for all users, but done for simplicity' angle too, and always disable
> IRQs?

I was thinking the latter (always disable IRQs in kvm_gpc_lock()).  Sorry I didn't
make that clear.  I completely agree that fewer conditionals in this code is better,
I was mostly trying to figure out if there is some edge case I was missing.
