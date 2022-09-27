Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2D9805ECA2F
	for <lists+kvm@lfdr.de>; Tue, 27 Sep 2022 18:55:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232849AbiI0Qzr (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 27 Sep 2022 12:55:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36928 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232904AbiI0QzK (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 27 Sep 2022 12:55:10 -0400
Received: from mail-yw1-x1135.google.com (mail-yw1-x1135.google.com [IPv6:2607:f8b0:4864:20::1135])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 85B3C101FF
        for <kvm@vger.kernel.org>; Tue, 27 Sep 2022 09:54:34 -0700 (PDT)
Received: by mail-yw1-x1135.google.com with SMTP id 00721157ae682-345528ceb87so106206177b3.11
        for <kvm@vger.kernel.org>; Tue, 27 Sep 2022 09:54:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date;
        bh=W0xg9RtiBqYWCn75opQ1wyDHiSh1EdYgdVcJnSQAyaI=;
        b=bRnTe953BU0S9p4GzkMTwutXKUYULiE3E2Wpn3dShC2oZ9jQjO+yNRGCVh0vFpovYx
         QIvVUnEw09Z7bPOXir+36n4MD0SQG+mWc4pTOWgeijinfnLHdYoCCp9j7rxVNDgpuwhM
         3rlkwqKC3se4rlZ/mQoKE5gW3UVfsvqggQjsPkAkmlqesubcgJlsvxOTi2RuDqUDynii
         fnfD96JZy2rGjPakIYlAarTffn3C653ZtWZx4eR2WNMqS6Kca2mD7dVt3vjXpupNiRdn
         8lwz80B/CRCr85+TE8e0Ce+n1HdV/q+DEMbisJxQFDSXqup711Zp6aR3gWwym0NqMm0i
         4Ivw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date;
        bh=W0xg9RtiBqYWCn75opQ1wyDHiSh1EdYgdVcJnSQAyaI=;
        b=c0aGV/H7jbBtDCOm174/QVv0aReTvYTI1LWqexZacQsZzfT/RKHD0Q7MADstM8V/7v
         bp2WGovkFLMwhmnijyWIWFWOILLzQoZ9NaVXW2cGmrFsjXokfCK8pFMMOas6gXAClTXd
         EVZnEGuGzEqVpff57OuyL7R0iOSJ/VISl65/DZ7EopvGnPaAJbuMRt6ILLx9DyKMSjPQ
         N4DLgsbL4nGowtIMHgIc0RyG39XOi72X6haChFtOo9luIMtfDAkI8JGecnO89DXTwixT
         Xje3uCZTQHyT6ka64UY+2ZtOlZmeFGMgFEx/gp37jg6nioA05PLEOEVxgrKgwb3DOWOi
         bwGQ==
X-Gm-Message-State: ACrzQf23DnzSpSqi2DIV4mi1qxQzaeuvUWpmbc+eaLfvBmjE43tT505c
        tAr0Y104DH1whdfYSBHqfJo/JtdNbyg7htoScf2Zl2am8xA=
X-Google-Smtp-Source: AMsMyM5iNWq9PrZ4SQcEEyjs1vDn+yBhn057UlEajJm2EicjZLp/lXTHe8LGAsvjZ9hHsk5s/BGmHSUTnw7PCtMjh38=
X-Received: by 2002:a81:c02:0:b0:34d:829a:20f3 with SMTP id
 2-20020a810c02000000b0034d829a20f3mr25274846ywm.168.1664297673551; Tue, 27
 Sep 2022 09:54:33 -0700 (PDT)
MIME-Version: 1.0
References: <20220926171457.532542-1-dmatlack@google.com> <3d091669-cb83-330e-52d0-5d3ac0fe7214@redhat.com>
In-Reply-To: <3d091669-cb83-330e-52d0-5d3ac0fe7214@redhat.com>
From:   David Matlack <dmatlack@google.com>
Date:   Tue, 27 Sep 2022 09:54:07 -0700
Message-ID: <CALzav=de=S5wDX=_jq3EvRYf9PromLMUmEvuDF_S075o3HO=jA@mail.gmail.com>
Subject: Re: [PATCH] KVM: selftests: Skip tests that require EPT when it is
 not available
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Peter Xu <peterx@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        kvm list <kvm@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
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

On Tue, Sep 27, 2022 at 4:58 AM Paolo Bonzini <pbonzini@redhat.com> wrote:
>
> On 9/26/22 19:14, David Matlack wrote:
> > Skip selftests that require EPT support in the VM when it is not
> > available. For example, if running on a machine where kvm_intel.ept=N
> > since KVM does not offer EPT support to guests if EPT is not supported
> > on the host.
> >
> > This commit causes vmx_dirty_log_test to be skipped instead of failing
> > on hosts where kvm_intel.ept=N.
> >
> > Signed-off-by: David Matlack <dmatlack@google.com>
>
> Queued for 6.0, thanks.

I sent a v2 based on the feedback from Sean. Please grab that one
instead. Thanks.
