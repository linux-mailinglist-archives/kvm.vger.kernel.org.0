Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6206F68E5BF
	for <lists+kvm@lfdr.de>; Wed,  8 Feb 2023 03:03:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230062AbjBHCDW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 7 Feb 2023 21:03:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35040 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229563AbjBHCDV (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 7 Feb 2023 21:03:21 -0500
Received: from mail-pf1-x44a.google.com (mail-pf1-x44a.google.com [IPv6:2607:f8b0:4864:20::44a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8106129420
        for <kvm@vger.kernel.org>; Tue,  7 Feb 2023 18:03:20 -0800 (PST)
Received: by mail-pf1-x44a.google.com with SMTP id i15-20020aa787cf000000b00593addd14a5so9104150pfo.15
        for <kvm@vger.kernel.org>; Tue, 07 Feb 2023 18:03:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=c+95jXxbZ416BpHiNRrKuwMfS/1unz29UutTwcR9vcQ=;
        b=eGaTHY0Lo5bHQCjeVBaDEgQxuTSrczIII/PcJEuK39MLzach0/v1nIn5fQDwA6y0H0
         Q2F5zhEQPeLOYPfqhqR4H/YAz/cLwOQgEOvzYVknDoWHxvOmpnXRPHwxO3O0udrMTLph
         vqp7s7ikoQINGCIEi1JzdF/kcAPYYRlUJU+0BtMBCNFi0+lPpGbnS6iXGC7g0nJyKnQ4
         pouqE+1oHgbZe1ErPcaNy03ksWazjUMrB8e+Jf0A701LcVq2xLb67BRkTuXvhM20Ht0t
         W+W6ibBWGduzMI0I1xTzTT8IW06kIuDGRyNKDDtvu5FZCWRU5I50Rw3jdr/KYmRmIN0G
         qk+A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=c+95jXxbZ416BpHiNRrKuwMfS/1unz29UutTwcR9vcQ=;
        b=seN5PTJ4MTb7pJMVQLeMLLIVqOQXTQHtCAVuhtLxQfbXnEmhlBiU2lXc9i/obp1ngU
         G5yFnuSxn6tXUaR29jw3vGuWOYoJDh/k2TB1/hoEqabldKXxHGRlQp8j9P35QiqRVkgJ
         D5ZGSAgYWyW/7GA92e4AnBHbFgy0oCmdhtieFlRMQmrT/gy+BIoza4mPool95oXIo8P/
         juJnuxjyKo6qhys98UYNwZlYmfZHwxt43A/UAvgK5xz0TWHAwKGsfdF41Mt3jhT6t+qO
         0ZA6DQ/jSqrRdjPz2UnAgXdbKvtFSTOigTGPIbzgEfgler+9MWCXuxdgVYOPECiF1n+Y
         8VIQ==
X-Gm-Message-State: AO0yUKWU1GB/iOIZP1yRapjWx47In7rKfVf1N0Iz8s79xWZFBTOmTBA0
        OcPfquRDPwxgiEYWsCIN7+GDBjLiCPo=
X-Google-Smtp-Source: AK7set86lk0YJ8vjRm7VpR26D1gLImTrjIQSSULyHnS5us/hgXdip+ntaIFYb4/8cM1EdrEjSuPdWCB/IcY=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:902:bb87:b0:196:7128:f809 with SMTP id
 m7-20020a170902bb8700b001967128f809mr1425520pls.2.1675821799966; Tue, 07 Feb
 2023 18:03:19 -0800 (PST)
Date:   Wed,  8 Feb 2023 02:02:37 +0000
In-Reply-To: <20230123221208.4964-1-alexandru.matei@uipath.com>
Mime-Version: 1.0
References: <20230123221208.4964-1-alexandru.matei@uipath.com>
X-Mailer: git-send-email 2.39.1.519.gcb327c4b5f-goog
Message-ID: <167580730537.345873.4477811742777949287.b4-ty@google.com>
Subject: Re: [PATCH v4] KVM: VMX: Fix crash due to uninitialized current_vmcs
From:   Sean Christopherson <seanjc@google.com>
To:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Alexandru Matei <alexandru.matei@uipath.com>
Cc:     kvm@vger.kernel.org, Mihai Petrisor <mihai.petrisor@uipath.com>,
        Viorel Canja <viorel.canja@uipath.com>
Content-Type: text/plain; charset="utf-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 24 Jan 2023 00:12:08 +0200, Alexandru Matei wrote:
> KVM enables 'Enlightened VMCS' and 'Enlightened MSR Bitmap' when running as
> a nested hypervisor on top of Hyper-V. When MSR bitmap is updated,
> evmcs_touch_msr_bitmap function uses current_vmcs per-cpu variable to mark
> that the msr bitmap was changed.
> 
> vmx_vcpu_create() modifies the msr bitmap via vmx_disable_intercept_for_msr
> -> vmx_msr_bitmap_l01_changed which in the end calls this function. The
> function checks for current_vmcs if it is null but the check is
> insufficient because current_vmcs is not initialized. Because of this, the
> code might incorrectly write to the structure pointed by current_vmcs value
> left by another task. Preemption is not disabled, the current task can be
> preempted and moved to another CPU while current_vmcs is accessed multiple
> times from evmcs_touch_msr_bitmap() which leads to crash.
> 
> [...]

Applied to git@github.com:sean-jc/linux.git x86/hyperv_evmcs_cleanup, thanks!

[1/1] KVM: VMX: Fix crash due to uninitialized current_vmcs
      https://github.com/kvm-x86/linux/commit/93827a0a3639

--
https://github.com/kvm-x86/linux/tree/next
https://github.com/kvm-x86/linux/tree/fixes
