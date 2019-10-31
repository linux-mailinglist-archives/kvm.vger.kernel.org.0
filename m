Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 38E07EA9EB
	for <lists+kvm@lfdr.de>; Thu, 31 Oct 2019 05:34:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726370AbfJaEeC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 31 Oct 2019 00:34:02 -0400
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:22174 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725816AbfJaEeC (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 31 Oct 2019 00:34:02 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1572496441;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=j5qcyVpwDqk90mJ8Py1Gxg6f818uFbFkJ4UO0Lw3UAI=;
        b=E0k70NUcfUYOAQJlJxUhLGopP5L/VVCfIe1wsnO/d4qhBcb2T99JXOIqc1JI+3VcVOPEQL
        UlVZKMGk0us160ez2vpd0tkO57fV/FCbJGQDJViSrOu5Zqs+nUJccuFULdQSiMHo8XQ8/y
        u1nY3ZcvA7UwQNiUNb/uUQ55C0lU38g=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-395-pwcln2pkOUya02HzONlt1Q-1; Thu, 31 Oct 2019 00:33:57 -0400
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 22B688017E0;
        Thu, 31 Oct 2019 04:33:56 +0000 (UTC)
Received: from [10.72.12.100] (ovpn-12-100.pek2.redhat.com [10.72.12.100])
        by smtp.corp.redhat.com (Postfix) with ESMTP id B8616600CD;
        Thu, 31 Oct 2019 04:33:23 +0000 (UTC)
Subject: Re: [RFC v2 00/22] intel_iommu: expose Shared Virtual Addressing to
 VM
To:     "Tian, Kevin" <kevin.tian@intel.com>,
        "Liu, Yi L" <yi.l.liu@intel.com>,
        "qemu-devel@nongnu.org" <qemu-devel@nongnu.org>,
        "mst@redhat.com" <mst@redhat.com>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
        "peterx@redhat.com" <peterx@redhat.com>
Cc:     "tianyu.lan@intel.com" <tianyu.lan@intel.com>,
        "jacob.jun.pan@linux.intel.com" <jacob.jun.pan@linux.intel.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "Tian, Jun J" <jun.j.tian@intel.com>,
        "eric.auger@redhat.com" <eric.auger@redhat.com>,
        "Sun, Yi Y" <yi.y.sun@intel.com>,
        "david@gibson.dropbear.id.au" <david@gibson.dropbear.id.au>
References: <1571920483-3382-1-git-send-email-yi.l.liu@intel.com>
 <367adad0-eb05-c950-21d7-755fffacbed6@redhat.com>
 <AADFC41AFE54684AB9EE6CBC0274A5D19D5D0619@SHSMSX104.ccr.corp.intel.com>
From:   Jason Wang <jasowang@redhat.com>
Message-ID: <fa994379-a847-0ffe-5043-40a2aefecf43@redhat.com>
Date:   Thu, 31 Oct 2019 12:33:14 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <AADFC41AFE54684AB9EE6CBC0274A5D19D5D0619@SHSMSX104.ccr.corp.intel.com>
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
X-MC-Unique: pwcln2pkOUya02HzONlt1Q-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


On 2019/10/25 =E4=B8=8B=E5=8D=886:12, Tian, Kevin wrote:
>> From: Jason Wang [mailto:jasowang@redhat.com]
>> Sent: Friday, October 25, 2019 5:49 PM
>>
>>
>> On 2019/10/24 =E4=B8=8B=E5=8D=888:34, Liu Yi L wrote:
>>> Shared virtual address (SVA), a.k.a, Shared virtual memory (SVM) on Int=
el
>>> platforms allow address space sharing between device DMA and
>> applications.
>>
>>
>> Interesting, so the below figure demonstrates the case of VM. I wonder
>> how much differences if we compare it with doing SVM between device
>> and
>> an ordinary process (e.g dpdk)?
>>
>> Thanks
> One difference is that ordinary process requires only stage-1 translation=
,
> while VM requires nested translation.


A silly question, then I believe there's no need for VFIO DMA API in=20
this case consider the page table is shared between MMU and IOMMU?

Thanks

>

