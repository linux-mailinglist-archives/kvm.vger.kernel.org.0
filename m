Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 117DB50020D
	for <lists+kvm@lfdr.de>; Thu, 14 Apr 2022 00:48:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238233AbiDMWuw (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 13 Apr 2022 18:50:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39802 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238062AbiDMWup (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 13 Apr 2022 18:50:45 -0400
Received: from mail-pl1-x630.google.com (mail-pl1-x630.google.com [IPv6:2607:f8b0:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8687F583A9
        for <kvm@vger.kernel.org>; Wed, 13 Apr 2022 15:48:22 -0700 (PDT)
Received: by mail-pl1-x630.google.com with SMTP id v12so3183283plv.4
        for <kvm@vger.kernel.org>; Wed, 13 Apr 2022 15:48:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=BWDcRvlcACWbh4dLrXlVIAQiZ0iwUy3CwzcBurn6W5k=;
        b=GLB/dZeXcK9x0+8IJh6XpIAyQ4Jy+6QuCDLBae2fwpu3/6UxR9BDzB/Mt3reRbQH5O
         hT1q3Mxf+18dfJZqG8yv4dPR1a0wlGSIRHA99ykan7WPx4XqZbGmi4+W//d1W0Ke93uH
         BTDmMOxswZ3hR4UQgT/zF18Y/lkmhNApAVHuOYrGtW9H1lgUcNboV65jbfQhRinxmcjR
         yNbme2jxX5myTnrU64Ni16FgeG46b50uR3oHbMggUhEClTMN4hTbGYv20EVq03ok2p5k
         RPwydPkkx4VFaXG1wZpbZx26aU0TWPPlV0szbYfjbu0xLU2EsdpccfPfMLW2hfiyuS9r
         4qZw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=BWDcRvlcACWbh4dLrXlVIAQiZ0iwUy3CwzcBurn6W5k=;
        b=zFuKiIde4q8C6UmwDV3xuqm50kHn6kXDyVQCbb5Uo7FRHDGIutLNMslH7QS3T5oaUk
         Qdfnd+mTowK/aPwCTTPtRur0GhgBz2RBCQoX1OcSF50oqdz2j0HyLTygc6wCOgmzrXDs
         0d+Qr4s1YVJWWP4cL9bTlvftV8OBgXk1yPNKD37JlDdRqwN9V78zuXDNKo104oL37bWH
         2FxvtbkZKRbuetsaUbkLdImvMygAd2imM8zBGwekcw1NGbZHAyYbFgHj8aLBrhvb7+xf
         HVmvX5snutD5BBCdh3HfwIr59vKmmT1Ri/0FZj4mH7EIkHcem7Afn3N2z8ZnRSPclIW4
         jNtg==
X-Gm-Message-State: AOAM532695NCzVF7kMEGItRjGf6h/83bIElg3noUND1E7BjSvv5kc8B3
        HO6EhcN4xd2/NxI6rPHLColp6g==
X-Google-Smtp-Source: ABdhPJxqvRe3fCUY5+aIDspm3J9J5wiKSYq0d2ut+7oZsZ1vO+LGoKXG3p3k4LB2+u49l38ISdK+RQ==
X-Received: by 2002:a17:90a:5298:b0:1ca:7fb3:145 with SMTP id w24-20020a17090a529800b001ca7fb30145mr442363pjh.200.1649890101837;
        Wed, 13 Apr 2022 15:48:21 -0700 (PDT)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id u5-20020a17090a3fc500b001cb3fec230bsm97047pjm.14.2022.04.13.15.48.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 13 Apr 2022 15:48:21 -0700 (PDT)
Date:   Wed, 13 Apr 2022 22:48:17 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Ben Gardon <bgardon@google.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Peter Xu <peterx@redhat.com>,
        David Matlack <dmatlack@google.com>,
        Jim Mattson <jmattson@google.com>,
        David Dunn <daviddunn@google.com>,
        Jing Zhang <jingzhangos@google.com>,
        Junaid Shahid <junaids@google.com>
Subject: Re: [PATCH v5 10/10] KVM: selftests: Test disabling NX hugepages on
 a VM
Message-ID: <YldTMfNEzsweKi1V@google.com>
References: <20220413175944.71705-1-bgardon@google.com>
 <20220413175944.71705-11-bgardon@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220413175944.71705-11-bgardon@google.com>
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Apr 13, 2022, Ben Gardon wrote:
> diff --git a/tools/testing/selftests/kvm/x86_64/nx_huge_pages_test.c b/tools/testing/selftests/kvm/x86_64/nx_huge_pages_test.c
> index 7f80e48781fd..21c31e1d567e 100644
> --- a/tools/testing/selftests/kvm/x86_64/nx_huge_pages_test.c
> +++ b/tools/testing/selftests/kvm/x86_64/nx_huge_pages_test.c
> @@ -13,6 +13,8 @@
>  #include <fcntl.h>
>  #include <stdint.h>
>  #include <time.h>
> +#include <linux/reboot.h>
> +#include <sys/syscall.h>
>  
>  #include <test_util.h>
>  #include "kvm_util.h"
> @@ -80,13 +82,45 @@ static void check_split_count(struct kvm_vm *vm, int expected_splits)
>  		    expected_splits, actual_splits);
>  }
>  
> -int main(int argc, char **argv)
> +void run_test(bool disable_nx)

Probably worth naming this disable_nx_workaround or disable_nx_mitigation, it's
quite easy to think this means "disable EFER.NX".

>  {
>  	struct kvm_vm *vm;
>  	struct timespec ts;
> +	uint64_t pages;
>  	void *hva;
> -
> -	vm = vm_create_default(0, 0, guest_code);
> +	int r;
> +
> +	pages = vm_pages_needed(VM_MODE_DEFAULT, 1, DEFAULT_GUEST_PHY_PAGES,
> +				0, 0);
> +	vm = vm_create_without_vcpus(VM_MODE_DEFAULT, pages);
> +
> +	if (disable_nx) {
> +		kvm_check_cap(KVM_CAP_VM_DISABLE_NX_HUGE_PAGES);
> +
> +		/*
> +		 * Check if this process has the reboot permissions needed to
> +		 * disable NX huge pages on a VM.
> +		 *
> +		 * The reboot call below will never have any effect because
> +		 * the magic values are not set correctly, however the
> +		 * permission check is done before the magic value check.
> +		 */
> +		r = syscall(SYS_reboot, 0, 0, 0, NULL);
> +		if (r && errno == EPERM) {
> +			r = vm_disable_nx_huge_pages(vm);
> +			TEST_ASSERT(r == EPERM,
> +				    "This process should not have permission to disable NX huge pages");

First off, huge kudos for negative testing!  But, it's going to provide poor coverage
if we teach everyone to use the runner script, because that'll likely require root on
most hosts, e.g. to futz with the module param.

Aha!  Idea.  And it should eliminate the SYS_reboot shenanigans, which while hilarious,
are mildy scary.

In the runner script, wrap all the modification of sysfs knobs with sudo, and then
(again with sudo) do:

	setcap cap_sys_boot+ep path/to/nx_huge_pages_test
	path/to/nx_huge_pages_test MAGIC_NUMBER -b

where "-b" means "has CAP_SYS_BOOT".  And then 

	setcap cap_sys_boot-ep path/to/nx_huge_pages_test
	path/to/nx_huge_pages_test MAGIC_NUMBER

Hmm, and I guess if the script is run as root, just skip the second invocation.

> +			return;
> +		}
> +
> +		TEST_ASSERT(r && errno == EINVAL,
> +			    "Reboot syscall should fail with -EINVAL");
> +
> +		r = vm_disable_nx_huge_pages(vm);
> +		TEST_ASSERT(!r, "Disabling NX huge pages should succeed if process has reboot permissions");
> +	}
> +
> +	vm_vcpu_add_default(vm, 0, guest_code);
>  
>  	vm_userspace_mem_region_add(vm, VM_MEM_SRC_ANONYMOUS_HUGETLB,
>  				    HPAGE_GPA, HPAGE_SLOT,
> @@ -121,21 +155,21 @@ int main(int argc, char **argv)
>  	 * to be remapped at 4k.
>  	 */
>  	vcpu_run(vm, 0);
> -	check_2m_page_count(vm, 1);
> -	check_split_count(vm, 1);
> +	check_2m_page_count(vm, disable_nx ? 2 : 1);
> +	check_split_count(vm, disable_nx ? 0 : 1);

Can you update the comments to explain why these magic number of pages are
expected for NX enabled/disabled?  As Jim has pointed out, just because KVM and
selftests might agree that 1==2, doesn't mean that their math is correct :-)
