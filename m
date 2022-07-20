Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 34E5A57C0D5
	for <lists+kvm@lfdr.de>; Thu, 21 Jul 2022 01:23:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231430AbiGTXXy (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 20 Jul 2022 19:23:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40926 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231293AbiGTXXw (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 20 Jul 2022 19:23:52 -0400
Received: from mail-pj1-x102e.google.com (mail-pj1-x102e.google.com [IPv6:2607:f8b0:4864:20::102e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DF0DF4F6A4
        for <kvm@vger.kernel.org>; Wed, 20 Jul 2022 16:23:51 -0700 (PDT)
Received: by mail-pj1-x102e.google.com with SMTP id o5-20020a17090a3d4500b001ef76490983so3689718pjf.2
        for <kvm@vger.kernel.org>; Wed, 20 Jul 2022 16:23:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=ZcOsGUTY+jxlUI545yWUbvFPl+aZJvPHoIP7UpfQ5XA=;
        b=kbxwLO4iCnuAg3bkPewULTWwrUxaNQruWxxzUVMN7RghidtXrqAJFcubbW1830H7dP
         kKhWkmhwfsOXaBL9kb2mFh60po0CbORHxX304iJnrLaKn/L1GpuBz2fOE+GbrSrdl7Sw
         Mg5F8GQjfB1+7q8JQyOgonXepQR/4ZWev2FzfzLo9YzriDaiu6cM+u7/EQKOu0JICfmK
         tgqbZY4JFDvXpl6S7zd7IX88zfA09cjhDIaCubXnm28ccpk5xjfUS6HEp7N3QikDJbWO
         i9bvBc47Pyboyb16pRSoslW/O0npGPUTGbTkeLcdU+uh/c8j17D1FPVZuOF2cWaAJKJg
         Aprg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=ZcOsGUTY+jxlUI545yWUbvFPl+aZJvPHoIP7UpfQ5XA=;
        b=CIQFM23UpY+/IP3kUrYh2o1Jmy6E401QoZGmAwl/oyW9p3NGUbBzceqzfI4x5GyjRT
         Z07K0xQYlVX9KkwoJclEScr85NNdnT5Bgy1Wyhn5umWpm7mVxX9WORE+aPoCZyppfQlh
         4wOUng9+sUGplFZ/8WXxCOSPQHinTy37AGyUFWFZtCru8Cedjf+nys1xSJTrs02d+ls3
         NHarBNvhtChJIGR2EOWh0ufDTgcA1VzA+GuJG7h2toLKD7KeJQVIaRgnFhFqXEOtgCL7
         9l2WQv5t120PLQcMRooZHkv6/66FZj8MHCRejRiaInhfgayLnDWTWlQtK2NPDjI8i0mz
         g5/A==
X-Gm-Message-State: AJIora8RYFIXXcAo+4v3sG3KMr3FCruT7eEXFcHVzMBzR3s9+/kFYPQF
        KYk39nr5n4pdCPvpi9hwhgORHg==
X-Google-Smtp-Source: AGRyM1tPQ2KmxItkLMO5hY/NRvHFtRky0mpHHGbngBlpyM5YaYheWPFG15VwH5cXN+y0zPHZOVD0qg==
X-Received: by 2002:a17:902:b191:b0:16c:64ef:ed86 with SMTP id s17-20020a170902b19100b0016c64efed86mr40756681plr.63.1658359431172;
        Wed, 20 Jul 2022 16:23:51 -0700 (PDT)
Received: from google.com (123.65.230.35.bc.googleusercontent.com. [35.230.65.123])
        by smtp.gmail.com with ESMTPSA id z12-20020a63e54c000000b004119deff40dsm48683pgj.23.2022.07.20.16.23.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 20 Jul 2022 16:23:50 -0700 (PDT)
Date:   Wed, 20 Jul 2022 23:23:46 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Aaron Lewis <aaronlewis@google.com>
Cc:     kvm@vger.kernel.org, pbonzini@redhat.com, jmattson@google.com
Subject: Re: [RFC PATCH v2 3/3] selftests: kvm/x86: Test the flags in MSR
 filtering / exiting
Message-ID: <YtiOgtQy1bjL3VNX@google.com>
References: <20220719234950.3612318-1-aaronlewis@google.com>
 <20220719234950.3612318-4-aaronlewis@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220719234950.3612318-4-aaronlewis@google.com>
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Jul 19, 2022, Aaron Lewis wrote:
> When using the flags in KVM_X86_SET_MSR_FILTER and
> KVM_CAP_X86_USER_SPACE_MSR it is expected that an attempt to write to
> any of the unused bits will fail.  Add testing to walk over every bit
> in each of the flag fields in MSR filtering / exiting to verify that
> happens.
> 
> Signed-off-by: Aaron Lewis <aaronlewis@google.com>
> ---
>  .../kvm/x86_64/userspace_msr_exit_test.c      | 95 +++++++++++++++++++
>  1 file changed, 95 insertions(+)
> 
> diff --git a/tools/testing/selftests/kvm/x86_64/userspace_msr_exit_test.c b/tools/testing/selftests/kvm/x86_64/userspace_msr_exit_test.c
> index f84dc37426f5..3b4ad16cc982 100644
> --- a/tools/testing/selftests/kvm/x86_64/userspace_msr_exit_test.c
> +++ b/tools/testing/selftests/kvm/x86_64/userspace_msr_exit_test.c
> @@ -734,6 +734,99 @@ static void test_msr_permission_bitmap(void)
>  	kvm_vm_free(vm);
>  }
>  
> +static void test_results(int rc, const char *scmd, bool expected_success)

Rather than pass in "success expected", pass in the actual value and the valid
mask.  Then you can spit out the problematic value in the assert and be kind to
future debuggers.

And similarly, make the __vm_ioctl() call here instead of in the "caller" and name
this __test_ioctl() (rename as necessary, see below) to show it's relationship with
the macro.

> +{
> +	int expected_rc;
> +
> +	expected_rc = expected_success ? 0 : -1;
> +	TEST_ASSERT(rc == expected_rc,
> +		    "Unexpected result from '%s', rc: %d, expected rc: %d.",
> +		    scmd, rc, expected_rc);
> +	TEST_ASSERT(!rc || (rc == -1 && errno == EINVAL),
> +		    "Failures are expected to have rc == -1 && errno == EINVAL(%d),\n"
> +		    "  got rc: %d, errno: %d",
> +		    EINVAL, rc, errno);
> +}
> +
> +#define test_ioctl(vm, cmd, arg, expected_success)	\

As above, just do e.g.

#define test_ioctl(vm, cmd, arg, val, valid_mask)	\
	__test_ioctl(vm, cmd, arg, #cmd, val, valid_mask)

Though it might be worth using a more verbose name?  E.g. test_msr_filtering_ioctl()?
Hmm, but I guess KVM_CAP_X86_USER_SPACE_MSR isn't technically filtering.
test_user_exit_msr_ioctl()?  Not a big deal if that's too wordy.

> +({							\
> +	int rc = __vm_ioctl(vm, cmd, arg);		\
> +							\
> +	test_results(rc, #cmd, expected_success);	\
> +})
> +#define FLAG (1ul << i)

No.  :-)

First, silently consuming local variables is Evil with a capital E.

Second, just use BIT() or BIT_ULL().

> +/* Test that attempts to write to the unused bits in a flag fails. */
> +static void test_flags(void)

For this one, definitely use a more verbose name, even if it seems stupidly
redundant.  test_user_msr_exit_flags()?

> +{
> +	struct kvm_vcpu *vcpu;
> +	struct kvm_vm *vm;
> +
> +	vm = vm_create_with_one_vcpu(&vcpu, NULL);
> +
> +	/* Test flags for KVM_CAP_X86_USER_SPACE_MSR. */
> +	run_user_space_msr_flag_test(vm);
> +
> +	/* Test flags and range flags for KVM_X86_SET_MSR_FILTER. */
> +	run_msr_filter_flag_test(vm);
> +
> +	kvm_vm_free(vm);
> +}
> +
>  int main(int argc, char *argv[])
>  {
>  	/* Tell stdout not to buffer its content */
> @@ -745,5 +838,7 @@ int main(int argc, char *argv[])
>  
>  	test_msr_permission_bitmap();
>  
> +	test_flags();
> +
>  	return 0;
>  }
> -- 
> 2.37.1.359.gd136c6c3e2-goog
> 
