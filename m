Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 30256763E2E
	for <lists+kvm@lfdr.de>; Wed, 26 Jul 2023 20:12:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230099AbjGZSMQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 26 Jul 2023 14:12:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52344 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229479AbjGZSMP (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 26 Jul 2023 14:12:15 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4990C1FF5
        for <kvm@vger.kernel.org>; Wed, 26 Jul 2023 11:11:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1690395094;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=eGukCLwIpbf54ieqMBZB+shCMT6w9p/EZv5cgNQmWkc=;
        b=Y2MP3vGPnEdiZ/Xer1W3dYzpOJtXzBmYwo+Cllji3GIYbVjIgfP1+M2Yop0hlY/83TjQfd
        phjswfdrIKbn+Rp9o7KpDbjbbxfiTh13Lh6sI7ASJvds14i1dTOmV/pjIXJs30cCMDNMDg
        p/aF8FffRPAcGWySPqzYCkfhGZjRuXU=
Received: from mail-io1-f70.google.com (mail-io1-f70.google.com
 [209.85.166.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-264-FYkgQ9BqNi66g8R1B9ZOxQ-1; Wed, 26 Jul 2023 14:11:33 -0400
X-MC-Unique: FYkgQ9BqNi66g8R1B9ZOxQ-1
Received: by mail-io1-f70.google.com with SMTP id ca18e2360f4ac-77e3eaa1343so3165639f.2
        for <kvm@vger.kernel.org>; Wed, 26 Jul 2023 11:11:32 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1690395092; x=1690999892;
        h=content-transfer-encoding:mime-version:organization:references
         :in-reply-to:message-id:subject:cc:to:from:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=eGukCLwIpbf54ieqMBZB+shCMT6w9p/EZv5cgNQmWkc=;
        b=fvAJJmjckumPxEs3Sauh51a+kGmryGstHSOuXzSYFiM9HhqUE4Axy7pYuHFD9ksNnE
         FDI6hDtnBYTp6Aa6f+rqJL4pj4t1YjE7FS9d8VOlxfBCoP2mjAT7RULsZuGqbqULBeuW
         Z2crKWJ1IzMd5joKkuTsGtSH7GNR3nSt0VQ2OWHZcmUfmmohNfsVJFq1nmkO0DbBnPlS
         t7gmAx6jkz/01KA4n5/0joGFq01WjSmbjT39nqDg8PaAlEZFAC3nFaQhd9lfcs3YpPfx
         o/MBeuuq6bz0JxZhyMm86wbq5o5ReEicosT0KdyslY/EwPKfbU9xsx59Qwvfwgy7GFXr
         UY2A==
X-Gm-Message-State: ABy/qLbpEesDZA0WhXAEterFGS3KhKf8FJpKNAWO12X/bSkbgoAh1knL
        wbM/tUbbXg6xMZDbjLhTioNiAd0oSBn60oL5zPZ3V6NAlzlk1+dreiB6WrU0gicTr5FiH9+QwqL
        B1gP1nw4OfRMb
X-Received: by 2002:a5e:860e:0:b0:786:25a3:ef30 with SMTP id z14-20020a5e860e000000b0078625a3ef30mr2821758ioj.7.1690395092345;
        Wed, 26 Jul 2023 11:11:32 -0700 (PDT)
X-Google-Smtp-Source: APBJJlEKFEwRNEZtSvBBm6CRwq4z8Y+YP3bImDoHXznPC0Prn+72XzzlCZujlBdG7nGijjkuLmRXww==
X-Received: by 2002:a5e:860e:0:b0:786:25a3:ef30 with SMTP id z14-20020a5e860e000000b0078625a3ef30mr2821733ioj.7.1690395092104;
        Wed, 26 Jul 2023 11:11:32 -0700 (PDT)
Received: from redhat.com ([38.15.60.12])
        by smtp.gmail.com with ESMTPSA id z25-20020a02ceb9000000b0042b3e86dfd8sm4452392jaq.141.2023.07.26.11.11.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 26 Jul 2023 11:11:31 -0700 (PDT)
Date:   Wed, 26 Jul 2023 12:11:30 -0600
From:   Alex Williamson <alex.williamson@redhat.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Greg KH <gregkh@linuxfoundation.org>,
        Sean Christopherson <seanjc@google.com>,
        Roxana Bradescu <roxabee@google.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 1/2] kvm/vfio: ensure kvg instance stays around in
 kvm_vfio_group_add()
Message-ID: <20230726121130.7117a238.alex.williamson@redhat.com>
In-Reply-To: <20230714224538.404793-1-dmitry.torokhov@gmail.com>
References: <20230714224538.404793-1-dmitry.torokhov@gmail.com>
Organization: Red Hat
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hey Paolo,

I'll pull this through the vfio tree unless you have a particular
interest.  Thanks,

Alex

On Fri, 14 Jul 2023 15:45:32 -0700
Dmitry Torokhov <dmitry.torokhov@gmail.com> wrote:

> kvm_vfio_group_add() creates kvg instance, links it to kv->group_list,
> and calls kvm_vfio_file_set_kvm() with kvg->file as an argument after
> dropping kv->lock. If we race group addition and deletion calls, kvg
> instance may get freed by the time we get around to calling
> kvm_vfio_file_set_kvm().
> 
> Previous iterations of the code did not reference kvg->file outside of
> the critical section, but used a temporary variable. Still, they had
> similar problem of the file reference being owned by kvg structure and
> potential for kvm_vfio_group_del() dropping it before
> kvm_vfio_group_add() had a chance to complete.
> 
> Fix this by moving call to kvm_vfio_file_set_kvm() under the protection
> of kv->lock. We already call it while holding the same lock when vfio
> group is being deleted, so it should be safe here as well.
> 
> Fixes: 2fc1bec15883 ("kvm: set/clear kvm to/from vfio_group when group add/delete")
> Reviewed-by: Alex Williamson <alex.williamson@redhat.com>
> Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
> ---
> 
> v3: added Alex's reviewed-by
> 
> v2: updated commit description with the correct "Fixes" tag (per Alex),
>     expanded commit description to mention issues with the earlier
>     implementation of kvm_vfio_group_add().
> 
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

