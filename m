Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 60BBF73B1C9
	for <lists+kvm@lfdr.de>; Fri, 23 Jun 2023 09:38:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230170AbjFWHiw (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 23 Jun 2023 03:38:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35704 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231382AbjFWHit (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 23 Jun 2023 03:38:49 -0400
Received: from out-14.mta1.migadu.com (out-14.mta1.migadu.com [95.215.58.14])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4758C2134
        for <kvm@vger.kernel.org>; Fri, 23 Jun 2023 00:38:46 -0700 (PDT)
Date:   Fri, 23 Jun 2023 09:38:43 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1687505924;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=PtdwSU4PYelk0dj1Hg4+fs35PD3IHMTgzkjQcNxh7n0=;
        b=fVBHqdUJhSTW+Dl7P0h9+3UCWC1Nccb6zdJCg5Fw8CzLyPP/MHxcdxJSRFejSnI5C7xJ/F
        STCP8aT0oCeNDG/GWVn/YiL/FDbQKOWcPL3fCdmVM0hhxSj19nKi1JwXOxnkUfYH9wHvfU
        BA9bcB2Du+HMiRS5pfMcrFzc3xDNt14=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From:   Andrew Jones <andrew.jones@linux.dev>
To:     Gavin Shan <gshan@redhat.com>
Cc:     kvmarm@lists.linux.dev, kvm@vger.kernel.org,
        kvm-ppc@vger.kernel.org, linux-s390@vger.kernel.org,
        lvivier@redhat.com, thuth@redhat.com, frankja@linux.ibm.com,
        imbrenda@linux.ibm.com, david@redhat.com, pbonzini@redhat.com,
        nrb@linux.ibm.com, shan.gavin@gmail.com
Subject: Re: [kvm-unit-tests PATCH v4] runtime: Allow to specify properties
 for accelerator
Message-ID: <20230623-285cfe53df170a6175b5369c@orel>
References: <20230623035750.312679-1-gshan@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230623035750.312679-1-gshan@redhat.com>
X-Migadu-Flow: FLOW_OUT
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Jun 23, 2023 at 01:57:50PM +1000, Gavin Shan wrote:
> There are extra properties for accelerators to enable the specific
> features. For example, the dirty ring for KVM accelerator can be
> enabled by "-accel kvm,dirty-ring-size=65536". Unfortuntely, the
> extra properties for the accelerators aren't supported. It makes
> it's impossible to test the combination of KVM and dirty ring
> as the following error message indicates.
> 
>   # cd /home/gavin/sandbox/kvm-unit-tests/tests
>   # QEMU=/home/gavin/sandbox/qemu.main/build/qemu-system-aarch64 \
>     ACCEL=kvm,dirty-ring-size=65536 ./its-migration
>      :
>   BUILD_HEAD=2fffb37e
>   timeout -k 1s --foreground 90s                                 \
>   /home/gavin/sandbox/qemu.main/build/qemu-system-aarch64        \
>   -nodefaults -machine virt -accel kvm,dirty-ring-size=65536     \
>   -cpu cortex-a57 -device virtio-serial-device                   \
>   -device virtconsole,chardev=ctd -chardev testdev,id=ctd        \
>   -device pci-testdev -display none -serial stdio                \
>   -kernel _NO_FILE_4Uhere_ -smp 160 -machine gic-version=3       \
>   -append its-pending-migration # -initrd /tmp/tmp.gfDLa1EtWk
>      :
>   qemu-system-aarch64: kvm_init_vcpu: kvm_arch_init_vcpu failed (0):
>   Invalid argument
> 
> Allow to specify extra properties for accelerators. With this, the
> "its-migration" can be tested for the combination of KVM and dirty
> ring. Rename get_qemu_accelerator() to set_qemu_accelerator() since
> no values are returned by printing at return.
> 
> Signed-off-by: Gavin Shan <gshan@redhat.com>
> Tested-by: Nico Boehr <nrb@linux.ibm.com>
> Acked-by: Nico Boehr <nrb@linux.ibm.com>
> ---
> v4: Rename get_qemu_accelerator() to set_qemu_accelerator() and
>     don't break the fix included in commit c7d6c7f00e7c by setting
>     $ACCEL to "tcg" before set_qemu_accelerator() is called, suggested
>     by Drew.
> ---
>  arm/run               | 20 ++++++++------------
>  powerpc/run           |  5 ++---
>  s390x/run             |  5 ++---
>  scripts/arch-run.bash | 23 ++++++++++++++---------
>  x86/run               |  5 ++---
>  5 files changed, 28 insertions(+), 30 deletions(-)
> 
> diff --git a/arm/run b/arm/run
> index c6f25b8..956940f 100755
> --- a/arm/run
> +++ b/arm/run
> @@ -10,24 +10,20 @@ if [ -z "$KUT_STANDALONE" ]; then
>  fi
>  processor="$PROCESSOR"
>  
> -accel=$(get_qemu_accelerator) ||
> -	exit $?
> +if [ "$QEMU" ] && [ -z "$ACCEL" ] &&
> +   [ "$HOST" = "aarch64" ] && [ "$ARCH" = "arm" ] &&
> +   [ "$(basename $QEMU)" = "qemu-system-arm" ]; then
> +	ACCEL="tcg"
> +fi
>  
> -if [ "$accel" = "kvm" ]; then
> +set_qemu_accelerator || exit $?
> +if [ "$ACCEL" = "kvm" ]; then
>  	QEMU_ARCH=$HOST
>  fi
>  
>  qemu=$(search_qemu_binary) ||
>  	exit $?
>  
> -if [ "$QEMU" ] && [ -z "$ACCEL" ] &&
> -   [ "$HOST" = "aarch64" ] && [ "$ARCH" = "arm" ] &&
> -   [ "$(basename $QEMU)" = "qemu-system-arm" ]; then
> -	accel=tcg
> -fi
> -
> -ACCEL=$accel
> -
>  if ! $qemu -machine '?' | grep -q 'ARM Virtual Machine'; then
>  	echo "$qemu doesn't support mach-virt ('-machine virt'). Exiting."
>  	exit 2
> @@ -72,7 +68,7 @@ if $qemu $M -device '?' | grep -q pci-testdev; then
>  	pci_testdev="-device pci-testdev"
>  fi
>  
> -A="-accel $ACCEL"
> +A="-accel $ACCEL$ACCEL_PROPS"
>  command="$qemu -nodefaults $M $A -cpu $processor $chr_testdev $pci_testdev"
>  command+=" -display none -serial stdio -kernel"
>  command="$(migration_cmd) $(timeout_cmd) $command"
> diff --git a/powerpc/run b/powerpc/run
> index ee38e07..b353169 100755
> --- a/powerpc/run
> +++ b/powerpc/run
> @@ -9,8 +9,7 @@ if [ -z "$KUT_STANDALONE" ]; then
>  	source scripts/arch-run.bash
>  fi
>  
> -ACCEL=$(get_qemu_accelerator) ||
> -	exit $?
> +set_qemu_accelerator || exit $?
>  
>  qemu=$(search_qemu_binary) ||
>  	exit $?
> @@ -21,7 +20,7 @@ if ! $qemu -machine '?' 2>&1 | grep 'pseries' > /dev/null; then
>  fi
>  
>  M='-machine pseries'
> -M+=",accel=$ACCEL"
> +M+=",accel=$ACCEL$ACCEL_PROPS"
>  command="$qemu -nodefaults $M -bios $FIRMWARE"
>  command+=" -display none -serial stdio -kernel"
>  command="$(migration_cmd) $(timeout_cmd) $command"
> diff --git a/s390x/run b/s390x/run
> index f1111db..dcbf3f0 100755
> --- a/s390x/run
> +++ b/s390x/run
> @@ -9,8 +9,7 @@ if [ -z "$KUT_STANDALONE" ]; then
>  	source scripts/arch-run.bash
>  fi
>  
> -ACCEL=$(get_qemu_accelerator) ||
> -	exit $?
> +set_qemu_accelerator || exit $?
>  
>  qemu=$(search_qemu_binary) ||
>  	exit $?
> @@ -26,7 +25,7 @@ if [ "${1: -7}" = ".pv.bin" ] || [ "${TESTNAME: -3}" = "_PV" ] && [ "$MIGRATION"
>  fi
>  
>  M='-machine s390-ccw-virtio'
> -M+=",accel=$ACCEL"
> +M+=",accel=$ACCEL$ACCEL_PROPS"
>  command="$qemu -nodefaults -nographic $M"
>  command+=" -chardev stdio,id=con0 -device sclpconsole,chardev=con0"
>  command+=" -kernel"
> diff --git a/scripts/arch-run.bash b/scripts/arch-run.bash
> index 51e4b97..2d28e0b 100644
> --- a/scripts/arch-run.bash
> +++ b/scripts/arch-run.bash
> @@ -410,8 +410,11 @@ hvf_available ()
>  		( [ "$HOST" = x86_64 ] && [ "$ARCH" = i386 ] )
>  }
>  
> -get_qemu_accelerator ()
> +set_qemu_accelerator ()
>  {
> +	ACCEL_PROPS=${ACCEL#"${ACCEL%%,*}"}
> +	ACCEL=${ACCEL%%,*}
> +
>  	if [ "$ACCEL" = "kvm" ] && ! kvm_available; then
>  		echo "KVM is needed, but not available on this host" >&2
>  		return 2
> @@ -421,13 +424,15 @@ get_qemu_accelerator ()
>  		return 2
>  	fi
>  
> -	if [ "$ACCEL" ]; then
> -		echo $ACCEL
> -	elif kvm_available; then
> -		echo kvm
> -	elif hvf_available; then
> -		echo hvf
> -	else
> -		echo tcg
> +	if [ -z "$ACCEL" ]; then
> +		if kvm_available; then
> +			ACCEL="kvm"
> +		elif hvf_available; then
> +			ACCEL="hvf"
> +		else
> +			ACCEL="tcg"
> +		fi
>  	fi
> +
> +	return 0
>  }
> diff --git a/x86/run b/x86/run
> index 4d53b72..a3d3e7d 100755
> --- a/x86/run
> +++ b/x86/run
> @@ -9,8 +9,7 @@ if [ -z "$KUT_STANDALONE" ]; then
>  	source scripts/arch-run.bash
>  fi
>  
> -ACCEL=$(get_qemu_accelerator) ||
> -	exit $?
> +set_qemu_accelerator || exit $?
>  
>  qemu=$(search_qemu_binary) ||
>  	exit $?
> @@ -38,7 +37,7 @@ else
>  fi
>  
>  command="${qemu} --no-reboot -nodefaults $pc_testdev -vnc none -serial stdio $pci_testdev"
> -command+=" -machine accel=$ACCEL"
> +command+=" -machine accel=$ACCEL$ACCEL_PROPS"
>  if [ "${CONFIG_EFI}" != y ]; then
>  	command+=" -kernel"
>  fi
> -- 
> 2.40.1
>

Reviewed-by: Andrew Jones <andrew.jones@linux.dev>
