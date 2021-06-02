Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D1A7E399689
	for <lists+kvm@lfdr.de>; Thu,  3 Jun 2021 01:57:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229554AbhFBX6u (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 2 Jun 2021 19:58:50 -0400
Received: from mail-pf1-f173.google.com ([209.85.210.173]:37683 "EHLO
        mail-pf1-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229533AbhFBX6t (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 2 Jun 2021 19:58:49 -0400
Received: by mail-pf1-f173.google.com with SMTP id y15so3495807pfl.4
        for <kvm@vger.kernel.org>; Wed, 02 Jun 2021 16:57:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=w8bKAvJDF2/ejbmITp0Y9SOKD0U71nS0Tkvr2qtI/5k=;
        b=H2Nq+IXAm43kIiKRPbtw0K7qyEo/9Gw3yBPAwMkMDpodMpfHmz7sZRzZZI3bOiBGfw
         qN2PVTrxDVwyvoVKXFp7I5q212UWS8bxcqecLMmth27nlPpqAGbJ64I5Jhd6n7GjK7Lt
         F/1NtIDw0LWEUG9pQSpupEK6hVrkvediHSABps8059FJuWQenrwopscHUhcqu+UxWEM+
         aAtqs74dgkV3hTtP+vMeDeVXqtkkFVjBSoHMszyouhLKrKAT7Ee/hqyTgbsmNH9NIwbU
         a23d2E5GWCQOXNcuWZ5Y5KXV4bbWxqMb39N2xzqfWO4eahI9K3PjUBOw1dH+9+c+pSCw
         pixA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=w8bKAvJDF2/ejbmITp0Y9SOKD0U71nS0Tkvr2qtI/5k=;
        b=npTJqiCK2fpGI50WzSzzWLBcN9gemPhQvpDgR1RizYDiAZJeAZvsvdPoI4ux7TZmxt
         V1PFW/RdYEcO2Y7xzQQA4/E/G+/zHbZURs19rYV0etPF+fZBMI54RlWxMKMlzRzTipII
         xsxK5yRhJVMzG9nnakVChV+JY+PvNbH2HVQtwCYxiwbL3VHmKZ+IbcU18sHjBw7abAXI
         M1hWPicB5IUiGMBKEav5L23Cs309NA+c8I1T0Z4XIQVvAl7tN9h3pACb9g6sFWoCGCDm
         p1hn2rBNoV+xnqF41CDB9gaMsDqFM+6sjUCilMsqPHioANc9aERGYGUkPjxAUb7toGsg
         mLsw==
X-Gm-Message-State: AOAM531JS0vynwAy5uNeJ81sfYfofGAtNTIm4HSUq5OXXWdQQ0OQ+KF4
        sDRBIGGx36wlS0toJqkrduWL/g==
X-Google-Smtp-Source: ABdhPJzjb89zQaridnBNqeIcwirFsJPJ8AiysuXbJ/FWVCSqWdrlpD+fTXcJAQ/fBGX8VKYMQmTEDw==
X-Received: by 2002:a63:4b18:: with SMTP id y24mr36580105pga.438.1622678165836;
        Wed, 02 Jun 2021 16:56:05 -0700 (PDT)
Received: from google.com (150.12.83.34.bc.googleusercontent.com. [34.83.12.150])
        by smtp.gmail.com with ESMTPSA id s24sm549111pfh.104.2021.06.02.16.56.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 02 Jun 2021 16:56:05 -0700 (PDT)
Date:   Wed, 2 Jun 2021 16:56:01 -0700
From:   Ricardo Koller <ricarkol@google.com>
To:     Andrew Jones <drjones@redhat.com>
Cc:     kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu, maz@kernel.org,
        eric.auger@redhat.com, alexandru.elisei@arm.com,
        pbonzini@redhat.com
Subject: Re: [PATCH v3 2/5] KVM: arm64: selftests: get-reg-list: Prepare to
 run multiple configs at once
Message-ID: <YLgakV2Eru1J2f4K@google.com>
References: <20210531103344.29325-1-drjones@redhat.com>
 <20210531103344.29325-3-drjones@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210531103344.29325-3-drjones@redhat.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, May 31, 2021 at 12:33:41PM +0200, Andrew Jones wrote:
> We don't want to have to create a new binary for each vcpu config, so
> prepare to run the test for multiple vcpu configs in a single binary.
> We do this by factoring out the test from main() and then looping over
> configs. When given '--list' we still never print more than a single
> reg-list for a single vcpu config though, because it would be confusing
> otherwise.
> 
> No functional change intended.
> 
> Signed-off-by: Andrew Jones <drjones@redhat.com>

Reviewed-by: Ricardo Koller <ricarkol@google.com>

> ---
>  .../selftests/kvm/aarch64/get-reg-list.c      | 68 ++++++++++++++-----
>  1 file changed, 51 insertions(+), 17 deletions(-)
> 
> diff --git a/tools/testing/selftests/kvm/aarch64/get-reg-list.c b/tools/testing/selftests/kvm/aarch64/get-reg-list.c
> index 7bb09ce20dde..14fc8d82e30f 100644
> --- a/tools/testing/selftests/kvm/aarch64/get-reg-list.c
> +++ b/tools/testing/selftests/kvm/aarch64/get-reg-list.c
> @@ -56,8 +56,8 @@ struct vcpu_config {
>  	struct reg_sublist sublists[];
>  };
>  
> -static struct vcpu_config vregs_config;
> -static struct vcpu_config sve_config;
> +static struct vcpu_config *vcpu_configs[];
> +static int vcpu_configs_n;
>  
>  #define for_each_sublist(c, s)							\
>  	for ((s) = &(c)->sublists[0]; (s)->regs; ++(s))
> @@ -400,29 +400,20 @@ static void check_supported(struct vcpu_config *c)
>  	}
>  }
>  
> -int main(int ac, char **av)
> +static bool print_list;
> +static bool print_filtered;
> +static bool fixup_core_regs;
> +
> +static void run_test(struct vcpu_config *c)
>  {
> -	struct vcpu_config *c = reg_list_sve() ? &sve_config : &vregs_config;
>  	struct kvm_vcpu_init init = { .target = -1, };
>  	int new_regs = 0, missing_regs = 0, i, n;
>  	int failed_get = 0, failed_set = 0, failed_reject = 0;
> -	bool print_list = false, print_filtered = false, fixup_core_regs = false;
>  	struct kvm_vm *vm;
>  	struct reg_sublist *s;
>  
>  	check_supported(c);
>  
> -	for (i = 1; i < ac; ++i) {
> -		if (strcmp(av[i], "--core-reg-fixup") == 0)
> -			fixup_core_regs = true;
> -		else if (strcmp(av[i], "--list") == 0)
> -			print_list = true;
> -		else if (strcmp(av[i], "--list-filtered") == 0)
> -			print_filtered = true;
> -		else
> -			TEST_FAIL("Unknown option: %s\n", av[i]);
> -	}
> -
>  	vm = vm_create(VM_MODE_DEFAULT, DEFAULT_GUEST_PHY_PAGES, O_RDWR);
>  	prepare_vcpu_init(c, &init);
>  	aarch64_vcpu_add_default(vm, 0, &init, NULL);
> @@ -442,7 +433,7 @@ int main(int ac, char **av)
>  				print_reg(c, id);
>  		}
>  		putchar('\n');
> -		return 0;
> +		return;
>  	}
>  
>  	/*
> @@ -541,6 +532,44 @@ int main(int ac, char **av)
>  		    "%d registers failed get; %d registers failed set; %d registers failed reject",
>  		    config_name(c), missing_regs, failed_get, failed_set, failed_reject);
>  
> +	pr_info("%s: PASS\n", config_name(c));
> +	blessed_n = 0;
> +	free(blessed_reg);
> +	free(reg_list);
> +	kvm_vm_free(vm);
> +}
> +
> +int main(int ac, char **av)
> +{
> +	struct vcpu_config *c, *sel = NULL;
> +	int i;
> +
> +	for (i = 1; i < ac; ++i) {
> +		if (strcmp(av[i], "--core-reg-fixup") == 0)
> +			fixup_core_regs = true;
> +		else if (strcmp(av[i], "--list") == 0)
> +			print_list = true;
> +		else if (strcmp(av[i], "--list-filtered") == 0)
> +			print_filtered = true;
> +		else
> +			TEST_FAIL("Unknown option: %s\n", av[i]);
> +	}
> +
> +	if (print_list || print_filtered) {
> +		/*
> +		 * We only want to print the register list of a single config.
> +		 * TODO: Add command line support to pick which config.
> +		 */
> +		sel = vcpu_configs[0];
> +	}
> +
> +	for (i = 0; i < vcpu_configs_n; ++i) {
> +		c = vcpu_configs[i];
> +		if (sel && c != sel)
> +			continue;
> +		run_test(c);
> +	}
> +
>  	return 0;
>  }
>  
> @@ -945,3 +974,8 @@ static struct vcpu_config sve_config = {
>  	{0},
>  	},
>  };
> +
> +static struct vcpu_config *vcpu_configs[] = {
> +	reg_list_sve() ? &sve_config : &vregs_config,
> +};
> +static int vcpu_configs_n = ARRAY_SIZE(vcpu_configs);
> -- 
> 2.31.1
> 
