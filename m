Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 03A381A1EAF
	for <lists+kvm@lfdr.de>; Wed,  8 Apr 2020 12:21:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728154AbgDHKVs (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 8 Apr 2020 06:21:48 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:27000 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726846AbgDHKVs (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 8 Apr 2020 06:21:48 -0400
Received: from pps.filterd (m0098414.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 038A4Psw071640
        for <kvm@vger.kernel.org>; Wed, 8 Apr 2020 06:21:47 -0400
Received: from e06smtp02.uk.ibm.com (e06smtp02.uk.ibm.com [195.75.94.98])
        by mx0b-001b2d01.pphosted.com with ESMTP id 30920sqeqx-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Wed, 08 Apr 2020 06:21:46 -0400
Received: from localhost
        by e06smtp02.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <kvm@vger.kernel.org> from <imbrenda@linux.ibm.com>;
        Wed, 8 Apr 2020 11:21:26 +0100
Received: from b06cxnps4074.portsmouth.uk.ibm.com (9.149.109.196)
        by e06smtp02.uk.ibm.com (192.168.101.132) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Wed, 8 Apr 2020 11:21:23 +0100
Received: from d06av23.portsmouth.uk.ibm.com (d06av23.portsmouth.uk.ibm.com [9.149.105.59])
        by b06cxnps4074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 038ALfe254132826
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 8 Apr 2020 10:21:41 GMT
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id EA6DBA4051;
        Wed,  8 Apr 2020 10:21:40 +0000 (GMT)
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 7A9D5A404D;
        Wed,  8 Apr 2020 10:21:40 +0000 (GMT)
Received: from p-imbrenda (unknown [9.145.10.183])
        by d06av23.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Wed,  8 Apr 2020 10:21:40 +0000 (GMT)
Date:   Wed, 8 Apr 2020 12:21:38 +0200
From:   Claudio Imbrenda <imbrenda@linux.ibm.com>
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     Christian Borntraeger <borntraeger@de.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        David Hildenbrand <david@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        syzbot+d889b59b2bb87d4047a2@syzkaller.appspotmail.com
Subject: Re: [PATCH 2/2] KVM: s390: Return last valid slot if approx index
 is out-of-bounds
In-Reply-To: <20200408064059.8957-3-sean.j.christopherson@intel.com>
References: <20200408064059.8957-1-sean.j.christopherson@intel.com>
        <20200408064059.8957-3-sean.j.christopherson@intel.com>
Organization: IBM
X-Mailer: Claws Mail 3.17.5 (GTK+ 2.24.32; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
x-cbid: 20040810-0008-0000-0000-0000036CC612
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 20040810-0009-0000-0000-00004A8E6302
Message-Id: <20200408122138.71493308@p-imbrenda>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.676
 definitions=2020-04-07_10:2020-04-07,2020-04-07 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 suspectscore=0
 impostorscore=0 mlxscore=0 malwarescore=0 phishscore=0 priorityscore=1501
 adultscore=0 lowpriorityscore=0 spamscore=0 bulkscore=0 clxscore=1015
 mlxlogscore=999 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2004080079
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue,  7 Apr 2020 23:40:59 -0700
Sean Christopherson <sean.j.christopherson@intel.com> wrote:

> Return the index of the last valid slot from gfn_to_memslot_approx()
> if its binary search loop yielded an out-of-bounds index.  The index
> can be out-of-bounds if the specified gfn is less than the base of the
> lowest memslot (which is also the last valid memslot).
> 
> Note, the sole caller, kvm_s390_get_cmma(), ensures used_slots is
> non-zero.
> 
> Fixes: afdad61615cc3 ("KVM: s390: Fix storage attributes migration
> with memory slots") Signed-off-by: Sean Christopherson
> <sean.j.christopherson@intel.com> ---
>  arch/s390/kvm/kvm-s390.c | 3 +++
>  1 file changed, 3 insertions(+)
> 
> diff --git a/arch/s390/kvm/kvm-s390.c b/arch/s390/kvm/kvm-s390.c
> index 19a81024fe16..5dcf9ff12828 100644
> --- a/arch/s390/kvm/kvm-s390.c
> +++ b/arch/s390/kvm/kvm-s390.c
> @@ -1939,6 +1939,9 @@ static int gfn_to_memslot_approx(struct
> kvm_memslots *slots, gfn_t gfn) start = slot + 1;
>  	}
>  
> +	if (start >= slots->used_slots)
> +		return slots->used_slots - 1;
> +
>  	if (gfn >= memslots[start].base_gfn &&
>  	    gfn < memslots[start].base_gfn + memslots[start].npages)
> { atomic_set(&slots->lru_slot, start);

on s390 memory always starts at 0; you can't even boot a system missing
the first pages of physical memory, so this means this situation would
never happen in practice. 

of course, a malicious userspace program could create an (unbootable) VM
and trigger this bug, so the patch itself makes sense.

Reviewed-by: Claudio Imbrenda <imbrenda@linux.ibm.com>

