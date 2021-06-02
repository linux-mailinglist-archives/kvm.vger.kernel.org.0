Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8A1A13986BF
	for <lists+kvm@lfdr.de>; Wed,  2 Jun 2021 12:43:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231357AbhFBKpd (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 2 Jun 2021 06:45:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43908 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229721AbhFBKp1 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 2 Jun 2021 06:45:27 -0400
Received: from mail-wm1-x32e.google.com (mail-wm1-x32e.google.com [IPv6:2a00:1450:4864:20::32e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D784AC06174A
        for <kvm@vger.kernel.org>; Wed,  2 Jun 2021 03:43:44 -0700 (PDT)
Received: by mail-wm1-x32e.google.com with SMTP id m18so986795wmq.0
        for <kvm@vger.kernel.org>; Wed, 02 Jun 2021 03:43:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=uetljnpMVagZUL5muUxDZIQ/D9uiCnsyXeZAzCtugkc=;
        b=S5AMEA55e6WiHfILJvvLPJjjSa/Yq2hHfihL5FLlwc0nkqiEigDVv6zGaQ9Zqw30CZ
         ZcNArqEE1KLDPi62Lj3DON4XRA4lRQEPl3mkiGXqf1NuzcbVyz2xB5213Beslcbi0VY+
         vsODVyRmobfR1fCmUKCnp2nQgPmer3uq6shiln93ca9H6FsgwmDg30qGDQ8d9/7e24Mp
         CSLPgs6X+XyQ7pC/c2x8ETo1zkBVPUtq9sPOkmehhhoJFv3lhBEv40tvpOSBlEY1/b8H
         QUE7F5ZbBoi4Gyi+g8C3tw7hkEOfNdrM3DT6aidkaFGmRGF0N81BVxOpbVVxuR5GQeKr
         JnRA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=uetljnpMVagZUL5muUxDZIQ/D9uiCnsyXeZAzCtugkc=;
        b=EabnedHfJjxK9Uclk/B0JSTsVPNpl8GghbPpaSaL13k7Xrj0kbzrGiO/z0czkNsDf1
         6o6Jmnxylvv4NRd+swJ3EmKdqDp0e3UGvI1smMegUEJupAhbORhKVjXK6RFZsTaBHGtw
         z/BhOwb6i6lMpqSqTHGd2KQeo743vnTS/HSuPhVnGYd9qLCRzqExRLwtSV5XmmHeVEuT
         crpVK0KYfTkrKnXjhPh1qaI+nEQCcKpDbPy+l44DP+g3XsLudpNTbQUFSJ66896BMrjc
         vi5KVm1jKRdIe2+4556nQTF/Ix8dBmQJRUGo7kpkR2t1ccYUMiiu8odNoeGuMstXHnbZ
         8OAg==
X-Gm-Message-State: AOAM533jymDGQFGch6vDeOROtQNNX/xR+cJt3cpHyihQmJdYiJ1kJYQW
        h4+4Gv4qOC0hS92HVOjTmml/qM2uNxcj3w==
X-Google-Smtp-Source: ABdhPJwVt/mkHfPZsWQ7XeVPY+TVxGZoc9ruOznSEZgl2V+JcARglYdu24JT3h1Ue3fGnhgc5QDPqA==
X-Received: by 2002:a7b:c042:: with SMTP id u2mr30819876wmc.127.1622630623364;
        Wed, 02 Jun 2021 03:43:43 -0700 (PDT)
Received: from google.com (105.168.195.35.bc.googleusercontent.com. [35.195.168.105])
        by smtp.gmail.com with ESMTPSA id 31sm7003760wrc.96.2021.06.02.03.43.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 02 Jun 2021 03:43:42 -0700 (PDT)
Date:   Wed, 2 Jun 2021 10:43:40 +0000
From:   Quentin Perret <qperret@google.com>
To:     Yanan Wang <wangyanan55@huawei.com>
Cc:     Marc Zyngier <maz@kernel.org>, Will Deacon <will@kernel.org>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Catalin Marinas <catalin.marinas@arm.com>,
        James Morse <james.morse@arm.com>,
        Julien Thierry <julien.thierry.kdev@gmail.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Gavin Shan <gshan@redhat.com>, wanghaibin.wang@huawei.com,
        zhukeqian1@huawei.com, yuzenghui@huawei.com
Subject: Re: [PATCH v5 1/6] KVM: arm64: Introduce KVM_PGTABLE_S2_GUEST
 stage-2 flag
Message-ID: <YLdg3K6m0P+cis2P@google.com>
References: <20210415115032.35760-1-wangyanan55@huawei.com>
 <20210415115032.35760-2-wangyanan55@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210415115032.35760-2-wangyanan55@huawei.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Yanan,

On Thursday 15 Apr 2021 at 19:50:27 (+0800), Yanan Wang wrote:
> diff --git a/arch/arm64/include/asm/kvm_pgtable.h b/arch/arm64/include/asm/kvm_pgtable.h
> index c3674c47d48c..a43cbe697b37 100644
> --- a/arch/arm64/include/asm/kvm_pgtable.h
> +++ b/arch/arm64/include/asm/kvm_pgtable.h
> @@ -61,10 +61,12 @@ struct kvm_pgtable_mm_ops {
>   * @KVM_PGTABLE_S2_NOFWB:	Don't enforce Normal-WB even if the CPUs have
>   *				ARM64_HAS_STAGE2_FWB.
>   * @KVM_PGTABLE_S2_IDMAP:	Only use identity mappings.
> + * @KVM_PGTABLE_S2_GUEST:	Whether the page-tables are guest stage-2.
>   */
>  enum kvm_pgtable_stage2_flags {
>  	KVM_PGTABLE_S2_NOFWB			= BIT(0),
>  	KVM_PGTABLE_S2_IDMAP			= BIT(1),
> +	KVM_PGTABLE_S2_GUEST			= BIT(2),

Assuming that we need this flag (maybe not given Marc's suggestion on
another patch), I'd recommend re-naming it to explain _what_ it does,
rather than _who_ is using it.

That's the principle we followed for e.g. KVM_PGTABLE_S2_IDMAP, so we
should be consistent here as well.

Thanks,
Quentin
