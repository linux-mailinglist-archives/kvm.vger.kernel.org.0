Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DF1D36131A2
	for <lists+kvm@lfdr.de>; Mon, 31 Oct 2022 09:22:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229781AbiJaIV7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 31 Oct 2022 04:21:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41278 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229679AbiJaIV6 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 31 Oct 2022 04:21:58 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 119099FEA
        for <kvm@vger.kernel.org>; Mon, 31 Oct 2022 01:21:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1667204466;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=im6vMDpZ4QR8KDTirDvE233dWKuaLZGJIPJhOg4Fv98=;
        b=BcIoNmaGF3PiXe+W676CggQM+IRD47HO5GhYtIntarCA+cJjnfUeqccql391uqkfZqeCo5
        h/FuoGcnKnpSjs5aUaEIlhK+K2LhgrY0BW7H7IpqzuhMSQDsbLBcZ+geBqhUhaZVTiB8mc
        Nz0zEz6FSiiueymX0lo8K/WJfqcBmNw=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-247-6y-1ggHGPK2YxBFoZ7ig7A-1; Mon, 31 Oct 2022 04:21:04 -0400
X-MC-Unique: 6y-1ggHGPK2YxBFoZ7ig7A-1
Received: by mail-wm1-f69.google.com with SMTP id h8-20020a1c2108000000b003cf550bfc8dso5797712wmh.2
        for <kvm@vger.kernel.org>; Mon, 31 Oct 2022 01:21:04 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=im6vMDpZ4QR8KDTirDvE233dWKuaLZGJIPJhOg4Fv98=;
        b=ZV4zGdVneB21hX5kodmHnks+LrR4xgIMaDfnh/dN9QFUKG1VlUl/lbkJAQHyUlyEcO
         Iafqc6KmWmIEogU8XpOCvzcEWPIbk8SAk/EWYsWASaEY9WDOV4ERw3+C4siKov163IG7
         NV6kovo+A4cVT1642OOX1/EyfU5Bhq1tj/p61994ZHVWiQkyxZwn0iFID4tCN3feJid7
         rNBtlvABTfFk19lfcrFSEwC8ZiIuVpn5TRbKcbE/cQc/qkSTgj6z3BseelCdJYqkG6oN
         hYAUoJCueyBd/CX8PddaOJIw5AZcVrpRf0/H1bzL0d6yjuSLKboQASTOIjjwrZVYcLbZ
         DoZw==
X-Gm-Message-State: ACrzQf1bgv9y0evxxsv1VftDSHs2t+h2JkKokRYjQQ3Tvcw5JcBphLf3
        IHZMUQM0IIwYvlo1obxUf/f2VxyNsP0vAGXrShW+GvGqEDDbnLaL9nk5OwT9L+GhH6T/ByEXkH/
        uVXWAqM+yjMGr
X-Received: by 2002:a05:6000:1d94:b0:22e:34ef:b07f with SMTP id bk20-20020a0560001d9400b0022e34efb07fmr7242206wrb.272.1667204463537;
        Mon, 31 Oct 2022 01:21:03 -0700 (PDT)
X-Google-Smtp-Source: AMsMyM7pWhEuLLTmll7+NNqrSauhIVegJ+TqYCAjjkPUTJ1qckmTM1uMN7lpqxldGowx+uM/YWLxgQ==
X-Received: by 2002:a05:6000:1d94:b0:22e:34ef:b07f with SMTP id bk20-20020a0560001d9400b0022e34efb07fmr7242193wrb.272.1667204463276;
        Mon, 31 Oct 2022 01:21:03 -0700 (PDT)
Received: from redhat.com ([2.52.15.189])
        by smtp.gmail.com with ESMTPSA id t12-20020adff60c000000b002366ded5864sm6267581wrp.116.2022.10.31.01.21.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 31 Oct 2022 01:21:02 -0700 (PDT)
Date:   Mon, 31 Oct 2022 04:20:58 -0400
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Eugenio =?iso-8859-1?Q?P=E9rez?= <eperezma@redhat.com>
Cc:     qemu-devel@nongnu.org, Gautam Dawar <gdawar@xilinx.com>,
        Zhu Lingshan <lingshan.zhu@intel.com>,
        Jason Wang <jasowang@redhat.com>,
        Si-Wei Liu <si-wei.liu@oracle.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Eli Cohen <eli@mellanox.com>,
        Parav Pandit <parav@mellanox.com>,
        Laurent Vivier <lvivier@redhat.com>,
        Stefano Garzarella <sgarzare@redhat.com>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        "Gonglei (Arei)" <arei.gonglei@huawei.com>,
        Cindy Lu <lulu@redhat.com>,
        Liuxiangdong <liuxiangdong5@huawei.com>,
        Cornelia Huck <cohuck@redhat.com>, kvm@vger.kernel.org,
        Harpreet Singh Anand <hanand@xilinx.com>
Subject: Re: [PATCH v5 2/6] vdpa: Allocate SVQ unconditionally
Message-ID: <20221031041821-mutt-send-email-mst@kernel.org>
References: <20221011104154.1209338-1-eperezma@redhat.com>
 <20221011104154.1209338-3-eperezma@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20221011104154.1209338-3-eperezma@redhat.com>
X-Spam-Status: No, score=-3.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Oct 11, 2022 at 12:41:50PM +0200, Eugenio Pérez wrote:
> SVQ may run or not in a device depending on runtime conditions (for
> example, if the device can move CVQ to its own group or not).
> 
> Allocate the resources unconditionally, and decide later if to use them
> or not.
> 
> Signed-off-by: Eugenio Pérez <eperezma@redhat.com>

I applied this for now but I really dislike it that we are wasting
resources like this.

Can I just drop this patch from the series? It looks like things
will just work anyway ...

I know, when one works on a feature it seems like everyone should
enable it - but the reality is qemu already works quite well for
most users and it is our resposibility to first do no harm.


> ---
>  hw/virtio/vhost-vdpa.c | 33 +++++++++++++++------------------
>  1 file changed, 15 insertions(+), 18 deletions(-)
> 
> diff --git a/hw/virtio/vhost-vdpa.c b/hw/virtio/vhost-vdpa.c
> index 7f0ff4df5b..d966966131 100644
> --- a/hw/virtio/vhost-vdpa.c
> +++ b/hw/virtio/vhost-vdpa.c
> @@ -410,6 +410,21 @@ static int vhost_vdpa_init_svq(struct vhost_dev *hdev, struct vhost_vdpa *v,
>      int r;
>      bool ok;
>  
> +    shadow_vqs = g_ptr_array_new_full(hdev->nvqs, vhost_svq_free);
> +    for (unsigned n = 0; n < hdev->nvqs; ++n) {
> +        g_autoptr(VhostShadowVirtqueue) svq;
> +
> +        svq = vhost_svq_new(v->iova_tree, v->shadow_vq_ops,
> +                            v->shadow_vq_ops_opaque);
> +        if (unlikely(!svq)) {
> +            error_setg(errp, "Cannot create svq %u", n);
> +            return -1;
> +        }
> +        g_ptr_array_add(shadow_vqs, g_steal_pointer(&svq));
> +    }
> +
> +    v->shadow_vqs = g_steal_pointer(&shadow_vqs);
> +
>      if (!v->shadow_vqs_enabled) {
>          return 0;
>      }
> @@ -426,20 +441,6 @@ static int vhost_vdpa_init_svq(struct vhost_dev *hdev, struct vhost_vdpa *v,
>          return -1;
>      }
>  
> -    shadow_vqs = g_ptr_array_new_full(hdev->nvqs, vhost_svq_free);
> -    for (unsigned n = 0; n < hdev->nvqs; ++n) {
> -        g_autoptr(VhostShadowVirtqueue) svq;
> -
> -        svq = vhost_svq_new(v->iova_tree, v->shadow_vq_ops,
> -                            v->shadow_vq_ops_opaque);
> -        if (unlikely(!svq)) {
> -            error_setg(errp, "Cannot create svq %u", n);
> -            return -1;
> -        }
> -        g_ptr_array_add(shadow_vqs, g_steal_pointer(&svq));
> -    }
> -
> -    v->shadow_vqs = g_steal_pointer(&shadow_vqs);
>      return 0;
>  }
>  
> @@ -580,10 +581,6 @@ static void vhost_vdpa_svq_cleanup(struct vhost_dev *dev)
>      struct vhost_vdpa *v = dev->opaque;
>      size_t idx;
>  
> -    if (!v->shadow_vqs) {
> -        return;
> -    }
> -
>      for (idx = 0; idx < v->shadow_vqs->len; ++idx) {
>          vhost_svq_stop(g_ptr_array_index(v->shadow_vqs, idx));
>      }
> -- 
> 2.31.1

