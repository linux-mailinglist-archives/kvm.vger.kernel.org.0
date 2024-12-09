Return-Path: <kvm+bounces-33282-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 313409E8CD4
	for <lists+kvm@lfdr.de>; Mon,  9 Dec 2024 09:00:28 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 99EF0164DE1
	for <lists+kvm@lfdr.de>; Mon,  9 Dec 2024 08:00:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DDEAF21571F;
	Mon,  9 Dec 2024 07:59:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="ejg/aU4D"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 790AF215708;
	Mon,  9 Dec 2024 07:59:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733731186; cv=none; b=gz4NO8lRy8DwpnNUhLPFI+XgdmUqW9MjfBqEEAnzUqrXoQrZgZFM4wipjkEb844sP9KYcl6t2CFVE+FCTRbX4WaghVpt/5Y9Wolrid53iaetnJWdhS7bSC9ULv4sjxGeMfjFHkFRN4ApfHClB1Ez092kNHdZGZxGj/Q5MV1vWQk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733731186; c=relaxed/simple;
	bh=a4a70V6MW6N4+jR4dyMjFouk5yH5UGvtLrvsMqpnlH0=;
	h=Mime-Version:Content-Type:Date:Message-Id:From:To:Cc:Subject:
	 References:In-Reply-To; b=aovYB3CXHVs5/CwLKb02FPHXF4yLC76NSoiTZ7MvP6HydSb18eCwUJirOSO30RJZ1eCq2DKUvN+3dNhpTlWsi41BnPDtX/qLjPwAJmG7lk3Rz/FiyruyzM25LYPu2w4mXpcVQxCOOHbLem2FF+hC5qaruevHNFFYctE9ikww0j4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=ejg/aU4D; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0356517.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 4B8MQOdT006738;
	Mon, 9 Dec 2024 07:59:41 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=Nqy/tf
	mRvjnuKqOUAmwpbbcBzuyWaib5GSN9jxJpl8k=; b=ejg/aU4DZidLTdgy3coqfS
	nczY3CaNA6tCtLqSJ6h4oML8mUQCCquQ7Mz3hP3FQhk/TY3slGHekNd1U4xKmTsk
	IbHFSsK35rzwruSi0gc32B6pwG/X08+74Olisah+oJMG0wEH/s2VxFjmc0FhJeix
	BeEHukaSQKjBTBbmT1VG66WhUEobKd8YQyoGEvAGJgI7uuxJdHdOl02WgUbLo70Z
	VAcNFI2dKjpC7Po3CyUKVyfLE3fhbzgcn1j8bivipmc2hW3iB/CnOQUKS5wx8NxA
	3CjHkyqadSpQMEhoeEltYj/I+/kZQabtu9mOCcTmFb0aIx42uQyytYLMJFL5TrIg
	==
Received: from ppma13.dal12v.mail.ibm.com (dd.9e.1632.ip4.static.sl-reverse.com [50.22.158.221])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 43ce38g1dg-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 09 Dec 2024 07:59:40 +0000 (GMT)
Received: from pps.filterd (ppma13.dal12v.mail.ibm.com [127.0.0.1])
	by ppma13.dal12v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 4B97SqZj023039;
	Mon, 9 Dec 2024 07:59:39 GMT
Received: from smtprelay06.fra02v.mail.ibm.com ([9.218.2.230])
	by ppma13.dal12v.mail.ibm.com (PPS) with ESMTPS id 43d2wjnbm7-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 09 Dec 2024 07:59:39 +0000
Received: from smtpav06.fra02v.mail.ibm.com (smtpav06.fra02v.mail.ibm.com [10.20.54.105])
	by smtprelay06.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 4B97xaGN19923290
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 9 Dec 2024 07:59:36 GMT
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 377112004B;
	Mon,  9 Dec 2024 07:59:36 +0000 (GMT)
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 1611920040;
	Mon,  9 Dec 2024 07:59:36 +0000 (GMT)
Received: from t14-nrb (unknown [9.171.40.250])
	by smtpav06.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Mon,  9 Dec 2024 07:59:36 +0000 (GMT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Mon, 09 Dec 2024 08:59:35 +0100
Message-Id: <D670EQUUSVS6.1RFVHYTPER26Y@linux.ibm.com>
From: "Nico Boehr" <nrb@linux.ibm.com>
To: "Marc Hartmayer" <mhartmay@linux.ibm.com>, <linux-s390@vger.kernel.org>,
        "Thomas Huth" <thuth@redhat.com>
Cc: <kvm@vger.kernel.org>, "Janosch Frank" <frankja@linux.ibm.com>
Subject: Re: [kvm-unit-tests PATCH] s390x: Support newer version of
 genprotimg
X-Mailer: aerc 0.18.2
References: <20241205160011.100609-1-mhartmay@linux.ibm.com>
In-Reply-To: <20241205160011.100609-1-mhartmay@linux.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: A7l3KuGnLDlLHBCUeZMzmX5HkhVl5LNI
X-Proofpoint-ORIG-GUID: A7l3KuGnLDlLHBCUeZMzmX5HkhVl5LNI
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1051,Hydra:6.0.680,FMLib:17.12.62.30
 definitions=2024-10-15_01,2024-10-11_01,2024-09-30_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 adultscore=0 suspectscore=0
 spamscore=0 clxscore=1015 priorityscore=1501 lowpriorityscore=0
 impostorscore=0 bulkscore=0 mlxscore=0 malwarescore=0 mlxlogscore=999
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.19.0-2411120000 definitions=main-2412090061

On Thu Dec 5, 2024 at 5:00 PM CET, Marc Hartmayer wrote:
[...]
> diff --git a/s390x/Makefile b/s390x/Makefile
> index 23342bd64f44..3da3bebb6775 100644
> --- a/s390x/Makefile
> +++ b/s390x/Makefile
> @@ -197,17 +197,26 @@ $(comm-key):
>  %.bin: %.elf
>  	$(OBJCOPY) -O binary  $< $@
> =20
> +define test_genprotimg_opt
> +$(shell $(GENPROTIMG) --help | grep -q -- "$1" && echo yes || echo no)
> +endef
> +
> +GENPROTIMG_DEFAULT_ARGS :=3D --no-verify
> +ifneq ($(HOST_KEY_DOCUMENT),)
>  # The genprotimg arguments for the cck changed over time so we need to
>  # figure out which argument to use in order to set the cck
> -ifneq ($(HOST_KEY_DOCUMENT),)
> -GENPROTIMG_HAS_COMM_KEY =3D $(shell $(GENPROTIMG) --help | grep -q -- --=
comm-key && echo yes)
> -ifeq ($(GENPROTIMG_HAS_COMM_KEY),yes)
> +ifeq ($(call test_genprotimg_opt,--comm-key),yes)
>  	GENPROTIMG_COMM_OPTION :=3D --comm-key
>  else
>  	GENPROTIMG_COMM_OPTION :=3D --x-comm-key
>  endif
> -else
> -GENPROTIMG_HAS_COMM_KEY =3D
> +# Newer version of the genprotimg command checks if the given image/kern=
el is a

After having my first cup of coffee, one question: at which version did thi=
s behaviour change?

