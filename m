Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 306C15806E7
	for <lists+kvm@lfdr.de>; Mon, 25 Jul 2022 23:43:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231223AbiGYVnw (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 25 Jul 2022 17:43:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36480 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229739AbiGYVnu (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 25 Jul 2022 17:43:50 -0400
Received: from mail-pl1-x62e.google.com (mail-pl1-x62e.google.com [IPv6:2607:f8b0:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 22844AE6A
        for <kvm@vger.kernel.org>; Mon, 25 Jul 2022 14:43:50 -0700 (PDT)
Received: by mail-pl1-x62e.google.com with SMTP id c6so7519429plc.5
        for <kvm@vger.kernel.org>; Mon, 25 Jul 2022 14:43:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=vxs/kjDzT8xmnfAolVvF5egE6ySjqBi8jIvVMpgsjVM=;
        b=Nhv+acGYpc9fxkWDI6xWBI4KCMyINQVY2WCQYWOh6u30qlz4Pli5x+qqLlJdRqLjKp
         Z2IB/WWyaKFLauguIXcXjHNyBsSW2XpWFXCp2Nage43P89tA3ZXaCFHQR0DxU6sLhSXS
         G7wCSrou/fTGjsvuJCOvuhWgqDr5q/vmfA9uVEd/vrcMuaP0ZaaKna1pR9aFK4DcjDr0
         rMbdythyJK9MqViMd/gDzscfuXCuEMCw5LBjeETLMemwC8V1EIYOluZ2uQAfWKiPUqPY
         UWvT5/gGDJh/UDeebo3eLdaR6bizp7vYlda1v8pVCZp/H41oZ17g9KfgKgAmvPlOm6Bk
         wBVA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=vxs/kjDzT8xmnfAolVvF5egE6ySjqBi8jIvVMpgsjVM=;
        b=Q9p/ubzhLyY0CxEGqagllGoie/PUwh71IRxD5mGvK5wEfDNtB2iRJazzDtX+eFHqsQ
         rv/hPEwwWM+Y4+DzyiwYKr8gZloGIfj7nllbKIoZJj74HCnJCxHtzrB5TxNfjDC2JCl/
         Uibkdkk2mP0sE0OYm2wXWPJRSbzDMNs0agJP80xmUTEAChPy+KyB/DPMZyiLqALH7nrO
         NQq0cfipPYE9m6vpaOODbPa1ZaO7pvKotCjtVqVG4NYwfUBeujw3nO3FT8jtF6x+YLUI
         0yrxasxwRFNaWqLUrGNmUPSaC0onYHK01PQ00DvxwwalKJwQ92169oXoD5VtRbKTKyKQ
         AwBA==
X-Gm-Message-State: AJIora8G1KvorS6rZRIbn7fdNUWbhGfKX85Liegl5qFbU1qUna/Y+Ae6
        Nl6B3A0LLHknZnMalqRjecL+FQ==
X-Google-Smtp-Source: AGRyM1sMfmJWs2AQ8/nQOy+NMEJEgHO9DsP4xcRix6Wrmd2+/UtZVjShXct+zXqEFtIy9mvT7/YgZA==
X-Received: by 2002:a17:90a:6d63:b0:1f2:1669:7c30 with SMTP id z90-20020a17090a6d6300b001f216697c30mr16081599pjj.89.1658785429544;
        Mon, 25 Jul 2022 14:43:49 -0700 (PDT)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id k13-20020a170902c40d00b0016d21697ed9sm3072397plk.48.2022.07.25.14.43.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 25 Jul 2022 14:43:49 -0700 (PDT)
Date:   Mon, 25 Jul 2022 21:43:45 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     David Matlack <dmatlack@google.com>
Cc:     Junaid Shahid <junaids@google.com>, kvm@vger.kernel.org,
        pbonzini@redhat.com
Subject: Re: [PATCH] kvm: x86: mmu: Drop the need_remote_flush() function
Message-ID: <Yt8OkRUYfndOnGrw@google.com>
References: <20220723024316.2725328-1-junaids@google.com>
 <Yt7VNt2bsdNtyqZl@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Yt7VNt2bsdNtyqZl@google.com>
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

On Mon, Jul 25, 2022, David Matlack wrote:
> On Fri, Jul 22, 2022 at 07:43:16PM -0700, Junaid Shahid wrote:
> > This is only used by kvm_mmu_pte_write(), which no longer actually
> > creates the new SPTE and instead just clears the old SPTE. So we
> > just need to check if the old SPTE was shadow-present instead of
> > calling need_remote_flush(). Hence we can drop this function. It was
> > incomplete anyway as it didn't take access-tracking into account.
> > 
> > This patch should not result in any functional change.
> 
> Even if we don't assume anything about the new SPTE, this commit flushes
> TLBs in a superset of the current cases. So this change should
> definitely be safe.
> 
> And then if we assume new SPTE is 0 (which it should be), I agree this
> should not result in any functional change.

Nit for posterity, zapped SPTEs don't necessarily have to be '0', e.g. KVM is
more than likely going to use 0x80000000_00000000 as the "zero" value for TDP MMU
SPTEs so that the SUPPRESS_VE is set for "zero"-initialized SPTEs (TDX requires
EPT Violation #VEs be enabled).

> Reviewed-by: David Matlack <dmatlack@google.com>

Reviewed-by: Sean Christopherson <seanjc@google.com>
