Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EE1F22795B3
	for <lists+kvm@lfdr.de>; Sat, 26 Sep 2020 02:56:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729832AbgIZA4O (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 25 Sep 2020 20:56:14 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:43502 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729424AbgIZA4O (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 25 Sep 2020 20:56:14 -0400
Received: from pps.filterd (m0098399.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 08Q0mVtd064150;
        Fri, 25 Sep 2020 20:56:10 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=pp1;
 bh=cf6hvWkTo8OFE10cNfyaIwPYVXcBPhnJ5CUj9nT8RQc=;
 b=kOQ6XlhWk1ZuF1qotWqLiDkMwHikxjdAOQ0ypO/VckYgagA+NGXZN97Zkn+WY5O+G4ds
 RiyhAR5zrag7PsRZT/0TE9l4xna1k4f86lp6w0eJ07W8zSlBzRDFfckjvb6VlF4dO94J
 rejMCnoEdEcmCIUHQx/uWYvYCycuMXEm+s4GqUSj7M22AJ2FPd/cJc7DtmptJ7qPSuQE
 +KkibBp+acnDWTGvYh/uc6S0MmWbyCIxCWz9qjHgrEGa/D1F2wXejrkIsrI7nmhv8oRW
 pewRtHr55rGbFP4u4S3LURZC0wUlWT7iq5bI2Uht4Wws/ki9mJrlnND9TNvfkWaVB8rp sQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 33sue583hr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 25 Sep 2020 20:56:10 -0400
Received: from m0098399.ppops.net (m0098399.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 08Q0oimA068472;
        Fri, 25 Sep 2020 20:56:09 -0400
Received: from ppma06fra.de.ibm.com (48.49.7a9f.ip4.static.sl-reverse.com [159.122.73.72])
        by mx0a-001b2d01.pphosted.com with ESMTP id 33sue583ha-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 25 Sep 2020 20:56:09 -0400
Received: from pps.filterd (ppma06fra.de.ibm.com [127.0.0.1])
        by ppma06fra.de.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 08Q0mUU7030414;
        Sat, 26 Sep 2020 00:56:07 GMT
Received: from b06cxnps4074.portsmouth.uk.ibm.com (d06relay11.portsmouth.uk.ibm.com [9.149.109.196])
        by ppma06fra.de.ibm.com with ESMTP id 33n98guhwv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Sat, 26 Sep 2020 00:56:07 +0000
Received: from d06av21.portsmouth.uk.ibm.com (d06av21.portsmouth.uk.ibm.com [9.149.105.232])
        by b06cxnps4074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 08Q0u4PF23527738
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 26 Sep 2020 00:56:04 GMT
Received: from d06av21.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 343F752050;
        Sat, 26 Sep 2020 00:56:04 +0000 (GMT)
Received: from oc2783563651 (unknown [9.145.172.136])
        by d06av21.portsmouth.uk.ibm.com (Postfix) with ESMTP id AEA335204E;
        Sat, 26 Sep 2020 00:56:03 +0000 (GMT)
Date:   Sat, 26 Sep 2020 02:56:01 +0200
From:   Halil Pasic <pasic@linux.ibm.com>
To:     Tony Krowiak <akrowiak@linux.ibm.com>
Cc:     linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, pmorel@linux.ibm.com,
        alex.williamson@redhat.com, cohuck@redhat.com,
        kwankhede@nvidia.com, borntraeger@de.ibm.com
Subject: Re: [PATCH] s390/vfio-ap: fix unregister GISC when KVM is already
 gone results in OOPS
Message-ID: <20200926025601.2ad52b77.pasic@linux.ibm.com>
In-Reply-To: <3795bc75-9d5e-2098-fd18-f1cbaef9c290@linux.ibm.com>
References: <20200918170234.5807-1-akrowiak@linux.ibm.com>
        <20200921174536.49e45e68.pasic@linux.ibm.com>
        <3795bc75-9d5e-2098-fd18-f1cbaef9c290@linux.ibm.com>
Organization: IBM
X-Mailer: Claws Mail 3.11.1 (GTK+ 2.24.31; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-09-25_19:2020-09-24,2020-09-25 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 clxscore=1015
 malwarescore=0 bulkscore=0 lowpriorityscore=0 mlxlogscore=999 adultscore=0
 suspectscore=2 spamscore=0 phishscore=0 priorityscore=1501 impostorscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2009260001
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, 25 Sep 2020 18:29:16 -0400
Tony Krowiak <akrowiak@linux.ibm.com> wrote:

> 
> 
> On 9/21/20 11:45 AM, Halil Pasic wrote:
> > On Fri, 18 Sep 2020 13:02:34 -0400
> > Tony Krowiak <akrowiak@linux.ibm.com> wrote:
> >
> >> Attempting to unregister Guest Interruption Subclass (GISC) when the
> >> link between the matrix mdev and KVM has been removed results in the
> >> following:
> >>
> >>     "Kernel panic -not syncing: Fatal exception: panic_on_oops"
> >>
> >> This patch fixes this bug by verifying the matrix mdev and KVM are still
> >> linked prior to unregistering the GISC.
> >
> > I read from your commit message that this happens when the link between
> > the KVM and the matrix mdev was established and then got severed.
> >
> > I assume the interrupts were previously enabled, and were not been
> > disabled or cleaned up because q->saved_isc != VFIO_AP_ISC_INVALID.
> >
> > That means the guest enabled  interrupts and then for whatever
> > reason got destroyed, and this happens on mdev cleanup.
> >
> > Does it happen all the time or is it some sort of a race?
> 
> This is a race condition that happens when a guest is terminated and the 
> mdev is
> removed in rapid succession. I came across it with one of my hades test 
> cases
> on cleanup of the resources after the test case completes. There is a 
> bug in the problem appears
> the vfio_ap_mdev_releasefunction because it tries to reset the APQNs 
> after the bits are
> cleared from the matrix_mdev.matrix, so the resets never happen.
> 

That sounds very strange. I couldn't find the place where we clear the
bits in matrix_mdev.matrix except for unassign. Currently the unassign
is supposed to be enabled only after we have no guest and we have
cleaned up the queues (which should restore VFIO_AP_ISC_INVALID). Does
your test do any unassign operations? (I'm not sure the we always do
like we are supposed to.)

Now if we did not clear the bits from matrix_mdev.matrix then this
could be an use after free scenario (where we interpret already
re-purposed memory as matrix_mdev.matrix).

> Fixing that, however, does not resolve the issue, so I'm in the process 
> of doing a bunch of
> tracing to see the flow of the resets etc. during the lifecycle of the 
> mdev during this
> hades test. I should have a better answer next week.
>

My take away is that we don't understand what exactly is going wrong, and
so this patch is at best a mitigation (not a real fix). Does that sound
about correct?

Regards,
Halil

[..]
