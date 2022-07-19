Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3041457A761
	for <lists+kvm@lfdr.de>; Tue, 19 Jul 2022 21:47:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239650AbiGSTrS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 19 Jul 2022 15:47:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34076 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229379AbiGSTrR (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 19 Jul 2022 15:47:17 -0400
Received: from mail-wm1-x335.google.com (mail-wm1-x335.google.com [IPv6:2a00:1450:4864:20::335])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 08426491F2
        for <kvm@vger.kernel.org>; Tue, 19 Jul 2022 12:47:17 -0700 (PDT)
Received: by mail-wm1-x335.google.com with SMTP id v5so843600wmj.0
        for <kvm@vger.kernel.org>; Tue, 19 Jul 2022 12:47:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=gBFjV+H6Bk3RZxQhgs56c67pgeASH1p2afTivA2Q2Vc=;
        b=KrgMqaDt3ZgzHO1BtCtBq135bE3bgQv7e8jRHxvJbvqo3cmDSOd+LSEs2PH8kuqxfs
         emr/IPgM6AjvLaJASN0wyDekUB3EINlss/6PLn21LE9wNQaZUig++JUGxsCyL/SAganH
         Z4TR1ZNqWrAYFVuUAqTqOnYYoMpdoJqCy6MinMZXeNsZKEE44eBulPDc67EUzzy4DC8b
         8/lxcds8SRccRI+Ce6sYUqiyVxpMmd/t3vBeyNk3E3Jqq6J5w/kHV3OQC5iuJTMyxQnC
         iRVPriGbSTHR0R3d4rYAkE34WKbXdHr5gcRhZXoROuiZqgO4PcezuBKHf9FoV4u8z+vq
         6TKQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=gBFjV+H6Bk3RZxQhgs56c67pgeASH1p2afTivA2Q2Vc=;
        b=iMF6LEW/nWEq2BcJA8MDtPsG/Kao2CHRI3qd91fr/mtWbYaaCGFAoiq1erFLRPmeeG
         XrwizcjXLJs5CE3Kg2R/XCtiG8qwaPGKCczxM3TPJJKOPquh6mLTG0vllIJYX+PuDnEV
         DWXkgs7sQGHxYIG8QRBM15ssfhqZh9G5aGQY67I7wj2r2T7VZMAhE3SMXLt72xJhgp1L
         cBA9Qb04Ss67yi6zpx7IRLCcV476Ohdo3XXjgGtogKhqu5/sf+EbkDRmE+4F3HrbSmfD
         0SAMZopahCh5kN6alDZRc/OWzZByYGZ0fByKDr+Fp8CIHx3xisGXpBnJSvnNxxk3ZYY8
         HNYQ==
X-Gm-Message-State: AJIora9Ck4bAreACclfa9MeNEXNQQRD+hZOK8loIQ8aj9DKv0mdP6rzP
        Ji2rmGc9iTS8FewkokSyJupM2ki/EQvLA+toxFRSRw==
X-Google-Smtp-Source: AGRyM1uQBR4na6veEfF1mg5OS0WvZjNtFpMwwRCEhEhK71d4qdWD+Wce2nBnLah5OuBBO777DYvZ07fvVYmkxqmccoo=
X-Received: by 2002:a05:600c:1c22:b0:3a2:fe0c:aea6 with SMTP id
 j34-20020a05600c1c2200b003a2fe0caea6mr724845wms.59.1658260035506; Tue, 19 Jul
 2022 12:47:15 -0700 (PDT)
MIME-Version: 1.0
References: <20220714161314.1715227-1-aaronlewis@google.com>
 <8da08a8a-e639-301d-ca98-d85b74c1ad20@redhat.com> <Ytb+BZReuuD+2rpd@google.com>
In-Reply-To: <Ytb+BZReuuD+2rpd@google.com>
From:   Aaron Lewis <aaronlewis@google.com>
Date:   Tue, 19 Jul 2022 19:47:03 +0000
Message-ID: <CAAAPnDHL=aP62POsYPJwKjiJsS6=r4AvVdbn2-u1AMfSCi2YjQ@mail.gmail.com>
Subject: Re: [RFC PATCH] KVM: x86: Protect the unused bits in MSR exiting flags
To:     Sean Christopherson <seanjc@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
        jmattson@google.com
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

On Tue, Jul 19, 2022 at 6:55 PM Sean Christopherson <seanjc@google.com> wrote:
>
> On Tue, Jul 19, 2022, Paolo Bonzini wrote:
> > On 7/14/22 18:13, Aaron Lewis wrote:
> > > ---
> > >
> > > Posting as an RFC to get feedback whether it's too late to protect the
> > > unused flag bits.  My hope is this feature is still new enough, and not
> > > widely used enough, and this change is reasonable enough to be able to be
> > > corrected.  These bits should have been protected from the start, but
> > > unfortunately they were not.
> > >
> > > Another option would be to correct this by adding a quirk, but fixing
> > > it that has its down sides.   It complicates the code more than it
> > > would otherwise be, and complicates the usage for anyone using any new
> > > features introduce in the future because they would also have to enable
> > > a quirk.  For long term simplicity my hope is to be able to just patch
> > > the original change.
> >
> > Yes, let's do it this way.
>
> Heh, which way is "this way"?
>
>   (a) Fix KVM_CAP_X86_USER_SPACE_MSR and cross our fingers
>   (b) Add a quirk
>   (c) ???

I hope we're talking about (a).  I should have a patchset out later
today with fixes and selftest.
