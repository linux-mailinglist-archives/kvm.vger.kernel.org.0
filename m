Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 35A59734E70
	for <lists+kvm@lfdr.de>; Mon, 19 Jun 2023 10:47:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230308AbjFSIrP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 19 Jun 2023 04:47:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47858 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231178AbjFSIqx (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 19 Jun 2023 04:46:53 -0400
Received: from out-45.mta0.migadu.com (out-45.mta0.migadu.com [91.218.175.45])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 65B411982
        for <kvm@vger.kernel.org>; Mon, 19 Jun 2023 01:45:34 -0700 (PDT)
Date:   Mon, 19 Jun 2023 10:45:06 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1687164308;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=Yc83PnN5uZDaSvvfMIm5f8nMXBZAL/vBiqKtGXrcu2s=;
        b=CfUQPDdnj7VPH/HlhJCtHaQbCLZunDWWnluY2fu4aOMO9xhd0MbW8HgI83GCF62v3GeRWs
        Au6X9+ShrbKou5q0/AuIp7bnfEVpLKX6Pbks/McromH413LDzAT5QUxzUd+C+PAd29Xb0Q
        Cxeha+0JZ+jkZadDLlDvw2StrjnWYis=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From:   Andrew Jones <andrew.jones@linux.dev>
To:     Gavin Shan <gshan@redhat.com>
Cc:     kvmarm@lists.linux.dev, kvm@vger.kernel.org,
        kvm-ppc@vger.kernel.org, linux-s390@vger.kernel.org,
        lvivier@redhat.com, thuth@redhat.com, frankja@linux.ibm.com,
        imbrenda@linux.ibm.com, david@redhat.com, pbonzini@redhat.com,
        nrb@linux.ibm.com, shan.gavin@gmail.com
Subject: Re: [kvm-unit-tests PATCH v3] runtime: Allow to specify properties
 for accelerator
Message-ID: <20230619-339675e424da033000049f83@orel>
References: <20230615062148.19883-1-gshan@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230615062148.19883-1-gshan@redhat.com>
X-Migadu-Flow: FLOW_OUT
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Jun 15, 2023 at 04:21:48PM +1000, Gavin Shan wrote:
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
> v3: Split $ACCEL to $ACCEL and $ACCEL_PROPS in get_qemu_accelerator()
>     and don't print them as output, suggested by Drew.
> ---
>  arm/run               | 12 ++++--------
>  powerpc/run           |  5 ++---
>  s390x/run             |  5 ++---
>  scripts/arch-run.bash | 21 +++++++++++++--------
>  x86/run               |  5 ++---
>  5 files changed, 23 insertions(+), 25 deletions(-)
> 
> diff --git a/arm/run b/arm/run
> index c6f25b8..d9ebe59 100755
> --- a/arm/run
> +++ b/arm/run
> @@ -10,10 +10,8 @@ if [ -z "$KUT_STANDALONE" ]; then
>  fi
>  processor="$PROCESSOR"
>  
> -accel=$(get_qemu_accelerator) ||
> -	exit $?
> -
> -if [ "$accel" = "kvm" ]; then
> +get_qemu_accelerator || exit $?
> +if [ "$ACCEL" = "kvm" ]; then
>  	QEMU_ARCH=$HOST
>  fi
>  
> @@ -23,11 +21,9 @@ qemu=$(search_qemu_binary) ||
>  if [ "$QEMU" ] && [ -z "$ACCEL" ] &&
>     [ "$HOST" = "aarch64" ] && [ "$ARCH" = "arm" ] &&
>     [ "$(basename $QEMU)" = "qemu-system-arm" ]; then
> -	accel=tcg
> +	ACCEL="tcg"
>  fi
>  

As I pointed out in the v2 review we can't just s/accel/ACCEL/ without
other changes. Now ACCEL will also be set when the above condition
is checked, making it useless. Please ensure the test case that commit
c7d6c7f00e7c ("arm/run: Use TCG with qemu-system-arm on arm64 systems")
fixed still works with your patch.

Thanks,
drew
