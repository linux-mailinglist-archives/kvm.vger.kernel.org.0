Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E09BE5A0F11
	for <lists+kvm@lfdr.de>; Thu, 25 Aug 2022 13:29:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241574AbiHYL3N (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 25 Aug 2022 07:29:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42618 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241489AbiHYL3K (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 25 Aug 2022 07:29:10 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 45F99AF0F1
        for <kvm@vger.kernel.org>; Thu, 25 Aug 2022 04:29:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1661426949;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=OtGUKnZ/fNP3L/9UxFQ5OgIHUUObTzF059y+JT2zWmo=;
        b=EQiSqH12rKtNeQvARCu+CFG7WpNtHOOqipE6FVejyxqx8N5t7qMVUYZJlMZeXMbQwSOsC1
        n4z+8odEXMIpi7mAiSk+csOpKfuFcBBlXERR6gc1bADWcZKG9JbV/OLyS2qUHFJuRmbmex
        F6Yygns0rEuAPge1J0XFVmgeBaNCkhg=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-20-ycnmSfs6MtCMqTgnxH-NRg-1; Thu, 25 Aug 2022 07:29:05 -0400
X-MC-Unique: ycnmSfs6MtCMqTgnxH-NRg-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com [10.11.54.5])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 5F4468039BB;
        Thu, 25 Aug 2022 11:29:02 +0000 (UTC)
Received: from sirius.home.kraxel.org (unknown [10.39.195.82])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 20DE9945DF;
        Thu, 25 Aug 2022 11:29:02 +0000 (UTC)
Received: by sirius.home.kraxel.org (Postfix, from userid 1000)
        id DE685180039D; Thu, 25 Aug 2022 13:29:00 +0200 (CEST)
Date:   Thu, 25 Aug 2022 13:29:00 +0200
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
Subject: Re: [PATCH v1 14/40] i386/tdx: Initialize TDX before creating TD
 vcpus
Message-ID: <20220825112900.6ekzk6gdbourjbew@sirius.home.kraxel.org>
References: <20220802074750.2581308-1-xiaoyao.li@intel.com>
 <20220802074750.2581308-15-xiaoyao.li@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220802074750.2581308-15-xiaoyao.li@intel.com>
X-Scanned-By: MIMEDefang 2.79 on 10.11.54.5
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Aug 02, 2022 at 03:47:24PM +0800, Xiaoyao Li wrote:
> Invoke KVM_TDX_INIT in kvm_arch_pre_create_vcpu() that KVM_TDX_INIT
> configures global TD state, e.g. the canonical CPUID config, and must
> be executed prior to creating vCPUs.
> 
> Use kvm_x86_arch_cpuid() to setup the CPUID settings for TDX VM and
> tie x86cpu->enable_pmu with TD's attributes.
> 
> Note, this doesn't address the fact that QEMU may change the CPUID
> configuration when creating vCPUs, i.e. punts on refactoring QEMU to
> provide a stable CPUID config prior to kvm_arch_init().

Acked-by: Gerd Hoffmann <kraxel@redhat.com>

