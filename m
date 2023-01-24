Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F0F7C679E61
	for <lists+kvm@lfdr.de>; Tue, 24 Jan 2023 17:16:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233843AbjAXQQi (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 24 Jan 2023 11:16:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49698 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232855AbjAXQQg (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 24 Jan 2023 11:16:36 -0500
Received: from mail-pj1-x1036.google.com (mail-pj1-x1036.google.com [IPv6:2607:f8b0:4864:20::1036])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 21AA2474D2
        for <kvm@vger.kernel.org>; Tue, 24 Jan 2023 08:16:36 -0800 (PST)
Received: by mail-pj1-x1036.google.com with SMTP id e10-20020a17090a630a00b0022bedd66e6dso2523003pjj.1
        for <kvm@vger.kernel.org>; Tue, 24 Jan 2023 08:16:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=OHafq/bnQqe8SrboMo9hHNpvzyiZJrZ0d/xhlpndPV0=;
        b=kUoFIx412QWnZID/hc50OfhcOoG1T6YgdOyyfP4tJlMecl1LkuOqAsHA+EWW1rAyje
         abZUSy8nk8oVy6oh+8ZkQGR/szqVZoWxWMJyQC6YktTHMf6b+6Kwqwp8rDXd6t4UtI73
         Yp8jCLSaI/OS1UCuMN5oi9p07L74QEtSrbkkYTAfN1twohmcWMWWVI8iXwOXeImnBbWC
         xJKGsO7NgNMNsGRqMQjEYtp4GiVl0L0h4IeSugzm1C7sH6dlnx7pNlT0f5d4ff9T1UCO
         YPPHQlefWgnxlwQTcLW4S/NRC4cnJ22LSwLuMIQ6U072sxgxEfiAjHfmFZDXfdHLarE9
         lqmA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=OHafq/bnQqe8SrboMo9hHNpvzyiZJrZ0d/xhlpndPV0=;
        b=Vz+f+oK1h5UiXhbSOLTexlMa3MhXtwYhkRT4FJVGesQJ5cvgU0zz94tudTKFh0Z5Uu
         zGAADSua4cZC8m5ln3nmCtwgI2KiCSJYJBaB7DW/uOP4N+e12tefrvZSBuULsIIgwepe
         PlTFYnE9C4IZXr6dnV8wonL8aH2bzdJslAMDZHD+dW2mTWexl2xWta12ftnMB+3FEPL1
         XuRw51T7B1TwZStYe9xdN7e90ivuIRVHNtG43GGd4znHujlsAwlisFmdXNEkG6Sk54DN
         cVygcjiYfwgbl/Ai8gCpVHrcQ+3E4pV9L5ugbsbbw+gm1ICuYnyKCkAT0drYFGbljoy8
         3dbA==
X-Gm-Message-State: AO0yUKV2BxS8p9TRESnDeHoqYjHsYMJvMBTnl6iU4cFd5C0BFZanp8MM
        93TltqcsQrSlRBhTnHsBV/HwHg==
X-Google-Smtp-Source: AK7set9/iAkFLt0+U8DRsBB0q9v3QqYTp1hzk/gVBo4wD77XsBCDOT/mY5FIlZ3E8l1LkfuFd1afLw==
X-Received: by 2002:a05:6a21:329b:b0:b8:c3c0:e7f7 with SMTP id yt27-20020a056a21329b00b000b8c3c0e7f7mr293075pzb.1.1674576995440;
        Tue, 24 Jan 2023 08:16:35 -0800 (PST)
Received: from google.com (220.181.82.34.bc.googleusercontent.com. [34.82.181.220])
        by smtp.gmail.com with ESMTPSA id b192-20020a621bc9000000b005817fa83bcesm1765014pfb.76.2023.01.24.08.16.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 24 Jan 2023 08:16:34 -0800 (PST)
Date:   Tue, 24 Jan 2023 08:16:31 -0800
From:   Ricardo Koller <ricarkol@google.com>
To:     Oliver Upton <oliver.upton@linux.dev>
Cc:     kvm@vger.kernel.org, kvmarm@lists.linux.dev,
        andrew.jones@linux.dev, pbonzini@redhat.com, maz@kernel.org,
        alexandru.elisei@arm.com, eric.auger@redhat.com,
        yuzenghui@huawei.com
Subject: Re: [PATCH 0/4] KVM: selftests: aarch64: page_fault_test S1PTW
 related fixes
Message-ID: <Y9AEX1bOyJ2omlub@google.com>
References: <20230110022432.330151-1-ricarkol@google.com>
 <Y88bRSisoRAML0M6@google.com>
 <Y88bl/+lqrUCVKEf@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y88bl/+lqrUCVKEf@google.com>
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

On Mon, Jan 23, 2023 at 11:43:19PM +0000, Oliver Upton wrote:
> On Mon, Jan 23, 2023 at 11:41:57PM +0000, Oliver Upton wrote:
> > On Tue, Jan 10, 2023 at 02:24:28AM +0000, Ricardo Koller wrote:
> > > Commit "KVM: arm64: Fix S1PTW handling on RO memslots" changed the way
> > > S1PTW faults were handled by KVM.
> > 
> > I understand that this commit wasn't in Linus' tree at the time you sent
> > these patches, could you please attribute it as:
> > 
> >   commit 406504c7b040 ("KVM: arm64: Fix S1PTW handling on RO memslots")
> > 
> > in v2?
> 
> Sorry, I was a bit terse. What I mean is to update all of the commit
> messages to reflect the suggestion.

Sounds good, will do. I was betting on having a v2 by then (should have
mentioned it in the cover letter).

> 
> --
> Thanks,
> Oliver
