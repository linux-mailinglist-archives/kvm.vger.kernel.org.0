Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AFF6B76A2F8
	for <lists+kvm@lfdr.de>; Mon, 31 Jul 2023 23:36:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230080AbjGaVgK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 31 Jul 2023 17:36:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49368 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230322AbjGaVgD (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 31 Jul 2023 17:36:03 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7CC441BF7
        for <kvm@vger.kernel.org>; Mon, 31 Jul 2023 14:34:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1690839237;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=7RaNBI6rmSgDQ/p+0u44WYWfipJQLQNF2UOLsc5T27k=;
        b=Qg/pZW+4weUQe6EzGHwlOeK4SsqyBnXFDDgxm4dNMylb5sdXNfiVNZNC2OBhYWTZ5vWPwA
        5MmDG873nvUszKVoYrWDCu7oIRL4RuklxkUFspFKs2VIQfNA8vmpxC3i01CKphumEDyYdh
        UZvH0Ziu3OulfOqynK1ZG/AvV75n580=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-102-qmMYuBdjO3-k1d1WxvtAbg-1; Mon, 31 Jul 2023 17:33:56 -0400
X-MC-Unique: qmMYuBdjO3-k1d1WxvtAbg-1
Received: by mail-wr1-f72.google.com with SMTP id ffacd0b85a97d-3176ace3f58so2468581f8f.0
        for <kvm@vger.kernel.org>; Mon, 31 Jul 2023 14:33:56 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1690839235; x=1691444035;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=7RaNBI6rmSgDQ/p+0u44WYWfipJQLQNF2UOLsc5T27k=;
        b=da6BOGChrqPU2rZO+r2Mrenn9A7avLUSi5eNYZskTRvvJlmMoZT5+HEKp7OhjngAW7
         xl4YMnkIYUH52cDeAC7JdfUrCgGdKj7lWriolb7x9FwlR05EdtbvLMeOy4oyYa+WJZF3
         kdjSp+dCb+/l+JhSikRMMtpvC3qFMBQGfbhlcRTa3wXZSuW1qyiMd1GyT4OewoPZ+Hrn
         J+DB1kbkGSHddH6DgtB5gEziWFAeldy7o3F/+Dxpf2HXzlF8RGgjE1RScLXigYU47b2M
         zTtSMmenb6Sb5UMyTS+3YfIMxTAkAIJkKaH5meisyHM8mqzVgJMTjAMVgqN7jvw7+SI2
         OUYQ==
X-Gm-Message-State: ABy/qLb7sj50a9BooT5kNLmX//REO4qB3reiSYlsavW5tFf4cb5+N6vz
        /kbRHfN40oSnIKue8e7fToeGLlHLxPi0OKme2c1HPQ09aExcolcZ0fRA8xEnJGAB7NZLApLLOGe
        wGzYM0liPX/RH
X-Received: by 2002:adf:ee91:0:b0:317:6be2:f444 with SMTP id b17-20020adfee91000000b003176be2f444mr775731wro.49.1690839235272;
        Mon, 31 Jul 2023 14:33:55 -0700 (PDT)
X-Google-Smtp-Source: APBJJlHcpjszLVqFylH1zCms7R0ZXVG+68YIUyxgADLBbo5hwKg+QDAGEsaP020c80X8aiInSNd3/Q==
X-Received: by 2002:adf:ee91:0:b0:317:6be2:f444 with SMTP id b17-20020adfee91000000b003176be2f444mr775710wro.49.1690839235003;
        Mon, 31 Jul 2023 14:33:55 -0700 (PDT)
Received: from redhat.com ([2.52.21.81])
        by smtp.gmail.com with ESMTPSA id k14-20020adfe3ce000000b00317643a93f4sm14127145wrm.96.2023.07.31.14.33.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 31 Jul 2023 14:33:54 -0700 (PDT)
Date:   Mon, 31 Jul 2023 17:33:49 -0400
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Peter Xu <peterx@redhat.com>
Cc:     Xiaoyao Li <xiaoyao.li@intel.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        David Hildenbrand <david@redhat.com>,
        Igor Mammedov <imammedo@redhat.com>,
        Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
        Richard Henderson <richard.henderson@linaro.org>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        Markus Armbruster <armbru@redhat.com>,
        Eric Blake <eblake@redhat.com>,
        Daniel =?iso-8859-1?Q?P=2E_Berrang=E9?= <berrange@redhat.com>,
        Philippe =?iso-8859-1?Q?Mathieu-Daud=E9?= <philmd@linaro.org>,
        Chao Peng <chao.p.peng@linux.intel.com>,
        Michael Roth <michael.roth@amd.com>, isaku.yamahata@gmail.com,
        qemu-devel@nongnu.org, kvm@vger.kernel.org
Subject: Re: [RFC PATCH 04/19] memory: Introduce
 memory_region_can_be_private()
Message-ID: <20230731173132-mutt-send-email-mst@kernel.org>
References: <20230731162201.271114-1-xiaoyao.li@intel.com>
 <20230731162201.271114-5-xiaoyao.li@intel.com>
 <ZMgma0cRi/lkTKSz@x1n>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZMgma0cRi/lkTKSz@x1n>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Jul 31, 2023 at 05:23:55PM -0400, Peter Xu wrote:
> On Mon, Jul 31, 2023 at 12:21:46PM -0400, Xiaoyao Li wrote:
> > +bool memory_region_can_be_private(MemoryRegion *mr)
> > +{
> > +    return mr->ram_block && mr->ram_block->gmem_fd >= 0;
> > +}
> 
> This is not really MAP_PRIVATE, am I right?  If so, is there still chance
> we rename it (it seems to be also in the kernel proposal all across..)?
> 
> I worry it can be very confusing in the future against MAP_PRIVATE /
> MAP_SHARED otherwise.
> 
> Thanks,

It is - kernel calls this "map shared" but unfortunately qemu calls this
just "shared". Maybe e.g. "protect_shared" would be a better name for qemu?

-- 
MST

