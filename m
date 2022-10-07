Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E58AC5F80C5
	for <lists+kvm@lfdr.de>; Sat,  8 Oct 2022 00:24:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229731AbiJGWY1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 7 Oct 2022 18:24:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50778 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229511AbiJGWYZ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 7 Oct 2022 18:24:25 -0400
Received: from mail-pj1-x1034.google.com (mail-pj1-x1034.google.com [IPv6:2607:f8b0:4864:20::1034])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C036DD01A6
        for <kvm@vger.kernel.org>; Fri,  7 Oct 2022 15:24:24 -0700 (PDT)
Received: by mail-pj1-x1034.google.com with SMTP id i7-20020a17090a65c700b0020ad9666a86so8443770pjs.0
        for <kvm@vger.kernel.org>; Fri, 07 Oct 2022 15:24:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=59hgvhDRUt+M/dRVt6uQ4wb9apA1vJ61fWUCmRW4UQg=;
        b=kk8GCHtPq4IDS7mfxvqqrER92tF3MJ3BVt7lbTuxLUYee+PH8s2n9OXW2unfZwvr32
         AROfGNR9P7ERogLiPzMfSfSQ8pZlCQTuVUD3Ohl4Wpi7LZ7xddw6kl7Uv7zLL4MmJFp8
         oEgcxzVBNtfyiuwhtjxNmPXNx22oauJgpdGWiVqRiWYhbpaNkrdD+cN0SEp6PItSlqI8
         kQdzyJ6tlE7Q2oCU/zbTEeWga4Ha9gyvea1/N5M1HLX5u0FWuPcx+sYwKFu/1J+gyxJF
         VTyI2ERWVzBbdZJn2BEsJAe8LGFmEcKM/AC9oj1CAr2cCw7BhhbvJS6wYjnbn6Z7XRCt
         BN2w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=59hgvhDRUt+M/dRVt6uQ4wb9apA1vJ61fWUCmRW4UQg=;
        b=YubO2/YZo9ny+QX/g5b1gXkQBCBgaNsiMJyie8MAfWmexiOISqEo0IiHCUwyp1G1RN
         xEZtNXNIkPrOR6GO7sG/2ZT+RCRcES+ddnAQQsPAB0iapYMFo2iHLpsaQF9s+DCEX6cH
         wwne+ew/IxusWwDMhdr7hKN1rM3s0hLb0GUx1KKOIBM6PwpTCO9QVNBi27bdthr+RWno
         QcdNAMGrXfw5fT4PrQxWSEOKNoOg6tP4j/nHL7Q/GU+M/LJujeljVX218y43+TACKSje
         OtAqsHVuyLf1F1m/RFod38wMc1O5d+z2V/UidNErnlk0nTnrUX+Ut8scxBIpjkYEsPKY
         Ti+w==
X-Gm-Message-State: ACrzQf26x2idE0lr5tBQ0/Cw8a+muv63EDlut49hUFpqyX9gk0GpqRPz
        dLqoWztJa1U0keeNdkokQbzxlg==
X-Google-Smtp-Source: AMsMyM5OcWlPXpzUE9rIkQy7vPreWxX9NMzfb2GrQyyPA8JBelRQWQnn4Ihtlj2pBBLDrYOrTh2ZnA==
X-Received: by 2002:a17:90a:9381:b0:20a:79b7:766a with SMTP id q1-20020a17090a938100b0020a79b7766amr19001607pjo.33.1665181464133;
        Fri, 07 Oct 2022 15:24:24 -0700 (PDT)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id y22-20020a17090a6c9600b0020ad46d277bsm5082551pjj.42.2022.10.07.15.24.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 07 Oct 2022 15:24:23 -0700 (PDT)
Date:   Fri, 7 Oct 2022 22:24:19 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Aaron Lewis <aaronlewis@google.com>
Cc:     kvm@vger.kernel.org, pbonzini@redhat.com, jmattson@google.com
Subject: Re: [PATCH v4 5/5] selftests: kvm/x86: Test the flags in MSR
 filtering and MSR exiting
Message-ID: <Y0CnE4iqo60j2wdT@google.com>
References: <20220921151525.904162-1-aaronlewis@google.com>
 <20220921151525.904162-6-aaronlewis@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220921151525.904162-6-aaronlewis@google.com>
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

On Wed, Sep 21, 2022, Aaron Lewis wrote:
> +#define test_user_exit_msr_ioctl(vm, cmd, arg, flag, valid_mask)	\

There's nothing specific to userspace MSR exiting in this macro.  To keep the
name short, and to potentially allow moving it to common code in the future, how
about test_ioctl_flags()?

> +({									\
> +	int r = __vm_ioctl(vm, cmd, arg);				\
> +									\
> +	if (flag & valid_mask)						\
> +		TEST_ASSERT(!r, __KVM_IOCTL_ERROR(#cmd, r));		\
> +	else								\
> +		TEST_ASSERT(r == -1 && errno == EINVAL,			\
> +			    "Wanted EINVAL for %s with flag = 0x%llx, got  rc: %i errno: %i (%s)", \
> +			    #cmd, flag, r, errno,  strerror(errno));	\
> +})
> +
> +static void run_user_space_msr_flag_test(struct kvm_vm *vm)
> +{
> +	struct kvm_enable_cap cap = { .cap = KVM_CAP_X86_USER_SPACE_MSR };
> +	int nflags = sizeof(cap.args[0]) * BITS_PER_BYTE;
> +	int rc;
> +	int i;

These declarations can go on a single line.

> +
> +	rc = kvm_check_cap(KVM_CAP_X86_USER_SPACE_MSR);
> +	TEST_ASSERT(rc, "KVM_CAP_X86_USER_SPACE_MSR is available");
> +
> +	for (i = 0; i < nflags; i++) {
> +		cap.args[0] = BIT_ULL(i);
> +		test_user_exit_msr_ioctl(vm, KVM_ENABLE_CAP, &cap,
> +			   BIT_ULL(i), KVM_MSR_EXIT_REASON_VALID_MASK);

Align params.  With a shorter macro name, that's easy to do without creating
massively long lines.

And pass in the actual flags, e.g. cap.args[0] here, so that it's slightly more
obvious what is being tested, and to minimize the risk of mixups.

E.g.

		test_ioctl_flags(vm, KVM_ENABLE_CAP, &cap, cap.args[0],
				 KVM_MSR_EXIT_REASON_VALID_MASK);

> +	}
> +}
> +
> +static void run_msr_filter_flag_test(struct kvm_vm *vm)
> +{
> +	u64 deny_bits = 0;
> +	struct kvm_msr_filter filter = {
> +		.flags = KVM_MSR_FILTER_DEFAULT_ALLOW,
> +		.ranges = {
> +			{
> +				.flags = KVM_MSR_FILTER_READ,
> +				.nmsrs = 1,
> +				.base = 0,
> +				.bitmap = (uint8_t *)&deny_bits,
> +			},
> +		},
> +	};
> +	int nflags;
> +	int rc;
> +	int i;

	int nflags, rc, i;

> +
> +	rc = kvm_check_cap(KVM_CAP_X86_MSR_FILTER);
> +	TEST_ASSERT(rc, "KVM_CAP_X86_MSR_FILTER is available");
> +
> +	nflags = sizeof(filter.flags) * BITS_PER_BYTE;
> +	for (i = 0; i < nflags; i++) {
> +		filter.flags = BIT_ULL(i);
> +		test_user_exit_msr_ioctl(vm, KVM_X86_SET_MSR_FILTER, &filter,
> +			   BIT_ULL(i), KVM_MSR_FILTER_VALID_MASK);

		test_ioctl_flags(vm, KVM_X86_SET_MSR_FILTER, &filter,
				 filter.flags, KVM_MSR_FILTER_VALID_MASK);

> +	}
> +
> +	filter.flags = KVM_MSR_FILTER_DEFAULT_ALLOW;
> +	nflags = sizeof(filter.ranges[0].flags) * BITS_PER_BYTE;
> +	for (i = 0; i < nflags; i++) {
> +		filter.ranges[0].flags = BIT_ULL(i);
> +		test_user_exit_msr_ioctl(vm, KVM_X86_SET_MSR_FILTER, &filter,
> +			   BIT_ULL(i), KVM_MSR_FILTER_RANGE_VALID_MASK);

		test_ioctl_flags(vm, KVM_X86_SET_MSR_FILTER, &filter,
				 filter.ranges[0].flags,
				 KVM_MSR_FILTER_RANGE_VALID_MASK);

> +	}
> +}

Nits aside, nice test!

