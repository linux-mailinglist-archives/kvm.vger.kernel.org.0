Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BFD4457A866
	for <lists+kvm@lfdr.de>; Tue, 19 Jul 2022 22:40:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240174AbiGSUkr (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 19 Jul 2022 16:40:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55574 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240144AbiGSUkq (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 19 Jul 2022 16:40:46 -0400
Received: from mail-pj1-x102a.google.com (mail-pj1-x102a.google.com [IPv6:2607:f8b0:4864:20::102a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AB85328E3A
        for <kvm@vger.kernel.org>; Tue, 19 Jul 2022 13:40:45 -0700 (PDT)
Received: by mail-pj1-x102a.google.com with SMTP id b10so4924870pjq.5
        for <kvm@vger.kernel.org>; Tue, 19 Jul 2022 13:40:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=Y5fwh5XQ1eQ19E2Z8DxxEP57ot41iP+HZxIKEkeAu7k=;
        b=Gg1iGwaFzeNXWLYH3o7HDYdbOCx4YcdI19btWPVG9za5H/8vIXfD59H2snLGuj7tBm
         X8zOltVQGm+kXZztqubzj8hap2L1wiCMWZb8ON1NV34KFIUtowCVaQNU4YjYJmEqoxIc
         GwluNfF4a73tE0YFGBqyP6CGaP/l8PH30NjqTNTcixgexwrhhC4RYmnUWUvabYZsnimL
         5nTjBYctDEN1kG7Dk9FF+zi+0g0XgXzqJCYwfXLuktyljPrNOXldpD4XrI7skoZGpbHq
         WthL/PFwmSwXuilw7qb16uw6vKakYq578EXI4hl36UikZVmL4lrLLSYHntEt0fAoI01A
         tv/w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=Y5fwh5XQ1eQ19E2Z8DxxEP57ot41iP+HZxIKEkeAu7k=;
        b=pvQ7wFtEn9nrvpx7ZBXSmwwSFv5qpyk9xjhUjbi0jVTo3rnae5N5PpNZyEdSNQonwY
         UFCCWNFZBhkefqXgjE71NcvI1YIyEt3EZTRKUSxHi+A9Jjbi5aLMNQGNfjVp0/xh6iCK
         /pZD4nGOXoEKXNX4bSx2D4VWxP8cswcTPJFUUXnYTggnyH8Sa/g8LbajS0uVtXDTcsNN
         JVePpj3bdiHFvrxZwqTxeAuYdf6R4d/C6ECAVe/38LaNQssj8j+H45H8mgKOI0U9ZRYA
         tl6tDMYBtZRZo/wCIEWAe8zyxwWvbhrFwcpDdWGMYToE/QtEvEUEx8h7qdTrSCYuB4sD
         BR8w==
X-Gm-Message-State: AJIora/PxxialhkqWCS0rz+epDoGHXiBNYLe8UA+MvrZj/+2VcU2o271
        somWzxBBzcuAM9W5/ZUfZP/4+A==
X-Google-Smtp-Source: AGRyM1vf3dbslbsbY2ic8F1U4mypBluA6i60ryQkUBk7ewKA1RFGBbhLGjzJ59JOrn6udnWcR3irSQ==
X-Received: by 2002:a17:90a:7409:b0:1ef:8e95:c861 with SMTP id a9-20020a17090a740900b001ef8e95c861mr1323452pjg.115.1658263244890;
        Tue, 19 Jul 2022 13:40:44 -0700 (PDT)
Received: from google.com (123.65.230.35.bc.googleusercontent.com. [35.230.65.123])
        by smtp.gmail.com with ESMTPSA id u1-20020a634701000000b004168945bdf4sm10156947pga.66.2022.07.19.13.40.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 19 Jul 2022 13:40:44 -0700 (PDT)
Date:   Tue, 19 Jul 2022 20:40:40 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Lai Jiangshan <jiangshanlai@gmail.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Maxim Levitsky <mlevitsk@redhat.com>,
        Lai Jiangshan <jiangshan.ljs@antgroup.com>
Subject: Re: [PATCH 11/12] KVM: X86/MMU: Remove mmu_pages_first() and
 mmu_pages_next()
Message-ID: <YtcWyEdSnMN5M9vn@google.com>
References: <20220605064342.309219-1-jiangshanlai@gmail.com>
 <20220605064342.309219-12-jiangshanlai@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220605064342.309219-12-jiangshanlai@gmail.com>
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

On Sun, Jun 05, 2022, Lai Jiangshan wrote:
> From: Lai Jiangshan <jiangshan.ljs@antgroup.com>
> 
> Use i = 0 andd i++ instead.

s/andd/and, but even better would be to write a full changelog.

  Drop mmu_pages_{next,first}() and open code their now trivial
  implementations in for_each_sp(), the sole caller.
