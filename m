Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 71A4324AC06
	for <lists+kvm@lfdr.de>; Thu, 20 Aug 2020 02:19:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726887AbgHTAST (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 19 Aug 2020 20:18:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56950 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726715AbgHTASS (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 19 Aug 2020 20:18:18 -0400
Received: from mail-ed1-x543.google.com (mail-ed1-x543.google.com [IPv6:2a00:1450:4864:20::543])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CFE23C061757
        for <kvm@vger.kernel.org>; Wed, 19 Aug 2020 17:18:17 -0700 (PDT)
Received: by mail-ed1-x543.google.com with SMTP id cq28so252276edb.10
        for <kvm@vger.kernel.org>; Wed, 19 Aug 2020 17:18:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=TuAaMqCSqAubmr9wD4ZNsDvhaFPQUFZIOAfBFHk846w=;
        b=nrDn2FhKJbjkXVTb80pcZRU95qXHJcmizItKrlD1KPEofZLrHrlg2icz2TxBSXJlSS
         Vyb+jrDVN/kSO1c0tVWC5rlnzDg0zR3pMShJUMV7l878QacVbX5qViWsIKzvQ5ORAmwv
         D2nv/KSFFMhl244SgUrro8H5gqZtpHtxMD/qcUU5yhZCggKNF3FeNCw8URmPdbKNeEhj
         gzqt9LnnRH+5BpbN2jDRnzWFyclR8gUbkmeWAF0TPi43NRA5FUUggQ5lKY8F1kkmBvtz
         m0jmZeKaLhJV+5Ftp8Lu9JutPotQwYHAy0l87K3ted4koNiFkRKOyse6bXvFWojujdU0
         WQag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=TuAaMqCSqAubmr9wD4ZNsDvhaFPQUFZIOAfBFHk846w=;
        b=raDVCtjXNNBYL+P1HzK8BBSzhhDYVdZWrsmAVagf1RKs883F0bwUJXMXuXflra2aCQ
         z5snsdfsf3BWA9T9hUmvy/zWHznzBiwHyTs3jndU02ShwZe7sTKviKeFs9jFhLWfrysx
         M34ldZc8GwIuDGvlOHuJZTM1JNPcXA/C8hz53S+FWG7WCAQGFVEcRIZJMHvg9rBSG+ga
         VD9AFKRh/bueBEGSAzJHaZQfJ+c6t7XODorOP2fvzaLs1zd5Yngqc/LfNS/lP5BBSrt3
         7uelTfhNgu5dx93L1hsCbfAS1pBIFJVc/Z7B8JTKdCALWZpfAAymLM8xbSfS4/8N06VB
         7IUQ==
X-Gm-Message-State: AOAM5318zoDayzqFxXeVlbeRQ9iwiGxE/+tDjEAtRzUzKG7cJdQL2cAW
        a2A+4MysH+2EgdHTyiZ4QHxnSJNX9bBJIyupZAeJyQ==
X-Google-Smtp-Source: ABdhPJyo/qiDSmrX22BUtLDejIWEJk6mHb9+juL+POj1WMDaLJFZ9IcNLLpQVDiNE8ShTnkDuu/MN9zT+aQjvxlvaxo=
X-Received: by 2002:a05:6402:b26:: with SMTP id bo6mr554339edb.104.1597882696251;
 Wed, 19 Aug 2020 17:18:16 -0700 (PDT)
MIME-Version: 1.0
References: <20200818211533.849501-1-aaronlewis@google.com>
 <20200818211533.849501-8-aaronlewis@google.com> <522d8a2f-8047-32f6-a329-c9ace7bf3693@amazon.com>
In-Reply-To: <522d8a2f-8047-32f6-a329-c9ace7bf3693@amazon.com>
From:   Aaron Lewis <aaronlewis@google.com>
Date:   Wed, 19 Aug 2020 17:18:04 -0700
Message-ID: <CAAAPnDFEKOQjTKcmkFjP6hr6dgmR-61NL_W9=7Fs0THdOOJ7+Q@mail.gmail.com>
Subject: Re: [PATCH v3 07/12] KVM: x86: Ensure the MSR bitmap never clears
 userspace tracked MSRs
To:     Alexander Graf <graf@amazon.com>
Cc:     Jim Mattson <jmattson@google.com>, kvm list <kvm@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Aug 19, 2020 at 8:26 AM Alexander Graf <graf@amazon.com> wrote:
>
>
>
> On 18.08.20 23:15, Aaron Lewis wrote:
> >
> > SDM volume 3: 24.6.9 "MSR-Bitmap Address" and APM volume 2: 15.11 "MS
> > intercepts" describe MSR permission bitmaps.  Permission bitmaps are
> > used to control whether an execution of rdmsr or wrmsr will cause a
> > vm exit.  For userspace tracked MSRs it is required they cause a vm
> > exit, so the host is able to forward the MSR to userspace.  This change
> > adds vmx/svm support to ensure the permission bitmap is properly set to
> > cause a vm_exit to the host when rdmsr or wrmsr is used by one of the
> > userspace tracked MSRs.  Also, to avoid repeatedly setting them,
> > kvm_make_request() is used to coalesce these into a single call.
> >
> > Signed-off-by: Aaron Lewis <aaronlewis@google.com>
> > Reviewed-by: Oliver Upton <oupton@google.com>
>
> This is incomplete, as it doesn't cover all of the x2apic registers.
> There are also a few MSRs that IIRC are handled differently from this
> logic, such as EFER.
>
> I'm really curious if this is worth the effort? I would be inclined to
> say that MSRs that KVM has direct access for need special handling one
> way or another.
>

Can you please elaborate on this?  It was my understanding that the
permission bitmap covers the x2apic registers.  Also, I=E2=80=99m not sure =
how
EFER is handled differently, but I see there is a separate
conversation on that.

This effort does seem worthwhile as it ensures userspace is able to
manage the MSRs it is requesting, and will remain that way in the
future.


>
> Alex
>
>
>
> Amazon Development Center Germany GmbH
> Krausenstr. 38
> 10117 Berlin
> Geschaeftsfuehrung: Christian Schlaeger, Jonathan Weiss
> Eingetragen am Amtsgericht Charlottenburg unter HRB 149173 B
> Sitz: Berlin
> Ust-ID: DE 289 237 879
>
>
