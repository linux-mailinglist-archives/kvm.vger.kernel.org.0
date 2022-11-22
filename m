Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D56C16337D1
	for <lists+kvm@lfdr.de>; Tue, 22 Nov 2022 10:02:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233029AbiKVJC5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 22 Nov 2022 04:02:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35518 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233009AbiKVJCt (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 22 Nov 2022 04:02:49 -0500
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 895B910BA;
        Tue, 22 Nov 2022 01:02:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=I3JtwSpkdP77vSyM0WIL4jCtx94jec1H7+Vd7VeGsXg=; b=drj2W2DsQ3QoPR70ZVUerQCLR9
        iwwS44zR/5xnF1e083im4QvkIwq09JUSe+ZPZq1PhvvcH/B7GNJIqgM5j/ItZ8ZDVgGWHbCx8WWZe
        /TRhG6IIP58JaLdPZR/hlgi+ryIJWJRKw2j+Dl+nYNl6ZkVaZ4SFsd7AhLfybs3CLvW7gzsQe1bhq
        EAon/0pXQGx3Enjkb2fiWkV14PFxmCC/DKz5Ynew2L1dtnVK38zOvMYwDiNm5OljEKvGNxMz1hUoC
        80yTqq3/Jwe4mGRLMUm6t1Xi/sCrBeVHADkqdRM9Rc9hQHunPzOddSh5bcyJB2yZMzUTrNtmN/W35
        zr0sDenQ==;
Received: from j130084.upc-j.chello.nl ([24.132.130.84] helo=noisy.programming.kicks-ass.net)
        by casper.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1oxPAu-0068jT-W7; Tue, 22 Nov 2022 09:02:41 +0000
Received: from hirez.programming.kicks-ass.net (hirez.programming.kicks-ass.net [192.168.1.225])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits))
        (Client did not present a certificate)
        by noisy.programming.kicks-ass.net (Postfix) with ESMTPS id 5E8E0300244;
        Tue, 22 Nov 2022 10:02:32 +0100 (CET)
Received: by hirez.programming.kicks-ass.net (Postfix, from userid 1000)
        id 4353F2D65BCDB; Tue, 22 Nov 2022 10:02:32 +0100 (CET)
Date:   Tue, 22 Nov 2022 10:02:32 +0100
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
Subject: Re: [PATCH v7 04/20] x86/virt/tdx: Add skeleton to initialize TDX on
 demand
Message-ID: <Y3yQKDZFC8+oCyqK@hirez.programming.kicks-ass.net>
References: <cover.1668988357.git.kai.huang@intel.com>
 <d26254af8e5b3dcca8a070703c5d6d04f48d47a9.1668988357.git.kai.huang@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d26254af8e5b3dcca8a070703c5d6d04f48d47a9.1668988357.git.kai.huang@intel.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Nov 21, 2022 at 01:26:26PM +1300, Kai Huang wrote:
> +static int __tdx_enable(void)
> +{
> +	int ret;
> +
> +	/*
> +	 * Initializing the TDX module requires doing SEAMCALL on all
> +	 * boot-time present CPUs.  For simplicity temporarily disable
> +	 * CPU hotplug to prevent any CPU from going offline during
> +	 * the initialization.
> +	 */
> +	cpus_read_lock();
> +
> +	/*
> +	 * Check whether all boot-time present CPUs are online and
> +	 * return early with a message so the user can be aware.
> +	 *
> +	 * Note a non-buggy BIOS should never support physical (ACPI)
> +	 * CPU hotplug when TDX is enabled, and all boot-time present
> +	 * CPU should be enabled in MADT, so there should be no
> +	 * disabled_cpus and num_processors won't change at runtime
> +	 * either.
> +	 */
> +	if (disabled_cpus || num_online_cpus() != num_processors) {
> +		pr_err("Unable to initialize the TDX module when there's offline CPU(s).\n");
> +		ret = -EINVAL;
> +		goto out;
> +	}
> +
> +	ret = init_tdx_module();
> +	if (ret == -ENODEV) {
> +		pr_info("TDX module is not loaded.\n");
> +		tdx_module_status = TDX_MODULE_NONE;
> +		goto out;
> +	}
> +
> +	/*
> +	 * Shut down the TDX module in case of any error during the
> +	 * initialization process.  It's meaningless to leave the TDX
> +	 * module in any middle state of the initialization process.
> +	 *
> +	 * Shutting down the module also requires doing SEAMCALL on all
> +	 * MADT-enabled CPUs.  Do it while CPU hotplug is disabled.
> +	 *
> +	 * Return all errors during the initialization as -EFAULT as the
> +	 * module is always shut down.
> +	 */
> +	if (ret) {
> +		pr_info("Failed to initialize TDX module. Shut it down.\n");
> +		shutdown_tdx_module();
> +		tdx_module_status = TDX_MODULE_SHUTDOWN;
> +		ret = -EFAULT;
> +		goto out;
> +	}
> +
> +	pr_info("TDX module initialized.\n");
> +	tdx_module_status = TDX_MODULE_INITIALIZED;
> +out:
> +	cpus_read_unlock();
> +
> +	return ret;
> +}

Uhm.. so if we've offlined all the SMT siblings because of some
speculation fail or other, this TDX thing will fail to initialize?

Because as I understand it; this TDX initialization happens some random
time after boot, when the first (TDX using) KVM instance gets created,
long after the speculation mitigations are enforced.
