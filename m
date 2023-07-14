Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5EB1075433B
	for <lists+kvm@lfdr.de>; Fri, 14 Jul 2023 21:32:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235894AbjGNTct (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 14 Jul 2023 15:32:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40770 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229849AbjGNTcs (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 14 Jul 2023 15:32:48 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A41F012D
        for <kvm@vger.kernel.org>; Fri, 14 Jul 2023 12:32:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1689363121;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=BKxVQXvv2xifA277lsMm5CJovPA2ZC2bSr4vguNtNxo=;
        b=JRGB/MbodVxv7HH8wntPi/VZveBVCYcRTJxProgL7FDjakliZogbjTh3rTYM0/MGfaGS08
        V8yBTK31PfbumeYbzAbPtOFEbqhO3LKbp+6o1K3Suwn3ffTEU7IVOrfOFex04lrSPa9ipr
        3lPt/FQTsr54RifL/sYiZcV2WGL3RlU=
Received: from mail-io1-f69.google.com (mail-io1-f69.google.com
 [209.85.166.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-106-2E0FJt6CN4OZWk7sL4AKzg-1; Fri, 14 Jul 2023 15:32:00 -0400
X-MC-Unique: 2E0FJt6CN4OZWk7sL4AKzg-1
Received: by mail-io1-f69.google.com with SMTP id ca18e2360f4ac-7834a155749so100197839f.0
        for <kvm@vger.kernel.org>; Fri, 14 Jul 2023 12:32:00 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1689363119; x=1691955119;
        h=content-transfer-encoding:mime-version:organization:references
         :in-reply-to:message-id:subject:cc:to:from:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=BKxVQXvv2xifA277lsMm5CJovPA2ZC2bSr4vguNtNxo=;
        b=ZiLzim7fdlNDSOZ7crgmvH0vjNE7y0FM6JivjpRnNgiN1yOUM8WGs+qPfogzOmrt8M
         uxOPxdtzCYQd+xmY/szke7UoFhSVFtln1kAp2ffVS1jNXntGZOBNchoEHz9pDyNWfBcJ
         /01vWrUTy4Lyu9kdpXWtqnprxPPGrJkYrBAvcEAINUBffTSMFuArn0CnlOlSac4ao1PP
         p9gY5PkeqjdXjOPOkRpuAU3sla/61uCLXAtih/ztv6kf0Hyek1cQsH+2s50nK6t/vlz9
         xfMdOJR7tIOqxFeQVdqAsRrUFBXm2zzL64flTmZtbY6YcSYvJGst8aRugSrkOLRKFN4c
         Q0AQ==
X-Gm-Message-State: ABy/qLatP62eosx3/eHMVAyqYz5lFgMdQKPdOzE35AJ8KK3OwtKrnStd
        FE729kYO2UrP1hlsS/BpTKpIcZTOCOuQLWaDRET0xIGMgp4iKHqZa7qDI9IdE0SplR3wuPW9F8E
        UQToBU9YobSsj
X-Received: by 2002:a5d:8897:0:b0:783:727b:7073 with SMTP id d23-20020a5d8897000000b00783727b7073mr5297459ioo.20.1689363119680;
        Fri, 14 Jul 2023 12:31:59 -0700 (PDT)
X-Google-Smtp-Source: APBJJlFdnKw4epFNpNmUmXDYSNIXBnhkkmj0pxQ/KnYRs6JyUKxyNNg/Cf2A8utgvw6R6/ieOShXUg==
X-Received: by 2002:a5d:8897:0:b0:783:727b:7073 with SMTP id d23-20020a5d8897000000b00783727b7073mr5297445ioo.20.1689363119425;
        Fri, 14 Jul 2023 12:31:59 -0700 (PDT)
Received: from redhat.com ([38.15.36.239])
        by smtp.gmail.com with ESMTPSA id z2-20020a02cea2000000b004290f6c15bfsm2803545jaq.145.2023.07.14.12.31.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 14 Jul 2023 12:31:58 -0700 (PDT)
Date:   Fri, 14 Jul 2023 13:31:56 -0600
From:   Alex Williamson <alex.williamson@redhat.com>
To:     Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Greg KH <gregkh@linuxfoundation.org>,
        Sean Christopherson <seanjc@google.com>,
        Roxana Bradescu <roxabee@google.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 2/2] kvm/vfio: avoid bouncing the mutex when adding
 and deleting groups
Message-ID: <20230714133156.3e584eab.alex.williamson@redhat.com>
In-Reply-To: <20230714183800.3112449-2-dmitry.torokhov@gmail.com>
References: <20230714183800.3112449-1-dmitry.torokhov@gmail.com>
        <20230714183800.3112449-2-dmitry.torokhov@gmail.com>
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

On Fri, 14 Jul 2023 11:37:57 -0700
Dmitry Torokhov <dmitry.torokhov@gmail.com> wrote:

> Stop taking kv->lock mutex in kvm_vfio_update_coherency() and instead
> call it with this mutex held: the callers of the function usually
> already have it taken (and released) before calling
> kvm_vfio_update_coherency(). This avoid bouncing the lock up and down.
> 
> The exception is kvm_vfio_release() where we do not take the lock, but
> it is being executed when the very last reference to kvm_device is being
> dropped, so there are no concerns about concurrency.
> 
> Suggested-by: Alex Williamson <alex.williamson@redhat.com>
> Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
> ---
> 
> v2: new patch.
> 
>  virt/kvm/vfio.c | 25 +++++++++----------------
>  1 file changed, 9 insertions(+), 16 deletions(-)
> 
> diff --git a/virt/kvm/vfio.c b/virt/kvm/vfio.c
> index cd46d7ef98d6..9868e7ccb5fb 100644
> --- a/virt/kvm/vfio.c
> +++ b/virt/kvm/vfio.c
> @@ -122,8 +122,6 @@ static void kvm_vfio_update_coherency(struct kvm_device *dev)
>  	bool noncoherent = false;
>  	struct kvm_vfio_group *kvg;
>  
> -	mutex_lock(&kv->lock);
> -
>  	list_for_each_entry(kvg, &kv->group_list, node) {
>  		if (!kvm_vfio_file_enforced_coherent(kvg->file)) {
>  			noncoherent = true;
> @@ -139,8 +137,6 @@ static void kvm_vfio_update_coherency(struct kvm_device *dev)
>  		else
>  			kvm_arch_unregister_noncoherent_dma(dev->kvm);
>  	}
> -
> -	mutex_unlock(&kv->lock);
>  }
>  
>  static int kvm_vfio_group_add(struct kvm_device *dev, unsigned int fd)
> @@ -157,7 +153,7 @@ static int kvm_vfio_group_add(struct kvm_device *dev, unsigned int fd)
>  	/* Ensure the FD is a vfio group FD.*/
>  	if (!kvm_vfio_file_is_group(filp)) {
>  		ret = -EINVAL;
> -		goto err_fput;
> +		goto out_fput;
>  	}
>  
>  	mutex_lock(&kv->lock);
> @@ -165,30 +161,27 @@ static int kvm_vfio_group_add(struct kvm_device *dev, unsigned int fd)
>  	list_for_each_entry(kvg, &kv->group_list, node) {
>  		if (kvg->file == filp) {
>  			ret = -EEXIST;
> -			goto err_unlock;
> +			goto out_unlock;
>  		}
>  	}
>  
>  	kvg = kzalloc(sizeof(*kvg), GFP_KERNEL_ACCOUNT);
>  	if (!kvg) {
>  		ret = -ENOMEM;
> -		goto err_unlock;
> +		goto out_unlock;
>  	}
>  
> -	kvg->file = filp;
> +	kvg->file = get_file(filp);
>  	list_add_tail(&kvg->node, &kv->group_list);
>  
>  	kvm_arch_start_assignment(dev->kvm);
>  	kvm_vfio_file_set_kvm(kvg->file, dev->kvm);
> -
> -	mutex_unlock(&kv->lock);
> -
>  	kvm_vfio_update_coherency(dev);
>  
> -	return 0;
> -err_unlock:
> +	ret = 0;

Nit, let's initialize ret = 0 when it's declared to avoid this.  Series
looks good to me otherwise.  Thanks,

Alex

> +out_unlock:
>  	mutex_unlock(&kv->lock);
> -err_fput:
> +out_fput:
>  	fput(filp);
>  	return ret;
>  }
> @@ -224,12 +217,12 @@ static int kvm_vfio_group_del(struct kvm_device *dev, unsigned int fd)
>  		break;
>  	}
>  
> +	kvm_vfio_update_coherency(dev);
> +
>  	mutex_unlock(&kv->lock);
>  
>  	fdput(f);
>  
> -	kvm_vfio_update_coherency(dev);
> -
>  	return ret;
>  }
>  

