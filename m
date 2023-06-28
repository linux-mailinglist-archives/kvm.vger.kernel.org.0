Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3EC8A741372
	for <lists+kvm@lfdr.de>; Wed, 28 Jun 2023 16:11:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230219AbjF1OLF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 28 Jun 2023 10:11:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52802 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230060AbjF1OLD (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 28 Jun 2023 10:11:03 -0400
Received: from desiato.infradead.org (desiato.infradead.org [IPv6:2001:8b0:10b:1:d65d:64ff:fe57:4e05])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 10122FB;
        Wed, 28 Jun 2023 07:11:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=desiato.20200630; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=t1UE1YcEx/3OUicSr8z/BxwdM98H5NewX/wXJaCdFrk=; b=KN9eHtrUeD8K5uBlduYTWdmVU0
        BnoJhC4+EfIzFNgShMK+lgnKmk5ySokNqM4QQV2xRysgEDs2tfLnZVA2I9EeWgUH1cQ9eUSnOUvwJ
        lsuJ5n4bDOA0ktg7bN+lJKhMKJyTKHCWZut/VURu+Th7hIvRZut9CPXuLJv4CAZboTJzIq5ub3OBG
        +J1vzhZalUaW+f4qY5EhbZawLqYzk8ruZJSxspunCw53CuW+bIkPAitD4kpY6NHBbpJ5zZYMZKc5h
        kgudLe2y3bI36Qsw9nHv53G3UldK+aajeE4zDbsslFbv//oqf7Gf6eZZPd/UoDqgx3ddnIYprUMy/
        6JSD5CtQ==;
Received: from j130084.upc-j.chello.nl ([24.132.130.84] helo=noisy.programming.kicks-ass.net)
        by desiato.infradead.org with esmtpsa (Exim 4.96 #2 (Red Hat Linux))
        id 1qEVs5-005fcL-0g;
        Wed, 28 Jun 2023 14:10:13 +0000
Received: from hirez.programming.kicks-ass.net (hirez.programming.kicks-ass.net [192.168.1.225])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        by noisy.programming.kicks-ass.net (Postfix) with ESMTPS id 690B5300023;
        Wed, 28 Jun 2023 16:10:11 +0200 (CEST)
Received: by hirez.programming.kicks-ass.net (Postfix, from userid 1000)
        id 521712458D611; Wed, 28 Jun 2023 16:10:11 +0200 (CEST)
Date:   Wed, 28 Jun 2023 16:10:11 +0200
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
Subject: Re: [PATCH v12 08/22] x86/virt/tdx: Get information about TDX module
 and TDX-capable memory
Message-ID: <20230628141011.GG2438817@hirez.programming.kicks-ass.net>
References: <cover.1687784645.git.kai.huang@intel.com>
 <a33f372df345f6232b55e26d498ea67d4adc18f0.1687784645.git.kai.huang@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a33f372df345f6232b55e26d498ea67d4adc18f0.1687784645.git.kai.huang@intel.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Jun 27, 2023 at 02:12:38AM +1200, Kai Huang wrote:
> +static int tdx_get_sysinfo(struct tdsysinfo_struct *sysinfo,
> +			   struct cmr_info *cmr_array)
> +{
> +	struct tdx_module_output out;
> +	u64 sysinfo_pa, cmr_array_pa;
> +	int ret;
> +
> +	sysinfo_pa = __pa(sysinfo);
> +	cmr_array_pa = __pa(cmr_array);
> +	ret = seamcall(TDH_SYS_INFO, sysinfo_pa, TDSYSINFO_STRUCT_SIZE,
> +			cmr_array_pa, MAX_CMRS, NULL, &out);
> +	if (ret)
> +		return ret;
> +
> +	pr_info("TDX module: attributes 0x%x, vendor_id 0x%x, major_version %u, minor_version %u, build_date %u, build_num %u",
> +		sysinfo->attributes,	sysinfo->vendor_id,
> +		sysinfo->major_version, sysinfo->minor_version,
> +		sysinfo->build_date,	sysinfo->build_num);
> +
> +	/* R9 contains the actual entries written to the CMR array. */

So I'm vexed by this comment; it's either not enough or too much.

I mean, as given you assume we all know about the magic parameters to
TDH_SYS_INFO but then somehow need an explanation for how %r9 is changed
from the array size to the number of used entries.

Either describe the whole thing or none of it.

Me, I would prefer all of it, because I've no idea where to begin
looking for any of this, SDM doesn't seem to be the place. That doesn't
even list TDCALL/SEAMCALL in Volume 2 :-( Let alone describe the magic
values.

> +	print_cmrs(cmr_array, out.r9);
> +
> +	return 0;
> +}
