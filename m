Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 60DA5743E9E
	for <lists+kvm@lfdr.de>; Fri, 30 Jun 2023 17:21:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231633AbjF3PVw (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 30 Jun 2023 11:21:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38430 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232836AbjF3PVi (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 30 Jun 2023 11:21:38 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 60ABC1FCB;
        Fri, 30 Jun 2023 08:21:16 -0700 (PDT)
Received: from pps.filterd (m0356517.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 35UFL6c4022072;
        Fri, 30 Jun 2023 15:21:16 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=pp1;
 bh=mroG2bNPFP4a3LKuOqs8lVWBWyw9ttA+6E6TiOkXUJk=;
 b=lL8W+Iwh+ZnF+WaWZC2I8tpdPb//AKWDV6cIdyIw5jogcNKGZSVrdjSlk1OUZRWxmsmg
 /MwCeWNfMBOQq3Lo/CGkKJ7/nvm2i64ruzQwXSJFqWsPldNbwqEZ2c0h/w2mzP8gRPhz
 PhxLAq6UaSrpt83JgknWrMVO0TGkKqzHQOnpt3P8cK3zWTa+nPOehM0ghPmYLQ0uv6zi
 QuBKCOt6ganFjkzaKnqc1oHA6hZal66U1voHtmNYeKuX3JuJwN58ySYNrkZuEXrsoSgn
 ucUIPcsnqdyKfGq8++eyo1qgxKldffBLJKGu6Z1pFIjLiCBYIHyadFDlpeznz7q4PiWv fA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3rj1m7804v-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 30 Jun 2023 15:21:15 +0000
Received: from m0356517.ppops.net (m0356517.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 35UFLFVs022531;
        Fri, 30 Jun 2023 15:21:15 GMT
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3rj1m78046-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 30 Jun 2023 15:21:15 +0000
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
        by ppma03ams.nl.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 35UAodqT003997;
        Fri, 30 Jun 2023 15:21:13 GMT
Received: from smtprelay03.fra02v.mail.ibm.com ([9.218.2.224])
        by ppma03ams.nl.ibm.com (PPS) with ESMTPS id 3rdr4547dy-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 30 Jun 2023 15:21:12 +0000
Received: from smtpav04.fra02v.mail.ibm.com (smtpav04.fra02v.mail.ibm.com [10.20.54.103])
        by smtprelay03.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 35UFL9Hs3343092
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 30 Jun 2023 15:21:09 GMT
Received: from smtpav04.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 67CA72004D;
        Fri, 30 Jun 2023 15:21:09 +0000 (GMT)
Received: from smtpav04.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 1DC8520040;
        Fri, 30 Jun 2023 15:21:09 +0000 (GMT)
Received: from p-imbrenda (unknown [9.152.224.66])
        by smtpav04.fra02v.mail.ibm.com (Postfix) with ESMTP;
        Fri, 30 Jun 2023 15:21:09 +0000 (GMT)
Date:   Fri, 30 Jun 2023 17:12:26 +0200
From:   Claudio Imbrenda <imbrenda@linux.ibm.com>
To:     Janosch Frank <frankja@linux.ibm.com>
Cc:     kvm@vger.kernel.org, linux-s390@vger.kernel.org, thuth@redhat.com,
        david@redhat.com, nsg@linux.ibm.com, nrb@linux.ibm.com
Subject: Re: [kvm-unit-tests RFC 1/3] lib: s390x: sclp: Add carriage return
 to line feed
Message-ID: <20230630171226.3e77e0eb@p-imbrenda>
In-Reply-To: <20230630145449.2312-2-frankja@linux.ibm.com>
References: <20230630145449.2312-1-frankja@linux.ibm.com>
        <20230630145449.2312-2-frankja@linux.ibm.com>
Organization: IBM
X-Mailer: Claws Mail 4.1.1 (GTK 3.24.38; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: 4IpcbtqqaW5tpxbAM6yF88xlYsoRbl8C
X-Proofpoint-ORIG-GUID: vCCqO_j3h23g82c7AsXgnM4Jspn0zlDB
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.957,Hydra:6.0.591,FMLib:17.11.176.26
 definitions=2023-06-30_05,2023-06-30_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 bulkscore=0 mlxlogscore=999
 impostorscore=0 mlxscore=0 phishscore=0 malwarescore=0 lowpriorityscore=0
 priorityscore=1501 clxscore=1015 spamscore=0 adultscore=0 suspectscore=0
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

On Fri, 30 Jun 2023 14:54:47 +0000
Janosch Frank <frankja@linux.ibm.com> wrote:

> Without the \r the output of the ASCII console takes a lot of
> additional effort to read in comparison to the line mode console.
> 
> Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
> ---
>  lib/s390x/sclp-console.c | 15 ++++++++++++++-
>  1 file changed, 14 insertions(+), 1 deletion(-)
> 
> diff --git a/lib/s390x/sclp-console.c b/lib/s390x/sclp-console.c
> index 19c74e46..384080b0 100644
> --- a/lib/s390x/sclp-console.c
> +++ b/lib/s390x/sclp-console.c
> @@ -97,14 +97,27 @@ static void sclp_print_ascii(const char *str)
>  {
>  	int len = strlen(str);
>  	WriteEventData *sccb = (void *)_sccb;
> +	char *str_dest = (char *)&sccb->msg;
> +	int i = 0;
>  
>  	sclp_mark_busy();
>  	memset(sccb, 0, sizeof(*sccb));
> +
> +	for (; i < len; i++) {
> +		*str_dest = str[i];
> +		str_dest++;
> +		/* Add a \r to the \n */
> +		if (str[i] == '\n') {
> +			*str_dest = '\r';
> +			str_dest++;
> +		}
> +	}
> +
> +	len = (uintptr_t)str_dest - (uintptr_t)&sccb->msg;

some strings will therefore potentially overflow the SCCB

sclp_print() refuses to print more than 2kB, with this patch that limit
could potentially be crossed

can you please briefly explain in a comment why that is ok? (or maybe
that is not ok? then fix it somehow :) )

>  	sccb->h.length = offsetof(WriteEventData, msg) + len;
>  	sccb->h.function_code = SCLP_FC_NORMAL_WRITE;
>  	sccb->ebh.length = sizeof(EventBufferHeader) + len;
>  	sccb->ebh.type = SCLP_EVENT_ASCII_CONSOLE_DATA;
> -	memcpy(&sccb->msg, str, len);
>  
>  	sclp_service_call(SCLP_CMD_WRITE_EVENT_DATA, sccb);
>  }

