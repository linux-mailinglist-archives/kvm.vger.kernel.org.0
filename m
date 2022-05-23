Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 42479530D73
	for <lists+kvm@lfdr.de>; Mon, 23 May 2022 12:42:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233521AbiEWJq1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 23 May 2022 05:46:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35686 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233831AbiEWJqI (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 23 May 2022 05:46:08 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 24EE7D99
        for <kvm@vger.kernel.org>; Mon, 23 May 2022 02:46:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1653299166;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=AwlQtMbC814OlU2gRT2gVy4No1pGzM7Fqesio3HXtDQ=;
        b=MYtmoemMM+/cfKXsbykIXez59XYwysAwvUerRBTI4SRpTaFCV0eDt4xI8fyLc5BNH0LJJx
        LZKUlTahon5OzopUr1yeb2rPc/TnpLk8mjWPjVysTUibuEemTnVsHPs+vfe54DAurTSVp9
        PO8wz5ENMFnyJFnCITQyWeDjh2pDe0E=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-335-HCs9_ZCzPoirzVLg27oWqg-1; Mon, 23 May 2022 05:46:01 -0400
X-MC-Unique: HCs9_ZCzPoirzVLg27oWqg-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com [10.11.54.3])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 6B3228032E5;
        Mon, 23 May 2022 09:46:00 +0000 (UTC)
Received: from sirius.home.kraxel.org (unknown [10.39.192.41])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 1E1C21121314;
        Mon, 23 May 2022 09:46:00 +0000 (UTC)
Received: by sirius.home.kraxel.org (Postfix, from userid 1000)
        id 847F418000B4; Mon, 23 May 2022 11:45:58 +0200 (CEST)
Date:   Mon, 23 May 2022 11:45:58 +0200
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
Subject: Re: [RFC PATCH v4 15/36] i386/tdx: Set kvm_readonly_mem_enabled to
 false for TDX VM
Message-ID: <20220523094558.dtxsxezmt6eckrm5@sirius.home.kraxel.org>
References: <20220512031803.3315890-1-xiaoyao.li@intel.com>
 <20220512031803.3315890-16-xiaoyao.li@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220512031803.3315890-16-xiaoyao.li@intel.com>
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.3
X-Spam-Status: No, score=-3.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, May 12, 2022 at 11:17:42AM +0800, Xiaoyao Li wrote:
> TDX only supports readonly for shared memory but not for private memory.
> 
> In the view of QEMU, it has no idea whether a memslot is used as shared
> memory of private. Thus just mark kvm_readonly_mem_enabled to false to
> TDX VM for simplicity.

Acked-by: Gerd Hoffmann <kraxel@redhat.com>

