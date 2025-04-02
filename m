Return-Path: <kvm+bounces-42523-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 27263A7981F
	for <lists+kvm@lfdr.de>; Thu,  3 Apr 2025 00:18:39 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 02C083AD10D
	for <lists+kvm@lfdr.de>; Wed,  2 Apr 2025 22:18:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C50041F583D;
	Wed,  2 Apr 2025 22:18:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Nc2MV8ZP"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f171.google.com (mail-pf1-f171.google.com [209.85.210.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5CA311F4CBF;
	Wed,  2 Apr 2025 22:18:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743632300; cv=none; b=K+fNXdOOkuGTfO4l+euJ7W+5rfOpepl2wBa6O8Ec46vNzwdquYylzgC5rsRXmfHRu5Ux9+Rqo6TNMjlnf4/m/01nqxx4p+6fUe6T551uJkFM5HY2sQcjXw5G9aomNiFiHzB4yAt6v0lRYHg6XgfvtKqCIIGJrBDSt6xSpSRo6cs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743632300; c=relaxed/simple;
	bh=83f0pETp0M1GCR4F51pZK1phNpNTkGWXfj6wjPcxxFI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=swPtKFujmN/J9DdeUBKL11lSme+/H6DXeLpEagQgAUp6nYAwv8K7CXJbNp6Af/Bz9xinAv8cKhw7ouu4xzYveRcyDVUqC5PVX07yj4R/0zVsFBsx7rfYOZlIufTR6GiIiW0PST+nJAY0Cuk1KlqhFEW3RZzVMS9BSJfjz1gUpIU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Nc2MV8ZP; arc=none smtp.client-ip=209.85.210.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pf1-f171.google.com with SMTP id d2e1a72fcca58-7376e311086so329834b3a.3;
        Wed, 02 Apr 2025 15:18:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1743632297; x=1744237097; darn=vger.kernel.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=5LEHy4x5hnkfDI/FlX76y9wNeBb+/8QoTP8b5uw3x8I=;
        b=Nc2MV8ZPWfwWSAC9Nj0MKz0uhW61Obkw0UhyJHL7PPeOaPCLkKcjo3KK+X4j03/eCb
         hmCrSBNDCWeCtux5Tkr5LDkbndvrz8/TNXuHZT+9wYfGH1VV+YoPUMN2u/hgQO+se9+9
         bIVTYxISwZWODx9WqYiLOgJVbWBu9G2HJ8vYtCdEal7KWgRM992T/1vMnHpC1x1A5vrt
         qxJQuNZC/w12HXXc8pmiJs12Xw7zBtsEi1FFHd7P6HKtXJti6fKXTDQfSeQEUrYFdfr4
         7QXeZIZp4w71sjyu09rMf1zLJiyL8C9+W5MhmvZnyA/WcMyuiZ+6Uulu9OIJhkGKrnJ8
         wmXw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1743632297; x=1744237097;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=5LEHy4x5hnkfDI/FlX76y9wNeBb+/8QoTP8b5uw3x8I=;
        b=vAd8ZGAwqNXukOc4RY78idmVFIcH7pHiHciiALQaxCO8rPv3kzJlMju2PVC5nK/k3P
         /brorOQd+/tQgx120YvCX3M7gC5HCEjHRB0XED9clE6KUYQREk6lSjN7ARxrf6ubvPq8
         sELItkF+7xTWsyZXToy9GJu95giogEQlyRTRppc3BpDkhxP83IGY05kKmSmjZcd4P+lT
         pndSR/5OMiLZFSDx6bcdZShGosgZTI6Mq2DigPCWjXPAXGeHefJVN9odE+gu2cmBVfMq
         DtV33YkUhTuXSHMyVNqEkRaJaRsEiWxTaTAuHomP9HlnpsApFkAymsgAo+ZljYr1iZBh
         +kmw==
X-Forwarded-Encrypted: i=1; AJvYcCWR2XKHvukDgj1zRTiUslV7ILYAri1TGkbZ0VZsr+2kEZUvxJhaUjxPCcHdTiXl+wymIWb+agHFOD494q7V@vger.kernel.org, AJvYcCWuSj7qEpTtR99EkWd0Ab6LCA+giYhHdXvlZ/jmlucUkGte30c2jo4aQ2JTtKrWjm1kGxAZO3Z/@vger.kernel.org, AJvYcCXQv6+5uyP6LPecW2MND6NfcPBnCJp+K6ZE5qGVZ+o8pPYxlXO4a5xza25/2qcSpm3vAGo=@vger.kernel.org, AJvYcCXVzpurRIOzb+mBmNYAAsdV+7/vpNNNBpGmltPKGLo/K1UenGKWeOr8/Drmju2eKbyqu9z4EgmavQuDyvgk@vger.kernel.org
X-Gm-Message-State: AOJu0YwYmYP/YdNLIVMi923eW2Bn9sKpjE2XyIrENByp/n+B6cP9/0WM
	RmmKdTUhAw9gbDSOPZz5E4aBffbZ1XqjnPOUEi2TQpjsp2JuJFSP
X-Gm-Gg: ASbGnctQvLZvqv+SB6MFcq6AnSGE++/4ODemt/IAOt/SOe+vRgH95dmtldfhkxoPT5v
	WuZTyQ/ZOviNlrA2yGsXmEbsxquF9QPrAw7MFOnIr02m578Ug1O3FLgUrLCbvcwbg/Izf8z69Gq
	pVQuPtlPY50H6hrhN8CwzM6JXJWeYSicB9aus+4elGeDbvfuEjURA0QU5qNUG3oh82QrX5a2njp
	Y6rsOrwoWqhJKm0STho+SqDvDIrpjAHFXKMaLUsC4VXLMUuipxPxxaZx8WzQf/LnrGPM2oFoHNW
	+8D0RthQzLl09T2B6OC6iIZ//FUvw1dOeq+GZfSMspFLK83lhIdAQPqxASJ56kDrfov/xjgtGY8
	9
X-Google-Smtp-Source: AGHT+IHJEBcIMQrWstviWhStuPuGs1oGBCFqM4wEt2zZaMlsMAYkBXHcn6d960097eIHnG5Klr1wVA==
X-Received: by 2002:aa7:88d0:0:b0:731:737c:3224 with SMTP id d2e1a72fcca58-739803b3f12mr25015506b3a.10.1743632297419;
        Wed, 02 Apr 2025 15:18:17 -0700 (PDT)
Received: from devvm6277.cco0.facebook.com ([2a03:2880:2ff:7::])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-af93b67dc0fsm10504705a12.16.2025.04.02.15.18.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 02 Apr 2025 15:18:16 -0700 (PDT)
Date: Wed, 2 Apr 2025 15:18:13 -0700
From: Bobby Eshleman <bobbyeshleman@gmail.com>
To: Daniel =?iso-8859-1?Q?P=2E_Berrang=E9?= <berrange@redhat.com>
Cc: Stefano Garzarella <sgarzare@redhat.com>,
	Jakub Kicinski <kuba@kernel.org>,
	"K. Y. Srinivasan" <kys@microsoft.com>,
	Haiyang Zhang <haiyangz@microsoft.com>,
	Wei Liu <wei.liu@kernel.org>, Dexuan Cui <decui@microsoft.com>,
	Stefan Hajnoczi <stefanha@redhat.com>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Jason Wang <jasowang@redhat.com>,
	Xuan Zhuo <xuanzhuo@linux.alibaba.com>,
	Eugenio =?iso-8859-1?Q?P=E9rez?= <eperezma@redhat.com>,
	Bryan Tan <bryan-bt.tan@broadcom.com>,
	Vishnu Dasa <vishnu.dasa@broadcom.com>,
	Broadcom internal kernel review list <bcm-kernel-feedback-list@broadcom.com>,
	"David S. Miller" <davem@davemloft.net>,
	virtualization@lists.linux.dev, netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-hyperv@vger.kernel.org,
	kvm@vger.kernel.org
Subject: Re: [PATCH v2 0/3] vsock: add namespace support to vhost-vsock
Message-ID: <Z+23pbK9t5ckSmLl@devvm6277.cco0.facebook.com>
References: <20250312-vsock-netns-v2-0-84bffa1aa97a@gmail.com>
 <r6a6ihjw3etlb5chqsb65u7uhcav6q6pjxu65iqpp76423w2wd@kmctvoaywmbu>
 <Z-w47H3qUXZe4seQ@redhat.com>
 <Z+yDCKt7GpubbTKJ@devvm6277.cco0.facebook.com>
 <CAGxU2F7=64HHaAD+mYKYLqQD8rHg1CiF1YMDUULgSFw0WSY-Aw@mail.gmail.com>
 <Z-0BoF4vkC2IS1W4@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <Z-0BoF4vkC2IS1W4@redhat.com>

On Wed, Apr 02, 2025 at 10:21:36AM +0100, Daniel P. Berrangé wrote:
> On Wed, Apr 02, 2025 at 10:13:43AM +0200, Stefano Garzarella wrote:
> > On Wed, 2 Apr 2025 at 02:21, Bobby Eshleman <bobbyeshleman@gmail.com> wrote:
> > >
> > > I do like Stefano's suggestion to add a sysctl for a "strict" mode,
> > > Since it offers the best of both worlds, and still tends conservative in
> > > protecting existing applications... but I agree, the non-strict mode
> > > vsock would be unique WRT the usual concept of namespaces.
> > 
> > Maybe we could do the opposite, enable strict mode by default (I think 
> > it was similar to what I had tried to do with the kernel module in v1, I 
> > was young I know xD)
> > And provide a way to disable it for those use cases where the user wants 
> > backward compatibility, while paying the cost of less isolation.
> 
> I think backwards compatible has to be the default behaviour, otherwise
> the change has too high risk of breaking existing deployments that are
> already using netns and relying on VSOCK being global. Breakage has to
> be opt in.
> 
> > I was thinking two options (not sure if the second one can be done):
> > 
> >   1. provide a global sysfs/sysctl that disables strict mode, but this
> >   then applies to all namespaces
> > 
> >   2. provide something that allows disabling strict mode by namespace.
> >   Maybe when it is created there are options, or something that can be
> >   set later.
> > 
> > 2 would be ideal, but that might be too much, so 1 might be enough. In 
> > any case, 2 could also be a next step.
> > 
> > WDYT?
> 
> It occured to me that the problem we face with the CID space usage is
> somewhat similar to the UID/GID space usage for user namespaces.
> 
> In the latter case, userns has exposed /proc/$PID/uid_map & gid_map, to
> allow IDs in the namespace to be arbitrarily mapped onto IDs in the host.
> 
> At the risk of being overkill, is it worth trying a similar kind of
> approach for the vsock CID space ?
> 
> A simple variant would be a /proc/net/vsock_cid_outside specifying a set
> of CIDs which are exclusively referencing /dev/vhost-vsock associations
> created outside the namespace. Anything not listed would be exclusively
> referencing associations created inside the namespace.
> 
> A more complex variant would be to allow a full remapping of CIDs as is
> done with userns, via a /proc/net/vsock_cid_map, which the same three
> parameters, so that CID=15 association outside the namespace could be
> remapped to CID=9015 inside the namespace, allow the inside namespace
> to define its out association for CID=15 without clashing.
> 
> IOW, mapped CIDs would be exclusively referencing /dev/vhost-vsock
> associations created outside namespace, while unmapped CIDs would be
> exclusively referencing /dev/vhost-vsock associations inside the
> namespace. 
> 
> A likely benefit of relying on a kernel defined mapping/partition of
> the CID space is that apps like QEMU don't need changing, as there's
> no need to invent a new /dev/vhost-vsock-netns device node.
> 
> Both approaches give the desirable security protection whereby the
> inside namespace can be prevented from accessing certain CIDs that
> were associated outside the namespace.
> 
> Some rule would need to be defined for updating the /proc/net/vsock_cid_map
> file as it is the security control mechanism. If it is write-once then
> if the container mgmt app initializes it, nothing later could change
> it.
> 
> A key question is do we need the "first come, first served" behaviour
> for CIDs where a CID can be arbitrarily used by outside or inside namespace
> according to whatever tries to associate a CID first ?

I think with /proc/net/vsock_cid_outside, instead of disallowing the CID
from being used, this could be solved by disallowing remapping the CID
while in use?

The thing I like about this is that users can check
/proc/net/vsock_cid_outside to figure out what might be going on,
instead of trying to check lsof or ps to figure out if the VMM processes
have used /dev/vhost-vsock vs /dev/vhost-vsock-netns.

Just to check I am following... I suppose we would have a few typical
configurations for /proc/net/vsock_cid_outside. Following uid_map file
format of:
	"<local cid start>		<global cid start>		<range size>"

	1. Identity mapping, current namespace CID is global CID (default
	setting for new namespaces):

		# empty file

				OR

		0    0    4294967295

	2. Complete isolation from global space (initialized, but no mappings):

		0    0    0

	3. Mapping in ranges of global CIDs

	For example, global CID space starts at 7000, up to 32-bit max:

		7000    0    4294960295
	
	Or for multiple mappings (0-100 map to 7000-7100, 1000-1100 map to
	8000-8100) :

		7000    0       100
		8000    1000    100


One thing I don't love is that option 3 seems to not be addressing a
known use case. It doesn't necessarily hurt to have, but it will add
complexity to CID handling that might never get used?

Since options 1/2 could also be represented by a boolean (yes/no
"current ns shares CID with global"), I wonder if we could either A)
only support the first two options at first, or B) add just
/proc/net/vsock_ns_mode at first, which supports only "global" and
"local", and later add a "mapped" mode plus /proc/net/vsock_cid_outside
or the full mapping if the need arises?

This could also be how we support Option 2 from Stefano's last email of
supporting per-namespace opt-in/opt-out.

Any thoughts on this?

> 
> IMHO those semantics lead to unpredictable behaviour for apps because
> what happens depends on ordering of app launches inside & outside the
> namespace, but they do sort of allow for VSOCK namespace behaviour to
> be 'zero conf' out of the box.
> 
> A mapping that strictly partitions CIDs to either outside or inside
> namespace usage, but never both, gives well defined behaviour, at the
> cost of needing to setup an initial mapping/partition.
> 

Agreed, I do like the plainness of reasoning through it.

Thanks!
Bobby

