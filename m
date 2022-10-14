Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5D3635FF548
	for <lists+kvm@lfdr.de>; Fri, 14 Oct 2022 23:23:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230014AbiJNVXy (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 14 Oct 2022 17:23:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55032 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230015AbiJNVXh (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 14 Oct 2022 17:23:37 -0400
Received: from mail-pl1-x635.google.com (mail-pl1-x635.google.com [IPv6:2607:f8b0:4864:20::635])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AAF761DCCE7
        for <kvm@vger.kernel.org>; Fri, 14 Oct 2022 14:23:35 -0700 (PDT)
Received: by mail-pl1-x635.google.com with SMTP id z20so5850164plb.10
        for <kvm@vger.kernel.org>; Fri, 14 Oct 2022 14:23:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=xCLcgM5p0Xi25bsK6RWh7QvQp7XU1CO69/w1Ar3c+II=;
        b=gmGiZE77o04w3Lo/ylaRSpsaJ6T0ylACDyfKIIQbAZfJj51AKsMwVt8b5o9OAJWtli
         xeXFhWam3d/geNCFfveD8OaOu0/uny3xfFLlm8HOVq+u3TlQhtZ6Gwn13Fs0xdsGHtet
         T8PknKGOZBLm8Y9bojwtyArKrCCV4obDDexbhMXkMz1fKY4EOEB70m1o6PnQcNfp1iXv
         ejURaySDblSheuAfo1aSFyStmfYzNbFZIIo0anrx7aisz0dZq8T4sFgLwBsXCrYIp7FP
         VtzarBoMc82CBTOOr+jGSyo171CJ+2BZBGMKPeCFYmoXUVatiHxa4jFlzod+LGMm2Euv
         n/Cw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=xCLcgM5p0Xi25bsK6RWh7QvQp7XU1CO69/w1Ar3c+II=;
        b=ZCoiMmdkAY97hMJuCoZWDkQn1qScmE9wq1MWmtxqekFM0Y6cPgX/bYi239IepsXyfE
         SKaemXwrsx1Kq9OfR85FVSeixXCpaJCbK8FUZVOoUf6QU1We9Jv/rd/7apEMBaiymM48
         4qSKVxVhQpOUBpYvCQw1chimasbEGgn7sQRXyNu/XY8rzTJ15Nix98eQhIdHBDQ5+rWj
         RLz4MUWRsMFVBgsCZDrS7UHZuUgpeIdtShLsjyRL7L1nbIbBhmHzptEMh3HOjnUS+2Z1
         ZWHFS0T/uVOYE0lXvY1SEYFq5ssWkTldCj68rJyMf579UDFs0l9RK9X8YNg1cpoM6U8u
         nGAg==
X-Gm-Message-State: ACrzQf0RiAhjuAhaXVXrxGDdAK6CQTLkluv3fRFT/sGoviI0PyL3uzFX
        3dTbofXhlUoC9jbh7Kah/2lvjQ==
X-Google-Smtp-Source: AMsMyM4T7f/zchI8yBfJsjb1QMLlCXvQLmbJzBWG/hENTAl0t/BseKUlwkTlh7t6m2TxyxfQCYJ0xQ==
X-Received: by 2002:a17:90a:ba90:b0:20d:3434:7f56 with SMTP id t16-20020a17090aba9000b0020d34347f56mr7960241pjr.105.1665782614370;
        Fri, 14 Oct 2022 14:23:34 -0700 (PDT)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id b10-20020a170902650a00b001752216ca51sm2161326plk.39.2022.10.14.14.23.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 14 Oct 2022 14:23:34 -0700 (PDT)
Date:   Fri, 14 Oct 2022 21:23:30 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Ricardo Koller <ricarkol@google.com>
Cc:     kvm@vger.kernel.org, kvmarm@lists.linux.dev,
        kvmarm@lists.cs.columbia.edu, andrew.jones@linux.dev,
        pbonzini@redhat.com, maz@kernel.org, alexandru.elisei@arm.com,
        eric.auger@redhat.com, oupton@google.com, reijiw@google.com,
        rananta@google.com, bgardon@google.com, dmatlack@google.com,
        axelrasmussen@google.com
Subject: Re: [PATCH v9 10/14] KVM: selftests: aarch64: Add
 aarch64/page_fault_test
Message-ID: <Y0nTUmsC7YGTQery@google.com>
References: <20221011010628.1734342-1-ricarkol@google.com>
 <20221011010628.1734342-11-ricarkol@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221011010628.1734342-11-ricarkol@google.com>
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
> +/* Returns true to continue the test, and false if it should be skipped. */
> +static bool punch_hole_in_backing_store(struct kvm_vm *vm,
> +					struct userspace_mem_region *region)
> +{
> +	void *hva = (void *)region->region.userspace_addr;
> +	uint64_t paging_size = region->region.memory_size;
> +	int ret, fd = region->fd;
> +
> +	if (fd != -1) {
> +		ret = fallocate(fd, FALLOC_FL_PUNCH_HOLE | FALLOC_FL_KEEP_SIZE,
> +				0, paging_size);
> +		TEST_ASSERT(ret == 0, "fallocate failed, errno: %d\n", errno);
> +	} else {
> +		ret = madvise(hva, paging_size, MADV_DONTNEED);
> +		TEST_ASSERT(ret == 0, "madvise failed, errno: %d\n", errno);
> +	}

Uber nit, no need to manually print the errno, TEST_ASSERT() does that automatically
and pretty prints the string too.  I know this because I keep forgetting myself :-).

> +/* Returns true to continue the test, and false if it should be skipped. */
> +static bool handle_cmd(struct kvm_vm *vm, int cmd)
> +{
> +	struct userspace_mem_region *data_region, *pt_region;
> +	bool continue_test = true;
> +
> +	data_region = vm_get_mem_region(vm, MEM_REGION_TEST_DATA);
> +	pt_region = vm_get_mem_region(vm, MEM_REGION_PT);
> +
> +	if (cmd == CMD_SKIP_TEST)
> +		continue_test = false;
> +
> +	if (cmd & CMD_HOLE_PT)
> +		continue_test = punch_hole_in_backing_store(vm, pt_region);
> +	if (cmd & CMD_HOLE_DATA)
> +		continue_test = punch_hole_in_backing_store(vm, data_region);
> +
> +	return continue_test;
> +}

...

> +static void setup_abort_handlers(struct kvm_vm *vm, struct kvm_vcpu *vcpu,
> +		struct test_desc *test)

Align params.

static void setup_abort_handlers(struct kvm_vm *vm, struct kvm_vcpu *vcpu,
				 struct test_desc *test)

> +static void for_each_test_and_guest_mode(
> +		void (*func)(enum vm_guest_mode m, void *a),

If you spin a new version, can you put together a patch or mini-series to add a
typedef for this function pointer?  Then this function doesn't need a funky wrap.
Or alternatively, as follow-up to avoid delaying this series even longer.

E.g.

static void for_each_test_and_guest_mode(guest_mode_test_t func,
					 enum vm_mem_backing_src_type src_type)

diff --git a/tools/testing/selftests/kvm/include/guest_modes.h b/tools/testing/selftests/kvm/include/guest_modes.h
index b691df33e64e..ee7c5c271eb2 100644
--- a/tools/testing/selftests/kvm/include/guest_modes.h
+++ b/tools/testing/selftests/kvm/include/guest_modes.h
@@ -15,7 +15,9 @@ extern struct guest_mode guest_modes[NUM_VM_MODES];
        guest_modes[mode] = (struct guest_mode){ supported, enabled }; \
 })
 
+typedef void (*guest_mode_test_t)(enum vm_guest_mode, void *);
+
 void guest_modes_append_default(void);
-void for_each_guest_mode(void (*func)(enum vm_guest_mode, void *), void *arg);
+void for_each_guest_mode(guest_mode_test_t func, void *arg);
 void guest_modes_help(void);
 void guest_modes_cmdline(const char *arg);



> +		enum vm_mem_backing_src_type src_type)
> +{
> +	struct test_desc *t;
> +
> +	for (t = &tests[0]; t->name; t++) {
> +		if (t->skip)
> +			continue;
> +
> +		struct test_params p = {
> +			.src_type = src_type,
> +			.test_desc = t,
> +		};
> +
> +		for_each_guest_mode(run_test, &p);
> +	}
> +}
> +
> +int main(int argc, char *argv[])
> +{
> +	enum vm_mem_backing_src_type src_type;
> +	int opt;
> +
> +	setbuf(stdout, NULL);
> +
> +	src_type = DEFAULT_VM_MEM_SRC;
> +
> +	while ((opt = getopt(argc, argv, "hm:s:")) != -1) {
> +		switch (opt) {
> +		case 'm':
> +			guest_modes_cmdline(optarg);
> +			break;
> +		case 's':
> +			src_type = parse_backing_src_type(optarg);
> +			break;
> +		case 'h':
> +		default:
> +			help(argv[0]);
> +			exit(0);
> +		}
> +	}
> +
> +	for_each_test_and_guest_mode(run_test, src_type);
> +	return 0;
> +}
> diff --git a/tools/testing/selftests/kvm/include/aarch64/processor.h b/tools/testing/selftests/kvm/include/aarch64/processor.h
> index c1ddca8db225..5f977528e09c 100644
> --- a/tools/testing/selftests/kvm/include/aarch64/processor.h
> +++ b/tools/testing/selftests/kvm/include/aarch64/processor.h
> @@ -105,11 +105,19 @@ enum {
>  #define ESR_EC_MASK		(ESR_EC_NUM - 1)
>  
>  #define ESR_EC_SVC64		0x15
> +#define ESR_EC_IABT		0x21
> +#define ESR_EC_DABT		0x25
>  #define ESR_EC_HW_BP_CURRENT	0x31
>  #define ESR_EC_SSTEP_CURRENT	0x33
>  #define ESR_EC_WP_CURRENT	0x35
>  #define ESR_EC_BRK_INS		0x3c
>  
> +/* Access flag */
> +#define PTE_AF			(1ULL << 10)
> +
> +/* Access flag update enable/disable */
> +#define TCR_EL1_HA		(1ULL << 39)
> +
>  void aarch64_get_supported_page_sizes(uint32_t ipa,
>  				      bool *ps4k, bool *ps16k, bool *ps64k);
>  
> -- 
> 2.38.0.rc1.362.ged0d419d3c-goog
> 
