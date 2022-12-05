Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 72A28642B9D
	for <lists+kvm@lfdr.de>; Mon,  5 Dec 2022 16:26:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232600AbiLEP0S (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 5 Dec 2022 10:26:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59760 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232441AbiLEPZ7 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 5 Dec 2022 10:25:59 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 50AAC20F50
        for <kvm@vger.kernel.org>; Mon,  5 Dec 2022 07:22:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1670253725;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=elsUsSh2guQFj13lKLZcZWyjOegOjpyy+dsSOWV4Rrk=;
        b=HSQ/fL9mSNw7WukmadmrlLLR2WdcBo+D5vXIYNgU783B+TzZ1D0/CypLM/LXLLcr3T9bgY
        bHPe6I3B0cXLmnYPf7xkJEogg1BR6oeOM9b4RxO6PPAO+DTVs2l6IvRD2XyBvAcxY4exqq
        yFZHusR+5iAF0JgHqpKge9bYm5le3gI=
Received: from mail-io1-f69.google.com (mail-io1-f69.google.com
 [209.85.166.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-408-AO6ENLyCOmCfMrIVcKqM8A-1; Mon, 05 Dec 2022 10:22:04 -0500
X-MC-Unique: AO6ENLyCOmCfMrIVcKqM8A-1
Received: by mail-io1-f69.google.com with SMTP id n23-20020a056602341700b00689fc6dbfd6so9889371ioz.8
        for <kvm@vger.kernel.org>; Mon, 05 Dec 2022 07:22:04 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:organization:references
         :in-reply-to:message-id:subject:cc:to:from:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=elsUsSh2guQFj13lKLZcZWyjOegOjpyy+dsSOWV4Rrk=;
        b=N99gZupe+MXDX/Qtcfm4S8T7Aq6f+EL099PoUnaZPAGYD/zJHc9ygq/kpRm7q1J2xK
         l+8sqQ6e8gBvA3oA4Tn4vix4mCffeAx2wyfKrXqvxZ2fCF3V3L13R+twbdMjUk5Xy/he
         HXmKNEZL2OSp4Sl1cDpv9m4lf7HnuqSycaUn075xDKFzKQAPReM9L3RfRDrrfGFPNVOb
         PAXVF6qFIJXKq7zrq1riYvtt/O1+t+1zmVcEM5EMgqycf12uIDjosf0/7PDv5kRnENBa
         tjI+9p7Evr1k9c81akibC/LkmkNNlqcl3FBCMQXtO6MZX9JteuCDum7sSrWiBhQT2S+T
         Zh2A==
X-Gm-Message-State: ANoB5pnPHPAKojsi9R1FTxPOwmKqU+uff8rFDZ8EGouVJTgGJGZfLQiX
        pnF+IFkgBFlo5RstnwCAAHSBmQ4X4cL6AcIlYObXeMmS0qZCTvoKRqsUU1nmNEEFsR9TLC7yBbG
        SDDDczZaU8u7c
X-Received: by 2002:a02:6051:0:b0:38a:3421:f2cb with SMTP id d17-20020a026051000000b0038a3421f2cbmr3998879jaf.308.1670253723965;
        Mon, 05 Dec 2022 07:22:03 -0800 (PST)
X-Google-Smtp-Source: AA0mqf5Fn6RoG1BO70G70p7DKjgvtzDgC9bxusH3iJEQAmPrGw+cf8s+8RL38mY8uM4UGdTzS/Zg2g==
X-Received: by 2002:a02:6051:0:b0:38a:3421:f2cb with SMTP id d17-20020a026051000000b0038a3421f2cbmr3998870jaf.308.1670253723749;
        Mon, 05 Dec 2022 07:22:03 -0800 (PST)
Received: from redhat.com ([38.15.36.239])
        by smtp.gmail.com with ESMTPSA id c4-20020a023304000000b003752e5b3c23sm5822470jae.20.2022.12.05.07.22.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 05 Dec 2022 07:22:03 -0800 (PST)
Date:   Mon, 5 Dec 2022 08:22:00 -0700
From:   Alex Williamson <alex.williamson@redhat.com>
To:     Yishai Hadas <yishaih@nvidia.com>
Cc:     <jgg@nvidia.com>, <kvm@vger.kernel.org>, <kevin.tian@intel.com>,
        <joao.m.martins@oracle.com>, <leonro@nvidia.com>,
        <shayd@nvidia.com>, <maorg@nvidia.com>, <avihaih@nvidia.com>,
        <cohuck@redhat.com>, <shameerali.kolothum.thodi@huawei.com>,
        saeedm@nvidia.com
Subject: Re: [PATCH V3 vfio 01/14] net/mlx5: Introduce ifc bits for pre_copy
Message-ID: <20221205082200.6667589c.alex.williamson@redhat.com>
In-Reply-To: <20221205144838.245287-2-yishaih@nvidia.com>
References: <20221205144838.245287-1-yishaih@nvidia.com>
        <20221205144838.245287-2-yishaih@nvidia.com>
Organization: Red Hat
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

On Mon, 5 Dec 2022 16:48:25 +0200
Yishai Hadas <yishaih@nvidia.com> wrote:

> From: Shay Drory <shayd@nvidia.com>
> 
> Introduce ifc related stuff to enable PRE_COPY of VF during migration.
> 
> Signed-off-by: Shay Drory <shayd@nvidia.com>
> Signed-off-by: Yishai Hadas <yishaih@nvidia.com>

This will need an ack from Leon or Saeed to go through the vfio tree.
Thanks,

Alex

> ---
>  include/linux/mlx5/mlx5_ifc.h | 14 +++++++++++---
>  1 file changed, 11 insertions(+), 3 deletions(-)
> 
> diff --git a/include/linux/mlx5/mlx5_ifc.h b/include/linux/mlx5/mlx5_ifc.h
> index 5a4e914e2a6f..230a96626a5f 100644
> --- a/include/linux/mlx5/mlx5_ifc.h
> +++ b/include/linux/mlx5/mlx5_ifc.h
> @@ -1882,7 +1882,12 @@ struct mlx5_ifc_cmd_hca_cap_2_bits {
>  	u8	   max_reformat_remove_size[0x8];
>  	u8	   max_reformat_remove_offset[0x8];
>  
> -	u8	   reserved_at_c0[0xe0];
> +	u8	   reserved_at_c0[0x8];
> +	u8	   migration_multi_load[0x1];
> +	u8	   migration_tracking_state[0x1];
> +	u8	   reserved_at_ca[0x16];
> +
> +	u8	   reserved_at_e0[0xc0];
>  
>  	u8	   reserved_at_1a0[0xb];
>  	u8	   log_min_mkey_entity_size[0x5];
> @@ -11918,7 +11923,8 @@ struct mlx5_ifc_query_vhca_migration_state_in_bits {
>  	u8         reserved_at_20[0x10];
>  	u8         op_mod[0x10];
>  
> -	u8         reserved_at_40[0x10];
> +	u8         incremental[0x1];
> +	u8         reserved_at_41[0xf];
>  	u8         vhca_id[0x10];
>  
>  	u8         reserved_at_60[0x20];
> @@ -11944,7 +11950,9 @@ struct mlx5_ifc_save_vhca_state_in_bits {
>  	u8         reserved_at_20[0x10];
>  	u8         op_mod[0x10];
>  
> -	u8         reserved_at_40[0x10];
> +	u8         incremental[0x1];
> +	u8         set_track[0x1];
> +	u8         reserved_at_42[0xe];
>  	u8         vhca_id[0x10];
>  
>  	u8         reserved_at_60[0x20];

