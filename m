Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2D514523A90
	for <lists+kvm@lfdr.de>; Wed, 11 May 2022 18:46:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344937AbiEKQqn (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 11 May 2022 12:46:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60804 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230440AbiEKQqm (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 11 May 2022 12:46:42 -0400
Received: from mail-oi1-x22f.google.com (mail-oi1-x22f.google.com [IPv6:2607:f8b0:4864:20::22f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C17323E5E6
        for <kvm@vger.kernel.org>; Wed, 11 May 2022 09:46:41 -0700 (PDT)
Received: by mail-oi1-x22f.google.com with SMTP id i66so3346090oia.11
        for <kvm@vger.kernel.org>; Wed, 11 May 2022 09:46:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=W61e8Beb9C0rrwvWLXvghQlyTT+OB/E10KtzePQGPL4=;
        b=qC9ruXYKycYwwp57PRsAW7znvOrSbuqcW3DHuxmCh8nzW+k7q0H4EMctn5Db56iE9w
         BQUNkHYBv0e1KN8wS5B4c2X+nV6NdLj1L4+1sX5mdPb/HhrVcO7hftDDTa6Ivf8VhygV
         zYT2wAKPWZTlwaSOMHoTgc+0Ds3IOtsZe823PbdqC/ZytU6UZCucfxBpiXtxoHVJw9Nk
         pGaXtQOIXbfEt6GDSauFwDf8DnFn2HVx4NjifRnqW2BscLvu8RGaq1RkZn+PAVSUG1yn
         UgabdoqhuYNsW4wT9mH483cVT0UhHo4AmOtsiAbsMTgLCs8NNkxmzPOW0oUCMwTiCRlO
         5xKw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=W61e8Beb9C0rrwvWLXvghQlyTT+OB/E10KtzePQGPL4=;
        b=WGg6Gxs/O2MyjaDP3/s0C8ogblU+eK0m0u4PU3lfl9zwYcApUksyJprtzEeyIWCCGP
         TbFzI8LQ4f/G4+uGTlJCBe9xgkXiI+D62mo5IX60UDpWVg3UZlqUW4qWH5XXI4Fis77q
         R8G7Ib0+E81QKHY6RByoCx2kRPPWh9KOb/GX8ToRd7Jsp+zyAOEDPNnQjddjbiPdXy4w
         Oho5bFelT441c7VyImFFx+e/tcIGfsrd+5xc3gagJemsCIaEQyQkXHUxS1AkGMKG5I3+
         uY/QxxL54QiRRJLylBkU1BcMfkRf0lUV3bpwC8h4k7dG5MGh5VE/K34+GhC62Gp7AVUz
         5baw==
X-Gm-Message-State: AOAM533lot6KhPveL2e7OgorHGLyjFQxg+yGAp/qZmtQZmlYTxa9rkVA
        pkDBEFQUcA+z65D0hwVhBxqixmSxS4Y3qbTEIdj7Pw==
X-Google-Smtp-Source: ABdhPJxCJQhYe8mNvl+SI2wOrKJVTqqrGltMynBtx7qbJZ2lNzlNv9Ueg8nAxnwgbCGZ3s25dNuNfz9A2qGigUkeOiw=
X-Received: by 2002:a05:6808:a11:b0:325:e5c1:5912 with SMTP id
 n17-20020a0568080a1100b00325e5c15912mr3000582oij.204.1652287600719; Wed, 11
 May 2022 09:46:40 -0700 (PDT)
MIME-Version: 1.0
References: <20220412195846.3692374-1-zhanwei@google.com> <YnmqgFkhqWklrQIw@google.com>
In-Reply-To: <YnmqgFkhqWklrQIw@google.com>
From:   Wei Zhang <zhanwei@google.com>
Date:   Wed, 11 May 2022 18:45:00 +0200
Message-ID: <CAN86XOYNpzEUN0aL9g=_GQFz5zdXX9Pvcs_TDmBVyJZDTfXREg@mail.gmail.com>
Subject: Re: [PATCH 0/2] KVM: x86: Fix incorrect VM-exit profiling
To:     Sean Christopherson <seanjc@google.com>
Cc:     Suleiman Souhlal <suleiman@google.com>,
        Sangwhan Moon <sxm@google.com>, Ingo Molnar <mingo@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
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

Yes, the profiling is about finding out which instructions in the
guest trigger VM exits and the corresponding frequencies.

Basically this will give a histogram array in /proc/profile. So if
'array[A] == T', we know that the instruction at (_stext + A) triggers
VM exits T times. readprofile command could read the information and
show a summary.




On Tue, May 10, 2022 at 1:57 AM Sean Christopherson <seanjc@google.com> wrote:
>
> On Tue, Apr 12, 2022, Wei Zhang wrote:
> > The profile=kvm boot option has been useful because it provides a
> > convenient approach to profile VM exits.
>
> What exactly are you profiling?  Where the guest executing at any given exit?  Mostly
> out of curiosity, but also in the hope that we might be able to replace profiling with
> a dedicated KVM stat(s).
