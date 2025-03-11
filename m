Return-Path: <kvm+bounces-40753-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 24AB5A5BB95
	for <lists+kvm@lfdr.de>; Tue, 11 Mar 2025 10:03:29 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id BB82A1883682
	for <lists+kvm@lfdr.de>; Tue, 11 Mar 2025 09:03:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 449D02206A7;
	Tue, 11 Mar 2025 09:03:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="LRTIRk/K"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A038E1E8325;
	Tue, 11 Mar 2025 09:03:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741683801; cv=none; b=dq7VRVNU+M+e3wLx9iPc63AuF/IPFzBeSBRovam/DO+IC1P32Y8lrGb8bewybI6nVNkG+/Ro/BqbE7S6/ZFj4CkAzm0zOVN1KxjIRUCudsMSvmuVHbno1u23jsMKkIl1yca1IfkR/1U0YblVt7htgl64gvoAYONaRI83nmNFXWY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741683801; c=relaxed/simple;
	bh=pjEg5cmLEj5ooQVvL49nmBZYAhf5d8xz543Q8kEuuPc=;
	h=Mime-Version:Content-Type:Date:Message-Id:To:Cc:Subject:From:
	 References:In-Reply-To; b=knPmDs17EfOjXyJ0V78HPT6L3DpkOO9ri53TgzkyvgLV/7NByX7H6FCt4YvZ5/A4N/6Jq85biXXT790jyDDkaL9ZUrUKlIkRreN/71eKITd+Y1uzwkUjRisPc6+fbmsKgUiqH5/FF9a5U6eJWv78a5WA1yAsTX5BNUCeGhAZrGs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=LRTIRk/K; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0356516.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 52B7axre004999;
	Tue, 11 Mar 2025 09:03:15 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=pvB777
	kIThSkt/KxU+Ma6cpWoL4Ow0d5CmXaNiO+TN8=; b=LRTIRk/KlMH5nhye4u5uEa
	wogGKB8GL0Et7qqdMvBZfb8oA2wKcLLOE2pNbgqb/JvYYAwnsR8cJ+LTAc+6t1rj
	XAlP68qKuxTjzkvHYiO98wGKsge/TrF3mlUZSg7QwieDWt2u0VD35hC89oiU0us0
	07D01603l6ntewauga/eezav9zvLKndTW+mGTAv+tFFCZBRqYAV8Bi1rqM4RyjI3
	neBnsvkkXRqlGaA6Ybdfpk2vJs0OJIyG1b38nWgSsRR7aAMJt7eX5BC++tH+ObTk
	luRAHFmpKAboWr28EDp4Bs/M1H5IDhaqMr41O1+SPwyP9Wb1bcT7KLhLMGsnmtzA
	==
Received: from ppma12.dal12v.mail.ibm.com (dc.9e.1632.ip4.static.sl-reverse.com [50.22.158.220])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 45a78qtt4w-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 11 Mar 2025 09:03:14 +0000 (GMT)
Received: from pps.filterd (ppma12.dal12v.mail.ibm.com [127.0.0.1])
	by ppma12.dal12v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 52B8gOkj007011;
	Tue, 11 Mar 2025 09:03:14 GMT
Received: from smtprelay05.fra02v.mail.ibm.com ([9.218.2.225])
	by ppma12.dal12v.mail.ibm.com (PPS) with ESMTPS id 45907t3gvc-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 11 Mar 2025 09:03:14 +0000
Received: from smtpav01.fra02v.mail.ibm.com (smtpav01.fra02v.mail.ibm.com [10.20.54.100])
	by smtprelay05.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 52B93BS656820078
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 11 Mar 2025 09:03:11 GMT
Received: from smtpav01.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id F09BF20040;
	Tue, 11 Mar 2025 09:03:10 +0000 (GMT)
Received: from smtpav01.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 9D77020043;
	Tue, 11 Mar 2025 09:03:10 +0000 (GMT)
Received: from t14-nrb (unknown [9.179.15.153])
	by smtpav01.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Tue, 11 Mar 2025 09:03:10 +0000 (GMT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Tue, 11 Mar 2025 10:03:10 +0100
Message-Id: <D8DBDJDQ6EAC.36V0PWNW1R4MH@linux.ibm.com>
To: "Janosch Frank" <frankja@linux.ibm.com>, <imbrenda@linux.ibm.com>,
        <thuth@redhat.com>
Cc: <kvm@vger.kernel.org>, <linux-s390@vger.kernel.org>
Subject: Re: [kvm-unit-tests PATCH v1] s390x: pv: fix arguments for
 out-of-tree-builds
From: "Nico Boehr" <nrb@linux.ibm.com>
X-Mailer: aerc 0.20.1
References: <20250227131031.3811206-1-nrb@linux.ibm.com>
 <aa9bd929-e2b9-4772-9802-171c30036dff@linux.ibm.com>
In-Reply-To: <aa9bd929-e2b9-4772-9802-171c30036dff@linux.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: ag5WFr6-MB5KlmPOGBDwb5qfmhSvrA0F
X-Proofpoint-ORIG-GUID: ag5WFr6-MB5KlmPOGBDwb5qfmhSvrA0F
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1093,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2025-03-11_01,2025-03-11_01,2024-11-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1015 impostorscore=0
 spamscore=0 adultscore=0 mlxlogscore=999 phishscore=0 priorityscore=1501
 lowpriorityscore=0 malwarescore=0 bulkscore=0 suspectscore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.19.0-2502100000
 definitions=main-2503110060

On Mon Mar 10, 2025 at 1:20 PM CET, Janosch Frank wrote:
> On 2/27/25 2:10 PM, Nico Boehr wrote:
>> When building out-of-tree, the parmfile was not passed to genprotimg,
>> causing the selftest-setup_PV test to fail.
>>=20
>> Fix the Makefile rule s.t. parmfile is correctly passed.
>>=20
>> Suggested-by: Marc Hartmayer <mhartmay@linux.ibm.com>
>> Signed-off-by: Nico Boehr <nrb@linux.ibm.com>
>> ---
>>   s390x/Makefile | 2 +-
>>   1 file changed, 1 insertion(+), 1 deletion(-)
>>=20
>> diff --git a/s390x/Makefile b/s390x/Makefile
>> index 47dda6d26a6f..97ed0b473af5 100644
>> --- a/s390x/Makefile
>> +++ b/s390x/Makefile
>> @@ -213,7 +213,7 @@ else
>>   	GENPROTIMG_PCF :=3D 0x000000e0
>>   endif
>>  =20
>> -$(patsubst %.parmfile,%.pv.bin,$(wildcard s390x/*.parmfile)): %.pv.bin:=
 %.parmfile
>> +$(TEST_DIR)/selftest.pv.bin: $(SRCDIR)/s390x/selftest.parmfile
>>   %.pv.bin: %.bin $(HOST_KEY_DOCUMENT) $(comm-key)
>>   	$(eval parmfile_args =3D $(if $(filter %.parmfile,$^),--parmfile $(fi=
lter %.parmfile,$^),))
>>   	$(GENPROTIMG) $(GENPROTIMG_DEFAULT_ARGS) --host-key-document $(HOST_K=
EY_DOCUMENT) $(GENPROTIMG_COMM_OPTION) $(comm-key) --x-pcf $(GENPROTIMG_PCF=
) $(parmfile_args) --image $(filter %.bin,$^) -o $@
>
>
> We had this hardcoded, then changed to this rule and now move back to=20
> hardcoding, no?

I mean the preferred way would be to not hardcode it _and_ have out of tree
builds working, but I (with my limited makefile knowledge) couldn't get thi=
s to
work properly. I will of course take patches... :-)

Since I had a unpleasant surprise with the upstream CI and out-of-tree-buil=
ds
recently, I thought it's acceptable to remove flexibility that nobody uses.

