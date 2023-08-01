Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C2CCC76A57E
	for <lists+kvm@lfdr.de>; Tue,  1 Aug 2023 02:23:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229590AbjHAAXK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 31 Jul 2023 20:23:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37612 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229486AbjHAAXJ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 31 Jul 2023 20:23:09 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E710B1BEC
        for <kvm@vger.kernel.org>; Mon, 31 Jul 2023 17:22:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1690849312;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=1JqVW3nKS6ih7lr1bT/HdEeWmAfLdL43H1rrm50D/ao=;
        b=AeAW4m9tHosIISHXrBGK2SCT8g+AgQBijP31nAhazAUV5K2NLCGu/nehszJWc/SoQpGmhT
        qNeFEbEUDpg67aiMCYxbHAnKE00ZU4gf3zm4lt+UOE2MgfzQdE8msHjMIMV3yGLKtq8eBc
        U2VXBnM71CJOfwRz3kfs8iwMoRoG9WY=
Received: from mail-qk1-f200.google.com (mail-qk1-f200.google.com
 [209.85.222.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-308-V1bk4oSvNp-9AJ19a2t3yQ-1; Mon, 31 Jul 2023 20:21:50 -0400
X-MC-Unique: V1bk4oSvNp-9AJ19a2t3yQ-1
Received: by mail-qk1-f200.google.com with SMTP id af79cd13be357-76ca3baaec8so44142085a.1
        for <kvm@vger.kernel.org>; Mon, 31 Jul 2023 17:21:50 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1690849310; x=1691454110;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=1JqVW3nKS6ih7lr1bT/HdEeWmAfLdL43H1rrm50D/ao=;
        b=EZEA5qkivW9pnoOji1HzNpvdUK40XtpbU9gH4Ou+WV8icY1H3NVanWnSgY2cCOFAZ9
         kReKRtQYctzn2j9Xs0DRDQxdTS4XfXBEhLrDdWH79b2alFROs9b6RyOBtP7E/8LnYBET
         NnO/fhSRsWabJut+px8RG8Ddq062kkrtEiymrl9TL7x+sq89WaUfpVRmjzbeo8Fow3Eb
         FIOaJ1ZmOKcAR3QDJnRUnfwfSxuZNzvgK/I2Q5xeXG0wTIPtKc2lZ2lUKdqgrybZM7ot
         +nyPHydMm88wVRuDJa4ovypPzsWdykIW0y+sIopZRxRHzyi1LKFnrUgZnhKCnAHJTwze
         Re/Q==
X-Gm-Message-State: ABy/qLZtWXFeBYAXlxzbQTvkAV2p8lj+nsdG1kKCp+TOloAYki/qrDvX
        XB8xs0Eiz2290m4RYhqFsslZY9Hke8CzLo6f/X5a0dY6HOfKBqwFTbXllxHMnRcFVGMS/LQwLXs
        KI7cb4AxXRcjY
X-Received: by 2002:a05:620a:24d0:b0:767:f2e7:47c0 with SMTP id m16-20020a05620a24d000b00767f2e747c0mr11472998qkn.1.1690849309944;
        Mon, 31 Jul 2023 17:21:49 -0700 (PDT)
X-Google-Smtp-Source: APBJJlFkB2xrFKwX29nFK0UU7HJMjyCVFqFuyruoxfJ4KYdJp/fi0G+JCL4IHqQH3QsZS+VEOSY1iQ==
X-Received: by 2002:a05:620a:24d0:b0:767:f2e7:47c0 with SMTP id m16-20020a05620a24d000b00767f2e747c0mr11472985qkn.1.1690849309634;
        Mon, 31 Jul 2023 17:21:49 -0700 (PDT)
Received: from x1n (cpe5c7695f3aee0-cm5c7695f3aede.cpe.net.cable.rogers.com. [99.254.144.39])
        by smtp.gmail.com with ESMTPSA id h26-20020a05620a10ba00b00767ba88f0c9sm3725129qkk.7.2023.07.31.17.21.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 31 Jul 2023 17:21:49 -0700 (PDT)
Date:   Mon, 31 Jul 2023 20:21:46 -0400
From:   Peter Xu <peterx@redhat.com>
To:     "Michael S. Tsirkin" <mst@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Xiaoyao Li <xiaoyao.li@intel.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        David Hildenbrand <david@redhat.com>,
        Igor Mammedov <imammedo@redhat.com>,
        Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
        Richard Henderson <richard.henderson@linaro.org>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        Markus Armbruster <armbru@redhat.com>,
        Eric Blake <eblake@redhat.com>,
        Daniel =?utf-8?B?UC4gQmVycmFuZ8Op?= <berrange@redhat.com>,
        Philippe =?utf-8?Q?Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
        Chao Peng <chao.p.peng@linux.intel.com>,
        Michael Roth <michael.roth@amd.com>, isaku.yamahata@gmail.com,
        qemu-devel@nongnu.org, kvm@vger.kernel.org
Subject: Re: [RFC PATCH 04/19] memory: Introduce
 memory_region_can_be_private()
Message-ID: <ZMhQGi6MuHfyvNS9@x1n>
References: <20230731162201.271114-1-xiaoyao.li@intel.com>
 <20230731162201.271114-5-xiaoyao.li@intel.com>
 <ZMgma0cRi/lkTKSz@x1n>
 <ZMgo3mGKtoQ7QsB+@google.com>
 <20230731173607-mutt-send-email-mst@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20230731173607-mutt-send-email-mst@kernel.org>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Jul 31, 2023 at 05:36:37PM -0400, Michael S. Tsirkin wrote:
> On Mon, Jul 31, 2023 at 02:34:22PM -0700, Sean Christopherson wrote:
> > On Mon, Jul 31, 2023, Peter Xu wrote:
> > > On Mon, Jul 31, 2023 at 12:21:46PM -0400, Xiaoyao Li wrote:
> > > > +bool memory_region_can_be_private(MemoryRegion *mr)
> > > > +{
> > > > +    return mr->ram_block && mr->ram_block->gmem_fd >= 0;
> > > > +}
> > > 
> > > This is not really MAP_PRIVATE, am I right?  If so, is there still chance
> > > we rename it (it seems to be also in the kernel proposal all across..)?
> > 
> > Yes and yes.
> > 
> > > I worry it can be very confusing in the future against MAP_PRIVATE /
> > > MAP_SHARED otherwise.
> > 
> > Heh, it's already quite confusing at times.  I'm definitely open to naming that
> > doesn't collide with MAP_{PRIVATE,SHARED}, especially if someone can come with a
> > naming scheme that includes a succinct way to describe memory that is shared
> > between two or more VMs, but is accessible to _only_ those VMs.
> 
> Standard solution is a technology specific prefix.
> protect_shared, encrypt_shared etc.

Agreed, a prefix could definitely help (if nothing better comes at last..).
If e.g. "encrypted" too long to be applied everywhere in var names and
functions, maybe it can also be "enc_{private|shared}".

Thanks,

-- 
Peter Xu

