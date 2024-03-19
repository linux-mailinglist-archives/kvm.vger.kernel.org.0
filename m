Return-Path: <kvm+bounces-12113-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id CDB3A87FA02
	for <lists+kvm@lfdr.de>; Tue, 19 Mar 2024 09:34:58 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 0BAFC1C21BFE
	for <lists+kvm@lfdr.de>; Tue, 19 Mar 2024 08:34:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1171C7B3F6;
	Tue, 19 Mar 2024 08:34:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="J3vZ0b6X"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C7132364
	for <kvm@vger.kernel.org>; Tue, 19 Mar 2024 08:34:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710837287; cv=none; b=RusdPr90chFXsMOCWKe+nAAR6/3W6RA/92l9R0LsCayMb+70dDZGD8+tC7iLXkf1goGSCvFQIo2n2nux6IfEhPnJyJJ7QB+sf4g/+TBXMJA1yIo/6UNtiS1zSil/5yF6UpGQ55BQ4MRqKVZBRN2YukLOE1aXXXZnSX9wEA7IVAo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710837287; c=relaxed/simple;
	bh=Uhw7X37ePZrOYI/rJry/tZ9rI468Mam9nGel7TLxUcI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=pp7rd+3f+hi/aUYw+8SFCFlGUYyEvFaFpZZd46dGRZt7ukkN2Q/p0AA/GF+tubvifKBlKIMu8KdwH6mup+168L8YbVjylVI8yta7FiGzUnkwf7coHNDYcPF9x1QODVG8uXEGL000asiYeLyL/xSzazf0CzZfEi5rX9jR0ZBnemk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=J3vZ0b6X; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1710837284;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=bidhNprDIaXErWo++B8NK9gU1Mr0P973Tkk526SOsxc=;
	b=J3vZ0b6X0dOzxKLwq78pmBhv2yFBYNaN1+G9Uc0v0+Rals2hBpKzBv2QmaeqmymONSHj2j
	ezv11gzKFQQQZanWGpgF88Z43BvXnUqaNin7b9aTQG79a0lIkqEpL9vaIw5MDome3CzKCt
	RKQAPmSRbTZi7kpu3NlZQp237PNZSsQ=
Received: from mail-ed1-f72.google.com (mail-ed1-f72.google.com
 [209.85.208.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-130-DPemvRFmNMCwaOXsbk4pfw-1; Tue, 19 Mar 2024 04:34:42 -0400
X-MC-Unique: DPemvRFmNMCwaOXsbk4pfw-1
Received: by mail-ed1-f72.google.com with SMTP id 4fb4d7f45d1cf-56b924de243so287166a12.1
        for <kvm@vger.kernel.org>; Tue, 19 Mar 2024 01:34:42 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1710837281; x=1711442081;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=bidhNprDIaXErWo++B8NK9gU1Mr0P973Tkk526SOsxc=;
        b=BtfQFzVD9F2z+EsYq7WhIvuL93FtG+TL2hGYrDo1LTxYRXSnvNXyE/klyQJJbtTSSS
         K94PotAsuGHPc81u/99/r79VRwTzVryOqaiRiOZH1gnaqffqrn/GQ5FaTEbA2G1jmW+K
         CkKGmCZFGDb+r29FyNEZgHN3ayeCedsHqUfyNnE5h3N7X8RsrMxvEQkYrFH6rFFeRZyr
         RKJ4YBaGNtkqJxeTnqCb8YeQBWfHndsPrGARuXzUhC1/qLgG0Q2f1AIY8lSxNxbeerrV
         IyA4xcPDrNf5nHsiIua9yd0YPAIwtTtZfPqB1HFCPkISC/y+DOIXWjUuUc7VDsFK7NwU
         LeZQ==
X-Forwarded-Encrypted: i=1; AJvYcCUWk1/K/zM2iHw1dTEhl1H2w2s4iTR+o+iZQ5Qic++428oiiJhy7GSx49sGmh31cgn3wJTek7JVdkU53pGzF7ZrxeF+
X-Gm-Message-State: AOJu0YxRmlmMH+hJIV16zCPPaVYzl+b44eWuf2v5/fUSl42MzwVXxkI3
	hTv3+Xa5BoNwIZh3paGm2FJpyJ2+i5hneuwoLjy/cUpz0zGqiBjRfCKZRHcfbh3WpbkMsNVJT8z
	55DPR5j3W0K78T5V1wZP4ZPvSk8IiGtAnDojfgw7RaRcfPc/dzpGYGMEavg==
X-Received: by 2002:a05:6402:1cd0:b0:566:ca0:4a91 with SMTP id ds16-20020a0564021cd000b005660ca04a91mr10498306edb.2.1710837281378;
        Tue, 19 Mar 2024 01:34:41 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IH2M46P0WU30p/kI4KM147xUw+jHFCsikBReD0bxprbCUbp1whXFumyfQAXLRkNAFtveWMugw==
X-Received: by 2002:a05:6512:68c:b0:513:db96:2be9 with SMTP id t12-20020a056512068c00b00513db962be9mr10460157lfe.64.1710836978279;
        Tue, 19 Mar 2024 01:29:38 -0700 (PDT)
Received: from redhat.com ([2.52.6.254])
        by smtp.gmail.com with ESMTPSA id g14-20020a5d540e000000b0033e95bf4796sm11737388wrv.27.2024.03.19.01.29.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 19 Mar 2024 01:29:37 -0700 (PDT)
Date: Tue, 19 Mar 2024 04:29:33 -0400
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Tobias Huschle <huschle@linux.ibm.com>
Cc: Luis Machado <luis.machado@arm.com>, Jason Wang <jasowang@redhat.com>,
	Abel Wu <wuyun.abel@bytedance.com>,
	Peter Zijlstra <peterz@infradead.org>,
	Linux Kernel <linux-kernel@vger.kernel.org>, kvm@vger.kernel.org,
	virtualization@lists.linux.dev, netdev@vger.kernel.org,
	nd <nd@arm.com>
Subject: Re: EEVDF/vhost regression (bisected to 86bfbb7ce4f6 sched/fair: Add
 lag based placement)
Message-ID: <20240319042829-mutt-send-email-mst@kernel.org>
References: <07974.124020102385100135@us-mta-501.us.mimecast.lan>
 <20240201030341-mutt-send-email-mst@kernel.org>
 <89460.124020106474400877@us-mta-475.us.mimecast.lan>
 <20240311130446-mutt-send-email-mst@kernel.org>
 <cf813f92-9806-4449-b099-1bb2bd492b3c@arm.com>
 <73123.124031407552500165@us-mta-156.us.mimecast.lan>
 <20240314110649-mutt-send-email-mst@kernel.org>
 <84704.124031504335801509@us-mta-515.us.mimecast.lan>
 <20240315062839-mutt-send-email-mst@kernel.org>
 <b3fd680c675208370fc4560bb3b4d5b8@linux.ibm.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b3fd680c675208370fc4560bb3b4d5b8@linux.ibm.com>

On Tue, Mar 19, 2024 at 09:21:06AM +0100, Tobias Huschle wrote:
> On 2024-03-15 11:31, Michael S. Tsirkin wrote:
> > On Fri, Mar 15, 2024 at 09:33:49AM +0100, Tobias Huschle wrote:
> > > On Thu, Mar 14, 2024 at 11:09:25AM -0400, Michael S. Tsirkin wrote:
> > > >
> > 
> > Could you remind me pls, what is the kworker doing specifically that
> > vhost is relying on?
> 
> The kworker is handling the actual data moving in memory if I'm not
> mistaking.

I think that is the vhost process itself. Maybe you mean the
guest thread versus the vhost thread then?


