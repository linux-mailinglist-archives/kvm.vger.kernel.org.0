Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7B32E7D7273
	for <lists+kvm@lfdr.de>; Wed, 25 Oct 2023 19:37:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233381AbjJYRho (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 25 Oct 2023 13:37:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41562 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231263AbjJYRhn (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 25 Oct 2023 13:37:43 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2579B189
        for <kvm@vger.kernel.org>; Wed, 25 Oct 2023 10:37:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1698255428;
        h=from:from:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=922xtKTOob6poxpoZsiCw+YhrPnKiBWnIIyzotl6EqI=;
        b=gqgu2oz2AQM6nI3GFy/OMjk4ClHMGdFRUBxjSgS3fkpH6+r/WvJOGD1U0Dh/C1hRwlcHXc
        +MZKfYJFE67IiB0tfORS2vJ/80uKQQ2juvKdjFB1jSUcQWG1pfjXfg1oLKuQASkTtrCFV6
        LT1MvizAhDKaxM0Q6dPX9F4jSC9DDAs=
Received: from mimecast-mx02.redhat.com (mx-ext.redhat.com [66.187.233.73])
 by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-219-n_tunRMeMcqozCzyA1834w-1; Wed,
 25 Oct 2023 13:37:05 -0400
X-MC-Unique: n_tunRMeMcqozCzyA1834w-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com [10.11.54.6])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id AD90628004ED;
        Wed, 25 Oct 2023 17:37:04 +0000 (UTC)
Received: from redhat.com (unknown [10.42.28.154])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id E55182166B26;
        Wed, 25 Oct 2023 17:37:03 +0000 (UTC)
Date:   Wed, 25 Oct 2023 18:37:01 +0100
From:   Daniel =?utf-8?B?UC4gQmVycmFuZ8Op?= <berrange@redhat.com>
To:     Daan De Meyer <daan.j.demeyer@gmail.com>
Cc:     qemu-devel@nongnu.org, kvm@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [PATCH] Add class property to configure KVM device node to use
Message-ID: <ZTlSPbh2GnhOKExO@redhat.com>
Reply-To: Daniel =?utf-8?B?UC4gQmVycmFuZ8Op?= <berrange@redhat.com>
References: <20231021134015.1119597-1-daan.j.demeyer@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20231021134015.1119597-1-daan.j.demeyer@gmail.com>
User-Agent: Mutt/2.2.9 (2022-11-12)
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.6
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sat, Oct 21, 2023 at 03:40:15PM +0200, Daan De Meyer wrote:
> This allows passing the KVM device node to use as a file
> descriptor via /dev/fdset/XX. Passing the device node to
> use as a file descriptor allows running qemu unprivileged
> even when the user running qemu is not in the kvm group
> on distributions where access to /dev/kvm is gated behind
> membership of the kvm group (as long as the process invoking
> qemu is able to open /dev/kvm and passes the file descriptor
> to qemu).
> 
> Signed-off-by: Daan De Meyer <daan.j.demeyer@gmail.com>
> ---
>  accel/kvm/kvm-all.c      | 25 ++++++++++++++++++++++++-
>  include/sysemu/kvm_int.h |  1 +
>  qemu-options.hx          |  8 +++++++-
>  3 files changed, 32 insertions(+), 2 deletions(-)

Reviewed-by: Daniel P. Berrangé <berrange@redhat.com>


With regards,
Daniel
-- 
|: https://berrange.com      -o-    https://www.flickr.com/photos/dberrange :|
|: https://libvirt.org         -o-            https://fstop138.berrange.com :|
|: https://entangle-photo.org    -o-    https://www.instagram.com/dberrange :|

