Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 18802530BFF
	for <lists+kvm@lfdr.de>; Mon, 23 May 2022 11:04:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232087AbiEWIpq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 23 May 2022 04:45:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50206 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232027AbiEWIpi (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 23 May 2022 04:45:38 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 3DFFF218A
        for <kvm@vger.kernel.org>; Mon, 23 May 2022 01:45:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1653295536;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=jTW5NKpRCH89l9B0rOSSyDJS/2Azvl2oj2FaioH483o=;
        b=GXvhOQKG+tAtakENrotSrOgww2Pt9VZwF+V+LJizeZZv2EUR9kcwEVknyTNRQk/sgAmfNt
        Lu0TVCYfMUMy9b1myZig9KZ+PAY3VfqvfhZczhka5C5T2J6UXevj0bI4OkReuDAQM+Qnvt
        XejT5PqmiV2OeSpUVTF47L96cvRce7M=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-324-hpyjY1TANBqSQAqbDN9i1A-1; Mon, 23 May 2022 04:45:33 -0400
X-MC-Unique: hpyjY1TANBqSQAqbDN9i1A-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com [10.11.54.6])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 8F91F18019E7;
        Mon, 23 May 2022 08:45:32 +0000 (UTC)
Received: from sirius.home.kraxel.org (unknown [10.39.192.41])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 4F00E2166B25;
        Mon, 23 May 2022 08:45:32 +0000 (UTC)
Received: by sirius.home.kraxel.org (Postfix, from userid 1000)
        id B64A118000B4; Mon, 23 May 2022 10:45:30 +0200 (CEST)
Date:   Mon, 23 May 2022 10:45:30 +0200
From:   Gerd Hoffmann <kraxel@redhat.com>
To:     Xiaoyao Li <xiaoyao.li@intel.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Isaku Yamahata <isaku.yamahata@gmail.com>,
        isaku.yamahata@intel.com,
        Daniel P =?utf-8?B?LiBCZXJyYW5nw6k=?= <berrange@redhat.com>,
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
Subject: Re: [RFC PATCH v4 06/36] i386/tdx: Get tdx_capabilities via
 KVM_TDX_CAPABILITIES
Message-ID: <20220523084530.baedwpbwldc7cbnz@sirius.home.kraxel.org>
References: <20220512031803.3315890-1-xiaoyao.li@intel.com>
 <20220512031803.3315890-7-xiaoyao.li@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220512031803.3315890-7-xiaoyao.li@intel.com>
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.6
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

> +    do {
> +        size = sizeof(struct kvm_tdx_capabilities) +
> +               max_ent * sizeof(struct kvm_tdx_cpuid_config);
> +        caps = g_malloc0(size);
> +        caps->nr_cpuid_configs = max_ent;
> +
> +        r = tdx_platform_ioctl(KVM_TDX_CAPABILITIES, 0, caps);
> +        if (r == -E2BIG) {
> +            g_free(caps);
> +            max_ent *= 2;
> +        } else if (r < 0) {
> +            error_report("KVM_TDX_CAPABILITIES failed: %s\n", strerror(-r));
> +            exit(1);
> +        }
> +    }
> +    while (r == -E2BIG);

This should have a limit for the number of loop runs.

take care,
  Gerd

