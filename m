Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 67F96530C1B
	for <lists+kvm@lfdr.de>; Mon, 23 May 2022 11:04:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232361AbiEWJBs (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 23 May 2022 05:01:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59222 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232322AbiEWJBo (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 23 May 2022 05:01:44 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id CD502443E4
        for <kvm@vger.kernel.org>; Mon, 23 May 2022 02:01:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1653296499;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=9TNnfIZ+DcTG6WScXMXF6bmDMYeYfeojwTqs68X24Rs=;
        b=gSjDjExGvQhRQxziCAmo9Kutwny71zg6PaE6jaensHH/rwLnkvrPp2w49Mo8aVvBAAmhEG
        UNiaOrO3kS7wFvjLcp3jc+z74wa7RfR6ENq4fql8oeBcdzohpSGTO5vDnyeawq00aDegDQ
        2y1E7ZyG5QFx5xAz4aU0uE7BrDSlVVs=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-112-9Ou6MMAlNiWQa8BXya6mSA-1; Mon, 23 May 2022 05:01:36 -0400
X-MC-Unique: 9Ou6MMAlNiWQa8BXya6mSA-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com [10.11.54.3])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 834E280B712;
        Mon, 23 May 2022 09:01:35 +0000 (UTC)
Received: from sirius.home.kraxel.org (unknown [10.39.192.41])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 466081121314;
        Mon, 23 May 2022 09:01:35 +0000 (UTC)
Received: by sirius.home.kraxel.org (Postfix, from userid 1000)
        id D1AB918000B4; Mon, 23 May 2022 11:01:33 +0200 (CEST)
Date:   Mon, 23 May 2022 11:01:33 +0200
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
Subject: Re: [RFC PATCH v4 08/36] i386/tdx: Adjust get_supported_cpuid() for
 TDX VM
Message-ID: <20220523090133.tdctqihkmwv7nlog@sirius.home.kraxel.org>
References: <20220512031803.3315890-1-xiaoyao.li@intel.com>
 <20220512031803.3315890-9-xiaoyao.li@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220512031803.3315890-9-xiaoyao.li@intel.com>
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.3
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

> - The supported XCR0 and XSS bits needs to be cap'ed by tdx_caps, because
>   KVM uses them to setup XFAM of TD.

> +    case 0xd:
> +        if (index == 0) {
> +            if (reg == R_EAX) {
> +                *ret &= (uint32_t)tdx_caps->xfam_fixed0 & XCR0_MASK;
> +                *ret |= (uint32_t)tdx_caps->xfam_fixed1 & XCR0_MASK;
> +            } else if (reg == R_EDX) {
> +                *ret &= (tdx_caps->xfam_fixed0 & XCR0_MASK) >> 32;
> +                *ret |= (tdx_caps->xfam_fixed1 & XCR0_MASK) >> 32;
> +            }
> +        } else if (index == 1) {
> +            /* TODO: Adjust XSS when it's supported. */
> +        }
> +        break;

> +    default:
> +        /* TODO: Use tdx_caps to adjust CPUID leafs. */
> +        break;

Hmm, that looks all a bit messy and incomplete, also the commit
message doesn't match the patch (describes XSS which isn't actually
implemented).

take care,
  Gerd

