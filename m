Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F401F5A25EA
	for <lists+kvm@lfdr.de>; Fri, 26 Aug 2022 12:36:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343655AbiHZKea (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 26 Aug 2022 06:34:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46172 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231664AbiHZKe3 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 26 Aug 2022 06:34:29 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0F694D2914
        for <kvm@vger.kernel.org>; Fri, 26 Aug 2022 03:34:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1661510068;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=Ck4pyqa0p1LfNT86jStkgkXQVN7v/2Id4bBpyjnzAEk=;
        b=FeB9I5mDzDkAgghONoPRDEBM8YZYHnkXQjZDqS9rYh0NTQichQcEdVrzU1z7d99lk9sPFa
        VMdA9SyWbu+V0wlCLpPcCFOzin8l35wJCwIe7Ivick3IuaMavtM+xiHxPdCEXwYJ2E9kIx
        8a/yhvyc0sP0Ap5b7dKqrQm8Cvo1TdY=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-12-bZRuzE8dOGmFYjgLQ16kVQ-1; Fri, 26 Aug 2022 06:34:22 -0400
X-MC-Unique: bZRuzE8dOGmFYjgLQ16kVQ-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com [10.11.54.7])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 83CFC3C1015C;
        Fri, 26 Aug 2022 10:34:21 +0000 (UTC)
Received: from sirius.home.kraxel.org (unknown [10.39.195.82])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 2BE79141510F;
        Fri, 26 Aug 2022 10:34:21 +0000 (UTC)
Received: by sirius.home.kraxel.org (Postfix, from userid 1000)
        id 8746818009AB; Fri, 26 Aug 2022 12:34:19 +0200 (CEST)
Date:   Fri, 26 Aug 2022 12:34:19 +0200
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
Subject: Re: [PATCH v1 38/40] i386/tdx: Skip kvm_put_apicbase() for TDs
Message-ID: <20220826103419.obrgioi7yebrncmr@sirius.home.kraxel.org>
References: <20220802074750.2581308-1-xiaoyao.li@intel.com>
 <20220802074750.2581308-39-xiaoyao.li@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220802074750.2581308-39-xiaoyao.li@intel.com>
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.7
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Aug 02, 2022 at 03:47:48PM +0800, Xiaoyao Li wrote:
> KVM doesn't allow wirting to MSR_IA32_APICBASE for TDs.
> 
> Signed-off-by: Xiaoyao Li <xiaoyao.li@intel.com>

Acked-by: Gerd Hoffmann <kraxel@redhat.com>

