Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 74C5D770A32
	for <lists+kvm@lfdr.de>; Fri,  4 Aug 2023 23:00:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230178AbjHDVAS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 4 Aug 2023 17:00:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57540 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229644AbjHDVAK (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 4 Aug 2023 17:00:10 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E97D0E42;
        Fri,  4 Aug 2023 14:00:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=JFFCsN9K9Ex5Mwtfom51BRrJsL5nDFgNUaXFoOYJG7w=; b=rHhdTFI81CG1zh2GbAP9Se94kO
        lgjelzV0T49hJyoXlu2aILrMovxWhUnY0T7jBImcKI0KqIQjtU9JjpWTpCSzmvUhGxYbSCx+K823X
        WkaWv04qWNRoamYY2nogdL/5N7lQLHryDZZ3vE8tUcgQtIfpnT9RpuCdASSyYfwtZejoQYV50Gnfr
        i0D3ThFImuY2joHyuX18g13EBzB5yMP4E8OrXMZVUIThmpXr988HjTwXg0zuO0gsY0a3EJxHOMZMI
        BtIM6EkQL2a5z8InZxwyV/vPGPJVcD6xesoadFuCEW+MhMfmbOFVqufq7/Zpt6BSlSl6+VvhzAuwZ
        bIzUGzPA==;
Received: from j130084.upc-j.chello.nl ([24.132.130.84] helo=noisy.programming.kicks-ass.net)
        by casper.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1qS1tt-00C0MG-K0; Fri, 04 Aug 2023 20:59:57 +0000
Received: from hirez.programming.kicks-ass.net (hirez.programming.kicks-ass.net [192.168.1.225])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits))
        (Client did not present a certificate)
        by noisy.programming.kicks-ass.net (Postfix) with ESMTPS id 1D22A30007E;
        Fri,  4 Aug 2023 22:59:55 +0200 (CEST)
Received: by hirez.programming.kicks-ass.net (Postfix, from userid 1000)
        id 0893E276A4B5F; Fri,  4 Aug 2023 22:59:55 +0200 (CEST)
Date:   Fri, 4 Aug 2023 22:59:54 +0200
From:   Peter Zijlstra <peterz@infradead.org>
To:     Sean Christopherson <seanjc@google.com>
Cc:     Weijiang Yang <weijiang.yang@intel.com>,
        Chao Gao <chao.gao@intel.com>, pbonzini@redhat.com,
        john.allen@amd.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, rick.p.edgecombe@intel.com,
        binbin.wu@linux.intel.com
Subject: Re: [PATCH v5 09/19] KVM:x86: Make guest supervisor states as
 non-XSAVE managed
Message-ID: <20230804205954.GS212435@hirez.programming.kicks-ass.net>
References: <20230803042732.88515-1-weijiang.yang@intel.com>
 <20230803042732.88515-10-weijiang.yang@intel.com>
 <ZMuMN/8Qa1sjJR/n@chao-email>
 <bfc0b3cb-c17a-0ad6-6378-0c4e38f23024@intel.com>
 <ZM1jV3UPL0AMpVDI@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZM1jV3UPL0AMpVDI@google.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_BLOCKED,
        SPF_HELO_NONE,SPF_NONE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Aug 04, 2023 at 01:45:11PM -0700, Sean Christopherson wrote:

> So unless I'm missing something, NAK to this approach, at least not without trying
> the kernel FPU approach, i.e. I want somelike like to PeterZ or tglx to actually
> full on NAK the kernel approach before we consider shoving a hack into KVM.

Not having fully followed things (I'll go read up), SSS is blocked on
FRED. But it is definitely on the books to do SSS once FRED is go.

So if the approach as chosen gets in the way of host kernel SS
management, that is a wee problem.
