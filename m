Return-Path: <kvm+bounces-57545-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 9C78CB5787D
	for <lists+kvm@lfdr.de>; Mon, 15 Sep 2025 13:36:33 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 09EF9188B9E7
	for <lists+kvm@lfdr.de>; Mon, 15 Sep 2025 11:35:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C5985303A3C;
	Mon, 15 Sep 2025 11:30:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b="nRes1P59"
X-Original-To: kvm@vger.kernel.org
Received: from m16.mail.163.com (m16.mail.163.com [117.135.210.4])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 27E5520C463;
	Mon, 15 Sep 2025 11:30:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=117.135.210.4
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757935849; cv=none; b=VOJHFiSKSxmJZZ8JVE76lB2gNI3FTQllQxCl/moNoCe0xLNz/V1+x51eMAhmgHR+1dJ8dRwWSxxK3TXHxvdGDGwZoCDa5dTkJLT2ApHP+ZYef0K8eP7GO5t/jGXd6pbbXt9OTo1I5aky6FNmL/FQ/37KbssIkY7R4IsiprDtpLY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757935849; c=relaxed/simple;
	bh=47DEQpj8HBSa+/TImW+5JCeuQeRkm5NMpJWZG3hSuFU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pL4XaJcp5iJ+R/Pd4JJJZiA4NRBrtDwwkxdWeWWU5x9zyM6aGq9VvzYJrS5IU7K8+W2F+q+fRwdPJMOwE701zUCEsVWLwHmWFBGGQ9yMumPO0CztNEWtL+CPJDl1PgXyJ+YJRo5PvFSDOfUFQZ+Xx6zFhXPP1xJGau0y1joi1AE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=163.com; spf=pass smtp.mailfrom=163.com; dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b=nRes1P59; arc=none smtp.client-ip=117.135.210.4
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=163.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=163.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
	s=s110527; h=From:To:Subject:Date:Message-ID:MIME-Version; bh=47
	DEQpj8HBSa+/TImW+5JCeuQeRkm5NMpJWZG3hSuFU=; b=nRes1P59wp9fYzplsx
	a69S08t/AKtIEApSDM6L9sg6rHZThIp4j8kdRcCoV0YPdLPyi6hcQyrFakgyDVhS
	VwzjFcKKSaGXf8tCiP9S2zqPuY455kKYPhr+nFCejc1NflGomvO0DcPnlBcyg6Xn
	jhNoTgBLNeiSAMtE94e1x7o/4=
Received: from localhost.localdomain (unknown [])
	by gzsmtp3 (Coremail) with SMTP id PigvCgDnU+G4+MdomWZMDA--.15853S2;
	Mon, 15 Sep 2025 19:30:01 +0800 (CST)
From: Jinyu Tang <tjytimi@163.com>
To: anup@brainfault.org
Cc: ajones@ventanamicro.com,
	atish.patra@linux.dev,
	conor.dooley@microchip.com,
	kvm-riscv@lists.infradead.org,
	kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-riscv@lists.infradead.org,
	nutty.liu@hotmail.com,
	paul.walmsley@sifive.com,
	tjytimi@163.com,
	yongxuan.wang@sifive.com
Subject: Re:Re: [PATCH v3] riscv: skip csr restore if vcpu preempted reload
Date: Mon, 15 Sep 2025 19:29:59 +0800
Message-ID: <20250915112959.1337857-1-tjytimi@163.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <CAAhSdy27hnGS3HOazwnR4Y+SCk94RLnz5CA1kDkzsx7QH3dmwA@mail.gmail.com>
References: <CAAhSdy27hnGS3HOazwnR4Y+SCk94RLnz5CA1kDkzsx7QH3dmwA@mail.gmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:PigvCgDnU+G4+MdomWZMDA--.15853S2
X-Coremail-Antispam: 1Uf129KBjDUn29KB7ZKAUJUUUUU529EdanIXcx71UUUUU7v73
	VFW2AGmfu7bjvjm3AaLaJ3UbIYCTnIWIevJa73UjIFyTuYvjfUjkucUUUUU
X-CM-SenderInfo: xwm13xlpl6il2tof0z/1tbiThbJeGjH9Pex3wAAsr



