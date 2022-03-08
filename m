Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3845D4D1E50
	for <lists+kvm@lfdr.de>; Tue,  8 Mar 2022 18:15:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348700AbiCHRQq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 8 Mar 2022 12:16:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46120 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348702AbiCHRQm (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 8 Mar 2022 12:16:42 -0500
Received: from mail-pj1-x1029.google.com (mail-pj1-x1029.google.com [IPv6:2607:f8b0:4864:20::1029])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 33123532CB
        for <kvm@vger.kernel.org>; Tue,  8 Mar 2022 09:15:46 -0800 (PST)
Received: by mail-pj1-x1029.google.com with SMTP id b8so17780373pjb.4
        for <kvm@vger.kernel.org>; Tue, 08 Mar 2022 09:15:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=hkyn/vGlcppYdspp9RKzcQ3UD3ptvOdy4abrHzmJQ4c=;
        b=NaxBH/garo7tXqwcDzW8xg9cwt7C718vSZwUlAT5Uh/PPawICrZPCXg3FOCZztFI/y
         UAb24xDqEzXo2QMZbM9qoaqQG24d0tNiFMmoyjYzUJA9JBT6Ojwvp4zmVAdLqL9juIXz
         XIbTo6UD0t8glSuD6fOgKwtVOFofW8Xbv+LGmBmAUaHbyUU20p6BO0neo1qOaJV+Ag4b
         3XvkKiqmYJN0csaknR9dfI/2PwOi9/6Z52ZKQS3IxXIkzwpkePqFtnOjVM7vrQTp44AU
         t8wd6BVBeQnlaQK7J4Qp3R42JOf4I2eDhqSa1t4XKdgSlGk9nerAui8RBJbR0KlwOPf6
         hcmA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=hkyn/vGlcppYdspp9RKzcQ3UD3ptvOdy4abrHzmJQ4c=;
        b=aO/RNzEvzgTF3q/JUXU/+k0nCbcjTTcugA2fQSAD/buODNSTpevXCZ2MVEsdbzazpe
         /F6YJmMh750MZfc4X6X8SoHCRkorrHVN0rC47hCU2on55rlaWVvFQHh68ukXLuNOqy9l
         MXk9cBRheDeJaNH+cMPW0n4DaKawWe60QI9r8BfQiolSnAxUnVgVURths0AgSTiTqzKP
         9hW/roixKc85jQa2HoghmzjB3aiUoORHlREiqU8WLFH1MpLFhMQNKI+NZqmzsKTa91Nz
         WYf6S/b5W4+FnRg5+mqa7wMvyP6bZR64ufByrluzmIJu0C3R8HWvo1VCVwybHL9srA9/
         uq6w==
X-Gm-Message-State: AOAM5304RgLPUTXbhX2satrlU2G9poAv0BHigwGeMO6E0NOXOU1wkfzU
        8vNl4zIcjsDsjL7LDKFtxz+YfQ==
X-Google-Smtp-Source: ABdhPJwRVXiFKAq3QxXoWfu61BFBFCXR1VvO6KSAO/0RCVrRwZN7zWSGikIg/y9dmxbwUgugaoOzbg==
X-Received: by 2002:a17:903:248:b0:14f:139f:191f with SMTP id j8-20020a170903024800b0014f139f191fmr18269276plh.71.1646759745558;
        Tue, 08 Mar 2022 09:15:45 -0800 (PST)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id v23-20020a17090a521700b001bbfc181c93sm3383375pjh.19.2022.03.08.09.15.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 08 Mar 2022 09:15:44 -0800 (PST)
Date:   Tue, 8 Mar 2022 17:15:41 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        dmatlack@google.com
Subject: Re: [PATCH v2 07/25] KVM: x86/mmu: remove "bool base_only" arguments
Message-ID: <YiePPQzw2Ak8O/cf@google.com>
References: <20220221162243.683208-1-pbonzini@redhat.com>
 <20220221162243.683208-8-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220221162243.683208-8-pbonzini@redhat.com>
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

On Mon, Feb 21, 2022, Paolo Bonzini wrote:
> The argument is always false now that kvm_mmu_calc_root_page_role has
> been removed.
> 
> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
> ---

Reviewed-by: Sean Christopherson <seanjc@google.com>
