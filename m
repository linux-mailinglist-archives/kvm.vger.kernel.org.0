Return-Path: <kvm+bounces-45965-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 09A8BAB01CE
	for <lists+kvm@lfdr.de>; Thu,  8 May 2025 19:51:30 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 125F43AE48D
	for <lists+kvm@lfdr.de>; Thu,  8 May 2025 17:51:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 37982286D4A;
	Thu,  8 May 2025 17:51:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="CSui1x8y"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C61FA2139D8
	for <kvm@vger.kernel.org>; Thu,  8 May 2025 17:51:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746726679; cv=none; b=Qh6PQV3yXpmodVzVoXfWFvOzIgePNkO332SZTngWk96Z+sl4UIc/8mpH5DK7Og8bjGILoDRyu2yfhtWxmlA6IDVHubMvwLZ7wjqz+ZWcEOqt/ar8q/tf8TC09Wn2+U6NN3fcYGIK0HzkHnvNBtgZ05fHPBmQ3RhaIeSksbcxU6Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746726679; c=relaxed/simple;
	bh=nssSBeCkXHTHuH7oP/DIiP3G47FdBuIT9jFk4RFLUoQ=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type; b=CXTnNHg+PI/msVP3S6Io/ULB3eGVp9AlCa7wpA4qviyRu/M8Un9pKv3LvEQtSS+MorAR4E+JMlqos1QlCu0k0MFqq/U9Wmd23+ka0CsvWwtFTMb+rDB3ryrSYos56KfgX2hN249EsOWTg3JkJSoXqrcGdz2TjpAsLQc18k4qzZc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=CSui1x8y; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1746726676;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=H7pvuB9Kat/lENMiaug5ERD4iLY8+Gw9do+INRaXLYY=;
	b=CSui1x8y7e1/vOt+oymXSM3TRSgBn17AI1v62/JYPXwlwBF4WU2YkoXzr6tPkCHTJ3gWtL
	EFIoZ1g0fH29l3U9e2zo7hy6i3GM7l5k+JcqeRhlwFJPN8oyIrXjbANEiMKiguQxwiVKj/
	rCBT6qVyakj1Zikt74sBieKvEW3rLbA=
Received: from mail-io1-f71.google.com (mail-io1-f71.google.com
 [209.85.166.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-74-qTIKZyPrO3uK4GR8sCzIDQ-1; Thu, 08 May 2025 13:51:15 -0400
X-MC-Unique: qTIKZyPrO3uK4GR8sCzIDQ-1
X-Mimecast-MFC-AGG-ID: qTIKZyPrO3uK4GR8sCzIDQ_1746726674
Received: by mail-io1-f71.google.com with SMTP id ca18e2360f4ac-85b4d893399so4058539f.2
        for <kvm@vger.kernel.org>; Thu, 08 May 2025 10:51:15 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1746726673; x=1747331473;
        h=content-transfer-encoding:mime-version:message-id:subject:cc:to
         :from:date:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=H7pvuB9Kat/lENMiaug5ERD4iLY8+Gw9do+INRaXLYY=;
        b=j+aoynmbLhXpBKKKEvr+qGu7jt8e/yvJgdzukOEGj6+uq+HCcGai4jRRKocmit1RTY
         Z6ciDcHCZdJFA6Lv9IM+l2Z9C3VTf0HzVNskkS5iTOUEuNOaP+NclIn83CowyvV7SAk/
         Hp+/2VxoF2XGw9rM+FIiVGwO6/CxekxDNcoodw179kSYlEx2Pt+7u8ItTrRN8W4RVRLJ
         IbxOGz5GjxmPXEk0Cb1geFeRX/5ybpQCdaiEVCjalIf4NDp8Z1lYU7zuGEH7rKwSPX4O
         7G82Ed/+7mGQVqawhf1LR9j7eTcXuHwYGXYy2JQsOJyENCWEXNsCnhDVcf3TzfG3lhzZ
         CDKA==
X-Forwarded-Encrypted: i=1; AJvYcCU4beejHvZgmwxJ6arzOoR8tXFD+HtWiLd+tlpF9Z9fOtLA3Q3AHB368yZs72X72oLOqyA=@vger.kernel.org
X-Gm-Message-State: AOJu0Yw7E1jwo2GqT8pRRhqUJRg8DqSdfUV8WX0krX02V91Pe9AvBIz9
	vU+tByg8kX/IVeGs54xIWUFMGemvAkA/KhQXKE89oS2owdlkAlUA4Lh+6o0VGglp4uQeyylGqGO
	t5msXXbnWhDoenwwE5HQCOd48YusSb6gx1JJqsRVLaPAFzuERK3ZtVSlDGw==
X-Gm-Gg: ASbGncvMZD3UPKvTWbiAzFPS7xgckc5diTSzb5aOU7LGZmHnuMVwd9kfjj+EgdYdP5u
	hbQ3RX9c8eDeHR+fi4RdkUWRJKQrWPV6JQ/DwMx6Sju+PHcb6ACQRi+9RvEw2I0bKUpu6YlQRvx
	RPGHtpAfNUQUV42Kbv2g+AQwkmoI6CnohSp44PBxLn3jg8TinjybCCZd/eHxxRmxhKYpfkKAkaG
	ODlxhKnhHQTV1rp5Bmgg5IQuDNYC0RwFr0Wx/uvqvAYrt+XgZCma+5/JorT1EYmB3zuvm5V5J0B
	QcdbjU0b9Pnd1oA=
X-Received: by 2002:a05:6602:2dd5:b0:85a:fd80:df2b with SMTP id ca18e2360f4ac-86763541687mr21930639f.2.1746726673325;
        Thu, 08 May 2025 10:51:13 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHkQt9myXVwB7o8pNg5TdGwRTEQjZSHkXMWZXuNibUqf0c2zhrB2WfJ9C26jKFu4Cg7bvroow==
X-Received: by 2002:a05:6602:2dd5:b0:85a:fd80:df2b with SMTP id ca18e2360f4ac-86763541687mr21929939f.2.1746726672993;
        Thu, 08 May 2025 10:51:12 -0700 (PDT)
Received: from redhat.com ([38.15.36.11])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-4fa2250348bsm63280173.55.2025.05.08.10.51.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 08 May 2025 10:51:12 -0700 (PDT)
Date: Thu, 8 May 2025 11:51:10 -0600
From: Alex Williamson <alex.williamson@redhat.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: <linux-kernel@vger.kernel.org>, "kvm@vger.kernel.org"
 <kvm@vger.kernel.org>
Subject: [GIT PULL] VFIO update for v6.15-rc6
Message-ID: <20250508115110.5ac2ee95.alex.williamson@redhat.com>
X-Mailer: Claws Mail 4.3.0 (GTK 3.24.43; x86_64-redhat-linux-gnu)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

Hi Linus,

The following changes since commit 92a09c47464d040866cf2b4cd052bc60555185fb:

  Linux 6.15-rc5 (2025-05-04 13:55:04 -0700)

are available in the Git repository at:

  https://github.com/awilliam/linux-vfio.git tags/vfio-v6.15-rc6

for you to fetch changes up to c1d9dac0db168198b6f63f460665256dedad9b6e:

  vfio/pci: Align huge faults to order (2025-05-06 12:59:12 -0600)

----------------------------------------------------------------
VFIO update for v6.15-rc6

 - Fix an issue in vfio-pci huge_fault handling by aligning faults to
   the order, resulting in deterministic use of huge pages.  This
   avoids a race where simultaneous aligned and unaligned faults to
   the same PMD can result in a VM_FAULT_OOM and subsequent VM crash.
   (Alex Williamson)

----------------------------------------------------------------
Alex Williamson (1):
      vfio/pci: Align huge faults to order

 drivers/vfio/pci/vfio_pci_core.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)


