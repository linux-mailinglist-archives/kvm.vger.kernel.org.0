Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EA4544BBFAA
	for <lists+kvm@lfdr.de>; Fri, 18 Feb 2022 19:40:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235292AbiBRSkJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 18 Feb 2022 13:40:09 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:47434 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239325AbiBRSkH (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 18 Feb 2022 13:40:07 -0500
Received: from mail-pl1-x631.google.com (mail-pl1-x631.google.com [IPv6:2607:f8b0:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8A7422A072E
        for <kvm@vger.kernel.org>; Fri, 18 Feb 2022 10:39:49 -0800 (PST)
Received: by mail-pl1-x631.google.com with SMTP id l8so7837906pls.7
        for <kvm@vger.kernel.org>; Fri, 18 Feb 2022 10:39:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=z6Bvj05xcHZ8scACXRLrqFmVNNP/kVQ38WCNRoc9XKw=;
        b=rxk0jwB8ICLKh+8xaKXBp+1GzMw8O3daGo7CE8qC+eNNHZUl5rhvpsxPc+UkJtI9Ma
         KeZVPi9IRBNVjqLEJ+8R50hnUHGRKf56Ufo3ibpmdEciJ39pOv29hlXCt7YMhpLhcUEo
         HUzWguhARNtG9UbfU2cyuBn9ejeRfbvfS3MRi3BVrEHEIgziCmp2twyApgtveBjZY7AA
         sOuTFg6TR9vDcJR3tBxfo9zRB1ayCW/T1YkWUOHacvs9Cg10bh8ZD2XHmrqaylELbP6S
         Fw0y2/FuiOBOdI87r4ncpeVYTQzwFBhefTG/leFRrd8fac2nrgmfiX//dR8VQpyDsyI9
         TAdQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=z6Bvj05xcHZ8scACXRLrqFmVNNP/kVQ38WCNRoc9XKw=;
        b=mf4Y8OGCRdxwfu5PHaHD3Hg/ANSuVT6bugxgj7F0SyyzGkFUwUZKQ/lDry3ABqqSV0
         9rstYO2fmKqaZLLecyrZl47UmCAEqYb+pDm6rIOkTHu7wVxmkQ0H6Og4WUB5gCqKp3nE
         lEX9LXIjFJpVxT96Ya9xMzXZsTEyhzOxMj5b2R9avIQvO3kc+jmr8Z4x8TKFhgk/1pHa
         BfO4pU5Q7SIZ2saa/jT8vxOnQs+SETckOcYUflJbb78pfto7I9F+k2CefrjKF0QbNh6C
         Ap9X2rvpm80aCj9hJIO5/dcWVVQoGC/z1Rl/Zdg+1WmqdoHEw2JvZ+PwlJaldh37ns40
         nnPA==
X-Gm-Message-State: AOAM53200ZM3tP4OVPCvEA/g+gElSK8IKFw9d2p7OVBTURvKeqQQv+/O
        TjIczOlmi1Kj6DujVAycGpRJUw==
X-Google-Smtp-Source: ABdhPJzjq13fjwW0o9GeWGu5+HhZkEk3XYCmh4PYDrDLtL3cQaeU7+asPz9j0b75b+hI9CssfaYEIQ==
X-Received: by 2002:a17:90a:bb0e:b0:1b9:fffa:f030 with SMTP id u14-20020a17090abb0e00b001b9fffaf030mr9613386pjr.206.1645209588900;
        Fri, 18 Feb 2022 10:39:48 -0800 (PST)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id on17sm104807pjb.40.2022.02.18.10.39.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 18 Feb 2022 10:39:48 -0800 (PST)
Date:   Fri, 18 Feb 2022 18:39:45 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Subject: Re: [PATCH v2 08/18] KVM: x86/mmu: do not pass vcpu to root freeing
 functions
Message-ID: <Yg/n8dC7Umd5x0m6@google.com>
References: <20220217210340.312449-1-pbonzini@redhat.com>
 <20220217210340.312449-9-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220217210340.312449-9-pbonzini@redhat.com>
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

On Thu, Feb 17, 2022, Paolo Bonzini wrote:
> These functions only operate on a given MMU, of which there are two in a vCPU.

Technically 3, but one is only used to walk guest pages tables ;-)

> They also need a struct kvm in order to lock the mmu_lock, but they do not
> needed anything else in the struct kvm_vcpu.  So, pass the vcpu->kvm directly
> to them.

Wrapping at ~75 chars is preferred for changelogs.

> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
> ---

Reviewed-by: Sean Christopherson <seanjc@google.com>
