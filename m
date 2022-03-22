Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 33B804E3BBF
	for <lists+kvm@lfdr.de>; Tue, 22 Mar 2022 10:30:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232580AbiCVJbg (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 22 Mar 2022 05:31:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39570 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231376AbiCVJbf (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 22 Mar 2022 05:31:35 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id A3B685DE69
        for <kvm@vger.kernel.org>; Tue, 22 Mar 2022 02:30:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1647941407;
        h=from:from:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:in-reply-to:in-reply-to:  references:references;
        bh=WvAx0gqmJgN7iOL12kRdoAxfZVQoNQP8msiXzlvQRbQ=;
        b=aSQ/zuhKnHJVnmapLOqTAdaglwLW5wNAY07/MehfHTVye6IUVsd4QtvaGSBl1k2i2hoTea
        qWITIQmWuK8ojXpJT6UnNXgd7MN5r3ECO5cVLuP7esK/UPOzl8FzoDxQHtpejsCFoZv+wF
        rZf8iFi58ybP/3VvNjM0qTCU9QKYInY=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-517-FF6o3ReuOC6Q2YBi0Iw6cA-1; Tue, 22 Mar 2022 05:30:04 -0400
X-MC-Unique: FF6o3ReuOC6Q2YBi0Iw6cA-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com [10.11.54.1])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 380AF3801EC4;
        Tue, 22 Mar 2022 09:30:04 +0000 (UTC)
Received: from redhat.com (unknown [10.39.195.0])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id A2EFE40CF8EF;
        Tue, 22 Mar 2022 09:30:00 +0000 (UTC)
Date:   Tue, 22 Mar 2022 09:29:57 +0000
From:   Daniel =?utf-8?B?UC4gQmVycmFuZ8Op?= <berrange@redhat.com>
To:     Gerd Hoffmann <kraxel@redhat.com>
Cc:     Xiaoyao Li <xiaoyao.li@intel.com>,
        Philippe =?utf-8?Q?Mathieu-Daud=C3=A9?= 
        <philippe.mathieu.daude@gmail.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Philippe =?utf-8?Q?Mathieu-Daud=C3=A9?= <f4bug@amsat.org>,
        Richard Henderson <richard.henderson@linaro.org>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        Laszlo Ersek <lersek@redhat.com>,
        Eric Blake <eblake@redhat.com>,
        Connor Kuehl <ckuehl@redhat.com>, isaku.yamahata@intel.com,
        erdemaktas@google.com, kvm@vger.kernel.org, qemu-devel@nongnu.org,
        seanjc@google.com
Subject: Re: [RFC PATCH v3 17/36] pflash_cfi01/tdx: Introduce ram_mode of
 pflash for TDVF
Message-ID: <YjmXFZRCbKXTkAhN@redhat.com>
Reply-To: Daniel =?utf-8?B?UC4gQmVycmFuZ8Op?= <berrange@redhat.com>
References: <20220317135913.2166202-1-xiaoyao.li@intel.com>
 <20220317135913.2166202-18-xiaoyao.li@intel.com>
 <f418548e-c24c-1bc3-4e16-d7a775298a18@gmail.com>
 <7a8233e4-0cae-b05a-7931-695a7ee87fc9@intel.com>
 <20220322092141.qsgv3pqlvlemgrgw@sirius.home.kraxel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20220322092141.qsgv3pqlvlemgrgw@sirius.home.kraxel.org>
User-Agent: Mutt/2.1.5 (2021-12-30)
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.1
X-Spam-Status: No, score=-2.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Mar 22, 2022 at 10:21:41AM +0100, Gerd Hoffmann wrote:
>   Hi,
> 
> > > If you don't need a pflash device, don't use it: simply map your nvram
> > > region as ram in your machine. No need to clutter the pflash model like
> > > that.
> 
> Using the pflash device for something which isn't actually flash looks a
> bit silly indeed.
> 
> > 
> > I know it's dirty to hack the pflash device. The purpose is to make the user
> > interface unchanged that people can still use
> > 
> > 	-drive if=pflash,format=raw,unit=0,file=/path/to/OVMF_CODE.fd
> >         -drive if=pflash,format=raw,unit=1,file=/path/to/OVMF_VARS.fd
> > 
> > to create TD guest.
> 
> Well, if persistent vars are not supported anyway there is little reason
> to split the firmware into CODE and VARS files.  You can use just use
> OVMF.fd with a single pflash device.  libvirt recently got support for
> that.

Agreed.

> Just using -bios OVMF.fd might work too.  Daniel tried that recently for
> sev, but ran into problems with wiring up ovmf metadata parsing for
> -bios.  Don't remember the details though.

It was related to the BIOS shadowing, whereby QEMU loads it at one
address, and then when CPUs start it is copied to another address.
This was not compatible with the way AMD SEV wants to do measurement
of the firmware. May or may not be relevant for TDX, I don't know
enough about TDX to say.


With regards,
Daniel
-- 
|: https://berrange.com      -o-    https://www.flickr.com/photos/dberrange :|
|: https://libvirt.org         -o-            https://fstop138.berrange.com :|
|: https://entangle-photo.org    -o-    https://www.instagram.com/dberrange :|

