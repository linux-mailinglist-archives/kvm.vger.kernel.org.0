Return-Path: <kvm+bounces-35383-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 691D0A10849
	for <lists+kvm@lfdr.de>; Tue, 14 Jan 2025 15:01:16 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id D2D5A3A248B
	for <lists+kvm@lfdr.de>; Tue, 14 Jan 2025 14:01:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2382F5A4D5;
	Tue, 14 Jan 2025 14:01:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Ky1DFg8S"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 65291232444
	for <kvm@vger.kernel.org>; Tue, 14 Jan 2025 14:01:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736863269; cv=none; b=Yx1wyZrqvr426PA3d3zQDp5Rcw4KZ2OqSt3x+H1ZmUNRNdVU8NibepIGqnp/DFlRmhtWnbf0cFjhNwU71YBnVsm4pvzyyTVSpdnP0h/8qXdsUiJcrh9R5HgKUBXgHsFtxnl0hlBXn5c5AgItd7Srcu1kJkIXgxiq9brOiO5qVqc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736863269; c=relaxed/simple;
	bh=RO2+LMMSt9/CV9mfZLBX3GcG1XZ/JAvd+2+TOjJhBUc=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=gibrWIK1Rfu+j/X9c31aRofZUR4YBwT2byHXDzGSADBH1592jKkBAS5k91YKc5VdOh5rP35JUsiHeU4xHY/Mb6jaoJNmMxwh28xyYmU5EwlzjX9BatqZt+1dPyPNQyZPihFXmpoVF8J9z6FAotIDFCGSTbgN2hTGF9xTvhyjCKs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Ky1DFg8S; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1736863266;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=nlWleDUIMsS2jwvuNYiGOiFFuyxeQDHZ/qZSc7hmHcQ=;
	b=Ky1DFg8StsNp4E2plFmGUhVivvybRl9Xw9KDuJvw8q05QdyjId1wGWMsKf3wItiYcmi8nO
	lHVASmAfGO78KMHRk/rFDIFZ7qBFBLJWSKBGNlNVUQ87Rb8pRosKM1MW3Evq9jLJnHxU1E
	xqEiUzuWg0NtOY0icgaI71EEKmvMLs4=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-498-AA3KQRqcOAC0PS6MJ0YQ7g-1; Tue, 14 Jan 2025 09:01:05 -0500
X-MC-Unique: AA3KQRqcOAC0PS6MJ0YQ7g-1
X-Mimecast-MFC-AGG-ID: AA3KQRqcOAC0PS6MJ0YQ7g
Received: by mail-wr1-f70.google.com with SMTP id ffacd0b85a97d-385e03f54d0so2460368f8f.3
        for <kvm@vger.kernel.org>; Tue, 14 Jan 2025 06:01:04 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1736863264; x=1737468064;
        h=content-transfer-encoding:in-reply-to:organization:autocrypt
         :content-language:from:references:cc:to:subject:user-agent
         :mime-version:date:message-id:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=nlWleDUIMsS2jwvuNYiGOiFFuyxeQDHZ/qZSc7hmHcQ=;
        b=o5ZvXLhLp+0YX2HPqjEBE6SMwwHeWXwqu9A95iwcgGy7L06ZktRPjMecnfPy8nNXFg
         kTn7+IXbxiveHK7G0IOPYRfv82HGF6FzaxkQZ9D3YttPcQp1v0b4JdcSanSj1nIamRTk
         NLnvFTsSJepdfPc3M5tH+Qtu5QEqBC9gCRiM7Os9+5dpw0DOYk4pG/pKNPP79bRGrDiw
         T8OEVksRv1Auf6jSpr6n6fa5sa6A7HqqmGZOcdrXsuPOQOrS2np963s/wUA2AUpdCaDB
         WIeetWzhr+5PmKHw5Rl133eWDsavfjVGVXICwawX9+ndIHqE9wSTcqQBuMXQNKneOT98
         WEdg==
X-Forwarded-Encrypted: i=1; AJvYcCWxQ2LmU7abZsFCP9f2QwbFRLyTyuVwK4JlmJldmphZqU5T5PVM4oY0NCUP1T34eE8r0t8=@vger.kernel.org
X-Gm-Message-State: AOJu0YzC0ZAZb2AF4g+BacLQW+TOfCj586ZKIZEQFtewvii8yZjSOJA6
	2pbb4VWqL+Mxy+hfiZDbAiSZqFvgOrhjQ4vanKBRK7xI4JdCy3kvEAc90woWrr7ofDpimKnw0A5
	pKJTyf/Nb//AfgzMlrJWaoKu+msV0hlVQ29tNvtX3/x4ZVV6Cof51/Vdp1o+o
X-Gm-Gg: ASbGncusG8us5RnMQmn6UUAN6+dqYNvJxR5kKXp1xzyri8OC9myBl0692XyOyxjhoJ0
	yaU7k3L2A6s9y12bTWJbFVrV4qSzA4kB2d3q71bq+Vtv8FYH+PkA09Rp7fGlt8TGRO8gTVnkDqh
	IlAGwrs4TYxQobFp6R1M3342vU0t+iPYlmDhuvYja380fQfZLLDf9c272r8tzd8ngxRDv8c3aDk
	EZ9JtUT+/TD+ym8Adf6Kn+HWReEqbXrM3dp1R2RrUpQ5rcsReFb6Ovb79nhjuyebgttzrwmrQm2
	/o4lyh/8ka0SyFQLZ0gLz/4HIqBDtleC4tAomKnZxwJ2Ou9M/k7i1OLsbenytBwkFMm+GNDB6Vg
	5BBti4O4X
X-Received: by 2002:a5d:6c63:0:b0:385:f38e:c0c3 with SMTP id ffacd0b85a97d-38a872f6eb4mr19679299f8f.6.1736863263172;
        Tue, 14 Jan 2025 06:01:03 -0800 (PST)
X-Google-Smtp-Source: AGHT+IFxwFQMVUCHSGLQ9DgFsnAU/aUPIjw3iKv0pKkRJvNfQO83MKMVpbo6Eqxcny4Gp0x1sjvOPA==
X-Received: by 2002:a5d:6c63:0:b0:385:f38e:c0c3 with SMTP id ffacd0b85a97d-38a872f6eb4mr19679214f8f.6.1736863262417;
        Tue, 14 Jan 2025 06:01:02 -0800 (PST)
Received: from ?IPV6:2003:cb:c738:3100:8133:26cf:7877:94aa? (p200300cbc7383100813326cf787794aa.dip0.t-ipconnect.de. [2003:cb:c738:3100:8133:26cf:7877:94aa])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-38a9fcb7a11sm9419173f8f.75.2025.01.14.06.00.59
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 14 Jan 2025 06:01:01 -0800 (PST)
Message-ID: <dbdc0f83-5b5b-4104-b850-63c0a4ec795f@redhat.com>
Date: Tue, 14 Jan 2025 15:00:58 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 2/7] system/physmem: poisoned memory discard on reboot
To: William Roche <william.roche@oracle.com>, kvm@vger.kernel.org,
 qemu-devel@nongnu.org, qemu-arm@nongnu.org
Cc: peterx@redhat.com, pbonzini@redhat.com, richard.henderson@linaro.org,
 philmd@linaro.org, peter.maydell@linaro.org, mtosatti@redhat.com,
 imammedo@redhat.com, eduardo@habkost.net, marcel.apfelbaum@gmail.com,
 wangyanan55@huawei.com, zhao1.liu@intel.com, joao.m.martins@oracle.com
References: <cf587c8b-3894-4589-bfea-be5db70e81f3@redhat.com>
 <20241214134555.440097-1-william.roche@oracle.com>
 <20241214134555.440097-3-william.roche@oracle.com>
 <15d255c8-31fb-4155-83f0-bf294696621b@redhat.com>
 <9d1ed0f2-f87a-4330-bf5b-375e570a74e1@oracle.com>
From: David Hildenbrand <david@redhat.com>
Content-Language: en-US
Autocrypt: addr=david@redhat.com; keydata=
 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
 WNyWQQ==
Organization: Red Hat
In-Reply-To: <9d1ed0f2-f87a-4330-bf5b-375e570a74e1@oracle.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

> If we can get the current set of fixes integrated, I'll submit another
> fix proposal to take the fd_offset into account in a second time. (Not
> enlarging the current set)
> 
> But here is what I'm thinking about. That we can discuss later if you want:
> 
> @@ -3730,11 +3724,12 @@ int ram_block_discard_range(RAMBlock *rb,
> uint64_t start, size_t length)
>                }
> 
>                ret = fallocate(rb->fd, FALLOC_FL_PUNCH_HOLE |
> FALLOC_FL_KEEP_SIZE,
> -                            start, length);
> +                            start + rb->fd_offset, length);
>                if (ret) {
>                    ret = -errno;
>                    error_report("%s: Failed to fallocate %s:%" PRIx64 "
> +%zx (%d)",
> -                             __func__, rb->idstr, start, length, ret);
> +                             __func__, rb->idstr, start + rb->fd_offset,
> +                            length, ret);
>                    goto err;
>                }
> 
> 
> Or I can integrate that as an addition patch if you prefer.

Very good point! We missed to take fd_offset into account here.

Can you send that out as a separate fix?

Fixed: 4b870dc4d0c0 ("hostmem-file: add offset option")

-- 
Cheers,

David / dhildenb


