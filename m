Return-Path: <kvm+bounces-57133-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 4E23BB506A1
	for <lists+kvm@lfdr.de>; Tue,  9 Sep 2025 21:56:05 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 5D0E37B46A4
	for <lists+kvm@lfdr.de>; Tue,  9 Sep 2025 19:54:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 03C5F340D9D;
	Tue,  9 Sep 2025 19:55:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="N8BUWrtY"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 91A4F30506E
	for <kvm@vger.kernel.org>; Tue,  9 Sep 2025 19:55:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757447751; cv=none; b=dgGPcsv7pwi3lKLYyf0E7ls9DeIQCXxqIdq/nZFAtUF+8dxyEwP5/lY/mUoUzDpLsDSzBX9hGlrqUm1u/1a1RtU+cnvIliyvAwOGjGBcKeSzQV0knLtDDT1KvON0rm7RlpsTmIPLgZ3zaYRN5nrZpnsBgJJ5VR5+gl/fZVagfgM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757447751; c=relaxed/simple;
	bh=UBTwN9epOeHMQdtzqaWFx5uzJ4dIDcreN1C53Qvt8jo=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=qdPF5sTbWUWS8ZXSzubiIp3U+xjP9a9Ojx+acsOxDLhFOAnCT+1IbEFQrn527LjkdPLUdqxd/MLyuxDqxuD5QYv6PaHgGPrt2aCi0hPrG9rDhkZIFkC6TfdPKH4LfYb/E/DpaZzTNAw/OZncYO4fmozM3yQ99NgMgd4C/FJ6JSE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=N8BUWrtY; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1757447748;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=VwEaYTkppqVE2bssVNAxlDikzdrxi/t7gGAUHOOn71I=;
	b=N8BUWrtYCQn2ENL2WYj3KNdAOVBlLw4IuPeTC5WdfMlz5vMNIOgWFV49Ad/Af2FGknBiQ8
	y4sNXY2KKwS8ulImht7eBDPuc1SM7bDo/uF3T+UJGHhVcTe9EKi8+5xbjHYCEnG0/qKMmc
	chjV+OOxQZb1k4oPM+0MPB/HGIdbDcg=
Received: from mail-qk1-f200.google.com (mail-qk1-f200.google.com
 [209.85.222.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-498-0RwDk34xPPe94FR4SCeGMw-1; Tue, 09 Sep 2025 15:55:47 -0400
X-MC-Unique: 0RwDk34xPPe94FR4SCeGMw-1
X-Mimecast-MFC-AGG-ID: 0RwDk34xPPe94FR4SCeGMw_1757447746
Received: by mail-qk1-f200.google.com with SMTP id af79cd13be357-7e870614b86so1983023685a.2
        for <kvm@vger.kernel.org>; Tue, 09 Sep 2025 12:55:47 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757447746; x=1758052546;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=VwEaYTkppqVE2bssVNAxlDikzdrxi/t7gGAUHOOn71I=;
        b=ayESA5Wx/Qiws5dnGhQd2nBV/P4kz2COMB5atBbpSmAizotcBASKYWWiGodTQM7Af6
         8sNlac49I71vTdYN3ojHktSztQ+zXYEhfhXBOutwImq0lOCVvgbxjikQ3fYHSc0nM7Y2
         1T3fyqL+YK6FVtZFz2hWrPpqH0eDfBMkm9yf0rK7mn7GwcaCYu0RYwPQwLBhgrXrN6aU
         DHvyQlvOa+TlCgi70QTOXW+a1kcHwCglh9milrv1iroRQCqmJbTQcNYwPqenanHCd9TV
         M5QGmEsDUoT09CYQwuwSZyAKZokcxKUEH7EBLdp2hi1PiN1QdRkXn5lrsqo1sThsTMi8
         Yj/A==
X-Forwarded-Encrypted: i=1; AJvYcCVP1Vaj3jmN0hg4a/LSaJZgILUQv/nZp1H2GM/1BlFkCgZ6ysaKt9kmz62pelI6RWmdqlc=@vger.kernel.org
X-Gm-Message-State: AOJu0YzLWC6Ao2sYyR5VKyzGZv9vJWWAMTakqjs63XZObcH1iIZYImb0
	zfzpCeYBgzUXoPhFoInvNUylu4iKlm/4R4kGTx1lLOqz1DG7k0545wXOkeDrCOMfea4lu0cL3QF
	ZNF/AWYbp7OT0FfU2xE2nK40AG21f+M73hXtUvDCmMYJ64XtcnqCPPw==
X-Gm-Gg: ASbGncv4iuf7oioLjzwvwIfysxvp2qJA7arrn195U2JZzGd1oZjg/h03DoWeMV3vOLu
	QRjFRuPKwnYqfvrAKfYJTrzcY4hZC/djanL8zzjK7S+8O48oXA2Xi+LZQw0ulMXy/09upuS2FS5
	r3wkvo17rzl7q01ihpbajfdhdfhBeXmCuFqOrU2vkJza2Q0E55KvQ4j9jlG3hdEYtcsh/hCHPlf
	DQEDCNnfZZovwrM/S0Ubqh9h6FoyDPhXA4AgeXwEuxPMhoo/ynMduATfkQM8D2N0lJBClO65015
	lFeaOcA+QdyQsAkYqaIyrFwzHaTfBgqHrwkWgqD/
X-Received: by 2002:a05:620a:2695:b0:813:ccb9:509f with SMTP id af79cd13be357-813ccb9510emr1236085885a.5.1757447746519;
        Tue, 09 Sep 2025 12:55:46 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFaAcXU8kXFobnNvUqNWSUsQz0woT7+jL6jE0MUCrwRybPYjUTXel6RI/GHw+5Xzip867Mnsw==
X-Received: by 2002:a05:620a:2695:b0:813:ccb9:509f with SMTP id af79cd13be357-813ccb9510emr1236082685a.5.1757447746092;
        Tue, 09 Sep 2025 12:55:46 -0700 (PDT)
Received: from [192.168.40.164] ([70.105.235.240])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-73a16bb3ff5sm74385076d6.1.2025.09.09.12.55.44
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 09 Sep 2025 12:55:45 -0700 (PDT)
Message-ID: <25676d12-57f0-4f54-8554-a6d77d2c6631@redhat.com>
Date: Tue, 9 Sep 2025 15:55:43 -0400
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 06/11] iommu: Compute iommu_groups properly for PCIe
 MFDs
Content-Language: en-US
To: Jason Gunthorpe <jgg@nvidia.com>
Cc: Bjorn Helgaas <bhelgaas@google.com>, iommu@lists.linux.dev,
 Joerg Roedel <joro@8bytes.org>, linux-pci@vger.kernel.org,
 Robin Murphy <robin.murphy@arm.com>, Will Deacon <will@kernel.org>,
 Alex Williamson <alex.williamson@redhat.com>,
 Lu Baolu <baolu.lu@linux.intel.com>, galshalom@nvidia.com,
 Joerg Roedel <jroedel@suse.de>, Kevin Tian <kevin.tian@intel.com>,
 kvm@vger.kernel.org, maorg@nvidia.com, patches@lists.linux.dev,
 tdave@nvidia.com, Tony Zhu <tony.zhu@intel.com>
References: <6-v3-8827cc7fc4e0+23f-pcie_switch_groups_jgg@nvidia.com>
 <d0a5052e-fbbc-4bb7-b1cd-f3f72c7085d3@redhat.com>
 <20250909133128.GK789684@nvidia.com>
From: Donald Dutile <ddutile@redhat.com>
In-Reply-To: <20250909133128.GK789684@nvidia.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 9/9/25 9:31 AM, Jason Gunthorpe wrote:
> On Tue, Sep 09, 2025 at 12:57:59AM -0400, Donald Dutile wrote:
> 
>> ... and why was the above code done in patch 3 and then undone here to
>> use the reachable() support in patch 5 below, when patch 5 could be moved before
>> patch 3, and we just get to this final implementation, dropping (some of) patch 3?
> 
> If you use that order then the switch stuff has to be done and redone :(
> 
> I put it in this order because the switch change seems lower risk to
> me. Fewer people have switches in their system. While the MFD change
> on top is higher risk, even my simple consumer test systems hit
> troubles with it.
> 
In 'my world' I see -lots- of switches in servers.
I don't disagree on the MFD being a higher risk, and more common across all systems.

> Jason
> 

poe-tay-toe, poh-tah-toh... It gets to the end point needed.
Thanks for reasoning...

Reviewed-by: Donald Dutile <ddutile@redhat.com>


