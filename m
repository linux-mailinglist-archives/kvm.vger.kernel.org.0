Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E0C8A741A05
	for <lists+kvm@lfdr.de>; Wed, 28 Jun 2023 23:06:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231252AbjF1VFi (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 28 Jun 2023 17:05:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48784 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231766AbjF1VFc (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 28 Jun 2023 17:05:32 -0400
Received: from mail-pg1-x54a.google.com (mail-pg1-x54a.google.com [IPv6:2607:f8b0:4864:20::54a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E34561BC5
        for <kvm@vger.kernel.org>; Wed, 28 Jun 2023 14:05:30 -0700 (PDT)
Received: by mail-pg1-x54a.google.com with SMTP id 41be03b00d2f7-55b10f171e0so82131a12.2
        for <kvm@vger.kernel.org>; Wed, 28 Jun 2023 14:05:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1687986330; x=1690578330;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=iTvXYleREN2yij4E2iUrdc4+zuDCLfU8CgECkdsXphw=;
        b=cWI8VVVE+Ru56ZbxlSZbx0tMknUOLoqjPH2JPTt5mLCocaJ8gX7Q5GfqTwyw8XGY8y
         PfVI/cEtyzXfxg7+mvUwpRuRl8eqK2/VCy6afjdbJRkR8A2uHG24VcLPUGeumDdw6wjW
         /fjXoTwo87IoY9+EB/D/baO17ET5i726YMsEH7tSlt/sXxBioH+K8WmOXUlU72OViZfg
         ZrNji/5MZPDtDPaMe82Gi1qOcIgK2lfxMPkYbzXrIFmxCb2H+Cj9fBUE3W7ZP0ZiojA7
         RD2Bb+g+RkrEX3P7+KT+cZ5/6FqEUiHFxd5KyRD8R+ssSw+LTo8zcHZgVs1QkDkyi08X
         miIw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1687986330; x=1690578330;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=iTvXYleREN2yij4E2iUrdc4+zuDCLfU8CgECkdsXphw=;
        b=k0yFY1XcSwGzAy4gkKgedtxLJfmp68SxdvDuZNrYPeykx4yu93pwGWns06T7byIwst
         nPIxM5ZnFrfZVYdNVdGNJDuAF0u9cMMWQiMdBYbHA7l9VGPabkO1PZAUGWB4zbX6BIQM
         5hluOZN+vTcat+ucxZ0Oc1VK7GhOyKFqYR3xlVgtwin5c7EmM6ms48hegyxJpWTkIyGV
         8fd/tUELmicsRqgjEA4UxnjVT1PgJKZ6qXx80WVdBOFr9cW9/Gv1D7qZTXxPot5K4/8/
         yZnNjgvmvGOMRz84P42oqIfBtkIyjmQ/+EgM50ez6GcSf1GBCI4qsUmDRjR2WJUEMauY
         uebQ==
X-Gm-Message-State: AC+VfDxnOvybGjDbIl84+pOHyLoTpFmtgr96ky3N1DxD7hLLq8MfHaA7
        EK5JToGbAlgZRtpGmvNTKPYHo1WZyZE=
X-Google-Smtp-Source: ACHHUZ7fKOO6PjrVD51fLP7DRQhQIYqcdFWnENpYf47eYPEkqJ8jK/51l1raBdyO8JzNi4eZWC0Mxh4VHnA=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a63:e954:0:b0:55a:c91e:4121 with SMTP id
 q20-20020a63e954000000b0055ac91e4121mr969253pgj.5.1687986330389; Wed, 28 Jun
 2023 14:05:30 -0700 (PDT)
Date:   Wed, 28 Jun 2023 14:05:28 -0700
In-Reply-To: <20230530134248.23998-8-cloudliang@tencent.com>
Mime-Version: 1.0
References: <20230530134248.23998-1-cloudliang@tencent.com> <20230530134248.23998-8-cloudliang@tencent.com>
Message-ID: <ZJygmEIjdWHcqMQ7@google.com>
Subject: Re: [PATCH v2 7/8] KVM: selftests: Test Intel supported fixed
 counters bit mask
From:   Sean Christopherson <seanjc@google.com>
To:     Jinrong Liang <ljr.kernel@gmail.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, Like Xu <likexu@tencent.com>,
        David Matlack <dmatlack@google.com>,
        Aaron Lewis <aaronlewis@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jinrong Liang <cloudliang@tencent.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
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

On Tue, May 30, 2023, Jinrong Liang wrote:
> +static void test_fixed_counters_setup(struct kvm_vcpu *vcpu, uint8_t edx_fix_num,
> +				      uint32_t fixed_bitmask, bool expected)
> +{
> +	struct kvm_cpuid_entry2 *entry;
> +	uint8_t max_fixed_num = X86_INTEL_MAX_FIXED_CTR_NUM;
> +	uint64_t supported_bitmask = 0;
> +	uint64_t msr_val;
> +	unsigned int i;
> +
> +	entry = vcpu_get_cpuid_entry(vcpu, 0xa);
> +	entry->ecx = fixed_bitmask;
> +	entry->edx = (entry->edx & ~FIXED_CTR_NUM_MASK) | edx_fix_num;
> +	vcpu_set_cpuid(vcpu);
> +
> +	for (i = 0; i < max_fixed_num; i++) {
> +		if (entry->ecx & BIT_ULL(i) ||
> +		    ((entry->edx & FIXED_CTR_NUM_MASK) > i))
> +			supported_bitmask |= BIT_ULL(i);
> +	}
> +
> +	vcpu_args_set(vcpu, 2, supported_bitmask, max_fixed_num);

All of this can be queried from the guest, no?  Then you also verify that KVM is
passing in the correct CPUID info too.

> +	while (run_vcpu(vcpu, &msr_val) != UCALL_DONE)
> +		TEST_ASSERT(!!msr_val == expected,
> +			    "Unexpected when testing fixed counter.");

ASSERT_EQ()
