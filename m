Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 657F27265B8
	for <lists+kvm@lfdr.de>; Wed,  7 Jun 2023 18:19:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231629AbjFGQTl (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 7 Jun 2023 12:19:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44786 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230496AbjFGQTj (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 7 Jun 2023 12:19:39 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5D8251BFE;
        Wed,  7 Jun 2023 09:19:37 -0700 (PDT)
Received: from pps.filterd (m0360083.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 357GHXpZ008720;
        Wed, 7 Jun 2023 16:19:37 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=pp1;
 bh=CMNTOr6sBD8r6vaC63/KBTECjHasOvKZLafa9AVPN18=;
 b=e7CMS7YJ1fEMCYxIA8GHPIXRGzYAGac0MQAE5hN9HVKJn8t73CKWPbkKV+E+tTKDwz9P
 HTmXHuKqX5/TRLAXPKMrxKnOABYi9NRzgakbLuIKqAQe5tZDGkZLRWwkTTwrfP93S21b
 9jtgZitPr+rj0C+3v7YVueFMvspiV5rMo6dPZHKMztYsniAd+UnN6P9oF5v5C2AVBefr
 83xe6Cm8egcKw0L8WjaXYXqaASnb1UjorQemRlpVlVj0nfHMHLv0RqNS6gD00JHEf7Iy
 MifUGyDNTSgUsXhfu9j6//Qx3RXG4LFG1Dhvpm3eYK0istyIF7gc4jDWXsQeBTx5czsg cA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3r2w9e00v4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 07 Jun 2023 16:19:36 +0000
Received: from m0360083.ppops.net (m0360083.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 357GIYuK014026;
        Wed, 7 Jun 2023 16:19:36 GMT
Received: from ppma06fra.de.ibm.com (48.49.7a9f.ip4.static.sl-reverse.com [159.122.73.72])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3r2w9e00uq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 07 Jun 2023 16:19:36 +0000
Received: from pps.filterd (ppma06fra.de.ibm.com [127.0.0.1])
        by ppma06fra.de.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 3577s6mj007661;
        Wed, 7 Jun 2023 16:19:34 GMT
Received: from smtprelay07.fra02v.mail.ibm.com ([9.218.2.229])
        by ppma06fra.de.ibm.com (PPS) with ESMTPS id 3r2a7a0e6y-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 07 Jun 2023 16:19:33 +0000
Received: from smtpav06.fra02v.mail.ibm.com (smtpav06.fra02v.mail.ibm.com [10.20.54.105])
        by smtprelay07.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 357GJUd950331998
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 7 Jun 2023 16:19:30 GMT
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 3277E20043;
        Wed,  7 Jun 2023 16:19:30 +0000 (GMT)
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id EAE0320040;
        Wed,  7 Jun 2023 16:19:29 +0000 (GMT)
Received: from p-imbrenda (unknown [9.152.224.66])
        by smtpav06.fra02v.mail.ibm.com (Postfix) with ESMTP;
        Wed,  7 Jun 2023 16:19:29 +0000 (GMT)
Date:   Wed, 7 Jun 2023 18:19:28 +0200
From:   Claudio Imbrenda <imbrenda@linux.ibm.com>
To:     Nico Boehr <nrb@linux.ibm.com>
Cc:     Janosch Frank <frankja@linux.ibm.com>, thuth@redhat.com,
        kvm@vger.kernel.org, linux-s390@vger.kernel.org
Subject: Re: [kvm-unit-tests PATCH v3 1/6] lib: s390x: introduce bitfield
 for PSW mask
Message-ID: <20230607181928.75d20898@p-imbrenda>
In-Reply-To: <168615337335.127716.6745745533225595281@t14-nrb>
References: <20230601070202.152094-1-nrb@linux.ibm.com>
        <20230601070202.152094-2-nrb@linux.ibm.com>
        <3667d7af-f9ba-fbb6-537d-e6143f63ac43@linux.ibm.com>
        <168615337335.127716.6745745533225595281@t14-nrb>
Organization: IBM
X-Mailer: Claws Mail 4.1.1 (GTK 3.24.38; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: FeKWB12d_yMac4a0q6qBZubRk9yz8nF1
X-Proofpoint-ORIG-GUID: NCh3ZXQjwk_gQYJZbYZRHI2cM3xVJYCB
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.957,Hydra:6.0.573,FMLib:17.11.176.26
 definitions=2023-06-07_07,2023-06-07_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0 mlxscore=0
 spamscore=0 lowpriorityscore=0 malwarescore=0 bulkscore=0
 priorityscore=1501 mlxlogscore=959 phishscore=0 adultscore=0 clxscore=1015
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2305260000 definitions=main-2306070137
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, 07 Jun 2023 17:56:13 +0200
Nico Boehr <nrb@linux.ibm.com> wrote:

> Quoting Janosch Frank (2023-06-01 09:42:48)
> [...]
> > I've come to like static asserts for huge structs and bitfields since 
> > they can safe you from a *lot* of headaches.  
> 
> I generally agree and I add a _Static_assert but I want to mention the
> usefulness is a bit limited in this case, since we have a bitfield inside a
> union. So it only really helps if you manage to exceed the size of mask.

better than nothing :)

if the struct becomes too big, the assert will catch it

> 
> There really is no way around the stuff I put in the selftests.
> 
> I could of course try to make that code _Static_asserts but it will not be
> pretty.

I think just a couple of asserts to make sure things aren't __too__
crazy would be good enough
