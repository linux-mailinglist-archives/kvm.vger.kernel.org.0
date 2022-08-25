Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 751A25A1752
	for <lists+kvm@lfdr.de>; Thu, 25 Aug 2022 18:58:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242631AbiHYQ63 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 25 Aug 2022 12:58:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41552 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239344AbiHYQ6Y (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 25 Aug 2022 12:58:24 -0400
Received: from out0.migadu.com (out0.migadu.com [IPv6:2001:41d0:2:267::])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 58857AFAE4
        for <kvm@vger.kernel.org>; Thu, 25 Aug 2022 09:58:23 -0700 (PDT)
Date:   Thu, 25 Aug 2022 09:58:09 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1661446701;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=23LQr+BJhfVdQfv6GAKyN2WcdFY338AxJHz2RBNuoO0=;
        b=C/uCf0Lc2rScl/KZeL7T6K12Gtj0qfj9SX4MfVwAvFeXiaWQmHIFyOhv8HJqSOm4ZujbLX
        uYgcabc7AWWiuKfiCv2o0nSdiM208/HH9sQs89lXqq+blkCq1iAOabOfvxSJMLiPPpHfNA
        pHAz3AOn2NJyI9GHeCh4zAoYvcPK8sU=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From:   Oliver Upton <oliver.upton@linux.dev>
To:     Ricardo Koller <ricarkol@google.com>
Cc:     Reiji Watanabe <reijiw@google.com>, kvm@vger.kernel.org,
        Marc Zyngier <maz@kernel.org>,
        Andrew Jones <andrew.jones@linux.dev>,
        Paolo Bonzini <pbonzini@redhat.com>,
        kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 1/9] KVM: arm64: selftests: Add helpers to extract a
 field of an ID register
Message-ID: <YweqIefFbP107fe+@google.com>
References: <20220825050846.3418868-1-reijiw@google.com>
 <20220825050846.3418868-2-reijiw@google.com>
 <Ywen44OKe8gGcOcW@google.com>
 <Yweo5cmA6D0pxwmJ@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Yweo5cmA6D0pxwmJ@google.com>
X-Migadu-Flow: FLOW_OUT
X-Migadu-Auth-User: linux.dev
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_PASS,
        SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Aug 25, 2022 at 09:52:53AM -0700, Ricardo Koller wrote:
> On Thu, Aug 25, 2022 at 09:48:35AM -0700, Oliver Upton wrote:
> > Hi Reiji,
> > 
> > On Wed, Aug 24, 2022 at 10:08:38PM -0700, Reiji Watanabe wrote:
> > > Introduce helpers to extract a field of an ID register.
> > > Subsequent patches will use those helpers.
> > > 
> > > Signed-off-by: Reiji Watanabe <reijiw@google.com>
> > > ---
> > >  .../selftests/kvm/include/aarch64/processor.h     |  2 ++
> > >  .../testing/selftests/kvm/lib/aarch64/processor.c | 15 +++++++++++++++
> > >  2 files changed, 17 insertions(+)
> > > 
> > > diff --git a/tools/testing/selftests/kvm/include/aarch64/processor.h b/tools/testing/selftests/kvm/include/aarch64/processor.h
> > > index a8124f9dd68a..a9b4b4e0e592 100644
> > > --- a/tools/testing/selftests/kvm/include/aarch64/processor.h
> > > +++ b/tools/testing/selftests/kvm/include/aarch64/processor.h
> > > @@ -193,4 +193,6 @@ void smccc_hvc(uint32_t function_id, uint64_t arg0, uint64_t arg1,
> > >  
> > >  uint32_t guest_get_vcpuid(void);
> > >  
> > > +int cpuid_get_sfield(uint64_t val, int field_shift);
> > > +unsigned int cpuid_get_ufield(uint64_t val, int field_shift);
> > >  #endif /* SELFTEST_KVM_PROCESSOR_H */
> > > diff --git a/tools/testing/selftests/kvm/lib/aarch64/processor.c b/tools/testing/selftests/kvm/lib/aarch64/processor.c
> > > index 6f5551368944..0b2ad46e7ff5 100644
> > > --- a/tools/testing/selftests/kvm/lib/aarch64/processor.c
> > > +++ b/tools/testing/selftests/kvm/lib/aarch64/processor.c
> > > @@ -528,3 +528,18 @@ void smccc_hvc(uint32_t function_id, uint64_t arg0, uint64_t arg1,
> > >  		       [arg4] "r"(arg4), [arg5] "r"(arg5), [arg6] "r"(arg6)
> > >  		     : "x0", "x1", "x2", "x3", "x4", "x5", "x6", "x7");
> > >  }
> > > +
> > > +/* Helpers to get a signed/unsigned feature field from ID register value */
> > > +int cpuid_get_sfield(uint64_t val, int field_shift)
> > > +{
> > > +	int width = 4;
> > > +
> > > +	return (int64_t)(val << (64 - width - field_shift)) >> (64 - width);
> > > +}
> > 
> > I don't believe this helper is ever used.
> > 
> > > +unsigned int cpuid_get_ufield(uint64_t val, int field_shift)
> > > +{
> > > +	int width = 4;
> > > +
> > > +	return (uint64_t)(val << (64 - width - field_shift)) >> (64 - width);
> > > +}
> > 
> > I would recommend not open-coding this and instead make use of
> > ARM64_FEATURE_MASK(). You could pull in linux/bitfield.h to tools, or do
> > something like this:
> > 
> >   #define ARM64_FEATURE_GET(ftr, val)					\
> >   	  	  ((ARM64_FEATURE_MASK(ftr) & val) >> ftr##_SHIFT)
> > 
> > Slight preference for FIELD_{GET,SET}() as it matches the field
> > extraction in the kernel as well.
> 
> Was doing that with this commit:
> 
> 	[PATCH v5 05/13] tools: Copy bitfield.h from the kernel sources
> 
> Maybe you could just use it given that it's already reviewed.

Oops, thanks for the reminder Ricardo! Yeah, let's go that route then.

--
Thanks,
Oliver
