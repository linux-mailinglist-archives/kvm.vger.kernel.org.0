Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 713E46255D2
	for <lists+kvm@lfdr.de>; Fri, 11 Nov 2022 09:56:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233417AbiKKI4L (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 11 Nov 2022 03:56:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43526 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233409AbiKKI4K (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 11 Nov 2022 03:56:10 -0500
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B6E1377202;
        Fri, 11 Nov 2022 00:56:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=AfRcqsf6ejL03DcbffFiojk0ADSJ78lfGlZNfAZ1V2U=; b=HugVjGcHnTyIsDGx07ol/W+kIw
        7ggClT5QAf0liWieHhjSiB44zU6v5dL85be8swzrWT8+8dydXV0hS3OAEKB+vltFSZOqYyhwiva8v
        92vBUPIjLUCC3xkzXkdLUsLVpHbmUNwL7oTbz2mxm4vNqF+lc7/GoEZ1CK+pfOo2qXCeiv63VTi3f
        abmW812Lxo63BrYMsgkTbwps3bGo+1214N01Hu+wY8TBMydPkgCVoCieLHIJBfsTd39JfPnGLD2nI
        yTWAkeVdEbhbFeUfLI+v6J/w3dcovibb4P6+W7+fHxoH0kv21MxBMo0Gj7P9o48X89/p4Gs2U8ahj
        tijVfu/w==;
Received: from j130084.upc-j.chello.nl ([24.132.130.84] helo=noisy.programming.kicks-ass.net)
        by casper.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1otPpG-00CsEc-Gp; Fri, 11 Nov 2022 08:55:50 +0000
Received: from hirez.programming.kicks-ass.net (hirez.programming.kicks-ass.net [192.168.1.225])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        by noisy.programming.kicks-ass.net (Postfix) with ESMTPS id 8FC623002EC;
        Fri, 11 Nov 2022 09:55:43 +0100 (CET)
Received: by hirez.programming.kicks-ass.net (Postfix, from userid 1000)
        id 427FF20243A99; Fri, 11 Nov 2022 09:55:43 +0100 (CET)
Date:   Fri, 11 Nov 2022 09:55:43 +0100
From:   Peter Zijlstra <peterz@infradead.org>
To:     "Li, Xin3" <xin3.li@intel.com>
Cc:     "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "x86@kernel.org" <x86@kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "bp@alien8.de" <bp@alien8.de>,
        "dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>,
        "hpa@zytor.com" <hpa@zytor.com>,
        "Christopherson,, Sean" <seanjc@google.com>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "Tian, Kevin" <kevin.tian@intel.com>
Subject: Re: [RESEND PATCH 2/6] x86/traps: add a system interrupt table for
 system interrupt dispatch
Message-ID: <Y24OD6nmPVS0v1vu@hirez.programming.kicks-ass.net>
References: <20221110061545.1531-1-xin3.li@intel.com>
 <20221110061545.1531-3-xin3.li@intel.com>
 <Y2y8obdYDXo9vlH/@hirez.programming.kicks-ass.net>
 <BN6PR1101MB21619E2092AFF048422C6311A8019@BN6PR1101MB2161.namprd11.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <BN6PR1101MB21619E2092AFF048422C6311A8019@BN6PR1101MB2161.namprd11.prod.outlook.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Nov 10, 2022 at 07:55:22PM +0000, Li, Xin3 wrote:
> > > Signed-off-by: H. Peter Anvin (Intel) <hpa@zytor.com>
> > > Signed-off-by: Xin Li <xin3.li@intel.com>
> > 
> > This is not a valid SOB, it would suggest hpa is the author, but he's not in in
> > From.
> 
> HPA wrote the initial dispatch code for FRED, and I worked with him to
> refactor it for KVM/VMX NMI/IRQ dispatch.  So use SOB from both.  No?

Yes, but not like this. Please review the documentation we have on this.
