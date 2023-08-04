Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1A9407709EE
	for <lists+kvm@lfdr.de>; Fri,  4 Aug 2023 22:43:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230127AbjHDUm7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 4 Aug 2023 16:42:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50428 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229657AbjHDUmx (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 4 Aug 2023 16:42:53 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5AE264C31
        for <kvm@vger.kernel.org>; Fri,  4 Aug 2023 13:42:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=fJNwTyJuCfce4nA2IQS2C5hCcmvY06t/HtZ71B7uaIA=; b=KBfmx/U/H3GAgrPnHduRtz1pZ2
        eBD5EhPba6nIchKrucpHvHm1fJLBhBwztRfH5GFUHTun8TLX2HN2w919kNqw8DWvbzNocnBRZpDgN
        d4s/zLpt2hchkWS87JH1yZ0RrBwZEejnjjPEidVLzYEuEWNNqo2o5zByLx5hFS70B7YDBVnUNDd91
        oKi5SC1exbUOJnkH6J5ReJdYULE4PrRT3D8emCNqIlLnAUEevxY9o74SzkG4mSss2EQC9jRNjE+dR
        587jxByl04a3TK9OAzGj+BeEF+EVrKx83I/D5RtCDCL2XQh7Cy/aW9vWNiL451IS+kgBVR+Fd93m3
        ks5VA2hg==;
Received: from j130084.upc-j.chello.nl ([24.132.130.84] helo=noisy.programming.kicks-ass.net)
        by casper.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1qS1cv-00BxTj-N8; Fri, 04 Aug 2023 20:42:25 +0000
Received: from hirez.programming.kicks-ass.net (hirez.programming.kicks-ass.net [192.168.1.225])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        by noisy.programming.kicks-ass.net (Postfix) with ESMTPS id C703630007E;
        Fri,  4 Aug 2023 22:42:24 +0200 (CEST)
Received: by hirez.programming.kicks-ass.net (Postfix, from userid 1000)
        id B30CC276A4BDC; Fri,  4 Aug 2023 22:42:24 +0200 (CEST)
Date:   Fri, 4 Aug 2023 22:42:24 +0200
From:   Peter Zijlstra <peterz@infradead.org>
To:     "Nikunj A. Dadhania" <nikunj@amd.com>
Cc:     kvm@vger.kernel.org, Sean Christopherson <seanjc@google.com>,
        Josh Poimboeuf <jpoimboe@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Randy Dunlap <rdunlap@infradead.org>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        Ravi Bangoria <ravi.bangoria@amd.com>
Subject: Re: [PATCH] KVM: SVM: Add exception to disable objtool warning for
 kvm-amd.o
Message-ID: <20230804204224.GQ212435@hirez.programming.kicks-ass.net>
References: <20230802091107.1160320-1-nikunj@amd.com>
 <20230804111404.GI214207@hirez.programming.kicks-ass.net>
 <5f1f9c96-5f40-3190-6888-2620b869b82a@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5f1f9c96-5f40-3190-6888-2620b869b82a@amd.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_BLOCKED,
        SPF_HELO_NONE,SPF_NONE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Aug 04, 2023 at 06:10:19PM +0530, Nikunj A. Dadhania wrote:
> On 8/4/2023 4:44 PM, Peter Zijlstra wrote:
> > On Wed, Aug 02, 2023 at 02:41:07PM +0530, Nikunj A Dadhania wrote:
> >> commit 7f4b5cde2409 ("kvm: Disable objtool frame pointer checking for
> >> vmenter.S") had added the vmenter.o file to the exception list.
> >>
> >> objtool gives the following warnings in the newer kernel builds:
> >>
> >>   arch/x86/kvm/kvm-amd.o: warning: objtool: __svm_vcpu_run+0x17d: BP used as a scratch register
> >>   arch/x86/kvm/kvm-amd.o: warning: objtool: __svm_sev_es_vcpu_run+0x72: BP used as a scratch register
> >>
> > 
> > I wanted to poke around a little, but can't reproduce this.
> > 
> > I took x86_64-defconfig + KVM=m + KVM_AMD=m + UNWIND_FRAME_POINTER=y but
> > objtool won't complain :/ What actual .config trips this?
> 
> I have attached the config.

Thanks, that does reproduce, although now I'm left wondering what
exactly makes it go beep. Also, URGH, I thought the build was broken
until I noticed it had BTF on :/
