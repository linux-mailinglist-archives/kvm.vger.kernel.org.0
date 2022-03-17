Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1D1074DCD20
	for <lists+kvm@lfdr.de>; Thu, 17 Mar 2022 19:02:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237162AbiCQSD5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 17 Mar 2022 14:03:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52996 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234218AbiCQSDz (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 17 Mar 2022 14:03:55 -0400
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id E68B821C710
        for <kvm@vger.kernel.org>; Thu, 17 Mar 2022 11:02:38 -0700 (PDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 8B0151682;
        Thu, 17 Mar 2022 11:02:38 -0700 (PDT)
Received: from monolith.localdoman (unknown [172.31.20.19])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id AFC813F7B4;
        Thu, 17 Mar 2022 11:02:37 -0700 (PDT)
Date:   Thu, 17 Mar 2022 18:03:07 +0000
From:   Alexandru Elisei <alexandru.elisei@arm.com>
To:     Andrew Jones <drjones@redhat.com>
Cc:     kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu
Subject: Re: [kvm-unit-tests PATCH] arm/run: Use TCG with qemu-system-arm on
 arm64 systems
Message-ID: <YjN3xyfiLU2RUdGr@monolith.localdoman>
References: <20220317165601.356466-1-alexandru.elisei@arm.com>
 <20220317174507.jt2rattmtetddvsq@gator>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220317174507.jt2rattmtetddvsq@gator>
X-Spam-Status: No, score=-6.9 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi,

On Thu, Mar 17, 2022 at 06:45:07PM +0100, Andrew Jones wrote:
> On Thu, Mar 17, 2022 at 04:56:01PM +0000, Alexandru Elisei wrote:
> > From: Andrew Jones <drjones@redhat.com>
> > 
> > If the user sets QEMU=qemu-system-arm on arm64 systems, the tests can only
> > be run by using the TCG accelerator. In this case use TCG instead of KVM.
> > 
> > Signed-off-by: Andrew Jones <drjones@redhat.com>
> > [ Alex E: Added commit message ]
> > Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>
> > ---
> >  arm/run | 12 ++++++++++--
> >  1 file changed, 10 insertions(+), 2 deletions(-)
> > 
> > diff --git a/arm/run b/arm/run
> > index 28a0b4ad2729..128489125dcb 100755
> > --- a/arm/run
> > +++ b/arm/run
> > @@ -10,16 +10,24 @@ if [ -z "$KUT_STANDALONE" ]; then
> >  fi
> >  processor="$PROCESSOR"
> >  
> > -ACCEL=$(get_qemu_accelerator) ||
> > +accel=$(get_qemu_accelerator) ||
> >  	exit $?
> >  
> > -if [ "$ACCEL" = "kvm" ]; then
> > +if [ "$accel" = "kvm" ]; then
> >  	QEMU_ARCH=$HOST
> >  fi
> >  
> >  qemu=$(search_qemu_binary) ||
> >  	exit $?
> >  
> > +if [ "$QEMU" ] && [ -z "$ACCEL" ] &&
> > +   [ "$HOST" = "aarch64" ] && [ "$ARCH" = "arm" ] &&
> > +   [ "$(basename $QEMU)" = "qemu-system-arm" ]; then
> > +	accel=tcg
> > +fi
> > +
> > +ACCEL=$accel
> > +
> >  if ! $qemu -machine '?' 2>&1 | grep 'ARM Virtual Machine' > /dev/null; then
> >  	echo "$qemu doesn't support mach-virt ('-machine virt'). Exiting."
> >  	exit 2
> > -- 
> > 2.35.1
> >
> 
> Ha, OK, I guess you posting this is a strong vote in favor of this
> behavior. I've queued it

Ah, yes, maybe I should've been more clear about it. I think this is more
intuitive for the new users who might not be very familiar with
run_tests.sh internals, and like you've said it won't break existing users
who had to set ACCEL=tcg to get the desired behaviour anyway.

Thanks you for queueing it so fast! Should probably have also mentioned
this as a comment in the commit, but I take full responsibility for
breaking stuff.

Alex

> 
> https://gitlab.com/rhdrjones/kvm-unit-tests/-/commits/arm/queue
> 
> Thanks,
> drew 
> 
