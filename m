Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0DB605ED008
	for <lists+kvm@lfdr.de>; Wed, 28 Sep 2022 00:06:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230183AbiI0WGc (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 27 Sep 2022 18:06:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49146 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229940AbiI0WG3 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 27 Sep 2022 18:06:29 -0400
Received: from mail-pj1-x1036.google.com (mail-pj1-x1036.google.com [IPv6:2607:f8b0:4864:20::1036])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 50C37E21CA
        for <kvm@vger.kernel.org>; Tue, 27 Sep 2022 15:06:28 -0700 (PDT)
Received: by mail-pj1-x1036.google.com with SMTP id bu5-20020a17090aee4500b00202e9ca2182so2332041pjb.0
        for <kvm@vger.kernel.org>; Tue, 27 Sep 2022 15:06:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date;
        bh=fauuNPDstfZWj568q3xiy+B2bGT91D8Yz04rERb5Agk=;
        b=bb6TqY4OGRLC3s4+XD5mAJ2HiSFhDxmZt3FTJEx4kw9/5yoX9bEwOhntdKQ202LEiB
         VP/RlohlCkOlNazikDGLqx+Kl3wBF5XhJI5sUt5VYhqRM2FXYT+oKfAmLVRM97ZRSWwm
         uq41IM9DNjiK38osgt3A7lvLEe04aA5+H1VU0igiLZKAt4dIDKlcT2HcMNBIAdgyGE/v
         uRiVDmSp0SFjcjxpnROFgl0MB4/Rgl49lnLUCs3MUVRpqpOXrVtVi18Q6GqcDHWDiOIP
         z5ePynT9lJKuhVMOrmRsSIlz95m0FrftDHNkyVgUICXo18CLg0plcPXDX5yTtTMNbJUN
         b0QA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date;
        bh=fauuNPDstfZWj568q3xiy+B2bGT91D8Yz04rERb5Agk=;
        b=F9HgEBcNxu9fGfZ/xR+0T1phXhqR6RQ/F4FrOGwRKICOvYh9v6mNYfRR0dRSMRYlgX
         Cjn/e/oTa8OKFu5w1vAKPESBbXdcvKM8fHfvBx1fxdrYjcHYSOWKuIhYvyqKNzg2bfz3
         IFq3ySJVrOXLDALH0Hk2meR0raP43kwRvHd/03F5s1+xgegieqbndfmcMG3v9ZaRF0Er
         kLIiZKvURcTK0J3eEDuUPn+O/4vTotbEHWECwKYWrfOCxBwDIr0887oPehQb9CTdSovB
         aWHg2DSjNO+iAqkK44y+nPLkM5U4nU9kab8C+sIJUvqPNE3KZPpZAprDMLSr7sSGT/fr
         ub4g==
X-Gm-Message-State: ACrzQf0O/+yf+aSxrg2ZuD5cp8AK5CUuEmwL1MZKEOFBujfktroqjLeA
        bkPBnhZBLNEZkwPbKvFxw7vHcg==
X-Google-Smtp-Source: AMsMyM7axbyNIr4UEZ3eDvOk36cBFXytSk86ZlNroaL1fCDvwa8InsjXbITt4AIhy8bIIM3OVNR3MA==
X-Received: by 2002:a17:90a:650a:b0:203:a3a9:6b14 with SMTP id i10-20020a17090a650a00b00203a3a96b14mr6784620pjj.198.1664316387694;
        Tue, 27 Sep 2022 15:06:27 -0700 (PDT)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id g10-20020a17090a708a00b002007b60e288sm8834070pjk.23.2022.09.27.15.06.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 27 Sep 2022 15:06:27 -0700 (PDT)
Date:   Tue, 27 Sep 2022 22:06:23 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Ricardo Koller <ricarkol@google.com>
Cc:     kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu,
        andrew.jones@linux.dev, pbonzini@redhat.com, maz@kernel.org,
        alexandru.elisei@arm.com, eric.auger@redhat.com, oupton@google.com,
        reijiw@google.com, rananta@google.com, bgardon@google.com,
        dmatlack@google.com, axelrasmussen@google.com
Subject: Re: [PATCH v8 10/14] KVM: selftests: aarch64: Add
 aarch64/page_fault_test
Message-ID: <YzNz36gZqrse9GzT@google.com>
References: <20220922031857.2588688-1-ricarkol@google.com>
 <20220922031857.2588688-11-ricarkol@google.com>
 <Yyy4WjEmuSH1tSZb@google.com>
 <YzHfwmZqMQ9xXaNa@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YzHfwmZqMQ9xXaNa@google.com>
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

On Mon, Sep 26, 2022, Ricardo Koller wrote:
> On Thu, Sep 22, 2022 at 07:32:42PM +0000, Sean Christopherson wrote:
> > On Thu, Sep 22, 2022, Ricardo Koller wrote:
> > > +	void *hva = (void *)region->region.userspace_addr;
> > > +	uint64_t paging_size = region->region.memory_size;
> > > +	int ret, fd = region->fd;
> > > +
> > > +	if (fd != -1) {
> > > +		ret = fallocate(fd, FALLOC_FL_PUNCH_HOLE | FALLOC_FL_KEEP_SIZE,
> > > +				0, paging_size);
> > > +		TEST_ASSERT(ret == 0, "fallocate failed, errno: %d\n", errno);
> > > +	} else {
> > > +		if (is_backing_src_hugetlb(region->backing_src_type))
> > > +			return false;
> > 
> > Why is hugetlb disallowed?  I thought anon hugetlb supports MADV_DONTNEED?
> > 
> 
> It fails with EINVAL (only tried on arm) for both the PAGE_SIZE and the huge
> page size. And note that the address is aligned as well.
> 
> madvise(0xffffb7c00000, 2097152, MADV_DONTNEED) = -1 EINVAL (Invalid argument)
> 	^^^^^^^^^^^^^^	^^^^^^^
> 	2M aligned	2M (hugepage size)
> 			
> madvise(0xffff9e800000, 4096, MADV_DONTNEED) = -1 EINVAL (Invalid argument)   
> 			^^^^
> 			PAGE_SIZE

I think this needs to be root caused before merging.  Unless I'm getting turned
around, MADV_DONTEED should work, i.e. there is a test bug lurking somewhere.
