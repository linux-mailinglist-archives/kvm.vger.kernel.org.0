Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 586CD485D3D
	for <lists+kvm@lfdr.de>; Thu,  6 Jan 2022 01:35:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343846AbiAFAft (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 5 Jan 2022 19:35:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40006 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343868AbiAFAfg (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 5 Jan 2022 19:35:36 -0500
Received: from mail-pf1-x432.google.com (mail-pf1-x432.google.com [IPv6:2607:f8b0:4864:20::432])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6342AC0611FD
        for <kvm@vger.kernel.org>; Wed,  5 Jan 2022 16:35:36 -0800 (PST)
Received: by mail-pf1-x432.google.com with SMTP id p37so1024061pfh.4
        for <kvm@vger.kernel.org>; Wed, 05 Jan 2022 16:35:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=YZVZgxC9JA3GLEhOQ5Scw73sf86RuKnvzNpEaW8qm0c=;
        b=ATQGuVbFvbCRvYCLvWSDF2jZfany/V380lG3tKYBRJ5Ipv4gW7B/E+l36QDR2qwvp8
         UR+MG3RSUFyKgQW96AWqOlG4yJ25/p3AJwYMqVVb4zt4gv2re8oeKANYnsFcJbydrXUR
         URGrJqWuWAEksRIyiOstw+7U6/T1VZZsVP0aMhomi1m3XtQavF+K6s+c3AXe/05+lnd1
         OuO5J6Efbxl8rYSkyye+i3WA3QvGOUQOyvAWvfEWTL1f/oESrholTsTgaKXfMJOYuCpn
         jaKGrj4ZIVxGPoupQSmxsschp5TEMwkQDP9yNF3W3Ul6zhvJh4qB7S2c9KonQGxdBBKP
         sLXA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=YZVZgxC9JA3GLEhOQ5Scw73sf86RuKnvzNpEaW8qm0c=;
        b=EGKKzurvNpsUlijC1/yFFqt6irIzuLBv+2++QQWgkuygycdPHF0YpoBOeZ/fAF4o9G
         nSs2j9HSJikb15AKFYpsdXe96ASs+RllN09RUjU+AXDfeqUthKKcY+7+LzVYCETrPil0
         AoDJxMyuM6eyrpBwLUyCjQWQAKyFdYzgtzG5ci9QvB0Xc38W5cdz8mOW/GplX3rEh3on
         4mZu9DrffHbQ4f0vrUPlksO2r10YK5EGZN6WKJYUcUBVUE/YaKwME5ibMoOF3fBY9Ncj
         oOJIZdF3nNQMzTFEhvCWKgHQrxFm3fYkVUuz/41HBkaLexJzuUcCl7yV6nAXE92IX4zw
         d3rA==
X-Gm-Message-State: AOAM5339yx44hm9SsGaTKevkH6oWUU7BIp/a/9+Y4Shc59tICPp0OWIj
        vQIKiJZHJkqtYXxXUzCvMcbS1g==
X-Google-Smtp-Source: ABdhPJxaIbzo5ceWLVmzJrnHZVdVWtpaI0czuDrJazlr/ybFjxljTPqB9xRanvkxECQXwO0QUr5OGw==
X-Received: by 2002:a05:6a00:21cd:b0:4bc:35e8:eaea with SMTP id t13-20020a056a0021cd00b004bc35e8eaeamr35197692pfj.23.1641429335749;
        Wed, 05 Jan 2022 16:35:35 -0800 (PST)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id h10sm167098pgi.56.2022.01.05.16.35.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 05 Jan 2022 16:35:35 -0800 (PST)
Date:   Thu, 6 Jan 2022 00:35:31 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     David Matlack <dmatlack@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
        Ben Gardon <bgardon@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Jim Mattson <jmattson@google.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Janis Schoetterl-Glausch <scgl@linux.vnet.ibm.com>,
        Junaid Shahid <junaids@google.com>,
        Oliver Upton <oupton@google.com>,
        Harish Barathvajasankar <hbarath@google.com>,
        Peter Xu <peterx@redhat.com>, Peter Shier <pshier@google.com>,
        "Nikunj A . Dadhania" <nikunj@amd.com>
Subject: Re: [PATCH v1 01/13] KVM: x86/mmu: Rename rmap_write_protect to
 kvm_vcpu_write_protect_gfn
Message-ID: <YdY5U1cC4Jvv3IgK@google.com>
References: <20211213225918.672507-1-dmatlack@google.com>
 <20211213225918.672507-2-dmatlack@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211213225918.672507-2-dmatlack@google.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Dec 13, 2021, David Matlack wrote:
> rmap_write_protect is a poor name because we may not even touch the rmap
> if the TDP MMU is in use. It is also confusing that rmap_write_protect
> is not a simpler wrapper around __rmap_write_protect, since that is the
> typical flow for functions with double-underscore names.
> 
> Rename it to kvm_vcpu_write_protect_gfn to convey that we are
> write-protecting a specific gfn in the context of a vCPU.
> 
> No functional change intended.
> 
> Signed-off-by: David Matlack <dmatlack@google.com>
> Reviewed-by: Ben Gardon <bgardon@google.com>
> Reviewed-by: Peter Xu <peterx@redhat.com>
> ---

Hopping on the R-b train...

Reviewed-by: Sean Christopherson <seanjc@google.com>
