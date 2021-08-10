Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C3E443E833A
	for <lists+kvm@lfdr.de>; Tue, 10 Aug 2021 20:48:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231406AbhHJSs7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 10 Aug 2021 14:48:59 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:34463 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230181AbhHJSs6 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 10 Aug 2021 14:48:58 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1628621315;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=uGh9fA/6SL05Y4+mEAteYPx6YCipxcI5JZ/cNQGYfos=;
        b=XDu8pTQ1m5Tqf16wPV6QbBZh7d2epsSgc1tEOFcOoh/pCHna6qYZWFPzrxavIMJeh3tc/s
        XUY7p7YXdoL6crGrsrBUkGWAu45W2klDohYPf4Ouak7FrD2EUIGqgW1pot7TJJA9eYWeid
        BeN8lNOFRCr0iv2f6jkFJuqMreXewtw=
Received: from mail-qv1-f70.google.com (mail-qv1-f70.google.com
 [209.85.219.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-271-hLVSX5Z_N-2E1fodvtg6rQ-1; Tue, 10 Aug 2021 14:48:34 -0400
X-MC-Unique: hLVSX5Z_N-2E1fodvtg6rQ-1
Received: by mail-qv1-f70.google.com with SMTP id b2-20020a0cc9820000b0290352b2c7d7e1so7963967qvk.9
        for <kvm@vger.kernel.org>; Tue, 10 Aug 2021 11:48:34 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=uGh9fA/6SL05Y4+mEAteYPx6YCipxcI5JZ/cNQGYfos=;
        b=SwZDZpW32qQMRg6Sf1wpRHe1Vt2gk3wzngWnTS7Ggmm6OfDeIgXXTgAr6tiTSlM/mO
         vqfeOvmspS4c9wEsVr1CdbDSssmIfu1JXZOKi8Ckmqoldwrp5dEnZV5ORgaq/rrZV35I
         DIFvcUigUOK1oOGAiuYFxH39w1rpaTkQEM+k7+PiM7bPxBvLYq2CgnaXTGBElIq4VQQa
         x409fCi9rDOoSJ6XObgyZlB2JNS9hMyk4h154w9NljLGnm9+YMUT6c+5t0CLP/jne+XR
         BhNUVVo7Y1WHBZCa6H7bljUENMaG6cd2EkaqvEVIWqWsOrYdgAtMMZbQop/AmBI03VrM
         +JMQ==
X-Gm-Message-State: AOAM5319fE97yXHPGqRPYbucZzPqqdgsWYT77BUmq0qs7LlEDzjY3Fn8
        Ti3U2qa2XP/fzwpatTc/R6U+RB7hk3gOA2x/AtGXP512+Dh9770l4Jgkjxlf8IsOEr08TZ0gp69
        hiNNuJQQFFVZI
X-Received: by 2002:a05:620a:2101:: with SMTP id l1mr14790460qkl.104.1628621313806;
        Tue, 10 Aug 2021 11:48:33 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxIyq0bJKC/A97FVUFNlJ4uivR7xL4lKUeKBCJnJ5l4dPxGWD2CLEAIiMGQtQn39x+UaF2hrA==
X-Received: by 2002:a05:620a:2101:: with SMTP id l1mr14790443qkl.104.1628621313591;
        Tue, 10 Aug 2021 11:48:33 -0700 (PDT)
Received: from t490s (bras-base-toroon474qw-grc-92-76-70-75-133.dsl.bell.ca. [76.70.75.133])
        by smtp.gmail.com with ESMTPSA id a24sm8898750qtj.43.2021.08.10.11.48.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 10 Aug 2021 11:48:32 -0700 (PDT)
Date:   Tue, 10 Aug 2021 14:48:31 -0400
From:   Peter Xu <peterx@redhat.com>
To:     Alex Williamson <alex.williamson@redhat.com>
Cc:     Jason Gunthorpe <jgg@nvidia.com>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Subject: Re: [PATCH 3/7] vfio/pci: Use vfio_device_unmap_mapping_range()
Message-ID: <YRLJ/wdiY/fnGj2d@t490s>
References: <162818167535.1511194.6614962507750594786.stgit@omen>
 <162818325518.1511194.1243290800645603609.stgit@omen>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <162818325518.1511194.1243290800645603609.stgit@omen>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Aug 05, 2021 at 11:07:35AM -0600, Alex Williamson wrote:
> @@ -1690,7 +1554,7 @@ static int vfio_pci_mmap(struct vfio_device *core_vdev, struct vm_area_struct *v
>  
>  	vma->vm_private_data = vdev;
>  	vma->vm_page_prot = pgprot_noncached(vma->vm_page_prot);
> -	vma->vm_pgoff = (pci_resource_start(pdev, index) >> PAGE_SHIFT) + pgoff;
> +	vma->vm_page_prot = pgprot_decrypted(vma->vm_page_prot);

This addition seems to be an accident. :) Thanks,

-- 
Peter Xu

