Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6E9075BD634
	for <lists+kvm@lfdr.de>; Mon, 19 Sep 2022 23:17:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229723AbiISVR1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 19 Sep 2022 17:17:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53352 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229522AbiISVR0 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 19 Sep 2022 17:17:26 -0400
Received: from out1.migadu.com (out1.migadu.com [91.121.223.63])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6E9512B62F;
        Mon, 19 Sep 2022 14:17:24 -0700 (PDT)
Date:   Mon, 19 Sep 2022 21:17:11 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1663622242;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=tSvK5IvdnSqXV3YZK0CrcY2MYv1YLMvmstzyS0/p/3Y=;
        b=Zm8R2gYheUqs8kaOvIaQNFC4yqEMp2GRRNiJBpM7M5vA/WgdwqTESjDkKU0coSFz6MXhW2
        Pxvb8ZjDE6n4so7BREdVS+vE39ju3kO3195nF4Ve50+lzh/xP3zlyBZv/kHwnMgkYK1yKX
        Jth+sXWoVAAT0psTZjNDah/SKd1aEK0=
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
Subject: Re: [PATCH 2/5] KVM: selftests: Compare insn opcodes directly in
 fix_hypercall_test
Message-ID: <YyjcVydnLQzKtNC/@google.com>
References: <20220908233134.3523339-1-seanjc@google.com>
 <20220908233134.3523339-3-seanjc@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20220908233134.3523339-3-seanjc@google.com>
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

On Thu, Sep 08, 2022 at 11:31:31PM +0000, Sean Christopherson wrote:
> Directly compare the expected versus observed hypercall instructions when
> verifying that KVM patched in the native hypercall (FIX_HYPERCALL_INSN
> quirk enabled).  gcc rightly complains that doing a 4-byte memcpy() with
> an "unsigned char" as the source generates an out-of-bounds accesses.
> 
> Alternatively, "exp" and "obs" could be declared as 3-byte arrays, but
> there's no known reason to copy locally instead of comparing directly.

I was trying to print just the instruction bytes if such a comparison
failed, but that's already a bust given that it was a 4-byte copy.

Having said that, the assertion should be clear enough.

> In function ‘assert_hypercall_insn’,
>     inlined from ‘guest_main’ at x86_64/fix_hypercall_test.c:91:2:
> x86_64/fix_hypercall_test.c:63:9: error: array subscript ‘unsigned int[0]’
>  is partly outside array bounds of ‘unsigned char[1]’ [-Werror=array-bounds]
>    63 |         memcpy(&exp, exp_insn, sizeof(exp));
>       |         ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
> x86_64/fix_hypercall_test.c: In function ‘guest_main’:
> x86_64/fix_hypercall_test.c:42:22: note: object ‘vmx_hypercall_insn’ of size 1
>    42 | extern unsigned char vmx_hypercall_insn;
>       |                      ^~~~~~~~~~~~~~~~~~
> x86_64/fix_hypercall_test.c:25:22: note: object ‘svm_hypercall_insn’ of size 1
>    25 | extern unsigned char svm_hypercall_insn;
>       |                      ^~~~~~~~~~~~~~~~~~
> In function ‘assert_hypercall_insn’,
>     inlined from ‘guest_main’ at x86_64/fix_hypercall_test.c:91:2:
> x86_64/fix_hypercall_test.c:64:9: error: array subscript ‘unsigned int[0]’
>  is partly outside array bounds of ‘unsigned char[1]’ [-Werror=array-bounds]
>    64 |         memcpy(&obs, obs_insn, sizeof(obs));
>       |         ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
> x86_64/fix_hypercall_test.c: In function ‘guest_main’:
> x86_64/fix_hypercall_test.c:25:22: note: object ‘svm_hypercall_insn’ of size 1
>    25 | extern unsigned char svm_hypercall_insn;
>       |                      ^~~~~~~~~~~~~~~~~~
> x86_64/fix_hypercall_test.c:42:22: note: object ‘vmx_hypercall_insn’ of size 1
>    42 | extern unsigned char vmx_hypercall_insn;
>       |                      ^~~~~~~~~~~~~~~~~~
> cc1: all warnings being treated as errors
> make: *** [../lib.mk:135: tools/testing/selftests/kvm/x86_64/fix_hypercall_test] Error 1
> 
> Fixes: 6c2fa8b20d0c ("selftests: KVM: Test KVM_X86_QUIRK_FIX_HYPERCALL_INSN")
> Cc: Oliver Upton <oliver.upton@linux.dev>
> Signed-off-by: Sean Christopherson <seanjc@google.com>

Reviewed-by: Oliver Upton <oliver.upton@linux.dev>

--
Thanks,
Oliver
