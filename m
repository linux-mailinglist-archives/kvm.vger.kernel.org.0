Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CDA027308F8
	for <lists+kvm@lfdr.de>; Wed, 14 Jun 2023 22:11:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235295AbjFNULX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 14 Jun 2023 16:11:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45412 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236282AbjFNULR (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 14 Jun 2023 16:11:17 -0400
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5812A268A
        for <kvm@vger.kernel.org>; Wed, 14 Jun 2023 13:11:13 -0700 (PDT)
Received: by mail-yb1-xb49.google.com with SMTP id 3f1490d57ef6-bd5f9d084c9so1424547276.3
        for <kvm@vger.kernel.org>; Wed, 14 Jun 2023 13:11:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1686773472; x=1689365472;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=EcvsZOKJkqQx6/PFs9sH9n3WmNQKe57hd91ilzy0zfs=;
        b=C0pYCOUjrXEmValighI9SSwooagzRgRdEtdKIvgeQuUKWhp1bHs0AoAH2Np6I/eD2M
         MRwU1qw+zNEGspqo1Cq2DqZS/yxmFAzTvcBVjAkDLZsdg10ois3bMBqWQEjqjtBKaR3d
         uwPl/uQch9m/RpQ5NNriyRW2tkS3ByHC+H6vxz5q17tlBSO/9Vyl5+NBmfpERKVtD8IH
         S1OfgglEqgkRIQXYcHMZwx/zOqCzt9t+8MLRXtEKY6bIB/3bZPFsWfPwPkWNcQcJ7/fB
         gfPhud8gmHrUD7K62wzahhEmJ4f1lOpCwG0D+XhW7uBXR3STyEoJFuZW12XUvMF4iHSM
         yX2Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686773472; x=1689365472;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=EcvsZOKJkqQx6/PFs9sH9n3WmNQKe57hd91ilzy0zfs=;
        b=COaaxnPLfpGPnZiumjGQGU1mFhiwAmiUmf+XTvmBUNB4j9VhbiWS3Ow4lXh59HDWhz
         yAQlsnC7ZgUV/yJQQ0l4gHG7tkmnKK2HKZjhojjwcox8tsMfofvzDLW1AEpejWHwDQBS
         BmQvoPnXuNG1cmFpxFax9N5ee7qmdSNM9v8UWqJYuYQyUJ/XDpPJq8niP0+AF7xqeU9V
         1tkQ853M6r9Zo36Ast0Eyfdtlb3UcGXgxK0Jfa4RmbUPOsd8XUn/+/XCsuMCq7Xq1UAv
         lb9PxtU/IjDfaI8xuEXjTeiW3hdmLYvIYW2mZUvbGmVCOU2U8zsK5XFRtrihysa/cNI2
         +chg==
X-Gm-Message-State: AC+VfDzfnCUQsIQ5de7iA2HPgtjndNMSxZk9CjaxL3LSerxzEiFKeEUB
        rINV9NxTrlpx1Vsd8gZGO9Dv2hr7Do8=
X-Google-Smtp-Source: ACHHUZ7bu8PhJlTXQ7djoUpQtUhWj2+OGlZcFl96vkCkx++1uwGk7QlpqFMzQSmVUNbJky914t7dsBBZyPg=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a25:e657:0:b0:bbb:8c13:ce26 with SMTP id
 d84-20020a25e657000000b00bbb8c13ce26mr1429852ybh.11.1686773472330; Wed, 14
 Jun 2023 13:11:12 -0700 (PDT)
Date:   Wed, 14 Jun 2023 13:11:10 -0700
In-Reply-To: <20230602161921.208564-10-amoorthy@google.com>
Mime-Version: 1.0
References: <20230602161921.208564-1-amoorthy@google.com> <20230602161921.208564-10-amoorthy@google.com>
Message-ID: <ZIoe3o7JtultNWqR@google.com>
Subject: Re: [PATCH v4 09/16] KVM: Introduce KVM_CAP_NOWAIT_ON_FAULT without implementation
From:   Sean Christopherson <seanjc@google.com>
To:     Anish Moorthy <amoorthy@google.com>
Cc:     oliver.upton@linux.dev, kvm@vger.kernel.org,
        kvmarm@lists.linux.dev, pbonzini@redhat.com, maz@kernel.org,
        robert.hoo.linux@gmail.com, jthoughton@google.com,
        bgardon@google.com, dmatlack@google.com, ricarkol@google.com,
        axelrasmussen@google.com, peterx@redhat.com, nadav.amit@gmail.com,
        isaku.yamahata@gmail.com
Content-Type: text/plain; charset="us-ascii"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Jun 02, 2023, Anish Moorthy wrote:
> diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
> index 05d6e7e3994d..2c276d4d0821 100644
> --- a/virt/kvm/kvm_main.c
> +++ b/virt/kvm/kvm_main.c
> @@ -1527,6 +1527,9 @@ static int check_memory_region_flags(const struct kvm_userspace_memory_region *m
>  	valid_flags |= KVM_MEM_READONLY;
>  #endif
>  
> +	if (kvm_vm_ioctl_check_extension(NULL, KVM_CAP_NOWAIT_ON_FAULT))

Rather than force architectures to add the extension, probably better to use a

	config HAVE_KVM_NOWAIT_ON_FAULT
	       bool

and select that from arch Kconfigs.  That way the enumeration can be done in
common code, and then this can be computed at compile time doesn't need to do a
rather weird invocation of kvm_dev_ioctl() with KVM_CHECK_EXTENSION.

FWIW, you should be able to do 

	if (IS_ENABLED(CONFIG_HAVE_KVM_NOWAIT_ON_FAULT))

and avoid more #ifdefs.
