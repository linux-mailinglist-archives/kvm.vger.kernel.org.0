Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9F65C6B136A
	for <lists+kvm@lfdr.de>; Wed,  8 Mar 2023 21:57:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230244AbjCHU5b (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 8 Mar 2023 15:57:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59236 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229814AbjCHU52 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 8 Mar 2023 15:57:28 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 53EB812BE1
        for <kvm@vger.kernel.org>; Wed,  8 Mar 2023 12:56:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1678309002;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=oVGZ/25JKdgQAbVvX7AHjP4Caly5y5IN8BvHz0QlaiA=;
        b=Gd2MOJgsGSkTC6eLAExH3mn5Pkd6ggNFGtxse60JZYIJSHWKhp4sEwNMsKov1cxnHiYofd
        hsoCGulJ96msOdreEvyptSryDPBY1+ylfN1Ov0GangP2A5ga7wfceItXMBtYF53s+PMZYH
        XVhGQCBIXpEUg9L91yLenYyjnB9WQMk=
Received: from mail-io1-f72.google.com (mail-io1-f72.google.com
 [209.85.166.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-479-Fw0oFK63PvK7w6XT6rB--A-1; Wed, 08 Mar 2023 15:56:41 -0500
X-MC-Unique: Fw0oFK63PvK7w6XT6rB--A-1
Received: by mail-io1-f72.google.com with SMTP id g21-20020a6be615000000b0074cb292f57dso9229988ioh.17
        for <kvm@vger.kernel.org>; Wed, 08 Mar 2023 12:56:41 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678309000;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=oVGZ/25JKdgQAbVvX7AHjP4Caly5y5IN8BvHz0QlaiA=;
        b=AmmkOw7eNwggksYyMGZDCMXdMjDx27Lyfm4R8SMMGrM7DxUMSI4nPeaMx0kjA8A/EF
         AuC+28PYfcIr3RQfjkZuJJJs+DrEndXf+K7T690Kqd9TwlN5E9DkYwvMjzblMJeztgV8
         oVbPIUT0Rt3qwiC1r8izQ10u/Y1UCNg/J7AzyMEEAJxk1NL87UyZmXkpLmTdD6xADhG8
         g4uyD/9an9KPx6Aeul8a7zQSaYN3wcPGndmbqk5x2MuNkiXfQT971pDpGJMMZVy9Ye/4
         TSzA8Rt69Ko6GUvMjgwunDHO34WIvwYegt9VP5YqrpkC6RlZ/z5/osT4SRK5yenSpze5
         CukA==
X-Gm-Message-State: AO0yUKX3yLZAuY8O99K20OTuk+NyIXGg7V53T70AwpC7UBI6ygumX7ki
        TcHKQhPmLBlSx+TcBu2wS7hMDE2A8PJwvcsgjmeG0+rVtUBDHWLmDYqF1P5kaNHVffT84d7HvtN
        pgwx887TJPmDz
X-Received: by 2002:a05:6e02:188f:b0:317:f9b4:c2e6 with SMTP id o15-20020a056e02188f00b00317f9b4c2e6mr18250406ilu.18.1678309000649;
        Wed, 08 Mar 2023 12:56:40 -0800 (PST)
X-Google-Smtp-Source: AK7set9Z5MibWYnh2xDpkomolSD9fO8qvmoz/WLFVZR2gUvMnUfY5AEMvKHStu7OuwW3g90NdKF//g==
X-Received: by 2002:a05:6e02:188f:b0:317:f9b4:c2e6 with SMTP id o15-20020a056e02188f00b00317f9b4c2e6mr18250393ilu.18.1678309000405;
        Wed, 08 Mar 2023 12:56:40 -0800 (PST)
Received: from redhat.com ([38.15.36.239])
        by smtp.gmail.com with ESMTPSA id v6-20020a02cba6000000b003c4f97d41d2sm5191846jap.116.2023.03.08.12.56.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 08 Mar 2023 12:56:39 -0800 (PST)
Date:   Wed, 8 Mar 2023 13:56:39 -0700
From:   Alex Williamson <alex.williamson@redhat.com>
To:     Yishai Hadas <yishaih@nvidia.com>
Cc:     <jgg@nvidia.com>, <kvm@vger.kernel.org>, <kevin.tian@intel.com>,
        <joao.m.martins@oracle.com>, <leonro@nvidia.com>,
        <maorg@nvidia.com>, <avihaih@nvidia.com>
Subject: Re: [PATCH vfio] vfio/mlx5: Fix the report of dirty_bytes upon
 pre-copy
Message-ID: <20230308135639.1378418d.alex.williamson@redhat.com>
In-Reply-To: <20230308155723.108218-1-yishaih@nvidia.com>
References: <20230308155723.108218-1-yishaih@nvidia.com>
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

On Wed, 8 Mar 2023 17:57:23 +0200
Yishai Hadas <yishaih@nvidia.com> wrote:

> Fix the report of dirty_bytes upon pre-copy to include both the existing
> data on the migration file and the device extra bytes.
> 
> This gives a better close estimation to what can be passed any more as
> part of pre-copy.
> 
> Fixes: 0dce165b1adf ("vfio/mlx5: Introduce vfio precopy ioctl implementation")
> Signed-off-by: Yishai Hadas <yishaih@nvidia.com>
> ---
>  drivers/vfio/pci/mlx5/main.c | 14 ++++----------
>  1 file changed, 4 insertions(+), 10 deletions(-)
> 
> diff --git a/drivers/vfio/pci/mlx5/main.c b/drivers/vfio/pci/mlx5/main.c
> index e897537a9e8a..d95fd382814c 100644
> --- a/drivers/vfio/pci/mlx5/main.c
> +++ b/drivers/vfio/pci/mlx5/main.c
> @@ -442,16 +442,10 @@ static long mlx5vf_precopy_ioctl(struct file *filp, unsigned int cmd,
>  	if (migf->pre_copy_initial_bytes > *pos) {
>  		info.initial_bytes = migf->pre_copy_initial_bytes - *pos;
>  	} else {
> -		buf = mlx5vf_get_data_buff_from_pos(migf, *pos, &end_of_data);
> -		if (buf) {
> -			info.dirty_bytes = buf->start_pos + buf->length - *pos;
> -		} else {
> -			if (!end_of_data) {
> -				ret = -EINVAL;
> -				goto err_migf_unlock;
> -			}
> -			info.dirty_bytes = inc_length;
> -		}
> +		info.dirty_bytes = migf->max_pos - *pos;
> +		if (!info.dirty_bytes)
> +			end_of_data = true;
> +		info.dirty_bytes += inc_length;
>  	}
>  
>  	if (!end_of_data || !inc_length) {

This is intended for v6.3, correct?  Thanks,

Alex

