Return-Path: <kvm+bounces-26740-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 360CA976DE9
	for <lists+kvm@lfdr.de>; Thu, 12 Sep 2024 17:38:43 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 5261D1C23BD4
	for <lists+kvm@lfdr.de>; Thu, 12 Sep 2024 15:38:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6AF6B1B9B24;
	Thu, 12 Sep 2024 15:38:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="boSi4JFV"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6AF391B4C3F
	for <kvm@vger.kernel.org>; Thu, 12 Sep 2024 15:38:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726155516; cv=none; b=VJOg6p9Lkw8PXxZ4F1ZjShioFp5bFj67HJcKIBmdcKifl3BIOmfdlzN0fJ0WuQA2eZP/RLbSD48qBXCGeaO4RiRL0ntFEksYFMduN4bqujSnjsS9ywfAKHd5vDk/qzvnX5PlzvUlu1uja18U4kzAvZUAvUziSHGBIRfQBBmfv3c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726155516; c=relaxed/simple;
	bh=Z/37yDpEzegj4acK47vSsV2Vu3UGeesZJmiP2+h1CA8=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=TKF8Quok4fgsa4DbJ5SKPmKASZn0/MkZA4UoQAW2NKwaUOfqQ/xjdOQ3s2BfASSzQKftWDaFg5dkYvFTuT+ciIXYoYS6i6fcneY0j+vZYK1qWr02K4wa8biQgIRgp7+YT+T3eLvNo93rtcJFVyRg6lDkwW3CJX1Pk3wWda8eGfs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=boSi4JFV; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0353725.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 48CCfff7014165;
	Thu, 12 Sep 2024 15:36:02 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=
	message-id:subject:from:to:cc:date:in-reply-to:references
	:content-type:content-transfer-encoding:mime-version; s=pp1; bh=
	yG3RwRKYVV8o+TWmN0BvykfATMUgxIORVXcyp78ULHU=; b=boSi4JFV1d47E4xh
	xRPzoW7LqT9Wk2q+KSaAjBau67C9tUf8fWWa6Oa57/hXkY2dgj0e0KnXzU/Ni/ox
	aGMYqXX3ZE1B9d2nxq2jh8CLo982z4ha+lcCja5E4FvMG1n9ZQyLCxuxyIgAMQ3z
	aa2Rg5bSFhUA2UMwP7LhwWq5YKlK1q9bWqp+h71jnOuO37vuVLKjMq/2u7+oKmoq
	ZsGwuzdPlTvl8GMmjAnCgZIBWtQ1MSS9AuDwW0jNXyF/Impd9iuKxHAEQcNkMfqo
	YjV2sRLPiARVxUntZLQ9wpEXkoj4Ts8kI/c6jXhBuJai0o24IGIkSrzgPdgXwcVt
	ajd+Ww==
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 41gd8kvcb0-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 12 Sep 2024 15:36:01 +0000 (GMT)
Received: from m0353725.ppops.net (m0353725.ppops.net [127.0.0.1])
	by pps.reinject (8.18.0.8/8.18.0.8) with ESMTP id 48CFa0EV030118;
	Thu, 12 Sep 2024 15:36:00 GMT
Received: from ppma22.wdc07v.mail.ibm.com (5c.69.3da9.ip4.static.sl-reverse.com [169.61.105.92])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 41gd8kvcas-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 12 Sep 2024 15:36:00 +0000 (GMT)
Received: from pps.filterd (ppma22.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma22.wdc07v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 48CFWH2d010757;
	Thu, 12 Sep 2024 15:35:59 GMT
Received: from smtprelay06.dal12v.mail.ibm.com ([172.16.1.8])
	by ppma22.wdc07v.mail.ibm.com (PPS) with ESMTPS id 41kmb6vdym-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 12 Sep 2024 15:35:59 +0000
Received: from smtpav06.dal12v.mail.ibm.com (smtpav06.dal12v.mail.ibm.com [10.241.53.105])
	by smtprelay06.dal12v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 48CFZwdH55509414
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 12 Sep 2024 15:35:58 GMT
Received: from smtpav06.dal12v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 0545258043;
	Thu, 12 Sep 2024 15:35:58 +0000 (GMT)
Received: from smtpav06.dal12v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 6447858055;
	Thu, 12 Sep 2024 15:35:54 +0000 (GMT)
Received: from li-479af74c-31f9-11b2-a85c-e4ddee11713b.ibm.com (unknown [9.61.112.103])
	by smtpav06.dal12v.mail.ibm.com (Postfix) with ESMTP;
	Thu, 12 Sep 2024 15:35:54 +0000 (GMT)
Message-ID: <8d93598ebe29a8216e89c54b6a438d9fda67a118.camel@linux.ibm.com>
Subject: Re: [PATCH v2 14/48] include/hw/s390x: replace assert(false) with
 g_assert_not_reached()
From: Eric Farman <farman@linux.ibm.com>
To: Pierrick Bouvier <pierrick.bouvier@linaro.org>, qemu-devel@nongnu.org
Cc: Jason Wang <jasowang@redhat.com>,
        Alex =?ISO-8859-1?Q?Benn=E9e?=
 <alex.bennee@linaro.org>,
        Laurent Vivier <lvivier@redhat.com>,
        Marcelo
 Tosatti <mtosatti@redhat.com>,
        Nicholas Piggin <npiggin@gmail.com>, Klaus
 Jensen <its@irrelevant.dk>,
        WANG Xuerui <git@xen0n.name>, Halil Pasic
 <pasic@linux.ibm.com>,
        Rob Herring <robh@kernel.org>, Michael Rolnik
 <mrolnik@gmail.com>,
        Zhao Liu <zhao1.liu@intel.com>,
        Peter Maydell
 <peter.maydell@linaro.org>,
        Richard Henderson
 <richard.henderson@linaro.org>,
        Fabiano Rosas <farosas@suse.de>, Corey
 Minyard <minyard@acm.org>,
        Keith Busch <kbusch@kernel.org>, Thomas Huth
 <thuth@redhat.com>,
        "Maciej S. Szmigiero" <maciej.szmigiero@oracle.com>,
        Harsh Prateek Bora <harshpb@linux.ibm.com>,
        Kevin Wolf <kwolf@redhat.com>, Paolo Bonzini <pbonzini@redhat.com>,
        Jesper Devantier <foss@defmacro.it>,
        Hyman Huang <yong.huang@smartx.com>,
        Philippe
 =?ISO-8859-1?Q?Mathieu-Daud=E9?= <philmd@linaro.org>,
        Palmer Dabbelt
 <palmer@dabbelt.com>, qemu-s390x@nongnu.org,
        Laurent Vivier
 <laurent@vivier.eu>, qemu-riscv@nongnu.org,
        "Richard W.M. Jones"
 <rjones@redhat.com>,
        Liu Zhiwei <zhiwei_liu@linux.alibaba.com>,
        Aurelien
 Jarno <aurelien@aurel32.net>,
        "Daniel P." =?ISO-8859-1?Q?Berrang=E9?=
 <berrange@redhat.com>,
        Marcel Apfelbaum <marcel.apfelbaum@gmail.com>, kvm@vger.kernel.org,
        Christian Borntraeger <borntraeger@linux.ibm.com>,
        Akihiko Odaki <akihiko.odaki@daynix.com>,
        Daniel Henrique Barboza
 <dbarboza@ventanamicro.com>,
        Hanna Reitz <hreitz@redhat.com>, Ani Sinha
 <anisinha@redhat.com>,
        qemu-ppc@nongnu.org,
        =?ISO-8859-1?Q?Marc-Andr=E9?=
 Lureau <marcandre.lureau@redhat.com>,
        Alistair Francis
 <alistair.francis@wdc.com>,
        Bin Meng <bmeng.cn@gmail.com>, "Michael S.
 Tsirkin" <mst@redhat.com>,
        Helge Deller <deller@gmx.de>, Peter Xu
 <peterx@redhat.com>,
        Daniel Henrique Barboza <danielhb413@gmail.com>,
        Dmitry Fleytman <dmitry.fleytman@gmail.com>,
        Nina Schoetterl-Glausch
 <nsg@linux.ibm.com>,
        Yanan Wang <wangyanan55@huawei.com>, qemu-arm@nongnu.org,
        Igor Mammedov <imammedo@redhat.com>,
        Jean-Christophe
 Dubois <jcd@tribudubois.net>,
        Sriram Yagnaraman
 <sriram.yagnaraman@ericsson.com>,
        qemu-block@nongnu.org, Stefan Berger
 <stefanb@linux.vnet.ibm.com>,
        Joel Stanley <joel@jms.id.au>, Eduardo
 Habkost <eduardo@habkost.net>,
        David Gibson <david@gibson.dropbear.id.au>, Fam Zheng <fam@euphon.net>,
        Weiwei Li <liwei1518@gmail.com>,
        Markus
 Armbruster <armbru@redhat.com>
Date: Thu, 12 Sep 2024 11:35:53 -0400
In-Reply-To: <20240912073921.453203-15-pierrick.bouvier@linaro.org>
References: <20240912073921.453203-1-pierrick.bouvier@linaro.org>
	 <20240912073921.453203-15-pierrick.bouvier@linaro.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.52.4 (3.52.4-1.fc40) 
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: r9TPNGqGpx0_YhQSRS1-lT9seE_YIGR7
X-Proofpoint-ORIG-GUID: Gz5qt6Tm2MiyWvmu-JygOZPXVBetGDaf
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.680,FMLib:17.12.60.29
 definitions=2024-09-12_05,2024-09-12_01,2024-09-02_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 impostorscore=0 suspectscore=0 clxscore=1011 phishscore=0 spamscore=0
 lowpriorityscore=0 adultscore=0 mlxscore=0 mlxlogscore=727 bulkscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.19.0-2408220000 definitions=main-2409120114

On Thu, 2024-09-12 at 00:38 -0700, Pierrick Bouvier wrote:
> This patch is part of a series that moves towards a consistent use of
> g_assert_not_reached() rather than an ad hoc mix of different
> assertion mechanisms.
>=20
> Reviewed-by: Richard Henderson <richard.henderson@linaro.org>
> Reviewed-by: Thomas Huth <thuth@redhat.com>
> Signed-off-by: Pierrick Bouvier <pierrick.bouvier@linaro.org>
> ---
>  include/hw/s390x/cpu-topology.h | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)

Reviewed-by: Eric Farman <farman@linux.ibm.com>

