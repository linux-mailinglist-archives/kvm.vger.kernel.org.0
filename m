Return-Path: <kvm+bounces-33175-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 1AE009E5FE6
	for <lists+kvm@lfdr.de>; Thu,  5 Dec 2024 22:19:06 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 9CB741883FBA
	for <lists+kvm@lfdr.de>; Thu,  5 Dec 2024 21:19:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8AEE91BE23F;
	Thu,  5 Dec 2024 21:19:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="UPbRATbH"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA877192D69
	for <kvm@vger.kernel.org>; Thu,  5 Dec 2024 21:18:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733433539; cv=none; b=KZ0IXFR//vt1635BttOdv7SAt5RRTxF/Aoyqyw2xjMMSl1oaVEogsbauk3z71cBeI4FNVi1JAQiQQ8t4i/zmTsO/hUH9bvfBr7coTp+ciIHMJwIEC3XCeEHg/CjAUwFsw9Q4KVB32wA61NlFMj6AzDbEUenLBCe8j08SXadYl8s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733433539; c=relaxed/simple;
	bh=6BPlJ1Ho9QjWuTsnQ5IJACnbSj62sQk7t/+7YZiQFW0=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=IHtnHoZQM2xJed8U7bwM1SQt6GXKm9i8OLlc6hvFdl8CxDDIBU34UQJjl2vMGlB59PEi5ihttKzmdUjaTRel1zQKcoHZdIRO8xM8cJN+8a8BTTMnKPN+SOu+PddNHUZsLWwKu2jm1ncIENFwqtQSB4AMG0BBidvksNHt1kwSDrw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=UPbRATbH; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1733433536;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=YuHocZ2AjX4ZPj8HvuL3uJe2ZidedyMiwQ16Kht0i8k=;
	b=UPbRATbH8p4clUPaq0GWhJNDAnKDPqKzrdv13L9idSEqYERdvYGQkDd5e16jCOvN8zNHcQ
	mc9oJ6n+w3i5S8ANRW0r2J1P8w8cb5maAve/gwj7y89cIF0HMI26Tq8SWj6b68BmqeMb4u
	dGX1gpeC7dW5eFOECRdN3rzvx4ss40c=
Received: from mail-io1-f72.google.com (mail-io1-f72.google.com
 [209.85.166.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-578-DDv_sRnFMde9cXJ15ncVNQ-1; Thu, 05 Dec 2024 16:18:55 -0500
X-MC-Unique: DDv_sRnFMde9cXJ15ncVNQ-1
X-Mimecast-MFC-AGG-ID: DDv_sRnFMde9cXJ15ncVNQ
Received: by mail-io1-f72.google.com with SMTP id ca18e2360f4ac-841a8731ca2so11275139f.1
        for <kvm@vger.kernel.org>; Thu, 05 Dec 2024 13:18:55 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1733433534; x=1734038334;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=YuHocZ2AjX4ZPj8HvuL3uJe2ZidedyMiwQ16Kht0i8k=;
        b=UN6ynqV+R821YOFqHBYBeGiP9yFvtOtTm+1z0goskeU5rp61AsHgx2tPMRTPpqheca
         CmIUK/kdnSyaBs5zVIvwBNCAchCJDqDS9Fxo9IIQILubzG99bavvjXfR1MV34o307bv9
         Y5i6HK01QtuhhrKxX/hBRuesLjNmtkzDMfHori67dBAHnvu5+80CLRTrmVjy54KYR6p0
         J1xb75h7wLdAqg1h9pMl+G0FlvI9HwihbGzhIVc05p9j6bgBjwvLy7FzB5cEZl1dXW3D
         nowXKwzmrv5oMS2q36Qxw7UgOSn10VR728/5iH8W/rUpsg6q8C7Pmmqw4f5bc0oE7FhY
         c9IA==
X-Forwarded-Encrypted: i=1; AJvYcCVrRwH969TVgRp+tFktVDN3d77R1f/E3yyk1GXu98Vbd2RNx/mWe6p4zzqUHVU5UcLZ72U=@vger.kernel.org
X-Gm-Message-State: AOJu0YwtqJtMdKo9c8K02p2C04ns+OFO2y6qKLOpVLUOvFR3JZLHHequ
	QkUQLyx5C/bHtbCB7k23jies9JxRyUH7V5lEnYaK4kl6vVu6Je+9xGKvH4R6d54sm/wDOkCnJda
	Wx9fP+G8+akBcEjYQ+vimSHZqzAmYa0EAtsw4UmFMaWnms17d2A==
X-Gm-Gg: ASbGnct8q/7HK5nqMARQgeO7EhBK4qRKccdxjMqjEPqHsALX3HkfF9H3+vDyWOhdrf9
	VGnyuGaqLQoFlhRjZKguCbjdBjrqets0jOIyPJWH2nxYrl1ULSTJuVL43GOKZE82x6E4cKM3Le6
	//isUHqMJM3nf4r+UNnYThIMttccEDzlzemgTOngTBi4yK6YW49CMRPZJnoa6qtWMK2bbERyqI0
	L4i3SjpKmHvArXXxMNEVlQ3nJq/dFUjwAnRgY7ozzUR44U5xaS1dw==
X-Received: by 2002:a05:6e02:1a69:b0:3a7:bcfb:356 with SMTP id e9e14a558f8ab-3a811e19d11mr2963405ab.4.1733433534719;
        Thu, 05 Dec 2024 13:18:54 -0800 (PST)
X-Google-Smtp-Source: AGHT+IGbRPp2CYWRTV6Hc+87T8g1Y5TD2rMpdgF3yVh+3C2q4R86wGrGcw08XlUmzIhT5r0R56aJHA==
X-Received: by 2002:a05:6e02:1a69:b0:3a7:bcfb:356 with SMTP id e9e14a558f8ab-3a811e19d11mr2963305ab.4.1733433534433;
        Thu, 05 Dec 2024 13:18:54 -0800 (PST)
Received: from redhat.com ([38.15.36.11])
        by smtp.gmail.com with ESMTPSA id e9e14a558f8ab-3a808e2bbe7sm6456885ab.78.2024.12.05.13.18.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 05 Dec 2024 13:18:53 -0800 (PST)
Date: Thu, 5 Dec 2024 14:18:52 -0700
From: Alex Williamson <alex.williamson@redhat.com>
To: Yishai Hadas <yishaih@nvidia.com>
Cc: <jgg@nvidia.com>, <kvm@vger.kernel.org>, <kevin.tian@intel.com>,
 <joao.m.martins@oracle.com>, <maorg@nvidia.com>, <galshalom@nvidia.com>,
 <clg@redhat.com>, <yicui@redhat.com>
Subject: Re: [PATCH V1] vfio/mlx5: Align the page tracking max message size
 with the device capability
Message-ID: <20241205141852.27ba8105.alex.williamson@redhat.com>
In-Reply-To: <20241205122654.235619-1-yishaih@nvidia.com>
References: <20241205122654.235619-1-yishaih@nvidia.com>
X-Mailer: Claws Mail 4.3.0 (GTK 3.24.43; x86_64-redhat-linux-gnu)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On Thu, 5 Dec 2024 14:26:54 +0200
Yishai Hadas <yishaih@nvidia.com> wrote:

> Align the page tracking maximum message size with the device's
> capability instead of relying on PAGE_SIZE.
>=20
> This adjustment resolves a mismatch on systems where PAGE_SIZE is 64K,
> but the firmware only supports a maximum message size of 4K.
>=20
> Now that we rely on the device's capability for max_message_size, we
> must account for potential future increases in its value.
>=20
> Key considerations include:
> - Supporting message sizes that exceed a single system page (e.g., an 8K
>   message on a 4K system).
> - Ensuring the RQ size is adjusted to accommodate at least 4
>   WQEs/messages, in line with the device specification.
>=20
> The above has been addressed as part of the patch.
>=20
> Fixes: 79c3cf279926 ("vfio/mlx5: Init QP based resources for dirty tracki=
ng")
> Reviewed-by: C=C3=A9dric Le Goater <clg@redhat.com>
> Tested-by: Yingshun Cui <yicui@redhat.com>
> Signed-off-by: Yishai Hadas <yishaih@nvidia.com>
> ---
> Changes from V0:
> https://lore.kernel.org/kvm/20241125113249.155127-1-yishaih@nvidia.com/T/
>=20
> - Rename 'page_start' to 'kaddr' as was suggested by C=C3=A9dric.
> - Add the Tested-by and Reviewed-by clauses.
>=20
>  drivers/vfio/pci/mlx5/cmd.c | 47 +++++++++++++++++++++++++++----------
>  1 file changed, 35 insertions(+), 12 deletions(-)

Applied to vfio for-linus branch for v6.13-rc.  Thanks,

Alex


