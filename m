Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EAC9E5A23EE
	for <lists+kvm@lfdr.de>; Fri, 26 Aug 2022 11:17:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245276AbiHZJQM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 26 Aug 2022 05:16:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40184 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245463AbiHZJQH (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 26 Aug 2022 05:16:07 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 35C50C9E8D
        for <kvm@vger.kernel.org>; Fri, 26 Aug 2022 02:16:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1661505366;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=8kQ/eyPbluffEJuq7fg90Ws5mV8WwQN8C264MWbZ3XA=;
        b=gR8WMzOO7Fe7LemBknonEUvY/j0KHXVNivSWunRyWEbcjqr5ODBUHxmwFLZHnV8tm9Fu9X
        YBciqpoyrCSqR7Z6WvJX3XSxlfn1cyAEiUHD6KHZwFF+L71liua0FUI1LmG3AGyJ0fiVSI
        edlMtZke5sio4TNjZr38Yq6fqKBJfzI=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-599-4rGAbZ-9MRKRyYjw_BDLvg-1; Fri, 26 Aug 2022 05:16:01 -0400
X-MC-Unique: 4rGAbZ-9MRKRyYjw_BDLvg-1
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com [10.11.54.9])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 4CE6A8032F6;
        Fri, 26 Aug 2022 09:16:00 +0000 (UTC)
Received: from sirius.home.kraxel.org (unknown [10.39.195.82])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 0D58D492CA2;
        Fri, 26 Aug 2022 09:16:00 +0000 (UTC)
Received: by sirius.home.kraxel.org (Postfix, from userid 1000)
        id B41911800627; Fri, 26 Aug 2022 11:15:58 +0200 (CEST)
Date:   Fri, 26 Aug 2022 11:15:58 +0200
From:   Gerd Hoffmann <kraxel@redhat.com>
To:     Xiaoyao Li <xiaoyao.li@intel.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Isaku Yamahata <isaku.yamahata@gmail.com>,
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
Subject: Re: [PATCH v1 25/40] i386/tdx: Track RAM entries for TDX VM
Message-ID: <20220826091558.qqn4uknuydzc2gdd@sirius.home.kraxel.org>
References: <20220802074750.2581308-1-xiaoyao.li@intel.com>
 <20220802074750.2581308-26-xiaoyao.li@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220802074750.2581308-26-xiaoyao.li@intel.com>
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.9
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Aug 02, 2022 at 03:47:35PM +0800, Xiaoyao Li wrote:
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

Acked-by: Gerd Hoffmann <kraxel@redhat.com>

