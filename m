Return-Path: <kvm+bounces-5799-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 7C6F7826DE4
	for <lists+kvm@lfdr.de>; Mon,  8 Jan 2024 13:29:29 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 9336B1C2242A
	for <lists+kvm@lfdr.de>; Mon,  8 Jan 2024 12:29:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A4FAC4174F;
	Mon,  8 Jan 2024 12:27:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="eXwElvQ2"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 95E2341205
	for <kvm@vger.kernel.org>; Mon,  8 Jan 2024 12:27:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0353722.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 408CJ7eF011242;
	Mon, 8 Jan 2024 12:26:48 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : subject :
 from : to : cc : date : in-reply-to : references : content-type :
 content-transfer-encoding : mime-version; s=pp1;
 bh=GWZ5VSSILwvZEYjs2ah+vKQhv71Sizq1i7905GYRhVg=;
 b=eXwElvQ2AvLzT8soE9YIYlVKrCndglb1kIKoouuKU76bE7+DNgp0fD6YYJ+loqDS/6/Y
 s80tA2b98JpSCfA26XiYwgSWexblKVBHX4Xx6JD+HvFcQ8zo+/eX/ydma+hAPoYeVjOM
 PDOAhMQQIx3k3pc/y9cz7QSzYvZPGvp4vtq3Esbc3L9f9SgRjzrjU4ujze8fLW6zHqOK
 nl/EGDZMcHZGPMw4AG1bXzVX9+MpaJYc/R7GPhMytjP10aIZKnbJnR0VuRQ/YW5qsQ7A
 u7ykuStrbzvnGdeK+TFvh1A2g5aO+yyOKXQIvJXzmqkOZUTOy9vaRtVnHOeZGrv1AFeF Jw== 
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3vggxs857n-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 08 Jan 2024 12:26:47 +0000
Received: from m0353722.ppops.net (m0353722.ppops.net [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 408CMM9j023215;
	Mon, 8 Jan 2024 12:26:47 GMT
Received: from ppma22.wdc07v.mail.ibm.com (5c.69.3da9.ip4.static.sl-reverse.com [169.61.105.92])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3vggxs856j-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 08 Jan 2024 12:26:46 +0000
Received: from pps.filterd (ppma22.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma22.wdc07v.mail.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 408C5E66022845;
	Mon, 8 Jan 2024 12:26:44 GMT
Received: from smtprelay06.fra02v.mail.ibm.com ([9.218.2.230])
	by ppma22.wdc07v.mail.ibm.com (PPS) with ESMTPS id 3vfhjy7yjm-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 08 Jan 2024 12:26:44 +0000
Received: from smtpav03.fra02v.mail.ibm.com (smtpav03.fra02v.mail.ibm.com [10.20.54.102])
	by smtprelay06.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 408CQgO538797722
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 8 Jan 2024 12:26:42 GMT
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 951E420043;
	Mon,  8 Jan 2024 12:26:42 +0000 (GMT)
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id B6D5D20040;
	Mon,  8 Jan 2024 12:26:41 +0000 (GMT)
Received: from [9.155.200.166] (unknown [9.155.200.166])
	by smtpav03.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Mon,  8 Jan 2024 12:26:41 +0000 (GMT)
Message-ID: <1e5fb129a184ce743365f3503bc3ba2e47676b5c.camel@linux.ibm.com>
Subject: Re: [PATCH v2 08/43] qtest: bump npcm7xx_pwn-test timeout to 5
 minutes
From: Ilya Leoshkevich <iii@linux.ibm.com>
To: Alex =?ISO-8859-1?Q?Benn=E9e?= <alex.bennee@linaro.org>,
        qemu-devel@nongnu.org
Cc: qemu-s390x@nongnu.org, qemu-ppc@nongnu.org,
        Richard Henderson
 <richard.henderson@linaro.org>,
        Song Gao <gaosong@loongson.cn>,
        =?ISO-8859-1?Q?Marc-Andr=E9?= Lureau <marcandre.lureau@redhat.com>,
        David
 Hildenbrand <david@redhat.com>,
        Aurelien Jarno <aurelien@aurel32.net>,
        Yoshinori Sato <ysato@users.sourceforge.jp>,
        Yanan Wang
 <wangyanan55@huawei.com>,
        Bin Meng <bin.meng@windriver.com>,
        Laurent Vivier
 <lvivier@redhat.com>,
        Michael Rolnik <mrolnik@gmail.com>,
        Alexandre Iooss
 <erdnaxe@crans.org>,
        David Woodhouse <dwmw2@infradead.org>,
        Laurent Vivier
 <laurent@vivier.eu>,
        Paolo Bonzini <pbonzini@redhat.com>, Brian Cain
 <bcain@quicinc.com>,
        Daniel Henrique Barboza <danielhb413@gmail.com>,
        Beraldo Leal <bleal@redhat.com>, Paul Durrant <paul@xen.org>,
        Mahmoud
 Mandour <ma.mandourr@gmail.com>,
        Thomas Huth <thuth@redhat.com>,
        Liu
 Zhiwei <zhiwei_liu@linux.alibaba.com>,
        Cleber Rosa <crosa@redhat.com>, kvm@vger.kernel.org,
        Peter Maydell <peter.maydell@linaro.org>,
        Wainer dos
 Santos Moschetta <wainersm@redhat.com>,
        qemu-arm@nongnu.org, Weiwei Li
 <liwei1518@gmail.com>,
        Philippe =?ISO-8859-1?Q?Mathieu-Daud=E9?=
 <philmd@linaro.org>,
        John Snow <jsnow@redhat.com>,
        Daniel Henrique Barboza
 <dbarboza@ventanamicro.com>,
        Nicholas Piggin <npiggin@gmail.com>,
        Palmer
 Dabbelt <palmer@dabbelt.com>,
        Marcel Apfelbaum
 <marcel.apfelbaum@gmail.com>,
        =?ISO-8859-1?Q?C=E9dric?= Le Goater
 <clg@kaod.org>,
        "Edgar E. Iglesias" <edgar.iglesias@gmail.com>,
        Eduardo
 Habkost <eduardo@habkost.net>,
        Pierrick Bouvier
 <pierrick.bouvier@linaro.org>, qemu-riscv@nongnu.org,
        Alistair Francis
 <alistair.francis@wdc.com>,
        "Daniel P." =?ISO-8859-1?Q?Berrang=E9?=
 <berrange@redhat.com>
Date: Mon, 08 Jan 2024 13:26:41 +0100
In-Reply-To: <20240103173349.398526-9-alex.bennee@linaro.org>
References: <20240103173349.398526-1-alex.bennee@linaro.org>
	 <20240103173349.398526-9-alex.bennee@linaro.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.48.4 (3.48.4-1.fc38) 
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: 3n4703UJLu9UuNQtQwKGxRASFadYab6V
X-Proofpoint-ORIG-GUID: uFOpD788Yz5ZHIHSnHD0G_5gxHCVFtIt
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.997,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2024-01-08_04,2024-01-08_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 adultscore=0 mlxscore=0
 spamscore=0 clxscore=1011 phishscore=0 lowpriorityscore=0 bulkscore=0
 priorityscore=1501 mlxlogscore=922 suspectscore=0 impostorscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2311290000 definitions=main-2401080106

On Wed, 2024-01-03 at 17:33 +0000, Alex Benn=C3=A9e wrote:
> From: Daniel P. Berrang=C3=A9 <berrange@redhat.com>
>=20
> The npcm7xx_pwn-test takes 3 & 1/2 minutes in a --enable-debug build.
> Bumping to 5 minutes will give more headroom.
>=20
> Signed-off-by: Daniel P. Berrang=C3=A9 <berrange@redhat.com>
> Reviewed-by: Thomas Huth <thuth@redhat.com>
> Message-ID: <20230717182859.707658-5-berrange@redhat.com>
> Signed-off-by: Thomas Huth <thuth@redhat.com>
> Message-Id: <20231215070357.10888-5-thuth@redhat.com>
> Signed-off-by: Alex Benn=C3=A9e <alex.bennee@linaro.org>
> ---
> =C2=A0tests/qtest/meson.build | 2 +-
> =C2=A01 file changed, 1 insertion(+), 1 deletion(-)
>=20
> diff --git a/tests/qtest/meson.build b/tests/qtest/meson.build
> index 000ac54b7d6..84cec0a847d 100644
> --- a/tests/qtest/meson.build
> +++ b/tests/qtest/meson.build
> @@ -1,7 +1,7 @@
> =C2=A0slow_qtests =3D {
> =C2=A0=C2=A0 'bios-tables-test' : 120,
> =C2=A0=C2=A0 'migration-test' : 480,
> -=C2=A0 'npcm7xx_pwm-test': 150,
> +=C2=A0 'npcm7xx_pwm-test': 300,
> =C2=A0=C2=A0 'qom-test' : 900,
> =C2=A0=C2=A0 'test-hmp' : 120,
> =C2=A0}

Nit: s/pwn/pwm/ in the commit subject and message.

