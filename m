Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5473D741319
	for <lists+kvm@lfdr.de>; Wed, 28 Jun 2023 15:56:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231908AbjF1Nzi (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 28 Jun 2023 09:55:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50800 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232432AbjF1Nz0 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 28 Jun 2023 09:55:26 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3C817269D;
        Wed, 28 Jun 2023 06:55:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=5EcaSelTELk66D9yc9EYTzF87nomzYvNvPRV8mwi9rc=; b=W7LN9a17V1DnA+F/c3rpfgeTL+
        s9C6KEt2zXeQToktpw0ehyIxpP8abSG8JjAcd9hEC4JaLD6uOF28ErTho1dbkT4FRasYilW+/pm9O
        GaSsh2got/8M5YCpEVHSaY8H+lWAe3N63tWBp/2z5fY+mKdxDssIuFK9qmNpu5ecE8L8odGjryrT2
        WFMy4Jdp3EFl1ebmWQlv+E01ibKRG2NMOpr2uJVr3ZFgoClliTEpNwjhVxW7ODFQiIbaDbxY22PqA
        J7KGeNLv4kkiMfDRCqctgMKvjGcSccUdAk74NE+Z8nefaHQ2rvGphUe/z+LAwqyo4NVN1faZP7an5
        N4GwLRXQ==;
Received: from j130084.upc-j.chello.nl ([24.132.130.84] helo=noisy.programming.kicks-ass.net)
        by casper.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1qEVcz-003psp-FM; Wed, 28 Jun 2023 13:54:37 +0000
Received: from hirez.programming.kicks-ass.net (hirez.programming.kicks-ass.net [192.168.1.225])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits))
        (Client did not present a certificate)
        by noisy.programming.kicks-ass.net (Postfix) with ESMTPS id 5214B30005E;
        Wed, 28 Jun 2023 15:54:36 +0200 (CEST)
Received: by hirez.programming.kicks-ass.net (Postfix, from userid 1000)
        id 316902424518F; Wed, 28 Jun 2023 15:54:36 +0200 (CEST)
Date:   Wed, 28 Jun 2023 15:54:36 +0200
From:   Peter Zijlstra <peterz@infradead.org>
To:     Kai Huang <kai.huang@intel.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        linux-mm@kvack.org, x86@kernel.org, dave.hansen@intel.com,
        kirill.shutemov@linux.intel.com, tony.luck@intel.com,
        tglx@linutronix.de, bp@alien8.de, mingo@redhat.com, hpa@zytor.com,
        seanjc@google.com, pbonzini@redhat.com, david@redhat.com,
        dan.j.williams@intel.com, rafael.j.wysocki@intel.com,
        ashok.raj@intel.com, reinette.chatre@intel.com,
        len.brown@intel.com, ak@linux.intel.com, isaku.yamahata@intel.com,
        ying.huang@intel.com, chao.gao@intel.com,
        sathyanarayanan.kuppuswamy@linux.intel.com, nik.borisov@suse.com,
        bagasdotme@gmail.com, sagis@google.com, imammedo@redhat.com
Subject: Re: [PATCH v12 05/22] x86/virt/tdx: Add SEAMCALL infrastructure
Message-ID: <20230628135436.GC2439977@hirez.programming.kicks-ass.net>
References: <cover.1687784645.git.kai.huang@intel.com>
 <b2a875fd855145728744617ac4425a06d8b46c90.1687784645.git.kai.huang@intel.com>
 <20230628125813.GA2438817@hirez.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230628125813.GA2438817@hirez.programming.kicks-ass.net>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Jun 28, 2023 at 02:58:13PM +0200, Peter Zijlstra wrote:

> Can someone explain to me why __tdx_hypercall() is sane (per the above)
> but then we grew __tdx_module_call() as an absolute abomination and are
> apparently using that for seam too?

That is, why do we have two different TDCALL wrappers? Makes no sense.
