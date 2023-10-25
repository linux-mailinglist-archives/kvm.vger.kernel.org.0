Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E18677D653C
	for <lists+kvm@lfdr.de>; Wed, 25 Oct 2023 10:35:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232992AbjJYIfC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 25 Oct 2023 04:35:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53092 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234022AbjJYIfB (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 25 Oct 2023 04:35:01 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3CFFD9C
        for <kvm@vger.kernel.org>; Wed, 25 Oct 2023 01:34:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1698222853;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=PwvR0H/rJekRKW7bPChVNQWyI2TmQ8ZzJ/CtmxOFWqI=;
        b=IvvfKJrpuRggrJieXQ5IdJA/D2Ifch5hW4Cm3xKTnGah8SaBn3WpEi49aFrQ3/ryuoJbmw
        w/Jg2QSOpw+b1j4zQCDowJVOxroY9nLi52UNObltpPA602wPWqeRC34iPZ+YmJm86RS4Ki
        K0OhzxTrdhIqTARr3CAcBQLSXhfZzeI=
Received: from mail-qt1-f199.google.com (mail-qt1-f199.google.com
 [209.85.160.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-649-xJIg9dGHPN6OMfN429c6Lw-1; Wed, 25 Oct 2023 04:34:02 -0400
X-MC-Unique: xJIg9dGHPN6OMfN429c6Lw-1
Received: by mail-qt1-f199.google.com with SMTP id d75a77b69052e-41bf9a5930aso63408051cf.2
        for <kvm@vger.kernel.org>; Wed, 25 Oct 2023 01:34:02 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1698222841; x=1698827641;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=PwvR0H/rJekRKW7bPChVNQWyI2TmQ8ZzJ/CtmxOFWqI=;
        b=YPXXananrzWlVfVXv618nblq089VuM40PHPYrHwhjFc3JprV3xViw5gpFouwRw9wpn
         M6Yn5Advm6JUepCcWFwqJsHdsDTyHpPi/hCe+gpfBjHJwHUzjrDMuOaEKTdNZcShKI1r
         h3tlVGyWrmTwb9xOJLJ7Hun0TLmRjZty1fp3uALKNQnwSBOWvosgmRK0U9tUNscZv3Oz
         wChmNrLCtMn8reEnhHzl9iX7NAxRlMZM1sBX2/jrCN01TouYm4p4iyFnEtHMJe0GZl1v
         7TKK4166H5MUpEKSbg+gX13nH/yNzBi9ZjeqN2OgPqbp6Aog+zAcdEhpGEiGqKb0g4KH
         5Kyg==
X-Gm-Message-State: AOJu0YyOsNPciOpcUJBUD+gqQFRCoSCTRbBXdbLxTrdlolecAK9eDkb2
        zo/XWvTvvA9yYTyDkUOlT+698tVlhT+mAEGOameD1EeW6eJXyKFCp8Ilu5GeRFJRAeN31H6l1kx
        mKoGjWpOC+IOn
X-Received: by 2002:a05:622a:3d3:b0:418:b8c:1a0a with SMTP id k19-20020a05622a03d300b004180b8c1a0amr19027901qtx.25.1698222841615;
        Wed, 25 Oct 2023 01:34:01 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEwwSeGExFJjD6DFEBCEVHy8IMPsNdmNyv4qMG1/LmCczDQr1ec7svBZSUmolsxUEMpJlCnJQ==
X-Received: by 2002:a05:622a:3d3:b0:418:b8c:1a0a with SMTP id k19-20020a05622a03d300b004180b8c1a0amr19027875qtx.25.1698222841295;
        Wed, 25 Oct 2023 01:34:01 -0700 (PDT)
Received: from sgarzare-redhat (host-87-12-185-56.business.telecomitalia.it. [87.12.185.56])
        by smtp.gmail.com with ESMTPSA id f2-20020ac87f02000000b004198f67acbesm4022433qtk.63.2023.10.25.01.33.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 25 Oct 2023 01:34:00 -0700 (PDT)
Date:   Wed, 25 Oct 2023 10:33:56 +0200
From:   Stefano Garzarella <sgarzare@redhat.com>
To:     Alexandru Matei <alexandru.matei@uipath.com>
Cc:     Stefan Hajnoczi <stefanha@redhat.com>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Mihai Petrisor <mihai.petrisor@uipath.com>,
        Viorel Canja <viorel.canja@uipath.com>
Subject: Re: [PATCH v4] vsock/virtio: initialize the_virtio_vsock before
 using VQs
Message-ID: <gg3dml3ipk44cx55gjshr7km74xsksdc6pkosa5sulufannxsw@pgpqq7kjosw4>
References: <20231024191742.14259-1-alexandru.matei@uipath.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20231024191742.14259-1-alexandru.matei@uipath.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Oct 24, 2023 at 10:17:42PM +0300, Alexandru Matei wrote:
>Once VQs are filled with empty buffers and we kick the host, it can send
>connection requests. If the_virtio_vsock is not initialized before,
>replies are silently dropped and do not reach the host.
>
>virtio_transport_send_pkt() can queue packets once the_virtio_vsock is
>set, but they won't be processed until vsock->tx_run is set to true. We
>queue vsock->send_pkt_work when initialization finishes to send those
>packets queued earlier.
>
>Fixes: 0deab087b16a ("vsock/virtio: use RCU to avoid use-after-free on the_virtio_vsock")
>Signed-off-by: Alexandru Matei <alexandru.matei@uipath.com>
>---
>v4:
>- moved queue_work for send_pkt_work in vqs_start and added comment explaining why
>v3:
>- renamed vqs_fill to vqs_start and moved tx_run initialization to it
>- queued send_pkt_work at the end of initialization to send packets queued earlier
>v2:
>- split virtio_vsock_vqs_init in vqs_init and vqs_fill and moved
>  the_virtio_vsock initialization after vqs_init
>
> net/vmw_vsock/virtio_transport.c | 18 +++++++++++++++++-
> 1 file changed, 17 insertions(+), 1 deletion(-)

LGTM!

Reviewed-by: Stefano Garzarella <sgarzare@redhat.com>

