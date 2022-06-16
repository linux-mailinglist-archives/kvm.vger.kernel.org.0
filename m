Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 29F9C54E826
	for <lists+kvm@lfdr.de>; Thu, 16 Jun 2022 18:54:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234948AbiFPQyz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 16 Jun 2022 12:54:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59600 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234526AbiFPQyy (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 16 Jun 2022 12:54:54 -0400
Received: from mail-pf1-x431.google.com (mail-pf1-x431.google.com [IPv6:2607:f8b0:4864:20::431])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3F9192D1EA
        for <kvm@vger.kernel.org>; Thu, 16 Jun 2022 09:54:54 -0700 (PDT)
Received: by mail-pf1-x431.google.com with SMTP id u37so2009527pfg.3
        for <kvm@vger.kernel.org>; Thu, 16 Jun 2022 09:54:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=LzIoat5tvoKjMobcVCYTGuH3jDJmFEBiWBVDBiUd/KE=;
        b=TxgPoU9m7P7k73wmYXXSCSdzcii7y55/TkyYtk6K4DsJ4veirk3cBcbsSqwTO0+v1o
         QA0Qp5+ib36PACt6hsJOCjIaysP7AYNZ8C96Ao+BmimEhXZkqjcD4qHnvbZGvBT3oyMt
         /HrkKamnOrY7GvnirR/1Ia4UYTPLSTQbMA9aR+dO5wvD8+q4yokjLr2Ur+4WeAO9XQGO
         z/iGZcfn3qrJyCwvpCgaQGJAqR07BXMxFLp9AiNRxneqxlMZj9hZAbftUpL6AN9/xNl2
         PqT19PHDDJk3LLPHl8vQx83s/gqtzXzsFO3fUSkx4QRpn1a+x2f1pb1INz3i2d5wmEYG
         zFMQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=LzIoat5tvoKjMobcVCYTGuH3jDJmFEBiWBVDBiUd/KE=;
        b=5WEmUN86sdOx1RUFYmFTUYdD5cot46sprd82v2z/WM78sb2wvEaMscx7ovHRvSObuf
         aKzJo6E8Cziz8wydEtWJ5wuBKp+O7hUbHdJ5917ns1COgLOMhmOmepm7XdIxuPuCHu8L
         IqrTq2giSpIMCNUPnBO0ek9F29tAH5AGdvcvKL9l4rMszKfanVJZPG+wmjMBpJ86aIYC
         LwcIN+V/4FCHbGh4EiubIuXzCexcVLOzUhJAxKPGeGyFSWD7jBYfwrcb8NGOftO7wOdJ
         5aE45Rz+8PxE5cP89lV9LKFv+ZRyDXs+zYD4XbSUqF9MLg3Fp0X3VpoyMl+ZVSV2kgmF
         B2ZQ==
X-Gm-Message-State: AJIora+ZoMLFfJfx5UZ2KHX0SlvSNRSlMfTJ84ONBGJ78fpC/GzqmuZ+
        wrgZza7zp6S/0AfKOhb8m4fv8g==
X-Google-Smtp-Source: AGRyM1uIJP8T9rXgj65zBh450gEVVD6ZZE5nhMnpm6cridY6D6NO8phz3Hg1WSl8XfZ0LT2CfyM8Bg==
X-Received: by 2002:a05:6a00:228d:b0:524:cb23:2fb2 with SMTP id f13-20020a056a00228d00b00524cb232fb2mr2823851pfe.42.1655398493537;
        Thu, 16 Jun 2022 09:54:53 -0700 (PDT)
Received: from google.com (123.65.230.35.bc.googleusercontent.com. [35.230.65.123])
        by smtp.gmail.com with ESMTPSA id l4-20020a17090a660400b001e8d377c648sm1813816pjj.11.2022.06.16.09.54.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 16 Jun 2022 09:54:52 -0700 (PDT)
Date:   Thu, 16 Jun 2022 16:54:49 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 04/10] KVM: Avoid pfn_to_page() and vice versa when
 releasing pages
Message-ID: <YqtgWesFK9Hkm9h9@google.com>
References: <20220429010416.2788472-1-seanjc@google.com>
 <20220429010416.2788472-5-seanjc@google.com>
 <e793f8f4-69dd-1824-7bb1-048428d977f4@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e793f8f4-69dd-1824-7bb1-048428d977f4@redhat.com>
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

On Thu, Jun 16, 2022, Paolo Bonzini wrote:
> On 4/29/22 03:04, Sean Christopherson wrote:
> > -
> > +/*
> > + * Note, checking for an error/noslot pfn is the caller's responsibility when
> > + * directly marking a page dirty/accessed.  Unlike the "release" helpers, the
> > + * "set" helpers are not to be unused when the pfn might point at garbage.
> > + */
> 
> s/unused/unused/

LOL, s/unused/used?  :-)

> But while at it, I'd rather add a WARN_ON(is_error_noslot_pfn(pfn)).

I've no objection to that.  IIRC, I almost added it myself, but my mental coin
flip came up wrong.
