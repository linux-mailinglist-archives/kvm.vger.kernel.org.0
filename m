Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4377B58B037
	for <lists+kvm@lfdr.de>; Fri,  5 Aug 2022 21:16:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237692AbiHETQO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 5 Aug 2022 15:16:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35436 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237004AbiHETQO (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 5 Aug 2022 15:16:14 -0400
Received: from mail-pj1-x102b.google.com (mail-pj1-x102b.google.com [IPv6:2607:f8b0:4864:20::102b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4618EEE15
        for <kvm@vger.kernel.org>; Fri,  5 Aug 2022 12:16:13 -0700 (PDT)
Received: by mail-pj1-x102b.google.com with SMTP id s5-20020a17090a13c500b001f4da9ffe5fso9108752pjf.5
        for <kvm@vger.kernel.org>; Fri, 05 Aug 2022 12:16:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc;
        bh=klakVaaOLIsvpoZrygnJlfJlT1huxnKlBQo5LLDccT0=;
        b=KztTU0CGzo8RZxSH9h2EG/vhuCLha+RnkVNwBawBp4PyFeKnDsCASgdOZM7ka8gPO8
         0aOn0KyDf6ShfLZQLnfKCV1m+CXP9mb8we2e8eJrYLrhonuSaVhSwewwShCD+2GzEaGN
         ROJmsmWk2TYxExwin42C++5WEdjwZa2Zs/+TIFTz+I7vn5m0l1aD5oOFqihkRFaac7ci
         QLeGZr/sekVnxgyi7rSPNEsG/WzmjdtY1LJ57trcg/kk9BBNF6pv3NbsHNFNWFFkoEm6
         Ud8CBkGAg+v3clfGOy4z7+YDyPrNK1Z7J8tak+VlP7GrfbttG2qCzE4xB1SVaJ93+KvM
         NMhA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc;
        bh=klakVaaOLIsvpoZrygnJlfJlT1huxnKlBQo5LLDccT0=;
        b=SEPI/HYgQMScqF52kX8UerhwU3FLWyCVzh9TmxLc8xHs7dpTkbDyo8Bc9hcyYB2jm/
         y6AaKWKO9NVSAsC/DGIZJcFy8hDTPFASE0pwEALktIHGaLLxHfRG0BkLgkkIbjb4uNRr
         7bZcc2D8n2+qdOgyXt7Jxa8iSxyobnWzJI5nzLmV3QxCUKDhQd5wb9Vs4cCvGmCbb0V0
         YIh0tGQt42HeCKtg+FHhEwGfXb2ZNuKqm353iujUZnIZqBOZq+8d40qwjWcSqFMfFDxM
         2pBbcxW/m9Z85jQ1x1I6qjHljbhmizhkRxWgwl4o7Rae7W7HC4wvGnnPAoKtVXuY3NDX
         Y5MA==
X-Gm-Message-State: ACgBeo2EtrP5vm3JJFY32hBEpjVkQZU4g1KUvXe9zkYm2kPXh/uPEEd+
        wNvZXKIZdEnW5YjVbckbBJYvMQ==
X-Google-Smtp-Source: AA6agR67xr5fuSDKlSClrno5f/s39cuKPOzApbwNF7pDrxMkrGuHt6ds4ojmZXtiCNt9NFNl3CCnkw==
X-Received: by 2002:a17:902:d2c6:b0:16e:d285:c602 with SMTP id n6-20020a170902d2c600b0016ed285c602mr8119987plc.81.1659726972589;
        Fri, 05 Aug 2022 12:16:12 -0700 (PDT)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id t4-20020a63eb04000000b003db7de758besm1843132pgh.5.2022.08.05.12.16.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 05 Aug 2022 12:16:11 -0700 (PDT)
Date:   Fri, 5 Aug 2022 19:16:08 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Oliver Upton <oliver.upton@linux.dev>
Cc:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        Oliver Upton <oupton@google.com>
Subject: Re: [PATCH v3 5/6] KVM: Actually create debugfs in kvm_create_vm()
Message-ID: <Yu1seNDDwUDEAEL4@google.com>
References: <20220720092259.3491733-1-oliver.upton@linux.dev>
 <20220720092259.3491733-6-oliver.upton@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220720092259.3491733-6-oliver.upton@linux.dev>
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,FSL_HELO_FAKE,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Jul 20, 2022, Oliver Upton wrote:
> From: Oliver Upton <oupton@google.com>
> 
> Doing debugfs creation after vm creation leaves things in a
> quasi-initialized state for a while. This is further complicated by the
> fact that we tear down debugfs from kvm_destroy_vm(). Align debugfs and
> stats init/destroy with the vm init/destroy pattern to avoid any
> headaches.
> 
> Note the fix for a benign mistake in error handling for calls to
> kvm_arch_create_vm_debugfs() rolled in. Since all implementations of
> the function return 0 unconditionally it isn't actually a bug at
> the moment.

Heh, now I feel like you're being intentionally mean.  Usually I discourage
play-by-play descriptions, but in this case being explicit saves readers a lot
of staring.

And I would argue it's still a bug, it's just that the bug can't be hit and so
can't cause issues.  E.g.

  Opportunistically fix a benign bug where KVM would return "i" instead
  of "ret" if kvm_arch_create_vm_debugfs() failed.  The bug is benign as
  all implementations of the function return 0 unconditionally.

> Lastly, tear down debugfs/stats data in the kvm_create_vm_debugfs()
> error path. Previously it was safe to assume that kvm_destroy_vm() would
> take out the garbage, that is no longer the case.
> 
> Signed-off-by: Oliver Upton <oupton@google.com>
> ---

Reviewed-by: Sean Christopherson <seanjc@google.com>
