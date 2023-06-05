Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D8DB27223CA
	for <lists+kvm@lfdr.de>; Mon,  5 Jun 2023 12:47:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230300AbjFEKrc (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 5 Jun 2023 06:47:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57022 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229967AbjFEKrb (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 5 Jun 2023 06:47:31 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 34836EA;
        Mon,  5 Jun 2023 03:47:30 -0700 (PDT)
Received: from pps.filterd (m0353726.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 355AL2OP009143;
        Mon, 5 Jun 2023 10:47:30 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=pp1;
 bh=j5qejy42J0uW3MhDxE4QmFyI3t6cuZ/IarPawSMMZyw=;
 b=Ec48oqj8hWfXCxyEVaSMtsFDxxcynZng/2Bj2BiEsR75Hbs/ePCw//hQ5vFTpxRcL8by
 Ndq4SSzAEbOGxfuoaLEhv3avUXeaz72e4AUdSNkqE9uT7JdwFjNpB+1+pn/0Ao9G9TnB
 aZ4rT3YozJynqJUvFk7U7BZtYubNODqTRkmGa2M6I5PIhlZkcmsBY6lvJBjIMUZ6nKFR
 AqcI1Q6YjN1ppKXuj7ha1N4cVFATa57kAKlMvcw/SrdFxrMpmqgs3M5V1DMPQQq3Hs1B
 V+ERCXzq+j+za1gNPWS3XcE8Eg9mHOyRlvzx10JuWfpjXcreqIZobSLrwU3Jk9dKm/Ou fQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3r1dvjrfn2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 05 Jun 2023 10:47:29 +0000
Received: from m0353726.ppops.net (m0353726.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 355AicP3027756;
        Mon, 5 Jun 2023 10:47:29 GMT
Received: from ppma05fra.de.ibm.com (6c.4a.5195.ip4.static.sl-reverse.com [149.81.74.108])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3r1dvjrfkr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 05 Jun 2023 10:47:29 +0000
Received: from pps.filterd (ppma05fra.de.ibm.com [127.0.0.1])
        by ppma05fra.de.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 355407GW007430;
        Mon, 5 Jun 2023 10:47:26 GMT
Received: from smtprelay03.fra02v.mail.ibm.com ([9.218.2.224])
        by ppma05fra.de.ibm.com (PPS) with ESMTPS id 3qyx8xh0ux-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 05 Jun 2023 10:47:26 +0000
Received: from smtpav03.fra02v.mail.ibm.com (smtpav03.fra02v.mail.ibm.com [10.20.54.102])
        by smtprelay03.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 355AlN5J18612864
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 5 Jun 2023 10:47:23 GMT
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 3081E20040;
        Mon,  5 Jun 2023 10:47:23 +0000 (GMT)
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 0756A2004D;
        Mon,  5 Jun 2023 10:47:23 +0000 (GMT)
Received: from p-imbrenda (unknown [9.152.224.66])
        by smtpav03.fra02v.mail.ibm.com (Postfix) with ESMTP;
        Mon,  5 Jun 2023 10:47:22 +0000 (GMT)
Date:   Mon, 5 Jun 2023 12:35:55 +0200
From:   Claudio Imbrenda <imbrenda@linux.ibm.com>
To:     Janosch Frank <frankja@linux.ibm.com>
Cc:     Nico Boehr <nrb@linux.ibm.com>, thuth@redhat.com,
        kvm@vger.kernel.org, linux-s390@vger.kernel.org
Subject: Re: [kvm-unit-tests PATCH v3 1/6] lib: s390x: introduce bitfield
 for PSW mask
Message-ID: <20230605123555.4f865f2c@p-imbrenda>
In-Reply-To: <3667d7af-f9ba-fbb6-537d-e6143f63ac43@linux.ibm.com>
References: <20230601070202.152094-1-nrb@linux.ibm.com>
        <20230601070202.152094-2-nrb@linux.ibm.com>
        <3667d7af-f9ba-fbb6-537d-e6143f63ac43@linux.ibm.com>
Organization: IBM
X-Mailer: Claws Mail 4.1.1 (GTK 3.24.38; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: A4ep7Yx_Yd8w1vSb9nAT-Sz1mZfYId8R
X-Proofpoint-GUID: exBYvJaftsKcGvka91wlUwH7Xvtbgmha
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.957,Hydra:6.0.573,FMLib:17.11.176.26
 definitions=2023-06-03_08,2023-06-02_02,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 phishscore=0
 adultscore=0 clxscore=1015 suspectscore=0 spamscore=0 malwarescore=0
 bulkscore=0 impostorscore=0 mlxlogscore=913 priorityscore=1501
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2304280000 definitions=main-2306050094
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, 1 Jun 2023 09:42:48 +0200
Janosch Frank <frankja@linux.ibm.com> wrote:

[...]

> Hrm, since I already made the mistake of introducing bitfields with and 
> without spaces between the ":" I'm in no position to complain here.
> 
> I'm also not sure what the consensus is.

tbh I don't really have an opinion, I don't mind either, to the point
that I don't even care if we mix them

> 
> > +		};
> > +	};
> >   	uint64_t	addr;
> >   };  
> 
> I've come to like static asserts for huge structs and bitfields since 
> they can safe you from a *lot* of headaches.

you mean statically asserting that the size is what it should be?
in that case fully agree

[...]
