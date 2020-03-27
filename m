Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7B529195577
	for <lists+kvm@lfdr.de>; Fri, 27 Mar 2020 11:41:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726454AbgC0KlE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 27 Mar 2020 06:41:04 -0400
Received: from us-smtp-delivery-74.mimecast.com ([63.128.21.74]:57502 "EHLO
        us-smtp-delivery-74.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726333AbgC0KlE (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 27 Mar 2020 06:41:04 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1585305662;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=2ikhyBV+lTyNWQW7OrmnTQsuLXT8inKMBRWFmavjpcY=;
        b=e/8i2rx9jH18Lq2jk0HT7+HB1n/rb3qWTMhdjwsJPzmxkFwaeSmT4HN8dyex3Yxcx+WEbe
        Vknihsp5CWeBFTWfZPKwwh5jF+401mWYdOQXnrUIXglCeCZPnvqhxK2FQslSFh+oQYHTHJ
        OxsLhDHGtyQeGzH9Bq/sQrmIqqZPC9Q=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-298-IFpLkaC8OdajWJjN-oYbqA-1; Fri, 27 Mar 2020 06:41:00 -0400
X-MC-Unique: IFpLkaC8OdajWJjN-oYbqA-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id A31AB1005524;
        Fri, 27 Mar 2020 10:40:59 +0000 (UTC)
Received: from gondolin (ovpn-113-83.ams2.redhat.com [10.36.113.83])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 94D325C1D6;
        Fri, 27 Mar 2020 10:40:52 +0000 (UTC)
Date:   Fri, 27 Mar 2020 11:40:49 +0100
From:   Cornelia Huck <cohuck@redhat.com>
To:     Christian Borntraeger <borntraeger@de.ibm.com>
Cc:     Janosch Frank <frankja@linux.vnet.ibm.com>,
        KVM <kvm@vger.kernel.org>, David Hildenbrand <david@redhat.com>,
        linux-s390 <linux-s390@vger.kernel.org>,
        Heiko Carstens <heiko.carstens@de.ibm.com>
Subject: Re: [PATCH v2] s390/gmap: return proper error code on ksm unsharing
Message-ID: <20200327114049.3d2aa4c7.cohuck@redhat.com>
In-Reply-To: <20200327113954.6d7c31e6.cohuck@redhat.com>
References: <20200327092356.25171-1-borntraeger@de.ibm.com>
        <859b9810-eb50-6f81-ec12-3f22cc5c1d2c@de.ibm.com>
        <20200327113954.6d7c31e6.cohuck@redhat.com>
Organization: Red Hat GmbH
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, 27 Mar 2020 11:39:54 +0100
Cornelia Huck <cohuck@redhat.com> wrote:

> On Fri, 27 Mar 2020 11:23:33 +0100
> Christian Borntraeger <borntraeger@de.ibm.com> wrote:
> 
> > On 27.03.20 10:23, Christian Borntraeger wrote:
> 
> > After the qemu patch discussion I would add
> > 
> > 
> > diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
> > index 0e268b3d1591..ba8f9cbe4376 100644
> > --- a/Documentation/virt/kvm/api.rst
> > +++ b/Documentation/virt/kvm/api.rst
> > @@ -4680,6 +4680,12 @@ KVM_PV_ENABLE
> >    command has succeeded, any CPU added via hotplug will become
> >    protected during its creation as well.
> >  
> > +  Errors:
> > +
> > +  =====      =============================
> > +  EINTR      an unmasked signal is pending
> > +  =====      =============================
> > +
> >  KVM_PV_DISABLE
> >  
> >    Deregister the VM from the Ultravisor and reclaim the memory that
> > 
> > 
> > and change the patch description to something like
> > 
> > 
> >     s390/gmap: return proper error code on ksm unsharing
> >     
> >     If a signal is pending we might return -ENOMEM instead of -EINTR.
> >     We should propagate the proper error during KSM unsharing.
> >     unmerge_ksm_pages returns -ERESTARTSYS on signal_pending. This gets
> >     translated by entry.S to -EINTR. It is important to get this error
> >     code so that userspace can retry.
> >     
> >     Fixes: 3ac8e38015d4 ("s390/mm: disable KSM for storage key enabled pages")
> >     Reviewed-by: Janosch Frank <frankja@linux.vnet.ibm.com>
> >     Reported-by: Marc Hartmayer <mhartmay@linux.ibm.com>
> >     Tested-by: Marc Hartmayer <mhartmay@linux.ibm.com>
> >     Reviewed-by: David Hildenbrand <david@redhat.com>
> >     Signed-off-by: Christian Borntraeger <borntraeger@de.ibm.com>
> > 
> 
> LGTM

...well, if you add my

Reviewed-by: Cornelia Huck <cohuck@redhat.com>

