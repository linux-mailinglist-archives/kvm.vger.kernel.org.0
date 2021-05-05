Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0A821374A86
	for <lists+kvm@lfdr.de>; Wed,  5 May 2021 23:39:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234403AbhEEVk2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 5 May 2021 17:40:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49850 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234357AbhEEVkF (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 5 May 2021 17:40:05 -0400
Received: from mail-pl1-x635.google.com (mail-pl1-x635.google.com [IPv6:2607:f8b0:4864:20::635])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BA8B3C061342
        for <kvm@vger.kernel.org>; Wed,  5 May 2021 14:39:06 -0700 (PDT)
Received: by mail-pl1-x635.google.com with SMTP id b3so1912927plg.11
        for <kvm@vger.kernel.org>; Wed, 05 May 2021 14:39:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=p5WbUDTCy8at+RZ096C+TWQnzaCtiquOJEsVUamTn30=;
        b=ETnPvDSVlt25+89h0ch6LhrN35qUJuQCBbGlyz3o2IOhExXNm6UpZw/tf8+HZgcqpe
         lhGwJGuOkMdxfElfqPtedvXKV9MyFrZZ198NxzoVbhciFoXWPthFQKCbLN98uOh5t3fo
         veePHsvDMF79EluHjNAqVwzWgLxb4cDnIfadO6wFUw68fjewmA4LI3i8xuuBwAbyvZfK
         MLqC0o5Bgn2P8Gqa1qPlAH5Zup+Vx72EYq6In9XYLQcRvCnnads4Zq79YgRV0DXbU8aG
         wqM2HcNLYL1zpWi6OYTILb8u9Nx0eOH03KnyiNBS0WdJQKvcksyehGNId8EqL3t8fkBd
         sNYA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=p5WbUDTCy8at+RZ096C+TWQnzaCtiquOJEsVUamTn30=;
        b=PAGcKwFwFmbiC5P6RYIAmUFbI7jBt1anXhdBDtyPE53i0p9NjTnPGUCpAg+B/jeKw3
         isuZcmJVvKpi5IpM+JsoJKZNF7XyHi8R717NbjWfPRTS90Shh4Q3Z99SeOGn01aqJQRO
         wuTGoEyIF6aXjgzucS7HahE3uHzZjIALpxtMOkk/SqaqT/WqRXcPmwmtL4ndPfCgrfNq
         cBu1drhd0K7XqbjV6BpgG07imPnwbyjLTwkDb+bDKQuPTQagCDvT3tWtCI54lm26zpjZ
         fOn3C6STMEnCJAyV9lKrx2rsKrcGk2fYX//ETJ09ntpTpApRhnm6pbcicneXOo43YTPE
         8pmA==
X-Gm-Message-State: AOAM532Myi9cIxXd3WWHbi/H3LFjvy+u9XoxM9AsLJdJpAXa5idzNM2B
        TI+CljIucQGlzRUctplxbo7h8w==
X-Google-Smtp-Source: ABdhPJz0SxL7mrUMHW2PvMJvUwEgPsKwRyWrWN3HZY/ZPlMvYkaCBRGDspfkdlxIzeZc6dae/3Se6A==
X-Received: by 2002:a17:90b:3905:: with SMTP id ob5mr13270238pjb.94.1620250746117;
        Wed, 05 May 2021 14:39:06 -0700 (PDT)
Received: from google.com (240.111.247.35.bc.googleusercontent.com. [35.247.111.240])
        by smtp.gmail.com with ESMTPSA id q194sm174912pfc.62.2021.05.05.14.39.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 05 May 2021 14:39:05 -0700 (PDT)
Date:   Wed, 5 May 2021 21:39:01 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Dan Carpenter <dan.carpenter@oracle.com>
Cc:     rientjes@google.com, kvm@vger.kernel.org
Subject: Re: [bug report] KVM: SVM: prevent DBG_DECRYPT and DBG_ENCRYPT
 overflow
Message-ID: <YJMQdQu4LRMd9lSi@google.com>
References: <YIpeFsdjT5Fz5FWZ@mwanda>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YIpeFsdjT5Fz5FWZ@mwanda>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Apr 29, 2021, Dan Carpenter wrote:
> Hello David Rientjes,
> 
> The patch b86bc2858b38: "KVM: SVM: prevent DBG_DECRYPT and
> DBG_ENCRYPT overflow" from Mar 25, 2019, leads to the following
> static checker warning:
> 
> 	arch/x86/kvm/svm/sev.c:960 sev_dbg_crypt()
> 	error: uninitialized symbol 'ret'.
> 
> arch/x86/kvm/svm/sev.c
>    879  static int sev_dbg_crypt(struct kvm *kvm, struct kvm_sev_cmd *argp, bool dec)
>    880  {
>    881          unsigned long vaddr, vaddr_end, next_vaddr;
>                 ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
> 
>    882          unsigned long dst_vaddr;
>                 ^^^^^^^^^^^^^^^^^^^^^^^^
> 
> These are unsigned long
> 
>    883          struct page **src_p, **dst_p;
>    884          struct kvm_sev_dbg debug;
>    885          unsigned long n;
>    886          unsigned int size;
>    887          int ret;
>    888  
>    889          if (!sev_guest(kvm))
>    890                  return -ENOTTY;
>    891  
>    892          if (copy_from_user(&debug, (void __user *)(uintptr_t)argp->data, sizeof(debug)))
>    893                  return -EFAULT;
>    894  
>    895          if (!debug.len || debug.src_uaddr + debug.len < debug.src_uaddr)
>                                   ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
> But these are u64 so this could still overflow on 32 bit.  Do we care?

Not really.  sev_guest() will always be false for CONFIG_KVM_AMD_SEV=n, and
CONFIG_KVM_AMD_SEV is dependent on CONFIG_X86_64=y.  This code is compiled for
32-bit only because everyone has been too lazy to stub out sev.c.
