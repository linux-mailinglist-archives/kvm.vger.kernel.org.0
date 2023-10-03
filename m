Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 51C657B69A3
	for <lists+kvm@lfdr.de>; Tue,  3 Oct 2023 14:58:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231266AbjJCM6e (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 3 Oct 2023 08:58:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34674 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229803AbjJCM6d (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 3 Oct 2023 08:58:33 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D1B90B4
        for <kvm@vger.kernel.org>; Tue,  3 Oct 2023 05:57:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1696337866;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=+18KoJo0hjBpxEBABbzWRmC0iKfSd2Bit05hdEDUubk=;
        b=TOirl3iJLdeNDoEyw/O5xa26o5YUOAy9YutKgib0ENN4ww95iQRx/zYy+5e/b4sEg7Qyaj
        gU70N93ItPvtUrLCc8EeROTfCTewWdPOwfav2TdJR1TytrYxHAqWm8N0UtPg+xF5Mc6hsP
        u2G641yPsaxgqdQVZJGYxe927Zp5o2Y=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-17-T2sufox6M3m8RwT3MpbgJQ-1; Tue, 03 Oct 2023 08:57:35 -0400
X-MC-Unique: T2sufox6M3m8RwT3MpbgJQ-1
Received: by mail-wm1-f71.google.com with SMTP id 5b1f17b1804b1-40570ccc497so6975225e9.3
        for <kvm@vger.kernel.org>; Tue, 03 Oct 2023 05:57:34 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1696337854; x=1696942654;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=+18KoJo0hjBpxEBABbzWRmC0iKfSd2Bit05hdEDUubk=;
        b=G9NYF/599I46ggs4c0oO1MBL+dF4w67RVyx3WgyxI3XrA4Tw6Fbr7VPLVbKCFtH4wC
         XhQXDWXLVcZBbY9mWGu4DH7rdhek6B1Eh/EUuB+2xAHIAdg2N8bFG6OTGUyb35/5tXR6
         7zcQFedMJWjA3JNODk3wBu8Cdcb+N6uuegJ6BKjdHmnXRMCdLq8onYWB8B9ZuN45NDg9
         Auy1zh0Ntj7PMm/UTicSMukCYYKmjnn51nVOZ7dbCW8V/8KLfqnF+UKdhCUzF5gSmwI0
         61Uce+w46jJR79xGh3WPiru6NDMumPESLSKl8YIH/VqgYArnA0ZJLoSiiJZpAmodP6JF
         hyzw==
X-Gm-Message-State: AOJu0YzRenZ6TMv9uFzrarchct+YsNIEZUM/R5TKXIrlSlQe49qsm9dB
        Om9j6SirEcOBSCegKx+Uu2T48IIDhHPQVlF9+8gCXiRJuCo6FiMdo91B25oTEOmcVGwnVUx9RlT
        iZBfVabxgVK55
X-Received: by 2002:a7b:cc15:0:b0:405:499a:7fc1 with SMTP id f21-20020a7bcc15000000b00405499a7fc1mr13431007wmh.40.1696337854001;
        Tue, 03 Oct 2023 05:57:34 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IE5ZdnN4CZ73I2itg2r6+8Pdjhyyad5Rh8jVgUE2uyTdUKD0glxVY1en8riGy6n5jL88ivWyA==
X-Received: by 2002:a7b:cc15:0:b0:405:499a:7fc1 with SMTP id f21-20020a7bcc15000000b00405499a7fc1mr13430986wmh.40.1696337853583;
        Tue, 03 Oct 2023 05:57:33 -0700 (PDT)
Received: from redhat.com ([2.52.132.27])
        by smtp.gmail.com with ESMTPSA id z20-20020a7bc7d4000000b004064e3b94afsm9428262wmk.4.2023.10.03.05.57.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 03 Oct 2023 05:57:32 -0700 (PDT)
Date:   Tue, 3 Oct 2023 08:57:27 -0400
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Zhao Liu <zhao1.liu@linux.intel.com>
Cc:     Philippe =?iso-8859-1?Q?Mathieu-Daud=E9?= <philmd@linaro.org>,
        Eduardo Habkost <eduardo@habkost.net>,
        Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
        Yanan Wang <wangyanan55@huawei.com>,
        Richard Henderson <richard.henderson@linaro.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Marcelo Tosatti <mtosatti@redhat.com>, qemu-devel@nongnu.org,
        kvm@vger.kernel.org, Zhenyu Wang <zhenyu.z.wang@intel.com>,
        Xiaoyao Li <xiaoyao.li@intel.com>,
        Babu Moger <babu.moger@amd.com>,
        Zhao Liu <zhao1.liu@intel.com>,
        Yongwei Ma <yongwei.ma@intel.com>
Subject: Re: [PATCH v4 21/21] i386: Add new property to control L2 cache topo
 in CPUID.04H
Message-ID: <20231003085516-mutt-send-email-mst@kernel.org>
References: <20230914072159.1177582-1-zhao1.liu@linux.intel.com>
 <20230914072159.1177582-22-zhao1.liu@linux.intel.com>
 <75ea5477-ca1b-7016-273c-abd6c36f4be4@linaro.org>
 <ZQQNddiCky/cImAz@liuzhao-OptiPlex-7080>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <ZQQNddiCky/cImAz@liuzhao-OptiPlex-7080>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Sep 15, 2023 at 03:53:25PM +0800, Zhao Liu wrote:
> Hi Philippe,
> 
> On Thu, Sep 14, 2023 at 09:41:30AM +0200, Philippe Mathieu-Daudé wrote:
> > Date: Thu, 14 Sep 2023 09:41:30 +0200
> > From: Philippe Mathieu-Daudé <philmd@linaro.org>
> > Subject: Re: [PATCH v4 21/21] i386: Add new property to control L2 cache
> >  topo in CPUID.04H
> > 
> > On 14/9/23 09:21, Zhao Liu wrote:
> > > From: Zhao Liu <zhao1.liu@intel.com>
> > > 
> > > The property x-l2-cache-topo will be used to change the L2 cache
> > > topology in CPUID.04H.
> > > 
> > > Now it allows user to set the L2 cache is shared in core level or
> > > cluster level.
> > > 
> > > If user passes "-cpu x-l2-cache-topo=[core|cluster]" then older L2 cache
> > > topology will be overrode by the new topology setting.
> > > 
> > > Here we expose to user "cluster" instead of "module", to be consistent
> > > with "cluster-id" naming.
> > > 
> > > Since CPUID.04H is used by intel CPUs, this property is available on
> > > intel CPUs as for now.
> > > 
> > > When necessary, it can be extended to CPUID.8000001DH for AMD CPUs.
> > > 
> > > (Tested the cache topology in CPUID[0x04] leaf with "x-l2-cache-topo=[
> > > core|cluster]", and tested the live migration between the QEMUs w/ &
> > > w/o this patch series.)
> > > 
> > > Signed-off-by: Zhao Liu <zhao1.liu@intel.com>
> > > Tested-by: Yongwei Ma <yongwei.ma@intel.com>
> > > ---
> > > Changes since v3:
> > >   * Add description about test for live migration compatibility. (Babu)
> > > 
> > > Changes since v1:
> > >   * Rename MODULE branch to CPU_TOPO_LEVEL_MODULE to match the previous
> > >     renaming changes.
> > > ---
> > >   target/i386/cpu.c | 34 +++++++++++++++++++++++++++++++++-
> > >   target/i386/cpu.h |  2 ++
> > >   2 files changed, 35 insertions(+), 1 deletion(-)
> > 
> > 
> > > @@ -8079,6 +8110,7 @@ static Property x86_cpu_properties[] = {
> > >                        false),
> > >       DEFINE_PROP_BOOL("x-intel-pt-auto-level", X86CPU, intel_pt_auto_level,
> > >                        true),
> > > +    DEFINE_PROP_STRING("x-l2-cache-topo", X86CPU, l2_cache_topo_level),
> > 
> > We use the 'x-' prefix for unstable features, is it the case here?
> 
> I thought that if we can have a more general CLI way to define cache
> topology in the future, then this option can be removed.
> 
> I'm not sure if this option could be treated as unstable, what do you
> think?
> 
> 
> Thanks,
> Zhao

Then, please work on this new generic thing.
What we don't want is people relying on unstable options.

> > 
> > >       DEFINE_PROP_END_OF_LIST()
> > >   };
> > 

