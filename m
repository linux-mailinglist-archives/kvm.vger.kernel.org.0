Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B10204D364A
	for <lists+kvm@lfdr.de>; Wed,  9 Mar 2022 18:43:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236879AbiCIRP6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 9 Mar 2022 12:15:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36058 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238894AbiCIRPM (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 9 Mar 2022 12:15:12 -0500
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id C345C154D09
        for <kvm@vger.kernel.org>; Wed,  9 Mar 2022 09:11:45 -0800 (PST)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 42CA81691;
        Wed,  9 Mar 2022 09:11:45 -0800 (PST)
Received: from monolith.localdoman (unknown [172.31.20.19])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 226CA3F7F5;
        Wed,  9 Mar 2022 09:11:44 -0800 (PST)
Date:   Wed, 9 Mar 2022 17:12:05 +0000
From:   Alexandru Elisei <alexandru.elisei@arm.com>
To:     Andrew Jones <drjones@redhat.com>
Cc:     kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu,
        pbonzini@redhat.com, thuth@redhat.com
Subject: Re: [kvm-unit-tests PATCH 2/2] arm/run: Fix using
 qemu-system-aarch64 to run aarch32 tests on aarch64
Message-ID: <Yijf5TlbOKhV+Mw6@monolith.localdoman>
References: <20220309162117.56681-1-alexandru.elisei@arm.com>
 <20220309162117.56681-3-alexandru.elisei@arm.com>
 <20220309165812.46xmnjek72yrv3g6@gator>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220309165812.46xmnjek72yrv3g6@gator>
X-Spam-Status: No, score=-6.9 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi,

On Wed, Mar 09, 2022 at 05:58:12PM +0100, Andrew Jones wrote:
> On Wed, Mar 09, 2022 at 04:21:17PM +0000, Alexandru Elisei wrote:
> > From: Andrew Jones <drjones@redhat.com>
> > 
> > KVM on arm64 can create 32 bit and 64 bit VMs. kvm-unit-tests tries to
> > take advantage of this by setting the aarch64=off -cpu option. However,
> > get_qemu_accelerator() isn't aware that KVM on arm64 can run both types
> > of VMs and it selects qemu-system-arm instead of qemu-system-aarch64.
> > This leads to an error in premature_failure() and the test is marked as
> > skipped:
> > 
> > $ ./run_tests.sh selftest-setup
> > SKIP selftest-setup (qemu-system-arm: -accel kvm: invalid accelerator kvm)
> > 
> > Fix this by setting QEMU to the correct qemu binary before calling
> > get_qemu_accelerator().
> > 
> > Signed-off-by: Andrew Jones <drjones@redhat.com>
> > [ Alex E: Added commit message, changed the logic to make it clearer ]
> > Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>
> > ---
> >  arm/run | 5 +++++
> >  1 file changed, 5 insertions(+)
> > 
> > diff --git a/arm/run b/arm/run
> > index 2153bd320751..5fe0a45c4820 100755
> > --- a/arm/run
> > +++ b/arm/run
> > @@ -13,6 +13,11 @@ processor="$PROCESSOR"
> >  ACCEL=$(get_qemu_accelerator) ||
> >  	exit $?
> >  
> > +# KVM for arm64 can create a VM in either aarch32 or aarch64 modes.
> > +if [ "$ACCEL" = kvm ] && [ -z "$QEMU" ] && [ "$HOST" = "aarch64" ]; then
> > +	QEMU=qemu-system-aarch64
> > +fi
> > +
> >  qemu=$(search_qemu_binary) ||
> >  	exit $?
> >  
> > -- 
> > 2.35.1
> >
> 
> So there's a bug with this patch which was also present in the patch I
> proposed. By setting $QEMU before we call search_qemu_binary() we may
> force a "A QEMU binary was not found." failure even though a perfectly
> good 'qemu-kvm' binary is present.

I noticed that search_qemu_binary() tries to search for both
qemu-system-ARCH_NAME and qemu-kvm, and I first thought that qemu-kvm is a
legacy name for qemu-system-ARCH_NAME.

I just did some googling, and I think it's actually how certain distros (like
SLES) package qemu-system-ARCH_NAME, is that correct?

If that is so, one idea I toyed with (for something else) is to move the error
messages from search_qemu_binary() to the call sites, that way arm/run can first
try to find qemu-system-aarch64, then fallback to qemu-kvm, and only after both
aren't found exit with an error. Just a suggestion, in case you find it useful.

Thanks,
Alex

> 
> I'll try to come up with something better.
> 
> Thanks,
> drew
> 
