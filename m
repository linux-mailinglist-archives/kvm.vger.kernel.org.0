Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3E029731BBD
	for <lists+kvm@lfdr.de>; Thu, 15 Jun 2023 16:48:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345097AbjFOOsK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 15 Jun 2023 10:48:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33946 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237810AbjFOOsJ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 15 Jun 2023 10:48:09 -0400
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 6853D1BF3
        for <kvm@vger.kernel.org>; Thu, 15 Jun 2023 07:48:08 -0700 (PDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 6101111FB;
        Thu, 15 Jun 2023 07:48:52 -0700 (PDT)
Received: from [10.57.85.226] (unknown [10.57.85.226])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 5DA703F71E;
        Thu, 15 Jun 2023 07:48:07 -0700 (PDT)
Message-ID: <009eac78-74a3-0c4f-c557-670a98e9c8ea@arm.com>
Date:   Thu, 15 Jun 2023 15:48:05 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.12.0
Subject: Re: [kvm-unit-tests PATCH 3/3] configure: efi: Link correct run
 script
Content-Language: en-GB
To:     Andrew Jones <andrew.jones@linux.dev>, kvm@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>, Thomas Huth <thuth@redhat.com>
References: <20230607185905.32810-1-andrew.jones@linux.dev>
 <20230607185905.32810-4-andrew.jones@linux.dev>
From:   Nikos Nikoleris <nikos.nikoleris@arm.com>
In-Reply-To: <20230607185905.32810-4-andrew.jones@linux.dev>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 07/06/2023 19:59, Andrew Jones wrote:
> EFI built tests use $TEST_DIR/efi/run, not $TEST_DIR/run.
> Also, now that we may be using the link, rather than the
> script directly, make sure we use an absolute path to the
> EFI source rather than assuming it's the parent directory.
> TEST_DIR already points there, so we can just use that.
> 
> Signed-off-by: Andrew Jones <andrew.jones@linux.dev>

Reviewed-by: Nikos Nikoleris <nikos.nikoleris@arm.com>

> ---
>   arm/efi/run | 2 +-
>   configure   | 5 ++++-
>   x86/efi/run | 2 +-
>   3 files changed, 6 insertions(+), 3 deletions(-)
> 
> diff --git a/arm/efi/run b/arm/efi/run
> index f75ef157acf3..6872c337c945 100755
> --- a/arm/efi/run
> +++ b/arm/efi/run
> @@ -21,7 +21,7 @@ elif [ -f /usr/share/edk2/aarch64/QEMU_EFI.silent.fd ]; then
>   	DEFAULT_UEFI=/usr/share/edk2/aarch64/QEMU_EFI.silent.fd
>   fi
>   
> -: "${EFI_SRC:=$(realpath "$(dirname "$0")/../")}"
> +: "${EFI_SRC:=$TEST_DIR}"
>   : "${EFI_UEFI:=$DEFAULT_UEFI}"
>   : "${EFI_TEST:=efi-tests}"
>   : "${EFI_CASE:=$(basename $1 .efi)}"
> diff --git a/configure b/configure
> index b665f7d586c2..6ee9b27a6af2 100755
> --- a/configure
> +++ b/configure
> @@ -313,7 +313,10 @@ if [ ! -d "$srcdir/$testdir" ]; then
>       echo "$testdir does not exist!"
>       exit 1
>   fi
> -if [ -f "$srcdir/$testdir/run" ]; then
> +
> +if [ "$efi" = "y" ] && [ -f "$srcdir/$testdir/efi/run" ]; then
> +    ln -fs "$srcdir/$testdir/efi/run" $testdir-run
> +elif [ -f "$srcdir/$testdir/run" ]; then
>       ln -fs "$srcdir/$testdir/run" $testdir-run
>   fi
>   
> diff --git a/x86/efi/run b/x86/efi/run
> index 322cb7567fdc..85aeb94fe605 100755
> --- a/x86/efi/run
> +++ b/x86/efi/run
> @@ -13,7 +13,7 @@ if [ ! -f config.mak ]; then
>   fi
>   source config.mak
>   
> -: "${EFI_SRC:=$(realpath "$(dirname "$0")/../")}"
> +: "${EFI_SRC:=$TEST_DIR}"
>   : "${EFI_UEFI:=/usr/share/ovmf/OVMF.fd}"
>   : "${EFI_TEST:=efi-tests}"
>   : "${EFI_SMP:=1}"
