Return-Path: <kvm+bounces-43270-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id ECBFCA88B81
	for <lists+kvm@lfdr.de>; Mon, 14 Apr 2025 20:39:34 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 8CD843B4836
	for <lists+kvm@lfdr.de>; Mon, 14 Apr 2025 18:39:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 97F3F28DEF0;
	Mon, 14 Apr 2025 18:39:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="h2w8UC1D"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1C849289374
	for <kvm@vger.kernel.org>; Mon, 14 Apr 2025 18:39:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744655955; cv=none; b=VxZJSGghIt+K+u4tbVk1tuJRDwzD7Vtv0z7cOp8DO3mPo2pD/CDD8KILrU/4ulW43mM01xIHRNiIVSqWBU7Qvn3HlSe0oJlb67jF+AiBVEHnYHAhe1LF1zy1A8rqglB9/scyAobFguKWvcRXDYvVlccI7O+Jfa+b+xqvqIOuOck=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744655955; c=relaxed/simple;
	bh=3l2S1L46U8XsU4sWtbSp+mYEbAJYokaHNWfzbDztxOM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=lAScXzJqafBq/VuhORxV3EzEDPNISr3gTv0IfxyI0nZHqUhheUn4CnFniHWKQ8GgZfUse5/KmooPORoio82cF+5qOEE43YZhK8aMXH6Ce0np2OkqowV17WQyy4cTHKPY+IKN67n4wzQBoI0WXA6K2RlP4heLIX2ELIkuVRoY6Ok=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=h2w8UC1D; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1744655953;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=r/iXXqChlzjbODZfwDRdIt5xwYfNbSaluxaykDmQl48=;
	b=h2w8UC1DaFdnC9duQ0kK3ZKAnRG71Jqi57JvpWhnq1ufuhXRUEfTT/+7EhkBxaM9DPPZ2Y
	x6R1baorzkXXN2CU/VgenUsRLgPrSOJVwOXdzNzOfIG6TUUzUAnxJLc59k/V8XAtWz/ToT
	pHRFCPTNd8NlJkbadf9jk9TFAtv44Bc=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-333-PR057SqhMdqrzk4u7K3bng-1; Mon, 14 Apr 2025 14:39:09 -0400
X-MC-Unique: PR057SqhMdqrzk4u7K3bng-1
X-Mimecast-MFC-AGG-ID: PR057SqhMdqrzk4u7K3bng_1744655948
Received: by mail-wr1-f69.google.com with SMTP id ffacd0b85a97d-39123912ff0so1855997f8f.2
        for <kvm@vger.kernel.org>; Mon, 14 Apr 2025 11:39:09 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1744655948; x=1745260748;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=r/iXXqChlzjbODZfwDRdIt5xwYfNbSaluxaykDmQl48=;
        b=eOjFy6z/vZKDtG8A8TxdqUaR983fmVyWqNWidik1KjBpXSrUPHBTFTQx3hZ9jbXwqJ
         +uiVGnLo8t0RY49JQv7+FxPJTtxWt3QvI5201Y4hgnkKolYRgH1bY8Dwapx2VXLnCOIv
         hOTG8+VWyhpa0OSzQlHwsIp+sCZiKrnMD3o5emxNXHCWQeDvQ8/BWneoq/c4Rf88aQf6
         uupxZn6a0z4jFqXOGBXc3oQ5iP19MrnZn1cTraU0dbN4iJpxshWEPWU4gyQnUb+Uc53B
         yyHIQgrQF2gEYxinBpg+xRWsMc3pJXZp8YBRD91VbTzabRD2ts7+w2jZ0sSiKcUEjKjD
         eu4g==
X-Forwarded-Encrypted: i=1; AJvYcCXSyyWM+LYT312kSz1HH++FvcWpUPFtn5zw8xHpjD9W4mXWw6lG0d0nk7bOnsyionXf3Yw=@vger.kernel.org
X-Gm-Message-State: AOJu0YxSE3UDwGmkUc/9Ue5T+cYEqxzPsb68LPMdKqFfk5MMbo7deaKq
	EduQCQeU02ZhHjGjNg0Vgj4FGYtLelYyDR8TYlA0iLlK8QUuZrc/Y2+Db83xiBrRIV3AMhVXZ+0
	DMk+ynTxIQy503D2QjEzwnf5m1ygIgbpza1Qme37TTN5A1SFjAw==
X-Gm-Gg: ASbGncvpqLAp/MWeN2fYinRt9mVSGC8vg4hDVCqYJ+fwhAZnkDHKOOKBweYCrCKK5+A
	qwbwalc2XzxZ6LhxZvAdw9+PBhDo8j4qoAwj/tDWX/xF4gSjrx/sttjmW5wWtpqo7DGMHzemvKn
	ibOgqz32bX1EOpI08XJhX9KGNcxSajzha0e5WWLC72qSiOxwMJFF7fEvpnMsBL0lN7maKKMCYHI
	Ai0x1jR/YwbO0wmBppuG8wiBItMTXgBEJOvkiIs5dghZLmopQtvm4e9P1cH9sBvgcK/EDtI7dK+
	YEtG/A==
X-Received: by 2002:a5d:6da8:0:b0:39c:1424:3246 with SMTP id ffacd0b85a97d-39ea51d3527mr9946038f8f.2.1744655948211;
        Mon, 14 Apr 2025 11:39:08 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHAxTcLnqSrTxH65+u6GiRouP7vWe1kbCg6AHGAsfsrltSDOoWgKmUYeCud8h0C9/BhA/o+Iw==
X-Received: by 2002:a5d:6da8:0:b0:39c:1424:3246 with SMTP id ffacd0b85a97d-39ea51d3527mr9946011f8f.2.1744655947712;
        Mon, 14 Apr 2025 11:39:07 -0700 (PDT)
Received: from redhat.com ([2a0d:6fc0:1517:1000:ea83:8e5f:3302:3575])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-39eaf445788sm11861921f8f.93.2025.04.14.11.39.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 14 Apr 2025 11:39:06 -0700 (PDT)
Date: Mon, 14 Apr 2025 14:39:04 -0400
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Dongli Zhang <dongli.zhang@oracle.com>
Cc: virtualization@lists.linux.dev, kvm@vger.kernel.org,
	netdev@vger.kernel.org, jasowang@redhat.com,
	michael.christie@oracle.com, pbonzini@redhat.com,
	stefanha@redhat.com, eperezma@redhat.com, joao.m.martins@oracle.com,
	joe.jin@oracle.com, si-wei.liu@oracle.com,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 9/9] vhost: add WARNING if log_num is more than limit
Message-ID: <20250414143039-mutt-send-email-mst@kernel.org>
References: <20250403063028.16045-1-dongli.zhang@oracle.com>
 <20250403063028.16045-10-dongli.zhang@oracle.com>
 <20250414123119-mutt-send-email-mst@kernel.org>
 <e00d882e-9ce7-48b0-bc2f-bf937ff6b9c3@oracle.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e00d882e-9ce7-48b0-bc2f-bf937ff6b9c3@oracle.com>

On Mon, Apr 14, 2025 at 09:52:04AM -0700, Dongli Zhang wrote:
> Hi Michael,
> 
> On 4/14/25 9:32 AM, Michael S. Tsirkin wrote:
> > On Wed, Apr 02, 2025 at 11:29:54PM -0700, Dongli Zhang wrote:
> >> Since long time ago, the only user of vq->log is vhost-net. The concern is
> >> to add support for more devices (i.e. vhost-scsi or vsock) may reveals
> >> unknown issue in the vhost API. Add a WARNING.
> >>
> >> Suggested-by: Joao Martins <joao.m.martins@oracle.com>
> >> Signed-off-by: Dongli Zhang <dongli.zhang@oracle.com>
> > 
> > 
> > Userspace can trigger this I think, this is a problem since
> > people run with reboot on warn.
> 
> I think it will be a severe kernel bug (page fault) if userspace can trigger this.
> 
> If (*log_num >= vq->dev->iov_limit), the next line will lead to an out-of-bound
> memory access:
> 
>     log[*log_num].addr = vhost64_to_cpu(vq, desc.addr);
> 
> I could not propose a case to trigger the WARNING from userspace. Would you mind
> helping explain if that can happen?

Oh I see. the commit log made me think this is an actual issue,
not a debugging aid just in case.


> > Pls grammar issues in comments... I don't think so.
> 
> I did an analysis of code and so far I could not identify any case to trigger
> (*log_num >= vq->dev->iov_limit).
> 
> The objective of the patch is to add a WARNING to double confirm the case won't
> happen.
> 
> Regarding "I don't think so", would you mean we don't need this patch/WARNING
> because the code is robust enough?
> 
> Thank you very much!
> 
> Dongli Zhang


Let me clarify the comment is misleading.
All it has to say is:

	/* Let's make sure we are not out of bounds. */
	BUG_ON(*log_num >= vq->dev->iov_limit);

at the same time, this is unnecessary pointer chasing
on critical path, and I don't much like it that we are
making an assumption about array size here.

If you strongly want to do it, you must document it near
get_indirect: 
@log - array of size at least vq->dev->iov_limit


> > 
> >> ---
> >>  drivers/vhost/vhost.c | 18 ++++++++++++++++++
> >>  1 file changed, 18 insertions(+)
> >>
> >> diff --git a/drivers/vhost/vhost.c b/drivers/vhost/vhost.c
> >> index 494b3da5423a..b7d51d569646 100644
> >> --- a/drivers/vhost/vhost.c
> >> +++ b/drivers/vhost/vhost.c
> >> @@ -2559,6 +2559,15 @@ static int get_indirect(struct vhost_virtqueue *vq,
> >>  		if (access == VHOST_ACCESS_WO) {
> >>  			*in_num += ret;
> >>  			if (unlikely(log && ret)) {
> >> +				/*
> >> +				 * Since long time ago, the only user of
> >> +				 * vq->log is vhost-net. The concern is to
> >> +				 * add support for more devices (i.e.
> >> +				 * vhost-scsi or vsock) may reveals unknown
> >> +				 * issue in the vhost API. Add a WARNING.
> >> +				 */
> >> +				WARN_ON_ONCE(*log_num >= vq->dev->iov_limit);
> >> +
> >>  				log[*log_num].addr = vhost64_to_cpu(vq, desc.addr);
> >>  				log[*log_num].len = vhost32_to_cpu(vq, desc.len);
> >>  				++*log_num;
> >> @@ -2679,6 +2688,15 @@ int vhost_get_vq_desc(struct vhost_virtqueue *vq,
> >>  			 * increment that count. */
> >>  			*in_num += ret;
> >>  			if (unlikely(log && ret)) {
> >> +				/*
> >> +				 * Since long time ago, the only user of
> >> +				 * vq->log is vhost-net. The concern is to
> >> +				 * add support for more devices (i.e.
> >> +				 * vhost-scsi or vsock) may reveals unknown
> >> +				 * issue in the vhost API. Add a WARNING.
> >> +				 */
> >> +				WARN_ON_ONCE(*log_num >= vq->dev->iov_limit);
> >> +
> >>  				log[*log_num].addr = vhost64_to_cpu(vq, desc.addr);
> >>  				log[*log_num].len = vhost32_to_cpu(vq, desc.len);
> >>  				++*log_num;
> >> -- 
> >> 2.39.3
> > 


