Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 62CC55EE267
	for <lists+kvm@lfdr.de>; Wed, 28 Sep 2022 18:59:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233644AbiI1Q7C (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 28 Sep 2022 12:59:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57374 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231419AbiI1Q7A (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 28 Sep 2022 12:59:00 -0400
Received: from mail-pj1-x102c.google.com (mail-pj1-x102c.google.com [IPv6:2607:f8b0:4864:20::102c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 95A487D1E5
        for <kvm@vger.kernel.org>; Wed, 28 Sep 2022 09:58:59 -0700 (PDT)
Received: by mail-pj1-x102c.google.com with SMTP id q35-20020a17090a752600b002038d8a68fbso3145663pjk.0
        for <kvm@vger.kernel.org>; Wed, 28 Sep 2022 09:58:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date;
        bh=JPHVsQZph796quobJWecE9d8WYuQzTyeUzZ9fJLJCt0=;
        b=YoST0dNL+tr2MxBQPBb3gEUaaq2rchEwRpYCm/C4/zvdm9UbKh4weE6f9Rse5smcva
         0ahnHpBHQGqD6xuD07bwTCdT6qGIDSf9F6/AboMMdLNCblGFmx69YPL/461ja3bispRg
         k153DDi1J/ci/zwEhY4ofIjbRC0HhlW960PgWUe/WeFDrYHoLQ39lc8uF/VM7e5pQVuz
         2eTDb0AMqf01PjFToZsmQF4Fj0BS16kv5rz2+m7xcKElBgh8RAV574fvfcPkJMbQVVgU
         43/eaF6HCiqUcc3OI8Dv6vd+rxicq1Qoydc+AH/IWaov28Ka3KoT6aBdmKLOjV3965OP
         xnjg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date;
        bh=JPHVsQZph796quobJWecE9d8WYuQzTyeUzZ9fJLJCt0=;
        b=VCFyFii8yRJb7JYq3rkCLiJBeONZ82mA1JuK4AUZVxkJwub79McVVjjWOnXFIlpzML
         haRoWZnbarrqtlXIPfa4iOfl/Y8uvVzmtvhjU//yYCN6XUHW/i/e+jG6R5spQEXwagEu
         f/dIZUFCNIc2avp7+RsVhNxS06tFn3CvAZfQL4pzkMejlMhq8KBsFCxoataMCha43fpx
         AjxFNwFN6pik8uRdCoLvxTucHTLAkh0AU7ACzX4CL8I03ROrESufRpNciAmMBJK0g173
         05tIOHGAfKD0nW+NrhJ7Ur0Sy41iNE9IB2N2GMcp4oYwkpaYlzZs696Te3h7e/0orD7m
         H4Fg==
X-Gm-Message-State: ACrzQf0jwP9mp+FkgliA4uBkI6cTUrJPqy01WkQu7lMhewKgCYV74UTv
        Dku6dcyeH1IBtTuveTCFvmQZ4A==
X-Google-Smtp-Source: AMsMyM6PrX/MsmRBqg1sXs0jHHhg5Yrxul40DjOGHB7X7ofNSd1KnKk+KnOzfR/QXB8u3pbAG0zRAQ==
X-Received: by 2002:a17:90a:4e8a:b0:203:9556:1b7d with SMTP id o10-20020a17090a4e8a00b0020395561b7dmr11605672pjh.0.1664384338687;
        Wed, 28 Sep 2022 09:58:58 -0700 (PDT)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id e8-20020a056a0000c800b005361f6a0573sm4218372pfj.44.2022.09.28.09.58.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 28 Sep 2022 09:58:58 -0700 (PDT)
Date:   Wed, 28 Sep 2022 16:58:53 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Ricardo Koller <ricarkol@google.com>
Cc:     kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu,
        andrew.jones@linux.dev, pbonzini@redhat.com, maz@kernel.org,
        alexandru.elisei@arm.com, eric.auger@redhat.com, oupton@google.com,
        reijiw@google.com, rananta@google.com, bgardon@google.com,
        dmatlack@google.com, axelrasmussen@google.com
Subject: Re: [PATCH v8 10/14] KVM: selftests: aarch64: Add
 aarch64/page_fault_test
Message-ID: <YzR9TRjVFi+P7UOp@google.com>
References: <20220922031857.2588688-1-ricarkol@google.com>
 <20220922031857.2588688-11-ricarkol@google.com>
 <Yyy4WjEmuSH1tSZb@google.com>
 <YzHfwmZqMQ9xXaNa@google.com>
 <YzNz36gZqrse9GzT@google.com>
 <YzPMaEPBtaXguJaT@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YzPMaEPBtaXguJaT@google.com>
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

On Tue, Sep 27, 2022, Ricardo Koller wrote:
> On Tue, Sep 27, 2022 at 10:06:23PM +0000, Sean Christopherson wrote:
> > On Mon, Sep 26, 2022, Ricardo Koller wrote:
> > > On Thu, Sep 22, 2022 at 07:32:42PM +0000, Sean Christopherson wrote:
> > > > On Thu, Sep 22, 2022, Ricardo Koller wrote:
> > > > > +	void *hva = (void *)region->region.userspace_addr;
> > > > > +	uint64_t paging_size = region->region.memory_size;
> > > > > +	int ret, fd = region->fd;
> > > > > +
> > > > > +	if (fd != -1) {
> > > > > +		ret = fallocate(fd, FALLOC_FL_PUNCH_HOLE | FALLOC_FL_KEEP_SIZE,
> > > > > +				0, paging_size);
> > > > > +		TEST_ASSERT(ret == 0, "fallocate failed, errno: %d\n", errno);
> > > > > +	} else {
> > > > > +		if (is_backing_src_hugetlb(region->backing_src_type))
> > > > > +			return false;
> > > > 
> > > > Why is hugetlb disallowed?  I thought anon hugetlb supports MADV_DONTNEED?
> > > > 
> > > 
> > > It fails with EINVAL (only tried on arm) for both the PAGE_SIZE and the huge
> > > page size. And note that the address is aligned as well.
> > > 
> > > madvise(0xffffb7c00000, 2097152, MADV_DONTNEED) = -1 EINVAL (Invalid argument)
> > > 	^^^^^^^^^^^^^^	^^^^^^^
> > > 	2M aligned	2M (hugepage size)
> > > 			
> > > madvise(0xffff9e800000, 4096, MADV_DONTNEED) = -1 EINVAL (Invalid argument)   
> > > 			^^^^
> > > 			PAGE_SIZE
> > 
> > I think this needs to be root caused before merging.  Unless I'm getting turned
> > around, MADV_DONTEED should work, i.e. there is a test bug lurking somewhere.
> 
> Turns out that the failure is documented. Found this in the madvise manpage:
> 
>   MADV_DONTNEED cannot be applied to locked pages, Huge TLB pages, or VM_PFNMAP pages.

The manpages are stale:

   c4b6cb884011 ("selftests/vm: add hugetlb madvise MADV_DONTNEED MADV_REMOVE test")
   90e7e7f5ef3f ("mm: enable MADV_DONTNEED for hugetlb mappings")

The tools/testing/selftests/vm/hugetlb-madvise.c selftest effectively tests what
is being done here, so _something_ is broken.
