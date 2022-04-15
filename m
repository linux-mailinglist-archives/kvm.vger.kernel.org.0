Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3EEF6502E12
	for <lists+kvm@lfdr.de>; Fri, 15 Apr 2022 18:59:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1356032AbiDORAT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 15 Apr 2022 13:00:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47604 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233533AbiDORAS (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 15 Apr 2022 13:00:18 -0400
Received: from mail-pg1-x52c.google.com (mail-pg1-x52c.google.com [IPv6:2607:f8b0:4864:20::52c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 375FBC6EEE
        for <kvm@vger.kernel.org>; Fri, 15 Apr 2022 09:57:46 -0700 (PDT)
Received: by mail-pg1-x52c.google.com with SMTP id t13so7733035pgn.8
        for <kvm@vger.kernel.org>; Fri, 15 Apr 2022 09:57:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=jrQ3dR+2kAvaP6gd4RsffOdz7Sc1X4eisr7NpQ4z6iQ=;
        b=Nr3qvTEZ+iMmiDsRBd3RdnJd4qpxKNKdASPMjoL4h/E7rLHB9PsBWX0YA7GvRTTxoC
         RlWILuyHy+UvwLCusy+tCFhg8IRlMxh4MJQ5h4WTPJEKXDECb8z3HUUPVZHwnSpytnt+
         5LRItdTwrx4GThx+kqi1GhAcd3bgpdWCGC7mfuKa1rZFefIIcmNDSfDWL1NzPu3XPaX0
         ttFoM0N5g9xrXRplbmzhWbqHcn3PD67LdcmvIiNel2/IZOkk6f78Pwj7zQV29Lvp/Ket
         Dy7d2i6hHkJu+hMgiJuc5T3bw4HD4TnDFwICQWSb5IzdAPGBlyHZd2B0A2QhFzU5XGkj
         XCVg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=jrQ3dR+2kAvaP6gd4RsffOdz7Sc1X4eisr7NpQ4z6iQ=;
        b=aluvbUCsO+JSI7sinyTwIHOoIPnPnVjNpywDaijfY/hSO7e0DcEUC59EcXadRCdZhM
         2nS1gNRq/klp8d1JYRyYrOxFuTvAaf98qegoFY3q4BZO+iV0jE23FwlBVy5XKMpvpS0q
         v7t1GZBM0xOoAeUDxOnxDgTYNAINeZ6rs4vNzeO6XfKrQleDYLF/nsZ3Amid7uTEeTVw
         7jDEIMJ802YcbKoLc1GQln9dpFXOdyn4yI0u7LyF4GqraBq23azrsmRMe4lDD1Yf+dSO
         HLkTkRg/DNK4nyIFgv6Psn18iyBlX21Y87ifH3o/+wGZzJoXanceTRj5NithFLjYKO0d
         AGRw==
X-Gm-Message-State: AOAM533fk2Yg3KU8Nz7j3uz2ZQ8ulvbbH5cf+RwF5BC+s0Uo0/Br7J8B
        z6qUEtngOu1fw9JhkVtSNqIEwQ==
X-Google-Smtp-Source: ABdhPJw4RCYieh6f+M2xB6AJaHauGAUcYPXy81P95pdlXyDjMxFae8RJRypprFtujojIl+yGqaAG6A==
X-Received: by 2002:a05:6a00:10d0:b0:4f7:5af4:47b6 with SMTP id d16-20020a056a0010d000b004f75af447b6mr20740533pfu.6.1650041865536;
        Fri, 15 Apr 2022 09:57:45 -0700 (PDT)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id h7-20020aa786c7000000b00505bf336385sm3323883pfo.124.2022.04.15.09.57.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 15 Apr 2022 09:57:44 -0700 (PDT)
Date:   Fri, 15 Apr 2022 16:57:40 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Joerg Roedel <jroedel@suse.de>
Cc:     Varad Gautam <varad.gautam@suse.com>, kvm@vger.kernel.org,
        pbonzini@redhat.com, drjones@redhat.com, marcorr@google.com,
        zxwang42@gmail.com, erdemaktas@google.com, rientjes@google.com,
        brijesh.singh@amd.com, Thomas.Lendacky@amd.com, bp@suse.de
Subject: Re: [kvm-unit-tests PATCH v3 11/11] x86: AMD SEV-ES: Handle string
 IO for IOIO #VC
Message-ID: <YlmkBLz4udVfdpeQ@google.com>
References: <20220224105451.5035-1-varad.gautam@suse.com>
 <20220224105451.5035-12-varad.gautam@suse.com>
 <Ykzx5f9HucC7ss2i@google.com>
 <Yk/nid+BndbMBYCx@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Yk/nid+BndbMBYCx@suse.de>
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

On Fri, Apr 08, 2022, Joerg Roedel wrote:
> On Wed, Apr 06, 2022 at 01:50:29AM +0000, Sean Christopherson wrote:
> > On Thu, Feb 24, 2022, Varad Gautam wrote:
> > > Using Linux's IOIO #VC processing logic.
> > 
> > How much string I/O is there in KUT?  I assume it's rare, i.e. avoiding it entirely
> > is probably less work in the long run.
> 
> The problem is that SEV-ES support will silently break if someone adds
> it unnoticed and without testing changes on SEV-ES.

But IMO that is extremely unlikely to happen.  objdump + grep shows that the only
string I/O in KUT comes from the explicit asm in emulator.c and amd_sev.c.  And
the existence of amd_sev.c's version suggests that emulator.c isn't supported.
I.e. this is being added purely for an SEV specific test, which is silly.

And it's not like we're getting validation coverage of the exit_info, that also
comes from software in vc_ioio_exitinfo().

Burying this in the #VC handler makes it so much harder to understand what is
actually be tested, and will make it difficult to test the more interesting edge
cases.  E.g. I'd really like to see a test that requests string I/O emulation for
a buffer that's beyond the allowed size, straddles multiple pages, walks into
non-existent memory, etc.., and doing those with a direct #VMGEXIT will be a lot
easier to write and read then bouncing through the #VC handler.
