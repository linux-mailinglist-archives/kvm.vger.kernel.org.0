Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BEC85745BD1
	for <lists+kvm@lfdr.de>; Mon,  3 Jul 2023 14:04:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231206AbjGCMEd (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 3 Jul 2023 08:04:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35560 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230183AbjGCMEc (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 3 Jul 2023 08:04:32 -0400
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B61BB109;
        Mon,  3 Jul 2023 05:04:31 -0700 (PDT)
Received: from pps.filterd (m0353722.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 363C2iFg003675;
        Mon, 3 Jul 2023 12:04:31 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=pp1;
 bh=wRK3wxUFxkIBfxCkvO4Xl7cbBWtnXnvnWceydubqDCY=;
 b=LfNf9nTE7Gqb0RBks3lLsxRqf2M40/38HBoXR+5ltLZgETT7Y63RdXszWa9p9N/1AQMU
 sa6UEiHr73wxhM996Cuggn+/y83BM+GZMDiLcEM/jAk5qW90KTmZ/SM6HEscCx6QTVpK
 1WJxvuq99TMqhuUKyRdWeavxmDXaRkoaS3hEt8NxYX0kyu4qYTo0qDE/qPDvmfH8Uju8
 AykdwO2rp7tdrs/RU5l7m/RhpZO1v1P7L6Uw3O+q703SBxKYXx6a0nRMac0g0j2JFXKA
 NJPiy+TI99HzrZGvoqyoBIOnF3TUDh3ayFAJFTlAmwJOV4pUGxCt9VryLZ+IRCpVwTOC og== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3rkx060138-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 03 Jul 2023 12:04:30 +0000
Received: from m0353722.ppops.net (m0353722.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 363C2ll4003781;
        Mon, 3 Jul 2023 12:04:29 GMT
Received: from ppma06ams.nl.ibm.com (66.31.33a9.ip4.static.sl-reverse.com [169.51.49.102])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3rkx0600yc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 03 Jul 2023 12:04:29 +0000
Received: from pps.filterd (ppma06ams.nl.ibm.com [127.0.0.1])
        by ppma06ams.nl.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 362C454E006641;
        Mon, 3 Jul 2023 12:04:15 GMT
Received: from smtprelay07.fra02v.mail.ibm.com ([9.218.2.229])
        by ppma06ams.nl.ibm.com (PPS) with ESMTPS id 3rjbde1a42-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 03 Jul 2023 12:04:15 +0000
Received: from smtpav03.fra02v.mail.ibm.com (smtpav03.fra02v.mail.ibm.com [10.20.54.102])
        by smtprelay07.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 363C4CKQ63701268
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 3 Jul 2023 12:04:12 GMT
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 4062820043;
        Mon,  3 Jul 2023 12:04:12 +0000 (GMT)
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 0138620040;
        Mon,  3 Jul 2023 12:04:12 +0000 (GMT)
Received: from p-imbrenda (unknown [9.152.224.66])
        by smtpav03.fra02v.mail.ibm.com (Postfix) with ESMTP;
        Mon,  3 Jul 2023 12:04:11 +0000 (GMT)
Date:   Mon, 3 Jul 2023 14:04:10 +0200
From:   Claudio Imbrenda <imbrenda@linux.ibm.com>
To:     Janosch Frank <frankja@linux.ibm.com>
Cc:     kvm@vger.kernel.org, linux-s390@vger.kernel.org, thuth@redhat.com,
        david@redhat.com, nsg@linux.ibm.com, nrb@linux.ibm.com
Subject: Re: [kvm-unit-tests RFC 1/3] lib: s390x: sclp: Add carriage return
 to line feed
Message-ID: <20230703140410.6d1907d5@p-imbrenda>
In-Reply-To: <6ad06172-ad8e-4615-ad20-d254dcb3f380@linux.ibm.com>
References: <20230630145449.2312-1-frankja@linux.ibm.com>
        <20230630145449.2312-2-frankja@linux.ibm.com>
        <20230630171226.3e77e0eb@p-imbrenda>
        <6ad06172-ad8e-4615-ad20-d254dcb3f380@linux.ibm.com>
Organization: IBM
X-Mailer: Claws Mail 4.1.1 (GTK 3.24.38; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: gQZVqF8RFuyT7FHxiP9axTrRYlSMfYvN
X-Proofpoint-ORIG-GUID: xhGZMRuCpIdhpMjNRhYyLpPh-ymDSKT_
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.957,Hydra:6.0.591,FMLib:17.11.176.26
 definitions=2023-07-03_09,2023-06-30_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 adultscore=0 suspectscore=0
 bulkscore=0 mlxlogscore=999 clxscore=1015 spamscore=0 priorityscore=1501
 phishscore=0 impostorscore=0 mlxscore=0 malwarescore=0 lowpriorityscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2305260000
 definitions=main-2307030109
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, 3 Jul 2023 13:46:29 +0200
Janosch Frank <frankja@linux.ibm.com> wrote:

> On 6/30/23 17:12, Claudio Imbrenda wrote:
> > On Fri, 30 Jun 2023 14:54:47 +0000
> > Janosch Frank <frankja@linux.ibm.com> wrote:
> >   
> >> Without the \r the output of the ASCII console takes a lot of
> >> additional effort to read in comparison to the line mode console.
> >>
> >> Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
> >> ---
> >>   lib/s390x/sclp-console.c | 15 ++++++++++++++-
> >>   1 file changed, 14 insertions(+), 1 deletion(-)
> >>
> >> diff --git a/lib/s390x/sclp-console.c b/lib/s390x/sclp-console.c
> >> index 19c74e46..384080b0 100644
> >> --- a/lib/s390x/sclp-console.c
> >> +++ b/lib/s390x/sclp-console.c
> >> @@ -97,14 +97,27 @@ static void sclp_print_ascii(const char *str)
> >>   {
> >>   	int len = strlen(str);
> >>   	WriteEventData *sccb = (void *)_sccb;
> >> +	char *str_dest = (char *)&sccb->msg;
> >> +	int i = 0;
> >>   
> >>   	sclp_mark_busy();
> >>   	memset(sccb, 0, sizeof(*sccb));
> >> +
> >> +	for (; i < len; i++) {
> >> +		*str_dest = str[i];
> >> +		str_dest++;
> >> +		/* Add a \r to the \n */
> >> +		if (str[i] == '\n') {
> >> +			*str_dest = '\r';
> >> +			str_dest++;
> >> +		}
> >> +	}
> >> +
> >> +	len = (uintptr_t)str_dest - (uintptr_t)&sccb->msg;  
> > 
> > some strings will therefore potentially overflow the SCCB
> > 
> > sclp_print() refuses to print more than 2kB, with this patch that limit
> > could potentially be crossed
> > 
> > can you please briefly explain in a comment why that is ok? (or maybe
> > that is not ok? then fix it somehow :) )  
> 
> I'd like to see someone find a useful application for printing 2kb in a 
> single printf() call.

I'm with you there

> 
> Anyway, I could truncate the ASCII after the 2KB limit when adding the \r.

sounds like a plan

> 
> I'm wondering how the line-mode console interprets the \r. If it ignores 
> it, then we could also convert to \n\r for both consoles and check for 
> 2kb when converting.

is \n\r the right order? what about \r\n ?
