Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C32956607B
	for <lists+kvm@lfdr.de>; Thu, 11 Jul 2019 22:18:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729025AbfGKUR4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 11 Jul 2019 16:17:56 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:63646 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726207AbfGKUR4 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 11 Jul 2019 16:17:56 -0400
Received: from pps.filterd (m0098419.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x6BKHqbF045066
        for <kvm@vger.kernel.org>; Thu, 11 Jul 2019 16:17:54 -0400
Received: from e06smtp03.uk.ibm.com (e06smtp03.uk.ibm.com [195.75.94.99])
        by mx0b-001b2d01.pphosted.com with ESMTP id 2tpbfb17cp-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Thu, 11 Jul 2019 16:17:53 -0400
Received: from localhost
        by e06smtp03.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <kvm@vger.kernel.org> from <rppt@linux.ibm.com>;
        Thu, 11 Jul 2019 21:17:21 +0100
Received: from b06cxnps4075.portsmouth.uk.ibm.com (9.149.109.197)
        by e06smtp03.uk.ibm.com (192.168.101.133) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Thu, 11 Jul 2019 21:17:15 +0100
Received: from d06av21.portsmouth.uk.ibm.com (d06av21.portsmouth.uk.ibm.com [9.149.105.232])
        by b06cxnps4075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id x6BKHErw49217562
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 11 Jul 2019 20:17:14 GMT
Received: from d06av21.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 4BFD152052;
        Thu, 11 Jul 2019 20:17:14 +0000 (GMT)
Received: from rapoport-lnx (unknown [9.148.204.152])
        by d06av21.portsmouth.uk.ibm.com (Postfix) with ESMTPS id 2AD435205A;
        Thu, 11 Jul 2019 20:17:09 +0000 (GMT)
Date:   Thu, 11 Jul 2019 23:17:07 +0300
From:   Mike Rapoport <rppt@linux.ibm.com>
To:     Andi Kleen <andi@firstfloor.org>
Cc:     Alexandre Chartre <alexandre.chartre@oracle.com>,
        pbonzini@redhat.com, rkrcmar@redhat.com, tglx@linutronix.de,
        mingo@redhat.com, bp@alien8.de, hpa@zytor.com,
        dave.hansen@linux.intel.com, luto@kernel.org, peterz@infradead.org,
        kvm@vger.kernel.org, x86@kernel.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, konrad.wilk@oracle.com,
        jan.setjeeilers@oracle.com, liran.alon@oracle.com,
        jwadams@google.com, graf@amazon.de, rppt@linux.vnet.ibm.com
Subject: Re: [RFC v2 02/26] mm/asi: Abort isolation on interrupt, exception
 and context switch
References: <1562855138-19507-1-git-send-email-alexandre.chartre@oracle.com>
 <1562855138-19507-3-git-send-email-alexandre.chartre@oracle.com>
 <874l3sz5z4.fsf@firstfloor.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <874l3sz5z4.fsf@firstfloor.org>
User-Agent: Mutt/1.5.24 (2015-08-30)
X-TM-AS-GCONF: 00
x-cbid: 19071120-0012-0000-0000-00000331E9C1
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 19071120-0013-0000-0000-0000216B57DD
Message-Id: <20190711201706.GB20140@rapoport-lnx>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-07-11_05:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1011 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=956 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1810050000 definitions=main-1907110224
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Jul 11, 2019 at 01:11:43PM -0700, Andi Kleen wrote:
> Alexandre Chartre <alexandre.chartre@oracle.com> writes:
> >  	jmp	paranoid_exit
> > @@ -1182,6 +1196,16 @@ ENTRY(paranoid_entry)
> >  	xorl	%ebx, %ebx
> >  
> >  1:
> > +#ifdef CONFIG_ADDRESS_SPACE_ISOLATION
> > +	/*
> > +	 * If address space isolation is active then abort it and return
> > +	 * the original kernel CR3 in %r14.
> > +	 */
> > +	ASI_START_ABORT_ELSE_JUMP 2f
> > +	movq	%rdi, %r14
> > +	ret
> > +2:
> > +#endif
> 
> Unless I missed it you don't map the exception stacks into ASI, so it
> has likely already triple faulted at this point.

The exception stacks are in the CPU entry area, aren't they?
 
> -Andi
> 

-- 
Sincerely yours,
Mike.

