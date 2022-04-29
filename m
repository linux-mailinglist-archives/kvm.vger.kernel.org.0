Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E5384515258
	for <lists+kvm@lfdr.de>; Fri, 29 Apr 2022 19:34:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1379693AbiD2Rhf (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 29 Apr 2022 13:37:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33980 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1379607AbiD2Rhc (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 29 Apr 2022 13:37:32 -0400
Received: from mail-lf1-x129.google.com (mail-lf1-x129.google.com [IPv6:2a00:1450:4864:20::129])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0C12B4927D
        for <kvm@vger.kernel.org>; Fri, 29 Apr 2022 10:34:12 -0700 (PDT)
Received: by mail-lf1-x129.google.com with SMTP id bu29so15345844lfb.0
        for <kvm@vger.kernel.org>; Fri, 29 Apr 2022 10:34:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=A1VTFJE968v5GHpvmbVSvv7tzCFKNqranep89YCahco=;
        b=FgZVFGyKAlcmm7+KHCsydqDe/OWhm1Tfax+GzbxCKfwolWa55sMS5nG0dA9rPZgq2m
         EJkl4ahYxA3niUEu2nWkdFhhPQk+svsaX/K17RXYIt57xc/go9cBRWPSY25hcd9MvN5N
         XdYX9/C44U0Dqv3sAPePvqB17Qft4wMIdoKGwz9UfG4Lbi4Th6xvMONGoS8yfEgNsqxT
         NsygHY2Lao2TgkbBUCIEwXWMk3icUslJeTR8MyVh5sDcsfU2Qj2P5QA6ua64sGvlOj/p
         D3cks9hLuyfEM2E2I6Mc58SkX5SrOjJo97N97Ye4zs2KDRKRO6ToWYCVFqjwCXM3I9pW
         nIsQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=A1VTFJE968v5GHpvmbVSvv7tzCFKNqranep89YCahco=;
        b=JPTlQ5bX+AKUYdgaVMfUVK9+fQzWbTYqGsC2/oNseLBHB2L7xdPjNvx9x1AJa+18Ia
         XITuHldyLjMrenHWl7vucG/u0hGxzOP1NOKMXsMfSeHCjqhBo8qmpO8ZsQ5+byjwRChH
         flHiS0PFfHEqRpcNv7ukBGlLG94aI8FprYjmDzCahIo9WFcXn2URLqB4t1YNPJX41X1S
         xoUYPdQTgRU3l7PvSTCTx4nVzyWriF+OBHiRpISdSc/Res2nPsFpE8Q4SmlI8sWIQ10+
         +g+6daIVgCoP/6SaQ9YB3cK6alk/4NLiqJydHlJy9g5BQPB58+aIvYMwjK4IhRGunRU8
         n5xw==
X-Gm-Message-State: AOAM532cM50S2U+ZnzJC2VF0BFaYtDKs2bPuKgIb+oBjJGljJqiOatqA
        oa640W9C9nYwD4Y5BPBnFWu0WgKLL2BFNq5fRLdU7g==
X-Google-Smtp-Source: ABdhPJwnaLo2jma4swv1OpPoyEX/Cp4DjStcxkoqeDaMCOCT3MDEeqR2D+Eu0BYhsgfVT0ruHGefqlR9SQfCtYFY8s4=
X-Received: by 2002:a05:6512:12c6:b0:44a:650f:3b86 with SMTP id
 p6-20020a05651212c600b0044a650f3b86mr211123lfg.79.1651253650122; Fri, 29 Apr
 2022 10:34:10 -0700 (PDT)
MIME-Version: 1.0
References: <20220407195908.633003-1-pgonda@google.com> <CAMkAt6r-Mc_YN-gVHuCpTj4E1EmcvyYpP9jhtHo5HRHnoNJAdA@mail.gmail.com>
 <CAMkAt6r+OMPWCbV_svUyGWa0qMzjj2UEG29G6P7jb6uH6yko2w@mail.gmail.com>
 <62e9ece1-5d71-f803-3f65-2755160cf1d1@redhat.com> <CAMkAt6q6YLBfo2RceduSXTafckEehawhD4K4hUEuB4ZNqe2kKg@mail.gmail.com>
 <4c0edc90-36a1-4f4c-1923-4b20e7bdbb4c@redhat.com> <CAMkAt6oL5qi7z-eh4z7z8WBhpc=Ow6WtcJA5bDi6-aGMnz135A@mail.gmail.com>
 <CAMkAt6rmDrZfN5DbNOTsKFV57PwEnK2zxgBTCbEPeE206+5v5w@mail.gmail.com>
 <0d282be4-d612-374d-84ba-067994321bab@redhat.com> <CAMkAt6ragq4OmnX+n628Yd5pn51qFv4qV20upGR6tTvyYw3U5A@mail.gmail.com>
 <8a2c5f8c-503c-b4f0-75e7-039533c9852d@redhat.com> <CAMkAt6qAW5zFyTAqX_Az2DT2J3KROPo4u-Ak1sC0J+UTUeFfXA@mail.gmail.com>
 <4afce434-ab25-66d6-76f4-3a987f64e88e@redhat.com> <CAMkAt6o8u9=H_kjr_xyRO05J=RDFUZRiTc_Bw-FFDKEUaiyp2Q@mail.gmail.com>
 <CABgObfa0ubOwNv2Vi9ziEjHXQMR_Sa6P-fwuXfPq76qy0N61kA@mail.gmail.com>
 <CAMkAt6pcg_Eg49nN5hS=wbeVWtPV1N_12G9Lvfgoq_bS_tUYog@mail.gmail.com> <d53df9d3-5de2-c1e6-11ce-a3b61e9e630e@redhat.com>
In-Reply-To: <d53df9d3-5de2-c1e6-11ce-a3b61e9e630e@redhat.com>
From:   Peter Gonda <pgonda@google.com>
Date:   Fri, 29 Apr 2022 11:33:58 -0600
Message-ID: <CAMkAt6o+tA9=DvHjv-zJtvZHiFaXhiO-7iV8ts3p6JWog-V9og@mail.gmail.com>
Subject: Re: [PATCH v3] KVM: SEV: Mark nested locking of vcpu->lock
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     John Sperbeck <jsperbeck@google.com>,
        kvm list <kvm@vger.kernel.org>,
        David Rientjes <rientjes@google.com>,
        Sean Christopherson <seanjc@google.com>,
        LKML <linux-kernel@vger.kernel.org>
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

On Fri, Apr 29, 2022 at 11:32 AM Paolo Bonzini <pbonzini@redhat.com> wrote:
>
> On 4/29/22 19:27, Peter Gonda wrote:
> > Ah yes I missed that. I would suggest `role = SEV_NR_MIGRATION_ROLES`
> > or something else instead of role++ to avoid leaking this
> > implementation detail outside of the function signature / enum.
>
> Sure.

OK. I'll get that tested and get a V4 out. Thank you for all the help
here Paolo!!

>
> Paolo
>
