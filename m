Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A2140530E0A
	for <lists+kvm@lfdr.de>; Mon, 23 May 2022 12:43:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232865AbiEWJUN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 23 May 2022 05:20:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39972 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232840AbiEWJUL (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 23 May 2022 05:20:11 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id D3AFD47AD6
        for <kvm@vger.kernel.org>; Mon, 23 May 2022 02:20:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1653297609;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=2WssiX03mpBVHdBN+acen/ASZgo748LXbRvBIixfV0I=;
        b=Up9pi1ruF90HmStn4B5ujx9VQ0NmgaeqDYZ4q4hdfN4CXwTp4y7w8wsPjuv1hCCmT6mlVJ
        mLbStFlUgYZp8TNNFBWbHVJjx3Ged3LujvgW+Kq0yux07hXnd+g6ktlmX7F8+ev30GVhGA
        n3w7FkCV8xsNTe+Y73CyAnpJy2dvun0=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-616-MYPFSuCOOGaWgaaAtYjTQQ-1; Mon, 23 May 2022 05:20:06 -0400
X-MC-Unique: MYPFSuCOOGaWgaaAtYjTQQ-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com [10.11.54.8])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 073D7101AA42;
        Mon, 23 May 2022 09:20:06 +0000 (UTC)
Received: from sirius.home.kraxel.org (unknown [10.39.192.41])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id C7E55C27E97;
        Mon, 23 May 2022 09:20:05 +0000 (UTC)
Received: by sirius.home.kraxel.org (Postfix, from userid 1000)
        id AE71418000B4; Mon, 23 May 2022 11:20:03 +0200 (CEST)
Date:   Mon, 23 May 2022 11:20:03 +0200
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
Subject: Re: [RFC PATCH v4 11/36] i386/tdx: Initialize TDX before creating TD
 vcpus
Message-ID: <20220523092003.lm4vzfpfh4ezfcmy@sirius.home.kraxel.org>
References: <20220512031803.3315890-1-xiaoyao.li@intel.com>
 <20220512031803.3315890-12-xiaoyao.li@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220512031803.3315890-12-xiaoyao.li@intel.com>
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.8
X-Spam-Status: No, score=-3.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> +int tdx_pre_create_vcpu(CPUState *cpu)
> +{
> +    MachineState *ms = MACHINE(qdev_get_machine());
> +    X86CPU *x86cpu = X86_CPU(cpu);
> +    CPUX86State *env = &x86cpu->env;
> +    struct kvm_tdx_init_vm init_vm;
> +    int r = 0;
> +
> +    qemu_mutex_lock(&tdx_guest->lock);
> +    if (tdx_guest->initialized) {
> +        goto out;
> +    }
> +
> +    memset(&init_vm, 0, sizeof(init_vm));
> +    init_vm.cpuid.nent = kvm_x86_arch_cpuid(env, init_vm.entries, 0);
> +
> +    init_vm.attributes = tdx_guest->attributes;
> +    init_vm.max_vcpus = ms->smp.cpus;
> +
> +    r = tdx_vm_ioctl(KVM_TDX_INIT_VM, 0, &init_vm);
> +    if (r < 0) {
> +        error_report("KVM_TDX_INIT_VM failed %s", strerror(-r));
> +        goto out;
> +    }
> +
> +    tdx_guest->initialized = true;
> +
> +out:
> +    qemu_mutex_unlock(&tdx_guest->lock);
> +    return r;
> +}

Hmm, hooking *vm* initialization into *vcpu* creation looks wrong to me.

take care,
  Gerd

