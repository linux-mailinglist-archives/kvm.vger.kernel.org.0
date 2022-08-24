Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CF55159FD79
	for <lists+kvm@lfdr.de>; Wed, 24 Aug 2022 16:43:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235745AbiHXOnX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 24 Aug 2022 10:43:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60340 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231224AbiHXOnV (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 24 Aug 2022 10:43:21 -0400
Received: from mail-pj1-x1034.google.com (mail-pj1-x1034.google.com [IPv6:2607:f8b0:4864:20::1034])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 70143275D1
        for <kvm@vger.kernel.org>; Wed, 24 Aug 2022 07:43:20 -0700 (PDT)
Received: by mail-pj1-x1034.google.com with SMTP id p9-20020a17090a2d8900b001fb86ec43aaso1341688pjd.0
        for <kvm@vger.kernel.org>; Wed, 24 Aug 2022 07:43:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc;
        bh=zgR63Pokq2CbaIPjDV2dBbMmqrnmrq2DaAqhPP+oYxg=;
        b=DAeK4nt1suClshcQdkhyRPNdmBzpK4p44fg+vk4zdOOzea80bbH5VbYvCH61RI9nUu
         kUVkFxEYLAUgUuH8Uz6fXEZCEC46MIJF1IJw1PYHVlDiJ0EsHjda4VU2/+/yNdVkZmxP
         NN6zonygneCKNyyQJ9atC+puhtS2CHjPceA2N3NRlfAjVMl/qG1vQljKdWdmqXh39CUU
         EzABzPsPZsZoaBSfnb4hwtjT2lm7a/12GveFYSOcya98OsZflm/vk14RxmfUM1lSy6Wc
         9VH/cz2qKKbjOMrXZfgY0Q4HyHoSAyKYURBe4O/LvusX0T2eYWkz/KjMvyRnzzW2d1mY
         fE6w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc;
        bh=zgR63Pokq2CbaIPjDV2dBbMmqrnmrq2DaAqhPP+oYxg=;
        b=Vuvvzxto4Os82qMRyFacsLPjPdo6BiOONeKDS3xSENPIZFkbrFpu2SehsG/KA/UTOf
         r/7AnjdhdFfejMQFpI06XFFayOB3gfbpMpQeKmaCPnSAMJAvzea1Kuucwz+HgXTnGoNC
         3mprlFfowF1QR2Z8t/phRjZO3ITF+SeK1ohLklyKCJllMtrvnsylSoiktfgE7F/ZHtYP
         4U3+Fb3u97DTZCgH6BUuJS0SjgEtiA1RA/qG8I6HfXNKxjUVi0EYQswLiL609jyk3kfd
         T18FJYjA+xpr5xRX5w0swdVo7yjbvbyEX18nNJ3BiCMs8V/1lf7UFOxn35drkrVYSfM4
         FHtQ==
X-Gm-Message-State: ACgBeo23qv8o/vnx9oPVMbPsg7YGInU3Hd9atQvec8/xunvZ8b353FDk
        yksFBW++fFSSGfNcIV2ThbKJtw==
X-Google-Smtp-Source: AA6agR7DZbr2PpjywcCRzf6zw8qRouBsoco74JgCONjulw++08aY8h6eGiMBwXBPB2i2kykOAjs1ng==
X-Received: by 2002:a17:903:230b:b0:16f:2276:1fc4 with SMTP id d11-20020a170903230b00b0016f22761fc4mr27929381plh.172.1661352199809;
        Wed, 24 Aug 2022 07:43:19 -0700 (PDT)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id p18-20020a170902ead200b0016a6caacaefsm12595764pld.103.2022.08.24.07.43.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 24 Aug 2022 07:43:19 -0700 (PDT)
Date:   Wed, 24 Aug 2022 14:43:15 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Maxim Levitsky <mlevitsk@redhat.com>
Cc:     Oliver Upton <oupton@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        David Dunn <daviddunn@google.com>,
        Peter Shier <pshier@google.com>
Subject: Re: [PATCH 1/2] KVM: x86: Allow userspace to opt out of hypercall
 patching
Message-ID: <YwY5AxXHAAxjJEPB@google.com>
References: <20220316005538.2282772-1-oupton@google.com>
 <20220316005538.2282772-2-oupton@google.com>
 <Yjyt7tKSDhW66fnR@google.com>
 <2a438f7c-4dea-c674-86c0-9164cbad0813@redhat.com>
 <YjzBB6GzNGrJdRC2@google.com>
 <Yj5V4adpnh8/B/K0@google.com>
 <YkHwMd37Fo8Zej59@google.com>
 <YkH+X9c0TBSGKtzj@google.com>
 <48030e75b36b281d4441d7dba729889aa9641125.camel@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <48030e75b36b281d4441d7dba729889aa9641125.camel@redhat.com>
X-Spam-Status: No, score=-14.5 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,FSL_HELO_FAKE,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Aug 24, 2022, Maxim Levitsky wrote:
> On Mon, 2022-03-28 at 18:28 +0000, Sean Christopherson wrote:
> > On Mon, Mar 28, 2022, Oliver Upton wrote:
> > > While I was looking at #UD under nested for this issue, I noticed:
> > > 
> > > Isn't there a subtle inversion on #UD intercepts for nVMX? L1 gets first dibs
> > > on #UD, even though it is possible that L0 was emulating an instruction not
> > > present in hardware (like RDPID). If L1 passed through RDPID the #UD
> > > should not be reflected to L1.
> > 
> > Yes, it's a known bug.
> > 
> > > I believe this would require that we make the emulator aware of nVMX which
> > > sounds like a science project on its own.
> > 
> > I don't think it would require any new awareness in the emulator proper, KVM
> > would "just" need to ensure it properly morphs the resulting reflected #UD to a
> > nested VM-Exit if the emulator doesn't "handle" the #UD.  In theory, that should
> > Just Work...
> > 
> > > Do we write this off as another erratum of KVM's (virtual) hardware on VMX? :)
> > 
> > I don't think we write it off entirely, but it's definitely on the backburner
> > because there are so precious few cases where KVM emulates on #UD.  And for good
> > reason, e.g. the RDPID case takes an instruction that exists purely to optimize
> > certain flows and turns them into dreadfully sloooow paths.
> > 
> 
> I noticed that 'fix_hypercall_test' selftest fails if run in a VM. The reason is
> that L0 patches the hypercall before L1 sees it so it can't really do anything
> about it.
> 
> Do you think we can always stop patching hypercalls for the nested guest regardless
> of the quirk, or that too will be considered breaking backwards compatability?

Heh, go run it on Intel, problem solved ;-)

As discussed last year[*], it's impossible to get this right in all cases, ignoring
the fact that patching in the first place is arguably wrong.  E.g. if KVM is running
on AMD hardware and L0 exposes an Intel vCPU to L1, then it sadly becomes KVM's
responsibility to patch L2 because from L1's perspective, a #UD on Intel's VMCALL
in L2 is spurious.

Regardless of what path we take, I do think we should align VMX and SVM on exception
intercept behavior.

[*] https://lore.kernel.org/all/YEZUhbBtNjWh0Zka@google.com
