Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4AFE9633838
	for <lists+kvm@lfdr.de>; Tue, 22 Nov 2022 10:21:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232654AbiKVJVK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 22 Nov 2022 04:21:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55006 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231300AbiKVJVH (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 22 Nov 2022 04:21:07 -0500
Received: from desiato.infradead.org (desiato.infradead.org [IPv6:2001:8b0:10b:1:d65d:64ff:fe57:4e05])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7C22924BE9;
        Tue, 22 Nov 2022 01:21:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=desiato.20200630; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=aBITBJ1p295wuNeBBhm/B8LW9oNFY5gamj55K4mKePw=; b=AQF66lESLP89XmPdshYCszvIfn
        WbOIiuGmtwycULWx7bZZ953U5szx1+l3A0l87GZx69A6WGl7sPsVxzfJby2q3sIUM+8M3sffvcjyM
        khzH//RUOQmtynDqMMB1DaZhAvLH42dr3An3dP/1fAvpQ4HNfdmWrmsBjaL3MVHtn5fWIqYYJdvN6
        p0UODz+GQ8F4TO93sWLLVAAjoudXK2Q+BbeiOWmxqEUnd/Ku3QNDoY3kphofG8DEp6BYw9K2N3EpT
        tzHcx4wSbkgZmzCCv9TlG9mSq2eQZZmEIokxtE18tI3s0YKF0LLjG+6zaeRn/bLuYBjhzXWlaV6XR
        3Lc1+kIg==;
Received: from j130084.upc-j.chello.nl ([24.132.130.84] helo=noisy.programming.kicks-ass.net)
        by desiato.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1oxPSY-003ODh-2s; Tue, 22 Nov 2022 09:20:54 +0000
Received: from hirez.programming.kicks-ass.net (hirez.programming.kicks-ass.net [192.168.1.225])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits))
        (Client did not present a certificate)
        by noisy.programming.kicks-ass.net (Postfix) with ESMTPS id 982B9300322;
        Tue, 22 Nov 2022 10:20:53 +0100 (CET)
Received: by hirez.programming.kicks-ass.net (Postfix, from userid 1000)
        id 808B22D66C42F; Tue, 22 Nov 2022 10:20:53 +0100 (CET)
Date:   Tue, 22 Nov 2022 10:20:53 +0100
From:   Peter Zijlstra <peterz@infradead.org>
To:     Kai Huang <kai.huang@intel.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        linux-mm@kvack.org, seanjc@google.com, pbonzini@redhat.com,
        dave.hansen@intel.com, dan.j.williams@intel.com,
        rafael.j.wysocki@intel.com, kirill.shutemov@linux.intel.com,
        ying.huang@intel.com, reinette.chatre@intel.com,
        len.brown@intel.com, tony.luck@intel.com, ak@linux.intel.com,
        isaku.yamahata@intel.com, chao.gao@intel.com,
        sathyanarayanan.kuppuswamy@linux.intel.com, bagasdotme@gmail.com,
        sagis@google.com, imammedo@redhat.com
Subject: Re: [PATCH v7 06/20] x86/virt/tdx: Shut down TDX module in case of
 error
Message-ID: <Y3yUdcJjrY2LhUWJ@hirez.programming.kicks-ass.net>
References: <cover.1668988357.git.kai.huang@intel.com>
 <48505089b645019a734d85c2c29f3c8ae2dbd6bd.1668988357.git.kai.huang@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <48505089b645019a734d85c2c29f3c8ae2dbd6bd.1668988357.git.kai.huang@intel.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Nov 21, 2022 at 01:26:28PM +1300, Kai Huang wrote:

> Shutting down the TDX module requires calling TDH.SYS.LP.SHUTDOWN on all
> BIOS-enabled CPUs, and the SEMACALL can run concurrently on different
> CPUs.  Implement a mechanism to run SEAMCALL concurrently on all online
> CPUs and use it to shut down the module.  Later logical-cpu scope module
> initialization will use it too.

Uhh, those requirements ^ are not met by this:

> +static void seamcall_on_each_cpu(struct seamcall_ctx *sc)
> +{
> +	on_each_cpu(seamcall_smp_call_function, sc, true);
> +}

Consider:

	CPU0			CPU1			CPU2

	local_irq_disable()
	...
				seamcall_on_each_cpu()
				send-IPIs to 0 and 2
							<IPI>
				runs local seamcall
				(seamcall done)
				waits for 0 and 2
							<has an NMI delay things>
							runs seamcall
							clears CSD_LOCK
							</IPI>
				... spinning ...

	local_irq_enable()
	<IPI>
	  runs seamcall
	  clears CSD_LOCK
				*FINALLY* observes CSD_LOCK cleared on
				all CPU and continues
	</IPI>

IOW, they all 3 run seamcall at different times.

Either the Changelog is broken or this TDX crud is worse crap than I
thought possible, because the only way to actually meet that requirement
as stated is stop_machine().


