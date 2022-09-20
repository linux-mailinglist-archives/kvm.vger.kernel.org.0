Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8BE745BE7D1
	for <lists+kvm@lfdr.de>; Tue, 20 Sep 2022 16:00:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230172AbiITOAG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 20 Sep 2022 10:00:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56300 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230307AbiITOAB (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 20 Sep 2022 10:00:01 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E2B91E08F
        for <kvm@vger.kernel.org>; Tue, 20 Sep 2022 07:00:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1663682399;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=/dJ1RkA4+wpdunwUxvxfjJfpRsPVL8KliFUpOWYWLYI=;
        b=Suz8y8moFaEDkOzSpex+982xSf5dExyEDHwn+EZIUnL2AQ/kCotgXBLBRNA375rgh+jAAK
        cg3FCJPtPFXhWILEPa/6kWKivUQON49CoEH8GXIfIlip5p5bGuT3wtSz4Hkt9QzPZILCgn
        zkWPeHkz1QjklCYKvz870c1c+5K4qDU=
Received: from mail-qk1-f197.google.com (mail-qk1-f197.google.com
 [209.85.222.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-592-3e-jy4_RPQCebCq4oCJ8lg-1; Tue, 20 Sep 2022 09:59:58 -0400
X-MC-Unique: 3e-jy4_RPQCebCq4oCJ8lg-1
Received: by mail-qk1-f197.google.com with SMTP id k2-20020a05620a414200b006ceec443c8bso1992069qko.14
        for <kvm@vger.kernel.org>; Tue, 20 Sep 2022 06:59:58 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date;
        bh=/dJ1RkA4+wpdunwUxvxfjJfpRsPVL8KliFUpOWYWLYI=;
        b=z0Px3uF/by0Jwkq+2RHne382vSqjw2/SnWibmVbZ22ra1wEn3B1brl1qko/9+/fI0x
         8/TgLs4OXrdOIlaI/i/EMkT81/OXlrzRhTGFEZeEXl78t9396mnEarKrGtZ6k71hAsP2
         Cu01gCWOEBH6SSeAXbs3YHyvNtDD1k1Lz1r/HbmgZfbZlOb5Yvs6eneq1/6gwiNNzCwV
         sTBPMwQJljlGyReWNoV0Q1cP9LT2bw6DIr/FTO/2lCr+GruIGP+6NHsGhzqTOkmRJUdn
         ky+f358gaeEDCv1Rog78FKKiuIQ7CVSwWEB/fJhe99xYHNzTJOvg1Y9UyV+Hj+nwWYix
         gEpw==
X-Gm-Message-State: ACrzQf0qNMjxDfMF4apm3mvi0SldQteBHYk8eU8zn6VixY3euYoBtMC4
        ur/4vCAQKp8feoLMeJ3/847pjlwqoME4VBb8J/EFfB8zoCaEMRx1mPCbn3z1ivsosEQ1DaL+5Xn
        TzmByj4nye7WD
X-Received: by 2002:ac8:588c:0:b0:35b:b351:f470 with SMTP id t12-20020ac8588c000000b0035bb351f470mr19759485qta.42.1663682398174;
        Tue, 20 Sep 2022 06:59:58 -0700 (PDT)
X-Google-Smtp-Source: AMsMyM4egJn61ykqKpdQpxGx75VbGWe44zXl2b3l1RIQcKOJIhbCCzaCsIPzjxQQpuilO9BStm1FIQ==
X-Received: by 2002:ac8:588c:0:b0:35b:b351:f470 with SMTP id t12-20020ac8588c000000b0035bb351f470mr19759468qta.42.1663682397977;
        Tue, 20 Sep 2022 06:59:57 -0700 (PDT)
Received: from xz-m1.local (bras-base-aurron9127w-grc-46-70-31-27-79.dsl.bell.ca. [70.31.27.79])
        by smtp.gmail.com with ESMTPSA id l16-20020ac87250000000b0035bb6298526sm26371qtp.17.2022.09.20.06.59.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 20 Sep 2022 06:59:57 -0700 (PDT)
Date:   Tue, 20 Sep 2022 09:59:56 -0400
From:   Peter Xu <peterx@redhat.com>
To:     Chenyi Qiang <chenyi.qiang@intel.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        Richard Henderson <richard.henderson@linaro.org>,
        Eduardo Habkost <eduardo@habkost.net>,
        Xiaoyao Li <xiaoyao.li@intel.com>, qemu-devel@nongnu.org,
        kvm@vger.kernel.org
Subject: Re: [PATCH v6 2/2] i386: Add notify VM exit support
Message-ID: <YynHXI+Vtrf9J/Ae@xz-m1.local>
References: <20220915092839.5518-1-chenyi.qiang@intel.com>
 <20220915092839.5518-3-chenyi.qiang@intel.com>
 <YyTxL7kstA20tB5a@xz-m1.local>
 <5beb9f1c-a419-94f7-a1b9-4aeb281baa41@intel.com>
 <YyiQeD9QmJ9/eS9F@xz-m1.local>
 <ee855874-bb8b-3f43-cffe-425700b26918@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <ee855874-bb8b-3f43-cffe-425700b26918@intel.com>
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Sep 20, 2022 at 01:55:20PM +0800, Chenyi Qiang wrote:
> > > @@ -5213,6 +5213,7 @@ int kvm_arch_handle_exit(CPUState *cs, struct kvm_run
> > > *run)
> > >           break;
> > >       case KVM_EXIT_NOTIFY:
> > >           ret = 0;
> > > +        warn_report_once("KVM: notify window was exceeded in guest");
> > 
> > Is there more informative way to dump this?  If it's 99% that the guest was
> > doing something weird and needs attention, maybe worthwhile to point that
> > out directly to the admin?
> > 
> 
> Do you mean to use other method to dump the info? i.e. printing a message is
> not so clear. Or the output message ("KVM: notify window was exceeded in
> guest") is not obvious and we need other wording.

I meant something like:

  KVM received notify exit.  It means there can be possible misbehaves in
  the guest, please have a look.

Or something similar.  What I'm worried is the admin may not understand
what's "notify window" and that message got simply ignored.

Though I am not even sure whether that's accurate in the wordings.

> 
> > >           if (run->notify.flags & KVM_NOTIFY_CONTEXT_INVALID) {
> > >               warn_report("KVM: invalid context due to notify vmexit");
> > >               if (has_triple_fault_event) {
> > 
> > Adding a warning looks good to me, with that (or in any better form of
> > wording):
> > 
> If no objection, I'll follow Xiaoyao's suggestion to form the wording like:

No objection here.  Thanks.

-- 
Peter Xu

