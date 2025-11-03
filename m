Return-Path: <kvm+bounces-61905-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [IPv6:2605:f480:58:1:0:1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id A3482C2DA7D
	for <lists+kvm@lfdr.de>; Mon, 03 Nov 2025 19:22:33 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 86EBB4E8840
	for <lists+kvm@lfdr.de>; Mon,  3 Nov 2025 18:22:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A85F128C5B8;
	Mon,  3 Nov 2025 18:22:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="cTH9zQI5"
X-Original-To: kvm@vger.kernel.org
Received: from mail-ej1-f67.google.com (mail-ej1-f67.google.com [209.85.218.67])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C9F3617AE11
	for <kvm@vger.kernel.org>; Mon,  3 Nov 2025 18:22:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.67
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762194135; cv=none; b=LSNDt5TD1/c6a1U1txVeeR+QxMoB4jT2EXugS9IKfgThSGAUJFe4SR9cXxfMFCn1Jb8cJW3MGxaTChHCD6TnJ3wBrKVJjMRu0BAEe2gbJKkjrOrN8zOiEB8oTap3+vkEj2arZC/PbI/Lf7oZo2vRiSLYjmxWSRiD50Nupzcs7hE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762194135; c=relaxed/simple;
	bh=hBQwSFa3ls5tXGp6taWMTxAYUVgv5w1YYI79QHPzWyU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=B604BbEHxcYbCxixMros3/E/o2fpMgDV34FTKvBKKId+EVwBe2SvZ2JbFVtuhH9Uh/LKwrVx8OTNjDTqoKdDcglznLbNqotklnd506j+dK7Fu8+o97iJHTzVwfw8syZ5uQoqlEk+Mtu/7o13jqLkFxMlvpyyUIB4Yxqegyh/DK4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=cTH9zQI5; arc=none smtp.client-ip=209.85.218.67
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Received: by mail-ej1-f67.google.com with SMTP id a640c23a62f3a-afcb7ae6ed0so863929466b.3
        for <kvm@vger.kernel.org>; Mon, 03 Nov 2025 10:22:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1762194132; x=1762798932; darn=vger.kernel.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=CADywisMv8oKHI4QSeR7YMm7LIR82MPNXUUykN5HtdQ=;
        b=cTH9zQI54ZaNq0zxV8Dw4tPnnCh6XgK88EPasgwpEJlQUXlEl1DD4tTfXawG9IzzeK
         fCScb4fMGs0E5v3+1sFwRSw8bKK/AQc58IuowXmlwlr5Bo/yBBQ6CX9zcAJUGxysOLbB
         3djBaj1ZJ5LddmMBgMSaIhWvCqJrSfHHEdFTLctKfv8eTNkQuFL6m0SlZk4Wsktr23mX
         fqd4oZH1ziIf5b9wPS3c6ksZifpMKBe5qeMtE64kI09Mxl7jBk9PgMX8ZiKpjFrX9glP
         zBtomn8BO/sT7iGTDTEr0SWsRDut8boxxEB0BOcnRWhP1hkYtolShXn9V9pNQEIftqnC
         W2ng==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762194132; x=1762798932;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=CADywisMv8oKHI4QSeR7YMm7LIR82MPNXUUykN5HtdQ=;
        b=ZcaFD2jByS+mh9IOsO6zm/EDpms5UljSoJKO2NfoHsZGhfLnojoagXPjIGr8WBGo65
         MSj0dJCpvplWnx8K/ZnrovyYmAHntGVcdKs6lQtYFi1Upl+Zq3vhYbc9TtzJdD0xtSk3
         OF/FUdwc5Wbwe2ywOgEFMOqXUrzU8HVD0hYapuSbPqS2ik/l4rf+8v8qDnYzCsb5Fbxb
         j/OAx5FlDXwxFqa3QF1HmKU4BF0IaED7ESAEJ+SonrwQ9b8f0OrqpjJahmWqRC128CFW
         T3ejhOFU8BfKL65LM/YreHO9Ed1isynqiWlKKJdm0YaoVyhZGHWzsQ+OpcXct+atU/bs
         2Oyg==
X-Forwarded-Encrypted: i=1; AJvYcCX1sRrhsEn+JvYT5Xk2cL4BrsNSAvZLB6f6W0peXhN9OI71SPM4abHdkot0/MccB1/H+/Y=@vger.kernel.org
X-Gm-Message-State: AOJu0YywXHuDx/sUfD5aW+2MdQ2Z5Zd1UXUX0QWiHJmME+MpdRB+vPBG
	qCPIz8uuCxLvKL4SviBKoxJJ+TnKew6YrF47LgLvpikCJAIh0lAw5cBU0DTHSJ/73I8=
X-Gm-Gg: ASbGncsHnSI+F8OuoqIbaG36zksk9nvHD80HYgWAw0exOPvfAdU3LJI/GnDmT7D0I6r
	TZuKIzftO3Ja1qxkR0H4/R51GNJRZox3JYU5xuSlJcyuwNPwt9shcpxnQyYntVAvVpdw9NaWZRu
	9pvLlLi95Mq/QMSf9okyCUQNELMXgWKguZy/n1L6ZzrTRmzD9i/y0IJNArmNhGmvIXVqO2nHxrU
	qF7dvKxbTigvpFO2Pevn+y/zAkEbQN4WXrr330hT9WfmsSPiLX35L49CJ4mpTB1G0+Vy0YSgdm4
	8tbzpNHPPVW7GS01qnYtYXTFNXcnA8/O0CzrKxy7wA3zdQNUyIdmounDZFUdcTcMoWEI+kIAkWg
	/iUHz3cSwwgVgoNv5eBdp2upBWAknTH+cBQHTtI45+9Za1sSZFYRlWwX5+pAwXGyajHyKbSb4Tt
	ldwHSukTtDJ4UEYA==
X-Google-Smtp-Source: AGHT+IHNFHN7nALHAQI3py5s3oB3pNSaTHU60CtQtHtaXj2ajzjyABGHYsA7JkTUyfWfWQz+8Ib3/g==
X-Received: by 2002:a17:907:944d:b0:b70:b7c2:abe9 with SMTP id a640c23a62f3a-b70b7c2af64mr561377766b.38.1762194131429;
        Mon, 03 Nov 2025 10:22:11 -0800 (PST)
Received: from localhost (109-81-31-109.rct.o2.cz. [109.81.31.109])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-b70bedcec19sm413921266b.7.2025.11.03.10.22.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 03 Nov 2025 10:22:10 -0800 (PST)
Date: Mon, 3 Nov 2025 19:22:09 +0100
From: Michal Hocko <mhocko@suse.com>
To: Ankit Agrawal <ankita@nvidia.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Aniket Agashe <aniketa@nvidia.com>,
	Vikram Sethi <vsethi@nvidia.com>, Jason Gunthorpe <jgg@nvidia.com>,
	Matt Ochs <mochs@nvidia.com>,
	Shameer Kolothum <skolothumtho@nvidia.com>,
	"linmiaohe@huawei.com" <linmiaohe@huawei.com>,
	"nao.horiguchi@gmail.com" <nao.horiguchi@gmail.com>,
	"david@redhat.com" <david@redhat.com>,
	"lorenzo.stoakes@oracle.com" <lorenzo.stoakes@oracle.com>,
	"Liam.Howlett@oracle.com" <Liam.Howlett@oracle.com>,
	"vbabka@suse.cz" <vbabka@suse.cz>,
	"rppt@kernel.org" <rppt@kernel.org>,
	"surenb@google.com" <surenb@google.com>,
	"tony.luck@intel.com" <tony.luck@intel.com>,
	"bp@alien8.de" <bp@alien8.de>,
	"rafael@kernel.org" <rafael@kernel.org>,
	"guohanjun@huawei.com" <guohanjun@huawei.com>,
	"mchehab@kernel.org" <mchehab@kernel.org>,
	"lenb@kernel.org" <lenb@kernel.org>,
	"kevin.tian@intel.com" <kevin.tian@intel.com>,
	"alex@shazbot.org" <alex@shazbot.org>, Neo Jia <cjia@nvidia.com>,
	Kirti Wankhede <kwankhede@nvidia.com>,
	"Tarun Gupta (SW-GPU)" <targupta@nvidia.com>,
	Zhi Wang <zhiw@nvidia.com>, Dheeraj Nigam <dnigam@nvidia.com>,
	Krishnakant Jaju <kjaju@nvidia.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"linux-mm@kvack.org" <linux-mm@kvack.org>,
	"linux-edac@vger.kernel.org" <linux-edac@vger.kernel.org>,
	"Jonathan.Cameron@huawei.com" <Jonathan.Cameron@huawei.com>,
	"ira.weiny@intel.com" <ira.weiny@intel.com>,
	"Smita.KoralahalliChannabasappa@amd.com" <Smita.KoralahalliChannabasappa@amd.com>,
	"u.kleine-koenig@baylibre.com" <u.kleine-koenig@baylibre.com>,
	"peterz@infradead.org" <peterz@infradead.org>,
	"linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>
Subject: Re: [PATCH v4 2/3] mm: handle poisoning of pfn without struct pages
Message-ID: <aQjy0ZsVq7vhxtr7@tiehlicka>
References: <20251026141919.2261-1-ankita@nvidia.com>
 <20251026141919.2261-3-ankita@nvidia.com>
 <20251027172620.d764b8e0eab34abd427d7945@linux-foundation.org>
 <MW4PR12MB7213976611F767842380FB56B0FAA@MW4PR12MB7213.namprd12.prod.outlook.com>
 <aQRy4rafpvo-W-j6@tiehlicka>
 <SA1PR12MB71998D21DD1852EB074A11ABB0C6A@SA1PR12MB7199.namprd12.prod.outlook.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <SA1PR12MB71998D21DD1852EB074A11ABB0C6A@SA1PR12MB7199.namprd12.prod.outlook.com>

On Sun 02-11-25 11:55:56, Ankit Agrawal wrote:
> >> >> +static void add_to_kill_pfn(struct task_struct *tsk,
> >> >> +                         struct vm_area_struct *vma,
> >> >> +                         struct list_head *to_kill,
> >> >> +                         unsigned long pfn)
> >> >> +{
> >> >> +     struct to_kill *tk;
> >> >> +
> >> >> +     tk = kmalloc(sizeof(*tk), GFP_ATOMIC);
> >> >> +     if (!tk)
> >> >> +             return;
> >> >
> >> > This is unfortunate.  GFP_ATOMIC is unreliable and we silently behave
> >> > as if it worked OK.
> >>
> >> Got it. I'll mark this as a failure case.
> >
> > why do you need to batch all processes and kill them at once? Can you
> > just kill one by one?
> 
> Hi Michal, I am trying to replicate what is being done today for non-PFNMAP
> memory failure in __add_to_kill
> (https://github.com/torvalds/linux/blob/master/mm/memory-failure.c#L376).
> For this series, I am inclined to keep it uniform.

Unless there is a very good reason for this code then I would rather not
rely on an atomic allocation. This just makes the behavior hard to
predict
-- 
Michal Hocko
SUSE Labs

