Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EDFE2518D4A
	for <lists+kvm@lfdr.de>; Tue,  3 May 2022 21:40:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241973AbiECTo2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 3 May 2022 15:44:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39900 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236024AbiECTo0 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 3 May 2022 15:44:26 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 72FC71A051
        for <kvm@vger.kernel.org>; Tue,  3 May 2022 12:40:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1651606852;
        h=from:from:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=qyazgKmNz6MvewagZP0q+tDesycMY+RcOXxoB9vbg74=;
        b=aN6vzCgpEx6x/kWX3eq3hdaxDIq9v4azfSN0FzXf9QxTzKnndNAC6a+xWBhQeEqkTPnKiF
        JD0z/MrXNdc70tUFodMBtx5fEKyx+QhX/pK0GlZ3NCaV0k2iuhuByfSoNttpwktv7K8rB2
        KjmSJD+xMTIy4J5+Qk6/FhS9fCFESis=
Received: from mail-qk1-f197.google.com (mail-qk1-f197.google.com
 [209.85.222.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-587-gftBROQzONSgS8WuwEhu2g-1; Tue, 03 May 2022 15:40:51 -0400
X-MC-Unique: gftBROQzONSgS8WuwEhu2g-1
Received: by mail-qk1-f197.google.com with SMTP id bj2-20020a05620a190200b005084968bb24so13089961qkb.23
        for <kvm@vger.kernel.org>; Tue, 03 May 2022 12:40:51 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:reply-to
         :subject:content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=qyazgKmNz6MvewagZP0q+tDesycMY+RcOXxoB9vbg74=;
        b=BvhUdauxUy+yFa1Kf0Vuhwy4cGAbIEaDWs52nlHJN8XwUJPapqN38ZRTKnb/1Rl513
         4+Ft/3EBNftoR+V5sxjsvxoD6x4j7pBqV3QsNJQ9qiUan5Q5n6WNXJ6hlQyqUaE+obVs
         w2mmNZcU4GJOnSSzOZiefE313w6T4yLMg5Aoo9kSIth6jc55G7BmYkSUz/lvi/mOfOIr
         HjU7814UR1Sh6z0vHTHYZWSWd4NMGuTmkQuVVkWm+XIDzWuwvxwwGFPqnVz8xp/ZqHww
         +LWKSAnWLn0dw7+QTHuQqJiyba/8blsHYm8FbN3rP9NgPN4FcxIjy8qfXHxdc8xFn08r
         sNCQ==
X-Gm-Message-State: AOAM5316pv0lmwPPI8+UfHjA/roki0A9A+BRMNXn+mG0dfMJi1aJmMCB
        hCPiRFw1bzA1BjtQecJ+MFo+7FZJCPY85NIFxYyvQ5YlMfVJNktwQpWb4bPEU7FLG7irQpSqddr
        QRavSuju8UGNV
X-Received: by 2002:ac8:7f0a:0:b0:2f1:f60d:2b39 with SMTP id f10-20020ac87f0a000000b002f1f60d2b39mr16038532qtk.470.1651606850795;
        Tue, 03 May 2022 12:40:50 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyUzjOo6cdaooCBJoI2l9Mjw62a4uKABfTpoWuDdloGnEHRUre3/Lrt0n+yxqvJ2c59h8moIA==
X-Received: by 2002:ac8:7f0a:0:b0:2f1:f60d:2b39 with SMTP id f10-20020ac87f0a000000b002f1f60d2b39mr16038516qtk.470.1651606850552;
        Tue, 03 May 2022 12:40:50 -0700 (PDT)
Received: from ?IPV6:2a01:e0a:59e:9d80:527b:9dff:feef:3874? ([2a01:e0a:59e:9d80:527b:9dff:feef:3874])
        by smtp.gmail.com with ESMTPSA id s15-20020a05620a030f00b0069fc13ce254sm6152999qkm.133.2022.05.03.12.40.47
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 03 May 2022 12:40:49 -0700 (PDT)
Message-ID: <7b5f03d4-1db1-c2c4-c7d6-9e6be3a427e2@redhat.com>
Date:   Tue, 3 May 2022 21:40:44 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.0
Reply-To: eric.auger@redhat.com
Subject: Re: [PATCH v2 4/4] KVM: arm64: vgic: Undo work in failed ITS restores
Content-Language: en-US
To:     Ricardo Koller <ricarkol@google.com>, kvm@vger.kernel.org,
        kvmarm@lists.cs.columbia.edu
Cc:     pbonzini@redhat.com, maz@kernel.org, andre.przywara@arm.com,
        drjones@redhat.com, alexandru.elisei@arm.com, oupton@google.com,
        reijiw@google.com, pshier@google.com
References: <20220427184814.2204513-1-ricarkol@google.com>
 <20220427184814.2204513-5-ricarkol@google.com>
From:   Eric Auger <eric.auger@redhat.com>
In-Reply-To: <20220427184814.2204513-5-ricarkol@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-6.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Ricardo,

On 4/27/22 20:48, Ricardo Koller wrote:
> Failed ITS restores should clean up all state restored until the
> failure. There is some cleanup already present when failing to restore
> some tables, but it's not complete. Add the missing cleanup.
>
> Note that this changes the behavior in case of a failed restore of the
> device tables.
I assume this is acceptable
>
> 	restore ioctl:
> 	1. restore collection tables
> 	2. restore device tables
>
> With this commit, failures in 2. clean up everything created so far,
> including state created by 1.
>
> Signed-off-by: Ricardo Koller <ricarkol@google.com>
> ---
>  arch/arm64/kvm/vgic/vgic-its.c | 15 +++++++++++++--
>  1 file changed, 13 insertions(+), 2 deletions(-)
>
> diff --git a/arch/arm64/kvm/vgic/vgic-its.c b/arch/arm64/kvm/vgic/vgic-its.c
> index 86c26aaa8275..c35534d7393a 100644
> --- a/arch/arm64/kvm/vgic/vgic-its.c
> +++ b/arch/arm64/kvm/vgic/vgic-its.c
> @@ -2222,8 +2222,10 @@ static int vgic_its_restore_ite(struct vgic_its *its, u32 event_id,
>  		vcpu = kvm_get_vcpu(kvm, collection->target_addr);
>  
>  	irq = vgic_add_lpi(kvm, lpi_id, vcpu);
> -	if (IS_ERR(irq))
> +	if (IS_ERR(irq)) {
> +		its_free_ite(kvm, ite);
>  		return PTR_ERR(irq);
> +	}
>  	ite->irq = irq;
>  
>  	return offset;
> @@ -2491,6 +2493,9 @@ static int vgic_its_restore_device_tables(struct vgic_its *its)
>  	if (ret > 0)
>  		ret = 0;
>  
> +	if (ret < 0)
> +		vgic_its_free_device_list(its->dev->kvm, its);
> +
>  	return ret;
>  }
>  
> @@ -2617,6 +2622,9 @@ static int vgic_its_restore_collection_table(struct vgic_its *its)
>  		read += cte_esz;
>  	}
>  
> +	if (ret < 0)
> +		vgic_its_free_collection_list(its->dev->kvm, its);
> +
>  	return ret;
>  }
>  
> @@ -2648,7 +2656,10 @@ static int vgic_its_restore_tables_v0(struct vgic_its *its)
>  	if (ret)
>  		return ret;
>  
> -	return vgic_its_restore_device_tables(its);
> +	ret = vgic_its_restore_device_tables(its);
> +	if (ret)
> +		vgic_its_free_collection_list(its->dev->kvm, its);
> +	return ret;
>  }
>  
>  static int vgic_its_commit_v0(struct vgic_its *its)

Looks good to me.
Reviewed-by: Eric Auger <eric.auger@redhat.com>


Eric



