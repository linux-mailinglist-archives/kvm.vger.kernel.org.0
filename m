Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 238FF5FF559
	for <lists+kvm@lfdr.de>; Fri, 14 Oct 2022 23:27:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229511AbiJNV1Z (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 14 Oct 2022 17:27:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54202 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229960AbiJNV1N (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 14 Oct 2022 17:27:13 -0400
Received: from mail-pj1-x1029.google.com (mail-pj1-x1029.google.com [IPv6:2607:f8b0:4864:20::1029])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 756867FE6A
        for <kvm@vger.kernel.org>; Fri, 14 Oct 2022 14:27:10 -0700 (PDT)
Received: by mail-pj1-x1029.google.com with SMTP id x1-20020a17090ab00100b001fda21bbc90so9038397pjq.3
        for <kvm@vger.kernel.org>; Fri, 14 Oct 2022 14:27:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=R7qTg4rvqZImy4oSXdOm12cIKEYmtASg3XAfcAnUDcM=;
        b=l25kqs3a61DaB3+w+wPvWgbq+VuBHGQozUNEFz5hqhixj5qz64yh7XX1XVs5rquKe6
         q7c23KkvieMhgPIT+OOgNM88n2dm7rJY3G4FRhwr/nNv5Rj0Lf6PZI8nP3roPxtXaMdS
         GY+747N44GgC133eQMUHrGiBefoUnge0flfTz6nAAkC+s6tmNU+Hm3EZpwm19cGzXO+d
         fob8k5w0NREvitPeDw5KMEzDaJ089YaSaWx4VLBcY2E4+4GbhauC28MpAFhEjfnGjnCq
         bws1dIeh/bSHr5EhHNDRWYyKNcJGWWzf1+y2ugyae2FIkeB9grWmdYsr2MKh3VmOxyzo
         0zyA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=R7qTg4rvqZImy4oSXdOm12cIKEYmtASg3XAfcAnUDcM=;
        b=oUB44rHq4z0cILKECNvz+QgS3XfwgKXshXShpR7JKZEJkkXbys1/Oh7nBHmBBPS2su
         KzMkWr1mJHm2xdlsFH9UaoxqatWm5z/7cguthZdUnSEBXHiVSiLTCxnhC055B7L7vUFf
         ZN2ydnB9YFe3Md9AWwsQTwcnT1IMCSk35PtNEiOabkZWLS6IiqeSV4ilrZw+acVXMq32
         PiWBbEclmqcSzOLNMv27rNTaVZHN9sNC/RLKJ3o4/40+9ZanKnmfvrfNaGqrMClKszjC
         p8MAinqkL98m4a4AjIwHKJmfLAGPxlAxOU0oeKq6jLRSsLZ9tQKcnY1z9GwExeioRdcU
         R4yQ==
X-Gm-Message-State: ACrzQf38CgeV/hXGqLpO1Cc78p+M+a16zJL7+prcm49gbQEKP3xJHYzA
        /VkyVHzcyIKB5aSg5YIiV8hNmg==
X-Google-Smtp-Source: AMsMyM7sKoBkd+EySe6oS9G7uiWefGTirJ2MjX+Dl/2HH/8lz3/GH4/ihrDXbgHaNJ57gQFjt56hDg==
X-Received: by 2002:a17:90b:1a91:b0:20d:268b:eab with SMTP id ng17-20020a17090b1a9100b0020d268b0eabmr7681124pjb.177.1665782829503;
        Fri, 14 Oct 2022 14:27:09 -0700 (PDT)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id d15-20020a170903230f00b0016be834d54asm2144558plh.306.2022.10.14.14.27.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 14 Oct 2022 14:27:09 -0700 (PDT)
Date:   Fri, 14 Oct 2022 21:27:06 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Ricardo Koller <ricarkol@google.com>
Cc:     kvm@vger.kernel.org, kvmarm@lists.linux.dev,
        kvmarm@lists.cs.columbia.edu, andrew.jones@linux.dev,
        pbonzini@redhat.com, maz@kernel.org, alexandru.elisei@arm.com,
        eric.auger@redhat.com, oupton@google.com, reijiw@google.com,
        rananta@google.com, bgardon@google.com, dmatlack@google.com,
        axelrasmussen@google.com
Subject: Re: [PATCH v9 11/14] KVM: selftests: aarch64: Add userfaultfd tests
 into page_fault_test
Message-ID: <Y0nUKhuCJHUaQukj@google.com>
References: <20221011010628.1734342-1-ricarkol@google.com>
 <20221011010628.1734342-12-ricarkol@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221011010628.1734342-12-ricarkol@google.com>
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

On Tue, Oct 11, 2022, Ricardo Koller wrote:
>  /* Returns true to continue the test, and false if it should be skipped. */
> +static int uffd_generic_handler(int uffd_mode, int uffd,
> +		struct uffd_msg *msg, struct uffd_args *args,
> +		bool expect_write)

Align.

static int uffd_generic_handler(int uffd_mode, int uffd,
				struct uffd_msg *msg, struct uffd_args *args,
				bool expect_write)

> +static void setup_uffd(struct kvm_vm *vm, struct test_params *p,
> +		struct uffd_desc **pt_uffd, struct uffd_desc **data_uffd)

static void setup_uffd(struct kvm_vm *vm, struct test_params *p,
		       struct uffd_desc **pt_uffd, struct uffd_desc **data_uffd)

> +{
> +	struct test_desc *test = p->test_desc;
> +
> +	setup_uffd_args(vm_get_mem_region(vm, MEM_REGION_PT), &pt_args);
> +	setup_uffd_args(vm_get_mem_region(vm, MEM_REGION_TEST_DATA), &data_args);
> +
> +	*pt_uffd = NULL;
> +	if (test->uffd_pt_handler)
> +		*pt_uffd = uffd_setup_demand_paging(
> +				UFFDIO_REGISTER_MODE_MISSING, 0,
> +				pt_args.hva, pt_args.paging_size,
> +				test->uffd_pt_handler);
> +
> +	*data_uffd = NULL;
> +	if (test->uffd_data_handler)
> +		*data_uffd = uffd_setup_demand_paging(
> +				UFFDIO_REGISTER_MODE_MISSING, 0,
> +				data_args.hva, data_args.paging_size,
> +				test->uffd_data_handler);
> +}
> +
> +static void free_uffd(struct test_desc *test, struct uffd_desc *pt_uffd,
> +			struct uffd_desc *data_uffd)

static void free_uffd(struct test_desc *test, struct uffd_desc *pt_uffd,
		      struct uffd_desc *data_uffd)

> +static void reset_event_counts(void)
> +{
> +	memset(&events, 0, sizeof(events));
> +}
> +
>  /*
>   * This function either succeeds, skips the test (after setting test->skip), or
>   * fails with a TEST_FAIL that aborts all tests.
>   */
>  static void vcpu_run_loop(struct kvm_vm *vm, struct kvm_vcpu *vcpu,
> -			  struct test_desc *test)
> +		struct test_desc *test)

Spurious change, and it introduces bad alignment.

static void vcpu_run_loop(struct kvm_vm *vm, struct kvm_vcpu *vcpu,
			  struct test_desc *test)

>  {
>  	struct ucall uc;
>  
> @@ -453,6 +575,7 @@ static void run_test(enum vm_guest_mode mode, void *arg)
>  	struct test_desc *test = p->test_desc;
>  	struct kvm_vm *vm;
>  	struct kvm_vcpu *vcpu;
> +	struct uffd_desc *pt_uffd, *data_uffd;
>  
>  	print_test_banner(mode, p);
>  

