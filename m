Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0A5756C1E8E
	for <lists+kvm@lfdr.de>; Mon, 20 Mar 2023 18:51:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230407AbjCTRvb (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 20 Mar 2023 13:51:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40562 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230267AbjCTRvB (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 20 Mar 2023 13:51:01 -0400
Received: from desiato.infradead.org (desiato.infradead.org [IPv6:2001:8b0:10b:1:d65d:64ff:fe57:4e05])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4BB5E2DE78;
        Mon, 20 Mar 2023 10:45:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=desiato.20200630; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=xHmOUL5c7d7/FrFtZQKw5S5y23ri0niwCk3/YRUyPWQ=; b=bnAymxi8xO8MJaRLCHQLkuVkuX
        gxqbmObZ4bT0nmB/OiD+fyUXeCa5clslwnlIh/FE6Wjh+02GAkyZ4HEwhliG5nusQCGJsuDSyaQ1q
        oAnsNwLIB/T82wkRxsGcwJmqJNNLYiUUeKPrzdpdBFpItkCh7I5Klifh2awagmUCkuOeA/6h1Xale
        6jm/BEEdQS0fp78/G2pxnz7DxtRkEJWuX/FCBU3KBetGlKfRuQMxzRQFmYNz+Mveyw3v2Rl0NMwBi
        83w5xBuh5eKp/yLlqnNnlh5PCaE0ZwQQv17itQN2TtKtK2ooH1rdv2U7w0YD+C3PfacDLIqcVrKAI
        dXbjoV7w==;
Received: from j130084.upc-j.chello.nl ([24.132.130.84] helo=noisy.programming.kicks-ass.net)
        by desiato.infradead.org with esmtpsa (Exim 4.96 #2 (Red Hat Linux))
        id 1peIhj-003zqE-0F;
        Mon, 20 Mar 2023 16:49:52 +0000
Received: from hirez.programming.kicks-ass.net (hirez.programming.kicks-ass.net [192.168.1.225])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits))
        (Client did not present a certificate)
        by noisy.programming.kicks-ass.net (Postfix) with ESMTPS id 8C7FF300137;
        Mon, 20 Mar 2023 17:49:50 +0100 (CET)
Received: by hirez.programming.kicks-ass.net (Postfix, from userid 1000)
        id 75486200A76E5; Mon, 20 Mar 2023 17:49:50 +0100 (CET)
Date:   Mon, 20 Mar 2023 17:49:50 +0100
From:   Peter Zijlstra <peterz@infradead.org>
To:     Lai Jiangshan <jiangshanlai@gmail.com>
Cc:     "H. Peter Anvin" <hpa@zytor.com>, Xin Li <xin3.li@intel.com>,
        linux-kernel@vger.kernel.org, x86@kernel.org, kvm@vger.kernel.org,
        tglx@linutronix.de, mingo@redhat.com, bp@alien8.de,
        dave.hansen@linux.intel.com, andrew.cooper3@citrix.com,
        seanjc@google.com, pbonzini@redhat.com, ravi.v.shankar@intel.com
Subject: Re: [PATCH v5 22/34] x86/fred: FRED initialization code
Message-ID: <20230320164950.GR2194297@hirez.programming.kicks-ass.net>
References: <20230307023946.14516-1-xin3.li@intel.com>
 <20230307023946.14516-23-xin3.li@intel.com>
 <CAJhGHyADXz-3PCFS3M_7TJ8qLGJ=4NcV9aBWrpjemuXB_SnMGg@mail.gmail.com>
 <5D679723-D84F-42F0-AD8A-8BD1A38FB6CD@zytor.com>
 <CAJhGHyC0_1xJD2R03-NoRVpMXFTHR4v8CdzyJOZe_k0rdv=NfQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAJhGHyC0_1xJD2R03-NoRVpMXFTHR4v8CdzyJOZe_k0rdv=NfQ@mail.gmail.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sat, Mar 18, 2023 at 02:33:30PM +0800, Lai Jiangshan wrote:
> If there is no other concrete reason other than overflowing for
> assigning NMI and #DB with a stack level > 0, #VE should also
> be assigned with a stack level > 0, and #BP too. #VE can happen
> anytime and anywhere, so it is subject to overflowing too.

So #BP needs the stack-gap (redzone) for text_poke_bp().

#BP can end up in kprobes which can then end up in ftrace/perf,
depending on how it's all wired up.

#VE is currently a trainwreck vs NMI/MCE, but I think FRED solves the
worst of that. I'm not exactly sure how deep the #VE handler goes.


