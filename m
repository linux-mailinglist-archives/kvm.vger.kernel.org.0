Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E2D051C505F
	for <lists+kvm@lfdr.de>; Tue,  5 May 2020 10:33:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728488AbgEEId3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 5 May 2020 04:33:29 -0400
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:35576 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727784AbgEEId3 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 5 May 2020 04:33:29 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1588667608;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=cxZ3uZ0zoCJmHZiRVgV/TlO2GfBb/WBpAElEsKGOLxs=;
        b=NSbRp6K1rzkE7dYUxmLC8o2GnjMMJU8TmhQ/GiQAs3e8hOB2ZPSAAimAvKDQjWmGqGgQ29
        YiUvxD5wYgw0u0Q4zzL9rsMAfBe2hKplzXN32TNgXLZ7LP+lpxgKE0YS+TbYHiF629Su9f
        gTPbk+8v2IIMfEDfTVbcoIS8Mdl609U=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-415-Uh8ED_ZoORuyA8xJ0qPdig-1; Tue, 05 May 2020 04:33:26 -0400
X-MC-Unique: Uh8ED_ZoORuyA8xJ0qPdig-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 40C2E800687;
        Tue,  5 May 2020 08:33:25 +0000 (UTC)
Received: from gondolin (ovpn-112-219.ams2.redhat.com [10.36.112.219])
        by smtp.corp.redhat.com (Postfix) with ESMTP id E1B8A600F5;
        Tue,  5 May 2020 08:33:20 +0000 (UTC)
Date:   Tue, 5 May 2020 10:33:19 +0200
From:   Cornelia Huck <cohuck@redhat.com>
To:     Christian Borntraeger <borntraeger@de.ibm.com>
Cc:     David Hildenbrand <david@redhat.com>,
        Janosch Frank <frankja@linux.vnet.ibm.com>,
        KVM <kvm@vger.kernel.org>,
        linux-s390 <linux-s390@vger.kernel.org>,
        Qian Cai <cailca@icloud.com>,
        Pierre Morel <pmorel@linux.ibm.com>,
        Tony Krowiak <akrowiak@linux.ibm.com>
Subject: Re: [PATCH] KVM: s390: Remove false WARN_ON_ONCE for the PQAP
 instruction
Message-ID: <20200505103145.1057c2a3.cohuck@redhat.com>
In-Reply-To: <480b0bff-8eb5-f75c-a3ce-2555e38917ee@de.ibm.com>
References: <20200505073525.2287-1-borntraeger@de.ibm.com>
        <20200505095332.528254e5.cohuck@redhat.com>
        <f3512a63-91dc-ab9a-a9ab-3e2a6e24fea3@de.ibm.com>
        <59f1b90c-47d6-2661-0e99-548a53c9bcd6@redhat.com>
        <480b0bff-8eb5-f75c-a3ce-2555e38917ee@de.ibm.com>
Organization: Red Hat GmbH
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 5 May 2020 10:27:16 +0200
Christian Borntraeger <borntraeger@de.ibm.com> wrote:

> On 05.05.20 10:04, David Hildenbrand wrote:
> > On 05.05.20 09:55, Christian Borntraeger wrote:  
> >>
> >>
> >> On 05.05.20 09:53, Cornelia Huck wrote:  
> >>> On Tue,  5 May 2020 09:35:25 +0200
> >>> Christian Borntraeger <borntraeger@de.ibm.com> wrote:
> >>>  
> >>>> In LPAR we will only get an intercept for FC==3 for the PQAP
> >>>> instruction. Running nested under z/VM can result in other intercepts as
> >>>> well, for example PQAP(QCI). So the WARN_ON_ONCE is not right. Let
> >>>> us simply remove it.  
> >>>
> >>> While I agree with removing the WARN_ON_ONCE, I'm wondering why z/VM
> >>> gives us intercepts for those fcs... is that just a result of nesting
> >>> (or the z/VM implementation), or is there anything we might want to do?  
> >>
> >> Yes nesting. 
> >> The ECA bit for interpretion is an effective one. So if the ECA bit is off
> >> in z/VM (no crypto cards) our ECA bit is basically ignored as these bits
> >> are ANDed.
> >> I asked Tony to ask the z/VM team if that is the case here.
> >>  
> > 
> > So we can't detect if we have support for ECA_APIE, because there is no
> > explicit feature bit, right? Rings a bell. Still an ugly
> > hardware/firmware specification.  
> 
> Yes, no matter if this is the case here, we cannot rely on ECA_APIE to not
> trigger intercepts. So we must remove the WARN_ON. 
> 
> cc stable?

Agreed.

> 
> > 
> > Seems to be the right thing to do
> > 
> > Reviewed-by: David Hildenbrand <david@redhat.com>
> >   
> 

