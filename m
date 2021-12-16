Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 924384774CB
	for <lists+kvm@lfdr.de>; Thu, 16 Dec 2021 15:39:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238086AbhLPOjq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 16 Dec 2021 09:39:46 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:17400 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S238072AbhLPOjp (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 16 Dec 2021 09:39:45 -0500
Received: from pps.filterd (m0098420.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 1BGE1FZ7014222;
        Thu, 16 Dec 2021 14:39:45 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : subject :
 from : to : cc : date : in-reply-to : references : content-type :
 mime-version : content-transfer-encoding; s=pp1;
 bh=s+kZ4z9SPZYEvJx1p4gc2PbRIGWj3eV70NaTPLlf3Vw=;
 b=auWhV/bu2Az9/czsWT9oKv7P5uD5gxgfAxINigUoDBn4SiGA1m4nHe3BBv9SpWXdKnCH
 7EQT2gHQJ8oVAV/A0URoIaqRsf9S62riZDdIkJitCMgqkYtehPEakiSp2QgIqw6UdXHN
 hSBeTCxCLvb+CzatO5bst7e0c02luGXG0H4bW020h4SSV1JLmS6DST6+FhsF2DsRrkDX
 HjEIlt5Nm+P0t9a7RGrGKRvpDG6aAcJr0/3nD2NGrwj2SC69pca8Z93OZgcd/ge0cL/F
 L4tlMwEFlfGR1FV43q7zEKjSA1NNl2W2IL320rITzvqmpTiROCRoPT9RwRs3x59DwMVN Jg== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3cygmwny11-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 16 Dec 2021 14:39:44 +0000
Received: from m0098420.ppops.net (m0098420.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 1BGDFO5K001982;
        Thu, 16 Dec 2021 14:39:44 GMT
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3cygmwny0h-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 16 Dec 2021 14:39:44 +0000
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
        by ppma03ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 1BGEb669027461;
        Thu, 16 Dec 2021 14:39:42 GMT
Received: from b06cxnps3075.portsmouth.uk.ibm.com (d06relay10.portsmouth.uk.ibm.com [9.149.109.195])
        by ppma03ams.nl.ibm.com with ESMTP id 3cy7jr7xmb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 16 Dec 2021 14:39:42 +0000
Received: from d06av26.portsmouth.uk.ibm.com (d06av26.portsmouth.uk.ibm.com [9.149.105.62])
        by b06cxnps3075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 1BGEddj343909562
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 16 Dec 2021 14:39:39 GMT
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id EB4BDAE058;
        Thu, 16 Dec 2021 14:39:38 +0000 (GMT)
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id BB0B2AE055;
        Thu, 16 Dec 2021 14:39:37 +0000 (GMT)
Received: from sig-9-145-91-172.uk.ibm.com (unknown [9.145.91.172])
        by d06av26.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Thu, 16 Dec 2021 14:39:37 +0000 (GMT)
Message-ID: <9a953a7938218afed246e93995d22ee7d09a81f3.camel@linux.ibm.com>
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
Date:   Thu, 16 Dec 2021 15:39:37 +0100
In-Reply-To: <a963388d-b13e-07c5-c256-c91671b3aa73@linux.ibm.com>
References: <20211207205743.150299-1-mjrosato@linux.ibm.com>
         <20211207205743.150299-24-mjrosato@linux.ibm.com>
         <d2af697e-bf48-e78b-eed6-766f0790232f@linux.ibm.com>
         <a963388d-b13e-07c5-c256-c91671b3aa73@linux.ibm.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.28.5 (3.28.5-18.el8) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: v14hu2LacGPjBKSVq1O-LbVCO2rSRKIT
X-Proofpoint-ORIG-GUID: nq6d8D3ySq01nG3eejosq1Sb93vew-fK
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2021-12-16_05,2021-12-16_01,2021-12-02_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 spamscore=0 phishscore=0 clxscore=1015 lowpriorityscore=0 malwarescore=0
 mlxlogscore=999 mlxscore=0 impostorscore=0 adultscore=0 bulkscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2110150000 definitions=main-2112160081
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 2021-12-14 at 12:54 -0500, Matthew Rosato wrote:
> On 12/14/21 11:59 AM, Pierre Morel wrote:
> > 
> > On 12/7/21 21:57, Matthew Rosato wrote:
> > > Add a routine that will perform a shadow operation between a guest
> > > and host IOAT.  A subsequent patch will invoke this in response to
> > > an 04 RPCIT instruction intercept.
> > > 
> > > Signed-off-by: Matthew Rosato <mjrosato@linux.ibm.com>
> > > ---
> > >   arch/s390/include/asm/kvm_pci.h |   1 +
> > >   arch/s390/include/asm/pci_dma.h |   1 +
> > >   arch/s390/kvm/pci.c             | 191 ++++++++++++++++++++++++++++++++
> > >   arch/s390/kvm/pci.h             |   4 +-
> > >   4 files changed, 196 insertions(+), 1 deletion(-)
> > > 
---8<---
> > 
> > > +
> > > +int kvm_s390_pci_refresh_trans(struct kvm_vcpu *vcpu, unsigned long req,
> > > +                   unsigned long start, unsigned long size)
> > > +{
> > > +    struct zpci_dev *zdev;
> > > +    u32 fh;
> > > +    int rc;
> > > +
> > > +    /* If the device has a SHM bit on, let userspace take care of 
> > > this */
> > > +    fh = req >> 32;
> > > +    if ((fh & aift.mdd) != 0)
> > > +        return -EOPNOTSUPP;
> > 
> > I think you should make this check in the caller.
> 
> OK
> 
> > > +
> > > +    /* Make sure this is a valid device associated with this guest */
> > > +    zdev = get_zdev_by_fh(fh);
> > > +    if (!zdev || !zdev->kzdev || zdev->kzdev->kvm != vcpu->kvm)
> > > +        return -EINVAL;
> > > +
> > > +    /* Only proceed if the device is using the assist */
> > > +    if (zdev->kzdev->ioat.head[0] == 0)
> > > +        return -EOPNOTSUPP;
> > 
> > Using the assist means using interpretation over using interception and 
> > legacy vfio-pci. right?
> 
> Right - more specifically that the IOAT assist feature was never set via 
> the vfio feature ioctl, so we can't handle the RPCIT for this device and 
> so throw to userspace.
> 
> The way the QEMU series is being implemented, a device using 
> interpretation will always have the IOAT feature set on.
> 
> > > +
> > > +    rc = dma_table_shadow(vcpu, zdev, start, size);
> > > +    if (rc > 0)
> > > +        rc = zpci_refresh_trans((u64) zdev->fh << 32, start, size);
> > 
> > Here you lose the status reported by the hardware.
> > You should directly use __rpcit(fn, addr, range, &status);
> 
> OK, I can have a look at doing this.
> 
> @Niklas thoughts on how you would want this exported.  Renamed to 
> zpci_rpcit or so?

Hmm with using __rpcit() directly we would lose the error reporting in
s390dbf and this ist still kind of a RPCIT in the host. How about we
add the status as an out parameter to zpci_refresh_trans()? But yes if
you prefer to use __rpcit() directly I would rename it to zpci_rpcit().

> 

---8<---

