Return-Path: <kvm+bounces-7033-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 4D9D683CF94
	for <lists+kvm@lfdr.de>; Thu, 25 Jan 2024 23:49:16 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id AD2B0B26A9A
	for <lists+kvm@lfdr.de>; Thu, 25 Jan 2024 22:49:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 14C5111CB1;
	Thu, 25 Jan 2024 22:49:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="N5j5nBC6"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD735111B5
	for <kvm@vger.kernel.org>; Thu, 25 Jan 2024 22:49:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706222943; cv=none; b=EeQj8o2RjCOGMPgG+iQAW3W41Z6P6ZiFCh3ic6CjRZZr9f49v3Vjb+c1Z3MLO0ls/PGqAZzOKWwIy2dfY4R9j5Zz+WBaJGG4yFiFwteWVFEO196aRV4w/WU1na4DUsnEE6OgeJdF/sy8CYwtX12cWAfSW1hz6fejo+hZqhWcHe0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706222943; c=relaxed/simple;
	bh=CbmW/228GCi3mqE9tnHZSnzCJD3NGsjyla4RSnkrJ8c=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=IyFC4mcbZgzNWq+PVZlA5DpCEXecvC5vYGwFErxXmDcb+SxC5LDqQPGLUMm3joeqAqlTb5vwfMsIeY23PJQTgYHgf4/5QyTqEvORgiZzM9yLllZ+nDy0U4sIFiz5RiNNXifk07EXI4Ja0L4x7AwGtyw80E+HkUz8RAbs52SuWW4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=N5j5nBC6; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1706222940;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=q4Crka9/JgHcU0ey0pI+XUxXs9hF7aNw/5Jtdg8P4KE=;
	b=N5j5nBC6PXcvXuW5fmoXcfVAqqydqTzu0WTZvC7GiKxX2bjjFRtv95BcPeErdgn9Xp42nK
	0+Fey16/S+J+wwrcLklbVZL+Mewsru9eDEH9fh7IpLbxhRSoh7ngLcq8n7SHlK+fGA2hOc
	6S3sQ9AeJPz7NPY+iCpQO2I/pepaGf4=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-538-BxwGEJ4dPu6OQ0wviROkbA-1; Thu, 25 Jan 2024 17:48:59 -0500
X-MC-Unique: BxwGEJ4dPu6OQ0wviROkbA-1
Received: by mail-wr1-f70.google.com with SMTP id ffacd0b85a97d-337a9795c5cso5196030f8f.2
        for <kvm@vger.kernel.org>; Thu, 25 Jan 2024 14:48:59 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1706222938; x=1706827738;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=q4Crka9/JgHcU0ey0pI+XUxXs9hF7aNw/5Jtdg8P4KE=;
        b=feLIN5C2gijLX3saw0zh/0nDKYmtWB2y6iQekDjoodc4fu1f5YM500IxAvi3i6fon9
         9TAGWPg2+YqB8IwJJYCVJVOpjv9iHHIdSfImoSa4J53R9RNbiY1qWYBzw4xQNobnI/Kw
         JIFTP8RMBm219swwpftt/4NM4oHN24nmp58ORDVg+oklriGeUFT5K4oc8E7QAvZtm6Bz
         pFpRZOi9zMp/9/GH3zR9C9M/E8AeyAw1U8zyPD/tJZ+xhyWiUrfQK0hbg2NTcopn/0Kc
         LhHjMpA+6LD8mKxYf9p6qXVetvXaI9FKYQZNXAidM4DMvye133RZyV7hoxtqeq6PT8g3
         q1xQ==
X-Gm-Message-State: AOJu0Yxv7ddWkLByYpPT+2+/Tsb6sK4ny86/+NC9lHNT+2TcO90Zwugb
	c6nlIyYjCjluJ5cDdjMOrHVMytSwvl4AGDv6W3nxId2VmfOXbyRnoy9FVdYlWT8nImCJk6Bu91X
	aIueZmgW+S4mneD3B4MCYlrM0th4WtT8X1LHbZsOfpPSejSOpYQ==
X-Received: by 2002:a5d:456f:0:b0:337:bfd4:8c1b with SMTP id a15-20020a5d456f000000b00337bfd48c1bmr209627wrc.23.1706222938149;
        Thu, 25 Jan 2024 14:48:58 -0800 (PST)
X-Google-Smtp-Source: AGHT+IEYwVPAR3CAgbGUu1SF1zj6JUO3aXtfnw/UqEkEi86zKYeiQ92JA4m9kDpOpg8QaBLVc0gbMg==
X-Received: by 2002:a5d:456f:0:b0:337:bfd4:8c1b with SMTP id a15-20020a5d456f000000b00337bfd48c1bmr209611wrc.23.1706222937744;
        Thu, 25 Jan 2024 14:48:57 -0800 (PST)
Received: from redhat.com ([2.52.130.36])
        by smtp.gmail.com with ESMTPSA id x1-20020adff641000000b0033922db3f74sm15876156wrp.116.2024.01.25.14.48.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 25 Jan 2024 14:48:56 -0800 (PST)
Date: Thu, 25 Jan 2024 17:48:52 -0500
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Arseniy Krasnov <avkrasnov@salutedevices.com>
Cc: Stefan Hajnoczi <stefanha@redhat.com>,
	Stefano Garzarella <sgarzare@redhat.com>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	Jason Wang <jasowang@redhat.com>,
	Bobby Eshleman <bobby.eshleman@bytedance.com>, kvm@vger.kernel.org,
	virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org, kernel@sberdevices.ru,
	oxffffaa@gmail.com
Subject: Re: [PATCH net-next v1] vsock/test: print type for SOCK_SEQPACKET
Message-ID: <20240125174845-mutt-send-email-mst@kernel.org>
References: <20240124193255.3417803-1-avkrasnov@salutedevices.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240124193255.3417803-1-avkrasnov@salutedevices.com>

On Wed, Jan 24, 2024 at 10:32:55PM +0300, Arseniy Krasnov wrote:
> SOCK_SEQPACKET is supported for virtio transport, so do not interpret
> such type of socket as unknown.
> 
> Signed-off-by: Arseniy Krasnov <avkrasnov@salutedevices.com>


Acked-by: Michael S. Tsirkin <mst@redhat.com>

> ---
>  tools/testing/vsock/vsock_diag_test.c | 2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/tools/testing/vsock/vsock_diag_test.c b/tools/testing/vsock/vsock_diag_test.c
> index 5e6049226b77..17aeba7cbd14 100644
> --- a/tools/testing/vsock/vsock_diag_test.c
> +++ b/tools/testing/vsock/vsock_diag_test.c
> @@ -39,6 +39,8 @@ static const char *sock_type_str(int type)
>  		return "DGRAM";
>  	case SOCK_STREAM:
>  		return "STREAM";
> +	case SOCK_SEQPACKET:
> +		return "SEQPACKET";
>  	default:
>  		return "INVALID TYPE";
>  	}
> -- 
> 2.25.1


