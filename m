Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 974157ADB52
	for <lists+kvm@lfdr.de>; Mon, 25 Sep 2023 17:24:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232813AbjIYPYy (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 25 Sep 2023 11:24:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45488 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231674AbjIYPYx (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 25 Sep 2023 11:24:53 -0400
Received: from desiato.infradead.org (desiato.infradead.org [IPv6:2001:8b0:10b:1:d65d:64ff:fe57:4e05])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E84219C
        for <kvm@vger.kernel.org>; Mon, 25 Sep 2023 08:24:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=desiato.20200630; h=Content-Transfer-Encoding:Content-Type
        :MIME-Version:Message-ID:References:In-Reply-To:Subject:CC:To:From:Date:
        Sender:Reply-To:Content-ID:Content-Description;
        bh=8nIJdlh43L+FZjxjYbl1I/tdL6wRJG++OmIwcjT6SRY=; b=JowlXT3ViUAZX4bw47+FItMbsi
        C3Ohb4pHXxvsfUzNuzuRgN4VTtGHC12fntApGfoU++5n6VkPxyMYs26tgjvn7YQwGC7iK3PuFqPqo
        +LavZDMTcVIj9eLYqBWYCFgyYSf6Li8AVjTzsTpi23ekcuNSbvfyD1aL9waPZsyRVymw2VbwTYUkX
        KXnndYfpn+La1ES49hc0PcAYdXzMg/oltQcjsAjZLxYPx3HokNUfWjzKFMuoLA9m83j8Z+2Egfxmw
        vHbU31Aa8pYfFD9l+eXPh9Sc14DXryGjwf9zgLAvmcTdt8Hv/dqyyWc0QnQH50SceHU9lCG6z7Kj8
        Fm6AfMxw==;
Received: from [31.94.56.64] (helo=[127.0.0.1])
        by desiato.infradead.org with esmtpsa (Exim 4.96 #2 (Red Hat Linux))
        id 1qknRq-001jLI-1S;
        Mon, 25 Sep 2023 15:24:36 +0000
Date:   Mon, 25 Sep 2023 17:24:33 +0200
From:   David Woodhouse <dwmw2@infradead.org>
To:     kvm@vger.kernel.org
CC:     jmattson@google.com, joro@8bytes.org, oupton@google.com,
        pbonzini@redhat.com, seanjc@google.com, tglx@linutronix.de,
        vkuznets@redhat.com, wanpengli@tencent.com,
        Simon Veith <sveith@amazon.de>
Subject: =?US-ASCII?Q?Re=3A_=5BRFC=5D_KVM=3A_x86=3A_Add_KVM=5FVCPU=5FTSC=5FSCALE?= =?US-ASCII?Q?_and_fix_the_documentation_on_TSC_migration?=
User-Agent: K-9 Mail for Android
In-Reply-To: <13f256ad95de186e3b6bcfcc1f88da5d0ad0cb71.camel@infradead.org>
References: <13f256ad95de186e3b6bcfcc1f88da5d0ad0cb71.camel@infradead.org>
Message-ID: <01FE7B76-AA4C-4910-A193-284B45CB4601@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by desiato.infradead.org. See http://www.infradead.org/rpr.html
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_BLOCKED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 13 September 2023 16:08:22 CEST, David Woodhouse <dwmw2@infradead=2Eorg=
> wrote:
>From: David Woodhouse <dwmw@amazon=2Eco=2Euk>
>
>The documentation on TSC migration using KVM_VCPU_TSC_OFFSET is woefully
>inadequate=2E It ignores TSC scaling, and ignores the fact that the host
>TSC may differ from one host to the next (and in fact because of the way
>the kernel calibrates it, it generally differs from one boot to the next
>even on the same hardware)=2E
>
>Add KVM_VCPU_TSC_SCALE to extract the actual scale ratio and frac_bits,
>and attempt to document the *awful* process that we're requiring userspac=
e
>to follow to merely preserve the TSC across migration=2E
>
>I may have thrown up in my mouth a little when writing that documentation=
=2E
>It's an awful API=2E If we do this, we should be ashamed of ourselves=2E
>(I also haven't tested the documented process yet)=2E

Ah, I think I missed a step in that documentation of the existing requirem=
ents=2E Because the KVM clock KVM_CLOCK_REALTIME reports the relationship t=
o `CLOCK_REALTIME`, you end up with bugs if you migrate during a leap secon=
d=2E It should actually use `CLOCK_TAI`, shouldn't it?=20

Is that even fixable by userspace? There are literally two different point=
s in time when the kernel could return the same value of `CLOCK_REALTIME`, =
aren't there?

I think the only way we can document that for userspace is to say that if =
the real-time clock value you get from kvm_get_clock contains an ambiguous =
time, you should try again=2E=2E=2E
