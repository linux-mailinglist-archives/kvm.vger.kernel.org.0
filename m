Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 478C1357098
	for <lists+kvm@lfdr.de>; Wed,  7 Apr 2021 17:41:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236227AbhDGPlS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 7 Apr 2021 11:41:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35756 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235715AbhDGPlR (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 7 Apr 2021 11:41:17 -0400
Received: from desiato.infradead.org (desiato.infradead.org [IPv6:2001:8b0:10b:1:d65d:64ff:fe57:4e05])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 52D9AC061756;
        Wed,  7 Apr 2021 08:41:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=desiato.20200630; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=mnNg26720QrcvOj5pMl+lCkR+DJYA6RC8uuPt2+RH04=; b=dy1lADERjjlGZ2fEGGQ78+xBFZ
        OkGAC2y9rGJRqmf3k4wKbIY1R4qoAYHruHuWyaNfx4/wpGasRKMNiyG1QvtZYcDJAdOFuhgkZeemt
        zyuCBLghXqhPJJnY9pIX1YLHTYpTHNlcHbFr7F7Cq+MjIQeIkmRhy7ny6oGScgse3EZm2Fh2Lbo25
        QHbJD9JRMrBIPE6249ZijiYvLccNV3bTSBhD7C2t0rmvKIScdZSESCe9GEuOGgtxBprjHoUaMlxpI
        4iFTkrzZlL/T71e2SxceecbrnzAlib7ZyTbbR42lfzTI2ooZdvr05GHoLLZurNLqq2bpZUrF+2FIv
        OnbCuPWQ==;
Received: from j217100.upc-j.chello.nl ([24.132.217.100] helo=noisy.programming.kicks-ass.net)
        by desiato.infradead.org with esmtpsa (Exim 4.94 #2 (Red Hat Linux))
        id 1lUAIS-005IqW-CR; Wed, 07 Apr 2021 15:40:48 +0000
Received: from hirez.programming.kicks-ass.net (hirez.programming.kicks-ass.net [192.168.1.225])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (Client did not present a certificate)
        by noisy.programming.kicks-ass.net (Postfix) with ESMTPS id 142B43001FB;
        Wed,  7 Apr 2021 17:40:48 +0200 (CEST)
Received: by hirez.programming.kicks-ass.net (Postfix, from userid 1000)
        id 06A4A2BF09264; Wed,  7 Apr 2021 17:40:48 +0200 (CEST)
Date:   Wed, 7 Apr 2021 17:40:47 +0200
From:   Peter Zijlstra <peterz@infradead.org>
To:     Like Xu <like.xu@linux.intel.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>, eranian@google.com,
        andi@firstfloor.org, kan.liang@linux.intel.com,
        wei.w.wang@intel.com, Wanpeng Li <wanpengli@tencent.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        x86@kernel.org, linux-kernel@vger.kernel.org,
        Luwei Kang <luwei.kang@intel.com>
Subject: Re: [PATCH v4 09/16] KVM: x86/pmu: Add PEBS_DATA_CFG MSR emulation
 to support adaptive PEBS
Message-ID: <YG3Sfy2T8tjqSgkp@hirez.programming.kicks-ass.net>
References: <20210329054137.120994-1-like.xu@linux.intel.com>
 <20210329054137.120994-10-like.xu@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210329054137.120994-10-like.xu@linux.intel.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Mar 29, 2021 at 01:41:30PM +0800, Like Xu wrote:
> @@ -3863,6 +3864,12 @@ static struct perf_guest_switch_msr *intel_guest_get_msrs(int *nr, void *data)
>  		arr[2].host = (unsigned long)ds;
>  		arr[2].guest = pmu->ds_area;

		*nr = 3;
>  
> +		if (baseline) {
> +			arr[3].msr = MSR_PEBS_DATA_CFG;
> +			arr[3].host = cpuc->pebs_data_cfg;
> +			arr[3].guest = pmu->pebs_data_cfg;

			*nr = 4;
> +		}
> +
>  		/*
>  		 * If PMU counter has PEBS enabled it is not enough to
>  		 * disable counter on a guest entry since PEBS memory
> @@ -3879,9 +3886,11 @@ static struct perf_guest_switch_msr *intel_guest_get_msrs(int *nr, void *data)
>  		else {
>  			arr[1].guest = arr[1].host;
>  			arr[2].guest = arr[2].host;
> +			if (baseline)
> +				arr[3].guest = arr[3].host;
>  		}
>  
> -		*nr = 3;
> +		*nr = baseline ? 4 : 3;

And you don't need yet another branch to determine a value you already
know.

>  	}
