Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 95FBF5955CF
	for <lists+kvm@lfdr.de>; Tue, 16 Aug 2022 11:04:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233413AbiHPJEZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 16 Aug 2022 05:04:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51552 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231339AbiHPJDk (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 16 Aug 2022 05:03:40 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 40C147E33B
        for <kvm@vger.kernel.org>; Tue, 16 Aug 2022 00:16:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1660634204;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=BfSQx9MJUDsWYgkIpHZtARUsqPURAMDDVQHDICsC73Q=;
        b=KVon8XgFCa2IgeOcRthsT1mu7T2OFH/SGtktW/8nRUZ/nNsNAJyvbX3Dy2le0RUrX8LsUt
        DFAASGr56og4KZfLIMbXzq46BA7wSTXPtqx50Pa4K8DpgExyKAEtVt667GZP70wz1hXcU+
        A7Z2ApQuBPCO5B8UfycHNOo/wQKtIs4=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-675-HfawVT-mNWqx7lgDv68_8w-1; Tue, 16 Aug 2022 03:16:40 -0400
X-MC-Unique: HfawVT-mNWqx7lgDv68_8w-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com [10.11.54.8])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 9670C802D2C;
        Tue, 16 Aug 2022 07:16:39 +0000 (UTC)
Received: from sirius.home.kraxel.org (unknown [10.39.192.6])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 43952C15BA6;
        Tue, 16 Aug 2022 07:16:39 +0000 (UTC)
Received: by sirius.home.kraxel.org (Postfix, from userid 1000)
        id 9FBFB18003A8; Tue, 16 Aug 2022 09:16:37 +0200 (CEST)
Date:   Tue, 16 Aug 2022 09:16:37 +0200
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
Message-ID: <20220816071637.ihh7d4kbv7vpboqk@sirius.home.kraxel.org>
References: <20220512031803.3315890-1-xiaoyao.li@intel.com>
 <20220512031803.3315890-19-xiaoyao.li@intel.com>
 <20220524070804.tcrsg7cwlnbkzhjz@sirius.home.kraxel.org>
 <b294af31-fe92-f251-5d3e-0e439a59ee1e@intel.com>
 <20220530114904.242xqql3xfugy2a7@sirius.home.kraxel.org>
 <ad425c66-ce61-3e21-307e-55fc7131d954@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ad425c66-ce61-3e21-307e-55fc7131d954@intel.com>
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.8
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

  Hi,

> I did some tracing for this, and the result differs for q35 machine type and
> pc machine type.
> 
> - For q35, the memslot update for isa-bios/pc.rom happens when mc->reset()
> that is triggered via
> 
>   qdev_machine_creation_done()
>     -> qemu_system_reset(SHUTDOWN_CASE_NONE);
> 
> It's surely later than TDX's machine_init_done_notify callback which
> initializes the part of private memory via KVM_TDX_INIT_MEM_REGION
> 
> - For pc machine type, the memslot update happens in i440fx_init(), which is
> earlier than TDX's machine_init_done_notify callback
> 
> I haven't fully understand in what condition will QEMU carry out the memslot
> update yet. I will keep learning and try to come up a solution to ensure
> TDX's machine_init_done_notify callback executed after all the memslot
> settle down.

My guess would be the rom shadowing initialization being slightly
different in 'pc' and 'q35'.

take care,
  Gerd

