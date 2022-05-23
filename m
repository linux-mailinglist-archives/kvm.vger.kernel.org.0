Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1F4AB530D05
	for <lists+kvm@lfdr.de>; Mon, 23 May 2022 12:41:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233419AbiEWJjb (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 23 May 2022 05:39:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36998 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233453AbiEWJj3 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 23 May 2022 05:39:29 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 798561154
        for <kvm@vger.kernel.org>; Mon, 23 May 2022 02:39:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1653298766;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=+TxRfMkI29EpV9M74qsZWsccffjGup9UXF5ZlzJ8zeo=;
        b=d4bqTLB+RXgQRrNDZIlCYMZW0gxy3lkfo1Z3NBkuyteScjt2oeFK+E9RhiXj35aYNO9enV
        I36tyzj8EE6ZO439yLMTCAHSpnTct2o9tLuAtwVpe8gaZ9Xl+P6TF3DbDeb7Jxy+a30vlO
        ftouE3wqOKf9FmEUxYl9dFLdurbLklo=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-601-WfOSOmZxPpO2UKkF9D2zuw-1; Mon, 23 May 2022 05:39:22 -0400
X-MC-Unique: WfOSOmZxPpO2UKkF9D2zuw-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com [10.11.54.4])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 197753C1022A;
        Mon, 23 May 2022 09:39:22 +0000 (UTC)
Received: from sirius.home.kraxel.org (unknown [10.39.192.41])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id BFF322026D6A;
        Mon, 23 May 2022 09:39:21 +0000 (UTC)
Received: by sirius.home.kraxel.org (Postfix, from userid 1000)
        id 0A69E18000B4; Mon, 23 May 2022 11:39:20 +0200 (CEST)
Date:   Mon, 23 May 2022 11:39:20 +0200
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
Subject: Re: [RFC PATCH v4 13/36] i386/tdx: Validate TD attributes
Message-ID: <20220523093920.o6pk5i7zig6enwnm@sirius.home.kraxel.org>
References: <20220512031803.3315890-1-xiaoyao.li@intel.com>
 <20220512031803.3315890-14-xiaoyao.li@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220512031803.3315890-14-xiaoyao.li@intel.com>
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.4
X-Spam-Status: No, score=-3.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> Validate TD attributes with tdx_caps that fixed-0 bits must be zero and
> fixed-1 bits must be set.

> -static void setup_td_guest_attributes(X86CPU *x86cpu)
> +static int tdx_validate_attributes(TdxGuest *tdx)
> +{
> +    if (((tdx->attributes & tdx_caps->attrs_fixed0) | tdx_caps->attrs_fixed1) !=
> +        tdx->attributes) {
> +            error_report("Invalid attributes 0x%lx for TDX VM (fixed0 0x%llx, fixed1 0x%llx)",
> +                          tdx->attributes, tdx_caps->attrs_fixed0, tdx_caps->attrs_fixed1);
> +            return -EINVAL;
> +    }

So, how is this supposed to work?  Patch #2 introduces attributes as
user-settable property.  So do users have to manually figure and pass
the correct value, so the check passes?  Specifically the fixed1 check?

I think 'attributes' should not be user-settable in the first place.
Each feature-bit which is actually user-settable (and not already
covered by another option like pmu) should be a separate attribute for
tdx-object.  Then the tdx code can create attributes from hardware
capabilities and user settings.

When user-settable options might not be available depending on hardware
capabilities best practice is to create them as OnOffAuto properties.

  Auto == qemu can pick the value, typical behavior is to enable the
          feature if the hardware supports it.
  On == must enable, if it isn't possible throw an error and exit.
  Off == must disable, if it isn't possible throw an error and exit. 

take care,
  Gerd

