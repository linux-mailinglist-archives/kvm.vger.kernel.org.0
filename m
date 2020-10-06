Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4A1DB284D6F
	for <lists+kvm@lfdr.de>; Tue,  6 Oct 2020 16:15:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726536AbgJFOPJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 6 Oct 2020 10:15:09 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:53591 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726487AbgJFOPJ (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 6 Oct 2020 10:15:09 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1601993708;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=qierp6TmZvlqYsC8Xw2Zd9AVjsf7lgKlqdSsuItngyI=;
        b=dCxyMi/IY0av42Bd+0g2Y9fTILcSN/qkbfWglo3eZ1pX/h+akzQAvOqB5gX7HAoOOlVgus
        Hce6NN5m3RPTGEMpEhrrk9O1FMEZ45Bj7uR+Uz3kSvLe9Dgo2XEsRUmaEOKsXwsh9CgUig
        /hq3R4Jt26/fU9/e142kOcxyiht+4rQ=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-385-X0pYrsl5MgipFxSkDkPWPg-1; Tue, 06 Oct 2020 10:15:06 -0400
X-MC-Unique: X0pYrsl5MgipFxSkDkPWPg-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 245F218A8225;
        Tue,  6 Oct 2020 14:15:05 +0000 (UTC)
Received: from horse.redhat.com (ovpn-117-72.rdu2.redhat.com [10.10.117.72])
        by smtp.corp.redhat.com (Postfix) with ESMTP id ED9BA18E3C;
        Tue,  6 Oct 2020 14:15:01 +0000 (UTC)
Received: by horse.redhat.com (Postfix, from userid 10451)
        id 6CB52220AD7; Tue,  6 Oct 2020 10:15:01 -0400 (EDT)
Date:   Tue, 6 Oct 2020 10:15:01 -0400
From:   Vivek Goyal <vgoyal@redhat.com>
To:     Vitaly Kuznetsov <vkuznets@redhat.com>
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        virtio-fs-list <virtio-fs@redhat.com>, pbonzini@redhat.com
Subject: Re: [PATCH v4] kvm,x86: Exit to user space in case page fault error
Message-ID: <20201006141501.GC5306@redhat.com>
References: <20201002153854.GC3119@redhat.com>
 <20201002183036.GB24460@linux.intel.com>
 <20201002192734.GD3119@redhat.com>
 <20201002194517.GD24460@linux.intel.com>
 <20201002200214.GB10232@redhat.com>
 <20201002211314.GE24460@linux.intel.com>
 <20201005153318.GA4302@redhat.com>
 <20201005161620.GC11938@linux.intel.com>
 <20201006134629.GB5306@redhat.com>
 <877ds38n6r.fsf@vitty.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <877ds38n6r.fsf@vitty.brq.redhat.com>
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Oct 06, 2020 at 04:05:16PM +0200, Vitaly Kuznetsov wrote:
> Vivek Goyal <vgoyal@redhat.com> writes:
> 
> > A. Just exit to user space with -EFAULT (using kvm request) and don't
> >    wait for the accessing task to run on vcpu again. 
> 
> What if we also save the required information (RIP, GFN, ...) in the
> guest along with the APF token

Can you elaborate a bit more on this. You mean save GFN on stack before
it starts waiting for PAGE_READY event?

> so in case of -EFAULT we can just 'crash'
> the guest and the required information can easily be obtained from
> kdump? This will solve the debugging problem even for TDX/SEV-ES (if
> kdump is possible there).

Just saving additional info in guest will not help because there might
be many tasks waiting and you don't know which GFN is problematic one.

Thanks
Vivek

