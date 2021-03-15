Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C4AFA33C952
	for <lists+kvm@lfdr.de>; Mon, 15 Mar 2021 23:25:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231913AbhCOWZF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 15 Mar 2021 18:25:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41632 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233011AbhCOWYz (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 15 Mar 2021 18:24:55 -0400
Received: from mail-pg1-x52c.google.com (mail-pg1-x52c.google.com [IPv6:2607:f8b0:4864:20::52c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 52B9BC06174A
        for <kvm@vger.kernel.org>; Mon, 15 Mar 2021 15:24:55 -0700 (PDT)
Received: by mail-pg1-x52c.google.com with SMTP id 16so14892781pgo.13
        for <kvm@vger.kernel.org>; Mon, 15 Mar 2021 15:24:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=eSVlAX1fVhHy5kDtEAhAVCPc2Y7cisX9hzDXn3zscVI=;
        b=bjgBxGjHEMRNyeW5ZR60bTqODOEFFDPuFNQ2XqkxtP66eBtZvnGUH7QnK7SLaZe2kV
         2MJE6/rNfD6fXtoE77q0KzViTXs3Bolxa4A0VLFpVa/hGpx9mzarl5SDjE5qcHLBvaBG
         /F5do3FaplK0gneUwJjvMDMETyEeXEs6Ht/UZpm9W6xigJvw3fSWDHXwuXChV/thnyMC
         m03EDozzPfncJ2gWNsDIQyO1HZz/ZjBscKzdWTPj9vyZUSdsIH/xwDeq9qukcZx+KTOE
         lWKdL2hf5KvgnJWtcVPbb7kyRtK239faccNX3NjYGn1+VLmzV4gijd6cP3l3vtt7ZDoe
         wZFA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=eSVlAX1fVhHy5kDtEAhAVCPc2Y7cisX9hzDXn3zscVI=;
        b=nBfA5+AWZMm2NyGvs5RDfAYpYqXkYeaMc7DcJad5WRJCY4l54Wu5+gPfslIGXxKQdQ
         jPNccHpyDPhuZVxMfOTQgWKwb/ILUaFt4UuSFp8MgJJQJl9BisA9TBW3dnXCDTa/9rn9
         avr/m7zYOTzAgQMXB8mFJ4ZEXqItIfMigIpXlsG4GezJUISRWLYlJtp5ULyFmcas8Nl9
         E/vAzIrC3/HDORiIDmhvTD85ND4XHihZPxlKCJZu8g9VRlRxTrAFryM3ytoWld0kzLtP
         p3hC1oj0GJBk8ywgnEdV1hzkBQQV0HTIQIaHsX7X5IejMPG7j1cLhZn1xF9/4VjdB5CT
         G2yQ==
X-Gm-Message-State: AOAM531JhiEWNGMWV8Z+GR7K99tkI499d1EwLW6lH+FRTjesqtojI0Ak
        JhilRJizSdyoEnOFlRhKpsSrNg==
X-Google-Smtp-Source: ABdhPJxxxIwSByhv2EZChCu9P/0+HQoZiD8tGw1WkIfGR7VUosFxL+FfNkp6LAuFn1I8kagkCJeKHg==
X-Received: by 2002:aa7:8e43:0:b029:1ed:447c:f1d4 with SMTP id d3-20020aa78e430000b02901ed447cf1d4mr11831394pfr.16.1615847094734;
        Mon, 15 Mar 2021 15:24:54 -0700 (PDT)
Received: from google.com ([2620:15c:f:10:3d60:4c70:d756:da57])
        by smtp.gmail.com with ESMTPSA id f15sm5790864pgr.90.2021.03.15.15.24.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 15 Mar 2021 15:24:54 -0700 (PDT)
Date:   Mon, 15 Mar 2021 15:24:48 -0700
From:   Sean Christopherson <seanjc@google.com>
To:     Ben Gardon <bgardon@google.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Peter Shier <pshier@google.com>,
        Jim Mattson <jmattson@google.com>
Subject: Re: [PATCH v2 3/4] KVM: x86/mmu: Factor out tdp_iter_return_to_root
Message-ID: <YE/esByaQWd3QV2U@google.com>
References: <20210315182643.2437374-1-bgardon@google.com>
 <20210315182643.2437374-4-bgardon@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210315182643.2437374-4-bgardon@google.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Mar 15, 2021, Ben Gardon wrote:
> In tdp_mmu_iter_cond_resched there is a call to tdp_iter_start which
> causes the iterator to continue its walk over the paging structure from
> the root. This is needed after a yield as paging structure could have
> been freed in the interim.
> 
> The tdp_iter_start call is not very clear and something of a hack. It
> requires exposing tdp_iter fields not used elsewhere in tdp_mmu.c and
> the effect is not obvious from the function name. Factor a more aptly
> named function out of tdp_iter_start and call it from
> tdp_mmu_iter_cond_resched and tdp_iter_start.
> 
> No functional change intended.
> 
> Signed-off-by: Ben Gardon <bgardon@google.com>
> ---

Very nice, sooo much easier to read.

Reviewed-by: Sean Christopherson <seanjc@google.com>
