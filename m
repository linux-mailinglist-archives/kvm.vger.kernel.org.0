Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 00EB916A46C
	for <lists+kvm@lfdr.de>; Mon, 24 Feb 2020 11:57:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727277AbgBXK5K (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 24 Feb 2020 05:57:10 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:39532 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726216AbgBXK5K (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 24 Feb 2020 05:57:10 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1582541829;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=/1CCPaVc2aLA8NjqXCPZT0Ga6w227BL2pWYhrzftV6o=;
        b=Z6vgo9GjVuXXTNbukTnEgOdraeg9JgyvDI2xUZknZRqdc5BPFVT0n/gINM4MIz+oJ21iGy
        FnC6AnskbXrYU6j/Muej1bhsDyPOt/3IN85lacSBRUBQ4V1iynCd15AMSRRnJjzUxB7hjQ
        sxCcOLBnHAopUcklobBu/awPmecxyVE=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-382-KkcF6BPkPU6Cx1I_E9QGyw-1; Mon, 24 Feb 2020 05:57:07 -0500
X-MC-Unique: KkcF6BPkPU6Cx1I_E9QGyw-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id C6E9613F6;
        Mon, 24 Feb 2020 10:57:05 +0000 (UTC)
Received: from sirius.home.kraxel.org (ovpn-116-87.ams2.redhat.com [10.36.116.87])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 44C691001B2D;
        Mon, 24 Feb 2020 10:57:05 +0000 (UTC)
Received: by sirius.home.kraxel.org (Postfix, from userid 1000)
        id 517B21747F; Mon, 24 Feb 2020 11:57:04 +0100 (CET)
Date:   Mon, 24 Feb 2020 11:57:04 +0100
From:   Gerd Hoffmann <kraxel@redhat.com>
To:     "Tian, Kevin" <kevin.tian@intel.com>
Cc:     Chia-I Wu <olvaffe@gmail.com>, Paolo Bonzini <pbonzini@redhat.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "vkuznets@redhat.com" <vkuznets@redhat.com>,
        "wanpengli@tencent.com" <wanpengli@tencent.com>,
        "jmattson@google.com" <jmattson@google.com>,
        "joro@8bytes.org" <joro@8bytes.org>,
        Gurchetan Singh <gurchetansingh@chromium.org>,
        ML dri-devel <dri-devel@lists.freedesktop.org>,
        "Christopherson, Sean J" <sean.j.christopherson@intel.com>
Subject: Re: [RFC PATCH 0/3] KVM: x86: honor guest memory type
Message-ID: <20200224105704.55tv3ulirnse53j4@sirius.home.kraxel.org>
References: <20200213213036.207625-1-olvaffe@gmail.com>
 <8fdb85ea-6441-9519-ae35-eaf91ffe8741@redhat.com>
 <CAPaKu7T8VYXTMc1_GOzJnwBaZSG214qNoqRr8c7Z4Lb3B7dtTg@mail.gmail.com>
 <b82cd76c-0690-c13b-cf2c-75d7911c5c61@redhat.com>
 <CAPaKu7TDtFwF5czdpke1v7NWKf61kw_jVp-E1qQPqs-qbZYnMw@mail.gmail.com>
 <AADFC41AFE54684AB9EE6CBC0274A5D19D78D724@SHSMSX104.ccr.corp.intel.com>
 <CAPaKu7Qa6yzRxB10ufNxu+F5S3_GkwofKCm66aB9H4rdWj8fFQ@mail.gmail.com>
 <AADFC41AFE54684AB9EE6CBC0274A5D19D78EEA2@SHSMSX104.ccr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AADFC41AFE54684AB9EE6CBC0274A5D19D78EEA2@SHSMSX104.ccr.corp.intel.com>
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

  Hi,

> > The plan is for virtio-gpu device to reserve a huge memory region in
> > the guest.  Memslots may be added dynamically or statically to back
> > the region.
> 
> so the region is marked as E820_RESERVED to prevent guest kernel 
> from using it for other purpose and then virtio-gpu device will report
> virtio-gpu driver of the exact location of the region through its own
> interface?

It's large pci bar, to reserve address space, using (recently added)
virtio shared memory support.  dma-bufs are mapped dynamically as
sub-regions into that pci bar.

At kvm level that'll end up as one memory slot per dma-buf.

cheers,
  Gerd

