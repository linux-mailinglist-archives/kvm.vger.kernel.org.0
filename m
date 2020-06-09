Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0C2FF1F4087
	for <lists+kvm@lfdr.de>; Tue,  9 Jun 2020 18:19:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728333AbgFIQTU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 9 Jun 2020 12:19:20 -0400
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:23385 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725894AbgFIQTT (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 9 Jun 2020 12:19:19 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1591719558;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=xIjfaioqmBdVChcuQCpcGGXIjUXo4w4gXfPUySK3fk8=;
        b=QbHK2GE1gnIkXL59cGoVG247P1nlPgbSf8iSUBY3HWGsWzPYuDKJ9UFNtdcfdptfZfnWFd
        2Y8v35rLMEov8y8a4K9l2CyaVsL8Rg+XTT/oPvdCiWfSI3xhHtqWPCJcMrR/hwnvwvtrlI
        CMTvNmZJNluRZcYS/FTPbjN4ZGkO980=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-485-FOFoOAkGP-mJYruZWnJrDw-1; Tue, 09 Jun 2020 12:19:08 -0400
X-MC-Unique: FOFoOAkGP-mJYruZWnJrDw-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 08210107AFB2;
        Tue,  9 Jun 2020 16:18:56 +0000 (UTC)
Received: from localhost (ovpn-113-3.phx2.redhat.com [10.3.113.3])
        by smtp.corp.redhat.com (Postfix) with ESMTP id E37958FF9A;
        Tue,  9 Jun 2020 16:18:14 +0000 (UTC)
Date:   Tue, 9 Jun 2020 12:18:14 -0400
From:   Eduardo Habkost <ehabkost@redhat.com>
To:     "Michael S. Tsirkin" <mst@redhat.com>
Cc:     David Hildenbrand <david@redhat.com>, qemu-devel@nongnu.org,
        kvm@vger.kernel.org, qemu-s390x@nongnu.org,
        Richard Henderson <rth@twiddle.net>,
        Paolo Bonzini <pbonzini@redhat.com>,
        "Dr . David Alan Gilbert" <dgilbert@redhat.com>,
        teawater <teawaterz@linux.alibaba.com>,
        Pankaj Gupta <pankaj.gupta.linux@gmail.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Eric Blake <eblake@redhat.com>,
        Eric Farman <farman@linux.ibm.com>,
        Hailiang Zhang <zhang.zhanghailiang@huawei.com>,
        Halil Pasic <pasic@linux.ibm.com>,
        Igor Mammedov <imammedo@redhat.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Juan Quintela <quintela@redhat.com>,
        Keith Busch <kbusch@kernel.org>,
        Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
        Markus Armbruster <armbru@redhat.com>,
        Peter Maydell <peter.maydell@linaro.org>,
        Pierre Morel <pmorel@linux.ibm.com>,
        Tony Krowiak <akrowiak@linux.ibm.com>
Subject: Re: [PATCH v3 00/20] virtio-mem: Paravirtualized memory hot(un)plug
Message-ID: <20200609161814.GJ2366737@habkost.net>
References: <20200603144914.41645-1-david@redhat.com>
 <20200609091034-mutt-send-email-mst@kernel.org>
 <08385823-d98f-fd9d-aa9d-bc1bd6747c29@redhat.com>
 <20200609115814-mutt-send-email-mst@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200609115814-mutt-send-email-mst@kernel.org>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Jun 09, 2020 at 11:59:04AM -0400, Michael S. Tsirkin wrote:
> On Tue, Jun 09, 2020 at 03:26:08PM +0200, David Hildenbrand wrote:
> > On 09.06.20 15:11, Michael S. Tsirkin wrote:
> > > On Wed, Jun 03, 2020 at 04:48:54PM +0200, David Hildenbrand wrote:
> > >> This is the very basic, initial version of virtio-mem. More info on
> > >> virtio-mem in general can be found in the Linux kernel driver v2 posting
> > >> [1] and in patch #10. The latest Linux driver v4 can be found at [2].
> > >>
> > >> This series is based on [3]:
> > >>     "[PATCH v1] pc: Support coldplugging of virtio-pmem-pci devices on all
> > >>      buses"
> > >>
> > >> The patches can be found at:
> > >>     https://github.com/davidhildenbrand/qemu.git virtio-mem-v3
> > > 
> > > So given we tweaked the config space a bit, this needs a respin.
> > 
> > Yeah, the virtio-mem-v4 branch already contains a fixed-up version. Will
> > send during the next days.
> 
> BTW. People don't normally capitalize the letter after ":".
> So a better subject is
>   virtio-mem: paravirtualized memory hot(un)plug

I'm not sure that's still the rule:

[qemu/(49ee115552...)]$ git log --oneline v4.0.0.. | egrep ': [A-Z]' | wc -l
5261
[qemu/(49ee115552...)]$ git log --oneline v4.0.0.. | egrep ': [a-z]' | wc -l
2921

-- 
Eduardo

