Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 634AC24C7CD
	for <lists+kvm@lfdr.de>; Fri, 21 Aug 2020 00:36:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728376AbgHTWf6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 20 Aug 2020 18:35:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37452 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726666AbgHTWf5 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 20 Aug 2020 18:35:57 -0400
Received: from mail-oi1-x242.google.com (mail-oi1-x242.google.com [IPv6:2607:f8b0:4864:20::242])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 71B57C061385
        for <kvm@vger.kernel.org>; Thu, 20 Aug 2020 15:35:57 -0700 (PDT)
Received: by mail-oi1-x242.google.com with SMTP id h3so3279764oie.11
        for <kvm@vger.kernel.org>; Thu, 20 Aug 2020 15:35:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=FmMIo8IyiREh96JgFipUSZ+7AJ0OSUn/XGVI1YhMu/0=;
        b=vAncOIMujCgfELDl/4+VX+Bl7dfAI7Ht7h4Naxer2dzWlROnCr1TcDqSCzs96uWExg
         i3gh0lloIFBcCMrh87i8hts7bgYJY+Jk7YgRrfJjNX+Ico05lsSZbrVmhrgaIG/egFem
         60v3LmUXtVfWx7b8s9bgNR1dBOHeI5oC+h9ulE2ynaxGT+0xuXsdL/fwiVYjXOhxnn8l
         PY1e/oL8dJwWFRbL5hPN57h/wEPxYoVFJTxjtCIzpyKziKHY1QQwK/nI8AKgj4ii6iE/
         fSuoikTcHbLzTJLre8BbT8Bq242mLf7pv67vPAUEGVS2jm1K38oZkwS7M5zY+2k0OR/0
         6cHA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=FmMIo8IyiREh96JgFipUSZ+7AJ0OSUn/XGVI1YhMu/0=;
        b=VjUDAAbQIieEps/HEMexX2QJP65ceAp1X836vlx9us10/MABuZ29Tyj9emIIY4/tWY
         qPWsMz5r0VQPFVvyVc+QV+koLmDCDTryQhVAeG9N0ZSaLZZS+a6q7yBu+PgSCOOCSr4J
         cjYSIuZm3XSfNCMeb9rS8rkzasP0OU0ys4uLC+lVdEMW2dWTRtukJvcrWhVTEmTBoGYX
         eoeyxPOQui3yfD7vgnRQOF8iV8ykxcxf7TMLVq4QC6VSuz887ZrUV94nn6iSeTT+EMpK
         ZUY1UVGERgmczV3NDmVBesBAdrX1T63N0CKDAGRHjYIf4FaxofMW7j99YLzRZn+BR9Xz
         DgbQ==
X-Gm-Message-State: AOAM530j5PWXa+UYC+lKTTUqRDSHU9RdJnAV984hfXDecxc3n6LFXHoy
        PAZkWrx7EmpEmqskKf0dQ4dlfqYrTXKDJzHQ1sS0oNKs4U9joQ==
X-Google-Smtp-Source: ABdhPJzmAWwTE2XJx1BJGYAjE68tTYAk2VUVG6fKf7spWLVQm4IQJAQQzBhpOBPzNYiAb+XiZQVifpyWiY51gRu/G14=
X-Received: by 2002:aca:b942:: with SMTP id j63mr98265oif.28.1597962956479;
 Thu, 20 Aug 2020 15:35:56 -0700 (PDT)
MIME-Version: 1.0
References: <20200818211533.849501-1-aaronlewis@google.com>
 <20200818211533.849501-8-aaronlewis@google.com> <522d8a2f-8047-32f6-a329-c9ace7bf3693@amazon.com>
 <CAAAPnDFEKOQjTKcmkFjP6hr6dgmR-61NL_W9=7Fs0THdOOJ7+Q@mail.gmail.com> <d75a3862-d4f4-e057-5d45-9edcb3f9b696@amazon.com>
In-Reply-To: <d75a3862-d4f4-e057-5d45-9edcb3f9b696@amazon.com>
From:   Jim Mattson <jmattson@google.com>
Date:   Thu, 20 Aug 2020 15:35:45 -0700
Message-ID: <CALMp9eRQ3FYOW08tbLJ79KJ32dD8K7djSoze9rcV0tuGbfVgLw@mail.gmail.com>
Subject: Re: [PATCH v3 07/12] KVM: x86: Ensure the MSR bitmap never clears
 userspace tracked MSRs
To:     Alexander Graf <graf@amazon.com>
Cc:     Aaron Lewis <aaronlewis@google.com>, kvm list <kvm@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Aug 20, 2020 at 3:04 PM Alexander Graf <graf@amazon.com> wrote:
>
>
>
> On 20.08.20 02:18, Aaron Lewis wrote:
> >
> > On Wed, Aug 19, 2020 at 8:26 AM Alexander Graf <graf@amazon.com> wrote:
> >>
> >>
> >>
> >> On 18.08.20 23:15, Aaron Lewis wrote:
> >>>
> >>> SDM volume 3: 24.6.9 "MSR-Bitmap Address" and APM volume 2: 15.11 "MS
> >>> intercepts" describe MSR permission bitmaps.  Permission bitmaps are
> >>> used to control whether an execution of rdmsr or wrmsr will cause a
> >>> vm exit.  For userspace tracked MSRs it is required they cause a vm
> >>> exit, so the host is able to forward the MSR to userspace.  This chan=
ge
> >>> adds vmx/svm support to ensure the permission bitmap is properly set =
to
> >>> cause a vm_exit to the host when rdmsr or wrmsr is used by one of the
> >>> userspace tracked MSRs.  Also, to avoid repeatedly setting them,
> >>> kvm_make_request() is used to coalesce these into a single call.
> >>>
> >>> Signed-off-by: Aaron Lewis <aaronlewis@google.com>
> >>> Reviewed-by: Oliver Upton <oupton@google.com>
> >>
> >> This is incomplete, as it doesn't cover all of the x2apic registers.
> >> There are also a few MSRs that IIRC are handled differently from this
> >> logic, such as EFER.
> >>
> >> I'm really curious if this is worth the effort? I would be inclined to
> >> say that MSRs that KVM has direct access for need special handling one
> >> way or another.
> >>
> >
> > Can you please elaborate on this?  It was my understanding that the
> > permission bitmap covers the x2apic registers.  Also, I=E2=80=99m not s=
ure how
>
> So x2apic MSR passthrough is configured specially:
>
>
> https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/tree/a=
rch/x86/kvm/vmx/vmx.c#n3796
>
> and I think not handled by this patch?

By happenstance only, I think, since there is also a call there to
vmx_disable_intercept_for_msr() for the TPR when x2APIC is enabled.
