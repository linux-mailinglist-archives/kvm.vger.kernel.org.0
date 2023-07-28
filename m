Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 541A6766A10
	for <lists+kvm@lfdr.de>; Fri, 28 Jul 2023 12:19:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235089AbjG1KS6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 28 Jul 2023 06:18:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47592 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235730AbjG1KSq (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 28 Jul 2023 06:18:46 -0400
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 161C13A8B;
        Fri, 28 Jul 2023 03:18:46 -0700 (PDT)
Received: from pps.filterd (m0356516.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 36S9E8W6023143;
        Fri, 28 Jul 2023 09:14:18 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : references : mime-version : content-type :
 in-reply-to; s=pp1; bh=OPhaYHzj5yj1W013w+Tp+FkvxzlBGRyIkyGVGs57y4o=;
 b=ZetTmRIqrma/7XA4ZH+kNYIPcmEPCy+PQT9vdkK2KomOxafhTDiV8RgeQz6mAjKReBbY
 8w7VazQBndaKyvzdfX7XgS7MnutNxnHUBu402eEeOE+RmQPAD59H8LyoRzocl0oWmRo5
 AVRq3ANvFIqh/TtgY49AeQqBX1AjaaUYpTwCf67680yO6aC8/jSIc7NYvrvvqFB2+Nkk
 38nNs7/dsqk/2s+04Pyyf8hWnkqtCdhiP8dNMftjuSjO4IjwJBLRsjMifKBPRoGsUmdA
 0kSQBdZNE/d2R4+M23jrVQOlLc7f2C7J/+lFRY8eD0NEJQO8TjVFg1EvTlGRunnUNQF1 zA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3s4av1r043-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 28 Jul 2023 09:14:17 +0000
Received: from m0356516.ppops.net (m0356516.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 36S9EGTW023444;
        Fri, 28 Jul 2023 09:14:17 GMT
Received: from ppma11.dal12v.mail.ibm.com (db.9e.1632.ip4.static.sl-reverse.com [50.22.158.219])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3s4av1r03t-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 28 Jul 2023 09:14:17 +0000
Received: from pps.filterd (ppma11.dal12v.mail.ibm.com [127.0.0.1])
        by ppma11.dal12v.mail.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 36S8SEr2016574;
        Fri, 28 Jul 2023 09:14:16 GMT
Received: from smtprelay03.fra02v.mail.ibm.com ([9.218.2.224])
        by ppma11.dal12v.mail.ibm.com (PPS) with ESMTPS id 3s0v51v74d-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 28 Jul 2023 09:14:16 +0000
Received: from smtpav07.fra02v.mail.ibm.com (smtpav07.fra02v.mail.ibm.com [10.20.54.106])
        by smtprelay03.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 36S9EDnU852494
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 28 Jul 2023 09:14:13 GMT
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 346392004B;
        Fri, 28 Jul 2023 09:14:13 +0000 (GMT)
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id A651820040;
        Fri, 28 Jul 2023 09:14:12 +0000 (GMT)
Received: from osiris (unknown [9.171.95.61])
        by smtpav07.fra02v.mail.ibm.com (Postfix) with ESMTPS;
        Fri, 28 Jul 2023 09:14:12 +0000 (GMT)
Date:   Fri, 28 Jul 2023 11:14:11 +0200
From:   Heiko Carstens <hca@linux.ibm.com>
To:     Christian Borntraeger <borntraeger@linux.ibm.com>
Cc:     Janosch Frank <frankja@linux.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        David Hildenbrand <david@redhat.com>,
        Mete Durlu <meted@linux.ibm.com>, kvm@vger.kernel.org,
        linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] KVM: s390: fix sthyi error handling
Message-ID: <20230728091411.6761-A-hca@linux.ibm.com>
References: <20230727182939.2050744-1-hca@linux.ibm.com>
 <7fadab86-2b7c-b934-fcfa-61046c0778b6@linux.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7fadab86-2b7c-b934-fcfa-61046c0778b6@linux.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: Yhlxo3Fzz_wVPc7vqX0jBI8BPtWapXeO
X-Proofpoint-GUID: qtzApPhxRoQY-Q3FoFeXXsn1FOdaF3hg
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.957,Hydra:6.0.591,FMLib:17.11.176.26
 definitions=2023-07-27_10,2023-07-26_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 suspectscore=0 adultscore=0
 bulkscore=0 spamscore=0 mlxlogscore=670 mlxscore=0 clxscore=1015
 impostorscore=0 malwarescore=0 lowpriorityscore=0 priorityscore=1501
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2306200000 definitions=main-2307280082
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Jul 28, 2023 at 09:28:58AM +0200, Christian Borntraeger wrote:
> Am 27.07.23 um 20:29 schrieb Heiko Carstens:
> > Commit 9fb6c9b3fea1 ("s390/sthyi: add cache to store hypervisor info")
> > added cache handling for store hypervisor info. This also changed the
> > possible return code for sthyi_fill().
> > 
> > Instead of only returning a condition code like the sthyi instruction would
> > do, it can now also return a negative error value (-ENOMEM). handle_styhi()
> > was not changed accordingly. In case of an error, the negative error value
> > would incorrectly injected into the guest PSW.
> > 
> > Add proper error handling to prevent this, and update the comment which
> > describes the possible return values of sthyi_fill().
> 
> To me it looks like this can only happen if page allocation fails? This should
> not happen in normal cases (and return -ENOMEM would likely kill the guest as
> QEMU would stop).
> But if it happens we better stop.

Yes, no reason for any stable backports. But things might change in the
future, so we better have correct error handling in place.
