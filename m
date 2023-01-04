Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B56F165D132
	for <lists+kvm@lfdr.de>; Wed,  4 Jan 2023 12:07:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234523AbjADLHi (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 4 Jan 2023 06:07:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43492 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231130AbjADLHf (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 4 Jan 2023 06:07:35 -0500
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D876D1583E
        for <kvm@vger.kernel.org>; Wed,  4 Jan 2023 03:07:34 -0800 (PST)
Received: from pps.filterd (m0098421.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 304AxYti021909;
        Wed, 4 Jan 2023 11:07:29 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=pp1;
 bh=JsNh0IiPcoYBgvmkhWdCYuFTRRrhaO0c0NZ02gxo7pQ=;
 b=KRii5RG3WidfIg3XJYxwIrxRIXK2ZlzBHsanawEqTZhNpGxrIhEQCQJ+o0mJ/Npz2ynr
 kVQZf2o620IvkOlGoMa4zVX/q/0eb7cIaiu537ZWvg4xzrBFulsN/FXj9fUBv2TeKkpC
 eDAf4vySDvstPPqh7PWU5q8qN/T+DGUVKDmJClfl22YnWV9z0VYey6z6dNGQjkyMsutW
 iJg4DbICnk7XULIorvkgQhgU28bM5tFilDuZ+AT+ixXg81VCmgUhel22PKoSWVRaFBcH
 3dAtDf8Tg2+iZhVyKvwnRo66m42jaPfgGMr1YsvU9+YCCmVI4WD7aJswM+8x6W+mq1J4 CA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3mw86j06rr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 04 Jan 2023 11:07:29 +0000
Received: from m0098421.ppops.net (m0098421.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 304AxcW5022040;
        Wed, 4 Jan 2023 11:07:28 GMT
Received: from ppma04ams.nl.ibm.com (63.31.33a9.ip4.static.sl-reverse.com [169.51.49.99])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3mw86j06r4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 04 Jan 2023 11:07:28 +0000
Received: from pps.filterd (ppma04ams.nl.ibm.com [127.0.0.1])
        by ppma04ams.nl.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 30440S6V005147;
        Wed, 4 Jan 2023 11:07:26 GMT
Received: from smtprelay04.fra02v.mail.ibm.com ([9.218.2.228])
        by ppma04ams.nl.ibm.com (PPS) with ESMTPS id 3mtcq6d62u-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 04 Jan 2023 11:07:26 +0000
Received: from smtpav01.fra02v.mail.ibm.com (smtpav01.fra02v.mail.ibm.com [10.20.54.100])
        by smtprelay04.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 304B7MHA21758518
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 4 Jan 2023 11:07:23 GMT
Received: from smtpav01.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id E483820049;
        Wed,  4 Jan 2023 11:07:22 +0000 (GMT)
Received: from smtpav01.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 5BA4520040;
        Wed,  4 Jan 2023 11:07:22 +0000 (GMT)
Received: from p-imbrenda (unknown [9.171.85.101])
        by smtpav01.fra02v.mail.ibm.com (Postfix) with SMTP;
        Wed,  4 Jan 2023 11:07:22 +0000 (GMT)
Date:   Wed, 4 Jan 2023 12:07:20 +0100
From:   Claudio Imbrenda <imbrenda@linux.ibm.com>
To:     Andrew Jones <andrew.jones@linux.dev>
Cc:     Nico Boehr <nrb@linux.ibm.com>, kvm@vger.kernel.org,
        frankja@linux.ibm.com, seiden@linux.ibm.com, nsg@linux.ibm.com,
        thuth@redhat.com
Subject: Re: [kvm-unit-tests PATCH v1 1/1] s390x: fix make standalone
Message-ID: <20230104120720.0d3490bd@p-imbrenda>
In-Reply-To: <20221226184112.ezyw2imr2ezffutr@orel>
References: <20221220175508.57180-1-imbrenda@linux.ibm.com>
        <167161061144.28055.8565976183630294954@t14-nrb.local>
        <167161409237.28055.17477704571322735500@t14-nrb.local>
        <20221226184112.ezyw2imr2ezffutr@orel>
Organization: IBM
X-Mailer: Claws Mail 4.1.1 (GTK 3.24.35; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: hEeKyXFaonJ0v4ZLcLL6fmMtLN1qVvvV
X-Proofpoint-ORIG-GUID: KlfMhz55exS2RSc7Urtnpr7mZM8YN9hB
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.923,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2023-01-04_06,2023-01-04_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1015
 lowpriorityscore=0 malwarescore=0 bulkscore=0 mlxlogscore=999 adultscore=0
 spamscore=0 suspectscore=0 phishscore=0 impostorscore=0 priorityscore=1501
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2212070000 definitions=main-2301040093
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, 26 Dec 2022 19:41:12 +0100
Andrew Jones <andrew.jones@linux.dev> wrote:

> On Wed, Dec 21, 2022 at 10:14:52AM +0100, Nico Boehr wrote:
> > Quoting Nico Boehr (2022-12-21 09:16:51)  
> > > Quoting Claudio Imbrenda (2022-12-20 18:55:08)  
> > > > A recent patch broke make standalone. The function find_word is not
> > > > available when running make standalone, replace it with a simple grep.
> > > > 
> > > > Reported-by: Nina Schoetterl-Glausch <nsg@linux.ibm.com>
> > > > Fixes: 743cacf7 ("s390x: don't run migration tests under PV")
> > > > Signed-off-by: Claudio Imbrenda <imbrenda@linux.ibm.com>  
> > > 
> > > I am confused why find_word would not be available in standalone, since run() in runtime.bash uses it quite a few times.
> > > 
> > > Not that I mind the grep, but I fear more might be broken in standalone?  
> 
> standalone tests don't currently include scripts/$ARCH/func.bash, which
> may be an issue for s390x. That could be fixed, though.
> 
> > > 
> > > Anyways, to get this fixed ASAP:
> > > 
> > > Acked-by: Nico Boehr <nrb@linux.ibm.com>  
> > 
> > OK, I get it now, find_word is not available during _build time_.  
> 
> That could be changed, but it'd need to be moved to somewhere that
> mkstandalone.sh wants to source, which could be common.bash, but
> then we'd need to include common.bash in the standalone tests. So,
> a new file for find_word() would be cleaner, but that sounds like
> overkill.

the hack I posted here was meant to be "clean enough" and
arch-only (since we are the only ones with this issue). To be
honest, I don't really care __how__ we fix the problem, only that we do
fix it :)

what do you think would be the cleanest solution?

> 
> Thanks,
> drew
> 
> > 
> > Please make this a:
> > 
> > Reviewed-by: Nico Boehr <nrb@linux.ibm.com>  

