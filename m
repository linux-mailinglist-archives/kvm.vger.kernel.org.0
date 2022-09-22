Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 52D765E6232
	for <lists+kvm@lfdr.de>; Thu, 22 Sep 2022 14:21:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230326AbiIVMVI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 22 Sep 2022 08:21:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41000 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229766AbiIVMVG (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 22 Sep 2022 08:21:06 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 733BE15A2F
        for <kvm@vger.kernel.org>; Thu, 22 Sep 2022 05:21:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1663849261;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=e7qSItG4GJ0pjWkOrqf7j7YUBeEY/5XkBwaXQ44W3Ko=;
        b=UdJoPa72hZ7ZDtRi2y53HJo0rvONP82V7r6dH6lPmjf5DbwxSAwyHsQboV12W2xJXkHRMM
        ePxd7nA9jy7VLzNZcAEBf1ubw88rY5OsqsKVy19tDQC9SM9FCAo/cz/W0Bk2Pa7I9cHumL
        WDZI0sl5lyjwZRFw4MRk+W0sotok+f0=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-626-MbS4KflOOsWJYHqC3yy1BQ-1; Thu, 22 Sep 2022 08:21:00 -0400
X-MC-Unique: MbS4KflOOsWJYHqC3yy1BQ-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com [10.11.54.5])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id D7D293C10237;
        Thu, 22 Sep 2022 12:20:59 +0000 (UTC)
Received: from sirius.home.kraxel.org (unknown [10.39.192.24])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 7186253AA;
        Thu, 22 Sep 2022 12:20:59 +0000 (UTC)
Received: by sirius.home.kraxel.org (Postfix, from userid 1000)
        id 353711800084; Thu, 22 Sep 2022 14:20:58 +0200 (CEST)
Date:   Thu, 22 Sep 2022 14:20:58 +0200
From:   Gerd Hoffmann <kraxel@redhat.com>
To:     Daniel =?utf-8?B?UC4gQmVycmFuZ8Op?= <berrange@redhat.com>
Cc:     qemu-devel@nongnu.org, Sergio Lopez <slp@redhat.com>,
        Eduardo Habkost <eduardo@habkost.net>,
        Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
        Richard Henderson <richard.henderson@linaro.org>,
        kvm@vger.kernel.org, Marcelo Tosatti <mtosatti@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>
Subject: Re: [PATCH v4] x86: add etc/phys-bits fw_cfg file
Message-ID: <20220922122058.vesh352623uaon6e@sirius.home.kraxel.org>
References: <20220922101454.1069462-1-kraxel@redhat.com>
 <YyxF2TNwnXaefT6u@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <YyxF2TNwnXaefT6u@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.5
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Sep 22, 2022 at 12:24:09PM +0100, Daniel P. Berrangé wrote:
> On Thu, Sep 22, 2022 at 12:14:54PM +0200, Gerd Hoffmann wrote:
> > In case phys bits are functional and can be used by the guest (aka
> > host-phys-bits=on) add a fw_cfg file carrying the value.  This can
> > be used by the guest firmware for address space configuration.
> > 
> > The value in the etc/phys-bits fw_cfg file should be identical to
> > the phys bits value published via cpuid leaf 0x80000008.
> > 
> > This is only enabled for 7.2+ machine types for live migration
> > compatibility reasons.
> 
> Is this going to have any implications for what mgmt apps must
> take into account when selecting valid migration target hosts ?
> 
> Historically, apps have tended to ignore any checks for phys
> bits between src/dst migration hosts and hoped for the best.
> 
> Will this new behaviour introduce / change any failure scenarios
> where the target host has fewer phys bits than the src host, that
> mgmt apps need to be made aware of ?

No.  This will basically inform the guest that host-phys-bits has been
enabled (and pass the number of bits).  So the firmware can make use of
the available address space instead of trying to be as conservative as
possible to avoid going beyond the (unknown) limit.

The phys-bits config itself is not touched.

take care,
  Gerd

