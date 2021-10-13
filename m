Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1EABE42C1CE
	for <lists+kvm@lfdr.de>; Wed, 13 Oct 2021 15:54:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233241AbhJMN4X (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 13 Oct 2021 09:56:23 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:28380 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229611AbhJMN4W (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 13 Oct 2021 09:56:22 -0400
Received: from pps.filterd (m0098396.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 19DCqNHS021869;
        Wed, 13 Oct 2021 09:54:18 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : subject :
 from : to : cc : date : in-reply-to : references : content-type :
 mime-version : content-transfer-encoding; s=pp1;
 bh=xefFNKbYo1VWj3k5fBMZrLG2hOezTFbJhLRUFRuTxq0=;
 b=QZmkMBbyrMRc7prNGRczBEWHl0huOV4XqTgxvjv1vptFv5djt+c8CFMk6a2+MByFepGi
 m+QBGsMUOX1YKaxizk+EE3gRzV2sl1jiN4c6vyPn5PLOWPQmw6Wqw9z1V6R5gvVJ+Py3
 4hL1A/DTYPtDnDOc9iAVNW+wmx4dAyX1T3cHmjcUlFNU2+ZM+cCPrerE29VsYRU+2os3
 jDQeCCI4nyocBFNg79hjvqUXxzuk1vO+XOHzsQRaKympUWN3yQXW0UjAK6GjveMSQ00t
 vJOZ88xNu4DE2PcJX6szuHVTRylSF7vb91Qsb3+Jphdu1BeCLyaxHAZRfmpPqQwKOOWk lg== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3bnr79kmje-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 13 Oct 2021 09:54:18 -0400
Received: from m0098396.ppops.net (m0098396.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 19DDgnFk031969;
        Wed, 13 Oct 2021 09:54:18 -0400
Received: from ppma05wdc.us.ibm.com (1b.90.2fa9.ip4.static.sl-reverse.com [169.47.144.27])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3bnr79kmhx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 13 Oct 2021 09:54:18 -0400
Received: from pps.filterd (ppma05wdc.us.ibm.com [127.0.0.1])
        by ppma05wdc.us.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 19DDlUWC027964;
        Wed, 13 Oct 2021 13:54:17 GMT
Received: from b03cxnp08027.gho.boulder.ibm.com (b03cxnp08027.gho.boulder.ibm.com [9.17.130.19])
        by ppma05wdc.us.ibm.com with ESMTP id 3bk2qbsb7y-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 13 Oct 2021 13:54:16 +0000
Received: from b03ledav004.gho.boulder.ibm.com (b03ledav004.gho.boulder.ibm.com [9.17.130.235])
        by b03cxnp08027.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 19DDsFSj12583410
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 13 Oct 2021 13:54:15 GMT
Received: from b03ledav004.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 6802E78067;
        Wed, 13 Oct 2021 13:54:15 +0000 (GMT)
Received: from b03ledav004.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 5661F78070;
        Wed, 13 Oct 2021 13:54:14 +0000 (GMT)
Received: from farman-thinkpad-t470p (unknown [9.211.134.52])
        by b03ledav004.gho.boulder.ibm.com (Postfix) with ESMTP;
        Wed, 13 Oct 2021 13:54:14 +0000 (GMT)
Message-ID: <3daa6f7de62fa9dd7a8fc781eabbde002e4729f5.camel@linux.ibm.com>
Subject: Re: [RFC PATCH v1 3/6] KVM: s390: Simplify SIGP Restart
From:   Eric Farman <farman@linux.ibm.com>
To:     Thomas Huth <thuth@redhat.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        David Hildenbrand <david@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        Heiko Carstens <hca@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Jason Herne <jjherne@linux.ibm.com>
Cc:     kvm@vger.kernel.org, linux-s390@vger.kernel.org
Date:   Wed, 13 Oct 2021 09:54:13 -0400
In-Reply-To: <d30c2f8b-73f1-5639-dbb4-2e70b5982c62@redhat.com>
References: <20211008203112.1979843-1-farman@linux.ibm.com>
         <20211008203112.1979843-4-farman@linux.ibm.com>
         <e3b874c1-e220-5e23-bd67-ed08c261e425@de.ibm.com>
         <518fea79-1579-ee4a-c09b-ae4e70e32d96@redhat.com>
         <0e4bb561170a287cea4124e9da56dfc4bd4a0eab.camel@linux.ibm.com>
         <d30c2f8b-73f1-5639-dbb4-2e70b5982c62@redhat.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.28.5 (3.28.5-16.el8) 
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: h5kbbUUaj_cI-uiIAsVsBuOdTuGrck9Z
X-Proofpoint-ORIG-GUID: AzcyiCvWOB23ZqcwddIGhmSMCjJsJAvW
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.182.1,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.0.607.475
 definitions=2021-10-13_05,2021-10-13_02,2020-04-07_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1015
 lowpriorityscore=0 mlxlogscore=999 malwarescore=0 adultscore=0
 suspectscore=0 bulkscore=0 spamscore=0 phishscore=0 mlxscore=0
 priorityscore=1501 impostorscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2109230001 definitions=main-2110130092
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, 2021-10-13 at 07:54 +0200, Thomas Huth wrote:
> On 12/10/2021 17.31, Eric Farman wrote:
> > On Tue, 2021-10-12 at 17:23 +0200, Thomas Huth wrote:
> > > On 11/10/2021 09.45, Christian Borntraeger wrote:
> > > > Am 08.10.21 um 22:31 schrieb Eric Farman:
> > > > > Now that we check for the STOP IRQ injection at the top of
> > > > > the
> > > > > SIGP
> > > > > handler (before the userspace/kernelspace check), we don't
> > > > > need
> > > > > to do
> > > > > it down here for the Restart order.
> > > > > 
> > > > > Signed-off-by: Eric Farman <farman@linux.ibm.com>
> > > > > ---
> > > > >    arch/s390/kvm/sigp.c | 11 +----------
> > > > >    1 file changed, 1 insertion(+), 10 deletions(-)
> > > > > 
> > > > > diff --git a/arch/s390/kvm/sigp.c b/arch/s390/kvm/sigp.c
> > > > > index 6ca01bbc72cf..0c08927ca7c9 100644
> > > > > --- a/arch/s390/kvm/sigp.c
> > > > > +++ b/arch/s390/kvm/sigp.c
> > > > > @@ -240,17 +240,8 @@ static int __sigp_sense_running(struct
> > > > > kvm_vcpu *vcpu,
> > > > >    static int __prepare_sigp_re_start(struct kvm_vcpu *vcpu,
> > > > >                       struct kvm_vcpu *dst_vcpu, u8
> > > > > order_code)
> > > > >    {
> > > > > -    struct kvm_s390_local_interrupt *li = &dst_vcpu-
> > > > > > arch.local_int;
> > > > >        /* handle (RE)START in user space */
> > > > > -    int rc = -EOPNOTSUPP;
> > > > > -
> > > > > -    /* make sure we don't race with STOP irq injection */
> > > > > -    spin_lock(&li->lock);
> > > > > -    if (kvm_s390_is_stop_irq_pending(dst_vcpu))
> > > > > -        rc = SIGP_CC_BUSY;
> > > > > -    spin_unlock(&li->lock);
> > > > > -
> > > > > -    return rc;
> > > > > +    return -EOPNOTSUPP;
> > > > >    }
> > > > >    static int __prepare_sigp_cpu_reset(struct kvm_vcpu *vcpu,
> > > > > 
> > > > 
> > > > @thuth?
> > > > Question is, does it make sense to merge patch 2 and 3 to make
> > > > things more
> > > > obvious?
> > > 
> > > Maybe.
> > > 
> > > Anyway: Would it make sense to remove __prepare_sigp_re_start()
> > > completely
> > > now and let __prepare_sigp_unknown() set the return code in the
> > > "default:" case?
> > 
> > We could, but that would affect the SIGP START case which also uses
> > the
> > re_start routine. And if we're going down that path, we could
> > remove
> > (INITIAL) CPU RESET handled in __prepare_sigp_cpu_reset, which does
> > the
> > same thing (nothing). Not sure it buys us much, other than losing
> > the
> > details in the different counters of which SIGP orders are
> > processed.
> 
> Ok, we likely shouldn't change the way of counting the SIGPs here...
> So what about removing the almost empty function and simply do the
> "rc = 
> -EOPNOTSUPP" right in the handle_sigp_dst() function? That's still
> the 
> easiest way to read the code, I think. 

Hrm, that might be better. I've almost got the IOCTL stuff in a
reasonable place for a discussion, will see about such cleanups at the
end of that (new) series.

> And we should do the same with the 
> __prepare_sigp_cpu_reset() function (in a separate patch). Just my
> 0.02 € of 
> course.

I appreciate it. Though I still don't have an easy way to use the €
coins I have in a drawer over here. ;-)

Eric

> 
>   Thomas
> 

