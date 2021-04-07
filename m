Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 979CF357090
	for <lists+kvm@lfdr.de>; Wed,  7 Apr 2021 17:40:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242395AbhDGPkT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 7 Apr 2021 11:40:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35518 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231366AbhDGPkR (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 7 Apr 2021 11:40:17 -0400
Received: from desiato.infradead.org (desiato.infradead.org [IPv6:2001:8b0:10b:1:d65d:64ff:fe57:4e05])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 47ACBC061756;
        Wed,  7 Apr 2021 08:40:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=desiato.20200630; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=cI27ms1y8lLpiUqUNPeuv/2lHvb/2VL0ZjKGdez54dI=; b=m8esMUoZiIDjn8rWXyVjcL8n/p
        Tebeu5tJPb5RHhNPR2bPTXVG6MfbdxGxuQaiRW7UWmtAfIY+ZgWP5fkQyWRQrwjErk5fF615lslZS
        hpJaV7SAY1/BZak7RK8Lb8Oz+0JVb0rhMKjEzAoDRQqifDzMl7PO9H1E0O63fi8Bcul0K0XvW97Nm
        muAxPrigaM17dsfJmfZhehG43FUwxCmnZsGPkoam7LRQ+0ud5G2pqYgbRWyaUT/+VVNm01S7G00J8
        K4GIrWYbEh/s2CbFWX/1+xXFJ8UoDzvzc0cJQYjVwAhNUZtjpiCTMieJX2zgdMv3Yw7lGFbaDIukp
        6iqzQxmg==;
Received: from j217100.upc-j.chello.nl ([24.132.217.100] helo=noisy.programming.kicks-ass.net)
        by desiato.infradead.org with esmtpsa (Exim 4.94 #2 (Red Hat Linux))
        id 1lUAHT-005Ij9-3E; Wed, 07 Apr 2021 15:39:47 +0000
Received: from hirez.programming.kicks-ass.net (hirez.programming.kicks-ass.net [192.168.1.225])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (Client did not present a certificate)
        by noisy.programming.kicks-ass.net (Postfix) with ESMTPS id B86393001FB;
        Wed,  7 Apr 2021 17:39:42 +0200 (CEST)
Received: by hirez.programming.kicks-ass.net (Postfix, from userid 1000)
        id A601D2BF09264; Wed,  7 Apr 2021 17:39:42 +0200 (CEST)
Date:   Wed, 7 Apr 2021 17:39:42 +0200
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
        Andi Kleen <ak@linux.intel.com>
Subject: Re: [PATCH v4 08/16] KVM: x86/pmu: Add IA32_DS_AREA MSR emulation to
 manage guest DS buffer
Message-ID: <YG3SPsiFJPeXQXhq@hirez.programming.kicks-ass.net>
References: <20210329054137.120994-1-like.xu@linux.intel.com>
 <20210329054137.120994-9-like.xu@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210329054137.120994-9-like.xu@linux.intel.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Mar 29, 2021 at 01:41:29PM +0800, Like Xu wrote:
> @@ -3869,10 +3876,12 @@ static struct perf_guest_switch_msr *intel_guest_get_msrs(int *nr, void *data)
>  
>  		if (arr[1].guest)
>  			arr[0].guest |= arr[1].guest;
> -		else
> +		else {
>  			arr[1].guest = arr[1].host;
> +			arr[2].guest = arr[2].host;
> +		}

What's all this gibberish?

The way I read that it says:

	if guest has PEBS_ENABLED
		guest GLOBAL_CTRL |= PEBS_ENABLED
	otherwise
		guest PEBS_ENABLED = host PEBS_ENABLED
		guest DS_AREA = host DS_AREA

which is just completely random garbage afaict. Why would you leak host
msrs into the guest? Why would you change guest GLOBAL_CTRL implicitly;
guest had better wrmsr that himself to control when stuff is enabled.

This just cannot be right.
