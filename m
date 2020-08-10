Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6D9652406A7
	for <lists+kvm@lfdr.de>; Mon, 10 Aug 2020 15:37:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726787AbgHJNhJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 10 Aug 2020 09:37:09 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:39906 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726518AbgHJNhJ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 10 Aug 2020 09:37:09 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1597066627;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=b/qxK5C6ePLAWVdlOOgywCTwX3DZjSUnV1UIiKmwyDg=;
        b=ByifV7GicXk5g52Pd+PddF/ZmZK90SKpSc/SKRlwYM/GN8KH32yHm/6q2oqeWaLLDBSCvl
        SUiU2qsPS8uc7juaP78BHWvoJvgx7ZkRQGSvE+NBUpgSJvHtHdZq3Qo5gZyuKRN5KOgd9+
        300ONfMR68viGohDoqV31stCwn6QHSs=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-20-LxSi600yNwOX21OLxCDt-A-1; Mon, 10 Aug 2020 09:37:05 -0400
X-MC-Unique: LxSi600yNwOX21OLxCDt-A-1
Received: by mail-wm1-f70.google.com with SMTP id z10so2865278wmi.8
        for <kvm@vger.kernel.org>; Mon, 10 Aug 2020 06:37:05 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=b/qxK5C6ePLAWVdlOOgywCTwX3DZjSUnV1UIiKmwyDg=;
        b=Ag/ptTYrKBf8vrpnn+aTnBKBFfO7Zz9nRFk3SJrLms7D7Fj1pBPgr81IjJO2pilNBt
         LC0o7K4AiHoWwt3BMw22Gw6tubmeepSCdVx01C3v9IU5aE4UeCdW8ExfSqHF+/ce6fZi
         FK0OFgPaSLm1oQcFfsxA7E1Pavyulz/LSx0AggFKbgzShD4vANoPnfkMmc137+UP3N1j
         FVFdHSMZy53iYJUhJYU/D8nh2lHXISdZW4agassId41TSB8ahqa/XLKe/ixrsAtE/j5z
         fwXxxTcxAIaT6ZcFMpuPlHgL1TRlDZOhHHXYdlSC/pbTdgzCToz5Xx3nKpx2vGNt3rFt
         pW9w==
X-Gm-Message-State: AOAM530xWbvl5icGJ+cs3bV3i57AYZP53PAYdh4wQ8pWs8EzTqbEBp5A
        46GZeBoPItNkyvVXp1nlXRiqqZjY9HO2TVB1/g4EqcmZV1OBUXTAvwXnydmzAUdxu1oX7opktP2
        Wd5+T8j8EWujE
X-Received: by 2002:a1c:5f44:: with SMTP id t65mr23851975wmb.99.1597066624610;
        Mon, 10 Aug 2020 06:37:04 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyntbXKihSaGm5opEK+za7CdlaF4OJ93oO4OKkytJl8FaoN1WxNcKI6KM/HsYZNiaqGUVp/wQ==
X-Received: by 2002:a1c:5f44:: with SMTP id t65mr23851960wmb.99.1597066624455;
        Mon, 10 Aug 2020 06:37:04 -0700 (PDT)
Received: from redhat.com (bzq-109-67-41-16.red.bezeqint.net. [109.67.41.16])
        by smtp.gmail.com with ESMTPSA id f12sm21591802wmc.46.2020.08.10.06.37.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 10 Aug 2020 06:37:03 -0700 (PDT)
Date:   Mon, 10 Aug 2020 09:37:00 -0400
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Jason Wang <jasowang@redhat.com>
Cc:     "Zhu, Lingshan" <lingshan.zhu@intel.com>,
        alex.williamson@redhat.com, pbonzini@redhat.com,
        sean.j.christopherson@intel.com, wanpengli@tencent.com,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        kvm@vger.kernel.org, eli@mellanox.com, shahafs@mellanox.com,
        parav@mellanox.com
Subject: Re: [PATCH V5 1/6] vhost: introduce vhost_vring_call
Message-ID: <20200810093630-mutt-send-email-mst@kernel.org>
References: <20200731065533.4144-1-lingshan.zhu@intel.com>
 <20200731065533.4144-2-lingshan.zhu@intel.com>
 <5e646141-ca8d-77a5-6f41-d30710d91e6d@redhat.com>
 <d51dd4e3-7513-c771-104c-b61f9ee70f30@intel.com>
 <156b8d71-6870-c163-fdfa-35bf4701987d@redhat.com>
 <20200804052050-mutt-send-email-mst@kernel.org>
 <14fd2bf1-e9c1-a192-bd6c-f1ee5fd227f6@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <14fd2bf1-e9c1-a192-bd6c-f1ee5fd227f6@redhat.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Aug 05, 2020 at 10:16:16AM +0800, Jason Wang wrote:
> 
> On 2020/8/4 下午5:21, Michael S. Tsirkin wrote:
> > > > > >    +struct vhost_vring_call {
> > > > > > +    struct eventfd_ctx *ctx;
> > > > > > +    struct irq_bypass_producer producer;
> > > > > > +    spinlock_t ctx_lock;
> > > > > It's not clear to me why we need ctx_lock here.
> > > > > 
> > > > > Thanks
> > > > Hi Jason,
> > > > 
> > > > we use this lock to protect the eventfd_ctx and irq from race conditions,
> > > We don't support irq notification from vDPA device driver in this version,
> > > do we still have race condition?
> > > 
> > > Thanks
> > Jason I'm not sure what you are trying to say here.
> 
> 
> I meant we change the API from V4 so driver won't notify us if irq is
> changed.
> 
> Then it looks to me there's no need for the ctx_lock, everyhing could be
> synchronized with vq mutex.
> 
> Thanks

Jason do you want to post a cleanup patch simplifying code along these
lines?

Thanks,


> > 
> > 

