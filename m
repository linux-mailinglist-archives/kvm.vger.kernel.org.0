Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DE2464B147E
	for <lists+kvm@lfdr.de>; Thu, 10 Feb 2022 18:46:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245287AbiBJRpd (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 10 Feb 2022 12:45:33 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:50790 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239868AbiBJRpc (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 10 Feb 2022 12:45:32 -0500
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 49C15F6F
        for <kvm@vger.kernel.org>; Thu, 10 Feb 2022 09:45:33 -0800 (PST)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 1378AD6E;
        Thu, 10 Feb 2022 09:45:33 -0800 (PST)
Received: from monolith.localdoman (unknown [172.31.20.19])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 8A8FC3F718;
        Thu, 10 Feb 2022 09:45:31 -0800 (PST)
Date:   Thu, 10 Feb 2022 17:45:47 +0000
From:   Alexandru Elisei <alexandru.elisei@arm.com>
To:     Sean Christopherson <seanjc@google.com>
Cc:     pbonzini@redhat.com, thuth@redhat.com, drjones@redhat.com,
        varad.gautam@suse.com, zixuanwang@google.com, kvm@vger.kernel.org,
        kvmarm@lists.cs.columbia.edu
Subject: Re: [kvm-unit-tests PATCH 0/4] configure changes and rename
 --target-efi
Message-ID: <YgVPPCTJG7UFRkhQ@monolith.localdoman>
References: <20220210150943.1280146-1-alexandru.elisei@arm.com>
 <YgVKmjBnAjITQcm+@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YgVKmjBnAjITQcm+@google.com>
X-Spam-Status: No, score=-6.9 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi,

On Thu, Feb 10, 2022 at 05:25:46PM +0000, Sean Christopherson wrote:
> On Thu, Feb 10, 2022, Alexandru Elisei wrote:
> > I renamed --target-efi to --efi-payload in the last patch because I felt it
> > looked rather confusing to do ./configure --target=qemu --target-efi when
> > configuring the tests. If the rename is not acceptable, I can think of a
> > few other options:
> 
> I find --target-efi to be odd irrespective of this new conflict.  A simple --efi
> seems like it would be sufficient.
> 
> > 1. Rename --target to --vmm. That was actually the original name for the
> > option, but I changed it because I thought --target was more generic and
> > that --target=efi would be the way going forward to compile kvm-unit-tests
> > to run as an EFI payload. I realize now that separating the VMM from
> > compiling kvm-unit-tests to run as an EFI payload is better, as there can
> > be multiple VMMs that can run UEFI in a VM. Not many people use kvmtool as
> > a test runner, so I think the impact on users should be minimal.
> 
> Again irrespective of --target-efi, I think --target for the VMM is a potentially
> confusing name.  Target Triplet[*] and --target have specific meaning for the
> compiler, usurping that for something similar but slightly different is odd.

Wouldn't that mean that --target-efi is equally confusing? Do you have
suggestions for other names?

> 
> But why is the VMM specified at ./configure time?  Why can't it be an option to
> run_tests.sh?  E.g. --target-efi in configure makes sense because it currently
> requires different compilation options, but even that I hope we can someday change
> so that x86-64 always builds EFI-friendly tests.  I really don't want to get to a
> point where tests themselves have to be recompiled to run under different VMMs.

Setting the VMM at configure time was initially added to remove a warning
from lib/arm/io.c, where if the UART address if different than what
kvm-unit-tests expects the test would print:

WARNING: early print support may not work. Found uart at 0x1000000, but early base is 0x9000000.

kvmtool emulates a different UART, at a different address than what qemu
emulates, and kvm-unit-tests compares the address found in the DTB with the
qemu UART's address (the address is used to be a #define lib/arm/io.c, now
it's generated at configure time in lib/config.h).

On top of that, configuring kvm-unit-tests to run under kvmtool will also
set CONFIG_ERRATA_FORCE to 1. At the time when kvmtool support was added,
kvmtool didn't have support for running a test with an initrd from which to
extract erratas. This has been recently fixed in kvmtool, now it can run a
test with an initrd.

Thanks,
Alex

> 
> [*] https://www.gnu.org/savannah-checkouts/gnu/autoconf/manual/autoconf-2.69/html_node/Specifying-Target-Triplets.html
