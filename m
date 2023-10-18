Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AC4D77CD70C
	for <lists+kvm@lfdr.de>; Wed, 18 Oct 2023 10:53:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229532AbjJRIxH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 18 Oct 2023 04:53:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34124 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229449AbjJRIxF (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 18 Oct 2023 04:53:05 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4E1BFEA
        for <kvm@vger.kernel.org>; Wed, 18 Oct 2023 01:52:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1697619138;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=2QqvfO0DgHUb1b4lvzB4Y2b9lzIz4ZUlzP/607LhnMw=;
        b=DN2KxSckrdpoKi0O0W1kFaXINM6B8/o6o4VS3JCT1ISbvo6kuQ9aFR5Uwpqd5+IZdxNZ9s
        UcuVpt3Z8a86BpF0rl0OAHlIC76ssZbpBLLOwVwtGF+rTHramIyxRTw7LDrjvV+qZDkLPG
        A2fHLYSto5KgWaZSPV5UE1HS6sFctWc=
Received: from mimecast-mx02.redhat.com (mx-ext.redhat.com [66.187.233.73])
 by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-582-7wigXbIkP_i32babYPld5g-1; Wed, 18 Oct 2023 04:52:14 -0400
X-MC-Unique: 7wigXbIkP_i32babYPld5g-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com [10.11.54.8])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 2347D28AC1EA;
        Wed, 18 Oct 2023 08:52:14 +0000 (UTC)
Received: from redhat.com (unknown [10.39.193.245])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id CB252C15BB8;
        Wed, 18 Oct 2023 08:52:11 +0000 (UTC)
Date:   Wed, 18 Oct 2023 10:52:10 +0200
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
Message-ID: <ZS+cutIjulWBQakk@redhat.com>
References: <20231016151909.22133-1-dwmw2@infradead.org>
 <20231016151909.22133-12-dwmw2@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231016151909.22133-12-dwmw2@infradead.org>
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.8
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Am 16.10.2023 um 17:19 hat David Woodhouse geschrieben:
> From: David Woodhouse <dwmw@amazon.co.uk>
> 
> There's no need to force the user to assign a vdev. We can automatically
> assign one, starting at xvda and searching until we find the first disk
> name that's unused.
> 
> This means we can now allow '-drive if=xen,file=xxx' to work without an
> explicit separate -driver argument, just like if=virtio.
> 
> Signed-off-by: David Woodhouse <dwmw@amazon.co.uk>

Actually, how does this play together with xen_config_dev_blk()? This
looks like it tried to implement a very similar thing (which is IF_XEN
even already existed).

Are we now trying to attach each if=xen disk twice in the 'xenpv'
machine? Or if something prevents this, is it dead code?

I think in both cases, we would want to delete that function and remove
the loop that calls it in xen_init_pv()?

Kevin

