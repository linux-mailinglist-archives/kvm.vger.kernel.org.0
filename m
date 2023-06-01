Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B1E4C71F420
	for <lists+kvm@lfdr.de>; Thu,  1 Jun 2023 22:47:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231600AbjFAUrS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 1 Jun 2023 16:47:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33930 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229536AbjFAUrQ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 1 Jun 2023 16:47:16 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7987E18C
        for <kvm@vger.kernel.org>; Thu,  1 Jun 2023 13:46:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1685652389;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=mKfOoPxKXKTaQ3RA/2u3I6KvcI8YXFqEVhkLpnR7WjE=;
        b=G+XPJJ8t3Gn0vdncwys81GZ7iZzbZp6buFOJ5favAH8aMc8roNghYIbVLvikLV7HRWK7iH
        /fUrwnHtTmhQRTvANhj5OEUoUiq2xmoOpy7lPehERhmDd7LInY0j2vjyha4rPmtdCIaG3s
        p+WYdUBdtuj37NbYHVVu2Uu0cI1lwHQ=
Received: from mail-il1-f198.google.com (mail-il1-f198.google.com
 [209.85.166.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-626-Uz1Fq1cFOWygwxZ_PJJSyA-1; Thu, 01 Jun 2023 16:46:28 -0400
X-MC-Unique: Uz1Fq1cFOWygwxZ_PJJSyA-1
Received: by mail-il1-f198.google.com with SMTP id e9e14a558f8ab-33b7a468d14so10289265ab.3
        for <kvm@vger.kernel.org>; Thu, 01 Jun 2023 13:46:28 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685652387; x=1688244387;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=mKfOoPxKXKTaQ3RA/2u3I6KvcI8YXFqEVhkLpnR7WjE=;
        b=UFKdVfC+VPjw8bHmry7/KCT2ne1doX+Eq/7/bIrNptbSISLmxWxzxtU6uW8L6rnf9w
         LjJqKiPZ6zzuoH94n355DwhknnoQI0pjz2CgG0BBmvM+KTOg3uA+BFcaPrTMFysWPUxm
         iZsEBsJQAyXb/dGWNFjFG4eOAcK8wVyD0wK9wmXI/9btd0wxRzvdbpZ17FW3hUlo2xbO
         UC/SkiFpRRVQyebuc6U5EhMJFkpiWWz2tCKZqkS2DG6eJklnBTfxIdADfPltSu03+rJ6
         L41mRGWyYZAgvXZ6iNXtAlzR+XrmvKNwMrUk5hR2myhS9FIdo2ZsSeX56ffnz2a00CQv
         xZTw==
X-Gm-Message-State: AC+VfDxBOg6WmXFiit3WzZG1yjKRSwqLwHcfd32q6D4PoRLcmqzffF3q
        Xn1A0ozM1gsnwqhGl3fY2Syo5cWbts3TVJ7xVxZAlejilZRzVCatLa2k1HKpqOZC7sMJKm/llEC
        G2IqdBppbX3ds
X-Received: by 2002:a92:de0e:0:b0:33a:a6de:65be with SMTP id x14-20020a92de0e000000b0033aa6de65bemr5672190ilm.21.1685652387608;
        Thu, 01 Jun 2023 13:46:27 -0700 (PDT)
X-Google-Smtp-Source: ACHHUZ4ywpMG3vtlHLLEM1U239mV9AK6gm9PprEslu+sHDJULivPRXsgppL7UaHjCclklcKCTTg9FA==
X-Received: by 2002:a92:de0e:0:b0:33a:a6de:65be with SMTP id x14-20020a92de0e000000b0033aa6de65bemr5672186ilm.21.1685652387435;
        Thu, 01 Jun 2023 13:46:27 -0700 (PDT)
Received: from redhat.com ([38.15.36.239])
        by smtp.gmail.com with ESMTPSA id u22-20020a056638135600b00411be337516sm2570727jad.24.2023.06.01.13.46.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 01 Jun 2023 13:46:26 -0700 (PDT)
Date:   Thu, 1 Jun 2023 14:46:26 -0600
From:   Alex Williamson <alex.williamson@redhat.com>
To:     Tony Krowiak <akrowiak@linux.ibm.com>
Cc:     linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, jjherne@linux.ibm.com, pasic@linux.ibm.com,
        farman@linux.ibm.com, mjrosato@linux.ibm.com,
        borntraeger@linux.ibm.com
Subject: Re: [PATCH 1/3] vfio: ap: realize the VFIO_DEVICE_GET_IRQ_INFO
 ioctl
Message-ID: <20230601144626.577a94d3.alex.williamson@redhat.com>
In-Reply-To: <20230530223538.279198-2-akrowiak@linux.ibm.com>
References: <20230530223538.279198-1-akrowiak@linux.ibm.com>
        <20230530223538.279198-2-akrowiak@linux.ibm.com>
X-Mailer: Claws Mail 4.1.1 (GTK 3.24.35; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 30 May 2023 18:35:36 -0400
Tony Krowiak <akrowiak@linux.ibm.com> wrote:

> Realize the VFIO_DEVICE_GET_IRQ_INFO ioctl to retrieve the information for
> the VFIO device request IRQ.
> 
> Signed-off-by: Tony Krowiak <akrowiak@linux.ibm.com>
> ---
>  drivers/s390/crypto/vfio_ap_ops.c | 30 +++++++++++++++++++++++++++++-
>  include/uapi/linux/vfio.h         |  9 +++++++++
>  2 files changed, 38 insertions(+), 1 deletion(-)

Acked-by: Alex Williamson <alex.williamson@redhat.com>

