Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 302FF62D358
	for <lists+kvm@lfdr.de>; Thu, 17 Nov 2022 07:17:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231734AbiKQGRC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 17 Nov 2022 01:17:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59092 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239133AbiKQGQ6 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 17 Nov 2022 01:16:58 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F2C7429824
        for <kvm@vger.kernel.org>; Wed, 16 Nov 2022 22:16:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1668665764;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=W+WY7fE+dg2X2iyU5DPd7eZ0r72bXN9Iad6U2vbxRTA=;
        b=heMkLK4m/n2DWVLNUGaHDGeKBAKtHomq4KmY3J5k8rHyWKoBbnOreBx+8GnK/l2EVYAba8
        a51ibqrpNRtPGlJYNrbOi93/EqGdEnk1ZUVzw/RAuOeH76fDj4qZeqSps7+rd5qYZHrUhW
        M/N5irm4UbJdai98ytN0cuCk46ga0IE=
Received: from mail-pl1-f197.google.com (mail-pl1-f197.google.com
 [209.85.214.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-53-DzMqXIDENv2Pf5SS03ooRg-1; Thu, 17 Nov 2022 01:16:02 -0500
X-MC-Unique: DzMqXIDENv2Pf5SS03ooRg-1
Received: by mail-pl1-f197.google.com with SMTP id u8-20020a17090341c800b0018731b83fe4so689377ple.16
        for <kvm@vger.kernel.org>; Wed, 16 Nov 2022 22:16:01 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=W+WY7fE+dg2X2iyU5DPd7eZ0r72bXN9Iad6U2vbxRTA=;
        b=iIqWz46ptbQ8opxQKuXtM0yjuMfz7HJZme9kMuxDnAP3giDIZAbd0Zuq8UHGCdTe96
         oG2gewEU8cGUAI7b7FSxQFs5QMI8XaOZfzOz9D83D96mtcE7DppyAbRlpEC+dfrsZEWO
         ETSfb1OMv43+6No/xBipGXDQ4ysvl8h8k9MhXByeD6t9ffrx/sY7pEUfwj0bP78piCmf
         br2g2osNCQZif2/SH0g/RWg9RBMA2wFq1HjejqLP28SzgycEeuPvw8/TJZNx355ZJhrc
         h5JRUpgvR+rYaHSMxxQEsrqB6KaDKbJuHmHLGbwP+kXgWdE8Ff6TUONIXPy29zIKB2iK
         mZOg==
X-Gm-Message-State: ANoB5plGilbxdMPB1WhY886FmD2zNM/HFI65tecETIfw0qUDsFfScv+c
        kX2BJTr3PlxVubhsDTeRO49ZiPRYNaoY0KO7o2xsrhOuYsC4lF4T2hSBk+qKrtsWwvdQ7gHqJ+r
        MafIEOUYESEwa
X-Received: by 2002:a17:902:aa08:b0:188:e878:b5f6 with SMTP id be8-20020a170902aa0800b00188e878b5f6mr1252645plb.150.1668665761023;
        Wed, 16 Nov 2022 22:16:01 -0800 (PST)
X-Google-Smtp-Source: AA0mqf6Gnau1gRHMne9NkEleqkHKmBOFGSfeA0NerNOykI8lxUX7dHM8OB+NczGWBZu3yu7/vhYG4g==
X-Received: by 2002:a17:902:aa08:b0:188:e878:b5f6 with SMTP id be8-20020a170902aa0800b00188e878b5f6mr1252615plb.150.1668665760681;
        Wed, 16 Nov 2022 22:16:00 -0800 (PST)
Received: from [10.72.13.24] ([43.228.180.230])
        by smtp.gmail.com with ESMTPSA id h16-20020a170902f55000b001869f2120absm196256plf.294.2022.11.16.22.15.54
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 16 Nov 2022 22:16:00 -0800 (PST)
Message-ID: <400412ca-813a-3a59-c054-16576b5ae61d@redhat.com>
Date:   Thu, 17 Nov 2022 14:15:52 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.4.2
Subject: Re: [PATCH for 8.0 v7 08/10] vdpa: Store x-svq parameter in
 VhostVDPAState
Content-Language: en-US
To:     =?UTF-8?Q?Eugenio_P=c3=a9rez?= <eperezma@redhat.com>,
        qemu-devel@nongnu.org
Cc:     Cornelia Huck <cohuck@redhat.com>,
        Gautam Dawar <gdawar@xilinx.com>, Eli Cohen <eli@mellanox.com>,
        Stefano Garzarella <sgarzare@redhat.com>,
        Harpreet Singh Anand <hanand@xilinx.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        Cindy Lu <lulu@redhat.com>,
        Liuxiangdong <liuxiangdong5@huawei.com>,
        "Gonglei (Arei)" <arei.gonglei@huawei.com>,
        Parav Pandit <parav@mellanox.com>,
        Si-Wei Liu <si-wei.liu@oracle.com>,
        Zhu Lingshan <lingshan.zhu@intel.com>,
        Laurent Vivier <lvivier@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>, kvm@vger.kernel.org
References: <20221116150556.1294049-1-eperezma@redhat.com>
 <20221116150556.1294049-9-eperezma@redhat.com>
From:   Jason Wang <jasowang@redhat.com>
In-Reply-To: <20221116150556.1294049-9-eperezma@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


在 2022/11/16 23:05, Eugenio Pérez 写道:
> CVQ can be shadowed two ways:
> - Device has x-svq=on parameter (current way)
> - The device can isolate CVQ in its own vq group
>
> QEMU needs to check for the second condition dynamically, because CVQ
> index is not known at initialization time. Since this is dynamic, the
> CVQ isolation could vary with different conditions, making it possible
> to go from "not isolated group" to "isolated".
>
> Saving the cmdline parameter in an extra field so we never disable CVQ
> SVQ in case the device was started with cmdline.
>
> Signed-off-by: Eugenio Pérez <eperezma@redhat.com>


Acked-by: Jason Wang <jasowang@redhat.com>

Thanks


> ---
>   net/vhost-vdpa.c | 3 +++
>   1 file changed, 3 insertions(+)
>
> diff --git a/net/vhost-vdpa.c b/net/vhost-vdpa.c
> index 89b01fcaec..5185ac7042 100644
> --- a/net/vhost-vdpa.c
> +++ b/net/vhost-vdpa.c
> @@ -38,6 +38,8 @@ typedef struct VhostVDPAState {
>       void *cvq_cmd_out_buffer;
>       virtio_net_ctrl_ack *status;
>   
> +    /* The device always have SVQ enabled */
> +    bool always_svq;
>       bool started;
>   } VhostVDPAState;
>   
> @@ -566,6 +568,7 @@ static NetClientState *net_vhost_vdpa_init(NetClientState *peer,
>   
>       s->vhost_vdpa.device_fd = vdpa_device_fd;
>       s->vhost_vdpa.index = queue_pair_index;
> +    s->always_svq = svq;
>       s->vhost_vdpa.shadow_vqs_enabled = svq;
>       s->vhost_vdpa.iova_tree = iova_tree;
>       if (!is_datapath) {

