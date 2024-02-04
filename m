Return-Path: <kvm+bounces-7944-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id C8106848BFF
	for <lists+kvm@lfdr.de>; Sun,  4 Feb 2024 08:51:31 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 8397F284F6B
	for <lists+kvm@lfdr.de>; Sun,  4 Feb 2024 07:51:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8F6C616423;
	Sun,  4 Feb 2024 07:50:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=ti.com header.i=@ti.com header.b="HnTtvqz+"
X-Original-To: kvm@vger.kernel.org
Received: from fllv0015.ext.ti.com (fllv0015.ext.ti.com [198.47.19.141])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C567214A94;
	Sun,  4 Feb 2024 07:50:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.47.19.141
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707033003; cv=none; b=lo0uQ8UJKw/+VIziT4Bn2b+hY7ajqHICe2SjhNNof7IFhEhC66EeaUCSvfuCWN3tBlNGKv/OWweFf2KDFMSoZ0TTkpEmSFrdnUVC3LrqruREAJTu9xOOCAfNOaDpKzN5oVARNecOD+9e4ltogLZYVF/LRI87UH61GEPPrZc2poI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707033003; c=relaxed/simple;
	bh=8rYxczI/5Lo4DDBMNGT7Xezq3tFx3qZcjoXISzbgu8o=;
	h=From:To:CC:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=EujY80wRTVHeBzWphuk8yr2PiR4FrHGB5lqcy3ww5m8srZ1q7YH++mNxx7S3mPpMFSYtpIau/BabK22fOqDQU1VYl5QeyGlz9N1/hvtWmQDVK05gv0IfAjbOUczNgCIkoVC2lU/ofNFfXanSuIiW0PhkOWIU5db1nHZO1JQn8XM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=ti.com; spf=pass smtp.mailfrom=ti.com; dkim=pass (1024-bit key) header.d=ti.com header.i=@ti.com header.b=HnTtvqz+; arc=none smtp.client-ip=198.47.19.141
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=ti.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ti.com
Received: from lelv0266.itg.ti.com ([10.180.67.225])
	by fllv0015.ext.ti.com (8.15.2/8.15.2) with ESMTP id 4147nZVA040695;
	Sun, 4 Feb 2024 01:49:35 -0600
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
	s=ti-com-17Q1; t=1707032975;
	bh=A14BCls41fwfyoOZpPImx9gM6CsoQWADM/eYvGfz9Sg=;
	h=From:To:CC:Subject:In-Reply-To:References:Date;
	b=HnTtvqz+bj/maXJMRIFvmTvcnjEgG7IUIaeB9KK+Ei6OlNfkUkTvlpuVwxmar3cBM
	 cGw8kVsdvDZXnSa2+/VkLNOML3E9cVn+EVg5R03mdJE5hQPyi4mWwMq+TzbQ939VJ8
	 qpbx+8sA3WQ/9M2bYTOMCuSQ0vJWroZWlusiR2qM=
Received: from DLEE115.ent.ti.com (dlee115.ent.ti.com [157.170.170.26])
	by lelv0266.itg.ti.com (8.15.2/8.15.2) with ESMTPS id 4147nZ5A053108
	(version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
	Sun, 4 Feb 2024 01:49:35 -0600
Received: from DLEE111.ent.ti.com (157.170.170.22) by DLEE115.ent.ti.com
 (157.170.170.26) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2507.23; Sun, 4
 Feb 2024 01:49:35 -0600
Received: from lelvsmtp5.itg.ti.com (10.180.75.250) by DLEE111.ent.ti.com
 (157.170.170.22) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2507.23 via
 Frontend Transport; Sun, 4 Feb 2024 01:49:35 -0600
Received: from localhost (kamlesh.dhcp.ti.com [172.24.227.123])
	by lelvsmtp5.itg.ti.com (8.15.2/8.15.2) with ESMTP id 4147nY0O050380;
	Sun, 4 Feb 2024 01:49:35 -0600
From: Kamlesh Gurudasani <kamlesh@ti.com>
To: Xin Zeng <xin.zeng@intel.com>, <herbert@gondor.apana.org.au>,
        <alex.williamson@redhat.com>, <jgg@nvidia.com>, <yishaih@nvidia.com>,
        <shameerali.kolothum.thodi@huawei.com>, <kevin.tian@intel.com>
CC: <linux-crypto@vger.kernel.org>, <kvm@vger.kernel.org>,
        <qat-linux@intel.com>, Siming Wan <siming.wan@intel.com>,
        Xin Zeng
	<xin.zeng@intel.com>
Subject: Re: [EXTERNAL] [PATCH 07/10] crypto: qat - add bank save and
 restore flows
In-Reply-To: <20240201153337.4033490-8-xin.zeng@intel.com>
References: <20240201153337.4033490-1-xin.zeng@intel.com>
 <20240201153337.4033490-8-xin.zeng@intel.com>
Date: Sun, 4 Feb 2024 13:19:34 +0530
Message-ID: <87o7cwzn1t.fsf@kamlesh.i-did-not-set--mail-host-address--so-tickle-me>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
X-EXCLAIMER-MD-CONFIG: e1e8a2fd-e40a-4ac6-ac9b-f7e9cc9ee180

Xin Zeng <xin.zeng@intel.com> writes:

> This message was sent from outside of Texas Instruments. 
> Do not click links or open attachments unless you recognize the source of this email and know the content is safe. 
>  
> From: Siming Wan <siming.wan@intel.com>
>
> Add logic to save, restore, quiesce and drain a ring bank for QAT GEN4
> devices.
> This allows to save and restore the state of a Virtual Function (VF) and
> will be used to implement VM live migration.
>
> Signed-off-by: Siming Wan <siming.wan@intel.com>
> Reviewed-by: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
> Reviewed-by: Xin Zeng <xin.zeng@intel.com>
> Signed-off-by: Xin Zeng <xin.zeng@intel.com>
...
> +#define CHECK_STAT(op, expect_val, name, args...) \
> +({ \
> +	u32 __expect_val = (expect_val); \
> +	u32 actual_val = op(args); \
> +	if (__expect_val != actual_val) \
> +		pr_err("QAT: Fail to restore %s register. Expected 0x%x, but actual is 0x%x\n", \
> +			name, __expect_val, actual_val); \
> +	(__expect_val == actual_val) ? 0 : -EINVAL; \
I was wondering if this can be done like following, saves repeat comparison.

(__expect_val == actual_val) ? 0 : (pr_err("QAT: Fail to restore %s \
                                          register. Expected 0x%x, \
                                          but actual is 0x%x\n", \
                 			  name, __expect_val, \
                                          actual_val), -EINVAL); \
Regards,
Kamlesh

> +})
...

