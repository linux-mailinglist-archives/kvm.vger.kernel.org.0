Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7675D7CF698
	for <lists+kvm@lfdr.de>; Thu, 19 Oct 2023 13:22:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345353AbjJSLW2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 19 Oct 2023 07:22:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46302 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345316AbjJSLW1 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 19 Oct 2023 07:22:27 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 37513112
        for <kvm@vger.kernel.org>; Thu, 19 Oct 2023 04:21:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1697714503;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=wJbjQEX6r4FVtVGUs3f8q9Y8qBJ81kVTcIhxYAo3Mqk=;
        b=I4Fy1zkXJ+i4ar6jj/tCSAnfPsq/o7f5vphWb2XTK3zXgc9GChMpEbAmnYWsa1OqvYRasU
        hdpyxqMNqJBxQoW54IIBp2+yOdkNkoMBkJUCK0x1Tzn1Uup8W+iqM/wvDGasyBVsAAWh3Q
        +TPFC0SFg6J3CiQU5MSEHzsn32QJ5Bg=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-578-SK7vo6K2NX2TQ2jYrduzJQ-1; Thu, 19 Oct 2023 07:21:40 -0400
X-MC-Unique: SK7vo6K2NX2TQ2jYrduzJQ-1
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com [10.11.54.10])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 57E82801234;
        Thu, 19 Oct 2023 11:21:39 +0000 (UTC)
Received: from redhat.com (unknown [10.39.193.120])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id D792A492BFB;
        Thu, 19 Oct 2023 11:21:36 +0000 (UTC)
Date:   Thu, 19 Oct 2023 13:21:35 +0200
From:   Kevin Wolf <kwolf@redhat.com>
To:     David Woodhouse <dwmw2@infradead.org>
Cc:     qemu-devel@nongnu.org, Hanna Reitz <hreitz@redhat.com>,
        Stefano Stabellini <sstabellini@kernel.org>,
        Anthony Perard <anthony.perard@citrix.com>,
        Paul Durrant <paul@xen.org>,
        =?iso-8859-1?Q?Marc-Andr=E9?= Lureau 
        <marcandre.lureau@redhat.com>, Paolo Bonzini <pbonzini@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
        Richard Henderson <richard.henderson@linaro.org>,
        Eduardo Habkost <eduardo@habkost.net>,
        Marcelo Tosatti <mtosatti@redhat.com>, qemu-block@nongnu.org,
        xen-devel@lists.xenproject.org, kvm@vger.kernel.org
Subject: Re: [PATCH 11/12] hw/xen: automatically assign device index to block
 devices
Message-ID: <ZTERPwrbUJf7kty2@redhat.com>
References: <20231016151909.22133-1-dwmw2@infradead.org>
 <20231016151909.22133-12-dwmw2@infradead.org>
 <ZS+cutIjulWBQakk@redhat.com>
 <950f3a62dfcecce902037f95575f1013697a5925.camel@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <950f3a62dfcecce902037f95575f1013697a5925.camel@infradead.org>
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.10
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Am 18.10.2023 um 12:52 hat David Woodhouse geschrieben:
> > Actually, how does this play together with xen_config_dev_blk()? This
> > looks like it tried to implement a very similar thing (which is IF_XEN
> > even already existed).
> 
> Ah yes, thanks for spotting that! I hadn't been looking at the xenfv
> 
> > Are we now trying to attach each if=xen disk twice in the 'xenpv'
> > machine? Or if something prevents this, is it dead code.
> 
> I suspect we end up creating them twice (and probably thus failing to
> lock the backing file).
>
> [...]
>
> ... but this just reinforces what I said there about "if
> qmp_device_add() can find the damn bus and do this right, why do we
> have to litter it through platform code?"

Indeed, if you can do -device, it's always the best option. For block
devices not the least because it gives you a way to use -blockdev with
it. I'm happy whenever I see a drive_get() call go away.

Kevin

