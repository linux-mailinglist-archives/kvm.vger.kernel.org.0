Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8D9D65E6BC0
	for <lists+kvm@lfdr.de>; Thu, 22 Sep 2022 21:32:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231519AbiIVTcv (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 22 Sep 2022 15:32:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50810 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231641AbiIVTct (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 22 Sep 2022 15:32:49 -0400
Received: from mail-pj1-x102e.google.com (mail-pj1-x102e.google.com [IPv6:2607:f8b0:4864:20::102e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 45E5E1080A0
        for <kvm@vger.kernel.org>; Thu, 22 Sep 2022 12:32:47 -0700 (PDT)
Received: by mail-pj1-x102e.google.com with SMTP id q9-20020a17090a178900b0020265d92ae3so3449830pja.5
        for <kvm@vger.kernel.org>; Thu, 22 Sep 2022 12:32:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date;
        bh=Ny4mS6pSDyL84H1BdG99sfUYk9g3T27xf8u3RbpkR3g=;
        b=ew8sDwy+EkU8W7ZAio8iLRqNCKXMaSBkLgJi0QS4iv3I14D1Mw/Q4iitHB92m+HF4A
         33oEJIfBRydLjz9JNuf1axbwtLHhS8r8ZbP3DhUX7Y570jsP0XVN+bKhqSMTZnq3O7hQ
         R4wVJOv4o0HUTE/xMCQ9hdDMsfc/sWLPuvCPNg5s3Ia72spYvozxWOFbFIN0ra+hDK/v
         xzi2hsDPz1FlBp87VIdCo93fphkP/od4Knzia3WU1sDMsUfu2tP0P5kMZCw/P69sVjGe
         UvaCwOnXCCSBOPR8f0DJxgIyCHA3+rb9va8Px+Xzx4KuotM32lhTMzfKXSESqpukjG+W
         guZw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date;
        bh=Ny4mS6pSDyL84H1BdG99sfUYk9g3T27xf8u3RbpkR3g=;
        b=VNDkdOoGFcQCVrQmW2SuzbuByqORE+MFMd/pHds4urY/pQX03Mk0BiPeceSNW8PgzW
         t2p3ih32zO4kKMb4bWt0M2GX1IsCOk2A7lYHwyHcGqulAJ6pCH1grqeBXb1J/MhgGz1Z
         FIKNzt54xpGVpt8fXP0xiu5jR+N8QpmDzznf4CFmaGkrO7mlrCQvFRkcT7XIpsmZQ/0E
         zkEQ+2oSQFEuS95hPx2LxdLloI5wkpzJJb4bP+tjTXbp/Bi4g3MuE7SjSqMPw2l56fN1
         GiOpU+DOlKFtoJwmX2DojDd5xCD2bcXlgtfsejZAXLaoqy5CBYlJai8JXJqoxMfvSUhB
         tvJQ==
X-Gm-Message-State: ACrzQf0ryzGo1a9EM5+e8ak0XMjgoYAONXF/yOBlwB1U19V8+tRqSxCs
        et8m7PD3f4j132iq4At1J4P2KYz33S2g+A==
X-Google-Smtp-Source: AMsMyM56UY+azR04/Q7tdxr2gQHDeSWmzGZg2J4abiFuofIPx2Zvmd0WSJChG1Ko2HRLwnzZ77A3AQ==
X-Received: by 2002:a17:903:32cf:b0:178:3d49:45b0 with SMTP id i15-20020a17090332cf00b001783d4945b0mr4732611plr.5.1663875167015;
        Thu, 22 Sep 2022 12:32:47 -0700 (PDT)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id s8-20020a170902ea0800b00179b6d0f90esm1877037plg.159.2022.09.22.12.32.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 22 Sep 2022 12:32:46 -0700 (PDT)
Date:   Thu, 22 Sep 2022 19:32:42 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Ricardo Koller <ricarkol@google.com>
Cc:     kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu,
        andrew.jones@linux.dev, pbonzini@redhat.com, maz@kernel.org,
        alexandru.elisei@arm.com, eric.auger@redhat.com, oupton@google.com,
        reijiw@google.com, rananta@google.com, bgardon@google.com,
        dmatlack@google.com, axelrasmussen@google.com
Subject: Re: [PATCH v8 10/14] KVM: selftests: aarch64: Add
 aarch64/page_fault_test
Message-ID: <Yyy4WjEmuSH1tSZb@google.com>
References: <20220922031857.2588688-1-ricarkol@google.com>
 <20220922031857.2588688-11-ricarkol@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220922031857.2588688-11-ricarkol@google.com>
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

On Thu, Sep 22, 2022, Ricardo Koller wrote:
> +/* Returns true to continue the test, and false if it should be skipped. */
> +static bool punch_hole_in_memslot(struct kvm_vm *vm,

This is a very misleading name, and IMO is flat out wrong.  The helper isn't
punching a hole in the memslot, it's punching a hole in the backing store, and
those are two very different things.  Encountering a hole in a _memslot_ yields
emualted MMIO semantics, not CoW zero page semantics.

Ideally, if we can come up with a not awful name, I'd also prefer to avoid "punch
hole" in the function name.  I can't think of a better alternative, so it's not
the end of the world if we're stuck with e.g punch_hole_in_backing_store(), but I
think the "punch_hole" name will be confusing for readers that are unfamiliar with
PUNCH_HOLE, especially for anonymous memory as "punching a hole" in anonymous
memory is more likely to be interpreted as "munmap()".

> +				  struct userspace_mem_region *region)
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
> +		if (is_backing_src_hugetlb(region->backing_src_type))
> +			return false;

Why is hugetlb disallowed?  I thought anon hugetlb supports MADV_DONTNEED?

> +
> +		ret = madvise(hva, paging_size, MADV_DONTNEED);
> +		TEST_ASSERT(ret == 0, "madvise failed, errno: %d\n", errno);
> +	}
> +
> +	return true;
> +}

...

> +	/*
> +	 * Accessing a hole in the data memslot (punched with fallocate or

s/memslot/backing store

> +	 * madvise) shouldn't fault (more sanity checks).


Naming aside, please provide more detail as to why this is the correct KVM
behavior.  This is quite subtle and relies on gory implementation details that a
lot of KVM developers will be unaware of.

Specifically, from an accessibility perspective, PUNCH_HOLE doesn't actually create
a hole in the file.  The "hole" can still be read and written; the "expect '0'"
checks are correct specifically because those are the semantics of PUNCH_HOLE.

In other words, it's not just that the accesses shouldn't fault, reads _must_
return zeros and writes _must_ re-populate the page.

Compare that with e.g. ftruncate() that makes the size of the file smaller, in
which case an access should result in KVM exiting to userspace with -EFAULT.

> +	 */
> +	TEST_ACCESS(guest_read64, no_af, CMD_HOLE_DATA),
> +	TEST_ACCESS(guest_cas, no_af, CMD_HOLE_DATA),
> +	TEST_ACCESS(guest_ld_preidx, no_af, CMD_HOLE_DATA),
> +	TEST_ACCESS(guest_write64, no_af, CMD_HOLE_DATA),
> +	TEST_ACCESS(guest_st_preidx, no_af, CMD_HOLE_DATA),
> +	TEST_ACCESS(guest_at, no_af, CMD_HOLE_DATA),
> +	TEST_ACCESS(guest_dc_zva, no_af, CMD_HOLE_DATA),
> +
> +	{ 0 }
> +};
