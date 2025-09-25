Return-Path: <kvm+bounces-58714-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 7A7B0B9D851
	for <lists+kvm@lfdr.de>; Thu, 25 Sep 2025 08:04:45 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id A62151BC118D
	for <lists+kvm@lfdr.de>; Thu, 25 Sep 2025 06:05:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C1A412E7BB3;
	Thu, 25 Sep 2025 06:04:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="hddF+tjk"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 553DA2E6CCB
	for <kvm@vger.kernel.org>; Thu, 25 Sep 2025 06:04:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758780264; cv=none; b=gIN+mDwdWvOCIER9yeGx4zvEm5XgHkjjERfqzoG4zJJp2RcNYtQuci3fVrzx+OG+UrUkVZNqekLeNhTI8UAYu0/1acJ7Reu86ASacKc4vbTvF9SMIFTAIIBA7hrLqFd8KJZLPzaNGWgXN2b5hohlzcxlt+vw4cms5KF2WT7X93Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758780264; c=relaxed/simple;
	bh=o0VNqoePQ9Fxc7vePL+KVWDFK3PNoSh+8m9moiHOP0E=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=hpsbBQlDRgfTCu5XdyXpyu7PgEkGgPxw67LdUzcHEBUAbsaBJ9gvenxmVEfrtZgCrIil9uP9ykGZQqr7rymGHppG46nyUSUKWwuvqhBxJQyWevotQsDXstrZ9KW3DqDZ3StoqIuOwIkQkY/25oMztY9vS/1qNqVuw8QmfI1GDYQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=hddF+tjk; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1758780259;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type;
	bh=aFGTlM/AfVM6UoD7+6D0K+JKl8i8C5klHuPNmVycESE=;
	b=hddF+tjkvXa9V9wLegZHVDQXStTTCN2W3YTQxQQjB4sdo8Pyjwn0bv3f6dk7CjKe6cjV5O
	ge37qLRCYfRsedShoAxs6fr2/5jpMFmIaqaZBY2cCg4vRpWqbS6Q4nOs30FCkgmYYFr167
	+8B+dL+NjeE846rK6zevoalV7QzBKY8=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-34-QhTsRZaUOpubcD2X41qIWQ-1; Thu, 25 Sep 2025 02:04:12 -0400
X-MC-Unique: QhTsRZaUOpubcD2X41qIWQ-1
X-Mimecast-MFC-AGG-ID: QhTsRZaUOpubcD2X41qIWQ_1758780251
Received: by mail-wr1-f71.google.com with SMTP id ffacd0b85a97d-3ecdf7b5c46so324311f8f.2
        for <kvm@vger.kernel.org>; Wed, 24 Sep 2025 23:04:12 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758780251; x=1759385051;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=aFGTlM/AfVM6UoD7+6D0K+JKl8i8C5klHuPNmVycESE=;
        b=cQljlm4oNLRzhyiQK5Zm/Z8hOb0o2czaJtSBG+DbQZBMO4iVDLqrpWFdr7FmYlzf/d
         aVS5IpFj0jiWxtOoMfGPs/YZi39AuatZfKx7LVE9Jqo5XnGbCZ44VT1a45o9XCg7IAy7
         AeS6li4U4IYCLRWT/eBixwDSb6d8XoyDeRtljjcZtp2bOr3TEgRfeoTefosHxnBlEcDu
         czfMDF0uAWqXXG63vxkZfD2mi2B+UnQEI+SRUtkddESo4/CWa13zMPQd18VrylZYlvsR
         EcIJCTo5Q94V2Z+0mbQxWtanoxv5nFbHZdgKM/DSeNMbs79xtwSIEl3rQmsQi5F9jjsf
         QaLg==
X-Forwarded-Encrypted: i=1; AJvYcCUv7bs5H/jxEg5sFEAe8h1VjVL6EP0K0bX7Rm3b+23NLr1Mhph8qZ//ZZn4ZJOVHA36Tbo=@vger.kernel.org
X-Gm-Message-State: AOJu0YyhMEH/dS+LrkuhkLp4ZC5xSltZFWH0Y9KBqoi0tqzAIO1ktLy4
	Q5MYwrtNOZQD0NuEcA+AyVVGJ1kViCvEIkwcpyAu50GnYKSk1/7rBHxOjP3vaUjvw+L/X6K09P+
	UIJrnUES0lMiGzTpxHLQdO2vdfzL6z3DUnuN34ahcKvo/RvyITVVL7w==
X-Gm-Gg: ASbGncv/Aww5z3vijVcrw4qJQj7Z+INTEBFzzqDGK60Vr3jUTNgY9YUDmPwzzjUUCsA
	I/bpwkPSG3Z+oIyOXJub9dltdKgrn7QOzfv9ou9pRie16NxzJ/U6KMKpl2C3brr/OPynWVzZ45U
	a/7z4MkPADykb8rQPzTn3eW6tsWlxw5LTC6O5BpM8fvcVJUv8VJjMVd7HqSVXpa08ADG3DAPRiy
	p7+ClgxkT7AdamNeaF98oWjR8kLuILZ1hiy1aEFQxbOl3Dvo/Pck6tA+94qGJvKaY58wTNaNPwR
	uTN00LtIinMWsGYkxYGbRDZpUL5CY4W1TA==
X-Received: by 2002:a05:6000:2912:b0:3eb:f3de:1a87 with SMTP id ffacd0b85a97d-40e49e725f0mr2176048f8f.56.1758780250920;
        Wed, 24 Sep 2025 23:04:10 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEzXROWH0HheOoR3C9U+J8DhuDXRcMrs5JaiB8XcConfDaf/URbl6oeL/NMdqI1Vf+S1XrqWA==
X-Received: by 2002:a05:6000:2912:b0:3eb:f3de:1a87 with SMTP id ffacd0b85a97d-40e49e725f0mr2176012f8f.56.1758780250483;
        Wed, 24 Sep 2025 23:04:10 -0700 (PDT)
Received: from redhat.com ([2a0d:6fc0:1538:2200:56d4:5975:4ce3:246f])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-40fc5603365sm1463946f8f.37.2025.09.24.23.04.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 24 Sep 2025 23:04:09 -0700 (PDT)
Date: Thu, 25 Sep 2025 02:04:08 -0400
From: "Michael S. Tsirkin" <mst@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: zhang jiao <zhangjiao2@cmss.chinamobile.com>,
	Jason Wang <jasowang@redhat.com>,
	Eugenio =?utf-8?B?UMOpcmV6?= <eperezma@redhat.com>,
	kvm@vger.kernel.org, virtualization@lists.linux.dev,
	netdev@vger.kernel.org
Subject: [PATCH net] vhost: vringh: Fix copy_to_iter return value check
Message-ID: <cd637504a6e3967954a9e80fc1b75e8c0978087b.1758723310.git.mst@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Mailer: git-send-email 2.27.0.106.g8ac3dc51b1
X-Mutt-Fcc: =sent

The return value of copy_to_iter can't be negative, check whether the
copied length is equal to the requested length instead of checking for
negative values.

Cc: zhang jiao <zhangjiao2@cmss.chinamobile.com>
Link: https://lore.kernel.org/all/20250910091739.2999-1-zhangjiao2@cmss.chinamobile.com
Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
---
 drivers/vhost/vringh.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/vhost/vringh.c b/drivers/vhost/vringh.c
index 0c8a17cbb22e..925858cc6096 100644
--- a/drivers/vhost/vringh.c
+++ b/drivers/vhost/vringh.c
@@ -1162,6 +1162,7 @@ static inline int copy_to_iotlb(const struct vringh *vrh, void *dst,
 		struct iov_iter iter;
 		u64 translated;
 		int ret;
+		size_t size;
 
 		ret = iotlb_translate(vrh, (u64)(uintptr_t)dst,
 				      len - total_translated, &translated,
@@ -1179,9 +1180,9 @@ static inline int copy_to_iotlb(const struct vringh *vrh, void *dst,
 				      translated);
 		}
 
-		ret = copy_to_iter(src, translated, &iter);
-		if (ret < 0)
-			return ret;
+		size = copy_to_iter(src, translated, &iter);
+		if (size != translated)
+			return -EFAULT;
 
 		src += translated;
 		dst += translated;
-- 
MST


