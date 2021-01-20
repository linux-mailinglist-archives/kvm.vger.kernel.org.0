Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E52882FD327
	for <lists+kvm@lfdr.de>; Wed, 20 Jan 2021 15:53:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732792AbhATOvC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 20 Jan 2021 09:51:02 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:7744 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2390678AbhATOkC (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 20 Jan 2021 09:40:02 -0500
Received: from pps.filterd (m0098409.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 10KEX1n3089220;
        Wed, 20 Jan 2021 09:39:22 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=OUbEvXc1Tx8V9pnilr/S7a1PK0RDaqnlUhgdCe/oUr0=;
 b=jRHpL/B6KvDQMtbY0fKBB5OpusbtGnyKqH0Ja5OC4kA6SbdTswYftqYLqeQElm31Q02i
 BErLePsaTqZ4gVQ1vouCpoN/SsqbFVDnkWaYDYApiifkJsT537ICeyzn+mds4AMD3sRe
 B0Z9mD5jwhy1NiIklQTYAyU8qHaULPnkas7sNiZPqrI2tmsgk/jAtTAh8Aj6CO4ui7iR
 r+DAxLIWmn7NdzlsTa+WzqQI2KEaooZahOYPhYGxw9IlIpOdcgFStrVc87BnZ/szAc+u
 K5Ls86hkmFAi+dRLuItjKVMKkNDtaKc6Js9SCPlzXNc4Y4i6hwtZSO6KEbuBG7boI9p5 Aw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 366p870dmc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 20 Jan 2021 09:39:21 -0500
Received: from m0098409.ppops.net (m0098409.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 10KEXDtf090499;
        Wed, 20 Jan 2021 09:39:21 -0500
Received: from ppma01fra.de.ibm.com (46.49.7a9f.ip4.static.sl-reverse.com [159.122.73.70])
        by mx0a-001b2d01.pphosted.com with ESMTP id 366p870dk8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 20 Jan 2021 09:39:21 -0500
Received: from pps.filterd (ppma01fra.de.ibm.com [127.0.0.1])
        by ppma01fra.de.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 10KEbF1t017315;
        Wed, 20 Jan 2021 14:39:19 GMT
Received: from b06avi18878370.portsmouth.uk.ibm.com (b06avi18878370.portsmouth.uk.ibm.com [9.149.26.194])
        by ppma01fra.de.ibm.com with ESMTP id 3668p4gcfy-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 20 Jan 2021 14:39:18 +0000
Received: from d06av21.portsmouth.uk.ibm.com (d06av21.portsmouth.uk.ibm.com [9.149.105.232])
        by b06avi18878370.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 10KEd9Oe30671232
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 20 Jan 2021 14:39:09 GMT
Received: from d06av21.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 20F2D5204E;
        Wed, 20 Jan 2021 14:39:16 +0000 (GMT)
Received: from oc7455500831.ibm.com (unknown [9.171.13.250])
        by d06av21.portsmouth.uk.ibm.com (Postfix) with ESMTP id 21B3652050;
        Wed, 20 Jan 2021 14:39:15 +0000 (GMT)
Subject: Re: [PATCH 2/2] s390: mm: Fix secure storage access exception
 handling
To:     Heiko Carstens <hca@linux.ibm.com>
Cc:     Janosch Frank <frankja@linux.ibm.com>,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        thuth@redhat.com, david@redhat.com, imbrenda@linux.ibm.com,
        cohuck@redhat.com, linux-s390@vger.kernel.org, gor@linux.ibm.com,
        mihajlov@linux.ibm.com
References: <20210119100402.84734-1-frankja@linux.ibm.com>
 <20210119100402.84734-3-frankja@linux.ibm.com>
 <3e1978c6-4462-1de6-e1aa-e664ffa633c1@de.ibm.com>
 <20210120134208.GC8202@osiris>
From:   Christian Borntraeger <borntraeger@de.ibm.com>
Message-ID: <221ce6ab-4630-473d-a49f-150ac8c573d6@de.ibm.com>
Date:   Wed, 20 Jan 2021 15:39:14 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.0
MIME-Version: 1.0
In-Reply-To: <20210120134208.GC8202@osiris>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.343,18.0.737
 definitions=2021-01-20_05:2021-01-20,2021-01-20 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 malwarescore=0
 lowpriorityscore=0 impostorscore=0 phishscore=0 mlxlogscore=899
 clxscore=1015 suspectscore=0 bulkscore=0 priorityscore=1501 spamscore=0
 adultscore=0 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2101200083
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 20.01.21 14:42, Heiko Carstens wrote:
> On Tue, Jan 19, 2021 at 11:25:01AM +0100, Christian Borntraeger wrote:
>>> +		if (user_mode(regs)) {
>>> +			send_sig(SIGSEGV, current, 0);
>>> +			return;
>>> +		} else
>>> +			panic("Unexpected PGM 0x3d with TEID bit 61=0");
>>
>> use BUG instead of panic? That would kill this process, but it allows
>> people to maybe save unaffected data.
> 
> It would kill the process, and most likely lead to deadlock'ed
> system. But with all the "good" debug information being lost, which
> wouldn't be the case with panic().
> I really don't think this is a good idea.
> 

My understanding is that Linus hates panic for anything that might be able
to continue to run. With BUG the admin can decide via panic_on_oops if
debugging data or runtime data is more important. But mm is more on your
side, so if you insist on panic we can keep it.
