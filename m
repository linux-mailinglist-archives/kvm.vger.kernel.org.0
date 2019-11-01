Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4E9A4EC007
	for <lists+kvm@lfdr.de>; Fri,  1 Nov 2019 09:50:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727870AbfKAIu1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 1 Nov 2019 04:50:27 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:9008 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727806AbfKAIu1 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 1 Nov 2019 04:50:27 -0400
Received: from pps.filterd (m0098409.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id xA18lMM5080956
        for <kvm@vger.kernel.org>; Fri, 1 Nov 2019 04:50:26 -0400
Received: from e06smtp07.uk.ibm.com (e06smtp07.uk.ibm.com [195.75.94.103])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2w0epfdjds-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Fri, 01 Nov 2019 04:50:25 -0400
Received: from localhost
        by e06smtp07.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <kvm@vger.kernel.org> from <imbrenda@linux.ibm.com>;
        Fri, 1 Nov 2019 08:50:23 -0000
Received: from b06avi18878370.portsmouth.uk.ibm.com (9.149.26.194)
        by e06smtp07.uk.ibm.com (192.168.101.137) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Fri, 1 Nov 2019 08:50:20 -0000
Received: from d06av23.portsmouth.uk.ibm.com (d06av23.portsmouth.uk.ibm.com [9.149.105.59])
        by b06avi18878370.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id xA18oI3136110666
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 1 Nov 2019 08:50:18 GMT
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 5B48AA4053;
        Fri,  1 Nov 2019 08:50:18 +0000 (GMT)
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 0E6B5A4055;
        Fri,  1 Nov 2019 08:50:18 +0000 (GMT)
Received: from p-imbrenda.boeblingen.de.ibm.com (unknown [9.145.0.105])
        by d06av23.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Fri,  1 Nov 2019 08:50:17 +0000 (GMT)
Date:   Fri, 1 Nov 2019 09:50:16 +0100
From:   Claudio Imbrenda <imbrenda@linux.ibm.com>
To:     David Hildenbrand <david@redhat.com>
Cc:     Christian Borntraeger <borntraeger@de.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>, kvm@vger.kernel.org,
        linux-s390@vger.kernel.org, thuth@redhat.com,
        mihajlov@linux.ibm.com, mimu@linux.ibm.com, cohuck@redhat.com,
        gor@linux.ibm.com
Subject: Re: [RFC 09/37] KVM: s390: protvirt: Implement on-demand pinning
In-Reply-To: <4abdc1dc-884e-a819-2e9d-2b8b15030394@redhat.com>
References: <20191024114059.102802-1-frankja@linux.ibm.com>
        <20191024114059.102802-10-frankja@linux.ibm.com>
        <b76ae1ca-d211-d1c7-63d9-9b45c789f261@redhat.com>
        <7465141c-27b7-a89e-f02d-ab05cdd8505d@de.ibm.com>
        <4abdc1dc-884e-a819-2e9d-2b8b15030394@redhat.com>
Organization: IBM
X-Mailer: Claws Mail 3.13.2 (GTK+ 2.24.30; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
x-cbid: 19110108-0028-0000-0000-000003B1BD85
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 19110108-0029-0000-0000-000024740AB6
Message-Id: <20191101095016.0562fa76@p-imbrenda.boeblingen.de.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-11-01_03:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=714 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1908290000 definitions=main-1911010089
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, 31 Oct 2019 18:30:30 +0100
David Hildenbrand <david@redhat.com> wrote:

> On 31.10.19 16:41, Christian Borntraeger wrote:
> > 
> > 
> > On 25.10.19 10:49, David Hildenbrand wrote:  
> >> On 24.10.19 13:40, Janosch Frank wrote:  
> >>> From: Claudio Imbrenda <imbrenda@linux.ibm.com>
> >>>
> >>> Pin the guest pages when they are first accessed, instead of all
> >>> at the same time when starting the guest.  
> >>
> >> Please explain why you do stuff. Why do we have to pin the hole
> >> guest memory? Why can't we mlock() the hole memory to avoid
> >> swapping in user space?  
> > 
> > Basically we pin the guest for the same reason as AMD did it for
> > their SEV. It is hard  
> 
> Pinning all guest memory is very ugly. What you want is "don't page", 
> what you get is unmovable pages all over the place. I was hoping that 
> you could get around this by having an automatic back-and-forth 
> conversion in place (due to the special new exceptions).

we're not pinning all of guest memory, btw, but only the pages that are
actually used.

so if you have a *huge* guest, only the few pages used by the kernel and
initrd are actually pinned at VM start. Then one by one the ones
actually used when the guest is running get pinned on first use.

I don't need to add anything regarding the other points since the other
have commented already :)

