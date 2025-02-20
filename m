Return-Path: <kvm+bounces-38656-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 77B83A3D3AD
	for <lists+kvm@lfdr.de>; Thu, 20 Feb 2025 09:51:16 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id DD9E1189E362
	for <lists+kvm@lfdr.de>; Thu, 20 Feb 2025 08:51:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 47B1E1EDA0D;
	Thu, 20 Feb 2025 08:50:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ventanamicro.com header.i=@ventanamicro.com header.b="ibRQdlT7"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f51.google.com (mail-wm1-f51.google.com [209.85.128.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A23971EBFFF
	for <kvm@vger.kernel.org>; Thu, 20 Feb 2025 08:50:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740041411; cv=none; b=jGykHI3QEnFrKsb9+UOvs4WO5kb2ltpZSsvwEFtkJt/MOOpkbLWhIJMfXVzXQvdWE+K4EEU0jRFb2bS64SmdaV1ddaJj09iEENX7ox7Dx4ASoI42NWOrJRyrYlhSNMRm9w8xXHfHs9T3BhNElj4UF3Yg8xEfAJS+cLGD48/tOnE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740041411; c=relaxed/simple;
	bh=GgaM6vvIOpqR7NE3Jr5ncvGl66QjYPZHcGTUZgOMyR8=;
	h=Mime-Version:Content-Type:Date:Message-Id:Subject:Cc:To:From:
	 References:In-Reply-To; b=eh5Y8TEMKFIWep7ttGPt+SGLQaEDqHifO/2hWdgtg0yqK2u6EpTbTLITZWUb/R/ipwyNCRLqynqTYHhp2+2SNDm1ilEwozAPptTmsdxtZNeISQbTqXb8MMKWp5wt0dKLSwekJpqyn+HlatLAkvaSp7Vd7gk2p+QS1WhWJ2zOSmI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ventanamicro.com; spf=pass smtp.mailfrom=ventanamicro.com; dkim=pass (2048-bit key) header.d=ventanamicro.com header.i=@ventanamicro.com header.b=ibRQdlT7; arc=none smtp.client-ip=209.85.128.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ventanamicro.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ventanamicro.com
Received: by mail-wm1-f51.google.com with SMTP id 5b1f17b1804b1-43987d046caso906535e9.0
        for <kvm@vger.kernel.org>; Thu, 20 Feb 2025 00:50:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ventanamicro.com; s=google; t=1740041408; x=1740646208; darn=vger.kernel.org;
        h=in-reply-to:references:from:to:cc:subject:message-id:date
         :content-transfer-encoding:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=X4cSnvn9ljr1+95vro6JQ9OboRp/UL3qAMCfprqMPPM=;
        b=ibRQdlT7UpoqfFO6a0krzGXimdbtF2N28m2BNujdnNIWSNpIObUg7Wf3TNeIp8sUMh
         zG2p6/vMw1wSlTAjqx7YcXABJPXQxmwLXVSILL8D3jI4gTfz6AdT/T8tu2oOTE+rAZn6
         f6cShWOzYuKZlwl2bEzZWoVwlsn5KyQoMi+/MhF/Li4phLTLn+2ScRG/woXuvX2QirF0
         Hg57p0/yzU6O87CqInpeAi3ZQhdr1mEMwYCDqNGl1J98nULLRvJ636Lic76Oe9/hzfJJ
         85jYqjnINNIpMw0bnA5LqOuPrb78hce44xb68eabcQp/I3gzITITH83COahMiZo+bICA
         X17A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1740041408; x=1740646208;
        h=in-reply-to:references:from:to:cc:subject:message-id:date
         :content-transfer-encoding:mime-version:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=X4cSnvn9ljr1+95vro6JQ9OboRp/UL3qAMCfprqMPPM=;
        b=DfvuNq+R7SODjlrCXbCqtFN/3IXY4Y9gZU73150gx5zFC+2mzOvflyx5bL6JZyrC9Z
         Xf0nfgr443RlB5MgK3wmIIJ5cKke65fwE2lJizt3PvaQA6yr+Cc8wQGxmaME5kONEy7X
         3bTD8auHUn0hSWusnk3Cl9hKojXnlOI/QkJ9aySc/StFzMnhuupuIe+gLHBPWSsXKTuL
         h9UvuxsO88ZOzifRIvbfE3Pv4kyP8m0cA6g3lhhQSlf/akORYvJiBRK9Z78rE7PTu5LA
         2GFQRcsWsGIkuAyRyulqnGvFqjOT1UtjoRSi/a6b206Afw3Y2ljaOBedVmYrCHWnqUPc
         zKZw==
X-Forwarded-Encrypted: i=1; AJvYcCXzPfMvhaVUW4Piwq7xAXbRfo6xNQdWMb7FYpE2l5hosVW0aN3GYs23AYDrc3SsS/O9ITU=@vger.kernel.org
X-Gm-Message-State: AOJu0Yy7Yw6AdYB9EUGnrOM0GCtrUJrNuOQ80jWeKuTS91PypINOmrMy
	c0uPqIZ2veBqzvnim7aF0ILnZZ4u4vD5PHZkh40o8+bhGx2njFKE7eRFs2J4oks=
X-Gm-Gg: ASbGncvkCR4o3mHgnF5NK4Kc03XCjnmDN5poKFVkkU4Td4Twjx0XI5yeZM5rK4JmFoN
	T0WCun9zBNqpnWVX+f3nGPwUu9buWyWxoAKwTxhSqOv8p9b/n0WEK7g/n5UWR/tPTXdTCeRNjsS
	37G5TZOe2RsBKpG8Xz1zJt0IlEN6X1kwmOV4YC68B6rntKsEFK4i2nIcqXFGGo+vBj+ukbVObbV
	O2LcdgOQiTfDrznVPWE++8AdZczsh8ftglcu6CCCDFzuT/AGcPjx2Ycd1K8kx+gx+sXO5OWM/vy
	EHnFuUUx7GzjDqdbFQy3dzqgwZNs/FshM7oIChISzZqGeWxWu6k=
X-Google-Smtp-Source: AGHT+IHfThnNuH0h6beaOQ5rYMykdsdyrSk1TPSC2gmbY63W9HKJJCP1ryph8gsbU1Jj4BNeY7MpCQ==
X-Received: by 2002:a05:600c:2d04:b0:439:84d3:f7fd with SMTP id 5b1f17b1804b1-43984d3fb0bmr51487845e9.4.1740041407801;
        Thu, 20 Feb 2025 00:50:07 -0800 (PST)
Received: from localhost (ip-89-103-73-235.bb.vodafone.cz. [89.103.73.235])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-439918273dbsm81894325e9.20.2025.02.20.00.50.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 20 Feb 2025 00:50:07 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Thu, 20 Feb 2025 09:50:06 +0100
Message-Id: <D7X576NHG512.2HBBO3JLIA1JH@ventanamicro.com>
Subject: Re: [PATCH] riscv: KVM: Remove unnecessary vcpu kick
Cc: <anup@brainfault.org>, <kvm-riscv@lists.infradead.org>,
 <kvm@vger.kernel.org>, <linux-riscv@lists.infradead.org>,
 <linux-kernel@vger.kernel.org>, <atishp@atishpatra.org>,
 <paul.walmsley@sifive.com>, <palmer@dabbelt.com>, <aou@eecs.berkeley.edu>,
 "linux-riscv" <linux-riscv-bounces@lists.infradead.org>
To: "xiangwencheng" <xiangwencheng@lanxincomputing.com>, "Andrew Jones"
 <ajones@ventanamicro.com>
From: =?utf-8?q?Radim_Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@ventanamicro.com>
References: <20250219015426.1939-1-xiangwencheng@lanxincomputing.com>
 <D7WALEFMK28X.13HQ0UL1S3NM5@ventanamicro.com>
 <38cc241c40a8ef2775e304d366bcd07df733ecf0.f7f1d4c7.545f.42a8.90f5.c5d09b1d32ec@feishu.cn> <20250220-f9c4c4b3792a66999ea5b385@orel> <38cc241c40a8ef2775e304d366bcd07df733ecf0.818d94fe.c229.4f42.a074.e64851f0591b@feishu.cn>
In-Reply-To: <38cc241c40a8ef2775e304d366bcd07df733ecf0.818d94fe.c229.4f42.a074.e64851f0591b@feishu.cn>

2025-02-20T16:17:33+08:00, xiangwencheng <xiangwencheng@lanxincomputing.com=
>:
>> From: "Andrew Jones"<ajones@ventanamicro.com>
>> On Thu, Feb 20, 2025 at 03:12:58PM +0800, xiangwencheng wrote:
>> > In kvm_arch_vcpu_blocking it will enable guest external interrupt, whi=
ch
>
>> > means wirting to VS_FILE will cause an interrupt. And the interrupt ha=
ndler
>
>> > hgei_interrupt which is setted in aia_hgei_init will finally call kvm_=
vcpu_kick
>
>> > to wake up vCPU.

(Configure your mail client, so it doesn't add a newline between each
 quoted line when replying.)

>> > So I still think is not necessary to call another kvm_vcpu_kick after =
writing to
>> > VS_FILE.

So the kick wasn't there to mask some other bug, thanks.

>> Right, we don't need anything since hgei_interrupt() kicks for us, but i=
f
>> we do
>>=C2=A0
>> @@ -973,8 +973,8 @@ int kvm_riscv_vcpu_aia_imsic_inject(struct kvm_vcpu =
*vcpu,
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 read_lock_irqsave(&imsic->vsfile_lock, flags=
);
>>=C2=A0
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 if (imsic->vsfile_cpu >=3D 0) {
>> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 kvm_vcpu_wake_up(vcpu=
);
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 writel(iid, imsi=
c->vsfile_va + IMSIC_MMIO_SETIPNUM_LE);
>> - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 kvm_vcpu_kick(vcpu);
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 } else {
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 eix =3D &imsic->=
swfile->eix[iid / BITS_PER_TYPE(u64)];
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 set_bit(iid & (B=
ITS_PER_TYPE(u64) - 1), eix->eip);
>>=C2=A0
>> then we should be able to avoid taking a host interrupt.

The wakeup is asynchronous, and this would practically never avoid the
host interrupt, but we'd do extra pointless work...
I think it's much better just with the write.  (The wakeup would again
make KVM look like it has a bug elsewhere.)

