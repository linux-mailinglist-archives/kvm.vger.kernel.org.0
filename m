Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6A12953236D
	for <lists+kvm@lfdr.de>; Tue, 24 May 2022 08:42:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233321AbiEXGmq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 24 May 2022 02:42:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45814 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229945AbiEXGmn (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 24 May 2022 02:42:43 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id A99866C567
        for <kvm@vger.kernel.org>; Mon, 23 May 2022 23:42:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1653374561;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=ZcCP2qAVtg+8ALVdH43HRFvkEtv7/fw48ULRdMeMgoY=;
        b=Cn6AD9x04BgEgtyCvrhlbTCm2ZRVWBgpXWtutPaWGXBtFutaEkHF2CIKnKfWBc6ceQ7VJk
        a4va/f3bnxLwuv4q1WhbaDc/TKXpglQSlCLaEKboPDaroFnbipgzojNN/OJK6gdgt+oIVR
        NFDYeeadlvDUW3aTpS8qrmwPljP0agI=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-493-kmOAKuvwPsGRXcKAgKCm5g-1; Tue, 24 May 2022 02:42:38 -0400
X-MC-Unique: kmOAKuvwPsGRXcKAgKCm5g-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id D5492811E75;
        Tue, 24 May 2022 06:42:37 +0000 (UTC)
Received: from sirius.home.kraxel.org (unknown [10.39.192.41])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 92B1540D1B98;
        Tue, 24 May 2022 06:42:37 +0000 (UTC)
Received: by sirius.home.kraxel.org (Postfix, from userid 1000)
        id 1B6B81800393; Tue, 24 May 2022 08:42:36 +0200 (CEST)
Date:   Tue, 24 May 2022 08:42:36 +0200
From:   Gerd Hoffmann <kraxel@redhat.com>
To:     Isaku Yamahata <isaku.yamahata@gmail.com>
Cc:     Xiaoyao Li <xiaoyao.li@intel.com>,
        Paolo Bonzini <pbonzini@redhat.com>, isaku.yamahata@intel.com,
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
Subject: Re: [RFC PATCH v4 07/36] i386/tdx: Introduce is_tdx_vm() helper and
 cache tdx_guest object
Message-ID: <20220524064236.aptmlagzqgrexeka@sirius.home.kraxel.org>
References: <20220512031803.3315890-1-xiaoyao.li@intel.com>
 <20220512031803.3315890-8-xiaoyao.li@intel.com>
 <20220523084817.ydle4f4acsoppbgr@sirius.home.kraxel.org>
 <20220523145944.GB3095181@ls.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220523145944.GB3095181@ls.amr.corp.intel.com>
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.2
X-Spam-Status: No, score=-3.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> > > +#ifdef CONFIG_TDX
> > > +bool is_tdx_vm(void);
> > > +#else
> > > +#define is_tdx_vm() 0
> > 
> > Just add that to the tdx-stubs.c file you already created in one of the
> > previous patches and drop this #ifdef mess ;)
> 
> This is for consistency with SEV.  Anyway Either way is okay.

> From target/i386/sev.h
>   ...
>   #ifdef CONFIG_SEV
>   bool sev_enabled(void);
>   bool sev_es_enabled(void);
>   #else
>   #define sev_enabled() 0
>   #define sev_es_enabled() 0
>   #endif

Hmm, not sure why sev did it this way.  One possible reason is that the
compiler optimizer can see sev_enabled() evaluates to 0 and throw away
the dead code branches then.

So, yes, maybe it makes sense to stick to the #ifdef in this specific
case.

take care,
  Gerd

