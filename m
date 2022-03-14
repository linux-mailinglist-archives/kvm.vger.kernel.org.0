Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0897F4D8DB5
	for <lists+kvm@lfdr.de>; Mon, 14 Mar 2022 21:03:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244861AbiCNUEG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 14 Mar 2022 16:04:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33912 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244854AbiCNUEA (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 14 Mar 2022 16:04:00 -0400
Received: from mail-io1-xd34.google.com (mail-io1-xd34.google.com [IPv6:2607:f8b0:4864:20::d34])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D8BDF129
        for <kvm@vger.kernel.org>; Mon, 14 Mar 2022 13:02:46 -0700 (PDT)
Received: by mail-io1-xd34.google.com with SMTP id 195so19788666iou.0
        for <kvm@vger.kernel.org>; Mon, 14 Mar 2022 13:02:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=5f2/HoIwu4j9nQu9qTBXrIZ6NMk6olPlLIzOEbYSwZw=;
        b=YSdWC5rvFf1g8ioBrwOR3I4g6iXlWuZTXYZmkB/YQq1F1LrcUaSd/IQL+JvtW6ihSp
         oQaeInLjTzG/E53npJN0joUHNTo51L0lUAbybFrGGy5h1XilJkR03a6LOeR1W6M85NDw
         P7mQ1C/yLXctxm7ySS07JsZcTqIrLfPQo031NqWsuNEIjJHqw9V4GydqW30p1Zya0c1K
         ZwDP19hMy8Qj4hekRHBCFttQRHyES8t1BcI1ERp2y6JBS5pxUC1EbIe4MEMkoI0rpq90
         NUTTKj2kIS88DkRO7tkBQ/gT5XSv4rVJd4VuWAIIiRZQFiudmldpM26HeG4gPWGw4D1b
         lyFw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=5f2/HoIwu4j9nQu9qTBXrIZ6NMk6olPlLIzOEbYSwZw=;
        b=j0M80yJwevztpi02ZGPOoFlNPs8o2Ua3bE6llAz5zJm4FwXMc4jZDngD3/41OPbgf9
         LShnJjZaSAb0JRQacbp4H1XEH7o7qfBSIkqR/oVnHGkH2VVn+kOC8IMfIogO1knmyTOY
         p6Pf3w33Y0vjwXOjsfux8vZSluRHGZMSDcAviQxSngCEOAB6+Ph1tzxDedr+2cv6O/TY
         nw6fud++JysY1DledrlyhQLKkbRcFPN9hp/NVY8p2K8uGEFmPZBTWLHym5fhZfs0iDuT
         ptXTgL9aEICJRGATLsSw52rLOGUBuH5fdZBBOpyzt4qVt+6PKvUS0/EWV0GP8t2PsxxS
         9S6Q==
X-Gm-Message-State: AOAM5304iRF0sJjusoq1rRQI7vWuiRdwryflub5MHBAO33MiyQffWY5d
        7oJJca/RxrJg78ItnRoMMy0XaQ==
X-Google-Smtp-Source: ABdhPJzeQC03D9/rf02Bht8goOg45eN2rPjgNoqhJu/PvxB2PzO/F0nX9G85uS1FXW19T23DPBCxaw==
X-Received: by 2002:a05:6638:16c5:b0:319:e32b:98e3 with SMTP id g5-20020a05663816c500b00319e32b98e3mr12201874jat.123.1647288165969;
        Mon, 14 Mar 2022 13:02:45 -0700 (PDT)
Received: from google.com (194.225.68.34.bc.googleusercontent.com. [34.68.225.194])
        by smtp.gmail.com with ESMTPSA id x14-20020a056e021bce00b002c7ada1bec5sm943788ilv.88.2022.03.14.13.02.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 14 Mar 2022 13:02:45 -0700 (PDT)
Date:   Mon, 14 Mar 2022 20:02:42 +0000
From:   Oliver Upton <oupton@google.com>
To:     Raghavendra Rao Ananta <rananta@google.com>
Cc:     Marc Zyngier <maz@kernel.org>, Andrew Jones <drjones@redhat.com>,
        James Morse <james.morse@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will@kernel.org>, Peter Shier <pshier@google.com>,
        Ricardo Koller <ricarkol@google.com>,
        Reiji Watanabe <reijiw@google.com>,
        Jing Zhang <jingzhangos@google.com>,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Subject: Re: [PATCH v4 13/13] selftests: KVM: aarch64: Add the bitmap
 firmware registers to get-reg-list
Message-ID: <Yi+fYt3MhMoZbN+T@google.com>
References: <20220224172559.4170192-1-rananta@google.com>
 <20220224172559.4170192-14-rananta@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220224172559.4170192-14-rananta@google.com>
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Feb 24, 2022 at 05:25:59PM +0000, Raghavendra Rao Ananta wrote:
> Add the psuedo-firmware registers KVM_REG_ARM_STD_BMAP,
> KVM_REG_ARM_STD_HYP_BMAP, and KVM_REG_ARM_VENDOR_HYP_BMAP to
> the base_regs[] list.
> 
> Signed-off-by: Raghavendra Rao Ananta <rananta@google.com>

Reviewed-by: Oliver Upton <oupton@google.com>

> ---
>  tools/testing/selftests/kvm/aarch64/get-reg-list.c | 3 +++
>  1 file changed, 3 insertions(+)
> 
> diff --git a/tools/testing/selftests/kvm/aarch64/get-reg-list.c b/tools/testing/selftests/kvm/aarch64/get-reg-list.c
> index f769fc6cd927..42e613a7bb6a 100644
> --- a/tools/testing/selftests/kvm/aarch64/get-reg-list.c
> +++ b/tools/testing/selftests/kvm/aarch64/get-reg-list.c
> @@ -686,6 +686,9 @@ static __u64 base_regs[] = {
>  	KVM_REG_ARM_FW_REG(0),
>  	KVM_REG_ARM_FW_REG(1),
>  	KVM_REG_ARM_FW_REG(2),
> +	KVM_REG_ARM_FW_BMAP_REG(0),	/* KVM_REG_ARM_STD_BMAP */
> +	KVM_REG_ARM_FW_BMAP_REG(1),	/* KVM_REG_ARM_STD_HYP_BMAP */
> +	KVM_REG_ARM_FW_BMAP_REG(2),	/* KVM_REG_ARM_VENDOR_HYP_BMAP */
>  	ARM64_SYS_REG(3, 3, 14, 3, 1),	/* CNTV_CTL_EL0 */
>  	ARM64_SYS_REG(3, 3, 14, 3, 2),	/* CNTV_CVAL_EL0 */
>  	ARM64_SYS_REG(3, 3, 14, 0, 2),
> -- 
> 2.35.1.473.g83b2b277ed-goog
> 
