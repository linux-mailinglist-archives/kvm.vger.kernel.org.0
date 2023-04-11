Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BCD8C6DE4FB
	for <lists+kvm@lfdr.de>; Tue, 11 Apr 2023 21:29:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229585AbjDKT3N (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 11 Apr 2023 15:29:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34858 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229606AbjDKT3M (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 11 Apr 2023 15:29:12 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E656DE51
        for <kvm@vger.kernel.org>; Tue, 11 Apr 2023 12:28:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1681241302;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=bVNE4HBLsM7bk8WD9QWxskR53JZ0gHpsGqJ8vPgqUlw=;
        b=CqTXUcPtf2M9+bR3gYI8cTRgMneRpEyYQ1QIaXoianjlGLyMFdRLxNU8BUZKxjOn+fmdYO
        iBRLiMUpgjAidxe6fcg9vLw+GJnOo8ZkFX1kH8MxEnZQvjoALpfzAi/7kJybx7mGdEmAg+
        hv9T7coOPAf96XQ4cXVTLts5v4B3KEY=
Received: from mail-io1-f70.google.com (mail-io1-f70.google.com
 [209.85.166.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-50-fxoO-q4cN-qOy_fYV9DzcA-1; Tue, 11 Apr 2023 15:28:20 -0400
X-MC-Unique: fxoO-q4cN-qOy_fYV9DzcA-1
Received: by mail-io1-f70.google.com with SMTP id v4-20020a6bac04000000b007587234a54cso6237475ioe.6
        for <kvm@vger.kernel.org>; Tue, 11 Apr 2023 12:28:20 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1681241299; x=1683833299;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=bVNE4HBLsM7bk8WD9QWxskR53JZ0gHpsGqJ8vPgqUlw=;
        b=J8wwvua86f52TDgJoCL7PmX7TBZnpIat2Q6ZDaFFa42JngRmNNY/0GyonQsprudWhf
         hJCkiLQ6Adialvib5ovMHDtJEIxqZcsEAqv2IjqxVGwnZ079IR2io1SJevYFV78nBgJ1
         e5ytYJTAbaIyErj9w5dUF7F+oltpF4tu/P1d6c8DYGSkTptI9nKDeuIMTxA30kxXuDmL
         FsdXHC44v/vRfErB5QUg7K+BCLCrd47OsFGVxo0tNDntjNg891InBsgB64DaIScYBKL8
         KFbJwfCLNpAichYUM4oZ7T2kfQc8E+9d+4KMqrSAC5mrVPPV9AMmhuZ+5FIVl/gf6xg7
         nSkA==
X-Gm-Message-State: AAQBX9cJmdB4f5ITOUl2oEvho7tI4NcHFaxPWscTsR6qyv2GaROG12oN
        hB6ku7Cl4+qonCrsljS936dlafzstlQdHIA4mCMJ3g24Th3t7exwzC+yVXAAX1dMley9R+kPB9c
        wqf+eLw5CVaU6X+De1Mv4
X-Received: by 2002:a92:da82:0:b0:325:dafe:d4a0 with SMTP id u2-20020a92da82000000b00325dafed4a0mr9399510iln.28.1681241299587;
        Tue, 11 Apr 2023 12:28:19 -0700 (PDT)
X-Google-Smtp-Source: AKy350ZqXUzBuDGLDDFtE+S0a9mP5wmE0VkSooTlfTXmeIR+bJrhHvjiuiD0mKfP4/Sr0YGZOPkGKQ==
X-Received: by 2002:a92:da82:0:b0:325:dafe:d4a0 with SMTP id u2-20020a92da82000000b00325dafed4a0mr9399499iln.28.1681241299339;
        Tue, 11 Apr 2023 12:28:19 -0700 (PDT)
Received: from redhat.com ([38.15.36.239])
        by smtp.gmail.com with ESMTPSA id v3-20020a92c6c3000000b003292f183c95sm113795ilm.58.2023.04.11.12.28.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 11 Apr 2023 12:28:18 -0700 (PDT)
Date:   Tue, 11 Apr 2023 13:28:11 -0600
From:   Alex Williamson <alex.williamson@redhat.com>
To:     Simon Horman <horms@kernel.org>
Cc:     kvm@vger.kernel.org
Subject: Re: [PATCH vfio] vfio: correct kdoc for ops structures
Message-ID: <20230411132811.498e0061.alex.williamson@redhat.com>
In-Reply-To: <20230329120603.468031-1-horms@kernel.org>
References: <20230329120603.468031-1-horms@kernel.org>
X-Mailer: Claws Mail 4.1.1 (GTK 3.24.35; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, 29 Mar 2023 14:06:03 +0200
Simon Horman <horms@kernel.org> wrote:

> Address minor omissions from kdoc for ops structures flagged by check-kdoc:
> 
>   ./scripts/kernel-doc -Werror -none include/linux/vfio.h
> 
>   include/linux/vfio.h:114: warning: Function parameter or member 'name' not described in 'vfio_device_ops'
>   include/linux/vfio.h:143: warning: Cannot understand  * @migration_set_state: Optional callback to change the migration state for
>    on line 143 - I thought it was a doc line
>   include/linux/vfio.h:168: warning: Cannot understand  * @log_start: Optional callback to ask the device start DMA logging.
>    on line 168 - I thought it was a doc line
> 
> Signed-off-by: Simon Horman <horms@kernel.org>
> ---
>  include/linux/vfio.h | 5 +++++
>  1 file changed, 5 insertions(+)

Applied to vfio next branch for v6.4.  Thanks,

Alex

> 
> diff --git a/include/linux/vfio.h b/include/linux/vfio.h
> index 93134b023968..cb46050045c0 100644
> --- a/include/linux/vfio.h
> +++ b/include/linux/vfio.h
> @@ -68,6 +68,7 @@ struct vfio_device {
>  /**
>   * struct vfio_device_ops - VFIO bus driver device callbacks
>   *
> + * @name: Name of the device driver.
>   * @init: initialize private fields in device structure
>   * @release: Reclaim private fields in device structure
>   * @bind_iommufd: Called when binding the device to an iommufd
> @@ -140,6 +141,8 @@ int vfio_iommufd_emulated_attach_ioas(struct vfio_device *vdev, u32 *pt_id);
>  #endif
>  
>  /**
> + * struct vfio_migration_ops - VFIO bus device driver migration callbacks
> + *
>   * @migration_set_state: Optional callback to change the migration state for
>   *         devices that support migration. It's mandatory for
>   *         VFIO_DEVICE_FEATURE_MIGRATION migration support.
> @@ -165,6 +168,8 @@ struct vfio_migration_ops {
>  };
>  
>  /**
> + * struct vfio_log_ops - VFIO bus device driver logging callbacks
> + *
>   * @log_start: Optional callback to ask the device start DMA logging.
>   * @log_stop: Optional callback to ask the device stop DMA logging.
>   * @log_read_and_clear: Optional callback to ask the device read

