Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BC62F4EB6F7
	for <lists+kvm@lfdr.de>; Wed, 30 Mar 2022 01:48:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241064AbiC2Xt7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 29 Mar 2022 19:49:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59390 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230432AbiC2Xty (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 29 Mar 2022 19:49:54 -0400
Received: from mail-pl1-x633.google.com (mail-pl1-x633.google.com [IPv6:2607:f8b0:4864:20::633])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D903F204C9D
        for <kvm@vger.kernel.org>; Tue, 29 Mar 2022 16:48:08 -0700 (PDT)
Received: by mail-pl1-x633.google.com with SMTP id y6so16485371plg.2
        for <kvm@vger.kernel.org>; Tue, 29 Mar 2022 16:48:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=k9zNH8eck7B2fqpSHhtjQeS2/0DdhWXUpHBJSuxKOv8=;
        b=laMf07yySldwhTJdf1DNpFBQdKfmIe/udTZIfmSv7noXMTdG9OSeh2ZOTifk/VxW7W
         /0qaWI+OIPWuWqh8829MPDsHpwXOKZf3GvbG9HOsl7q0M9zxgIdACJYJ2QFW+00b6IMl
         wZ2ypU6WshzDuGWYltk/gCBUhLvo2RQOyU61//80w2nFZSfUwsDNyHkrRphdRWy7gXq6
         fohaBr7Mn9/13s83/DhlM5uI1IafNFhkoUI4rD79RyfZ0uTkb9qAomBkNOrNrNPOQ+gP
         k5Co4ANfaity67+ihz73dlRVtZzvhHae6zDw04Huec1jfNF3maJSKVL/Jjwac8cQkJWV
         vplg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=k9zNH8eck7B2fqpSHhtjQeS2/0DdhWXUpHBJSuxKOv8=;
        b=HngYz1gCCCmUg005YLfCHCTGyWRKgE/5nBsXjC+rMSTVmT2xEUMJS6Lfj93KFE60V9
         Elha7R4IA2pSEHRIDqPZp3aQr2indw4URo/hYYQoh7sHBNGyr674Gk5Bcrr3tmpUt0Kp
         UxBBKeBqiPdNC3IICr5ofiSIUxyzPm1GPqOis5TeN6xUsOHJIoNWRoBMXGPXMJ0EzHwF
         du5nwET8qvkQaugLBI5qHcVS8Ht2a+v56ChNqy5jJqIqMCgBQgRRJhikTae2FJBxyoAW
         gA/vwd6JixR+vSYnkN9A5hZDH3uyReH5qHj10RcfkIaaOZckOXLPax/C7TjH9bMSYa1R
         oaPA==
X-Gm-Message-State: AOAM533A+m7uMxWRy5/LRb0jAm3d0+ZDgvVW2zLaJI8dm7MY1jvcpIb/
        nXwBYZVGDtrtQiosrLP9AAmzdA==
X-Google-Smtp-Source: ABdhPJwi0XSuejkaAFbg1D/khFYUdTlk19+zKFj7wtL6dE/9hSWn+IJ+E/tQR25dvxGUxBT5WJy72w==
X-Received: by 2002:a17:903:1210:b0:14f:973e:188d with SMTP id l16-20020a170903121000b0014f973e188dmr31927885plh.61.1648597688097;
        Tue, 29 Mar 2022 16:48:08 -0700 (PDT)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id e12-20020a056a001a8c00b004fab88d7de8sm20808407pfv.132.2022.03.29.16.48.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 29 Mar 2022 16:48:07 -0700 (PDT)
Date:   Tue, 29 Mar 2022 23:48:03 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Like Xu <like.xu.linux@gmail.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
        Jim Mattson <jmattson@google.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Joerg Roedel <joro@8bytes.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 4/4] KVM: x86: Use static calls to reduce kvm_pmu_ops
 overhead
Message-ID: <YkOas2UgOsUnhMkZ@google.com>
References: <20220307115920.51099-1-likexu@tencent.com>
 <20220307115920.51099-5-likexu@tencent.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220307115920.51099-5-likexu@tencent.com>
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Mar 07, 2022, Like Xu wrote:
> From: Like Xu <likexu@tencent.com>
> 
> Use static calls to improve kvm_pmu_ops performance. Introduce the
> definitions that will be used by a subsequent patch to actualize the
> savings. Add a new kvm-x86-pmu-ops.h header that can be used for the
> definition of static calls. This header is also intended to be
> used to simplify the defition of amd_pmu_ops and intel_pmu_ops.

This is stale, there are no subsequent patches and I think we decided to not fill
vendor ops with the ops.h headers.  I'll tweak it when sending v3.1.
