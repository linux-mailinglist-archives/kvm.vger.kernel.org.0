Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1E631545AEF
	for <lists+kvm@lfdr.de>; Fri, 10 Jun 2022 06:22:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235982AbiFJEW0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 10 Jun 2022 00:22:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41946 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229595AbiFJEWY (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 10 Jun 2022 00:22:24 -0400
Received: from mail-oi1-x22f.google.com (mail-oi1-x22f.google.com [IPv6:2607:f8b0:4864:20::22f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A21D42D56C2
        for <kvm@vger.kernel.org>; Thu,  9 Jun 2022 21:22:22 -0700 (PDT)
Received: by mail-oi1-x22f.google.com with SMTP id l81so18852345oif.9
        for <kvm@vger.kernel.org>; Thu, 09 Jun 2022 21:22:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=gaj0oheke5OQkaHG5tbuEIzRasAdO37vo5qEEpHUshs=;
        b=b1uWzdAmG1cVbn2NY4PO+LLU27EzNGIxzvi1S/PlWa/kiqUedrFiWil9YljuK5gVda
         PnaSTEraPK9gwtd5A1UtYnsCjcGCorlKQNUzU4Px2ScUxKl4WlAitd7P7WfQCScUbFsW
         1X5/eyXSjgXrOOs+l7x70fU60GJ5dfSyu9ThAaQ65blZtAFQe11lcsi9v2IBrqTWuT7C
         8L03e5VilYcRwH7VYz3rMf03hwqFxhvec9xZ6hqGSrtfAuSV6tPDmcq5V7pqd9G/rGx2
         jyxwXevHOINXyZv/+VyIVurtR7dy1efrr4KFE3Hv4W/x2X37B83Vq0x/Zi7CXD0DivOm
         W0Yw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=gaj0oheke5OQkaHG5tbuEIzRasAdO37vo5qEEpHUshs=;
        b=c8foZXBa7IqTa6YZeLLTqwfI1UMcYAE4E51xque0SsdkV9gcq3nxLW3zy3+LmepF9J
         fj0MnSdhhPxnmpSDW8PwU0E0UB/crKhhaCxWcNl5zKmfiFsURgGI7r5zBnZdOBSU5s/s
         XvH+OA8Zy++9lyc1gLv4sWY0rEyFmSv1Va9YH5zWcmyvf1/4c2MpEkQX+KlpqF3uWID/
         gr+54NUDW9gRRW8rFCT3JTQU890XIDY2jZtZKRS9IGz7TKMatL7+pPvzlhe9LKTM2Bv8
         K3MhkNh1uM4Fh/4UcI1sHVjHGjxbYtJN3Xq3CbeCZnaRqogMs13Tteb9sSxBJOUUaKc9
         onow==
X-Gm-Message-State: AOAM533rQtiSQo05GaOedLnBxejIE2EW7nCP+kXE6XR21LxcmsNZSKa3
        nMa11DHaGpd/ujqaX4amWJKJ8GNOwOudIbbc+hskiA==
X-Google-Smtp-Source: ABdhPJxp1zHg9orfHLA4DxS/aPs6yXf+FaQFIM0yFzrnyVQSIhnLSBsFRL5ueiuX7jQGdzoJNatdjDZo/i07lks8nOE=
X-Received: by 2002:a05:6808:1283:b0:32e:f2d1:b2ac with SMTP id
 a3-20020a056808128300b0032ef2d1b2acmr2812570oiw.13.1654834941822; Thu, 09 Jun
 2022 21:22:21 -0700 (PDT)
MIME-Version: 1.0
References: <20220609083916.36658-1-weijiang.yang@intel.com>
 <20220609083916.36658-4-weijiang.yang@intel.com> <587f8bc5-76fc-6cd7-d3d7-3a712c3f1274@gmail.com>
 <987d8a3d-19ef-094d-5c0e-007133362c30@intel.com> <CALMp9eT4JD-jTwOmpsayqZvheh4BvWB2aUiRAGsxNT145En6xg@mail.gmail.com>
 <ddff538b-81c4-6d96-bda8-6f614f1304fa@gmail.com> <CALMp9eQL1YmS+Ysn7ZPQjcha6HoqALNVTBqTLO7iTFpZMgyUAg@mail.gmail.com>
In-Reply-To: <CALMp9eQL1YmS+Ysn7ZPQjcha6HoqALNVTBqTLO7iTFpZMgyUAg@mail.gmail.com>
From:   Jim Mattson <jmattson@google.com>
Date:   Thu, 9 Jun 2022 21:22:10 -0700
Message-ID: <CALMp9eRO0K7L=OtoE4MWok6_7cy0DX5FyjPw6Sv83cZBCws0AQ@mail.gmail.com>
Subject: Re: [kvm-unit-tests PATCH 3/3] x86: Skip perf related tests when pmu
 is disabled
To:     Like Xu <like.xu.linux@gmail.com>
Cc:     "Yang, Weijiang" <weijiang.yang@intel.com>, kvm@vger.kernel.org,
        "Paolo Bonzini - Distinguished Engineer (kernel-recipes.org) (KVM HoF)" 
        <pbonzini@redhat.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED,USER_IN_DEF_DKIM_WL,
        USER_IN_DEF_SPF_WL autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Jun 9, 2022 at 9:16 PM Jim Mattson <jmattson@google.com> wrote:
>
> On Thu, Jun 9, 2022 at 7:49 PM Like Xu <like.xu.linux@gmail.com> wrote:
>
> > RDPMC Intel Operation:

Actually, the key phrase is also present in the pseudocode you quoted:

> > MSCB = Most Significant Counter Bit (* Model-specific *)
> > IF (((CR4.PCE = 1) or (CPL = 0) or (CR0.PE = 0)) and (ECX indicates a supported
> > counter))
 ...

The final conjunct in that condition is false under KVM when
!enable_pmu, because there are no supported counters.
