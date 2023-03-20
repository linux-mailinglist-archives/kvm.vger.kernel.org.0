Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7AE9E6C1CE4
	for <lists+kvm@lfdr.de>; Mon, 20 Mar 2023 17:53:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233095AbjCTQxc (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 20 Mar 2023 12:53:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55370 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232305AbjCTQxC (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 20 Mar 2023 12:53:02 -0400
Received: from desiato.infradead.org (desiato.infradead.org [IPv6:2001:8b0:10b:1:d65d:64ff:fe57:4e05])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4FC4B18AB4;
        Mon, 20 Mar 2023 09:45:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=desiato.20200630; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=ckSQEj+Igo6tabLZGjCg19IVePPixEan7GCzQanCqbU=; b=Wk4umnnRcEOaVFIf7ADu+HE5Rp
        Ty/M6muzlTsDwYCRhQaSnyJpOEPT8MsUhdIFp3C58fxA198pS2feoryDteyCdOERgj0fsWjSR8WlQ
        sn7kbJnD3HAxQ90l3NH6zgDRVRve6IRMqQG+4bmktcKS7k18yHLvqGkevoZM7kldz9OHSsnFrFVpE
        pNINtb2Sm9S+EDOsdmHNdWELAA6pnoeeUUlLfG5lnWDwlXswY8nhItDws12ymO1HU/zL9kzmjMtuD
        EXE7sR8zehdCnN8uwRW5A+GgtxUnxAPckmd32xmMFS7wFrtzsry8+wReH3+xkyjFWcWGJkLlDmsJl
        B3t4toBg==;
Received: from j130084.upc-j.chello.nl ([24.132.130.84] helo=noisy.programming.kicks-ass.net)
        by desiato.infradead.org with esmtpsa (Exim 4.96 #2 (Red Hat Linux))
        id 1peIcb-003zlA-1h;
        Mon, 20 Mar 2023 16:44:35 +0000
Received: from hirez.programming.kicks-ass.net (hirez.programming.kicks-ass.net [192.168.1.225])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        by noisy.programming.kicks-ass.net (Postfix) with ESMTPS id 3BE7D300288;
        Mon, 20 Mar 2023 17:44:31 +0100 (CET)
Received: by hirez.programming.kicks-ass.net (Postfix, from userid 1000)
        id 2242A200A76E5; Mon, 20 Mar 2023 17:44:31 +0100 (CET)
Date:   Mon, 20 Mar 2023 17:44:31 +0100
From:   Peter Zijlstra <peterz@infradead.org>
To:     "H. Peter Anvin" <hpa@zytor.com>
Cc:     Lai Jiangshan <jiangshanlai@gmail.com>, Xin Li <xin3.li@intel.com>,
        linux-kernel@vger.kernel.org, x86@kernel.org, kvm@vger.kernel.org,
        tglx@linutronix.de, mingo@redhat.com, bp@alien8.de,
        dave.hansen@linux.intel.com, andrew.cooper3@citrix.com,
        seanjc@google.com, pbonzini@redhat.com, ravi.v.shankar@intel.com
Subject: Re: [PATCH v5 22/34] x86/fred: FRED initialization code
Message-ID: <20230320164431.GQ2194297@hirez.programming.kicks-ass.net>
References: <20230307023946.14516-1-xin3.li@intel.com>
 <20230307023946.14516-23-xin3.li@intel.com>
 <CAJhGHyADXz-3PCFS3M_7TJ8qLGJ=4NcV9aBWrpjemuXB_SnMGg@mail.gmail.com>
 <5D679723-D84F-42F0-AD8A-8BD1A38FB6CD@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5D679723-D84F-42F0-AD8A-8BD1A38FB6CD@zytor.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Mar 17, 2023 at 02:32:28PM -0700, H. Peter Anvin wrote:
> The purpose of separate stacks for NMI, #DB and #MC *in the kernel*
> (remember that user space faults are always taken on stack level 0) is
> to avoid overflowing the kernel stack. #DB in the kernel would imply
> the use of a kernel debugger.

Perf (and through it bpf) also has access to #DB. They can set
breakpoints on kernel instructions/memory just fine provided permission
etc.
