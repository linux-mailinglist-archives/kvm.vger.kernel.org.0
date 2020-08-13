Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5139A24358A
	for <lists+kvm@lfdr.de>; Thu, 13 Aug 2020 09:54:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726713AbgHMHyk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 13 Aug 2020 03:54:40 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:10960 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726574AbgHMHyj (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 13 Aug 2020 03:54:39 -0400
Received: from pps.filterd (m0098416.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 07D7XLor098999;
        Thu, 13 Aug 2020 03:54:32 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=pvGpKk/te6wBrI+pp2guEgQc15OWxh2xznhiozF4vwo=;
 b=HhXmpc/felX4qtADi4vUIKF8kMcmVNbRzYF1X51Jj0/NU1jqJnPuBbgtsfBwPE26viZ0
 iVlm+QEP5uRr1QWvj9rRYOmDUm92JTfxLRqk4dIPeyyzDOmFraCFsB1RqJnVa8rMHdHp
 ABFWseoOzlWEMoKn0QNjFR93MMruiMZ/huAWb3TAujmHZ5eSvJapndNcBlpaMzp1sJO6
 RsE/p7/HtHQL3ylNp2x6T/s+Vq6nU0ZyHXe+VrD3DboNls8mAdEMvIjCjIUHRSvU5lP/
 Mh34Of93SED6xqlLeMJVpZMxa0A4+ALJvmaWAyN3NDVMI4rVrTQRxLnyZTIR6/xy0d2u fA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 32w0n09qk5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 13 Aug 2020 03:54:32 -0400
Received: from m0098416.ppops.net (m0098416.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 07D7ZNcl105533;
        Thu, 13 Aug 2020 03:54:31 -0400
Received: from ppma03fra.de.ibm.com (6b.4a.5195.ip4.static.sl-reverse.com [149.81.74.107])
        by mx0b-001b2d01.pphosted.com with ESMTP id 32w0n09qjf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 13 Aug 2020 03:54:31 -0400
Received: from pps.filterd (ppma03fra.de.ibm.com [127.0.0.1])
        by ppma03fra.de.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 07D7ns1a000342;
        Thu, 13 Aug 2020 07:54:29 GMT
Received: from b06cxnps3075.portsmouth.uk.ibm.com (d06relay10.portsmouth.uk.ibm.com [9.149.109.195])
        by ppma03fra.de.ibm.com with ESMTP id 32skp838g2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 13 Aug 2020 07:54:29 +0000
Received: from d06av22.portsmouth.uk.ibm.com (d06av22.portsmouth.uk.ibm.com [9.149.105.58])
        by b06cxnps3075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 07D7sQKF34013482
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 13 Aug 2020 07:54:27 GMT
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id D2CAF4C046;
        Thu, 13 Aug 2020 07:54:26 +0000 (GMT)
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 3A7944C044;
        Thu, 13 Aug 2020 07:54:26 +0000 (GMT)
Received: from oc5500677777.ibm.com (unknown [9.145.93.1])
        by d06av22.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Thu, 13 Aug 2020 07:54:26 +0000 (GMT)
Subject: Re: [PATCH v2] PCI: Introduce flag for detached virtual functions
To:     "Oliver O'Halloran" <oohall@gmail.com>,
        Alex Williamson <alex.williamson@redhat.com>
Cc:     Matthew Rosato <mjrosato@linux.ibm.com>,
        Bjorn Helgaas <bhelgaas@google.com>, pmorel@linux.ibm.com,
        Michael Ellerman <mpe@ellerman.id.au>,
        linux-s390@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        KVM list <kvm@vger.kernel.org>,
        linux-pci <linux-pci@vger.kernel.org>
References: <1597260071-2219-1-git-send-email-mjrosato@linux.ibm.com>
 <1597260071-2219-2-git-send-email-mjrosato@linux.ibm.com>
 <20200812143254.2f080c38@x1.home>
 <CAOSf1CFh4ygZeeqpjpbWFWxJJEpDjHD+Q_L4dUaU_3wx7_35pg@mail.gmail.com>
From:   Niklas Schnelle <schnelle@linux.ibm.com>
Message-ID: <19bb6ca8-f6bb-841c-e4dd-cd9e8e6e430f@linux.ibm.com>
Date:   Thu, 13 Aug 2020 09:54:25 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <CAOSf1CFh4ygZeeqpjpbWFWxJJEpDjHD+Q_L4dUaU_3wx7_35pg@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-08-13_05:2020-08-13,2020-08-13 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 phishscore=0
 priorityscore=1501 clxscore=1011 malwarescore=0 impostorscore=0
 adultscore=0 suspectscore=0 bulkscore=0 lowpriorityscore=0 spamscore=0
 mlxscore=0 mlxlogscore=999 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2008130057
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 8/13/20 3:59 AM, Oliver O'Halloran wrote:
> On Thu, Aug 13, 2020 at 6:33 AM Alex Williamson
> <alex.williamson@redhat.com> wrote:
>>
>> On Wed, 12 Aug 2020 15:21:11 -0400
>> Matthew Rosato <mjrosato@linux.ibm.com> wrote:
>>
... snip ...
>>
>> Is there too much implicit knowledge in defining a "detached VF"?  For
>> example, why do we know that we can skip the portion of
>> vfio_config_init() that copies the vendor and device IDs from the
>> struct pci_dev into the virtual config space?  It's true on s390x, but
>> I think that's because we know that firmware emulates those registers
>> for us.
>>
>> We also skip the INTx pin register sanity checking.  Do we do
>> that because we haven't installed the broken device into an s390x
>> system?  Because we know firmware manages that for us too?  Or simply
>> because s390x doesn't support INTx anyway, and therefore it's another
>> architecture implicit decision?
> 
> Agreed. Any hacks we put in for normal VFs are going to be needed for
> the passed-though VF case. Only applying the memory space enable
> workaround doesn't make sense to me either.

We did actually have the detached_vf check in that if in
a previous patch version, turning on the INTx and quirk checks.
We decided to send a minimal version for the discussion.
That said I agree that this is currently too specific to our
case.

> 
>> If detached_vf is really equivalent to is_virtfn for all cases that
>> don't care about referencing physfn on the pci_dev, then we should
>> probably have a macro to that effect.

In my opinion it really is, that's why we initially tried to just
set pdev->is_virtfn leaving the physfn pointer NULL for these
detached VFs. 
But as you said that gets uncomfortable because of the union and existing code
assuming that pdev->is_virtfn always means physfn is set.

I think the underlying problem here is, that the current use
of pdev->is_virtfn conflates the two reasons we need to know whether
something is a VF:

1. For dealing with the differences in how a VF presents itself vs a PF
2. For knowing whether the physfn/sriov union is a pointer to the parent PF

If we could untangle this in a sane way I think that would
be the best long term solution.

> 
> A pci_is_virtfn() helper would be better than open coding both checks
> everywhere. That said, it might be solving the wrong problem. The
> union between ->physfn and ->sriov has always seemed like a footgun to
> me so we might be better off switching the users who want a physfn to
> a helper instead. i.e.
> 
> struct pci_dev *pci_get_vf_physfn(struct pci_dev *vf)
> {
>         if (!vf->is_virtfn)
>                 return NULL;
> 
>         return vf->physfn;
> }

Hmm, this is almost exactly  include/linux/pci.h:pci_physfn()
except that returns the argument pdev itself when is_virtfn
is not set.

> 
> ...
> 
> pf = pci_get_vf_physfn(vf)
> if (pf)
>     /* do pf things */
> 
> Then we can just use ->is_virtfn for the normal and detached cases.

I'm asssuming you mean by setting vf->is_virtfn = 1; vf->physfn = NULL
for the detached case? I think that actually also works with the existing
pci_physfn() helper but it requires handling a returned NULL at
all callsites.

> 
> Oliver
> 
