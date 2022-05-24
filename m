Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 42574532388
	for <lists+kvm@lfdr.de>; Tue, 24 May 2022 08:57:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231700AbiEXG5g (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 24 May 2022 02:57:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44798 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229456AbiEXG5f (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 24 May 2022 02:57:35 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 44713544F7
        for <kvm@vger.kernel.org>; Mon, 23 May 2022 23:57:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1653375452;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=eNsJ5rEU5Pscc/8s3za+Q6hBhbzLBmvY5IewWuoALk0=;
        b=MU55t7ye4gjISEPtFQY1U3v24z/MI09HcY4pDI3RKGjd6NNw3MEEOnhBqb/R359VqSNR9k
        nPcsun5ezEaZmHX42k6P1sdLrzxumZA7lJki/Bz04FwwZpYrKuywpn3qQTQGAd4cRSxhYa
        pMPvL4WWoZd86KlhAeloOKO1kah4Pks=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-515-TnQ72z5-OZamaAwv0KhizQ-1; Tue, 24 May 2022 02:57:26 -0400
X-MC-Unique: TnQ72z5-OZamaAwv0KhizQ-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com [10.11.54.8])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id BCC8C3C025AF;
        Tue, 24 May 2022 06:57:20 +0000 (UTC)
Received: from sirius.home.kraxel.org (unknown [10.39.192.41])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 80AEFC1914E;
        Tue, 24 May 2022 06:57:20 +0000 (UTC)
Received: by sirius.home.kraxel.org (Postfix, from userid 1000)
        id 1000F1800393; Tue, 24 May 2022 08:57:19 +0200 (CEST)
Date:   Tue, 24 May 2022 08:57:19 +0200
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
Subject: Re: [RFC PATCH v4 11/36] i386/tdx: Initialize TDX before creating TD
 vcpus
Message-ID: <20220524065719.wyyoba2ke73tx3nc@sirius.home.kraxel.org>
References: <20220512031803.3315890-1-xiaoyao.li@intel.com>
 <20220512031803.3315890-12-xiaoyao.li@intel.com>
 <20220523092003.lm4vzfpfh4ezfcmy@sirius.home.kraxel.org>
 <d3e967f3-917f-27ce-1367-2dba23e5c241@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d3e967f3-917f-27ce-1367-2dba23e5c241@intel.com>
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.8
X-Spam-Status: No, score=-3.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

  Hi,

> > Hmm, hooking *vm* initialization into *vcpu* creation looks wrong to me.
> 
> That's because for TDX, it has to do VM-scope (feature) initialization
> before creating vcpu. This is new to KVM and QEMU, that every feature is
> vcpu-scope and configured per-vcpu before.
> 
> To minimize the change to QEMU, we want to utilize @cpu and @cpu->env to
> grab the configuration info. That's why it goes this way.
> 
> Do you have any better idea on it?

Maybe it's a bit more work to add VM-scope initialization support to
qemu.  But I expect that approach will work better long-term.  You need
this mutex and the 'initialized' variable in your code to make sure it
runs only once because the way you hook it in is not ideal ...

[ disclaimer: I'm not that familiar with the kvm interface in qemu ]

take care,
  Gerd

