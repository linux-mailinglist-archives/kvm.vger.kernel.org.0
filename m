Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 31F935A25E7
	for <lists+kvm@lfdr.de>; Fri, 26 Aug 2022 12:33:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343744AbiHZKdm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 26 Aug 2022 06:33:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45416 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245187AbiHZKdl (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 26 Aug 2022 06:33:41 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A53D2D34FE
        for <kvm@vger.kernel.org>; Fri, 26 Aug 2022 03:33:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1661510016;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=sIFfMhXmGMx4loY9a20XNiNxHtuX6k/wt1gOXHdsKWk=;
        b=Y0itall9Ghy/2/tlMHlVdnvXG9SIBhwqWc8GlBzeW5HwDwyNFgtatzb9OTZrDaDNcH3jjE
        E15oQ/w6DIWk3OFetoi3KPjl4X/gFD1ULvgklpxJ8M07/kK5EzdNFdvUi4ab/MZmx39P9a
        4wi5eDB5/UMUAhXZNdRlCuIoB/VLuWk=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-271-pafKijuQOj62tMbuVIWv-A-1; Fri, 26 Aug 2022 06:33:33 -0400
X-MC-Unique: pafKijuQOj62tMbuVIWv-A-1
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com [10.11.54.9])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 2F0183826253;
        Fri, 26 Aug 2022 10:33:33 +0000 (UTC)
Received: from sirius.home.kraxel.org (unknown [10.39.195.82])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id E4E78492C3B;
        Fri, 26 Aug 2022 10:33:32 +0000 (UTC)
Received: by sirius.home.kraxel.org (Postfix, from userid 1000)
        id 519EC18009AB; Fri, 26 Aug 2022 12:33:26 +0200 (CEST)
Date:   Fri, 26 Aug 2022 12:33:26 +0200
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
Subject: Re: [PATCH v1 36/40] i386/tdx: Don't synchronize guest tsc for TDs
Message-ID: <20220826103326.cruxszxwfuvcpg2s@sirius.home.kraxel.org>
References: <20220802074750.2581308-1-xiaoyao.li@intel.com>
 <20220802074750.2581308-37-xiaoyao.li@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220802074750.2581308-37-xiaoyao.li@intel.com>
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

On Tue, Aug 02, 2022 at 03:47:46PM +0800, Xiaoyao Li wrote:
> From: Isaku Yamahata <isaku.yamahata@intel.com>
> 
> TSC of TDs is not accessible and KVM doesn't allow access of
> MSR_IA32_TSC for TDs. To avoid the assert() in kvm_get_tsc, make
> kvm_synchronize_all_tsc() noop for TDs,
> 
> Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
> Reviewed-by: Connor Kuehl <ckuehl@redhat.com>
> Signed-off-by: Xiaoyao Li <xiaoyao.li@intel.com>

Acked-by: Gerd Hoffmann <kraxel@redhat.com>

