Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E43F46CC142
	for <lists+kvm@lfdr.de>; Tue, 28 Mar 2023 15:43:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232484AbjC1NnN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 28 Mar 2023 09:43:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45646 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232842AbjC1Nm6 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 28 Mar 2023 09:42:58 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 112392D4C;
        Tue, 28 Mar 2023 06:42:56 -0700 (PDT)
Received: from pps.filterd (m0098396.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 32SDd3wD023838;
        Tue, 28 Mar 2023 13:42:56 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : to : cc : references : from : subject : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=CfDYwmqpCBlWGH8vmTBL83v4InRbcL8+v/ad7HJ3Gqk=;
 b=Dk+k7NaQH5KtuWyTLUow0nOni079E7zwahfObwIX9R++FY9gnjNlJlLc1rY7kJfiF17p
 bm4qVgcZal+kkDkNd5h86X/fWA9trCYm3OIraiX9NFLVwuxmMppI66t6n1s35B7Z5Y+O
 wmzFQ+6Yy0ymcLHpzutYa33eL+u6XDvQv72cbxwnxINpSESz7AzEHdGhCvrQpxPNB87o
 QYyPJkGcXu7dYU0T79KO7rpL1IBrb/ulxLd1qvtk8B6Vyy20OXI5ldfTzOJVxKat6/o5
 TM5WKeUqdMZFAyIWwrQQe616807KtuP9cuoZqoSTl6q4rckxT4QzxOkQ7vUh0Jv2HFmU zQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3pky56ktgx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 28 Mar 2023 13:42:55 +0000
Received: from m0098396.ppops.net (m0098396.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 32SDdsuK027542;
        Tue, 28 Mar 2023 13:42:55 GMT
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3pky56kt4v-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 28 Mar 2023 13:42:55 +0000
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
        by ppma03ams.nl.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 32S3FEt4019120;
        Tue, 28 Mar 2023 13:42:31 GMT
Received: from smtprelay03.fra02v.mail.ibm.com ([9.218.2.224])
        by ppma03ams.nl.ibm.com (PPS) with ESMTPS id 3phrk6m1h8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 28 Mar 2023 13:42:30 +0000
Received: from smtpav02.fra02v.mail.ibm.com (smtpav02.fra02v.mail.ibm.com [10.20.54.101])
        by smtprelay03.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 32SDgRhf11338390
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 28 Mar 2023 13:42:27 GMT
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 5F94920043;
        Tue, 28 Mar 2023 13:42:27 +0000 (GMT)
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 1A86E2004B;
        Tue, 28 Mar 2023 13:42:27 +0000 (GMT)
Received: from [9.179.1.68] (unknown [9.179.1.68])
        by smtpav02.fra02v.mail.ibm.com (Postfix) with ESMTP;
        Tue, 28 Mar 2023 13:42:27 +0000 (GMT)
Message-ID: <4eb0d6aa-d0c9-ff0e-d1f6-2d23ea8a957d@linux.ibm.com>
Date:   Tue, 28 Mar 2023 15:42:26 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.9.0
To:     Nico Boehr <nrb@linux.ibm.com>, imbrenda@linux.ibm.com,
        thuth@redhat.com
Cc:     kvm@vger.kernel.org, linux-s390@vger.kernel.org
References: <20230327082118.2177-1-nrb@linux.ibm.com>
 <20230327082118.2177-4-nrb@linux.ibm.com>
Content-Language: en-US
From:   Janosch Frank <frankja@linux.ibm.com>
Subject: Re: [kvm-unit-tests PATCH v1 3/4] s390x: lib: sie: don't reenter SIE
 on pgm int
In-Reply-To: <20230327082118.2177-4-nrb@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: O9Zk6q3OroVC5YymcRwQn2EiSPgrh-3w
X-Proofpoint-ORIG-GUID: vFeWtwn65QU4dOSsy1CMYtfKHc20dke9
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-03-24_11,2023-03-28_02,2023-02-09_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0
 mlxlogscore=757 malwarescore=0 phishscore=0 adultscore=0 spamscore=0
 clxscore=1011 suspectscore=0 priorityscore=1501 bulkscore=0
 impostorscore=0 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2303200000 definitions=main-2303280107
X-Spam-Status: No, score=-0.1 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_EF,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 3/27/23 10:21, Nico Boehr wrote:
> At the moment, when a PGM int occurs while in SIE, we will just reenter
> SIE after the interrupt handler was called.
> 
> This is because sie() has a loop which checks icptcode and re-enters SIE
> if it is zero.
> 
> However, this behaviour is quite undesirable for SIE tests, since it
> doesn't give the host the chance to assert on the PGM int. Instead, we
> will just re-enter SIE, on nullifing conditions even causing the
> exception again.
> 
> Add a flag PROG_PGM_IN_SIE set by the pgm int fixup which indicates a
> program interrupt has occured in SIE. Check for the flag in sie() and if
> it's set return from sie() to give the host the ability to react on the
> exception. The host may check if a PGM int has occured in the guest
> using the new function sie_had_pgm_int().

We could simply check "!lowcore.pgm_int_code" by introducing:
uint16_t read_pgm_int(void)
{
	mb();
	return lowcore.pgm_int_code;
}

into interrupt.c.


Or to be a bit more verbose:
I don't see a reason why we'd want to store a per sblk PGM in SIE bit 
when all we want to know is either: was there a PGM at all (to stop the 
SIE loop) or was there a PGM between the expect and the 
check_pgm_int_code().
