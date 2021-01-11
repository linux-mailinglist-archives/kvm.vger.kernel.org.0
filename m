Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8A29A2F2040
	for <lists+kvm@lfdr.de>; Mon, 11 Jan 2021 21:00:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404084AbhAKT7o (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 11 Jan 2021 14:59:44 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:21696 "EHLO
        mx0b-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1731772AbhAKT7m (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 11 Jan 2021 14:59:42 -0500
Received: from pps.filterd (m0127361.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 10BJgskZ196225;
        Mon, 11 Jan 2021 14:58:45 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 message-id : reply-to : references : mime-version : content-type :
 in-reply-to : subject; s=pp1;
 bh=HlnbdNAo/94mEI3tW5H4udb4sNucEjNi1gf15FFs+2g=;
 b=WOtrlOc2dHAfPVKG8WVaHzwIXAhGWs9l+IRZw9edGTWr5UKnBx6L7JXGUFbHapsskZss
 tR2l6eRZkh3Vi/rZZZfMypAc4NlyVQL4HtmJiBS+xjgAzCXNqPQE7qXHzH4qeWLTaELy
 82lpx0/kkutbP5YTfMbVO9s2Mn4ypsK8woa4ql+rMrQruOJ4mILZqzAGh+WsZS6IRwYx
 JqjPZHJV/Mvg6a/2pYhGeStDnKxsYpm9eOEjm6BcVj6mBzJ4eqBQLwaKDwCSobnF0K/A
 3aargxd8gv6rl8C6scmVFL+11vaPAVmDGoF6OnJWsWcSOMfyDe7t3Y9oJvV7CRshSrTu UA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 360w2sgaqx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 11 Jan 2021 14:58:44 -0500
Received: from m0127361.ppops.net (m0127361.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 10BJhLWa000880;
        Mon, 11 Jan 2021 14:58:44 -0500
Received: from ppma05fra.de.ibm.com (6c.4a.5195.ip4.static.sl-reverse.com [149.81.74.108])
        by mx0a-001b2d01.pphosted.com with ESMTP id 360w2sgaqd-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 11 Jan 2021 14:58:44 -0500
Received: from pps.filterd (ppma05fra.de.ibm.com [127.0.0.1])
        by ppma05fra.de.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 10BJwg2x025212;
        Mon, 11 Jan 2021 19:58:42 GMT
Received: from b06cxnps3075.portsmouth.uk.ibm.com (d06relay10.portsmouth.uk.ibm.com [9.149.109.195])
        by ppma05fra.de.ibm.com with ESMTP id 35y4489br1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 11 Jan 2021 19:58:42 +0000
Received: from d06av26.portsmouth.uk.ibm.com (d06av26.portsmouth.uk.ibm.com [9.149.105.62])
        by b06cxnps3075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 10BJwd8x43319708
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 11 Jan 2021 19:58:39 GMT
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 1D668AE053;
        Mon, 11 Jan 2021 19:58:39 +0000 (GMT)
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 5D80EAE051;
        Mon, 11 Jan 2021 19:58:33 +0000 (GMT)
Received: from ram-ibm-com.ibm.com (unknown [9.163.29.145])
        by d06av26.portsmouth.uk.ibm.com (Postfix) with ESMTPS;
        Mon, 11 Jan 2021 19:58:33 +0000 (GMT)
Date:   Mon, 11 Jan 2021 11:58:30 -0800
From:   Ram Pai <linuxram@us.ibm.com>
To:     Cornelia Huck <cohuck@redhat.com>
Cc:     Halil Pasic <pasic@linux.ibm.com>, Greg Kurz <groug@kaod.org>,
        pair@us.ibm.com, brijesh.singh@amd.com, kvm@vger.kernel.org,
        "Michael S. Tsirkin" <mst@redhat.com>, qemu-devel@nongnu.org,
        frankja@linux.ibm.com, david@redhat.com, mdroth@linux.vnet.ibm.com,
        borntraeger@de.ibm.com, David Gibson <david@gibson.dropbear.id.au>,
        thuth@redhat.com, Eduardo Habkost <ehabkost@redhat.com>,
        Richard Henderson <richard.henderson@linaro.org>,
        dgilbert@redhat.com, qemu-s390x@nongnu.org, rth@twiddle.net,
        berrange@redhat.com, Marcelo Tosatti <mtosatti@redhat.com>,
        qemu-ppc@nongnu.org, pbonzini@redhat.com
Message-ID: <20210111195830.GA23898@ram-ibm-com.ibm.com>
Reply-To: Ram Pai <linuxram@us.ibm.com>
References: <20201217054736.GH310465@yekko.fritz.box>
 <20201217123842.51063918.cohuck@redhat.com>
 <20201217151530.54431f0e@bahia.lan>
 <20201218124111.4957eb50.cohuck@redhat.com>
 <20210104071550.GA22585@ram-ibm-com.ibm.com>
 <20210104134629.49997b53.pasic@linux.ibm.com>
 <20210104184026.GD4102@ram-ibm-com.ibm.com>
 <20210105115614.7daaadd6.pasic@linux.ibm.com>
 <20210105204125.GE4102@ram-ibm-com.ibm.com>
 <20210111175914.13adfa2e.cohuck@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210111175914.13adfa2e.cohuck@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-GCONF: 00
Subject: RE: [for-6.0 v5 11/13] spapr: PEF: prevent migration
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.343,18.0.737
 definitions=2021-01-11_30:2021-01-11,2021-01-11 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 bulkscore=0 mlxlogscore=999
 impostorscore=0 malwarescore=0 adultscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 suspectscore=0 priorityscore=1501
 spamscore=0 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2101110105
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Jan 11, 2021 at 05:59:14PM +0100, Cornelia Huck wrote:
> On Tue, 5 Jan 2021 12:41:25 -0800
> Ram Pai <linuxram@us.ibm.com> wrote:
> 
> > On Tue, Jan 05, 2021 at 11:56:14AM +0100, Halil Pasic wrote:
> > > On Mon, 4 Jan 2021 10:40:26 -0800
> > > Ram Pai <linuxram@us.ibm.com> wrote:
> 
> > > > The main difference between my proposal and the other proposal is...
> > > > 
> > > >   In my proposal the guest makes the compatibility decision and acts
> > > >   accordingly.  In the other proposal QEMU makes the compatibility
> > > >   decision and acts accordingly. I argue that QEMU cannot make a good
> > > >   compatibility decision, because it wont know in advance, if the guest
> > > >   will or will-not switch-to-secure.
> > > >   
> > > 
> > > You have a point there when you say that QEMU does not know in advance,
> > > if the guest will or will-not switch-to-secure. I made that argument
> > > regarding VIRTIO_F_ACCESS_PLATFORM (iommu_platform) myself. My idea
> > > was to flip that property on demand when the conversion occurs. David
> > > explained to me that this is not possible for ppc, and that having the
> > > "securable-guest-memory" property (or whatever the name will be)
> > > specified is a strong indication, that the VM is intended to be used as
> > > a secure VM (thus it is OK to hurt the case where the guest does not
> > > try to transition). That argument applies here as well.  
> > 
> > As suggested by Cornelia Huck, what if QEMU disabled the
> > "securable-guest-memory" property if 'must-support-migrate' is enabled?
> > Offcourse; this has to be done with a big fat warning stating
> > "secure-guest-memory" feature is disabled on the machine.
> > Doing so, will continue to support guest that do not try to transition.
> > Guest that try to transition will fail and terminate themselves.
> 
> Just to recap the s390x situation:
> 
> - We currently offer a cpu feature that indicates secure execution to
>   be available to the guest if the host supports it.
> - When we introduce the secure object, we still need to support
>   previous configurations and continue to offer the cpu feature, even
>   if the secure object is not specified.
> - As migration is currently not supported for secured guests, we add a
>   blocker once the guest actually transitions. That means that
>   transition fails if --only-migratable was specified on the command
>   line. (Guests not transitioning will obviously not notice anything.)
> - With the secure object, we will already fail starting QEMU if
>   --only-migratable was specified.
> 
> My suggestion is now that we don't even offer the cpu feature if
> --only-migratable has been specified. For a guest that does not want to
> transition to secure mode, nothing changes; a guest that wants to
> transition to secure mode will notice that the feature is not available
> and fail appropriately (or ultimately, when the ultravisor call fails).


On POWER, secure-execution is not **automatically** enabled even when
the host supports it.  The feature is enabled only if the secure-object
is configured, and the host supports it.

However the behavior proposed above will be consistent on POWER and
on s390x,  when '--only-migratable' is specified and 'secure-object'
is NOT specified.

So I am in agreement till now. 


> We'd still fail starting QEMU for the secure object + --only-migratable
> combination.

Why fail? 

Instead, print a warning and  disable the secure-object; which will
disable your cpu-feature. Guests that do not transition to secure, will
continue to operate, and guests that transition to secure, will fail.

RP
