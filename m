Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 50B9376A2E8
	for <lists+kvm@lfdr.de>; Mon, 31 Jul 2023 23:34:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229537AbjGaVe4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 31 Jul 2023 17:34:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48950 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229469AbjGaVez (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 31 Jul 2023 17:34:55 -0400
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 94C681FC9
        for <kvm@vger.kernel.org>; Mon, 31 Jul 2023 14:34:27 -0700 (PDT)
Received: by mail-yb1-xb49.google.com with SMTP id 3f1490d57ef6-d27ac992539so3727135276.3
        for <kvm@vger.kernel.org>; Mon, 31 Jul 2023 14:34:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1690839264; x=1691444064;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=M5PijTkKav0RbsyrIfhOctghYsaDBtN0ksxtjkS2E3o=;
        b=C0RbbGvOmjlaHwoKOsVpABwkCgeBUojMJFqgHU3e7vn15TlMqi1/GNvhNBr/DnEblT
         S8ZKcXn9FhHXU6Yj2FL9z3P28LftMDsFJINcnv7hMEfCMCiavOoY20xAYb2rKktsEXOQ
         z5mBH169/JCPSbEIjZKLnQSMZ2Lld4QepdWvrkyww+Ss+NROk6emb1u+3nQvPpplchJb
         r3rGneDiJH1dEhxqhZbiyHtJIwY5il8SoHkjYv0GA2OczLFUEaI5dmW2MdSUO6wdGWBp
         FWCteCKEOMuivXPiXwICBYH89yRdMlkWwlrrSGNVh/UZS9rCQIXS+3ZUJNbqlJ3Kl2Wv
         AGPg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1690839264; x=1691444064;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=M5PijTkKav0RbsyrIfhOctghYsaDBtN0ksxtjkS2E3o=;
        b=ZKCiquPxAjh9R6WNfLg/hvI7Ww/TqNx1ywSbuh9Y24RvFE7wmPVrQxPo0z5IOjFIdb
         a/T68B7Hvl8JV27Ty2YXChhebQI/IBchhyXLdnl3vMw+H3kv+A9LPKL0rpuUm215fcQN
         HBXERcjXopUMUGDuX6q4uYA5KAOIgYLUfOk98lWKzcADb3tddgx1E5sJXDbpTxCqNaaQ
         XkffwF1ei8SDDKlPC6KeUGleeEcBMoMD6pzxGpM5bOobOd7iHPqHlmXTkzo25BWoy6ef
         o0M6IDjxkPnn/xBuBLKcPgQNZuUBWGn0Exi8iAW/pAuKxx9OVsxGQ1i4xYzo4aPVLIwW
         hR0w==
X-Gm-Message-State: ABy/qLbLGIOuo0gJ5vzPtkGtfMu5s+vjbNIzpC3cWRtffVXvCAgHD+wG
        UhizMEKFLi1v+oG3vy7WWTpzxGLJNyE=
X-Google-Smtp-Source: APBJJlHV+T8Txgl9BRU07jWBBYiAgSiNRp0sLaahO8lqY0D8EU4ErMu5NzAPx8L+vujcfg4Us62xnatJqHs=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a25:2042:0:b0:cb6:6c22:d0f8 with SMTP id
 g63-20020a252042000000b00cb66c22d0f8mr66923ybg.4.1690839263932; Mon, 31 Jul
 2023 14:34:23 -0700 (PDT)
Date:   Mon, 31 Jul 2023 14:34:22 -0700
In-Reply-To: <ZMgma0cRi/lkTKSz@x1n>
Mime-Version: 1.0
References: <20230731162201.271114-1-xiaoyao.li@intel.com> <20230731162201.271114-5-xiaoyao.li@intel.com>
 <ZMgma0cRi/lkTKSz@x1n>
Message-ID: <ZMgo3mGKtoQ7QsB+@google.com>
Subject: Re: [RFC PATCH 04/19] memory: Introduce memory_region_can_be_private()
From:   Sean Christopherson <seanjc@google.com>
To:     Peter Xu <peterx@redhat.com>
Cc:     Xiaoyao Li <xiaoyao.li@intel.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        David Hildenbrand <david@redhat.com>,
        Igor Mammedov <imammedo@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
        Richard Henderson <richard.henderson@linaro.org>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        Markus Armbruster <armbru@redhat.com>,
        Eric Blake <eblake@redhat.com>,
        "Daniel =?utf-8?B?UC4gQmVycmFuZ8Op?=" <berrange@redhat.com>,
        "Philippe =?utf-8?Q?Mathieu-Daud=C3=A9?=" <philmd@linaro.org>,
        Chao Peng <chao.p.peng@linux.intel.com>,
        Michael Roth <michael.roth@amd.com>, isaku.yamahata@gmail.com,
        qemu-devel@nongnu.org, kvm@vger.kernel.org
Content-Type: text/plain; charset="us-ascii"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,
        USER_IN_DEF_DKIM_WL autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Jul 31, 2023, Peter Xu wrote:
> On Mon, Jul 31, 2023 at 12:21:46PM -0400, Xiaoyao Li wrote:
> > +bool memory_region_can_be_private(MemoryRegion *mr)
> > +{
> > +    return mr->ram_block && mr->ram_block->gmem_fd >= 0;
> > +}
> 
> This is not really MAP_PRIVATE, am I right?  If so, is there still chance
> we rename it (it seems to be also in the kernel proposal all across..)?

Yes and yes.

> I worry it can be very confusing in the future against MAP_PRIVATE /
> MAP_SHARED otherwise.

Heh, it's already quite confusing at times.  I'm definitely open to naming that
doesn't collide with MAP_{PRIVATE,SHARED}, especially if someone can come with a
naming scheme that includes a succinct way to describe memory that is shared
between two or more VMs, but is accessible to _only_ those VMs.
