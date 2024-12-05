Return-Path: <kvm+bounces-33117-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 2848E9E502B
	for <lists+kvm@lfdr.de>; Thu,  5 Dec 2024 09:47:39 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id B8D06168AD7
	for <lists+kvm@lfdr.de>; Thu,  5 Dec 2024 08:47:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 133C51E519;
	Thu,  5 Dec 2024 08:46:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="EKt9+DaE"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D22CE1D5162
	for <kvm@vger.kernel.org>; Thu,  5 Dec 2024 08:46:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733388370; cv=none; b=N0sTGyGmYCMMjJj15Hll0kZsPqXHP/Gz0z1CkwlwjEYh2fownmWb9g8k7xAqN0bC41w8KGhQm3vkVlZiys2ZwpBJyVk/uvTIzUE2USEtU7dCgaoK96CkZcAq2xj+k1IZsTTH3/eZeMb/1PfqoRBFcfeUvlr4RqaResO/7AAQqOQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733388370; c=relaxed/simple;
	bh=leTbGIdH+wwneN12mrITrjyKrdX4sBUGCwftvPjwa4g=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=J+hGlYkKfKdBGCoNuT3rJyLHtqBS2aMmJ0du+HyB/vpsijO5IEZqMoR3mg8D25vFmQ/bGthD2ecx+L2q0rwK/yTcq+EhfEzE4FEB/t5tKeXGgfHDJXqUqiHe0ZTO1Kc0Xp5r8QHEFAUHrwNwh+Sjixn4PWzF+pH23ZaeXbKhjtw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=EKt9+DaE; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1733388364;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=ElxufMeo4oGQJH0o1ayi7s1CXncUB7NTIG7/pITrC34=;
	b=EKt9+DaEBII7I0G1U0TXrP/SzbBVBYKsjpRx02iztcgLxLATz/vBPcLhEKkMrqtpY70fuw
	2zd2DUF4qfxMj3Iir+H36jlfGB5/6NPw3RfEjA2Fr4kUqVfKI5iaJJtVEMb+5wNY1Tr5to
	xfTIgqhNkOZ1K+jEpyes3Fj58bkLvBk=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-685-mR48fgA4MXapUVoJjNdgIQ-1; Thu, 05 Dec 2024 03:46:03 -0500
X-MC-Unique: mR48fgA4MXapUVoJjNdgIQ-1
X-Mimecast-MFC-AGG-ID: mR48fgA4MXapUVoJjNdgIQ
Received: by mail-wm1-f72.google.com with SMTP id 5b1f17b1804b1-4349cbf726cso3778085e9.3
        for <kvm@vger.kernel.org>; Thu, 05 Dec 2024 00:46:03 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1733388362; x=1733993162;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ElxufMeo4oGQJH0o1ayi7s1CXncUB7NTIG7/pITrC34=;
        b=lP4C2q6mgoCeZQ32SsuuPfpF6Jfb52qWxdYle6uS9D3ExHKRCTotnvYfLoLna0HUDO
         Sx6QcuvW08MKlCTCemQd/k8799OMA2wspT6fN9xufQxewl7XIbfXnIqkWBGvjbHdNPH1
         UUiSiExbfj72clT0+W2Tex/m5ywCsOvZKJR3y8unhS35VXkwpA1SXBu0PBnlpw0ailuh
         VtkrHXY0fzS9ik+khNUsBJR5oV826A3fGgnXfSDs4NVlcq0E+xOJ+4iEijlZjrDheZgP
         ELzMzVwLukiCVpu/ykiWyjH2YBbRBOBrLuryKnMaj/qx+ahsGpwInPoX49mnbIxPgYYL
         INFw==
X-Gm-Message-State: AOJu0YxOWWO1lDmLHw5o3IvKoeucL07XqbhXLpATrkPaWdrE9ENmWTzT
	1MXqpw+6K7VG1W8+kNBqG6ashM7ob1sYWL3N7hWnd5Lugnoum4PEqY3eXt3xi5ZdggCsoGpKvgH
	kz22IWrOWDMG+oEc0q5TryMOZkW9XhtxY7ysGYwe0qzBknWlIQQ==
X-Gm-Gg: ASbGncskGGlGDYNzQyghSTeFR7TlmriV4lD0m3BQ/Xir4YqDGQDygQJTr2DN2QXfWln
	wRMor5jUNf3yd7c2cQdQJi3ZJvZ05PDDFnxN2cRgpJvIpjNjxN5/ycAXdpD4G+BWjgzxxTSdk/M
	6y0qInflMTZP8NzJEnjSSxoOXHds6+JwSFtcv3Jl9wp9lBxPFwUxMOrC7ZvfxCoJe2koV88BdS5
	RywffTMQfyzQ88yGTxTuf5R+yzgKBAmTX+a4mBfRMU+q+eKvF1bJaampPYi0N2kFwjHPttiQWkr
	eIGeCkKEdU/I
X-Received: by 2002:a05:600c:46cd:b0:434:882c:f746 with SMTP id 5b1f17b1804b1-434d09c8e42mr89561485e9.17.1733388362298;
        Thu, 05 Dec 2024 00:46:02 -0800 (PST)
X-Google-Smtp-Source: AGHT+IE5ie7QEoQDHLZ687t5kACegS3GqMXnolUmMajHP800XM2ilJQnis7RGnIZ1JSs6XS9vKfOCA==
X-Received: by 2002:a05:600c:46cd:b0:434:882c:f746 with SMTP id 5b1f17b1804b1-434d09c8e42mr89561275e9.17.1733388361968;
        Thu, 05 Dec 2024 00:46:01 -0800 (PST)
Received: from ?IPV6:2a01:e0a:280:24f0:9db0:474c:ff43:9f5c? ([2a01:e0a:280:24f0:9db0:474c:ff43:9f5c])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-434da0d2698sm16109025e9.8.2024.12.05.00.46.01
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 05 Dec 2024 00:46:01 -0800 (PST)
Message-ID: <42e4cc64-89be-4f6f-b698-c7e94f0cf6e0@redhat.com>
Date: Thu, 5 Dec 2024 09:46:00 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] vfio/mlx5: Align the page tracking max message size with
 the device capability
To: Yishai Hadas <yishaih@nvidia.com>, alex.williamson@redhat.com,
 jgg@nvidia.com
Cc: kvm@vger.kernel.org, kevin.tian@intel.com, joao.m.martins@oracle.com,
 maorg@nvidia.com, galshalom@nvidia.com
References: <20241125113249.155127-1-yishaih@nvidia.com>
 <c69d6fc7-ab18-48f5-9e23-e0f947f8840e@redhat.com>
 <48068205-1fd9-4e5d-bb45-b13043d9f198@nvidia.com>
Content-Language: en-US, fr
From: =?UTF-8?Q?C=C3=A9dric_Le_Goater?= <clg@redhat.com>
Autocrypt: addr=clg@redhat.com; keydata=
 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
 uVKe8BVz4atMOoktmt0GWTOC8P4=
In-Reply-To: <48068205-1fd9-4e5d-bb45-b13043d9f198@nvidia.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 12/3/24 17:14, Yishai Hadas wrote:
> On 03/12/2024 17:07, Cédric Le Goater wrote:
>> Hello Yishai,
>>
>> On 11/25/24 12:32, Yishai Hadas wrote:
>>> Align the page tracking maximum message size with the device's
>>> capability instead of relying on PAGE_SIZE.
>>>
>>> This adjustment resolves a mismatch on systems where PAGE_SIZE is 64K,
>>> but the firmware only supports a maximum message size of 4K.
>>>
>>> Now that we rely on the device's capability for max_message_size, we
>>> must account for potential future increases in its value.
>>>
>>> Key considerations include:
>>> - Supporting message sizes that exceed a single system page (e.g., an 8K
>>>    message on a 4K system).
>>> - Ensuring the RQ size is adjusted to accommodate at least 4
>>>    WQEs/messages, in line with the device specification.
>>
>> Perhaps theses changes deserve two separate patches ?
> 
> I had considered that as well at some point.
> 
> However, once we transitioned to use the firmware maximum message size capability, the code needed to be prepared for any future change to that value. Failing to do so, could result in a broken patch.
> 
> Since this is a Fixes patch, I believe it’s better to provide a single functional patch rather than splitting it into two.
> 
>>
>>>
>>> The above has been addressed as part of the patch.
>>>
>>> Fixes: 79c3cf279926 ("vfio/mlx5: Init QP based resources for dirty tracking")
>>> Signed-off-by: Yishai Hadas <yishaih@nvidia.com>
>>> ---
>>>   drivers/vfio/pci/mlx5/cmd.c | 47 +++++++++++++++++++++++++++----------
>>>   1 file changed, 35 insertions(+), 12 deletions(-)
>>>
>>> diff --git a/drivers/vfio/pci/mlx5/cmd.c b/drivers/vfio/pci/mlx5/cmd.c
>>> index 7527e277c898..a61d303d9b6a 100644
>>> --- a/drivers/vfio/pci/mlx5/cmd.c
>>> +++ b/drivers/vfio/pci/mlx5/cmd.c
>>> @@ -1517,7 +1517,8 @@ int mlx5vf_start_page_tracker(struct vfio_device *vdev,
>>>       struct mlx5_vhca_qp *host_qp;
>>>       struct mlx5_vhca_qp *fw_qp;
>>>       struct mlx5_core_dev *mdev;
>>> -    u32 max_msg_size = PAGE_SIZE;
>>> +    u32 log_max_msg_size;
>>> +    u32 max_msg_size;
>>>       u64 rq_size = SZ_2M;
>>>       u32 max_recv_wr;
>>>       int err;
>>> @@ -1534,6 +1535,12 @@ int mlx5vf_start_page_tracker(struct vfio_device *vdev,
>>>       }
>>>       mdev = mvdev->mdev;
>>> +    log_max_msg_size = MLX5_CAP_ADV_VIRTUALIZATION(mdev, pg_track_log_max_msg_size);
>>> +    max_msg_size = (1ULL << log_max_msg_size);
>>> +    /* The RQ must hold at least 4 WQEs/messages for successful QP creation */
>>> +    if (rq_size < 4 * max_msg_size)
>>> +        rq_size = 4 * max_msg_size;
>>> +
>>>       memset(tracker, 0, sizeof(*tracker));
>>>       tracker->uar = mlx5_get_uars_page(mdev);
>>>       if (IS_ERR(tracker->uar)) {
>>> @@ -1623,25 +1630,41 @@ set_report_output(u32 size, int index, struct mlx5_vhca_qp *qp,
>>>   {
>>>       u32 entry_size = MLX5_ST_SZ_BYTES(page_track_report_entry);
>>>       u32 nent = size / entry_size;
>>> +    u32 nent_in_page;
>>> +    u32 nent_to_set;
>>>       struct page *page;
>>> +    void *page_start;
>>
>> A variable name of 'kaddr' would reflect better that this is a mapping.
> 
> OK, I'll rename as part of V1.
> 
>>
>>> +    u32 page_offset;
>>> +    u32 page_index;
>>> +    u32 buf_offset;
>>
>> I would move these declarations below under the 'do {} while' loop
> 
> We could consider moving most of the variables inside the do { } while block. However, since the majority of the function's body is already within the do { } while, it seems reasonable and cleaner to declare all the variables together at the start of the function.
> 
>> A part from that, it looks good.
> 
> Thanks for your review.
> 
>>
>> I haven't seen any issues on x86 and I have asked QE to test with
>> a 64k kernel on ARM
> 
> Could you please update once the test is completed successfully on the 64K system ?
> 
> After that, I'll send out V1 and include the tested-by clause with the name you'll provide.

Yingshun just did.

You can add :

Reviewed-by: Cédric Le Goater <clg@redhat.com>

Thanks,

C.




