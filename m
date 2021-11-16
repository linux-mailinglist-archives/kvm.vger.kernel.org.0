Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 450FD452C8A
	for <lists+kvm@lfdr.de>; Tue, 16 Nov 2021 09:16:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231774AbhKPITM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 16 Nov 2021 03:19:12 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:47244 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231405AbhKPITM (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 16 Nov 2021 03:19:12 -0500
Received: from pps.filterd (m0187473.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 1AG7KZHF024383;
        Tue, 16 Nov 2021 08:15:52 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=CfrWYVK/WWUx2FkE6O2ernHb54WT2Dsdlt0HTCGPt+w=;
 b=f0TBohjdWu+iuJrqMrr3R+j6zBNzfqH8j7EEQO7V49x7A5Pll0a6HHEijwy/4eZuLrFF
 BRG1zq9QewkxR7PY0vPizivDqBVB5z/vmi7CeXawPgV8W/+NyMraum4+4EL5L9CB/0Cn
 vqSJl8S6UVr9bF790zrEpVgBMEM2e7zZM3e0OPBsW378Js0iJBKmQCex5bVPzHItEyzl
 0kUGt8FgsE5FX2e+9nZPgGPCqPsiguv8V8dBj9k60QN3JLBf678bdC1CaDVgGIeBPugb
 BwJzbTdm1liutRvChFPAxtost/N44Cs2Qh5ozJqgYILooTJ5aWLsY2Y/HWWqGHPh8Ki1 ZA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3cc4j2mu6r-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 16 Nov 2021 08:15:51 +0000
Received: from m0187473.ppops.net (m0187473.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 1AG7c4OW006712;
        Tue, 16 Nov 2021 08:15:51 GMT
Received: from ppma04ams.nl.ibm.com (63.31.33a9.ip4.static.sl-reverse.com [169.51.49.99])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3cc4j2mu5p-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 16 Nov 2021 08:15:51 +0000
Received: from pps.filterd (ppma04ams.nl.ibm.com [127.0.0.1])
        by ppma04ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 1AG8C17h001896;
        Tue, 16 Nov 2021 08:15:48 GMT
Received: from b06cxnps4076.portsmouth.uk.ibm.com (d06relay13.portsmouth.uk.ibm.com [9.149.109.198])
        by ppma04ams.nl.ibm.com with ESMTP id 3ca50avrcx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 16 Nov 2021 08:15:48 +0000
Received: from d06av21.portsmouth.uk.ibm.com (d06av21.portsmouth.uk.ibm.com [9.149.105.232])
        by b06cxnps4076.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 1AG8FirP4522606
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 16 Nov 2021 08:15:44 GMT
Received: from d06av21.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id AC33E52054;
        Tue, 16 Nov 2021 08:15:44 +0000 (GMT)
Received: from [9.171.18.51] (unknown [9.171.18.51])
        by d06av21.portsmouth.uk.ibm.com (Postfix) with ESMTP id 588DA52051;
        Tue, 16 Nov 2021 08:15:43 +0000 (GMT)
Message-ID: <d7547cab-88d6-18a9-8307-bf2cc5d61163@de.ibm.com>
Date:   Tue, 16 Nov 2021 09:15:43 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.2.0
Subject: Re: [PATCH 0/5] KVM: Cap KVM_CAP_NR_VCPUS by KVM_CAP_MAX_VCPUS and
 re-purpose it on x86
Content-Language: en-US
To:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org
Cc:     Sean Christopherson <seanjc@google.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Eduardo Habkost <ehabkost@redhat.com>,
        Marc Zyngier <maz@kernel.org>,
        Andrew Jones <drjones@redhat.com>,
        Huacai Chen <chenhuacai@kernel.org>,
        Aleksandar Markovic <aleksandar.qemu.devel@gmail.com>,
        Anup Patel <anup.patel@wdc.com>,
        Paul Mackerras <paulus@ozlabs.org>,
        Michael Ellerman <mpe@ellerman.id.au>, kvm-ppc@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-mips@vger.kernel.org,
        kvm-riscv@lists.infradead.org, linux-kernel@vger.kernel.org,
        Janosch Frank <frankja@linux.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>
References: <20211111162746.100598-1-vkuznets@redhat.com>
 <4a3c7be7-12fa-6e47-64eb-02e6c5be5dbc@redhat.com>
 <ecd55383-7089-b3cd-30cc-3f9feb7eadb4@de.ibm.com> <877dd9pfri.fsf@redhat.com>
From:   Christian Borntraeger <borntraeger@de.ibm.com>
In-Reply-To: <877dd9pfri.fsf@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: LcLtdeI1wcxvnUw1x1mtWpHDxGmneBxm
X-Proofpoint-ORIG-GUID: q5QSO4swu95OL1X3UIEGk2E0NE9OQf1Y
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.0.607.475
 definitions=2021-11-15_16,2021-11-15_01,2020-04-07_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 spamscore=0 impostorscore=0
 adultscore=0 clxscore=1015 priorityscore=1501 phishscore=0 malwarescore=0
 mlxscore=0 mlxlogscore=999 suspectscore=0 lowpriorityscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2110150000
 definitions=main-2111160041
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



Am 15.11.21 um 17:04 schrieb Vitaly Kuznetsov:
[...]
> or cap KVM_CAP_MAX_VCPUS value with num_online_cpus(), e.g.
> 
> diff --git a/arch/s390/kvm/kvm-s390.c b/arch/s390/kvm/kvm-s390.c
> index 6a6dd5e1daf6..1cfe36f6432e 100644
> --- a/arch/s390/kvm/kvm-s390.c
> +++ b/arch/s390/kvm/kvm-s390.c
> @@ -585,6 +585,8 @@ int kvm_vm_ioctl_check_extension(struct kvm *kvm, long ext)
>                          r = KVM_MAX_VCPUS;
>                  else if (sclp.has_esca && sclp.has_64bscao)
>                          r = KVM_S390_ESCA_CPU_SLOTS;
> +               if (ext == KVM_CAP_NR_VCPUS)
> +                       r = min_t(unsigned int, num_online_cpus(), r);
>                  break;
>          case KVM_CAP_S390_COW:
>                  r = MACHINE_HAS_ESOP;

Acked-by: Christian Borntraeger <borntraeger@de.ibm.com>


I think this is the better variant. Thanks.
