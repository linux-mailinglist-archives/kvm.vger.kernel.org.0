Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2D4FD6A5E1C
	for <lists+kvm@lfdr.de>; Tue, 28 Feb 2023 18:19:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229592AbjB1RTs (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 28 Feb 2023 12:19:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44328 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229585AbjB1RTp (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 28 Feb 2023 12:19:45 -0500
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 983361ABE8;
        Tue, 28 Feb 2023 09:19:44 -0800 (PST)
Received: from pps.filterd (m0098399.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 31SHDdOI011008;
        Tue, 28 Feb 2023 17:19:44 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=pp1;
 bh=M5Q1aP+LbLYxMfyjfrSpYE0iRbO9vgu03GegGbVGmlM=;
 b=Ql0Dgu6i3sdmc6+4UQ5+b6ZpIRz/yBSj1NZmEQ2zmm2j+pK/bxGv544u5lNdzmvqKOH4
 mbl5tO3Q0y91xCxxpHX1KfCba8B4JAA4ZmbXZyY7xs53WBDtNrIkeP+SyPRYEFz/jMra
 5w5O3o2NrUR1oOKpiSGlVfPjc3kwauXkKIgutioFG7mkeRa8Xe8zszBV9UK38sdTQ9OE
 FSs/iKLgmlUiWA15TBy+8sqGrdXDP+U1mTX/TSsZdlixjjx96m8wWcHOOxKqPh3vAHqc
 nnMVRCv0LCGM23I+6SE6GpWH9dscjApguv94UiBa1HFJ8GA4xQm2V5a0M4p/7etefkMg kg== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3p1mfq30b0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 28 Feb 2023 17:19:43 +0000
Received: from m0098399.ppops.net (m0098399.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 31SGt4Gg016505;
        Tue, 28 Feb 2023 17:19:43 GMT
Received: from ppma02fra.de.ibm.com (47.49.7a9f.ip4.static.sl-reverse.com [159.122.73.71])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3p1mfq30ab-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 28 Feb 2023 17:19:43 +0000
Received: from pps.filterd (ppma02fra.de.ibm.com [127.0.0.1])
        by ppma02fra.de.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 31SH2iJ8011251;
        Tue, 28 Feb 2023 17:19:41 GMT
Received: from smtprelay04.fra02v.mail.ibm.com ([9.218.2.228])
        by ppma02fra.de.ibm.com (PPS) with ESMTPS id 3nybe2jete-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 28 Feb 2023 17:19:40 +0000
Received: from smtpav04.fra02v.mail.ibm.com (smtpav04.fra02v.mail.ibm.com [10.20.54.103])
        by smtprelay04.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 31SHJb1L19333466
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 28 Feb 2023 17:19:37 GMT
Received: from smtpav04.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 3F47F2004F;
        Tue, 28 Feb 2023 17:19:37 +0000 (GMT)
Received: from smtpav04.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id D2B7E20043;
        Tue, 28 Feb 2023 17:19:36 +0000 (GMT)
Received: from p-imbrenda (unknown [9.171.17.91])
        by smtpav04.fra02v.mail.ibm.com (Postfix) with SMTP;
        Tue, 28 Feb 2023 17:19:36 +0000 (GMT)
Date:   Tue, 28 Feb 2023 18:19:34 +0100
From:   Claudio Imbrenda <imbrenda@linux.ibm.com>
To:     Janosch Frank <frankja@linux.ibm.com>
Cc:     kvm@vger.kernel.org, linux-s390@vger.kernel.org, thuth@redhat.com,
        seiden@linux.ibm.com, nrb@linux.ibm.com, nsg@linux.ibm.com
Subject: Re: [kvm-unit-tests PATCH 2/3] s390x: pv: Test sie entry intercepts
 and validities
Message-ID: <20230228181934.24c573df@p-imbrenda>
In-Reply-To: <95184ea5-7451-934d-8988-54f0eeec99f1@linux.ibm.com>
References: <20230201084833.39846-1-frankja@linux.ibm.com>
        <20230201084833.39846-3-frankja@linux.ibm.com>
        <20230215180625.53b260a9@p-imbrenda>
        <95184ea5-7451-934d-8988-54f0eeec99f1@linux.ibm.com>
Organization: IBM
X-Mailer: Claws Mail 4.1.1 (GTK 3.24.35; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: pxC9qIIfAdn2wc_Z8YPpFgHeQOtl8wT8
X-Proofpoint-ORIG-GUID: ldgtwBpKeJB8HhjWAUTjQXT-wwhnoHjJ
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-02-28_14,2023-02-28_03,2023-02-09_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 suspectscore=0
 priorityscore=1501 impostorscore=0 phishscore=0 lowpriorityscore=0
 malwarescore=0 clxscore=1015 bulkscore=0 adultscore=0 mlxlogscore=999
 mlxscore=0 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2212070000 definitions=main-2302280141
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 21 Feb 2023 10:22:13 +0100
Janosch Frank <frankja@linux.ibm.com> wrote:

[...]

> >> +	/* Yes I know this is not reliable as one cpu might overwrite it */  
> > 
> > the wording in this comment could be improved  
> 
> How about:
> This might not be fully reliable but it should be sufficient for our 
> current goals.

looks good, thanks

> 
> [...]
> 
> >> +	report_prefix_push("shared");
> >> +	sie(&vm);
> >> +	/* Guest indicates that it has shared the new lowcore */
> >> +	report(vm.sblk->icptcode == ICPT_PV_NOTIFY && vm.sblk->ipa == 0x8302 &&
> >> +	       vm.sblk->ipb == 0x50000000 && vm.save_area.guest.grs[5] == 0x44,
> >> +	       "intercept values");
> >> +
> >> +	uv_export(vm.sblk->mso + lc_off);
> >> +	uv_export(vm.sblk->mso + lc_off + PAGE_SIZE);  
> > 
> > why are you not testing both pages individually here, like you did
> > above?  
> 
> Hmm, I don't think there was a reason behind this. I'll add it.
> 
> [...]

