Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0FFA654E33B
	for <lists+kvm@lfdr.de>; Thu, 16 Jun 2022 16:19:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1377090AbiFPOSq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 16 Jun 2022 10:18:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57270 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1377642AbiFPOSn (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 16 Jun 2022 10:18:43 -0400
Received: from desiato.infradead.org (desiato.infradead.org [IPv6:2001:8b0:10b:1:d65d:64ff:fe57:4e05])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B14DD38BF2;
        Thu, 16 Jun 2022 07:18:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=desiato.20200630; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=u5EdENq+ei/uB3hVuj+8C5dFhMYjXxg2KzK2A5yd0yY=; b=BzaUueabgfP0CWvdxYqZ2jqjn8
        muioLUhJx1Dn31tfLnwJeUQAH3iRg36Ppx8n7a4S0n4e380NYauBdtenJMIA0Y4BV/7hs56pNNWf1
        3ko8F0Xz7H7Z36BRsnm5CHA3MegVat45maW7aoiCVhy6mBjTxje+EvashYHhqfBToFsEiiDR2RGIw
        BsAKUt8eGLAZXO1V975msmZaqDJ7COkjiUnP3BK/bqHAGYdVN7vaM4gazKwBjYgnGyWHtwOF7tyMw
        5/GA6lzbGggsOUGYDUtQ3tDV0UkYiFlnoQRTMeaKkIOvJ/m+TozOyNPULEA2xx6Tav5X95a4FNLH2
        YogpxHig==;
Received: from dhcp-077-249-017-003.chello.nl ([77.249.17.3] helo=noisy.programming.kicks-ass.net)
        by desiato.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1o1qKA-008QiY-VJ; Thu, 16 Jun 2022 14:18:19 +0000
Received: from hirez.programming.kicks-ass.net (hirez.programming.kicks-ass.net [192.168.1.225])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits))
        (Client did not present a certificate)
        by noisy.programming.kicks-ass.net (Postfix) with ESMTPS id 7091430008D;
        Thu, 16 Jun 2022 16:18:18 +0200 (CEST)
Received: by hirez.programming.kicks-ass.net (Postfix, from userid 1000)
        id 57D4728B675F1; Thu, 16 Jun 2022 16:18:18 +0200 (CEST)
Date:   Thu, 16 Jun 2022 16:18:18 +0200
From:   Peter Zijlstra <peterz@infradead.org>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Yang Weijiang <weijiang.yang@intel.com>, seanjc@google.com,
        x86@kernel.org, kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        rick.p.edgecombe@intel.com
Subject: Re: [PATCH 00/19] Refresh queued CET virtualization series
Message-ID: <Yqs7qjjbqxpw62B/@hirez.programming.kicks-ass.net>
References: <20220616084643.19564-1-weijiang.yang@intel.com>
 <YqsB9upUystxvl+d@hirez.programming.kicks-ass.net>
 <62d4f7f0-e7b2-83ad-a2c7-a90153129da2@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <62d4f7f0-e7b2-83ad-a2c7-a90153129da2@redhat.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Jun 16, 2022 at 12:21:20PM +0200, Paolo Bonzini wrote:
> On 6/16/22 12:12, Peter Zijlstra wrote:
> > Do I understand this right in that a host without X86_KERNEL_IBT cannot
> > run a guest with X86_KERNEL_IBT on? That seems unfortunate, since that
> > was exactly what I did while developing the X86_KERNEL_IBT patches.
> > 
> > I'm thinking that if the hardware supports it, KVM should expose it,
> > irrespective of the host kernel using it.
> 
> For IBT in particular, I think all processor state is only loaded and stored
> at vmentry/vmexit (does not need XSAVES), so it should be feasible.

That would be the S_CET stuff, yeah, that's VMCS managed. The U_CET
stuff is all XSAVE though.

But funny thing, CPUID doesn't enumerate {U,S}_CET separately. It *does*
enumerate IBT and SS separately, but for each IBT/SS you have to
implement both U and S.

That was a problem with the first series, which only implemented support
for U_CET while advertising IBT and SS (very much including S_CET), and
still is a problem with this series because S_SS is missing while
advertised.

