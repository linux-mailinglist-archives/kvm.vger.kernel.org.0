Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7B5FC648B53
	for <lists+kvm@lfdr.de>; Sat, 10 Dec 2022 00:27:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229756AbiLIX1p (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 9 Dec 2022 18:27:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37174 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229573AbiLIX1l (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 9 Dec 2022 18:27:41 -0500
Received: from mail-pl1-x630.google.com (mail-pl1-x630.google.com [IPv6:2607:f8b0:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4A5F81039
        for <kvm@vger.kernel.org>; Fri,  9 Dec 2022 15:27:36 -0800 (PST)
Received: by mail-pl1-x630.google.com with SMTP id d3so6437354plr.10
        for <kvm@vger.kernel.org>; Fri, 09 Dec 2022 15:27:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=DccUrzXDPkCis38vl40UhxJ5RHRHNtvxDpHidEkCq9Y=;
        b=H44g5y/IIV95d5co2Z4RJ80CAJrIakiphXnpJDuxyCTmwxjW2Xsb1v+FNZwEB5CwZ+
         R/7eyOrOp6GBV2q4jr9eYCyKrivL088Auo5XLE1XqllSxnrDdVfvonJTAKha7tBF91zr
         fAALv5O/Y0Mnzcy6jEmrComNHO+LzlU8/Cua03tFMk+WM2eWKZ0k74w8+6Kob21S67D6
         qquea3A4/dHjXyt/2cV4iwcMU8kAzYr5NjiKTUX8nK9Q9RUrZ19vfQVeX/Kz2Y9x604V
         YT2wEslINvdkJdNZHtQdgcCpGkK4/MVoAJvwleZyN002ciZkm1/BsYOf5tvZjYQTmXlB
         s0og==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=DccUrzXDPkCis38vl40UhxJ5RHRHNtvxDpHidEkCq9Y=;
        b=M2pSetWltE3+Wh2rDDzhUpPHUPY/btKC0tNhe8Mo8iTwjPaClc5ZOMZ3N2DuWN7Y7l
         1Mv9v7kaf1mlLxmrIuFxq+RHfrEEvBNcXsUrkekcCptEJmLk02it0kbmLmaGNxEBOkQA
         H6oGxRzzPWBbTvfBapUGb//AiiS5IySMfbeVcb5JY8kP8Ekr06Yps6IsDMW8pHMwN66d
         uhBKosk5qGGpKua/cv6oYEneOvGxnDv9BzDPbM25DufMxZwl0J06lVv+G0gNsmzd12N1
         qj8j0y1CNm13uR0aIoXMnjLI4TQwdq0bzW9Fga32v+aJ8o4HrHPu/AGPBwF59FFjqIjp
         1tLA==
X-Gm-Message-State: ANoB5pm1s+RJVhzOMCz0VXwCm5zbL0A4HofRc5R/pJrqLfWZgt51ECmV
        BiO+81AelgnjaGRMMTbmo5CFxw==
X-Google-Smtp-Source: AA0mqf5jlwNYlvfVVCwCWyBbXcJay9azrH0LTuA27L7BleEJOj6IG2EKI0V8OQvzpZrB+tVOIgHLkA==
X-Received: by 2002:a17:903:2112:b0:189:e711:170 with SMTP id o18-20020a170903211200b00189e7110170mr6927687ple.64.1670628455689;
        Fri, 09 Dec 2022 15:27:35 -0800 (PST)
Received: from google.com (223.103.125.34.bc.googleusercontent.com. [34.125.103.223])
        by smtp.gmail.com with ESMTPSA id v3-20020a170902e8c300b00188a7bce192sm1791864plg.264.2022.12.09.15.27.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 09 Dec 2022 15:27:35 -0800 (PST)
Date:   Fri, 9 Dec 2022 15:27:31 -0800
From:   David Matlack <dmatlack@google.com>
To:     Ben Gardon <bgardon@google.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Peter Xu <peterx@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Vipin Sharma <vipinsh@google.com>
Subject: Re: [PATCH 7/7] KVM: x86/MMU: Move rmap_add() to rmap.c
Message-ID: <Y5PEVoZ0dFIBuuTG@google.com>
References: <20221206173601.549281-1-bgardon@google.com>
 <20221206173601.549281-8-bgardon@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221206173601.549281-8-bgardon@google.com>
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Dec 06, 2022 at 05:36:01PM +0000, Ben Gardon wrote:
> Move rmap_add() to rmap.c to complete the migration of the various rmap
> operations out of mmu.c.

IMO rmap_{can_add,add,remove}() should stay in mmu.c since the
implementation of those functions is all Shadow MMU book-keeping that
just needs to be done when the rmap changes.

I would be in favor of giving them more accurate and MMU-related names
though. e.g.

  rmap_can_add() -> kvm_vcpu_can_extend_rmap()
  rmap_add()     -> kvm_mmu_rmap_add()
  rmap_remove()  -> kvm_mmu_rmap_remove()
