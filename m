Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2C33E3390F8
	for <lists+kvm@lfdr.de>; Fri, 12 Mar 2021 16:16:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231337AbhCLPQV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 12 Mar 2021 10:16:21 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:36751 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231861AbhCLPQR (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 12 Mar 2021 10:16:17 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1615562176;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=A5J2rJulblbgqoqRb92cPCJCQqD7ZFSeC+TL1fUNNCA=;
        b=S5VojyAwcrKyEhWt53gobzRfN+ndiwcEc+q2MnCz2wUjusXp2RlU/RvJxCXNe4gt+VReqD
        knOHQQ5wmOSN81VNH38EgUZIhp70Pu2S2WsD7YLfVkSC9GDDJ3aNjvc8b60Q0tgqcKeZ6U
        YmUh1WrixPLNTIyGWFmtdOXuAtQrURk=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-22-9H0tOIyEP7qpkoGZnRSVqg-1; Fri, 12 Mar 2021 10:16:12 -0500
X-MC-Unique: 9H0tOIyEP7qpkoGZnRSVqg-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 2078A107ACCD;
        Fri, 12 Mar 2021 15:16:11 +0000 (UTC)
Received: from kamzik.brq.redhat.com (unknown [10.40.192.104])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 8589619704;
        Fri, 12 Mar 2021 15:16:09 +0000 (UTC)
Date:   Fri, 12 Mar 2021 16:16:06 +0100
From:   Andrew Jones <drjones@redhat.com>
To:     Alexandru Elisei <alexandru.elisei@arm.com>
Cc:     kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu,
        pbonzini@redhat.com
Subject: Re: [kvm-unit-tests PATCH] configure: arm/arm64: Add --earlycon
 option to set UART type and address
Message-ID: <20210312151606.qkfp7evsrpbw2wtq@kamzik.brq.redhat.com>
References: <20210219163718.109101-1-alexandru.elisei@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210219163718.109101-1-alexandru.elisei@arm.com>
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Feb 19, 2021 at 04:37:18PM +0000, Alexandru Elisei wrote:
> Currently, the UART early address is set indirectly with the --vmm option
> and there are only two possible values: if the VMM is qemu (the default),
> then the UART address is set to 0x09000000; if the VMM is kvmtool, then the
> UART address is set to 0x3f8.
> 
> There several efforts under way to change the kvmtool UART address, and
> kvm-unit-tests so far hasn't had mechanism to let the user set a specific
> address, which means that the early UART won't be available.
> 
> This situation will only become worse as kvm-unit-tests gains support to
> run as an EFI app, as each platform will have their own UART type and
> address.
> 
> To address both issues, a new configure option is added, --earlycon. The
> syntax and semantics are identical to the kernel parameter with the same
> name. Specifying this option will overwrite the UART address set by --vmm.
> 
> At the moment, the UART type and register width parameters are ignored
> since both qemu's and kvmtool's UART emulation use the same offset for the
> TX register and no other registers are used by kvm-unit-tests, but the
> parameters will become relevant once EFI support is added.
> 
> Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>
> ---
> The kvmtool patches I was referring to are the patches to unify ioport and
> MMIO emulation [1] and to allow the user to specify a custom memory layout
> for the VM [2] (these patches are very old, but I plan to revive them after
> the ioport and MMIO unification series are merged).
> 
> [1] https://lore.kernel.org/kvm/20201210142908.169597-1-andre.przywara@arm.com/T/#t
> [2] https://lore.kernel.org/kvm/1569245722-23375-1-git-send-email-alexandru.elisei@arm.com/
> 
>  configure | 35 +++++++++++++++++++++++++++++++++++
>  1 file changed, 35 insertions(+)
> 
> diff --git a/configure b/configure
> index cdcd34e94030..d94b92255088 100755
> --- a/configure
> +++ b/configure
> @@ -26,6 +26,7 @@ errata_force=0
>  erratatxt="$srcdir/errata.txt"
>  host_key_document=
>  page_size=
> +earlycon=
>  
>  usage() {
>      cat <<-EOF
> @@ -54,6 +55,17 @@ usage() {
>  	    --page-size=PAGE_SIZE
>  	                           Specify the page size (translation granule) (4k, 16k or
>  	                           64k, default is 64k, arm64 only)
> +	    --earlycon=EARLYCON
> +	                           Specify the UART name, type and address (optional, arm and
> +	                           arm64 only). The specified address will overwrite the UART
> +	                           address set by the --vmm option. EARLYCON can be on of (case

s/be on of/be one of/

> +	                           sensitive):
> +	               uart[8250],mmio,ADDR
> +	                           Specify an 8250 compatible UART at address ADDR. Supported
> +	                           register stride is 8 bit only.
> +	               pl011,mmio,ADDR
> +	                           Specify a PL011 compatible UART at address ADDR. Supported
> +	                           register stride is 8 bit only.
>  EOF
>      exit 1
>  }
> @@ -112,6 +124,9 @@ while [[ "$1" = -* ]]; do
>  	--page-size)
>  	    page_size="$arg"
>  	    ;;
> +	--earlycon)
> +	    earlycon="$arg"
> +	    ;;
>  	--help)
>  	    usage
>  	    ;;
> @@ -170,6 +185,26 @@ elif [ "$arch" = "arm" ] || [ "$arch" = "arm64" ]; then
>          echo '--vmm must be one of "qemu" or "kvmtool"!'
>          usage
>      fi
> +
> +    if [ "$earlycon" ]; then
> +        name=$(echo $earlycon|cut -d',' -f1)
> +        if [ "$name" != "uart" ] && [ "$name" != "uart8250" ] &&
> +                [ "$name" != "pl011" ]; then
> +            echo "unknown earlycon name: $name"
> +            usage
> +        fi
> +        type=$(echo $earlycon|cut -d',' -f2)
> +        if [ "$type" != "mmio" ]; then
> +            echo "unknown earlycon type: $type"
> +            usage
> +        fi
> +        addr=$(echo $earlycon|cut -d',' -f3)
> +        if [ -z "$addr" ]; then
> +            echo "missing earlycon address"
> +            usage
> +        fi
> +        arm_uart_early_addr=$addr
> +    fi
>  elif [ "$arch" = "ppc64" ]; then
>      testdir=powerpc
>      firmware="$testdir/boot_rom.bin"
> -- 
> 2.30.1
>

Otherwise,
 
Reviewed-by: Andrew Jones <drjones@redhat.com>

