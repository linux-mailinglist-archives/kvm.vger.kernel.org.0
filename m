Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EBE76528DED
	for <lists+kvm@lfdr.de>; Mon, 16 May 2022 21:30:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345410AbiEPTaq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 16 May 2022 15:30:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44008 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233560AbiEPTal (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 16 May 2022 15:30:41 -0400
Received: from mail-ot1-x32b.google.com (mail-ot1-x32b.google.com [IPv6:2607:f8b0:4864:20::32b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 446992B1A9
        for <kvm@vger.kernel.org>; Mon, 16 May 2022 12:30:40 -0700 (PDT)
Received: by mail-ot1-x32b.google.com with SMTP id s18-20020a056830149200b006063fef3e17so10749638otq.12
        for <kvm@vger.kernel.org>; Mon, 16 May 2022 12:30:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=YCWtu0aA9CxSyLGzITwZE2RFoiQ9ONEqkxjQ2xXJpA8=;
        b=N1DvjCOaQM6sCQEEes2mVcUTdjUIrlF10i/geaVSLrHdW9DHYM9RSOwUNdSe7sw5ML
         iI3+X/2W5j8/acTRzANF1jt2JabJjE9l79gK36u0DlbQpjUQmO+2vvqMqvrd8/hCtNxN
         h3GpKGPOdbbBsUh+4HGkoE9XTVtn8oJ6wJDYGY6w1Wl1O1sP7dtZAJAbloyhxxl9R4kJ
         r/lqjcKKIuaM1mV77JcWxk6aaIAec1SVa5DDVsoV9KwfHA28PP5JzR1Hn97cZceOoQF8
         /yuJWqUkk8aq21QpukmMZWeXguHH0Vk1JAmGo80S4cRvkDK/djzob22EKoiPPQn3x5Vd
         XlSg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=YCWtu0aA9CxSyLGzITwZE2RFoiQ9ONEqkxjQ2xXJpA8=;
        b=TaBUeTWO/TWVd7+OoS6NsMCoLcPWNcOnRn0cuABuyMBkWkL1nhv4W7kPBSuG1Mm152
         UoHzr61KJOt8wWiSaWHO35RSpXNyCJ9SNI35HS+S9lQsEiQyY5byeH8ix9UtOA/BSqJd
         s0cLV1WI5T8QXT80VfC/ZRaq4AnbLmlZJu4ezRodd2zl7fek4bhm5pWK57Y0ALFRgdDq
         IN8kto2Gb0jMcFCfdb38/oXqCtW7RVo+tNQ8732QlQOKexHvQNgYKMUJjlGSLJ5b2Eha
         wTHSvYHQrw3BasFs1DsKu+gVr3bhlyQjXgNjOt2AmTq0hRLo5cFV3KLiV6f7PefvyyFq
         /M+Q==
X-Gm-Message-State: AOAM531I3aFpuQX6O5UdP4Ef2KEnjcdKmjV86jMmidbJZ0JlUMG2bDO3
        H1BNbGCbqcIIyMnuyWLePrfowo3yszQrsnv62L9VDA==
X-Google-Smtp-Source: ABdhPJz23KWYvAC+Yv7AxHe5ZYX+hLIjlHHyYF2clYPjWK/Y+R+Tix4W90Th4qCk0Q61fhRXkvUaf+iddyNwXNkW368=
X-Received: by 2002:a9d:6e83:0:b0:605:4a01:1d8c with SMTP id
 a3-20020a9d6e83000000b006054a011d8cmr6598748otr.174.1652729439301; Mon, 16
 May 2022 12:30:39 -0700 (PDT)
MIME-Version: 1.0
References: <20220412195846.3692374-1-zhanwei@google.com> <YnmqgFkhqWklrQIw@google.com>
 <CAN86XOYNpzEUN0aL9g=_GQFz5zdXX9Pvcs_TDmBVyJZDTfXREg@mail.gmail.com> <YnwRld0aH8489+XQ@google.com>
In-Reply-To: <YnwRld0aH8489+XQ@google.com>
From:   Wei Zhang <zhanwei@google.com>
Date:   Mon, 16 May 2022 21:30:00 +0200
Message-ID: <CAN86XOZdW7aZXhSU2=gP5TrRQc8wLmtTQui0J2kwhchp2pnbeQ@mail.gmail.com>
Subject: Re: [PATCH 0/2] KVM: x86: Fix incorrect VM-exit profiling
To:     Sean Christopherson <seanjc@google.com>,
        Suleiman Souhlal <suleiman@google.com>
Cc:     Sangwhan Moon <sxm@google.com>, Ingo Molnar <mingo@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Jing Zhang <jingzhangos@google.com>,
        David Matlack <dmatlack@google.com>
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

> Please don't top-post.  From https://people.kernel.org/tglx/notes-about-netiquette:

Ah, I didn't know this should be avoided. Thanks for the info!

> My preference would be to find a more complete, KVM-specific solution.  The
> profiling stuff seems like it's a dead end, i.e. will always be flawed in some
> way.  If this cleanup didn't require a new hypercall then I wouldn't care, but
> I don't love having to extend KVM's guest/host ABI for something that ideally
> will become obsolete sooner than later.

I also feel that adding a new hypercall is too much here. A
KVM-specific solution is definitely better, and the eBPF based
approach you mentioned sounds like the ultimate solution (at least for
inspecting exit reasons).

+Suleiman What do you think? The on-going work Sean described sounds
promising, perhaps we should put this patch aside for the time being.
