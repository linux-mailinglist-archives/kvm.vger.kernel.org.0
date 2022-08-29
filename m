Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1AA435A5170
	for <lists+kvm@lfdr.de>; Mon, 29 Aug 2022 18:19:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229549AbiH2QTv (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 29 Aug 2022 12:19:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45912 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229472AbiH2QTs (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 29 Aug 2022 12:19:48 -0400
Received: from out0.migadu.com (out0.migadu.com [94.23.1.103])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 89633D40;
        Mon, 29 Aug 2022 09:19:46 -0700 (PDT)
Date:   Mon, 29 Aug 2022 18:19:41 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1661789984;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=URd452JoMFM9JD7pYWX5aoZrRYft8Gac0hRTpx4CpB4=;
        b=cmAaq27a2rEDvaFF7eIf/c+iEhVwMjmtSQo0G1Xqa4rr5PmoDkzJisJPTaorWXIbYYuMsN
        +N8RcRi9Mq5LOv6cPDYQyYshMhIlPtfYGzLct3XwxIvDIbi8Tvjjnjp38np47QcYF+a9Up
        7KTvlcfUB1wBgeGX6fRshWbeb0i2X2I=
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
Subject: Re: [PATCH v5 5/7] KVM: selftests: Make arm64's MMIO ucall multi-VM
 friendly
Message-ID: <20220829161941.c5bd6azxv7jzpwq2@kamzik>
References: <20220825232522.3997340-1-seanjc@google.com>
 <20220825232522.3997340-6-seanjc@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220825232522.3997340-6-seanjc@google.com>
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

On Thu, Aug 25, 2022 at 11:25:20PM +0000, Sean Christopherson wrote:
> Fix a mostly-theoretical bug where ARM's ucall MMIO setup could result in
> different VMs stomping on each other by cloberring the global pointer.
> 
> Fix the most obvious issue by saving the MMIO gpa into the VM.
> 
> A more subtle bug is that creating VMs in parallel (on multiple tasks)
> could result in a VM using the wrong address.  Synchronizing a global to
> a guest effectively snapshots the value on a per-VM basis, i.e. the
> "global" is already prepped to work with multiple VMs, but setting the
> global in the host is not thread-safe.  To fix that bug, add
> write_guest_global() to allow stuffing a VM's copy of a "global" without
> modifying the host value.
> 
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>  .../selftests/kvm/include/kvm_util_base.h     | 15 +++++++++++++++
>  .../testing/selftests/kvm/lib/aarch64/ucall.c | 19 ++++++++++++++-----
>  2 files changed, 29 insertions(+), 5 deletions(-)
>

Reviewed-by: Andrew Jones <andrew.jones@linux.dev>
