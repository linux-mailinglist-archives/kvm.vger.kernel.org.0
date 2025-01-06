Return-Path: <kvm+bounces-34602-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id C0D8CA0285C
	for <lists+kvm@lfdr.de>; Mon,  6 Jan 2025 15:46:37 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 4286D165798
	for <lists+kvm@lfdr.de>; Mon,  6 Jan 2025 14:46:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E88591DDC3C;
	Mon,  6 Jan 2025 14:44:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Xp31HB3j"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB6881DE8AF
	for <kvm@vger.kernel.org>; Mon,  6 Jan 2025 14:44:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736174671; cv=none; b=OECak/vniPD4qbrLU5hEZ12yOaolqsCN7ERfuc3anq/WulVX4iy4k7/JaK1yJ11oWvNOhXx/60GD/yxGhFQ6STKcXrlo7yuNYIrT8XyRjqrJ7a96F0t9yVe1K2dE5ak4Io4yaOwz/KQKoAx4Zh0reLiC0vcKc9HQKpTW5y6aZQA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736174671; c=relaxed/simple;
	bh=nBsYJbiXYIY9ywBtlWFfHXN7kk9ZlfhgY7EYBx6MQ2s=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type; b=qRTC3wcnl/7kD9PzVkIQgLWxReLYvQE1CsrkfqmTwKpMtSTCV6qbuNmyAyn2EgJ5nsEVMrthFKyIVCa/dvwmAUyJJ9qmV3SAeabaMeeEBPFMAnVMWRVOAXxidV+4m8cNzYMY9gyaEaK1vCQOCErt7t+VtF1xdJaTCtiT5HjXrck=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Xp31HB3j; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1736174668;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=FUH3DFdlL6ZUk3YpgcJ4VUOICW4X9z+8QLMCyb4jShE=;
	b=Xp31HB3jQ/kzEK/dPMPa+nYvCsdxe/YgWOtWaT9cfXRHElxxsrvKJeMEHKORc6oZp1rGtx
	PIw6Og6+YkYYAV90kIfvHhkq36Fdl/hkbWRRWAzlnxnfMBBsk6rNK6ggmO5TCk4Z8cx+wA
	RYaM1gA5Ui6CMElfJrDzWpsl69tWx94=
Received: from mail-io1-f70.google.com (mail-io1-f70.google.com
 [209.85.166.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-9-cgPtAKY_Mu-gW3M_eNHxxg-1; Mon, 06 Jan 2025 09:44:25 -0500
X-MC-Unique: cgPtAKY_Mu-gW3M_eNHxxg-1
X-Mimecast-MFC-AGG-ID: cgPtAKY_Mu-gW3M_eNHxxg
Received: by mail-io1-f70.google.com with SMTP id ca18e2360f4ac-849e7868f6eso28665939f.0
        for <kvm@vger.kernel.org>; Mon, 06 Jan 2025 06:44:25 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1736174665; x=1736779465;
        h=content-transfer-encoding:mime-version:organization:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=FUH3DFdlL6ZUk3YpgcJ4VUOICW4X9z+8QLMCyb4jShE=;
        b=WypNfSjinNiW76RQrKgHxy08eTMwv2rtokvZ6qlSWviEABaMsUEtsYTuS6G7F3i9rk
         EUpnRtYVHjRnjLh5GkfXFcOzx6TNvUdvNEUCeR/PICPfiYNmZsfNEa+su7Ut8NtCUyyy
         yb5BawhV5v2Cs5LY7FjfK+70+BlBv92/eMAWpc2hEb0h3Z84pyGY3G8Wi40B98LP91tB
         tvxXApO0N6pHx9FIk24Bc4jHL0AnlsREpHfBthpbOa30y2O24PZPfqwYx6piN/ntD2DC
         0DrhJalAByvX9PoaB7BTToBh+Dpp7ZEwZezZg+4HWU2sCey0WDMDFIQq48zMbBC8T3lW
         p3UQ==
X-Forwarded-Encrypted: i=1; AJvYcCVeyJhw+fiFhi3NSprhZOodVMzBlevyaF4dZ4s5pCOIf1urQGfhkmCLCm5ipJ0WSphZ78c=@vger.kernel.org
X-Gm-Message-State: AOJu0YynydB+62NSRY0USTLiwzTzMrrLR/wgQMzF/kF8Gvyb6W9T844c
	M/3UfO2rlJi5/pzbNwEMy43LSl43+EOuWcy82/BE1XzFsGRtrpv1rTipHHcsO+aj5gD3smyrfBH
	HIdE80vRvHWitDQowARQ1i3N/tDyYxXNlMs+pSgGKJHjBNXFOsQ==
X-Gm-Gg: ASbGnculKdFt18wtvGsnJCqsdlMg6fPXBAhLa8cfiGyGsTFSt3IZQEuGUNJmjUL9c4x
	+q7pVcmnG8j/o/ESQXf+4zIZU4xnLFKGScdgGLM1C3mzk13TVairijlaBl07MX/RUZqOdqGlVXg
	aKVjEeKr08RY8DirOG0uGUoUiiTrP7PFhMsYc2Qm3Ct8Nfqct/ckTUtsbhCtxr6h7C9enoV7BCK
	K2D6KYKlFxjDwVFqUSzKH9atnaKfFeVWoN78Eo/Q3y/LrDaXTYuRzwl+4lz
X-Received: by 2002:a05:6e02:1a48:b0:3a7:c041:6666 with SMTP id e9e14a558f8ab-3c2d5928ec6mr129759835ab.6.1736174664709;
        Mon, 06 Jan 2025 06:44:24 -0800 (PST)
X-Google-Smtp-Source: AGHT+IGafXrLACV5MeycD5XeRwqejObpLz/sq3AgN/WfDwm0ae2VRSm7hSiK4Gv9MSAfAxEDyj4qWg==
X-Received: by 2002:a05:6e02:1a48:b0:3a7:c041:6666 with SMTP id e9e14a558f8ab-3c2d5928ec6mr129759805ab.6.1736174664444;
        Mon, 06 Jan 2025 06:44:24 -0800 (PST)
Received: from redhat.com ([38.15.36.11])
        by smtp.gmail.com with ESMTPSA id e9e14a558f8ab-3c0deae6a1csm99722175ab.23.2025.01.06.06.44.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 06 Jan 2025 06:44:23 -0800 (PST)
Date: Mon, 6 Jan 2025 09:44:19 -0500
From: Alex Williamson <alex.williamson@redhat.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
 "kvm@vger.kernel.org" <kvm@vger.kernel.org>
Subject: [GIT PULL] VFIO fixes for v6.13-rc7
Message-ID: <20250106094419.66067d1c.alex.williamson@redhat.com>
Organization: Red Hat
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

Hi Linus,

The following changes since commit fc033cf25e612e840e545f8d5ad2edd6ba613ed5:

  Linux 6.13-rc5 (2024-12-29 13:15:45 -0800)

are available in the Git repository at:

  https://github.com/awilliam/linux-vfio.git tags/vfio-v6.13-rc7

for you to fetch changes up to 09dfc8a5f2ce897005a94bf66cca4f91e4e03700:

  vfio/pci: Fallback huge faults for unaligned pfn (2025-01-03 08:49:05 -0700)

----------------------------------------------------------------
VFIO fixes for v6.13-rc7

 - Fix a missed order alignment requirement of the pfn when inserting
   mappings through the new huge fault handler introduced in v6.12.
   (Alex Williamson)

----------------------------------------------------------------
Alex Williamson (1):
      vfio/pci: Fallback huge faults for unaligned pfn

 drivers/vfio/pci/vfio_pci_core.c | 17 +++++++++--------
 1 file changed, 9 insertions(+), 8 deletions(-)


