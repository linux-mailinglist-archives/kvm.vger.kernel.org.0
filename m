Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1464D539EC3
	for <lists+kvm@lfdr.de>; Wed,  1 Jun 2022 09:55:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241600AbiFAHzL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 1 Jun 2022 03:55:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48432 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347816AbiFAHzD (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 1 Jun 2022 03:55:03 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id E432093451
        for <kvm@vger.kernel.org>; Wed,  1 Jun 2022 00:55:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1654070100;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=ektNvZ5f4NVTyT0W6eboUrdKdy7sGj8EOeyn5QtPw8I=;
        b=SvmznhHyeaxTUWWlL5Z3dZpXaoCA4XNc0R7YGJ2aB+vTVAz7UDQt5MmKHZNha4n7erXTOB
        6agXnTXvJRNgQufjWWbsjaMmIl+3GQwYlekdPLf+8a5lTEjXcyUbUJWAwgFJgjib/cvqK2
        LDZ3nFoIbzeF1DteBUwWMl88/UscfZo=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-154-Psw_Tb8pP9ek7Jym9Wwc0A-1; Wed, 01 Jun 2022 03:54:55 -0400
X-MC-Unique: Psw_Tb8pP9ek7Jym9Wwc0A-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com [10.11.54.3])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 2C776801E80;
        Wed,  1 Jun 2022 07:54:55 +0000 (UTC)
Received: from sirius.home.kraxel.org (unknown [10.39.192.104])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id B728B1121314;
        Wed,  1 Jun 2022 07:54:54 +0000 (UTC)
Received: by sirius.home.kraxel.org (Postfix, from userid 1000)
        id 0DB321800623; Wed,  1 Jun 2022 09:54:53 +0200 (CEST)
Date:   Wed, 1 Jun 2022 09:54:53 +0200
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
Message-ID: <20220601075453.7qyd5z22ejgp37iz@sirius.home.kraxel.org>
References: <20220512031803.3315890-1-xiaoyao.li@intel.com>
 <20220512031803.3315890-12-xiaoyao.li@intel.com>
 <20220523092003.lm4vzfpfh4ezfcmy@sirius.home.kraxel.org>
 <d3e967f3-917f-27ce-1367-2dba23e5c241@intel.com>
 <20220524065719.wyyoba2ke73tx3nc@sirius.home.kraxel.org>
 <39341481-67b6-aba4-a25a-10abb398bec4@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <39341481-67b6-aba4-a25a-10abb398bec4@intel.com>
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.3
X-Spam-Status: No, score=-2.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Jun 01, 2022 at 03:20:46PM +0800, Xiaoyao Li wrote:
> On 5/24/2022 2:57 PM, Gerd Hoffmann wrote:
> >    Hi,
> > Maybe it's a bit more work to add VM-scope initialization support to
> > qemu.
> 
> If just introducing VM-scope initialization to QEMU, it would be easy. What
> matters is what needs to be done inside VM-scope initialization.
> 
> For TDX, we need to settle down the features that configured for the TD.
> Typically, the features are attributes of cpu object, parsed from "-cpu"
> option and stored in cpu object.

> 2) create a CPU object when initializing machine object and collect all the
> info from "-cpu" and drop it in the end; then why not do it when creating
> 1st vcpu like this patch.

Do VM-scope tdx initialization late enough that cpu objects are already
created at that point, so you can collect the info you need without a
dummy cpu?

I guess it could be helpful for the discussion when you can outine the
'big picture' for tdx initialization.  How does kvm accel setup look
like without TDX, and what additional actions are needed for TDX?  What
ordering requirements and other constrains exist?

take care,
  Gerd

