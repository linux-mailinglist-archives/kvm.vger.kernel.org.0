Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F134A5E6B12
	for <lists+kvm@lfdr.de>; Thu, 22 Sep 2022 20:36:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230470AbiIVSgx (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 22 Sep 2022 14:36:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39286 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230293AbiIVSgv (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 22 Sep 2022 14:36:51 -0400
Received: from mail-pg1-x530.google.com (mail-pg1-x530.google.com [IPv6:2607:f8b0:4864:20::530])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DF98CB0B06
        for <kvm@vger.kernel.org>; Thu, 22 Sep 2022 11:36:50 -0700 (PDT)
Received: by mail-pg1-x530.google.com with SMTP id b5so1833714pgb.6
        for <kvm@vger.kernel.org>; Thu, 22 Sep 2022 11:36:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date;
        bh=xeXyRnO8u8qVtwLZvI7KUvwb1dqHZEKqSauwoLHPeRc=;
        b=MsUFO6ksxwknDRS63WqbV1UjW5K0WfIUl0VExSg8G7NqaDX7mcUTMOcEiNxFOV+BhQ
         9a5D0Z6m6byKH5HgDjTwYnobNTPmvpHk9Uth/EYtfLi+OZFc9ywioBJpjiHi9L9mYmXZ
         eEPgLM+ccNS9qG2X2Up6IHrLG3vW5Pg5Z41D6QPOKV3WuGpbDFWOel4ih1Lx4m6P8aVW
         Su7zzz9KdReFVAb75/XJ6kniOw2XOaT9bqIOSRm7j6mxeji68AdP4qslI9vbpw6zmyrX
         rGeV8cOlXHyyITUwqyINLkBwMewVO9AEPMsfCU8i4zjDVYEfgOl99urBhq+iGMWgCnVy
         s7qQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date;
        bh=xeXyRnO8u8qVtwLZvI7KUvwb1dqHZEKqSauwoLHPeRc=;
        b=0BA0xqES/K7iF8BwNb6mjy3DI88mkV9xnO3r6lqGv2y/Wbit3XOPQKcVRovHJNA34N
         61/A7E11ggWxW1m57+0PkuN2Un48K57CZvSF8e7OMNVkBIXbAmRItolw3Ou3JN9BdkI/
         b1Jrj0tY5scnwyjNwnp1PpXggOlIo2f34D7sV7XyOXFOIESsVBkLUbLYe8CUpWpitBpg
         GD1eyZ4dTDPQyrTaSJ9YLxFECCOkmlr17mX88AllS7hpGB6u2sZ/wPZjClZh6mKCvdOY
         km282wYAAFO2U/CTJ6WzRR2ZSgisT7kSM3VmaDskZKMwhFSJ0L1olJdXEEemcKISvFXx
         7PmQ==
X-Gm-Message-State: ACrzQf27zjjeOW+Fj9Aw3BbKYzFRze3Nz890GBpIwAAMSP/9Mlam1PYV
        uuKqkCW5WUh1vJ4QqHwwWnl3ag==
X-Google-Smtp-Source: AMsMyM4f26ESxlQUpfb5qvMMZlT9zu+S1MjQerkiPWv/MbVFfr/KRg36FzW9sYRc0FqcUzIsoDWH4A==
X-Received: by 2002:a05:6a00:174f:b0:537:6845:8b1a with SMTP id j15-20020a056a00174f00b0053768458b1amr5104834pfc.68.1663871810305;
        Thu, 22 Sep 2022 11:36:50 -0700 (PDT)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id k81-20020a628454000000b0054cd16c9f6bsm4739560pfd.200.2022.09.22.11.36.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 22 Sep 2022 11:36:49 -0700 (PDT)
Date:   Thu, 22 Sep 2022 18:36:46 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Ricardo Koller <ricarkol@google.com>
Cc:     kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu,
        andrew.jones@linux.dev, pbonzini@redhat.com, maz@kernel.org,
        alexandru.elisei@arm.com, eric.auger@redhat.com, oupton@google.com,
        reijiw@google.com, rananta@google.com, bgardon@google.com,
        dmatlack@google.com, axelrasmussen@google.com
Subject: Re: [PATCH v8 09/14] KVM: selftests: Use the right memslot for code,
 page-tables, and data allocations
Message-ID: <YyyrPpDwwZSkzGu6@google.com>
References: <20220922031857.2588688-1-ricarkol@google.com>
 <20220922031857.2588688-10-ricarkol@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220922031857.2588688-10-ricarkol@google.com>
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

On Thu, Sep 22, 2022, Ricardo Koller wrote:
> Now that kvm_vm allows specifying different memslots for code, page tables,
> and data, use the appropriate memslot when making allocations in
> common/libraty code. Change them accordingly:
> 
> - code (allocated by lib/elf) use the CODE memslot
> - stacks, exception tables, and other core data pages (like the TSS in x86)
>   use the DATA memslot
> - page tables and the PGD use the PT memslot
> - test data (anything allocated with vm_vaddr_alloc()) uses the TEST_DATA
>   memslot
> 
> No functional change intended. All allocators keep using memslot #0.
> 
> Cc: Sean Christopherson <seanjc@google.com>
> Cc: Andrew Jones <andrew.jones@linux.dev>
> Signed-off-by: Ricardo Koller <ricarkol@google.com>
> ---

Reviewed-by: Sean Christopherson <seanjc@google.com>
