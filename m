Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0A585218E14
	for <lists+kvm@lfdr.de>; Wed,  8 Jul 2020 19:16:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726660AbgGHRQg (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 8 Jul 2020 13:16:36 -0400
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:31664 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726374AbgGHRQg (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 8 Jul 2020 13:16:36 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1594228595;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=qE29t9i0arRfIYNg/XRg+3yFtpkbxdAMVE0O/Y0bPw4=;
        b=Uq8Ro97qiUQclvgpmfWdd9noK7VBnI5D3MnBd9J88mZWB7fnaN0aebOv8Jzus+XSJNBH6k
        X7vMYOUU1H6RUAUpw7DrSrhodlIj9YKjt6jFb3UcHOnxOrsphMIwd9UO+KngmgX0Diw02c
        9IbpytH4GM2cU8I5eOH65EzCV3W1Zw8=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-284-ZqDD13RrM2OM7849dyWt-g-1; Wed, 08 Jul 2020 13:16:33 -0400
X-MC-Unique: ZqDD13RrM2OM7849dyWt-g-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id AC936800D5C;
        Wed,  8 Jul 2020 17:16:31 +0000 (UTC)
Received: from localhost (ovpn-116-140.rdu2.redhat.com [10.10.116.140])
        by smtp.corp.redhat.com (Postfix) with ESMTP id EDD605D9C9;
        Wed,  8 Jul 2020 17:16:22 +0000 (UTC)
Date:   Wed, 8 Jul 2020 13:16:21 -0400
From:   Eduardo Habkost <ehabkost@redhat.com>
To:     Mohammed Gamal <mgamal@redhat.com>
Cc:     Daniel =?iso-8859-1?Q?P=2E_Berrang=E9?= <berrange@redhat.com>,
        "Dr. David Alan Gilbert" <dgilbert@redhat.com>,
        Pedro Principeza <pedro.principeza@canonical.com>,
        Dann Frazier <dann.frazier@canonical.com>,
        Guilherme Piccoli <gpiccoli@canonical.com>,
        qemu-devel@nongnu.org,
        Christian Ehrhardt <christian.ehrhardt@canonical.com>,
        Gerd Hoffmann <kraxel@redhat.com>,
        Laszlo Ersek <lersek@redhat.com>, fw@gpiccoli.net,
        pbonzini@redhat.com, mtosatti@redhat.com, rth@twiddle.net,
        kvm@vger.kernel.org, libvir-list@redhat.com
Subject: Re: [PATCH 2/2] x86/cpu: Handle GUEST_MAXPHYADDR < HOST_MAXPHYADDR
 for hosts that don't support it
Message-ID: <20200708171621.GA780932@habkost.net>
References: <20200619155344.79579-1-mgamal@redhat.com>
 <20200619155344.79579-3-mgamal@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200619155344.79579-3-mgamal@redhat.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

(CCing libvir-list, and people who were included in the OVMF
thread[1])

[1] https://lore.kernel.org/qemu-devel/99779e9c-f05f-501b-b4be-ff719f140a88@canonical.com/

On Fri, Jun 19, 2020 at 05:53:44PM +0200, Mohammed Gamal wrote:
> If the CPU doesn't support GUEST_MAXPHYADDR < HOST_MAXPHYADDR we
> let QEMU choose to use the host MAXPHYADDR and print a warning to the
> user.
> 
> Signed-off-by: Mohammed Gamal <mgamal@redhat.com>
> ---
>  target/i386/cpu.c | 11 +++++++++++
>  1 file changed, 11 insertions(+)
> 
> diff --git a/target/i386/cpu.c b/target/i386/cpu.c
> index b1b311baa2..91c57117ce 100644
> --- a/target/i386/cpu.c
> +++ b/target/i386/cpu.c
> @@ -6589,6 +6589,17 @@ static void x86_cpu_realizefn(DeviceState *dev, Error **errp)
>              uint32_t host_phys_bits = x86_host_phys_bits();
>              static bool warned;
>  
> +	    /*
> +	     * If host doesn't support setting physical bits on the guest,
> +	     * report it and return
> +	     */
> +	    if (cpu->phys_bits < host_phys_bits &&
> +		!kvm_has_smaller_maxphyaddr()) {
> +		warn_report("Host doesn't support setting smaller phys-bits."
> +			    " Using host phys-bits\n");
> +		cpu->phys_bits = host_phys_bits;
> +	    }
> +

This looks like a regression from existing behavior.  Today,
using smaller phys-bits doesn't crash most guests, and still
allows live migration to smaller hosts.  I agree using the host
phys-bits is probably a better default, but we shouldn't override
options set explicitly in the command line.

Also, it's important that we work with libvirt and management
software to ensure they have appropriate APIs to choose what to
do when a cluster has hosts with different MAXPHYADDR.

>              /* Print a warning if the user set it to a value that's not the
>               * host value.
>               */
> -- 
> 2.26.2
> 

-- 
Eduardo

