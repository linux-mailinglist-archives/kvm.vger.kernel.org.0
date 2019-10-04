Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 745E1CB7A4
	for <lists+kvm@lfdr.de>; Fri,  4 Oct 2019 11:51:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387674AbfJDJvZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 4 Oct 2019 05:51:25 -0400
Received: from mx1.redhat.com ([209.132.183.28]:58226 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387564AbfJDJvY (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 4 Oct 2019 05:51:24 -0400
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 4323F18C4290;
        Fri,  4 Oct 2019 09:51:24 +0000 (UTC)
Received: from kamzik.brq.redhat.com (unknown [10.43.2.160])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id E365660BE1;
        Fri,  4 Oct 2019 09:51:18 +0000 (UTC)
Date:   Fri, 4 Oct 2019 11:51:16 +0200
From:   Andrew Jones <drjones@redhat.com>
To:     Steven Price <steven.price@arm.com>
Cc:     Marc Zyngier <maz@kernel.org>, Will Deacon <will@kernel.org>,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        Catalin Marinas <catalin.marinas@arm.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Radim =?utf-8?B?S3LEjW3DocWZ?= <rkrcmar@redhat.com>,
        Russell King <linux@armlinux.org.uk>,
        James Morse <james.morse@arm.com>,
        Julien Thierry <julien.thierry.kdev@gmail.com>,
        Suzuki K Pouloze <suzuki.poulose@arm.com>,
        Mark Rutland <mark.rutland@arm.com>, kvm@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v5 05/10] KVM: arm64: Support stolen time reporting via
 shared structure
Message-ID: <20191004095116.a6bi46y76chik3kd@kamzik.brq.redhat.com>
References: <20191002145037.51630-1-steven.price@arm.com>
 <20191002145037.51630-6-steven.price@arm.com>
 <20191003132235.ruanyfmdim5s6npj@kamzik.brq.redhat.com>
 <20191004070301.d7ari5rjlu3uuara@kamzik.brq.redhat.com>
 <b107c1ca-6804-dc47-af25-fcd0b201472f@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b107c1ca-6804-dc47-af25-fcd0b201472f@arm.com>
User-Agent: NeoMutt/20180716
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.6.2 (mx1.redhat.com [10.5.110.62]); Fri, 04 Oct 2019 09:51:24 +0000 (UTC)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Oct 04, 2019 at 10:13:40AM +0100, Steven Price wrote:
> On 04/10/2019 08:03, Andrew Jones wrote:
> > On Thu, Oct 03, 2019 at 03:22:35PM +0200, Andrew Jones wrote:
> >> On Wed, Oct 02, 2019 at 03:50:32PM +0100, Steven Price wrote:
> >>> +int kvm_update_stolen_time(struct kvm_vcpu *vcpu, bool init)
> >>> +{
> >>> +	struct kvm *kvm = vcpu->kvm;
> >>> +	u64 steal;
> >>> +	u64 steal_le;
> >>> +	u64 offset;
> >>> +	int idx;
> >>> +	u64 base = vcpu->arch.steal.base;
> >>> +
> >>> +	if (base == GPA_INVALID)
> >>> +		return -ENOTSUPP;
> >>> +
> >>> +	/* Let's do the local bookkeeping */
> >>> +	steal = vcpu->arch.steal.steal;
> >>> +	steal += current->sched_info.run_delay - vcpu->arch.steal.last_steal;
> >>> +	vcpu->arch.steal.last_steal = current->sched_info.run_delay;
> >>> +	vcpu->arch.steal.steal = steal;
> >>> +
> >>> +	steal_le = cpu_to_le64(steal);
> >>
> >> Agreeing on a byte order for this interface makes sense, but I don't see
> >> it documented anywhere. Is this an SMCCC thing? Because I skimmed some
> >> of those specs and other users too but didn't see anything obvious. Anyway
> >> even if everybody but me knows that all data returned from SMCCC calls
> >> should be LE, it might be nice to document that in the pvtime doc.
> 
> A very good point - I'll document this in the Linux document and feed
> that back for DEN0057A.
> 
> > 
> > I have another [potentially dumb] SMCCC byte order question. If we need
> > to worry about using LE for the members of this structure, then why don't
> > we need to worry about the actual return values of the SMCCC calls? Like
> > the IPA of the structure?
> 
> The SMCCC calls pass values in registers. It's only when reading/writing
> these values from/to memory that the endianness actually has any meaning.
>

Ah yes, of course.

Thanks,
drew 
