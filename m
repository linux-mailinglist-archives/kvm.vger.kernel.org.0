Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3E2B2782669
	for <lists+kvm@lfdr.de>; Mon, 21 Aug 2023 11:39:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234426AbjHUJjQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 21 Aug 2023 05:39:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40378 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230107AbjHUJjP (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 21 Aug 2023 05:39:15 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8D03B9D
        for <kvm@vger.kernel.org>; Mon, 21 Aug 2023 02:38:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1692610708;
        h=from:from:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:in-reply-to:in-reply-to:  references:references;
        bh=R2brJ+XSxT0BCix3/bDQpxgcg7IYxyY9nHO9hl4iHpo=;
        b=a8ij3rrgbQMyMV6tsKY9y905yhAGyNG0nWyQk1Al4msMM2bpc+2h0pmRFhwbLDAaEn0sMy
        oUVC3gCQatESZsVOd8ReS25m+kEPvPKbOmKzyiGjJmdnklUfP4kw7JXCsI/rvAUmW1LB5U
        0y8vSAkbAlYKYlNmbsfc1nA+kSuyzdA=
Received: from mimecast-mx02.redhat.com (66.187.233.73 [66.187.233.73]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-322-xPJoeZ4kMByDKf4SCIkV0A-1; Mon, 21 Aug 2023 05:38:24 -0400
X-MC-Unique: xPJoeZ4kMByDKf4SCIkV0A-1
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com [10.11.54.10])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 71A7E3815EE7;
        Mon, 21 Aug 2023 09:38:23 +0000 (UTC)
Received: from redhat.com (unknown [10.42.28.139])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id AC418492C13;
        Mon, 21 Aug 2023 09:38:20 +0000 (UTC)
Date:   Mon, 21 Aug 2023 10:38:18 +0100
From:   Daniel =?utf-8?B?UC4gQmVycmFuZ8Op?= <berrange@redhat.com>
To:     Xiaoyao Li <xiaoyao.li@intel.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Richard Henderson <richard.henderson@linaro.org>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
        Igor Mammedov <imammedo@redhat.com>,
        Ani Sinha <anisinha@redhat.com>, Peter Xu <peterx@redhat.com>,
        David Hildenbrand <david@redhat.com>,
        Philippe =?utf-8?Q?Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
        Cornelia Huck <cohuck@redhat.com>,
        Eric Blake <eblake@redhat.com>,
        Markus Armbruster <armbru@redhat.com>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        Gerd Hoffmann <kraxel@redhat.com>, qemu-devel@nongnu.org,
        kvm@vger.kernel.org, Eduardo Habkost <eduardo@habkost.net>,
        Laszlo Ersek <lersek@redhat.com>,
        Isaku Yamahata <isaku.yamahata@gmail.com>,
        erdemaktas@google.com, Chenyi Qiang <chenyi.qiang@intel.com>
Subject: Re: [PATCH v2 32/58] i386/tdx: Track RAM entries for TDX VM
Message-ID: <ZOMwin3eGaYLNNQh@redhat.com>
Reply-To: Daniel =?utf-8?B?UC4gQmVycmFuZ8Op?= <berrange@redhat.com>
References: <20230818095041.1973309-1-xiaoyao.li@intel.com>
 <20230818095041.1973309-33-xiaoyao.li@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20230818095041.1973309-33-xiaoyao.li@intel.com>
User-Agent: Mutt/2.2.9 (2022-11-12)
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.10
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Aug 18, 2023 at 05:50:15AM -0400, Xiaoyao Li wrote:
> The RAM of TDX VM can be classified into two types:
> 
>  - TDX_RAM_UNACCEPTED: default type of TDX memory, which needs to be
>    accepted by TDX guest before it can be used and will be all-zeros
>    after being accepted.
> 
>  - TDX_RAM_ADDED: the RAM that is ADD'ed to TD guest before running, and
>    can be used directly. E.g., TD HOB and TEMP MEM that needed by TDVF.
> 
> Maintain TdxRamEntries[] which grabs the initial RAM info from e820 table
> and mark each RAM range as default type TDX_RAM_UNACCEPTED.
> 
> Then turn the range of TD HOB and TEMP MEM to TDX_RAM_ADDED since these
> ranges will be ADD'ed before TD runs and no need to be accepted runtime.
> 
> The TdxRamEntries[] are later used to setup the memory TD resource HOB
> that passes memory info from QEMU to TDVF.
> 
> Signed-off-by: Xiaoyao Li <xiaoyao.li@intel.com>
> Acked-by: Gerd Hoffmann <kraxel@redhat.com>
> 
> ---
> Changes from RFC v4:
>   - simplify the algorithm of tdx_accept_ram_range() (Suggested-by: Gerd Hoffman)
>     (1) Change the existing entry to cover the accepted ram range.
>     (2) If there is room before the accepted ram range add a
> 	TDX_RAM_UNACCEPTED entry for that.
>     (3) If there is room after the accepted ram range add a
> 	TDX_RAM_UNACCEPTED entry for that.
> ---
>  target/i386/kvm/tdx.c | 110 ++++++++++++++++++++++++++++++++++++++++++
>  target/i386/kvm/tdx.h |  14 ++++++
>  2 files changed, 124 insertions(+)
> 
> diff --git a/target/i386/kvm/tdx.c b/target/i386/kvm/tdx.c
> index bb806736b4ff..ed617ebab266 100644
> --- a/target/i386/kvm/tdx.c
> +++ b/target/i386/kvm/tdx.c
> +static int tdx_accept_ram_range(uint64_t address, uint64_t length)
> +{
> +    uint64_t head_start, tail_start, head_length, tail_length;
> +    uint64_t tmp_address, tmp_length;
> +    TdxRamEntry *e;
> +    int i;
> +
> +    for (i = 0; i < tdx_guest->nr_ram_entries; i++) {
> +        e = &tdx_guest->ram_entries[i];
> +
> +        if (address + length <= e->address ||
> +            e->address + e->length <= address) {
> +                continue;

Indented too far

> +        }
> +
> +        /*
> +         * The to-be-accepted ram range must be fully contained by one
> +         * RAM entry.
> +         */
> +        if (e->address > address ||
> +            e->address + e->length < address + length) {
> +            return -EINVAL;
> +        }
> +
> +        if (e->type == TDX_RAM_ADDED) {
> +            return -EINVAL;
> +        }
> +
> +        break;
> +    }
> +
> +    if (i == tdx_guest->nr_ram_entries) {
> +        return -1;
> +    }
> +
> +    tmp_address = e->address;
> +    tmp_length = e->length;
> +
> +    e->address = address;
> +    e->length = length;
> +    e->type = TDX_RAM_ADDED;
> +
> +    head_length = address - tmp_address;
> +    if (head_length > 0) {
> +        head_start = tmp_address;
> +        tdx_add_ram_entry(head_start, head_length, TDX_RAM_UNACCEPTED);
> +    }
> +
> +    tail_start = address + length;
> +    if (tail_start < tmp_address + tmp_length) {
> +        tail_length = tmp_address + tmp_length - tail_start;
> +        tdx_add_ram_entry(tail_start, tail_length, TDX_RAM_UNACCEPTED);
> +    }
> +
> +    return 0;
> +}

With regards,
Daniel
-- 
|: https://berrange.com      -o-    https://www.flickr.com/photos/dberrange :|
|: https://libvirt.org         -o-            https://fstop138.berrange.com :|
|: https://entangle-photo.org    -o-    https://www.instagram.com/dberrange :|

