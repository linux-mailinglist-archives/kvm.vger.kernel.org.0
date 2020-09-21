Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BB6CC271C55
	for <lists+kvm@lfdr.de>; Mon, 21 Sep 2020 09:53:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726406AbgIUHxX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 21 Sep 2020 03:53:23 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:34916 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726211AbgIUHxX (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 21 Sep 2020 03:53:23 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1600674802;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=+yU0qD4mrbo+E/JHts5fvuh+XEsnmFdemkkwXFLVy4I=;
        b=EQpmjzjs81v9fV8L7tAI3Bb6Mb4F4Xl41lldGRZPd2NWFsd9zGS5+vtOiTh1QlFdQF+fD5
        T91jHsxlCNujL52PkVlHQbKwFHHKkisk/tuP7U2Acg3qkytcIS5brAjFZMfEysCR4dxnxY
        HNDbq/bGUq8U9Barr+RzuEMByPp6xYg=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-85-NEEVvtwfM5axLizBzqIYLg-1; Mon, 21 Sep 2020 03:53:18 -0400
X-MC-Unique: NEEVvtwfM5axLizBzqIYLg-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 32B551018720;
        Mon, 21 Sep 2020 07:53:17 +0000 (UTC)
Received: from [10.36.112.29] (ovpn-112-29.ams2.redhat.com [10.36.112.29])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 9A1D87882C;
        Mon, 21 Sep 2020 07:53:12 +0000 (UTC)
Subject: Re: KVM_SET_DEVICE_ATTR failed
To:     Zenghui Yu <yuzenghui@huawei.com>, qemu-arm@nongnu.org,
        kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org
Cc:     Marc Zyngier <maz@kernel.org>,
        Alex Williamson <alex.williamson@redhat.com>,
        wanghaibin.wang@huawei.com
References: <1f70926e-27dd-9e30-3d0f-770130112777@huawei.com>
From:   Auger Eric <eric.auger@redhat.com>
Message-ID: <d0c418f2-07a2-f090-e13d-f5ea299a009b@redhat.com>
Date:   Mon, 21 Sep 2020 09:53:10 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <1f70926e-27dd-9e30-3d0f-770130112777@huawei.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Zenghui,

On 9/19/20 1:15 PM, Zenghui Yu wrote:
> Hi folks,
> 
> I had booted a guest with an assigned virtual function, with GICv4
> (direct MSI injection) enabled on my arm64 server. I got the following
> QEMU error message on its shutdown:
> 
> "qemu-system-aarch64: KVM_SET_DEVICE_ATTR failed: Group 4 attr
> 0x0000000000000001: Permission denied"
> 
> The problem is that the KVM_DEV_ARM_ITS_SAVE_TABLES ioctl failed while
> stopping the VM.
> 
> As for the kernel side, it turned out that an LPI with irq->hw=true was
> observed while saving ITT for the device. KVM simply failed the save
> operation by returning -EACCES to user-space. The reason is explained in
> the comment block of vgic_its_save_itt(), though I think the HW bit
> should actually be checked in the KVM_DEV_ARM_VGIC_SAVE_PENDING_TABLES
> ioctl rather than in the ITT saving, well, it isn't much related to this
> problem...
> 
> I had noticed that some vectors had been masked by guest VF-driver on
> shutdown, the correspond VLPIs had therefore been unmapped and irq->hw
> was cleared. But some other vectors were un-handled. I *guess* that VFIO
> released these vectors *after* the KVM_DEV_ARM_ITS_SAVE_TABLES ioctl so
> that we end-up trying to save the VLPI's state.
> 
> It may not be a big problem as the guest is going to shutdown anyway and
> the whole guest save/restore on the GICv4.x system is not supported for
> the time being... I'll look at how VFIO would release these vectors but
> post it early in case this is an already known issue (and this might be
> one thing need to be considered if one wants to implement migration on
> the GICv4.x system).

Thanks for reporting the issue. I will have a look at the QEMU sequence too


Eric
> 
> 
> Thanks,
> Zenghui
> 

