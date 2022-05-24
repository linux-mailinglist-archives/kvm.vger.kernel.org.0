Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 20F0C532439
	for <lists+kvm@lfdr.de>; Tue, 24 May 2022 09:38:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233019AbiEXHh5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 24 May 2022 03:37:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33410 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229726AbiEXHhi (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 24 May 2022 03:37:38 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 8720673548
        for <kvm@vger.kernel.org>; Tue, 24 May 2022 00:37:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1653377856;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=QSn0eq4Bvs2xTbrxH6SjZqtwFwJqFEDca7NJAzrGl1g=;
        b=iG2CyS0CIwWxWhils1i0F3bLkRBCz3Qr0LNc0Gj6bklMDmb1bmXdR5qppoTeyP/Jm+LPpB
        cK5dZPyRY/3Q2ZuCq1XBY+cEba0TUiquiZc922VkT4qZ54iuWbmYuNzgD5/vpTE99mZA77
        9rA8S8/ESwNpmEGv1uucXnXPdT6MmNk=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-515-09kSuQVyOh-UYVNkFCeBAQ-1; Tue, 24 May 2022 03:37:33 -0400
X-MC-Unique: 09kSuQVyOh-UYVNkFCeBAQ-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com [10.11.54.7])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id BDA04801E80;
        Tue, 24 May 2022 07:37:32 +0000 (UTC)
Received: from sirius.home.kraxel.org (unknown [10.39.192.41])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 976A91410DD5;
        Tue, 24 May 2022 07:37:31 +0000 (UTC)
Received: by sirius.home.kraxel.org (Postfix, from userid 1000)
        id E8EEA1800393; Tue, 24 May 2022 09:37:29 +0200 (CEST)
Date:   Tue, 24 May 2022 09:37:29 +0200
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
Subject: Re: [RFC PATCH v4 22/36] i386/tdx: Track RAM entries for TDX VM
Message-ID: <20220524073729.xkk6s4tjkzm77wwz@sirius.home.kraxel.org>
References: <20220512031803.3315890-1-xiaoyao.li@intel.com>
 <20220512031803.3315890-23-xiaoyao.li@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220512031803.3315890-23-xiaoyao.li@intel.com>
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

> +static int tdx_accept_ram_range(uint64_t address, uint64_t length)
> +{
> +    TdxRamEntry *e;
> +    int i;
> +
> +    for (i = 0; i < tdx_guest->nr_ram_entries; i++) {
> +        e = &tdx_guest->ram_entries[i];
> +
> +        if (address + length < e->address ||
> +            e->address + e->length < address) {
> +                continue;
> +        }
> +
> +        if (e->address > address ||
> +            e->address + e->length < address + length) {
> +            return -EINVAL;
> +        }

if (e->type == TDX_RAM_ADDED)
	return -EINVAL

> +        if (e->address == address && e->length == length) {
> +            e->type = TDX_RAM_ADDED;
> +        } else if (e->address == address) {
> +            e->address += length;
> +            e->length -= length;
> +            tdx_add_ram_entry(address, length, TDX_RAM_ADDED);
> +        } else if (e->address + e->length == address + length) {
> +            e->length -= length;
> +            tdx_add_ram_entry(address, length, TDX_RAM_ADDED);
> +        } else {
> +            TdxRamEntry tmp = {
> +                .address = e->address,
> +                .length = e->length,
> +            };
> +            e->length = address - tmp.address;
> +
> +            tdx_add_ram_entry(address, length, TDX_RAM_ADDED);
> +            tdx_add_ram_entry(address + length,
> +                              tmp.address + tmp.length - (address + length),
> +                              TDX_RAM_UNACCEPTED);
> +        }

I think all this can be simplified, by
  (1) Change the existing entry to cover the accepted ram range.
  (2) If there is room before the accepted ram range add a
      TDX_RAM_UNACCEPTED entry for that.
  (3) If there is room after the accepted ram range add a
      TDX_RAM_UNACCEPTED entry for that.

take care,
  Gerd

