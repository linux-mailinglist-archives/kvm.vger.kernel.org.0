Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B883A665B18
	for <lists+kvm@lfdr.de>; Wed, 11 Jan 2023 13:11:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232457AbjAKMLp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 11 Jan 2023 07:11:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33500 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233456AbjAKMLg (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 11 Jan 2023 07:11:36 -0500
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 02664D8F;
        Wed, 11 Jan 2023 04:11:36 -0800 (PST)
Received: from pps.filterd (m0098396.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 30BBG4jo001977;
        Wed, 11 Jan 2023 12:11:35 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : references : mime-version : content-type :
 in-reply-to; s=pp1; bh=skNIDLkNuOS2uXYldF2DcYdMTiB4OnILt7WANkAQoR8=;
 b=PPR96e7dxIffZoaa4Q1S2uywu7jK6pF7E36ofdWYkrTGxY6ZRH+CwobjHa82QUImWEQD
 JZGMTHFFWLflPFYQYsmbWKcZ0DoVsas6VqgDYPnw/39vZLKiU6aASEQqRXpff1Bevfrf
 vMVJknez0ip7X6UrawsqJq9KD3lNK9lk55H0mA2u+Qsxo0wJpTVDrfWYX5UTu0kQnhp6
 zT+n3hTTp81yghGMU9PFuOGMDYRwMl1cn2ELTrMJ8S5yZkGs31O6/6/qx6p6TVXaojgd
 tNZb861ZG1XNBfUixFb99Ig41ckEXmMK69DqX7gHqMHHXIeVWJ2CPob05bG4YgBmBUlo dA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3n1v359605-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 11 Jan 2023 12:11:35 +0000
Received: from m0098396.ppops.net (m0098396.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 30BBrWng011382;
        Wed, 11 Jan 2023 12:11:35 GMT
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3n1v3595yj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 11 Jan 2023 12:11:35 +0000
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
        by ppma03ams.nl.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 30B1R79l030779;
        Wed, 11 Jan 2023 12:11:32 GMT
Received: from smtprelay01.fra02v.mail.ibm.com ([9.218.2.227])
        by ppma03ams.nl.ibm.com (PPS) with ESMTPS id 3n1kf7gtdq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 11 Jan 2023 12:11:32 +0000
Received: from smtpav04.fra02v.mail.ibm.com (smtpav04.fra02v.mail.ibm.com [10.20.54.103])
        by smtprelay01.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 30BCBTKX42598850
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 11 Jan 2023 12:11:29 GMT
Received: from smtpav04.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 1BA0620049;
        Wed, 11 Jan 2023 12:11:29 +0000 (GMT)
Received: from smtpav04.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id A9DF020040;
        Wed, 11 Jan 2023 12:11:28 +0000 (GMT)
Received: from osiris (unknown [9.171.72.122])
        by smtpav04.fra02v.mail.ibm.com (Postfix) with ESMTPS;
        Wed, 11 Jan 2023 12:11:28 +0000 (GMT)
Date:   Wed, 11 Jan 2023 13:11:27 +0100
From:   Heiko Carstens <hca@linux.ibm.com>
To:     Christian Borntraeger <borntraeger@linux.ibm.com>
Cc:     Janosch Frank <frankja@linux.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        David Hildenbrand <david@redhat.com>, kvm@vger.kernel.org,
        linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] KVM: s390: interrupt: use READ_ONCE() before cmpxchg()
Message-ID: <Y76nb+2tTERSszfP@osiris>
References: <20230109145456.2895385-1-hca@linux.ibm.com>
 <f4203dea-93a9-6903-d635-c36ff47337c9@linux.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f4203dea-93a9-6903-d635-c36ff47337c9@linux.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: q8MITHyDDcFW0naIlSJCWeS-1AziEiaX
X-Proofpoint-ORIG-GUID: vkzoQUqH3bFWkezvlncQUdImcB7Y8pnf
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.923,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2023-01-11_05,2023-01-11_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0
 malwarescore=0 bulkscore=0 clxscore=1015 adultscore=0 phishscore=0
 spamscore=0 priorityscore=1501 mlxscore=0 mlxlogscore=455 suspectscore=0
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2212070000 definitions=main-2301110089
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Jan 10, 2023 at 08:15:50PM +0100, Christian Borntraeger wrote:
> Am 09.01.23 um 15:54 schrieb Heiko Carstens:
> > Use READ_ONCE() before cmpxchg() to prevent that the compiler generates
> > code that fetches the to be compared old value several times from memory.
> > 
> > Signed-off-by: Heiko Carstens <hca@linux.ibm.com>
> 
> Looks sane.
> 
> Reviewed-by: Christian Borntraeger <borntraeger@linux.ibm.com>
> 
> In case you want to take it via the s390 tree:
> Acked-by: Christian Borntraeger <borntraeger@linux.ibm.com>

Given that there don't seem to be any pending s390 specific patches I
take it via the s390 tree.

Applied.
