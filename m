Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A48037A074A
	for <lists+kvm@lfdr.de>; Thu, 14 Sep 2023 16:28:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240139AbjINO2E (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 14 Sep 2023 10:28:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54560 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240145AbjINO2D (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 14 Sep 2023 10:28:03 -0400
Received: from mail-pf1-x449.google.com (mail-pf1-x449.google.com [IPv6:2607:f8b0:4864:20::449])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F17991FD5
        for <kvm@vger.kernel.org>; Thu, 14 Sep 2023 07:27:57 -0700 (PDT)
Received: by mail-pf1-x449.google.com with SMTP id d2e1a72fcca58-68fbd31d9a1so965090b3a.1
        for <kvm@vger.kernel.org>; Thu, 14 Sep 2023 07:27:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1694701677; x=1695306477; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=Vsfbaqk3pugdnSOMYJldf0CNS26AMaT5XkgAatqG0RA=;
        b=NEDQMVdEF+f/9Wobzg8tIiJpBxmZbNTaBpFGKMzeufXHgtRYQj/SzET5xl9FBE7d+f
         n24pXEka8WUEkMz5hxpY9OcyR6HxLNp19pUbgjpJ3ks8SVGFrrisKwTNfLDZjQKfqNzv
         WD4y7pOXkXdsNYb0MkFZbh4d9Jz28OAvU+CpDMHjNg1NPUT6GzcHfTB9wlXb3vgFZxYM
         85nAUScuyooB811dJDpFSv+G/KbZ3wT31ZaeCJGb3rYVF9bELbG+2DR16OpdXExmVWO+
         bm6Wi6otLTX8QJo2CfHI6BSHh0zI0tNi1pF0aGnnbIA3gQd5MznHCAHJMqKdDqByCNIM
         aRAg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1694701677; x=1695306477;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Vsfbaqk3pugdnSOMYJldf0CNS26AMaT5XkgAatqG0RA=;
        b=tMI2BSMWfu/YjGZrZ+AIUmQcxVcmTJOXyEPgrUyebJ+MxH6aXfEC0WCVzz7Sa0Qx2E
         avDyuD9pkQAWGAl8TA+5r1G2EhbqeTbySZAmSfrxYrOnnl+doX9+E3mFhRvPj4yw1XN4
         lHdXLmQ1PdmlkkanjXGwwvFjl4flA0TjQ+CeEbqGDCbYgZVsX8eLew0hu9f+ZMOdEsiN
         +vEmj0UX6qqFNAOsNH01ORTG+YOwJUHOHOGc7PP0G/+uNxAnO4/GLV9wc8lwbkTchyjy
         qY5Hszl672hJ7vF7lDBbckij//f1i/eFUtdxfvBH1xASJ9l5bOuDrHVer6lQXaAFC1gr
         aNVw==
X-Gm-Message-State: AOJu0YzF50bPjnQOpn+nLA09dIvmw9OVOkNKiqIR2+mH1i6DFWjfc/p0
        Aez1Htc/kSEoVviAG+6k8tL4VzbGQXs=
X-Google-Smtp-Source: AGHT+IGGii8oNe71mghet7VY0HpUDsDVt89FoFa+4brUpHc7XLBwaIXYjHyZNgDlhd1qwPUPo/ZPBqS2ly4=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6a00:124a:b0:68a:2c24:57de with SMTP id
 u10-20020a056a00124a00b0068a2c2457demr61338pfi.1.1694701677447; Thu, 14 Sep
 2023 07:27:57 -0700 (PDT)
Date:   Thu, 14 Sep 2023 07:27:55 -0700
In-Reply-To: <3c012a84-de53-0c54-c294-97c1c52b84c3@gmail.com>
Mime-Version: 1.0
References: <20230901185646.2823254-1-jmattson@google.com> <3c012a84-de53-0c54-c294-97c1c52b84c3@gmail.com>
Message-ID: <ZQMYa9q8CyYMuLKu@google.com>
Subject: Re: [PATCH 1/2] KVM: x86: Synthesize at most one PMI per VM-exit
From:   Sean Christopherson <seanjc@google.com>
To:     Like Xu <like.xu.linux@gmail.com>
Cc:     Jim Mattson <jmattson@google.com>,
        Mingwei Zhang <mizhang@google.com>,
        Like Xu <likexu@tencent.com>, Roman Kagan <rkagan@amazon.de>,
        Kan Liang <kan.liang@intel.com>,
        Dapeng1 Mi <dapeng1.mi@intel.com>,
        Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org
Content-Type: text/plain; charset="us-ascii"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Sep 14, 2023, Like Xu wrote:
> On 2/9/2023 2:56 am, Jim Mattson wrote:
> > When the irq_work callback, kvm_pmi_trigger_fn(), is invoked during a
> > VM-exit that also invokes __kvm_perf_overflow() as a result of
> > instruction emulation, kvm_pmu_deliver_pmi() will be called twice
> > before the next VM-entry.
> > 
> > That shouldn't be a problem. The local APIC is supposed to
> 
> As you said, that shouldn't be a problem.

It's still a bug though, overflow should only happen once.

> > automatically set the mask flag in LVTPC when it handles a PMI, so the
> > second PMI should be inhibited. However, KVM's local APIC emulation
> > fails to set the mask flag in LVTPC when it handles a PMI, so two PMIs
> > are delivered via the local APIC. In the common case, where LVTPC is
> > configured to deliver an NMI, the first NMI is vectored through the
> > guest IDT, and the second one is held pending. When the NMI handler
> > returns, the second NMI is vectored through the IDT. For Linux guests,
> > this results in the "dazed and confused" spurious NMI message.
> > 
> > Though the obvious fix is to set the mask flag in LVTPC when handling
> > a PMI, KVM's logic around synthesizing a PMI is unnecessarily
> > convoluted.
> 
> Any obstruction issues on fixing in this direction ?

No, patch 2/2 in this series fixes LVTPC masking bug.  I haven't dug through all
of this yet, but my gut reaction is that I'm very strongly in favor of not using
irq_work just to ensure KVM kicks a vCPU out of HLT.  That's just ridiculous.
