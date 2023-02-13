Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A13ED693FBE
	for <lists+kvm@lfdr.de>; Mon, 13 Feb 2023 09:37:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230050AbjBMIhA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 13 Feb 2023 03:37:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45746 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229663AbjBMIg7 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 13 Feb 2023 03:36:59 -0500
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 66C0EB457;
        Mon, 13 Feb 2023 00:36:58 -0800 (PST)
Received: from pps.filterd (m0127361.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 31D8Lvhv004546;
        Mon, 13 Feb 2023 08:36:57 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=pp1;
 bh=z+uYQk09qIe/OPjT/0i5zBxN8duBX/EdvHszA378x7I=;
 b=X8519aZs3o6cYpkHBU/SCClsmtHAEFpBAOLa11D9BAkL5nxVtvxmyKArqT9BHba5j8CA
 YKcamMH1qRV2T+9da/RD8KO6UItvYX63r7zHSGRaABl04ESKrQ+9ep9PuJVrU2EL5kVm
 XmMKEdN1GZ6/c+qiBxwovf1O2D8Atp8KRPsp4Yf+TgpKpVxOR2PCXEBG6JY52AjINWs+
 mMxFbMI5Gkpw8GOcDp7dJD8PkSq3p8vnirNqjGDLyE/CVmKe4cN7f/l2hWode1n49nu9
 uHIOZUQPXf80C/q7WwK7pxE7wVFf7ye9IWSNdMMTyiFKnFeG0r/SLp3ZwAECr/ei1Xgw yw== 
Received: from ppma05fra.de.ibm.com (6c.4a.5195.ip4.static.sl-reverse.com [149.81.74.108])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3nqhmnr8tu-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 13 Feb 2023 08:36:57 +0000
Received: from pps.filterd (ppma05fra.de.ibm.com [127.0.0.1])
        by ppma05fra.de.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 31C60WMM008616;
        Mon, 13 Feb 2023 08:36:55 GMT
Received: from smtprelay05.fra02v.mail.ibm.com ([9.218.2.225])
        by ppma05fra.de.ibm.com (PPS) with ESMTPS id 3np2n69s4x-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 13 Feb 2023 08:36:55 +0000
Received: from smtpav02.fra02v.mail.ibm.com (smtpav02.fra02v.mail.ibm.com [10.20.54.101])
        by smtprelay05.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 31D8apZB40960306
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 13 Feb 2023 08:36:51 GMT
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 4D51F2005A;
        Mon, 13 Feb 2023 08:36:51 +0000 (GMT)
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id EE1142004B;
        Mon, 13 Feb 2023 08:36:50 +0000 (GMT)
Received: from [9.171.76.240] (unknown [9.171.76.240])
        by smtpav02.fra02v.mail.ibm.com (Postfix) with ESMTP;
        Mon, 13 Feb 2023 08:36:50 +0000 (GMT)
Message-ID: <8754aab3-1b4a-d48e-cf30-081fe720583c@linux.ibm.com>
Date:   Mon, 13 Feb 2023 09:36:50 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.1
Subject: Re: [v2] KVM: s390: pv: fix external interruption loop not always
 detected
To:     Nico Boehr <nrb@linux.ibm.com>, borntraeger@linux.ibm.com,
        imbrenda@linux.ibm.com
Cc:     kvm@vger.kernel.org, linux-s390@vger.kernel.org
References: <20221005122050.60625-1-nrb@linux.ibm.com>
 <167627590762.7662.2548443744874886411@t14-nrb.local>
Content-Language: en-US
From:   Janosch Frank <frankja@linux.ibm.com>
In-Reply-To: <167627590762.7662.2548443744874886411@t14-nrb.local>
Content-Type: text/plain; charset=UTF-8; format=flowed
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: 4MgRNAPzMpjLMRBsboDvmarre-3eTSUn
X-Proofpoint-ORIG-GUID: 4MgRNAPzMpjLMRBsboDvmarre-3eTSUn
Content-Transfer-Encoding: 7bit
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.930,Hydra:6.0.562,FMLib:17.11.170.22
 definitions=2023-02-13_04,2023-02-09_03,2023-02-09_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 suspectscore=0
 spamscore=0 adultscore=0 mlxlogscore=924 malwarescore=0 clxscore=1015
 impostorscore=0 phishscore=0 priorityscore=1501 bulkscore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2212070000 definitions=main-2302130076
X-Spam-Status: No, score=-2.3 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 2/13/23 09:11, Nico Boehr wrote:
> Quoting Nico Boehr (2022-10-05 14:20:50)
>> To determine whether the guest has caused an external interruption loop
>> upon code 20 (external interrupt) intercepts, the ext_new_psw needs to
>> be inspected to see whether external interrupts are enabled.
>>
>> Under non-PV, ext_new_psw can simply be taken from guest lowcore. Under
>> PV, KVM can only access the encrypted guest lowcore and hence the
>> ext_new_psw must not be taken from guest lowcore.
>>
>> handle_external_interrupt() incorrectly did that and hence was not able
>> to reliably tell whether an external interruption loop is happening or
>> not. False negatives cause spurious failures of my kvm-unit-test
>> for extint loops[1] under PV.
>>
>> Since code 20 is only caused under PV if and only if the guest's
>> ext_new_psw is enabled for external interrupts, false positive detection
>> of a external interruption loop can not happen.
>>
>> Fix this issue by instead looking at the guest PSW in the state
>> description. Since the PSW swap for external interrupt is done by the
>> ultravisor before the intercept is caused, this reliably tells whether
>> the guest is enabled for external interrupts in the ext_new_psw.
>>
>> Also update the comments to explain better what is happening.
>>
>> [1] https://lore.kernel.org/kvm/20220812062151.1980937-4-nrb@linux.ibm.com/
> 
> Polite Ping.

There are 2 checkpatch warnings, would you mind fixing them up so I 
don't need to fiddle with this when picking?
