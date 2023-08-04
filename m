Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 56A3F76F68C
	for <lists+kvm@lfdr.de>; Fri,  4 Aug 2023 02:40:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232225AbjHDAkm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 3 Aug 2023 20:40:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38324 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229632AbjHDAkl (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 3 Aug 2023 20:40:41 -0400
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 044A3211F
        for <kvm@vger.kernel.org>; Thu,  3 Aug 2023 17:40:40 -0700 (PDT)
Received: by mail-yb1-xb4a.google.com with SMTP id 3f1490d57ef6-d27ac992539so1609725276.3
        for <kvm@vger.kernel.org>; Thu, 03 Aug 2023 17:40:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1691109639; x=1691714439;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=2MTPG25T990bVHJJfSXBJqNtxyxIeDTfGkDNbbn9VRo=;
        b=iW8mrfPxZd6Y73dLSWJB8xTj6eLOlzlP6IPatG1zrb9Y89hhKoXzIJeR7vbjVwKNEN
         yDJ2DN2qGreGCJEZQJmiYlW3hT4+ihZctX8cQela4iH5oeDxROUoQDGk5gZevGQuVT4v
         fUljMMElPag1IfLrYDj8Puli35vdMbqrHVDsTInoeEpeCnXAYDxtw2amtbFHCTMp3IGN
         JJHz1r6vu+UAG8wvf7l8a3mCAjQHAcntCRyvPZhGUReQipoon92zvMxYeWcRtR7HHv0t
         WV+FDmI6+B8XGjOTdQP43ohlRkuhwcKupPlrNeSDv3fwfuV9ThiZ38wMKYs2uYT+aACE
         scCQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1691109639; x=1691714439;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=2MTPG25T990bVHJJfSXBJqNtxyxIeDTfGkDNbbn9VRo=;
        b=DlIqoO2NYFCJ3UGhqpl2ctcN4Kt8iOcc0P9w+N4yUcVu+kPgdTMhtPcu2E8iwbWudT
         SzLzUNcPutycOYxsiNNAPp/6+MlLLJ+QmwRlDEWAFz2sFdHVAdG2rMaoG/mxX0DXAj+l
         yH2WhWxmDujx8obXphedTThAAKzXO/cboE4UnHkE9TTcF4tKRkewFf4Sr8TLlU8oYlE5
         seVstynqWvZw79zMB7h/usKPTVyZXgjUH9HPzIVrG8OPsHzkFM9yXg8sETIEXh19pSON
         h1eWtlIC8C0DUIWza9298I3zOLj0u3CV/5GMbLnBoG9TOTfN5REXkbPnxnCQwhYdDm5j
         7Bww==
X-Gm-Message-State: AOJu0YxV0ZKintHRe7pY2rx9jITG5vknj4JJWuYZW370eCt2OfAlcS49
        J2dhdolPwvYnsaTEL5NATWSl3pXErnQ=
X-Google-Smtp-Source: AGHT+IEJhILmalCdW3UiHIHpablrybyGDuSz9AiVfz/YiWvbHs7HVTkacldRuQREBUWnzwu1QyZyAs7NmPE=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6902:1363:b0:d0d:cce3:d32d with SMTP id
 bt3-20020a056902136300b00d0dcce3d32dmr724ybb.6.1691109639295; Thu, 03 Aug
 2023 17:40:39 -0700 (PDT)
Date:   Thu,  3 Aug 2023 17:40:24 -0700
In-Reply-To: <20230729011608.1065019-1-seanjc@google.com>
Mime-Version: 1.0
References: <20230729011608.1065019-1-seanjc@google.com>
X-Mailer: git-send-email 2.41.0.585.gd2178a4bd4-goog
Message-ID: <169110235118.1966695.6759395684478323945.b4-ty@google.com>
Subject: Re: [PATCH v2 00/21] KVM: x86: Add "governed" X86_FEATURE framework
From:   Sean Christopherson <seanjc@google.com>
To:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Maxim Levitsky <mlevitsk@redhat.com>
Content-Type: text/plain; charset="utf-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,
        USER_IN_DEF_DKIM_WL autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, 28 Jul 2023 18:15:47 -0700, Sean Christopherson wrote:
> Add a framework to manage and cache KVM-governed features, i.e. CPUID
> based features that require explicit KVM enabling and/or need to be
> queried semi-frequently by KVM.  The idea originally came up in the
> context of the architectural LBRs series as a way to avoid querying
> guest CPUID in hot paths without needing a dedicated flag, but as
> evidenced by the shortlog, the most common usage is to handle the ever-
> growing list of SVM features that are exposed to L1.
> 
> [...]

Applied to kvm-x86 misc.  I'm still hoping for reviews before sending this on
to Paolo, but I also want to get this into -next sooner than later.  And I
tried to grab everything else for "misc" ahead of time, so hopefully there won't
be much, if any, collateral damage if I need to unwind.

[01/21] KVM: nSVM: Check instead of asserting on nested TSC scaling support
        https://github.com/kvm-x86/linux/commit/06b2c8f7d994
[02/21] KVM: nSVM: Load L1's TSC multiplier based on L1 state, not L2 state
        https://github.com/kvm-x86/linux/commit/3b5ebb78fdc4
[03/21] KVM: nSVM: Use the "outer" helper for writing multiplier to MSR_AMD64_TSC_RATIO
        https://github.com/kvm-x86/linux/commit/b5b10353a0c6
[04/21] KVM: SVM: Clean up preemption toggling related to MSR_AMD64_TSC_RATIO
        https://github.com/kvm-x86/linux/commit/3e6e20a49690
[05/21] KVM: x86: Always write vCPU's current TSC offset/ratio in vendor hooks
        https://github.com/kvm-x86/linux/commit/c1a3910b30f6
[06/21] KVM: nSVM: Skip writes to MSR_AMD64_TSC_RATIO if guest state isn't loaded
        https://github.com/kvm-x86/linux/commit/923428d7f741
[07/21] KVM: x86: Add a framework for enabling KVM-governed x86 features
        https://github.com/kvm-x86/linux/commit/ed425263d977
[08/21] KVM: x86/mmu: Use KVM-governed feature framework to track "GBPAGES enabled"
        https://github.com/kvm-x86/linux/commit/f274417a0920
[09/21] KVM: VMX: Recompute "XSAVES enabled" only after CPUID update
        https://github.com/kvm-x86/linux/commit/73db29bfc576
[10/21] KVM: VMX: Check KVM CPU caps, not just VMX MSR support, for XSAVE enabling
        https://github.com/kvm-x86/linux/commit/82816e485b02
[11/21] KVM: VMX: Rename XSAVES control to follow KVM's preferred "ENABLE_XYZ"
        https://github.com/kvm-x86/linux/commit/080b5890f88e
[12/21] KVM: x86: Use KVM-governed feature framework to track "XSAVES enabled"
        https://github.com/kvm-x86/linux/commit/ae1f7788d4a3
[13/21] KVM: nVMX: Use KVM-governed feature framework to track "nested VMX enabled"
        https://github.com/kvm-x86/linux/commit/d60c21f44fe2
[14/21] KVM: nSVM: Use KVM-governed feature framework to track "NRIPS enabled"
        https://github.com/kvm-x86/linux/commit/f32e9ba4ff57
[15/21] KVM: nSVM: Use KVM-governed feature framework to track "TSC scaling enabled"
        https://github.com/kvm-x86/linux/commit/417293d8eebc
[16/21] KVM: nSVM: Use KVM-governed feature framework to track "vVM{SAVE,LOAD} enabled"
        https://github.com/kvm-x86/linux/commit/a179919b6b08
[17/21] KVM: nSVM: Use KVM-governed feature framework to track "LBRv enabled"
        https://github.com/kvm-x86/linux/commit/2a688180ae59
[18/21] KVM: nSVM: Use KVM-governed feature framework to track "Pause Filter enabled"
        https://github.com/kvm-x86/linux/commit/2b4a6cce48b6
[19/21] KVM: nSVM: Use KVM-governed feature framework to track "vGIF enabled"
        https://github.com/kvm-x86/linux/commit/994e74975227
[20/21] KVM: nSVM: Use KVM-governed feature framework to track "vNMI enabled"
        https://github.com/kvm-x86/linux/commit/17e2299ac6a6
[21/21] KVM: x86: Disallow guest CPUID lookups when IRQs are disabled
        https://github.com/kvm-x86/linux/commit/20b18b1dea4c

--
https://github.com/kvm-x86/linux/tree/next
https://github.com/kvm-x86/linux/tree/fixes
