Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7FBF230B916
	for <lists+kvm@lfdr.de>; Tue,  2 Feb 2021 09:01:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230073AbhBBIAs (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 2 Feb 2021 03:00:48 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:49755 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229511AbhBBIAo (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 2 Feb 2021 03:00:44 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1612252758;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Qr/EBv5x90hPAyplhITInR4O7nt+NV3Z854L2GClqxI=;
        b=AqscvCrYBVs+PlN4DXTxvYZ36Y8FRS3GKptilyoVFH4i8Sww+eXwq0zp5UxiMHMa3qSEvZ
        AC9d96y7mV72kmUXOTpxBf1BIabfUNM5Zrm0pXGwROs7JqMN9SQkcm8fas0D6R60bxEpIE
        3kYQkcuGYy2P4x4pY9Euc+/cqa9ZpkY=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-9-OZpaACF5OKmSbUNVcVUenA-1; Tue, 02 Feb 2021 02:59:13 -0500
X-MC-Unique: OZpaACF5OKmSbUNVcVUenA-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 48DB01800D50;
        Tue,  2 Feb 2021 07:59:11 +0000 (UTC)
Received: from gondolin (ovpn-113-169.ams2.redhat.com [10.36.113.169])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 8A6C21975E;
        Tue,  2 Feb 2021 07:59:02 +0000 (UTC)
Date:   Tue, 2 Feb 2021 08:58:59 +0100
From:   Cornelia Huck <cohuck@redhat.com>
To:     Alex Williamson <alex.williamson@redhat.com>
Cc:     Matthew Rosato <mjrosato@linux.ibm.com>,
        Max Gurtovoy <mgurtovoy@nvidia.com>, jgg@nvidia.com,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        liranl@nvidia.com, oren@nvidia.com, tzahio@nvidia.com,
        leonro@nvidia.com, yarong@nvidia.com, aviadye@nvidia.com,
        shahafs@nvidia.com, artemp@nvidia.com, kwankhede@nvidia.com,
        ACurrid@nvidia.com, gmataev@nvidia.com, cjia@nvidia.com,
        yishaih@nvidia.com, aik@ozlabs.ru
Subject: Re: [PATCH 6/9] vfio-pci/zdev: fix possible segmentation fault
 issue
Message-ID: <20210202085859.12c09b6d.cohuck@redhat.com>
In-Reply-To: <20210201134757.375c91bf@omen.home.shazbot.org>
References: <20210201162828.5938-1-mgurtovoy@nvidia.com>
        <20210201162828.5938-7-mgurtovoy@nvidia.com>
        <20210201175214.0dc3ba14.cohuck@redhat.com>
        <139adb14-f75a-25ef-06da-e87729c2ccf2@linux.ibm.com>
        <20210201134757.375c91bf@omen.home.shazbot.org>
Organization: Red Hat GmbH
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, 1 Feb 2021 13:47:57 -0700
Alex Williamson <alex.williamson@redhat.com> wrote:

> On Mon, 1 Feb 2021 12:08:45 -0500
> Matthew Rosato <mjrosato@linux.ibm.com> wrote:
> 
> > On 2/1/21 11:52 AM, Cornelia Huck wrote:  
> > > On Mon, 1 Feb 2021 16:28:25 +0000
> > > Max Gurtovoy <mgurtovoy@nvidia.com> wrote:
> > >     
> > >> In case allocation fails, we must behave correctly and exit with error.
> > >>
> > >> Signed-off-by: Max Gurtovoy <mgurtovoy@nvidia.com>    
> > > 
> > > Fixes: e6b817d4b821 ("vfio-pci/zdev: Add zPCI capabilities to VFIO_DEVICE_GET_INFO")
> > > 
> > > Reviewed-by: Cornelia Huck <cohuck@redhat.com>
> > > 
> > > I think this should go in independently of this series. >    
> > 
> > Agreed, makes sense to me -- thanks for finding.
> > 
> > Reviewed-by: Matthew Rosato <mjrosato@linux.ibm.com>  
> 
> I can grab this one, and 5/9.  Connie do you want to toss an R-b at
> 5/9?  Thanks,
> 
> Alex

Yes, makes sense to grab these two. R-b added.

