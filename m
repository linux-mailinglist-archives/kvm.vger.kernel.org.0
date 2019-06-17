Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 33545485D1
	for <lists+kvm@lfdr.de>; Mon, 17 Jun 2019 16:43:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728368AbfFQOnP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 17 Jun 2019 10:43:15 -0400
Received: from mail-qt1-f195.google.com ([209.85.160.195]:33103 "EHLO
        mail-qt1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726614AbfFQOnP (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 17 Jun 2019 10:43:15 -0400
Received: by mail-qt1-f195.google.com with SMTP id x2so11017735qtr.0
        for <kvm@vger.kernel.org>; Mon, 17 Jun 2019 07:43:15 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=lxS/dzQw4wkh+Z+PAMdqgR2Kw5xVW/ETkqpwQQdohjY=;
        b=t8gDnEBAcc2CD7r5eqm3KycYQL/Qw4M2VU8sQYR6PKMMQn95uWh7enbObL1kWQQlRd
         nmOiFivVejPGqAjHt7A9y8eRbdlF9/QkcWHdr/UOQ44O9KRT2oNFL2y/zQpH2OsYivvP
         YOFkUz0L2vjtB0ESvoZOiXneBQaTGbFKEvPQff7gNRNkwp+HJ2lh0BJu994NRASXTsK2
         GofBfWmVujNWrdzSIRg/YP303FXmgzb0X+V/qy8afeOydSzNT7E1gTYr5ydsiU2NM94n
         jcA46OLmM1MWrqUNCOn3azDima4QqMse2WNbYSa+9+/ZETRDM8CXewSGqR+GoZabTvNt
         dBOQ==
X-Gm-Message-State: APjAAAVKNkZWp9W+Jy/rwVfYiigQWUyifY1s5v/rwECMASWvAHZxgzJN
        MfUTRrzSOKZ1x2W+HW9pvHaLeA==
X-Google-Smtp-Source: APXvYqwavvGjRNDaa71vDWp/7KVZgO3Ghhc2s0zA1b8b++lVdLmzk98FDf0R90PixvOg24leSYkxow==
X-Received: by 2002:a0c:b5dd:: with SMTP id o29mr21771848qvf.85.1560782594646;
        Mon, 17 Jun 2019 07:43:14 -0700 (PDT)
Received: from redhat.com (pool-100-0-197-103.bstnma.fios.verizon.net. [100.0.197.103])
        by smtp.gmail.com with ESMTPSA id s44sm8410210qtc.8.2019.06.17.07.43.13
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Mon, 17 Jun 2019 07:43:13 -0700 (PDT)
Date:   Mon, 17 Jun 2019 10:43:12 -0400
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Jason Wang <jasowang@redhat.com>
Cc:     kvm@vger.kernel.org, virtualization@lists.linux-foundation.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        huhai@kylinos.cn
Subject: Re: [PATCH net-next] vhost_net: disable zerocopy by default
Message-ID: <20190617104301-mutt-send-email-mst@kernel.org>
References: <20190617092054.12299-1-jasowang@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190617092054.12299-1-jasowang@redhat.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Jun 17, 2019 at 05:20:54AM -0400, Jason Wang wrote:
> Vhost_net was known to suffer from HOL[1] issues which is not easy to
> fix. Several downstream disable the feature by default. What's more,
> the datapath was split and datacopy path got the support of batching
> and XDP support recently which makes it faster than zerocopy part for
> small packets transmission.
> 
> It looks to me that disable zerocopy by default is more
> appropriate. It cold be enabled by default again in the future if we
> fix the above issues.
> 
> [1] https://patchwork.kernel.org/patch/3787671/
> 
> Signed-off-by: Jason Wang <jasowang@redhat.com>


Acked-by: Michael S. Tsirkin <mst@redhat.com>

> ---
>  drivers/vhost/net.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/vhost/net.c b/drivers/vhost/net.c
> index 2d9df786a9d3..21e0805e5e60 100644
> --- a/drivers/vhost/net.c
> +++ b/drivers/vhost/net.c
> @@ -36,7 +36,7 @@
>  
>  #include "vhost.h"
>  
> -static int experimental_zcopytx = 1;
> +static int experimental_zcopytx = 0;
>  module_param(experimental_zcopytx, int, 0444);
>  MODULE_PARM_DESC(experimental_zcopytx, "Enable Zero Copy TX;"
>  		                       " 1 -Enable; 0 - Disable");
> -- 
> 2.18.1
