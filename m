Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4E035743EB6
	for <lists+kvm@lfdr.de>; Fri, 30 Jun 2023 17:26:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232935AbjF3P0b (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 30 Jun 2023 11:26:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43226 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232835AbjF3P02 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 30 Jun 2023 11:26:28 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 52AED4220;
        Fri, 30 Jun 2023 08:26:08 -0700 (PDT)
Received: from pps.filterd (m0353727.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 35UFGp5n028558;
        Fri, 30 Jun 2023 15:26:08 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=pp1;
 bh=pn22A98pXYlQtC3wO0cEzklFNcVIWdSYRPNq41LuUvs=;
 b=IN94GtdpX/EnX49kPcHcBMbGmVxIwqca5AlXqzHCo1PFMqCQX4fm2sOCrgSe3Qte9WWy
 TrdFcgSq+ak/I0x7EGeaSf3z+dTkYCmdNnxUFT/IF8J0XJ54yS9QDrpqvK/JUmeIS5za
 yI6qO5bqpvmFPbZKihCq0BZ6vsRJJLDq0Tsntdopm5sVQ1Kwk+WWygCLyf3xqXELTsso
 sE+tuSAz98Z0SMfs6IBkRtw13qNMg/Ci4YPMH3mpqHZvRPnwNj4tQOfIeP7RFJpJ28K6
 cCnhVAP/CkHY74v50kXI3NH5eMKCGt0etVsl8w0kE1fjTAnHm7TmRP9A4HweYsORKycY 7g== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3rj1j8871h-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 30 Jun 2023 15:26:07 +0000
Received: from m0353727.ppops.net (m0353727.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 35UFHv8w032606;
        Fri, 30 Jun 2023 15:26:07 GMT
Received: from ppma05fra.de.ibm.com (6c.4a.5195.ip4.static.sl-reverse.com [149.81.74.108])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3rj1j88700-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 30 Jun 2023 15:26:07 +0000
Received: from pps.filterd (ppma05fra.de.ibm.com [127.0.0.1])
        by ppma05fra.de.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 35U405M1011788;
        Fri, 30 Jun 2023 15:26:03 GMT
Received: from smtprelay01.fra02v.mail.ibm.com ([9.218.2.227])
        by ppma05fra.de.ibm.com (PPS) with ESMTPS id 3rdr45b4d6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 30 Jun 2023 15:26:03 +0000
Received: from smtpav06.fra02v.mail.ibm.com (smtpav06.fra02v.mail.ibm.com [10.20.54.105])
        by smtprelay01.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 35UFQ0Mx8782360
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 30 Jun 2023 15:26:00 GMT
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 195D42004B;
        Fri, 30 Jun 2023 15:26:00 +0000 (GMT)
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id C1AAE20040;
        Fri, 30 Jun 2023 15:25:59 +0000 (GMT)
Received: from p-imbrenda (unknown [9.152.224.66])
        by smtpav06.fra02v.mail.ibm.com (Postfix) with ESMTP;
        Fri, 30 Jun 2023 15:25:59 +0000 (GMT)
Date:   Fri, 30 Jun 2023 17:25:58 +0200
From:   Claudio Imbrenda <imbrenda@linux.ibm.com>
To:     Janosch Frank <frankja@linux.ibm.com>
Cc:     kvm@vger.kernel.org, linux-s390@vger.kernel.org, thuth@redhat.com,
        david@redhat.com, nsg@linux.ibm.com, nrb@linux.ibm.com
Subject: Re: [kvm-unit-tests RFC 2/3] lib: s390x: sclp: Clear ASCII screen
 on setup
Message-ID: <20230630172558.3edfa9ec@p-imbrenda>
In-Reply-To: <20230630145449.2312-3-frankja@linux.ibm.com>
References: <20230630145449.2312-1-frankja@linux.ibm.com>
        <20230630145449.2312-3-frankja@linux.ibm.com>
Organization: IBM
X-Mailer: Claws Mail 4.1.1 (GTK 3.24.38; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: qZqqA0qN2cMEHnIyWr3afLsFvFMCUvyU
X-Proofpoint-ORIG-GUID: bAMdnxINwWSErEaZaJgXaMP14vofY7Fy
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.957,Hydra:6.0.591,FMLib:17.11.176.26
 definitions=2023-06-30_05,2023-06-30_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 adultscore=0 impostorscore=0
 suspectscore=0 bulkscore=0 spamscore=0 priorityscore=1501 mlxlogscore=999
 clxscore=1015 phishscore=0 malwarescore=0 lowpriorityscore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2305260000
 definitions=main-2306300127
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, 30 Jun 2023 14:54:48 +0000
Janosch Frank <frankja@linux.ibm.com> wrote:

> In contrast to the line-mode console the ASCII console will retain

what's the problem with that?

> previously written text on a reboot. So let's clear the console on
> setup so only our text will be displayed. To not clear the whole
> screen when running under QEMU we switch the run command to the line
> mode console.
> 
> Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
> ---
>  lib/s390x/sclp-console.c | 2 ++
>  s390x/run                | 2 +-
>  2 files changed, 3 insertions(+), 1 deletion(-)
> 
> diff --git a/lib/s390x/sclp-console.c b/lib/s390x/sclp-console.c
> index 384080b0..534d3443 100644
> --- a/lib/s390x/sclp-console.c
> +++ b/lib/s390x/sclp-console.c
> @@ -233,6 +233,8 @@ void sclp_console_setup(void)
>  {
>  	/* We send ASCII and line mode. */
>  	sclp_write_event_mask(0, SCLP_EVENT_MASK_MSG_ASCII | SCLP_EVENT_MASK_MSG);
> +	/* Hard terminal reset to clear screen */
> +	sclp_print_ascii("\ec");
>  }
>  
>  void sclp_print(const char *str)
> diff --git a/s390x/run b/s390x/run
> index f1111dbd..68f8e733 100755
> --- a/s390x/run
> +++ b/s390x/run
> @@ -28,7 +28,7 @@ fi
>  M='-machine s390-ccw-virtio'
>  M+=",accel=$ACCEL"
>  command="$qemu -nodefaults -nographic $M"
> -command+=" -chardev stdio,id=con0 -device sclpconsole,chardev=con0"
> +command+=" -chardev stdio,id=con0 -device sclplmconsole,chardev=con0"
>  command+=" -kernel"
>  command="$(panic_cmd) $(migration_cmd) $(timeout_cmd) $command"
>  

