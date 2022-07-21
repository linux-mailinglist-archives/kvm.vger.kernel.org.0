Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 10A0957CC7A
	for <lists+kvm@lfdr.de>; Thu, 21 Jul 2022 15:47:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230044AbiGUNr2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 21 Jul 2022 09:47:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48942 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229776AbiGUNrN (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 21 Jul 2022 09:47:13 -0400
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 22EB581B3F;
        Thu, 21 Jul 2022 06:46:19 -0700 (PDT)
Received: from pps.filterd (m0098417.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 26LDjI8P016079;
        Thu, 21 Jul 2022 13:46:14 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : in-reply-to : references : content-type :
 content-transfer-encoding : mime-version; s=pp1;
 bh=o9rsZ2NZQTUCNcNVSugAR1X1hCuYKfTg1Geek3XAjw0=;
 b=VA5g9/43U9yj1q4xV2Scpz74kJBvonw08u6p4p90cVg5UsbGQ+Ko1x+kndLjKSmtVoiy
 c50IcrC1J30B9e6l8o1sSJ23zIFYjNrakxcAhv9ehLw+I6Wha3rOmI0jvWbfjI1oWRKP
 tQblV8QmEgBPluZAHZxziYwj10hyqlUkjb4tAvpSpG416+VUNC/6EI0twhekDjg21Eq1
 SNj5DJZhEle7njCTaicOrW7sgi/HiuQxG5rA+lcM1ln3eaao16dtLT0vE9asHxODs0AA
 hytw8YW2sa/gYVvHcPIsweCX1JzHz1yQHXyNm6B1OAgtYB/u2nrBQHY0tPm4+Y36itpV Ig== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3hf74qa1a0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 21 Jul 2022 13:46:14 +0000
Received: from m0098417.ppops.net (m0098417.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 26LDjXCh017780;
        Thu, 21 Jul 2022 13:46:13 GMT
Received: from ppma04ams.nl.ibm.com (63.31.33a9.ip4.static.sl-reverse.com [169.51.49.99])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3hf74qa19c-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 21 Jul 2022 13:46:13 +0000
Received: from pps.filterd (ppma04ams.nl.ibm.com [127.0.0.1])
        by ppma04ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 26LDOxGb000807;
        Thu, 21 Jul 2022 13:46:12 GMT
Received: from b06avi18878370.portsmouth.uk.ibm.com (b06avi18878370.portsmouth.uk.ibm.com [9.149.26.194])
        by ppma04ams.nl.ibm.com with ESMTP id 3hbmy8y0aq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 21 Jul 2022 13:46:11 +0000
Received: from d06av22.portsmouth.uk.ibm.com (d06av22.portsmouth.uk.ibm.com [9.149.105.58])
        by b06avi18878370.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 26LDkMlj17695152
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 21 Jul 2022 13:46:22 GMT
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id AD32E4C040;
        Thu, 21 Jul 2022 13:46:09 +0000 (GMT)
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 65DB64C046;
        Thu, 21 Jul 2022 13:46:09 +0000 (GMT)
Received: from p-imbrenda (unknown [9.145.4.232])
        by d06av22.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Thu, 21 Jul 2022 13:46:09 +0000 (GMT)
Date:   Thu, 21 Jul 2022 15:46:07 +0200
From:   Claudio Imbrenda <imbrenda@linux.ibm.com>
To:     Thomas Huth <thuth@redhat.com>
Cc:     kvm@vger.kernel.org, linux-s390@vger.kernel.org,
        qemu-s390x@nongnu.org, frankja@linux.ibm.com
Subject: Re: [PATCH v2 1/2] s390x: intercept: fence one test when using TCG
Message-ID: <20220721154607.3c43fb6f@p-imbrenda>
In-Reply-To: <b250461b-ee09-d499-e5a4-4a9a303bed66@redhat.com>
References: <20220721133002.142897-1-imbrenda@linux.ibm.com>
        <20220721133002.142897-2-imbrenda@linux.ibm.com>
        <b250461b-ee09-d499-e5a4-4a9a303bed66@redhat.com>
Organization: IBM
X-Mailer: Claws Mail 4.1.0 (GTK 3.24.34; x86_64-redhat-linux-gnu)
Content-Type: text/plain; charset=US-ASCII
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: 7xLUfKgv2jq88RCeyAhN1LHdrMF3ylMY
X-Proofpoint-ORIG-GUID: N7SKqUE9tvu9-5xKTvvrNdmSBrqcJnH1
Content-Transfer-Encoding: 7bit
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-07-21_18,2022-07-20_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0 phishscore=0
 mlxlogscore=999 adultscore=0 spamscore=0 mlxscore=0 priorityscore=1501
 bulkscore=0 malwarescore=0 lowpriorityscore=0 clxscore=1015 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2206140000
 definitions=main-2207210054
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, 21 Jul 2022 15:41:30 +0200
Thomas Huth <thuth@redhat.com> wrote:

> On 21/07/2022 15.30, Claudio Imbrenda wrote:
> > Qemu commit f8333de2793 ("target/s390x/tcg: SPX: check validity of new prefix")
> > fixes a TCG bug discovered with a new testcase in the intercept test.
> > 
> > The gitlab pipeline for the KVM unit tests uses TCG and it will keep
> > failing every time as long as the pipeline uses a version of Qemu
> > without the aforementioned patch.
> > 
> > Fence the specific testcase for now. Once the pipeline is fixed, this
> > patch can safely be reverted.
> > 
> > This patch is meant to go on top this already queued patch from Janis:
> > "s390x/intercept: Test invalid prefix argument to SET PREFIX"
> > https://lore.kernel.org/all/20220627152412.2243255-1-scgl@linux.ibm.com/  
> 
> If we keep this as a separate patch, that paragraph should be removed from 
> the commit description.

yeah that will be removed

> 
> Anyway:
> 
> Reviewed-by: Thomas Huth <thuth@redhat.com>
> 

thanks!
