Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 902705EC8B5
	for <lists+kvm@lfdr.de>; Tue, 27 Sep 2022 17:55:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232415AbiI0PzX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 27 Sep 2022 11:55:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47182 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232364AbiI0Pyt (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 27 Sep 2022 11:54:49 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3E9EE1BEB9
        for <kvm@vger.kernel.org>; Tue, 27 Sep 2022 08:54:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1664294079;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=Ig6ff3s+qaz6qZ/eoAJt38MgXkJ4N1+o+oKgI8RLbn8=;
        b=euHfhu+Dneap86UW+R0mT2hzM2wYY0QZNTfsPuEK1l1JtznoJgA0GX8bSVc5BVgjvZaDzY
        PoWG3rI3QptVoycgkUO7a5HGm7zeFRhF1gPeBO0Pg8TztNOPBytaAVJW3MaM9WMmLo1nNJ
        /DChPWWdz0sjLEhnkzNRtiqmkw4Z9B4=
Received: from mail-qk1-f198.google.com (mail-qk1-f198.google.com
 [209.85.222.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-151-iw-i2DGYN6OSLH4FOzd9lg-1; Tue, 27 Sep 2022 11:54:38 -0400
X-MC-Unique: iw-i2DGYN6OSLH4FOzd9lg-1
Received: by mail-qk1-f198.google.com with SMTP id o13-20020a05620a2a0d00b006cf9085682dso5802032qkp.7
        for <kvm@vger.kernel.org>; Tue, 27 Sep 2022 08:54:37 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date;
        bh=Ig6ff3s+qaz6qZ/eoAJt38MgXkJ4N1+o+oKgI8RLbn8=;
        b=px1kmF3khfdzY9FrKCKY9QUwjygE2wze5fraRIZxJ4YnhS2UFxv0KTR1csauHumkE7
         qdVD/sc70Zj1+aeQHf+ikhCkGi3VecqPuDWEu4cIuF2khrpjiUoXjlaAAr5hNOBTI5ud
         iQO6l+XS/5qZO8g8yQFMLtOvyOUM7eMaOckVvQj6mWkbSGEd99V7rrgln2hb3ZHAFsZd
         f+KrnZIhU6oLAjyiYLmspViMmkTz9RQU6FTok9wfjFAnUhQgYp6p9MLDjSqzfPWlR1tT
         x7Bf/rrMPzf3La05k/3qD7/tuEn1FYH2bZ1GWj1kKgIbFvLK57bJIOfC3mcfiHBA0113
         AXBA==
X-Gm-Message-State: ACrzQf0sN7UnW0IXCWjVOcRRSqYtgTLgEFnWiUJ+XNZrv70jxMa8DNzB
        uiFcuss7XJQ6rQi1u3sfGpRIt+fs+7Thd8S+Ji93+wIdSgbM/YiaiOGRv8Y3dazwuJbK0fJVuNG
        fwVwNlzNoAxGL
X-Received: by 2002:ae9:ed86:0:b0:6cd:f5da:f133 with SMTP id c128-20020ae9ed86000000b006cdf5daf133mr18620921qkg.782.1664294077532;
        Tue, 27 Sep 2022 08:54:37 -0700 (PDT)
X-Google-Smtp-Source: AMsMyM4xjk4/ceelvrxyUiJwWpr9g1wDD/8LYUgh2WXS4MZCJiGO8aqkBSJFdDz61sp/yQclkvpxug==
X-Received: by 2002:ae9:ed86:0:b0:6cd:f5da:f133 with SMTP id c128-20020ae9ed86000000b006cdf5daf133mr18620900qkg.782.1664294077304;
        Tue, 27 Sep 2022 08:54:37 -0700 (PDT)
Received: from x1n (bras-base-aurron9127w-grc-46-70-31-27-79.dsl.bell.ca. [70.31.27.79])
        by smtp.gmail.com with ESMTPSA id j4-20020a05620a410400b006cf7ecee246sm1226956qko.9.2022.09.27.08.54.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 27 Sep 2022 08:54:36 -0700 (PDT)
Date:   Tue, 27 Sep 2022 11:54:32 -0400
From:   Peter Xu <peterx@redhat.com>
To:     Marc Zyngier <maz@kernel.org>
Cc:     kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org,
        catalin.marinas@arm.com, bgardon@google.com, shuah@kernel.org,
        andrew.jones@linux.dev, will@kernel.org, dmatlack@google.com,
        pbonzini@redhat.com, zhenyzha@redhat.com, shan.gavin@gmail.com,
        gshan@redhat.com, James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Oliver Upton <oliver.upton@linux.dev>
Subject: Re: [PATCH v2 0/6] KVM: Fix dirty-ring ordering on weakly ordered
 architectures
Message-ID: <YzMcuGnQGvpMy1km@x1n>
References: <20220926145120.27974-1-maz@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20220926145120.27974-1-maz@kernel.org>
X-Spam-Status: No, score=-2.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Sep 26, 2022 at 03:51:14PM +0100, Marc Zyngier wrote:
> [Same distribution list as Gavin's dirty-ring on arm64 series]
> 
> This is an update on the initial series posted as [0].
> 
> As Gavin started posting patches enabling the dirty-ring infrastructure
> on arm64 [1], it quickly became apparent that the API was never intended
> to work on relaxed memory ordering architectures (owing to its x86
> origins).
> 
> This series tries to retrofit some ordering into the existing API by:
> 
> - relying on acquire/release semantics which are the default on x86,
>   but need to be explicit on arm64
> 
> - adding a new capability that indicate which flavor is supported, either
>   with explicit ordering (arm64) or both implicit and explicit (x86),
>   as suggested by Paolo at KVM Forum
> 
> - documenting the requirements for this new capability on weakly ordered
>   architectures
> 
> - updating the selftests to do the right thing
> 
> Ideally, this series should be a prefix of Gavin's, plus a small change
> to his series:
> 
> diff --git a/arch/arm64/kvm/Kconfig b/arch/arm64/kvm/Kconfig
> index 0309b2d0f2da..7785379c5048 100644
> --- a/arch/arm64/kvm/Kconfig
> +++ b/arch/arm64/kvm/Kconfig
> @@ -32,7 +32,7 @@ menuconfig KVM
>  	select KVM_VFIO
>  	select HAVE_KVM_EVENTFD
>  	select HAVE_KVM_IRQFD
> -	select HAVE_KVM_DIRTY_RING
> +	select HAVE_KVM_DIRTY_RING_ACQ_REL
>  	select HAVE_KVM_MSI
>  	select HAVE_KVM_IRQCHIP
>  	select HAVE_KVM_IRQ_ROUTING
> 
> This has been very lightly tested on an arm64 box with Gavin's v3 [2] series.
> 
> * From v1:
>   - Repainted the config symbols and new capability so that their
>     naming is more acceptable and causes less churn
>   - Fixed a couple of blunders as pointed out by Peter and Paolo
>   - Updated the documentation
> 
> [0] https://lore.kernel.org/r/20220922170133.2617189-1-maz@kernel.org
> [1] https://lore.kernel.org/lkml/YyiV%2Fl7O23aw5aaO@xz-m1.local/T/
> [2] https://lore.kernel.org/r/20220922003214.276736-1-gshan@redhat.com
> 
> Marc Zyngier (6):
>   KVM: Use acquire/release semantics when accessing dirty ring GFN state
>   KVM: Add KVM_CAP_DIRTY_LOG_RING_ACQ_REL capability and config option
>   KVM: x86: Select CONFIG_HAVE_KVM_DIRTY_RING_ACQ_REL
>   KVM: Document weakly ordered architecture requirements for dirty ring
>   KVM: selftests: dirty-log: Upgrade flag accesses to acquire/release
>     semantics
>   KVM: selftests: dirty-log: Use KVM_CAP_DIRTY_LOG_RING_ACQ_REL if
>     available

Reviewed-by: Peter Xu <peterx@redhat.com>

Thanks!

-- 
Peter Xu

