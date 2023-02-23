Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9249A6A0020
	for <lists+kvm@lfdr.de>; Thu, 23 Feb 2023 01:36:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232860AbjBWAgN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 22 Feb 2023 19:36:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56648 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232935AbjBWAgM (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 22 Feb 2023 19:36:12 -0500
Received: from mail-wm1-x336.google.com (mail-wm1-x336.google.com [IPv6:2a00:1450:4864:20::336])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D2B3D48E1B
        for <kvm@vger.kernel.org>; Wed, 22 Feb 2023 16:36:01 -0800 (PST)
Received: by mail-wm1-x336.google.com with SMTP id p18-20020a05600c359200b003dc57ea0dfeso8229958wmq.0
        for <kvm@vger.kernel.org>; Wed, 22 Feb 2023 16:36:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=tM21s8EVceV6/LVXcxWNp0yqpPhhEPVFfLzEzvls2gc=;
        b=k8M6FMc967RDYLTDnnDDDZBqvu2NGE7W+rdGoNYdiw4/b7/kZzQN16hix+mqd0FYau
         88rcc0hVnEwgg/K5ER0HDMGaorinLh/Mehb8+x4SabBikNNZxNLrvfEbNUpy0gk28iU3
         AUeRc1xP8merzOi4FwbmypGThv1VneHUsrgV/BFXvExajMQ5slH9e4akrokad4Lh0hbt
         F9XCvu9f0NNrHrMgShWZ3TfXc+KqNyxkUAmX34/OWL6sD3U49FCFx4b/gzl8UoMSzAjv
         AonRePkCip7kHnZ4liCeJ3itstgEpcsLpnuSV2jGHZOgYyx0pQ9XHoNOw+kUFUhJDQcP
         oIVA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=tM21s8EVceV6/LVXcxWNp0yqpPhhEPVFfLzEzvls2gc=;
        b=CKSRxVl74o/j15A14PPJGRroxtjj2Nkv56hCXRotKbGsxb05z4+2CNnaHcL7ir8IsC
         reOtGQkNMEPnzg0GUEz2IjsCB/VJyUjGCVUFkZQzoIxG5QWsM7zElY99EvyXTlcSZ2KO
         fXPPLD1X/L/HOW1P7G5tzDNBw5G7IbGVMwwQgyji+S4Cgw4AQ4aV2yCgjtPvk02WyCjJ
         4xn5fErzURkJHu+KbbOyXCEWCGLFyWTtja4dCNxxILWUAGR8scCJV6yeJf97wXrbrjMH
         GgRPPT5AW7OwaNLTxaKz7wYIjOuF13Em8twZ8U5iLHly/l7oR4/uUywyavoAKz+jw6xC
         PybQ==
X-Gm-Message-State: AO0yUKU1Mb4fc572SYSWgGg7NfspfFM23c60w7mZGn3M2cZohX2Q5XFv
        FT6GCtA8s0yjmG78+SI1xOLiQTFbAqnSnOU/aUsnHg==
X-Google-Smtp-Source: AK7set8zVzyqkvXTx9TIzdagwkER9AyH/LsfATHlY5ThqEBDCOs2BWYJ641Vl7lOuh8HEdKyYhV/DrCBu+RqUnTIqhY=
X-Received: by 2002:a05:600c:1e12:b0:3df:97de:8bab with SMTP id
 ay18-20020a05600c1e1200b003df97de8babmr41791wmb.4.1677112560160; Wed, 22 Feb
 2023 16:36:00 -0800 (PST)
MIME-Version: 1.0
References: <20230215011614.725983-1-amoorthy@google.com> <20230215011614.725983-7-amoorthy@google.com>
 <Y+0VK6vZpMqAQ2Dc@google.com>
In-Reply-To: <Y+0VK6vZpMqAQ2Dc@google.com>
From:   Anish Moorthy <amoorthy@google.com>
Date:   Wed, 22 Feb 2023 16:35:48 -0800
Message-ID: <CAF7b7mor-QHwLCLQ_sp4sOJTztRGVOzpBupeuiCicA3YG=-TTQ@mail.gmail.com>
Subject: Re: [PATCH 6/8] kvm/x86: Add mem fault exit on EPT violations
To:     Sean Christopherson <seanjc@google.com>
Cc:     kvm@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
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

On Wed, Feb 15, 2023 at 9:24=E2=80=AFAM Sean Christopherson <seanjc@google.=
com> wrote:
>
> On Wed, Feb 15, 2023, Anish Moorthy wrote:
> > +     if (mem_fault_nowait) {
> > +             if (fault->pfn =3D=3D KVM_PFN_ERR_FAULT) {
> > +                     vcpu->run->exit_reason =3D KVM_EXIT_MEMORY_FAULT;
> > +                     vcpu->run->memory_fault.gpa =3D fault->gfn << PAG=
E_SHIFT;
> > +                     vcpu->run->memory_fault.size =3D PAGE_SIZE;
>
> This belongs in a separate patch, and the exit stuff should be filled in =
by
> kvm_handle_error_pfn().  Then this if-statement goes away entirely becaus=
e the
> "if (!async)" will always evaluate true in the nowait case.

Hi Sean, what exactly did you want "in a separate patch"? Unless you
mean separating
the changes to arch/x86/kvm/mmu/mmu.c and the one-liner to enable the cap i=
n
arch/x86/kvm/x86.c, I don't really understand how this patch could
logically be split.
