Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B2F765324E8
	for <lists+kvm@lfdr.de>; Tue, 24 May 2022 10:06:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230439AbiEXIGZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 24 May 2022 04:06:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58294 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230170AbiEXIF7 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 24 May 2022 04:05:59 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id A4E9393468
        for <kvm@vger.kernel.org>; Tue, 24 May 2022 01:05:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1653379555;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=p1ApjFFAVOLjqbDsOMVHTwr38YXUn42zoJ+sAI4Jjjk=;
        b=V5TR15V0BVHW6Dco8wPkmKPvvAauPU3KZ1Z+F1vjPCL96XKzIazkC4Jcc5P9ZaPuT6YZ+a
        7rYqyqgBBX97KcVNDmCilKxxAuQ1dBj10bL8yrTkkJa2J+7hYKyWuwbR2WSPZTsOaNz7V9
        6KgB34BHmxHU7kxS5CzPWn5cm9KQmhE=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-510-ReE-LsV8OZ-IX1gEC4soQA-1; Tue, 24 May 2022 04:05:52 -0400
X-MC-Unique: ReE-LsV8OZ-IX1gEC4soQA-1
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com [10.11.54.10])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id C2ECD8339A2;
        Tue, 24 May 2022 08:05:51 +0000 (UTC)
Received: from sirius.home.kraxel.org (unknown [10.39.192.41])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 8F7A0401E74;
        Tue, 24 May 2022 08:05:51 +0000 (UTC)
Received: by sirius.home.kraxel.org (Postfix, from userid 1000)
        id 1CEC81800393; Tue, 24 May 2022 10:05:50 +0200 (CEST)
Date:   Tue, 24 May 2022 10:05:50 +0200
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
Subject: Re: [RFC PATCH v4 33/36] i386/tdx: Only configure MSR_IA32_UCODE_REV
 in kvm_init_msrs() for TDs
Message-ID: <20220524080550.xe7ymb22jpdx23ee@sirius.home.kraxel.org>
References: <20220512031803.3315890-1-xiaoyao.li@intel.com>
 <20220512031803.3315890-34-xiaoyao.li@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220512031803.3315890-34-xiaoyao.li@intel.com>
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.10
X-Spam-Status: No, score=-3.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, May 12, 2022 at 11:18:00AM +0800, Xiaoyao Li wrote:
> For TDs, only MSR_IA32_UCODE_REV in kvm_init_msrs() can be configured
> by VMM, while the features enumerated/controlled by other MSRs except
> MSR_IA32_UCODE_REV in kvm_init_msrs() are not under control of VMM.
> 
> Only configure MSR_IA32_UCODE_REV for TDs.

Acked-by: Gerd Hoffmann <kraxel@redhat.com>

