Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3D1E7135F94
	for <lists+kvm@lfdr.de>; Thu,  9 Jan 2020 18:46:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388270AbgAIRqZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 9 Jan 2020 12:46:25 -0500
Received: from foss.arm.com ([217.140.110.172]:35174 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728724AbgAIRqZ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 9 Jan 2020 12:46:25 -0500
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 58D57328;
        Thu,  9 Jan 2020 09:46:24 -0800 (PST)
Received: from localhost (unknown [10.37.6.20])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id CDE423F703;
        Thu,  9 Jan 2020 09:46:23 -0800 (PST)
Date:   Thu, 9 Jan 2020 17:46:22 +0000
From:   Andrew Murray <andrew.murray@arm.com>
To:     Mark Rutland <mark.rutland@arm.com>
Cc:     Marc Zyngier <maz@kernel.org>, kvm@vger.kernel.org,
        Catalin Marinas <catalin.marinas@arm.com>,
        linux-kernel@vger.kernel.org, Sudeep Holla <sudeep.holla@arm.com>,
        kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v2 11/18] KVM: arm64: don't trap Statistical Profiling
 controls to EL2
Message-ID: <20200109174621.GB42593@e119886-lin.cambridge.arm.com>
References: <20191220143025.33853-1-andrew.murray@arm.com>
 <20191220143025.33853-12-andrew.murray@arm.com>
 <86bls0iqv6.wl-maz@kernel.org>
 <20191223115651.GA42593@e119886-lin.cambridge.arm.com>
 <1bb190091362262021dbaf41b5fe601e@www.loen.fr>
 <20191223121042.GC42593@e119886-lin.cambridge.arm.com>
 <20200109172511.GA42593@e119886-lin.cambridge.arm.com>
 <20200109174251.GJ3112@lakrids.cambridge.arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200109174251.GJ3112@lakrids.cambridge.arm.com>
User-Agent: Mutt/1.10.1+81 (426a6c1) (2018-08-26)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Jan 09, 2020 at 05:42:51PM +0000, Mark Rutland wrote:
> Hi Andrew,
> 
> On Thu, Jan 09, 2020 at 05:25:12PM +0000, Andrew Murray wrote:
> > On Mon, Dec 23, 2019 at 12:10:42PM +0000, Andrew Murray wrote:
> > > On Mon, Dec 23, 2019 at 12:05:12PM +0000, Marc Zyngier wrote:
> > > > On 2019-12-23 11:56, Andrew Murray wrote:
> > > > > My original concern in the cover letter was in how to prevent
> > > > > the guest from attempting to use these registers in the first
> > > > > place - I think the solution I was looking for is to
> > > > > trap-and-emulate ID_AA64DFR0_EL1 such that the PMSVer bits
> > > > > indicate that SPE is not emulated.
> > > > 
> > > > That, and active trapping of the SPE system registers resulting in injection
> > > > of an UNDEF into the offending guest.
> > > 
> > > Yes that's no problem.
> > 
> > The spec says that 'direct access to [these registers] are UNDEFINED' - is it
> > not more correct to handle this with trap_raz_wi than an undefined instruction?
> 
> The term UNDEFINED specifically means treated as an undefined
> instruction. The Glossary in ARM DDI 0487E.a says for UNDEFINED:
> 
> | Indicates cases where an attempt to execute a particular encoding bit
> | pattern generates an exception, that is taken to the current Exception
> | level, or to the default Exception level for taking exceptions if the
> | UNDEFINED encoding was executed at EL0. This applies to:
> |
> | * Any encoding that is not allocated to any instruction.
> |
> | * Any encoding that is defined as never accessible at the current
> |   Exception level.
> |
> | * Some cases where an enable, disable, or trap control means an
> |   encoding is not accessible at the current Exception level.
> 
> So these should trigger an UNDEFINED exception rather than behaving as
> RAZ/WI.

OK thanks for the clarification - I'll leave it as an undefined instruction.

Thanks,

Andrew Murray

> 
> Thanks,
> Mark.
