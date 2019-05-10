Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 612F51992D
	for <lists+kvm@lfdr.de>; Fri, 10 May 2019 09:49:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727026AbfEJHtl convert rfc822-to-8bit (ORCPT
        <rfc822;lists+kvm@lfdr.de>); Fri, 10 May 2019 03:49:41 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:36628 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727010AbfEJHtl (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 10 May 2019 03:49:41 -0400
Received: from pps.filterd (m0098420.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x4A7ftqA039691
        for <kvm@vger.kernel.org>; Fri, 10 May 2019 03:49:39 -0400
Received: from e06smtp01.uk.ibm.com (e06smtp01.uk.ibm.com [195.75.94.97])
        by mx0b-001b2d01.pphosted.com with ESMTP id 2sd4yk8phk-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Fri, 10 May 2019 03:49:39 -0400
Received: from localhost
        by e06smtp01.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <kvm@vger.kernel.org> from <imbrenda@linux.ibm.com>;
        Fri, 10 May 2019 08:49:37 +0100
Received: from b06cxnps3075.portsmouth.uk.ibm.com (9.149.109.195)
        by e06smtp01.uk.ibm.com (192.168.101.131) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Fri, 10 May 2019 08:49:33 +0100
Received: from d06av26.portsmouth.uk.ibm.com (d06av26.portsmouth.uk.ibm.com [9.149.105.62])
        by b06cxnps3075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id x4A7nVKi60162116
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 10 May 2019 07:49:31 GMT
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id CD994AE045;
        Fri, 10 May 2019 07:49:31 +0000 (GMT)
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 31475AE05F;
        Fri, 10 May 2019 07:49:31 +0000 (GMT)
Received: from p-imbrenda.boeblingen.de.ibm.com (unknown [9.152.224.155])
        by d06av26.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Fri, 10 May 2019 07:49:31 +0000 (GMT)
Date:   Fri, 10 May 2019 09:49:29 +0200
From:   Claudio Imbrenda <imbrenda@linux.ibm.com>
To:     "Jason J. Herne" <jjherne@linux.ibm.com>
Cc:     Halil Pasic <pasic@linux.ibm.com>, kvm@vger.kernel.org,
        linux-s390@vger.kernel.org, "Cornelia Huck ," <cohuck@redhat.com>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Sebastian Ott <sebott@linux.ibm.com>,
        virtualization@lists.linux-foundation.org,
        "Michael S. Tsirkin ," <mst@redhat.com>,
        Christoph Hellwig <hch@infradead.org>,
        "Thomas Huth ," <thuth@redhat.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Viktor Mihajlovski <mihajlov@linux.ibm.com>,
        "Vasily Gorbik ," <gor@linux.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Farhan Ali <alifm@linux.ibm.com>,
        Eric Farman <farman@linux.ibm.com>
Subject: Re: [PATCH 04/10] s390/mm: force swiotlb for protected
 virtualization
In-Reply-To: <4c7a990a-7f11-17f3-2024-18acaf7ceb06@linux.ibm.com>
References: <20190426183245.37939-5-pasic@linux.ibm.com>
        <ad23f5e7-dc78-04af-c892-47bbc65134c6@linux.ibm.com>
        <4c7a990a-7f11-17f3-2024-18acaf7ceb06@linux.ibm.com>
Organization: IBM
X-Mailer: Claws Mail 3.13.2 (GTK+ 2.24.30; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
X-TM-AS-GCONF: 00
x-cbid: 19051007-4275-0000-0000-000003334F05
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 19051007-4276-0000-0000-00003842C441
Message-Id: <20190510094929.67e4ad29@p-imbrenda.boeblingen.de.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-05-09_02:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1810050000 definitions=main-1905100054
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, 9 May 2019 14:05:20 -0400
"Jason J. Herne" <jjherne@linux.ibm.com> wrote:

[...]

> > +#define sme_me_mask    0ULL
> > +
> > +static inline bool sme_active(void) { return false; }
> > +extern bool sev_active(void);
> > +  
> 
> I noticed this patch always returns false for sme_active. Is it safe
> to assume that whatever fixups are required on x86 to deal with sme
> do not apply to s390?

yes, on x86 sev_active returns false if SEV is enabled. SME is for
host memory encryption. from arch/x86/mm/mem_encrypt.c:

bool sme_active(void)
{
        return sme_me_mask && !sev_enabled;
}

and it makes sense because you can't have both SME and SEV enabled on
the same kernel, because either you're running on bare metal (and then
you can have SME) __or__ you are running as a guest (and then you can
have SEV). The key difference is that DMA operations don't need
bounce buffers with SME, but they do with SEV.

I hope this clarifies your doubts :)

[...]

