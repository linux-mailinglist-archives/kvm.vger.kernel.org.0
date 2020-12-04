Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 83AF52CF488
	for <lists+kvm@lfdr.de>; Fri,  4 Dec 2020 20:08:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387420AbgLDTI2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 4 Dec 2020 14:08:28 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:38626 "EHLO
        mx0b-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726021AbgLDTI1 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 4 Dec 2020 14:08:27 -0500
Received: from pps.filterd (m0127361.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0B4J6qnk167443;
        Fri, 4 Dec 2020 14:07:42 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=pp1;
 bh=341the/jWzmsDSyFh/kypimy2W9A0JNne9mVTs9imtA=;
 b=su9kAN4GFN17vohEkvdIoc/DeXRFI0Fi47VOoWNu9zNrGDslMoHJuYZU0UsK1Jj8395D
 BdkZ7l+Zwpwd2bDcgEmsCWC+T9jRZXeYLl0SiqI0/MhXrvg4n5LKUz/e+1ZhRtelxZJ6
 uLiMUxtxUlERiFSVTvquYmrFck+xzdCbPp9ukTk812Up6pjXaqzOhmO5LtM08dzt4NA8
 Lg0W+NzrSdHgYEm3wlLTPpdmROZ9LQ8xFeK9YwI42LGbMXtKG6h3n2ZhRaXeJ+9kpAAV
 FGUf9iEyfBcqYxCz59ma8iuw3Z7r0zHC5xuWUUavjUIBWjZ1MstvllK8E/Q06KSGcmtA /g== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 357743ct1r-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 04 Dec 2020 14:07:42 -0500
Received: from m0127361.ppops.net (m0127361.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 0B4J76fA168139;
        Fri, 4 Dec 2020 14:07:20 -0500
Received: from ppma06fra.de.ibm.com (48.49.7a9f.ip4.static.sl-reverse.com [159.122.73.72])
        by mx0a-001b2d01.pphosted.com with ESMTP id 357743csmu-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 04 Dec 2020 14:07:19 -0500
Received: from pps.filterd (ppma06fra.de.ibm.com [127.0.0.1])
        by ppma06fra.de.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 0B4J42XZ031526;
        Fri, 4 Dec 2020 19:05:10 GMT
Received: from b06cxnps4075.portsmouth.uk.ibm.com (d06relay12.portsmouth.uk.ibm.com [9.149.109.197])
        by ppma06fra.de.ibm.com with ESMTP id 353dthbdxn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 04 Dec 2020 19:05:09 +0000
Received: from d06av21.portsmouth.uk.ibm.com (d06av21.portsmouth.uk.ibm.com [9.149.105.232])
        by b06cxnps4075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 0B4J57kE7537182
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 4 Dec 2020 19:05:07 GMT
Received: from d06av21.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id F12C652050;
        Fri,  4 Dec 2020 19:05:06 +0000 (GMT)
Received: from oc2783563651 (unknown [9.171.41.218])
        by d06av21.portsmouth.uk.ibm.com (Postfix) with SMTP id 6F6FF5204F;
        Fri,  4 Dec 2020 19:05:06 +0000 (GMT)
Date:   Fri, 4 Dec 2020 20:05:02 +0100
From:   Halil Pasic <pasic@linux.ibm.com>
To:     Tony Krowiak <akrowiak@linux.ibm.com>
Cc:     linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, borntraeger@de.ibm.com, cohuck@redhat.com,
        alex.williamson@redhat.com, kwankhede@nvidia.com, david@redhat.com,
        Janosch Frank <frankja@linux.ibm.com>
Subject: Re: [PATCH] s390/vfio-ap: Clean up vfio_ap resources when KVM
 pointer invalidated
Message-ID: <20201204200502.1c34ae58.pasic@linux.ibm.com>
In-Reply-To: <a8a90aed-97df-6f10-85c2-8e18dba8f085@linux.ibm.com>
References: <20201202234101.32169-1-akrowiak@linux.ibm.com>
        <20201203185514.54060568.pasic@linux.ibm.com>
        <a8a90aed-97df-6f10-85c2-8e18dba8f085@linux.ibm.com>
Organization: IBM
X-Mailer: Claws Mail 3.11.1 (GTK+ 2.24.31; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.312,18.0.737
 definitions=2020-12-04_07:2020-12-04,2020-12-04 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxlogscore=999 spamscore=0
 priorityscore=1501 mlxscore=0 suspectscore=0 impostorscore=0
 lowpriorityscore=0 bulkscore=0 adultscore=0 clxscore=1015 malwarescore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2012040106
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, 4 Dec 2020 09:43:59 -0500
Tony Krowiak <akrowiak@linux.ibm.com> wrote:

> >> +{
> >> +	if (matrix_mdev->kvm) {
> >> +		(matrix_mdev->kvm);
> >> +		matrix_mdev->kvm->arch.crypto.pqap_hook = NULL;  
> > Is a plain assignment to arch.crypto.pqap_hook apropriate, or do we need
> > to take more care?
> >
> > For instance kvm_arch_crypto_set_masks() takes kvm->lock before poking
> > kvm->arch.crypto.crycb.  
> 
> I do not think so. The CRYCB is used by KVM to provide crypto resources
> to the guest so it makes sense to protect it from changes to it while 
> passing
> the AP devices through to the guest. The hook is used only when an AQIC
> executed on the guest is intercepted by KVM. If the notifier
> is being invoked to notify vfio_ap that KVM has been set to NULL, this means
> the guest is gone in which case there will be no AP instructions to 
> intercept.

If the update to pqap_hook isn't observed as atomic we still have a
problem. With torn writes or reads we would try to use a corrupt function
pointer. While the compiler probably ain't likely to generate silly code
for the above assignment (multiple write instructions less then
quadword wide), I know of nothing that would prohibit the compiler to do
so.

I'm not certain about the scope of the kvm->lock (if it's supposed to
protect the whole sub-tree of objects). Maybe Janosch can help us out.
@Janosch: what do you think?

Regards,
Halil
