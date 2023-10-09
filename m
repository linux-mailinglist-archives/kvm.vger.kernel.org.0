Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DDF9D7BE47E
	for <lists+kvm@lfdr.de>; Mon,  9 Oct 2023 17:18:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1376491AbjJIPSd (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 9 Oct 2023 11:18:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58636 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1376748AbjJIPS2 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 9 Oct 2023 11:18:28 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 14405BA
        for <kvm@vger.kernel.org>; Mon,  9 Oct 2023 08:17:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1696864662;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=u5JcXPIqedItIu+FW3AQTSKHWl8dmpt+dQk3rJLF9AU=;
        b=PC4LxMwd1AjS0MzlaktxkiXQO4+idm+Cka8SP/4cunjYYOmRvEyj3tBx9jqOk+tyU4pxlh
        okN8FZ1dLr1lNlSnqheX41gnAHv2g2ciyuiTUvIOUsjdNBgnUhj39Pa6IeLFRA2REryr7B
        tfmQHMIDt2t30QgAM7t9PSJSJNI5aOw=
Received: from mail-ej1-f70.google.com (mail-ej1-f70.google.com
 [209.85.218.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-241-TW9370haOMyeXsP7bLLBBg-1; Mon, 09 Oct 2023 11:17:39 -0400
X-MC-Unique: TW9370haOMyeXsP7bLLBBg-1
Received: by mail-ej1-f70.google.com with SMTP id a640c23a62f3a-9b99b6b8315so126543066b.2
        for <kvm@vger.kernel.org>; Mon, 09 Oct 2023 08:17:39 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1696864658; x=1697469458;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=u5JcXPIqedItIu+FW3AQTSKHWl8dmpt+dQk3rJLF9AU=;
        b=Q+h+ssiO/QskZx1ZbGU1iS/IaPiuL3DCSn7drAIH71GGnZ+OTrsoLwTlub3IROjCfI
         b2QqHHltaD9vSqPTacyjPaHoklB2YSFtcHY0tQ8q2KEK+BDCrAweUZpNmGZOgm7kEv3j
         tzKTjRLLsZHkM4mxp5BrGjy/8UO7iYW3ngw8V6t1NzUI5CMYB+B0hwXfmmD5IQPuOSGR
         FFXByuBU+V1mzw7EC93X7sl6/hMF7fcJDxiub9LLmtWNt1TWvY2qJr5r1jaGgFR2UOrp
         GB0yCy5SNZXKwqNiUqI3oltggtPECzkoMCunX9KjNx8gdWNYdwdMeceVm/zAvTOH304w
         N5yg==
X-Gm-Message-State: AOJu0Yz/i1C980B4jwUCEstGylLKSAoXmA7lf1samkx1h5SRwYlJ4bhE
        ZV5lZkpdMHsI18IcbbJSZNOEPnwyQeNcj30EmVVkTOo9WETTJxfapijH2JvWaB9ZVuyipCfRZUI
        Kfg6ZL7apsHDt
X-Received: by 2002:aa7:c991:0:b0:536:e5f7:b329 with SMTP id c17-20020aa7c991000000b00536e5f7b329mr13448866edt.33.1696864658547;
        Mon, 09 Oct 2023 08:17:38 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFqaNdjOVR8GEVS7MrW8+be1z+py7ZOPR3ncwNWSeW3qxMntltB1eh7SSq1dhz3kONe9XqOGA==
X-Received: by 2002:aa7:c991:0:b0:536:e5f7:b329 with SMTP id c17-20020aa7c991000000b00536e5f7b329mr13448839edt.33.1696864658056;
        Mon, 09 Oct 2023 08:17:38 -0700 (PDT)
Received: from sgarzare-redhat (host-82-57-51-114.retail.telecomitalia.it. [82.57.51.114])
        by smtp.gmail.com with ESMTPSA id w24-20020a50fa98000000b00532bec5f768sm6197050edr.95.2023.10.09.08.17.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 09 Oct 2023 08:17:37 -0700 (PDT)
Date:   Mon, 9 Oct 2023 17:17:33 +0200
From:   Stefano Garzarella <sgarzare@redhat.com>
To:     Arseniy Krasnov <avkrasnov@salutedevices.com>
Cc:     Stefan Hajnoczi <stefanha@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        Bobby Eshleman <bobby.eshleman@bytedance.com>,
        kvm@vger.kernel.org, virtualization@lists.linux-foundation.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        kernel@sberdevices.ru, oxffffaa@gmail.com
Subject: Re: [PATCH net-next v3 11/12] test/vsock: MSG_ZEROCOPY support for
 vsock_perf
Message-ID: <afcyfpp6axca3d2ebtrp44o4wqxkutbn6eixv2gnpa2r3ievhr@yx2462i5p3e7>
References: <20231007172139.1338644-1-avkrasnov@salutedevices.com>
 <20231007172139.1338644-12-avkrasnov@salutedevices.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20231007172139.1338644-12-avkrasnov@salutedevices.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sat, Oct 07, 2023 at 08:21:38PM +0300, Arseniy Krasnov wrote:
>To use this option pass '--zerocopy' parameter:
>
>./vsock_perf --zerocopy --sender <cid> ...
>
>With this option MSG_ZEROCOPY flag will be passed to the 'send()' call.
>
>Signed-off-by: Arseniy Krasnov <avkrasnov@salutedevices.com>
>---
> Changelog:
> v1 -> v2:
>  * Move 'SOL_VSOCK' and 'VSOCK_RECVERR' from 'util.c' to 'util.h'.
> v2 -> v3:
>  * Use 'msg_zerocopy_common.h' for MSG_ZEROCOPY related things.
>  * Rename '--zc' option to '--zerocopy'.
>  * Add detail in help that zerocopy mode is for sender mode only.
>
> tools/testing/vsock/vsock_perf.c | 80 ++++++++++++++++++++++++++++----
> 1 file changed, 71 insertions(+), 9 deletions(-)

Reviewed-by: Stefano Garzarella <sgarzare@redhat.com>

