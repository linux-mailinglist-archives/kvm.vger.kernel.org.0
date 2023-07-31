Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6C30A769574
	for <lists+kvm@lfdr.de>; Mon, 31 Jul 2023 14:03:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231985AbjGaMDM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 31 Jul 2023 08:03:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57680 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232605AbjGaMDJ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 31 Jul 2023 08:03:09 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E237C119;
        Mon, 31 Jul 2023 05:03:05 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6F3C56105A;
        Mon, 31 Jul 2023 12:03:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 032D8C433C8;
        Mon, 31 Jul 2023 12:03:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1690804984;
        bh=TtJhPqRQlajaW9Ul53sJZlLR70A30mmQNrdXLgduGeY=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=T67Z5ZQ9m8brhGwe96qXE+V+KHAb39u6KyKtiWKwEAYCI1tyXX9XShvxgOps3Dbwj
         0Q2fgBFQtqyPSsIJgm6iyYAYEvnF1C5/pq+kydCiB3stV7WbWwOiUvloVWyMWn3XtH
         +8T0HX6x+LDWk68iF26AvX+8Y5ZV38wROJpU6zNs=
Date:   Mon, 31 Jul 2023 14:02:59 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Roxana Bradescu <roxabee@google.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] kvm/vfio: ensure kvg instance stays around in
 kvm_vfio_group_add()
Message-ID: <2023073144-whimsical-liberty-4b4f@gregkh>
References: <ZKyEL/4pFicxMQvg@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZKyEL/4pFicxMQvg@google.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Jul 10, 2023 at 03:20:31PM -0700, Dmitry Torokhov wrote:
> kvm_vfio_group_add() creates kvg instance, links it to kv->group_list,
> and calls kvm_vfio_file_set_kvm() with kvg->file as an argument after
> dropping kv->lock. If we race group addition and deletion calls, kvg
> instance may get freed by the time we get around to calling
> kvm_vfio_file_set_kvm().
> 
> Fix this by moving call to kvm_vfio_file_set_kvm() under the protection
> of kv->lock. We already call it while holding the same lock when vfio
> group is being deleted, so it should be safe here as well.
> 
> Fixes: ba70a89f3c2a ("vfio: Change vfio_group_set_kvm() to vfio_file_set_kvm()")
> Cc: stable@vger.kernel.org
> Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
> ---
>  virt/kvm/vfio.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/virt/kvm/vfio.c b/virt/kvm/vfio.c
> index 9584eb57e0ed..cd46d7ef98d6 100644
> --- a/virt/kvm/vfio.c
> +++ b/virt/kvm/vfio.c
> @@ -179,10 +179,10 @@ static int kvm_vfio_group_add(struct kvm_device *dev, unsigned int fd)
>  	list_add_tail(&kvg->node, &kv->group_list);
>  
>  	kvm_arch_start_assignment(dev->kvm);
> +	kvm_vfio_file_set_kvm(kvg->file, dev->kvm);
>  
>  	mutex_unlock(&kv->lock);
>  
> -	kvm_vfio_file_set_kvm(kvg->file, dev->kvm);
>  	kvm_vfio_update_coherency(dev);
>  
>  	return 0;
> -- 
> 2.41.0.255.g8b1d071c50-goog

What ever happened to this change?  Did it end up in a KVM tree
somewhere?

thanks,

greg k-h
