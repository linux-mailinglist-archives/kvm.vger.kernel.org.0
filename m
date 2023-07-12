Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 782057507C2
	for <lists+kvm@lfdr.de>; Wed, 12 Jul 2023 14:12:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232004AbjGLMMH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 12 Jul 2023 08:12:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33258 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232255AbjGLMMF (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 12 Jul 2023 08:12:05 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B6063E5F;
        Wed, 12 Jul 2023 05:12:02 -0700 (PDT)
Received: from pps.filterd (m0353726.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 36CBgLvI016373;
        Wed, 12 Jul 2023 12:12:02 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=pp1;
 bh=tltQXugxcZeoO8dwlag/RdnQKSKFt0PN5wxaRNpTQLE=;
 b=IFSoiMmyi9a0TZ4NBySuasNEDApH7Xe3fYRELBYvTq9fZIEQkOQVxE5Q93UsZ2qob+J/
 CBtRy9DBg8HY8A/cV+7fM6EbtJdrJMrgrkUeQU+I/UjvGPvB0vAsBUhuZJXheQuWwFW0
 /lednIMbaGXLVgno+J/yFU9oLrjZOGQt5QHheIWz8rQdVCd0nCsk/dNHGIJRoQCVInYb
 sblQz12vpaOpGeEjvGzqXk8ocNyHfKWBT58vutijw63b36Sn7xWZmyov0xGceFa++aCI
 UmhGyEUyXYeum3jyMOMV2XJPWVx035A+ZtU1iXF2Yh2ZGrPAK4HCSwF+bJnMviQ2Wq9l Og== 
Received: from ppma05fra.de.ibm.com (6c.4a.5195.ip4.static.sl-reverse.com [149.81.74.108])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3rsuhhrtt5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 12 Jul 2023 12:12:01 +0000
Received: from pps.filterd (ppma05fra.de.ibm.com [127.0.0.1])
        by ppma05fra.de.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 36CBY54Z020388;
        Wed, 12 Jul 2023 12:06:58 GMT
Received: from smtprelay06.fra02v.mail.ibm.com ([9.218.2.230])
        by ppma05fra.de.ibm.com (PPS) with ESMTPS id 3rpye59waq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 12 Jul 2023 12:06:58 +0000
Received: from smtpav04.fra02v.mail.ibm.com (smtpav04.fra02v.mail.ibm.com [10.20.54.103])
        by smtprelay06.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 36CC6rqw31785322
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 12 Jul 2023 12:06:53 GMT
Received: from smtpav04.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 2A8632004B;
        Wed, 12 Jul 2023 12:06:53 +0000 (GMT)
Received: from smtpav04.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id CC8A220043;
        Wed, 12 Jul 2023 12:06:52 +0000 (GMT)
Received: from p-imbrenda (unknown [9.152.224.66])
        by smtpav04.fra02v.mail.ibm.com (Postfix) with ESMTP;
        Wed, 12 Jul 2023 12:06:52 +0000 (GMT)
Date:   Wed, 12 Jul 2023 14:06:51 +0200
From:   Claudio Imbrenda <imbrenda@linux.ibm.com>
To:     Janosch Frank <frankja@linux.ibm.com>
Cc:     kvm@vger.kernel.org, linux-s390@vger.kernel.org,
        linux-kernel@vger.kernel.org, mhartmay@linux.ibm.com,
        nsg@linux.ibm.com, borntraeger@de.ibm.com, nrb@linux.ibm.com
Subject: Re: [PATCH v2 2/2] KVM: s390: pv: fix index value of replaced ASCE
Message-ID: <20230712140651.37d84e5d@p-imbrenda>
In-Reply-To: <e3daf6b9-c7e9-89f3-b6ab-d8cf89de0b86@linux.ibm.com>
References: <20230705111937.33472-1-imbrenda@linux.ibm.com>
        <20230705111937.33472-3-imbrenda@linux.ibm.com>
        <e3daf6b9-c7e9-89f3-b6ab-d8cf89de0b86@linux.ibm.com>
Organization: IBM
X-Mailer: Claws Mail 4.1.1 (GTK 3.24.38; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: Shp0wLu6T1-ef94pjMgPiBBL6MSo6_oc
X-Proofpoint-ORIG-GUID: Shp0wLu6T1-ef94pjMgPiBBL6MSo6_oc
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.957,Hydra:6.0.591,FMLib:17.11.176.26
 definitions=2023-07-12_07,2023-07-11_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0
 priorityscore=1501 mlxlogscore=918 clxscore=1015 mlxscore=0 phishscore=0
 adultscore=0 bulkscore=0 malwarescore=0 lowpriorityscore=0 suspectscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2305260000 definitions=main-2307120108
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H5,
        RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, 12 Jul 2023 13:58:49 +0200
Janosch Frank <frankja@linux.ibm.com> wrote:

> On 7/5/23 13:19, Claudio Imbrenda wrote:
> > The index field of the struct page corresponding to a guest ASCE should
> > be 0. When replacing the ASCE in s390_replace_asce(), the index of the
> > new ASCE should also be set to 0.
> > 
> > Having the wrong index might lead to the wrong addresses being passed
> > around when notifying pte invalidations, and eventually to validity
> > intercepts (VM crash) if the prefix gets unmapped and the notifier gets
> > called with the wrong address.
> > 
> > Signed-off-by: Claudio Imbrenda <imbrenda@linux.ibm.com>  
> 
> No fixes tag?

oops, you're right

Fixes: faa2f72cb356 ("KVM: s390: pv: leak the topmost page table when
destroy fails")


> 
> Reviewed-by: Janosch Frank <frankja@linux.ibm.com>
> 

