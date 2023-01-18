Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 37B3067183D
	for <lists+kvm@lfdr.de>; Wed, 18 Jan 2023 10:54:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229933AbjARJxw (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 18 Jan 2023 04:53:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37562 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230256AbjARJxP (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 18 Jan 2023 04:53:15 -0500
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6B3851816E
        for <kvm@vger.kernel.org>; Wed, 18 Jan 2023 01:05:02 -0800 (PST)
Received: from pps.filterd (m0098421.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 30I8D1mi014673
        for <kvm@vger.kernel.org>; Wed, 18 Jan 2023 09:05:01 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : in-reply-to : references : date : message-id : mime-version :
 content-type : content-transfer-encoding; s=pp1;
 bh=LNC0NN9Ct8lxZ01oqMmKJ6YzFbsSx+ySWnja+U7BmEc=;
 b=Ar+SldaD/Qvtml3obeKILSCyH0FptGLyOHTEaOgfWO+4RtZ83gnGDE97Eb0Y7luJdlDM
 su2zD4+Uu0WJy6TidXdozMmgycCXHdaOflmqvmMEbn/ePVKLPP7VR7vx43sWGmB1h5Rg
 zyXfjP72Bx+5tVcrQoDsrOmfyIFy/oW6zD9xgSPYNvtktz0SX2UnjvTq1FMuZe90WBKs
 a6d0xpsIkIUO2hnnL57s2xdKUEKXUhOL8cnJT+0XIL0644mLTNR83lvQxb4ir1aRcqac
 ZfIhw4nEqJhfsTnw3VZQtOSwtk0QxOTgSmiSDKddoJyVOlMXCcMD4AyNotE5qcB8BGtx aQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3n6d2ds4qf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Wed, 18 Jan 2023 09:05:01 +0000
Received: from m0098421.ppops.net (m0098421.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 30I8DxUu020133
        for <kvm@vger.kernel.org>; Wed, 18 Jan 2023 09:05:01 GMT
Received: from ppma06fra.de.ibm.com (48.49.7a9f.ip4.static.sl-reverse.com [159.122.73.72])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3n6d2ds4pr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 18 Jan 2023 09:05:01 +0000
Received: from pps.filterd (ppma06fra.de.ibm.com [127.0.0.1])
        by ppma06fra.de.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 30I66Tb6010590;
        Wed, 18 Jan 2023 09:04:59 GMT
Received: from smtprelay01.fra02v.mail.ibm.com ([9.218.2.227])
        by ppma06fra.de.ibm.com (PPS) with ESMTPS id 3n3knfbnqn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 18 Jan 2023 09:04:59 +0000
Received: from smtpav06.fra02v.mail.ibm.com (smtpav06.fra02v.mail.ibm.com [10.20.54.105])
        by smtprelay01.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 30I94tR250987458
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 18 Jan 2023 09:04:55 GMT
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id A9B742004B;
        Wed, 18 Jan 2023 09:04:55 +0000 (GMT)
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 31BDF20043;
        Wed, 18 Jan 2023 09:04:55 +0000 (GMT)
Received: from li-1de7cd4c-3205-11b2-a85c-d27f97db1fe1.ibm.com (unknown [9.179.30.151])
        by smtpav06.fra02v.mail.ibm.com (Postfix) with ESMTPS;
        Wed, 18 Jan 2023 09:04:55 +0000 (GMT)
From:   "Marc Hartmayer" <mhartmay@linux.ibm.com>
To:     Janosch Frank <frankja@linux.ibm.com>, kvm@vger.kernel.org
Cc:     David Hildenbrand <david@redhat.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        Nina Schoetterl-Glausch <nsg@linux.ibm.com>,
        Nico Boehr <nrb@linux.ibm.com>, Thomas Huth <thuth@redhat.com>
Subject: Re: [kvm-unit-tests PATCH 6/9] s390x: define a macro for the stack
 frame size
In-Reply-To: <87ace2e2-8c0f-e4b7-addc-6ef04e8d29c4@linux.ibm.com>
References: <20230116175757.71059-1-mhartmay@linux.ibm.com>
 <20230116175757.71059-7-mhartmay@linux.ibm.com>
 <87ace2e2-8c0f-e4b7-addc-6ef04e8d29c4@linux.ibm.com>
Date:   Wed, 18 Jan 2023 10:04:53 +0100
Message-ID: <87fsc8mcwa.fsf@li-1de7cd4c-3205-11b2-a85c-d27f97db1fe1.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: DYUub-MjyusHzv8VX-lUkMT9ueqqP1le
X-Proofpoint-ORIG-GUID: MCEplsftGhNMVKeI9vhVJBNPKUfSm2Xl
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.923,Hydra:6.0.562,FMLib:17.11.122.1
 definitions=2023-01-18_03,2023-01-17_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 spamscore=0 mlxscore=0 mlxlogscore=999 malwarescore=0 lowpriorityscore=0
 phishscore=0 adultscore=0 suspectscore=0 clxscore=1015 bulkscore=0
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2212070000 definitions=main-2301180078
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Janosch Frank <frankja@linux.ibm.com> writes:

> On 1/16/23 18:57, Marc Hartmayer wrote:
>> Define and use a macro for the stack frame size.
>
> There are two more instances in s390x/macros.S and there might be some=20
> in s390x/gs.c.

Thanks, will change them.

>
>>=20
>> Signed-off-by: Marc Hartmayer <mhartmay@linux.ibm.com>
>> ---
>>   lib/s390x/asm-offsets.c | 1 +
>>   s390x/cstart64.S        | 2 +-
>>   2 files changed, 2 insertions(+), 1 deletion(-)
>>=20
>> diff --git a/lib/s390x/asm-offsets.c b/lib/s390x/asm-offsets.c
>> index f612f3277a95..188dd2e51181 100644
>> --- a/lib/s390x/asm-offsets.c
>> +++ b/lib/s390x/asm-offsets.c
>> @@ -87,6 +87,7 @@ int main(void)
>>   	OFFSET(STACK_FRAME_INT_GRS0, stack_frame_int, grs0);
>>   	OFFSET(STACK_FRAME_INT_GRS1, stack_frame_int, grs1);
>>   	DEFINE(STACK_FRAME_INT_SIZE, sizeof(struct stack_frame_int));
>> +	DEFINE(STACK_FRAME_SIZE, sizeof(struct stack_frame));
>
> I'm wondering why we didn't do this when Pierre introduced the int stacks=
...
>
>>=20=20=20
>>   	return 0;
>>   }
>> diff --git a/s390x/cstart64.S b/s390x/cstart64.S
>> index 6f83da2a6c0a..468ace3ea4df 100644
>> --- a/s390x/cstart64.S
>> +++ b/s390x/cstart64.S
>> @@ -38,7 +38,7 @@ start:
>>   	/* setup stack */
>>   	larl	%r15, stackptr
>>   	/* Clear first stack frame */
>> -	xc      0(160,%r15), 0(%r15)
>> +	xc      0(STACK_FRAME_SIZE,%r15), 0(%r15)
>>   	/* setup initial PSW mask + control registers*/
>>   	larl	%r1, initial_psw
>>   	lpswe	0(%r1)
>
--=20
Kind regards / Beste Gr=C3=BC=C3=9Fe
   Marc Hartmayer

IBM Deutschland Research & Development GmbH
Vorsitzender des Aufsichtsrats: Gregor Pillen=20
Gesch=C3=A4ftsf=C3=BChrung: David Faller
Sitz der Gesellschaft: B=C3=B6blingen
Registergericht: Amtsgericht Stuttgart, HRB 243294
