Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 28EEB4807E8
	for <lists+kvm@lfdr.de>; Tue, 28 Dec 2021 10:38:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235986AbhL1JiN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 28 Dec 2021 04:38:13 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.129.124]:24976 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S235985AbhL1JiM (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 28 Dec 2021 04:38:12 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1640684292;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=GBj1Lmo862bZ5iBBD9Gif3sLiVjk0Wo9dVxJgXi9alI=;
        b=RURLtzv6EQzVZPGLNqbUQpmJYjZCrdF6l8SGw2Fhp0Ksq77S8ZkOTsESwbvkfQUKxVA87l
        Mxw0tmTTsW7pV0i8Ow/HfakQLrkNGv6E0Kwdjk9X0CBquehIY/XnQ0cY57lRTCx5anFU4m
        mmszta0P+ZmUIyrDXSxOGvAgW5q0xM8=
Received: from mail-ed1-f72.google.com (mail-ed1-f72.google.com
 [209.85.208.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-217-bIGBPSa2PvWtoJy-47_xzw-1; Tue, 28 Dec 2021 04:38:10 -0500
X-MC-Unique: bIGBPSa2PvWtoJy-47_xzw-1
Received: by mail-ed1-f72.google.com with SMTP id z10-20020a05640235ca00b003f8efab3342so5729350edc.2
        for <kvm@vger.kernel.org>; Tue, 28 Dec 2021 01:38:10 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=GBj1Lmo862bZ5iBBD9Gif3sLiVjk0Wo9dVxJgXi9alI=;
        b=Fn/8HPKKKV2Yqek0G58nlgdtQmYUP3De2ysgcpXGeuerbvEymyUP0f0cW7Wvo4Exwt
         XU55Ygvtg2Bl0CzbY8yMQUcxONfSOQTlVBn3qtXUDpy2OFJjMbv/nseEBsLa1XOKfr8o
         kzpfyV6BP4uodMzll+DooMb6SDV7ascE0O3vWINnXeAY99Xe7sA4+VM619QEMCWEI/ls
         Xwgr2X8seTlASPcSvJUXB6lK7QfAHXzDD+VdYz9xW7hRJ8vNoPLddY+E1NEppChXQ+1b
         8IVwuu+RcBCUGzYCLrkB41WoL7HVYP6KwNryC8KpVpCR0GP2Xw3bnMKJ86dF3MHUVO7j
         84gw==
X-Gm-Message-State: AOAM530ShvR71pzY2Mk35DP0RzD5TPtJW27k8sZRxg9icXAJJ718mWFN
        +H/GE40p8+5lr5CBXsiwGU+8H2AmCXFydsqmOaFnRrBGSiYQ7IFn9i8YCZK2l1rz6STY826rfxq
        XW4GheSyKHIyn
X-Received: by 2002:a17:906:4703:: with SMTP id y3mr16876611ejq.346.1640684289472;
        Tue, 28 Dec 2021 01:38:09 -0800 (PST)
X-Google-Smtp-Source: ABdhPJxSJyRS8TjbSLG0wyvRnwXos8K6OpwsqZkJ/RTwvEz16Ua9DcGNhPNRUQd8GoC6Nld1r5RMzw==
X-Received: by 2002:a17:906:4703:: with SMTP id y3mr16876603ejq.346.1640684289289;
        Tue, 28 Dec 2021 01:38:09 -0800 (PST)
Received: from gator.home (cst2-173-70.cust.vodafone.cz. [31.30.173.70])
        by smtp.gmail.com with ESMTPSA id gs14sm5894820ejc.183.2021.12.28.01.38.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 28 Dec 2021 01:38:09 -0800 (PST)
Date:   Tue, 28 Dec 2021 10:38:07 +0100
From:   Andrew Jones <drjones@redhat.com>
To:     Marc Zyngier <maz@kernel.org>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, kernel-team@android.com
Subject: Re: [PATCH v2 6/6] KVM: selftests: arm64: Add support for various
 modes with 16kB page size
Message-ID: <20211228093807.4s46hte4ilbjmxz7@gator.home>
References: <20211227124809.1335409-1-maz@kernel.org>
 <20211227124809.1335409-7-maz@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211227124809.1335409-7-maz@kernel.org>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Dec 27, 2021 at 12:48:09PM +0000, Marc Zyngier wrote:
> The 16kB page size is not a popular choice, due to only a few CPUs
> actually implementing support for it. However, it can lead to some
> interesting performance improvements given the right uarch choices.
> 
> Add support for this page size for various PA/VA combinations.
> 
> Signed-off-by: Marc Zyngier <maz@kernel.org>
> ---
>  tools/testing/selftests/kvm/include/kvm_util.h   |  4 ++++
>  .../selftests/kvm/lib/aarch64/processor.c        | 10 ++++++++++
>  tools/testing/selftests/kvm/lib/guest_modes.c    |  4 ++++
>  tools/testing/selftests/kvm/lib/kvm_util.c       | 16 ++++++++++++++++
>  4 files changed, 34 insertions(+)
>

Reviewed-by: Andrew Jones <drjones@redhat.com>

