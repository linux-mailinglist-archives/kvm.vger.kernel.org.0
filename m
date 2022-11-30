Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7773D63D873
	for <lists+kvm@lfdr.de>; Wed, 30 Nov 2022 15:46:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229601AbiK3OqQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 30 Nov 2022 09:46:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43994 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229499AbiK3OqP (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 30 Nov 2022 09:46:15 -0500
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A8E682FA6D;
        Wed, 30 Nov 2022 06:46:14 -0800 (PST)
Received: from pps.filterd (m0098399.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 2AUEVfUC028040;
        Wed, 30 Nov 2022 14:46:14 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=pp1;
 bh=fS3B0R7stgiV0PsxxUIOkHEHrTaTOO9CSNAOklNttVA=;
 b=oiKEDu68MzIw1hKtYj/zZ0AinsOpQ0ibR7aXBpu0xmJzi8vQj/W5gkU96zTImUgzdhbN
 Jr6HjWJgSuqA0CuZArXelU5w4Eax/2BfkwPkCP9WvcAYrLg2V3iOcgq02tpoMJqb0Z4C
 gSyflUUJAGOFPFIKhsqMRo3rfGbYQ71298TFYDhsJjXPmY41l5gLQowCKnc2YavDtXAk
 L/lBj8kouWT3uih9WAd6JxyPh8nmM7JFji6ITaf9GOnPWk+FPD4uqAjqixL1gAw9yBof
 z/FwsjopkXx5DYBYbnUgJbGR6ohz7SCvU6AAxREw5cfmJIqwbYs77r5FK1BOLGQkRGwM Hw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3m66yc3rsc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 30 Nov 2022 14:46:14 +0000
Received: from m0098399.ppops.net (m0098399.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 2AUEJVbl028205;
        Wed, 30 Nov 2022 14:46:13 GMT
Received: from ppma04ams.nl.ibm.com (63.31.33a9.ip4.static.sl-reverse.com [169.51.49.99])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3m66yc3rrb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 30 Nov 2022 14:46:13 +0000
Received: from pps.filterd (ppma04ams.nl.ibm.com [127.0.0.1])
        by ppma04ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 2AUEZjMt008734;
        Wed, 30 Nov 2022 14:46:11 GMT
Received: from b06avi18626390.portsmouth.uk.ibm.com (b06avi18626390.portsmouth.uk.ibm.com [9.149.26.192])
        by ppma04ams.nl.ibm.com with ESMTP id 3m3ae9dy4c-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 30 Nov 2022 14:46:11 +0000
Received: from d06av23.portsmouth.uk.ibm.com (d06av23.portsmouth.uk.ibm.com [9.149.105.59])
        by b06avi18626390.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 2AUEdca82490968
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 30 Nov 2022 14:39:38 GMT
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 6943FA404D;
        Wed, 30 Nov 2022 14:46:08 +0000 (GMT)
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 2B66DA4040;
        Wed, 30 Nov 2022 14:46:08 +0000 (GMT)
Received: from p-imbrenda (unknown [9.152.224.56])
        by d06av23.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Wed, 30 Nov 2022 14:46:08 +0000 (GMT)
Date:   Wed, 30 Nov 2022 15:46:06 +0100
From:   Claudio Imbrenda <imbrenda@linux.ibm.com>
To:     Janosch Frank <frankja@linux.ibm.com>
Cc:     kvm@vger.kernel.org, linux-s390@vger.kernel.org, david@redhat.com,
        thuth@redhat.com, seiden@linux.ibm.com, nrb@linux.ibm.com
Subject: Re: [kvm-unit-tests PATCH 5/5] lib: s390x: Handle debug prints for
 SIE exceptions correctly
Message-ID: <20221130154606.758b1087@p-imbrenda>
In-Reply-To: <44870720-bd9c-47b2-f08e-6ece37410498@linux.ibm.com>
References: <20221123084656.19864-1-frankja@linux.ibm.com>
        <20221123084656.19864-6-frankja@linux.ibm.com>
        <20221123140118.25114940@p-imbrenda>
        <44870720-bd9c-47b2-f08e-6ece37410498@linux.ibm.com>
Organization: IBM
X-Mailer: Claws Mail 4.1.1 (GTK 3.24.35; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: pO-L9ZQcQsMTciCJwkxRzdvYGnzrQS3D
X-Proofpoint-ORIG-GUID: LGxfXx5sv7rMqyr55sn1dD48EJqKmDY4
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-11-30_04,2022-11-30_02,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 bulkscore=0 spamscore=0 impostorscore=0 suspectscore=0 mlxscore=0
 mlxlogscore=954 adultscore=0 clxscore=1015 phishscore=0 malwarescore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2210170000 definitions=main-2211300101
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, 30 Nov 2022 15:38:53 +0100
Janosch Frank <frankja@linux.ibm.com> wrote:

> On 11/23/22 14:01, Claudio Imbrenda wrote:
> > On Wed, 23 Nov 2022 08:46:56 +0000
> > Janosch Frank <frankja@linux.ibm.com> wrote:
> >   
> >> When we leave SIE due to an exception, we'll still have guest values
> >> in registers 0 - 13 and that's not clearly portraied in our debug
> >> prints. So let's fix that.  
> > 
> > wouldn't it be cleaner to restore the registers in the interrupt
> > handler? (I thought we were already doing it)  
> 
> You mean RESTORE_REGS_STACK? Please don't make me write this in assembly...
> 
> RESTORE_REGS_STACK is doing test/pgm register swapping, it doesn't care 
> if the test registers are "host" or "guest" registers.

fair enough :)

