Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2787778F294
	for <lists+kvm@lfdr.de>; Thu, 31 Aug 2023 20:29:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345044AbjHaS32 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 31 Aug 2023 14:29:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41960 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230019AbjHaS31 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 31 Aug 2023 14:29:27 -0400
Received: from mail-pl1-x649.google.com (mail-pl1-x649.google.com [IPv6:2607:f8b0:4864:20::649])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C020EE43
        for <kvm@vger.kernel.org>; Thu, 31 Aug 2023 11:29:24 -0700 (PDT)
Received: by mail-pl1-x649.google.com with SMTP id d9443c01a7336-1bf707f526bso12759065ad.1
        for <kvm@vger.kernel.org>; Thu, 31 Aug 2023 11:29:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1693506564; x=1694111364; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=BAQ/pFsVHD1Aoomibgpxf2ZqL3aYZZ65V96hB69Tw9c=;
        b=fDxwxv2JRt9tSD2mwNu82F5veh8qKIzH4kHxxD85d62MrAMfuY0NGzRcJdp34SuaYW
         AFVJb7Hh/tHW8uzyes3YJyhOrC6JoiJc4jfvhMs050Eg4c79zIuVsbzY1LPk/mGn8xE4
         fggDMeALBIyCfly1WqwUm4vPj5ZFWm7faLOvsoiLtts05kcbSjMOOUmT6tOrDuI/jcCJ
         RZVfaNiqtEEeP38++akgIW7aWX9alVIeA0XcccNASlczwRwRfIA+4xrkL9yqMLOovtt3
         HtgB5cuyrmANwPBqCLzB5cpfwjdifPHGOtgMFRVA3EZTDgnb12m/Bh9MTQfvMAkjdYzi
         okHA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1693506564; x=1694111364;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=BAQ/pFsVHD1Aoomibgpxf2ZqL3aYZZ65V96hB69Tw9c=;
        b=AokSuplfq12WKgK0wG1rLm3ywOTCgp0SBws1DgEwGmnDAK3/4FhTVFNkCyQgre+ZKU
         s69wuzKcDUnWJgqy8jt22YQnh09qqfVdVfT7k6eEEcnNy4SFZDxgAbvlO/mBNjxEPIkW
         tqO+g7l/sGOZemh7zW2bm1hSPW29y4QbX45O3WDHk3GoRi7YaVNJM4gp9qHJi5WdgrlP
         +t8N5L2mt1zoDR9ZE25OQwBXFGX0xroHbtGpIfjwnXrP1uO70yD0OtdW3qvpjQJslUqL
         5QiLOtdU/9z00i2SM0VccnsKk7GB4puOEMXjvwliOULAciJVnrE7wHar6Cd1TQI25FCf
         S3tw==
X-Gm-Message-State: AOJu0YyoQJ+jMv2GYhFHYQHB9z93cGD9kqJEv+anXQ6iWT07TYiHg4vH
        f1JxsmEmuSuHQVrSppaPkwHb3QTsI9w=
X-Google-Smtp-Source: AGHT+IFL1xqBeQ6sRUjnp1DduAFvrSYTtqUwn+ivj8j9EbmZT0+UmpZ+UIr8YgioG1n3CHlx12vtk7JlsdI=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:902:e74f:b0:1bf:cc5:7b53 with SMTP id
 p15-20020a170902e74f00b001bf0cc57b53mr154232plf.1.1693506564284; Thu, 31 Aug
 2023 11:29:24 -0700 (PDT)
Date:   Thu, 31 Aug 2023 11:29:22 -0700
In-Reply-To: <20230829091233.GA72470@chaop.bj.intel.com>
Mime-Version: 1.0
References: <20230718234512.1690985-1-seanjc@google.com> <ZOjpIL0SFH+E3Dj4@google.com>
 <20230829091233.GA72470@chaop.bj.intel.com>
Message-ID: <ZPDcAuHcoRfU+yRX@google.com>
Subject: Re: [RFC PATCH v11 00/29]  KVM: guest_memfd() and per-page attributes
From:   Sean Christopherson <seanjc@google.com>
To:     Chao Peng <chao.p.peng@linux.intel.com>
Cc:     kvm@vger.kernel.org, Fuad Tabba <tabba@google.com>,
        Yu Zhang <yu.c.zhang@linux.intel.com>,
        Vishal Annapurve <vannapurve@google.com>,
        Ackerley Tng <ackerleytng@google.com>,
        Maciej Szmigiero <mail@maciej.szmigiero.name>,
        Vlastimil Babka <vbabka@suse.cz>,
        Quentin Perret <qperret@google.com>,
        Michael Roth <michael.roth@amd.com>,
        Wang <wei.w.wang@intel.com>,
        Liam Merwick <liam.merwick@oracle.com>,
        Isaku Yamahata <isaku.yamahata@gmail.com>,
        "Kirill A . Shutemov" <kirill.shutemov@linux.intel.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Jorg Rodel <jroedel@suse.de>,
        Vitaly Kuznetsov <vkuznets@redhat.com>
Content-Type: text/plain; charset="us-ascii"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Aug 29, 2023, Chao Peng wrote:
> On Fri, Aug 25, 2023 at 10:47:12AM -0700, Sean Christopherson wrote:
> > 
> > 
> > Filemap vs. xarray
> > ------------------
> > This is the main item that needs attention.  I don't want to merge guest_memfd()
> > without doing this comparison, as not using filemap means we don't need AS_UNMOVABLE.
> > Arguably we could merge a filemap implementation without AS_UNMOVABLE and just eat
> > the suboptimal behavior, but not waiting a little while longer to do everything we
> > can to get this right the first time seems ridiculous after we've been working on
> > this for literally years.
> > 
> > Paolo was going to work on an axarray implementation, but AFAIK he hasn't done
> > anything yet.  We (Google) don't have anyone available to work on an xarray
> > implementation for several weeks (at best), so if anyone has the bandwidth and
> > desire to take stab at an xarray implementation, please speak up.
> 
> I can do some experiments in the following weeks on the xarray
> direction. I'm not quite confident I understood all what Paolo
> originally wanted to do, so questions may have.

FYI, I jumped the gun, sounds like Paolo got far enough along to form a strong
opinion[*].

Thanks for volunteering though, much appreciated!

[*] https://lore.kernel.org/all/CABgObfay4FKV=foWLZzAWaC2kVHRnF1ib+6NC058QVZVFhGeyA@mail.gmail.com
