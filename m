Return-Path: <kvm+bounces-19557-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 424109065AC
	for <lists+kvm@lfdr.de>; Thu, 13 Jun 2024 09:51:36 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id E882A1F25ED0
	for <lists+kvm@lfdr.de>; Thu, 13 Jun 2024 07:51:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id ECBA913C8FF;
	Thu, 13 Jun 2024 07:51:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="bsBHTJKS"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E249613C8EC
	for <kvm@vger.kernel.org>; Thu, 13 Jun 2024 07:51:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718265071; cv=none; b=Ujt//boW9ldgwtXNmmrJhOiapj6s+kYwhfqr4nzdA0lgL3cVlJ8guBxcZS5l4F8xjWG222u2TO+Ops2SVMUzWVz9qS0AAUkTANwoOSg6E3gHz3+BRy+BtReXC/0OrIlTftVbUahTzpshNy3HpSnBJ2etdEKk9sCh41wMemGQ9VY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718265071; c=relaxed/simple;
	bh=GFIcxWXQwNCRH03Z9cLHboBcOBzSFyWQjvAxn613bA8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=L0TSHbtqsDozpNA5RVbtOPfl1SjJrn1btf/vI9dmsPwluoWV9uc7tPC3IZlqCiLUrYT9cAzoqiTL3Bir/6hM90O2PQ0gMxnLsoLyjIaC5Vl+HDi1j/qy4XRSIxh/LCdPbDusZCw0kLnqt4uY10UJ4HhjawQ47ns4+NY6WX4WKIs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=bsBHTJKS; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1718265067;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=A/n+AhuyhqSsJr+vWl3tvLtoPgeLWQoTZ3U+G+ztgvo=;
	b=bsBHTJKSab5vyxARrVYEkE0NmQuDatcGMXaAaKJoo15ih9SDrqsfq2YT63gZm3Scfa84rd
	p7mx1n7QXkyO/5ye0UI/ldh4mdD35HtU3h+BqqWD3oVhhYdmsgMxrQdnIoB1vJsrDejFdg
	MCNDtz5c7vAiD3mje3u27NTMzEeulVc=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-412-Fh9-ocaoMnyeThyRVxEGtQ-1; Thu, 13 Jun 2024 03:51:05 -0400
X-MC-Unique: Fh9-ocaoMnyeThyRVxEGtQ-1
Received: by mail-wr1-f69.google.com with SMTP id ffacd0b85a97d-35f09791466so388098f8f.2
        for <kvm@vger.kernel.org>; Thu, 13 Jun 2024 00:51:04 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1718265064; x=1718869864;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=A/n+AhuyhqSsJr+vWl3tvLtoPgeLWQoTZ3U+G+ztgvo=;
        b=VV/g9KHmAAV3Sm+Z8sp11dDrUijsbuLUHN511x7E3QWhZoD6ra4IZq37hjoq+Dkyq/
         gZH1WJAVRp5PTAZ32pFkPm5Kkcje8VSjR+M/kwNO+b3E3uY2Vcoq7J0vGEagvyxOXJ4T
         CFOTLksbBN+60CVAs5JWrMzBTXVZnie20mIhP4o48CcXiVLGNeNozsEsDp+fv/8hwSZa
         rF3POzpO0bFzMuRs7iqWzidcKX0Rx3JukIhMMsYKqeLofhc7wdR9UfGRDyeg3nptUkBw
         6uBmAo/tn19gJMClwIALP74xpqBVUccIMvAxLTxTATWggfA+4CxtwKKnRI6NMqeAC62S
         OwMw==
X-Forwarded-Encrypted: i=1; AJvYcCVf4bWN5Fc/+cS2PqNZ/jQ2EG1BWBSRDJojprWbARBHBGr6Y+3WnEWwizxKNC13A5pn4BdmWJURA4PsyU4ADe0nJytf
X-Gm-Message-State: AOJu0YwsrpaMH7u8/vLD+xELsX4CPN/gVqaFeNzvq+D8hp6BM0Se2xe+
	aAGyhyjO/iapy3bYfu/CHdZvhCRFXgp1Mb36DwNTijdrZjMZK+REa2BKO4NqBgDPHRpGYosnl9t
	9p13jIz/2eCnu7m0cPPq7cF2nn6HvTXKqUPT1wD4+0tm09A95xw==
X-Received: by 2002:a05:6000:d:b0:360:75b3:2cd9 with SMTP id ffacd0b85a97d-36075b32d48mr830153f8f.65.1718265063724;
        Thu, 13 Jun 2024 00:51:03 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGecT5yUVKpC78rMOjYPpZNfe8ITqSuJs063PFj3s8mFpH0gfLFXFffpfByk9P/e9suAjpbJA==
X-Received: by 2002:a05:6000:d:b0:360:75b3:2cd9 with SMTP id ffacd0b85a97d-36075b32d48mr830121f8f.65.1718265063171;
        Thu, 13 Jun 2024 00:51:03 -0700 (PDT)
Received: from redhat.com ([2a02:14f:176:94c5:b48b:41a4:81c0:f1c8])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-36075093d58sm894451f8f.4.2024.06.13.00.50.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 13 Jun 2024 00:51:02 -0700 (PDT)
Date: Thu, 13 Jun 2024 03:50:54 -0400
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Jiri Pirko <jiri@resnulli.us>
Cc: Jakub Kicinski <kuba@kernel.org>, Cindy Lu <lulu@redhat.com>,
	dtatulea@nvidia.com, jasowang@redhat.com,
	virtualization@lists.linux-foundation.org,
	linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
	netdev@vger.kernel.org
Subject: Re: [PATCH 1/2] vdpa: support set mac address from vdpa tool
Message-ID: <20240613034647-mutt-send-email-mst@kernel.org>
References: <20240611053239.516996-1-lulu@redhat.com>
 <20240611185810.14b63d7d@kernel.org>
 <ZmlAYcRHMqCgYBJD@nanopsycho.orion>
 <20240612031356-mutt-send-email-mst@kernel.org>
 <ZmlMuGGY2po6LLCY@nanopsycho.orion>
 <20240613024756-mutt-send-email-mst@kernel.org>
 <Zmqd45TnVVZYPwp8@nanopsycho.orion>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Zmqd45TnVVZYPwp8@nanopsycho.orion>

On Thu, Jun 13, 2024 at 09:21:07AM +0200, Jiri Pirko wrote:
> Thu, Jun 13, 2024 at 08:49:25AM CEST, mst@redhat.com wrote:
> >On Wed, Jun 12, 2024 at 09:22:32AM +0200, Jiri Pirko wrote:
> >> Wed, Jun 12, 2024 at 09:15:44AM CEST, mst@redhat.com wrote:
> >> >On Wed, Jun 12, 2024 at 08:29:53AM +0200, Jiri Pirko wrote:
> >> >> Wed, Jun 12, 2024 at 03:58:10AM CEST, kuba@kernel.org wrote:
> >> >> >On Tue, 11 Jun 2024 13:32:32 +0800 Cindy Lu wrote:
> >> >> >> Add new UAPI to support the mac address from vdpa tool
> >> >> >> Function vdpa_nl_cmd_dev_config_set_doit() will get the
> >> >> >> MAC address from the vdpa tool and then set it to the device.
> >> >> >> 
> >> >> >> The usage is: vdpa dev set name vdpa_name mac **:**:**:**:**:**
> >> >> >
> >> >> >Why don't you use devlink?
> >> >> 
> >> >> Fair question. Why does vdpa-specific uapi even exist? To have
> >> >> driver-specific uapi Does not make any sense to me :/
> >> >
> >> >I am not sure which uapi do you refer to? The one this patch proposes or
> >> >the existing one?
> >> 
> >> Sure, I'm sure pointing out, that devlink should have been the answer
> >> instead of vdpa netlink introduction. That ship is sailed,
> >
> >> now we have
> >> unfortunate api duplication which leads to questions like Jakub's one.
> >> That's all :/
> >
> >
> >
> >Yea there's no point to argue now, there were arguments this and that
> >way.  I don't think we currently have a lot
> >of duplication, do we?
> 
> True. I think it would be good to establish guidelines for api
> extensions in this area.
> 
> >
> >-- 
> >MST
> >


Guidelines are good, are there existing examples of such guidelines in
Linux to follow though? Specifically after reviewing this some more, I
think what Cindy is trying to do is actually provisioning as opposed to
programming.

-- 
MST


