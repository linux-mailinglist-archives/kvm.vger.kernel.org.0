Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DF079135EA2
	for <lists+kvm@lfdr.de>; Thu,  9 Jan 2020 17:47:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387835AbgAIQrj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 9 Jan 2020 11:47:39 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:56356 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1730602AbgAIQrj (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 9 Jan 2020 11:47:39 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1578588458;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=H7yvRcnHtdyGEcTJgOAUtJzzkjbm96l99F3Bt+eWI8s=;
        b=Bw9NA0CTdHqRcrpkN6dqpoYg8PkiRCNAozb/XYj3m+VTqJdLNJQeK2RRGZbtissCMb1asj
        EYBughyjY/YuLrDeeGaG0iBeA2TYwCoZzneLvsaGHiITdNdXRx4RhAq2NXjePCgnO4Mr1y
        iRcCg4DA7r2QW+V+m8Kar39cXZRynIg=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-178-PPGhbvvvOrSIrVG1C-5OsQ-1; Thu, 09 Jan 2020 11:47:22 -0500
X-MC-Unique: PPGhbvvvOrSIrVG1C-5OsQ-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 965E51132C9E;
        Thu,  9 Jan 2020 16:47:20 +0000 (UTC)
Received: from w520.home (ovpn-116-128.phx2.redhat.com [10.3.116.128])
        by smtp.corp.redhat.com (Postfix) with ESMTP id C1E1A10013A7;
        Thu,  9 Jan 2020 16:47:12 +0000 (UTC)
Date:   Thu, 9 Jan 2020 09:47:11 -0700
From:   Alex Williamson <alex.williamson@redhat.com>
To:     Peter Xu <peterx@redhat.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Christophe de Dinechin <dinechin@redhat.com>,
        "Michael S . Tsirkin" <mst@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Yan Zhao <yan.y.zhao@intel.com>,
        Jason Wang <jasowang@redhat.com>,
        Kevin Kevin <kevin.tian@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        "Dr . David Alan Gilbert" <dgilbert@redhat.com>,
        Kirti Wankhede <kwankhede@nvidia.com>
Subject: Re: [PATCH v3 00/21] KVM: Dirty ring interface
Message-ID: <20200109094711.00eb96b1@w520.home>
In-Reply-To: <20200109145729.32898-1-peterx@redhat.com>
References: <20200109145729.32898-1-peterx@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu,  9 Jan 2020 09:57:08 -0500
Peter Xu <peterx@redhat.com> wrote:

> Branch is here: https://github.com/xzpeter/linux/tree/kvm-dirty-ring
> (based on kvm/queue)
> 
> Please refer to either the previous cover letters, or documentation
> update in patch 12 for the big picture.  Previous posts:
> 
> V1: https://lore.kernel.org/kvm/20191129213505.18472-1-peterx@redhat.com
> V2: https://lore.kernel.org/kvm/20191221014938.58831-1-peterx@redhat.com
> 
> The major change in V3 is that we dropped the whole waitqueue and the
> global lock. With that, we have clean per-vcpu ring and no default
> ring any more.  The two kvmgt refactoring patches were also included
> to show the dependency of the works.

Hi Peter,

Would you recommend this style of interface for vfio dirty page
tracking as well?  This mechanism seems very tuned to sparse page
dirtying, how well does it handle fully dirty, or even significantly
dirty regions?  We also don't really have "active" dirty page tracking
in vfio, we simply assume that if a page is pinned or otherwise mapped
that it's dirty, so I think we'd constantly be trying to re-populate
the dirty ring with pages that we've seen the user consume, which
doesn't seem like a good fit versus a bitmap solution.  Thanks,

Alex

