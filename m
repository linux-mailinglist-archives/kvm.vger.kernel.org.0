Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 187575324B2
	for <lists+kvm@lfdr.de>; Tue, 24 May 2022 10:00:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233763AbiEXIAa (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 24 May 2022 04:00:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46566 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232635AbiEXIA2 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 24 May 2022 04:00:28 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 191A77628F
        for <kvm@vger.kernel.org>; Tue, 24 May 2022 01:00:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1653379227;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=Dxmtmp+YugjvDTDuqYei2bCuEkYm4yjkMTf0k4bzXIM=;
        b=a8pW1ucuxFTfMPx3INLNQJlPQ6n10imclQj1b/SQu86zzr2upW5Sj1/wKFphmem2PNefLY
        4iJGDnCMea284OH1CQCqaNqehEcTW7ThrAsVVMteHvw13Fj7Mh8/3a7u2Ef9IN0HetPGQk
        tKnUmxakW8MtpFqSZfguk6jVjpqudTo=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-596--KOPGuv7PHaCglFni5-Wpg-1; Tue, 24 May 2022 04:00:23 -0400
X-MC-Unique: -KOPGuv7PHaCglFni5-Wpg-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com [10.11.54.8])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id DA5E21C05138;
        Tue, 24 May 2022 08:00:22 +0000 (UTC)
Received: from sirius.home.kraxel.org (unknown [10.39.192.41])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 80317C27E8E;
        Tue, 24 May 2022 08:00:22 +0000 (UTC)
Received: by sirius.home.kraxel.org (Postfix, from userid 1000)
        id D82B91800393; Tue, 24 May 2022 10:00:20 +0200 (CEST)
Date:   Tue, 24 May 2022 10:00:20 +0200
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
Subject: Re: [RFC PATCH v4 27/36] i386/tdx: Disable SMM for TDX VMs
Message-ID: <20220524080020.frxwwsd73lgqm4u5@sirius.home.kraxel.org>
References: <20220512031803.3315890-1-xiaoyao.li@intel.com>
 <20220512031803.3315890-28-xiaoyao.li@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220512031803.3315890-28-xiaoyao.li@intel.com>
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

On Thu, May 12, 2022 at 11:17:54AM +0800, Xiaoyao Li wrote:
> TDX doesn't support SMM and VMM cannot emulate SMM for TDX VMs because
> VMM cannot manipulate TDX VM's memory.
> 
> Disable SMM for TDX VMs and error out if user requests to enable SMM.

Acked-by: Gerd Hoffmann <kraxel@redhat.com>

