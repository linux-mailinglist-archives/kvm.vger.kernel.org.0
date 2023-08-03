Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0337C76F48A
	for <lists+kvm@lfdr.de>; Thu,  3 Aug 2023 23:15:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230128AbjHCVP3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 3 Aug 2023 17:15:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38660 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229935AbjHCVP2 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 3 Aug 2023 17:15:28 -0400
Received: from mailtransmit04.runbox.com (mailtransmit04.runbox.com [IPv6:2a0c:5a00:149::25])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0CCCB4C06
        for <kvm@vger.kernel.org>; Thu,  3 Aug 2023 14:14:55 -0700 (PDT)
Received: from mailtransmit02.runbox ([10.9.9.162] helo=aibo.runbox.com)
        by mailtransmit04.runbox.com with esmtps  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
        (Exim 4.93)
        (envelope-from <mhal@rbox.co>)
        id 1qRfem-001WTZ-4l; Thu, 03 Aug 2023 23:14:52 +0200
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=rbox.co;
        s=selector1; h=Content-Transfer-Encoding:Content-Type:In-Reply-To:From:
        References:Cc:To:Subject:MIME-Version:Date:Message-ID;
        bh=GJXr3kflO9THvFP/5xJTSo8V52sHmFBak1tAFn/aaS4=; b=w2kmEB4aY4JXUGtCZbpbpjQBF+
        QAp7MFsGZglv7i0VcFjFv5zn4unBoTdVvsTePvhgypBi0U3yCaGY9ricnZh9e069+35oGUwQ4FFyn
        gtc0Aik7yy33B9vOtf6Wqd/N77qn+Fmstc1E0T+Nfzv5fpmAcaUCGH03aMuX9vCJsOtXy2Mfo6F6x
        8bBQ6SiPcN5pLBJle4rGMKNDvBz6hil3sBHaTBwOSyxBSSI53wF8sEYm99wCkAGH3SXZ7G/+vN6Ii
        PTouqtcm8v1jslEYy52yZRTdQGS0Pd6NQWFkdQNzKeomstPtw/q9ZNVwcdXlknkNIt3Hz0zDBSYeG
        Tim+A8ZA==;
Received: from [10.9.9.74] (helo=submission03.runbox)
        by mailtransmit02.runbox with esmtp (Exim 4.86_2)
        (envelope-from <mhal@rbox.co>)
        id 1qRfeW-0001iU-L5; Thu, 03 Aug 2023 23:14:36 +0200
Received: by submission03.runbox with esmtpsa  [Authenticated ID (604044)]  (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.90_1)
        id 1qRfeJ-00041W-Fg; Thu, 03 Aug 2023 23:14:23 +0200
Message-ID: <5c7309cb-30be-fe99-8563-d33098adbfe9@rbox.co>
Date:   Thu, 3 Aug 2023 23:14:03 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 2/2] KVM: selftests: Extend x86's sync_regs_test to check
 for races
Content-Language: pl-PL, en-GB
To:     Sean Christopherson <seanjc@google.com>
Cc:     pbonzini@redhat.com, kvm@vger.kernel.org, shuah@kernel.org
References: <20230728001606.2275586-1-mhal@rbox.co>
 <20230728001606.2275586-3-mhal@rbox.co> <ZMrFmKRcsb84DaTY@google.com>
 <222888b6-0046-3351-ba2f-fe6ac863f73d@rbox.co> <ZMvY17kJR59P2blD@google.com>
From:   Michal Luczaj <mhal@rbox.co>
In-Reply-To: <ZMvY17kJR59P2blD@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 8/3/23 18:41, Sean Christopherson wrote:
> KVM doesn't expost the bugged/dead information, though I suppose userspace could
> probe that information by doing an ioctl() that is guaranteed to succeeed and
> looking for -EIO, e.g. KVM_CHECK_EXTENSION on the VM.
> 
> I was going to say that it's not worth trying to detect a bugged/dead VM in
> selftests, because it requires having the pointer to the VM, and that's not
> typically available when an assert fails, but the obviously solution is to tap
> into the VM and vCPU ioctl() helpers.  That's also good motivation to add helpers
> and consolidate asserts for ioctls() that return fds, i.e. for which a positive
> return is considered success.
> 
> With the below (partial conversion), the failing testcase yields this.  Using a
> heuristic isn't ideal, but practically speaking I can't see a way for the -EIO
> check to go awry, and anything to make debugging errors easier is definitely worth
> doing IMO.
> 
> ==== Test Assertion Failure ====
>   lib/kvm_util.c:689: false
>   pid=80347 tid=80347 errno=5 - Input/output error
>      1	0x00000000004039ab: __vm_mem_region_delete at kvm_util.c:689 (discriminator 5)
>      2	0x0000000000404660: kvm_vm_free at kvm_util.c:724 (discriminator 12)
>      3	0x0000000000402ac9: race_sync_regs at sync_regs_test.c:193
>      4	0x0000000000401cb7: main at sync_regs_test.c:334 (discriminator 6)
>      5	0x0000000000418263: __libc_start_call_main at libc-start.o:?
>      6	0x00000000004198af: __libc_start_main_impl at ??:?
>      7	0x0000000000401d90: _start at ??:?
>   KVM killed/bugged the VM, check kernel log for clues

Yes, such automatic reporting of dead VMs is a really nice feature.

> diff --git a/tools/testing/selftests/kvm/include/kvm_util_base.h b/tools/testing/selftests/kvm/include/kvm_util_base.h
> index 07732a157ccd..e48ac57be13a 100644
> --- a/tools/testing/selftests/kvm/include/kvm_util_base.h
> +++ b/tools/testing/selftests/kvm/include/kvm_util_base.h
> @@ -258,17 +258,42 @@ static __always_inline void static_assert_is_vm(struct kvm_vm *vm) { }
>         kvm_do_ioctl((vm)->fd, cmd, arg);                       \
>  })
>  
> +/*
> + * Assert that a VM or vCPU ioctl() succeeded (obviously), with extra magic to
> + * detect if the ioctl() failed because KVM killed/bugged the VM.  To detect a
> + * dead VM, probe KVM_CAP_USER_MEMORY, which (a) has been supported by KVM
> + * since before selftests existed and (b) should never outright fail, i.e. is
> + * supposed to return 0 or 1.  If KVM kills a VM, KVM returns -EIO for all
> + * ioctl()s for the VM and its vCPUs, including KVM_CHECK_EXTENSION.
> + */

Do you think it's worth mentioning the ioctl() always returning -EIO in case of
kvm->mm != current->mm? I suppose that's something purely hypothetical in this
context.

thanks,
Michal

