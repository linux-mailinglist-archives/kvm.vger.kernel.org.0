Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BA6C44E5FCA
	for <lists+kvm@lfdr.de>; Thu, 24 Mar 2022 08:58:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242400AbiCXIAU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 24 Mar 2022 04:00:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46476 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240437AbiCXIAT (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 24 Mar 2022 04:00:19 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id E7874140FF
        for <kvm@vger.kernel.org>; Thu, 24 Mar 2022 00:58:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1648108727;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=dPeLp0k+vrmKTVazNwKW4gd0GBb4zvPxGzXIEkvw4mE=;
        b=id/GMxgidDbdx/wLeHk3/m/PDAOyYUXSomIYY/v7yG4dbnpiHx0/R3tT6grLZ+DiyO7gis
        XeptJYmRCUGTR43aGmLNvwozLYEAMTBUSAb+TFlsPhNtCf9v+Bs4mFvu6DNuO+csrHgWEf
        ugnaTsQyQ4ioPRkhoCVn4bLpmSNdX10=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-319-HBxkaEeaO8Sbv9VOTniVfA-1; Thu, 24 Mar 2022 03:58:44 -0400
X-MC-Unique: HBxkaEeaO8Sbv9VOTniVfA-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com [10.11.54.1])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 70A773810D36;
        Thu, 24 Mar 2022 07:58:43 +0000 (UTC)
Received: from sirius.home.kraxel.org (unknown [10.39.196.67])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 3210440CF8ED;
        Thu, 24 Mar 2022 07:58:43 +0000 (UTC)
Received: by sirius.home.kraxel.org (Postfix, from userid 1000)
        id C086418000AA; Thu, 24 Mar 2022 08:58:41 +0100 (CET)
Date:   Thu, 24 Mar 2022 08:58:41 +0100
From:   Gerd Hoffmann <kraxel@redhat.com>
To:     Xiaoyao Li <xiaoyao.li@intel.com>
Cc:     Daniel =?utf-8?B?UC4gQmVycmFuZ8Op?= <berrange@redhat.com>,
        Philippe =?utf-8?Q?Mathieu-Daud=C3=A9?= 
        <philippe.mathieu.daude@gmail.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Philippe =?utf-8?Q?Mathieu-Daud=C3=A9?= <f4bug@amsat.org>,
        Richard Henderson <richard.henderson@linaro.org>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        Laszlo Ersek <lersek@redhat.com>,
        Eric Blake <eblake@redhat.com>,
        Connor Kuehl <ckuehl@redhat.com>, isaku.yamahata@intel.com,
        erdemaktas@google.com, kvm@vger.kernel.org, qemu-devel@nongnu.org,
        seanjc@google.com
Subject: Re: [RFC PATCH v3 17/36] pflash_cfi01/tdx: Introduce ram_mode of
 pflash for TDVF
Message-ID: <20220324075841.6ywj6eboeyep2sz2@sirius.home.kraxel.org>
References: <20220317135913.2166202-1-xiaoyao.li@intel.com>
 <20220317135913.2166202-18-xiaoyao.li@intel.com>
 <f418548e-c24c-1bc3-4e16-d7a775298a18@gmail.com>
 <7a8233e4-0cae-b05a-7931-695a7ee87fc9@intel.com>
 <20220322092141.qsgv3pqlvlemgrgw@sirius.home.kraxel.org>
 <YjmXFZRCbKXTkAhN@redhat.com>
 <e7fb2eab-b2b1-dd0e-4821-4cca40751d15@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e7fb2eab-b2b1-dd0e-4821-4cca40751d15@intel.com>
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.1
X-Spam-Status: No, score=-3.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

  Hi,

> > > Well, if persistent vars are not supported anyway there is little reason
> > > to split the firmware into CODE and VARS files.  You can use just use
> > > OVMF.fd with a single pflash device.  libvirt recently got support for
> > > that.
> > 
> > Agreed.
> 
> The purpose of using split firmware is that people can share the same
> code.fd while using different vars.fd

Using different vars.fd files is pointless though when changes are never
written back ...

take care,
  Gerd

