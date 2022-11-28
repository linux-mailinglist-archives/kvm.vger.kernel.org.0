Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F2AEA63AE5B
	for <lists+kvm@lfdr.de>; Mon, 28 Nov 2022 18:04:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232755AbiK1REs (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 28 Nov 2022 12:04:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49320 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232731AbiK1REW (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 28 Nov 2022 12:04:22 -0500
Received: from mail-pf1-x42e.google.com (mail-pf1-x42e.google.com [IPv6:2607:f8b0:4864:20::42e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EE77D26AEA
        for <kvm@vger.kernel.org>; Mon, 28 Nov 2022 09:04:00 -0800 (PST)
Received: by mail-pf1-x42e.google.com with SMTP id q12so7007567pfn.10
        for <kvm@vger.kernel.org>; Mon, 28 Nov 2022 09:04:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=R+xYVkIg3Eex/OftXposXwIE2BJ8dq2LKPQf7NrW3/o=;
        b=QKgSl8Nq+emnld5BL9+4mcXMoKLE69igTsm/xJJ2Sv7sIiBng7zrxARxxoi4/eoToJ
         JmmvHyiXCsi3tERPdiTIj1INUNArjTTxgdiFSJ+gr61afi1ua4S0SwlTCDM0ntIJHUKc
         hw6TY1QoMvOd+L4u6kmYV28AmeK8XuwuqMPprFsQcoWsU6r/DSPOOXFOfOqPkb2AaNeK
         khhwr3xT49APZnM6Kzo3b9sly372SbehWeEFOotGlcaRAn8mGDBoS9heC+PTg7cuf8FJ
         TQRECUw1ltaWme7Xj7ScBVUvWedidvZwnECreQ+Y4k8943vm0vrKVPQmgCNLQr2+GhBj
         Id0w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=R+xYVkIg3Eex/OftXposXwIE2BJ8dq2LKPQf7NrW3/o=;
        b=I2LAzfXMtJ4XbSPAV3aOxvL8Cz7sst2wO+nIABaNxpWErlPdLyH5E3FeXdqi0vKyvX
         UbC8M2tCQI3YRFq7g7yr1Efv9+ECx4BS+CHmqkPg7hgP2OT4RSen6vEEkEKWXZg6od4u
         XW8WBHErzh2CdqCEYmfN3mckOSNMN/4pCrgp0k4wfKtkEOm8+L1HV7SmcrebRkM9Mcpv
         oX23TgtLD5D054xX+M1AxU8mMDKVEpTsLf09/E7yvPf21jkwdNEaXfTaJecSConCqlDi
         LX8lmYitGewkUhUVmiKYwzaGX+/8EETE4xDUY/25PP7SPBVO5OGoY8d72EqKp8fCE2dH
         e5Ig==
X-Gm-Message-State: ANoB5pkecFvMMinUbTmdiQY4r4Ji8JFJWksyiQQcdAwBY6k1/KQ5CQHl
        tTgFucaJHbHQ2vzaRDaQ/E59SQ==
X-Google-Smtp-Source: AA0mqf45srP3cBcQ7tTPaca2nygNlKt5sM2ZPFLPPrgLm65+eg5whMYSoqzxgBriP1pHqPZ2d/jGLA==
X-Received: by 2002:a63:5920:0:b0:43f:88cc:473 with SMTP id n32-20020a635920000000b0043f88cc0473mr31324344pgb.491.1669655033066;
        Mon, 28 Nov 2022 09:03:53 -0800 (PST)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id jc21-20020a17090325d500b00176d347e9a7sm9063406plb.233.2022.11.28.09.03.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 28 Nov 2022 09:03:52 -0800 (PST)
Date:   Mon, 28 Nov 2022 17:03:49 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     "Wang, Lei" <lei4.wang@intel.com>
Cc:     kvm@vger.kernel.org, pbonzini@redhat.com,
        yang.zhong@linux.intel.com
Subject: Re: [PATCH] KVM: selftest: Move XFD CPUID checking out of
 __vm_xsave_require_permission()
Message-ID: <Y4Tp9YO0vgsaJeyd@google.com>
References: <20221125023839.315207-1-lei4.wang@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221125023839.315207-1-lei4.wang@intel.com>
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

On Thu, Nov 24, 2022, Wang, Lei wrote:
> kvm_cpu_has(X86_FEATURE_XFD) will call kvm_get_supported_cpuid() which will
> cache the cpuid information when it is firstly called. Move this line out
> of __vm_xsave_require_permission() and check it afterwards so that the
> CPUID change will not be veiled by the cached CPUID information.

Please call out exactly what CPUID change is being referred to.  Someone that
doesn't already know about ARCH_REQ_XCOMP_GUEST_PERM and it's interaction with
KVM_GET_SUPPORTED_CPUID will have zero clue what this fixes.

E.g.

Move the kvm_cpu_has() check on X86_FEATURE_XFD out of the helper to
enable off-by-default XSAVE-managed features and into the one test that
currenty requires XFD (XFeature Disable) support.   kvm_cpu_has() uses
kvm_get_supported_cpuid() and thus caches KVM_GET_SUPPORTED_CPUID, and so
using kvm_cpu_has() before ARCH_REQ_XCOMP_GUEST_PERM effectively results
in the test caching stale values, e.g. subsequent checks on AMX_TILE will
get false negatives.

Although off-by-default features are nonsensical without XFD, checking
for XFD virtualization prior to enabling such features isn't strictly
required.

Fixes: 7fbb653e01fd ("KVM: selftests: Check KVM's supported CPUID, not host CPUID, for XFD")

> Signed-off-by: Wang, Lei <lei4.wang@intel.com>
> ---
>  tools/testing/selftests/kvm/lib/x86_64/processor.c | 2 --
>  tools/testing/selftests/kvm/x86_64/amx_test.c      | 1 +
>  2 files changed, 1 insertion(+), 2 deletions(-)
> 
> diff --git a/tools/testing/selftests/kvm/lib/x86_64/processor.c b/tools/testing/selftests/kvm/lib/x86_64/processor.c
> index 39c4409ef56a..5686eacd4700 100644
> --- a/tools/testing/selftests/kvm/lib/x86_64/processor.c
> +++ b/tools/testing/selftests/kvm/lib/x86_64/processor.c
> @@ -616,8 +616,6 @@ void __vm_xsave_require_permission(int bit, const char *name)
>  		.addr = (unsigned long) &bitmask
>  	};
>  
> -	TEST_REQUIRE(kvm_cpu_has(X86_FEATURE_XFD));
> -
>  	kvm_fd = open_kvm_dev_path_or_exit();
>  	rc = __kvm_ioctl(kvm_fd, KVM_GET_DEVICE_ATTR, &attr);
>  	close(kvm_fd);
> diff --git a/tools/testing/selftests/kvm/x86_64/amx_test.c b/tools/testing/selftests/kvm/x86_64/amx_test.c
> index dadcbad10a1d..1e3457ff304b 100644
> --- a/tools/testing/selftests/kvm/x86_64/amx_test.c
> +++ b/tools/testing/selftests/kvm/x86_64/amx_test.c
> @@ -312,6 +312,7 @@ int main(int argc, char *argv[])
>  	/* Create VM */
>  	vm = vm_create_with_one_vcpu(&vcpu, guest_code);
>  
> +	TEST_REQUIRE(kvm_cpu_has(X86_FEATURE_XFD));

I think we should disallow kvm_get_supported_cpuid() before
__vm_xsave_require_permission(), otherwise we'll reintroduce a similar bug in the
future.
 
>  	TEST_REQUIRE(kvm_cpu_has(X86_FEATURE_XSAVE));
>  	TEST_REQUIRE(kvm_cpu_has(X86_FEATURE_AMX_TILE));
>  	TEST_REQUIRE(kvm_cpu_has(X86_FEATURE_XTILECFG));

And then as a follow-up, we should move these above vm_create_with_one_vcpu(),
checking them after vm_create_with_one_vcpu() is odd.

I'll send a v2 with the reworded changelog and additional patches to assert that
__vm_xsave_require_permission() isn't used after kvm_get_supported_cpuid().
