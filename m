Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 774CB6A5E1E
	for <lists+kvm@lfdr.de>; Tue, 28 Feb 2023 18:20:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229524AbjB1RUo (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 28 Feb 2023 12:20:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44754 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229437AbjB1RUn (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 28 Feb 2023 12:20:43 -0500
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 716CF1ABE8;
        Tue, 28 Feb 2023 09:20:42 -0800 (PST)
Received: from pps.filterd (m0098421.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 31SGYfvf005109;
        Tue, 28 Feb 2023 17:20:41 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=pp1;
 bh=ik5iaUcn4aUanPaSreO3KU4tHAIQK1wl+/Jl2te1YGY=;
 b=gTAxVgynl29/2AztDyYR5FgEw952hFNxCQzUcANYMokOnyTDJpYfYYojpkUaTCD1KWHd
 GD4/Jw4xW8Cl/PDO1tMowJVpzY9+KqggcjPnPuQzWuOKGrzLxiuywwSMteaa5ckgEpqI
 GLaTx2SU65/Xl2EXrbmotMSfepeNLEf6cn5+5Dp3vtaBUrNFb+pDHmxNToVNOk6acRRI
 /aUvuhlvfO6omVuLrgXnCZNkUwUHCaNV5saQ0FYe4wxNnbtHXhuvZ18ygNuopu/jp/ic
 6UScHpt7k0SOMSVaYbtUiGQaDmYwotGG1neZKTqk3qqh95AAgpbR4zxkPKgl6KNTQQY1 qQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3p1n8qh680-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 28 Feb 2023 17:20:41 +0000
Received: from m0098421.ppops.net (m0098421.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 31SHHO0D011199;
        Tue, 28 Feb 2023 17:20:41 GMT
Received: from ppma01fra.de.ibm.com (46.49.7a9f.ip4.static.sl-reverse.com [159.122.73.70])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3p1n8qh678-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 28 Feb 2023 17:20:40 +0000
Received: from pps.filterd (ppma01fra.de.ibm.com [127.0.0.1])
        by ppma01fra.de.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 31SD0k0h001589;
        Tue, 28 Feb 2023 17:20:39 GMT
Received: from smtprelay05.fra02v.mail.ibm.com ([9.218.2.225])
        by ppma01fra.de.ibm.com (PPS) with ESMTPS id 3nybdftesa-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 28 Feb 2023 17:20:39 +0000
Received: from smtpav03.fra02v.mail.ibm.com (smtpav03.fra02v.mail.ibm.com [10.20.54.102])
        by smtprelay05.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 31SHKZZ065667342
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 28 Feb 2023 17:20:35 GMT
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 877D22004B;
        Tue, 28 Feb 2023 17:20:35 +0000 (GMT)
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 0AC7B20043;
        Tue, 28 Feb 2023 17:20:35 +0000 (GMT)
Received: from p-imbrenda (unknown [9.171.17.91])
        by smtpav03.fra02v.mail.ibm.com (Postfix) with SMTP;
        Tue, 28 Feb 2023 17:20:34 +0000 (GMT)
Date:   Tue, 28 Feb 2023 18:20:33 +0100
From:   Claudio Imbrenda <imbrenda@linux.ibm.com>
To:     Janosch Frank <frankja@linux.ibm.com>
Cc:     kvm@vger.kernel.org, linux-s390@vger.kernel.org, thuth@redhat.com,
        seiden@linux.ibm.com, nrb@linux.ibm.com, nsg@linux.ibm.com
Subject: Re: [kvm-unit-tests PATCH 3/3] s390x: pv: Add IPL reset tests
Message-ID: <20230228182033.67876b8b@p-imbrenda>
In-Reply-To: <171b551d-5c44-172e-4bdc-65cdb6e446ce@linux.ibm.com>
References: <20230201084833.39846-1-frankja@linux.ibm.com>
        <20230201084833.39846-4-frankja@linux.ibm.com>
        <20230217174219.71163eb5@p-imbrenda>
        <171b551d-5c44-172e-4bdc-65cdb6e446ce@linux.ibm.com>
Organization: IBM
X-Mailer: Claws Mail 4.1.1 (GTK 3.24.35; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: ipNZiBzeX2Z7YnXQI3Q3XKjYT0PL5zcZ
X-Proofpoint-GUID: xLn4LsokSqwx5-XEwYaq88T0Yh-GWlUr
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-02-28_13,2023-02-28_03,2023-02-09_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 clxscore=1015 mlxscore=0 spamscore=0 adultscore=0 malwarescore=0
 impostorscore=0 lowpriorityscore=0 suspectscore=0 mlxlogscore=999
 phishscore=0 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2212070000 definitions=main-2302280141
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 21 Feb 2023 10:26:11 +0100
Janosch Frank <frankja@linux.ibm.com> wrote:

[...]

> 
> >> +/* Execute the diag500 which will set the subcode we execute in gr2 */
> >> +diag	0, 0, 0x500
> >> +
> >> +/*
> >> + * A valid PGM new PSW can be a real problem since we never fall out
> >> + * of SIE and therefore effectively loop forever. 0 is a valid PSW
> >> + * therefore we re-use the reset_psw as this has the short PSW
> >> + * bit set which is invalid for a long PSW like the exception new
> >> + * PSWs.
> >> + *
> >> + * For subcode 0/1 there are no PGMs to consider.
> >> + */
> >> +lgrl   %r5, reset_psw
> >> +stg    %r5, GEN_LC_PGM_NEW_PSW
> >> +
> >> +/* Clean registers that are used */
> >> +xgr	%r0, %r0
> >> +xgr	%r1, %r1
> >> +xgr	%r3, %r3
> >> +xgr	%r4, %r4
> >> +xgr	%r5, %r5
> >> +xgr	%r6, %r6
> >> +
> >> +/* Subcode 0 - Modified Clear */  
> > 
> > what about subcode 1?  
> 
> My guess is that this hasn't been removed after a re-work of the code.
> I suggest to remove the comment.

sounds good

> 
> >   
> >> +SET_RESET_PSW_ADDR done
> >> +diag	%r0, %r2, 0x308
> >> +
> >> +/* Should never be executed because of the reset PSW */
> >> +diag	0, 0, 0x44
> >> +
> >> +done:
> >> +lghi	%r1, 42
> >> +diag	%r1, 0, 0x9c
> >> +
> >> +
> >> +	.align	8
> >> +reset_psw:
> >> +	.quad	0x0008000180000000  
> >   
> 

