Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 82C297D9AB2
	for <lists+kvm@lfdr.de>; Fri, 27 Oct 2023 16:04:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346043AbjJ0OEC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 27 Oct 2023 10:04:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57604 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345997AbjJ0OEB (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 27 Oct 2023 10:04:01 -0400
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 238E7DE;
        Fri, 27 Oct 2023 07:03:59 -0700 (PDT)
Received: from pps.filterd (m0353722.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 39RDpgrv007185;
        Fri, 27 Oct 2023 14:03:58 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=pp1;
 bh=mfkMwzC5iCTTQA92R3nTRXIdLPb6nW7IXhNeTLvK0Pg=;
 b=P4bmUqZekkSwZQxSw0wzHEPL1YDjFapJJxCCFjggmrBgqGxuWN8Mj9BGwgTqSQt79/+H
 nnR8w4sA3JgfzMXjtl/q9VyHJKPoVbrHcC15ecl0YX+v3fKybG+pydXSZjfEf9I6WzE4
 /Zc1jungHpd5nZqxr7nttjKPKkYsCk9b8UzGrRAcYNaiTzq5aJaWIYPNgg1RdmUXS4UE
 Cv+E0ZAKRDNxDh1Il7p/sqMV5KWjDsz7kUVKyqYXIByBTKx33KdCZ/hXRJtBD+sutHB9
 tb6SYHkCbKXGhLl9he/xgKbDUQn0g8dLRIMQi+J8gTqd69YA0vVJSdf09GTsFECfJAbf zQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3u0ef80egu-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 27 Oct 2023 14:03:57 +0000
Received: from m0353722.ppops.net (m0353722.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 39RDt1h2017970;
        Fri, 27 Oct 2023 14:03:56 GMT
Received: from ppma23.wdc07v.mail.ibm.com (5d.69.3da9.ip4.static.sl-reverse.com [169.61.105.93])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3u0ef80eff-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 27 Oct 2023 14:03:56 +0000
Received: from pps.filterd (ppma23.wdc07v.mail.ibm.com [127.0.0.1])
        by ppma23.wdc07v.mail.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 39RDI41C021676;
        Fri, 27 Oct 2023 14:03:55 GMT
Received: from smtprelay01.fra02v.mail.ibm.com ([9.218.2.227])
        by ppma23.wdc07v.mail.ibm.com (PPS) with ESMTPS id 3tywqsdgys-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 27 Oct 2023 14:03:54 +0000
Received: from smtpav02.fra02v.mail.ibm.com (smtpav02.fra02v.mail.ibm.com [10.20.54.101])
        by smtprelay01.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 39RE3pXA36831608
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 27 Oct 2023 14:03:51 GMT
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 94DE620043;
        Fri, 27 Oct 2023 14:03:51 +0000 (GMT)
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 5483920040;
        Fri, 27 Oct 2023 14:03:51 +0000 (GMT)
Received: from li-ce58cfcc-320b-11b2-a85c-85e19b5285e0 (unknown [9.152.224.212])
        by smtpav02.fra02v.mail.ibm.com (Postfix) with ESMTP;
        Fri, 27 Oct 2023 14:03:51 +0000 (GMT)
Date:   Fri, 27 Oct 2023 16:03:47 +0200
From:   Halil Pasic <pasic@linux.ibm.com>
To:     Tony Krowiak <akrowiak@linux.ibm.com>
Cc:     linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, jjherne@linux.ibm.com,
        borntraeger@linux.ibm.com, frankja@linux.ibm.com,
        imbrenda@linux.ibm.com, david@redhat.com,
        Halil Pasic <pasic@linux.ibm.com>
Subject: Re: [PATCH v2 2/3] s390/vfio-ap: set status response code to 06 on
 gisc registration failure
Message-ID: <20231027160347.05c6cd60.pasic@linux.ibm.com>
In-Reply-To: <8eb41445-1eff-4da7-830f-156f420afd5d@linux.ibm.com>
References: <20231018133829.147226-1-akrowiak@linux.ibm.com>
        <20231018133829.147226-3-akrowiak@linux.ibm.com>
        <20231027125638.67a65ab9.pasic@linux.ibm.com>
        <8eb41445-1eff-4da7-830f-156f420afd5d@linux.ibm.com>
Organization: IBM
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.32; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: YoxX6pE3zZJ0xM09oIpJ1MEUTAqNnUtI
X-Proofpoint-ORIG-GUID: ZRVq9v4AI2a852Rue87Vy-wZjdVuswqZ
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.987,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2023-10-27_12,2023-10-27_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 phishscore=0 impostorscore=0
 mlxscore=0 priorityscore=1501 malwarescore=0 clxscore=1015 suspectscore=0
 lowpriorityscore=0 spamscore=0 adultscore=0 mlxlogscore=999 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2310240000
 definitions=main-2310270122
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, 27 Oct 2023 09:36:26 -0400
Tony Krowiak <akrowiak@linux.ibm.com> wrote:

> >> The interception handler for the PQAP(AQIC) command calls the
> >> kvm_s390_gisc_register function to register the guest ISC with the channel
> >> subsystem. If that call fails, the status response code 08 - indicating
> >> Invalid ZONE/GISA designation - is returned to the guest. This response
> >> code does not make sense because the non-zero return code from the
> >> kvm_s390_gisc_register function can be due one of two things: Either the
> >> ISC passed as a parameter by the guest to the PQAP(AQIC) command is greater
> >> than the maximum ISC value allowed, or the guest is not using a GISA.  
> > 
> > The "ISC passed as a parameter by the guest to the PQAP(AQIC) command is
> > greater than the maximum ISC value allowed" is not possible. The isc is
> > 3 bits wide and all 8 values that can be represented on 3 bits are valid.
> > 
> > This is only possible if the hypervisor was to mess up, or if the machine
> > was broken.  
> 
> kvm_s390_gisc_register(struct kvm *kvm, u32 gisc)
> {
> 	struct kvm_s390_gisa_interrupt *gi = &kvm->arch.gisa_int;
> 
> 	if (!gi->origin)
> 		return -ENODEV;
> 	if (gisc > MAX_ISC)
> 		return -ERANGE;
> ...
> 
> Just quoting what is in the code.

Right! But it is not the guest that calls this function directly. This
function is called by the vfio_ap code.

The guest passes ISC in bits 61, 62 and 63 of GR1.

So the guest can't give you an invalid value.

Regards,
Halil
