Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2A6B1654185
	for <lists+kvm@lfdr.de>; Thu, 22 Dec 2022 14:09:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235395AbiLVNJo (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 22 Dec 2022 08:09:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45814 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229726AbiLVNJn (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 22 Dec 2022 08:09:43 -0500
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1374E3AA;
        Thu, 22 Dec 2022 05:09:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=DIGbjZ8nA1g3Iqt/Q7vETC8/38Ow2ZV5XHH1y7gKWrk=; b=ovm/JIYXQKDYU3paVM+M94jVcf
        Mun4OLJGrztHEJhyXJIYLqss0OdNDVrAkC9dkOVwzlzhXF6DZRG/1Y7JqQlVbLjw58R1eFZ6gSUlh
        iJHXYPocTcmBACgBLkpjxvJncBBRJ7jmj1poBdADhod61/Lbc8NaAynTKV+Ezt6qbo1t1P6LGs+H7
        K3Q91DXkQE6f9l2KIaVkIF+E4wi7uwpYHjx6ivm7rKxO61u89rjjEyfEDmiQf4N9C2b39TSezxCX2
        CkjeV0AJZxFxSFQvyt/Vzl2nlunORuIT+xFFg6uLCBRL2ipa5p+9MMXTh2JaXUa6j61Z6GHm6hCsr
        U1rxEjgg==;
Received: from j130084.upc-j.chello.nl ([24.132.130.84] helo=noisy.programming.kicks-ass.net)
        by casper.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1p8LKN-003ftz-Hu; Thu, 22 Dec 2022 13:09:39 +0000
Received: from hirez.programming.kicks-ass.net (hirez.programming.kicks-ass.net [192.168.1.225])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits))
        (Client did not present a certificate)
        by noisy.programming.kicks-ass.net (Postfix) with ESMTPS id CA6FE30006D;
        Thu, 22 Dec 2022 14:09:28 +0100 (CET)
Received: by hirez.programming.kicks-ass.net (Postfix, from userid 1000)
        id BBF5520D2DE36; Thu, 22 Dec 2022 14:09:28 +0100 (CET)
Date:   Thu, 22 Dec 2022 14:09:28 +0100
From:   Peter Zijlstra <peterz@infradead.org>
To:     "H. Peter Anvin" <hpa@zytor.com>
Cc:     "Li, Xin3" <xin3.li@intel.com>,
        "andrew.cooper3@citrix.com" <andrew.cooper3@citrix.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "x86@kernel.org" <x86@kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "bp@alien8.de" <bp@alien8.de>,
        "dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>,
        "Christopherson,, Sean" <seanjc@google.com>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "Shankar, Ravi V" <ravi.v.shankar@intel.com>
Subject: Re: [RFC PATCH 22/32] x86/fred: FRED initialization code
Message-ID: <Y6RXCJNn8xyl7g7u@hirez.programming.kicks-ass.net>
References: <20221220063658.19271-1-xin3.li@intel.com>
 <20221220063658.19271-23-xin3.li@intel.com>
 <Y6GELyEJeKY3dEqJ@hirez.programming.kicks-ass.net>
 <16972e64-7d7b-ad8c-f8dc-6dcab69e629e@citrix.com>
 <Y6GIN5Uf7Qd43A9U@hirez.programming.kicks-ass.net>
 <BN6PR1101MB2161C51C6068026D9C442460A8EB9@BN6PR1101MB2161.namprd11.prod.outlook.com>
 <0D72CCA1-A0B6-487B-A6B9-7341020D28A2@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0D72CCA1-A0B6-487B-A6B9-7341020D28A2@zytor.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Dec 20, 2022 at 09:44:33PM -0800, H. Peter Anvin wrote:

> Right, this is one major reason for putting #DB/NMI in a separate stack level.

But with the IST they each have their own stack, with FRED they'll share
this small stack.
