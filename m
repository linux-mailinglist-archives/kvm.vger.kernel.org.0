Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1530E6C1AF1
	for <lists+kvm@lfdr.de>; Mon, 20 Mar 2023 17:11:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231687AbjCTQL3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 20 Mar 2023 12:11:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39202 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231602AbjCTQLN (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 20 Mar 2023 12:11:13 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A997A3CE39;
        Mon, 20 Mar 2023 09:00:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=6x9rZyh/23qJOsuf3q71YSHaRSWJOK0YnVk8fs6md6M=; b=cFgPiiPUVLQSIIoN1/3BkGfa32
        +lllpPEcg2bF/xKlFz74JfaTkX47iOofBzmnkHhrU9eTFObrkeyoCBRLGm5G+WCxt/iiysJEZgBlk
        A9Hmwh95SFxM+fpXkbQk4NTu2L/JFfX5wduyUy9WNWNftqwMOlBJF895LtCue0rwhTngmK2rEH6hE
        fIoJSl/EGJ/xhqkw3O5iAa22T5D0KR/ZCAh41ycFbdmdtJhSvCBE9CgjuhcfKeQndzNYHAMfxqKny
        P5Q3nHG+PxQW8phB5U3cOHa4b+AAjYxSzGEiCR1puLSLpMeKx7vbMv3sqI/vRhiPSfK8HP1N4hpvk
        LHZ7UOKw==;
Received: from j130084.upc-j.chello.nl ([24.132.130.84] helo=noisy.programming.kicks-ass.net)
        by casper.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1peHvr-001B3X-Nn; Mon, 20 Mar 2023 16:00:23 +0000
Received: from hirez.programming.kicks-ass.net (hirez.programming.kicks-ass.net [192.168.1.225])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits))
        (Client did not present a certificate)
        by noisy.programming.kicks-ass.net (Postfix) with ESMTPS id F19D0300288;
        Mon, 20 Mar 2023 17:00:21 +0100 (CET)
Received: by hirez.programming.kicks-ass.net (Postfix, from userid 1000)
        id DBEA7200A76E5; Mon, 20 Mar 2023 17:00:21 +0100 (CET)
Date:   Mon, 20 Mar 2023 17:00:21 +0100
From:   Peter Zijlstra <peterz@infradead.org>
To:     Xin Li <xin3.li@intel.com>
Cc:     linux-kernel@vger.kernel.org, x86@kernel.org, kvm@vger.kernel.org,
        tglx@linutronix.de, mingo@redhat.com, bp@alien8.de,
        dave.hansen@linux.intel.com, hpa@zytor.com,
        andrew.cooper3@citrix.com, seanjc@google.com, pbonzini@redhat.com,
        ravi.v.shankar@intel.com
Subject: Re: [PATCH v5 20/34] x86/fred: add a machine check entry stub for
 FRED
Message-ID: <20230320160021.GP2194297@hirez.programming.kicks-ass.net>
References: <20230307023946.14516-1-xin3.li@intel.com>
 <20230307023946.14516-21-xin3.li@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230307023946.14516-21-xin3.li@intel.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Mar 06, 2023 at 06:39:32PM -0800, Xin Li wrote:
> Add a machine check entry stub for FRED.
> 
> Unlike IDT, no need to save/restore dr7 in FRED machine check handler.

Given how fragile MCE is, the question should be, do we ever want hw
breakpoints to happen while it is running?

If the hw-breakpoint handler trips on the same memory fail that got us
into the mce the first time, we're dead.
