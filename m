Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5A1BA76F342
	for <lists+kvm@lfdr.de>; Thu,  3 Aug 2023 21:08:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229837AbjHCTIh (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 3 Aug 2023 15:08:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51894 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231928AbjHCTH7 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 3 Aug 2023 15:07:59 -0400
Received: from desiato.infradead.org (desiato.infradead.org [IPv6:2001:8b0:10b:1:d65d:64ff:fe57:4e05])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 77DF03C0A
        for <kvm@vger.kernel.org>; Thu,  3 Aug 2023 12:07:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=desiato.20200630; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=l5rnQAE/sHDnIBFIJdD6853WLxMuNCPmxmuCTJhBJcc=; b=nYvUkacVmCXLl23Xl3GDFVerd5
        RVJjtqJh54icJ6/LBMm6RaoXNWaskrYO6ReS8Jdzc1fScsmw7EQ3KlPle9oSYR0BHNSBBqUQXKlcN
        x1SQw0hN6gNNUERzclxof7z4WGnP4Ns/FXV3iyImuQ26h6lXRmsSNHlu8Sbov15CMUcz1bCGySma5
        ZadZARnCJ6JfgdXYAwBrctC14AFajKAWYuQoPthipRBC1i0yc3xxmDr+BNRwk90CEheoTAzPm65Bx
        jcCqbP7ckuesTU5cc8gh3uvtoOw3hpvFRIrKzIA9zVk0xkXEoeXLVGxqnFcySDeOG9lzWLLeS2EWp
        cB+nQoMg==;
Received: from j130084.upc-j.chello.nl ([24.132.130.84] helo=noisy.programming.kicks-ass.net)
        by desiato.infradead.org with esmtpsa (Exim 4.96 #2 (Red Hat Linux))
        id 1qRdfY-00H14O-3D;
        Thu, 03 Aug 2023 19:07:33 +0000
Received: from hirez.programming.kicks-ass.net (hirez.programming.kicks-ass.net [192.168.1.225])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        by noisy.programming.kicks-ass.net (Postfix) with ESMTPS id 6C70D30007E;
        Thu,  3 Aug 2023 21:07:28 +0200 (CEST)
Received: by hirez.programming.kicks-ass.net (Postfix, from userid 1000)
        id 3E7B2200E8B31; Thu,  3 Aug 2023 21:07:28 +0200 (CEST)
Date:   Thu, 3 Aug 2023 21:07:28 +0200
From:   Peter Zijlstra <peterz@infradead.org>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Nikunj A Dadhania <nikunj@amd.com>, kvm@vger.kernel.org,
        Sean Christopherson <seanjc@google.com>,
        Josh Poimboeuf <jpoimboe@redhat.com>,
        Randy Dunlap <rdunlap@infradead.org>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        Ravi Bangoria <ravi.bangoria@amd.com>
Subject: Re: [PATCH] KVM: SVM: Add exception to disable objtool warning for
 kvm-amd.o
Message-ID: <20230803190728.GJ212435@hirez.programming.kicks-ass.net>
References: <20230802091107.1160320-1-nikunj@amd.com>
 <20230803120637.GD214207@hirez.programming.kicks-ass.net>
 <b22761ea-cab6-0e11-cdc9-ec26c300cd3f@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b22761ea-cab6-0e11-cdc9-ec26c300cd3f@redhat.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_BLOCKED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Aug 03, 2023 at 08:06:20PM +0200, Paolo Bonzini wrote:
> On 8/3/23 14:06, Peter Zijlstra wrote:
> > 
> > By marking them with STACK_FRAME_NON_STANDARD you will get no ORC data
> > at all, and then you also violate the normal framepointer calling
> > convention.
> > 
> > This means that if you need to unwind here you're up a creek without no
> > paddles on.
> 
> The only weird thing that can happen is ud2 instructions that are executed
> in case the vmload/vmrun/vmsave instructions causes a #GP, from the
> exception handler.

This code is ran with GIF disabled, so NMIs are not in the books, right?
Does GIF block #MC ?

> If I understand correctly those ud2 would use ORC information to show the
> backtrace, but even then the frame pointer should be correct.  Of these
> instructions, vmrun is the only one that runs with wrong %rbp; and it is
> unlikely or even impossible that a #GP happens at vmrun, because the same
> operand has been used for a vmload ten instructions before. The only time I
> saw that #GP it was due to a processor errata, but it happened consistently
> on the vmload.
> 
> So if frame pointer unwinding can be used in the absence of ORC, Nikunj
> patch should not break anything.

But framepointer unwinds rely on BP, and that is clobbered per the
objtool complaint.

Also, if you look at the makefile hunk that's being replaced, that was
conditional on CONFIG_FRAMEPOINTS, while the annotation that's being
added is not. I think objtool won't complain for ORC builds, only for
framepoints builds.
