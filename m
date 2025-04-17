Return-Path: <kvm+bounces-43589-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 50964A92B80
	for <lists+kvm@lfdr.de>; Thu, 17 Apr 2025 21:10:11 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id BDA261B607BF
	for <lists+kvm@lfdr.de>; Thu, 17 Apr 2025 19:10:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C642C1F8725;
	Thu, 17 Apr 2025 19:10:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="f/6ZUIR1"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 49EE118C034
	for <kvm@vger.kernel.org>; Thu, 17 Apr 2025 19:09:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744917002; cv=none; b=Ou19EaRY770DuREtFzLdX92+y1qqOxCnHEDbPxCexWYTpe22kV4TIEGeMlps32zwWeT4gTOtAKJjpvLJOnY3eN3hnPviUPIgCp2zxEYVRveRhPbeR6NmL0V9Ndk7rwUDMvHPwa6YzKV/2iiNeDTXRP03Vjt2+EQO+z0xlDPrcT8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744917002; c=relaxed/simple;
	bh=LWmtqcRg4vYqaht95rNzQTnZG5rXeJkgUB16GqPuT78=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type; b=TnWvkrQ6+BLehFQeC3YUTFFlyNX4c6H99S8YBxBQLIHmebjz2hKMvTFDFvyziOYtW5liOzmfHcQB+JNfkTIPtpNuOFfEF3eM5uRtkbGpiqXuIy/arWEhZ93Q/Ah9OsV0Bd1dpRFjZr6gQJciVj1JkzjHmcSO/0goZoM/DdghEZg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=f/6ZUIR1; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1744916999;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=uiXBTi+9xPzAQerymXjoaS4kjOTzAaU4VV7kSHRN7Dc=;
	b=f/6ZUIR1qYMFAMLE+UoNzb6CJG2Mn/0bPw76vMClyq4cUSRQuEUkJlrfn6a0V7Tcw5aOk0
	EGjlt6F+Un9j2NuqzOb7yjps9EYSc62aoHSjuYYJHva5d7uI07fi2rycsgdiaDqmSnXKvA
	1cy95Alyk9tg2AN8IdF5KKWLKgOmeWI=
Received: from mail-io1-f71.google.com (mail-io1-f71.google.com
 [209.85.166.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-690-VKtEVlp2NZq5REFWrBrzog-1; Thu, 17 Apr 2025 15:09:57 -0400
X-MC-Unique: VKtEVlp2NZq5REFWrBrzog-1
X-Mimecast-MFC-AGG-ID: VKtEVlp2NZq5REFWrBrzog_1744916997
Received: by mail-io1-f71.google.com with SMTP id ca18e2360f4ac-8618aa546c8so15054539f.0
        for <kvm@vger.kernel.org>; Thu, 17 Apr 2025 12:09:57 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1744916997; x=1745521797;
        h=content-transfer-encoding:mime-version:message-id:subject:cc:to
         :from:date:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=uiXBTi+9xPzAQerymXjoaS4kjOTzAaU4VV7kSHRN7Dc=;
        b=DY3U8VUJzVoNZow9vlveqJ6kKFT6Y7F0w4ONi3It7Y4HiirBuQcqDJD3UZaUggwUBq
         PcgCeQ3tbvSsVuMLinoId8Fnu92MsGotpiIYkT1HFSVPN3qs32s/4pFMBEuKpJ5Wd1q+
         tqqyWcA8VRF23NJout6s5kyigFps7aoCnfV0iysIxCtOPbEQe1shet/9WXVIo39Er+KF
         aIOIw5x4OI8NKKNIKyZ09t8mizLCp7OCvGWkioInkML+O74uS7Z/erMo6qFxP09xqMDz
         oOUzMnmP6mW/0hgKAnG/k2+0XsyMq2Rs/RZu3syaMJrJql448c4LWwFZJm/LQ8h0tJMB
         UpRw==
X-Forwarded-Encrypted: i=1; AJvYcCX7AiSHeqINGGX0Vnd9lQlM6i0jVLZiw+cKoAHNna2oA+Z66td2giWzyDNVWH1Y76gpxIo=@vger.kernel.org
X-Gm-Message-State: AOJu0YwBApxa27dB36nBOZO5VEOc3sWqWUOWUCz2Isn2VvrofYUDaFET
	IPrcruVIUbAT+pbWW1bC9TwyM91XzB/rzuHz2qnbRHxTQ8tuh0MEdkgBsGGTfogTkKT/6JhFlsv
	OvjCZJrVna9GpZnL58bVMhGmaxyplEyGXA6hEiecqRvCZvHechw==
X-Gm-Gg: ASbGncvhBXSa0/89qqF3670g0Dm53oR5WSiwssGqRNGTzEOFa4ADm+CBBAyCq2Aj92B
	foU4/+sU0/R9fPMkFt7qvMwm7ZTIyAU9ztVrCJ6EaGIMJQ2MoqKWFFGO8IWNfFQMjMaLvzWGHBB
	oD9/f0+2A1CbxKNCrie6jSw2N8u88wRorWSiIkqzoIITS3WZ+NS3yb0DZvokxxxMLFNmCbIlNth
	93UIv9XiUt3Zx0fDOMKE8rDET10FMbiKAW99qpqer8HCEg4407IiYEED7kg03jAjjY/9ib1sFxg
	MY2jcEtKck3Veec=
X-Received: by 2002:a05:6602:2cd2:b0:85b:3f28:ff99 with SMTP id ca18e2360f4ac-861cc459a02mr167212939f.2.1744916996977;
        Thu, 17 Apr 2025 12:09:56 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGxg3eT3tsXsVwuUelrtMA5J4sp1U5X0esmywejNrIGOo8PKOizFgbB/HiQRLWrl593n5mp7A==
X-Received: by 2002:a05:6602:2cd2:b0:85b:3f28:ff99 with SMTP id ca18e2360f4ac-861cc459a02mr167212239f.2.1744916996658;
        Thu, 17 Apr 2025 12:09:56 -0700 (PDT)
Received: from redhat.com ([38.15.36.11])
        by smtp.gmail.com with ESMTPSA id ca18e2360f4ac-861d95de8bcsm6563339f.4.2025.04.17.12.09.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 17 Apr 2025 12:09:55 -0700 (PDT)
Date: Thu, 17 Apr 2025 13:09:52 -0600
From: Alex Williamson <alex.williamson@redhat.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: <linux-kernel@vger.kernel.org>, "kvm@vger.kernel.org"
 <kvm@vger.kernel.org>, sbhat@linux.ibm.com
Subject: [GIT PULL] VFIO update for v6.15-rc3
Message-ID: <20250417130952.52761ea6.alex.williamson@redhat.com>
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

A small addendum to 860be250fc32 ("vfio/pci: Handle INTx IRQ_NOTCONNECTED")
that should also make it into v6.15.  Thanks,

Alex

The following changes since commit 8ffd015db85fea3e15a77027fda6c02ced4d2444:

  Linux 6.15-rc2 (2025-04-13 11:54:49 -0700)

are available in the Git repository at:

  https://github.com/awilliam/linux-vfio.git tags/vfio-v6.15-rc3

for you to fetch changes up to 2bd42b03ab6b04dde1753bd6b38eeca5c70f3941:

  vfio/pci: Virtualize zero INTx PIN if no pdev->irq (2025-04-14 08:31:45 -0600)

----------------------------------------------------------------
VFIO update for v6.15-rc3

 - Include devices where the platform indicates PCI INTx is not routed
   by setting pdev->irq to zero in the expanded virtualization of the
   PCI pin register.  This provides consistency in the INFO and
   SET_IRQS ioctls. (Alex Williamson)

----------------------------------------------------------------
Alex Williamson (1):
      vfio/pci: Virtualize zero INTx PIN if no pdev->irq

 drivers/vfio/pci/vfio_pci_config.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)


