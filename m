Return-Path: <kvm+bounces-49225-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 4DD26AD675B
	for <lists+kvm@lfdr.de>; Thu, 12 Jun 2025 07:32:41 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id DDA877A95DC
	for <lists+kvm@lfdr.de>; Thu, 12 Jun 2025 05:31:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B9A691EC006;
	Thu, 12 Jun 2025 05:32:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="e5u9UiMx"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f177.google.com (mail-pl1-f177.google.com [209.85.214.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9B838157A67;
	Thu, 12 Jun 2025 05:32:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749706346; cv=none; b=GHS00sCbjSxyprXfFzf3hCBYBrPDGBwhWtHCMxPPh2s8htlxqrvGbGZ9Ax/E7faXLtuB0tcxCUb/EsUesN1HhtWFXpBW7ywhiHV7aWUobEQsm9YyrlzA3pI9QOVVqkzKrEy9sihKeiJs93mRVfcB03J7bskBMjr52SXH040ld64=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749706346; c=relaxed/simple;
	bh=vii4+vAE/cNdk6rrbsnHbx44XX91OlPcufm+uzCCWrs=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=Wdw7XfNGdiFBstYAuB2AbcOVPtyuxrQwWTfeBl/J3ryCd8MgYJc4MTbMgUtL6kvjOwQROuB4Yjnf/ar0byfnstpRcrwfilV+vkFhtKv0x4sOdREa8UjULaak87aQsc6iiYEuPyH5RqlD/NiqW/Ubbnt8dQ9IFEIkq/DxXXXU1C8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=e5u9UiMx; arc=none smtp.client-ip=209.85.214.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pl1-f177.google.com with SMTP id d9443c01a7336-234c5b57557so5192605ad.3;
        Wed, 11 Jun 2025 22:32:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1749706345; x=1750311145; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=vii4+vAE/cNdk6rrbsnHbx44XX91OlPcufm+uzCCWrs=;
        b=e5u9UiMxEG943ZQbKGJZlFqjcwIz8iDavmd7ShJKzZ3AJupsjjeqmXVq9OnlA5Y7+2
         i5KES5YPX8LtFkVHGcxUF7E1nztZUpE7oYtCmYhAvZAcWqbCXJuvwUaYlu0c8yGf/FZv
         QiHcpOIivzyfPvyAEMSoZQiOJPlhnH7HgP7bNoSCKcPZFKG/sG5UzYhN+GspVYQlB0Ka
         u4TVRn5uS8fNT/xYl18G+2/kB4VEMNDbEx+QFJbUjuWCUdUPIGN24QvvwfZA+A9J1GGd
         BegM/8GE8ACy9K9wZuPm+V7AKDlL2OYUPhzHXqySW6xtbEE5y2H+AUYVT4bHF6sZWoLh
         VNpw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1749706345; x=1750311145;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=vii4+vAE/cNdk6rrbsnHbx44XX91OlPcufm+uzCCWrs=;
        b=FMH7S+S84L2ebwYiqix1kKuRNdGAXM97vcBDAAHdcADfct1LaDvqVHU7BZl7Dw5+XV
         Ah11QsTptaOPLhf05m4mn/pHll3ByHfJwCMlv3TVBfMUZpmjJGigDJ4icOBLB26tP2Cq
         24P+aAqsX/hJyggwpocoSgLr+ESy2AW6i2IMndVl77KdtrFOniJ63cFHD/C145qOiXn1
         dSmF/ZA+xud2sGclHY5HY/qKyEmQrPLY8QPKH3QkLMzWsZuKFkouSgWnWGMI3PmRipKy
         VbTfEGQCWUQcV1a29rwAle87Y4sdg5GV1lvpIqcbc9q8RzOsN/5bJhcBSmmDD2Qb4NUt
         7+JQ==
X-Forwarded-Encrypted: i=1; AJvYcCViJN3iTRLrIteAOiQ4BYkav7r0V/m2rqC9ej95HS3Yu8AoeN9+877+sr83HC7AV+gZl8U=@vger.kernel.org, AJvYcCWlTezQ883iDQSM2XAbPc9vQ4niJMBbkq2kh3IAAwDT5qqHkQo9f97wDufNLyWRtgUWnMZk60jd@vger.kernel.org, AJvYcCXx8qb2VJDRLZhgM8lei8/iUH1HTmrX5SjxhSplumcwsQxEHw6lcEu9XSTwUof8+ICPWS9W8m/C9ziRrdUi@vger.kernel.org
X-Gm-Message-State: AOJu0YytS4C0Gw6kWdbblTtzsoYYvtb2C517xnMWAgZx4Ly3ZGM0jUdJ
	I0Hb3Qm0N4ldnW+vkdjTCbUjHS9GZFJ2W0mGWZaS7KdXk5rH0mPljM0d
X-Gm-Gg: ASbGncscJE3URBYE95jm2RvCKQvRslXRN5uJ3LeXDOm4SNgpkvImYNljXGiJS2HdhVT
	2h35/2jwZFLVlDDH8mBd/WMoCwVxXBrGwJXscYOf2qpSnZFeW01+J4/4uCdeVHyaaw/HoL9TFtb
	TvBagdUcwZTWEuxrGL7bICHYnwMUb7y4tpX+Dj0KM5MEm5PN3h4xShswe+6B4X8xZTFL821rT6S
	Nu7XoTbmUNyeltYXkBFm2WLeV26D426uUMyA+HIMmibM6XXV7w5vY0Dw7olOrPiJg+gZL50BaKs
	z6XWvwuDbFSqBfwRAKorDiLdqnnQpJnKYUG7Nk9Kz+mxrI4vOabFy1PA3AVK3mVT4wbUykWIxpz
	7WdsuExNj
X-Google-Smtp-Source: AGHT+IHcqVGofAGhSc43EaW6uyTom42iW5fqDOibqA0yTFHdAqUwPEUt9Zalv0PruwPswO0c0C3b7g==
X-Received: by 2002:a17:902:e5cb:b0:235:ed02:288b with SMTP id d9443c01a7336-2364ca4bbcdmr29724125ad.30.1749706344723;
        Wed, 11 Jun 2025 22:32:24 -0700 (PDT)
Received: from devant.antgroup-inc.local ([47.89.83.0])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2364e6db2a6sm5243415ad.120.2025.06.11.22.32.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 11 Jun 2025 22:32:24 -0700 (PDT)
From: Xuewei Niu <niuxuewei97@gmail.com>
X-Google-Original-From: Xuewei Niu <niuxuewei.nxw@antgroup.com>
To: sgarzare@redhat.com
Cc: Oxffffaa@gmail.com,
	avkrasnov@salutedevices.com,
	davem@davemloft.net,
	edumazet@google.com,
	eperezma@redhat.com,
	horms@kernel.org,
	jasowang@redhat.com,
	kuba@kernel.org,
	kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	mst@redhat.com,
	netdev@vger.kernel.org,
	niuxuewei97@gmail.com,
	pabeni@redhat.com,
	stefanha@redhat.com,
	virtualization@lists.linux.dev,
	xuanzhuo@linux.alibaba.com,
	Xuewei Niu <niuxuewei.nxw@antgroup.com>
Subject: Re: [PATCH net] vsock/virtio: fix `rx_bytes` accounting for stream sockets
Date: Thu, 12 Jun 2025 13:32:01 +0800
Message-Id: <20250612053201.959017-1-niuxuewei.nxw@antgroup.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20250521121705.196379-1-sgarzare@redhat.com>
References: <20250521121705.196379-1-sgarzare@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

No comments since last month.

The patch [1], which adds SIOCINQ ioctl support for vsock, depends on this
patch. Could I get more eyes on this one?

[1]: https://lore.kernel.org/lkml/bbn4lvdwh42m2zvi3rdyws66y5ulew32rchtz3kxirqlllkr63@7toa4tcepax3/#t

Thanks,
Xuewei

