Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A8C7352628F
	for <lists+kvm@lfdr.de>; Fri, 13 May 2022 15:04:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1380517AbiEMNEQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 13 May 2022 09:04:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58674 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1380558AbiEMNEO (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 13 May 2022 09:04:14 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 742644707D;
        Fri, 13 May 2022 06:04:13 -0700 (PDT)
Received: from pps.filterd (m0098409.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 24DCINlI022119;
        Fri, 13 May 2022 13:04:13 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=pp1;
 bh=jqqlVn4O0isxX1DTalqWZZH0+BQqMmr8CCXYIDS65Y4=;
 b=j+7NpdicpZOMFw6vtztZ5JCPat2LJUs52MVUneu0KQhJSFXYRP90CX9gCu9/nh9BBOhZ
 VfqW7QXpqaAObvQQA4hB0o0PROfED/MoWvlonOEgqSgFjuD5CmMgYlR5TPGxi420T+Hu
 l2QhZa8CK62Ird/5R7J9GPCRW6Lb4G9sqy9vXJummKTylnV00IPu1HFMAc4YRQ6lJYrq
 bg+mXHTeqS+XsXVO3l78gVVoV/mpu2DV9TqZrwWfOWKHDHOrMGKHUBgoqPSuy3DZLeDZ
 XmZaGnESH+ITgsVGReJmZ4Sg7WnLRB799Ggnus7QmGm74YrljLSVh2797cAqBuKtlyHM JQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3g1q7agwa4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 13 May 2022 13:04:12 +0000
Received: from m0098409.ppops.net (m0098409.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 24DCwIsX012730;
        Fri, 13 May 2022 13:04:12 GMT
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3g1q7agw9b-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 13 May 2022 13:04:12 +0000
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
        by ppma03ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 24DCx0b8007351;
        Fri, 13 May 2022 13:04:09 GMT
Received: from b06cxnps3074.portsmouth.uk.ibm.com (d06relay09.portsmouth.uk.ibm.com [9.149.109.194])
        by ppma03ams.nl.ibm.com with ESMTP id 3fwgd90q41-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 13 May 2022 13:04:09 +0000
Received: from d06av26.portsmouth.uk.ibm.com (d06av26.portsmouth.uk.ibm.com [9.149.105.62])
        by b06cxnps3074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 24DD46dO50069850
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 13 May 2022 13:04:06 GMT
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 95B88AE051;
        Fri, 13 May 2022 13:04:06 +0000 (GMT)
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 5D949AE045;
        Fri, 13 May 2022 13:04:06 +0000 (GMT)
Received: from p-imbrenda (unknown [9.152.224.40])
        by d06av26.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Fri, 13 May 2022 13:04:06 +0000 (GMT)
Date:   Fri, 13 May 2022 15:04:04 +0200
From:   Claudio Imbrenda <imbrenda@linux.ibm.com>
To:     Janis Schoetterl-Glausch <scgl@linux.ibm.com>
Cc:     Nico Boehr <nrb@linux.ibm.com>, kvm@vger.kernel.org,
        linux-s390@vger.kernel.org, frankja@linux.ibm.com, thuth@redhat.com
Subject: Re: [kvm-unit-tests PATCH v1 2/2] s390x: add migration test for
 storage keys
Message-ID: <20220513150404.6d64ae9e@p-imbrenda>
In-Reply-To: <a2e497b3-7d86-280c-f483-9ba20707294b@linux.ibm.com>
References: <20220512140107.1432019-1-nrb@linux.ibm.com>
        <20220512140107.1432019-3-nrb@linux.ibm.com>
        <5781a3a7-c76c-710d-4236-b82f6e821c48@linux.ibm.com>
        <20220513143323.25ca256a@p-imbrenda>
        <a2e497b3-7d86-280c-f483-9ba20707294b@linux.ibm.com>
Organization: IBM
X-Mailer: Claws Mail 4.1.0 (GTK 3.24.31; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: jd6aVUh8aZtNa2wTTXGSTPVIrEgGPaIm
X-Proofpoint-ORIG-GUID: BGbW2Aw0JrJ5oUlAN2bj6z8k4xYZFnct
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.858,Hydra:6.0.486,FMLib:17.11.64.514
 definitions=2022-05-13_04,2022-05-13_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 suspectscore=0
 spamscore=0 phishscore=0 priorityscore=1501 lowpriorityscore=0 bulkscore=0
 impostorscore=0 clxscore=1015 mlxlogscore=999 adultscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2202240000
 definitions=main-2205130057
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, 13 May 2022 14:46:04 +0200
Janis Schoetterl-Glausch <scgl@linux.ibm.com> wrote:

> On 5/13/22 14:33, Claudio Imbrenda wrote:
> > On Fri, 13 May 2022 13:04:34 +0200
> > Janis Schoetterl-Glausch <scgl@linux.ibm.com> wrote:
> >   
> >> On 5/12/22 16:01, Nico Boehr wrote:  
> >>> Upon migration, we expect storage keys being set by the guest to be preserved,
> >>> so add a test for it.
> >>>
> >>> We keep 128 pages and set predictable storage keys. Then, we migrate and check
> >>> they can be read back and the respective access restrictions are in place when
> >>> the access key in the PSW doesn't match.
> >>>
> >>> TCG currently doesn't implement key-controlled protection, see
> >>> target/s390x/mmu_helper.c, function mmu_handle_skey(), hence add the relevant
> >>> tests as xfails.
> >>>
> >>> Signed-off-by: Nico Boehr <nrb@linux.ibm.com>
> >>> ---
> >>>  s390x/Makefile         |  1 +
> >>>  s390x/migration-skey.c | 98 ++++++++++++++++++++++++++++++++++++++++++
> >>>  s390x/unittests.cfg    |  4 ++
> >>>  3 files changed, 103 insertions(+)
> >>>  create mode 100644 s390x/migration-skey.c
> >>>  

[...]

> Not at all with regards to skeys. But neither is checking the keys on access.
> And for kvm, both TPROT and checking is handled by SIE.

fair enough

> > 
> > to be fair, this test is only about checking that storage keys are
> > correctly migrated, maybe the check for actual protection is out of
> > scope
> >   
> 
> Having more tests does no harm and might uncover things nobody thought of,
> but I'd also be fine with keeping it short and sweet.
> [...]

I think this migration test should be kept more on focus about migration

we can always have a storage keys "torture test" separately
