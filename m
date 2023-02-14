Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 111CE69680A
	for <lists+kvm@lfdr.de>; Tue, 14 Feb 2023 16:27:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231298AbjBNP1S (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 14 Feb 2023 10:27:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46662 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233453AbjBNP1Q (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 14 Feb 2023 10:27:16 -0500
Received: from desiato.infradead.org (desiato.infradead.org [IPv6:2001:8b0:10b:1:d65d:64ff:fe57:4e05])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 07AC82068B;
        Tue, 14 Feb 2023 07:27:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=desiato.20200630; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=2EnIovssVvP6O5SvRgUEVDWtbXeOafyJH3FigQrR9WM=; b=X5/ZCPe2J5h0cKKIxtipKsW48q
        Q8b18C/bo4pqRbA/604PvLWAudq+XNWTai9gymifQv/P9dlMwu2Ouk5mtsBgq3NnP7AgVfK8xm+EQ
        GEv2XfIus8NpuuHchFRRNwxIXG94DkLagHFngpwV58OIxND6gnANbpevgWqWAiic/R6cWMQ+OL8yV
        HqrED6cR8uNAHFYWcnm6MJUbmpT8e56dHSgKWKmHoSCFciU4NEB5sqFCNj4t45unVxkDaUc+XvcSE
        sEM7vW0cPZOld2DCt2EM1M1qtXY3TRhcfLdcbJc4EvsEw7jASz30jjlaJslzfBtEsPDU12oD9mKNe
        3BOY3ucw==;
Received: from j130084.upc-j.chello.nl ([24.132.130.84] helo=noisy.programming.kicks-ass.net)
        by desiato.infradead.org with esmtpsa (Exim 4.96 #2 (Red Hat Linux))
        id 1pRxC3-009fh2-13;
        Tue, 14 Feb 2023 15:26:08 +0000
Received: from hirez.programming.kicks-ass.net (hirez.programming.kicks-ass.net [192.168.1.225])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        by noisy.programming.kicks-ass.net (Postfix) with ESMTPS id 169E1302E82;
        Tue, 14 Feb 2023 13:42:54 +0100 (CET)
Received: by hirez.programming.kicks-ass.net (Postfix, from userid 1000)
        id EA1D523BC86ED; Tue, 14 Feb 2023 13:42:53 +0100 (CET)
Date:   Tue, 14 Feb 2023 13:42:53 +0100
From:   Peter Zijlstra <peterz@infradead.org>
To:     Kai Huang <kai.huang@intel.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        linux-mm@kvack.org, dave.hansen@intel.com, tglx@linutronix.de,
        seanjc@google.com, pbonzini@redhat.com, dan.j.williams@intel.com,
        rafael.j.wysocki@intel.com, kirill.shutemov@linux.intel.com,
        ying.huang@intel.com, reinette.chatre@intel.com,
        len.brown@intel.com, tony.luck@intel.com, ak@linux.intel.com,
        isaku.yamahata@intel.com, chao.gao@intel.com,
        sathyanarayanan.kuppuswamy@linux.intel.com, david@redhat.com,
        bagasdotme@gmail.com, sagis@google.com, imammedo@redhat.com
Subject: Re: [PATCH v9 05/18] x86/virt/tdx: Add SEAMCALL infrastructure
Message-ID: <Y+uBzZOUt95YTQ4J@hirez.programming.kicks-ass.net>
References: <cover.1676286526.git.kai.huang@intel.com>
 <dd18d6b42768e0107d212fdebedae92cfd72cfe1.1676286526.git.kai.huang@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <dd18d6b42768e0107d212fdebedae92cfd72cfe1.1676286526.git.kai.huang@intel.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Feb 14, 2023 at 12:59:12AM +1300, Kai Huang wrote:
> +/*
> + * Wrapper of __seamcall() to convert SEAMCALL leaf function error code
> + * to kernel error code.  @seamcall_ret and @out contain the SEAMCALL
> + * leaf function return code and the additional output respectively if
> + * not NULL.
> + */
> +static int __always_unused seamcall(u64 fn, u64 rcx, u64 rdx, u64 r8, u64 r9,
> +				    u64 *seamcall_ret,
> +				    struct tdx_module_output *out)
> +{
> +	int cpu, ret = 0;
> +	u64 sret;
> +
> +	/* Need a stable CPU id for printing error message */
> +	cpu = get_cpu();
> +
> +	sret = __seamcall(fn, rcx, rdx, r8, r9, out);
> +
> +	/* Save SEAMCALL return code if the caller wants it */
> +	if (seamcall_ret)
> +		*seamcall_ret = sret;
> +
> +	/* SEAMCALL was successful */
> +	if (!sret)
> +		goto out;

I'm thinking you want if (likely(!sret)), here. That whole switch thing
should end up in cold storage.

> +
> +	switch (sret) {
> +	case TDX_SEAMCALL_GP:
> +		/*
> +		 * tdx_enable() has already checked that BIOS has
> +		 * enabled TDX at the very beginning before going
> +		 * forward.  It's likely a firmware bug if the
> +		 * SEAMCALL still caused #GP.
> +		 */
> +		pr_err_once("[firmware bug]: TDX is not enabled by BIOS.\n");
> +		ret = -ENODEV;
> +		break;
> +	case TDX_SEAMCALL_VMFAILINVALID:
> +		pr_err_once("TDX module is not loaded.\n");
> +		ret = -ENODEV;
> +		break;
> +	case TDX_SEAMCALL_UD:
> +		pr_err_once("SEAMCALL failed: CPU %d is not in VMX operation.\n",
> +				cpu);
> +		ret = -EINVAL;
> +		break;
> +	default:
> +		pr_err_once("SEAMCALL failed: CPU %d: leaf %llu, error 0x%llx.\n",
> +				cpu, fn, sret);
> +		if (out)
> +			pr_err_once("additional output: rcx 0x%llx, rdx 0x%llx, r8 0x%llx, r9 0x%llx, r10 0x%llx, r11 0x%llx.\n",
> +					out->rcx, out->rdx, out->r8,
> +					out->r9, out->r10, out->r11);
> +		ret = -EIO;
> +	}
> +out:
> +	put_cpu();
> +	return ret;
> +}
