Return-Path: <kvm+bounces-15423-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id D1F8A8ABE72
	for <lists+kvm@lfdr.de>; Sun, 21 Apr 2024 05:06:28 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 00C9F1C209AF
	for <lists+kvm@lfdr.de>; Sun, 21 Apr 2024 03:06:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4D3E56AD7;
	Sun, 21 Apr 2024 03:06:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="JMXOfdCK"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f175.google.com (mail-pf1-f175.google.com [209.85.210.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 929184431;
	Sun, 21 Apr 2024 03:06:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713668778; cv=none; b=jKbi1GJbOYmJAuCUWV3XSjLdg9sCM6a7HNIZVcb0Q5gYR61+TC8YsuzxYR8Uj96jBpDG7AcrAowrgwZPhKYV5RmxwzN2f9wvd9Uly9FMFjL72uV5YII7uQmmyHk9jztQFSBBkCSIHLQhNQAUOrxcWg2w9ebGf3+3skXj1R3YjJE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713668778; c=relaxed/simple;
	bh=dG2jxD0m2zlXpqbBZqrDlEe0w3/A68n3Nqilq4yA1Us=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=D9Eq8YGfn6xFDYcTjCoZp+ryI8BlZmqu9pytoTN9153wDXXOxWo/xHTsQGfnZM7N9whTsMvwmowWNl9w2CtqhJ/1OFOcP1cutPNeDh5oW4IjPFBKknDaJ2gxKRHzDMRNtexFU2KVvEVEZTImwJeVuMeyUwsuY9zA68HPX46eCFM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=JMXOfdCK; arc=none smtp.client-ip=209.85.210.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pf1-f175.google.com with SMTP id d2e1a72fcca58-6ee13f19e7eso3033845b3a.1;
        Sat, 20 Apr 2024 20:06:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1713668773; x=1714273573; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=glNPfgGzKTb1W9Dy01P+rKaDaZjQlT5/vID4o6dvk0E=;
        b=JMXOfdCKh0D6rXXXEyHM4RIUydh82KZ/PKCVX1KVWj7zpIR+rmYrfxW/79KwWp4GMp
         vMkiDxRhReZCWixJOKyCcZ31LT7vBHzOoaq92CqrapmTS1AYojxcISlBHrp5P4K16a3h
         o2zinn6ulVSOVoAqF4PmdgQZ0AIDv0sbYQehPaC9Z9BQFrqMLfzgM97HrDnsvYeWwn13
         wj4HZOpc7PpEDCo6au31GGffJBqJgGQ4nKAQF0jY4b2YIuYN1KBBZ/OaQmFMqQrxeMjR
         KNKysTZzjYzID8g2nQrRbufQouSN2AKxsLDLW853SbyPJs9+eKarEcMJIm/bqNZA+RYS
         VFCA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1713668773; x=1714273573;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=glNPfgGzKTb1W9Dy01P+rKaDaZjQlT5/vID4o6dvk0E=;
        b=j/7uWawQUvkhAJmtDRQFM2uwf+P9eCHe5QPgiypM1iOwn2CMAnyp5P+xydD5YCG64W
         1DzU9F6Fr9oYgSJfUPRg8cBRtYbrSvD8gp/uho6qW5r/FxmBjWeGXJ0IrrVEidVA1odu
         6oDUqtwFIDPYYB4J37x82o/gKAYJ9c1knI6vRfrZqKPbQG3Ym36qjsKVe1/E0ABIuuP2
         ElvQVKTwsF2CThmDDa+vzYa4Ytz6Rve2kNueYE3b+QCTpdiIpWriq6iFo8n7OovlMM46
         M4CU0tHvAVnOH0CfeOSzjjPIJslXrKFE7CN/Ri9Bx/QfAbCkF/frYTLbwr5RcBfYxJFl
         gY+A==
X-Forwarded-Encrypted: i=1; AJvYcCU8DnEc2W9li1pst7iLU5AHZt0EOv1LAx3wC5vV/j0OmP8YZQgiSgL0yNux4D6x5jIdVv0hl3hmNUZr+kOXyCxx4AqzAsVaWqnDocoEAIe8sIPpWsS4IxbxpaCJQkVXuDfb
X-Gm-Message-State: AOJu0YwzwFdGXNWVHCy4rAsnFA1HnGysOJbtljUh8WnGzP3lAGXasPRG
	AF4VeuzgnZzWxV5oky9NUHL4Ge4cfDKGCQkC6TfDqZmSS0BKJPFM
X-Google-Smtp-Source: AGHT+IEIMHDG6CBHSCkblxM+iZEy+BtAoE3Ui1rKcYDeCHMBuit3cK4kprSZ7cQxAkqRomJqeCCmGA==
X-Received: by 2002:a17:90b:30d5:b0:2a7:d619:8e14 with SMTP id hi21-20020a17090b30d500b002a7d6198e14mr5251645pjb.5.1713668772846;
        Sat, 20 Apr 2024 20:06:12 -0700 (PDT)
Received: from kernelexploit-virtual-machine.localdomain ([121.185.186.233])
        by smtp.gmail.com with ESMTPSA id u14-20020a17090ac88e00b002abb4500e97sm5340655pjt.41.2024.04.20.20.06.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 20 Apr 2024 20:06:11 -0700 (PDT)
From: Jeongjun Park <aha310510@gmail.com>
To: mst@redhat.com
Cc: jasowang@redhat.com,
	kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	sgarzare@redhat.com,
	stefanha@redhat.com,
	syzbot+6c21aeb59d0e82eb2782@syzkaller.appspotmail.com,
	syzkaller-bugs@googlegroups.com,
	virtualization@lists.linux.dev
Subject: Re: [PATCH virt] virt: fix uninit-value in vhost_vsock_dev_open
Date: Sun, 21 Apr 2024 12:06:06 +0900
Message-Id: <20240421030606.80385-1-aha310510@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20240420060450-mutt-send-email-mst@kernel.org>
References: <20240420060450-mutt-send-email-mst@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

static bool vhost_transport_seqpacket_allow(u32 remote_cid)
{
....
	vsock = vhost_vsock_get(remote_cid);

	if (vsock)
		seqpacket_allow = vsock->seqpacket_allow;
....
}

I think this is due to reading a previously created uninitialized 
vsock->seqpacket_allow inside vhost_transport_seqpacket_allow(), 
which is executed by the function pointer present in the if statement.

Thanks

