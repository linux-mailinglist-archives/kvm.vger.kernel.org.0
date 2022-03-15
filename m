Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8429F4D9B4B
	for <lists+kvm@lfdr.de>; Tue, 15 Mar 2022 13:32:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348345AbiCOMeE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 15 Mar 2022 08:34:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39842 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348344AbiCOMeC (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 15 Mar 2022 08:34:02 -0400
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id A2BEFD4C
        for <kvm@vger.kernel.org>; Tue, 15 Mar 2022 05:32:49 -0700 (PDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 6F3791474;
        Tue, 15 Mar 2022 05:32:49 -0700 (PDT)
Received: from monolith.localdoman (unknown [172.31.20.19])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 751383F66F;
        Tue, 15 Mar 2022 05:32:48 -0700 (PDT)
Date:   Tue, 15 Mar 2022 12:33:17 +0000
From:   Alexandru Elisei <alexandru.elisei@arm.com>
To:     Andrew Jones <drjones@redhat.com>
Cc:     kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu,
        thuth@redhat.com, pbonzini@redhat.com
Subject: Re: [PATCH kvm-unit-tests] arch-run: Introduce QEMU_ARCH
Message-ID: <YjCHcV3iyTtSrw3k@monolith.localdoman>
References: <20220315080152.224606-1-drjones@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220315080152.224606-1-drjones@redhat.com>
X-Spam-Status: No, score=-6.9 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi,

On Tue, Mar 15, 2022 at 09:01:52AM +0100, Andrew Jones wrote:
> Add QEMU_ARCH, which allows run scripts to specify which architecture
> of QEMU should be used. This is useful on AArch64 when running with
> KVM and running AArch32 tests. For those tests, we *don't* want to
> select the 'arm' QEMU, as would have been selected, but rather the
> $HOST ('aarch64') QEMU.
> 
> To use this new variable, simply ensure it's set prior to calling
> search_qemu_binary().

Looks good, tested on an arm64 machine, with ACCEL set to tcg -
run_tests.sh selects qemu-system-arm; ACCEL unset - run_tests.sh selects
ACCEL=kvm and qemu-system-aarch64; also tested on an x86 machine -
run_tests.sh selects ACCEL=tcg and qemu-system-arm:

Tested-by: Alexandru Elisei <alexandru.elisei@arm.com>
Reviewed-by: Alexandru Elisei <alexandru.elisei@arm.com>

One thing I noticed is that if the user sets QEMU=qemu-system-arm on an arm64
machine, run_tests.sh still selects ACCEL=kvm which leads to the following
failure:

SKIP selftest-setup (qemu-system-arm: -accel kvm: invalid accelerator kvm)

I'm not sure if this deserves a fix, if the user set the QEMU variable I
believe it is probable that the user is also aware of the ACCEL variable
and the error message does a good job explaining what is wrong. Just in
case, this is what I did to make kvm-unit-tests pick the right accelerator
(copied-and-pasted the find_word function from scripts/runtime.bash):

diff --git a/arm/run b/arm/run
index 94adcddb7399..b0c9613b8d28 100755
--- a/arm/run
+++ b/arm/run
@@ -10,6 +15,10 @@ if [ -z "$KUT_STANDALONE" ]; then
 fi
 processor="$PROCESSOR"

+if [ -z $ACCEL ] && [ "$HOST" = "aarch64" ] && ! find_word "qemu-system-arm" "$QEMU"; then
+       ACCEL=tcg
+fi
+

Thanks,
Alex

> 
> Cc: Alexandru Elisei <alexandru.elisei@arm.com>
> Signed-off-by: Andrew Jones <drjones@redhat.com>
> ---
>  arm/run               | 4 ++++
>  scripts/arch-run.bash | 4 +++-
>  2 files changed, 7 insertions(+), 1 deletion(-)
> 
> diff --git a/arm/run b/arm/run
> index 0629b69a117c..28a0b4ad2729 100755
> --- a/arm/run
> +++ b/arm/run
> @@ -13,6 +13,10 @@ processor="$PROCESSOR"
>  ACCEL=$(get_qemu_accelerator) ||
>  	exit $?
>  
> +if [ "$ACCEL" = "kvm" ]; then
> +	QEMU_ARCH=$HOST
> +fi
> +
>  qemu=$(search_qemu_binary) ||
>  	exit $?
>  
> diff --git a/scripts/arch-run.bash b/scripts/arch-run.bash
> index aae552321f9b..0dfaf017db0a 100644
> --- a/scripts/arch-run.bash
> +++ b/scripts/arch-run.bash
> @@ -176,8 +176,10 @@ search_qemu_binary ()
>  	local save_path=$PATH
>  	local qemucmd qemu
>  
> +	: "${QEMU_ARCH:=$ARCH_NAME}"
> +
>  	export PATH=$PATH:/usr/libexec
> -	for qemucmd in ${QEMU:-qemu-system-$ARCH_NAME qemu-kvm}; do
> +	for qemucmd in ${QEMU:-qemu-system-$QEMU_ARCH qemu-kvm}; do
>  		if $qemucmd --help 2>/dev/null | grep -q 'QEMU'; then
>  			qemu="$qemucmd"
>  			break
> -- 
> 2.34.1
> 
