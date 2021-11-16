Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2D20A453407
	for <lists+kvm@lfdr.de>; Tue, 16 Nov 2021 15:21:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237277AbhKPOY1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 16 Nov 2021 09:24:27 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:60406 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S237357AbhKPOYE (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 16 Nov 2021 09:24:04 -0500
Received: from pps.filterd (m0098413.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 1AGDamYd021120;
        Tue, 16 Nov 2021 14:21:07 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : references : mime-version : content-type :
 in-reply-to; s=pp1; bh=tLeuFLjwj/uR/Lpm1a39bM0xOu/zyT2p4Tr6cd+2NrI=;
 b=aM0ofw5CJP1g/y+Uo7bxOJQ1AtpDxqDOXwG07ERmamle8wINQMgqHH3RInCCF0Cai3i+
 wKazSEfpwqLFUMgt5+4OivJSN9oIfmeXaaurpHXg6p3piW2g1IShxnEZlovCDInSFqmb
 RzB6DebEArwykkA5PCvYtH0/hiWOL669+fBaL3UA1Wkyztx1w7qFPW/DukadFMokeG38
 beWrD0rQY/UTw5rnR/YWM7RbcdI5yDmhMzL8JOfX4Up3AcEiDo6JfNFe4VmiNrprtgoA
 icc+pcb6+Ri6cYmwWBnZ16QMbdlUQvqaCd/SP9B0QrnGwuFvz126xX7Hk8etUn9Y5Slc jQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3cc6tbj9du-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 16 Nov 2021 14:21:06 +0000
Received: from m0098413.ppops.net (m0098413.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 1AGDxNfm018723;
        Tue, 16 Nov 2021 14:21:06 GMT
Received: from ppma03fra.de.ibm.com (6b.4a.5195.ip4.static.sl-reverse.com [149.81.74.107])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3cc6tbj9d9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 16 Nov 2021 14:21:06 +0000
Received: from pps.filterd (ppma03fra.de.ibm.com [127.0.0.1])
        by ppma03fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 1AGE8isi005603;
        Tue, 16 Nov 2021 14:21:04 GMT
Received: from b06avi18626390.portsmouth.uk.ibm.com (b06avi18626390.portsmouth.uk.ibm.com [9.149.26.192])
        by ppma03fra.de.ibm.com with ESMTP id 3ca509ydm4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 16 Nov 2021 14:21:04 +0000
Received: from d06av24.portsmouth.uk.ibm.com (d06av24.portsmouth.uk.ibm.com [9.149.105.60])
        by b06avi18626390.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 1AGEE81643450772
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 16 Nov 2021 14:14:08 GMT
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 8AD6442042;
        Tue, 16 Nov 2021 14:21:01 +0000 (GMT)
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 32F4F4203F;
        Tue, 16 Nov 2021 14:21:01 +0000 (GMT)
Received: from osiris (unknown [9.145.93.200])
        by d06av24.portsmouth.uk.ibm.com (Postfix) with ESMTPS;
        Tue, 16 Nov 2021 14:21:01 +0000 (GMT)
Date:   Tue, 16 Nov 2021 15:20:59 +0100
From:   Heiko Carstens <hca@linux.ibm.com>
To:     Christian Borntraeger <borntraeger@linux.ibm.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Vasily Gorbik <gor@linux.ibm.com>, KVM <kvm@vger.kernel.org>,
        Janosch Frank <frankja@linux.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        David Hildenbrand <david@redhat.com>,
        linux-s390 <linux-s390@vger.kernel.org>,
        Christian Borntraeger <borntraeger@de.ibm.com>
Subject: Re: [PATCH 1/1] MAINTAINERS: update email address of borntraeger
Message-ID: <YZO+S5bXJxPD/jgg@osiris>
References: <20211116135803.119489-1-borntraeger@linux.ibm.com>
 <20211116135803.119489-2-borntraeger@linux.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211116135803.119489-2-borntraeger@linux.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: oJ77AIJ1AkFTYLm2hm2-ZQjZSAMaI1dV
X-Proofpoint-ORIG-GUID: Ki5GOeQKdXzb2275KxDMBtUdzZExKrKV
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.0.607.475
 definitions=2021-11-16_02,2021-11-16_01,2020-04-07_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 phishscore=0
 priorityscore=1501 mlxscore=0 impostorscore=0 adultscore=0 suspectscore=0
 malwarescore=0 clxscore=1011 lowpriorityscore=0 bulkscore=0 spamscore=0
 mlxlogscore=769 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2110150000 definitions=main-2111160070
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Nov 16, 2021 at 02:58:03PM +0100, Christian Borntraeger wrote:
> My borntraeger@de.ibm.com email is just a forwarder to the
> linux.ibm.com address. Let us remove the extra hop to avoid
> a potential source of errors.
> 
> While at it, add the relevant email addresses to mailmap.
> 
> Signed-off-by: Christian Borntraeger <borntraeger@linux.ibm.com>
> ---
>  .mailmap    | 3 +++
>  MAINTAINERS | 4 ++--
>  2 files changed, 5 insertions(+), 2 deletions(-)

Applied, thanks!
