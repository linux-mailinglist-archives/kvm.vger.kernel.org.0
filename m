Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 271557413A9
	for <lists+kvm@lfdr.de>; Wed, 28 Jun 2023 16:20:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231917AbjF1OTL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 28 Jun 2023 10:19:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53496 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231921AbjF1OSl (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 28 Jun 2023 10:18:41 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B2E13294C;
        Wed, 28 Jun 2023 07:18:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=WHS7onuXT/a8g00MBKmGlEUlFARjR8xadQuu4dkQLVQ=; b=X+y2nRAABO9CYH/S/cO67Aav2A
        Z9L+Ubju0tpzunzzVqTASlwVFl2aTpcezURvoi6K1zqxzXlORCVbKPcOFBEhv9L4ZYLJro7xkYivF
        6d34SozdoP5rfGxg8mE+JUHIxdTX5sqn7kph4kKa5HxocTJhzGBlmPk9eSiCQOYYBDDUC4+w1V9dR
        IVPfMa4YNObNIqCMYmkY02S2cxQZD5bLT4clORhk0hXbtyUCwNWiCWcbIg5nYhOAlmiwaCr5jRHmT
        d+w5aRRSGxubahjTpvm6XSZM1ycZjIS4QHYBMQ749hKyUD3MdYa/3ntH5ZAyQjRhaaPFrYAwXAgHi
        s/XXZv7w==;
Received: from j130084.upc-j.chello.nl ([24.132.130.84] helo=noisy.programming.kicks-ass.net)
        by casper.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1qEVzU-003qti-RT; Wed, 28 Jun 2023 14:17:52 +0000
Received: from hirez.programming.kicks-ass.net (hirez.programming.kicks-ass.net [192.168.1.225])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits))
        (Client did not present a certificate)
        by noisy.programming.kicks-ass.net (Postfix) with ESMTPS id F1923300095;
        Wed, 28 Jun 2023 16:17:51 +0200 (CEST)
Received: by hirez.programming.kicks-ass.net (Postfix, from userid 1000)
        id D8FF52458D611; Wed, 28 Jun 2023 16:17:51 +0200 (CEST)
Date:   Wed, 28 Jun 2023 16:17:51 +0200
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
Subject: Re: [PATCH v12 09/22] x86/virt/tdx: Use all system memory when
 initializing TDX module as TDX memory
Message-ID: <20230628141751.GH2438817@hirez.programming.kicks-ass.net>
References: <cover.1687784645.git.kai.huang@intel.com>
 <999b47f30fbe2535c37a5e8d602c6c27ac6212dd.1687784645.git.kai.huang@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <999b47f30fbe2535c37a5e8d602c6c27ac6212dd.1687784645.git.kai.huang@intel.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Jun 27, 2023 at 02:12:39AM +1200, Kai Huang wrote:

> +static int tdx_memory_notifier(struct notifier_block *nb, unsigned long action,
> +			       void *v)
> +{
> +	struct memory_notify *mn = v;
> +
> +	if (action != MEM_GOING_ONLINE)
> +		return NOTIFY_OK;

So offlining TDX memory is ok?

> +
> +	/*
> +	 * Empty list means TDX isn't enabled.  Allow any memory
> +	 * to go online.
> +	 */
> +	if (list_empty(&tdx_memlist))
> +		return NOTIFY_OK;
> +
> +	/*
> +	 * The TDX memory configuration is static and can not be
> +	 * changed.  Reject onlining any memory which is outside of
> +	 * the static configuration whether it supports TDX or not.
> +	 */
> +	return is_tdx_memory(mn->start_pfn, mn->start_pfn + mn->nr_pages) ?
> +		NOTIFY_OK : NOTIFY_BAD;

	if (is_tdx_memory(...))
		return NOTIFY_OK;

	return NOTIFY_BAD;

> +}
