Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4705036C896
	for <lists+kvm@lfdr.de>; Tue, 27 Apr 2021 17:23:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236488AbhD0PYa (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 27 Apr 2021 11:24:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38774 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235974AbhD0PY3 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 27 Apr 2021 11:24:29 -0400
Received: from mail-ed1-x52a.google.com (mail-ed1-x52a.google.com [IPv6:2a00:1450:4864:20::52a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2EA2DC061574
        for <kvm@vger.kernel.org>; Tue, 27 Apr 2021 08:23:46 -0700 (PDT)
Received: by mail-ed1-x52a.google.com with SMTP id h10so70406384edt.13
        for <kvm@vger.kernel.org>; Tue, 27 Apr 2021 08:23:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=gc8woWbNxJbdvRRggI1IoUfbNc9lkDvROsvEblMei44=;
        b=lHGyM1d4Yy8DrhiOvl+mjtGGME5UNFBuzOhI7Nn9p7VfCVa/JwXm73/nfjycJXjkp4
         EJAk/7o0DUGO/VajmOLMlhIBYX9ICQ/jdpAwZuPb/KynHPPnKHGRxsdEtqKftN7lw5/E
         yi47mPq1fc+f1on1f1qFJPNr1OCMWE/KGHvDrosC5VSK+EkZMLLvIwVXZtdugCRWQuCL
         3x5yMxbq2deYKwZZc8sU+s/Ptr0lpMVxNPvdPM2HPzhQmaptrG1hrqWqN7+sIn9OLKW9
         cDDPdU+OVltMGb7CVfZqkXFlfIcQ/iGWZ3u4QhDXrTev/WdDiBcNF4BYl+2PLvJEa/UX
         Jw0Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=gc8woWbNxJbdvRRggI1IoUfbNc9lkDvROsvEblMei44=;
        b=U9SXfE6PenqEdM6s/Cn6nrmT5qx0vaw84Ef9GIjz+bN8lRA/lqTfIz8ZgNEAO9xKaK
         5XBVi1w0f6flexYEto/lV4otGn/ZeHDVN1j3VLRmwNQVuKWw5uLx3U2c2x8m5q8cffOp
         63cnnb9Zj4WZzau7ohGiBCRU/QDskrE+Kkc9VmLTTMydi6AZiv/ollJyvWv4zU+xmsj7
         uvz0xgpwHPRL4SuKgCxPK9/6YXIbEleB2sBBpmayu9LUS+UoAjH6OCRan5PEtnGxyCi5
         gsxt/ugVSSQpST3P0bJqBm9atZZ4kjrd14NW6myOIXca0adGVHlG8Pm6ruqL4k+HTY+J
         1FIw==
X-Gm-Message-State: AOAM530ac/jZHBIDTjOdnZa6Yuvp5dm5y4zA13q4vKgUM1qu9AyS+unh
        rAi8VuAEZ44TMVFvA3QKiBaNMQ==
X-Google-Smtp-Source: ABdhPJzUbrl2tMkMNoxFod1mRAGmCI1qrAttTgk/bfethyZA8K+AFiBsKzPZFj4LAwxcZcPOR1Gpkw==
X-Received: by 2002:a05:6402:1cb9:: with SMTP id cz25mr5022442edb.163.1619537024959;
        Tue, 27 Apr 2021 08:23:44 -0700 (PDT)
Received: from myrica ([2001:1715:4e26:a7e0:116c:c27a:3e7f:5eaf])
        by smtp.gmail.com with ESMTPSA id f11sm140948ejc.62.2021.04.27.08.23.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 27 Apr 2021 08:23:44 -0700 (PDT)
Date:   Tue, 27 Apr 2021 17:23:26 +0200
From:   Jean-Philippe Brucker <jean-philippe@linaro.org>
To:     Alexandru Elisei <alexandru.elisei@arm.com>
Cc:     Marc Zyngier <maz@kernel.org>,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        kvm@vger.kernel.org, James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        kernel-team@android.com, Krishna Reddy <vdumpa@nvidia.com>,
        Sumit Gupta <sumitg@nvidia.com>
Subject: Re: [PATCH] KVM: arm64: Skip CMOs when updating a PTE pointing to
 non-memory
Message-ID: <YIgsbp/hRxM9U+ZN@myrica>
References: <20210426103605.616908-1-maz@kernel.org>
 <e6d955f1-f2a4-9505-19ab-5a770f821386@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e6d955f1-f2a4-9505-19ab-5a770f821386@arm.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Apr 27, 2021 at 03:52:46PM +0100, Alexandru Elisei wrote:
> The comment [1] suggested that the panic is triggered during page aging.

I think only with an out-of-tree patch applied
https://jpbrucker.net/git/linux/commit/?h=sva/2021-03-01&id=d32d8baaf293aaefef8a1c9b8a4508ab2ec46c61
which probably is not going upstream.

Thanks,
Jean

> vfio_pci_mmap() sets the VM_PFNMAP for the VMA and I see in the Documentation that
> pages with VM_PFNMAP are added to the unevictable LRU list, doesn't that mean it's
> not subject the page aging? I feel like there's something I'm missing.
> 
> [1]
> https://lore.kernel.org/kvm/BY5PR12MB37642B9AC7E5D907F5A664F6B3459@BY5PR12MB3764.namprd12.prod.outlook.com/
> 
> Thanks,
> 
> Alex
