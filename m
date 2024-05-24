Return-Path: <kvm+bounces-18143-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 9F6F88CE92B
	for <lists+kvm@lfdr.de>; Fri, 24 May 2024 19:19:22 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 1E5B8B20C86
	for <lists+kvm@lfdr.de>; Fri, 24 May 2024 17:19:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8C1A912F384;
	Fri, 24 May 2024 17:19:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="VBZ3bXar"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BB93012CDAE;
	Fri, 24 May 2024 17:19:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716571152; cv=none; b=e9VflQanfV1k7OOlOSvZkd99o7UW0RAgrYP4XhWJLR4sFNlh3X5ebIZ4RizoS3T6/x1u2mntqRcq1kbQnY5Flz/cfBl34SpWDvQsEvdTRlPUY9Z/KnsotunCOulYcR/dAirbNFrzAV5cvsESAJ1n0GC/RgthYceZ7Jc9w/8cEmg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716571152; c=relaxed/simple;
	bh=gnes2yqsyctnX/ijk7QA8gwkT0PAdLVA3cu1MCbyNuQ=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=Zf4nOmGgPovCCWvsw+yuw3SgWAUn869w0nx998Kn8YXllP7dWQZrvVOtgKZQXmtknd7atjCLOlRs4LAgdrnbDt34NsK+TEqU9ci6yjxDxQMIXHAqJhXP//OfGwpI6yeW64IWA1S8SWBHFNDN5n6MQJqZkzvUhuB+17MYb73oszw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=VBZ3bXar; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0353729.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 44OH7GKI019124;
	Fri, 24 May 2024 17:18:35 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : subject :
 from : to : cc : date : in-reply-to : references : content-type :
 content-transfer-encoding : mime-version; s=pp1;
 bh=eyhcBL5UPIFE35Uck/PKe3g33kOuN8DgDYOte+vmJg0=;
 b=VBZ3bXar4X6Bkv/6VSgWtJ9U/bUhlD7gdrBDtOnQTa749xuK5u0O+08MQkeUdAnlFxTv
 5aPyHVKD/GBXyDZEeFIUXD+Zj1hqMxBL7VekqfTkG/kjohkd88gsLjnjLth9J1XOWT8N
 x3A24lS7iYqGQiCj0iS/9ARjUWIDYFo0GmZ7nun6BGI+kmtbqlem6zl0dQRqemiJ89Yt
 QBI0/lkvcbpCKH2FC1RLH8NNmDeYv5aoyvRaEvJVWzz4D+lMnlvR7AzNmBgzIho/UXyp
 9rc/7zxvXehemaVOKtT2+DP6KMQbY9Z93Av6Tw5YYj7F7taL+aWd6Ixb4SdCatzo1EE/ CA== 
Received: from ppma23.wdc07v.mail.ibm.com (5d.69.3da9.ip4.static.sl-reverse.com [169.61.105.93])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3yay0v011h-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 24 May 2024 17:18:35 +0000
Received: from pps.filterd (ppma23.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma23.wdc07v.mail.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 44OGIlj3026470;
	Fri, 24 May 2024 17:18:33 GMT
Received: from smtprelay03.fra02v.mail.ibm.com ([9.218.2.224])
	by ppma23.wdc07v.mail.ibm.com (PPS) with ESMTPS id 3y785n1v60-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 24 May 2024 17:18:33 +0000
Received: from smtpav07.fra02v.mail.ibm.com (smtpav07.fra02v.mail.ibm.com [10.20.54.106])
	by smtprelay03.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 44OHITWS54067580
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 24 May 2024 17:18:32 GMT
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id D75A620043;
	Fri, 24 May 2024 17:18:29 +0000 (GMT)
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 6088C20040;
	Fri, 24 May 2024 17:18:29 +0000 (GMT)
Received: from li-978a334c-2cba-11b2-a85c-a0743a31b510.ibm.com (unknown [9.179.12.135])
	by smtpav07.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Fri, 24 May 2024 17:18:29 +0000 (GMT)
Message-ID: <14cdedc0c6aa62d1c5aa4b770abd5bdc0f63f7c8.camel@linux.ibm.com>
Subject: Re: [PATCH 1/3] KVM: arm64: Fix AArch32 register narrowing on
 userspace write
From: Nina Schoetterl-Glausch <nsg@linux.ibm.com>
To: Marc Zyngier <maz@kernel.org>, kvmarm@lists.linux.dev, kvm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Cc: James Morse <james.morse@arm.com>,
        Suzuki K Poulose
 <suzuki.poulose@arm.com>,
        Oliver Upton <oliver.upton@linux.dev>,
        Zenghui
 Yu <yuzenghui@huawei.com>, stable@vger.kernel.org
Date: Fri, 24 May 2024 19:18:28 +0200
In-Reply-To: <20240524141956.1450304-2-maz@kernel.org>
References: <20240524141956.1450304-1-maz@kernel.org>
	 <20240524141956.1450304-2-maz@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.52.1 (3.52.1-1.fc40) 
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: 2zcVaPdxn_Gis_kAKQatAaMZImXhGwRz
X-Proofpoint-ORIG-GUID: 2zcVaPdxn_Gis_kAKQatAaMZImXhGwRz
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.650,FMLib:17.12.28.16
 definitions=2024-05-24_05,2024-05-24_01,2024-05-17_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 phishscore=0 spamscore=0
 adultscore=0 priorityscore=1501 mlxscore=0 lowpriorityscore=0
 malwarescore=0 impostorscore=0 clxscore=1011 bulkscore=0 mlxlogscore=936
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2405010000 definitions=main-2405240122

On Fri, 2024-05-24 at 15:19 +0100, Marc Zyngier wrote:
> When userspace writes to once of the core registers, we make
> sure to narrow the corresponding GPRs if PSTATE indicates
> an AArch32 context.
>=20
> The code tries to check whether the context is EL0 or EL1 so
> that it narrows the correct registers. But it does so by checking
> the full PSTATE instead of PSTATE.M.
>=20
> As a consequence, and if we are restoring an AArch32 EL0 context
> in a 64bit guest, and that PSTATE has *any* bit set outside of
> PSTATE.M, we narrow *all* registers instead of only the first 15,
> destroying the 64bit state.
>=20
> Obviously, this is not something the guest is likely to enjoy.
>=20
> Correctly masking PSTATE to only evaluate PSTATE.M fixes it.
>=20
> Fixes: 90c1f934ed71 ("KVM: arm64: Get rid of the AArch32 register mapping=
 code")
> Reported-by: Nina Schoetterl-Glausch <nsg@linux.ibm.com>
> Signed-off-by: Marc Zyngier <maz@kernel.org>
> Cc: stable@vger.kernel.org
> ---
>  arch/arm64/kvm/guest.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>=20
> diff --git a/arch/arm64/kvm/guest.c b/arch/arm64/kvm/guest.c
> index e2f762d959bb..d9617b11f7a8 100644
> --- a/arch/arm64/kvm/guest.c
> +++ b/arch/arm64/kvm/guest.c
> @@ -276,7 +276,7 @@ static int set_core_reg(struct kvm_vcpu *vcpu, const =
struct kvm_one_reg *reg)
>  	if (*vcpu_cpsr(vcpu) & PSR_MODE32_BIT) {
>  		int i, nr_reg;
> =20
> -		switch (*vcpu_cpsr(vcpu)) {
> +		switch (*vcpu_cpsr(vcpu) & PSR_AA32_MODE_MASK) {
>  		/*
>  		 * Either we are dealing with user mode, and only the
>  		 * first 15 registers (+ PC) must be narrowed to 32bit.

Reviewed-by: Nina Schoetterl-Glausch <nsg@linux.ibm.com>

