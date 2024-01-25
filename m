Return-Path: <kvm+bounces-6988-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 979B983BBE8
	for <lists+kvm@lfdr.de>; Thu, 25 Jan 2024 09:26:12 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id CA6501C21F78
	for <lists+kvm@lfdr.de>; Thu, 25 Jan 2024 08:26:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 079CF175AA;
	Thu, 25 Jan 2024 08:25:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="EJULUgE4"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BB95917BCC
	for <kvm@vger.kernel.org>; Thu, 25 Jan 2024 08:25:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706171153; cv=none; b=KSFNfNBFS2fQM4Ac4/OCOvtcoW7lN052FyhXQEUXFll3oc7Lyep9ZN5AqWBpkZ+5vA79/y3bkZU0fbR/Do7JEA4YXNc4dawLj3fTR2f7wleF9vPlrYySEhpNhG70K1CtmR7zyiCJBq+i1HXL+lfH4U10hXiDcFjVaNswuxiXMrM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706171153; c=relaxed/simple;
	bh=9iZDsOrwFbNhFUiQrCQV8ZvnDuL4DsA+Z6fFe12B2C8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=gsVtDMe8HKyDSa+c0r4ePpiFetE/I4m7IYcrR8LvVh4hSJKyaMz3CiJ+uoCKv9NP6kIwCkeZMcf+TgWhe/i/PqmomaOY7LEm2VgPU2EDkk+corHFX+biwAL8Gy6EhATqTwOWqzWqFsRhfvbr89rB7o0acnuLCCBk0KSjiE5rbls=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=EJULUgE4; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1706171150;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=7yorbOu4W949PDf1wJwUQ2ZcnYgGGHn5INiZOwEc64I=;
	b=EJULUgE4YgEr5HfC6r02tYnByMq90Xyd3Q6RhzRB7foFrHIRv6OlJqGGOkMwL7Q2kgqWoe
	dElvEQ1bUtBaUoNmIHpcf/9MHgk6sUDhqBQvwG+cLV+u01651Z1WP2MdtNfrJFq7mLiFB1
	CnU4bYSUXrTuhBUm7bJwNQhlYeFkDjs=
Received: from mail-ej1-f70.google.com (mail-ej1-f70.google.com
 [209.85.218.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-204-bqZiJEKkOzaRzNsScq25EQ-1; Thu, 25 Jan 2024 03:25:48 -0500
X-MC-Unique: bqZiJEKkOzaRzNsScq25EQ-1
Received: by mail-ej1-f70.google.com with SMTP id a640c23a62f3a-a2c4e9cb449so365522866b.1
        for <kvm@vger.kernel.org>; Thu, 25 Jan 2024 00:25:48 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1706171147; x=1706775947;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=7yorbOu4W949PDf1wJwUQ2ZcnYgGGHn5INiZOwEc64I=;
        b=fQhyERkjo/jKYIcUOlJzGgEHVEYq8kc+XXiybO6+OLJZgcRo3VzRrqfgtqES0MHbPY
         Dyh+UdTgL8WhSLw/HFlfha7OIpHgCAEudwJI70FUVbCW/K1sFvmMzG5TDriKwlG0wq/n
         eox/+WYo3DijGi/X1eQDMj7EeilLS0THIoc9LbJYKXeMTAkbzy1UFwEOO2tKPs3wXzyT
         /ORmAlAISsEf02RBqRjktgBEUzzagusqL7bv7iaNBF7e283zdRant5ueufzslpHzOheg
         6L5y6nSSPanWDTME5wUQ5GArl6ybPEgeQLKubBSWa05WhsOyt+0WB0IjpITEsaPwXbPX
         kW0Q==
X-Gm-Message-State: AOJu0Yz7v17tuBULFsRcGKhfE84GS0a0HNzGMfKZx/iqBveRHIRIGbc5
	YA5WaDMBcAhsRr2wItIoiT6XyuXYhxCGIIWM3Qy/YFj2UrBWBc/fku/sKHKWcdxRmnDyDmIJoYz
	CJnUee+0HcazM8T3wF5VBpMkCJ/eJA2hdDScDs78as1pZFc+pwA==
X-Received: by 2002:a17:906:194a:b0:a23:5672:735 with SMTP id b10-20020a170906194a00b00a2356720735mr200629eje.290.1706171147577;
        Thu, 25 Jan 2024 00:25:47 -0800 (PST)
X-Google-Smtp-Source: AGHT+IHtAmXQ4VLJ33gfVHQUvreFWKCVhdbCgy8sC+T+BXXLfj7avWyKayxGoOmLBlfAtzRcbKl+LA==
X-Received: by 2002:a17:906:194a:b0:a23:5672:735 with SMTP id b10-20020a170906194a00b00a2356720735mr200626eje.290.1706171147221;
        Thu, 25 Jan 2024 00:25:47 -0800 (PST)
Received: from sgarzare-redhat (host-87-12-25-71.business.telecomitalia.it. [87.12.25.71])
        by smtp.gmail.com with ESMTPSA id vb1-20020a170907d04100b00a3177f658afsm411613ejc.206.2024.01.25.00.25.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 25 Jan 2024 00:25:45 -0800 (PST)
Date: Thu, 25 Jan 2024 09:25:43 +0100
From: Stefano Garzarella <sgarzare@redhat.com>
To: Arseniy Krasnov <avkrasnov@salutedevices.com>
Cc: Stefan Hajnoczi <stefanha@redhat.com>, 
	"David S. Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>, 
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>, 
	"Michael S. Tsirkin" <mst@redhat.com>, Jason Wang <jasowang@redhat.com>, 
	Bobby Eshleman <bobby.eshleman@bytedance.com>, kvm@vger.kernel.org, virtualization@lists.linux-foundation.org, 
	netdev@vger.kernel.org, linux-kernel@vger.kernel.org, kernel@sberdevices.ru, 
	oxffffaa@gmail.com
Subject: Re: [PATCH net-next v1] vsock/test: print type for SOCK_SEQPACKET
Message-ID: <nsnvxue53rbvtyxwcouebcev6uk7izz62htxyqrngpfvl26qs2@jubx6oacqcck>
References: <20240124193255.3417803-1-avkrasnov@salutedevices.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20240124193255.3417803-1-avkrasnov@salutedevices.com>

On Wed, Jan 24, 2024 at 10:32:55PM +0300, Arseniy Krasnov wrote:
>SOCK_SEQPACKET is supported for virtio transport, so do not interpret
>such type of socket as unknown.
>
>Signed-off-by: Arseniy Krasnov <avkrasnov@salutedevices.com>
>---
> tools/testing/vsock/vsock_diag_test.c | 2 ++
> 1 file changed, 2 insertions(+)

Yeah, LGTM!

Reviewed-by: Stefano Garzarella <sgarzare@redhat.com>

>
>diff --git a/tools/testing/vsock/vsock_diag_test.c b/tools/testing/vsock/vsock_diag_test.c
>index 5e6049226b77..17aeba7cbd14 100644
>--- a/tools/testing/vsock/vsock_diag_test.c
>+++ b/tools/testing/vsock/vsock_diag_test.c
>@@ -39,6 +39,8 @@ static const char *sock_type_str(int type)
> 		return "DGRAM";
> 	case SOCK_STREAM:
> 		return "STREAM";
>+	case SOCK_SEQPACKET:
>+		return "SEQPACKET";
> 	default:
> 		return "INVALID TYPE";
> 	}
>-- 
>2.25.1
>


