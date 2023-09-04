Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2485579161E
	for <lists+kvm@lfdr.de>; Mon,  4 Sep 2023 13:16:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352735AbjIDLQM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 4 Sep 2023 07:16:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55906 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233478AbjIDLQL (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 4 Sep 2023 07:16:11 -0400
Received: from mail-wr1-x42a.google.com (mail-wr1-x42a.google.com [IPv6:2a00:1450:4864:20::42a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 90725CDA
        for <kvm@vger.kernel.org>; Mon,  4 Sep 2023 04:16:02 -0700 (PDT)
Received: by mail-wr1-x42a.google.com with SMTP id ffacd0b85a97d-31aec0a1a8bso828431f8f.0
        for <kvm@vger.kernel.org>; Mon, 04 Sep 2023 04:16:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ventanamicro.com; s=google; t=1693826161; x=1694430961; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=I9GCAlEvdvaQhIuQIQlH6uZieVhDq0JG0Q/Lab40q3Y=;
        b=CMqTvcfoarfIJSBd1JiDV22ESK/qNv7BI6cjJt3jShl1fQWkZU4snlpjUii5z9aKcD
         zOdcc0Zg6VUrg/fjmFMi6BVuyiZjRq8yMPLCu4Hfq3Cp/MUdAJrr6E2SVfXK8smgGQ7s
         G/DzOW2/pkwvk0GRWunoFFSMMY9RyJyVRru3ZT0bTlTOHoCmr8ZSL1i0jEqduUOHSySW
         icXJ+n0bTTn0pQvvd6wUN8SGWcjZ16Ero9htZTbqIBnAYOf/iU5kYE1W4se65SknXzw/
         IXvMDdgxXlHmx5OYzRF1MJxhWJ2B6ZQdoELVSsMaBeSnUvuKUTGFdfavrZ4RB5EgSnrT
         psMg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1693826161; x=1694430961;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=I9GCAlEvdvaQhIuQIQlH6uZieVhDq0JG0Q/Lab40q3Y=;
        b=J8Df/HnTS14SDiLst2ATVg/HjDs78JkV4E1/tPCGeBFCaj2GnvutCHuFZP3+GWQAes
         s8/pi8aJzMz7MWwan+bLRTrWOEDG4cEfwr0bXy57DlhpB97Hdg/uJo5Hh7TIcn1l7sXs
         b/1pyk6VLioLeG3aUrlqUas3JM3xvKZ4hfDlQKcKHSwvIHMOIqJuHHeFgrtCM8J45bjV
         89YCggtR6MUBTftlgEppsKR2Lr2th4iW2GxnK1ryMOJZ6bkG0+OPI0e4s3pYHJq2/j5z
         SjXu4tN0gfnNIS2fIuwn81vBRyAXkwdwUwZ7F3giX+c219sy45NGzbqy+K119fkdKE1W
         GnMg==
X-Gm-Message-State: AOJu0YwjztCeC8+t3ZVLXXc6BKw5NqoZ1A4CR7RvEMRqpG7glxEWJqsr
        fBLEbjgN66kpxiTo+ifIdE0YDg==
X-Google-Smtp-Source: AGHT+IHR3qJF/WADy7jFXe6yIqtW0lGNRVyiw5VlYSS4H2pPf8Rp4EorJnHY9mZBl7rKv7MV9xXpWQ==
X-Received: by 2002:adf:ee90:0:b0:319:6b56:94d9 with SMTP id b16-20020adfee90000000b003196b5694d9mr8511545wro.2.1693826161050;
        Mon, 04 Sep 2023 04:16:01 -0700 (PDT)
Received: from localhost (cst2-173-16.cust.vodafone.cz. [31.30.173.16])
        by smtp.gmail.com with ESMTPSA id x18-20020adfec12000000b0031989784d96sm14281097wrn.76.2023.09.04.04.15.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 04 Sep 2023 04:15:59 -0700 (PDT)
Date:   Mon, 4 Sep 2023 13:15:56 +0200
From:   Andrew Jones <ajones@ventanamicro.com>
To:     Haibo Xu <haibo1.xu@intel.com>
Cc:     xiaobo55x@gmail.com, Sean Christopherson <seanjc@google.com>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Albert Ou <aou@eecs.berkeley.edu>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Shuah Khan <shuah@kernel.org>, Marc Zyngier <maz@kernel.org>,
        Oliver Upton <oliver.upton@linux.dev>,
        James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Zenghui Yu <yuzenghui@huawei.com>,
        Anup Patel <anup@brainfault.org>,
        Atish Patra <atishp@atishpatra.org>,
        Guo Ren <guoren@kernel.org>,
        Greentime Hu <greentime.hu@sifive.com>,
        wchen <waylingii@gmail.com>,
        Daniel Henrique Barboza <dbarboza@ventanamicro.com>,
        Ricardo Koller <ricarkol@google.com>,
        Vishal Annapurve <vannapurve@google.com>,
        David Matlack <dmatlack@google.com>,
        Aaron Lewis <aaronlewis@google.com>,
        Mingwei Zhang <mizhang@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Ackerley Tng <ackerleytng@google.com>,
        Lei Wang <lei4.wang@intel.com>,
        Vipin Sharma <vipinsh@google.com>,
        Maxim Levitsky <mlevitsk@redhat.com>,
        Like Xu <likexu@tencent.com>, Peter Gonda <pgonda@google.com>,
        Thomas Huth <thuth@redhat.com>,
        Philippe =?utf-8?Q?Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
        David Woodhouse <dwmw@amazon.co.uk>,
        Michal Luczaj <mhal@rbox.co>,
        zhang songyi <zhang.songyi@zte.com.cn>,
        linux-kernel@vger.kernel.org, linux-riscv@lists.infradead.org,
        kvm@vger.kernel.org, linux-kselftest@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
        kvm-riscv@lists.infradead.org
Subject: Re: [PATCH v2 1/8] KVM: selftests: Unify the codes for guest
 exception handling
Message-ID: <20230904-ba5051a5bf17d17f2711d7dc@orel>
References: <cover.1693659382.git.haibo1.xu@intel.com>
 <7affb0387d7272573f7093de7887872e1fb5979b.1693659382.git.haibo1.xu@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7affb0387d7272573f7093de7887872e1fb5979b.1693659382.git.haibo1.xu@intel.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_BLOCKED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sat, Sep 02, 2023 at 08:59:23PM +0800, Haibo Xu wrote:
> Rename the vm_init_descriptor_tables() and vcpu_init_vector_tables()
                                             ^ vcpu_init_descriptor_tables()

> prototypes to vm_init_vector_tables() and vcpu_init_vector_tables()
> respectively, so that we can use common names for the architectures
> (x86/aarch64/riscv) and then put them in a common header.
> 
> By the way, vm_install_exception_handler() prototype were also moved to
> the common header since they are commonly used across the architectures.
> 
> The patch is a preparation to share the guest exception handling codes
> in riscv.
> 
> Suggested-by: Andrew Jones <ajones@ventanamicro.com>
> Suggested-by: Sean Christopherson <seanjc@google.com>
> Signed-off-by: Haibo Xu <haibo1.xu@intel.com>
> ---
>  tools/testing/selftests/kvm/aarch64/arch_timer.c          | 4 ++--
>  tools/testing/selftests/kvm/aarch64/debug-exceptions.c    | 4 ++--
>  tools/testing/selftests/kvm/aarch64/page_fault_test.c     | 4 ++--
>  tools/testing/selftests/kvm/aarch64/vgic_irq.c            | 4 ++--
>  tools/testing/selftests/kvm/include/aarch64/processor.h   | 8 +-------
>  tools/testing/selftests/kvm/include/kvm_util_base.h       | 7 +++++++
>  tools/testing/selftests/kvm/include/x86_64/processor.h    | 5 -----
>  tools/testing/selftests/kvm/lib/aarch64/processor.c       | 6 +++---
>  tools/testing/selftests/kvm/lib/x86_64/processor.c        | 4 ++--
>  tools/testing/selftests/kvm/x86_64/amx_test.c             | 4 ++--
>  tools/testing/selftests/kvm/x86_64/fix_hypercall_test.c   | 4 ++--
>  tools/testing/selftests/kvm/x86_64/hyperv_evmcs.c         | 4 ++--
>  tools/testing/selftests/kvm/x86_64/hyperv_features.c      | 8 ++++----
>  tools/testing/selftests/kvm/x86_64/hyperv_ipi.c           | 6 +++---
>  tools/testing/selftests/kvm/x86_64/kvm_pv_test.c          | 4 ++--
>  tools/testing/selftests/kvm/x86_64/monitor_mwait_test.c   | 4 ++--
>  .../testing/selftests/kvm/x86_64/pmu_event_filter_test.c  | 8 ++++----
>  .../kvm/x86_64/smaller_maxphyaddr_emulation_test.c        | 4 ++--
>  tools/testing/selftests/kvm/x86_64/svm_int_ctl_test.c     | 4 ++--
>  .../selftests/kvm/x86_64/svm_nested_shutdown_test.c       | 4 ++--
>  .../selftests/kvm/x86_64/svm_nested_soft_inject_test.c    | 4 ++--
>  tools/testing/selftests/kvm/x86_64/ucna_injection_test.c  | 8 ++++----
>  .../selftests/kvm/x86_64/userspace_msr_exit_test.c        | 4 ++--
>  .../kvm/x86_64/vmx_exception_with_invalid_guest_state.c   | 4 ++--
>  tools/testing/selftests/kvm/x86_64/vmx_pmu_caps_test.c    | 4 ++--
>  tools/testing/selftests/kvm/x86_64/xapic_ipi_test.c       | 4 ++--
>  tools/testing/selftests/kvm/x86_64/xcr0_cpuid_test.c      | 4 ++--
>  tools/testing/selftests/kvm/x86_64/xen_shinfo_test.c      | 4 ++--
>  28 files changed, 66 insertions(+), 70 deletions(-)
>

Reviewed-by: Andrew Jones <ajones@ventanamicro.com>
