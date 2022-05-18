Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E9E2352C1D8
	for <lists+kvm@lfdr.de>; Wed, 18 May 2022 20:09:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241147AbiERRvV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 18 May 2022 13:51:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59658 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241094AbiERRvR (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 18 May 2022 13:51:17 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id EF9D622B22
        for <kvm@vger.kernel.org>; Wed, 18 May 2022 10:51:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1652896274;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=49hW2Lgkit3FFJ0TGEQAkc/9Izoyz7QsMkLjDXmi4AY=;
        b=fzpt5aMYtzcQUknWNpFa6KdePQOcD7ZS5BqxJzhnhXL7ywqj9ZDUECE/qWLwVllipcz1yK
        e8NJNFnN3FEOXyGDtZloOKf1QFXogkeHDKZCDULswOlT9adcQKvEJ3VIH9aik7v6myq4t7
        hNZWAXNyvEWzTwbhiCjY7pgv8z63Rak=
Received: from mail-io1-f70.google.com (mail-io1-f70.google.com
 [209.85.166.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-556-hBTzrlT8PcuIqId5LtJ2FQ-1; Wed, 18 May 2022 13:51:13 -0400
X-MC-Unique: hBTzrlT8PcuIqId5LtJ2FQ-1
Received: by mail-io1-f70.google.com with SMTP id t1-20020a056602140100b0065393cc1dc3so692926iov.5
        for <kvm@vger.kernel.org>; Wed, 18 May 2022 10:51:13 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=49hW2Lgkit3FFJ0TGEQAkc/9Izoyz7QsMkLjDXmi4AY=;
        b=EsK0GPoqGKtcZldMyOjmSYthByUpJRwvrJSTYAPQVm8grABQKcgyTdq1bUJtisFCBS
         W51AHMzUNXQ/iQNkQWaLCDNNM/x6g2w95Lc0RjhaeA6mVnnc8Jf1v4fUhKsnI4VoWOBK
         1NG+yVQHCHKlULqofsFFH7v1/SiO1WOYqMZSZx5l3drVJkJW5J8PuV5Vj3763ScPHTbf
         shHNPukqsklVPmssOvGytsasyuHMJ/l1ol4/ie937oumAhoLhorkBQJFMU0hcb/Ii4bG
         Gwo8oXVrymR/ex8FzTGnPhejl0JNpL7ClzRRsLFzbHh5qCdE3UPLQhCmf6YKmgB8Yxfj
         urHg==
X-Gm-Message-State: AOAM532UXdSN01hwJ3d3f7MBeX+lhtqzDQIMu+Cu82toTM8DR9vPsxyQ
        Qudg20njsz4cccfQnYmKaGVIZXJADNPbCs2elyX7drZzXNeMTWoIn7ZtRnO/huxDkutATQoEqao
        32QnlPA7U5x0W
X-Received: by 2002:a05:6638:dc7:b0:32b:a483:16b8 with SMTP id m7-20020a0566380dc700b0032ba48316b8mr423071jaj.66.1652896272821;
        Wed, 18 May 2022 10:51:12 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJy4yot0L8H1GFnxd+jBFDsw6Yt7jnmhEuw0qSATO4iI9tLeFnhC04lgVq81N4r1GIYOBFpfHg==
X-Received: by 2002:a05:6638:dc7:b0:32b:a483:16b8 with SMTP id m7-20020a0566380dc700b0032ba48316b8mr423057jaj.66.1652896272606;
        Wed, 18 May 2022 10:51:12 -0700 (PDT)
Received: from redhat.com ([38.15.36.239])
        by smtp.gmail.com with ESMTPSA id g15-20020a92dd8f000000b002cf5aae6645sm727757iln.2.2022.05.18.10.51.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 18 May 2022 10:51:12 -0700 (PDT)
Date:   Wed, 18 May 2022 11:51:10 -0600
From:   Alex Williamson <alex.williamson@redhat.com>
To:     Wan Jiabing <wanjiabing@vivo.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, Yi Liu <yi.l.liu@intel.com>,
        Kevin Tian <kevin.tian@intel.com>,
        Jason Gunthorpe <jgg@ziepe.ca>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] kvm/vfio: Fix potential deadlock problem in vfio
Message-ID: <20220518115110.23a0e929.alex.williamson@redhat.com>
In-Reply-To: <20220517023441.4258-1-wanjiabing@vivo.com>
References: <20220517023441.4258-1-wanjiabing@vivo.com>
Organization: Red Hat
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 17 May 2022 10:34:41 +0800
Wan Jiabing <wanjiabing@vivo.com> wrote:

> Fix following coccicheck warning:
> ./virt/kvm/vfio.c:258:1-7: preceding lock on line 236
> 
> If kvm_vfio_file_iommu_group() failed, code would goto err_fdput with
> mutex_lock acquired and then return ret. It might cause potential
> deadlock. Move mutex_unlock bellow err_fdput tag to fix it. 
> 
> Fixes: d55d9e7a45721 ("kvm/vfio: Store the struct file in the kvm_vfio_group")
> Signed-off-by: Wan Jiabing <wanjiabing@vivo.com>
> ---
>  virt/kvm/vfio.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/virt/kvm/vfio.c b/virt/kvm/vfio.c
> index 8f9f7fffb96a..ce1b01d02c51 100644
> --- a/virt/kvm/vfio.c
> +++ b/virt/kvm/vfio.c
> @@ -252,8 +252,8 @@ static int kvm_vfio_group_set_spapr_tce(struct kvm_device *dev,
>  		break;
>  	}
>  
> -	mutex_unlock(&kv->lock);
>  err_fdput:
> +	mutex_unlock(&kv->lock);
>  	fdput(f);
>  	return ret;
>  }

Applied to vfio next branch for v5.19.  Thanks!

Alex

