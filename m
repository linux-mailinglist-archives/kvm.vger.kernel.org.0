Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DF2E96940CE
	for <lists+kvm@lfdr.de>; Mon, 13 Feb 2023 10:21:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230258AbjBMJV6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 13 Feb 2023 04:21:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49892 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229524AbjBMJV5 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 13 Feb 2023 04:21:57 -0500
Received: from mx0a-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 61A24C644;
        Mon, 13 Feb 2023 01:21:56 -0800 (PST)
Received: from pps.filterd (m0098420.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 31D8RQK7005640;
        Mon, 13 Feb 2023 09:21:55 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=pp1;
 bh=ylaedKUPVkiuwTWek6hj+l+VrUiHb8wDUwllrzXwIQw=;
 b=Cq519t7rgO3IeRsbaI1A3/J+UphfHr8yiYKjP0cjczS3WhUnro0E8D2yOWIvvyf7zGaB
 yIf91JWnkh8WNdex3qqAHgNz1SKTVQmtXXL3HxTpbhYqzejUTQQl5WVTisDx3r08jpS1
 nZctbDpagLwrzVXhrhNbliGcJ0Vef/5Rq1M1e0w9AVaoojf6hCTTxz9G+PLQjaZpT/P9
 oH5IiENCp7YKsADc5vTm6RRZ64xan88ZaMmeed6VO+IE1IBOP49erRGrLrGHa3FG5r0N
 9/9OtXAgX0X5dwxpMSOhpNpGafsJHfuATMQnd51a2k3GSK7jAGz5kT/+Anm8gjWHYXBP zQ== 
Received: from ppma05fra.de.ibm.com (6c.4a.5195.ip4.static.sl-reverse.com [149.81.74.108])
        by mx0b-001b2d01.pphosted.com (PPS) with ESMTPS id 3nqhqa97j3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 13 Feb 2023 09:21:55 +0000
Received: from pps.filterd (ppma05fra.de.ibm.com [127.0.0.1])
        by ppma05fra.de.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 31D8fYK6008513;
        Mon, 13 Feb 2023 09:21:53 GMT
Received: from smtprelay01.fra02v.mail.ibm.com ([9.218.2.227])
        by ppma05fra.de.ibm.com (PPS) with ESMTPS id 3np2n69tas-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 13 Feb 2023 09:21:53 +0000
Received: from smtpav02.fra02v.mail.ibm.com (smtpav02.fra02v.mail.ibm.com [10.20.54.101])
        by smtprelay01.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 31D9Ln5W48628012
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 13 Feb 2023 09:21:50 GMT
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id D8F3420043;
        Mon, 13 Feb 2023 09:21:49 +0000 (GMT)
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 858ED20040;
        Mon, 13 Feb 2023 09:21:49 +0000 (GMT)
Received: from [9.171.76.240] (unknown [9.171.76.240])
        by smtpav02.fra02v.mail.ibm.com (Postfix) with ESMTP;
        Mon, 13 Feb 2023 09:21:49 +0000 (GMT)
Message-ID: <38deba59-ac91-0196-d7f0-e7846a7531b3@linux.ibm.com>
Date:   Mon, 13 Feb 2023 10:21:49 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.1
Subject: Re: [PATCH v3 1/1] KVM: s390: pv: fix external interruption loop not
 always detected
Content-Language: en-US
To:     Nico Boehr <nrb@linux.ibm.com>, borntraeger@linux.ibm.com,
        imbrenda@linux.ibm.com
Cc:     kvm@vger.kernel.org, linux-s390@vger.kernel.org
References: <20230213085520.100756-1-nrb@linux.ibm.com>
 <20230213085520.100756-2-nrb@linux.ibm.com>
From:   Janosch Frank <frankja@linux.ibm.com>
In-Reply-To: <20230213085520.100756-2-nrb@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: CIDdRPkDhr7ntLr0XG-aocxo_lSlfdXp
X-Proofpoint-ORIG-GUID: CIDdRPkDhr7ntLr0XG-aocxo_lSlfdXp
Content-Transfer-Encoding: 7bit
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.930,Hydra:6.0.562,FMLib:17.11.170.22
 definitions=2023-02-13_04,2023-02-09_03,2023-02-09_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 suspectscore=0
 impostorscore=0 clxscore=1015 mlxscore=0 lowpriorityscore=0 phishscore=0
 spamscore=0 priorityscore=1501 mlxlogscore=729 adultscore=0 malwarescore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2212070000 definitions=main-2302130081
X-Spam-Status: No, score=-2.3 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 2/13/23 09:55, Nico Boehr wrote:
> To determine whether the guest has caused an external interruption loop
> upon code 20 (external interrupt) intercepts, the ext_new_psw needs to
> be inspected to see whether external interrupts are enabled.
> 
> Under non-PV, ext_new_psw can simply be taken from guest lowcore. Under
> PV, KVM can only access the encrypted guest lowcore and hence the
> ext_new_psw must not be taken from guest lowcore.
> 
> handle_external_interrupt() incorrectly did that and hence was not able
> to reliably tell whether an external interruption loop is happening or
> not. False negatives cause spurious failures of my kvm-unit-test
> for extint loops[1] under PV.
> 
> Since code 20 is only caused under PV if and only if the guest's
> ext_new_psw is enabled for external interrupts, false positive detection
> of a external interruption loop can not happen.
> 
> Fix this issue by instead looking at the guest PSW in the state
> description. Since the PSW swap for external interrupt is done by the
> ultravisor before the intercept is caused, this reliably tells whether
> the guest is enabled for external interrupts in the ext_new_psw.
> 
> Also update the comments to explain better what is happening.
> 
> [1] https://lore.kernel.org/kvm/20220812062151.1980937-4-nrb@linux.ibm.com/
> 
> Signed-off-by: Nico Boehr <nrb@linux.ibm.com>
> ---

Reviewed-by: Janosch Frank <frankja@linux.ibm.com>

