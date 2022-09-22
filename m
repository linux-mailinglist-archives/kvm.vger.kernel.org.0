Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8CFF75E5DBF
	for <lists+kvm@lfdr.de>; Thu, 22 Sep 2022 10:44:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230400AbiIVIog (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 22 Sep 2022 04:44:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42988 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230358AbiIVIoe (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 22 Sep 2022 04:44:34 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 70028110E
        for <kvm@vger.kernel.org>; Thu, 22 Sep 2022 01:44:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1663836269;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=VaYXNrEhF9SkCIvAw0+lUOkeDauzgEyAxcBo51EhDMk=;
        b=QV5vrwttIR9xMCCVO3SQZ7iizPkY4BpRQiX5FBWArVOKkGI+nMOFmv3bztc/YAZ+ILjPKy
        3MCViCFctj0aPJnRIOejIeUdAmu9Xy9y9yKFZQEEJkYexBqTP7XQ++FZrvMiv3My5YrwNV
        KDkLLpVenTGCaAVISkEcimBdVUx50bk=
Received: from mail-ej1-f70.google.com (mail-ej1-f70.google.com
 [209.85.218.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-108-hzEmEHynN3-nOKdYGY7QeA-1; Thu, 22 Sep 2022 04:44:27 -0400
X-MC-Unique: hzEmEHynN3-nOKdYGY7QeA-1
Received: by mail-ej1-f70.google.com with SMTP id he41-20020a1709073da900b00780bff831ebso4081365ejc.6
        for <kvm@vger.kernel.org>; Thu, 22 Sep 2022 01:44:27 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=mime-version:message-id:date:references:in-reply-to:subject:cc:to
         :from:x-gm-message-state:from:to:cc:subject:date;
        bh=VaYXNrEhF9SkCIvAw0+lUOkeDauzgEyAxcBo51EhDMk=;
        b=Eu5xlWvxMhmEOudj89ARPQGEC9vndd+QZqxP7xgxnpvVLTBnkpjo6lmAFwUwDfAt0K
         kkxZzz7+roh7ULyk69cFvf0etQH4ro5/zYUgRyPkr/l/43N2lbqIpoObh9j3e/eI1ql8
         tUD/cjB5A13f+kNBDxPgnPMSWFJjnmFtyzgZBogyOolCs9aQYzAPeji/2/MimMmIRBXq
         UT7u/8eFeWHeOVDQ3PCX5qFaP0VeBRmTf2GaNlfT4VAcswWjMJVK2CqosJSnziJSJYVR
         AMXJKlXaJXbp67n7aHfQpLJAV3O7y1Q7ccVQ9UFCyRmfd2dGZZmlkyngOYvVvMSU/nrj
         /SVg==
X-Gm-Message-State: ACrzQf2qPGGExmC4HWlGPWlMr5kZDm79mAcwLrYB1X/TUeSm8fNAev7a
        bCATAyD8q9bQ+PBmA5nPLl3uhNbYbarQQ1haxZ/tfZ3zPN1CNofdHjRfj5OebU504dyBcRfGUEF
        XK2tUfsVK6V1U
X-Received: by 2002:a05:6402:2489:b0:454:11de:7698 with SMTP id q9-20020a056402248900b0045411de7698mr2148312eda.214.1663836266309;
        Thu, 22 Sep 2022 01:44:26 -0700 (PDT)
X-Google-Smtp-Source: AMsMyM76AWfqa75dHov8UHe5lqSOhHZZZIH/7vxvIY4ZYiDmZ1kn4bxKpOY1qNt2GfoMjYC9JRiqUQ==
X-Received: by 2002:a05:6402:2489:b0:454:11de:7698 with SMTP id q9-20020a056402248900b0045411de7698mr2148300eda.214.1663836266053;
        Thu, 22 Sep 2022 01:44:26 -0700 (PDT)
Received: from fedora (nat-2.ign.cz. [91.219.240.2])
        by smtp.gmail.com with ESMTPSA id b20-20020a17090630d400b007262a5e2204sm2305509ejb.153.2022.09.22.01.44.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 22 Sep 2022 01:44:24 -0700 (PDT)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     Vipin Sharma <vipinsh@google.com>, seanjc@google.com,
        pbonzini@redhat.com
Cc:     jmattson@google.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Vipin Sharma <vipinsh@google.com>
Subject: Re: [PATCH v2] KVM: selftests: Check result in hyperv_features.c
 test only for successful hypercalls
In-Reply-To: <20220922062451.2927010-1-vipinsh@google.com>
References: <20220922062451.2927010-1-vipinsh@google.com>
Date:   Thu, 22 Sep 2022 10:44:23 +0200
Message-ID: <87fsgjol20.fsf@redhat.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="=-=-="
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

--=-=-=
Content-Type: text/plain

Vipin Sharma <vipinsh@google.com> writes:

> Commit cc5851c6be86 ("KVM: selftests: Use exception fixup for #UD/#GP
> Hyper-V MSR/hcall tests") introduced a wrong guest assert in guest_hcall().
> It is not checking the successful hypercall results and only checks the result
> when a fault happens.
>
>   GUEST_ASSERT_2(!hcall->ud_expected || res == hcall->expect,
>                  hcall->expect, res);
>
> Correct the assertion by only checking results of the successful
> hypercalls.
>
> This issue was observed when this test started failing after building it
> in Clang. Above guest assert statement fails because "res" is not equal
> to "hcall->expect" when "hcall->ud_expected" is true. "res" gets some
> garbage value in Clang from the RAX register. In GCC, RAX is 0 because
> it using RAX for @output_address in the asm statement and resetting it
> to 0 before using it as output operand in the same asm statement. Clang
> is not using RAX for @output_address.
>
> Load RAX with some default input value so that the compiler cannot
> modify it or use it for anything else. This makes sure that KVM is
> correctly clearing up return value on successful hypercall and compiler cannot
> generate any false positive.
>
> Fixes: cc5851c6be86 ("KVM: selftests: Use exception fixup for #UD/#GP Hyper-V MSR/hcall tests")
> Signed-off-by: Vipin Sharma <vipinsh@google.com>
> Suggested-by: Sean Christopherson <seanjc@google.com>
> Reviewed-by: Jim Mattson <jmattson@google.com>
>
> ---
>
> Jim's Reviewed-by is only for the code change and not shortlog message
> of v1. Also, there is one change in asm which was not present in v1 and
> not reviewed by Jim. But I am writing his name here so that it is not missed
> when patch is merged.
>
> v2:
> - Updated the shortlog message.
> - Using RAX register in hypercall asm as input operand also and
>   initializing it with -EFAULT
>
> v1:
> https://lore.kernel.org/lkml/20220921231151.2321058-1-vipinsh@google.com/
>
>  tools/testing/selftests/kvm/x86_64/hyperv_features.c | 11 ++++++-----
>  1 file changed, 6 insertions(+), 5 deletions(-)
>
> diff --git a/tools/testing/selftests/kvm/x86_64/hyperv_features.c b/tools/testing/selftests/kvm/x86_64/hyperv_features.c
> index 79ab0152d281..4d55e038c2d7 100644
> --- a/tools/testing/selftests/kvm/x86_64/hyperv_features.c
> +++ b/tools/testing/selftests/kvm/x86_64/hyperv_features.c
> @@ -26,7 +26,8 @@ static inline uint8_t hypercall(u64 control, vm_vaddr_t input_address,
>  		     : "=a" (*hv_status),
>  		       "+c" (control), "+d" (input_address),
>  		       KVM_ASM_SAFE_OUTPUTS(vector)
> -		     : [output_address] "r"(output_address)
> +		     : [output_address] "r"(output_address),
> +		       "a" (-EFAULT)
>  		     : "cc", "memory", "r8", KVM_ASM_SAFE_CLOBBERS);
>  	return vector;
>  }
> @@ -81,13 +82,13 @@ static void guest_hcall(vm_vaddr_t pgs_gpa, struct hcall_data *hcall)
>  	}
>  
>  	vector = hypercall(hcall->control, input, output, &res);
> -	if (hcall->ud_expected)
> +	if (hcall->ud_expected) {
>  		GUEST_ASSERT_2(vector == UD_VECTOR, hcall->control, vector);
> -	else
> +	} else {
>  		GUEST_ASSERT_2(!vector, hcall->control, vector);
> +		GUEST_ASSERT_2(res == hcall->expect, hcall->expect, res);
> +	}
>  
> -	GUEST_ASSERT_2(!hcall->ud_expected || res == hcall->expect,
> -			hcall->expect, res);
>  	GUEST_DONE();
>  }

And this immediately discovers a problem in the test!

$ ./x86_64/hyperv_features 
Testing access to Hyper-V specific MSRs
Testing access to Hyper-V hypercalls
==== Test Assertion Failure ====
  x86_64/hyperv_features.c:622: false
  pid=3683520 tid=3683520 errno=4 - Interrupted system call
     1	0x0000000000402832: guest_test_hcalls_access at hyperv_features.c:622
     2	 (inlined by) main at hyperv_features.c:642
     3	0x00007f546503feaf: ?? ??:0
     4	0x00007f546503ff5f: ?? ??:0
     5	0x0000000000402eb4: _start at ??:?
  Failed guest assert: res == hcall->expect at x86_64/hyperv_features.c:89
arg1 = 2, arg2 = 3

The root cause is: we're trying to test an invalid hypercall code but we
set 'control' wrong, i.e.:

	hcall->control = 0xdeadbeef;
	hcall->expect = HV_STATUS_INVALID_HYPERCALL_CODE;

as '0xdeadbeef' contains reserved bits 27 through 31 and we're getting
HV_STATUS_INVALID_HYPERCALL_INPUT instead.

Could you please include the attached patch to your series? Thanks a bunch!

For your patch:
Reviewed-by: Vitaly Kuznetsov <vkuznets@redhat.com>

-- 
Vitaly


--=-=-=
Content-Type: text/x-patch
Content-Disposition: inline;
 filename=0001-KVM-selftests-Do-not-set-reserved-control-bits-when-.patch

From d0670e7d7ed4c4a00f46c1f0b69e1e06eae06c8f Mon Sep 17 00:00:00 2001
From: Vitaly Kuznetsov <vkuznets@redhat.com>
Date: Thu, 22 Sep 2022 10:39:41 +0200
Subject: [PATCH] KVM: selftests: Do not set reserved control bits when testing
 invalid Hyper-V hypercall number
Content-Type: text/plain

Bits 27 through 31 in Hyper-V hypercall 'control' are reserved (see
HV_HYPERCALL_RSVD0_MASK) but '0xdeadbeef' includes them. This causes
KVM to return HV_STATUS_INVALID_HYPERCALL_INPUT instead of the expected
HV_STATUS_INVALID_HYPERCALL_CODE.

The test doesn't currently fail as the problem is masked by the wrong check
of the hypercall return code, this is going to be fixed separately.

Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
---
 tools/testing/selftests/kvm/x86_64/hyperv_features.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/testing/selftests/kvm/x86_64/hyperv_features.c b/tools/testing/selftests/kvm/x86_64/hyperv_features.c
index 79ab0152d281..d71b5cd4b74b 100644
--- a/tools/testing/selftests/kvm/x86_64/hyperv_features.c
+++ b/tools/testing/selftests/kvm/x86_64/hyperv_features.c
@@ -507,7 +507,7 @@ static void guest_test_hcalls_access(void)
 		switch (stage) {
 		case 0:
 			feat->eax |= HV_MSR_HYPERCALL_AVAILABLE;
-			hcall->control = 0xdeadbeef;
+			hcall->control = 0xbeef;
 			hcall->expect = HV_STATUS_INVALID_HYPERCALL_CODE;
 			break;
 
-- 
2.37.3


--=-=-=--

