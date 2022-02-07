Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 960394AC549
	for <lists+kvm@lfdr.de>; Mon,  7 Feb 2022 17:18:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237463AbiBGQRU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 7 Feb 2022 11:17:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50232 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232653AbiBGQKE (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 7 Feb 2022 11:10:04 -0500
Received: from mail-pj1-x102b.google.com (mail-pj1-x102b.google.com [IPv6:2607:f8b0:4864:20::102b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E3983C0401D1
        for <kvm@vger.kernel.org>; Mon,  7 Feb 2022 08:10:02 -0800 (PST)
Received: by mail-pj1-x102b.google.com with SMTP id y9so5685470pjf.1
        for <kvm@vger.kernel.org>; Mon, 07 Feb 2022 08:10:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=xiSBzPQnTG+yIHuJ7k7x6ADsNTF+1w12491gzVcMAFE=;
        b=ZbB3crbAr+DzqHrDW5Wa8yEKGFB41seBarYw/+E5gPl3dirtURFGGzZ5zhYw3d1vg5
         FdW1Gih98v5ar8dHJBsPRS7twDQgTBUtxRh3/aLC4PuerU5TfB9hvDDGxs+xE72BGbe8
         vxo84b+Mkfy5EU/P6GHDHkw5M3Ukn9Kn1G8ZOlG4BGoNjSCXabmc0C3yMadA5vBZmddf
         vU8HLzOLMQeRJTdxuj/Uzzqx62U4WyDC4oMoJM6mJEQ/NP2wOOiN/Q59NINXhQ0cdnJM
         R4H9/dJBXlmZTjjEn/6KotsLQzQGNfMutC0lPaHyHoSpVj6AmKHbmSJVa2+pwlNVhEuQ
         l6pw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=xiSBzPQnTG+yIHuJ7k7x6ADsNTF+1w12491gzVcMAFE=;
        b=7D2z8Om0OfOCs5S6wzq5kMKIZ4LkL6Vnh1GsSRnqPfh1cC7tjt6ayPNmSjzCwBMQR1
         lTPsf86fO2NDGhR33Iv8isWLwXwUy6gNJHkgVpQ6lFAqM5JE0WsqO51LOuFLzWxA/9SS
         49VFshieF2brTABDjG58l/+LYRaYSV3EnOCDWEzoOcNCxVvQoNHJ2tsxytN9yMtLeN78
         qGn+Cia/tNo/t+Hx336JVTtWVPUiMHLbvNInObr64i8CxdQTh9iC5JGw+QtqMHsFfspZ
         Z4F4I8K6wKEibv3PsSL7GGYB/cuzKoAJpPDFFq9ln7Oot0vBe9DDSkxbwxqBVNqfkEH/
         UQgg==
X-Gm-Message-State: AOAM5339ZvUBl/j8/L+BI9LhRFyxf4+wUxGV7CGy0COF1zbL+GNhFFP5
        zkvjlNMLCaj9CotdZfaVTXNshk/gbrHOxw==
X-Google-Smtp-Source: ABdhPJwRrTS8wrHCH7GEaOUas2bOM2kxOBaDos9y+CXKADhOyp3DgXUB0Ig+/gcWE2Wba/Q7POrZhw==
X-Received: by 2002:a17:90b:2251:: with SMTP id hk17mr19523346pjb.210.1644250202261;
        Mon, 07 Feb 2022 08:10:02 -0800 (PST)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id s32sm6788998pfw.80.2022.02.07.08.10.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 07 Feb 2022 08:10:01 -0800 (PST)
Date:   Mon, 7 Feb 2022 16:09:58 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     David Matlack <dmatlack@google.com>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, vkuznets@redhat.com
Subject: Re: [PATCH 01/23] KVM: MMU: pass uses_nx directly to
 reset_shadow_zero_bits_mask
Message-ID: <YgFEVr9NM1vXdexg@google.com>
References: <20220204115718.14934-1-pbonzini@redhat.com>
 <20220204115718.14934-2-pbonzini@redhat.com>
 <Yf1pk1EEBXj0O0/p@google.com>
 <8081cbe5-6d12-9f99-9f0f-13c1d7617647@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8081cbe5-6d12-9f99-9f0f-13c1d7617647@redhat.com>
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

On Sat, Feb 05, 2022, Paolo Bonzini wrote:
> On 2/4/22 18:59, David Matlack wrote:
> > > +	reset_shadow_zero_bits_mask(vcpu, context, is_efer_nx(context));
> > 
> > Out of curiousity, how does KVM mitigate iTLB multi-hit when shadowing
> > NPT and the guest has not enabled EFER.NX?
> 
> You got me worried for a second but iTLB multihit is Intel-only, isn't it?

AFAIK, yes, big Core only.  arch/x86/kernel/cpu/common.c sets NO_ITLB_MULTIHIT
for all AMD, Hygon, and Atom CPUs.
