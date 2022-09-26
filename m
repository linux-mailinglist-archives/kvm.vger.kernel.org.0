Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 278045EB2E8
	for <lists+kvm@lfdr.de>; Mon, 26 Sep 2022 23:14:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231356AbiIZVOC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 26 Sep 2022 17:14:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51566 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231339AbiIZVOA (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 26 Sep 2022 17:14:00 -0400
Received: from mail-oi1-x229.google.com (mail-oi1-x229.google.com [IPv6:2607:f8b0:4864:20::229])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2A3B09E129
        for <kvm@vger.kernel.org>; Mon, 26 Sep 2022 14:14:00 -0700 (PDT)
Received: by mail-oi1-x229.google.com with SMTP id q10so2247046oib.5
        for <kvm@vger.kernel.org>; Mon, 26 Sep 2022 14:14:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date;
        bh=nH0YFk0S4zFhxlF0ek4zsM6fw4Eo9gnemmrrWZpSvK0=;
        b=N1Da+bWelRVayYyB20TFnVIwMYhEkcjb+vqWk3mAUvRUT2GxTlBLELNW0YSAqoQVpg
         qraVvV6YqQsPm2vCcIKF8p++DR0JrXNJIh+TlWN1QJdaFwQy8KZ+7kwlEOHDyMT9+2j/
         14/QY/RXXCnZWaX50irPZ8IF94YEnK78qaolUx4F5NhR/tTjDAsiUuqtsdLxQdOfzw/2
         n4kyPDyASv5qFsrfI5HleMSNf6qOv/h1DojOSTfPFygvP3AQCXXzgLuIeSKuNF9PfLb6
         aGsifzz1HO6LfmDVjw6JwoXJtZR00dhEZ5az1cCl7UHzsJzBIRxvtMbb6WlmOt/IQAhD
         Z+5w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date;
        bh=nH0YFk0S4zFhxlF0ek4zsM6fw4Eo9gnemmrrWZpSvK0=;
        b=ZZ/3CEAr299bnt+FJcr4gKAe+CPy2GZ6Cy2cldIjLbH3KR9U4XzOitzCMt3nAI4BCi
         y78s/ulmpq+MOM+sYBVBd0ce5RCglYxmlMrh/ow8goohuRhhFcfojpPxDYvXp+ktXi+4
         VQQlGH7NYl7NDVTI36+y/VxSdlJmmOC/TR8gRBGfBTiizr2IMMK0kE+i5zS206n+qq19
         YByvEJHTbs4biX5V+X3ENkj5u1eJckbZLcuPH2Mic8tQ1vmuTZQc1PhluaptWUpj9vJQ
         zfYx9EoXAt5hJeQ0xRquQibL+FRa5ipokTHhqlbOCcQ5xpQGK5UdcueBkm4IDDMuX3WE
         CX9A==
X-Gm-Message-State: ACrzQf1ddYAF92S6alSIY9cwtrlDYArUrvjK3v5vPdtW65n824+tPO2H
        u7+qJ6Pwrgz6m2oq2XHsiPJkpXaW4nzwVH5+xxGa0g==
X-Google-Smtp-Source: AMsMyM6ndTC5AcWJjwLsN02RcyyK6Ex5cT14OIMHOE4DNIwyrBO6c6jpghLJkZL3KB2ScC1ekFmPFg7IRzBD/BSRY8Q=
X-Received: by 2002:aca:a8d0:0:b0:34f:7065:84b8 with SMTP id
 r199-20020acaa8d0000000b0034f706584b8mr330914oie.13.1664226839345; Mon, 26
 Sep 2022 14:13:59 -0700 (PDT)
MIME-Version: 1.0
References: <20220923223338.483103-1-jmattson@google.com> <YzIQigG1cVLoHQvm@google.com>
In-Reply-To: <YzIQigG1cVLoHQvm@google.com>
From:   Jim Mattson <jmattson@google.com>
Date:   Mon, 26 Sep 2022 14:13:48 -0700
Message-ID: <CALMp9eQE2_a3YexGYGrAXv3GCLDhQgS8JeW5xQnFTqKfwGO54A@mail.gmail.com>
Subject: Re: [PATCH] KVM: x86: Pass host's CPUID.16H through to KVM_GET_SUPPORTED_CPUID
To:     Sean Christopherson <seanjc@google.com>
Cc:     kvm@vger.kernel.org, pbonzini@redhat.com
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

On Mon, Sep 26, 2022 at 1:50 PM Sean Christopherson <seanjc@google.com> wrote:
>
> On Fri, Sep 23, 2022, Jim Mattson wrote:
> > In the default configuration, the guest TSC frequency is the same as
> > the host TSC frequency. Similarly, the maximum frequency of the
> > virtual CPU is the same as the maximum frequency of the physical
> > CPU.
>
> Under the hood, yes, but after the VM is migrated, isn't it possible that the
> host frequencies are completely disjoint from the frequencies that are enumerated
> to the guest?
>
> > Also, the bus (reference) frequency of the virtual CPU matches
> > that of the physical CPU.
> >
> > Pass this information directly from host CPUID.16H to guest CPUID.16H
> > in KVM_GET_SUPPORTED_CPUID.
>
> What about "solving" this via documentation, same as CPUID.15H?  If the API were
> KVM_GET_DEFAULT_CPUID, then enumerating host properties makes sense, but from a
> very pedantic point of view, the "supported" frequencies are just about anything.

Fair enough. Userspace will just have to figure out how to populate
this leaf on its own (or leave it blank).

> Somewhat of a moot point, as the leaf comes with "informational only" disclaimer.
>
>   The returned information should not be used for any other purpose as the returned
>   information does not accurately correlate to information / counters returned by
>   other processor interfaces.
