Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C049317DCE6
	for <lists+kvm@lfdr.de>; Mon,  9 Mar 2020 11:05:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726379AbgCIKFS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 9 Mar 2020 06:05:18 -0400
Received: from bombadil.infradead.org ([198.137.202.133]:33420 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725796AbgCIKFR (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 9 Mar 2020 06:05:17 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=cH9d5s5skj+POkYSuWj5kZEqcL/x30ONYbTKCTwNqJo=; b=gqsfUsenwszWL3nli8z5CzNc2i
        W+77bUrm7N3nyuSb4y+Oev7DBRugilabh+W6Dlsrl1M8N+uTNCumnq79J4R5xM8raQDE6KcW8+mjl
        kUXxLI6ljPz+p5pmmZRstg8jzkWc8ADF6HDeZRw5IcE5p1sjPKutoarcxOyv70E+3TVF/DXMJgQZU
        /VK8oliwK4CGXtlYV7Sg6dTjKS7WUGGQvOrAgknXM2oUHm/xgIrgw7mgH7hfK2xlr+JC50s9X1b5I
        5cam09L3pNDVTpQOlzZAZhfgaRZdkh/l2FKuBJJ2iDhyaUguAPwfLPs83aYlzi2iSvS2r4US/7sef
        wjAO1ifQ==;
Received: from j217100.upc-j.chello.nl ([24.132.217.100] helo=noisy.programming.kicks-ass.net)
        by bombadil.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jBFHC-0004fF-FA; Mon, 09 Mar 2020 10:04:46 +0000
Received: from hirez.programming.kicks-ass.net (hirez.programming.kicks-ass.net [192.168.1.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (Client did not present a certificate)
        by noisy.programming.kicks-ass.net (Postfix) with ESMTPS id 2620430066E;
        Mon,  9 Mar 2020 11:04:43 +0100 (CET)
Received: by hirez.programming.kicks-ass.net (Postfix, from userid 1000)
        id 1166B25F2A4F2; Mon,  9 Mar 2020 11:04:43 +0100 (CET)
Date:   Mon, 9 Mar 2020 11:04:43 +0100
From:   Peter Zijlstra <peterz@infradead.org>
To:     "Liang, Kan" <kan.liang@linux.intel.com>
Cc:     Luwei Kang <luwei.kang@intel.com>, x86@kernel.org,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        mingo@redhat.com, acme@kernel.org, mark.rutland@arm.com,
        alexander.shishkin@linux.intel.com, jolsa@redhat.com,
        namhyung@kernel.org, tglx@linutronix.de, bp@alien8.de,
        hpa@zytor.com, pbonzini@redhat.com,
        sean.j.christopherson@intel.com, vkuznets@redhat.com,
        wanpengli@tencent.com, jmattson@google.com, joro@8bytes.org,
        pawan.kumar.gupta@linux.intel.com, ak@linux.intel.com,
        thomas.lendacky@amd.com, fenghua.yu@intel.com,
        like.xu@linux.intel.com
Subject: Re: [PATCH v1 01/11] perf/x86/core: Support KVM to assign a
 dedicated counter for guest PEBS
Message-ID: <20200309100443.GG12561@hirez.programming.kicks-ass.net>
References: <1583431025-19802-1-git-send-email-luwei.kang@intel.com>
 <1583431025-19802-2-git-send-email-luwei.kang@intel.com>
 <20200306135317.GD12561@hirez.programming.kicks-ass.net>
 <b72cb68e-1a0a-eeff-21b4-ce412e939cfd@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b72cb68e-1a0a-eeff-21b4-ce412e939cfd@linux.intel.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Mar 06, 2020 at 09:42:47AM -0500, Liang, Kan wrote:
> 
> 
> On 3/6/2020 8:53 AM, Peter Zijlstra wrote:
> > On Fri, Mar 06, 2020 at 01:56:55AM +0800, Luwei Kang wrote:
> > > From: Kan Liang <kan.liang@linux.intel.com>
> > > 
> > > The PEBS event created by host needs to be assigned specific counters
> > > requested by the guest, which means the guest and host counter indexes
> > > have to be the same or fail to create. This is needed because PEBS leaks
> > > counter indexes into the guest. Otherwise, the guest driver will be
> > > confused by the counter indexes in the status field of the PEBS record.
> > > 
> > > A guest_dedicated_idx field is added to indicate the counter index
> > > specifically requested by KVM. The dedicated event constraints would
> > > constrain the counter in the host to the same numbered counter in guest.
> > > 
> > > A intel_ctrl_guest_dedicated_mask field is added to indicate the enabled
> > > counters for guest PEBS events. The IA32_PEBS_ENABLE MSR will be switched
> > > during the VMX transitions if intel_ctrl_guest_owned is set.
> > > 
> > 
> > > +	/* the guest specified counter index of KVM owned event, e.g PEBS */
> > > +	int				guest_dedicated_idx;
> > 
> > We've always objected to guest 'owned' counters, they destroy scheduling
> > freedom. Why are you expecting that to be any different this time?
> > 
> 
> The new proposal tries to 'own' a counter by setting the event constraint.
> It doesn't stop other events using the counter.
> If there is high priority event which requires the same counter, scheduler
> can still reject the request from KVM.
> I don't think it destroys the scheduling freedom this time.

Suppose your KVM thing claims counter 0/2 (ICL/SKL) for some random PEBS
event, and then the host wants to use PREC_DIST.. Then one of them will
be screwed for no reason what so ever.

How is that not destroying scheduling freedom? Any other situation we'd
have moved the !PREC_DIST PEBS event to another counter.
