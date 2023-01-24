Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5A843679E66
	for <lists+kvm@lfdr.de>; Tue, 24 Jan 2023 17:17:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233544AbjAXQR5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 24 Jan 2023 11:17:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51286 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232896AbjAXQRz (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 24 Jan 2023 11:17:55 -0500
Received: from mail-pj1-x1033.google.com (mail-pj1-x1033.google.com [IPv6:2607:f8b0:4864:20::1033])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 596EC558C
        for <kvm@vger.kernel.org>; Tue, 24 Jan 2023 08:17:54 -0800 (PST)
Received: by mail-pj1-x1033.google.com with SMTP id nn18-20020a17090b38d200b0022bfb584987so890150pjb.2
        for <kvm@vger.kernel.org>; Tue, 24 Jan 2023 08:17:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=K4gUZ8QoPMsgmVIH22hnGP5ly+yceMbFGnzKyjd0wdY=;
        b=UPp4JufSwtRNp94ONl0EC5nVMDyjAWSpwPgAbGkByDhx7r76dLXrdK0dQ/NGJgTyYy
         4+gkDBE0A+5vVppVUkX2ll2vSZZ+zQQBhbnuQCeK5Zay5OWKvKIG80gKKrhlAextTHHX
         jHtyuiTOjVPNNdLn845YcIbkIPp/NZMqMEcflWogAU5rGTAcycx3ffDsEhBXf+6TPtYr
         mXi5MQotYa5/GTRAbX54CxxFuZzc6Zz4NqIo9ZVxaxmehr/Omwam2ZbRZU0f9X22rTle
         z1W3M8paOpBXYay59HMe3u0g0X94tWF3TmcYkUUt5fMt6Vg9opxWw3d+fg+6ZP/ELFRW
         9E8Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=K4gUZ8QoPMsgmVIH22hnGP5ly+yceMbFGnzKyjd0wdY=;
        b=RzprOEzDstHpAual7cmQoBUzRLQjkbm6UtRAxIbyTC/BF+o8Kw6HhhHiNYSLYgFZMl
         6+6uIPUim6fgt++fjtsSWguDSUXf/vumsOza9C7F3lSn8WWcd5H9zK2o5jNk8spEmJrs
         6LpVLIGmOtDmtPybFDeDeXf0CsvHo0XLSxONdfYzbOb1ghl4pPcE9oRhvRbdFUuLXpiM
         1bsDqZ9u0HBLdTrdp+j5lLXGTYy15Vv9sppudS9zgeet9gu40xGYlhpYQwz2ALv+Fn9K
         wwirvAWQ2TWc7rc1MLkNL2hoxFwcmseH7OhDFnmkNu7s4WuIg1KKVNkXTq7Md4aLQpCU
         koGA==
X-Gm-Message-State: AO0yUKWiR24PNfVmR5a4ZuhQe1lYqiHo5dUYpPMzPfxYAeLZ18zrgWtD
        taeyJ3v6kEIT5dDQDoEvaW+S1A==
X-Google-Smtp-Source: AK7set8FFTNIfErrcpZvHzozOWX3Xx1vcflIUxA+YhAImZ7s/xPIH9xo1Ps0QCaPnRHW+42pHVm8IQ==
X-Received: by 2002:a05:6a20:9d90:b0:b8:e33c:f160 with SMTP id mu16-20020a056a209d9000b000b8e33cf160mr302472pzb.0.1674577073692;
        Tue, 24 Jan 2023 08:17:53 -0800 (PST)
Received: from google.com (220.181.82.34.bc.googleusercontent.com. [34.82.181.220])
        by smtp.gmail.com with ESMTPSA id x15-20020a62860f000000b0056b4c5dde61sm1846386pfd.98.2023.01.24.08.17.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 24 Jan 2023 08:17:53 -0800 (PST)
Date:   Tue, 24 Jan 2023 08:17:49 -0800
From:   Ricardo Koller <ricarkol@google.com>
To:     Oliver Upton <oliver.upton@linux.dev>
Cc:     kvm@vger.kernel.org, kvmarm@lists.linux.dev,
        andrew.jones@linux.dev, pbonzini@redhat.com, maz@kernel.org,
        alexandru.elisei@arm.com, eric.auger@redhat.com,
        yuzenghui@huawei.com
Subject: Re: [PATCH 1/4] KVM: selftests: aarch64: Relax userfaultfd read vs.
 write checks
Message-ID: <Y9AErXchOZFuKL05@google.com>
References: <20230110022432.330151-1-ricarkol@google.com>
 <20230110022432.330151-2-ricarkol@google.com>
 <Y88TLcuetXMSYyfD@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y88TLcuetXMSYyfD@google.com>
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

On Mon, Jan 23, 2023 at 11:07:25PM +0000, Oliver Upton wrote:
> On Tue, Jan 10, 2023 at 02:24:29AM +0000, Ricardo Koller wrote:
> > Only Stage1 Page table walks (S1PTW) writing a PTE on an unmapped page
> > should result in a userfaultfd write. However, the userfaultfd tests in
> > page_fault_test wrongly assert that any S1PTW is a PTE write.
> > 
> > Fix this by relaxing the read vs. write checks in all userfaultfd handlers.
> > Note that this is also an attempt to focus less on KVM (and userfaultfd)
> > behavior, and more on architectural behavior. Also note that after commit
> > "KVM: arm64: Fix S1PTW handling on RO memslots" the userfaultfd fault
> > (S1PTW with AF on an unmaped PTE page) is actually a read: the translation
> > fault that comes before the permission fault.
> 
> I certainly agree that we cannot make assertions about read v. write
> when registering uffd in 'missing' mode. We probably need another test
> to assert that we get write faults for hardware AF updates when using
> uffd in write protect mode.

I can do that. Only question, do you prefer having them in this series
with fixes, or another one?

> 
> --
> Thanks,
> Oliver
