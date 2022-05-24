Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3701053238E
	for <lists+kvm@lfdr.de>; Tue, 24 May 2022 09:00:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234207AbiEXHAH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 24 May 2022 03:00:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46126 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229456AbiEXHAG (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 24 May 2022 03:00:06 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 4D36C544C5
        for <kvm@vger.kernel.org>; Tue, 24 May 2022 00:00:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1653375603;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=YHXw5Avzhre0qOXI/gzhO3Vt9C0IiUfx5FpKs00044k=;
        b=FnudnCInr/3+n7eCRyhKAF0VmqRyjy33nFotHm6Kat+I//pDVjU81QsRSMeOfOEv7mUJ6c
        e1lESjeGMHXS4hdHiLTgI79mYPOn+V5NnG3Uj1IWMdwmXZTGGrozw5HQ/womyLEAa/NPlA
        9xq3qd2lr0AZzKS495jtfJkwaNBV3BA=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-493-QvkngRkCMZutatjTSc3fhw-1; Tue, 24 May 2022 03:00:02 -0400
X-MC-Unique: QvkngRkCMZutatjTSc3fhw-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com [10.11.54.7])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 5B66829AA3B8;
        Tue, 24 May 2022 07:00:01 +0000 (UTC)
Received: from sirius.home.kraxel.org (unknown [10.39.192.41])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 0C3581410DD5;
        Tue, 24 May 2022 07:00:01 +0000 (UTC)
Received: by sirius.home.kraxel.org (Postfix, from userid 1000)
        id 69B251800393; Tue, 24 May 2022 08:59:59 +0200 (CEST)
Date:   Tue, 24 May 2022 08:59:59 +0200
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
Subject: Re: [RFC PATCH v4 13/36] i386/tdx: Validate TD attributes
Message-ID: <20220524065959.umzmlhwcspfwi7m2@sirius.home.kraxel.org>
References: <20220512031803.3315890-1-xiaoyao.li@intel.com>
 <20220512031803.3315890-14-xiaoyao.li@intel.com>
 <20220523093920.o6pk5i7zig6enwnm@sirius.home.kraxel.org>
 <1e0f0051-f7c1-ed3b-be02-d16f0cf9f25d@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1e0f0051-f7c1-ed3b-be02-d16f0cf9f25d@intel.com>
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.7
X-Spam-Status: No, score=-3.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, May 24, 2022 at 12:19:51PM +0800, Xiaoyao Li wrote:
> On 5/23/2022 5:39 PM, Gerd Hoffmann wrote:
> > So, how is this supposed to work?  Patch #2 introduces attributes as
> > user-settable property.  So do users have to manually figure and pass
> > the correct value, so the check passes?  Specifically the fixed1 check?
> > 
> > I think 'attributes' should not be user-settable in the first place.
> > Each feature-bit which is actually user-settable (and not already
> > covered by another option like pmu) should be a separate attribute for
> > tdx-object.  Then the tdx code can create attributes from hardware
> > capabilities and user settings.
> 
> In patch #2, tdx-guest.attributes is defined as a field to hold a 64 bits
> value of attributes but it doesn't provide any getter/setter for it. So it's
> *not* user-settable.

Ok.  Why it is declared as object property in the first place then?

take care,
  Gerd

