Return-Path: <kvm+bounces-3106-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 75DAB8009E1
	for <lists+kvm@lfdr.de>; Fri,  1 Dec 2023 12:25:42 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 15319B20D29
	for <lists+kvm@lfdr.de>; Fri,  1 Dec 2023 11:25:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CE67221378;
	Fri,  1 Dec 2023 11:25:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="tHnqyxfO"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8BC7110DF;
	Fri,  1 Dec 2023 03:25:29 -0800 (PST)
Received: from pps.filterd (m0353727.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 3B1BLs6x025771;
	Fri, 1 Dec 2023 11:25:03 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=JDUzZoo0usIHW1bL2X7anyVGvbWqKUEA7tIrv8v05tw=;
 b=tHnqyxfOpKCyJQS9Q2t6T+YBArVIO9T+BksB7CPM23mv787TWNE400l6B35o4efxzIgZ
 dTVPk64R5ES/U8fIEFZdkk6XmOqPOItJQeGIYkr4RTjVnoTUvos/sgpjBL7sHtasGumI
 IqsBtbExaSGm0U/D4mKfTxabVmwieN8VVL/Od1F4AAzYpQRMafuh25W1NVF4eyWsmDBm
 ow/7ypoop/jr4CS5zEI0eV/IiVMIlFaheuK9Vg9wHgXceJScHgJ+9UaKFFEIdZmnYJ8P
 zPqO1SZOKKYj14HDlUigQ0HYnNwAhJNBvJJHU7VgJ8EWBSVbpJ9T2dUxnzRq6IcGfA2X xA== 
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3uqej203cs-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 01 Dec 2023 11:25:03 +0000
Received: from m0353727.ppops.net (m0353727.ppops.net [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 3B1BMput029715;
	Fri, 1 Dec 2023 11:25:02 GMT
Received: from ppma21.wdc07v.mail.ibm.com (5b.69.3da9.ip4.static.sl-reverse.com [169.61.105.91])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3uqej203bx-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 01 Dec 2023 11:25:02 +0000
Received: from pps.filterd (ppma21.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma21.wdc07v.mail.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 3B1AXt1j002633;
	Fri, 1 Dec 2023 11:25:01 GMT
Received: from smtprelay01.fra02v.mail.ibm.com ([9.218.2.227])
	by ppma21.wdc07v.mail.ibm.com (PPS) with ESMTPS id 3ukv8p4nxt-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 01 Dec 2023 11:25:01 +0000
Received: from smtpav06.fra02v.mail.ibm.com (smtpav06.fra02v.mail.ibm.com [10.20.54.105])
	by smtprelay01.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 3B1BOveo11600416
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 1 Dec 2023 11:24:58 GMT
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id D182D20049;
	Fri,  1 Dec 2023 11:24:57 +0000 (GMT)
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 7747820040;
	Fri,  1 Dec 2023 11:24:57 +0000 (GMT)
Received: from [9.152.224.222] (unknown [9.152.224.222])
	by smtpav06.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Fri,  1 Dec 2023 11:24:57 +0000 (GMT)
Message-ID: <fc436fea-b9af-5649-0b4e-ef6c0ef37ce9@linux.ibm.com>
Date: Fri, 1 Dec 2023 12:24:56 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.15.1
Subject: Re: [PATCH 0/3] Use new wrappers to copy userspace arrays
To: Sean Christopherson <seanjc@google.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        David Hildenbrand <david@redhat.com>,
        Heiko Carstens <hca@linux.ibm.com>, Vasily Gorbik <gor@linux.ibm.com>,
        Alexander Gordeev
 <agordeev@linux.ibm.com>,
        Sven Schnelle <svens@linux.ibm.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Philipp Stanner <pstanner@redhat.com>
Cc: kvm@vger.kernel.org, linux-s390@vger.kernel.org,
        linux-kernel@vger.kernel.org, x86@kernel.org
References: <20231102181526.43279-1-pstanner@redhat.com>
 <170137909771.669092.7450781639631347445.b4-ty@google.com>
Content-Language: en-US
From: Christian Borntraeger <borntraeger@linux.ibm.com>
In-Reply-To: <170137909771.669092.7450781639631347445.b4-ty@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: LrfhoqbS-eviJ5_jMuCu1wAkL1ISHKbx
X-Proofpoint-GUID: Xqwf_ASsKyrNP6BsfZQM4xXPHZMO1cS5
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.997,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2023-12-01_09,2023-11-30_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 bulkscore=0 spamscore=0
 priorityscore=1501 lowpriorityscore=0 mlxlogscore=744 adultscore=0
 phishscore=0 impostorscore=0 mlxscore=0 suspectscore=0 malwarescore=0
 clxscore=1011 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2311060000 definitions=main-2312010075



Am 01.12.23 um 02:52 schrieb Sean Christopherson:
> On Thu, 02 Nov 2023 19:15:23 +0100, Philipp Stanner wrote:
>> Linus recently merged [1] the wrapper functions memdup_array_user() and
>> vmemdup_array_user() in include/linux/string.h for Kernel v6.7
>>
>> I am currently adding them to all places where (v)memdup_user() had been
>> used to copy arrays.
>>
>> The wrapper is different to the wrapped functions only in that it might
>> return -EOVERFLOW. So this new error code might get pushed up to
>> userspace. I hope this is fine.
>>
>> [...]
> 
> Applied to kvm-x86 generic.  Claudio (or anyone else from s390), holler if
> you want to take the s390 patch through the s390 tree.

I think this is fine via your tree.

Feel free to add
Acked-by: Christian Borntraeger <borntraeger@linux.ibm.com>
to patch 2 if the commit id is not yet final.

