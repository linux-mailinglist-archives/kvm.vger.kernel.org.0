Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AB2525955C6
	for <lists+kvm@lfdr.de>; Tue, 16 Aug 2022 11:03:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231924AbiHPJDS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 16 Aug 2022 05:03:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39538 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233238AbiHPJCg (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 16 Aug 2022 05:02:36 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id DEA50844E8
        for <kvm@vger.kernel.org>; Tue, 16 Aug 2022 00:13:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1660634019;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=muPuRsbWUNvQq+AV/tXjZ/pmXJv9hf0eowkhwUQZsZs=;
        b=br7E0ZwG7GWV6oRT1eu3UQgSH8EdCYedFkNqreW34r/RwQwLjCfjcB5UwqqVVOlQEqq1DK
        4NMk+aKW34ULvrttx6ncsiyJVI6nlB/JVG51kj4HULHkenPHhOOc+Ick3609L5DO3sdcvj
        7hzHj1OjOCmNpPUyj0EMEl1wdgm/bvs=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-523-ygmvnsJ7N7yVnCqhMFKjbQ-1; Tue, 16 Aug 2022 03:13:36 -0400
X-MC-Unique: ygmvnsJ7N7yVnCqhMFKjbQ-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com [10.11.54.1])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 1F41D1C16B40;
        Tue, 16 Aug 2022 07:13:36 +0000 (UTC)
Received: from sirius.home.kraxel.org (unknown [10.39.192.6])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id A34FA40CF8EA;
        Tue, 16 Aug 2022 07:13:35 +0000 (UTC)
Received: by sirius.home.kraxel.org (Postfix, from userid 1000)
        id 402C018003A8; Tue, 16 Aug 2022 09:13:34 +0200 (CEST)
Date:   Tue, 16 Aug 2022 09:13:34 +0200
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
Message-ID: <20220816071334.6aygj32xwnf6t2i3@sirius.home.kraxel.org>
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
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.1
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Jul 29, 2022 at 03:14:02PM +0800, Xiaoyao Li wrote:
> On 5/30/2022 7:49 PM, Gerd Hoffmann wrote:
> > On Thu, May 26, 2022 at 10:48:56AM +0800, Xiaoyao Li wrote:
> > > On 5/24/2022 3:08 PM, Gerd Hoffmann wrote:
> > > > On Thu, May 12, 2022 at 11:17:45AM +0800, Xiaoyao Li wrote:
> > > > > TDX guest cannot go to real mode, so just skip the setup of isa-bios.
> > > > 
> > > > Does isa-bios setup cause any actual problems?
> > > > (same question for patch #19).

> > There is no need for copying, end_of_1M is a alias memory region for
> > end_of_4G, so the backing storage is the same.
> 
> It is a reason that current alias approach cannot work for TDX. Because in
> TDX a private page can be only mapped to one gpa.

Ok, so memory aliasing not being supported by TDX is the underlying
reason.

> So for simplicity, I will
> just skip isa-bios shadowing for TDX instead of implementing a non-alias +
> memcpy approach.

Makes sense given that tdx wouldn't use the mapping below 1M anyway.
A comment explaining the tdx aliasing restriction would be good to make
clear why the special case for tdx exists.

take care,
  Gerd

