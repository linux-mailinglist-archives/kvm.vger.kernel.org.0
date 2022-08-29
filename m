Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CD37C5A5148
	for <lists+kvm@lfdr.de>; Mon, 29 Aug 2022 18:16:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230302AbiH2QP6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 29 Aug 2022 12:15:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38350 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229894AbiH2QPt (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 29 Aug 2022 12:15:49 -0400
Received: from out1.migadu.com (out1.migadu.com [91.121.223.63])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2DED97199F;
        Mon, 29 Aug 2022 09:15:40 -0700 (PDT)
Date:   Mon, 29 Aug 2022 18:15:36 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1661789739;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=+wStadIO0VmoiizHUtMBUV7ir4oix+OG46hCH3/9nUA=;
        b=axsCOB4iqY8LlEIt1QM5kBid32gDCkM7tTjX+MaW67UKJMAocXMBMyQTKWkZJQuliAWCSI
        ugfhKgH5bl8QaX3KFeeyeHQAfBD2EZSE87zo7nshwXmqu46M70v71qFDmiv34QxSkK6F98
        iiMDGI469oRRmmLbgxzwFTpnag5/u3c=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From:   Andrew Jones <andrew.jones@linux.dev>
To:     Sean Christopherson <seanjc@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, Marc Zyngier <maz@kernel.org>,
        Anup Patel <anup@brainfault.org>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Albert Ou <aou@eecs.berkeley.edu>,
        Christian Borntraeger <borntraeger@linux.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        Nathan Chancellor <nathan@kernel.org>,
        Nick Desaulniers <ndesaulniers@google.com>,
        James Morse <james.morse@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Oliver Upton <oliver.upton@linux.dev>,
        Atish Patra <atishp@atishpatra.org>,
        David Hildenbrand <david@redhat.com>,
        Tom Rix <trix@redhat.com>, kvm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        kvm-riscv@lists.infradead.org, linux-riscv@lists.infradead.org,
        llvm@lists.linux.dev, linux-kernel@vger.kernel.org,
        Colton Lewis <coltonlewis@google.com>,
        Peter Gonda <pgonda@google.com>
Subject: Re: [PATCH v5 3/7] KVM: selftests: Automatically do init_ucall() for
 non-barebones VMs
Message-ID: <20220829161536.gszp6yvgbzwnor7r@kamzik>
References: <20220825232522.3997340-1-seanjc@google.com>
 <20220825232522.3997340-4-seanjc@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220825232522.3997340-4-seanjc@google.com>
X-Migadu-Flow: FLOW_OUT
X-Migadu-Auth-User: linux.dev
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_PASS,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Aug 25, 2022 at 11:25:18PM +0000, Sean Christopherson wrote:
> Do init_ucall() automatically during VM creation to kill two (three?)
> birds with one stone.
> 
> First, initializing ucall immediately after VM creations allows forcing
> aarch64's MMIO ucall address to immediately follow memslot0.  This is
> still somewhat fragile as tests could clobber the MMIO address with a
> new memslot, but it's safe-ish since tests have to be conversative when
> accounting for memslot0.  And this can be hardened in the future by
> creating a read-only memslot for the MMIO page (KVM ARM exits with MMIO
> if the guest writes to a read-only memslot).  Add a TODO to document that
> selftests can and should use a memslot for the ucall MMIO (doing so
> requires yet more rework because tests assumes thay can use all memslots
> except memslot0).
> 
> Second, initializing ucall for all VMs prepares for making ucall
> initialization meaningful on all architectures.  aarch64 is currently the
> only arch that needs to do any setup, but that will change in the future
> by switching to a pool-based implementation (instead of the current
> stack-based approach).
> 
> Lastly, defining the ucall MMIO address from common code will simplify
> switching all architectures (except s390) to a common MMIO-based ucall
> implementation (if there's ever sufficient motivation to do so).
> 
> Cc: Oliver Upton <oliver.upton@linux.dev>
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>  .../selftests/kvm/aarch64/arch_timer.c        |  1 -
>  .../selftests/kvm/aarch64/debug-exceptions.c  |  1 -
>  .../selftests/kvm/aarch64/hypercalls.c        |  1 -
>  .../testing/selftests/kvm/aarch64/psci_test.c |  1 -
>  .../testing/selftests/kvm/aarch64/vgic_init.c |  2 -
>  .../testing/selftests/kvm/aarch64/vgic_irq.c  |  1 -
>  tools/testing/selftests/kvm/dirty_log_test.c  |  2 -
>  .../selftests/kvm/include/ucall_common.h      |  6 +--
>  .../selftests/kvm/kvm_page_table_test.c       |  1 -
>  .../testing/selftests/kvm/lib/aarch64/ucall.c | 54 ++-----------------
>  tools/testing/selftests/kvm/lib/kvm_util.c    | 11 ++++
>  .../selftests/kvm/lib/perf_test_util.c        |  2 -
>  tools/testing/selftests/kvm/lib/riscv/ucall.c |  2 +-
>  tools/testing/selftests/kvm/lib/s390x/ucall.c |  2 +-
>  .../testing/selftests/kvm/lib/x86_64/ucall.c  |  2 +-
>  .../testing/selftests/kvm/memslot_perf_test.c |  1 -
>  tools/testing/selftests/kvm/rseq_test.c       |  1 -
>  tools/testing/selftests/kvm/steal_time.c      |  1 -
>  .../kvm/system_counter_offset_test.c          |  1 -
>  19 files changed, 20 insertions(+), 73 deletions(-)
>

Reviewed-by: Andrew Jones <andrew.jones@linux.dev>

Thanks,
drew
