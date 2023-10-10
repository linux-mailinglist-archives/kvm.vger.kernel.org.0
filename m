Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E05BF7BF8CE
	for <lists+kvm@lfdr.de>; Tue, 10 Oct 2023 12:40:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230174AbjJJKks (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 10 Oct 2023 06:40:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32946 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229597AbjJJKkq (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 10 Oct 2023 06:40:46 -0400
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A76E594
        for <kvm@vger.kernel.org>; Tue, 10 Oct 2023 03:40:40 -0700 (PDT)
Received: from pps.filterd (m0353722.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 39AAP5OB012154
        for <kvm@vger.kernel.org>; Tue, 10 Oct 2023 10:40:40 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=pp1;
 bh=jEEvz3I1mUzTKaBwvSIJ76ZQBjX4G7Y1m7d7LhizfpA=;
 b=kIBKKo/mAmpxTQ/r3K0TbRA58xQk7Fu76VrHlhTmVqcmLHPEB+FQbifBGA57D1Zfpl17
 PZzdM05te7w+Ke4CMOMqqCTfgDX/LqcjDpsl/3Vbo/SVYV/X3ShzoRcugoVnOutVOFrb
 OFbZyWcgr5w8AlC+TuwO2r739X/evWpZLVoAYLyQd40XjsSbV7496qmoMqs9piXE2Cse
 1Y0YHxDm2/ipD/Z+6/oL/d3jX81Uc9ZNbRYxpXks91Oo63ChG4uYrIX43FzaWamX/9pr
 Sj/mjI9DHPt5qfhWvhS4nG6KwXthv2oS8RcZHmCEkPxFiVLCq6517AdCushR3WbqywAY ag== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3tn4u7gmb8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Tue, 10 Oct 2023 10:40:39 +0000
Received: from m0353722.ppops.net (m0353722.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 39AAPGlr013408
        for <kvm@vger.kernel.org>; Tue, 10 Oct 2023 10:40:39 GMT
Received: from ppma11.dal12v.mail.ibm.com (db.9e.1632.ip4.static.sl-reverse.com [50.22.158.219])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3tn4u7gmae-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 10 Oct 2023 10:40:39 +0000
Received: from pps.filterd (ppma11.dal12v.mail.ibm.com [127.0.0.1])
        by ppma11.dal12v.mail.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 39A9oBlG023106;
        Tue, 10 Oct 2023 10:40:38 GMT
Received: from smtprelay03.fra02v.mail.ibm.com ([9.218.2.224])
        by ppma11.dal12v.mail.ibm.com (PPS) with ESMTPS id 3tkmc1f78y-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 10 Oct 2023 10:40:38 +0000
Received: from smtpav06.fra02v.mail.ibm.com (smtpav06.fra02v.mail.ibm.com [10.20.54.105])
        by smtprelay03.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 39AAeZgt21758680
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 10 Oct 2023 10:40:35 GMT
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id AD60E20040;
        Tue, 10 Oct 2023 10:40:35 +0000 (GMT)
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 88D9A20049;
        Tue, 10 Oct 2023 10:40:35 +0000 (GMT)
Received: from p-imbrenda (unknown [9.152.224.66])
        by smtpav06.fra02v.mail.ibm.com (Postfix) with ESMTP;
        Tue, 10 Oct 2023 10:40:35 +0000 (GMT)
Date:   Tue, 10 Oct 2023 12:40:29 +0200
From:   Claudio Imbrenda <imbrenda@linux.ibm.com>
To:     Janosch Frank <frankja@linux.ibm.com>
Cc:     kvm@vger.kernel.org, thuth@redhat.com, david@redhat.com,
        nsg@linux.ibm.com, nrb@linux.ibm.com
Subject: Re: [kvm-unit-tests PATCH 1/3] lib: s390x: hw: Provide early detect
 host
Message-ID: <20231010124029.70abcb0a@p-imbrenda>
In-Reply-To: <20231010073855.26319-2-frankja@linux.ibm.com>
References: <20231010073855.26319-1-frankja@linux.ibm.com>
        <20231010073855.26319-2-frankja@linux.ibm.com>
Organization: IBM
X-Mailer: Claws Mail 4.1.1 (GTK 3.24.38; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: 4M4oTp1WVbS_40OeFbROzc5TfchuqMdm
X-Proofpoint-ORIG-GUID: XNdZQ-lH0mmlGvW5E10731IdKgnFT48O
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.267,Aquarius:18.0.980,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2023-10-10_05,2023-10-10_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 suspectscore=0
 impostorscore=0 priorityscore=1501 bulkscore=0 clxscore=1015 adultscore=0
 malwarescore=0 phishscore=0 lowpriorityscore=0 spamscore=0 mlxscore=0
 mlxlogscore=810 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2309180000 definitions=main-2310100079
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H4,
        RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 10 Oct 2023 07:38:53 +0000
Janosch Frank <frankja@linux.ibm.com> wrote:

> For early sclp printing it's necessary to know if we're under LPAR or
> not so we can apply compat SCLP ASCII transformations.
> 
> Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
> ---
>  lib/s390x/hardware.c | 8 ++++++++
>  lib/s390x/hardware.h | 1 +
>  2 files changed, 9 insertions(+)
> 
> diff --git a/lib/s390x/hardware.c b/lib/s390x/hardware.c
> index 2bcf9c4c..d5a752c0 100644
> --- a/lib/s390x/hardware.c
> +++ b/lib/s390x/hardware.c
> @@ -52,6 +52,14 @@ static enum s390_host do_detect_host(void *buf)
>  	return HOST_IS_UNKNOWN;
>  }
>  
> +enum s390_host detect_host_early(void)
> +{
> +	if (stsi_get_fc() == 2)
> +		return HOST_IS_LPAR;
> +
> +	return HOST_IS_UNKNOWN;
> +}
> +
>  enum s390_host detect_host(void)
>  {
>  	static enum s390_host host = HOST_IS_UNKNOWN;
> diff --git a/lib/s390x/hardware.h b/lib/s390x/hardware.h
> index 86fe873c..5e5a9d90 100644
> --- a/lib/s390x/hardware.h
> +++ b/lib/s390x/hardware.h
> @@ -24,6 +24,7 @@ enum s390_host {
>  };
>  
>  enum s390_host detect_host(void);
> +enum s390_host detect_host_early(void);

I wonder if it weren't easier to fix detect_host so it can be used
early.... 

>  
>  static inline uint16_t get_machine_id(void)
>  {

