Return-Path: <kvm+bounces-5880-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 442D2828708
	for <lists+kvm@lfdr.de>; Tue,  9 Jan 2024 14:27:35 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 3D6D21C24338
	for <lists+kvm@lfdr.de>; Tue,  9 Jan 2024 13:27:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 306C438F9B;
	Tue,  9 Jan 2024 13:27:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="htpJk0nu"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B6A41381DB;
	Tue,  9 Jan 2024 13:27:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0353727.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 409CvJ60016248;
	Tue, 9 Jan 2024 13:27:24 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : in-reply-to : references : date : message-id : mime-version :
 content-type : content-transfer-encoding; s=pp1;
 bh=nHUmKyF9Gzjnhth+2ustS5mJ97YUJXAUGHnbAt9c2jg=;
 b=htpJk0nuCTBrJNeCq+fJThIoOW/S6uC8+w4OUAtbR6QEupwDYlJW9RMHC6jD2mGKKpTV
 gmKbSkjuefKADdFISzeZQiHh9l+2MSNIR1Pj272JuLD5l/AbmaKhLZwnGlO4AdgI0kim
 Xvfs1ZlFDFvA1io6rrV67IUIK0HJKU1F1FqGO6jffJ9by+H+oZk3RaCrmUcUqr4x/AsD
 UusG7cKL1l5jR9JBv6h7pWhpJ+aLUdbwp4IaFbAFMUOcd671TIT4tNuwuZ3MWtLWYiZs
 kL0jPGda3wpb9qPrbNTe58sPqW42dKOuO7dmw5VmxffhjMCPYR2kADVGPhef15l86RlR WQ== 
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3vh6kn0qgb-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 09 Jan 2024 13:27:24 +0000
Received: from m0353727.ppops.net (m0353727.ppops.net [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 409DOolv006193;
	Tue, 9 Jan 2024 13:27:24 GMT
Received: from ppma12.dal12v.mail.ibm.com (dc.9e.1632.ip4.static.sl-reverse.com [50.22.158.220])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3vh6kn0qft-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 09 Jan 2024 13:27:24 +0000
Received: from pps.filterd (ppma12.dal12v.mail.ibm.com [127.0.0.1])
	by ppma12.dal12v.mail.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 409D1SEk028052;
	Tue, 9 Jan 2024 13:27:23 GMT
Received: from smtprelay06.fra02v.mail.ibm.com ([9.218.2.230])
	by ppma12.dal12v.mail.ibm.com (PPS) with ESMTPS id 3vgwfsjr6m-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 09 Jan 2024 13:27:23 +0000
Received: from smtpav03.fra02v.mail.ibm.com (smtpav03.fra02v.mail.ibm.com [10.20.54.102])
	by smtprelay06.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 409DRKqD42599102
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 9 Jan 2024 13:27:20 GMT
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 2A9E920043;
	Tue,  9 Jan 2024 13:27:20 +0000 (GMT)
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 02B4B20040;
	Tue,  9 Jan 2024 13:27:20 +0000 (GMT)
Received: from li-1de7cd4c-3205-11b2-a85c-d27f97db1fe1.ibm.com (unknown [9.152.224.43])
	by smtpav03.fra02v.mail.ibm.com (Postfix) with ESMTPS;
	Tue,  9 Jan 2024 13:27:19 +0000 (GMT)
From: "Marc Hartmayer" <mhartmay@linux.ibm.com>
To: Janosch Frank <frankja@linux.ibm.com>,
        Claudio Imbrenda
 <imbrenda@linux.ibm.com>,
        Nico Boehr <nrb@linux.ibm.com>, Thomas Huth
 <thuth@redhat.com>
Cc: kvm@vger.kernel.org, linux-s390@vger.kernel.org
Subject: Re: [kvm-unit-tests PATCH v1] s390x/Makefile: simplify Secure
 Execution boot image generation
In-Reply-To: <20231121172338.146006-1-mhartmay@linux.ibm.com>
References: <20231121172338.146006-1-mhartmay@linux.ibm.com>
Date: Tue, 09 Jan 2024 14:27:18 +0100
Message-ID: <87bk9ueix5.fsf@linux.ibm.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: Mi4A4rk9ycU9J_QywO4uiGM5krq-a9TK
X-Proofpoint-GUID: FtAqLi63zhQFFl-wD4Dsus5lEeyKbjIK
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.997,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2024-01-09_05,2024-01-09_02,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0 phishscore=0
 malwarescore=0 priorityscore=1501 mlxlogscore=999 clxscore=1011 mlxscore=0
 lowpriorityscore=0 suspectscore=0 bulkscore=0 adultscore=0 spamscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2311290000
 definitions=main-2401090111

On Tue, Nov 21, 2023 at 06:23 PM +0100, Marc Hartmayer <mhartmay@linux.ibm.=
com> wrote:
> Changes:
> + merge Makefile rules for the generation of the Secure Execution boot
>   image
> + fix `parmfile` dependency for the `selftest.pv.bin` target
> + rename `genprotimg_pcf` to `GENPROTIMG_PCF` to match the coding style
>   in the file
> + always provide a customer communication key - not only for the
>   confidential dump case. Makes the code little easier and doesn't hurt.
>
> Signed-off-by: Marc Hartmayer <mhartmay@linux.ibm.com>
> ---
>  s390x/Makefile | 40 +++++++++++++++++-----------------------
>  1 file changed, 17 insertions(+), 23 deletions(-)
>
> diff --git a/s390x/Makefile b/s390x/Makefile
> index f79fd0098312..be89d8de1cba 100644
> --- a/s390x/Makefile
> +++ b/s390x/Makefile
> @@ -194,33 +194,27 @@ $(comm-key):
>  %.bin: %.elf
>  	$(OBJCOPY) -O binary  $< $@
>=20=20
> -# Will only be filled when dump has been enabled
> -GENPROTIMG_COMM_KEY =3D
> -# allow PCKMO
> -genprotimg_pcf =3D 0x000000e0
> -
> -ifeq ($(CONFIG_DUMP),yes)
> -	# The genprotimg arguments for the cck changed over time so we need to
> -	# figure out which argument to use in order to set the cck
> -	GENPROTIMG_HAS_COMM_KEY =3D $(shell $(GENPROTIMG) --help | grep -q -- -=
-comm-key && echo yes)
> -	ifeq ($(GENPROTIMG_HAS_COMM_KEY),yes)
> -		GENPROTIMG_COMM_KEY =3D --comm-key $(comm-key)
> -	else
> -		GENPROTIMG_COMM_KEY =3D --x-comm-key $(comm-key)
> -	endif
> -
> -	# allow dumping + PCKMO
> -	genprotimg_pcf =3D 0x200000e0
> +# The genprotimg arguments for the cck changed over time so we need to
> +# figure out which argument to use in order to set the cck
> +GENPROTIMG_HAS_COMM_KEY =3D $(shell $(GENPROTIMG) --help | grep -q -- --=
comm-key && echo yes)
> +ifeq ($(GENPROTIMG_HAS_COMM_KEY),yes)
> +	GENPROTIMG_COMM_OPTION :=3D --comm-key
> +else
> +	GENPROTIMG_COMM_OPTION :=3D --x-comm-key
>  endif
>=20=20
> -# use x-pcf to be compatible with old genprotimg versions
> -genprotimg_args =3D --host-key-document $(HOST_KEY_DOCUMENT) --no-verify=
 $(GENPROTIMG_COMM_KEY) --x-pcf $(genprotimg_pcf)
> -
> -%selftest.pv.bin: %selftest.bin $(HOST_KEY_DOCUMENT) $(patsubst %.pv.bin=
,%.parmfile,$@) $(comm-key)
> -	$(GENPROTIMG) $(genprotimg_args) --parmfile $(patsubst %.pv.bin,%.parmf=
ile,$@) --image $< -o $@
> +ifeq ($(CONFIG_DUMP),yes)
> +	# allow dumping + PCKMO
> +	GENPROTIMG_PCF :=3D 0x200000e0
> +else
> +	# allow PCKMO
> +	GENPROTIMG_PCF :=3D 0x000000e0
> +endif
>=20=20
> +$(patsubst %.parmfile,%.pv.bin,$(wildcard s390x/*.parmfile)): %.pv.bin: =
%.parmfile
>  %.pv.bin: %.bin $(HOST_KEY_DOCUMENT) $(comm-key)
> -	$(GENPROTIMG) $(genprotimg_args) --image $< -o $@
> +	$(eval parmfile_args =3D $(if $(filter %.parmfile,$^),--parmfile $(filt=
er %.parmfile,$^),))
> +	$(GENPROTIMG) --host-key-document $(HOST_KEY_DOCUMENT) --no-verify $(GE=
NPROTIMG_COMM_OPTION) $(comm-key) --x-pcf $(GENPROTIMG_PCF) $(parmfile_args=
) --image $(filter %.bin,$^) -o $@
>=20=20
>  $(snippet_asmlib): $$(patsubst %.o,%.S,$$@) $(asm-offsets)
>  	$(CC) $(CFLAGS) -c -nostdlib -o $@ $<
>
> base-commit: d0891021d5ad244c99290b4515152a1f997a9404
> --=20
> 2.34.1
>
>

Polite ping.

--=20
Kind regards / Beste Gr=C3=BC=C3=9Fe
   Marc Hartmayer

IBM Deutschland Research & Development GmbH
Vorsitzender des Aufsichtsrats: Gregor Pillen
Gesch=C3=A4ftsf=C3=BChrung: David Faller
Sitz der Gesellschaft: B=C3=B6blingen
Registergericht: Amtsgericht Stuttgart, HRB 243294

