Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1CDA767F901
	for <lists+kvm@lfdr.de>; Sat, 28 Jan 2023 16:13:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233641AbjA1PN3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 28 Jan 2023 10:13:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47848 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230394AbjA1PN3 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 28 Jan 2023 10:13:29 -0500
Received: from out2.migadu.com (out2.migadu.com [188.165.223.204])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8341526861;
        Sat, 28 Jan 2023 07:13:27 -0800 (PST)
Message-ID: <2bf4523a-ae8a-1fe2-32b1-25c7e3ae7092@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1674918805;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=E9bS3BnZ6WdEi1IEG6Dt2LIop6JFZjAkpCsRjTjS4xo=;
        b=jt3z+BQBkKlHupD4cZv/rULpNLuG3ljKqRTWB2BhKhINtWzcn2jFHlPNdLWWeqV1aXBjXw
        d2+VhlurXz3cxfOsajAxP1JiFFkAky0fH6g+e6459Yil+Grinzf3IRQ4giMhEF4jt5OFvw
        Hyy0M3x+hbhOHjehN6Hu1b0aqdcMfKY=
Date:   Sat, 28 Jan 2023 23:12:50 +0800
MIME-Version: 1.0
Subject: Re: [PATCH v2 2/7] KVM: arm64: Use kvm_arch_flush_remote_tlbs()
Content-Language: en-US
To:     David Matlack <dmatlack@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     Marc Zyngier <maz@kernel.org>, James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Oliver Upton <oliver.upton@linux.dev>,
        Zenghui Yu <yuzenghui@huawei.com>,
        Huacai Chen <chenhuacai@kernel.org>,
        Aleksandar Markovic <aleksandar.qemu.devel@gmail.com>,
        Anup Patel <anup@brainfault.org>,
        Atish Patra <atishp@atishpatra.org>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Albert Ou <aou@eecs.berkeley.edu>,
        Sean Christopherson <seanjc@google.com>,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
        kvmarm@lists.cs.columbia.edu, linux-mips@vger.kernel.org,
        kvm@vger.kernel.org, kvm-riscv@lists.infradead.org,
        linux-riscv@lists.infradead.org,
        Raghavendra Rao Ananta <rananta@google.com>
References: <20230126184025.2294823-1-dmatlack@google.com>
 <20230126184025.2294823-3-dmatlack@google.com>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From:   Zenghui Yu <zenghui.yu@linux.dev>
In-Reply-To: <20230126184025.2294823-3-dmatlack@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Migadu-Flow: FLOW_OUT
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 2023/1/27 02:40, David Matlack wrote:
> Use kvm_arch_flush_remote_tlbs() instead of
> CONFIG_HAVE_KVM_ARCH_TLB_FLUSH_ALL. The two mechanisms solve the same
> problem, allowing architecture-specific code to provide a non-IPI
> implementation of remote TLB flushing.
> 
> Dropping CONFIG_HAVE_KVM_ARCH_TLB_FLUSH_ALL allows KVM to standardize
> all architectures on kvm_arch_flush_remote_tlbs() instead of maintaining
> two mechanisms.
> 
> Opt to standardize on kvm_arch_flush_remote_tlbs() since it avoids
> duplicating the generic TLB stats across architectures that implement
> their own remote TLB flush.
> 
> This adds an extra function call to the ARM64 kvm_flush_remote_tlbs()
> path, but that is a small cost in comparison to flushing remote TLBs.
> 
> No functional change intended.
> 
> Signed-off-by: David Matlack <dmatlack@google.com>

Looks good,

Reviewed-by: Zenghui Yu <zenghui.yu@linux.dev>
