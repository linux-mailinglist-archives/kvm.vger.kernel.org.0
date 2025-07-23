Return-Path: <kvm+bounces-53262-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 36455B0F6A5
	for <lists+kvm@lfdr.de>; Wed, 23 Jul 2025 17:12:13 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 6B70F5A1720
	for <lists+kvm@lfdr.de>; Wed, 23 Jul 2025 15:07:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 848642F5C49;
	Wed, 23 Jul 2025 15:05:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="KTSZPMQe"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D2C802F5080
	for <kvm@vger.kernel.org>; Wed, 23 Jul 2025 15:05:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753283126; cv=none; b=pwiCGUAMQFuW0Qy/gWlbPKarO0gjwd603J6bRKo9hKdX0DeRljW/PjKZVqk1WExdyzsszYSryegZw9RYeEBSjVao0N601ObZMXdv3GqC2wv0892pC4DcYx/r0QlaEcXyyNBQs7Z9bENmLLH/TEuTRnoj7w88qg1enTufmYtQXPI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753283126; c=relaxed/simple;
	bh=yv5nB3643mwqFffYhxn7JpZMpQCIFo0F3qmPkPIlgM0=;
	h=Message-ID:Date:MIME-Version:From:To:Subject:Content-Type; b=joLGcyXQwomZa0HuKx1NFUmxIDFRR2OZRIIKHiRbkZorFEphP/KkhQlVCtzQjKQeW0Bb4XNtQoO0b9xlP+kDl75HysH6SYLtOkdRsxpR7/LWMdODcvFJ2Kn2g7N9usrBxNp+WhBsCQOgmh2GjMfU678nm0ylPAHUvQWNUYbdyPw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=KTSZPMQe; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1753283124;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:autocrypt:autocrypt;
	bh=yv5nB3643mwqFffYhxn7JpZMpQCIFo0F3qmPkPIlgM0=;
	b=KTSZPMQeQ3Lb1ja302xUWmi99AX9QJjJzh3cN2X4Bo7kCqa8WMLIWX/sgsYv20ofLVvKS0
	xNxLKZV4mqSdBN/0k08krmWjHuP7VtbkC/Px1W9SXbTiDS4Yac9tQaZkwRmBUJ3crkaWBE
	4qoh3roPx6TqC5hk7USb4O91ppPyvb0=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-673-HnbUuTwWPLSskZe-i04VpA-1; Wed, 23 Jul 2025 11:05:22 -0400
X-MC-Unique: HnbUuTwWPLSskZe-i04VpA-1
X-Mimecast-MFC-AGG-ID: HnbUuTwWPLSskZe-i04VpA_1753283121
Received: by mail-wm1-f72.google.com with SMTP id 5b1f17b1804b1-451d7de4ae3so39158495e9.2
        for <kvm@vger.kernel.org>; Wed, 23 Jul 2025 08:05:22 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753283121; x=1753887921;
        h=content-transfer-encoding:organization:autocrypt:subject:to:from
         :content-language:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=yv5nB3643mwqFffYhxn7JpZMpQCIFo0F3qmPkPIlgM0=;
        b=VYx8KqlOMC+oN8a4hLJa/AWrzFRFxuCA/KD+S6v1Sz1yY2UzTtg5yzdaX0h5iUI42I
         9RiiudNkbYnkbf6zYphLhj3KGpW2ZDH5t/dKgCyHxve45qv03gNyB5um9Hjdu1npTm+z
         06nvM9ngASsSBxzy3CKyn08uH8WWT7JHTq61ctJj+Av0mAySfXP+0xijW2Z/SxWXkxrR
         ca44OGVxClHE3fmEu9HvHwHdTQOwJjG8BVrhD8+txsMGTgjCpChiW8Ow/xlkiwZVIOB+
         bUdqcT//4mvjwwRUTxrMbkoaagC7mxwXg+ONa79aVAmxQCA8djE0shaQtKyveYdxaIyI
         2ekw==
X-Forwarded-Encrypted: i=1; AJvYcCUhjkH2fH5OmLSX6y8AgtdBUGylkG+SomCE/vRd3G1/IkbEgObnu+mxdWHtnpZmTbKuEek=@vger.kernel.org
X-Gm-Message-State: AOJu0YwGI3xEvckAd6yVitOLqKvi30/MjpwaXHny73dhRNuUZpbmOysh
	e2B8isAqEjYP/kTfTrmPs3T+fkspcr+InoxCf+T45w08lCv1zJ08cGnuxwu6dxKD1xqDvuGHXRn
	MzaPkwBphXSP2jEWtwFJnHqaauZa9r6F58UHvQ6OIMq2aNScOgg76Pg==
X-Gm-Gg: ASbGncvs0Sgoy+qySYd/GPE8hJeTCNR/XK9uSLdodCT6x++PPUehVyX2vF7U1ti8Itx
	ptPUIrK5SwToRciiB5FTf+RgTU0cTWNhsiRIhZsA+zzVSj72dm/y9uXDzx6rO/rxjTGzusOjqmd
	Qn0/6WxZgyxr2Y/uh+3jX3ZXf9HJo65AzrJZk5U+RIzwILRdvODAABizAPIlsPJaRfeC+reoenC
	ftYLqHOGQE+9Gd1XyLmsSPorpbK7zVUnVM4jZtuKQPslFfgPFpI3/2WvAQk9RuiFY8GrneVbzYL
	k274njW2RMIH/EcwcDGgRpBwQtDk9C6Ly7AYQopu7vtDLWrVkM46YGEGjRi2MwFIrr5Fsr2mACw
	GdmzCIp3WqQswTR6a3syQoSUbfsKBTMA6td2FDzn23y5drE7OjcnRCBcf3LUlRDVK1aY=
X-Received: by 2002:a05:600c:6992:b0:43d:46de:b0eb with SMTP id 5b1f17b1804b1-45868c99c85mr30116305e9.12.1753283119423;
        Wed, 23 Jul 2025 08:05:19 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IE2F5mSqLZEunEzF7urtX2WBp8ykNV6oKnn0wFMx2cm8cOAKr3D8at2B+ii/3mueYJl1zKZiQ==
X-Received: by 2002:a05:600c:6992:b0:43d:46de:b0eb with SMTP id 5b1f17b1804b1-45868c99c85mr30113555e9.12.1753283117177;
        Wed, 23 Jul 2025 08:05:17 -0700 (PDT)
Received: from ?IPV6:2003:d8:2f00:4000:a438:1541:1da1:723a? (p200300d82f004000a43815411da1723a.dip0.t-ipconnect.de. [2003:d8:2f00:4000:a438:1541:1da1:723a])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3b61ca2cc06sm16564115f8f.35.2025.07.23.08.05.15
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 23 Jul 2025 08:05:16 -0700 (PDT)
Message-ID: <37a930a0-e1ba-4be7-8b0a-4fb5409131d4@redhat.com>
Date: Wed, 23 Jul 2025 17:05:15 +0200
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Content-Language: en-US
From: David Hildenbrand <david@redhat.com>
To: "linux-coco@lists.linux.dev" <linux-coco@lists.linux.dev>,
 "linux-mm@kvack.org" <linux-mm@kvack.org>, KVM <kvm@vger.kernel.org>
Subject: [Invitation] bi-weekly guest_memfd upstream call on 2025-07-24
Autocrypt: addr=david@redhat.com; keydata=
 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
 g3eXuA==
Organization: Red Hat
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

Hi everybody,

whoops, I almost forgot.

Our next guest_memfd upstream call is scheduled for tomorrow,
Thursday, 2025-07-24 at 8:00 - 9:00am (GMT-07:00) Pacific Time - Vancouver.

We'll be using the following Google meet:
http://meet.google.com/wxp-wtju-jzw

The meeting notes can be found at [1], where we also link recordings and
collect current guest_memfd upstream proposals. If you want an google
calendar invitation that also covers all future meetings, just write me
a mail.

To put something to discuss onto the agenda, reply to this mail or add
them to the "Topics/questions for next meeting(s)" section in the
meeting notes as a comment.

Cheers,

David

[1]
https://docs.google.com/document/d/1M6766BzdY1Lhk7LiR5IqVR8B8mG3cr-cxTxOrAosPOk/edit?usp=sharing


