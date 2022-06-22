Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6A6AC554CF2
	for <lists+kvm@lfdr.de>; Wed, 22 Jun 2022 16:27:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354869AbiFVO0y (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 22 Jun 2022 10:26:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50738 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231184AbiFVO0x (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 22 Jun 2022 10:26:53 -0400
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 890B037ABF;
        Wed, 22 Jun 2022 07:26:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1655908012; x=1687444012;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=A7d2cHs1rusgGR62BUfFzsw6JwNIj4DohjCVILdINzQ=;
  b=CBCXtsdpQnhnc0gLEuRtzG3o75ff7DBf4F07oZqU4SjFuXGVfiPq7UV/
   EzkzH0Iw5+vqdl6QEpDYLNVzqZ2yAD9raiuNGPgYGDFpe7vxdOt4pySr0
   i0TSeF/Mp1IAzE9QrWQ3A+wM4GOkRDOPpfYWVTjGaQ/pA3UuSQSiK1j5x
   utp4Eu5cwv9e/wu9zUDEnhqY5DsV0nBgQKwgFPBMwAT0Tljm6m/Kazeda
   AqY0cMYWtcGHI+nJpkYcL3YypBqsy8XgCBYF0oEUNKWsICgLePZtXPh4z
   oPpu8KrQrxrOsVNVp4BwIXeuNJuVuDwq36oUCZWSeNJoZNgREALTBO6aj
   Q==;
X-IronPort-AV: E=McAfee;i="6400,9594,10385"; a="281160312"
X-IronPort-AV: E=Sophos;i="5.92,212,1650956400"; 
   d="scan'208";a="281160312"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Jun 2022 07:26:51 -0700
X-IronPort-AV: E=Sophos;i="5.92,212,1650956400"; 
   d="scan'208";a="677569503"
Received: from bshakya-mobl.amr.corp.intel.com (HELO [10.212.188.76]) ([10.212.188.76])
  by fmsmga003-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Jun 2022 07:26:49 -0700
Message-ID: <d89c695e-7d45-160f-5e28-fee5ee576104@intel.com>
Date:   Wed, 22 Jun 2022 07:26:31 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.1
Subject: Re: [PATCH Part2 v6 06/49] x86/sev: Add helper functions for
 RMPUPDATE and PSMASH instruction
Content-Language: en-US
To:     Ashish Kalra <Ashish.Kalra@amd.com>, x86@kernel.org,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        linux-coco@lists.linux.dev, linux-mm@kvack.org,
        linux-crypto@vger.kernel.org
Cc:     tglx@linutronix.de, mingo@redhat.com, jroedel@suse.de,
        thomas.lendacky@amd.com, hpa@zytor.com, ardb@kernel.org,
        pbonzini@redhat.com, seanjc@google.com, vkuznets@redhat.com,
        jmattson@google.com, luto@kernel.org, dave.hansen@linux.intel.com,
        slp@redhat.com, pgonda@google.com, peterz@infradead.org,
        srinivas.pandruvada@linux.intel.com, rientjes@google.com,
        dovmurik@linux.ibm.com, tobin@ibm.com, bp@alien8.de,
        michael.roth@amd.com, vbabka@suse.cz, kirill@shutemov.name,
        ak@linux.intel.com, tony.luck@intel.com, marcorr@google.com,
        sathyanarayanan.kuppuswamy@linux.intel.com, alpergun@google.com,
        dgilbert@redhat.com, jarkko@kernel.org
References: <cover.1655761627.git.ashish.kalra@amd.com>
 <e4643e9d37fcb025d0aec9080feefaae5e9245d5.1655761627.git.ashish.kalra@amd.com>
From:   Dave Hansen <dave.hansen@intel.com>
In-Reply-To: <e4643e9d37fcb025d0aec9080feefaae5e9245d5.1655761627.git.ashish.kalra@amd.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-5.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 6/20/22 16:02, Ashish Kalra wrote:
> +int psmash(u64 pfn)
> +{
> +	unsigned long paddr = pfn << PAGE_SHIFT;
> +	int ret;
> +
> +	if (!pfn_valid(pfn))
> +		return -EINVAL;
> +
> +	if (!cpu_feature_enabled(X86_FEATURE_SEV_SNP))
> +		return -ENXIO;
> +
> +	/* Binutils version 2.36 supports the PSMASH mnemonic. */
> +	asm volatile(".byte 0xF3, 0x0F, 0x01, 0xFF"
> +		      : "=a"(ret)
> +		      : "a"(paddr)
> +		      : "memory", "cc");
> +
> +	return ret;
> +}
> +EXPORT_SYMBOL_GPL(psmash);

If a function gets an EXPORT_SYMBOL_GPL(), the least we can do is
reasonably document it.  We don't need full kerneldoc nonsense, but a
one-line about what this does would be quite helpful.  That goes for all
the functions here.

It would also be extremely helpful to have the changelog explain why
these functions are exported and how the exports will be used.

As a general rule, please push cpu_feature_enabled() checks as early as
you reasonably can.  They are *VERY* cheap and can even enable the
compiler to completely zap code like an #ifdef.

There also seem to be a lot of pfn_valid() checks in here that aren't
very well thought out.  For instance, there's a pfn_valid() check here:


+int rmp_make_shared(u64 pfn, enum pg_level level)
+{
+	struct rmpupdate val;
+
+	if (!pfn_valid(pfn))
+		return -EINVAL;
...
+	return rmpupdate(pfn, &val);
+}

and in rmpupdate():

+static int rmpupdate(u64 pfn, struct rmpupdate *val)
+{
+	unsigned long paddr = pfn << PAGE_SHIFT;
+	int ret;
+
+	if (!pfn_valid(pfn))
+		return -EINVAL;
...


This is (at best) wasteful.  Could it be refactored?
