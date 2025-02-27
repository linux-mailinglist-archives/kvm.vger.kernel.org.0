Return-Path: <kvm+bounces-39572-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 4240FA47EBE
	for <lists+kvm@lfdr.de>; Thu, 27 Feb 2025 14:16:31 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id E0ECB1762E4
	for <lists+kvm@lfdr.de>; Thu, 27 Feb 2025 13:16:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6AAEF22FAC3;
	Thu, 27 Feb 2025 13:15:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="KFg7bbOd"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2FD38270021;
	Thu, 27 Feb 2025 13:15:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740662152; cv=none; b=HvEfHSHjtMhkZ9ffdvPC34bNtfvOVZ+wUKOPX4bJwcQ+aaDn1tk2LQj3hh85mUZeNEsGvT7x6eu8xT9jH5rZ3+6xHkhbxn0bW0IHnY12xQN1cCDj71AGF0nto/WKp5jbnEmvPKJwOzkkkON2xyM8ZsYN3nOHZiUs8PdlaW8kjZk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740662152; c=relaxed/simple;
	bh=Qjzx4/FNk9If3GDEW1Y/hPfr/hIF98jUsWXeBcxJfqE=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=JsCP7ec15Uxtkpit8zSHG22tjRUp2j+cq77OP3AVEyZ7s0aMmjdU1QYXUiRN9MMqUmVtbDuifIQfJJ+UGLb5UJOjJ3kCgPGoexhJG8aV8ZvBDlZwI8it3MH13DT/UL8M7mWoz/GaXUqgeUYWhhAj5xS2VngtFdURL+3XQDRBam4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=KFg7bbOd; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0353729.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 51R5Nr6a019655;
	Thu, 27 Feb 2025 13:15:48 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=pp1; bh=tVzqnTzkdBWYhrDV0iBqM5dpISbC9q
	hmc3fnBo9Zhp0=; b=KFg7bbOdgGE3SmYszA8sIdQvp9BZR0e7KgTjAI5moDmF0Z
	neRfuXS4BcGcMZTqH8IRVqWtO1qmEy3M7pgBYWfcgh3A+8iWzwFrdozcpeRqYLR7
	HsTIMjAk4zFSJcVAqhXrGx9PqrsOdrNEYVaWZdHQuT5heilpVHjPx6Zozvsy9qDh
	s+afjTU5Y+uAk9Or3lQSjMQVXpWGfP4dZouIPDCbJcv+nS/ll+H4hXyMbnAYTglU
	gIUTHALSlMhap443EgfbzxqHPWdW3D1ZWsJ0ZfjCMqCD4CiBix7gLMvUQyGBKNm6
	0s4V60HraWQTaekgPfulqNylUXh8+5ItNqsXRKRg==
Received: from ppma23.wdc07v.mail.ibm.com (5d.69.3da9.ip4.static.sl-reverse.com [169.61.105.93])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 452hv8t61y-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 27 Feb 2025 13:15:48 +0000 (GMT)
Received: from pps.filterd (ppma23.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma23.wdc07v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 51RCxRQt027396;
	Thu, 27 Feb 2025 13:15:47 GMT
Received: from smtprelay05.fra02v.mail.ibm.com ([9.218.2.225])
	by ppma23.wdc07v.mail.ibm.com (PPS) with ESMTPS id 44ytdkrnwk-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 27 Feb 2025 13:15:47 +0000
Received: from smtpav06.fra02v.mail.ibm.com (smtpav06.fra02v.mail.ibm.com [10.20.54.105])
	by smtprelay05.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 51RDFhrw56361336
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 27 Feb 2025 13:15:43 GMT
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 07CA520049;
	Thu, 27 Feb 2025 13:15:43 +0000 (GMT)
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id ACA0720040;
	Thu, 27 Feb 2025 13:15:42 +0000 (GMT)
Received: from li-1de7cd4c-3205-11b2-a85c-d27f97db1fe1.ibm.com (unknown [9.171.38.33])
	by smtpav06.fra02v.mail.ibm.com (Postfix) with ESMTPS;
	Thu, 27 Feb 2025 13:15:42 +0000 (GMT)
From: "Marc Hartmayer" <mhartmay@linux.ibm.com>
To: Nico Boehr <nrb@linux.ibm.com>, frankja@linux.ibm.com,
        imbrenda@linux.ibm.com, thuth@redhat.com
Cc: kvm@vger.kernel.org, linux-s390@vger.kernel.org
Subject: Re: [kvm-unit-tests PATCH v1] s390x: pv: fix arguments for
 out-of-tree-builds
In-Reply-To: <20250227131031.3811206-1-nrb@linux.ibm.com>
References: <20250227131031.3811206-1-nrb@linux.ibm.com>
Date: Thu, 27 Feb 2025 14:15:42 +0100
Message-ID: <87senzttoh.fsf@linux.ibm.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: 9k6giTRq43cOiAELmFOCPCQEIaND0Igu
X-Proofpoint-GUID: 9k6giTRq43cOiAELmFOCPCQEIaND0Igu
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1057,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2025-02-27_06,2025-02-27_01,2024-11-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1015 suspectscore=0
 phishscore=0 lowpriorityscore=0 malwarescore=0 adultscore=0 spamscore=0
 impostorscore=0 mlxlogscore=999 priorityscore=1501 mlxscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.19.0-2502100000
 definitions=main-2502270099

On Thu, Feb 27, 2025 at 02:10 PM +0100, Nico Boehr <nrb@linux.ibm.com> wrote:
> When building out-of-tree, the parmfile was not passed to genprotimg,
> causing the selftest-setup_PV test to fail.
>
> Fix the Makefile rule s.t. parmfile is correctly passed.
>
> Suggested-by: Marc Hartmayer <mhartmay@linux.ibm.com>
> Signed-off-by: Nico Boehr <nrb@linux.ibm.com>
> ---
>  s390x/Makefile | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/s390x/Makefile b/s390x/Makefile
> index 47dda6d26a6f..97ed0b473af5 100644
> --- a/s390x/Makefile
> +++ b/s390x/Makefile
> @@ -213,7 +213,7 @@ else
>  	GENPROTIMG_PCF := 0x000000e0
>  endif
>  
> -$(patsubst %.parmfile,%.pv.bin,$(wildcard s390x/*.parmfile)): %.pv.bin: %.parmfile
> +$(TEST_DIR)/selftest.pv.bin: $(SRCDIR)/s390x/selftest.parmfile
>  %.pv.bin: %.bin $(HOST_KEY_DOCUMENT) $(comm-key)
>  	$(eval parmfile_args = $(if $(filter %.parmfile,$^),--parmfile $(filter %.parmfile,$^),))
>  	$(GENPROTIMG) $(GENPROTIMG_DEFAULT_ARGS) --host-key-document $(HOST_KEY_DOCUMENT) $(GENPROTIMG_COMM_OPTION) $(comm-key) --x-pcf $(GENPROTIMG_PCF) $(parmfile_args) --image $(filter %.bin,$^) -o $@
> -- 
> 2.47.1

Reviewed-by: Marc Hartmayer <mhartmay@linux.ibm.com>

