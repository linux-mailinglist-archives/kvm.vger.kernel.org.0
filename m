Return-Path: <kvm+bounces-42597-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id E7F32A7AF96
	for <lists+kvm@lfdr.de>; Thu,  3 Apr 2025 22:55:38 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id C04927A78B5
	for <lists+kvm@lfdr.de>; Thu,  3 Apr 2025 20:53:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2CA712580F7;
	Thu,  3 Apr 2025 19:42:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="dp1adRtd"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f176.google.com (mail-pf1-f176.google.com [209.85.210.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 92A771F5825;
	Thu,  3 Apr 2025 19:42:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743709378; cv=none; b=FNTJo2Z6FnljTqOu2UWu822dSi2IJBByxVFdnmpysoUaoHEUAGmH0cZPbMU7rX3MgpHGz527EZvVQJCAc3JgHw08iXeZfeaBexpWZdmuvOLNCQqSrBRRSG3/jDPTUuuAlV0+s5Mwh6dulDxWiOQkOIqF2+e3jPUlVt+4S+3WmEI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743709378; c=relaxed/simple;
	bh=OxFQkTUUwkX1q6k8xQRbHlDEFB1zaVhWsRAl9W5U5hU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=M68zz6J3nmXvrHmte6dGWc6pFepvmWkRjWmImhQVBZyehJ2MnW74JURkO18ibXjwdknpyJ4fsURk3UYjJ4cE6wQ5xSQRfGYtwm6ICFYRjWA3rkZWumP2wPbJWrRE3ACMX5/5YCXmu/8ocxnYMVYziU+hvL36luOpb8B2y1IGY2A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=dp1adRtd; arc=none smtp.client-ip=209.85.210.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pf1-f176.google.com with SMTP id d2e1a72fcca58-7398d65476eso1009320b3a.1;
        Thu, 03 Apr 2025 12:42:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1743709376; x=1744314176; darn=vger.kernel.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=Dw5EaN/FeaV+PKwcwp5SEhnuatGIwWCjLsFP+3LpIU0=;
        b=dp1adRtdYE2eSA9xWfdxtKi6OXD7ZBjeEGOr1P5GGbfUFePWgUc7mpXhdHBE/g9BEY
         OqKz/eRTI5HTtYKq3+mGekG1KgB0KNSvz4aAw03O4PPj5OeX3Ql1T3dWyVsTb7/e5O8C
         og8LVoi2AKsEkprcZfSiqXr3MyizIKrXM14ZPyHMaYm7mLEpV+TILCsdyj4KOo8ei0t/
         f+qk9/Rf7Ql+1Ed//051SDYNOeUHhaVOcQguWDatBh0SNxDyEwjfl68ABLVb+hSB6nDH
         svUerJXJ3KOqbIIVHehZdyhqRnzFq18miNN89cU84rwSI1ZzEb6zEVO83Bizm5ljLdWj
         GhIg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1743709376; x=1744314176;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Dw5EaN/FeaV+PKwcwp5SEhnuatGIwWCjLsFP+3LpIU0=;
        b=ayD5iaCjP/9ZemTrA4pAOBbZCxbEdyVm8OHbGfMNJntRDSsFxXgeJ7HzUq3TqdO0Te
         scerTvTgtpCnejA0WazWnVVFDlozGXkEhdlQ4QuaWAXAlSHPXqHNtpCA/gC3Uo/fEnDD
         626EKCTovlzjwSzwJ/Fk93Jh2KV+1/ynzLEBk3MaWAJX9gQD5MhqhF6vOTkJw57HMEfL
         7hDm7sONq1YxoShtaufLIaDHmBtMbSsF6Udpd5xzbw2EEVT3/QB7RmUIMralpWovi2Hw
         YtDnhcLuFEr+9qv/3I+6u61mgsGxum7AVDoIh+LvpRQ8nwo7RA87mUc2IpaJm+4zF4Su
         WvGA==
X-Forwarded-Encrypted: i=1; AJvYcCWaByS+UbiVukchjdKnBSwWYbYEP/98Ha6v7HdD71vZmkc0HrjbAlRfOoy3uCacbfpItHw6Yk+q@vger.kernel.org, AJvYcCXAT/UivivEib9LAEQ5PCgb+18GZEC3CNhgqDNeU8mNndgXIgo0ObeUUUuOAYWvgafni4PrghULytPooFya@vger.kernel.org, AJvYcCXChZPoiQd+jG775VJe/Ee/2/+leFLz3k3H1XTJfZn74AG6ek6d84Jg8eM5GEB3An69Gz3M7ZXbnxcJwMQl@vger.kernel.org, AJvYcCXzb3fi2EOC6BQhp4J4DEPqFq7fy3+mqVG6/ReqLFz1iD5L8JsBltWH5x1kS1/mEDy1NfM=@vger.kernel.org
X-Gm-Message-State: AOJu0YzKuhHP4oyEEbcADzax+nnA4IP/eRcACfI2auKihbXj+Bjxy9qv
	dz9mOtbkNCNUfyp6KlqbPnWfYjScUU6j7wMZtRjOrGt0XNNEloqv
X-Gm-Gg: ASbGnctrjuuXGiO2oWUFb0DTyT0AZgC4q2It3VDdKug2ymmBmUqiAi/3GkkwTekrF/D
	WOlgHnzRF/myCw5EMPcm8ZavwIwChLFg3Al4J8Rgywd6Og3iwzgTzVGnGUBgOHKFT/x3a9kh22v
	T+d15auYxX6og7xKrzkZTa+rD6vi8juO5BmBRPg/JElwpLv4Bg9dt9jdBdwrmB+QyCOKybnsR58
	AVXvTrPLPAph23rIu+1saa+z4jzwPbIh4vJvj2x4znCtC2YPr8YOSZG43ZJnLxdRkkDWRq1h+kW
	ID2IW38ToGP+j+Lf64mdPvs1JA0JM1sQyxsDo3pK8hJqzinnsIpOnsH5vRuH4MhywAs1JsmkgHI
	8
X-Google-Smtp-Source: AGHT+IGTqm5ICR8EBlvvydBUIxaddn+H75GcdEQ/shNDpVkFY10lp50cz3ahcnw+0GlRzFfpgJP+zQ==
X-Received: by 2002:a05:6a00:2e0f:b0:732:706c:c4ff with SMTP id d2e1a72fcca58-739d6457e97mr7220468b3a.7.1743709375559;
        Thu, 03 Apr 2025 12:42:55 -0700 (PDT)
Received: from devvm6277.cco0.facebook.com ([2a03:2880:2ff:3::])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-739d98064fdsm1897473b3a.84.2025.04.03.12.42.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 03 Apr 2025 12:42:54 -0700 (PDT)
Date: Thu, 3 Apr 2025 12:42:46 -0700
From: Bobby Eshleman <bobbyeshleman@gmail.com>
To: Stefano Garzarella <sgarzare@redhat.com>
Cc: Daniel =?iso-8859-1?Q?P=2E_Berrang=E9?= <berrange@redhat.com>,
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
Message-ID: <Z+7ktkvIeNbf39D3@devvm6277.cco0.facebook.com>
References: <20250312-vsock-netns-v2-0-84bffa1aa97a@gmail.com>
 <r6a6ihjw3etlb5chqsb65u7uhcav6q6pjxu65iqpp76423w2wd@kmctvoaywmbu>
 <Z-w47H3qUXZe4seQ@redhat.com>
 <Z+yDCKt7GpubbTKJ@devvm6277.cco0.facebook.com>
 <CAGxU2F7=64HHaAD+mYKYLqQD8rHg1CiF1YMDUULgSFw0WSY-Aw@mail.gmail.com>
 <Z-0BoF4vkC2IS1W4@redhat.com>
 <Z+23pbK9t5ckSmLl@devvm6277.cco0.facebook.com>
 <Z+26A3sslT+w+wOI@devvm6277.cco0.facebook.com>
 <4c2xz3xhpdjvb6jmdw7ctsebpza5lcs4gevr5wlwwyt64usr2i@o5qt2msfyvvw>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <4c2xz3xhpdjvb6jmdw7ctsebpza5lcs4gevr5wlwwyt64usr2i@o5qt2msfyvvw>

On Thu, Apr 03, 2025 at 11:33:14AM +0200, Stefano Garzarella wrote:
> On Wed, Apr 02, 2025 at 03:28:19PM -0700, Bobby Eshleman wrote:
> > On Wed, Apr 02, 2025 at 03:18:13PM -0700, Bobby Eshleman wrote:
> > > On Wed, Apr 02, 2025 at 10:21:36AM +0100, Daniel P. Berrangé wrote:
> > > > On Wed, Apr 02, 2025 at 10:13:43AM +0200, Stefano Garzarella wrote:
> > > > > On Wed, 2 Apr 2025 at 02:21, Bobby Eshleman <bobbyeshleman@gmail.com> wrote:
> > > > > >
> > > > > > I do like Stefano's suggestion to add a sysctl for a "strict" mode,
> > > > > > Since it offers the best of both worlds, and still tends conservative in
> > > > > > protecting existing applications... but I agree, the non-strict mode
> > > > > > vsock would be unique WRT the usual concept of namespaces.
> > > > >
> > > > > Maybe we could do the opposite, enable strict mode by default (I think
> > > > > it was similar to what I had tried to do with the kernel module in v1, I
> > > > > was young I know xD)
> > > > > And provide a way to disable it for those use cases where the user wants
> > > > > backward compatibility, while paying the cost of less isolation.
> > > >
> > > > I think backwards compatible has to be the default behaviour, otherwise
> > > > the change has too high risk of breaking existing deployments that are
> > > > already using netns and relying on VSOCK being global. Breakage has to
> > > > be opt in.
> > > >
> > > > > I was thinking two options (not sure if the second one can be done):
> > > > >
> > > > >   1. provide a global sysfs/sysctl that disables strict mode, but this
> > > > >   then applies to all namespaces
> > > > >
> > > > >   2. provide something that allows disabling strict mode by namespace.
> > > > >   Maybe when it is created there are options, or something that can be
> > > > >   set later.
> > > > >
> > > > > 2 would be ideal, but that might be too much, so 1 might be enough. In
> > > > > any case, 2 could also be a next step.
> > > > >
> > > > > WDYT?
> > > >
> > > > It occured to me that the problem we face with the CID space usage is
> > > > somewhat similar to the UID/GID space usage for user namespaces.
> > > >
> > > > In the latter case, userns has exposed /proc/$PID/uid_map & gid_map, to
> > > > allow IDs in the namespace to be arbitrarily mapped onto IDs in the host.
> > > >
> > > > At the risk of being overkill, is it worth trying a similar kind of
> > > > approach for the vsock CID space ?
> > > >
> > > > A simple variant would be a /proc/net/vsock_cid_outside specifying a set
> > > > of CIDs which are exclusively referencing /dev/vhost-vsock associations
> > > > created outside the namespace. Anything not listed would be exclusively
> > > > referencing associations created inside the namespace.
> > > >
> > > > A more complex variant would be to allow a full remapping of CIDs as is
> > > > done with userns, via a /proc/net/vsock_cid_map, which the same three
> > > > parameters, so that CID=15 association outside the namespace could be
> > > > remapped to CID=9015 inside the namespace, allow the inside namespace
> > > > to define its out association for CID=15 without clashing.
> > > >
> > > > IOW, mapped CIDs would be exclusively referencing /dev/vhost-vsock
> > > > associations created outside namespace, while unmapped CIDs would be
> > > > exclusively referencing /dev/vhost-vsock associations inside the
> > > > namespace.
> > > >
> > > > A likely benefit of relying on a kernel defined mapping/partition of
> > > > the CID space is that apps like QEMU don't need changing, as there's
> > > > no need to invent a new /dev/vhost-vsock-netns device node.
> > > >
> > > > Both approaches give the desirable security protection whereby the
> > > > inside namespace can be prevented from accessing certain CIDs that
> > > > were associated outside the namespace.
> > > >
> > > > Some rule would need to be defined for updating the /proc/net/vsock_cid_map
> > > > file as it is the security control mechanism. If it is write-once then
> > > > if the container mgmt app initializes it, nothing later could change
> > > > it.
> > > >
> > > > A key question is do we need the "first come, first served" behaviour
> > > > for CIDs where a CID can be arbitrarily used by outside or inside namespace
> > > > according to whatever tries to associate a CID first ?
> > > 
> > > I think with /proc/net/vsock_cid_outside, instead of disallowing the CID
> > > from being used, this could be solved by disallowing remapping the CID
> > > while in use?
> > > 
> > > The thing I like about this is that users can check
> > > /proc/net/vsock_cid_outside to figure out what might be going on,
> > > instead of trying to check lsof or ps to figure out if the VMM processes
> > > have used /dev/vhost-vsock vs /dev/vhost-vsock-netns.
> 
> Yes, although the user in theory should not care about this information,
> right?
> I mean I don't even know if it makes sense to expose the contents of
> /proc/net/vsock_cid_outside in the namespace.
> 
> > > 
> > > Just to check I am following... I suppose we would have a few typical
> > > configurations for /proc/net/vsock_cid_outside. Following uid_map file
> > > format of:
> > > 	"<local cid start>		<global cid start>		<range size>"
> 
> This seems to relate more to /proc/net/vsock_cid_map, for
> /proc/net/vsock_cid_outside I think 2 parameters are enough
> (CID, range), right?
> 

True, yes vsock_cid_map.

> > > 
> > > 	1. Identity mapping, current namespace CID is global CID (default
> > > 	setting for new namespaces):
> > > 
> > > 		# empty file
> > > 
> > > 				OR
> > > 
> > > 		0    0    4294967295
> > > 
> > > 	2. Complete isolation from global space (initialized, but no mappings):
> > > 
> > > 		0    0    0
> > > 
> > > 	3. Mapping in ranges of global CIDs
> > > 
> > > 	For example, global CID space starts at 7000, up to 32-bit max:
> > > 
> > > 		7000    0    4294960295
> > > 	
> > > 	Or for multiple mappings (0-100 map to 7000-7100, 1000-1100 map to
> > > 	8000-8100) :
> > > 
> > > 		7000    0       100
> > > 		8000    1000    100
> > > 
> > > 
> > > One thing I don't love is that option 3 seems to not be addressing a
> > > known use case. It doesn't necessarily hurt to have, but it will add
> > > complexity to CID handling that might never get used?
> 
> Yes, as I also mentioned in the previous email, we could also do a
> step-by-step thing.
> 
> IMHO we can define /proc/net/vsock_cid_map (with the structure you just
> defined), but for now only support 1-1 mapping (with the ranges of
> course, I mean the first two parameters should always be the same) and
> then add option 3 in the future.
> 

makes sense, sgtm!

> > > 
> > > Since options 1/2 could also be represented by a boolean (yes/no
> > > "current ns shares CID with global"), I wonder if we could either A)
> > > only support the first two options at first, or B) add just
> > > /proc/net/vsock_ns_mode at first, which supports only "global" and
> > > "local", and later add a "mapped" mode plus /proc/net/vsock_cid_outside
> > > or the full mapping if the need arises?
> 
> I think option A is the same as I meant above :-)
> 

Indeed.

> > > 
> > > This could also be how we support Option 2 from Stefano's last email of
> > > supporting per-namespace opt-in/opt-out.
> 
> Hmm, how can we do it by namespace? Isn't that global?
> 

I think the file path is global but the contents are tied per-namespace,
according to the namespace of the process that called open() on it.
This way the container mgr can write-once lock it, and the namespace
processes can read it?

> > > 
> > > Any thoughts on this?
> > > 
> > 
> > Stefano,
> > 
> > Would only supporting 1/2 still support the Kata use case?
> 
> I think so, actually I was thinking something similar in the message I just
> sent.
> 
> By default (if the file is empty), nothing should change, so that's fine
> IMO. As Paolo suggested, we absolutely have to have tests to verify these
> things.
> 

Sounds like a plan! I'm working on the new vsock vmtest now and will
include the new tests in the next rev.

Also, I'm thinking we should protect vsock_cid_map behind a capability,
but I'm not sure which one is correct (CAP_NET_ADMIN?). WDYT?

Thanks!

