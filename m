Return-Path: <kvm+bounces-32197-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id CA8AF9D41B2
	for <lists+kvm@lfdr.de>; Wed, 20 Nov 2024 18:52:34 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id DE967B27EE8
	for <lists+kvm@lfdr.de>; Wed, 20 Nov 2024 17:37:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 424421AB523;
	Wed, 20 Nov 2024 17:37:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="PEB8Vnr3"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AC525482EF;
	Wed, 20 Nov 2024 17:37:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732124235; cv=none; b=acrKFQZ4VavXM0ljAyjyaGd3zh7ArH5esy/R7qAwivtnQ85+KmbfiUiVl0dEfuPTvhsMUCvW/hxpa0pwHFs1gSKK1wWnuc/nWBFPN2i5xqCRq7qAZNQKFpAVDBMk+dlmBy9Fgk+K9HnM5U+9/WkWbSbU1F5LAfF1bq4jmEonFG0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732124235; c=relaxed/simple;
	bh=/NT/97QuQ/L28XCDoJk9G8G5nJzx4P0Y8UUD5/Vo9k4=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=fbr3r+1RKtFfBSK7s9knXzCXZKTkb7i57HKRJDP4nCqOlOPUjynwBBsjTQbWKgnLV719SE+43cfiXN1lXCO1AgWvFEhI03eR8Py/C7AZsAetrYzy1qsywd+dr+acg4ddN3C9sgCnZm3CrwXntJKNqJl5R07tyh4mCQ2y4TDckZU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=PEB8Vnr3; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0356516.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 4AKHS9GL024342;
	Wed, 20 Nov 2024 17:37:11 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=msqb9M
	cdT9p45kO7DPVC1vjEgZfG1YQ9f7OsUFNEb/c=; b=PEB8Vnr3CMeie6/uL7Gpby
	YVUnnPzdKkb9mCXZ+4hpFfmDDoVf3hJ1uRFNU0TfrKV8++tIsI4xoCpyr2rFMqLM
	zyM5VTb9oZwhSc+Oli5Ye3w+2X2KDwU3nax4yItvuRLVXHuV5c4dHW9C+1KtkMD/
	ZEL1OH9ZBshkRUvOlZkSOrs7kjowH8r426Q1+r1gp7uaI0EhrtWTQ2XmYfF5GuvO
	HJJMk+pMvEcaoB8PR1GS4vfeREssWfC5f5Mu+PGSJ8d6rk+qdaYyFpj4XMVbMzP8
	7LzB/2RArD+jlZQk54gXWO7loC9aM+MnZt9JtKuqesgV5R7bCA+ZT0y5mY/LXnfA
	==
Received: from ppma21.wdc07v.mail.ibm.com (5b.69.3da9.ip4.static.sl-reverse.com [169.61.105.91])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 42xgttena8-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 20 Nov 2024 17:37:10 +0000 (GMT)
Received: from pps.filterd (ppma21.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma21.wdc07v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 4AK9r4Y3021788;
	Wed, 20 Nov 2024 17:37:10 GMT
Received: from smtprelay03.fra02v.mail.ibm.com ([9.218.2.224])
	by ppma21.wdc07v.mail.ibm.com (PPS) with ESMTPS id 42y6qmy3gg-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 20 Nov 2024 17:37:10 +0000
Received: from smtpav06.fra02v.mail.ibm.com (smtpav06.fra02v.mail.ibm.com [10.20.54.105])
	by smtprelay03.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 4AKHb4tm58720632
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 20 Nov 2024 17:37:04 GMT
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 460F420049;
	Wed, 20 Nov 2024 17:37:04 +0000 (GMT)
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 8F24C2004E;
	Wed, 20 Nov 2024 17:37:02 +0000 (GMT)
Received: from p-imbrenda (unknown [9.171.26.6])
	by smtpav06.fra02v.mail.ibm.com (Postfix) with SMTP;
	Wed, 20 Nov 2024 17:37:02 +0000 (GMT)
Date: Wed, 20 Nov 2024 18:36:58 +0100
From: Claudio Imbrenda <imbrenda@linux.ibm.com>
To: Janosch Frank <frankja@linux.ibm.com>
Cc: kvm@vger.kernel.org, nrb@linux.ibm.com, borntraeger@de.ibm.com,
        thuth@redhat.com, david@redhat.com, schlameuss@linux.ibm.com,
        linux-s390@vger.kernel.org
Subject: Re: [kvm-unit-tests PATCH v2 1/1] s390x: pv: Add test for large
 host pages backing
Message-ID: <20241120183658.5e5f5ce7@p-imbrenda>
In-Reply-To: <1ae6d8ef-fde6-4673-9727-4117a08dfe46@linux.ibm.com>
References: <20241111121529.30153-1-imbrenda@linux.ibm.com>
	<1ae6d8ef-fde6-4673-9727-4117a08dfe46@linux.ibm.com>
Organization: IBM
X-Mailer: Claws Mail 4.3.0 (GTK 3.24.43; x86_64-redhat-linux-gnu)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: 33EKQepmTwvD0tgLCYoZB7gluKzhf5W1
X-Proofpoint-ORIG-GUID: 33EKQepmTwvD0tgLCYoZB7gluKzhf5W1
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1051,Hydra:6.0.680,FMLib:17.12.62.30
 definitions=2024-10-15_01,2024-10-11_01,2024-09-30_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1015 phishscore=0
 mlxscore=0 malwarescore=0 mlxlogscore=999 adultscore=0 priorityscore=1501
 bulkscore=0 impostorscore=0 spamscore=0 lowpriorityscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.19.0-2409260000
 definitions=main-2411200121

On Wed, 20 Nov 2024 17:33:48 +0100
Janosch Frank <frankja@linux.ibm.com> wrote:

> On 11/11/24 1:15 PM, Claudio Imbrenda wrote:
> > Add a new test to check that the host can use 1M large pages to back
> > protected guests when the corresponding feature is present.
> > 
> > Signed-off-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
> > ---
> >   s390x/Makefile               |   2 +
> >   lib/s390x/asm/arch_def.h     |   1 +
> >   lib/s390x/asm/uv.h           |  18 ++
> >   s390x/pv-edat1.c             | 463 +++++++++++++++++++++++++++++++++++
> >   s390x/snippets/c/pv-memhog.c |  59 +++++
> >   5 files changed, 543 insertions(+)
> >   create mode 100644 s390x/pv-edat1.c
> >   create mode 100644 s390x/snippets/c/pv-memhog.c
> > 
> > diff --git a/s390x/Makefile b/s390x/Makefile
> > index 23342bd6..c5c6f92c 100644
> > --- a/s390x/Makefile
> > +++ b/s390x/Makefile
> > @@ -48,6 +48,7 @@ tests += $(TEST_DIR)/sie-dat.elf
> >   pv-tests += $(TEST_DIR)/pv-diags.elf
> >   pv-tests += $(TEST_DIR)/pv-icptcode.elf
> >   pv-tests += $(TEST_DIR)/pv-ipl.elf
> > +pv-tests += $(TEST_DIR)/pv-edat1.elf
> >   
> >   ifneq ($(HOST_KEY_DOCUMENT),)
> >   ifneq ($(GEN_SE_HEADER),)
> > @@ -137,6 +138,7 @@ $(TEST_DIR)/pv-icptcode.elf: pv-snippets += $(SNIPPET_DIR)/asm/icpt-loop.gbin
> >   $(TEST_DIR)/pv-icptcode.elf: pv-snippets += $(SNIPPET_DIR)/asm/loop.gbin
> >   $(TEST_DIR)/pv-icptcode.elf: pv-snippets += $(SNIPPET_DIR)/asm/pv-icpt-vir-timing.gbin
> >   $(TEST_DIR)/pv-ipl.elf: pv-snippets += $(SNIPPET_DIR)/asm/pv-diag-308.gbin
> > +$(TEST_DIR)/pv-edat1.elf: pv-snippets += $(SNIPPET_DIR)/c/pv-memhog.gbin
> >   
> >   ifneq ($(GEN_SE_HEADER),)
> >   snippets += $(pv-snippets)
> > diff --git a/lib/s390x/asm/arch_def.h b/lib/s390x/asm/arch_def.h
> > index 745a3387..481ede8f 100644
> > --- a/lib/s390x/asm/arch_def.h
> > +++ b/lib/s390x/asm/arch_def.h
> > @@ -249,6 +249,7 @@ extern struct lowcore lowcore;
> >   #define PGM_INT_CODE_REGION_FIRST_TRANS		0x39
> >   #define PGM_INT_CODE_REGION_SECOND_TRANS	0x3a
> >   #define PGM_INT_CODE_REGION_THIRD_TRANS		0x3b
> > +#define PGM_INT_CODE_SECURE_PAGE_SIZE		0x3c
> >   #define PGM_INT_CODE_SECURE_STOR_ACCESS		0x3d
> >   #define PGM_INT_CODE_NON_SECURE_STOR_ACCESS	0x3e
> >   #define PGM_INT_CODE_SECURE_STOR_VIOLATION	0x3f
> > diff --git a/lib/s390x/asm/uv.h b/lib/s390x/asm/uv.h
> > index 611dcd3f..7527be48 100644
> > --- a/lib/s390x/asm/uv.h
> > +++ b/lib/s390x/asm/uv.h
> > @@ -35,6 +35,7 @@
> >   #define UVC_CMD_CONV_TO_SEC_STOR	0x0200
> >   #define UVC_CMD_CONV_FROM_SEC_STOR	0x0201
> >   #define UVC_CMD_DESTR_SEC_STOR		0x0202
> > +#define UVC_CMD_VERIFY_LARGE_FRAME	0x0203
> >   #define UVC_CMD_SET_SEC_CONF_PARAMS	0x0300
> >   #define UVC_CMD_UNPACK_IMG		0x0301
> >   #define UVC_CMD_VERIFY_IMG		0x0302
> > @@ -74,6 +75,11 @@ enum uv_cmds_inst {
> >   	BIT_UVC_CMD_PIN_PAGE_SHARED = 21,
> >   	BIT_UVC_CMD_UNPIN_PAGE_SHARED = 22,
> >   	BIT_UVC_CMD_ATTESTATION = 28,
> > +	BIT_UVC_CMD_VERIFY_LARGE_FRAME = 32,
> > +};
> > +
> > +enum uv_features {
> > +	BIT_UV_1M_BACKING = 6,
> >   };
> >   
> >   struct uv_cb_header {
> > @@ -312,6 +318,18 @@ static inline int uv_import(uint64_t handle, unsigned long gaddr)
> >   	return uv_call(0, (uint64_t)&uvcb);
> >   }
> >   
> > +static inline int uv_merge(uint64_t handle, unsigned long gaddr)
> > +{
> > +	struct uv_cb_cts uvcb = {
> > +		.header.cmd = UVC_CMD_VERIFY_LARGE_FRAME,
> > +		.header.len = sizeof(uvcb),
> > +		.guest_handle = handle,
> > +		.gaddr = gaddr,
> > +	};
> > +
> > +	return uv_call(0, (uint64_t)&uvcb);
> > +}  
> 
> I don't understand why you added this to the lib if you're not using it 
> even once since you have your own function that returns more data.

I don't remember :D
I'll have a closer look

> 
> Are you expecting other tests to regularly need this UVC?
> The attestation test for instance added the constants but no function 
> since the call is basically only used for one test.
> 
> 
> 


