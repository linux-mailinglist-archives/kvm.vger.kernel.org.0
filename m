Return-Path: <kvm+bounces-2880-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 393F37FEBAA
	for <lists+kvm@lfdr.de>; Thu, 30 Nov 2023 10:16:26 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id A2A01B20FC2
	for <lists+kvm@lfdr.de>; Thu, 30 Nov 2023 09:16:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1CD47374C1;
	Thu, 30 Nov 2023 09:16:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="AFBdvLer"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1D80010EA
	for <kvm@vger.kernel.org>; Thu, 30 Nov 2023 01:16:08 -0800 (PST)
Received: from pps.filterd (m0353729.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 3AU9CGNH028745;
	Thu, 30 Nov 2023 09:14:59 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : subject :
 from : to : cc : date : in-reply-to : references : content-type :
 content-transfer-encoding : mime-version; s=pp1;
 bh=U7xhAiXyHYuSi9gQG6NV4CZH7LkdmdMB32D1ZOqvl2E=;
 b=AFBdvLera18ekFkEDQHSP2T6dJxy+bj5KW/jP/YQxVyqxiHZtRJXrFC+0ntnZuEvmXMl
 m5dICRXNSmZBGnKsumVVgBAXL4u0dvBZSGFJjow9KpyWozqGgg5e9lV0A3P1DYtJVgrk
 fcIAkenPAVxLZnA9inVImJFIRFFp84wVlNbQYq2PnUAD94eddwhNGmE1WEaq+o2oyHt9
 lgMLNpBO+kPcZI3+78p/T21qN3TQ/nrMIklnS6Mpmi8dOIQR1PJPM8F2VFLdmlnmfYt2
 bNGyD4yvrGuvjfFw260kty5gkpovVQqcuoFvY7pDIz7evPqH74AstesKRFOdN22SZxO6 0g== 
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3upqj4g6aa-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 30 Nov 2023 09:14:59 +0000
Received: from m0353729.ppops.net (m0353729.ppops.net [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 3AU9CSaJ029884;
	Thu, 30 Nov 2023 09:14:58 GMT
Received: from ppma12.dal12v.mail.ibm.com (dc.9e.1632.ip4.static.sl-reverse.com [50.22.158.220])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3upqj4g684-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 30 Nov 2023 09:14:58 +0000
Received: from pps.filterd (ppma12.dal12v.mail.ibm.com [127.0.0.1])
	by ppma12.dal12v.mail.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 3AU7Xw9A030737;
	Thu, 30 Nov 2023 09:14:55 GMT
Received: from smtprelay05.fra02v.mail.ibm.com ([9.218.2.225])
	by ppma12.dal12v.mail.ibm.com (PPS) with ESMTPS id 3uku8tddeu-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 30 Nov 2023 09:14:55 +0000
Received: from smtpav01.fra02v.mail.ibm.com (smtpav01.fra02v.mail.ibm.com [10.20.54.100])
	by smtprelay05.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 3AU9EqIJ6750948
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 30 Nov 2023 09:14:52 GMT
Received: from smtpav01.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 6F14720043;
	Thu, 30 Nov 2023 09:14:52 +0000 (GMT)
Received: from smtpav01.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 2CB6D20040;
	Thu, 30 Nov 2023 09:14:48 +0000 (GMT)
Received: from [9.171.32.92] (unknown [9.171.32.92])
	by smtpav01.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Thu, 30 Nov 2023 09:14:48 +0000 (GMT)
Message-ID: <c3ac8d9c2b9d611e84672436ce1a96aedcaacf5e.camel@linux.ibm.com>
Subject: Re: [PATCH 2/6] qemu/main-loop: rename QEMU_IOTHREAD_LOCK_GUARD to
 QEMU_BQL_LOCK_GUARD
From: Ilya Leoshkevich <iii@linux.ibm.com>
To: Stefan Hajnoczi <stefanha@redhat.com>, qemu-devel@nongnu.org
Cc: Jean-Christophe Dubois <jcd@tribudubois.net>,
        Fabiano Rosas
 <farosas@suse.de>, qemu-s390x@nongnu.org,
        Song Gao <gaosong@loongson.cn>,
        Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
        Thomas Huth
 <thuth@redhat.com>, Hyman Huang <yong.huang@smartx.com>,
        Marcelo Tosatti
 <mtosatti@redhat.com>,
        David Woodhouse <dwmw2@infradead.org>,
        Andrey
 Smirnov <andrew.smirnov@gmail.com>,
        Peter Maydell
 <peter.maydell@linaro.org>,
        Kevin Wolf <kwolf@redhat.com>, Artyom Tarasenko
 <atar4qemu@gmail.com>,
        Mark Cave-Ayland <mark.cave-ayland@ilande.co.uk>,
        Max Filippov <jcmvbkbc@gmail.com>,
        Alistair Francis
 <alistair.francis@wdc.com>,
        Paul Durrant <paul@xen.org>, Jagannathan Raman
 <jag.raman@oracle.com>,
        Juan Quintela <quintela@redhat.com>,
        "Daniel P."
 =?ISO-8859-1?Q?Berrang=E9?= <berrange@redhat.com>,
        qemu-arm@nongnu.org, Jason Wang <jasowang@redhat.com>,
        Gerd Hoffmann <kraxel@redhat.com>, Hanna
 Reitz <hreitz@redhat.com>,
        =?ISO-8859-1?Q?Marc-Andr=E9?= Lureau
 <marcandre.lureau@redhat.com>,
        BALATON Zoltan <balaton@eik.bme.hu>,
        Daniel
 Henrique Barboza <danielhb413@gmail.com>,
        Elena Ufimtseva
 <elena.ufimtseva@oracle.com>,
        Aurelien Jarno <aurelien@aurel32.net>,
        Hailiang Zhang <zhanghailiang@xfusion.com>,
        Roman Bolshakov
 <rbolshakov@ddn.com>,
        Huacai Chen <chenhuacai@kernel.org>, Fam Zheng
 <fam@euphon.net>,
        Eric Blake <eblake@redhat.com>, Jiri Slaby
 <jslaby@suse.cz>,
        Alexander Graf <agraf@csgraf.de>,
        Liu Zhiwei
 <zhiwei_liu@linux.alibaba.com>,
        Weiwei Li <liwei1518@gmail.com>, Eric
 Farman <farman@linux.ibm.com>,
        Stafford Horne <shorne@gmail.com>,
        David
 Hildenbrand <david@redhat.com>,
        Markus Armbruster <armbru@redhat.com>,
        Reinoud Zandijk <reinoud@netbsd.org>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Cameron Esfahani <dirty@apple.com>, xen-devel@lists.xenproject.org,
        Pavel
 Dovgalyuk <pavel.dovgaluk@ispras.ru>, qemu-riscv@nongnu.org,
        Aleksandar
 Rikalo <aleksandar.rikalo@syrmia.com>,
        John Snow <jsnow@redhat.com>,
        Sunil
 Muthuswamy <sunilmut@microsoft.com>,
        Michael Roth <michael.roth@amd.com>,
        David Gibson <david@gibson.dropbear.id.au>,
        "Michael S. Tsirkin"
 <mst@redhat.com>,
        Richard Henderson <richard.henderson@linaro.org>,
        Bin
 Meng <bin.meng@windriver.com>,
        Stefano Stabellini <sstabellini@kernel.org>, kvm@vger.kernel.org,
        qemu-block@nongnu.org, Halil Pasic
 <pasic@linux.ibm.com>,
        Peter Xu <peterx@redhat.com>,
        Anthony Perard
 <anthony.perard@citrix.com>,
        Harsh Prateek Bora <harshpb@linux.ibm.com>,
        Alex =?ISO-8859-1?Q?Benn=E9e?= <alex.bennee@linaro.org>,
        Eduardo Habkost
 <eduardo@habkost.net>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Vladimir
 Sementsov-Ogievskiy <vsementsov@yandex-team.ru>,
        =?ISO-8859-1?Q?C=E9dric?=
 Le Goater <clg@kaod.org>,
        qemu-ppc@nongnu.org,
        Philippe
 =?ISO-8859-1?Q?Mathieu-Daud=E9?= <philmd@linaro.org>,
        Christian Borntraeger
 <borntraeger@linux.ibm.com>,
        Akihiko Odaki <akihiko.odaki@daynix.com>,
        Leonardo Bras <leobras@redhat.com>,
        Nicholas Piggin <npiggin@gmail.com>,
        Jiaxun Yang <jiaxun.yang@flygoat.com>
Date: Thu, 30 Nov 2023 10:14:47 +0100
In-Reply-To: <20231129212625.1051502-3-stefanha@redhat.com>
References: <20231129212625.1051502-1-stefanha@redhat.com>
	 <20231129212625.1051502-3-stefanha@redhat.com>
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
X-Proofpoint-ORIG-GUID: k5g-bglZZ81amYqAueJeLCJOKEKz4uGW
X-Proofpoint-GUID: hyHEB3c1P1gBAyQsdYHk4l82Bt-Qzmtx
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.997,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2023-11-30_07,2023-11-29_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 mlxscore=0 bulkscore=0 adultscore=0 spamscore=0
 lowpriorityscore=0 suspectscore=0 clxscore=1011 impostorscore=0
 phishscore=0 mlxlogscore=810 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2311060000 definitions=main-2311300068

On Wed, 2023-11-29 at 16:26 -0500, Stefan Hajnoczi wrote:
> The name "iothread" is overloaded. Use the term Big QEMU Lock (BQL)
> instead, it is already widely used and unambiguous.
>=20
> Signed-off-by: Stefan Hajnoczi <stefanha@redhat.com>
> ---
> =C2=A0include/qemu/main-loop.h=C2=A0 | 20 ++++++++++----------
> =C2=A0hw/i386/kvm/xen_evtchn.c=C2=A0 | 14 +++++++-------
> =C2=A0hw/i386/kvm/xen_gnttab.c=C2=A0 |=C2=A0 2 +-
> =C2=A0hw/mips/mips_int.c=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 |=C2=
=A0 2 +-
> =C2=A0hw/ppc/ppc.c=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0 |=C2=A0 2 +-
> =C2=A0target/i386/kvm/xen-emu.c |=C2=A0 2 +-
> =C2=A0target/ppc/excp_helper.c=C2=A0 |=C2=A0 2 +-
> =C2=A0target/ppc/helper_regs.c=C2=A0 |=C2=A0 2 +-
> =C2=A0target/riscv/cpu_helper.c |=C2=A0 4 ++--
> =C2=A09 files changed, 25 insertions(+), 25 deletions(-)
>=20
> diff --git a/include/qemu/main-loop.h b/include/qemu/main-loop.h
> index d6f75e57bd..0b6a3e4824 100644
> --- a/include/qemu/main-loop.h
> +++ b/include/qemu/main-loop.h
> @@ -344,13 +344,13 @@ void qemu_bql_lock_impl(const char *file, int
> line);
> =C2=A0void qemu_bql_unlock(void);
> =C2=A0
> =C2=A0/**
> - * QEMU_IOTHREAD_LOCK_GUARD
> + * QEMU_BQL_LOCK_GUARD
> =C2=A0 *
> - * Wrap a block of code in a conditional
> qemu_mutex_{lock,unlock}_iothread.
> + * Wrap a block of code in a conditional qemu_bql_{lock,unlock}.
> =C2=A0 */
> -typedef struct IOThreadLockAuto IOThreadLockAuto;
> +typedef struct BQLLockAuto BQLLockAuto;
> =C2=A0
> -static inline IOThreadLockAuto *qemu_iothread_auto_lock(const char
> *file,
> +static inline BQLLockAuto *qemu_bql_auto_lock(const char *file,
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 int line)

The padding is not correct anymore.

Other than this:

Acked-by: Ilya Leoshkevich <iii@linux.ibm.com>

