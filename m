Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 74BE066659A
	for <lists+kvm@lfdr.de>; Wed, 11 Jan 2023 22:25:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235775AbjAKVZh (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 11 Jan 2023 16:25:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42970 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235347AbjAKVZW (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 11 Jan 2023 16:25:22 -0500
Received: from mail-pj1-x102c.google.com (mail-pj1-x102c.google.com [IPv6:2607:f8b0:4864:20::102c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C997BD2FF
        for <kvm@vger.kernel.org>; Wed, 11 Jan 2023 13:25:21 -0800 (PST)
Received: by mail-pj1-x102c.google.com with SMTP id o8-20020a17090a9f8800b00223de0364beso21405052pjp.4
        for <kvm@vger.kernel.org>; Wed, 11 Jan 2023 13:25:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=isiHwCTIoSENRpWwMehTehvClsZpOj/mU5tiBrBvyOg=;
        b=KODnx62o2YITMkZtLn5TAKhNM9ViUaeHdj9VjXJu/gHD+gH9FMAwMdxd9S9Ntb2qD/
         WxCsAxQoAwpJ/OxsMAX75z+niJFc+AWtYUiS09V5oCcA39kxAPcD4ncfHMGHdmWgwKfb
         gDzFgredSbRch4xBb/p8uj1iYCpaT5ViMVW6ljLuHgP3fLV0sFbvdJOLyZC7mr3G7lJR
         V2L0JRHU8Pn/bXdRzrYsj34McL+Fn+7ElCL1BqVozAQy9Oz89HURV7QDAD8c02CkHhAS
         2VoM0J9NnsuXREtxE89v9ZJBaoOetEiqm/n0lbZYIcjAOHyhpDq35tURWsqq27L1V9FF
         /7fQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=isiHwCTIoSENRpWwMehTehvClsZpOj/mU5tiBrBvyOg=;
        b=Z2w4Fgti5MDDVeY1BRJUOTQa87QAwyYalWaF+kR0fF//MAaPcsUBO/+hb4PdNHRRZl
         1D9nvVnJ4jqlXtSYtG1qpiJU2n6ltciclVLbp1fCpTs/rMpm+Xep/Y7WunzOJG9p+XAv
         W717pCPE0ioBa3WttAJ+zxDpbEWzvITHoDtzH6fb8JK0ZaqpwMqHuLnCKYM0rLZbSgef
         qwncYe1UTNwN90V5Mq8A3jA1QMzHMb9JiptZr27thf0v77dJ9fBVlMA5ZHJDBTUGBZQT
         GXxHMZED2PLvGH8pQPalUhUMScrDumUolb5zPfHNRPSSq0CeV3nlTxRooNUGb0VfMNmf
         GXPw==
X-Gm-Message-State: AFqh2kprxcNYpJbQKSplzunA4eum1s+6zNo+m0/asj9O/BMJhVqZ8gxa
        8HvMYbEndHSZhpSH0Qw/edJW/A==
X-Google-Smtp-Source: AMrXdXvKRkQZXBDq3VgD7eMaL2oaCGMXrXbnpTAy1wa0mbklDqdGfRFLsGOVTct14OhG9MnRmRGavw==
X-Received: by 2002:a05:6a21:33a1:b0:ac:af5c:2970 with SMTP id yy33-20020a056a2133a100b000acaf5c2970mr588164pzb.3.1673472321232;
        Wed, 11 Jan 2023 13:25:21 -0800 (PST)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id w11-20020aa79a0b000000b00580e679dcf2sm10368318pfj.157.2023.01.11.13.25.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 11 Jan 2023 13:25:20 -0800 (PST)
Date:   Wed, 11 Jan 2023 21:25:17 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Vipin Sharma <vipinsh@google.com>
Cc:     pbonzini@redhat.com, bgardon@google.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [Patch v2] KVM: selftests: Make reclaim_period_ms input always
 be positive
Message-ID: <Y78pPcNuXsjpE3DZ@google.com>
References: <20230111183408.104491-1-vipinsh@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230111183408.104491-1-vipinsh@google.com>
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Jan 11, 2023, Vipin Sharma wrote:
> reclaim_period_ms use to be positive only but the commit 0001725d0f9b
> ("KVM: selftests: Add atoi_positive() and atoi_non_negative() for input
> validation") incorrectly changed it to non-negative validation.
> 
> Change validation to allow only positive input.
> 
> Fixes: 0001725d0f9b ("KVM: selftests: Add atoi_positive() and atoi_non_negative() for input validation")
> Signed-off-by: Vipin Sharma <vipinsh@google.com>
> Reported-by: Ben Gardon <bgardon@google.com>
> Reviewed-by: Ben Gardon <bgardon@google.com>
> ---

Reviewed-by: Sean Christopherson <seanjc@google.com>
