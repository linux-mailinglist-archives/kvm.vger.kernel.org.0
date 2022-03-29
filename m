Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 212324EB5E0
	for <lists+kvm@lfdr.de>; Wed, 30 Mar 2022 00:28:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237084AbiC2WaC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 29 Mar 2022 18:30:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37100 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234969AbiC2WaA (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 29 Mar 2022 18:30:00 -0400
Received: from mail-pl1-x633.google.com (mail-pl1-x633.google.com [IPv6:2607:f8b0:4864:20::633])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 04D4E637A
        for <kvm@vger.kernel.org>; Tue, 29 Mar 2022 15:28:16 -0700 (PDT)
Received: by mail-pl1-x633.google.com with SMTP id i11so7602426plg.12
        for <kvm@vger.kernel.org>; Tue, 29 Mar 2022 15:28:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=vjcQWfLhbG0uWlWmdRXNd421Er7E9z2hWWjFUh0KLac=;
        b=OGLO94A5JWnv/1HgSvDkWtlZJ3KU0e1HVGPbLk1//DxgmJp5CzBFGqzrXpYKOet3CI
         MRdJXVjjM/YvN6nR0cdWOtpHtnrIaBS8AGoqWHODJ1D3gmNv7gKi/29MLo/3pNmq8BXr
         B1Is/E6Y3bdgDcyCcoaVmdiPfJgUdpKWNMbxpMxQlSHg1/wrvj1TvGYhWtfUV0Sxrbw2
         LPm/I0nN8vCvFXQf+AVGIqSE/SU8aLItoAQFJ626eiC4xjbHLmSNGjuk2t0eQYd+xAcx
         dsmBEMPa3ZexRfAacNlqhWctL1dkGfh6QS9hihyJt2JJNu/Yhblhckoiyax1sVGHsUJG
         Mh9w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=vjcQWfLhbG0uWlWmdRXNd421Er7E9z2hWWjFUh0KLac=;
        b=ksBCLEYSJI1MePuujxTS8G9Y56ms6fgM8oCC/HJne6wCIpsO1DGgOz/rDwR2/oGAef
         TVk6Ctc7G+/27eFnlb7tsdkaEl1vTHg4Hup8jdNBp6HAEr1Ww22He3ziiOLcc0BesAit
         ZXZJ7QA3ZeRj49bmFzhj7Yu8h8rFD76T6HIvkzdzVkdxEh147jAkfvr8vEQbp8pI8znd
         a3b1HBKJM8FyBZmGRWX8n+UPLgowYHgoSg3wwNZvsN3bBEy6/EJbU1TXjT/Fi9uTZ2F5
         R7NFszAfHXXBXdV5HRHD8ML4zM8b2DPVJvfm7De9ntxmexiQhPTS9HrEfg7Gous0rYJ+
         FpbQ==
X-Gm-Message-State: AOAM5330e1FNUGKMpBxpiyHsP1wVUMx95bMQtHArmo8x/pY6TFNHSsc7
        IL78JOg/DQr1nFf3bzjnP41FkQ==
X-Google-Smtp-Source: ABdhPJzgAPJDsue3uchTl3K7kEiko/T1kxeOR+TSgffxAJ/PrZ1l3QiItWqukpVDfkpMLPfIyYOVrQ==
X-Received: by 2002:a17:902:e2c3:b0:155:c75c:335d with SMTP id l3-20020a170902e2c300b00155c75c335dmr27420796plc.33.1648592895356;
        Tue, 29 Mar 2022 15:28:15 -0700 (PDT)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id k62-20020a17090a4cc400b001c7ea7f487asm3868557pjh.39.2022.03.29.15.28.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 29 Mar 2022 15:28:14 -0700 (PDT)
Date:   Tue, 29 Mar 2022 22:28:10 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Mingwei Zhang <mizhang@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Ben Gardon <bgardon@google.com>,
        David Matlack <dmatlack@google.com>,
        Jing Zhang <jingzhangos@google.com>,
        Peter Xu <peterx@redhat.com>,
        Yosry Ahmed <yosryahmed@google.com>
Subject: Re: [PATCH v2 3/4] KVM: x86/mmu: explicitly check nx_hugepage in
 disallowed_hugepage_adjust()
Message-ID: <YkOH+k7sE2x5wz+f@google.com>
References: <20220323184915.1335049-1-mizhang@google.com>
 <20220323184915.1335049-5-mizhang@google.com>
 <YkOHDeh8JgWc8iFb@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YkOHDeh8JgWc8iFb@google.com>
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

On Tue, Mar 29, 2022, Sean Christopherson wrote:
> > Fixes: b8e8c8303ff2 ("kvm: mmu: ITLB_MULTIHIT mitigation")
> > Cc: stable@vger.kernel.org
> 
> I vote to keep the Fixes tag, but drop the Cc: stable@ and NAK any MANUALSEL/AUTOSEL
> for backporting this to stable trees.  Yes, it's a bug, but the NX huge page zapping
> kthread will (eventually) reclaim the lost performance.  On the flip side, if there's
> an edge case we mess up (see below), then we've introduced a far worse bug.

Doh, that's wrong.  The whole problem is that these pages aren't on the NX list...
I think I'd still vote to not send this to stable, but it's a weak vote.
