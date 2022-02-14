Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 138E14B59B0
	for <lists+kvm@lfdr.de>; Mon, 14 Feb 2022 19:15:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1357372AbiBNSO5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 14 Feb 2022 13:14:57 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:58980 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229961AbiBNSOx (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 14 Feb 2022 13:14:53 -0500
Received: from mail-lj1-x22e.google.com (mail-lj1-x22e.google.com [IPv6:2a00:1450:4864:20::22e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2713E60D88
        for <kvm@vger.kernel.org>; Mon, 14 Feb 2022 10:14:45 -0800 (PST)
Received: by mail-lj1-x22e.google.com with SMTP id e17so23450255ljk.5
        for <kvm@vger.kernel.org>; Mon, 14 Feb 2022 10:14:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=za1XMQmDSvo1tI1nYjjULb15Ic/yfPGol3r5k5Fjeac=;
        b=V+B92DzLSwMBpjaeppdbk+sAoKjZyUQ/OkQuTlh+advSeJZ9o8fPIxWeIx7+AxQKpB
         ycAXqXNyBB+AapMyKSNHaZJ7HL1Va+uEb7lfmh2AV1MfBNopCD+DWsY9qFifDO0ZbPLZ
         8xSB5iHB35K56klYlTL1Ne9fKNWQWwPZd7Po3/ExMzbeYVsXqZujuaCJm/Wz0c5r6Xes
         a27j6r44Juz6t5pHXiUP2Fw6QXMGWpnFEhCPPS7xXrhEb63E7ymJjYtUU+e9HZwCMPIv
         eiFsgOCKmk12fLU4lBG8QNAuU65+Ch1IToVC9poY2QlUZYBuVpX7hIJylVRnbs0mi/qe
         JgRQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=za1XMQmDSvo1tI1nYjjULb15Ic/yfPGol3r5k5Fjeac=;
        b=BnFe3UQqnRezJp7+Fl4KdfWaGaeL2uCX7X6i77bGWckiti82tHE48X1kXO4+RrBgT8
         B8YrZ1lutPmHgI4GJ+m9DRuTTZI1hLWP8uxM1mlZ2n1D3HiYIAuxa9/GNJEqxktIdrsi
         RBJndzIWKDO/K2fRQy+fG52Pn8Aj1kU7Ugw71W19vAbBB5aRGCpMh20EifouiW9EK09H
         S/ZbVSRKZmE7vsKh/wQ+5yCLLEDHuexLTw0Gd4vLz+6iwskdk2b7af6x2VY+u6YSnG55
         VugcZHSjBjN67O3KcvDjT3dpPpADt5xOP7Y8omHDIFuZSO9JF0KNMrtr2mC21bc7Nsm6
         lsWA==
X-Gm-Message-State: AOAM533cFaF4Q4qvVnrQGvR0cgQ9RsQJQtIYc5hboIIpc6Bdgz0i/oBQ
        ne5hQc6DmSIkCvhMhJcBTSrYH3kvJYkFbbnWNdnVvg==
X-Google-Smtp-Source: ABdhPJxiu2ox2DHHG9pa9Pb9YzXWa4RTT8ly/QBgDWP1BBh9UF2nElrWB29CHHW3YhppFsZOhJ4rQ+DDijHwHUER8/8=
X-Received: by 2002:a05:651c:1a22:: with SMTP id by34mr645542ljb.331.1644862483359;
 Mon, 14 Feb 2022 10:14:43 -0800 (PST)
MIME-Version: 1.0
References: <20220204115718.14934-1-pbonzini@redhat.com> <YgRApq20ds4FDivX@google.com>
In-Reply-To: <YgRApq20ds4FDivX@google.com>
From:   David Matlack <dmatlack@google.com>
Date:   Mon, 14 Feb 2022 10:14:16 -0800
Message-ID: <CALzav=ee3JBR+L2uZOaB-ijakMoabEXJLLozy56SQJL+m9KC2Q@mail.gmail.com>
Subject: Re: [PATCH 00/23] KVM: MMU: MMU role refactoring
To:     Sean Christopherson <seanjc@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>,
        kvm list <kvm@vger.kernel.org>,
        Vitaly Kuznetsov <vkuznets@redhat.com>
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

On Wed, Feb 9, 2022 at 2:31 PM Sean Christopherson <seanjc@google.com> wrote:
> On Fri, Feb 04, 2022, Paolo Bonzini wrote:
> >   KVM: MMU: replace direct_map with mmu_role.direct
>
> Heresy!  Everyone knows the one true way is "KVM: x86/mmu:"
>
>   $ glo | grep "KVM: MMU:" | wc -l
>   740
>   $ glo | grep "KVM: x86/mmu:" | wc -l
>   403
>
> Dammit, I'm the heathen...
>
> I do think we should use x86/mmu though.  VMX and SVM (and nVMX and nSVM) are ok
> because they're unlikely to collide with other architectures, but every arch has
> an MMU...

Can you document these rules/preferences somewhere? Even better if we
can enforce them with checkpatch :)
