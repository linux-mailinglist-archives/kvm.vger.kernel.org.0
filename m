Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 648EC4BBE34
	for <lists+kvm@lfdr.de>; Fri, 18 Feb 2022 18:17:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238464AbiBRRRl (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 18 Feb 2022 12:17:41 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:45180 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238337AbiBRRPq (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 18 Feb 2022 12:15:46 -0500
Received: from mail-pl1-x62a.google.com (mail-pl1-x62a.google.com [IPv6:2607:f8b0:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 02C6D1275DA
        for <kvm@vger.kernel.org>; Fri, 18 Feb 2022 09:15:27 -0800 (PST)
Received: by mail-pl1-x62a.google.com with SMTP id x11so7649915pll.10
        for <kvm@vger.kernel.org>; Fri, 18 Feb 2022 09:15:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=5DBNroUKPfQERghwahUfBWjvAkNxMqGLB1PH+8DKuNc=;
        b=sHg3ObPWzkeC9xEO0V7DReNTB+4arPdrOPPDTmavWb5B9DZkREfKPq+3FpWBa403Lw
         Y5t53RaSluKTmLmNHRyur9hYMmHAGLgLMMAI9ZZbiNy8UlIbW/ZGkYCdPgABD0AC2T9u
         wKWYtt0XeXFY2WfwMfoSkvlcdhLyHj997+0tCVf6DE+moJBJXVSuJPlhu9L6zFceEp+Y
         hfaDc1XmVEbolMObbXCG6QURvbRe+kHph+8PAKn1JulfgmdoCvc2Ohn3pIQm1ymvmIn+
         13SIsdwC8zCLIm2zZwwsnzRC2s0H8azX8RkjbmF9uEIa/dkiSNanBcJyBfZMtoNe3gS/
         xzLw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=5DBNroUKPfQERghwahUfBWjvAkNxMqGLB1PH+8DKuNc=;
        b=moW5xAnlXSgAUS4LNAeJIV4vdeAi92MPePCkA97FlKub3ZUxs7Iu795OOb36/GYVf0
         QlnEsGPS+dSSyvtiYUDUC8PxuanPLQo+s3ypvFD5y+PKrTqJwHJIlnJdxdjm8Y25w7cw
         H6PMPKcHTjSpvUliSCUNzJMwtiWzXPWKfeTq1bOZhfSQqvesdRypQTo6TpHOUk28iTbH
         Jczqh2wxM0h/lBg4BkpPvaPoR0nl4nuBPTbIbO1dAm563ooT8QYeVJpJokSsztYOd3Rv
         zfAHt2W9A89WbygFBYrqM4A1eRaD8wWC2j3inWuCRWk4Cuq4AI/GDAWbkjb6dUq5p+TK
         +NYg==
X-Gm-Message-State: AOAM5332YVPF8xeVp4gyHJ+sr1L+/FJlgq1lf3tXO4BNCOYdWjc02o1U
        1FbQv9G1bEADE5hqvuXkBuJ7F4UxB/wjUw==
X-Google-Smtp-Source: ABdhPJzlvWoSjWwc9M5oN1R7z8trnYPRzDDfCSzYbcFXbOyMmf/dsym7BNfiUqYWis5pQSn1bh/9ww==
X-Received: by 2002:a17:90a:6809:b0:1b9:bc46:fdd7 with SMTP id p9-20020a17090a680900b001b9bc46fdd7mr13616473pjj.148.1645204526362;
        Fri, 18 Feb 2022 09:15:26 -0800 (PST)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id gm6-20020a17090b100600b001b8b502d18bsm6838pjb.19.2022.02.18.09.15.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 18 Feb 2022 09:15:25 -0800 (PST)
Date:   Fri, 18 Feb 2022 17:15:22 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Subject: Re: [PATCH v2 04/18] KVM: x86/mmu: avoid NULL-pointer dereference on
 page freeing bugs
Message-ID: <Yg/UKrihA/56EN8S@google.com>
References: <20220217210340.312449-1-pbonzini@redhat.com>
 <20220217210340.312449-5-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220217210340.312449-5-pbonzini@redhat.com>
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

On Thu, Feb 17, 2022, Paolo Bonzini wrote:
> WARN and bail if KVM attempts to free a root that isn't backed by a shadow
> page.  KVM allocates a bare page for "special" roots, e.g. when using PAE
> paging or shadowing 2/3/4-level page tables with 4/5-level, and so root_hpa
> will be valid but won't be backed by a shadow page.  It's all too easy to
> blindly call mmu_free_root_page() on root_hpa, be nice and WARN instead of
> crashing KVM and possibly the kernel.
> 
> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
> ---

Reviewed-by: Sean Christopherson <seanjc@google.com>
