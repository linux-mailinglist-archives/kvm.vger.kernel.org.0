Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B370A6FE82E
	for <lists+kvm@lfdr.de>; Thu, 11 May 2023 01:45:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236144AbjEJXpS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 10 May 2023 19:45:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48886 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229801AbjEJXpR (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 10 May 2023 19:45:17 -0400
Received: from mail-wr1-x42c.google.com (mail-wr1-x42c.google.com [IPv6:2a00:1450:4864:20::42c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BFC8C1BFE
        for <kvm@vger.kernel.org>; Wed, 10 May 2023 16:45:15 -0700 (PDT)
Received: by mail-wr1-x42c.google.com with SMTP id ffacd0b85a97d-305f0491e62so7553129f8f.3
        for <kvm@vger.kernel.org>; Wed, 10 May 2023 16:45:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1683762314; x=1686354314;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=g/f8372EfFL0dLuJKV88dmyrC50A+7+4fh9twA0BZdY=;
        b=m50IVE0QT4eqBj4Or1oen4xbNKS5CMUm8lq5U/3QnCNem8hdW+QYI69PdE8BXfygwY
         Cjkv9s5R+qJwKrCjXBH8R/n9NQ7BgQtk7xloOeLczsO4MytH/UMNsW2xu8L7mFu4hQZc
         /1nVpf6ZH1Z71Fa7KIXImPhZ0DM4l9QypzWSLXaAsyqZ9Xr2ox0vvREZsVpIoMZLjyO0
         AbPbgFy8D4/EFQJdZIN1s76ZENXKdlo32sjW+Gl4YRhppamJuQNYOGv7sRzm2k5bQyJa
         wmxK6NH1j4cRHDJqlY0J1XoRBFdt2rZRE4XecJJaVwockrnceezaYQm5KorLW22XdS78
         xNUg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683762314; x=1686354314;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=g/f8372EfFL0dLuJKV88dmyrC50A+7+4fh9twA0BZdY=;
        b=DK7vZcgx9HoXa0NsJtG4JfaOIfzABrDYF4NKKCDlnALgT7kOUR79YCVyZNktf42SKB
         qN+hGATI3roQ+I2eSUsqJHbnskjTYbZRVAfSSOOW32HmmdMV8tWbxI8IlkM/9PMqpr96
         gIZB31kgvAKE4pfdvzinkAwr4uXjaDqWNAaoPniwF7/bwuFKbRza79hZE1ZSGYmbuOpk
         3DjU+jDusVHBzAsd85Cb3l8bxfzN5I+pCDXc+lr4l9x3KEz8dKwZfFrTvOPd+qfdZ+Or
         VfQY9zPLuG9Ksxzs14XtrjUtpf88s++xjN78MmWYP1hoBz2fViIjB1grxLd48DCpPTpV
         jnYA==
X-Gm-Message-State: AC+VfDy8uwssAUgJSJ/kCIWVGG0JUlug9LNEqxM3XPWh8/9y2yIDVtYv
        gsqvznfYXJSa9P94NGBNcs8STkdsz2bzi2Xlwq9ngA==
X-Google-Smtp-Source: ACHHUZ47nGjmuV7bPmEwBVtyVi/FCzcge0GMT/DBO5cr5fCZW+NSursjE7RbTpdEU+gNfH1L81j3WQHrb0/C+84VnjY=
X-Received: by 2002:a5d:6606:0:b0:2ef:b123:46d9 with SMTP id
 n6-20020a5d6606000000b002efb12346d9mr13906473wru.3.1683762314195; Wed, 10 May
 2023 16:45:14 -0700 (PDT)
MIME-Version: 1.0
References: <20230412213510.1220557-1-amoorthy@google.com> <ZFrG4KSacT/K9+k5@google.com>
 <ZFwcRCSSlpCBspxy@google.com>
In-Reply-To: <ZFwcRCSSlpCBspxy@google.com>
From:   Anish Moorthy <amoorthy@google.com>
Date:   Wed, 10 May 2023 16:44:37 -0700
Message-ID: <CAF7b7mrLW665hfZCT==1A0C2bw1SHUYTF+yaAMDNuZAd8ydu1w@mail.gmail.com>
Subject: Re: [PATCH v3 00/22] Improve scalability of KVM + userfaultfd live
 migration via annotated memory faults.
To:     Sean Christopherson <seanjc@google.com>
Cc:     David Matlack <dmatlack@google.com>, pbonzini@redhat.com,
        maz@kernel.org, oliver.upton@linux.dev, jthoughton@google.com,
        bgardon@google.com, ricarkol@google.com, axelrasmussen@google.com,
        peterx@redhat.com, kvm@vger.kernel.org, kvmarm@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
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

On Wed, May 10, 2023 at 3:35=E2=80=AFPM Sean Christopherson <seanjc@google.=
com> wrote:
>
> Yeah, when I speed read the series, several of the conversions stood out =
as being
> "wrong".  My (potentially unstated) idea was that KVM would only signal
> KVM_EXIT_MEMORY_FAULT when the -EFAULT could be traced back to a user acc=
ess,
> i.e. when the fault _might_ be resolvable by userspace.

Well, you definitely tried to get the idea across somehow- even in my
cover letter here, I state

> As a first step, KVM_CAP_MEMORY_FAULT_INFO is introduced. This
> capability is meant to deliver useful information to userspace (i.e. the
> problematic range of guest physical memory) when a vCPU fails a guest
> memory access.

So the fact that I'm doing something more here is unintentional and
stems from unfamiliarity with all of the ways in which KVM does (or
does not) perform user accesses.

Sean, besides direct_map which other patches did you notice as needing
to be dropped/marked as unrecoverable errors?
