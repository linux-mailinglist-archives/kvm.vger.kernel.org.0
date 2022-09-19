Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A500F5BD64F
	for <lists+kvm@lfdr.de>; Mon, 19 Sep 2022 23:24:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229942AbiISVYG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 19 Sep 2022 17:24:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33544 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229521AbiISVYF (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 19 Sep 2022 17:24:05 -0400
Received: from out1.migadu.com (out1.migadu.com [IPv6:2001:41d0:2:863f::])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0BC744CA3A;
        Mon, 19 Sep 2022 14:24:04 -0700 (PDT)
Date:   Mon, 19 Sep 2022 21:23:58 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1663622642;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=NQO1pumSa/KfMYi+Zrv7/FLFzatbUmZ/Js3onvV1Rf4=;
        b=uPvogrlZEPm19kQ2OkUMqT5SWUP4Xqawx8ZuABCXpiJf8LcXs+aUJwmPohX7ZJjzZoppAg
        61uQrbGrAF09GdIVf2FyjLSbBHhlB+0uaKRDRhrPQhz997WXg1eI57bTwTXgblGSNnlk3d
        kMk4JB32oZ3uzCPz9SmwEM+yadiqj7c=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From:   Oliver Upton <oliver.upton@linux.dev>
To:     Sean Christopherson <seanjc@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Andrew Jones <andrew.jones@linux.dev>,
        Anup Patel <anup@brainfault.org>,
        Atish Patra <atishp@atishpatra.org>,
        Christian Borntraeger <borntraeger@linux.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>
Subject: Re: [PATCH 4/5] KVM: selftests: Explicitly verify KVM doesn't patch
 hypercall if quirk==off
Message-ID: <Yyjd7pcBw0NkYVQE@google.com>
References: <20220908233134.3523339-1-seanjc@google.com>
 <20220908233134.3523339-5-seanjc@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220908233134.3523339-5-seanjc@google.com>
X-Migadu-Flow: FLOW_OUT
X-Migadu-Auth-User: linux.dev
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_PASS,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Sep 08, 2022 at 11:31:33PM +0000, Sean Christopherson wrote:
> Explicitly verify that KVM doesn't patch in the native hypercall if the
> FIX_HYPERCALL_INSN quirk is disabled.  The test currently verifies that
> a #UD occurred, but doesn't actually verify that no patching occurred.
> 
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>  .../selftests/kvm/x86_64/fix_hypercall_test.c | 35 ++++++++++++++-----
>  1 file changed, 26 insertions(+), 9 deletions(-)
> 
> diff --git a/tools/testing/selftests/kvm/x86_64/fix_hypercall_test.c b/tools/testing/selftests/kvm/x86_64/fix_hypercall_test.c
> index dde97be3e719..5925da3b3648 100644
> --- a/tools/testing/selftests/kvm/x86_64/fix_hypercall_test.c
> +++ b/tools/testing/selftests/kvm/x86_64/fix_hypercall_test.c
> @@ -21,8 +21,8 @@ static bool ud_expected;
>  
>  static void guest_ud_handler(struct ex_regs *regs)
>  {
> -	GUEST_ASSERT(ud_expected);
> -	GUEST_DONE();
> +	regs->rax = -EFAULT;
> +	regs->rip += HYPERCALL_INSN_SIZE;
>  }
>  
>  extern unsigned char svm_hypercall_insn[HYPERCALL_INSN_SIZE];
> @@ -57,17 +57,18 @@ static void guest_main(void)
>  {
>  	unsigned char *native_hypercall_insn, *hypercall_insn;
>  	uint8_t apic_id;
> +	uint64_t ret;
>  
>  	apic_id = GET_APIC_ID_FIELD(xapic_read_reg(APIC_ID));
>  
>  	if (is_intel_cpu()) {
>  		native_hypercall_insn = vmx_hypercall_insn;
>  		hypercall_insn = svm_hypercall_insn;
> -		svm_do_sched_yield(apic_id);
> +		ret = svm_do_sched_yield(apic_id);
>  	} else if (is_amd_cpu()) {
>  		native_hypercall_insn = svm_hypercall_insn;
>  		hypercall_insn = vmx_hypercall_insn;
> -		vmx_do_sched_yield(apic_id);
> +		ret = vmx_do_sched_yield(apic_id);
>  	} else {
>  		GUEST_ASSERT(0);
>  		/* unreachable */
> @@ -75,12 +76,28 @@ static void guest_main(void)
>  	}
>  
>  	/*
> -	 * The hypercall didn't #UD (guest_ud_handler() signals "done" if a #UD
> -	 * occurs).  Verify that a #UD is NOT expected and that KVM patched in
> -	 * the native hypercall.
> +	 * If the quirk is disabled, verify that guest_ud_handler() "returned"
> +	 * -EFAULT and that KVM did NOT patch the hypercall.  If the quirk is
> +	 * enabled, verify that the hypercall succeeded and that KVM patched in
> +	 * the "right" hypercall.
>  	 */
> -	GUEST_ASSERT(!ud_expected);
> -	GUEST_ASSERT(!memcmp(native_hypercall_insn, hypercall_insn, HYPERCALL_INSN_SIZE));
> +	if (ud_expected) {
> +		GUEST_ASSERT(ret == (uint64_t)-EFAULT);
> +
> +		/*
> +		 * Divergence should occur only on the last byte, as the VMCALL
> +		 * (0F 01 C1) and VMMCALL (0F 01 D9) share the first two bytes.
> +		 */
> +		GUEST_ASSERT(!memcmp(native_hypercall_insn, hypercall_insn,
> +				     HYPERCALL_INSN_SIZE - 1));
> +		GUEST_ASSERT(memcmp(native_hypercall_insn, hypercall_insn,
> +				    HYPERCALL_INSN_SIZE));

Should we just keep the assertions consistent for both cases (patched
and unpatched)?

--
Thanks,
Oliver

> +	} else {
> +		GUEST_ASSERT(!ret);
> +		GUEST_ASSERT(!memcmp(native_hypercall_insn, hypercall_insn,
> +			     HYPERCALL_INSN_SIZE));
> +	}
> +
>  	GUEST_DONE();
>  }
>  
> -- 
> 2.37.2.789.g6183377224-goog
> 
