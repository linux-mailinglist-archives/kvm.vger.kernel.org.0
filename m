Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B80701D94E6
	for <lists+kvm@lfdr.de>; Tue, 19 May 2020 13:06:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728647AbgESLGN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 19 May 2020 07:06:13 -0400
Received: from merlin.infradead.org ([205.233.59.134]:32846 "EHLO
        merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726121AbgESLGM (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 19 May 2020 07:06:12 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=merlin.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=J9d+m4V5triwaXNGvm5EH9MRoAlSjk0m+9i2L2q2oJk=; b=Bs+G7VX1wRWj6afTmpcUxLpoi/
        JBtUsQIVq//6O+iZjieaPDTS8aED+dpeTxPG84OFimXYcb9AN9hznGDEmnHTPRi+84ZGUI3pirhvh
        FN8sIWI5Z2HJaLgK7CQQZBLk4A74x23YufEi4WMRfTQ2Jj76ITvKKQM6U7YqQuESPBOIXZLBpCshl
        hRX2Ypjw49xHp2pscgjpc9fMgSyn6pb2EZGEuhFssdW3K+EsjrCUQ36cwiGvKAPjBCDu+94uIe1hs
        BeuY86keLJwVRZ99VXfDU/xWc9XEqLAMqPz4bV4GWwPXQC6MS6Lvbatqzi7AHanP8WyGTu1UmoP3U
        5vxLEsWw==;
Received: from j217100.upc-j.chello.nl ([24.132.217.100] helo=noisy.programming.kicks-ass.net)
        by merlin.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jb02O-0005ff-Pv; Tue, 19 May 2020 11:03:56 +0000
Received: from hirez.programming.kicks-ass.net (hirez.programming.kicks-ass.net [192.168.1.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (Client did not present a certificate)
        by noisy.programming.kicks-ass.net (Postfix) with ESMTPS id 3A547304A59;
        Tue, 19 May 2020 13:03:55 +0200 (CEST)
Received: by hirez.programming.kicks-ass.net (Postfix, from userid 1000)
        id 25A7220BE636B; Tue, 19 May 2020 13:03:55 +0200 (CEST)
Date:   Tue, 19 May 2020 13:03:55 +0200
From:   Peter Zijlstra <peterz@infradead.org>
To:     Like Xu <like.xu@linux.intel.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Thomas Gleixner <tglx@linutronix.de>, ak@linux.intel.com,
        wei.w.wang@intel.com
Subject: Re: [PATCH v11 08/11] KVM: x86/pmu: Emulate LBR feature via guest
 LBR event
Message-ID: <20200519110355.GI279861@hirez.programming.kicks-ass.net>
References: <20200514083054.62538-1-like.xu@linux.intel.com>
 <20200514083054.62538-9-like.xu@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200514083054.62538-9-like.xu@linux.intel.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, May 14, 2020 at 04:30:51PM +0800, Like Xu wrote:
> @@ -6698,6 +6698,7 @@ static fastpath_t vmx_vcpu_run(struct kvm_vcpu *vcpu)
>  
>  	if (vcpu_to_pmu(vcpu)->version)
>  		atomic_switch_perf_msrs(vmx);
> +
>  	atomic_switch_umwait_control_msr(vmx);
>  
>  	if (enable_preemption_timer)

Is this where the test to see if any of the KVM events went into ERROR
state should go?

	if (event->state == PERF_EVENT_STATE_ERROR) {
		pr_warn("unhappy, someone stole our counter\n");
	}

like..
