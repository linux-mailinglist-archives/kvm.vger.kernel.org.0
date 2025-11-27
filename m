Return-Path: <kvm+bounces-64828-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ams.mirrors.kernel.org (ams.mirrors.kernel.org [IPv6:2a01:60a::1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id 4F957C8CF06
	for <lists+kvm@lfdr.de>; Thu, 27 Nov 2025 07:41:08 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ams.mirrors.kernel.org (Postfix) with ESMTPS id 6DBE534EA45
	for <lists+kvm@lfdr.de>; Thu, 27 Nov 2025 06:41:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5654D31352B;
	Thu, 27 Nov 2025 06:40:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="PzIlZMvX";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="qaRbcBwi"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C0A1F30B51A
	for <kvm@vger.kernel.org>; Thu, 27 Nov 2025 06:40:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764225637; cv=none; b=K+Egj9A9a13i0XwU6EO3hnK5vuDBMI55DRkjzg2sl6UuqsvXVF5wx9VaKhPHn/VpJNL1dOCakwddzAgn2wJF07aJzpy5ZAhtnIaJceOPlmJQDwHBQkSlaz9CM+SjxuvZ/+OhsLDsWi6gSyhktiQEEc5OZ9m/zNj1W1tIf82LwKg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764225637; c=relaxed/simple;
	bh=xBu9C98zr/V8IIqIfOuYV/Prmm6s8GMzcQJGTf+3eXY=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=HmMoytbDxKJmO6dWH4FbDNm/wEZMQaiwBLNl0sESz5GwgdB23wyZG/dlz0n5thLBpgtyG0v7pKBlHqOx+Zkxv2KL+mjjCgDT8lx8RI8cMv4WACaJnauAnfT9c2S0d4niZUjPa49Ycls/UFTTGBioAJ+HlX/RGIel7fdO5AulI1M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=PzIlZMvX; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=qaRbcBwi; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1764225634;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type;
	bh=wuT94p1p5YoZPXiJ9LxCEueq/01SlG2osUN2E2cz8Ic=;
	b=PzIlZMvX8qb8l+Nw6ziw9yMj49wY7fiVf+jqGP6AC/10SoMXRNic+SuZX1V1AKJ9eWWeeK
	56BFGFglBb2d/pT2DYSsQnW8nNf6wxg+HVIysG75rxAKfTj8LxM3PNEVgydP2HRuztO96D
	AwgVGM4AbfleVjH5MB5Hl8RQi+Foj/4=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-251-Xd0tu7CKM4aimELTnC_Mog-1; Thu, 27 Nov 2025 01:40:32 -0500
X-MC-Unique: Xd0tu7CKM4aimELTnC_Mog-1
X-Mimecast-MFC-AGG-ID: Xd0tu7CKM4aimELTnC_Mog_1764225631
Received: by mail-wm1-f70.google.com with SMTP id 5b1f17b1804b1-477964c22e0so2903975e9.0
        for <kvm@vger.kernel.org>; Wed, 26 Nov 2025 22:40:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1764225631; x=1764830431; darn=vger.kernel.org;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :from:to:cc:subject:date:message-id:reply-to;
        bh=wuT94p1p5YoZPXiJ9LxCEueq/01SlG2osUN2E2cz8Ic=;
        b=qaRbcBwii+olRp/ACl+F6Nhfm90dGGEjdgyoZVKmuVYpuOP8b6Ur+yYcHnGvxfZYmz
         lUblTXrA0JISONiiJCfMWO8uEy20wHLoad+xr/X3B/ExWStCvqQTmGq4pw5FcFymliyJ
         PMpDHn/8JGd/GJddM2J7imd5GUCp4dLZDMiWsOPhaNG4e3rdwrdQzWHul4NlYjvwXTCD
         L+S4l5ONJmA/Qvk4AKMWFGwkIPYZiJxDqAj67vixnOjU9m9FeMbzKccrpLkZr9Qv9FvG
         UwnhZRizX6ej+BWMj913o5jsLtNJRo4NR99XvbBCfSvuFWtNM0zpVOSySG09FTMyWyZ/
         nZiA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764225631; x=1764830431;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=wuT94p1p5YoZPXiJ9LxCEueq/01SlG2osUN2E2cz8Ic=;
        b=bIoJiu+lGkXRmKzDFIgaO3yl5FDeVpG2IiNvY3SayaeoKen1kBGeAysSBz+64RSHY4
         jDoj8BH+n0yO3VeYA9bYq5+9kSCi0GHb/GmPMlnP03zFPUXQYC33UXqji/kf9Aet9/hQ
         mszpHJD0ahZTUvUeGZ43H/gIqm3jmrwdqTlyFAHb2hBbQmC2mqDzMvhfkZ7agb8+Cr/f
         8nXvKAVf7Kt+gvvJlMYorjq6KeYvsukJYvA2mOos2XZwr7oa6CwsK2Li7P8vGfOwz9Wj
         /+DegG1yGPZzWvaiTdBnbIk5y+8b5yzSIgX7QCZJBROcJ2tPDTkJlKlj/7Jt6jK9YMOI
         2rfQ==
X-Forwarded-Encrypted: i=1; AJvYcCXxy8md4/xrj8UD81/p23q9Qp94oYHFCeZn0thh7IgHggngkfMXvHRbve0l2oTaKIjAwYw=@vger.kernel.org
X-Gm-Message-State: AOJu0YyPd9vY4l4+KCfZV7AFeUUv5jHbXp21kONEwIidyOlxKEkqWXNV
	FwIMKAn3sgIuqytKd05xlk5rfOxtE/3yf658ETZhHM2qnad2a/VOZL3yrvoWSBO2hZoxi44+ta3
	c6wTPgAlVxaizf092F1ST2LG0lMV0ABNq3DRsrIn8E4jx+bEocZgQvsSckPwxhA==
X-Gm-Gg: ASbGncs4Gxy2/V67NzRjgYJPVTrDYoiRsek+p3smLvzwmZZMH8B8D8J/1JRAh2MU1sk
	0mV/YgfJmn+t3CT+PvYujeAJzb6T3L5wDj3c8Ee1H2y/pl9avIixAXC+kPEwu74+uW4C+dayMfr
	rdk7KIKi1se2+82PhJTu41kagyl7Fteh8YizLjqPpGzTFeCVAFQAilIjrm+fpKoVu0HtgxBDQ3U
	As3F76WoL6ScUhssOMlOLWie4xIC7irxQTVsrbZvNu0wC/vdDlTtdMXk440jMm6zAjN5wLGQnQZ
	/2pKmAZ2RUYyvZhFWHQ5ba+0tPbEvyrCXkWgbrkWlkT4pSxTmuOdNMQnrT9E0BIGzkoMnHDVsxp
	jaQ1w/PO9ClCdN3Ou/rDSu72fZouMPQ==
X-Received: by 2002:a05:600c:1f85:b0:471:793:e795 with SMTP id 5b1f17b1804b1-477b9e61f7cmr222173695e9.0.1764225630962;
        Wed, 26 Nov 2025 22:40:30 -0800 (PST)
X-Google-Smtp-Source: AGHT+IF76KdhGXjY5ZtkUCvZbpceqilnQQdcgRmkvzsAfI7e3ekqqLFi6fdFkjz6br0cokEu+iwVsw==
X-Received: by 2002:a05:600c:1f85:b0:471:793:e795 with SMTP id 5b1f17b1804b1-477b9e61f7cmr222173475e9.0.1764225630563;
        Wed, 26 Nov 2025 22:40:30 -0800 (PST)
Received: from redhat.com (IGLD-80-230-39-63.inter.net.il. [80.230.39.63])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4790b0cc186sm76113625e9.13.2025.11.26.22.40.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 26 Nov 2025 22:40:30 -0800 (PST)
Date: Thu, 27 Nov 2025 01:40:28 -0500
From: "Michael S. Tsirkin" <mst@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Andrew Lunn <andrew@lunn.ch>, Paolo Abeni <pabeni@redhat.com>,
	Jason Wang <jasowang@redhat.com>,
	Eugenio =?utf-8?B?UMOpcmV6?= <eperezma@redhat.com>,
	Xuan Zhuo <xuanzhuo@linux.alibaba.com>,
	Jonathan Corbet <corbet@lwn.net>, kvm@vger.kernel.org,
	virtualization@lists.linux.dev, netdev@vger.kernel.org,
	linux-doc@vger.kernel.org
Subject: [PATCH v6 0/3] virtio: feature related cleanups
Message-ID: <cover.1764225384.git.mst@redhat.com>
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



Cleanup around handling of feature bits:
- address word/dword/qword confusion
- simplify interfaces so callers do not need to
  remember in which 64 bit chunk each bit belongs

changes from v5:
  rename variables in vhost to make the diff much smaller
changes from v4: address comments by Jason
  move features variable to beginning of block
  unsigned long -> u64 - they are not the same
changes from v3:
  drop an out of date unnecessary kdoc parser change

changes from v2:
- drop unnecessary casts
- rework the interface to use array of bits not


Michael S. Tsirkin (3):
  virtio: clean up features qword/dword terms
  vhost/test: add test specific macro for features
  vhost: switch to arrays of feature bits

 drivers/vhost/net.c                    | 29 +++++++++---------
 drivers/vhost/scsi.c                   |  9 ++++--
 drivers/vhost/test.c                   | 10 ++++--
 drivers/vhost/vhost.h                  | 42 +++++++++++++++++++++-----
 drivers/vhost/vsock.c                  | 10 +++---
 drivers/virtio/virtio.c                | 12 ++++----
 drivers/virtio/virtio_debug.c          | 10 +++---
 drivers/virtio/virtio_pci_modern_dev.c |  6 ++--
 include/linux/virtio.h                 |  2 +-
 include/linux/virtio_config.h          |  2 +-
 include/linux/virtio_features.h        | 29 +++++++++---------
 include/linux/virtio_pci_modern.h      |  8 ++---
 12 files changed, 104 insertions(+), 65 deletions(-)

-- 
MST


