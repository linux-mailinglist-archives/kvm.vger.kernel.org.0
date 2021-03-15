Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6ABB733C94D
	for <lists+kvm@lfdr.de>; Mon, 15 Mar 2021 23:24:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232263AbhCOWYB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 15 Mar 2021 18:24:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41330 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232290AbhCOWXa (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 15 Mar 2021 18:23:30 -0400
Received: from mail-pf1-x431.google.com (mail-pf1-x431.google.com [IPv6:2607:f8b0:4864:20::431])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B3DBFC061764
        for <kvm@vger.kernel.org>; Mon, 15 Mar 2021 15:23:30 -0700 (PDT)
Received: by mail-pf1-x431.google.com with SMTP id o3so2827734pfh.11
        for <kvm@vger.kernel.org>; Mon, 15 Mar 2021 15:23:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=76pLO4ynd5ZWyHNZ5ZDnbUyusicrWJvIzQ5SsEfOQDk=;
        b=airqsXzB/pgup9ugIMokOYOuKc7ZnQPtpIwDXFzpRbFsDaCkP1G8y4Exe06QF6l+hd
         k7GGyjxmpCS+N8LxgaxVkErbGTuglwMmT442b3UL14DvdSXAE0DQQG4bEJzaEUWyEqMU
         /48gWqX0Y9tvWyQ7fMkNcuOwMqwk7aDAy/wCP2Wp0lhKACYfP+dNRuwzwc9pVCXlIG3L
         Pcwi0I8n/Br+aUTJP3BM1796/zCy2pUhwBtFQffBrFz0k8LVLxC/FmQk4nDbrGL4SzZH
         W5tsoTvgZRxpSeqxRDY2m6gXmjcrNVishHe56MgyoPTWALrd1ClF+ylfl0Oo5XCaaVZo
         t74g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=76pLO4ynd5ZWyHNZ5ZDnbUyusicrWJvIzQ5SsEfOQDk=;
        b=abU+oeDjptyNyZHmLHiUSksffQKml+D1gvfamMjWeKpjjLeXE4qjB5AJyhyyGqhxbx
         GgsfK3SAdD7fUA0gn89kMoU7L0gLoq34ITu0PHaxtmbaabQWhRGDaArIpLLlNmmQ73LK
         1U2oUE3IoeeAWsm9VRvzK+pGl3Qd9u/pgRnFKtpJmJ0jYpv+polw8mF5IET19/LIdH1S
         gXZ4JEXi46fstp1dW4p5Xbvqfhk+cklh/BWLuEut/W611eJgqn9UpJF+H03pUx8mBUuW
         YgXQU/UjNsXYDcJG6Q7MsP+o/8L9UG8ObhmnsSYz6JzxFmpcHYsz5T/j6LjzNng7Tlnz
         tlOg==
X-Gm-Message-State: AOAM530nMqIi+xmFh7/dQXtOlmVMZCW2NC5S1YuH1pQxl49sVemezSLW
        uysRg3TPH7edgeHp2b0WW8Yqyw==
X-Google-Smtp-Source: ABdhPJzErUir6olHz3A1ngb1qVLxTGkxO4C5zuXPoJPawtyx7X02V/kHW2KtzInAJJ84hCgOH6wwSw==
X-Received: by 2002:a62:37c6:0:b029:1f0:abe0:8d1c with SMTP id e189-20020a6237c60000b02901f0abe08d1cmr12130769pfa.23.1615847010099;
        Mon, 15 Mar 2021 15:23:30 -0700 (PDT)
Received: from google.com ([2620:15c:f:10:3d60:4c70:d756:da57])
        by smtp.gmail.com with ESMTPSA id s76sm14738422pfc.110.2021.03.15.15.23.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 15 Mar 2021 15:23:29 -0700 (PDT)
Date:   Mon, 15 Mar 2021 15:23:24 -0700
From:   Sean Christopherson <seanjc@google.com>
To:     Ben Gardon <bgardon@google.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Peter Shier <pshier@google.com>,
        Jim Mattson <jmattson@google.com>,
        kernel test robot <lkp@intel.com>
Subject: Re: [PATCH v2 4/4] KVM: x86/mmu: Store the address space ID in the
 TDP iterator
Message-ID: <YE/eXP60IVki7csd@google.com>
References: <20210315182643.2437374-1-bgardon@google.com>
 <20210315182643.2437374-5-bgardon@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210315182643.2437374-5-bgardon@google.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Mar 15, 2021, Ben Gardon wrote:

Missing "From: Sean Christopherson <seanjc@google.com>", i.e. the commit in your
local tree needs "git commit --amend --author="Sean Christopherson <seanjc@google.com>".
Alternatively, you could just erase my SOB ;-)

> Store the address space ID in the TDP iterator so that it can be
> retrieved without having to bounce through the root shadow page.  This
> streamlines the code and fixes a Sparse warning about not properly using
> rcu_dereference() when grabbing the ID from the root on the fly.
> 
> Reported-by: kernel test robot <lkp@intel.com>
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> Signed-off-by: Ben Gardon <bgardon@google.com>
> ---
