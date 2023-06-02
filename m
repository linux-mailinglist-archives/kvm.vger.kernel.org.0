Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A289071F75B
	for <lists+kvm@lfdr.de>; Fri,  2 Jun 2023 02:50:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233139AbjFBAuq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 1 Jun 2023 20:50:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60896 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229682AbjFBAup (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 1 Jun 2023 20:50:45 -0400
Received: from mail-yw1-x1149.google.com (mail-yw1-x1149.google.com [IPv6:2607:f8b0:4864:20::1149])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8C1EFF2
        for <kvm@vger.kernel.org>; Thu,  1 Jun 2023 17:50:43 -0700 (PDT)
Received: by mail-yw1-x1149.google.com with SMTP id 00721157ae682-5655d99da53so37003717b3.0
        for <kvm@vger.kernel.org>; Thu, 01 Jun 2023 17:50:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1685667043; x=1688259043;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=UwDLvloBHLyRnlYV3ilTxE4DfXWJDonOEINeBkDblso=;
        b=ioyx/i5EjbogKgkMKMycd7DwDlffY7dtgmNR4/95N0IhgC40k/BLk6Q4bWmoDv+vxr
         GIolc3vF+dr9ORF0r6N6zs1JF4pmqnSWh7zryylKxB8jcVyd7alDEDyxB7pvhiPpHviG
         JHEPmGctVGXgShujLr2EVSmNDX2A1GSRimJJcDM7U1YjQpsnlHd8iPEzccplQcCqSdcx
         7Yvwdihx9U3mylWk6i3/ITuBt8+BzkwP0ZHJYNi8Yzzk3bvTnmP7n+2ZBVwqyR5mp1wC
         spnnzHQogWGIG8upOOYGiGEEuIx1FPgeRjlyqWyO6B4fLV+u41R8C91SCawHMRYo5MUE
         ho5g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685667043; x=1688259043;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=UwDLvloBHLyRnlYV3ilTxE4DfXWJDonOEINeBkDblso=;
        b=MUH/PizHfA6SQ9fX7oQXQE2/uIjHRUdHeub6gGXfl4AiU0YrNzX3txTPJlFyejtCYO
         EXycVo6DtmjkKaPB06LvuXRanYPCUmWDtlbw9ZsG46Wg0urtklSG78FWFHjEHR1fOXuw
         mAcJgEbill2SHTFflbgM/40marUc0/B7q9uqYGPq0fao/EVwWUV39YXrpEI6x19DOpIC
         CtwWYSLdh/wCyeIBKzV0TTq/vhX56xa0lw8FwNhCBbbxCewgwU9JTI1fghnggF39N0iJ
         +gPri1LEfTNw4RvKCC2OLIpx4ADjFyUtcl1YoD4tankY8eNbtA2M7VdrQWoHpw/jkj+0
         weqA==
X-Gm-Message-State: AC+VfDyo7GzP0nDjt+TEDd9KCGeZR5/hU0I+ZcNh5dJ5C2AuS+k6V/yG
        KFGYBZP4DTu9cH4mdFWQl37RKnLC4YY=
X-Google-Smtp-Source: ACHHUZ658NqNsdViSWdcB5ZYCHZmMOFx+wxk5f24o6x1at/+KIqRTfU+iG14fzFBoHZWLvXBi2RGAiAYz/Q=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:690c:386:b0:561:1494:69f8 with SMTP id
 bh6-20020a05690c038600b00561149469f8mr2639416ywb.1.1685667042796; Thu, 01 Jun
 2023 17:50:42 -0700 (PDT)
Date:   Thu, 1 Jun 2023 17:50:41 -0700
In-Reply-To: <20230530060423.32361-6-likexu@tencent.com>
Mime-Version: 1.0
References: <20230530060423.32361-1-likexu@tencent.com> <20230530060423.32361-6-likexu@tencent.com>
Message-ID: <ZHk84Ts9txpz5djC@google.com>
Subject: Re: [PATCH v6 05/10] KVM: x86/pmu: Disable vPMU if the minimum num of
 counters isn't met
From:   Sean Christopherson <seanjc@google.com>
To:     Like Xu <like.xu.linux@gmail.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Jim Mattson <jmattson@google.com>
Content-Type: text/plain; charset="us-ascii"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, May 30, 2023, Like Xu wrote:
> According to Intel SDM, "Intel Core Solo and Intel Core Duo processors
> support base level functionality identified by version ID of 1. Processors
> based on Intel Core microarchitecture support, at a minimum, the base
> level functionality of architectural performance monitoring." Those
> antique processors mentioned above all had at least two GP counters,
> subsequent processors had more and more GP counters, and given KVM's
> quirky handling of MSR_P6_PERFCTR0/1, the value of MIN_NR_GP_COUNTERS
> for the Intel Arch PMU can safely be 2.

Not sure what you mean by "safely", but I don't think this is correct.  KVM can,
and more importantly has up until this point, supported a vPMU so long as the CPU
has at least one counter.  Perf's support for P6/Core CPUs does appear to expect
and require 2 counters, but unless I'm misreading arch/x86/events/intel/core.c,
perf will happily chug along with a single counter when running on a modern CPU.
I doubt such a CPU exists in real silicon, but I can certainly imagine a virtual
CPU being configured with a single counter, and this change would break such a
setup.

And *if* we really want to raise the minimum to '2', that should be done in a
separate commit.  But I don't see any reason to force the issue.

No need to send v7 just for this, I can fixup when applying (planning on reviewing
the series tomorrow).
