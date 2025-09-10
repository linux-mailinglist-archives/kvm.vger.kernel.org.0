Return-Path: <kvm+bounces-57184-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 5851DB51223
	for <lists+kvm@lfdr.de>; Wed, 10 Sep 2025 11:06:33 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id D23D41650CE
	for <lists+kvm@lfdr.de>; Wed, 10 Sep 2025 09:06:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EEF94311971;
	Wed, 10 Sep 2025 09:06:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="iPcKNfwu"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8A00B2D0C78
	for <kvm@vger.kernel.org>; Wed, 10 Sep 2025 09:06:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757495183; cv=none; b=JEcURVLgTHvfTclsvFkP1Os3miM1OYNw8Fx8RKOsUyxQ4yGiQVS79t+WdPaNZ2hUAW0EXIHjigrgQDWZ0fMuLbVe53cnbg4HfYVOubJwRCphKNaEvWKCmXmgEGuD1DQYkffyKxtr6x9o//PlrHb5auKTt0bVMq2jc1WPKtek+yY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757495183; c=relaxed/simple;
	bh=iUSDXJGpofRG9F6DLBzhd1wjR2CBKpeDWXvgbbklw80=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=tWkgr8kgdP9u+5DDZfgQOFs95MO2gglfadmLMgKp00qZ4e27+vdFGhOGvUi79tW/meSWBIkQMOC50tloV0Jza7epIh/2EPrBeyujmHoc6Xtj1cYevyIk/z9ELccSD46DEeMCPHY+PLfjRj80VsbTI6BQ70/DCiQb1jh7zibfmBY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=iPcKNfwu; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1757495180;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=3UM/aAbKLzU70BTEJvzKMHJonTjUwJ5bEuUp7ofCYxY=;
	b=iPcKNfwusTHdmrWRNjo//nIsF2CriAxxkrbqqQw+oMFErpZzaV9tF1B+zyJxJVtW7O8Wa7
	X4jCAY6YHR28iEyRMZvM6pOhfdQ2O+ShtlCUPOKMGcndlVL6mSzlFqj5YHI29h5+mO2RNK
	oToltp7CBJBga30DjXn4BPS4dBWuOKQ=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-351-BsWWjvw3P-Wiku1scCAUhQ-1; Wed, 10 Sep 2025 05:06:19 -0400
X-MC-Unique: BsWWjvw3P-Wiku1scCAUhQ-1
X-Mimecast-MFC-AGG-ID: BsWWjvw3P-Wiku1scCAUhQ_1757495178
Received: by mail-wr1-f70.google.com with SMTP id ffacd0b85a97d-3dbc72f8d32so2664039f8f.3
        for <kvm@vger.kernel.org>; Wed, 10 Sep 2025 02:06:18 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757495178; x=1758099978;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=3UM/aAbKLzU70BTEJvzKMHJonTjUwJ5bEuUp7ofCYxY=;
        b=Dg0ifxYwS5VssEauaTSIFgdgmBLNQ8zSv00GWRUCwreqVfFzwHQbc5LmCdWRCUjSLS
         B0gwLonW1zNpHcwdDF0K+ERuGz+24p8CLwAPMZ5wDnwirMFsjHdfVuWJTChAqft1rPF0
         Tplh38A66iWFT87VsUuUFbRUqsQOwR3gbZ277TowVYM1acYFMq387fF7HZx4gDmDSLRJ
         21E9GKcZCtuuODWkE1cGJvYSG7hVgLY4Q5OxusV63Vxap6MRAY8tSyDXQedjdMyvIKaZ
         8fUI/Ja8cOkP/RStKKDyio8C1PXkY3nBM7xxh5iSa4+hTX3NZ5q1dfS+OMSFCbCHUv3e
         9lOA==
X-Gm-Message-State: AOJu0YyknkF03qQWktXERuCyjxY8NyViOD/cgX/N/or0AD6S2ibLrJta
	SqlQKCImOaviN93kEFtAAYEhYoml10WjXmtx3Hgi97e8HhLfcBwDoEElvfG9OU9xZXgYig7OlNC
	bzYYTV30DyZA0nZw7qxEjyIEyWEuP9Lmk26Ca9k550wgfHAWep02raA==
X-Gm-Gg: ASbGncsBkUnzLtYsrM/hR9BxSzl6M39oGuwYzNfHdt1OmpCHwYnqQoRubxk+PeJwXyp
	l/vviX4bRefcXo9FkcH2ovAmqhKmZui10R9zzslhyyiKVUzcfyTowAS70FwOxs4py8RYKS9j1/b
	MTHxEsBH4eUNwfqogB/i4YCJP2c4PxOnDFHaXA2Af1iglQEcwQAhTKMJdfu0y+HL/9EAWox31+4
	psILvR4CX77BZfcgKZYy7VH8sjoHeW06M20RBAvLjZKLw2LHqLAityKfb4a4iNW5wo9jBNwGyVp
	W8DISjjMW2iSkdUSCYowDi1pvQHBCaeVJFBfgPzQU2MlftD961WbA1aArr1LXTqEJlEWwj95tCk
	Qu4RB2Q==
X-Received: by 2002:a05:6000:1a8d:b0:3ce:db36:607f with SMTP id ffacd0b85a97d-3e64bde6d15mr9900273f8f.37.1757495177844;
        Wed, 10 Sep 2025 02:06:17 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEkg4Ida45Dd09K1k3H0dwnsGZOSj6xCdfbg5oXlsrXlRzSfc13R9cfU++IdoaTT1zsdDZI5w==
X-Received: by 2002:a05:6000:1a8d:b0:3ce:db36:607f with SMTP id ffacd0b85a97d-3e64bde6d15mr9900251f8f.37.1757495177465;
        Wed, 10 Sep 2025 02:06:17 -0700 (PDT)
Received: from [192.168.0.7] (ltea-047-064-113-183.pools.arcor-ip.net. [47.64.113.183])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3e7532f90e6sm5600559f8f.6.2025.09.10.02.06.16
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 10 Sep 2025 02:06:16 -0700 (PDT)
Message-ID: <5b8240d7-d3e9-4b8b-bc77-731fb2fb0001@redhat.com>
Date: Wed, 10 Sep 2025 11:06:15 +0200
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [kvm-unit-tests PATCH v2] scripts/arch-run.bash: Drop the
 dependency on "jq"
To: Claudio Imbrenda <imbrenda@linux.ibm.com>, Nico Boehr <nrb@linux.ibm.com>
Cc: kvm@vger.kernel.org, Andrew Jones <andrew.jones@linux.dev>,
 Janosch Frank <frankja@linux.ibm.com>
References: <20250909045855.71512-1-thuth@redhat.com>
 <DCOYKSEY6V79.3HE423J6WWXTT@linux.ibm.com>
 <20250910110007.26fa1643@p-imbrenda>
From: Thomas Huth <thuth@redhat.com>
Content-Language: en-US
Autocrypt: addr=thuth@redhat.com; keydata=
 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
In-Reply-To: <20250910110007.26fa1643@p-imbrenda>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 10/09/2025 11.00, Claudio Imbrenda wrote:
> On Wed, 10 Sep 2025 09:57:17 +0200
> "Nico Boehr" <nrb@linux.ibm.com> wrote:
> 
>> On Tue Sep 9, 2025 at 6:58 AM CEST, Thomas Huth wrote:
>>> For checking whether a panic event occurred, a simple "grep"
>>> for the related text in the output is enough - it's very unlikely
>>> that the output of QEMU will change. This way we can drop the
>>> dependency on the program "jq" which might not be installed on
>>> some systems.
>>
>> Trying to understand which problem you're trying to solve here.
>>
>> Is there any major distribution which doesn't have jq in its repos? Or any
>> reason why you wouldn't install it?
> 
> I think it's just a matter of trying to avoid too many dependencies,
> especially for something this trivial

Yes ... actually, a while ago, I noticed that I was never running this test 
on fresh installations since "jq" is not there by default. I guess it's the 
same for many other people, too, since we don't really tell them to install 
"jq" first.

So let's give this patch a try for a while, and if we run into problems, we 
can still revert it.

  Thomas


