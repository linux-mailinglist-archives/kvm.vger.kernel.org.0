Return-Path: <kvm+bounces-61269-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [142.0.200.124])
	by mail.lfdr.de (Postfix) with ESMTPS id 9B84FC12DA8
	for <lists+kvm@lfdr.de>; Tue, 28 Oct 2025 05:22:43 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 0A9F64FA8F0
	for <lists+kvm@lfdr.de>; Tue, 28 Oct 2025 04:21:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7B6782BD5BF;
	Tue, 28 Oct 2025 04:20:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=shazbot.org header.i=@shazbot.org header.b="BiDvI+Bj";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="QUov+s0n"
X-Original-To: kvm@vger.kernel.org
Received: from fout-a7-smtp.messagingengine.com (fout-a7-smtp.messagingengine.com [103.168.172.150])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9512329DB6E;
	Tue, 28 Oct 2025 04:20:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=103.168.172.150
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761625234; cv=none; b=M5oexct6T/gvbpCV57sp/b/jDeBen+wlJZUEXfPIXafYoz0pMoKM5aHrWxEt0/A9Z0o/jhGnMTW7jrFOGkuFAvBXUx9IPR4eB+ihpZ8463xC+Go+kZuWeIsx5lyvAGT6LPOYDPprWhu1cSZpq5vMDIlpUjB15zj5eQf5CatVCCU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761625234; c=relaxed/simple;
	bh=zFEKOBoVCgXwNi52RSBi6ZaQ0J7fk396lVdj6DPv7q0=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=beLcM1Cp1x2ua9nNMxLeQGprJugWZ6E2ogmW8BjaEj5+C0JoPyQPMimC5iVBVFchK9Ehmfe/pkCjOPP+ZyYn8HxeWfqLyF0m9Ng1MUtYvPBbq6tuFiE1O08rwpFprZymBbeJmAh7jsOo6qzUCPIv43xI5tYa4VIXz2aZsyWMonI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=shazbot.org; spf=pass smtp.mailfrom=shazbot.org; dkim=pass (2048-bit key) header.d=shazbot.org header.i=@shazbot.org header.b=BiDvI+Bj; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=QUov+s0n; arc=none smtp.client-ip=103.168.172.150
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=shazbot.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=shazbot.org
Received: from phl-compute-07.internal (phl-compute-07.internal [10.202.2.47])
	by mailfout.phl.internal (Postfix) with ESMTP id 8B771EC048A;
	Tue, 28 Oct 2025 00:20:30 -0400 (EDT)
Received: from phl-mailfrontend-01 ([10.202.2.162])
  by phl-compute-07.internal (MEProxy); Tue, 28 Oct 2025 00:20:30 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=shazbot.org; h=
	cc:cc:content-transfer-encoding:content-type:content-type:date
	:date:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to; s=fm2; t=1761625230;
	 x=1761711630; bh=7jzRI4s7gULOgGD3B8qwcysGNMpsKGW4N7s8XIBTbCc=; b=
	BiDvI+Bj2gUCQJlv92oAOF1f8RuOOagXqby+WnDB2zLG34GMyRW3XgdvU29C65gd
	Et2mjHFe8yjlYf6Kq3gld+TtexhoicOiDSaFtPXtVRrjXlsQ2b4hJRDBXDeO5CLK
	+DHgOp6q1WEuBqom65Qn1bAz0FHn16s8AqKZASlj+45rLJ+wefDMtgxXSzxTWQwK
	Nhi2ZeYxKoNHzyTy3Q2v2Sh/NIGw26jkWgjAZsh/8+7YmgxV7HxF1HQFgPVsXPOO
	cSduohMBxM51AjJT02qjklDratMMHCaoSRzcr3iLThZhIDFNzHmE4h1RDn+vXD24
	UAtNHUHJBKF0a2wJX3d7NA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:content-type:date:date:feedback-id:feedback-id
	:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to:x-me-proxy
	:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; t=1761625230; x=
	1761711630; bh=7jzRI4s7gULOgGD3B8qwcysGNMpsKGW4N7s8XIBTbCc=; b=Q
	Uov+s0nezDzZZmdA/f+1etrbsvLP0NCjZq/pLgmdFv0h3BFqmZBkmjdx+TYMoeoK
	HRKr9Imy96+ZJpn9C7aJeHGK6/q9GKCwFDAKXkHeRNPnGQgbI87nGcmdaZY9MFYc
	J/JokVlPOOZEz2yYILwHx7BXCYIYVEHTaWt/Yb5vlHlRm7DMQ6QN8OfhTOD9mcsY
	SXrIjEtScUoJXhL/aNj43zrkNRo7RMuDI+3yAzeCVLAy4vcuKuZ8lyZCSeUwvU7+
	1cct0BwbNYKe5VXzxo3LnPMrTnx00Hiogpey+IwZ/NLzmfuBAE/f+jTeR+UFi6fb
	bsbuIQQU6cdqCipvrjMJg==
X-ME-Sender: <xms:jUQAaUpQgI5KGYXfVzhl8JE_PB8DrOIt6kxl_mCi6RZodz8GRVqAEw>
    <xme:jUQAaY4xdYdDhkIJgiulV39rz46W214vXrSWXC3_1Qnl98kWXXo77mZlIQybDSCW8
    o-ZYq3n6PJSIGu9m7ekjMx4uyuUiX-UkuMQgua7b6ybYWYbIwH63A>
X-ME-Received: <xmr:jUQAaSjxocG8oQaLNTdHmLV_FK9LHBeCWKhHkfuZ3QIF0PQ7x0s4n5ODdsI>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeeffedrtdeggdduheelkeejucetufdoteggodetrf
    dotffvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfurfetoffkrfgpnffqhgenuceu
    rghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmnecujf
    gurhepfffhvfevuffkjghfgggtgfesthejredttddtvdenucfhrhhomheptehlvgigucgh
    ihhllhhirghmshhonhcuoegrlhgvgiesshhhrgiisghothdrohhrgheqnecuggftrfgrth
    htvghrnhepteetudelgeekieegudegleeuvdffgeehleeivddtfeektdekkeehffehudet
    hffhnecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomheprg
    hlvgigsehshhgriigsohhtrdhorhhgpdhnsggprhgtphhtthhopedutddpmhhouggvpehs
    mhhtphhouhhtpdhrtghpthhtoheplhhiuhhlohhnghhfrghngheshhhurgifvghirdgtoh
    hmpdhrtghpthhtoheprghlvgigrdifihhllhhirghmshhonhesrhgvughhrghtrdgtohhm
    pdhrtghpthhtohepjhhgghesnhhvihguihgrrdgtohhmpdhrtghpthhtohephhgvrhgsvg
    hrthesghhonhguohhrrdgrphgrnhgrrdhorhhgrdgruhdprhgtphhtthhopehshhgrmhgv
    vghrkhholhhothhhuhhmsehgmhgrihhlrdgtohhmpdhrtghpthhtohepjhhonhgrthhhrg
    hnrdgtrghmvghrohhnsehhuhgrfigvihdrtghomhdprhgtphhtthhopehlihhnuhigqdgt
    rhihphhtohesvhhgvghrrdhkvghrnhgvlhdrohhrghdprhgtphhtthhopehkvhhmsehvgh
    gvrhdrkhgvrhhnvghlrdhorhhgpdhrtghpthhtoheplhhinhhugidqkhgvrhhnvghlsehv
    ghgvrhdrkhgvrhhnvghlrdhorhhg
X-ME-Proxy: <xmx:jUQAae5wYuhBeER3u9fJNaJ7SXV7sFeo4g1DBiCgQkQXJde0CJ811g>
    <xmx:jUQAaXEEk7Lsit1gwjOEcHKljNt9oReNhuhBOdODxSNzMlM0vMtIyA>
    <xmx:jUQAaQLV8_HLj74-vV4H3L07JGnZM90pl8OTsCg1Rx8Dl7yhe9IqJw>
    <xmx:jUQAaUi3Wvif4yQjMLxXrdNF7o6evFSRDC6MxEdPtDYnlgKOUsiBRw>
    <xmx:jkQAaR1XWGiJKWEtWo1LMw5WyafD2nD97nQUVdAoeFl4czNJ5KYEoY50>
Feedback-ID: i03f14258:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Tue,
 28 Oct 2025 00:20:28 -0400 (EDT)
Date: Mon, 27 Oct 2025 22:20:11 -0600
From: Alex Williamson <alex@shazbot.org>
To: Longfang Liu <liulongfang@huawei.com>
Cc: <alex.williamson@redhat.com>, <jgg@nvidia.com>,
 <herbert@gondor.apana.org.au>, <shameerkolothum@gmail.com>,
 <jonathan.cameron@huawei.com>, <linux-crypto@vger.kernel.org>,
 <kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
 <linuxarm@openeuler.org>
Subject: Re: [PATCH v10 1/2] crypto: hisilicon - qm updates BAR
 configuration
Message-ID: <20251027222011.05bac6bd@shazbot.org>
In-Reply-To: <20251017091057.3770403-2-liulongfang@huawei.com>
References: <20251017091057.3770403-1-liulongfang@huawei.com>
	<20251017091057.3770403-2-liulongfang@huawei.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Fri, 17 Oct 2025 17:10:56 +0800
Longfang Liu <liulongfang@huawei.com> wrote:

> On new platforms greater than QM_HW_V3, the configuration region for the
> live migration function of the accelerator device is no longer
> placed in the VF, but is instead placed in the PF.
> 
> Therefore, the configuration region of the live migration function
> needs to be opened when the QM driver is loaded. When the QM driver
> is uninstalled, the driver needs to clear this configuration.
> 
> Signed-off-by: Longfang Liu <liulongfang@huawei.com>
> Reviewed-by: Shameer Kolothum <shameerkolothum@gmail.com>
> Acked-by: Herbert Xu <herbert@gondor.apana.org.au>
> ---
>  drivers/crypto/hisilicon/qm.c | 27 +++++++++++++++++++++++++++
>  include/linux/hisi_acc_qm.h   |  3 +++
>  2 files changed, 30 insertions(+)
> 
> diff --git a/drivers/crypto/hisilicon/qm.c b/drivers/crypto/hisilicon/qm.c
> index a5b96adf2d1e..f0fd0c3698eb 100644
> --- a/drivers/crypto/hisilicon/qm.c
> +++ b/drivers/crypto/hisilicon/qm.c
> @@ -3019,11 +3019,36 @@ static void qm_put_pci_res(struct hisi_qm *qm)
>  	pci_release_mem_regions(pdev);
>  }
>  
> +static void hisi_mig_region_clear(struct hisi_qm *qm)
> +{
> +	u32 val;
> +
> +	/* Clear migration region set of PF */
> +	if (qm->fun_type == QM_HW_PF && qm->ver > QM_HW_V3) {
> +		val = readl(qm->io_base + QM_MIG_REGION_SEL);
> +		val &= ~BIT(0);
> +		writel(val, qm->io_base + QM_MIG_REGION_SEL);
> +	}
> +}
> +
> +static void hisi_mig_region_enable(struct hisi_qm *qm)
> +{
> +	u32 val;
> +
> +	/* Select migration region of PF */
> +	if (qm->fun_type == QM_HW_PF && qm->ver > QM_HW_V3) {
> +		val = readl(qm->io_base + QM_MIG_REGION_SEL);
> +		val |= QM_MIG_REGION_EN;
> +		writel(val, qm->io_base + QM_MIG_REGION_SEL);
> +	}
> +}

Why the inconsistency in using BIT(0) in one place and QM_MIG_REGION_EN
in another?  This could easily define QM_BIT_REGION_EN_BIT and use
BIT() in both places, or use the complement rather than BIT().  Thanks,

Alex

> +
>  static void hisi_qm_pci_uninit(struct hisi_qm *qm)
>  {
>  	struct pci_dev *pdev = qm->pdev;
>  
>  	pci_free_irq_vectors(pdev);
> +	hisi_mig_region_clear(qm);
>  	qm_put_pci_res(qm);
>  	pci_disable_device(pdev);
>  }
> @@ -5725,6 +5750,7 @@ int hisi_qm_init(struct hisi_qm *qm)
>  		goto err_free_qm_memory;
>  
>  	qm_cmd_init(qm);
> +	hisi_mig_region_enable(qm);
>  
>  	return 0;
>  
> @@ -5863,6 +5889,7 @@ static int qm_rebuild_for_resume(struct hisi_qm *qm)
>  	}
>  
>  	qm_cmd_init(qm);
> +	hisi_mig_region_enable(qm);
>  	hisi_qm_dev_err_init(qm);
>  	/* Set the doorbell timeout to QM_DB_TIMEOUT_CFG ns. */
>  	writel(QM_DB_TIMEOUT_SET, qm->io_base + QM_DB_TIMEOUT_CFG);
> diff --git a/include/linux/hisi_acc_qm.h b/include/linux/hisi_acc_qm.h
> index c4690e365ade..aa0129d20c51 100644
> --- a/include/linux/hisi_acc_qm.h
> +++ b/include/linux/hisi_acc_qm.h
> @@ -99,6 +99,9 @@
>  
>  #define QM_DEV_ALG_MAX_LEN		256
>  
> +#define QM_MIG_REGION_SEL		0x100198
> +#define QM_MIG_REGION_EN		0x1
> +
>  /* uacce mode of the driver */
>  #define UACCE_MODE_NOUACCE		0 /* don't use uacce */
>  #define UACCE_MODE_SVA			1 /* use uacce sva mode */


