Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BD21F4E443B
	for <lists+kvm@lfdr.de>; Tue, 22 Mar 2022 17:31:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236527AbiCVQdW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 22 Mar 2022 12:33:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51930 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234303AbiCVQdT (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 22 Mar 2022 12:33:19 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 52ECA88B3A
        for <kvm@vger.kernel.org>; Tue, 22 Mar 2022 09:31:52 -0700 (PDT)
Received: from pps.filterd (m0098396.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 22MFJUbG014128;
        Tue, 22 Mar 2022 16:31:34 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : subject :
 from : to : cc : date : in-reply-to : references : content-type :
 content-transfer-encoding : mime-version; s=pp1;
 bh=pqaLwiIon2Jss+48I6yCOVHtlKWfYvUBILSkpPQGguE=;
 b=qAdWOl1OSHi63aguCsDxKU0LDIxmlhtHBaNozTdTMSPXvk3sBpVexIu+df03E2uTmaH0
 uitTPYbXz9s7KgVIJlCS1UbwAhnGaKiygNNYCCCsL5eB/jwTl3v90MXD3F68YYliBDmH
 I4OOKlYsjEMI6wizzYK/ghpP3uzOBkrF/UITqA7EWIUldgPWU5bY8/pbqk1OnON4Y+ch
 d/tk1C2feA/Pz16t6+8LVU/iIDwUZl3saVgJpSYnSGaI4wsDOKIsxMEEGwbsLEN2vZl7
 Bcykkrfd8qKD56i13DrdqdM3kFsQYernuWZMY/lfHw6YW/fvoTGxWoWoEBa9Ad8ruNpa vw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3ey86uxd5d-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 22 Mar 2022 16:31:34 +0000
Received: from m0098396.ppops.net (m0098396.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 22MGQUZH003040;
        Tue, 22 Mar 2022 16:31:33 GMT
Received: from ppma06ams.nl.ibm.com (66.31.33a9.ip4.static.sl-reverse.com [169.51.49.102])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3ey86uxd4f-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 22 Mar 2022 16:31:33 +0000
Received: from pps.filterd (ppma06ams.nl.ibm.com [127.0.0.1])
        by ppma06ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 22MGIwXC004855;
        Tue, 22 Mar 2022 16:31:31 GMT
Received: from b06cxnps3074.portsmouth.uk.ibm.com (d06relay09.portsmouth.uk.ibm.com [9.149.109.194])
        by ppma06ams.nl.ibm.com with ESMTP id 3ew6ehxnju-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 22 Mar 2022 16:31:30 +0000
Received: from d06av23.portsmouth.uk.ibm.com (d06av23.portsmouth.uk.ibm.com [9.149.105.59])
        by b06cxnps3074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 22MGVSeO36372820
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 22 Mar 2022 16:31:28 GMT
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 34D56A4055;
        Tue, 22 Mar 2022 16:31:28 +0000 (GMT)
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id EB0D1A4051;
        Tue, 22 Mar 2022 16:31:26 +0000 (GMT)
Received: from sig-9-145-28-179.uk.ibm.com (unknown [9.145.28.179])
        by d06av23.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Tue, 22 Mar 2022 16:31:26 +0000 (GMT)
Message-ID: <974181b0c01513293909d56844aa58c09c5fa166.camel@linux.ibm.com>
Subject: Re: [PATCH RFC 04/12] kernel/user: Allow user::locked_vm to be
 usable for iommufd
From:   Niklas Schnelle <schnelle@linux.ibm.com>
To:     Jason Gunthorpe <jgg@nvidia.com>
Cc:     Alex Williamson <alex.williamson@redhat.com>,
        Lu Baolu <baolu.lu@linux.intel.com>,
        Chaitanya Kulkarni <chaitanyak@nvidia.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Daniel Jordan <daniel.m.jordan@oracle.com>,
        David Gibson <david@gibson.dropbear.id.au>,
        Eric Auger <eric.auger@redhat.com>,
        iommu@lists.linux-foundation.org, Jason Wang <jasowang@redhat.com>,
        Jean-Philippe Brucker <jean-philippe@linaro.org>,
        Joao Martins <joao.m.martins@oracle.com>,
        Kevin Tian <kevin.tian@intel.com>, kvm@vger.kernel.org,
        Matthew Rosato <mjrosato@linux.ibm.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Nicolin Chen <nicolinc@nvidia.com>,
        Shameerali Kolothum Thodi 
        <shameerali.kolothum.thodi@huawei.com>,
        Yi Liu <yi.l.liu@intel.com>, Keqian Zhu <zhukeqian1@huawei.com>
Date:   Tue, 22 Mar 2022 17:31:26 +0100
In-Reply-To: <20220322145741.GH11336@nvidia.com>
References: <4-v1-e79cd8d168e8+6-iommufd_jgg@nvidia.com>
         <808a871b3918dc067031085de3e8af6b49c6ef89.camel@linux.ibm.com>
         <20220322145741.GH11336@nvidia.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.28.5 (3.28.5-18.el8) 
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: jXYKbOHpn0JogZg9L1GrQ5ZMVbljgl-5
X-Proofpoint-ORIG-GUID: qNxWqFw6df6GqWWAKCiBfdFY3Ay7UDSK
Content-Transfer-Encoding: 7bit
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.850,Hydra:6.0.425,FMLib:17.11.64.514
 definitions=2022-03-22_07,2022-03-22_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1011 mlxlogscore=999
 impostorscore=0 bulkscore=0 adultscore=0 suspectscore=0 malwarescore=0
 priorityscore=1501 lowpriorityscore=0 mlxscore=0 spamscore=0 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2202240000
 definitions=main-2203220091
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 2022-03-22 at 11:57 -0300, Jason Gunthorpe wrote:
> On Tue, Mar 22, 2022 at 03:28:22PM +0100, Niklas Schnelle wrote:
> > On Fri, 2022-03-18 at 14:27 -0300, Jason Gunthorpe wrote:
> > > Following the pattern of io_uring, perf, skb, and bpf iommfd will use
> >                                                 iommufd ----^
> > > user->locked_vm for accounting pinned pages. Ensure the value is included
> > > in the struct and export free_uid() as iommufd is modular.
> > > 
> > > user->locked_vm is the correct accounting to use for ulimit because it is
> > > per-user, and the ulimit is not supposed to be per-process. Other
> > > places (vfio, vdpa and infiniband) have used mm->pinned_vm and/or
> > > mm->locked_vm for accounting pinned pages, but this is only per-process
> > > and inconsistent with the majority of the kernel.
> > 
> > Since this will replace parts of vfio this difference seems
> > significant. Can you explain this a bit more?
> 
> I'm not sure what to say more, this is the correct way to account for
> this. It is natural to see it is right because the ulimit is supposted
> to be global to the user, not effectively reset every time the user
> creates a new process.
> 
> So checking the ulimit against a per-process variable in the mm_struct
> doesn't make too much sense.

Yes I agree that logically this makes more sense. I was kind of aiming
in the same direction as Alex i.e. it's a conscious decision to do it
right and we need to know where this may lead to differences and how to
handle them.

> 
> > I'm also a bit confused how io_uring handles this. When I stumbled over
> > the problem fixed by 6b7898eb180d ("io_uring: fix imbalanced sqo_mm
> > accounting") and from that commit description I seem to rember that
> > io_uring also accounts in mm->locked_vm too? 
> 
> locked/pinned_pages in the mm is kind of a debugging counter, it
> indicates how many pins the user obtained through this mm. AFAICT its
> only correct use is to report through proc. Things are supposed to
> update it, but there is no reason to limit it as the user limit
> supersedes it.
> 
> The commit you pointed at is fixing that io_uring corrupted the value.
> 
> Since VFIO checks locked/pinned_pages against the ulimit would blow up
> when the value was wrong.
> 
> > In fact I stumbled over that because the wrong accounting in
> > io_uring exhausted the applied to vfio (I was using a QEMU utilizing
> > io_uring itself).
> 
> I'm pretty interested in this as well, do you have anything you can
> share?

This was the issue reported in the following BZ.

https://bugzilla.kernel.org/show_bug.cgi?id=209025

I stumbled over the same problem on my x86 box and also on s390. I
don't remember exactly what limit this ran into but I suspect it had
something to do with the libvirt resource limits Alex mentioned.
Meaning io_uring had an accounting bug and then vfio / QEMU couldn't
pin memory. I think that libvirt limit is set to allow pinning all of
guest memory plus a bit so the io_uring misaccounting easily tipped it
over.

> 
> Thanks,
> Jason


