Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5BDB34787F1
	for <lists+kvm@lfdr.de>; Fri, 17 Dec 2021 10:41:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234494AbhLQJlV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 17 Dec 2021 04:41:21 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:57944 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233456AbhLQJlU (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 17 Dec 2021 04:41:20 -0500
Received: from pps.filterd (m0098409.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 1BH9NUV8018689;
        Fri, 17 Dec 2021 09:41:20 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : subject :
 from : to : cc : date : in-reply-to : references : content-type :
 mime-version : content-transfer-encoding; s=pp1;
 bh=1V2h6CdA68+Ix1SJbVML7WtOGTNAplQbD008lyEOFzY=;
 b=a+VvS0pyzA1RcAn22LrWw5He6Pz7wV6AnICiv/0lGd5AtPIJla0XR6+B6T7NwJjtuoEH
 0mZF/m/itZvIs431ZPsJJoDKBQsCN+s+1CiJb2eMfDmDH/iRsbYU47DmoC9cOjrAj+zE
 BTtSYrRQMXCC9m4rmGcfRKRbP2O8zL+Hp5muvcAz4J9d6pdiQHvccWGRGryXglil4AZB
 TR84/HD1rh0r/P8gWDB4hdjuEQKeH0aMFDsO+GLM1pKOuZGYbiqMYdpKE3t1Q8lXcRWl
 hW0sAbisbP2VKG5A7EtEEcZnaIN+KsbTwC5fNiWpbnEl3rvNxGXcEeNB6eKBPQdvlb/8 GA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3cyn1km27v-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 17 Dec 2021 09:41:20 +0000
Received: from m0098409.ppops.net (m0098409.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 1BH9RbFZ001842;
        Fri, 17 Dec 2021 09:41:19 GMT
Received: from ppma04ams.nl.ibm.com (63.31.33a9.ip4.static.sl-reverse.com [169.51.49.99])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3cyn1km26s-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 17 Dec 2021 09:41:19 +0000
Received: from pps.filterd (ppma04ams.nl.ibm.com [127.0.0.1])
        by ppma04ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 1BH9Xlvs013143;
        Fri, 17 Dec 2021 09:41:17 GMT
Received: from b06avi18878370.portsmouth.uk.ibm.com (b06avi18878370.portsmouth.uk.ibm.com [9.149.26.194])
        by ppma04ams.nl.ibm.com with ESMTP id 3cy7qwfqka-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 17 Dec 2021 09:41:16 +0000
Received: from d06av23.portsmouth.uk.ibm.com (d06av23.portsmouth.uk.ibm.com [9.149.105.59])
        by b06avi18878370.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 1BH9fDdg30867958
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 17 Dec 2021 09:41:13 GMT
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id B9397A4051;
        Fri, 17 Dec 2021 09:41:13 +0000 (GMT)
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 83BF4A4055;
        Fri, 17 Dec 2021 09:41:12 +0000 (GMT)
Received: from sig-9-145-149-59.de.ibm.com (unknown [9.145.149.59])
        by d06av23.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Fri, 17 Dec 2021 09:41:12 +0000 (GMT)
Message-ID: <e2525cc5e236852f23bfc22c49e150edf67d8e10.camel@linux.ibm.com>
Subject: Re: [PATCH 23/32] KVM: s390: pci: handle refresh of PCI translations
From:   Niklas Schnelle <schnelle@linux.ibm.com>
To:     Matthew Rosato <mjrosato@linux.ibm.com>,
        Pierre Morel <pmorel@linux.ibm.com>, linux-s390@vger.kernel.org
Cc:     alex.williamson@redhat.com, cohuck@redhat.com,
        farman@linux.ibm.com, borntraeger@linux.ibm.com, hca@linux.ibm.com,
        gor@linux.ibm.com, gerald.schaefer@linux.ibm.com,
        agordeev@linux.ibm.com, frankja@linux.ibm.com, david@redhat.com,
        imbrenda@linux.ibm.com, vneethv@linux.ibm.com,
        oberpar@linux.ibm.com, freude@linux.ibm.com, thuth@redhat.com,
        pasic@linux.ibm.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date:   Fri, 17 Dec 2021 10:41:12 +0100
In-Reply-To: <ee217f34-539f-2759-e4ac-5098e3923555@linux.ibm.com>
References: <20211207205743.150299-1-mjrosato@linux.ibm.com>
         <20211207205743.150299-24-mjrosato@linux.ibm.com>
         <d2af697e-bf48-e78b-eed6-766f0790232f@linux.ibm.com>
         <a963388d-b13e-07c5-c256-c91671b3aa73@linux.ibm.com>
         <9a953a7938218afed246e93995d22ee7d09a81f3.camel@linux.ibm.com>
         <ee217f34-539f-2759-e4ac-5098e3923555@linux.ibm.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.28.5 (3.28.5-18.el8) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: Vy7a1gi6tcHhcK5s5bCt3BykxBTP31cs
X-Proofpoint-GUID: Q5vGsOesOpy4B_D25kFuoR89pQGrXlT6
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2021-12-17_03,2021-12-16_01,2021-12-02_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 phishscore=0 mlxlogscore=999
 lowpriorityscore=0 priorityscore=1501 impostorscore=0 suspectscore=0
 clxscore=1015 malwarescore=0 spamscore=0 mlxscore=0 adultscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2110150000 definitions=main-2112170054
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, 2021-12-16 at 09:51 -0500, Matthew Rosato wrote:
> On 12/16/21 9:39 AM, Niklas Schnelle wrote:
> > On Tue, 2021-12-14 at 12:54 -0500, Matthew Rosato wrote:
> > > On 12/14/21 11:59 AM, Pierre Morel wrote:
> > > > On 12/7/21 21:57, Matthew Rosato wrote:
> > > > > Add a routine that will perform a shadow operation between a guest
> > > > > and host IOAT.  A subsequent patch will invoke this in response to
> > > > > an 04 RPCIT instruction intercept.
> > > > > 
> > > > > Signed-off-by: Matthew Rosato <mjrosato@linux.ibm.com>
> > > > > ---
> > > > >    arch/s390/include/asm/kvm_pci.h |   1 +
> > > > >    arch/s390/include/asm/pci_dma.h |   1 +
> > > > >    arch/s390/kvm/pci.c             | 191 ++++++++++++++++++++++++++++++++
> > > > >    arch/s390/kvm/pci.h             |   4 +-
> > > > >    4 files changed, 196 insertions(+), 1 deletion(-)
> > > > > 
> > ---8<---
> > > > > +
> > > > > +int kvm_s390_pci_refresh_trans(struct kvm_vcpu *vcpu, unsigned long req,
> > > > > +                   unsigned long start, unsigned long size)
> > > > > +{
> > > > > +    struct zpci_dev *zdev;
> > > > > +    u32 fh;
> > > > > +    int rc;
> > > > > +
> > > > > +    /* If the device has a SHM bit on, let userspace take care of
> > > > > this */
> > > > > +    fh = req >> 32;
> > > > > +    if ((fh & aift.mdd) != 0)
> > > > > +        return -EOPNOTSUPP;
> > > > 
> > > > I think you should make this check in the caller.
> > > 
> > > OK
> > > 
> > > > > +
> > > > > +    /* Make sure this is a valid device associated with this guest */
> > > > > +    zdev = get_zdev_by_fh(fh);
> > > > > +    if (!zdev || !zdev->kzdev || zdev->kzdev->kvm != vcpu->kvm)
> > > > > +        return -EINVAL;
> > > > > +
> > > > > +    /* Only proceed if the device is using the assist */
> > > > > +    if (zdev->kzdev->ioat.head[0] == 0)
> > > > > +        return -EOPNOTSUPP;
> > > > 
> > > > Using the assist means using interpretation over using interception and
> > > > legacy vfio-pci. right?
> > > 
> > > Right - more specifically that the IOAT assist feature was never set via
> > > the vfio feature ioctl, so we can't handle the RPCIT for this device and
> > > so throw to userspace.
> > > 
> > > The way the QEMU series is being implemented, a device using
> > > interpretation will always have the IOAT feature set on.
> > > 
> > > > > +
> > > > > +    rc = dma_table_shadow(vcpu, zdev, start, size);
> > > > > +    if (rc > 0)
> > > > > +        rc = zpci_refresh_trans((u64) zdev->fh << 32, start, size);
> > > > 
> > > > Here you lose the status reported by the hardware.
> > > > You should directly use __rpcit(fn, addr, range, &status);
> > > 
> > > OK, I can have a look at doing this.
> > > 
> > > @Niklas thoughts on how you would want this exported.  Renamed to
> > > zpci_rpcit or so?
> > 
> > Hmm with using __rpcit() directly we would lose the error reporting in
> > s390dbf and this ist still kind of a RPCIT in the host. How about we
> > add the status as an out parameter to zpci_refresh_trans()? But yes if
> 
> Another advantage of doing this would be that we then also keep the cc2 
> retry logic in zpci_refresh_trans(), which would be nice.

Yeah thought about that too. If we don't have that I believe the guest
would retry but that means doing two full intercepts and going through
all the other logic too. Since these retries are afaik extremely rare
it shouldn't matter much but on the other hand I would expect them to
only happen when the system is overloaded and then doing all this extra
work surely isn't helpful.

> 
> However we do still lose the returned CC value from the instruction. 
> But I think we can infer a CC1 from a nonzero status and a CC3 from a 
> zero status so maybe this is OK too.

I agree.


