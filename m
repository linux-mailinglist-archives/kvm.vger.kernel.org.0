Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 330B14B1F8B
	for <lists+kvm@lfdr.de>; Fri, 11 Feb 2022 08:47:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347805AbiBKHro (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 11 Feb 2022 02:47:44 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:54100 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239483AbiBKHrm (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 11 Feb 2022 02:47:42 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 8011D1A4
        for <kvm@vger.kernel.org>; Thu, 10 Feb 2022 23:47:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1644565660;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=QaXOsf3u+r2ufwTZMOtosmcIvxlt4ig9a/CYgvHucqc=;
        b=NFFJ0xCOW9IRL9oC5n8fLak4aeBcpPv8DvsrPr58+QhHhbEimwxu4xjRwhzmbKEj0voaG5
        Leee7/HjiIFjrSsvtgNtkqDODiJJUTjPQecGLSEy0NhlM7GcHLnx6RicEePLcCLOKwVMN0
        x46Upec2aHfbL/8qCFLiFNXgRtLDXYQ=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-270-tSU6n4nZP1OIE7_ofWC6Zg-1; Fri, 11 Feb 2022 02:47:39 -0500
X-MC-Unique: tSU6n4nZP1OIE7_ofWC6Zg-1
Received: by mail-wr1-f72.google.com with SMTP id w26-20020adf8bda000000b001e33dbc525cso3506173wra.18
        for <kvm@vger.kernel.org>; Thu, 10 Feb 2022 23:47:39 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=QaXOsf3u+r2ufwTZMOtosmcIvxlt4ig9a/CYgvHucqc=;
        b=btW5vd58YKsWYAknvIeYeKKPTWDtPfxB1fDHUwkrlAUZavjIVRMIMi2Qy0+E2UNFZQ
         QMPs4JRRawuFHehkj4la/y3kApM0Ykru94FgyxjM/f4qMXza8yB9LWS3tFCWIV0v3lYI
         LSeIDi5MedrHKW5MJfZomEW/axtrmBNGLbZsC6bbCAeKiVSnpLKVg7fnAgFImK8if3l/
         WodbnIgOb8hc5puLaca/+gao0iOYUgtDq1wX9DPFo6Z87tAlIEt0dWsl4ICWvmAOgGkx
         1ETEk+nGOxtGWG0eP7ElWkF7pIewYgCYN44V88szVIgQrQfwqQFPR3H/zkP0S9nTYkwn
         hJrA==
X-Gm-Message-State: AOAM53380KntdkWFqxeUx/Vnl4gW3I+mR85umoOZR1BNO0FWxJFjaCBt
        QwOf34s85Fv3KxwLYE5huBvtJKMBEjG91EROFes45wHSGJDsr4qV+0qq7BfpqJP9WEej7qVq1yQ
        KvOBbcBPTVhUm
X-Received: by 2002:adf:e34c:: with SMTP id n12mr301659wrj.263.1644565657881;
        Thu, 10 Feb 2022 23:47:37 -0800 (PST)
X-Google-Smtp-Source: ABdhPJwb0I1hItxkBN1IQnQVTbVivOEeEbaNAyMkZ7Or/dR+FOtWTucNQTNvIMOywMDQxiN+C07W8A==
X-Received: by 2002:adf:e34c:: with SMTP id n12mr301651wrj.263.1644565657711;
        Thu, 10 Feb 2022 23:47:37 -0800 (PST)
Received: from gator (cst2-173-70.cust.vodafone.cz. [31.30.173.70])
        by smtp.gmail.com with ESMTPSA id y14sm22953663wrd.91.2022.02.10.23.47.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 10 Feb 2022 23:47:37 -0800 (PST)
Date:   Fri, 11 Feb 2022 08:47:35 +0100
From:   Andrew Jones <drjones@redhat.com>
To:     Zixuan Wang <zxwang42@gmail.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Paolo Bonzini <pbonzini@redhat.com>, thuth@redhat.com,
        Varad Gautam <varad.gautam@suse.com>,
        kvm list <kvm@vger.kernel.org>, kvmarm@lists.cs.columbia.edu
Subject: Re: [kvm-unit-tests PATCH 0/4] configure changes and rename
 --target-efi
Message-ID: <20220211074735.erqk2uh6m6ci4zh5@gator>
References: <20220210150943.1280146-1-alexandru.elisei@arm.com>
 <YgVKmjBnAjITQcm+@google.com>
 <YgVPPCTJG7UFRkhQ@monolith.localdoman>
 <CAEDJ5ZSR=rw_ALjBcLgeVz9H6TS67eWvZW2SvGTJV468WjgyKw@mail.gmail.com>
 <YgVpJDIfUVzVvFdx@google.com>
 <CAEDJ5ZRkuCbmPzZXz0x2XUXqjKoi+O+Uq_SNkNW_We2mSv4aRg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAEDJ5ZRkuCbmPzZXz0x2XUXqjKoi+O+Uq_SNkNW_We2mSv4aRg@mail.gmail.com>
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Feb 10, 2022 at 11:48:03AM -0800, Zixuan Wang wrote:
> On Thu, Feb 10, 2022 at 11:36 AM Sean Christopherson <seanjc@google.com> wrote:
> >
> > On Thu, Feb 10, 2022, Zixuan Wang wrote:
> > > On Thu, Feb 10, 2022 at 11:05 AM Alexandru Elisei
> > > <alexandru.elisei@arm.com> wrote:
> > > >
> > > > Hi,
> > > >
> > > > On Thu, Feb 10, 2022 at 05:25:46PM +0000, Sean Christopherson wrote:
> > > > > On Thu, Feb 10, 2022, Alexandru Elisei wrote:
> > > > > > I renamed --target-efi to --efi-payload in the last patch because I felt it
> > > > > > looked rather confusing to do ./configure --target=qemu --target-efi when
> > > > > > configuring the tests. If the rename is not acceptable, I can think of a
> > > > > > few other options:
> > > > >
> > > > > I find --target-efi to be odd irrespective of this new conflict.  A simple --efi
> > > > > seems like it would be sufficient.
> > > > >
> > > > > > 1. Rename --target to --vmm. That was actually the original name for the
> > > > > > option, but I changed it because I thought --target was more generic and
> > > > > > that --target=efi would be the way going forward to compile kvm-unit-tests
> > > > > > to run as an EFI payload. I realize now that separating the VMM from
> > > > > > compiling kvm-unit-tests to run as an EFI payload is better, as there can
> > > > > > be multiple VMMs that can run UEFI in a VM. Not many people use kvmtool as
> > > > > > a test runner, so I think the impact on users should be minimal.
> > > > >
> > > > > Again irrespective of --target-efi, I think --target for the VMM is a potentially
> > > > > confusing name.  Target Triplet[*] and --target have specific meaning for the
> > > > > compiler, usurping that for something similar but slightly different is odd.
> > > >
> > > > Wouldn't that mean that --target-efi is equally confusing? Do you have
> > > > suggestions for other names?
> > >
> > > How about --config-efi for configure, and CONFIG_EFI for source code?
> > > I thought about this name when I was developing the initial patch, and
> > > Varad also proposed similar names in his initial patch series [1]:
> > > --efi and CONFIG_EFI.
> >
> > I don't mind CONFIG_EFI for the source, that provides a nice hint that it's a
> > configure option and is familiar for kernel developers.  But for the actually
> > option, why require more typing?  I really don't see any benefit of --config-efi
> > over --efi.
> 
> I agree, --efi looks better than --target-efi or --config-efi.
>

Works for me.

Thanks,
drew 

