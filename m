Return-Path: <kvm+bounces-18028-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 205708CD087
	for <lists+kvm@lfdr.de>; Thu, 23 May 2024 12:43:47 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id D0D09282147
	for <lists+kvm@lfdr.de>; Thu, 23 May 2024 10:43:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6AB80144300;
	Thu, 23 May 2024 10:43:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="H3qz4aTV"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C445913CFAF
	for <kvm@vger.kernel.org>; Thu, 23 May 2024 10:43:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716461016; cv=none; b=fUm3+tGQgU09tmoGqbv4czOy127EA3CrQzrdRJivIz1LrqfzsXRKvJg0KFX+BRwTR0v9xU2evxN5NgLLeDHS4SHxq7W7DrqFuQQvTLTHtsLe6PfCYLvKNga/U3frtK1G9V9y8G9y2jfMpAu4J+DEd6IXDHVhvsJT1VP/YDs8POE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716461016; c=relaxed/simple;
	bh=nDxsQh//zo1y5z5bauVnQVFtzT643YqTMG646rY/zdA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=iLvmVShGu2OmkqIienpb5O+vwOcGbyBXkyQjhNoLtmQWsZ3T0hWq5JGafe88c8c91Z7ac/wBrP0HRKkPPTpmrdD/wLqdYni0Zd1cpbmuROCu8U+OsTxIz/s8UitOBlGO/hiWrmynRsJiVmRl7R+pHpmaJgBg5Gi/XTlOFeJ7l08=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=H3qz4aTV; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1716461013;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=hbDIGJhvRjqMZ04SQyKdRF9N/GO/OgDidrS2yTufDB8=;
	b=H3qz4aTVKr+OMbvuUxpBrg9t6+NG/SskX0gaFK/95eKyiRgzEZvmvknRtKoT6794KtXJC0
	X8gi9x5+8aR61bq8SgwBnqWUgd7v/F0MYLcI4/63U7KUtS4tVXmSdMVbdf+tN9YRn7WhAk
	ur1/XHAVL2BIdj43AOgm9h+ij5rZ5hE=
Received: from mail-qk1-f198.google.com (mail-qk1-f198.google.com
 [209.85.222.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-264-uVxeLl-TNny6VE4brl0dPw-1; Thu, 23 May 2024 06:43:32 -0400
X-MC-Unique: uVxeLl-TNny6VE4brl0dPw-1
Received: by mail-qk1-f198.google.com with SMTP id af79cd13be357-792ff352462so1183366685a.1
        for <kvm@vger.kernel.org>; Thu, 23 May 2024 03:43:32 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1716461012; x=1717065812;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=hbDIGJhvRjqMZ04SQyKdRF9N/GO/OgDidrS2yTufDB8=;
        b=H3X6iWNZjJLjRPyZobXflrYixzLZEMoYJ3aCX9NoEHHP0dkHb7q0cd19UgznEirkFe
         sqXH5uhGGf5o3+HUBoZHT4P8HddWxA5B75iSLo6Q4mjiIsUKWFsEq6uWqvV3TCzY6mhF
         FDbPMXIHK+u+jaUDNW9I4/615zkzhmACO3eLQ3GuIoQVW9qYbbd7DF9xkPlIiGuLtmG+
         Pnl5GHplskKMZP/8OzlB429xX4YZJ7unhMXjsppGEjy6AoGRz7Hz9xhWV/YZQh9JXwWT
         qDLmilfdnXQT3BQmUAbUDF4Zi4fCyxxRtXqWcpqsVtBtyK5/knDMlhVxlmft/PabaxIf
         FXVQ==
X-Forwarded-Encrypted: i=1; AJvYcCWRYIRBAkHUtpWJG4gVrGtqTKFda+woadMGkHtPCPTOKo5qKK8O71iYsfrFtM0kHSlv23A1m2bQJI7+f3m5a1isAATu
X-Gm-Message-State: AOJu0YwdHyRYwI1xyqY//tpq8X2cblpdk8rjUfZYi/v9nsi11IsebYr6
	qMEtU/KHV5YJ/zwauPDKS4BqW19vCoqcwr++HaECwUR2Q1g8ttQjdmClFIYZe5KvGphjdTbicCi
	TxjXGlo66mNeuo5pS3LXs+jieVJo902XRMiYxpU14aAnr/oZFNw==
X-Received: by 2002:a05:620a:f87:b0:792:c037:abc7 with SMTP id af79cd13be357-7949943d681mr399675985a.25.1716461011796;
        Thu, 23 May 2024 03:43:31 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHyXkeky/hgXWrbr7XrVg67knYOzWxw3YK7pzC7NB1DXzAMHA73585YCgpBWOuQEQKJpllUnQ==
X-Received: by 2002:a05:620a:f87:b0:792:c037:abc7 with SMTP id af79cd13be357-7949943d681mr399674785a.25.1716461011444;
        Thu, 23 May 2024 03:43:31 -0700 (PDT)
Received: from sgarzare-redhat (host-79-53-30-109.retail.telecomitalia.it. [79.53.30.109])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-794724bb95dsm531587285a.53.2024.05.23.03.43.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 23 May 2024 03:43:30 -0700 (PDT)
Date: Thu, 23 May 2024 12:43:26 +0200
From: Stefano Garzarella <sgarzare@redhat.com>
To: Xuewei Niu <niuxuewei97@gmail.com>
Cc: stefanha@redhat.com, mst@redhat.com, davem@davemloft.net, 
	kvm@vger.kernel.org, virtualization@lists.linux.dev, netdev@vger.kernel.org, 
	linux-kernel@vger.kernel.org, Xuewei Niu <niuxuewei.nxw@antgroup.com>
Subject: Re: [RFC PATCH 1/5] vsock/virtio: Extend virtio-vsock spec with an
 "order" field
Message-ID: <opwx66tvekodbus52cmg4nihiopma46b7fpnnrdzw6l2ij7jai@7rqy3nnl6upn>
References: <20240517144607.2595798-1-niuxuewei.nxw@antgroup.com>
 <20240517144607.2595798-2-niuxuewei.nxw@antgroup.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20240517144607.2595798-2-niuxuewei.nxw@antgroup.com>

As Alyssa suggested, we should discuss spec changes in the virtio ML.
BTW as long as this is an RFC, it's fine. Just be sure, though, to 
remember to merge the change in the specification first versus the 
patches in Linux.
So I recommend that you don't send a non-RFC set into Linux until you 
have agreed on the changes to the specification.

On Fri, May 17, 2024 at 10:46:03PM GMT, Xuewei Niu wrote:
>The "order" field determines the location of the device in the linked list,
>the device with CID 4, having a smallest order, is in the first place, and
>so forth.

Do we really need an order, or would it suffice to just indicate the 
device to be used by default? (as the default gateway in networking)

>
>Rules:
>
>* It doesn’t have to be continuous;
>* It cannot exist conflicts;
>* It is optional for the mode of a single device, but is required for the
>  mode of multiple devices.

We should also add a feature to support this new field.

>
>Signed-off-by: Xuewei Niu <niuxuewei.nxw@antgroup.com>
>---
> include/uapi/linux/virtio_vsock.h | 1 +
> 1 file changed, 1 insertion(+)
>
>diff --git a/include/uapi/linux/virtio_vsock.h b/include/uapi/linux/virtio_vsock.h
>index 64738838bee5..b62ec7d2ab1e 100644
>--- a/include/uapi/linux/virtio_vsock.h
>+++ b/include/uapi/linux/virtio_vsock.h
>@@ -43,6 +43,7 @@
>
> struct virtio_vsock_config {
> 	__le64 guest_cid;
>+	__le64 order;

Do we really need 64 bits for the order?

> } __attribute__((packed));
>
> enum virtio_vsock_event_id {
>-- 
>2.34.1
>


