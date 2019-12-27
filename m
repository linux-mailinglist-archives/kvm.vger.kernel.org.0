Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5AF4012B43D
	for <lists+kvm@lfdr.de>; Fri, 27 Dec 2019 12:35:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727011AbfL0Lf3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 27 Dec 2019 06:35:29 -0500
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:51368 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726053AbfL0Lf3 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 27 Dec 2019 06:35:29 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1577446528;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=G520wLk4w8rMfRbHoLT/My/RHoPqlx4xSfB8MUzn4CA=;
        b=ZQNCAYMUWLZwVZM0z7YYSCY67vqhaExljcxwzXBUBXefe/2IdZOBwKZ/hWy0/dsHDQkYEP
        qBxWmxWMJ1RqiCApxKN23joDIvchxhLaTxFjguKTGbEuiWabWi2354+/Bc+EHvBiZyXhlE
        PxsYhCb5AEht7HUSplcPUmMgKIRbBho=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-361-S-dQp65oOZe6jIUiv_UmlA-1; Fri, 27 Dec 2019 06:35:24 -0500
X-MC-Unique: S-dQp65oOZe6jIUiv_UmlA-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 365CDDB20;
        Fri, 27 Dec 2019 11:35:23 +0000 (UTC)
Received: from kamzik.brq.redhat.com (ovpn-204-101.brq.redhat.com [10.40.204.101])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id C35F819E9C;
        Fri, 27 Dec 2019 11:35:20 +0000 (UTC)
Date:   Fri, 27 Dec 2019 12:35:17 +0100
From:   Andrew Jones <drjones@redhat.com>
To:     Zeng Tao <prime.zeng@hisilicon.com>
Cc:     pbonzini@redhat.com, kvm@vger.kernel.org, xuwei5@huawei.com,
        huangdaode@huawei.com, linuxarm@huawei.com
Subject: Re: [kvm-unit-tests PATCH] devicetree: Fix the dt_for_each_cpu_node
Message-ID: <20191227113517.ungo73oakc4kr6dw@kamzik.brq.redhat.com>
References: <1577444615-26720-1-git-send-email-prime.zeng@hisilicon.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1577444615-26720-1-git-send-email-prime.zeng@hisilicon.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Dec 27, 2019 at 07:03:35PM +0800, Zeng Tao wrote:
> If the /cpus node contains nodes other than /cpus/cpu*, for example:
> /cpus/cpu-map/. The test will issue an unexpected assert error as
> follow:
> [root@localhost]# ./arm-run arm/spinlock-test.flat
> qemu-system-aarch64 -nodefaults -machine virt,gic-version=host,accel=kvm
>  -cpu host -device virtio-serial-device -device virtconsole,chardev=ctd
> -chardev testdev,id=ctd -device pci-testdev -display none -serial stdio
> -kernel arm/spinlock-test.flat # -initrd /tmp/tmp.mwPLiF4EWm
> lib/arm/setup.c:64: assert failed: ret == 0
>         STACK:
> 
> In this patch, ignore the non-cpu subnodes instead of return an error.
> 
> Signed-off-by: Zeng Tao <prime.zeng@hisilicon.com>
> ---
>  lib/devicetree.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/lib/devicetree.c b/lib/devicetree.c
> index 2b89178..1020324 100644
> --- a/lib/devicetree.c
> +++ b/lib/devicetree.c
> @@ -225,7 +225,7 @@ int dt_for_each_cpu_node(void (*func)(int fdtnode, u64 regval, void *info),
>  
>  		prop = fdt_get_property(fdt, cpu, "device_type", &len);
>  		if (prop == NULL)
> -			return len;
> +			continue;
>  
>  		if (len != 4 || strcmp((char *)prop->data, "cpu"))
>  			continue;
> -- 
> 1.8.3.1
>

Queued to https://github.com/rhdrjones/kvm-unit-tests/commits/arm/queue

I'll send a pull request to Paolo soon.

Thanks,
drew

