Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F39AF209C49
	for <lists+kvm@lfdr.de>; Thu, 25 Jun 2020 11:50:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390150AbgFYJul (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 25 Jun 2020 05:50:41 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:54139 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1728725AbgFYJuk (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 25 Jun 2020 05:50:40 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1593078639;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=KedBPS+NpC8etXkXNTeGxZ25U7K2d6TeusgIBHRfbZM=;
        b=hBoz0d3mSzHp2S5GRm8+EZsxExWcsZbh3RmN28pa4qv2OyF4xe4VuI+WF65l5EhsbJMlIM
        uah5aqvpXeP+ZkuYaf+DS1RgSLVOaqtnQu0EDpky9maekyYu+agHxJACtA4ECQjps/fhiU
        V4mAtax6qHV9RsmbGfRVqchv514pE8c=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-245-wGy3wj-TNfWzFH6L1zzIXQ-1; Thu, 25 Jun 2020 05:50:37 -0400
X-MC-Unique: wGy3wj-TNfWzFH6L1zzIXQ-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id F2990100960F;
        Thu, 25 Jun 2020 09:50:35 +0000 (UTC)
Received: from gondolin (ovpn-112-36.ams2.redhat.com [10.36.112.36])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 7B3DF619C0;
        Thu, 25 Jun 2020 09:50:26 +0000 (UTC)
Date:   Thu, 25 Jun 2020 11:49:58 +0200
From:   Cornelia Huck <cohuck@redhat.com>
To:     David Hildenbrand <david@redhat.com>
Cc:     David Gibson <david@gibson.dropbear.id.au>, qemu-devel@nongnu.org,
        brijesh.singh@amd.com, pair@us.ibm.com, pbonzini@redhat.com,
        dgilbert@redhat.com, frankja@linux.ibm.com,
        Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
        kvm@vger.kernel.org, qemu-ppc@nongnu.org, mst@redhat.com,
        mdroth@linux.vnet.ibm.com, Richard Henderson <rth@twiddle.net>,
        pasic@linux.ibm.com, Eduardo Habkost <ehabkost@redhat.com>,
        qemu-s390x@nongnu.org
Subject: Re: [PATCH v3 0/9] Generalize memory encryption models
Message-ID: <20200625114958.6d1981fe.cohuck@redhat.com>
In-Reply-To: <778050eb-c6b2-e471-1945-598520fdc894@redhat.com>
References: <20200619020602.118306-1-david@gibson.dropbear.id.au>
        <e045e202-cd56-4ddc-8c1d-a2fe5a799d32@redhat.com>
        <20200619094820.GJ17085@umbus.fritz.box>
        <a1f47bc3-40d6-f46e-42e7-9c44597c3c90@redhat.com>
        <20200625054201.GE172395@umbus.fritz.box>
        <778050eb-c6b2-e471-1945-598520fdc894@redhat.com>
Organization: Red Hat GmbH
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, 25 Jun 2020 08:59:00 +0200
David Hildenbrand <david@redhat.com> wrote:

> >>>> How do upper layers actually figure out if memory encryption etc is
> >>>> available? on s390x, it's simply via the expanded host CPU model.  
> >>>
> >>> Haven't really tackled that yet.  But one way that works for multiple
> >>> systems has got to be better than a separate one for each, right?  
> >>
> >> I think that's an important piece. Especially once multiple different
> >> approaches are theoretically available one wants to sense from upper layers.  
> > 
> > Fair point.
> > 
> > So... IIRC there's a general way of looking at available properties
> > for any object, including the machine.  So we can probe for
> > availability of the "host-trust-limitation" property itself easily
> > enough.  
> 
> You can have a look at how it's currently probed by libvirt in
> 
> https://www.redhat.com/archives/libvir-list/2020-June/msg00518.html
> 
> For now, the s390x check consists of
> - checking if /sys/firmware/uv is available
> - checking if the kernel cmdline contains 'prot_virt=1'
> 
> The sev check is
> - checking if /sys/module/kvm_amd/parameters/sev contains the
>    value '1'
> - checking if /dev/sev
> 
> So at least libvirt does not sense via the CPU model on s390x yet.

It checks for 158 (which is apparently 'host supports secure
execution'). IIUC, only 161 ('unpack facility') is relevant for the
guest... does that also show up on the host? (I guess it does, as it
describes an ultravisor feature, IIUC.) If it is always implied,
libvirt probably does not need an extra check.

