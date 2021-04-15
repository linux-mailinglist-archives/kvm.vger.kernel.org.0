Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7C6D3361242
	for <lists+kvm@lfdr.de>; Thu, 15 Apr 2021 20:42:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234379AbhDOSmt (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 15 Apr 2021 14:42:49 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:44424 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233052AbhDOSms (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 15 Apr 2021 14:42:48 -0400
Received: from pps.filterd (m0098399.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 13FIWbx2057391;
        Thu, 15 Apr 2021 14:42:25 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : subject :
 from : to : cc : date : in-reply-to : references : content-type :
 mime-version : content-transfer-encoding; s=pp1;
 bh=wZj39AaQqH16vsdDKTgYtC7UiooubuHarcaE7CYM+a4=;
 b=HR5lrTFCkRAhCoYxBYeiyg8zfISlUHT6n23Ur2L3p8F0VoRtuVkZtgjaRVwZHChHpSWi
 4T0SwnIIKRdAqsPqx1eXReqJmk0bKrj5lUTRgHmMEAdh+OyevwDrBdCP9Zrp9RCwPomN
 wgoCB2NP9TfKTpm4ehRGBmFRpdIWnUfZZQKSBDSBns3gLQcLn92q26DY+meD1qf8a3E9
 rVQGQQLN8K2KJTKD1bEO47NI3miNbzvdOE5hufBKdlONVXRdOdtuVzkpiQNRBY5SBfvJ
 maKs/AmXLiOluk5MbTa50H+uwJy1xzXFyaPMiaOFDcAHrj5oHV/qCLf8MhnOiyBpYKn3 Tw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 37x5apub64-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 15 Apr 2021 14:42:25 -0400
Received: from m0098399.ppops.net (m0098399.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 13FIXRDw059685;
        Thu, 15 Apr 2021 14:42:24 -0400
Received: from ppma02dal.us.ibm.com (a.bd.3ea9.ip4.static.sl-reverse.com [169.62.189.10])
        by mx0a-001b2d01.pphosted.com with ESMTP id 37x5apub5r-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 15 Apr 2021 14:42:24 -0400
Received: from pps.filterd (ppma02dal.us.ibm.com [127.0.0.1])
        by ppma02dal.us.ibm.com (8.16.0.43/8.16.0.43) with SMTP id 13FIWNVj029740;
        Thu, 15 Apr 2021 18:42:23 GMT
Received: from b01cxnp23032.gho.pok.ibm.com (b01cxnp23032.gho.pok.ibm.com [9.57.198.27])
        by ppma02dal.us.ibm.com with ESMTP id 37u3naedx3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 15 Apr 2021 18:42:23 +0000
Received: from b01ledav002.gho.pok.ibm.com (b01ledav002.gho.pok.ibm.com [9.57.199.107])
        by b01cxnp23032.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 13FIgNpK31523136
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 15 Apr 2021 18:42:23 GMT
Received: from b01ledav002.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 0BB3F124054;
        Thu, 15 Apr 2021 18:42:23 +0000 (GMT)
Received: from b01ledav002.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 79896124058;
        Thu, 15 Apr 2021 18:42:22 +0000 (GMT)
Received: from farman-thinkpad-t470p (unknown [9.160.103.97])
        by b01ledav002.gho.pok.ibm.com (Postfix) with ESMTP;
        Thu, 15 Apr 2021 18:42:22 +0000 (GMT)
Message-ID: <577e873506ef60dd988653b8b28898e306e7493f.camel@linux.ibm.com>
Subject: Re: [RFC PATCH v4 2/4] vfio-ccw: Check workqueue before doing START
From:   Eric Farman <farman@linux.ibm.com>
To:     Cornelia Huck <cohuck@redhat.com>
Cc:     Halil Pasic <pasic@linux.ibm.com>,
        Matthew Rosato <mjrosato@linux.ibm.com>,
        Jared Rossi <jrossi@linux.ibm.com>, linux-s390@vger.kernel.org,
        kvm@vger.kernel.org
Date:   Thu, 15 Apr 2021 14:42:21 -0400
In-Reply-To: <20210415181951.2f13fdcc.cohuck@redhat.com>
References: <20210413182410.1396170-1-farman@linux.ibm.com>
         <20210413182410.1396170-3-farman@linux.ibm.com>
         <20210415125131.33065221.cohuck@redhat.com>
         <ac08eb1143b5d354b8bcaf9117178fbd91bc2af2.camel@linux.ibm.com>
         <20210415181951.2f13fdcc.cohuck@redhat.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.28.5 (3.28.5-14.el8) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: RCUQAeS6o9hmVFm_uNrJEQzrhKOzGwmH
X-Proofpoint-ORIG-GUID: uQlTVsdhy9TlhRp81kBhvDvOI1StAZ9m
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.761
 definitions=2021-04-15_09:2021-04-15,2021-04-15 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 spamscore=0 malwarescore=0
 priorityscore=1501 adultscore=0 suspectscore=0 mlxlogscore=999
 impostorscore=0 lowpriorityscore=0 phishscore=0 bulkscore=0 clxscore=1015
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104060000 definitions=main-2104150115
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, 2021-04-15 at 18:19 +0200, Cornelia Huck wrote:
> On Thu, 15 Apr 2021 09:48:37 -0400
> Eric Farman <farman@linux.ibm.com> wrote:
> 
> > On Thu, 2021-04-15 at 12:51 +0200, Cornelia Huck wrote:
> > > I'm wondering what we should do for hsch. We probably want to
> > > return
> > > -EBUSY for a pending condition as well, if I read the PoP
> > > correctly...  
> > 
> > Ah, yes...  I agree that to maintain parity with ssch and pops, the
> > same cc1/-EBUSY would be applicable here. Will make that change in
> > next
> > version.
> 
> Yes, just to handle things in the same fashion consistently.
> 
> > > the only problem is that QEMU seems to match everything to 0; but
> > > that
> > > is arguably not the kernel's problem.
> > > 
> > > For clear, we obviously don't have busy conditions. Should we
> > > clean
> > > up
> > > any pending conditions?  
> > 
> > By doing anything other than issuing the csch to the subchannel?  I
> > don't think so, that should be more than enough to get the css and
> > vfio-ccw in sync with each other.
> 
> Hm, doesn't a successful csch clear any status pending? 

Yep.

> That would mean
> that invoking our csch backend implies that we won't deliver the
> status
> pending that is already pending via the workqueue, which therefore
> needs to be flushed out in some way? 

Ah, so I misunderstood the direction you were going... I'm not aware of
a way to "purge" items from a workqueue, as the flush_workqueue()
routine is documented as picking them off and running them.

Perhaps an atomic flag in (private? cp?) that causes
vfio_ccw_sch_io_todo() to just exit rather than doing all its stuff?

> I remember we did some special
> csch handling, but I don't immediately see where; might have been
> only
> in QEMU.
> 

Maybe.  I don't see anything jumping out at me though. :(


