Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AA7D16C7348
	for <lists+kvm@lfdr.de>; Thu, 23 Mar 2023 23:46:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231355AbjCWWq4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 23 Mar 2023 18:46:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42590 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229600AbjCWWqy (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 23 Mar 2023 18:46:54 -0400
Received: from mail-pf1-x44a.google.com (mail-pf1-x44a.google.com [IPv6:2607:f8b0:4864:20::44a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0C6F044B8
        for <kvm@vger.kernel.org>; Thu, 23 Mar 2023 15:46:54 -0700 (PDT)
Received: by mail-pf1-x44a.google.com with SMTP id y186-20020a62cec3000000b00627df3d6ec4so113250pfg.12
        for <kvm@vger.kernel.org>; Thu, 23 Mar 2023 15:46:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1679611613;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=HNHBl3QczA2duBiLkiqIakCr9NDsSlzl00Etwe/x6AA=;
        b=nL4uDHT5LN/KzWrSdMVEP4XYVi62HDk1HQdumZO+SeJ01dVjDn9KXeH7sxgu9tN2Ih
         RQQcFcuMC2vmrq8CPwa2zJ/d5RXHOZIm0FZWzAhKQIq6n+2wWsoLdQb5LyBdnkh/XCR3
         LtelyBK6rrQ7Wl8BO8gKq9k6opsrbtRKnW+b3lr/tsBptbz8VcqOOX0SpuaQVweCq8Bt
         Ri/yPZwY5ilgL9UQPYNCu1WlZwlnlXh2mY+oVNh1ALHtmbXijZOJe7xRulULIa+f81kc
         iBSejLd+0rarVjncxsXJjQJmAvi3xW3ecUq/dhtcqRMYksgYeR4S9ZF9hAXyCgsPwIEn
         1JJw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679611613;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=HNHBl3QczA2duBiLkiqIakCr9NDsSlzl00Etwe/x6AA=;
        b=Mp6KEJw/bffHGAxcEVyPPXkq8vvesEioE7z2dANScbwDi8v3eVh2Wst8LSyBiaqcNZ
         EcrnB6Ij/TLtD0OvNRi0lNNJacSeJnWVIpawPDpswo3CXj/A3oRs5jnTdjDVg6sjX8sD
         +LCpDLKkzPFf4qAM+yjsCDu7pFafAoEWmRkHRk0edO8+b4S/Xs/uDfAQKNrUD22ZFjg2
         pUpIVDcrZqCaSv+sEXBXcUsmkLjc+kFMiU046GWPyefrRlH0dYCg63+H88Y2HcdYl9jr
         cGa4uV6J0jzz2D6nwm9QX5ZpxQmYgh4hT8M7D6ksam1DKKILwZQ/PgLWHQ+FZNMEmjL7
         Vz3w==
X-Gm-Message-State: AAQBX9dBmg/yERJetDR2bHrdFQqcH74POeao6xw1OsEjGpdQwxKx1gTk
        psUXY1M7cAn62Uc0pGW5XsTdIbZ8Nv0=
X-Google-Smtp-Source: AKy350b/PgUg+gxiOE/h70oYz151S5aJduuVjb8pRCIi0/IS8Bc+b+9UPB0ti6SDk5DSK+SHTuxsCHRMcOI=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a63:89:0:b0:4fc:7e60:d0c with SMTP id
 131-20020a630089000000b004fc7e600d0cmr19725pga.11.1679611613647; Thu, 23 Mar
 2023 15:46:53 -0700 (PDT)
Date:   Thu, 23 Mar 2023 15:46:32 -0700
In-Reply-To: <20230322011440.2195485-1-seanjc@google.com>
Mime-Version: 1.0
References: <20230322011440.2195485-1-seanjc@google.com>
X-Mailer: git-send-email 2.40.0.348.gf938b09366-goog
Message-ID: <167949671616.2217955.7836409047320878527.b4-ty@google.com>
Subject: Re: [PATCH 0/6] KVM: x86: Unhost the *_CMD MSR mess
From:   Sean Christopherson <seanjc@google.com>
To:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Nathan Chancellor <nathan@kernel.org>,
        Emanuele Giuseppe Esposito <eesposit@redhat.com>,
        Pawan Gupta <pawan.kumar.gupta@linux.intel.com>,
        Jim Mattson <jmattson@google.com>
Content-Type: text/plain; charset="utf-8"
X-Spam-Status: No, score=-7.7 required=5.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 21 Mar 2023 18:14:34 -0700, Sean Christopherson wrote:
> Revert the FLUSH_L1D enabling, which has multiple fatal bugs, clean up
> the existing PRED_CMD handling, and reintroduce FLUSH_L1D virtualization
> without inheriting the mistakes made by PRED_CMD.
> 
> The last patch hardens SVM against one of the bugs introduced in the
> FLUSH_L1D enabling.
> 
> [...]

Applied to a one-off branch, kvm-x86 cmd_msrs, so that I can get this into
kvm-x86 next and onto linux-next asap.  I'll drop the branch if Paolo wants
to do something else, or if there are issues with the series.

[1/6] KVM: x86: Revert MSR_IA32_FLUSH_CMD.FLUSH_L1D enabling
      https://github.com/kvm-x86/linux/commit/e9c126917c09
[2/6] KVM: VMX: Passthrough MSR_IA32_PRED_CMD based purely on host+guest CPUID
      https://github.com/kvm-x86/linux/commit/4f9babd37df0
[3/6] KVM: SVM: Passthrough MSR_IA32_PRED_CMD based purely on host+guest CPUID
      https://github.com/kvm-x86/linux/commit/5ac641dff621
[4/6] KVM: x86: Move MSR_IA32_PRED_CMD WRMSR emulation to common code
      https://github.com/kvm-x86/linux/commit/584aeda90bd9
[5/6] KVM: x86: Virtualize FLUSH_L1D and passthrough MSR_IA32_FLUSH_CMD
      https://github.com/kvm-x86/linux/commit/5bdebd246db5
[6/6] KVM: SVM: Return the local "r" variable from svm_set_msr()
      https://github.com/kvm-x86/linux/commit/8a16ed8c673c

--
https://github.com/kvm-x86/linux/tree/next
https://github.com/kvm-x86/linux/tree/fixes
