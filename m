Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 384F3369AA0
	for <lists+kvm@lfdr.de>; Fri, 23 Apr 2021 21:07:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243699AbhDWTH6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 23 Apr 2021 15:07:58 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:6938 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229549AbhDWTH5 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 23 Apr 2021 15:07:57 -0400
Received: from pps.filterd (m0098393.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 13NJ3r6S102474;
        Fri, 23 Apr 2021 15:07:20 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : subject :
 from : to : cc : date : in-reply-to : references : content-type :
 mime-version : content-transfer-encoding; s=pp1;
 bh=MuuIaY4DQlfTZ6cqt0OnJv+xUQY1Wu9vuyqv7QsCjUk=;
 b=lNgZXaylYqsM4ufjTfAIbOGzKlzW0vHXb/BOTdTl+ohfkp7itj7vg6vNNbFXx8LCT3co
 wIIcuf+kKBGMQsrYA6+v2JwE/2nUv52T279EUNdbubPphOe8E2gOT84VmD5pSGe0qIQw
 h7bJrJ6pjUMk7JgLo/IzMqQssfLbCCCeSFMfbjeGdHDyUgm0ZsGbLj4ABuDakqViCQuO
 GLbSnHdgZZpwW6OUEEjKiPM00IEmZ5B4v3DHFfwTFhwmMUjJECQGv+aQuqfzMDQJ0Psy
 FNX/lLLGYb0dey7lIWQ2qmvth27z/6XXCdW4qMwhKT1FtkT8M3BuSp0+X8YSHtIbYxDN 5g== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3842fmaprm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 23 Apr 2021 15:07:20 -0400
Received: from m0098393.ppops.net (m0098393.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 13NJ4HXS103080;
        Fri, 23 Apr 2021 15:07:20 -0400
Received: from ppma05wdc.us.ibm.com (1b.90.2fa9.ip4.static.sl-reverse.com [169.47.144.27])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3842fmapr9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 23 Apr 2021 15:07:20 -0400
Received: from pps.filterd (ppma05wdc.us.ibm.com [127.0.0.1])
        by ppma05wdc.us.ibm.com (8.16.0.43/8.16.0.43) with SMTP id 13NJ727L015794;
        Fri, 23 Apr 2021 19:07:19 GMT
Received: from b01cxnp22035.gho.pok.ibm.com (b01cxnp22035.gho.pok.ibm.com [9.57.198.25])
        by ppma05wdc.us.ibm.com with ESMTP id 37yqa9txa4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 23 Apr 2021 19:07:19 +0000
Received: from b01ledav002.gho.pok.ibm.com (b01ledav002.gho.pok.ibm.com [9.57.199.107])
        by b01cxnp22035.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 13NJ7Ihv37355920
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 23 Apr 2021 19:07:18 GMT
Received: from b01ledav002.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 84C96124055;
        Fri, 23 Apr 2021 19:07:18 +0000 (GMT)
Received: from b01ledav002.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id F147C124053;
        Fri, 23 Apr 2021 19:07:17 +0000 (GMT)
Received: from farman-thinkpad-t470p (unknown [9.160.17.178])
        by b01ledav002.gho.pok.ibm.com (Postfix) with ESMTP;
        Fri, 23 Apr 2021 19:07:17 +0000 (GMT)
Message-ID: <986a165f08d29110e86c044359111582332a4ccb.camel@linux.ibm.com>
Subject: Re: [RFC PATCH v4 0/4] vfio-ccw: Fix interrupt handling for
 HALT/CLEAR
From:   Eric Farman <farman@linux.ibm.com>
To:     Halil Pasic <pasic@linux.ibm.com>
Cc:     Cornelia Huck <cohuck@redhat.com>,
        Matthew Rosato <mjrosato@linux.ibm.com>,
        Jared Rossi <jrossi@linux.ibm.com>, linux-s390@vger.kernel.org,
        kvm@vger.kernel.org
Date:   Fri, 23 Apr 2021 15:07:17 -0400
In-Reply-To: <20210423190853.6b159871.pasic@linux.ibm.com>
References: <20210413182410.1396170-1-farman@linux.ibm.com>
         <20210422025258.6ed7619d.pasic@linux.ibm.com>
         <1eb9cbdfe43a42a62f6afb0315bb1e3a103dac9a.camel@linux.ibm.com>
         <20210423135015.5283edde.pasic@linux.ibm.com>
         <c23691d7e4d0456dffbbeb1cea80fe3395f92c86.camel@linux.ibm.com>
         <20210423190853.6b159871.pasic@linux.ibm.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.28.5 (3.28.5-14.el8) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: BSnHjZEVZU1lq8ZjC8uS6Zvusl0jhfm_
X-Proofpoint-ORIG-GUID: Lwu-Dhn5P1AIN38_v6_gnzXq6sq-MwiB
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.761
 definitions=2021-04-23_07:2021-04-23,2021-04-23 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 phishscore=0 mlxscore=0
 adultscore=0 malwarescore=0 suspectscore=0 impostorscore=0 mlxlogscore=974
 spamscore=0 clxscore=1015 lowpriorityscore=0 priorityscore=1501
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104060000 definitions=main-2104230123
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, 2021-04-23 at 19:08 +0200, Halil Pasic wrote:
> On Fri, 23 Apr 2021 11:53:06 -0400
> Eric Farman <farman@linux.ibm.com> wrote:
> 
> > > Is in your opinion the vfio-ccw kernel module data race free with
> > > this
> > > series applied?  
> > 
> > I have no further concerns.
> 
> I take this for a "yes, in my opinion it is data race free".

You asked about once this series is applied, which it is not.

> 
> Please explain me, how do we synchronize access to
> a) private->state
> b) cp->initialized?
> 
> Asuming we both use the definition from the C standard, the multiple
> threads potentially concurrently accessing private->state or
> cp->initialized are not hard to find.
> 

Correct. The examples you provide below are the subject of patch 2,
which has already been identified as having issues and will be
reworked.

Thanks,
Eric

> For the former you can take vfio_ccw_sch_io_todo() (has both a read
> and a write, and runs from the workqueue) and fsm_io_request() (has
> both read and write). I guess the accesses from fsm_io_request() are
> all with the io_mutex held, but the accesses form
> vfio_ccw_sch_io_todo()
> are not with the io_mutex held AFAICT.
> 
> And the same is true for the latter with the difference that 
> vfio_ccw_sch_io_todo() manipulates cp->initialized via
> cp_update_scsw()
> and cp_free().
> 
> These are either data races, or I'm missing something. Let me also
> note that C programs data races are bad news, because of undefined
> behavior.
> 
> Regards,
> Halil
> 
> 

