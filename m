Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0524A572A1
	for <lists+kvm@lfdr.de>; Wed, 26 Jun 2019 22:35:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726399AbfFZUfI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 26 Jun 2019 16:35:08 -0400
Received: from Galois.linutronix.de ([193.142.43.55]:50304 "EHLO
        Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726223AbfFZUfI (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 26 Jun 2019 16:35:08 -0400
Received: from p5b06daab.dip0.t-ipconnect.de ([91.6.218.171] helo=nanos)
        by Galois.linutronix.de with esmtpsa (TLS1.2:DHE_RSA_AES_256_CBC_SHA256:256)
        (Exim 4.80)
        (envelope-from <tglx@linutronix.de>)
        id 1hgEd3-0006Ow-24; Wed, 26 Jun 2019 22:34:53 +0200
Date:   Wed, 26 Jun 2019 22:34:52 +0200 (CEST)
From:   Thomas Gleixner <tglx@linutronix.de>
To:     Fenghua Yu <fenghua.yu@intel.com>
cc:     Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        H Peter Anvin <hpa@zytor.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Dave Hansen <dave.hansen@intel.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Radim Krcmar <rkrcmar@redhat.com>,
        Christopherson Sean J <sean.j.christopherson@intel.com>,
        Ashok Raj <ashok.raj@intel.com>,
        Tony Luck <tony.luck@intel.com>,
        Dan Williams <dan.j.williams@intel.com>,
        Xiaoyao Li <xiaoyao.li@intel.com>,
        Sai Praneeth Prakhya <sai.praneeth.prakhya@intel.com>,
        Ravi V Shankar <ravi.v.shankar@intel.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        x86 <x86@kernel.org>, kvm@vger.kernel.org
Subject: Re: [PATCH v9 13/17] x86/split_lock: Disable split lock detection
 by kernel parameter "nosplit_lock_detect"
In-Reply-To: <1560897679-228028-14-git-send-email-fenghua.yu@intel.com>
Message-ID: <alpine.DEB.2.21.1906262232220.32342@nanos.tec.linutronix.de>
References: <1560897679-228028-1-git-send-email-fenghua.yu@intel.com> <1560897679-228028-14-git-send-email-fenghua.yu@intel.com>
User-Agent: Alpine 2.21 (DEB 202 2017-01-01)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 18 Jun 2019, Fenghua Yu wrote:
>  
>  static void split_lock_update_msr(void)
>  {
> -	/* Enable split lock detection */
> -	this_cpu_or(msr_test_ctl_cached, MSR_TEST_CTL_SPLIT_LOCK_DETECT);
> +	if (split_lock_detect_enabled) {
> +		/* Enable split lock detection */
> +		this_cpu_or(msr_test_ctl_cached, MSR_TEST_CTL_SPLIT_LOCK_DETECT);
> +	} else {
> +		/* Disable split lock detection */

Could you please comment the non obvious things and not the obvious ones?

> +		this_cpu_and(msr_test_ctl_cached, ~MSR_TEST_CTL_SPLIT_LOCK_DETECT);

It's entirely clear that the if (enabled) path enables it or am I missing
something?

Thanks,

	tglx
