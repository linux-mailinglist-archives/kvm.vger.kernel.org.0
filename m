Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E37D4633FED
	for <lists+kvm@lfdr.de>; Tue, 22 Nov 2022 16:16:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233692AbiKVPQ2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 22 Nov 2022 10:16:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60040 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232648AbiKVPQ0 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 22 Nov 2022 10:16:26 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ABCA042F7D
        for <kvm@vger.kernel.org>; Tue, 22 Nov 2022 07:15:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1669130131;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=hK0ObLejkUdO2kT5TG9vuCU2RH+H4+xSCZQ9aj/PoXU=;
        b=YHGsAZurgKTwVkNI3Bzrgr4OycK/e3+aJL6t9Kex5X6yV35pwx87uBIJSZrd/K8orxqqY7
        YdApDA7kBLMaS9fN4pAXSV+PGT6hz//zue0Tc7hgESiifAJCZkRX9tHARZZPYeb+s3SIap
        PVvxF1WYyC+lUZTLJOUc+v8W5TlH3s4=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-500-FKhYbCPzM0eMSRPWLPxODA-1; Tue, 22 Nov 2022 10:15:30 -0500
X-MC-Unique: FKhYbCPzM0eMSRPWLPxODA-1
Received: by mail-wm1-f72.google.com with SMTP id e8-20020a05600c218800b003cf634f5280so4181745wme.8
        for <kvm@vger.kernel.org>; Tue, 22 Nov 2022 07:15:30 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=hK0ObLejkUdO2kT5TG9vuCU2RH+H4+xSCZQ9aj/PoXU=;
        b=uzlxt2aw57O5OVXvGMrxpjggGSaasquD8oB/M2d/vGArUZW54WS2oDjfTAQt0bZsyj
         MpwSp2WMln5roms6IlXB7xdm4EvO5aI3dILRftr8/hWTf+lXGHOyZOobYUq0WExWjPEi
         MMNCrdSZEH16V2TkhhG8sHn64CeO6qj1waj4DxVavkiU3k/PwIMHW9mnfofVhQP4jks3
         4yIed2KJ28wKcQd/YaWE2aR27D1X3k+0usdUO97BMLAfCh6UD/s3R0nbI+c9mzcy/uvt
         ltM+14NFauxf6r+oEQHyLt4AZztHyk2BrVP45Tsw4n22lteywekxYE5w2wnGAJVeUN1c
         XSdg==
X-Gm-Message-State: ANoB5pn58UFpsS9KI+PaVQluA3nyXmSRw9j7zIyw47rfjGgyWvr89IFF
        LMnoqYU6hKoMR7ECvdemseI+SjskE/pH1+YXaWwthsN/3O8JG9clBaJvd6TQ2XvCQcSlTCUX3Ew
        RD8pG2YcKbjXC
X-Received: by 2002:a7b:c3c9:0:b0:3cf:5442:bbe with SMTP id t9-20020a7bc3c9000000b003cf54420bbemr20606653wmj.2.1669130129214;
        Tue, 22 Nov 2022 07:15:29 -0800 (PST)
X-Google-Smtp-Source: AA0mqf5SOw1y9jXJkuwchkA+/tOO86TqATmbtRGdYrHaEKbQW+CeSO9KlzdRp2zdpCm9yQDtyT4spw==
X-Received: by 2002:a7b:c3c9:0:b0:3cf:5442:bbe with SMTP id t9-20020a7bc3c9000000b003cf54420bbemr20606627wmj.2.1669130128874;
        Tue, 22 Nov 2022 07:15:28 -0800 (PST)
Received: from [192.168.8.105] (tmo-116-109.customers.d1-online.com. [80.187.116.109])
        by smtp.gmail.com with ESMTPSA id f28-20020a5d58fc000000b0022e36c1113fsm14093648wrd.13.2022.11.22.07.15.27
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 22 Nov 2022 07:15:28 -0800 (PST)
Message-ID: <61474ecb-fa2a-e651-9157-b73b6b5a8295@redhat.com>
Date:   Tue, 22 Nov 2022 16:15:26 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.13.0
Subject: Re: [PATCH v3] virtio_console: Introduce an ID allocator for virtual
 console numbers
Content-Language: en-US
To:     =?UTF-8?Q?C=c3=a9dric_Le_Goater?= <clg@kaod.org>,
        Amit Shah <amit@kernel.org>,
        "Michael S. Tsirkin" <mst@redhat.com>
Cc:     Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        virtualization@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org
References: <20221122134643.376184-1-clg@kaod.org>
From:   Thomas Huth <thuth@redhat.com>
In-Reply-To: <20221122134643.376184-1-clg@kaod.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 22/11/2022 14.46, Cédric Le Goater wrote:
> When a virtio console port is initialized, it is registered as an hvc
> console using a virtual console number. If a KVM guest is started with
> multiple virtio console devices, the same vtermno (or virtual console
> number) can be used to allocate different hvc consoles, which leads to
> various communication problems later on.
> 
> This is also reported in debugfs :
> 
>    # grep vtermno /sys/kernel/debug/virtio-ports/*
>    /sys/kernel/debug/virtio-ports/vport1p1:console_vtermno: 1
>    /sys/kernel/debug/virtio-ports/vport2p1:console_vtermno: 1
>    /sys/kernel/debug/virtio-ports/vport3p1:console_vtermno: 2
>    /sys/kernel/debug/virtio-ports/vport4p1:console_vtermno: 3
> 
> Replace the next_vtermno global with an ID allocator and start the
> allocation at 1 as it is today. Also recycle IDs when a console port
> is removed.
> 
> Signed-off-by: Cédric Le Goater <clg@kaod.org>
> ---
> 
>   Changes in v3:
>   - made use of ida_alloc_min()
>   - free ID in case of error
>   
>   Changes in v2:
>   - introduced an ID allocator
> 
>   drivers/char/virtio_console.c | 26 +++++++++++---------------
>   1 file changed, 11 insertions(+), 15 deletions(-)
> 
> diff --git a/drivers/char/virtio_console.c b/drivers/char/virtio_console.c
> index 9fa3c76a267f..6a821118d553 100644
> --- a/drivers/char/virtio_console.c
> +++ b/drivers/char/virtio_console.c
> @@ -13,6 +13,7 @@
>   #include <linux/fs.h>
>   #include <linux/splice.h>
>   #include <linux/pagemap.h>
> +#include <linux/idr.h>
>   #include <linux/init.h>
>   #include <linux/list.h>
>   #include <linux/poll.h>
> @@ -48,22 +49,11 @@ struct ports_driver_data {
>   	/* List of all the devices we're handling */
>   	struct list_head portdevs;
>   
> -	/*
> -	 * This is used to keep track of the number of hvc consoles
> -	 * spawned by this driver.  This number is given as the first
> -	 * argument to hvc_alloc().  To correctly map an initial
> -	 * console spawned via hvc_instantiate to the console being
> -	 * hooked up via hvc_alloc, we need to pass the same vtermno.
> -	 *
> -	 * We also just assume the first console being initialised was
> -	 * the first one that got used as the initial console.
> -	 */
> -	unsigned int next_vtermno;
> -
>   	/* All the console devices handled by this driver */
>   	struct list_head consoles;
>   };
> -static struct ports_driver_data pdrvdata = { .next_vtermno = 1};
> +
> +static struct ports_driver_data pdrvdata;
>   
>   static DEFINE_SPINLOCK(pdrvdata_lock);
>   static DECLARE_COMPLETION(early_console_added);
> @@ -89,6 +79,8 @@ struct console {
>   	u32 vtermno;
>   };
>   
> +static DEFINE_IDA(vtermno_ida);
> +
>   struct port_buffer {
>   	char *buf;
>   
> @@ -1244,18 +1236,21 @@ static int init_port_console(struct port *port)
>   	 * pointers.  The final argument is the output buffer size: we
>   	 * can do any size, so we put PAGE_SIZE here.
>   	 */
> -	port->cons.vtermno = pdrvdata.next_vtermno;
> +	ret = ida_alloc_min(&vtermno_ida, 1, GFP_KERNEL);
> +	if (ret < 0)
> +		return ret;
>   
> +	port->cons.vtermno = ret;
>   	port->cons.hvc = hvc_alloc(port->cons.vtermno, 0, &hv_ops, PAGE_SIZE);
>   	if (IS_ERR(port->cons.hvc)) {
>   		ret = PTR_ERR(port->cons.hvc);
>   		dev_err(port->dev,
>   			"error %d allocating hvc for port\n", ret);
>   		port->cons.hvc = NULL;
> +		ida_free(&vtermno_ida, port->cons.vtermno);
>   		return ret;
>   	}
>   	spin_lock_irq(&pdrvdata_lock);
> -	pdrvdata.next_vtermno++;
>   	list_add_tail(&port->cons.list, &pdrvdata.consoles);
>   	spin_unlock_irq(&pdrvdata_lock);
>   	port->guest_connected = true;
> @@ -1532,6 +1527,7 @@ static void unplug_port(struct port *port)
>   		list_del(&port->cons.list);
>   		spin_unlock_irq(&pdrvdata_lock);
>   		hvc_remove(port->cons.hvc);
> +		ida_free(&vtermno_ida, port->cons.vtermno);
>   	}
>   
>   	remove_port_data(port);

Reviewed-by: Thomas Huth <thuth@redhat.com>

