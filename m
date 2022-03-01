Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ECD904C8F65
	for <lists+kvm@lfdr.de>; Tue,  1 Mar 2022 16:47:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235894AbiCAPsR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 1 Mar 2022 10:48:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55200 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235713AbiCAPsP (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 1 Mar 2022 10:48:15 -0500
Received: from mail-pg1-x52a.google.com (mail-pg1-x52a.google.com [IPv6:2607:f8b0:4864:20::52a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5E7E313E94
        for <kvm@vger.kernel.org>; Tue,  1 Mar 2022 07:47:33 -0800 (PST)
Received: by mail-pg1-x52a.google.com with SMTP id 195so14700204pgc.6
        for <kvm@vger.kernel.org>; Tue, 01 Mar 2022 07:47:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=U+GY94RaEa7x1vBqKGSJpgctg0TQe50+gLS4c7hl0cA=;
        b=LsZnpUaXMouxUUJ2zk0Uc1eAZOf9nYu0e8cSbcXTMwCeZauKHNDvhvz09P++SoSsYG
         iM3MPmjZOUe/I0RTdbQ5s+QjE06cR2ai0IPfi+4SWn5kA4DgJhiMrNUeqk95WUIKSc81
         jMZlTwdc/59EtUtwPSQlCAtL9md96UnllkiW7vhT3oW9x5/7CEt63iTMPYDNaogpMaNB
         ODcyHgNXq8LrCOUysbDBVYp2CayAonpITwcayxgznyAl1OpVYKiy9ZjBDlcgubZEBWJF
         D1jIx0H6iQI9n39qkNg+GcRptWyyFCe75H14gwvAY8TQBf9u9qRClhpdMfNkndnQeloB
         gJrw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=U+GY94RaEa7x1vBqKGSJpgctg0TQe50+gLS4c7hl0cA=;
        b=GlzjLfz/ZD3wJ10zr6Y8L9fPToA0t0HngE7Q76JsOy5zdCNUwb2EkytFl3fPwVW7HJ
         OI2zlkN/MEZlG6HrvBl3XrjfY8kzPuYB0W8enn6amurW+Qzy0sWK8Ik8/4XvHwDqw5g3
         VMNbWaR7hF20y7jokAPbSxYrSV92eWh4adQZUvq+mLnKnW+yXnL9OawBEgTrCmQ/wGfR
         PfMjjXWIi/1OQsYSZD7F5Sweron3tfTcRVyn6HhzXj4iw3ziEUATqENzv3/QgilGkTyA
         +TvvCCKK6cPodghEYCDEAViJhG1yCmW42v5Ji7AjmnFH3u9COAQejK5G89TBJX9E/b2P
         680g==
X-Gm-Message-State: AOAM532ARKQzPIyaXY2xx5mgSaM6SlGa1i2EqzN92pRLYciDCjchVlM9
        NYqu9CaWHoND4AZla/5Cuhks1w==
X-Google-Smtp-Source: ABdhPJx0AiiTffgCoa2WwMXYrCLWzP0cf+USWQGZW5dGBTAIdCO5v8ba87fkK0P5dQUEQ/hEZEXU+g==
X-Received: by 2002:a65:604b:0:b0:378:7add:ec47 with SMTP id a11-20020a65604b000000b003787addec47mr12456372pgp.555.1646149653133;
        Tue, 01 Mar 2022 07:47:33 -0800 (PST)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id n22-20020a056a0007d600b004f3ba7c23e2sm17581108pfu.37.2022.03.01.07.47.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 01 Mar 2022 07:47:32 -0800 (PST)
Date:   Tue, 1 Mar 2022 15:47:28 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Like Xu <like.xu.linux@gmail.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Joerg Roedel <joro@8bytes.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] KVM: x86/mmu: Passing up the error state of
 mmu_alloc_shadow_roots()
Message-ID: <Yh5AEAQOX4nT5p7G@google.com>
References: <20220301124941.48412-1-likexu@tencent.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220301124941.48412-1-likexu@tencent.com>
X-Spam-Status: No, score=-18.1 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Mar 01, 2022, Like Xu wrote:
> From: Like Xu <likexu@tencent.com>
> 
> Just like on the optional mmu_alloc_direct_roots() path, once shadow
> path reaches "r = -EIO" somewhere, the caller needs to know the actual
> state in order to enter error handling and avoid something worse.

Well that's emabarrassing.

> Fixes: 4a38162ee9f1 ("KVM: MMU: load PDPTRs outside mmu_lock")

Cc: stable@vger.kernel.org

> Signed-off-by: Like Xu <likexu@tencent.com>
> ---

Reviewed-by: Sean Christopherson <seanjc@google.com>
