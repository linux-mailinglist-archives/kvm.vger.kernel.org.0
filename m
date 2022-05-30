Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0DF94537A29
	for <lists+kvm@lfdr.de>; Mon, 30 May 2022 13:50:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235805AbiE3Lux (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 30 May 2022 07:50:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40452 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235985AbiE3LtR (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 30 May 2022 07:49:17 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 441F16B7C7
        for <kvm@vger.kernel.org>; Mon, 30 May 2022 04:49:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1653911351;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=1jBLgUxgHH8kcMeU83Uqv8BeFNU4gu6zKWN29kUJs70=;
        b=UmpZqp6Jf69R6diML4pTUwRuIIJ6G3fc5oqooJhgEzgwuKgg8d3eSOEn+oLEuilbV4xGte
        w4UoYqh4Hass6nj+bgo2e9KsqmzxqGNp9u9XwDfQ2G9SE9Q2yJntJhISjz7G1UwFQbZcsu
        EcB6nxn8uPd54qNOLmiNQf4AN8UMI5Y=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-375-2pVTSCIONnyhIaPVCzKfUA-1; Mon, 30 May 2022 07:49:06 -0400
X-MC-Unique: 2pVTSCIONnyhIaPVCzKfUA-1
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com [10.11.54.9])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 208D7811E75;
        Mon, 30 May 2022 11:49:06 +0000 (UTC)
Received: from sirius.home.kraxel.org (unknown [10.39.192.41])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id B9387492CA2;
        Mon, 30 May 2022 11:49:05 +0000 (UTC)
Received: by sirius.home.kraxel.org (Postfix, from userid 1000)
        id 2AD82180039F; Mon, 30 May 2022 13:49:04 +0200 (CEST)
Date:   Mon, 30 May 2022 13:49:04 +0200
From:   Gerd Hoffmann <kraxel@redhat.com>
To:     Xiaoyao Li <xiaoyao.li@intel.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Isaku Yamahata <isaku.yamahata@gmail.com>,
        isaku.yamahata@intel.com,
        Daniel =?utf-8?B?UC4gQmVycmFuZ8Op?= <berrange@redhat.com>,
        Philippe =?utf-8?Q?Mathieu-Daud=C3=A9?= <f4bug@amsat.org>,
        Richard Henderson <richard.henderson@linaro.org>,
        "Michael S . Tsirkin" <mst@redhat.com>,
        Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        Laszlo Ersek <lersek@redhat.com>,
        Eric Blake <eblake@redhat.com>,
        Connor Kuehl <ckuehl@redhat.com>, erdemaktas@google.com,
        kvm@vger.kernel.org, qemu-devel@nongnu.org, seanjc@google.com
Subject: Re: [RFC PATCH v4 18/36] i386/tdx: Skip BIOS shadowing setup
Message-ID: <20220530114904.242xqql3xfugy2a7@sirius.home.kraxel.org>
References: <20220512031803.3315890-1-xiaoyao.li@intel.com>
 <20220512031803.3315890-19-xiaoyao.li@intel.com>
 <20220524070804.tcrsg7cwlnbkzhjz@sirius.home.kraxel.org>
 <b294af31-fe92-f251-5d3e-0e439a59ee1e@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b294af31-fe92-f251-5d3e-0e439a59ee1e@intel.com>
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.9
X-Spam-Status: No, score=-2.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, May 26, 2022 at 10:48:56AM +0800, Xiaoyao Li wrote:
> On 5/24/2022 3:08 PM, Gerd Hoffmann wrote:
> > On Thu, May 12, 2022 at 11:17:45AM +0800, Xiaoyao Li wrote:
> > > TDX guest cannot go to real mode, so just skip the setup of isa-bios.
> > 
> > Does isa-bios setup cause any actual problems?
> > (same question for patch #19).
> 
> It causes mem_region split and mem_slot deletion on KVM.
> 
> TDVF marks pages starting from 0x800000 as TEMP_MEM and TD_HOB, which are
> TD's private memory and are TDH_MEM_PAGE_ADD'ed to TD via
> KVM_TDX_INIT_MEM_REGION
> 
> However, if isa-bios and pc.rom are not skipped, the memory_region
> initialization of them is after KVM_TDX_INIT_MEM_REGION in
> tdx_machine_done_notify(). (I didn't figure out why this order though)
> 
> And the it causes memory region split that splits
> 	[0, ram_below_4g)
> to
> 	[0, 0xc0 000),
> 	[0xc0 000, 0xe0 000),
> 	[0xe0 000, 0x100 000),
> 	[0x100 000, ram_below_4g)
> 
> which causes mem_slot deletion on KVM. On KVM side, we lose the page content
> when mem_slot deletion.  Thus, the we lose the content of TD HOB.

Hmm, removing and re-creating memory slots shouldn't cause page content
go away.   I'm wondering what the *real* problem is?  Maybe you loose
tdx-specific state, i.e. this removes TDH_MEM_PAGE_ADD changes?

> Yes, the better solution seems to be ensure KVM_TDX_INIT_MEM_REGION is
> called after all the mem region is settled down.

Yes, especially if tdx can't tolerate memory slots coming and going.

> But I haven't figured out the reason why the isa-bios and pc.rom
> initialization happens after machine_init_done_notifier

Probably happens when a flatview is created from the address space.

Maybe that is delayed somehow for machine creation, so all the address
space updates caused by device creation don't lead to lots of flatviews
being created and thrown away.

> on the other hand, to keep isa-bios and pc.rom, we need additional work to
> copy the content from the end_of_4G to end_of_1M.

There is no need for copying, end_of_1M is a alias memory region for
end_of_4G, so the backing storage is the same.

> I'm not sure if isa-bios and pc.rom are needed from people on TD guest, so I
> just skip them for simplicity,

Given that TDX guests start in 32bit mode not in real mode everything
should work fine without isa-bios.

I'd prefer to avoid creating a special case for tdx though.  Should make
long-term maintenance a bit easier when this is not needed.

take care,
  Gerd

