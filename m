Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 98F7860EBDE
	for <lists+kvm@lfdr.de>; Thu, 27 Oct 2022 00:52:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233880AbiJZWwr (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 26 Oct 2022 18:52:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54680 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233836AbiJZWwp (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 26 Oct 2022 18:52:45 -0400
Received: from mail-pl1-x632.google.com (mail-pl1-x632.google.com [IPv6:2607:f8b0:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 623F2205F6
        for <kvm@vger.kernel.org>; Wed, 26 Oct 2022 15:52:44 -0700 (PDT)
Received: by mail-pl1-x632.google.com with SMTP id d24so15693214pls.4
        for <kvm@vger.kernel.org>; Wed, 26 Oct 2022 15:52:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=xaB3W+Av0Ce62OmvQNhXvaJnJ7ao24amn5LSJuDZq94=;
        b=UAF5Hz3sgFGP0W93X5oL6Lr5V1c91U+QQriOD8CD9N3dHbliBMqlnGpD+GAmSESiJT
         N395ukbhECC807f4zQYTsjdtXE2MgQOT9+xisB3+my9yOLLrOjQzH1Qp2fqL3hrvi7gb
         Ro8YyG7F2OLKJlQ2H9EFk8tgjtW6qlFLBtCrheRhKqlM1Jg/HKGRS0luh0Wj6lyyytnq
         2ElqzCUXGmAlo5wXLtPPkWYN9cCGfLuBgJImGP8SlTc26xHWQ9BO2G+7nhtS+qqGt0E9
         dtQMMi/vGkbU2eN1CVIawb7MgaXADalWnApn8vBCEGKPUuHpKIpmZl1rAJSPpuCDoUuH
         4yZw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=xaB3W+Av0Ce62OmvQNhXvaJnJ7ao24amn5LSJuDZq94=;
        b=35GzACwT0vcu5/nwjmAAab+qNmnWTChYQtR8em6WO7e53/E/Dm7ijr/64tzBbHe9VR
         yTm19P1gGf1w7uxlO7EoW8pV+rLT9CakElHuHUgWGFMv8KkD4tHvnKXIxNCT3qPBoLB9
         BhhJtwuM6o73IfWCzIhj6WDCi+G+JG9QpVYynUVLAHe72c/RkZARMYMqRHU7t7JNZq6o
         isJDp3IJTedBIPDPtgz1x6oqQGsvUq1/7TVaHZO4IV91TU2WTfMcoKltRq5wKi4aJJ9Y
         7g2g07TT7JqR8CdS7GIhk5fBxaFdmumwsYdjySPJQ8uymRRRcWp4XlOo7kAJ23rIaBXd
         Wi7A==
X-Gm-Message-State: ACrzQf2Ad5FJSxLDspBC8u1t6pT+v3Eaj1Q9V98uxzwgJfs+thQbbj8P
        3qHQRBVAdPKHc5SdUf+UP82jxw==
X-Google-Smtp-Source: AMsMyM7YvOe2AHIkuLCLS119xAkIiHdydw/kRw7SYZTul5yFSDz/PUFM1dktnYyr7rrjSBGxDBjVCA==
X-Received: by 2002:a17:90a:428e:b0:205:d5fe:e0b3 with SMTP id p14-20020a17090a428e00b00205d5fee0b3mr6593148pjg.33.1666824763740;
        Wed, 26 Oct 2022 15:52:43 -0700 (PDT)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id c3-20020a634e03000000b0046ec0ef4a7esm3283989pgb.78.2022.10.26.15.52.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 26 Oct 2022 15:52:43 -0700 (PDT)
Date:   Wed, 26 Oct 2022 22:52:40 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Peter Xu <peterx@redhat.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        John Hubbard <jhubbard@nvidia.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        David Matlack <dmatlack@google.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Andrea Arcangeli <aarcange@redhat.com>,
        "Dr . David Alan Gilbert" <dgilbert@redhat.com>,
        David Hildenbrand <david@redhat.com>,
        Linux MM Mailing List <linux-mm@kvack.org>,
        Mike Kravetz <mike.kravetz@oracle.com>
Subject: Re: [PATCH v4 0/4] kvm/mm: Allow GUP to respond to non fatal signals
Message-ID: <Y1m6OKbsRqq76qFF@google.com>
References: <20221011195809.557016-1-peterx@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221011195809.557016-1-peterx@redhat.com>
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

On Tue, Oct 11, 2022, Peter Xu wrote:
> Peter Xu (4):
>   mm/gup: Add FOLL_INTERRUPTIBLE
>   kvm: Add KVM_PFN_ERR_SIGPENDING
>   kvm: Add interruptible flag to __gfn_to_pfn_memslot()
>   kvm: x86: Allow to respond to generic signals during slow PF

Some shortlog/changelog nits, but nothing that warrants a v5.  If they get fixed
up when applying, yay, if not, the world won't end.
