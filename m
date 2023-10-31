Return-Path: <kvm+bounces-180-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 205817DCA53
	for <lists+kvm@lfdr.de>; Tue, 31 Oct 2023 11:00:57 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id A541AB20AF7
	for <lists+kvm@lfdr.de>; Tue, 31 Oct 2023 10:00:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A257018C2D;
	Tue, 31 Oct 2023 10:00:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="UvotZFd9"
X-Original-To: kvm@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 142D4182B5
	for <kvm@vger.kernel.org>; Tue, 31 Oct 2023 10:00:46 +0000 (UTC)
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6FCBDDA
	for <kvm@vger.kernel.org>; Tue, 31 Oct 2023 03:00:43 -0700 (PDT)
Received: from pps.filterd (m0353726.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 39V9bIpx009769
	for <kvm@vger.kernel.org>; Tue, 31 Oct 2023 10:00:43 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=pp1;
 bh=5rU1V6wSm0UxklHsrYorgiRIOBoJPqimwc5czd7qwso=;
 b=UvotZFd9tBoSEri9IZ48uib5E2F0ZUSWkoXy97qospBOUKEH0+zk5uh2hhm+cMEclq6f
 Bn9uXav8UKbNNIyLoZhOXpMI0vkqnywna6D0Vro/9rHgTwEuoOrnM7rX0N2GJ4EV1tPr
 byGgoNiFDaDp8qGHGDolBvRIDfkkF9NP7uIcC651LiiZ7L+XSmdE/bhleBM//aSPxVFg
 Fy64/pMKP+PrzgrDvGOAJKtauNYo1Ce82Z3x+26EQ4+JkEW/5y23D1UTMUSXpMoCxp6L
 nfmdZpmTES7dBLcn/7mo+iFdo3hJMkN17BbPahugj92txZEInbzYMd5WVrNz6BCQLHRK dA== 
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3u2y3xgy6v-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
	for <kvm@vger.kernel.org>; Tue, 31 Oct 2023 10:00:42 +0000
Received: from m0353726.ppops.net (m0353726.ppops.net [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 39V9cKQ9014640
	for <kvm@vger.kernel.org>; Tue, 31 Oct 2023 10:00:42 GMT
Received: from ppma22.wdc07v.mail.ibm.com (5c.69.3da9.ip4.static.sl-reverse.com [169.61.105.92])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3u2y3xgy57-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 31 Oct 2023 10:00:42 +0000
Received: from pps.filterd (ppma22.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma22.wdc07v.mail.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 39V7LVsi019881;
	Tue, 31 Oct 2023 10:00:40 GMT
Received: from smtprelay04.fra02v.mail.ibm.com ([9.218.2.228])
	by ppma22.wdc07v.mail.ibm.com (PPS) with ESMTPS id 3u1d0yfp57-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 31 Oct 2023 10:00:39 +0000
Received: from smtpav01.fra02v.mail.ibm.com (smtpav01.fra02v.mail.ibm.com [10.20.54.100])
	by smtprelay04.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 39VA0abL38601242
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 31 Oct 2023 10:00:36 GMT
Received: from smtpav01.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id C76142004E;
	Tue, 31 Oct 2023 10:00:36 +0000 (GMT)
Received: from smtpav01.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 9C1E720063;
	Tue, 31 Oct 2023 10:00:36 +0000 (GMT)
Received: from p-imbrenda (unknown [9.152.224.66])
	by smtpav01.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Tue, 31 Oct 2023 10:00:36 +0000 (GMT)
Date: Tue, 31 Oct 2023 11:00:35 +0100
From: Claudio Imbrenda <imbrenda@linux.ibm.com>
To: Janosch Frank <frankja@linux.ibm.com>
Cc: kvm@vger.kernel.org, nrb@linux.ibm.com, thuth@redhat.com, david@redhat.com
Subject: Re: [kvm-unit-tests PATCH v2 1/3] lib: s390x: hw: rework
 do_detect_host so we don't need allocation
Message-ID: <20231031110035.0a4bb5c4@p-imbrenda>
In-Reply-To: <20231031095519.73311-2-frankja@linux.ibm.com>
References: <20231031095519.73311-1-frankja@linux.ibm.com>
	<20231031095519.73311-2-frankja@linux.ibm.com>
Organization: IBM
X-Mailer: Claws Mail 4.1.1 (GTK 3.24.38; x86_64-redhat-linux-gnu)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: VWeqatr-VGlnL1hhxHZE8hehoWeWE_mo
X-Proofpoint-GUID: rCetN5fqjqnfjyqTGFs88XwXGNSwl1Yo
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.987,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2023-10-30_13,2023-10-31_03,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 malwarescore=0 phishscore=0
 clxscore=1011 lowpriorityscore=0 suspectscore=0 priorityscore=1501
 spamscore=0 adultscore=0 bulkscore=0 mlxlogscore=999 impostorscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2310240000 definitions=main-2310310078

On Tue, 31 Oct 2023 09:55:17 +0000
Janosch Frank <frankja@linux.ibm.com> wrote:

> The current implementation needs to allocate a page for stsi 1.1.1 and
> 3.2.2. As such it's not usable before the allocator is set
> up.
> 
> Unfortunately we might end up with detect_host calls before the
> allocator setup is done. For example in the SCLP console setup code.
> 
> Let's allocate the stsi storage on the stack to solve that problem.
> 
> Signed-off-by: Janosch Frank <frankja@linux.ibm.com>

I like this solution :)

Reviewed-by: Claudio Imbrenda <imbrenda@linux.ibm.com>

> ---
>  lib/s390x/hardware.c | 11 +++++------
>  1 file changed, 5 insertions(+), 6 deletions(-)
> 
> diff --git a/lib/s390x/hardware.c b/lib/s390x/hardware.c
> index 2bcf9c4c..21752562 100644
> --- a/lib/s390x/hardware.c
> +++ b/lib/s390x/hardware.c
> @@ -13,6 +13,7 @@
>  #include <libcflat.h>
>  #include <alloc_page.h>
>  #include <asm/arch_def.h>
> +#include <asm/page.h>
>  #include "hardware.h"
>  #include "stsi.h"
>  
> @@ -21,9 +22,10 @@ static const uint8_t qemu_ebcdic[] = { 0xd8, 0xc5, 0xd4, 0xe4 };
>  /* The string "KVM/" in EBCDIC */
>  static const uint8_t kvm_ebcdic[] = { 0xd2, 0xe5, 0xd4, 0x61 };
>  
> -static enum s390_host do_detect_host(void *buf)
> +static enum s390_host do_detect_host(void)
>  {
> -	struct sysinfo_3_2_2 *stsi_322 = buf;
> +	uint8_t buf[PAGE_SIZE] __attribute__((aligned(PAGE_SIZE)));
> +	struct sysinfo_3_2_2 *stsi_322 = (struct sysinfo_3_2_2 *)buf;
>  
>  	if (stsi_get_fc() == 2)
>  		return HOST_IS_LPAR;
> @@ -56,14 +58,11 @@ enum s390_host detect_host(void)
>  {
>  	static enum s390_host host = HOST_IS_UNKNOWN;
>  	static bool initialized = false;
> -	void *buf;
>  
>  	if (initialized)
>  		return host;
>  
> -	buf = alloc_page();
> -	host = do_detect_host(buf);
> -	free_page(buf);
> +	host = do_detect_host();
>  	initialized = true;
>  	return host;
>  }


