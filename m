Return-Path: <kvm+bounces-33510-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 8F8FF9ED76C
	for <lists+kvm@lfdr.de>; Wed, 11 Dec 2024 21:45:58 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 2056E283B1A
	for <lists+kvm@lfdr.de>; Wed, 11 Dec 2024 20:45:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D76ED20B81C;
	Wed, 11 Dec 2024 20:45:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="N6X/DBR/"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 32AFB1BC085
	for <kvm@vger.kernel.org>; Wed, 11 Dec 2024 20:45:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733949951; cv=none; b=ie0+9zbcGN/NPdUNPeE+7Gpsm5xQ5ww7gLj2/CxI3VTnV51j9w6KUrZS9RCSZHOhMAIhmnFzMWvY3pd+gxAMbiUA0cU/V1e+ISZL0hpbGs9D02hnwnrUWidoTdLiQj3Z8xiEhr79tgSjUAeqI9IEjOP96snmG4zrlO8Xgcvrpc8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733949951; c=relaxed/simple;
	bh=x11F6rsThuI7COdxwbMUMCu//GFFQp6yj2Nz/5ckHOs=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type; b=LSeKJRsW1Ge98xy/NqSzWIDwWG4L8LrH5SK88g1WVqCrjX0QOXsnJkHZXwo5HAQjc7eZ7OxemDqaO3uHIiEpVTbbyUx6c0GK0CEcYEYLRMaCeAf58fTU5WjQ71EjK382VwPKhn4mlssh/mnnh8/H/hmlTpJcC/a3F7o0Zo9JAY8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=N6X/DBR/; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1733949948;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=UyMoM9bjZ04mHDYoi6wDKE6GsVPbRehJbv3JnFdeW/o=;
	b=N6X/DBR/KETaFzgcGqmVVqP50kl7VXatKzy8NWzWufP8seUORwK9vn7fNssOUMJb/pK+rV
	TiVy0EnkSSNOLe3JKiVR0AVLe0mITdeInzFTSAzWSgRs2U/8odL44vfP9NEKw9dhmOtuTR
	NhzV5Q8cnSsuVPcL1cRH0Ho4R5DKGnQ=
Received: from mail-io1-f71.google.com (mail-io1-f71.google.com
 [209.85.166.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-342-vbhgswbMMQeMOXyFqk-5Fg-1; Wed, 11 Dec 2024 15:45:46 -0500
X-MC-Unique: vbhgswbMMQeMOXyFqk-5Fg-1
X-Mimecast-MFC-AGG-ID: vbhgswbMMQeMOXyFqk-5Fg
Received: by mail-io1-f71.google.com with SMTP id ca18e2360f4ac-844ca9b7233so22083539f.3
        for <kvm@vger.kernel.org>; Wed, 11 Dec 2024 12:45:46 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1733949946; x=1734554746;
        h=content-transfer-encoding:mime-version:message-id:subject:cc:to
         :from:date:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=UyMoM9bjZ04mHDYoi6wDKE6GsVPbRehJbv3JnFdeW/o=;
        b=Kk1uHnD/Tu+TlQ6CawvzW7MgGlAmNGKdF3QGIMmv8OHDS226BZnCaRVde99Imrx83e
         dOw6FClcPRGVPX2rV3mToUQUyEq0uP1EwOIsrT+gpS/69xAvBRxS672FragO9nqqG9kE
         S4jdPcMToW+zrjpgw6Va2EC3oS1W1aVz5rxmxzA9Ls5degqER4gobwhVJVaA2V9l0DAp
         aXSM1wslNAzZLH50XWM6mgC58nXJNAGUNIVn/Iolh0cG1U8+st0UNFSaBpofk2ilCAvz
         kyYvl0gC7ISYepUCqCl9UtPoeTKxTrQS2Rzo4GB3OnhSUVsh3zD0j1NK8VDjOqFbrKdz
         kmSA==
X-Forwarded-Encrypted: i=1; AJvYcCXlJ/YsQsMGV42vpb3U+oaSmNAk7j0I5D/V60KSWbqpEJ18h+BWKAvx1UsFyd3TUuAJ/Z0=@vger.kernel.org
X-Gm-Message-State: AOJu0Yy+DvsuCnlOCX/wA8Icmyzg0dbFGyAf10N/V7qAVn0kQDv7d2Gm
	/k8OtagBEOmOydizJhlUA0mycaN8Dews66FXUwBh3KhxCZXXFHE3NJH41wl79UZJYBk1zRXZh9I
	2OmMEpyj+jS+TXFFLdW/OT9DFTV3zxHWjvJMgSC/RnfAgwMOO7A==
X-Gm-Gg: ASbGncueCKVeAVUczFCVNn73dF/k9P/KFJYD6XMulhhmLbTe3WLo55SaFEY54JIeHCJ
	AE1JVQxob+2FtGUsBp0yq85IVswMzi5ZPOp+xAxp1ySYZCfUrHibKxqH4xJ6BQ+Y8VKsV8k/1Sd
	2vUnko+KyeYrQ6eISnOivZHT1KGbOsWa4vAECwvhftBzDuD2FFpDKy2RA2gImlTmAfJtzLHydHK
	5NtGWSI+PTJdwCzPUfBXxEGvf/UckpAeeqbougbtvhWXe3EOJ6Kc+fgSQ==
X-Received: by 2002:a05:6e02:1d1e:b0:3a7:bd4c:b17e with SMTP id e9e14a558f8ab-3ac4166f178mr3035335ab.0.1733949945926;
        Wed, 11 Dec 2024 12:45:45 -0800 (PST)
X-Google-Smtp-Source: AGHT+IHxWrkTgdBRegPreVCTs6CWNouMMcQJGsW+xbyXyWDuRP4He8ysmi1RzcbKSB8OX3c/jOYU1w==
X-Received: by 2002:a05:6e02:1d1e:b0:3a7:bd4c:b17e with SMTP id e9e14a558f8ab-3ac4166f178mr3035265ab.0.1733949945622;
        Wed, 11 Dec 2024 12:45:45 -0800 (PST)
Received: from redhat.com ([38.15.36.11])
        by smtp.gmail.com with ESMTPSA id e9e14a558f8ab-3a9cc5bf7b4sm23524695ab.72.2024.12.11.12.45.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 11 Dec 2024 12:45:45 -0800 (PST)
Date: Wed, 11 Dec 2024 13:45:43 -0700
From: Alex Williamson <alex.williamson@redhat.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: <linux-kernel@vger.kernel.org>, "kvm@vger.kernel.org"
 <kvm@vger.kernel.org>, Yishai Hadas <yishaih@nvidia.com>
Subject: [GIT PULL] VFIO fixes for v6.13-rc3
Message-ID: <20241211134543.715454ea.alex.williamson@redhat.com>
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

The following changes since commit 40384c840ea1944d7c5a392e8975ed088ecf0b37:

  Linux 6.13-rc1 (2024-12-01 14:28:56 -0800)

are available in the Git repository at:

  https://github.com/awilliam/linux-vfio.git tags/vfio-v6.13-rc3

for you to fetch changes up to 9c7c5430bca36e9636eabbba0b3b53251479c7ab:

  vfio/mlx5: Align the page tracking max message size with the device capability (2024-12-05 11:56:01 -0700)

----------------------------------------------------------------
VFIO fixes for v6.13-rc3

 - Fix migration dirty page tracking support in the mlx5-vfio-pci
   variant driver in configurations where the system page size exceeds
   the device maximum message size, and anticipate device updates where
   the opposite may also be required. (Yishai Hadas)

----------------------------------------------------------------
Yishai Hadas (1):
      vfio/mlx5: Align the page tracking max message size with the device capability

 drivers/vfio/pci/mlx5/cmd.c | 47 +++++++++++++++++++++++++++++++++------------
 1 file changed, 35 insertions(+), 12 deletions(-)


