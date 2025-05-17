Return-Path: <kvm+bounces-46937-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id A4081ABAB49
	for <lists+kvm@lfdr.de>; Sat, 17 May 2025 19:15:31 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id A1E619E072E
	for <lists+kvm@lfdr.de>; Sat, 17 May 2025 17:15:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8AB2A20CCE4;
	Sat, 17 May 2025 17:15:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="BdIb7YGK"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f47.google.com (mail-pj1-f47.google.com [209.85.216.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 338401B6CE4;
	Sat, 17 May 2025 17:15:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747502121; cv=none; b=V226EeClDehvPsyyZAjKc9jToSQh5fKJX+Q23OsccaZFlmPBCH2QBaegpi24sSntCkOiYlrItIRGF7tYyMXn0ooEGFAc+QnqTltBxteuHQuoUOp9uQa7TTaluGyJg2lhpg0zC6RjL3cEw7W1Gb5U25U+XgepqLQPrqaIc0hBuwQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747502121; c=relaxed/simple;
	bh=9DjCofLXmx9Q5OCi6Po1q3UA8AxzT6dRjaBiwIUNyH8=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ZqaRSpwtOc3WyBTriIVaOl1RMrK8eyjXHpX2ChNmTWWINE2GJdX4cvgVzdUAD1NU7qVBoiw01/DNJ4le5RqkpEs9dvH5h2x1CXckN4QMc4TRDl5gPB7zJs0f+Yp5aJHpwxFmqpBpY5pItKfetr/eVVjTMNRp5ByO1wbJAIvHgvg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=BdIb7YGK; arc=none smtp.client-ip=209.85.216.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pj1-f47.google.com with SMTP id 98e67ed59e1d1-30e8feb1886so1368840a91.0;
        Sat, 17 May 2025 10:15:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1747502118; x=1748106918; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=9DjCofLXmx9Q5OCi6Po1q3UA8AxzT6dRjaBiwIUNyH8=;
        b=BdIb7YGKX93IoBUvusoGbbP5Tnh8Hsxy+BQLJx0OeVimVY6crefis3xtpvkMm+Mr7y
         KkaaQPwOy6qba3mvdllPB4Zzm1rYK5VK8gccXGGBJYk/jKqKv8bq93QtmoA73xXVxDWS
         nuB3RKAE8MAEmTnyAL2WMe6GJaelvJpjjBlyeI7sPYsLYHRCdu+lhmIl+fYAbpMEFZoU
         rl88hrrP365/12Tj2JMDURKjvkp7fhzUU63C05iqjSUpoOqg4cmvJ2fI0kLuV4vunTXO
         rSdeg2Oy08JhLK4XmuY/5gX9buA8fFrls1lLp4vywbTv0msYcUv4P9kFa4qu2Jzq4ACF
         BTRw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1747502118; x=1748106918;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=9DjCofLXmx9Q5OCi6Po1q3UA8AxzT6dRjaBiwIUNyH8=;
        b=APkuiTYZZhgXtogIp6+DZbbTmaTxb7U15MZWcbUT8YOwKQSfqCh4KWs6nxZboWFe98
         ZlziOVRO3hdXRsOFKRbuPh7YbFYXM1PG157VX9h+Qhsxqx+bNXTyfLFKo5k2JitsRK+N
         IBO6Gcz2qQcDZowaHBdMeHe62IBpn+y9bbTDdv+y8kfzKx3WbhCDI6AUT4zODzPCVCGQ
         4QUh8lZCwVy+80uD3HP2ZcNI2mJaFmH+omzTGzgZAV6n5sGGFpiChc1x5sEUhykiCdf5
         g6ArBkAQYAheENaWLFEROKeBnCkFIYT4SQJeq5363hc433v2J7iCWfoGzO+A6bBO0gVV
         r6Vw==
X-Forwarded-Encrypted: i=1; AJvYcCVsUUJZ7K2oPTdaa4puCQ2Mt8zaO3vrlh/0UQPjqVF9HMvz4Rshr/ZE18PwFhIP8dTZj9sQ@vger.kernel.org, AJvYcCW8fYbXCyVkkOpcBiYlfKSH0wvF0hFLfqZFEpQXWN2UqqcTa/4JO0zWC70IOKOgJbz9kQRp2c+qOuzI2cur@vger.kernel.org, AJvYcCXDvIsqkPLcauGFaAJDc9PlVinuIaEf+DEGxmLhq45YDohNzncuclVie9NCb9MuGMo9LqK3Bw==@vger.kernel.org
X-Gm-Message-State: AOJu0YxXUl5S10vvsISEAwq1lnB0cI3tOw9baq3Wxx4a18rm7t45mZyx
	m4xyDDwVeXbBTOx6AnaA4QwEZzZg7YYMZh9Lmipl2b93wXOEBInJReKQ
X-Gm-Gg: ASbGncvsK4E2G5Bu01A/kQcB70oiOdSN3ZWWgRUMFHAYTYnVJiMo+v5NCwrqMAMHNgr
	9QjkVNlwBqo+Q5XYtZPK9XF99UDHRnj04WE5WmYa88J/jJx1CtFiaAoa5fSM4MZUrp62+45rdlg
	t2U+zOAab5EeRj3O59RUpB9sz5RuLcGyedFLDZnlnrD/n8Uih846AoJSh6AyJtTV+M1xj17hhZy
	xx+6W6dS34aKj6sSsUoIggVDUemGmiSIjv9kn66WdspUZA8e1usE/7BVbnoZWyeUXpJ8PbG8lTK
	8Di73u49dOCziJSWOwZSB2vU848pTOwjSlz67ezlTsw+OZ0bZyoiZUKDTGqK7tyHN8owwFYw46F
	OfM1DJ3w11O9i6baeTc/ZsN1v5cm9
X-Google-Smtp-Source: AGHT+IGhXsveF4OEbJ1dDyp9Nw46gkHE+V0NR+HQKEHO5MjpfY02u0lplDjD8I9+4s1a7IPjvStHlA==
X-Received: by 2002:a17:90b:4b0f:b0:2f6:be57:49d2 with SMTP id 98e67ed59e1d1-30e7d545920mr12896336a91.17.1747502118288;
        Sat, 17 May 2025 10:15:18 -0700 (PDT)
Received: from master.chath-257608.iommu-security-pg0.clemson.cloudlab.us ([130.127.134.87])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-30e3340187dsm7160722a91.5.2025.05.17.10.15.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 17 May 2025 10:15:17 -0700 (PDT)
From: Chathura Rajapaksha <chathura.abeyrathne.lk@gmail.com>
X-Google-Original-From: Chathura Rajapaksha <chath@bu.edu>
To: jgg@ziepe.ca
Cc: Yunxiang.Li@amd.com,
	alex.williamson@redhat.com,
	audit@vger.kernel.org,
	avihaih@nvidia.com,
	bhelgaas@google.com,
	chath@bu.edu,
	chathura.abeyrathne.lk@gmail.com,
	eparis@redhat.com,
	giovanni.cabiddu@intel.com,
	kevin.tian@intel.com,
	kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	paul@paul-moore.com,
	schnelle@linux.ibm.com,
	xin.zeng@intel.com,
	yahui.cao@intel.com,
	zhangdongdong@eswincomputing.com
Subject: Re: [RFC PATCH 0/2] vfio/pci: Block and audit accesses to unassigned config regions
Date: Sat, 17 May 2025 17:14:59 +0000
Message-Id: <20250517171459.15231-1-chath@bu.edu>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20250516183516.GA643473@ziepe.ca>
References: <20250516183516.GA643473@ziepe.ca>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

On Fri, May 16, 2025 at 2:35 PM Jason Gunthorpe <jgg@ziepe.ca> wrote:
> > By PCI bus error, I was referring to AER-reported uncorrectable errors.
> > For example:
> > pcieport 0000:c0:01.1: PCIe Bus Error: severity=Uncorrected (Fatal), type=Transaction Layer, (Requester ID)
> > pcieport 0000:c0:01.1:   device [1022:1483] error status/mask=00004000/07a10000
> > pcieport 0000:c0:01.1:    [14] CmpltTO                (First)
>
> That's sure looks like a device bug. You should not ever get time out
> for a config space read.

Just to clarify, the above error was triggered by a write to the
configuration space. In fact, all the errors we have observed so far
were triggered by writes to unassigned PCI config space regions.

> Dynamically updateable might be overkill, I think you have one
> defective device. Have you talked to the supplier to see if it can be
> corrected?

So far, we have seen this issue on five PCIe devices across GPU and
storage classes from two different vendors. Therefore, we suspect the
problem is not limited to a single device, vendor, or class of devices.
We reported the issue to both vendors over two months ago. But we
have not gained any insights into the root cause of the issue from
either vendor so far.

> Alternatively you could handle this in qemu by sanitizing the config
> space..

While it's possible to address this issue for QEMU-KVM guests by
modifying QEMU, PCIe devices can also be assigned directly to
user-space applications such as DPDK via VFIO. We thought addressing
this at the VFIO driver level would help mitigate the issue in a
broader context beyond virtualized environments.

Thanks,
Chathura

