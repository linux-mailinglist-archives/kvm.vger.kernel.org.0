Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C2ABC6F312C
	for <lists+kvm@lfdr.de>; Mon,  1 May 2023 14:49:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232411AbjEAMto (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 1 May 2023 08:49:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41564 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229556AbjEAMtn (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 1 May 2023 08:49:43 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BF51F10D5
        for <kvm@vger.kernel.org>; Mon,  1 May 2023 05:48:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1682945337;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=PWad9w4sdvrJZTVU5kOVCYkO3f9hEPYY7626pqbBzYk=;
        b=JVXezp1BejYs8CZioCWY8FY+CHiDoq1SGHYviVkn7asxInOZ3rrlFHvFs6CR0lWQWKKUPR
        u+QFJBbmO15gWerr9s1nQMV06np7Zfv+CAy93Ht2w/NErdlcfk9U9kAbgYAjb6wJpmJE+z
        sxS8huvVudTDGEeXJ+EtCU2RvvsTCdE=
Received: from mail-pf1-f199.google.com (mail-pf1-f199.google.com
 [209.85.210.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-67-fF9fq2CYPHeH-bvjpmXC8w-1; Mon, 01 May 2023 08:48:56 -0400
X-MC-Unique: fF9fq2CYPHeH-bvjpmXC8w-1
Received: by mail-pf1-f199.google.com with SMTP id d2e1a72fcca58-63b653f5cb4so466379b3a.0
        for <kvm@vger.kernel.org>; Mon, 01 May 2023 05:48:56 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682945336; x=1685537336;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=PWad9w4sdvrJZTVU5kOVCYkO3f9hEPYY7626pqbBzYk=;
        b=YErhWD8q/dnmoSdzSOX7dKJ5wmg87rhSYmyDj4f65CfirGpRL1nUPXYE51C6FPUwaf
         FipTWksdMD8ydGGr5v/tnpQi2i/A+XBvHpb7yXSEYRprgs6/SS5SIkJK8IU0JJqkd5ch
         yhJSSH19EsIsOksoOcDXVCbAbDRF7a5RJDuvQpC5yiR5PRtJ03v7ndyI4LEcvLHZ8lwK
         nXNVDsKSiREZPZssMvv/S/GIjbYBujBy/xoDKCyIxRR4BdE/ajrcL30lGOgsTF6ribjS
         X0XLHcP+z4YyRTtFhw0pX9nBQwfvX7wtChX3nJtS2ti7xuBcLtcCte9Aud+Ommvnfdpb
         fB0g==
X-Gm-Message-State: AC+VfDwrHSRAfNcyMfzhRpmvwr+dVNmt17svXJcih+IYFe3peMF0OXac
        PtiWfwsytXd6oIvOCsziAaZcZjHo0FM6gHoP6rKxjkbkOe+KgDefWZh9PhmlKIP76Fg/rzq4ACQ
        Hcvrlls2RXoIF
X-Received: by 2002:a05:6a00:1a0f:b0:63d:3a18:49fd with SMTP id g15-20020a056a001a0f00b0063d3a1849fdmr16231021pfv.2.1682945335786;
        Mon, 01 May 2023 05:48:55 -0700 (PDT)
X-Google-Smtp-Source: ACHHUZ7R+XW5yARMhCaNUz3uZ8bssisrRfx/1EEjNh9s5GOPg9cqVC6Y6nxghRp3CFktVri7o4ur4A==
X-Received: by 2002:a05:6a00:1a0f:b0:63d:3a18:49fd with SMTP id g15-20020a056a001a0f00b0063d3a1849fdmr16231011pfv.2.1682945335443;
        Mon, 01 May 2023 05:48:55 -0700 (PDT)
Received: from [10.66.61.39] ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id t1-20020a62d141000000b0063b8ce0e860sm19801872pfl.21.2023.05.01.05.48.53
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 01 May 2023 05:48:55 -0700 (PDT)
Message-ID: <bd151928-c94b-73aa-dbd9-289e4213db7a@redhat.com>
Date:   Mon, 1 May 2023 20:48:51 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.8.0
Subject: Re: [kvm-unit-tests PATCH v5 29/29] arm64: Add an efi/run script
Content-Language: en-US
To:     Nikos Nikoleris <nikos.nikoleris@arm.com>, kvm@vger.kernel.org,
        kvmarm@lists.linux.dev, andrew.jones@linux.dev
Cc:     pbonzini@redhat.com, alexandru.elisei@arm.com, ricarkol@google.com
References: <20230428120405.3770496-1-nikos.nikoleris@arm.com>
 <20230428120405.3770496-30-nikos.nikoleris@arm.com>
From:   Shaoqin Huang <shahuang@redhat.com>
In-Reply-To: <20230428120405.3770496-30-nikos.nikoleris@arm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Currently, it seems not support:

./run_test.sh -j8

Since different test will write the startup.nsh to the same directory, 
which will make something wrong.

But that's fine right now. We can improve it later.

On 4/28/23 20:04, Nikos Nikoleris wrote:
> This change adds a efi/run script inspired by the one in x86. This
> script will setup a folder with the test compiled as an EFI app and a
> startup.nsh script. The script launches QEMU providing an image with
> EDKII and the path to the folder with the test which is executed
> automatically.
> 
> For example:
> 
> $> ./arm/efi/run ./arm/selftest.efi -append "setup smp=2 mem=256" -smp 2 -m 256
> 
> Signed-off-by: Nikos Nikoleris <nikos.nikoleris@arm.com>
> Reviewed-by: Ricardo Koller <ricarkol@google.com>
Reviewed-by: Shaoqin Huang <shahuang@redhat.com>

> ---
>   scripts/runtime.bash | 13 +++++++---
>   arm/efi/run          | 61 ++++++++++++++++++++++++++++++++++++++++++++
>   arm/run              | 14 +++++++---
>   arm/Makefile.common  |  1 +
>   arm/dummy.c          | 12 +++++++++
>   5 files changed, 94 insertions(+), 7 deletions(-)
>   create mode 100755 arm/efi/run
>   create mode 100644 arm/dummy.c
> 
> diff --git a/scripts/runtime.bash b/scripts/runtime.bash
> index 07b62b0e..785a7b62 100644
> --- a/scripts/runtime.bash
> +++ b/scripts/runtime.bash
> @@ -130,11 +130,18 @@ function run()
>           done
>       fi
>   
> -    last_line=$(premature_failure > >(tail -1)) && {
> +    log=$(premature_failure) && {
>           skip=true
> -        if [ "${CONFIG_EFI}" == "y" ] && [[ "${last_line}" =~ "Dummy Hello World!" ]]; then
> -            skip=false
> +        if [ "${CONFIG_EFI}" == "y" ]; then
> +            if [ "$ARCH" == "x86_64" ] &&
> +               [[ "$(tail -1 <<<"$log")" =~ "Dummy Hello World!" ]]; then
> +                   skip=false
> +            elif [ "$ARCH" == "arm64" ] &&
> +               [[ "$(tail -2 <<<"$log" | head -1)" =~ "Dummy Hello World!" ]]; then
> +                   skip=false
> +            fi
>           fi
> +
>           if [ ${skip} == true ]; then
>               print_result "SKIP" $testname "" "$last_line"
>               return 77
> diff --git a/arm/efi/run b/arm/efi/run
> new file mode 100755
> index 00000000..dfff717a
> --- /dev/null
> +++ b/arm/efi/run
> @@ -0,0 +1,61 @@
> +#!/bin/bash
> +
> +set -e
> +
> +if [ $# -eq 0 ]; then
> +	echo "Usage $0 TEST_CASE [QEMU_ARGS]"
> +	exit 2
> +fi
> +
> +if [ ! -f config.mak ]; then
> +	echo "run './configure --enable-efi && make' first. See ./configure -h"
> +	exit 2
> +fi
> +source config.mak
> +source scripts/arch-run.bash
> +source scripts/common.bash
> +
> +: "${EFI_SRC:=$(realpath "$(dirname "$0")/../")}"
> +: "${EFI_UEFI:=/usr/share/qemu-efi-aarch64/QEMU_EFI.fd}"
> +: "${EFI_TEST:=efi-tests}"
> +: "${EFI_CASE:=$(basename $1 .efi)}"
> +
> +if [ ! -f "$EFI_UEFI" ]; then
> +	echo "UEFI firmware not found: $EFI_UEFI"
> +	echo "Please install the UEFI firmware to this path"
> +	echo "Or specify the correct path with the env variable EFI_UEFI"
> +	exit 2
> +fi
> +
> +# Remove the TEST_CASE from $@
> +shift 1
> +
> +# Fish out the arguments for the test, they should be the next string
> +# after the "-append" option
> +qemu_args=()
> +cmd_args=()
> +while (( "$#" )); do
> +	if [ "$1" = "-append" ]; then
> +		cmd_args=$2
> +		shift 2
> +	else
> +		qemu_args+=("$1")
> +		shift 1
> +	fi
> +done
> +
> +if [ "$EFI_CASE" = "_NO_FILE_4Uhere_" ]; then
> +	EFI_CASE=dummy
> +fi
> +
> +: "${EFI_CASE_DIR:="$EFI_TEST/$EFI_CASE"}"
> +mkdir -p "$EFI_CASE_DIR"
> +
> +cp "$EFI_SRC/$EFI_CASE.efi" "$EFI_TEST/$EFI_CASE/"
> +echo "@echo -off" > "$EFI_TEST/$EFI_CASE/startup.nsh"
> +echo "$EFI_CASE.efi" "${cmd_args[@]}" >> "$EFI_TEST/$EFI_CASE/startup.nsh"
> +
> +EFI_RUN=y $TEST_DIR/run \
> +       -bios "$EFI_UEFI" \
> +       -drive file.dir="$EFI_TEST/$EFI_CASE/",file.driver=vvfat,file.rw=on,format=raw,if=virtio \
> +       "${qemu_args[@]}"
> diff --git a/arm/run b/arm/run
> index c6f25b8c..de520c11 100755
> --- a/arm/run
> +++ b/arm/run
> @@ -64,8 +64,10 @@ if ! $qemu $M -chardev '?' | grep -q testdev; then
>   	exit 2
>   fi
>   
> -chr_testdev='-device virtio-serial-device'
> -chr_testdev+=' -device virtconsole,chardev=ctd -chardev testdev,id=ctd'
> +if [ "$EFI_RUN" != "y" ]; then
> +	chr_testdev='-device virtio-serial-device'
> +	chr_testdev+=' -device virtconsole,chardev=ctd -chardev testdev,id=ctd'
> +fi
>   
>   pci_testdev=
>   if $qemu $M -device '?' | grep -q pci-testdev; then
> @@ -74,7 +76,11 @@ fi
>   
>   A="-accel $ACCEL"
>   command="$qemu -nodefaults $M $A -cpu $processor $chr_testdev $pci_testdev"
> -command+=" -display none -serial stdio -kernel"
> +command+=" -display none -serial stdio"
>   command="$(migration_cmd) $(timeout_cmd) $command"
>   
> -run_qemu $command "$@"
> +if [ "$EFI_RUN" = "y" ]; then
> +	ENVIRON_DEFAULT=n run_qemu_status $command "$@"
> +else
> +	run_qemu $command -kernel "$@"
> +fi
> diff --git a/arm/Makefile.common b/arm/Makefile.common
> index a133309d..d60cf8cd 100644
> --- a/arm/Makefile.common
> +++ b/arm/Makefile.common
> @@ -12,6 +12,7 @@ tests-common += $(TEST_DIR)/gic.$(exe)
>   tests-common += $(TEST_DIR)/psci.$(exe)
>   tests-common += $(TEST_DIR)/sieve.$(exe)
>   tests-common += $(TEST_DIR)/pl031.$(exe)
> +tests-common += $(TEST_DIR)/dummy.$(exe)
>   
>   tests-all = $(tests-common) $(tests)
>   all: directories $(tests-all)
> diff --git a/arm/dummy.c b/arm/dummy.c
> new file mode 100644
> index 00000000..7033bb7c
> --- /dev/null
> +++ b/arm/dummy.c
> @@ -0,0 +1,12 @@
> +#include "libcflat.h"
> +
> +int main(int argc, char **argv)
> +{
> +	/*
> +	 * scripts/runtime.bash uses this test as a canary to determine if the
> +	 * basic setup is functional.  Print a magic string to let runtime.bash
> +	 * know that all is well.
> +	 */
> +	printf("Dummy Hello World!");
> +	return 0;
> +}

-- 
Shaoqin

