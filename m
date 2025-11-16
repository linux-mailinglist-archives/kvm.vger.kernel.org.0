Return-Path: <kvm+bounces-63293-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [IPv6:2605:f480:58:1:0:1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id B84A5C61147
	for <lists+kvm@lfdr.de>; Sun, 16 Nov 2025 08:39:02 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 6B5A84EC4B1
	for <lists+kvm@lfdr.de>; Sun, 16 Nov 2025 07:37:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DC3E12874F5;
	Sun, 16 Nov 2025 07:36:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="GVxE7X4E";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="Qqh623P/"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 70402285041
	for <kvm@vger.kernel.org>; Sun, 16 Nov 2025 07:36:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763278596; cv=none; b=MHDcMeL/vvqt8hq0xh0yFjJzGm35PnWCxNZ57/E8YfSTJdqYueEtxhpj1seMrmaJhYVQJNXcE90aiaTS4yPHU+xGVxTK+jT+wJ0dWWpdEWwiSF48nyNT5GWbfThP2oHfOD8iq1qkbNA39TuMDUvzkX0h4vXPfAEh+FmExCRLYxc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763278596; c=relaxed/simple;
	bh=/wU2PjO/9k2SX10eUAJ2SEQukhtmpyHpHIXxtUzeWto=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=hqlDd2wyRiHgr8yehg7CXbh9gpbTO8rGu9+C+xAZx5mlRAKVl1N29344/UQzQfAcaharkycNWn/CLov6PSBUFifz36i4JzUICItVwUqrGtiCWBoc6Y6vdB5/k6KfCWC8ipzhSAv3Ji74LBBvQgFPkTCpTsf5Gbf62C/XB23tXGM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=GVxE7X4E; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=Qqh623P/; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1763278593;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type;
	bh=b0yaVDVgrAO7aUVp8P++ObXwpVxREDZ1FEXCsETlzo0=;
	b=GVxE7X4ENlScj1fJJahzREgc1flYEwPCrXSsSUeNvy0QILsMt+0JddfiskKjd3DpT1oE8n
	NKrzvPU+/m9j9FEaoul7a3Z96pY8d1GFpcf4ueURE5hIXy0RjSlWZsWEkKP7mKhN3kO0rd
	N0cUerxPlKjb6LorUF8ysMIgO2s9mSM=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-461-iBA69WxCN0WhxmN3JVbDRw-1; Sun, 16 Nov 2025 02:36:32 -0500
X-MC-Unique: iBA69WxCN0WhxmN3JVbDRw-1
X-Mimecast-MFC-AGG-ID: iBA69WxCN0WhxmN3JVbDRw_1763278591
Received: by mail-wm1-f72.google.com with SMTP id 5b1f17b1804b1-47797caba11so4749965e9.3
        for <kvm@vger.kernel.org>; Sat, 15 Nov 2025 23:36:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1763278591; x=1763883391; darn=vger.kernel.org;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :from:to:cc:subject:date:message-id:reply-to;
        bh=b0yaVDVgrAO7aUVp8P++ObXwpVxREDZ1FEXCsETlzo0=;
        b=Qqh623P/iRVGRWu89+BHV5Gz6faoTprK/wvT/Nz1c3adtOwfy445Us+QmfT5/NwgU0
         ATpEEAhUEbfALx6CXvgcsKvgMfrLqvsUN6Wit3XwBCV1qaeLwmYzTVj/9bocsMULpSvd
         Os+a9eNLZVyjkXFUnoG1Ni044Gf2rqNKM0LPHdDimvkbP93pqRXYWwtf4iVq93xiWS2Y
         DJ2m1E7gBptLha2YtuRgWAj+fyqK6w8pqO93nhq0+bRQB9zT+eoYPJtbc7kRhAoxZUKn
         iJH6i/Et+TptzS5Mrdq+IzzhhLCHbpOKbSKaPHzvujzv5YlksTT1Z47qzA5vSDB3fGbx
         Z3YA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763278591; x=1763883391;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=b0yaVDVgrAO7aUVp8P++ObXwpVxREDZ1FEXCsETlzo0=;
        b=uYCJx/afi0t870q4xj/qMd+MsteFjhdEXQHTMA8J71AKLSy2GtCfzuCq9zJZDbouv5
         QqjjiGjvakCEvTXmBa3YbhU+Ww1weiPTW2hKOj45LdyEnQ4DP3uk0KiD5A6i50OzIwL4
         z+LtFGhfBcGOCF6IJMcFXGN+gzqGPeKkwte8JbbOB6RaCXeAiEkAUARWsFDYVgQAepVg
         9mrz40/2BrPHNu/scJLYkmYE2Hblu/Y1Qw84Ec44RVV2AGi5CIlQ3ATl2FbT3iMaN+kj
         YcjF+95G4eNuyiqq1o+f2tUC+7SBJ451nfW4BkhebzbRbZPQav8m4d6zZWVA8fhcuOwy
         4tqA==
X-Forwarded-Encrypted: i=1; AJvYcCX3Uo38KG+JIN71LXx+vU9/RwQWPebzIbjBFb4a8J9bn1twDHpHpgKzPjdyR+YyD5VMElI=@vger.kernel.org
X-Gm-Message-State: AOJu0YzIxZzsb50941ln4bcbSvmowQ4aZHPjfw2ckRIzO50Jm5UE6pLr
	Q/pkggESqp/FrPmsQjs2+fhfneePeDbN+FejtISZBeozqWX6QOjfHSOvh7ZPBMP6QSyHuLfVO+I
	HrMGPMbgzyt3TJ+VA3or6R9633C1xgPnRbA6HAK0u7uM/iiO9xzqqMA==
X-Gm-Gg: ASbGncuKwS2u65jO6HsUuXS9ad+P/mAWZ6SezJicFLGB2sCC4df0EdM8wK4XmQI2V/N
	e4M8m1rVT8aikJ/PY85jRkkzzCCZoRJwBBkSd7ksvS9NuBLFr0iGPPG51Y8MakgJh8ZbpwFOx43
	hucayE5zX1Glm5b2BjkUs2McyyFG17Ekeovbjvaacd7wxLUlUcXBAA0uw+0dAUF+UwO7IPFDbZs
	GJ58fw9epuFgMGl3iuaztyY5a9TW/YhbuPfm9QhbeLGJ9kDrtgpXbwGGqaUcRliQLdC0hW+7r+n
	T3mGdJ8xEkx7D+b+i1Qx7WaDP0b/CrLcz5AJnUGfwK+xQdHOuSfzQi1akTpMgYZDIKVdQVMZaJa
	5cmSqCI1DJSaFc8TCUeM=
X-Received: by 2002:a05:600c:4744:b0:46e:48fd:a1a9 with SMTP id 5b1f17b1804b1-4778fea8ab2mr86716305e9.33.1763278590825;
        Sat, 15 Nov 2025 23:36:30 -0800 (PST)
X-Google-Smtp-Source: AGHT+IHqZuOeT1wAABazsJ0HksCXcwMYVBBLygHfL8/xmHfq4axK6seTI4Hh3FvYH1PcGLCWD6fslw==
X-Received: by 2002:a05:600c:4744:b0:46e:48fd:a1a9 with SMTP id 5b1f17b1804b1-4778fea8ab2mr86716095e9.33.1763278590441;
        Sat, 15 Nov 2025 23:36:30 -0800 (PST)
Received: from redhat.com (IGLD-80-230-39-63.inter.net.il. [80.230.39.63])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-47796a8a695sm79746965e9.13.2025.11.15.23.36.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 15 Nov 2025 23:36:30 -0800 (PST)
Date: Sun, 16 Nov 2025 02:36:27 -0500
From: "Michael S. Tsirkin" <mst@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Andrew Lunn <andrew@lunn.ch>, Paolo Abeni <pabeni@redhat.com>,
	Jason Wang <jasowang@redhat.com>,
	Eugenio =?utf-8?B?UMOpcmV6?= <eperezma@redhat.com>,
	Xuan Zhuo <xuanzhuo@linux.alibaba.com>,
	Jonathan Corbet <corbet@lwn.net>, kvm@vger.kernel.org,
	virtualization@lists.linux.dev, netdev@vger.kernel.org,
	linux-doc@vger.kernel.org
Subject: [PATCH v3 0/2] virtio: feature related cleanups
Message-ID: <cover.1763278093.git.mst@redhat.com>
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

changes from v2:
- drop unnecessary casts
- rework the interface to use array of bits not
  arrays of qwords

Michael S. Tsirkin (2):
  virtio: clean up features qword/dword terms
  vhost: switch to arrays of feature bits

 drivers/vhost/net.c                    | 44 ++++++++++++++------------
 drivers/vhost/scsi.c                   |  9 ++++--
 drivers/vhost/test.c                   | 10 ++++--
 drivers/vhost/vhost.h                  | 42 +++++++++++++++++++-----
 drivers/vhost/vsock.c                  | 10 +++---
 drivers/virtio/virtio.c                | 12 +++----
 drivers/virtio/virtio_debug.c          | 10 +++---
 drivers/virtio/virtio_pci_modern_dev.c |  6 ++--
 include/linux/virtio.h                 |  2 +-
 include/linux/virtio_config.h          |  2 +-
 include/linux/virtio_features.h        | 29 +++++++++--------
 include/linux/virtio_pci_modern.h      |  8 ++---
 scripts/lib/kdoc/kdoc_parser.py        |  2 +-
 13 files changed, 114 insertions(+), 72 deletions(-)

-- 
MST


