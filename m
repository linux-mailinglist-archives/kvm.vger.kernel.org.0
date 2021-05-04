Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D62C3372F47
	for <lists+kvm@lfdr.de>; Tue,  4 May 2021 19:53:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232243AbhEDRyP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 4 May 2021 13:54:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47714 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232199AbhEDRyN (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 4 May 2021 13:54:13 -0400
Received: from mail-ot1-x32b.google.com (mail-ot1-x32b.google.com [IPv6:2607:f8b0:4864:20::32b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3BB23C06174A
        for <kvm@vger.kernel.org>; Tue,  4 May 2021 10:53:18 -0700 (PDT)
Received: by mail-ot1-x32b.google.com with SMTP id g7-20020a9d5f870000b02902a5831ad705so8978583oti.10
        for <kvm@vger.kernel.org>; Tue, 04 May 2021 10:53:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=zBVMDvBEgjOjeMHbsEdTwYO7oiRFE8elSZdEfzu5kjo=;
        b=Hwj5AUvMrkRZauysJ4VIPZwfbnyHCjpUlARF9+kvnwXT7wKAuwkiCxrkcYY3bdDBFn
         TEUc9RwalezA/Ckl+j7dqQymKma/SAYUwK6AZOImiV1IE93bVdcOVHcVLfFeoXtIFSjO
         WyHBfaAyMJTsNoGt94zojRlK4hvKRV5Ben96Dd/KEqG/L93A93JlgiO5/MJ2FkiKokPO
         LP0HemyBSPR8eJiHlwoMtgTUvV3pAn0H4u8Mhgg+MQX5P45th0DljBpemVYxJyuoxshY
         Au9dpfeGBkduOEELK7ULyvyGjy53epUFFrz1yA9X6WHSYSNU7nc5bdsIuKUpL/ggN3+k
         LcJA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=zBVMDvBEgjOjeMHbsEdTwYO7oiRFE8elSZdEfzu5kjo=;
        b=tx0leFZqy7R/M7DaGnwFF08svEga4bIjDTDxcZbNu4+Uws0muQyrh1Oo3m0S+Z06R+
         Rz5oO1vW9rYcXNGcNaXdyc2Ff7gpuiwG/I37aidD1V6pzCTzfuHDyPAE2Jrh1fgd94ES
         uvSQCOSBayAzRvaDUGpF2yF2HZacccZSDcoGiGpcsnAPUEfInxCBWRtesILBKu2QtTuq
         wq8r+hIS0ncNWASzjjNj8OXTNOYOnb9touEhjnvqA/Ki470rxY6eRNqyUJ27tD3wMICk
         uVW1x8ByoP3iJjr8RmLYI0kOW2WmDpy7PmvgUWF2Dut6c7MsM+lUqfXBRzSK8kmPBsjc
         37OA==
X-Gm-Message-State: AOAM530V9jOzfOZdXK6s4nrJyoBbU4y9VXExLSuWZ2Wcws/V7JIPbh7D
        TFdHuTotV1oushWgBui6UeKtuqedN1OuYHStYPPsYw==
X-Google-Smtp-Source: ABdhPJybH8tugiuOvAR59PbiEySOPnTUmRDfAz8EGG36kg/E0g04w83cO+/0DMLypHj9WwWuxaOMfd0B90CRESZwTus=
X-Received: by 2002:a9d:1b4d:: with SMTP id l71mr20519674otl.241.1620150797159;
 Tue, 04 May 2021 10:53:17 -0700 (PDT)
MIME-Version: 1.0
References: <20210504171734.1434054-1-seanjc@google.com> <20210504171734.1434054-2-seanjc@google.com>
 <CALMp9eToSSQ=8Dy4Vt5-GYEB4YB9c6-LTp8c60C97LOY9ufdjg@mail.gmail.com>
In-Reply-To: <CALMp9eToSSQ=8Dy4Vt5-GYEB4YB9c6-LTp8c60C97LOY9ufdjg@mail.gmail.com>
From:   Jim Mattson <jmattson@google.com>
Date:   Tue, 4 May 2021 10:53:06 -0700
Message-ID: <CALMp9eQEP32pqFMtn2WZy1B_Aq1x-J52WhF2tC0dNd0vrdhmPg@mail.gmail.com>
Subject: Re: [PATCH 01/15] KVM: VMX: Do not adverise RDPID if ENABLE_RDTSCP
 control is unsupported
To:     Sean Christopherson <seanjc@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Joerg Roedel <joro@8bytes.org>, kvm list <kvm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Xiaoyao Li <xiaoyao.li@intel.com>,
        Reiji Watanabe <reijiw@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, May 4, 2021 at 10:37 AM Jim Mattson <jmattson@google.com> wrote:
>
> On Tue, May 4, 2021 at 10:17 AM Sean Christopherson <seanjc@google.com> wrote:
> >
> > Clear KVM's RDPID capability if the ENABLE_RDTSCP secondary exec control is
> > unsupported.  Despite being enumerated in a separate CPUID flag, RDPID is
> > bundled under the same VMCS control as RDTSCP and will #UD in VMX non-root
> > if ENABLE_RDTSCP is not enabled.
> >
> > Fixes: 41cd02c6f7f6 ("kvm: x86: Expose RDPID in KVM_GET_SUPPORTED_CPUID")
> > Cc: stable@vger.kernel.org
> > Signed-off-by: Sean Christopherson <seanjc@google.com>
>
> But KVM will happily emulate RDPID if the instruction causes a #UD
> VM-exit, won't it? See commit fb6d4d340e05 (KVM: x86: emulate RDPID).

Oh, after reading the second patch, I now see why this is needed.

You mispelled 'advertise' in the summary line.

Reviewed-by: Jim Mattson <jmattson@google.com>
