Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E435C1ABD8C
	for <lists+kvm@lfdr.de>; Thu, 16 Apr 2020 12:06:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2504684AbgDPKGD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 16 Apr 2020 06:06:03 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:42087 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S2504629AbgDPKF5 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 16 Apr 2020 06:05:57 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1587031556;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ty6Z8UVku80uLPKqpG/bK1so+aAxk3CuiSE3D0QPpK8=;
        b=Kahh3Q4+dPOnoSMUZB7T2HQ2Tr80KqsVlQ1fx0HYU32AhG312cKz+0L09Vvttneiex8uHV
        YmrJVdsS+yR37BLd5T7vgxsRNbwznGHi220fatLdNmpcJGzJNBSvazMl+th2+HsnM5F/VY
        mY99kLYXZIRY3sp/pWDBKMMKlwM1nl4=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-328-JPTMWRtDMI6k6O27XQEnjA-1; Thu, 16 Apr 2020 06:05:54 -0400
X-MC-Unique: JPTMWRtDMI6k6O27XQEnjA-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 671ACA0CC1;
        Thu, 16 Apr 2020 10:05:52 +0000 (UTC)
Received: from gondolin (ovpn-112-234.ams2.redhat.com [10.36.112.234])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 0F597105911B;
        Thu, 16 Apr 2020 10:05:46 +0000 (UTC)
Date:   Thu, 16 Apr 2020 12:05:44 +0200
From:   Cornelia Huck <cohuck@redhat.com>
To:     Tony Krowiak <akrowiak@linux.ibm.com>
Cc:     linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, freude@linux.ibm.com, borntraeger@de.ibm.com,
        mjrosato@linux.ibm.com, pmorel@linux.ibm.com, pasic@linux.ibm.com,
        alex.williamson@redhat.com, kwankhede@nvidia.com,
        jjherne@linux.ibm.com, fiuczy@linux.ibm.com
Subject: Re: [PATCH v7 03/15] s390/zcrypt: driver callback to indicate
 resource in use
Message-ID: <20200416120544.053b38d8.cohuck@redhat.com>
In-Reply-To: <0f193571-1ff6-08f3-d02d-b4f40d2930c8@linux.ibm.com>
References: <20200407192015.19887-1-akrowiak@linux.ibm.com>
        <20200407192015.19887-4-akrowiak@linux.ibm.com>
        <20200414140838.54f777b8.cohuck@redhat.com>
        <0f193571-1ff6-08f3-d02d-b4f40d2930c8@linux.ibm.com>
Organization: Red Hat GmbH
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, 15 Apr 2020 13:10:18 -0400
Tony Krowiak <akrowiak@linux.ibm.com> wrote:

> On 4/14/20 8:08 AM, Cornelia Huck wrote:
> > On Tue,  7 Apr 2020 15:20:03 -0400
> > Tony Krowiak <akrowiak@linux.ibm.com> wrote:

> >> @@ -995,9 +996,11 @@ int ap_parse_mask_str(const char *str,
> >>   	newmap = kmalloc(size, GFP_KERNEL);
> >>   	if (!newmap)
> >>   		return -ENOMEM;
> >> -	if (mutex_lock_interruptible(lock)) {
> >> -		kfree(newmap);
> >> -		return -ERESTARTSYS;
> >> +	if (lock) {
> >> +		if (mutex_lock_interruptible(lock)) {
> >> +			kfree(newmap);
> >> +			return -ERESTARTSYS;
> >> +		}  
> > This whole function is a bit odd. It seems all masks we want to
> > manipulate are always guarded by the ap_perms_mutex, and the need for
> > allowing lock == NULL comes from wanting to call this function with the
> > ap_perms_mutex already held.
> >
> > That would argue for a locked/unlocked version of this function... but
> > looking at it, why do we lock the way we do? The one thing this
> > function (prior to this patch) does outside of the holding of the mutex
> > is the allocation and freeing of newmap. But with this patch, we do the
> > allocation and freeing of newmap while holding the mutex. Something
> > seems a bit weird here.  
> 
> Note that the ap_parse_mask function copies the newmap
> to the bitmap passed in as a parameter to the function.
> Prior to the introduction of this patch, the calling functions - i.e.,
> apmask_store(), aqmask_store() and ap_perms_init() - passed
> in the actual bitmap (i.e., ap_perms.apm or ap_perms aqm),
> so the ap_perms were changed directly by this function.
> 
> With this patch, the apmask_store() and aqmask_store()
> functions now pass in a copy of those bitmaps. This is so
> we can verify that any APQNs being removed are not
> in use by the vfio_ap device driver before committing the
> change to ap_perms. Consequently, it is now necessary
> to take the lock for the until the changes are committed.

Yes, but every caller actually takes the mutex before calling this
function already :)

> Having explained that, you make a valid argument that
> this calls for a locked/unlocked version of this function, so
> I will modify this patch to that effect.

Ok.

The other thing I found weird is that the function does
alloc newmap -> grab mutex -> do manipulation -> release mutex -> free newmap

while the new callers do
(mutex already held) -> alloc newmap

so why grab/release the mutex the way the function does now? IOW, why
not have an unlocked __ap_parse_mask_string() and do

int ap_parse_mask_string(...)
{
	int rc;

	if (mutex_lock_interruptible(&ap_perms_mutex))
		return -ERESTARTSYS;
	rc = __ap_parse_mask_string(...);
        mutex_unlock(&ap_perms_mutex);
	return rc;
}

