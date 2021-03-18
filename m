Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2F8EC340A69
	for <lists+kvm@lfdr.de>; Thu, 18 Mar 2021 17:43:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232186AbhCRQma (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 18 Mar 2021 12:42:30 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:37392 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232185AbhCRQmG (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 18 Mar 2021 12:42:06 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1616085725;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=kX2zQnoPDL9myLXwoBUVguGMe20BFhMVAa6s8sui3hM=;
        b=L9qN/eHeHeRoAFq+c+ubtZRBJBVe0vLGadJ4PMVUEt8+oyhs3GA08OQn1mIjS8KrcByvlk
        dZ17NmY/sLE/ZQkP+m5M/72RQIElKlTsv41KHmvBmT3vFJ2RZ2yMdKnxbjxe8qvZY84tjS
        IPzkRbE1Cr9oIaFF3gviGM91gg/wmHc=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-473-ZNlHvmrXNSaQMGynjEf9Pw-1; Thu, 18 Mar 2021 12:42:03 -0400
X-MC-Unique: ZNlHvmrXNSaQMGynjEf9Pw-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 8046F107B784;
        Thu, 18 Mar 2021 16:42:02 +0000 (UTC)
Received: from kamzik.brq.redhat.com (unknown [10.40.196.5])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 2152E5B4A6;
        Thu, 18 Mar 2021 16:42:00 +0000 (UTC)
Date:   Thu, 18 Mar 2021 17:41:57 +0100
From:   Andrew Jones <drjones@redhat.com>
To:     Alexandru Elisei <alexandru.elisei@arm.com>
Cc:     kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu,
        pbonzini@redhat.com
Subject: Re: [kvm-unit-tests PATCH v2] configure: arm/arm64: Add --earlycon
 option to set UART type and address
Message-ID: <20210318164157.xervbl23zvqmqdli@kamzik.brq.redhat.com>
References: <20210318162022.84482-1-alexandru.elisei@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210318162022.84482-1-alexandru.elisei@arm.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Mar 18, 2021 at 04:20:22PM +0000, Alexandru Elisei wrote:
> Currently, the UART early address is set indirectly with the --vmm option
> and there are only two possible values: if the VMM is qemu (the default),
> then the UART address is set to 0x09000000; if the VMM is kvmtool, then the
> UART address is set to 0x3f8.
> 
> The upstream kvmtool commit 45b4968e0de1 ("hw/serial: ARM/arm64: Use MMIO
> at higher addresses") changed the UART address to 0x1000000, and
> kvm-unit-tests so far hasn't had mechanism to let the user set a specific
> address, which means that for recent versions of kvmtool the early UART
> won't be available.
> 
> This situation will only become worse as kvm-unit-tests gains support to
> run as an EFI app, as each platform will have their own UART type and
> address.
> 
> To address both issues, a new configure option is added, --earlycon. The
> syntax and semantics are identical to the kernel parameter with the same
> name. For example, for kvmtool, --earlycon=uart,mmio,0x1000000 will set the
> correct UART address. Specifying this option will overwrite the UART
> address set by --vmm.
> 
> At the moment, the UART type and register width parameters are ignored
> since both qemu's and kvmtool's UART emulation use the same offset for the
> TX register and no other registers are used by kvm-unit-tests, but the
> parameters will become relevant once EFI support is added.
> 
> Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>
> ---
> Besides working with current versions of kvmtool, this will also make early
> console work if the user specifies a custom memory layout [1] (patches are
> old, but I plan to pick them up at some point in the future).
> 
> Changes in v2:
> * kvmtool patches were merged, so I reworked the commit message to point to
>   the corresponding kvmtool commit.
> * Restricted pl011 register size to 32 bits, as per Arm Base System
>   Architecture 1.0 (DEN0094A), and to match Linux.
> * Reworked the way the fields are extracted to make it more precise
>   (without the -s argument, the entire string is echo'ed when no delimiter
>   is found).

You can also drop 'cut' and just do something like

IFS=, read -r name type_addr addr <<<"$earlycon"

> * The changes are not trivial, so I dropped Drew's Reviewed-by.
> 
> [1] https://lore.kernel.org/kvm/1569245722-23375-1-git-send-email-alexandru.elisei@arm.com/
> 
>  configure | 61 +++++++++++++++++++++++++++++++++++++++++++++++++++++++
>  1 file changed, 61 insertions(+)
> 
> diff --git a/configure b/configure
> index cdcd34e94030..137b165db18f 100755
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
> @@ -54,6 +55,18 @@ usage() {
>  	    --page-size=PAGE_SIZE
>  	                           Specify the page size (translation granule) (4k, 16k or
>  	                           64k, default is 64k, arm64 only)
> +	    --earlycon=EARLYCON
> +	                           Specify the UART name, type and address (optional, arm and
> +	                           arm64 only). The specified address will overwrite the UART
> +	                           address set by the --vmm option. EARLYCON can be on of (case

'on of' typo still here

> +	                           sensitive):
> +	               uart[8250],mmio,ADDR
> +	                           Specify an 8250 compatible UART at address ADDR. Supported
> +	                           register stride is 8 bit only.
> +	               pl011,ADDR
> +	               pl011,mmio32,ADDR
> +	                           Specify a PL011 compatible UART at address ADDR. Supported
> +	                           register stride is 32 bit only.
>  EOF
>      exit 1
>  }
> @@ -112,6 +125,9 @@ while [[ "$1" = -* ]]; do
>  	--page-size)
>  	    page_size="$arg"
>  	    ;;
> +	--earlycon)
> +	    earlycon="$arg"
> +	    ;;
>  	--help)
>  	    usage
>  	    ;;
> @@ -170,6 +186,51 @@ elif [ "$arch" = "arm" ] || [ "$arch" = "arm64" ]; then
>          echo '--vmm must be one of "qemu" or "kvmtool"!'
>          usage
>      fi
> +
> +    if [ "$earlycon" ]; then
> +        # Append delimiter and use cut -s to prevent cut from ignoring the field
> +        # argument if no delimiter is specified by the user.
> +        earlycon="$earlycon,"
> +        name=$(echo $earlycon|cut -sd',' -f1)
> +        if [ "$name" != "uart" ] && [ "$name" != "uart8250" ] &&
> +                [ "$name" != "pl011" ]; then
> +            echo "unknown earlycon name: $name"
> +            usage
> +        fi
> +
> +        if [ "$name" = "pl011" ]; then
> +            type_addr=$(echo $earlycon|cut -sd',' -f2)
> +            if [ -z "$type_addr" ]; then
> +                echo "missing earlycon address"
> +                usage
> +            fi
> +            addr=$(echo $earlycon|cut -sd',' -f3)
> +            if [ -z "$addr" ]; then

Don't you need

  if [ "$type_addr" = "mmio32" ]; then
     echo "missing earlycon address"
     usage
  fi

here to avoid accepting

  pl011,mmio32

and then assigning mmio32 to the address?

And/or should we do a quick sanity check on the address?
Something like

  [[ $addr =~ ^0?x?[0-9a-f]+$ ]]


> +                addr=$type_addr
> +            else
> +                if [ "$type_addr" != "mmio32" ]; then
> +                    echo "unknown $name earlycon type: $type_addr"
> +                    usage
> +                fi
> +            fi
> +        else
> +            type=$(echo $earlycon|cut -sd',' -f2)
> +            if [ -z "$type" ]; then
> +                echo "missing $name earlycon type"
> +                usage
> +            fi
> +            if [ "$type" != "mmio" ]; then
> +                echo "unknown $name earlycon type: $type"
> +                usage
> +            fi
> +            addr=$(echo $earlycon|cut -sd',' -f3)
> +            if [ -z "$addr" ]; then
> +                echo "missing earlycon address"
> +                usage
> +            fi
> +        fi
> +        arm_uart_early_addr=$addr
> +    fi
>  elif [ "$arch" = "ppc64" ]; then
>      testdir=powerpc
>      firmware="$testdir/boot_rom.bin"
> -- 
> 2.30.2
> 

Thanks,
drew

