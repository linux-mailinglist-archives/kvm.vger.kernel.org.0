Return-Path: <kvm+bounces-40695-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id D0036A5A3DA
	for <lists+kvm@lfdr.de>; Mon, 10 Mar 2025 20:34:46 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 19B33174063
	for <lists+kvm@lfdr.de>; Mon, 10 Mar 2025 19:34:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4127A23315A;
	Mon, 10 Mar 2025 19:34:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="fEY4ffPL"
X-Original-To: kvm@vger.kernel.org
Received: from mail-lf1-f50.google.com (mail-lf1-f50.google.com [209.85.167.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D8F581CAA60
	for <kvm@vger.kernel.org>; Mon, 10 Mar 2025 19:34:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741635279; cv=none; b=N/5d0J7Ego5eREujp9F0AUnrnYNwWowtYbieWdwgvEN2/Z2VKABRQQNci5fpHd9TxG86TFhmoXKxI8Ac0gALaX0s8iyN1RFf5exGF4ppATQ14UU60KLYmT1n4j4777/Yob69HtPGAMR0lNXGo5bszeDsDRlYafudBq4YadFzAew=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741635279; c=relaxed/simple;
	bh=3aQv+3Dx0GPEOeOXfiHksWWeIsHuQzeaNC1ZAO0Y6ao=;
	h=MIME-Version:From:Date:Message-ID:Subject:To:Content-Type; b=eUPvxD6Oh5aGVYGZlpWGu4Wq+gRcdkPOBjs2Xk2kIK2tVAK6SEBtgvUYUXqD75vx8shJ/4Wy8pe6LIlm5Dx0W9rLVgZL8tRQM4Ia4AFlT8V/ZvQwG8SLEARRCQw+ImBoY4lSu78aRD91HcCvF1qbOiV5kGMt2ZtG9FQTpnpouDQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=fEY4ffPL; arc=none smtp.client-ip=209.85.167.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-lf1-f50.google.com with SMTP id 2adb3069b0e04-547bcef2f96so4751647e87.1
        for <kvm@vger.kernel.org>; Mon, 10 Mar 2025 12:34:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1741635275; x=1742240075; darn=vger.kernel.org;
        h=to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=3aQv+3Dx0GPEOeOXfiHksWWeIsHuQzeaNC1ZAO0Y6ao=;
        b=fEY4ffPLGTV0XAWgULEPP7oDWuOgBj10HOt0p4hPIlDC0caS75EO1l6mvkE5Bgr2yh
         3jDmyIZ7k1g/RUPkgmMPAvLKi/TR3Aj0vsk7ux28uTs0fBdqo7pWrA9AqlW+AAKJhZ1i
         kpZrYCvEMSeDhharTGFac8JeFY0KX25eSa/MCFTKiSzfNXNpNMdyX/BdYrvgTVpCciyn
         p+TVhE24XaLeCrbZPKo3BD8YUIq31OhFUCI7+DDGXnOIaW+XdHEnD26CAMfp7ew7TtdH
         AGcCcrPznezRfObIpYGFtQqgf9BdClwBBs+R7DISo5TTudDXJ8lquF1fFc3FeF+Ms3ak
         FxGQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1741635275; x=1742240075;
        h=to:subject:message-id:date:from:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=3aQv+3Dx0GPEOeOXfiHksWWeIsHuQzeaNC1ZAO0Y6ao=;
        b=Sj8/G0SoOlYBR7JDrlxfjvGy5NcsSTRtTB8D26gDPe0zOoD7rbnUhy30RGtZ4xqeIE
         /dg7LXeJfuVIZid/6jiLgkzhX8QMHQ09XtDxNPT0rfCJkAwbc4IQjzx2vSU6cCNNSIKd
         eDtSZCADRQB/1OBXbsztZPYqWyrWPm6yda6+2nT7bdLwjykXUSQ4of06CEV1Jvc+apbY
         kqUz2dRAjc2JkuKyvmP1jEmNxAObjKMu1i7aE7aUIdVwO+mi2HQDfwwbVyV1K9tVrOQQ
         lHA3v+T+grUJr255M6SptNjx9kIE5dw+4Fv9Qp4625ssGk/IVOyeCzU2LefpnLWjMtg9
         g9LQ==
X-Gm-Message-State: AOJu0Yz8xm9XG4cgvPlh4E9ju+QBWMUPY7FY7TahJ1rKwpQQ2QOqOWsV
	8CYOm/saGYPkErF595+FCgytgeJCBCf9NcBtrSOz3D1T0IXh7UQWwSWw+99QlrL0yljnRds+DwH
	8KYIf9T1g7DFQ48/UFteRE73DAb9CsGIw4kg=
X-Gm-Gg: ASbGncuzcQpWZawG14eJCuqqqNiwGg6U4ydmoI97jSj9ZcW17oNDjXFYT4CozNbYgvF
	RuJcYVUC/WLEsDKC+260TUIf0BmCMdApSXvfE4A8PQ98quvkP0vX4Iu1Rma0L9DeItRx8VKmZwh
	1QMPPy3CJVVF0ev/bzsII2X/tw
X-Google-Smtp-Source: AGHT+IHjkQE//SMWFwrZHsPdn0JzNaYKlVSsYannwE3RXytTwCJD1vVlMOj35fBN9vXrW3Gd5jiy0xsv7EQKswzGbpM=
X-Received: by 2002:ac2:4e04:0:b0:545:bb6:8e41 with SMTP id
 2adb3069b0e04-549abaf1213mr384644e87.52.1741635274954; Mon, 10 Mar 2025
 12:34:34 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
From: Manuele Pandolfi <manuele.pand@gmail.com>
Date: Mon, 10 Mar 2025 20:34:23 +0100
X-Gm-Features: AQ5f1Jr0l8Fzi58g9IcxgoMTZ_BLK8vfwHlbtUa6tZsglKgHkG8q9XJrUspWf2o
Message-ID: <CAF4NBG1R0-moPUTHY0THkcRgPFU7nXcsGLfrrFeBJL7-LZLi6A@mail.gmail.com>
Subject: kvmtool: virtio MMIO notify_write access can schedule a job with an
 OOB struct
To: kvm@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

Doing a notify_write access with a whatever pci device leads to an OOB
access in the device.jobs array, by crafting a fake thread_pool__job
struct it is possible to obtain RIP hijacking, allowing a guest user
to execute arbitrary code in the host.
Index validation in virtio_device.ops.notify_vq should be done as in
other COMMON read and write functions.
I am willing to discuss details and provide an exploit in order to
help patching and register the CVE.

