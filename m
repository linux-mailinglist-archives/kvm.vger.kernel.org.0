Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 65ED0694DB5
	for <lists+kvm@lfdr.de>; Mon, 13 Feb 2023 18:08:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230282AbjBMRIR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 13 Feb 2023 12:08:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59070 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229802AbjBMRIQ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 13 Feb 2023 12:08:16 -0500
Received: from mail-pl1-x635.google.com (mail-pl1-x635.google.com [IPv6:2607:f8b0:4864:20::635])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 66595270A
        for <kvm@vger.kernel.org>; Mon, 13 Feb 2023 09:08:15 -0800 (PST)
Received: by mail-pl1-x635.google.com with SMTP id e17so5297907plg.12
        for <kvm@vger.kernel.org>; Mon, 13 Feb 2023 09:08:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=tIaGUtbeO8Q7szzkbT5AZaxmbn8CnzWe0QnRDCPq2y4=;
        b=q8fPlS/mNqdp3PZY1TlJUMjzRv1Vxy6Op+nl/B8neh82/SCpGtho983BJMHEiZ2oq/
         kgHGCKjMIgdYhu716bQyh4EN4MTu7InR0nZUmdEeM+sRpth+T/B34ocx4QyiguRjycZA
         CHm1tErT+v8SgDt5sJZrOh4K7RiniauB9HXm+AIOTO2uapvtqcKFFva9fOm0+aUzEHLB
         foZ7tQASaOOlo+kS3zPfa72/BcrBK3laYNf1aNMrkAi05XPCRfdDx0nurYYygfTkXnHT
         UC77EGb4itQValxcVP0wqKCVUNo5ulzopsUEHZ7Jmm2Ow+X8tpqYkeoJtT91+GyftVFO
         rVUA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=tIaGUtbeO8Q7szzkbT5AZaxmbn8CnzWe0QnRDCPq2y4=;
        b=ywSxXwqCMoFpnPigCmL7Cs/8RH0o/JFALO6Nr1f0a1pLun4FtVSHs24M3l2xjyI/Fk
         jY3Yau//BlmU6jdHmqd3Q0N/wAQX5nwYLIymrBGJ5gTejcowYn+0+BjGd2PyfUor9YBS
         W6/NHGS22oK8B0YyG/U2PnZ3Y7TApprEhPLeQFTRnvfniM2PWXcsfmkzR8MunY3AYIRW
         0yoO/29DIGg9pYSE6GxKWD6z6PihkUF5CWLWr2fJ7Tc5p2Oev0ZLUsOPEixNjqN9t8h+
         IUG5AfgsGhOBjdur3AzDlDrIHpgBqwOsyIgPEa1x8yjWO6lNeHRHXy8L9mKwJ+e1S3a4
         3wIg==
X-Gm-Message-State: AO0yUKUV5MIxH9/0yNKvcf1Pwhqdf6Pxn9hjZKY0Sgsv90zIo4DoUzzz
        FLNafAy3Yzvta/85LwOFK4xqMw==
X-Google-Smtp-Source: AK7set9bUuPo/nw2A9uQk6PdwuO0lt/JoXEl3LcQZpislsQ0DH3OyqHIHBGc7e8U0ZkpJceMEldOFA==
X-Received: by 2002:a17:902:f816:b0:198:af4f:de0f with SMTP id ix22-20020a170902f81600b00198af4fde0fmr443754plb.15.1676308094629;
        Mon, 13 Feb 2023 09:08:14 -0800 (PST)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id m16-20020aa79010000000b005a8c0560074sm1637098pfo.129.2023.02.13.09.08.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 13 Feb 2023 09:08:14 -0800 (PST)
Date:   Mon, 13 Feb 2023 17:08:09 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Mathias Krause <minipli@grsecurity.net>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [PATCH 3/5] KVM: Shrink struct kvm_mmu_memory_cache
Message-ID: <Y+puefrgtqf430fs@google.com>
References: <20230213163351.30704-1-minipli@grsecurity.net>
 <20230213163351.30704-4-minipli@grsecurity.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230213163351.30704-4-minipli@grsecurity.net>
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Feb 13, 2023, Mathias Krause wrote:
> Move the 'capacity' member around to make use of the padding hole on 64
> bit systems instead of introducing yet another one.
> 
> This allows us to save 8 bytes per instance for 64 bit builds of which,
> e.g., x86's struct kvm_vcpu_arch has a few.
> 
> Signed-off-by: Mathias Krause <minipli@grsecurity.net>
> ---
>  include/linux/kvm_types.h | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/include/linux/kvm_types.h b/include/linux/kvm_types.h
> index 76de36e56cdf..8e4f8fa31457 100644
> --- a/include/linux/kvm_types.h
> +++ b/include/linux/kvm_types.h
> @@ -92,10 +92,10 @@ struct gfn_to_pfn_cache {
>   */
>  struct kvm_mmu_memory_cache {
>  	int nobjs;
> +	int capacity;
>  	gfp_t gfp_zero;
>  	gfp_t gfp_custom;
>  	struct kmem_cache *kmem_cache;
> -	int capacity;
>  	void **objects;

If we touch this, I vote to do a more aggressive cleanup and place nobjs next
to objects, e.g.

struct kvm_mmu_memory_cache {
	gfp_t gfp_zero;
	gfp_t gfp_custom;
	struct kmem_cache *kmem_cache;
	int capacity;
	int nobjs;
	void **objects;
};
