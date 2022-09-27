Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CBA125EC8D7
	for <lists+kvm@lfdr.de>; Tue, 27 Sep 2022 18:01:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232081AbiI0QBG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 27 Sep 2022 12:01:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39484 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230445AbiI0QBE (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 27 Sep 2022 12:01:04 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 360EAF3136
        for <kvm@vger.kernel.org>; Tue, 27 Sep 2022 09:01:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1664294461;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=OBR4xNQEpKsKlU6oEB+jHo2f2aRGU/mGD6dagUtmSrA=;
        b=TIrbpndXAtuU5L2DNxRt0ePPmV6iakKU212b//vPoYvggxJ1FZasGhHFlg7naBlA+JVgRq
        BQrEVZd/fuW3oS0rZzGEhRaz2hiYwSocZUvL8mZ6DQKlAu+R1+JiCiWybym7cbIwxYqrPW
        68uUF2sbDNsouhzMJ4aD6TQUCVPM+9Q=
Received: from mail-qv1-f71.google.com (mail-qv1-f71.google.com
 [209.85.219.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-423-yRT78c9IMZSazRtoLip1cQ-1; Tue, 27 Sep 2022 12:00:59 -0400
X-MC-Unique: yRT78c9IMZSazRtoLip1cQ-1
Received: by mail-qv1-f71.google.com with SMTP id oj15-20020a056214440f00b004ac6db57cacso6087357qvb.17
        for <kvm@vger.kernel.org>; Tue, 27 Sep 2022 09:00:59 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date;
        bh=OBR4xNQEpKsKlU6oEB+jHo2f2aRGU/mGD6dagUtmSrA=;
        b=3hbAx3AXm2ifqQySDSQe4rmTYVjpvIucnkWeKljp+gVfi+xge7CzPaOEtYaMyRtWb9
         ecABEsdJrlcPmxPgjHp0csGTNbQ0GqxOVFSU4f2LjSnmzZHkd4O1IfMyARBzyvWnPqY+
         4w4rro7NxuFNYjjEbcNtCWN7Aa0bg5tj8kK4+XLbO0OjRcDPFa6soS2LTGms1VKYS26+
         tunlWu6NJpouoJAfGKy3njXgWEWcKKBCQXwdnLIAgGrw2YfNuszv8JYGH2z+ZhV5374W
         v+pfnVCH+0f02YqhcWAVsIILAtEdRbZLanqvl+AFdz2AWDT++ua/bPuGeq87gaDeKdA7
         ZvXw==
X-Gm-Message-State: ACrzQf01JnNcGUPW6LNKoTqU0uNltgAa0O4IYgHM0MwXAaXk4RCsa712
        8bHaNv6SG0j+GCFThq/6GJ5aMEN0SbVTjYHvS1gsAL3bYkVezTsgtxW05qRG8s5/7UMbunXbuM4
        n2etulmvVbJeb
X-Received: by 2002:a37:691:0:b0:6cf:532a:6f4c with SMTP id 139-20020a370691000000b006cf532a6f4cmr18552035qkg.89.1664294459073;
        Tue, 27 Sep 2022 09:00:59 -0700 (PDT)
X-Google-Smtp-Source: AMsMyM4vaVTukQ9Ej/20po7f9wxzUqLefkMYhEbvAtlgYl1WVQCZHpehWvF+WtqAEIp2CmBVHJb3hg==
X-Received: by 2002:a37:691:0:b0:6cf:532a:6f4c with SMTP id 139-20020a370691000000b006cf532a6f4cmr18552006qkg.89.1664294458793;
        Tue, 27 Sep 2022 09:00:58 -0700 (PDT)
Received: from x1n (bras-base-aurron9127w-grc-46-70-31-27-79.dsl.bell.ca. [70.31.27.79])
        by smtp.gmail.com with ESMTPSA id f1-20020a05620a280100b006b95b0a714esm1295626qkp.17.2022.09.27.09.00.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 27 Sep 2022 09:00:58 -0700 (PDT)
Date:   Tue, 27 Sep 2022 12:00:55 -0400
From:   Peter Xu <peterx@redhat.com>
To:     Gavin Shan <gshan@redhat.com>
Cc:     kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org,
        catalin.marinas@arm.com, bgardon@google.com, shuah@kernel.org,
        andrew.jones@linux.dev, will@kernel.org, dmatlack@google.com,
        maz@kernel.org, pbonzini@redhat.com, zhenyzha@redhat.com,
        shan.gavin@gmail.com, james.morse@arm.com, suzuki.poulose@arm.com,
        alexandru.elisei@arm.com, oliver.upton@linux.dev
Subject: Re: [PATCH v4 2/6] KVM: x86: Move declaration of
 kvm_cpu_dirty_log_size() to kvm_dirty_ring.h
Message-ID: <YzMeN6ZFjyoT+Rz2@x1n>
References: <20220927005439.21130-1-gshan@redhat.com>
 <20220927005439.21130-3-gshan@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20220927005439.21130-3-gshan@redhat.com>
X-Spam-Status: No, score=-2.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Sep 27, 2022 at 08:54:35AM +0800, Gavin Shan wrote:
> Not all architectures like ARM64 need to override the function. Move
> its declaration to kvm_dirty_ring.h to avoid the following compiling
> warning on ARM64 when the feature is enabled.
> 
>   arch/arm64/kvm/../../../virt/kvm/dirty_ring.c:14:12:        \
>   warning: no previous prototype for 'kvm_cpu_dirty_log_size' \
>   [-Wmissing-prototypes]                                      \
>   int __weak kvm_cpu_dirty_log_size(void)
> 
> Reported-by: kernel test robot <lkp@intel.com>
> Signed-off-by: Gavin Shan <gshan@redhat.com>

Reviewed-by: Peter Xu <peterx@redhat.com>

-- 
Peter Xu

