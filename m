Return-Path: <kvm+bounces-13515-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id C119D898105
	for <lists+kvm@lfdr.de>; Thu,  4 Apr 2024 07:35:58 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id CDD181C234CE
	for <lists+kvm@lfdr.de>; Thu,  4 Apr 2024 05:35:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5367943ABD;
	Thu,  4 Apr 2024 05:35:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="PCUEluys"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A11F717736
	for <kvm@vger.kernel.org>; Thu,  4 Apr 2024 05:35:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712208948; cv=none; b=uAQX+d1RfdbRm6NQVYd3O5B3IDrfOkbywEFsb7aPgHS8vwNHNJjkw1TGG7yyqJHfDWlnBfc1PIZwPCowJ9l7eMqa0u6QjQJf6BXGzFI3R0Nv0pFnZnOfZiiaOSyXR3iuDzzU+XP73JJ+aCV8wfUhUs/PpUipSrKHGGSuap7L7bM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712208948; c=relaxed/simple;
	bh=Ym38qLEOUNfy/4hL6ENnTMzg8xPqYlCnX/Fr3RLE/U8=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=BwEetIPl+IHOfX8IVPisfJ/Nh5YKReGrdCI54+wpKyPkmX3A4eSw7p4EyZ5XyPDh4BdsN/3qladi4EpetoVKC6ZFL8NaPkDFZP+gNpuhByCPOrYOBRCr2+4v/Yc6rZ9FO/pm51vCOup/vFK40Z22OZvcAgqD/aMtXkyBWFtgpKE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=PCUEluys; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1712208945;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=gaCNfh5JQ71P8XHmMhbBbFyQnfQUNQ6Qvksh5dYu/Jg=;
	b=PCUEluys+PKa7j0+pXlF6DoGW6oPFqo3PAOuikK8RdV1cNCE2gKbhPUsRANUaJGJfPKExS
	DtRJ2aa9gBwSLEXGtf37fsQMipCqi3FSjzXS9jXaCEu6s6ZudDRE+DOoidlbyrufrPK6vr
	RHURDSH/VnHJ8SOKABgr8JmvIKGFPrs=
Received: from mail-ej1-f72.google.com (mail-ej1-f72.google.com
 [209.85.218.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-400-1I3VcxPXOpmNEmTfo6aRkg-1; Thu, 04 Apr 2024 01:35:44 -0400
X-MC-Unique: 1I3VcxPXOpmNEmTfo6aRkg-1
Received: by mail-ej1-f72.google.com with SMTP id a640c23a62f3a-a46ba1a19fdso38106366b.1
        for <kvm@vger.kernel.org>; Wed, 03 Apr 2024 22:35:43 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1712208943; x=1712813743;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=gaCNfh5JQ71P8XHmMhbBbFyQnfQUNQ6Qvksh5dYu/Jg=;
        b=qIJX7cka5wO4JTtypA7sZwhRQX7tjWfiYdTCkwjzmoNtNM5s/rX+47i0fn6U6oQEVv
         izryGkmZ60J/r6cCVeorTc/Z7853xDpNsdLW4+G973pDzMvctuC/u93MXHGXuhdRE267
         aeKjOVZYl8PfJGtl1yNLZri99UToEyYD2vijziveYBYAHaT6e8KHxrwQ1qOaBRpLxXi3
         FXxkIl9eHgpwbnwPB10G8MgRaY2MA/ai8FVZQ2Tw6WrQjI5URvImVNe31VddvkRaZSSr
         9bpje0xy8MZD0URwDUV+B4KiEUwV7KB0+1csxup5FIif4AaQUfXE1PYgvIxEOx7OnHTh
         cWHw==
X-Forwarded-Encrypted: i=1; AJvYcCXOeMUDuAUOXtV/eXwCTLpWWGC/SOehPfwi/snV1HT29tFooC2lTn9VW3egsK6uNcnVtePsLuga5MfOPcBppPmV/ROL
X-Gm-Message-State: AOJu0Yxs6vAxaWLLnzx2/0Tz5vO4Nh3+GnKXpJDU1VXxQab93Z4trOop
	/xhCIUMysPc/idDuZWErUC1DEnMu1DlQVWjdhV5AtkhTbcPlfGEcLq8lfgsMtaPTzlhMHSOmlD6
	LXBKLC+lhhayUk9ipsmjEBHe+KuGoc6EdkpaUDtamPcyQq8T4dqHOChK1Ksia/U8hy3Ilo53hlP
	UpwZpcv3YZlPvWlPcTNgqduBF+
X-Received: by 2002:a17:906:3e50:b0:a4e:9591:c2dd with SMTP id t16-20020a1709063e5000b00a4e9591c2ddmr725274eji.39.1712208942841;
        Wed, 03 Apr 2024 22:35:42 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IH6977Prz4EA27qaIn9ShWtc7ls7nUld0dGYjMeBaoZgL/dkR13B3ZOUXg8GK3+bvqSwQUifVVp85zJvDVRczk=
X-Received: by 2002:a17:906:3e50:b0:a4e:9591:c2dd with SMTP id
 t16-20020a1709063e5000b00a4e9591c2ddmr725266eji.39.1712208942439; Wed, 03 Apr
 2024 22:35:42 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240329093832.140690-1-lulu@redhat.com> <20240329054845-mutt-send-email-mst@kernel.org>
In-Reply-To: <20240329054845-mutt-send-email-mst@kernel.org>
From: Cindy Lu <lulu@redhat.com>
Date: Thu, 4 Apr 2024 13:35:02 +0800
Message-ID: <CACLfguW5GxYLtgL-8itH6b9re25bGsorKBWwDW9z5kBucSPLVg@mail.gmail.com>
Subject: Re: [PATCH v2] Documentation: Add reconnect process for VDUSE
To: "Michael S. Tsirkin" <mst@redhat.com>
Cc: jasowang@redhat.com, virtualization@lists.linux-foundation.org, 
	linux-kernel@vger.kernel.org, kvm@vger.kernel.org, netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Mar 29, 2024 at 5:52=E2=80=AFPM Michael S. Tsirkin <mst@redhat.com>=
 wrote:
>
> On Fri, Mar 29, 2024 at 05:38:25PM +0800, Cindy Lu wrote:
> > Add a document explaining the reconnect process, including what the
> > Userspace App needs to do and how it works with the kernel.
> >
> > Signed-off-by: Cindy Lu <lulu@redhat.com>
> > ---
> >  Documentation/userspace-api/vduse.rst | 41 +++++++++++++++++++++++++++
> >  1 file changed, 41 insertions(+)
> >
> > diff --git a/Documentation/userspace-api/vduse.rst b/Documentation/user=
space-api/vduse.rst
> > index bdb880e01132..f903aed714d1 100644
> > --- a/Documentation/userspace-api/vduse.rst
> > +++ b/Documentation/userspace-api/vduse.rst
> > @@ -231,3 +231,44 @@ able to start the dataplane processing as follows:
> >     after the used ring is filled.
> >
> >  For more details on the uAPI, please see include/uapi/linux/vduse.h.
> > +
> > +HOW VDUSE devices reconnectoin works
>
> typo
>
Really sorry for this, I will send a new version

Thanks
Cindy
> > +------------------------------------
> > +1. What is reconnection?
> > +
> > +   When the userspace application loads, it should establish a connect=
ion
> > +   to the vduse kernel device. Sometimes,the userspace application exi=
sts,
> > +   and we want to support its restart and connect to the kernel device=
 again
> > +
> > +2. How can I support reconnection in a userspace application?
> > +
> > +2.1 During initialization, the userspace application should first veri=
fy the
> > +    existence of the device "/dev/vduse/vduse_name".
> > +    If it doesn't exist, it means this is the first-time for connectio=
n. goto step 2.2
> > +    If it exists, it means this is a reconnection, and we should goto =
step 2.3
> > +
> > +2.2 Create a new VDUSE instance with ioctl(VDUSE_CREATE_DEV) on
> > +    /dev/vduse/control.
> > +    When ioctl(VDUSE_CREATE_DEV) is called, kernel allocates memory fo=
r
> > +    the reconnect information. The total memory size is PAGE_SIZE*vq_m=
umber.
> > +
> > +2.3 Check if the information is suitable for reconnect
> > +    If this is reconnection :
> > +    Before attempting to reconnect, The userspace application needs to=
 use the
> > +    ioctl(VDUSE_DEV_GET_CONFIG, VDUSE_DEV_GET_STATUS, VDUSE_DEV_GET_FE=
ATURES...)
> > +    to get the information from kernel.
> > +    Please review the information and confirm if it is suitable to rec=
onnect.
> > +
> > +2.4 Userspace application needs to mmap the memory to userspace
> > +    The userspace application requires mapping one page for every vq. =
These pages
> > +    should be used to save vq-related information during system runnin=
g. Additionally,
> > +    the application must define its own structure to store information=
 for reconnection.
> > +
> > +2.5 Completed the initialization and running the application.
> > +    While the application is running, it is important to store relevan=
t information
> > +    about reconnections in mapped pages. When calling the ioctl VDUSE_=
VQ_GET_INFO to
> > +    get vq information, it's necessary to check whether it's a reconne=
ction. If it is
> > +    a reconnection, the vq-related information must be get from the ma=
pped pages.
> > +
>
>
> I don't get it. So this is just a way for the application to allocate
> memory? Why do we need this new way to do it?
> Why not just mmap a file anywhere at all?
>
We used to use tmpfs to save this reconnect information,
but this will make the API not self contained, so we changed to using
the kernel memory
Thanks
cindy



>
> > +2.6 When the Userspace application exits, it is necessary to unmap all=
 the
> > +    pages for reconnection
> > --
> > 2.43.0
>


