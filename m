Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2D7AC6BDD77
	for <lists+kvm@lfdr.de>; Fri, 17 Mar 2023 01:18:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229534AbjCQASt (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 16 Mar 2023 20:18:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58256 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229494AbjCQASs (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 16 Mar 2023 20:18:48 -0400
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B558A6B322
        for <kvm@vger.kernel.org>; Thu, 16 Mar 2023 17:18:43 -0700 (PDT)
Received: by mail-yb1-xb4a.google.com with SMTP id g5-20020a25a485000000b009419f64f6afso3540506ybi.2
        for <kvm@vger.kernel.org>; Thu, 16 Mar 2023 17:18:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1679012323;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=PY77Rzcg4DWFnbejM3BKQQs/9thRJmaRph59FVbPZ+E=;
        b=kTuzpzhmAxc3vOkHOiu5pkiHBngjEXKsni5CASpSsbgZaYRjKPYLj0tBtA8GdwAnEe
         vC7QZjHDzuHdyfYiaRDH6Js6zSnrMbhoMunX54yF6O6dfopyAgzRp8Ohpz8lMprG5wWk
         BFv9HPD8A0MryVOBhrXlNAATxZeDE3MvcF6gF+SFG4BUM0tEE1ZHYWCbt+50OPq+QGuk
         +5anY1Zk8qmcyQO3HcMgO8FGzdkqqtCb+vTOsH5cv85j4csjm8/WzkunmyvXj3q74whi
         U/y7UW02Ta20wElu14YuKvjR0eg//0HJjF6WUyaDevdaarRJR9M4qOK4MmWvmcZSjFHa
         JrFA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679012323;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=PY77Rzcg4DWFnbejM3BKQQs/9thRJmaRph59FVbPZ+E=;
        b=0uwm5kk9jxKI2I+ptPZqPb2bMK65HyLmdaUV89CW3fOQTetnkYsEyU2fTAwdvNze00
         uXcMoRkUGnV9zz6VhU21vM8y+OEYN9C1Lv68krTBy1uka9sSydmhLGG7FSnBQE/ThuCw
         DDto4hH9p2svpuJVfQaEADpJLECb4uYfVKQcurwCNQFo6EGNfo1JEy7pjv72ie6llFfH
         U285Fd8z/iYfwMSZEGNQ4lnzWtN/mKP3YumWbVULjRfSBbVCbQrJpN9mBMmspwRV4Y/U
         EQvRq1xLEc2qadUi45AdWgEDUIxHv/PrWnl7ANPDsIuLpmGtJ7yR1nCs4MKnPt5jM05G
         SqNg==
X-Gm-Message-State: AO0yUKUmxcvHvVMSf91z8Dorc88Fs7pyHUZEISHgYB/9qFQ1RY4hjB0N
        +89b0ifK3aXJnWBvku8Yopo+lb5R/+M=
X-Google-Smtp-Source: AK7set+yejSTUmS5wVMiE/M73+saIrm0DTV5k5jeq04iIp4ZNvSX7g5sbnDDJRkG2hqYC7hu3jM4XvbihS8=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6902:151:b0:afa:d8b5:8e82 with SMTP id
 p17-20020a056902015100b00afad8b58e82mr27161358ybh.6.1679012322869; Thu, 16
 Mar 2023 17:18:42 -0700 (PDT)
Date:   Fri, 17 Mar 2023 00:18:41 +0000
In-Reply-To: <a026b6ddf62843129193842d80edd182@huawei.com>
Mime-Version: 1.0
References: <20230316154554.1237-1-shameerali.kolothum.thodi@huawei.com>
 <ZBNLnp7c1JvDsmHm@google.com> <6b9e8589281c4d2bae46eba36f77afe7@huawei.com>
 <ZBN0pFN/nF8G3fWl@google.com> <a026b6ddf62843129193842d80edd182@huawei.com>
Message-ID: <ZBOx4b1yUpnxu/I1@google.com>
Subject: Re: [PATCH] KVM: Add the missing stub function for kvm_dirty_ring_check_request()
From:   Sean Christopherson <seanjc@google.com>
To:     Shameerali Kolothum Thodi <shameerali.kolothum.thodi@huawei.com>
Cc:     "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "gshan@redhat.com" <gshan@redhat.com>,
        "maz@kernel.org" <maz@kernel.org>
Content-Type: text/plain; charset="us-ascii"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Mar 16, 2023, Shameerali Kolothum Thodi wrote:
> > From: Sean Christopherson [mailto:seanjc@google.com]
> > On Thu, Mar 16, 2023, Shameerali Kolothum Thodi wrote:
> > > > From: Sean Christopherson [mailto:seanjc@google.com] On Thu, Mar 16,
> > > > 2023, Shameer Kolothum wrote:
> > > > > The stub for !CONFIG_HAVE_KVM_DIRTY_RING case is missing.
> > > >
> > > > No stub is needed.  kvm_dirty_ring_check_request() isn't called from
> > > > common code, and should not (and isn't unless I'm missing something)
> > > > be called from arch code unless CONFIG_HAVE_KVM_DIRTY_RING=y.
> > > >
> > > > x86 and arm64 are the only users, and they both select
> > > > HAVE_KVM_DIRTY_RING unconditionally when KVM is enabled.
> > >
> > > Yes, it is at present not called from anywhere other than x86 and arm64.
> > > But I still think since it is a common helper, better to have a stub.
> > 
> > Why?  It buys us nothing other than dead code, and even worse it could let
> > a bug that would otherwise be caught during build time escape to run time.
> 
> Agree, it buys nothing now:) It just came up while I was playing with a custom
> build without HAVE_KVM_DIRTY_RING. Since all other functions there has a stub
> just thought it would make it easier for future common usage. We could very well
> leave it till that comes up as well.

Stubs are typically only added when they are strictly necessary.  Providing a stub
would make things "easier" in the sense that it could theoretically avoid a build
error, but as above, in many cases we _want_ build errors when new code behaves
in a way that diverges from what's expected/established.
