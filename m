Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7FC9053FD37
	for <lists+kvm@lfdr.de>; Tue,  7 Jun 2022 13:17:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242737AbiFGLRb (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 7 Jun 2022 07:17:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57982 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242735AbiFGLRJ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 7 Jun 2022 07:17:09 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 2AE79396B2
        for <kvm@vger.kernel.org>; Tue,  7 Jun 2022 04:16:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1654600617;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=s6D+tDPL1+VIqSmAaw2F3EdpteVx9cYLBbOFIaNeFvc=;
        b=RwRUhrUsC9i2jpnApM4zKbrOcQ3ia66jY94VoPgCY2y8FnA8wZH8g8Qm2Y1A7vEP6GaHvi
        CBmsPis0GiecZAuaPi5xPateYwX/mGFwLa6X9nM/y+vTQa0K3ASpEy0cgH5CafqZMuYQc2
        4d25sj00zrj9JvehATBPIw0VEQ7zUnk=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-235-TQfqeU4POKqoplHVLhA46g-1; Tue, 07 Jun 2022 07:16:54 -0400
X-MC-Unique: TQfqeU4POKqoplHVLhA46g-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com [10.11.54.5])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id E4C89101A54E;
        Tue,  7 Jun 2022 11:16:53 +0000 (UTC)
Received: from sirius.home.kraxel.org (unknown [10.39.192.40])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 953CA82882;
        Tue,  7 Jun 2022 11:16:53 +0000 (UTC)
Received: by sirius.home.kraxel.org (Postfix, from userid 1000)
        id AB5141800081; Tue,  7 Jun 2022 13:16:51 +0200 (CEST)
Date:   Tue, 7 Jun 2022 13:16:51 +0200
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
Subject: Re: [RFC PATCH v4 11/36] i386/tdx: Initialize TDX before creating TD
 vcpus
Message-ID: <20220607111651.2zjm7mx2gz3irqxo@sirius.home.kraxel.org>
References: <20220512031803.3315890-1-xiaoyao.li@intel.com>
 <20220512031803.3315890-12-xiaoyao.li@intel.com>
 <20220523092003.lm4vzfpfh4ezfcmy@sirius.home.kraxel.org>
 <d3e967f3-917f-27ce-1367-2dba23e5c241@intel.com>
 <20220524065719.wyyoba2ke73tx3nc@sirius.home.kraxel.org>
 <39341481-67b6-aba4-a25a-10abb398bec4@intel.com>
 <20220601075453.7qyd5z22ejgp37iz@sirius.home.kraxel.org>
 <9d00fd58-b957-3b8e-22ab-12214dcbbe97@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <9d00fd58-b957-3b8e-22ab-12214dcbbe97@intel.com>
X-Scanned-By: MIMEDefang 2.79 on 10.11.54.5
X-Spam-Status: No, score=-3.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

  Hi,

> > I guess it could be helpful for the discussion when you can outine the
> > 'big picture' for tdx initialization.  How does kvm accel setup look
> > like without TDX, and what additional actions are needed for TDX?  What
> > ordering requirements and other constrains exist?
> 
> To boot a TDX VM, it requires several changes/additional steps in the flow:
> 
>  1. specify the vm type KVM_X86_TDX_VM when creating VM with
>     IOCTL(KVM_CREATE_VM);
> 	- When initializing KVM accel
> 
>  2. initialize VM scope configuration before creating any VCPU;
> 
>  3. initialize VCPU scope configuration;
> 	- done inside machine_init_done_notifier;
> 
>  4. initialize virtual firmware in guest private memory before vcpu running;
> 	- done inside machine_init_done_notifier;
> 
>  5. finalize the TD's measurement;
> 	- done inside machine init_done_notifier;
> 
> 
> And we are discussing where to do step 2).
> 
> We can find from the code of tdx_pre_create_vcpu(), that it needs
> cpuid entries[] and attributes as input to KVM.
> 
>   cpuid entries[] is set up by kvm_x86_arch_cpuid() mainly based on
>   'CPUX86State *env'
> 
>   attributes.pks is retrieved from env->features[]
>   and attributes.pmu is retrieved from x86cpu->enable_pmu
> 
> to make VM-socpe data is consistent with VCPU data, we do choose the point
> late enough to ensure all the info/configurations from VCPU are settle down,
> that just before calling KVM API to do VCPU-scope configuration.

So essentially tdx defines (some) vcpu properties at vm scope?  Given
that all vcpus typically identical (and maybe tdx even enforces this)
this makes sense.

A comment in the source code explaining this would be good.

thanks,
  Gerd

