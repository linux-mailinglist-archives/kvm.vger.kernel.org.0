Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C54D8610614
	for <lists+kvm@lfdr.de>; Fri, 28 Oct 2022 01:05:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235016AbiJ0XFB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 27 Oct 2022 19:05:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50952 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235028AbiJ0XE6 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 27 Oct 2022 19:04:58 -0400
Received: from mail-pf1-x433.google.com (mail-pf1-x433.google.com [IPv6:2607:f8b0:4864:20::433])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A310F25EAA
        for <kvm@vger.kernel.org>; Thu, 27 Oct 2022 16:04:54 -0700 (PDT)
Received: by mail-pf1-x433.google.com with SMTP id g62so3233440pfb.10
        for <kvm@vger.kernel.org>; Thu, 27 Oct 2022 16:04:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=p29KsZ6GZle3kQbNEFvbReD8ZLO1IYq4VI3X5ZbUWPI=;
        b=l7kc7JNlc2WI+vxSHQCsChDHJoXD3uZ+1ux60z28u2InhnRXLTg8gu2AE2uUJbuz5G
         V1WOY15YRtfqyG9AcpDj33IvcMDJK3aCtCTTfE+3ZCFeilbLV8vkN8ZvakqHWa2T39c+
         UkE7AuOiDyg70rKKM8Y+efP47ZfrHHGOSQvz1BcgNXP0hD6pkCXkeCA23rzOI+x8Lefn
         DfbwC+ubztPLOLjkvS2QTLK1RGz+LpxV+8LmPpnFP/WNk3lqrbbHxwPq9R+WeVAlvipl
         uKAareQt7hGlxMTscaZjj6xMHMQkDnXOwvtY0IPTbW4ZAg3DCgVcQEMFVZXBO0kh0Qfw
         dA3w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=p29KsZ6GZle3kQbNEFvbReD8ZLO1IYq4VI3X5ZbUWPI=;
        b=w7Re2UwQjGLQNAfWd/3goqJ/r/imPD8C51AHQPmVV5AzXhfAe8EwzFmmlf9CPGOcWt
         UWK0Ah5fhj7E4kLrjZGuO4Fbi14vFXCKIdY48FkvaHHxqOMtbrPU8BcEWSRs3xZxasZj
         GpqDTTjLxyFFo3MEKU+lxn3XnzZrU4VKNiZQcJ3fCiDhzGqE+pXSHqf54rV1jBEtPrBQ
         fL3Kfgkuw+g/lceO5kQ4pnAThYtYg00MY1TDrfNFZAQ3VqGu+zPOY8dX1wfOqz1YenHn
         5zRXU1qTQRVQztZ74VnMT65h1T+K2lp1u1kbDqdVfKNxQZrEKrxaQRE0yUIIyme+UckZ
         vzuw==
X-Gm-Message-State: ACrzQf0XEIKDFRZpjomzg4+KQ8PCfAL0XL0Ph+n8D9G/E6h+78ojzfpD
        5pfXG6hiQ/xi4Pj49iyH8Zddxg==
X-Google-Smtp-Source: AMsMyM5KRLfXI+mo4uk28sURlKWAMcDSd8OOPaB3DxwckC1J4gRPAxI09+yK7tCTT4gEYKzU+M6myw==
X-Received: by 2002:a63:4c05:0:b0:46f:3dfb:98a1 with SMTP id z5-20020a634c05000000b0046f3dfb98a1mr10963949pga.30.1666911893662;
        Thu, 27 Oct 2022 16:04:53 -0700 (PDT)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id t9-20020a62d149000000b0052d4cb47339sm1652169pfl.151.2022.10.27.16.04.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 27 Oct 2022 16:04:53 -0700 (PDT)
Date:   Thu, 27 Oct 2022 23:04:50 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     David Matlack <dmatlack@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org
Subject: Re: [PATCH 1/2] KVM: Keep track of the number of memslots with dirty
 logging enabled
Message-ID: <Y1sOklfZTcGXsRjZ@google.com>
References: <20221027200316.2221027-1-dmatlack@google.com>
 <20221027200316.2221027-2-dmatlack@google.com>
 <Y1rrcOcUJMo/VFSK@google.com>
 <CALzav=cMvsSevxS2zT6-bd+4EBFO1Jk5Y6=_6W7PsHhnW5uDeQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CALzav=cMvsSevxS2zT6-bd+4EBFO1Jk5Y6=_6W7PsHhnW5uDeQ@mail.gmail.com>
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

On Thu, Oct 27, 2022, David Matlack wrote:
> On Thu, Oct 27, 2022 at 1:35 PM Sean Christopherson <seanjc@google.com> wrote:
> >
> > On Thu, Oct 27, 2022, David Matlack wrote:
> > > Add a new field to struct kvm that keeps track of the number of memslots
> > > with dirty logging enabled. This will be used in a future commit to
> > > cheaply check if any memslot is doing dirty logging.
> > >
> > > Signed-off-by: David Matlack <dmatlack@google.com>
> > > ---
> > >  include/linux/kvm_host.h |  2 ++
> > >  virt/kvm/kvm_main.c      | 10 ++++++++++
> >
> > Why put this in common code?  I'm having a hard time coming up with a second use
> > case since the count isn't stable, i.e. it can't be used for anything except
> > scenarios like x86's NX huge page mitigation where a false negative/positive is benign.
> 
> I agree, but what is the downside of putting it in common code?

The potential for misuse, e.g. outside of slots_lock.

> The downside of putting it in architecture-specific code is if any other
> architecture needs it (or something similar) in the future they are unlikely
> to look through x86 code to see if it already exists. i.e.  we're more likely
> to end up with duplicate code.
>
> And while the count is not stable outside of slots_lock, it could
> still theoretically be used under slots_lock to coordinate something
> that depends on dirty logging being enabled in any slot. In our
> internal kernel, for example, we use it to decide when to
> create/destroy the KVM dirty log worker threads (although I doubt that
> specific usecase will ever see the light of day upstream :).

Yeah, I'm definitely not dead set against putting it in common code.  I suspect
I'm a little overly sensitive at the moment to x86 pushing a bunch of x86-centric
logic into kvm_main.c and making life miserable for everyone.  Been spending far
too much time unwinding the mess that is kvm_init()...
