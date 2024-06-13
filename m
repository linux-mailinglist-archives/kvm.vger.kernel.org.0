Return-Path: <kvm+bounces-19549-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 0E0C7906464
	for <lists+kvm@lfdr.de>; Thu, 13 Jun 2024 08:50:00 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 344901C22613
	for <lists+kvm@lfdr.de>; Thu, 13 Jun 2024 06:49:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3B2E9137C4E;
	Thu, 13 Jun 2024 06:49:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="DN3HQJsK"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0475F2119
	for <kvm@vger.kernel.org>; Thu, 13 Jun 2024 06:49:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718261384; cv=none; b=HmlYeBhJHqyBkrdRJWWUH2NK38rHJ61/1E4L2BbQzTjur6+nZtN6JzRCKpvxVwM+BTiiZkUhtvnoNdmS0unddk/+IPNnzOYksKOGkRxhyOed1i4Q4v4y5B4FuzCzk2o7xQm7EcVIwhDXCOI8vg3rE6ZEoL1F1lurWGc3hbrn0ds=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718261384; c=relaxed/simple;
	bh=nOI9j21ZgI3I0MQ5EhathzuyzKyOMxQisKyvdWlhhdA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=qAhkiCuGVw2GAUYb0zVdaTWMhsCmMUiv8FuLJeT7D/aPJEu0dxPcJ9RZ5jBEQP0rdltNkDWY37/HLGWAC6rOjZT2zKCVYImVz2kjgLFOj5JcCQAenivDIXCFO7Hy6ssVtv/RVuURdcb9jzCDRgPoEO7tLTr2zV97VXBsKxEIpG4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=DN3HQJsK; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1718261379;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=/CbSxasg15SB+kyQXKy/dPIg+1PKI2NcVPeH5mNpLbA=;
	b=DN3HQJsKk3VrNcnEUXYwMdHPFbzYJDIOv82JFW/h1KtjgN4QlRUZhxWUy+PEIZ/WVL4rG1
	I76r8Caw+0MM4u+xM4t1t4T2aCMjC/ppnXdJiGuX6G7ygInJJSU2aHhvsEha8y7r0hXy/I
	gEMqUBbPjD2bpWdD+oJd5C5a/zfE89I=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-45-sg5Kytz3Pmqa-TWdPqs-cw-1; Thu, 13 Jun 2024 02:49:34 -0400
X-MC-Unique: sg5Kytz3Pmqa-TWdPqs-cw-1
Received: by mail-wr1-f72.google.com with SMTP id ffacd0b85a97d-35f09791466so365608f8f.2
        for <kvm@vger.kernel.org>; Wed, 12 Jun 2024 23:49:34 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1718261371; x=1718866171;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=/CbSxasg15SB+kyQXKy/dPIg+1PKI2NcVPeH5mNpLbA=;
        b=jPluGrP8/10XIDVAZGMNuKuFIc8KzEu+nC3lsZND5N5y4DpfzXifXs+FXYvoXA+wKr
         fjyYeDDhqW3RbKwApBo2fiKQxXClddMQ8F22g5N3ZxEB0FMfdEdClWOY/qOfcqUkYSn8
         wmZsdSMeTzIP+0x4TtiewFUQGZAE9i091Drt0b0heRmClBP4sNDOc8vTC3iIhF18U6bH
         /1CDNCEkkc1itJY8M8lUpozejk9TjsjWZLTh4Cb1vYYnKYLxRnWeB16a0ZojdapwUUHc
         qAc5yIq5RaokwXp3xy0r/YkeyzK1Ouszg/r1rKUfaKWZIDMU27mhBZKvxpF2vug+19cw
         MUWA==
X-Forwarded-Encrypted: i=1; AJvYcCW/PwBCXaGB91zMkD3fuijiYNNTx3lIoZHqaYr2qj9GxseEM8BsKhYKowVmGoykxqdk4eTr9VtFVSYtO4/qhc9ZdS9v
X-Gm-Message-State: AOJu0YyVgdjZMTSiSHZd2zsCmbU8ZDFFOZzkfTLi3ve6tszU7/oqBOvw
	5Wz3rmnrNy7zzdRj0z75vwzqO4mat+chHPu9WYgB0A1Oq7vP1+Bvb6mclDOa72d/R6m80P+Fa13
	3XZz24jmEGPj5jYj7WHO7TACjYV1tuBRhT0MCpV0nvppgItHdIA==
X-Received: by 2002:a5d:4ac3:0:b0:355:161:b7e6 with SMTP id ffacd0b85a97d-35fdf7ae574mr2690500f8f.41.1718261371374;
        Wed, 12 Jun 2024 23:49:31 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IE2zc9YTuq67HAYl0S1ZCAGfDX9FHmtCsB3op2ROZqV+XTOIEDmRzmfD9lHK2sqlkU4bC7xmQ==
X-Received: by 2002:a5d:4ac3:0:b0:355:161:b7e6 with SMTP id ffacd0b85a97d-35fdf7ae574mr2690467f8f.41.1718261370362;
        Wed, 12 Jun 2024 23:49:30 -0700 (PDT)
Received: from redhat.com ([2a0d:6fc7:341:5539:9b1a:2e49:4aac:204e])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3607509c89dsm764954f8f.25.2024.06.12.23.49.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 12 Jun 2024 23:49:29 -0700 (PDT)
Date: Thu, 13 Jun 2024 02:49:25 -0400
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Jiri Pirko <jiri@resnulli.us>
Cc: Jakub Kicinski <kuba@kernel.org>, Cindy Lu <lulu@redhat.com>,
	dtatulea@nvidia.com, jasowang@redhat.com,
	virtualization@lists.linux-foundation.org,
	linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
	netdev@vger.kernel.org
Subject: Re: [PATCH 1/2] vdpa: support set mac address from vdpa tool
Message-ID: <20240613024756-mutt-send-email-mst@kernel.org>
References: <20240611053239.516996-1-lulu@redhat.com>
 <20240611185810.14b63d7d@kernel.org>
 <ZmlAYcRHMqCgYBJD@nanopsycho.orion>
 <20240612031356-mutt-send-email-mst@kernel.org>
 <ZmlMuGGY2po6LLCY@nanopsycho.orion>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZmlMuGGY2po6LLCY@nanopsycho.orion>

On Wed, Jun 12, 2024 at 09:22:32AM +0200, Jiri Pirko wrote:
> Wed, Jun 12, 2024 at 09:15:44AM CEST, mst@redhat.com wrote:
> >On Wed, Jun 12, 2024 at 08:29:53AM +0200, Jiri Pirko wrote:
> >> Wed, Jun 12, 2024 at 03:58:10AM CEST, kuba@kernel.org wrote:
> >> >On Tue, 11 Jun 2024 13:32:32 +0800 Cindy Lu wrote:
> >> >> Add new UAPI to support the mac address from vdpa tool
> >> >> Function vdpa_nl_cmd_dev_config_set_doit() will get the
> >> >> MAC address from the vdpa tool and then set it to the device.
> >> >> 
> >> >> The usage is: vdpa dev set name vdpa_name mac **:**:**:**:**:**
> >> >
> >> >Why don't you use devlink?
> >> 
> >> Fair question. Why does vdpa-specific uapi even exist? To have
> >> driver-specific uapi Does not make any sense to me :/
> >
> >I am not sure which uapi do you refer to? The one this patch proposes or
> >the existing one?
> 
> Sure, I'm sure pointing out, that devlink should have been the answer
> instead of vdpa netlink introduction. That ship is sailed,

> now we have
> unfortunate api duplication which leads to questions like Jakub's one.
> That's all :/



Yea there's no point to argue now, there were arguments this and that
way.  I don't think we currently have a lot
of duplication, do we?

-- 
MST


