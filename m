Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8BE522B90C2
	for <lists+kvm@lfdr.de>; Thu, 19 Nov 2020 12:15:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726712AbgKSLO6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 19 Nov 2020 06:14:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33754 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726691AbgKSLO6 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 19 Nov 2020 06:14:58 -0500
Received: from mail-wm1-x343.google.com (mail-wm1-x343.google.com [IPv6:2a00:1450:4864:20::343])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 169B7C0613CF
        for <kvm@vger.kernel.org>; Thu, 19 Nov 2020 03:14:58 -0800 (PST)
Received: by mail-wm1-x343.google.com with SMTP id w24so6390929wmi.0
        for <kvm@vger.kernel.org>; Thu, 19 Nov 2020 03:14:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=AT6vz2m42JXc7lrJwjmpvEMB8s7HSthxy8G6z45TFw8=;
        b=uyZKU41rSPFAFtLcohcLT9M2PYocUNVHWJWTf53IFCaNw7mcYBQ/OV5mF+Z9pUbtfJ
         pdGu30hiumiwL19aJe2aDPkmVcdpTz5KoWexqw70c9y9oBC49pNNsde7osvyz+XO6v51
         rxLO0OtV9yAmrJsEQRwQduDZyGZzh0/tJXDAFuP3Dkx3uNnotD3KgqM5ZYL58mtpgG8g
         41MOobefny3kFsPuCQY7AYFsMiN7wk2fscZESRIZd6slXTGiOo3U6S/OMJU8YKhwc1eO
         +mcuricEPz+YrRLiUnP9AvGQ/imaM0YwAZgi92o8A7PM6dcH1Gq5syyb3fl9WETdoAlZ
         Scaw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=AT6vz2m42JXc7lrJwjmpvEMB8s7HSthxy8G6z45TFw8=;
        b=D+k4prwbyyDgycTNykaU7cjNzopq3DN7ChFk+ufG/YOWJJTiPcTweTokReS7RGboEM
         IJKAW+DQv+QO0Wa4Eo6ylZ4iTthCly5x7BKLa0EIplqvW48fscKm81j8fV+l9KSJW703
         V1EbohUFkG3wTp/496XW40goF/wunp2TgprcwOWK9faTVOBlbCm/9Du/PgJMderaUH3S
         CIFF3diO7/SOhOmsmp8ALU5Ja6Zlaj1vLaXc9lFGecWpBvE2oaVqHWoZ6HLN+/HHNmnC
         KKyNdIAsrGr671rQx+5Da4mHpcK+jKRSUT/IVQQvSrQ6pQRQQgj+ULOQ410DH+M0U7yJ
         ovvw==
X-Gm-Message-State: AOAM532Cb7aRitOKBaMcjp8TcIllkd3VI77OSUAcP0SXZ+TOaENGLbSh
        dKTAfI2bLiLx7JQZJN3k53NCdA==
X-Google-Smtp-Source: ABdhPJyhjWDduxIBws3Ul6EHk3OG2nFzeTTtIhTcNveUaPVZ7P2RuGx59RiEB/hStDd4b5hulEmX3w==
X-Received: by 2002:a1c:7704:: with SMTP id t4mr4065727wmi.48.1605784496615;
        Thu, 19 Nov 2020 03:14:56 -0800 (PST)
Received: from google.com ([2a01:4b00:8523:2d03:9843:cd3f:f36b:d55c])
        by smtp.gmail.com with ESMTPSA id b124sm9245409wmh.13.2020.11.19.03.14.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 19 Nov 2020 03:14:55 -0800 (PST)
Date:   Thu, 19 Nov 2020 11:14:54 +0000
From:   David Brazdil <dbrazdil@google.com>
To:     Marc Zyngier <maz@kernel.org>
Cc:     linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        kvm@vger.kernel.org, James Morse <james.morse@arm.com>,
        Julien Thierry <julien.thierry.kdev@gmail.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Andrew Scull <ascull@google.com>,
        Will Deacon <will@kernel.org>,
        Quentin Perret <qperret@google.com>, ndesaulniers@google.com,
        kernel-team@android.com
Subject: Re: [PATCH v2 3/5] KVM: arm64: Patch kimage_voffset instead of
 loading the EL1 value
Message-ID: <20201119111454.vrbogriragp7zukk@google.com>
References: <20201109175923.445945-1-maz@kernel.org>
 <20201109175923.445945-4-maz@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201109175923.445945-4-maz@kernel.org>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hey Marc,

Just noticed in kvmarm/queue that the whitespacing in this patch is off.

> +.macro kimg_pa reg, tmp
> +alternative_cb kvm_get_kimage_voffset
> +       movz    \tmp, #0
> +       movk    \tmp, #0, lsl #16
> +       movk    \tmp, #0, lsl #32
> +       movk    \tmp, #0, lsl #48
> +alternative_cb_end
> +
> +       /* reg = __pa(reg) */
> +       sub     \reg, \reg, \tmp
> +.endm
This uses spaces instead of tabs.

> +	 
>  #else
This added empty line actually has a tab in it.

-David
