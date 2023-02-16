Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1E8A0699037
	for <lists+kvm@lfdr.de>; Thu, 16 Feb 2023 10:40:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230148AbjBPJkr (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 16 Feb 2023 04:40:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49716 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229631AbjBPJkS (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 16 Feb 2023 04:40:18 -0500
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7E6184C6C8;
        Thu, 16 Feb 2023 01:39:30 -0800 (PST)
Received: from pps.filterd (m0098417.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 31G9KX7J018668;
        Thu, 16 Feb 2023 09:38:40 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : references : mime-version : content-type :
 in-reply-to; s=pp1; bh=mVNyMsUhyXTx1xWUSoRlDn47fWcmqoMi3HzBKVv9n0g=;
 b=bY/Hu3Gu9rNRaUIR+/kUd22IiljxeWaxl95YLJGs6Irw3OwQlUGazjznlSw0cNax9P8a
 MFHm/ARFIReGtbGy0nW25/R4GIg2LNiUAcNgUB+9cF11wcOnDgIzQIiITIHHarDw5x7t
 ke3XLkC1bzVVIbYbvOuWbBikbdavbuUrPlu8JiVwlnunOhoVzmg9HG0kqbtcWo+mDbZu
 rZwRSHPvad1PVZDgAIyX6zTR8jj8mSayZXO/U58reMAvVzAH7B8ay9/rzy93UcUiELa6
 LXFboCwD/+uUPvfehOkNPal7k5xi1vOuF6+fRQv1MdNtrQp/Fqi0EacpPEPxZoYFQxe7 sA== 
Received: from ppma04ams.nl.ibm.com (63.31.33a9.ip4.static.sl-reverse.com [169.51.49.99])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3nshs6gb71-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 16 Feb 2023 09:38:39 +0000
Received: from pps.filterd (ppma04ams.nl.ibm.com [127.0.0.1])
        by ppma04ams.nl.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 31G5rv8t010804;
        Thu, 16 Feb 2023 09:38:37 GMT
Received: from smtprelay03.fra02v.mail.ibm.com ([9.218.2.224])
        by ppma04ams.nl.ibm.com (PPS) with ESMTPS id 3np2n6xf3y-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 16 Feb 2023 09:38:37 +0000
Received: from smtpav03.fra02v.mail.ibm.com (smtpav03.fra02v.mail.ibm.com [10.20.54.102])
        by smtprelay03.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 31G9cY1S51053034
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 16 Feb 2023 09:38:34 GMT
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id ED2632004D;
        Thu, 16 Feb 2023 09:38:33 +0000 (GMT)
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id CD9122004B;
        Thu, 16 Feb 2023 09:38:33 +0000 (GMT)
Received: from li-4a3a4a4c-28e5-11b2-a85c-a8d192c6f089.ibm.com (unknown [9.155.204.110])
        by smtpav03.fra02v.mail.ibm.com (Postfix) with ESMTPS;
        Thu, 16 Feb 2023 09:38:33 +0000 (GMT)
Date:   Thu, 16 Feb 2023 10:38:32 +0100
From:   Alexander Gordeev <agordeev@linux.ibm.com>
To:     Nico Boehr <nrb@linux.ibm.com>
Cc:     borntraeger@linux.ibm.com, frankja@linux.ibm.com,
        imbrenda@linux.ibm.com, kvm@vger.kernel.org,
        linux-s390@vger.kernel.org
Subject: Re: [PATCH v1 1/1] s390: nmi: fix virtual-physical address confusion
Message-ID: <Y+35mHYZJlKT+e+s@li-4a3a4a4c-28e5-11b2-a85c-a8d192c6f089.ibm.com>
References: <20230215160252.14672-1-nrb@linux.ibm.com>
 <20230215160252.14672-2-nrb@linux.ibm.com>
 <Y+3KYSnJsznJEX4v@li-4a3a4a4c-28e5-11b2-a85c-a8d192c6f089.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y+3KYSnJsznJEX4v@li-4a3a4a4c-28e5-11b2-a85c-a8d192c6f089.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: Vo6FwcE5ac0S9XU5LlmI-USs_Msf1EdO
X-Proofpoint-ORIG-GUID: Vo6FwcE5ac0S9XU5LlmI-USs_Msf1EdO
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.930,Hydra:6.0.562,FMLib:17.11.170.22
 definitions=2023-02-16_06,2023-02-15_01,2023-02-09_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0
 spamscore=0 impostorscore=0 mlxscore=0 mlxlogscore=721 malwarescore=0
 bulkscore=0 phishscore=0 suspectscore=0 priorityscore=1501 adultscore=0
 clxscore=1015 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2212070000 definitions=main-2302160075
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Feb 16, 2023 at 07:17:07AM +0100, Alexander Gordeev wrote:
> Casting to (struct kvm_s390_sie_block *) is not superfluous,

s/not//
