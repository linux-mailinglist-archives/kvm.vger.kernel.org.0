Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6327B67DC05
	for <lists+kvm@lfdr.de>; Fri, 27 Jan 2023 03:00:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233367AbjA0CAu (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 26 Jan 2023 21:00:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40664 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233771AbjA0B7u (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 26 Jan 2023 20:59:50 -0500
Received: from mail-pl1-x62e.google.com (mail-pl1-x62e.google.com [IPv6:2607:f8b0:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6D39420D01
        for <kvm@vger.kernel.org>; Thu, 26 Jan 2023 17:54:46 -0800 (PST)
Received: by mail-pl1-x62e.google.com with SMTP id jl3so3587195plb.8
        for <kvm@vger.kernel.org>; Thu, 26 Jan 2023 17:54:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=FVG3vcUNPuoauz0kQenibTVS8tEh32mHDh/BHGYm35Y=;
        b=REC6/SFdfstwPIQoNNlCe9zuXnwMpGW0RN3HSf1+wbzY0tdAqgA9C+YqlDiSRlJk4Z
         39fGpvhtKfanXE5VS8pFPQOV6kuY74S9ZaYkO+An7XxNyKaGvOdqRVeYa3cc9A2X5N9n
         zyHJcXqi14Nmqy9tp+58sQvzG9dJMY2SymT0LivicpBBn2HOpSBfgVmdXNdDXrLidnKP
         hn6vAQoQuZtTIvXdQGIMgWpAyhOwfvbBseIL87bwexpEQCBNjk8XEQ41dtwM7UZlp2z5
         cPVZjHyc3GSBxQ8QlsFLhklKncC5XFF0V6EBq85wLYW7HGNh9NQgn+b3HZuGPyvO3+mu
         eKRQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=FVG3vcUNPuoauz0kQenibTVS8tEh32mHDh/BHGYm35Y=;
        b=k5qgCf4Zpd+SyyiCxk7n8RLlAF4W7NxIB5EHgVbdYmMBQOqIhm2wJNkCcETfZ3EIKb
         0gEiWRdhiWXdrLQLLf/ZrxkFcFCl+bktrT6zNHqFj5l3GYNM6ckpEo5cJmoAUHdO2Icy
         GoLK6qjpH0Onx5wlbLs/vfm8zGKHG7pYHAXQgnUaRjjNJ2qAA2q1muJdRLkMYAoVODkc
         m/Mexf6BdQtriKMqOC+ASVxngx3ShCObyZmmNIhFHxur/AXxQtVai83EjJ7rO0LVWvzk
         /C7bP9S6R59/FlhRYoEglJrPMeBy/lYzSszcGSNaRRzU1FIiZcEmayeOqX7BcD6XSc74
         h7jA==
X-Gm-Message-State: AO0yUKXausjHrLO4jU4XIeOFvntjTXWif/IOBX1kVDUCNDrhJ1t3qMXd
        +Cb4svQcM/3cqjQ7v1XU0FPrsmVNzucw+fpDe2Y=
X-Google-Smtp-Source: AK7set88GHGvcNPhPkrAwGoIKwM+9AaXp2qlR9nsgSF2ertjsvvggvYD2qLb7IbyHXN5DPsY44AJiw==
X-Received: by 2002:a05:6a20:9d90:b0:b8:e33c:f160 with SMTP id mu16-20020a056a209d9000b000b8e33cf160mr1565325pzb.0.1674784408722;
        Thu, 26 Jan 2023 17:53:28 -0800 (PST)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id g5-20020a1709026b4500b0018b025d9a40sm1588184plt.256.2023.01.26.17.53.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 26 Jan 2023 17:53:28 -0800 (PST)
Date:   Fri, 27 Jan 2023 01:53:25 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     David Matlack <dmatlack@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org
Subject: Re: [PATCH] KVM: x86/mmu: Replace tdp_mmu_page with a bit in the role
Message-ID: <Y9MulRF8QXEiGIog@google.com>
References: <20230126210401.2862537-1-dmatlack@google.com>
 <Y9MA0+Q/rO5Voa0D@google.com>
 <CALzav=dXWkX7aFga=T9fk1auXcArECLXMOEotWnGODeGVL44iQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CALzav=dXWkX7aFga=T9fk1auXcArECLXMOEotWnGODeGVL44iQ@mail.gmail.com>
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

On Thu, Jan 26, 2023, David Matlack wrote:
> On Thu, Jan 26, 2023 at 2:38 PM Sean Christopherson <seanjc@google.com> wrote:
> >
> > On Thu, Jan 26, 2023, David Matlack wrote:
> > > Link: https://lore.kernel.org/kvm/b0e8eb55-c2ee-ce13-8806-9d0184678984@redhat.com/
> >
> > Drop the trailing slash, otherwise directly clicking the link goes sideways.
> 
> I don't have any problem clicking this link, but I can try to omit the
> trailing slash in the future.

Ha!  Figured out what happens.  Gmail gets confused and thinks the forward slash
indiciates a continuation, e.g. the original mail sends me to:

  https://lore.kernel.org/kvm/b0e8eb55-c2ee-ce13-8806-9d0184678984@redhat.com/Signed-off-by

I bet the above now works because there's whitespace. For giggles....

https://lore.kernel.org/kvm/b0e8eb55-c2ee-ce13-8806-9d0184678984@redhat.com/
will_it_blend
