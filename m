Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BFBD14CC6C2
	for <lists+kvm@lfdr.de>; Thu,  3 Mar 2022 21:03:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236086AbiCCUEj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 3 Mar 2022 15:04:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38284 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233490AbiCCUEi (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 3 Mar 2022 15:04:38 -0500
Received: from mail-pg1-x534.google.com (mail-pg1-x534.google.com [IPv6:2607:f8b0:4864:20::534])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C12C44C791
        for <kvm@vger.kernel.org>; Thu,  3 Mar 2022 12:03:52 -0800 (PST)
Received: by mail-pg1-x534.google.com with SMTP id o26so5610684pgb.8
        for <kvm@vger.kernel.org>; Thu, 03 Mar 2022 12:03:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=Pi8iH0FAYkIoz6MeuCkLdqM2juK9qQBoN4Ks48wQ+iA=;
        b=kwAxKx2fJbB7ljjwDZJV2FM0kwSPs73r6pQ8wAnY/3kHs37v6JZsIrTXQN53Bt4skz
         yyqVxn6+X7N3wpZLLN8h9GKt32c6qIlcAPqIDKfo9dH5iB1eeQ6v22e/xOtcht6inFUJ
         B6F87BAaFpwNu1r6QBlFyBpzdbDDpoOM224IxSKT+Abshs68aZSvbBiNdoE0jevxiMAj
         7rbmoLO/r5urHspdeg6T/wy63VhA3E3KCf0BgXYo3dI6ht7Ge1Q6QDHUgN+O+RgQCiv/
         uDwKWtOFhUyDGdvaJccDbRAxzkpHF8jms3QQ+IAqDUnsN9OFu1H/B7iQO8Z/CgnwzUjM
         uhTw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=Pi8iH0FAYkIoz6MeuCkLdqM2juK9qQBoN4Ks48wQ+iA=;
        b=xEmRvyQzjSud82bqeE+FujAl3j2EicrrG+MDTX1X6QVFVS7ZLFm/1I7ZuSkkOZ1maL
         o0XVFQJRIFVLf1g8+WjwsMKfSpepS+4EPPSSBbSQj+oHOIbLIlhNvSuDQJ8B5E0cMTtC
         NmG9KWmrsoR9ieW9H9Ov/tKZMmw61GU6oFed44jqt8QFtO1w31R3MQR8oUYO/xvrZIWw
         sIqPlhgf3AAjXCtHj2o65zLtY5D34Xs9z8ZgS2hH9QBEfxzZ0q9LPPbCFkAgcqPj4dia
         3gIG2lL0UXYG4UvUnZdOyxeOiN6iFmblcy0RsygSFdfupRY6gUgL1UBv1DqdYL60JfAd
         3ndA==
X-Gm-Message-State: AOAM533TvnMnmRgednrjgGpKvURHNc0K1rIOtmy8GJaBtFTc454VFvgQ
        mPC6TJWt6P/CGte50Fw7IqH72g==
X-Google-Smtp-Source: ABdhPJzWDDSu+QZHAmizrO5aMSiFU6NdT3KLIfTXE5v94X6e4+P4/7SuaoNqW/drd1Cpjh/dctSSSg==
X-Received: by 2002:a63:d252:0:b0:363:271c:fe63 with SMTP id t18-20020a63d252000000b00363271cfe63mr31827445pgi.524.1646337831852;
        Thu, 03 Mar 2022 12:03:51 -0800 (PST)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id m4-20020a17090a7f8400b001bef3fc3938sm2837806pjl.49.2022.03.03.12.03.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 03 Mar 2022 12:03:51 -0800 (PST)
Date:   Thu, 3 Mar 2022 20:03:47 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        David Hildenbrand <david@redhat.com>,
        David Matlack <dmatlack@google.com>,
        Ben Gardon <bgardon@google.com>,
        Mingwei Zhang <mizhang@google.com>
Subject: Re: [PATCH v4 06/30] KVM: x86/mmu: only perform eager page splitting
 on valid roots
Message-ID: <YiEfI0s6PJyHR96L@google.com>
References: <20220303193842.370645-1-pbonzini@redhat.com>
 <20220303193842.370645-7-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220303193842.370645-7-pbonzini@redhat.com>
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

On Thu, Mar 03, 2022, Paolo Bonzini wrote:
> Eager page splitting is an optimization; it does not have to be performed on
> invalid roots.  It is also the only case in which a reader might acquire
> a reference to an invalid root, so after this change we know that readers
> will skip both dying and invalid roots.
> 
> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
> ---

Reviewed-by: Sean Christopherson <seanjc@google.com>
