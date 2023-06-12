Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3749C72BA8F
	for <lists+kvm@lfdr.de>; Mon, 12 Jun 2023 10:28:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232526AbjFLI2k (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 12 Jun 2023 04:28:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35580 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232442AbjFLI2Y (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 12 Jun 2023 04:28:24 -0400
Received: from out-10.mta1.migadu.com (out-10.mta1.migadu.com [95.215.58.10])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 63222E4E
        for <kvm@vger.kernel.org>; Mon, 12 Jun 2023 01:27:30 -0700 (PDT)
Date:   Mon, 12 Jun 2023 10:27:24 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1686558446;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=nrLkHXpnyMgVgWF13lWr0o38dzOzf81GIoSG60CCB/g=;
        b=A85d0NVklqqKzMS3dPTr5pMK5jDj6i8Me5EHe1Ek/iDNTLLNUCqbgHBGRHrltToEOdQQVB
        +hNdgbVBT33Onv0YE7UDmqyoa12y9vy97Nm/kEjiSp/h7hWOWRl7ZxE+7eEYzQQ/LCq3G0
        jhghJYKeHd/0iL08t8Z2CoFceIg4RcM=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From:   Andrew Jones <andrew.jones@linux.dev>
To:     Gavin Shan <gshan@redhat.com>
Cc:     kvmarm@lists.linux.dev, kvmarm@lists.cs.columbia.edu,
        kvm@vger.kernel.org, frankja@linux.ibm.com, imbrenda@linux.ibm.com,
        nrb@linux.ibm.com, thuth@redhat.com, shan.gavin@gmail.com
Subject: Re: [kvm-unit-tests PATCH] runtime: Allow to specify properties for
 accelerator
Message-ID: <20230612-4c2e1b03885ddc0f55eb1988@orel>
References: <20230612050708.584111-1-gshan@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230612050708.584111-1-gshan@redhat.com>
X-Migadu-Flow: FLOW_OUT
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Jun 12, 2023 at 03:07:08PM +1000, Gavin Shan wrote:
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
>   timeout -k 1s --foreground 90s /home/gavin/sandbox/qemu.main/build/qemu-system-aarch64 \
>   -nodefaults -machine virt -accel kvm,dirty-ring-size=65536 -cpu cortex-a57             \
>   -device virtio-serial-device -device virtconsole,chardev=ctd -chardev testdev,id=ctd   \
>   -device pci-testdev -display none -serial stdio -kernel _NO_FILE_4Uhere_ -smp 160      \
>   -machine gic-version=3 -append its-pending-migration # -initrd /tmp/tmp.gfDLa1EtWk
>   qemu-system-aarch64: kvm_init_vcpu: kvm_arch_init_vcpu failed (0): Invalid argument
> 
> Allow to specify extra properties for accelerators. With this, the
> "its-migration" can be tested for the combination of KVM and dirty
> ring.
> 
> Signed-off-by: Gavin Shan <gshan@redhat.com>
> ---
>  arm/run               | 4 ++--
>  scripts/arch-run.bash | 4 ++--
>  2 files changed, 4 insertions(+), 4 deletions(-)
> 
> diff --git a/arm/run b/arm/run
> index c6f25b8..bbf80e0 100755
> --- a/arm/run
> +++ b/arm/run
> @@ -35,13 +35,13 @@ fi
>  
>  M='-machine virt'
>  
> -if [ "$ACCEL" = "kvm" ]; then
> +if [[ "$ACCEL" =~ ^kvm.* ]]; then
>  	if $qemu $M,\? | grep -q gic-version; then
>  		M+=',gic-version=host'
>  	fi
>  fi
>  
> -if [ "$ACCEL" = "kvm" ] || [ "$ACCEL" = "hvf" ]; then
> +if [[ "$ACCEL" =~ ^kvm.* ]] || [[ "$ACCEL" =~ ^hvf.* ]]; then
>  	if [ "$HOST" = "aarch64" ] || [ "$HOST" = "arm" ]; then
>  		processor="host"
>  		if [ "$ARCH" = "arm" ] && [ "$HOST" = "aarch64" ]; then
> diff --git a/scripts/arch-run.bash b/scripts/arch-run.bash
> index 51e4b97..e20b965 100644
> --- a/scripts/arch-run.bash
> +++ b/scripts/arch-run.bash
> @@ -412,11 +412,11 @@ hvf_available ()
>  
>  get_qemu_accelerator ()
>  {
> -	if [ "$ACCEL" = "kvm" ] && ! kvm_available; then
> +	if [[ "$ACCEL" =~ ^kvm.* ]] && [[ ! kvm_available ]]; then
>  		echo "KVM is needed, but not available on this host" >&2
>  		return 2
>  	fi
> -	if [ "$ACCEL" = "hvf" ] && ! hvf_available; then
> +	if [[ "$ACCEL" =~ ^hvf.* ]] && [[ ! hvf_available ]]; then
>  		echo "HVF is needed, but not available on this host" >&2
>  		return 2
>  	fi
> -- 
> 2.23.0
>

Hi Gavin,

I'd prefer that when we want to match 'kvm', 'tcg', etc. that we split
on the first comma, rather than use a regular expression that allows
arbitrary characters to follow the pattern. Actually
get_qemu_accelerator() could do the splitting itself, providing two
variables, ACCEL (only kvm, tcg, etc.) and ACCEL_PROPS (which is
either null or has a leading comma). Then command lines just need
to use $ACCEL$ACCEL_PROPS. If we do that, then get_qemu_accelerator()
should also allow the user to pre-split, i.e.

  ACCEL=kvm ACCEL_PROPS=dirty-ring-size=65536 arm/run ...

Finally, did you also test this with the accel property in the
unittests.cfg file run with run_tests.sh?

Thanks,
drew
