Return-Path: <kvm+bounces-4365-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 83807811A4A
	for <lists+kvm@lfdr.de>; Wed, 13 Dec 2023 18:01:14 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 3B1472829AD
	for <lists+kvm@lfdr.de>; Wed, 13 Dec 2023 17:01:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 746EA3A28B;
	Wed, 13 Dec 2023 17:00:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="gv/SvwvJ"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D8F1DF4;
	Wed, 13 Dec 2023 09:00:51 -0800 (PST)
Received: from pps.filterd (m0356517.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 3BDFkMZb006693;
	Wed, 13 Dec 2023 17:00:48 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=pp1;
 bh=/KaNs6G24r37ZCsp4qbLp9QHii+4udtbzDmnJT95nzM=;
 b=gv/SvwvJ+IjFV6yfcH5obplApiBxqpMvxfzPv894BxEHYfZSGaPOvkgB/yv2NXd1taKC
 FMsvGOvAz7EMf7RagUpGL3b0XhcEpvD8Ugh7Mg+uKjN+yYhEWcAa8XaTd0IkFL6bG4Di
 8QrIV+j7g53+B16hzMDcbdra9P6qsjmbS1HgHwilT+Zu8r8QggjjcggoY9aW95p+o55l
 +JUF6JSjm40/mnOo9roJ6VaqRIIn+zJBHr19Q0PrlROt7lXfRNCBLx5anI2rHi9+UGVT
 OVLyq8nUf6AOkG6oqkvPD/nDrhy24zsi3NMFuLhVSm/Zlpp2tmlWJJsm1xPnPbLMNNzA /g== 
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3uyeahmeg9-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 13 Dec 2023 17:00:48 +0000
Received: from m0356517.ppops.net (m0356517.ppops.net [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 3BDGxpbW009196;
	Wed, 13 Dec 2023 17:00:48 GMT
Received: from ppma22.wdc07v.mail.ibm.com (5c.69.3da9.ip4.static.sl-reverse.com [169.61.105.92])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3uyeahmefh-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 13 Dec 2023 17:00:47 +0000
Received: from pps.filterd (ppma22.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma22.wdc07v.mail.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 3BDGaKVV028206;
	Wed, 13 Dec 2023 17:00:46 GMT
Received: from smtprelay01.fra02v.mail.ibm.com ([9.218.2.227])
	by ppma22.wdc07v.mail.ibm.com (PPS) with ESMTPS id 3uw2xytdrg-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 13 Dec 2023 17:00:46 +0000
Received: from smtpav05.fra02v.mail.ibm.com (smtpav05.fra02v.mail.ibm.com [10.20.54.104])
	by smtprelay01.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 3BDH0hTM17629908
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 13 Dec 2023 17:00:43 GMT
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 5180B2004B;
	Wed, 13 Dec 2023 17:00:43 +0000 (GMT)
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 32D7420040;
	Wed, 13 Dec 2023 17:00:43 +0000 (GMT)
Received: from p-imbrenda (unknown [9.152.224.66])
	by smtpav05.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Wed, 13 Dec 2023 17:00:43 +0000 (GMT)
Date: Wed, 13 Dec 2023 17:42:22 +0100
From: Claudio Imbrenda <imbrenda@linux.ibm.com>
To: Nina Schoetterl-Glausch <nsg@linux.ibm.com>
Cc: Nico =?UTF-8?B?QsO2aHI=?= <nrb@linux.ibm.com>,
        Thomas Huth
 <thuth@redhat.com>, Janosch Frank <frankja@linux.ibm.com>,
        kvm@vger.kernel.org, linux-s390@vger.kernel.org,
        Andrew Jones
 <andrew.jones@linux.dev>,
        David Hildenbrand <david@redhat.com>
Subject: Re: [kvm-unit-tests PATCH 3/5] s390x: Add library functions for
 exiting from snippet
Message-ID: <20231213174222.542e11c6@p-imbrenda>
In-Reply-To: <20231213124942.604109-4-nsg@linux.ibm.com>
References: <20231213124942.604109-1-nsg@linux.ibm.com>
	<20231213124942.604109-4-nsg@linux.ibm.com>
Organization: IBM
X-Mailer: Claws Mail 4.2.0 (GTK 3.24.38; x86_64-redhat-linux-gnu)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: CFRWR_Jx8dZcvXqZ2s-fEOpUEMX12puv
X-Proofpoint-GUID: Zk71g95Fj2N9t8Iv70skiQLbovOMO3u8
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.997,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2023-12-13_10,2023-12-13_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 malwarescore=0 phishscore=0
 mlxscore=0 spamscore=0 lowpriorityscore=0 mlxlogscore=999 bulkscore=0
 suspectscore=0 impostorscore=0 priorityscore=1501 clxscore=1015
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2311290000 definitions=main-2312130121

On Wed, 13 Dec 2023 13:49:40 +0100
Nina Schoetterl-Glausch <nsg@linux.ibm.com> wrote:

> It is useful to be able to force an exit to the host from the snippet,
> as well as do so while returning a value.
> Add this functionality, also add helper functions for the host to check
> for an exit and get or check the value.
> Use diag 0x44 and 0x9c for this.
> Add a guest specific snippet header file and rename the host's.

you should also mention here that you are splitting snippet.h into a
host-only part and a guest-only part

> 
> Signed-off-by: Nina Schoetterl-Glausch <nsg@linux.ibm.com>
> ---
>  s390x/Makefile                          |  1 +
>  lib/s390x/asm/arch_def.h                | 13 ++++++++
>  lib/s390x/sie.h                         |  1 +
>  lib/s390x/snippet-guest.h               | 26 ++++++++++++++++
>  lib/s390x/{snippet.h => snippet-host.h} |  9 ++++--
>  lib/s390x/sie.c                         | 28 +++++++++++++++++
>  lib/s390x/snippet-host.c                | 40 +++++++++++++++++++++++++
>  lib/s390x/uv.c                          |  2 +-
>  s390x/mvpg-sie.c                        |  2 +-
>  s390x/pv-diags.c                        |  2 +-
>  s390x/pv-icptcode.c                     |  2 +-
>  s390x/pv-ipl.c                          |  2 +-
>  s390x/sie-dat.c                         |  2 +-
>  s390x/spec_ex-sie.c                     |  2 +-
>  s390x/uv-host.c                         |  2 +-
>  15 files changed, 123 insertions(+), 11 deletions(-)
>  create mode 100644 lib/s390x/snippet-guest.h
>  rename lib/s390x/{snippet.h => snippet-host.h} (93%)
>  create mode 100644 lib/s390x/snippet-host.c

[...]

> diff --git a/lib/s390x/sie.c b/lib/s390x/sie.c
> index 40936bd2..908b0130 100644
> --- a/lib/s390x/sie.c
> +++ b/lib/s390x/sie.c
> @@ -42,6 +42,34 @@ void sie_check_validity(struct vm *vm, uint16_t vir_exp)
>  	report(vir_exp == vir, "VALIDITY: %x", vir);
>  }
>  
> +bool sie_is_diag_icpt(struct vm *vm, unsigned int diag)
> +{
> +	uint32_t ipb = vm->sblk->ipb;
> +	uint64_t code;

uint64_t code = 0;

> +	uint16_t displace;
> +	uint8_t base;
> +	bool ret = true;

bool ret;

> +
> +	ret = ret && vm->sblk->icptcode == ICPT_INST;
> +	ret = ret && (vm->sblk->ipa & 0xff00) == 0x8300;

ret = vm->sblk->icptcode == ICPT_INST && (vm->sblk->ipa & 0xff00) ==
0x8300;

> +	switch (diag) {
> +	case 0x44:
> +	case 0x9c:
> +		ret = ret && !(ipb & 0xffff);
> +		ipb >>= 16;
> +		displace = ipb & 0xfff;

maybe it's more readable to avoid shifting thigs around all the time:

displace = (ipb >> 16) & 0xfff;
base = (ipb >> 28) & 0xf;
if (base)
	code = vm->....[base];
code = (code + displace) & 0xffff;
if (ipb & 0xffff || code != diag)
	return false;

> +		ipb >>= 12;
> +		base = ipb & 0xf;
> +		code = base ? vm->save_area.guest.grs[base] + displace : displace;
> +		code &= 0xffff;
> +		ret = ret && (code == diag);
> +		break;
> +	default:
> +		abort(); /* not implemented */
> +	}
> +	return ret;

although I have the feeling that this would be more readable if you
would check diag immediately, and avoid using ret

> +}
> +
>  void sie_handle_validity(struct vm *vm)
>  {
>  	if (vm->sblk->icptcode != ICPT_VALIDITY)
> diff --git a/lib/s390x/snippet-host.c b/lib/s390x/snippet-host.c
> new file mode 100644
> index 00000000..a829c1d5
> --- /dev/null
> +++ b/lib/s390x/snippet-host.c
> @@ -0,0 +1,40 @@
> +/* SPDX-License-Identifier: GPL-2.0-only */
> +/*
> + * Snippet functionality for the host.
> + *
> + * Copyright IBM Corp. 2023
> + */
> +
> +#include <libcflat.h>
> +#include <snippet-host.h>
> +#include <sie.h>
> +
> +bool snippet_check_force_exit(struct vm *vm)
> +{
> +	bool r;
> +
> +	r = sie_is_diag_icpt(vm, 0x44);
> +	report(r, "guest forced exit");
> +	return r;
> +}
> +
> +bool snippet_get_force_exit_value(struct vm *vm, uint64_t *value)
> +{
> +	struct kvm_s390_sie_block *sblk = vm->sblk;
> +
> +	if (sie_is_diag_icpt(vm, 0x9c)) {
> +		*value = vm->save_area.guest.grs[(sblk->ipa & 0xf0) >> 4];
> +		report_pass("guest forced exit with value: 0x%lx", *value);
> +		return true;
> +	}
> +	report_fail("guest forced exit with value");
> +	return false;
> +}
> +
> +void snippet_check_force_exit_value(struct vm *vm, uint64_t value_exp)
> +{
> +	uint64_t value;
> +
> +	if (snippet_get_force_exit_value(vm, &value))
> +		report(value == value_exp, "guest exit value matches 0x%lx", value_exp);
> +}

from a readability and a consistency perspective, it would be better if
the functions would only check stuff and return a bool or a value, and
do the report() in the body of the testcase


[...]

