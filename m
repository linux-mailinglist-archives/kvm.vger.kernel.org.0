Return-Path: <kvm+bounces-19450-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 31B339054B7
	for <lists+kvm@lfdr.de>; Wed, 12 Jun 2024 16:04:43 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id B16FC1F223CE
	for <lists+kvm@lfdr.de>; Wed, 12 Jun 2024 14:04:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8B74817DE1E;
	Wed, 12 Jun 2024 14:04:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="U6LYRqwY"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DFACF17C221
	for <kvm@vger.kernel.org>; Wed, 12 Jun 2024 14:04:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718201069; cv=none; b=ZWX3+AHnjvhcPJF4fPJ2bljbDl3H7Ku0cDst61z/z1C6OvVh8bHZK5mIDTGubUiB1W/9fgcuUoY2UFwDYz+DqVUP5nSkpEZpfW4ovUjLuGunVTq9oFpZ9ZGTozAU+H2Do0sLl6dpMFi8dvYkch7omzkqyQ9kLUZsv/uH94bOA2o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718201069; c=relaxed/simple;
	bh=n6rQcdlTzLyq3J1ACt2i5X2K8jWLz6x7Pyg6vl9BQmw=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=jG+myaUG3MKRQcYxFmGCF6ARXt9v8ADqc41tpjYfsmtnJTpH9l0dJBSHuYDQWfMTV8pqDYdeuM7gpUa/ZNNee5rmvklEJx88YXu/eJQofLiuF6/OVy9SMakanRMSjBDLPsGeMD9zNUk/66migb1LaZ1UjAZlwBn169YLlQZu5qU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=U6LYRqwY; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1718201066;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=VHS87YElUOWkANf6E72nxalS03lPC9WT8JCafxHD7gY=;
	b=U6LYRqwYxyWLr04hHswdwO9ZRdR4ZPeKdGsOIvYw8tIjPgK9bZjFFfK7i2gXaqtGafnZzp
	9WAX8Z3i4FteN5dRfLxylxZFWhUeYyQZsr4LPB9n8UpOOdthccdFNryLL9/zwO405fyr6W
	AwDsj9uwkqTPSYjNdcPdD8Td5t4d2dM=
Received: from mail-qv1-f70.google.com (mail-qv1-f70.google.com
 [209.85.219.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-287-_NhRRhR9ObOufsA6rturtQ-1; Wed, 12 Jun 2024 10:04:23 -0400
X-MC-Unique: _NhRRhR9ObOufsA6rturtQ-1
Received: by mail-qv1-f70.google.com with SMTP id 6a1803df08f44-6b06ce632b3so23454756d6.3
        for <kvm@vger.kernel.org>; Wed, 12 Jun 2024 07:04:23 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1718201063; x=1718805863;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=VHS87YElUOWkANf6E72nxalS03lPC9WT8JCafxHD7gY=;
        b=VaXPbLw5VxMTMP/+u9w0Rr9C6Q+f8q+4CXenofWhaEuQDK4ybIsItJFXSQNDy5RgIB
         qZTxHLNJ/+sbWypSJYLcui913zfXZpd0LkZw72S+dDJQiyUV+eXuMc9/COrsq46Tqtk+
         ms3y2xGlTyKFMY0r27zmyOcbBbOmLeFwQqZfT3VwJmT+7EE2Kj6Mg48knJVRbV/xX0m6
         sA3dq8MezZuojyBhF4NnJcKR/8XyNSUmUfkRbDHddAJ9aUTyVLNUWAsQyT/pyCjHvl1D
         ux3Ld3s8AYbk7wIqfTcZHpqaqrpWqjwLONIv7i5GKl4wXBEOv1XhiM+6oB2NzV0QINf6
         Cmvw==
X-Forwarded-Encrypted: i=1; AJvYcCW4GucGDrxeIF55DooDLrLQG7+epRQ+9oJV1Gv0gAW79s1RzAf3HF57W49/2HwNAqouN0NmkrTSFbbUDDG4W6ACm0k/
X-Gm-Message-State: AOJu0YyHW2A9bF56gxL4ezWCpN6aQNtXB3iMVLteK9o++nqCJfSnuQmD
	CeBdWq3hvMvP7wZzx4Wy3BRHY17fkSHedfkY5joXDuTex4oacbz2nmbbshTsZYg+19Gr6nyBYn7
	RJ8SYGyHU+iTWKTaDlZGbB8Qzpm9fO1OQNol+08XQ/lUNIY26nw==
X-Received: by 2002:a05:6214:2b90:b0:6b0:7821:4026 with SMTP id 6a1803df08f44-6b1a6c57871mr20407266d6.52.1718201062945;
        Wed, 12 Jun 2024 07:04:22 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHis29s85ghN1wCvWNHSB3z3fEhPObl0T66oMycOn7F9OWRQIQYakS2Z/8aehOyVDRyZ6GOEQ==
X-Received: by 2002:a05:6214:2b90:b0:6b0:7821:4026 with SMTP id 6a1803df08f44-6b1a6c57871mr20406306d6.52.1718201062563;
        Wed, 12 Jun 2024 07:04:22 -0700 (PDT)
Received: from [192.168.0.4] (ip-109-43-176-68.web.vodafone.de. [109.43.176.68])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-6b2a1515903sm958436d6.58.2024.06.12.07.04.18
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 12 Jun 2024 07:04:22 -0700 (PDT)
Message-ID: <6086ef5e-48e7-40f3-b0a7-ff67b20aeae3@redhat.com>
Date: Wed, 12 Jun 2024 16:04:15 +0200
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/1] s390/virtio_ccw: fix config change notifications
To: Halil Pasic <pasic@linux.ibm.com>, Cornelia Huck <cohuck@redhat.com>,
 Eric Farman <farman@linux.ibm.com>, Heiko Carstens <hca@linux.ibm.com>,
 Vasily Gorbik <gor@linux.ibm.com>, Alexander Gordeev
 <agordeev@linux.ibm.com>, Christian Borntraeger <borntraeger@linux.ibm.com>,
 Sven Schnelle <svens@linux.ibm.com>, linux-s390@vger.kernel.org,
 virtualization@lists.linux.dev, kvm@vger.kernel.org,
 linux-kernel@vger.kernel.org
Cc: Boqiao Fu <bfu@redhat.com>, Sebastian Mitterle <smitterl@redhat.com>
References: <20240611214716.1002781-1-pasic@linux.ibm.com>
From: Thomas Huth <thuth@redhat.com>
Content-Language: en-US
Autocrypt: addr=thuth@redhat.com; keydata=
 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
In-Reply-To: <20240611214716.1002781-1-pasic@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 11/06/2024 23.47, Halil Pasic wrote:
> Commit e3e9bda38e6d ("s390/virtio_ccw: use DMA handle from DMA API")
> broke configuration change notifications for virtio-ccw by putting the
> DMA address of *indicatorp directly into ccw->cda disregarding the fact
> that if !!(vcdev->is_thinint) then the function
> virtio_ccw_register_adapter_ind() will overwrite that ccw->cda value
> with the address of the virtio_thinint_area so it can actually set up
> the adapter interrupts via CCW_CMD_SET_IND_ADAPTER.  Thus we end up
> pointing to the wrong object for both CCW_CMD_SET_IND if setting up the
> adapter interrupts fails, and for CCW_CMD_SET_CONF_IND regardless
> whether it succeeds or fails.
> 
> To fix this, let us save away the dma address of *indicatorp in a local
> variable, and copy it to ccw->cda after the "vcdev->is_thinint" branch.
> 
> Reported-by: Boqiao Fu <bfu@redhat.com>
> Reported-by: Sebastian Mitterle <smitterl@redhat.com>
> Fixes: e3e9bda38e6d ("s390/virtio_ccw: use DMA handle from DMA API")
> Signed-off-by: Halil Pasic <pasic@linux.ibm.com>
> ---
> I know that checkpatch.pl complains about a missing 'Closes' tag.
> Unfortunately I don't have an appropriate URL at hand. @Sebastian,
> @Boqiao: do you have any suggetions?

Closes: https://issues.redhat.com/browse/RHEL-39983
?

Anyway, I've tested the patch and it indeed fixes the problem with 
virtio-balloon and the link state for me:

Tested-by: Thomas Huth <thuth@redhat.com>


