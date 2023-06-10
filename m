Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BB41772A7BE
	for <lists+kvm@lfdr.de>; Sat, 10 Jun 2023 03:46:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232543AbjFJBqm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 9 Jun 2023 21:46:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38434 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229522AbjFJBql (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 9 Jun 2023 21:46:41 -0400
Received: from mail-pj1-x102d.google.com (mail-pj1-x102d.google.com [IPv6:2607:f8b0:4864:20::102d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0163926B9;
        Fri,  9 Jun 2023 18:46:41 -0700 (PDT)
Received: by mail-pj1-x102d.google.com with SMTP id 98e67ed59e1d1-25692ff86cdso1216278a91.2;
        Fri, 09 Jun 2023 18:46:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1686361600; x=1688953600;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=nO6vzid1K69dvPDtrTKEIUfMDvueRgprm9O2MIgWICA=;
        b=LNV/FdI5PMCvcEXV+WiQ+PVKs5xxGkDes2/0Quu5bksLuYJi7BOzosmvDCYr9IfN2c
         xdAbrSB3r2a2KrDL2+YcW16r6MV+OSUYbFtfSWZL3V3PqINLhXVcMsfMFvlpL5l8/If2
         iYn+PYlKqcdMRQ36S4FNOaUyLe1rUxlv1ayysLrccRG91tHreSjZHSmVmi3vbgbnsBvQ
         E8X1nXQsvqF0peRhameHI38vUHivkri9PcbLfZqjaYF+1rC6ulntc7ruMfPWV9EMrU+4
         iRXbO3Ea9BxOSChhB2SLsAv2JS6erW15Ej3NmSRX8PKr9LClomq9ysZvKumnYxPl3D1c
         V2Mg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686361600; x=1688953600;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=nO6vzid1K69dvPDtrTKEIUfMDvueRgprm9O2MIgWICA=;
        b=NijUcrJiF/HHrSaOKmZHMNBb/OgI5mI5uX483omuoxQfIE+kIdrYQvuHkQjb+XqS9e
         hbz9B/1BG3qUGqqg8JjEFePh32TpPkfOslYVtZNRbsa7R8isHqBxggGHYvjusq4Jrzik
         S7IDvqu/e/vkq5eInV81Lg7mlldT9oonmRtzGAxJaGoeac9mjzLMutmvs0wKP68eQYN5
         iYTbi/faYgE1H6+qdPQnLjiQrOoM2KSaIaYeMJuO9E6QEMTKBY5tKh0MHFnZzZ0SepoJ
         3XX+7XkdtynxnhF6cCS6txFPL5xUX88ht7ZVSjDDQGku59OiZB5HQDo3ygD9a+786ibg
         tTHQ==
X-Gm-Message-State: AC+VfDxFCsVn+F67tHUzoWByNrKxJp3UkR9oZU/jTryfAdyiDniaYHjc
        QF1QpCRFunta7/UmYdhEDYszNMx2eCh4MFX4yXk=
X-Google-Smtp-Source: ACHHUZ48tqUVwDz9/d14iBGqnipYCI/liB2uXObdEuicH3caZ5C/h2oTO6YKZ4sD24Q33UWiGN9OCQLFD9t5U7l/W6g=
X-Received: by 2002:a17:90b:ed8:b0:250:2311:1535 with SMTP id
 gz24-20020a17090b0ed800b0025023111535mr2814927pjb.24.1686361600430; Fri, 09
 Jun 2023 18:46:40 -0700 (PDT)
MIME-Version: 1.0
References: <20230605064848.12319-1-jpn@linux.vnet.ibm.com> <CT6641NE8LNV.20P6CCOLXZEP@wheely>
In-Reply-To: <CT6641NE8LNV.20P6CCOLXZEP@wheely>
From:   Jordan Niethe <jniethe5@gmail.com>
Date:   Sat, 10 Jun 2023 11:46:28 +1000
Message-ID: <CACzsE9rTBTVtdTwSom-mL5ZV0PU86V8epnGvsxdcbJcGeXj5+A@mail.gmail.com>
Subject: Re: [RFC PATCH v2 0/6] KVM: PPC: Nested PAPR guests
To:     Nicholas Piggin <npiggin@gmail.com>
Cc:     Jordan Niethe <jpn@linux.vnet.ibm.com>,
        linuxppc-dev@lists.ozlabs.org, mikey@neuling.org,
        kautuk.consul.1980@gmail.com, kvm@vger.kernel.org,
        kvm-ppc@vger.kernel.org, sbhat@linux.ibm.com, vaibhav@linux.ibm.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Jun 7, 2023 at 3:54=E2=80=AFPM Nicholas Piggin <npiggin@gmail.com> =
wrote:
>
> On Mon Jun 5, 2023 at 4:48 PM AEST, Jordan Niethe wrote:
> > There is existing support for nested guests on powernv hosts however th=
e
> > hcall interface this uses is not support by other PAPR hosts.
>
> I kind of liked it being called nested-HV v1 and v2 APIs as short and
> to the point, but I suppose that's ambiguous with version 2 of the v1
> API, so papr is okay. What's the old API called in this scheme, then?
> "Existing API" is not great after patches go upstream.

Yes I was trying for a more descriptive name but it is just more
confusing and I'm struggling for a better alternative.

In the next revision I'll use v1 and v2. For version 2 of v1
we now call it v1.2 or something like that?

>
> And, you've probably explained it pretty well but slightly more of
> a background first up could be helpful. E.g.,
>
>   A nested-HV API for PAPR has been developed based on the KVM-specific
>   nested-HV API that is upstream in Linux/KVM and QEMU. The PAPR API
>   had to break compatibility to accommodate implementation in other
>   hypervisors and partitioning firmware.
>
> And key overall differences
>
>   The control flow and interrupt processing between L0, L1, and L2
>   in the new PAPR API are conceptually unchanged. Where the old API
>   is almost stateless, the PAPR API is stateful, with the L1 registering
>   L2 virtual machines and vCPUs with the L0. Supervisor-privileged
>   register switching duty is now the responsibility for the L0, which
>   holds canonical L2 register state and handles all switching. This
>   new register handling motivates the "getters and setters" wrappers
>   ...

I'll include something along those lines.

Thanks,
Jordan

>
> Thanks,
> Nick
>
