Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 205967BFF1A
	for <lists+kvm@lfdr.de>; Tue, 10 Oct 2023 16:24:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232991AbjJJOYD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 10 Oct 2023 10:24:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57936 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232779AbjJJOYC (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 10 Oct 2023 10:24:02 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 41525A7;
        Tue, 10 Oct 2023 07:24:01 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 97E7DC433C8;
        Tue, 10 Oct 2023 14:24:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1696947840;
        bh=ZMkjwEVkqqs+rA35d7AnsBp3tNIb0CuxBAEu1zdtero=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=h7vEvRZNjKQNq244pxQdZZ51LKeXR79TuHRXtPOjfQ3ZTPLk/aCkJ26X2WfdzabN9
         0krYwIEia9K0kLBExdGldfV/dy8Gft7TdWb1RyicsloYaV6HZ+xnDvbB8ALF9wuZDW
         iThwNFusIGObGwsCoH08hjwMeCK7927BiZSphxj8EN6w/p2bYMPXjHFLyzELfZjfGk
         KAjYodr1QNK61eZqNgXmHgJAXsLg6Sd1y1pkVrho6+R+3VI6G/DcnHk0GVb1Vf/2kQ
         ZulTAmhMA6mmVirU5yUxu2QTkZlc2qwjPiZwfyzeRxubsGweEPnqz1dC1EtRNmRseP
         krSkI1O1wPLhQ==
Date:   Tue, 10 Oct 2023 07:23:59 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Jani Nikula <jani.nikula@intel.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        pbonzini@redhat.com, workflows@vger.kernel.org,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Subject: Re: [PATCH] KVM: deprecate KVM_WERROR in favor of general WERROR
Message-ID: <20231010072359.0df918e9@kernel.org>
In-Reply-To: <87sf6i6gzh.fsf@intel.com>
References: <20231006205415.3501535-1-kuba@kernel.org>
        <ZSQ7z8gqIemJQXI6@google.com>
        <20231009110613.2405ff47@kernel.org>
        <ZSRVoYbCuDXc7aR7@google.com>
        <20231009144944.17c8eba3@kernel.org>
        <87sf6i6gzh.fsf@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 10 Oct 2023 11:04:18 +0300 Jani Nikula wrote:
> > If you do invest in build testing automation, why can't your automation
> > count warnings rather than depend on WERROR? I don't understand.  
> 
> Because having both CI and the subsystem/driver developers enable a
> local WERROR actually works in keeping the subsystem/driver clean of
> warnings.
> 
> For i915, we also enable W=1 warnings and kernel-doc -Werror with it,
> keeping all of them warning clean. I don't much appreciate calling that
> anti-social.

Anti-social is not the right word, that's fair.

Werror makes your life easier while increasing the blast radius 
of your mistakes. So you're trading off your convenience for risk
of breakage to others. Note that you can fix issues locally very
quickly and move on. Others have to wait to get your patches thru
Linus.

> >> I disagree.  WERROR simply doesn't provide the same coverage.  E.g. it can't be
> >> enabled for i386 without tuning FRAME_WARN, which (a) won't be at all obvious to
> >> the average contributor and (b) increasing FRAME_WARN effectively reduces the
> >> test coverage of KVM i386.
> >> 
> >> For KVM x86, I want the rules for contributing to be clearly documented, and as
> >> simple as possible.  I don't see a sane way to achieve that with WERROR=y.  
> 
> The DRM_I915_WERROR config depends on EXPERT and !COMPILE_TEST, and to
> my knowledge this has never caused issues outside of i915 developers and
> CI.

Ack, I think you do it right. I was trying to establish a precedent
so that we can delete these as soon as they cause an issue, not sooner.

Whatever tho, there's no accounting for taste.
