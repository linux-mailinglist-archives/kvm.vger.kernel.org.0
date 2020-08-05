Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7916823C768
	for <lists+kvm@lfdr.de>; Wed,  5 Aug 2020 10:11:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728248AbgHEIHl (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 5 Aug 2020 04:07:41 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:46284 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1728198AbgHEIHM (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 5 Aug 2020 04:07:12 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1596614831;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=U+P5AqxVwLdPgRW/WZrpuWJB7Ff2u+rvbxrrV1P3Ilw=;
        b=jUKl18odB4hQ78UwUbcb8PEUXmBeuEgP9rKXdJRMONfdtfaoJt38uU/Uqs3KWe5vhHE/p7
        tEPS/OXP4IkNjRRtbi76+Y3/kAVrFIIi4xusOnTGk0psOpJULNoHuBFfvyHapBM8Zk57Mh
        w8syGtfrj6/AEZGoYcgrUgk9jO+F8gA=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-162-waLDMApFPg6rO-lpbdax3w-1; Wed, 05 Aug 2020 04:07:07 -0400
X-MC-Unique: waLDMApFPg6rO-lpbdax3w-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id AB6D3100AA25;
        Wed,  5 Aug 2020 08:07:02 +0000 (UTC)
Received: from [10.72.12.225] (ovpn-12-225.pek2.redhat.com [10.72.12.225])
        by smtp.corp.redhat.com (Postfix) with ESMTP id E196C19C4F;
        Wed,  5 Aug 2020 08:06:51 +0000 (UTC)
Subject: Re: [PATCH V5 4/6] vhost_vdpa: implement IRQ offloading in vhost_vdpa
To:     Zhu Lingshan <lingshan.zhu@intel.com>, alex.williamson@redhat.com,
        mst@redhat.com, pbonzini@redhat.com,
        sean.j.christopherson@intel.com, wanpengli@tencent.com
Cc:     virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        kvm@vger.kernel.org, eli@mellanox.com, shahafs@mellanox.com,
        parav@mellanox.com
References: <20200731065533.4144-1-lingshan.zhu@intel.com>
 <20200731065533.4144-5-lingshan.zhu@intel.com>
From:   Jason Wang <jasowang@redhat.com>
Message-ID: <4c711720-b4ff-6f09-61cb-2d305daa69c8@redhat.com>
Date:   Wed, 5 Aug 2020 16:06:50 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20200731065533.4144-5-lingshan.zhu@intel.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


On 2020/7/31 下午2:55, Zhu Lingshan wrote:
> +static void vhost_vdpa_setup_vq_irq(struct vhost_vdpa *v, u16 qid)
> +{
> +	struct vhost_virtqueue *vq = &v->vqs[qid];
> +	const struct vdpa_config_ops *ops = v->vdpa->config;
> +	struct vdpa_device *vdpa = v->vdpa;
> +	int ret, irq;
> +
> +	spin_lock(&vq->call_ctx.ctx_lock);
> +	irq = ops->get_vq_irq(vdpa, qid);


Btw, this assumes that get_vq_irq is mandatory. This looks wrong since 
there's no guarantee that the vDPA device driver can see irq. And this 
break vdpa simulator.

Let's add a check and make it optional by document this assumption in 
the vdpa.h.

Thanks


> +	if (!vq->call_ctx.ctx || irq < 0) {
> +		spin_unlock(&vq->call_ctx.ctx_lock);
> +		return;
> +	}
> +

