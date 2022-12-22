Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5B5E76546E7
	for <lists+kvm@lfdr.de>; Thu, 22 Dec 2022 20:50:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235432AbiLVTuT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 22 Dec 2022 14:50:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39596 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229816AbiLVTuR (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 22 Dec 2022 14:50:17 -0500
Received: from mail-pj1-x102d.google.com (mail-pj1-x102d.google.com [IPv6:2607:f8b0:4864:20::102d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D41531838B
        for <kvm@vger.kernel.org>; Thu, 22 Dec 2022 11:50:16 -0800 (PST)
Received: by mail-pj1-x102d.google.com with SMTP id u15-20020a17090a3fcf00b002191825cf02so2926530pjm.2
        for <kvm@vger.kernel.org>; Thu, 22 Dec 2022 11:50:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=nlJ8ryU5g2QZFAdZtR+IR3SIX9Yfj1ZJNm9KsPKrj4w=;
        b=C/izAgLm7g5zOK+Yj40Z7ShGZxsCmvnvCi+MvzjyKGN+D+JddpAZG1uO3wl1ylCLg3
         x75ZaRDvBrb/aIVMiMmWF+b2yWTjNh2wPsY3Lbkm7+zK/O0lnewSWosouuKiVgn1XADL
         RBPbp2QN2L8YzFqzFLgqzEilUKcl7Y1q+uq5larK8GgrSfSKElqs+gbsJHaNaa4T09Qs
         pEJt7rlH2QWq3E7ZOdeALKnK5qjtNp8zQOjIgShnScTdMWEvfre0XO3Cf+TXYe7WU9qr
         sbloXoig4cS5DtlSqgY7uEq7JrzYno67OYh6/WbSLxCMvdPPYpp1V5830DAD/7y46BHr
         tqMA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=nlJ8ryU5g2QZFAdZtR+IR3SIX9Yfj1ZJNm9KsPKrj4w=;
        b=u2jpWowj/s33XIFrJKTS+l4/w5x6JusNUszpy3gfGoiXnERe6F+O/LJE0dCg9MTCsj
         CZZNNo+yptaLXQTTVPGg9ho+0qsSqEY5PD33LsdO2+Jf17G5q73JS+CiZwuwtQFRauEK
         pZrwVhYFCkS9IvRLz/fI5FLMIriuUjzMiL6gXf5YP6qGqcbe1JP2nhId9Bhe0+yXskna
         Dwbo7ZXL6l3KZPLTcKNjeqOi1mhXVvZipU3vbSUwNpZFcZAV+pFweXq1zsTGPh9wdKwG
         OEp68WvPYo4Jbu7/wzltIle8FpqnwQp+RPm7PW/JBhSZ17SGbSsd6OrlDpyT4dBlA6HB
         XuxQ==
X-Gm-Message-State: AFqh2krCsKepXHwCQvbbTYm5+k3XhxI6bIx7a04NuHluz4+GIDQv9xut
        gZZd/oCqNyKc3dvAot9ZblQ24g==
X-Google-Smtp-Source: AMrXdXuZwQU2WrHBJGKHHI9LixQ7/4PsU9O1YuJFGJ+QnNSzP4XKJzlnL0midJOxOfOUhKNH9TLQmA==
X-Received: by 2002:a17:90b:2301:b0:225:bc9e:ce8e with SMTP id mt1-20020a17090b230100b00225bc9ece8emr127777pjb.1.1671738616309;
        Thu, 22 Dec 2022 11:50:16 -0800 (PST)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id px12-20020a17090b270c00b0020dc318a43esm988874pjb.25.2022.12.22.11.50.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 22 Dec 2022 11:50:15 -0800 (PST)
Date:   Thu, 22 Dec 2022 19:50:12 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     David Woodhouse <dwmw2@infradead.org>
Cc:     Yu Zhang <yu.c.zhang@linux.intel.com>, kvm@vger.kernel.org,
        pbonzini@redhat.com, maz@kernel.org, james.morse@arm.com,
        alexandru.elisei@arm.com, suzuki.poulose@arm.com,
        oliver.upton@linux.dev, catalin.marinas@arm.com, will@kernel.org,
        paul@xen.org
Subject: Re: [PATCH v4 1/2] KVM: MMU: Introduce 'INVALID_GFN' and use it for
 GFN values
Message-ID: <Y6S09LWMJcUqFZ7H@google.com>
References: <20221216085928.1671901-1-yu.c.zhang@linux.intel.com>
 <20221216085928.1671901-2-yu.c.zhang@linux.intel.com>
 <Y5yeKucYYfYOMXqp@google.com>
 <89a8f726e6fb1a91097ef18d6e837aff31a675f3.camel@infradead.org>
 <Y6Snr42pMGvIO+9d@google.com>
 <9E3AF816-144E-43F7-8AFE-68BF405DCC4C@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <9E3AF816-144E-43F7-8AFE-68BF405DCC4C@infradead.org>
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

On Thu, Dec 22, 2022, David Woodhouse wrote:
> Will update the docs and test accordingly. I have a couple of other minor doc
> fixes which I spotted as I was doing the qemu support. If nobody beats me to
> the uapi header part, I'll do that too. But I'm not *scheduled* to be in
> front of a real computer until next year now, and and time I do steal is
> likely to be spent on qemu itself.

No rush, I'm about to disappear until next year too.  I'm guessing Paolo will be
fairly inactive next week too.
