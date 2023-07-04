Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2BB10746D06
	for <lists+kvm@lfdr.de>; Tue,  4 Jul 2023 11:18:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231593AbjGDJSD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 4 Jul 2023 05:18:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43544 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229598AbjGDJR5 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 4 Jul 2023 05:17:57 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7478FB3
        for <kvm@vger.kernel.org>; Tue,  4 Jul 2023 02:17:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1688462231;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=UAtcpfjIhGghN+hoXzP2DX/eD2bDJw9VvAHsF2obYOk=;
        b=VAubbDLe7ny+hFEsHCrYSMeFBGzCgNUrWAIxtarM4FXe2V9ajLVFeO70Rdm75OZlMbnpc6
        SXTzGLWk6vsuzjfApxtZ4O2hJ0P2bl2H2FU4zJbcCUB8tFCK29RWUGmXSk4/4Uwvm0M/vF
        B964sPOS7Va90C0iSeAAW97RVlI5uro=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-461-JT4m3KhFMMmM2X2pJEGL2A-1; Tue, 04 Jul 2023 05:17:05 -0400
X-MC-Unique: JT4m3KhFMMmM2X2pJEGL2A-1
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com [10.11.54.10])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 34C622834778;
        Tue,  4 Jul 2023 09:17:05 +0000 (UTC)
Received: from localhost (dhcp-192-239.str.redhat.com [10.33.192.239])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 978C8492C13;
        Tue,  4 Jul 2023 09:17:04 +0000 (UTC)
From:   Cornelia Huck <cohuck@redhat.com>
To:     Shaoqin Huang <shahuang@redhat.com>, qemu-devel@nongnu.org,
        qemu-arm@nongnu.org
Cc:     oliver.upton@linux.dev, salil.mehta@huawei.com,
        james.morse@arm.com, gshan@redhat.com,
        Shaoqin Huang <shahuang@redhat.com>,
        Peter Maydell <peter.maydell@linaro.org>,
        Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org
Subject: Re: [PATCH v1 4/5] arm/kvm: add skeleton implementation for
 userspace SMCCC call handling
In-Reply-To: <20230626064910.1787255-5-shahuang@redhat.com>
Organization: Red Hat GmbH
References: <20230626064910.1787255-1-shahuang@redhat.com>
 <20230626064910.1787255-5-shahuang@redhat.com>
User-Agent: Notmuch/0.37 (https://notmuchmail.org)
Date:   Tue, 04 Jul 2023 11:17:03 +0200
Message-ID: <877crghw8g.fsf@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.10
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Jun 26 2023, Shaoqin Huang <shahuang@redhat.com> wrote:

> The SMCCC call filtering provide the ability to forward the SMCCC call
> to userspace, so we provide a new option `user-smccc` to enable handling
> SMCCC call in userspace, the default value is off.
>
> And add the skeleton implementation for userspace SMCCC call
> initialization and handling.
>
> Signed-off-by: Shaoqin Huang <shahuang@redhat.com>
> ---
>  docs/system/arm/virt.rst |  4 +++
>  hw/arm/virt.c            | 21 ++++++++++++++++
>  include/hw/arm/virt.h    |  1 +
>  target/arm/kvm.c         | 54 ++++++++++++++++++++++++++++++++++++++++
>  4 files changed, 80 insertions(+)
>
> diff --git a/docs/system/arm/virt.rst b/docs/system/arm/virt.rst
> index 1cab33f02e..ff43d52f04 100644
> --- a/docs/system/arm/virt.rst
> +++ b/docs/system/arm/virt.rst
> @@ -155,6 +155,10 @@ dtb-randomness
>    DTB to be non-deterministic. It would be the responsibility of
>    the firmware to come up with a seed and pass it on if it wants to.
>  
> +user-smccc
> +  Set ``on``/``off`` to enable/disable handling smccc call in userspace
> +  instead of kernel.
> +
>  dtb-kaslr-seed
>    A deprecated synonym for dtb-randomness.
>  
> diff --git a/hw/arm/virt.c b/hw/arm/virt.c
> index 9b9f7d9c68..767720321c 100644
> --- a/hw/arm/virt.c
> +++ b/hw/arm/virt.c
> @@ -42,6 +42,7 @@
>  #include "hw/vfio/vfio-amd-xgbe.h"
>  #include "hw/display/ramfb.h"
>  #include "net/net.h"
> +#include "qom/object.h"
>  #include "sysemu/device_tree.h"
>  #include "sysemu/numa.h"
>  #include "sysemu/runstate.h"
> @@ -2511,6 +2512,19 @@ static void virt_set_oem_table_id(Object *obj, const char *value,
>      strncpy(vms->oem_table_id, value, 8);
>  }
>  
> +static bool virt_get_user_smccc(Object *obj, Error **errp)
> +{
> +    VirtMachineState *vms = VIRT_MACHINE(obj);
> +
> +    return vms->user_smccc;
> +}
> +
> +static void virt_set_user_smccc(Object *obj, bool value, Error **errp)
> +{
> +    VirtMachineState *vms = VIRT_MACHINE(obj);
> +
> +    vms->user_smccc = value;
> +}
>  
>  bool virt_is_acpi_enabled(VirtMachineState *vms)
>  {
> @@ -3155,6 +3169,13 @@ static void virt_machine_class_init(ObjectClass *oc, void *data)
>                                            "in ACPI table header."
>                                            "The string may be up to 8 bytes in size");
>  
> +    object_class_property_add_bool(oc, "user-smccc",
> +                                   virt_get_user_smccc,
> +                                   virt_set_user_smccc);
> +    object_class_property_set_description(oc, "user-smccc",
> +                                          "Set on/off to enable/disable "
> +                                          "handling smccc call in userspace");
> +
>  }
>  
>  static void virt_instance_init(Object *obj)

This knob pretty much only makes sense for KVM guests, and we'll ignore
it with tcg -- would it make sense to check that we are actually using
KVM before we proceed (like we do for the tcg-only props?)

