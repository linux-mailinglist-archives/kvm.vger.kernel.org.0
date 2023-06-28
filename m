Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6426B7411E7
	for <lists+kvm@lfdr.de>; Wed, 28 Jun 2023 15:05:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231182AbjF1NEk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 28 Jun 2023 09:04:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44030 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230517AbjF1NEj (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 28 Jun 2023 09:04:39 -0400
Received: from desiato.infradead.org (desiato.infradead.org [IPv6:2001:8b0:10b:1:d65d:64ff:fe57:4e05])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CAE1E2115;
        Wed, 28 Jun 2023 06:04:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=desiato.20200630; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=r4assKLUV0IbwzseqMfwCr0QBp5VHy4VpTRtS17tYNw=; b=etkAxCKGBrjRUymzYmu3Iqb/ae
        QdZYyMV6oDZXdPvYVjaz66ZhMBhFGgIH6JCPAhAuuo6K+ZQFx0+yAEOg4Im4gBUHRoVY66e6IgNlo
        cwB2kX6Lu/lte3Hm4L+l4XXgjAjkGJEpVR8Fprn5UOkFor2dJS3OvGDwc5VkGTTl1FU9BLg9JItTs
        ndqf69xpeVeEkCo2GTcN6VS7cMch0jcRLbCv3IKQDqj2WGByGG9yjGsQws9tXVKYPa8hZl3NmviEC
        /nYR+MKBUBr+eg3vS4/CULz7iOoBVQU/U8S41vHF3DYb8/hogtjEeC9c7ZG0mQz7SzdY1tGLHa+2G
        5mrg9DWg==;
Received: from j130084.upc-j.chello.nl ([24.132.130.84] helo=noisy.programming.kicks-ass.net)
        by desiato.infradead.org with esmtpsa (Exim 4.96 #2 (Red Hat Linux))
        id 1qEUqK-005eHM-1L;
        Wed, 28 Jun 2023 13:04:20 +0000
Received: from hirez.programming.kicks-ass.net (hirez.programming.kicks-ass.net [192.168.1.225])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits))
        (Client did not present a certificate)
        by noisy.programming.kicks-ass.net (Postfix) with ESMTPS id ABB583002F0;
        Wed, 28 Jun 2023 15:04:19 +0200 (CEST)
Received: by hirez.programming.kicks-ass.net (Postfix, from userid 1000)
        id 9C42C27F62BA3; Wed, 28 Jun 2023 15:04:19 +0200 (CEST)
Date:   Wed, 28 Jun 2023 15:04:19 +0200
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
Subject: Re: [PATCH v12 07/22] x86/virt/tdx: Add skeleton to enable TDX on
 demand
Message-ID: <20230628130419.GC2438817@hirez.programming.kicks-ass.net>
References: <cover.1687784645.git.kai.huang@intel.com>
 <104d324cd68b12e14722ee5d85a660cccccd8892.1687784645.git.kai.huang@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <104d324cd68b12e14722ee5d85a660cccccd8892.1687784645.git.kai.huang@intel.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Jun 27, 2023 at 02:12:37AM +1200, Kai Huang wrote:

> +static int try_init_module_global(void)
> +{
> +	unsigned long flags;
> +	int ret;
> +
> +	/*
> +	 * The TDX module global initialization only needs to be done
> +	 * once on any cpu.
> +	 */
> +	raw_spin_lock_irqsave(&tdx_global_init_lock, flags);
> +
> +	if (tdx_global_initialized) {
> +		ret = 0;
> +		goto out;
> +	}
> +
> +	/* All '0's are just unused parameters. */
> +	ret = seamcall(TDH_SYS_INIT, 0, 0, 0, 0, NULL, NULL);
> +	if (!ret)
> +		tdx_global_initialized = true;
> +out:
> +	raw_spin_unlock_irqrestore(&tdx_global_init_lock, flags);
> +
> +	return ret;
> +}

How long does that TDX_SYS_INIT take and why is a raw_spinlock with IRQs
disabled the right way to serialize this?
