Return-Path: <kvm+bounces-58433-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [142.0.200.124])
	by mail.lfdr.de (Postfix) with ESMTPS id 0D56DB93C04
	for <lists+kvm@lfdr.de>; Tue, 23 Sep 2025 02:51:48 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id CCBFC4E1735
	for <lists+kvm@lfdr.de>; Tue, 23 Sep 2025 00:51:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D57C41A9FB5;
	Tue, 23 Sep 2025 00:51:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="O83h0cuA"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6381C156C6A
	for <kvm@vger.kernel.org>; Tue, 23 Sep 2025 00:51:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758588701; cv=none; b=GGade9+n/H/m/HYigimpPVaajDhAwxW4tAcjLUyonZ6ZHCkukn6x8HU2eeYX4mVqOSKMCYMjlH7T1tlKg9z/yJ4niHq6CmoQMsDqeqT0Q+zLc5AFNk39h6h3Tp1wla0/sx3YQDBBL9wFfyVNMSqDr6Pk1zN1p44gcMhrgDCHz1c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758588701; c=relaxed/simple;
	bh=dLhm4LgNhR5mdQZSmBFvKzdtUHvA2mS6/XQxGDbK3Fk=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=dpzcf+NKCn6+YwP+YCG1T/rTTvKVZxDS54PkLMbgxkXW6IAQUOa+Fs32txuCHN0/T2IRkxTJov4BiuYOeEZ9tSFLXnlFF/2e4TQwDwmYjprRMswwbJO41JYfXh3FmTkuLYUVkgSdtcoAp/lJGrgIZro6TF+J2MT16K91Ke/M32k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=O83h0cuA; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1758588697;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=H5iTHO8SAQmP6KeYsXAWuHLqRvS2XzjaWtgcdw6rXFw=;
	b=O83h0cuAvF8QDNkFm5YkLrvvU5eJSi5XKUoH7cv9dx3RTh3XWe6XE7nACP97prp8nJ/3Hu
	B4ZzvxjL07b7dPdUVT0b4mtjmJPM+sAo0xqgjNezbujKgvQFct+XMt/ErKXlrviCJGwLM6
	MAcnL8ow3FyBNgf2k9evXnDtJJJU118=
Received: from mail-qv1-f72.google.com (mail-qv1-f72.google.com
 [209.85.219.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-39-6Jg4696CM6CVP7pvYeH9nQ-1; Mon, 22 Sep 2025 20:51:35 -0400
X-MC-Unique: 6Jg4696CM6CVP7pvYeH9nQ-1
X-Mimecast-MFC-AGG-ID: 6Jg4696CM6CVP7pvYeH9nQ_1758588695
Received: by mail-qv1-f72.google.com with SMTP id 6a1803df08f44-7bb414430c2so37773026d6.0
        for <kvm@vger.kernel.org>; Mon, 22 Sep 2025 17:51:35 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758588695; x=1759193495;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=H5iTHO8SAQmP6KeYsXAWuHLqRvS2XzjaWtgcdw6rXFw=;
        b=fPty0LiX6VdqXjCrfy5acEZ0P+lsrwEcNkfuy8awnobtfdbwj9yIVMcgLLZvnSmHgX
         xcXy6WQXoRJJxUqkerXdTEnC6RWjxqCDTAULhL9WVTIEz7vFfxAD9CsFciMvKB/yxHL4
         gTZgoBoMFJgr0DPlSevmwQ+geiIVkqb6nwiEQPt3/zBMjlAMAY2olR65ilk5rdL3kAFc
         0ULnO7uCxrjvC7a5hiDukP+nqbAXtSQjKCCoT/N08fCq+XqdPs5fYTk1dOFaBvxkdBaj
         4pmyn2/yau5ZI5XOo8ddz+MXC8DFuAposrzV+LlHPkqAjqNTLe22aKX8D/h1wmGSpBh9
         pc+Q==
X-Forwarded-Encrypted: i=1; AJvYcCUGafb81cFehnUVQk8BJ6X5VIWm1J8n+0jmIQfiqg9j0A45kd6/U4w1gE8vY5SpvSS6jOI=@vger.kernel.org
X-Gm-Message-State: AOJu0YyPH8EUNpm7rCcjLDDt/VLBF6hK975f+XSZO+R3Dac8lMH/9MWH
	NLBjkuYxp2RvxL63oaQHZznLI7LnKX8+/zLZlGsYVxyG68Chf7mh+N9iK5FpwYkGc1Wzhjw3P9E
	1OBZmfgFK/0qYvK8BRkLKj7k16JyMgVYtLSuAEcvggfByPTYRwDO9LQ==
X-Gm-Gg: ASbGncu1KJZCd9In2QxlAjulkcBE46eDB/xKL27fyC5VXtSkuIYuypFfmg+vtsnXyUP
	YQmf6WTeyBlmEv+7T4rcFGeE/B4f0JcmRrnzq8PfdbB79POwcLGjqPn86JtrG1IY5PXcYyvyzDd
	uL72N78hclYCEPWW05y3jO3K6d4kKxNOn4iiVgor1QVaeV718/iRaoUc2AFUKxP/SCgKfOow5t/
	6BvPbwOWbFhWFlUzO+DUUqnwtW5MSFhbdcoXmAolc2q2BSBX3CFy49Mp+Pgthz9eF4Sn8CwbOab
	fYpS2Csv6ZVcHzMk9CGn3kiIOvMrRkFyAQN/Hbns
X-Received: by 2002:a05:6214:240f:b0:70d:cef4:ea42 with SMTP id 6a1803df08f44-7e7a024aaa5mr8493756d6.1.1758588695279;
        Mon, 22 Sep 2025 17:51:35 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGtQ843uNCITnUkv1WbfVZrcAx/pYKTrBIqD6TgGbEMGluu0dapZ4MeWMUHT2U8u/TdPFwWnQ==
X-Received: by 2002:a05:6214:240f:b0:70d:cef4:ea42 with SMTP id 6a1803df08f44-7e7a024aaa5mr8493506d6.1.1758588694720;
        Mon, 22 Sep 2025 17:51:34 -0700 (PDT)
Received: from [192.168.40.164] ([70.105.235.240])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-79351b9de18sm82855666d6.48.2025.09.22.17.51.32
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 22 Sep 2025 17:51:34 -0700 (PDT)
Message-ID: <1845b412-e96d-438a-8c05-680ef70c04e6@redhat.com>
Date: Mon, 22 Sep 2025 20:51:31 -0400
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 03/11] iommu: Compute iommu_groups properly for PCIe
 switches
Content-Language: en-US
To: Jason Gunthorpe <jgg@nvidia.com>,
 Alex Williamson <alex.williamson@redhat.com>
Cc: Bjorn Helgaas <bhelgaas@google.com>, iommu@lists.linux.dev,
 Joerg Roedel <joro@8bytes.org>, linux-pci@vger.kernel.org,
 Robin Murphy <robin.murphy@arm.com>, Will Deacon <will@kernel.org>,
 Lu Baolu <baolu.lu@linux.intel.com>, galshalom@nvidia.com,
 Joerg Roedel <jroedel@suse.de>, Kevin Tian <kevin.tian@intel.com>,
 kvm@vger.kernel.org, maorg@nvidia.com, patches@lists.linux.dev,
 tdave@nvidia.com, Tony Zhu <tony.zhu@intel.com>
References: <0-v1-74184c5043c6+195-pcie_switch_groups_jgg@nvidia.com>
 <3-v1-74184c5043c6+195-pcie_switch_groups_jgg@nvidia.com>
 <20250701132905.67d29191.alex.williamson@redhat.com>
 <20250702010407.GB1051729@nvidia.com>
 <c05104a1-7c8e-4ce9-bfa3-bcbc8c9e0ef5@redhat.com>
 <20250717202744.GA2250220@nvidia.com>
 <2cb00715-bfa8-427a-a785-fa36667f91f9@redhat.com>
 <20250718133259.GD2250220@nvidia.com>
 <20250922163200.14025a41.alex.williamson@redhat.com>
 <20250922231541.GF1391379@nvidia.com>
From: Donald Dutile <ddutile@redhat.com>
In-Reply-To: <20250922231541.GF1391379@nvidia.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 9/22/25 7:15 PM, Jason Gunthorpe wrote:
> On Mon, Sep 22, 2025 at 04:32:00PM -0600, Alex Williamson wrote:
>> The ACS capability was only introduced in PCIe 2.0 and vendors have
>> only become more diligent about implementing it as it's become
>> important for device isolation and assignment.
PCIe-2.0 spec-wise, was released in 2007, 18 years ago.
If hw is on a 3-yr lifecycle, that's 6 generations (7th including this year releases, assuming
gen-1 was 2007); assuming a 5yr hw cycle, that's 4 generations of hardware.

Maybe a more interesting date is when DC servers implemented device-assignment/SRIOV
in full-scale, and then, determine number of hw generations from that point on as
'learning -> devel-changing' years.
I recall we had in in 'enterprise' customers in 2010, which only shaves one generation
from above counts.

> 
> IDK about this, I have very new systems and they still not have ACS
> flags according to this interpretation.
> 
>> IMO, we can't assume anything at all about a multifunction device
>> that does not implement ACS.
> 
> Yeah this is all true.
> 
> But we are already assuming. Today we assume MFDs without caps must
> have internal loopback in some cases, and then in other cases we
> assume they don't.
> 
> I've sent and people have tested various different rules - please tell
> me what you can live with.
> 
> Assuming the MFD does not have internal loopback, while not entirely
> satisfactory, is the one that gives the least practical breakage.
> 
> I think it most accurately reflects the majority of real hardware out
> there.
> 
> We can quirk to fix the remainder.
> 
> This is the best plan I've got..
> 
> Jason
> 

+1 to Jason's conclusions.
We should design the quirk hook to add ACS hooks for MFDs that do
not adhere to the spec., which should be the minority, and that's what
quirks are suppose to handle -- the odd cases.

- Don


