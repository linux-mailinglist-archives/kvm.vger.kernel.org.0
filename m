Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4D167537A45
	for <lists+kvm@lfdr.de>; Mon, 30 May 2022 13:59:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236026AbiE3L7T (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 30 May 2022 07:59:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39190 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236024AbiE3L7R (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 30 May 2022 07:59:17 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 0545A7CB2A
        for <kvm@vger.kernel.org>; Mon, 30 May 2022 04:59:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1653911955;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=xEV8sKFUdTUM3AL/I32tWpMjVPSfdad9VzF2DtI+nqM=;
        b=Ih/AF/Z6ePTdI5Jfxd4kKIa/TyNwdfRGuFIpCqVArMnULHdiZiiFXzqz4yd4hnWH4eKwl6
        FY4ouYqzQ4gPPUdrAaGcQnHoXMC8XHebgN9g1b/bvR3NlhaUucfIHlgKqWWQneQ/fkkovO
        H2P+WELdl8TOOd/2nL/xu0bvsllFawc=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-66-Gwz_03lfNHyfOE_hXCPuzQ-1; Mon, 30 May 2022 07:59:10 -0400
X-MC-Unique: Gwz_03lfNHyfOE_hXCPuzQ-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com [10.11.54.1])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 190ED80B70A;
        Mon, 30 May 2022 11:59:10 +0000 (UTC)
Received: from sirius.home.kraxel.org (unknown [10.39.192.41])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id D3B9F40CFD0A;
        Mon, 30 May 2022 11:59:09 +0000 (UTC)
Received: by sirius.home.kraxel.org (Postfix, from userid 1000)
        id 557A0180039F; Mon, 30 May 2022 13:59:08 +0200 (CEST)
Date:   Mon, 30 May 2022 13:59:08 +0200
From:   Gerd Hoffmann <kraxel@redhat.com>
To:     Xiaoyao Li <xiaoyao.li@intel.com>
Cc:     Isaku Yamahata <isaku.yamahata@gmail.com>,
        Paolo Bonzini <pbonzini@redhat.com>, isaku.yamahata@intel.com,
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
Subject: Re: [RFC PATCH v4 22/36] i386/tdx: Track RAM entries for TDX VM
Message-ID: <20220530115908.lcb6xegu4arfsqux@sirius.home.kraxel.org>
References: <20220512031803.3315890-1-xiaoyao.li@intel.com>
 <20220512031803.3315890-23-xiaoyao.li@intel.com>
 <20220524073729.xkk6s4tjkzm77wwz@sirius.home.kraxel.org>
 <5e457e0b-dc23-9e5b-de89-0b137e2baf7f@intel.com>
 <20220526184826.GA3413287@ls.amr.corp.intel.com>
 <fa75cda1-311d-dcd7-965d-c553700c5303@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <fa75cda1-311d-dcd7-965d-c553700c5303@intel.com>
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.1
X-Spam-Status: No, score=-2.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

  Hi,

> > tdx_add_ram_entry() increments tdx_guest->nr_ram_entries.  I think it's worth
> > for comments why this is safe regarding to this for-loop.
> 
> The for-loop is to find the valid existing RAM entry (from E820 table).
> It will update the RAM entry and increment tdx_guest->nr_ram_entries when
> the initial RAM entry needs to be split. However, once find, the for-loop is
> certainly stopped since it returns unconditionally.

Add a comment saying so would be good.

Or move the code block doing the update out of the loop.  That will
likewise make clear that finding the entry which must be updated is
the only purpose of the loop.

take care,
  Gerd

