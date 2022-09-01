Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8B07F5A9990
	for <lists+kvm@lfdr.de>; Thu,  1 Sep 2022 15:58:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233909AbiIAN6a (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 1 Sep 2022 09:58:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56072 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234181AbiIAN6T (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 1 Sep 2022 09:58:19 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4E6512AE18
        for <kvm@vger.kernel.org>; Thu,  1 Sep 2022 06:58:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1662040697;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=WiIx364gIjS2z7dRJE0nKaQQ0mHqcrR06/I23IKZLlc=;
        b=jPxq5Ni2FC3MxMz4Pn+MP/sDYRAc5DUpIAX8p66a1olhamw+Mjot0AcnrB3k/0NS8gYWkJ
        R+UdrttXHKHBrpaysGBFHDMY1RsWeA7Q/HSYYm2IMfGChmQpmCp6x86kIiCRi33aqm8tFQ
        kJdBSmU+6N1L2rlO+ZBOSbIZQCtCE8E=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-479-9a07oUgfMoKlFcVWOgok8g-1; Thu, 01 Sep 2022 09:58:13 -0400
X-MC-Unique: 9a07oUgfMoKlFcVWOgok8g-1
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com [10.11.54.10])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id A6A1E1C004E4;
        Thu,  1 Sep 2022 13:58:12 +0000 (UTC)
Received: from sirius.home.kraxel.org (unknown [10.39.195.70])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 68A10492C3B;
        Thu,  1 Sep 2022 13:58:12 +0000 (UTC)
Received: by sirius.home.kraxel.org (Postfix, from userid 1000)
        id B9E6518003AA; Thu,  1 Sep 2022 15:58:10 +0200 (CEST)
Date:   Thu, 1 Sep 2022 15:58:10 +0200
From:   Gerd Hoffmann <kraxel@redhat.com>
To:     Xiaoyao Li <xiaoyao.li@intel.com>
Cc:     qemu-devel@nongnu.org, kvm@vger.kernel.org,
        Marcelo Tosatti <mtosatti@redhat.com>,
        Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
        Eduardo Habkost <eduardo@habkost.net>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Richard Henderson <richard.henderson@linaro.org>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Sergio Lopez <slp@redhat.com>
Subject: Re: [PATCH 0/2] expose host-phys-bits to guest
Message-ID: <20220901135810.6dicz4grhz7ye2u7@sirius.home.kraxel.org>
References: <20220831125059.170032-1-kraxel@redhat.com>
 <957f0cc5-6887-3861-2b80-69a8c7cdd098@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <957f0cc5-6887-3861-2b80-69a8c7cdd098@intel.com>
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.10
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

> I think the problem is for all the named CPU model, that they don't have
> phys_bits defined. Thus they all have "cpu->phys-bits == 0", which leads to
> cpu->phys_bits = TCG_PHYS_ADDR_BITS (36 for 32-bits build and 40 for 64-bits
> build)

Exactly.  And if you run on hardware with phys-bits being 36 or 39
(common for intel desktop processors) things explode when the guest
tries to use the whole range.

> Anyway, IMO, guest including guest firmware, should always consult from
> CPUID leaf 0x80000008 for physical address length.

It simply can't for the reason outlined above.  Even if we fix qemu
today that doesn't solve the problem for the firmware because we want
backward compatibility with older qemu versions.  Thats why I want the
extra bit which essentially says "CPUID leaf 0x80000008 actually works".

take care,
  Gerd

