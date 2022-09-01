Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CA9F15A9CEE
	for <lists+kvm@lfdr.de>; Thu,  1 Sep 2022 18:18:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234995AbiIAQRv (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 1 Sep 2022 12:17:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58462 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234975AbiIAQRu (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 1 Sep 2022 12:17:50 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E2E489411B
        for <kvm@vger.kernel.org>; Thu,  1 Sep 2022 09:17:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1662049068;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=hedP1nanSg0nfEVRoW3l9wkxR5Nom5Xm3VIc4gzSbyI=;
        b=PqEioV2veOw0bFOtJchtrNJzCiZ7/32szNZkpDsK9wVdOV1NBh1PyZlWGbV9cHlqiD7nEc
        5sMH6KVgUHp72VBa4Md3mUa3Jg6nUDOuFL+i7D89yqqUSoQCPnakiyaOQHqehjPjeC2vUP
        ktE898XMFr23kNwZPfT+vDOrOsbmDBo=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-471-XbIq98NtP9KElR6TTclKsA-1; Thu, 01 Sep 2022 12:17:45 -0400
X-MC-Unique: XbIq98NtP9KElR6TTclKsA-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com [10.11.54.1])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 3AF30811E80;
        Thu,  1 Sep 2022 16:17:43 +0000 (UTC)
Received: from sirius.home.kraxel.org (unknown [10.39.195.70])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id E662840CF8F2;
        Thu,  1 Sep 2022 16:17:42 +0000 (UTC)
Received: by sirius.home.kraxel.org (Postfix, from userid 1000)
        id A29AF18003AA; Thu,  1 Sep 2022 18:17:41 +0200 (CEST)
Date:   Thu, 1 Sep 2022 18:17:41 +0200
From:   Gerd Hoffmann <kraxel@redhat.com>
To:     Xiaoyao Li <xiaoyao.li@intel.com>
Cc:     qemu-devel@nongnu.org, kvm@vger.kernel.org,
        Marcelo Tosatti <mtosatti@redhat.com>,
        Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
        Eduardo Habkost <eduardo@habkost.net>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Richard Henderson <richard.henderson@linaro.org>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Sergio Lopez <slp@redhat.com>
Subject: Re: [PATCH 0/2] expose host-phys-bits to guest
Message-ID: <20220901161741.dadmguwv25sk4h6i@sirius.home.kraxel.org>
References: <20220831125059.170032-1-kraxel@redhat.com>
 <957f0cc5-6887-3861-2b80-69a8c7cdd098@intel.com>
 <20220901135810.6dicz4grhz7ye2u7@sirius.home.kraxel.org>
 <f7a56158-9920-e753-4d21-e1bcc3573e27@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f7a56158-9920-e753-4d21-e1bcc3573e27@intel.com>
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.1
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Sep 01, 2022 at 10:36:19PM +0800, Xiaoyao Li wrote:
> On 9/1/2022 9:58 PM, Gerd Hoffmann wrote:
> 
> > > Anyway, IMO, guest including guest firmware, should always consult from
> > > CPUID leaf 0x80000008 for physical address length.
> > 
> > It simply can't for the reason outlined above.  Even if we fix qemu
> > today that doesn't solve the problem for the firmware because we want
> > backward compatibility with older qemu versions.  Thats why I want the
> > extra bit which essentially says "CPUID leaf 0x80000008 actually works".
> 
> I don't understand how it backward compatible with older qemu version. Old
> QEMU won't set the extra bit you introduced in this series, and all the
> guest created with old QEMU will become untrusted on CPUID leaf 0x80000008 ?

Correct, on old qemu firmware will not trust CPUID leaf 0x80000008.
That is not worse than the situation we have today, currently the
firmware never trusts CPUID leaf 0x80000008.

So the patches will improves the situation for new qemu only, but I
don't see a way around that.

take care,
  Gerd

