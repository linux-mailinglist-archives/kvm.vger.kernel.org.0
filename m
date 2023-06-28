Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0A41A7411DC
	for <lists+kvm@lfdr.de>; Wed, 28 Jun 2023 14:59:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231361AbjF1M7B (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 28 Jun 2023 08:59:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43476 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231237AbjF1M6o (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 28 Jun 2023 08:58:44 -0400
Received: from desiato.infradead.org (desiato.infradead.org [IPv6:2001:8b0:10b:1:d65d:64ff:fe57:4e05])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8C81F19B1;
        Wed, 28 Jun 2023 05:58:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=desiato.20200630; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=zblRw/4j1zlPqX3Dlun6zv4SMoiOHGXrVw0l++uKd7o=; b=XVBu/kW3Q71u5MMQF5W/TdFu++
        oTydPtSEv1z9Oz8kaUTyYOvEdD+a9Rva9LBMBGf9XfQB6ziGwhH1FTXSdprTYWXW1kMWhJiGV3jSI
        l1nmyoh26nis6AOtKyG4xgefOar78evVQb7hQDKLH9ydeOwVXVwh6EkDZqQ94QCcoxGd5aIcP7dGJ
        3h1dmIWjqnaEGvJQcBzuR2oKJSphBjwEAwmObHTiBMfSn851xJRTfyu/GzzdbHxEKA+jZSB4wWAmY
        ZuqKPwW8KKpaSxoldJ398TQqcxlGqODv/jocuFxsUoacmaG8frBdZ17RY980wzImZk+K38gC31DWJ
        kJWp8Sjw==;
Received: from j130084.upc-j.chello.nl ([24.132.130.84] helo=noisy.programming.kicks-ass.net)
        by desiato.infradead.org with esmtpsa (Exim 4.96 #2 (Red Hat Linux))
        id 1qEUkR-005eCg-32;
        Wed, 28 Jun 2023 12:58:16 +0000
Received: from hirez.programming.kicks-ass.net (hirez.programming.kicks-ass.net [192.168.1.225])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        by noisy.programming.kicks-ass.net (Postfix) with ESMTPS id 38A1030005E;
        Wed, 28 Jun 2023 14:58:13 +0200 (CEST)
Received: by hirez.programming.kicks-ass.net (Postfix, from userid 1000)
        id 225F827F62B9F; Wed, 28 Jun 2023 14:58:13 +0200 (CEST)
Date:   Wed, 28 Jun 2023 14:58:13 +0200
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
Message-ID: <20230628125813.GA2438817@hirez.programming.kicks-ass.net>
References: <cover.1687784645.git.kai.huang@intel.com>
 <b2a875fd855145728744617ac4425a06d8b46c90.1687784645.git.kai.huang@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b2a875fd855145728744617ac4425a06d8b46c90.1687784645.git.kai.huang@intel.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Jun 27, 2023 at 02:12:35AM +1200, Kai Huang wrote:

> +static int __always_unused seamcall(u64 fn, u64 rcx, u64 rdx, u64 r8, u64 r9,

__always_inline perhaps? __always_unused seems wrong, worse it's still
there at the end of the series:

$ quilt diff --combine - | grep seamcall
...
+static int __always_unused seamcall(u64 fn, u64 rcx, u64 rdx, u64 r8, u64 r9,
...
+       ret = seamcall(TDH_SYS_INIT, 0, 0, 0, 0, NULL, NULL);
+       ret = seamcall(TDH_SYS_LP_INIT, 0, 0, 0, 0, NULL, NULL);
+       ret = seamcall(TDH_SYS_INFO, sysinfo_pa, TDSYSINFO_STRUCT_SIZE,
+       ret = seamcall(TDH_SYS_CONFIG, __pa(tdmr_pa_array),
+       return seamcall(TDH_SYS_KEY_CONFIG, 0, 0, 0, 0, NULL, NULL);
+               ret = seamcall(TDH_SYS_TDMR_INIT, tdmr->base, 0, 0, 0, NULL,
...

Definitely not unused.

> +				    u64 *seamcall_ret,
> +				    struct tdx_module_output *out)

This interface is atrocious :/ Why have these two ret values? Why can't
that live in a single space -- /me looks throught the callers, and finds
seamcall_ret is unused :-(

Worse, the input (c,d,8,9) is a strict subset of the output
(c,d,8,9,10,11) so why isn't that a single thing used for both input and
output.

struct tdx_call {
	u64 rcx, rdx, r8, r9, r10, r11;
};

static int __always_inline seamcall(u64 fn, struct tdx_call *regs)
{
}


	struct tdx_regs regs = { };
	ret = seamcall(THD_SYS_INIT, &regs);



	struct tdx_regs regs = {
		.rcx = sysinfo_pa,	.rdx = TDXSYSINFO_STRUCT_SIZE,
		.r8  = cmr_array_pa,	.r9  = MAX_CMRS,
	};
	ret = seamcall(THD_SYS_INFO, &regs);
	if (ret)
		return ret;

	print_cmrs(cmr_array, regs.r9);


/me looks more at this stuff and ... WTF!?!?

Can someone explain to me why __tdx_hypercall() is sane (per the above)
but then we grew __tdx_module_call() as an absolute abomination and are
apparently using that for seam too?




> +{
> +	u64 sret;
> +	int cpu;
> +
> +	/* Need a stable CPU id for printing error message */
> +	cpu = get_cpu();

And that's important because? Does having preemption off across the
seamcall make sense? Does it still make sense when you add a loop later?

> +	sret = __seamcall(fn, rcx, rdx, r8, r9, out);
> +	put_cpu();
> +
> +	/* Save SEAMCALL return code if the caller wants it */
> +	if (seamcall_ret)
> +		*seamcall_ret = sret;
> +
> +	switch (sret) {
> +	case 0:
> +		/* SEAMCALL was successful */
> +		return 0;
> +	case TDX_SEAMCALL_VMFAILINVALID:
> +		pr_err_once("module is not loaded.\n");
> +		return -ENODEV;
> +	default:
> +		pr_err_once("SEAMCALL failed: CPU %d: leaf %llu, error 0x%llx.\n",
> +				cpu, fn, sret);
> +		if (out)
> +			pr_err_once("additional output: rcx 0x%llx, rdx 0x%llx, r8 0x%llx, r9 0x%llx, r10 0x%llx, r11 0x%llx.\n",
> +					out->rcx, out->rdx, out->r8,
> +					out->r9, out->r10, out->r11);

At the very least this lacks { }, but it is quite horrendous coding
style.

Why switch() at all, would not:

	if (!rset)
		return 0;

	if (sret == TDX_SEAMCALL_VMFAILINVALID) {
		pr_nonsense();
		return -ENODEV;
	}

	if (sret == TDX_SEAMCALL_GP) {
		pr_nonsense();
		return -ENODEV;
	}

	if (sret == TDX_SEAMCALL_UD) {
		pr_nonsense();
		return -EINVAL;
	}

	pr_nonsense();
	return -EIO;

be much clearer and have less horrific indenting issues?

> +		return -EIO;
> +	}
> +}
