Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 442FE2956BE
	for <lists+kvm@lfdr.de>; Thu, 22 Oct 2020 05:28:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2443881AbgJVD16 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 21 Oct 2020 23:27:58 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:34778 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2443726AbgJVD16 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 21 Oct 2020 23:27:58 -0400
Received: from pps.filterd (m0098393.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 09M3FOBd096976;
        Wed, 21 Oct 2020 23:27:06 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=pp1;
 bh=QXA5PKcnbXyplcamDabU6tKWRH41Fg2TXtPcQnoL6SA=;
 b=l7iRMHXLXBsIC7yFar8Y8bmeVc7ZPxRaA4FQmUgBfilhQYzo6ACYrGmyF7x3OJ8dyJZj
 +r1Fu9hWq9qTluuQyMRQCVSmaO8CbsUDDrStSlAkUhxwyqqQ6jQ9KyNmFT02cMc5CFyY
 EmCT9QJuPdW6leVHT06o06V5blq7EKrVG3nQYPQ8c9fzF7fnfCwiZrq3X/RLGVRgK1ST
 zEUzTAsV2Z/QIRyuMVsiH/4bcUoSzD9XMEVpXOKAWDT1F2uBjl6RWnD55AZdKf1JdJJe
 Z2fKD2oGHn62Jq+FwOGVk1ue5FVjI5VA0ZAXzVhNttu1A5o3itJl1cE+OxbRMN69IW4o WA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 34b0b529y7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 21 Oct 2020 23:27:06 -0400
Received: from m0098393.ppops.net (m0098393.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 09M3NsTT121870;
        Wed, 21 Oct 2020 23:27:05 -0400
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
        by mx0a-001b2d01.pphosted.com with ESMTP id 34b0b529x9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 21 Oct 2020 23:27:05 -0400
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
        by ppma03ams.nl.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 09M3R2JJ031794;
        Thu, 22 Oct 2020 03:27:02 GMT
Received: from b06cxnps4076.portsmouth.uk.ibm.com (d06relay13.portsmouth.uk.ibm.com [9.149.109.198])
        by ppma03ams.nl.ibm.com with ESMTP id 348d5qv42u-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 22 Oct 2020 03:27:02 +0000
Received: from d06av22.portsmouth.uk.ibm.com (d06av22.portsmouth.uk.ibm.com [9.149.105.58])
        by b06cxnps4076.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 09M3R0fV32244158
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 22 Oct 2020 03:27:00 GMT
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 830484C04A;
        Thu, 22 Oct 2020 03:27:00 +0000 (GMT)
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 72B624C040;
        Thu, 22 Oct 2020 03:26:59 +0000 (GMT)
Received: from oc2783563651 (unknown [9.145.57.168])
        by d06av22.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Thu, 22 Oct 2020 03:26:59 +0000 (GMT)
Date:   Thu, 22 Oct 2020 05:26:47 +0200
From:   Halil Pasic <pasic@linux.ibm.com>
To:     "Kirill A. Shutemov" <kirill@shutemov.name>
Cc:     Dave Hansen <dave.hansen@linux.intel.com>,
        Andy Lutomirski <luto@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        David Rientjes <rientjes@google.com>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Kees Cook <keescook@chromium.org>,
        Will Drewry <wad@chromium.org>,
        "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>,
        "Kleen, Andi" <andi.kleen@intel.com>,
        Liran Alon <liran.alon@oracle.com>,
        Mike Rapoport <rppt@kernel.org>, x86@kernel.org,
        kvm@vger.kernel.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Subject: Re: [RFCv2 14/16] KVM: Handle protected memory in
 __kvm_map_gfn()/__kvm_unmap_gfn()
Message-ID: <20201022052647.6a4d7e0b.pasic@linux.ibm.com>
In-Reply-To: <20201020061859.18385-15-kirill.shutemov@linux.intel.com>
References: <20201020061859.18385-1-kirill.shutemov@linux.intel.com>
        <20201020061859.18385-15-kirill.shutemov@linux.intel.com>
Organization: IBM
X-Mailer: Claws Mail 3.11.1 (GTK+ 2.24.31; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.737
 definitions=2020-10-22_01:2020-10-20,2020-10-22 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 phishscore=0 clxscore=1011 spamscore=0 lowpriorityscore=0 suspectscore=0
 malwarescore=0 adultscore=0 bulkscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=655 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2010220019
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 20 Oct 2020 09:18:57 +0300
"Kirill A. Shutemov" <kirill@shutemov.name> wrote:

> We cannot access protected pages directly. Use ioremap() to
> create a temporary mapping of the page. The mapping is destroyed
> on __kvm_unmap_gfn().
> 
> The new interface gfn_to_pfn_memslot_protected() is used to detect if
> the page is protected.
> 
> ioremap_cache_force() is a hack to bypass IORES_MAP_SYSTEM_RAM check in
> the x86 ioremap code. We need a better solution.
> 
> Signed-off-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
> ---
>  arch/powerpc/kvm/book3s_64_mmu_hv.c    |  2 +-
>  arch/powerpc/kvm/book3s_64_mmu_radix.c |  2 +-
>  arch/x86/include/asm/io.h              |  2 +
>  arch/x86/include/asm/pgtable_types.h   |  1 +
>  arch/x86/kvm/mmu/mmu.c                 |  6 ++-
>  arch/x86/mm/ioremap.c                  | 16 ++++++--
>  include/linux/kvm_host.h               |  3 +-
>  include/linux/kvm_types.h              |  1 +
>  virt/kvm/kvm_main.c                    | 52 +++++++++++++++++++-------
>  9 files changed, 63 insertions(+), 22 deletions(-)
> 

You declare ioremap_cache_force() arch/x86/include/asm/io.h  in and
define it in arch/x86/mm/ioremap.c which is architecture specific code,
but use it in __kvm_map_gfn() in virt/kvm/kvm_main.c which is common
code.

Thus your series breaks the build for the s390 architecture. Have you
tried to (cross) compile for s390?

Regards,
Halil
