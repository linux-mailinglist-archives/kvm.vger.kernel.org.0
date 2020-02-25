Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 53E7016BBEA
	for <lists+kvm@lfdr.de>; Tue, 25 Feb 2020 09:34:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729332AbgBYIeR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 25 Feb 2020 03:34:17 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:36021 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1725783AbgBYIeR (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 25 Feb 2020 03:34:17 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1582619656;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Zeq8bfWrbjUWuhe9VoT/P8t5pKlOCkcgFST3tqDuVYU=;
        b=P1KgZ9l0Rql8o6OqicmvbC92lYT9MWGzYsQDlJKBSa0b/V9XVMEHDCvbllSHpcePxrjdpG
        w6xfduxrhAIjrP5JgLbLnxf7p+gr1c0sp39ngcrDJsTKc3RzTPs5e7QKphGQhifizV78y9
        elwXA453iL1ASWRreBmKl6I2gzkj0k8=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-204-XRADUvImPiC2RjB3yHQlfg-1; Tue, 25 Feb 2020 03:34:14 -0500
X-MC-Unique: XRADUvImPiC2RjB3yHQlfg-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 3F4A0800D50;
        Tue, 25 Feb 2020 08:34:12 +0000 (UTC)
Received: from localhost (unknown [10.43.2.114])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 7EA3090A04;
        Tue, 25 Feb 2020 08:34:06 +0000 (UTC)
Date:   Tue, 25 Feb 2020 09:34:04 +0100
From:   Igor Mammedov <imammedo@redhat.com>
To:     Dongjiu Geng <gengdongjiu@huawei.com>
Cc:     <mst@redhat.com>, <xiaoguangrong.eric@gmail.com>,
        <shannon.zhaosl@gmail.com>, <peter.maydell@linaro.org>,
        <fam@euphon.net>, <rth@twiddle.net>, <ehabkost@redhat.com>,
        <mtosatti@redhat.com>, <qemu-devel@nongnu.org>,
        <kvm@vger.kernel.org>, <qemu-arm@nongnu.org>,
        <pbonzini@redhat.com>, <james.morse@arm.com>, <lersek@redhat.com>,
        <jonathan.cameron@huawei.com>,
        <shameerali.kolothum.thodi@huawei.com>, <zhengxiang9@huawei.com>
Subject: Re: [PATCH v24 02/10] hw/arm/virt: Introduce a RAS machine option
Message-ID: <20200225093404.0ee40224@redhat.com>
In-Reply-To: <20200217131248.28273-3-gengdongjiu@huawei.com>
References: <20200217131248.28273-1-gengdongjiu@huawei.com>
        <20200217131248.28273-3-gengdongjiu@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, 17 Feb 2020 21:12:40 +0800
Dongjiu Geng <gengdongjiu@huawei.com> wrote:

> RAS Virtualization feature is not supported now, so add a RAS machine

> option and disable it by default.
             ^^^^

this doesn't match the patch.

I'd rephrase it as:

... feature is disabled by default ..
add an option so user could enable it with

   -machine virt,ras=on


> Reviewed-by: Peter Maydell <peter.maydell@linaro.org>
> Signed-off-by: Dongjiu Geng <gengdongjiu@huawei.com>
> Signed-off-by: Xiang Zheng <zhengxiang9@huawei.com>
> Reviewed-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
> ---
>  hw/arm/virt.c         | 23 +++++++++++++++++++++++
>  include/hw/arm/virt.h |  1 +
>  2 files changed, 24 insertions(+)
> 
> diff --git a/hw/arm/virt.c b/hw/arm/virt.c
> index f788fe2..9555b8b 100644
> --- a/hw/arm/virt.c
> +++ b/hw/arm/virt.c
> @@ -1823,6 +1823,20 @@ static void virt_set_its(Object *obj, bool value, Error **errp)
>      vms->its = value;
>  }
>  
> +static bool virt_get_ras(Object *obj, Error **errp)
> +{
> +    VirtMachineState *vms = VIRT_MACHINE(obj);
> +
> +    return vms->ras;
> +}
> +
> +static void virt_set_ras(Object *obj, bool value, Error **errp)
> +{
> +    VirtMachineState *vms = VIRT_MACHINE(obj);
> +
> +    vms->ras = value;
> +}
> +
>  static char *virt_get_gic_version(Object *obj, Error **errp)
>  {
>      VirtMachineState *vms = VIRT_MACHINE(obj);
> @@ -2126,6 +2140,15 @@ static void virt_instance_init(Object *obj)
>                                      "Valid values are none and smmuv3",
>                                      NULL);
>  
> +    /* Default disallows RAS instantiation */
> +    vms->ras = false;
> +    object_property_add_bool(obj, "ras", virt_get_ras,
> +                             virt_set_ras, NULL);
> +    object_property_set_description(obj, "ras",
> +                                    "Set on/off to enable/disable reporting host memory errors "
> +                                    "to a KVM guest using ACPI and guest external abort exceptions",
> +                                    NULL);
> +
>      vms->irqmap = a15irqmap;
>  
>      virt_flash_create(vms);
> diff --git a/include/hw/arm/virt.h b/include/hw/arm/virt.h
> index 71508bf..c32b7c7 100644
> --- a/include/hw/arm/virt.h
> +++ b/include/hw/arm/virt.h
> @@ -123,6 +123,7 @@ typedef struct {
>      bool highmem_ecam;
>      bool its;
>      bool virt;
> +    bool ras;
>      int32_t gic_version;
>      VirtIOMMUType iommu;
>      struct arm_boot_info bootinfo;

