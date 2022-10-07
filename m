Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BAE5E5F7C0F
	for <lists+kvm@lfdr.de>; Fri,  7 Oct 2022 19:13:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229829AbiJGRNP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 7 Oct 2022 13:13:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56564 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229745AbiJGRNJ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 7 Oct 2022 13:13:09 -0400
Received: from mail-pj1-x102f.google.com (mail-pj1-x102f.google.com [IPv6:2607:f8b0:4864:20::102f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 96DBACD5D9
        for <kvm@vger.kernel.org>; Fri,  7 Oct 2022 10:12:55 -0700 (PDT)
Received: by mail-pj1-x102f.google.com with SMTP id q10-20020a17090a304a00b0020b1d5f6975so4190681pjl.0
        for <kvm@vger.kernel.org>; Fri, 07 Oct 2022 10:12:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=r9B2Io37F2WB3dubxdTH3aMsWowlvQ//OiuVGJXtoP0=;
        b=aDsNi2kFJ4h252fuK/kVoczwyXDG2McRIApgv12rS9woAmFaizTDPsoQHUZnV/Gqmk
         i/UC24IzUs/CQVt5w7bFFCz+XFNVOIiBaafD3b62A6eKRApYVcJqfS26KCTmVT+fOIaV
         um1gKp3tvK5aTPSHGRJue2yGzahdoxjhD+1me5h4hJiOVpujqZnUK2VOJhm0JtBw0Wxh
         QRxi7xyOWD8lOJjcbqdmpA2eX0ha07e9WP0tfXzqOb3lglo3VkgF1qsfH/wSlBpCMYva
         EK0QP4f16UJhsERB/QDMTEhqzg3DmsxgN+g2xGpmAe1HcoNwZ3h02lACf8UDiR1FMayc
         4uhA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=r9B2Io37F2WB3dubxdTH3aMsWowlvQ//OiuVGJXtoP0=;
        b=QPWv5j4Yea5PpgdSC9FRJVc9yUbXXEG9kkUUZIFT/yuHLhZ0c2Lh2Njy26SgT3EugH
         ECtAeOGBVU/Z0MGNja6pVpSELJPwiyQZ9x11QpUFDxKpEZ9f/shdK5IeEHWtNQErbKYn
         ge9aHB/3MR/dbUu/pgStx8OstKUmQBqcnzQKG02IpUR6undZ02HmuqJPngMIIBQZyCUX
         1nPoX6W69M9/e8KzyVV44IVz+W1qr6eJwTm7kpYYpzPwIPiYI856d1EYBlQ3ScGYQrCn
         IVr4epMaVl8gLHO4E9/k+KVULLKV/yO0rAD1mgQdi/MMUbPoD8RYjlqxepUjtHH67hG3
         JdZA==
X-Gm-Message-State: ACrzQf2+nfQ5HX1pUxNCkIDBrczon+ekLjMf5Y3Yoysyt3LOjAd4qKe+
        PFoYRF9f33FXhTeA34mzEHjZBsur0aDTBA==
X-Google-Smtp-Source: AMsMyM6iPTxQDdy3IiuF993uK93cycK/yyvuHhFri/bkK8tDViN5HgvcPljdj91mS/E4dn0KeWVatQ==
X-Received: by 2002:a17:902:e54c:b0:180:40fb:e1a2 with SMTP id n12-20020a170902e54c00b0018040fbe1a2mr2543172plf.14.1665162775039;
        Fri, 07 Oct 2022 10:12:55 -0700 (PDT)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id x13-20020aa79acd000000b00561c3ec5346sm1839174pfp.129.2022.10.07.10.12.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 07 Oct 2022 10:12:53 -0700 (PDT)
Date:   Fri, 7 Oct 2022 17:12:49 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Hao Peng <flyingpenghao@gmail.com>
Cc:     pbonzini@redhat.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] kvm: x86: keep srcu writer side operation mutually
 exclusive
Message-ID: <Y0BeEVxkDkctmTIX@google.com>
References: <CAPm50a+aygp3T1mNjzGXtL2nyNm-mHFZ3YO8F7eO0gCxZDuQsA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAPm50a+aygp3T1mNjzGXtL2nyNm-mHFZ3YO8F7eO0gCxZDuQsA@mail.gmail.com>
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

On Sat, Oct 08, 2022, Hao Peng wrote:
> From: Peng Hao <flyingpeng@tencent.com>
> 
> Synchronization operations on the writer side of SRCU should be
> invoked within the mutex.

Why?  Synchronizing SRCU is necessary only to ensure that all previous readers go
away before the old filter is freed.  There's no need to serialize synchronization
between writers.  The mutex ensures each writer operates on the "new" filter that's
set by the previous writer, i.e. there's no danger of a double-free.  And the next
writer will wait for readers to _its_ "new" filter.

I think it's a moot point though, as this is a subset of patch I posted[*] to fix
other issues with the PMU event filter.

[*] https://lore.kernel.org/all/20220923001355.3741194-2-seanjc@google.com
