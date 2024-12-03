Return-Path: <kvm+bounces-32951-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 846819E2CC3
	for <lists+kvm@lfdr.de>; Tue,  3 Dec 2024 21:09:07 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 3E32E28BE84
	for <lists+kvm@lfdr.de>; Tue,  3 Dec 2024 20:09:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0EA951F891C;
	Tue,  3 Dec 2024 20:09:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="OYfqerp8"
X-Original-To: kvm@vger.kernel.org
Received: from mail-ej1-f41.google.com (mail-ej1-f41.google.com [209.85.218.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9D33C18CBE1
	for <kvm@vger.kernel.org>; Tue,  3 Dec 2024 20:08:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733256541; cv=none; b=hy91gS1b0Pf8DEjWFJVTBJwnqV1F8eYcPW1A+/bk1jOnxLyBSwMfib5wMdOWG1NgHhthQqbqPSH7HLLg+oZ1AUVXaJ6B2gQQnCXCUq6VNGEwNYYkg6RTqyAwAe3AbA+z/BR9cbix3ZflN+DhMdc+FFOrp87y7amcIk360sbgU+Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733256541; c=relaxed/simple;
	bh=qiRILwbyqDNuyfmT3oAJuWeYTtQvTCA97X3gaWM5CgI=;
	h=Message-ID:Date:MIME-Version:To:Cc:From:Subject:Content-Type; b=qZh91Wf+5c7xdLUFv1xZfk/BFg3bCmeW8kzlWpzRQquL/NZehfnmFWqxH4QWYdEzTyw/rshB45ca3BmXhHTVFF5+IyllxfoAR0G8a2hOyUqhbGFQX3WDKtQ+pKKJ/zG4iXBFwQL5LLdpKpIS/Vx/U2oHgidlzLVsC8e6Gn9pGR0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=OYfqerp8; arc=none smtp.client-ip=209.85.218.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ej1-f41.google.com with SMTP id a640c23a62f3a-aa5ec8d6f64so103951766b.2
        for <kvm@vger.kernel.org>; Tue, 03 Dec 2024 12:08:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1733256538; x=1733861338; darn=vger.kernel.org;
        h=content-transfer-encoding:autocrypt:subject:from:cc:to
         :content-language:user-agent:mime-version:date:message-id:from:to:cc
         :subject:date:message-id:reply-to;
        bh=OTI69H7btkXCb72dSzaNg+akHgO9K5cjkmX/GOK6tjU=;
        b=OYfqerp8rWF/I28rdPxcmqu9WMLCWmsN3/bejHNG89mBL3FlPqWcLl/lGa9vR5GTOV
         /e+O3RjWd6Odtc5u3RawSaXKHMBQLdVBm2kfNekDeoTSaVmke+GnvUEieTFelC7yGIOM
         zGkUKlFH9IkF37txv4SmmcTNW17dBhh6nOgj5+1vh83+LVO9JWF70thdWIyvHvMPRotf
         06Z1bCN9bOTB5+G6rU/eCJO6VovwN9aKw1VTho/4FnwKC3d6ilbX/tnCr758tH71Won7
         qp/1gTkue6mrSd1UZM7vF7Zrjo8t5soUHi9IbQX823pIdoktNcdGKPcnzMU5cDZ7XgwN
         CdPA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1733256538; x=1733861338;
        h=content-transfer-encoding:autocrypt:subject:from:cc:to
         :content-language:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=OTI69H7btkXCb72dSzaNg+akHgO9K5cjkmX/GOK6tjU=;
        b=XHvcc3goouTp2dp5yAljoLBNAqcKoDd6277YugqPBXkgzZMB26L6qU85z839HGSCj1
         ElTegOg3OwrLNT1WmWV+iUMsHLzThxnADNoX6/Lg4+zwz+uST0jsZU4Lw+HT+Af43KqV
         hB5vBn+FM87NrpP8Hb28DPjQ7eBUmXeHpUtWsURneRuLVm16yAgIvUi8jSsYws25rcEn
         nN2J0h9cAKpU+1OZoO0OsZaW8wvzygYS+cqArQE4Rbnkpe9Nn30D5hzn8uSYCvbZWM9D
         DIdMLXytWpWoQAZdLQA6MslR3fEtDmHkyF7qBq5JAkZT0tBu60ea5hX8RCbMzSvrBoC8
         vcKw==
X-Gm-Message-State: AOJu0YzfPEM0orFwqCjXIVDvqIXznPFW64ZTlFmFTR5Au8m5K6tPPeuS
	g3lVb+aRcB8IjCe+HjoLiaZH9Igiwm6HJFqmRbcXNhjpuMcIl1Lj
X-Gm-Gg: ASbGncv4U/jLdNpTqQ6Wia9LdN31E4jCpzVuuFhua4byC9ZCGBQQN+1/Q7kHPdzMGkU
	V0VLTtJCmGHj/haeTb1rf7AmAPeaqOFprcowCSNa6EqfJfLw7JFQajScc6C8Cqg5Qp7noZQJK5G
	eL9wwYUxZB6bAAq3v1gGrodnLgGcap5/mOerL4YXuK0IKQUjsGc5NqFdMGImwwyRQR6H+QhHOro
	CttiCyOIIdDHEPyWIueam0ilmIuZ3/P+MFl61shjFeFfSYH6Y9VTm7+7nwdMpWBo+e6V1aMN9LQ
	DMreUXQ371w5MzGtv9nXGk4ePYBRQBfkTOcM2H2JHis6lyTg2e+wpd7v+dbqa8hpwk4u3ZJjpA1
	yoL4QBPmFa/trnzGiJ3Y/Z5tFuOYgaWJ0MQR4M37Yuw==
X-Google-Smtp-Source: AGHT+IEYG+487iWmch8Jm8y1uZM3URpIzZ5lpgg89YnGdVCTuDJfBMoFYj4HkVvY8cBoCebKiC+UCw==
X-Received: by 2002:a05:6402:4499:b0:5d0:bb76:dff2 with SMTP id 4fb4d7f45d1cf-5d10cb8025dmr4198873a12.24.1733256537735;
        Tue, 03 Dec 2024 12:08:57 -0800 (PST)
Received: from ?IPV6:2a02:3100:9d09:7500:8175:4ab5:e6ba:110b? (dynamic-2a02-3100-9d09-7500-8175-4ab5-e6ba-110b.310.pool.telefonica.de. [2a02:3100:9d09:7500:8175:4ab5:e6ba:110b])
        by smtp.googlemail.com with ESMTPSA id a640c23a62f3a-aa5996c1383sm650263266b.40.2024.12.03.12.08.55
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 03 Dec 2024 12:08:56 -0800 (PST)
Message-ID: <147a2a3e-8227-4f1b-9ab4-d0b4f261d2a6@gmail.com>
Date: Tue, 3 Dec 2024 21:08:55 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Content-Language: en-US
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
 "Rafael J. Wysocki" <rafael@kernel.org>,
 Kirti Wankhede <kwankhede@nvidia.com>,
 Alex Williamson <alex.williamson@redhat.com>
Cc: kvm@vger.kernel.org
From: Heiner Kallweit <hkallweit1@gmail.com>
Subject: [PATCH 0/3] driver core: class: remove class_compat code
Autocrypt: addr=hkallweit1@gmail.com; keydata=
 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
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

vfio/mdev is the last user of class_compat, and it doesn't use it for
the intended purpose. See kdoc of class_compat_register():
Compatibility class are meant as a temporary user-space compatibility
workaround when converting a family of class devices to a bus devices.

In addition it uses only a part of the class_compat functionality.
So inline the needed functionality, and afterwards all class_compat
code can be removed.

Heiner Kallweit (3):
  driver core: class: add class_pseudo_register
  vfio/mdev: inline needed class_compat functionality
  driver core: class: remove class_compat code

 drivers/base/class.c          | 89 ++++-------------------------------
 drivers/vfio/mdev/mdev_core.c | 12 ++---
 include/linux/device/class.h  |  8 +---
 3 files changed, 15 insertions(+), 94 deletions(-)

-- 
2.47.1


