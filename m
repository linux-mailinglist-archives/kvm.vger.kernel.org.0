Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4FF2D61FE3E
	for <lists+kvm@lfdr.de>; Mon,  7 Nov 2022 20:10:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232196AbiKGTJh (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 7 Nov 2022 14:09:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45332 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232908AbiKGTJ1 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 7 Nov 2022 14:09:27 -0500
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9BEF524953;
        Mon,  7 Nov 2022 11:09:26 -0800 (PST)
Received: from pps.filterd (m0127361.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 2A7IMGET008477;
        Mon, 7 Nov 2022 19:08:58 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : subject :
 from : to : cc : date : in-reply-to : references : content-type :
 content-transfer-encoding : mime-version; s=pp1;
 bh=8yB1T9kkcj6JZp4TFm1A7hnrKTeQoKKGrd8tbPdyOEs=;
 b=mPK9o5wVItAdUCHHrTW+8HPUpMJmXCn685NlXKeVscLMgyHN4njk8bVPEIHZQPcPLZqK
 Ztz8RCrPoADtS/PrmmIEoIPAMygo0OG+ehIy/Xh5qIWr83a/qhrmNPRWHT7LucYzuM6v
 GRY8EZO5Yi9cBmIGqjDcuXfelRLAZTOy12d0YJGmmFC79SKpFsiYDDpFKy4ciSN4pXgq
 ZH3CiU5g+v8IvCRrWHCXajaSzXembp+poMANK9d6PkKxLctLIG6WcGSnTwltbKhrZ/q9
 fu9tqSDViuxcUkN+0hEHKxNVgqwvD3l/8QHsqgCbXQ/CCD24BS1R0u7ACKjl2l8sEdL4 +A== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3kp1vspb26-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 07 Nov 2022 19:08:57 +0000
Received: from m0127361.ppops.net (m0127361.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 2A7IgUpc024059;
        Mon, 7 Nov 2022 19:08:56 GMT
Received: from ppma01wdc.us.ibm.com (fd.55.37a9.ip4.static.sl-reverse.com [169.55.85.253])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3kp1vspb1g-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 07 Nov 2022 19:08:56 +0000
Received: from pps.filterd (ppma01wdc.us.ibm.com [127.0.0.1])
        by ppma01wdc.us.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 2A7J6ZLd012249;
        Mon, 7 Nov 2022 19:08:55 GMT
Received: from b01cxnp22034.gho.pok.ibm.com (b01cxnp22034.gho.pok.ibm.com [9.57.198.24])
        by ppma01wdc.us.ibm.com with ESMTP id 3kngs3smh7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 07 Nov 2022 19:08:55 +0000
Received: from smtpav02.wdc07v.mail.ibm.com ([9.208.128.114])
        by b01cxnp22034.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 2A7J8sh916712426
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 7 Nov 2022 19:08:54 GMT
Received: from smtpav02.wdc07v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 26BC558068;
        Mon,  7 Nov 2022 19:08:54 +0000 (GMT)
Received: from smtpav02.wdc07v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 430D958060;
        Mon,  7 Nov 2022 19:08:50 +0000 (GMT)
Received: from li-479af74c-31f9-11b2-a85c-e4ddee11713b.ibm.com (unknown [9.65.225.56])
        by smtpav02.wdc07v.mail.ibm.com (Postfix) with ESMTP;
        Mon,  7 Nov 2022 19:08:50 +0000 (GMT)
Message-ID: <13c194d02d02a0e2adc006c724809b63c11f1e80.camel@linux.ibm.com>
Subject: Re: [PATCH 30/44] KVM: Drop kvm_arch_check_processor_compat() hook
From:   Eric Farman <farman@linux.ibm.com>
To:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Marc Zyngier <maz@kernel.org>,
        Huacai Chen <chenhuacai@kernel.org>,
        Aleksandar Markovic <aleksandar.qemu.devel@gmail.com>,
        Anup Patel <anup@brainfault.org>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Albert Ou <aou@eecs.berkeley.edu>,
        Christian Borntraeger <borntraeger@linux.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        Matthew Rosato <mjrosato@linux.ibm.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>
Cc:     James Morse <james.morse@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Oliver Upton <oliver.upton@linux.dev>,
        Atish Patra <atishp@atishpatra.org>,
        David Hildenbrand <david@redhat.com>, kvm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
        kvmarm@lists.cs.columbia.edu, linux-mips@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org, kvm-riscv@lists.infradead.org,
        linux-riscv@lists.infradead.org, linux-s390@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Isaku Yamahata <isaku.yamahata@intel.com>,
        Fabiano Rosas <farosas@linux.ibm.com>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Chao Gao <chao.gao@intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Yuan Yao <yuan.yao@intel.com>
Date:   Mon, 07 Nov 2022 14:08:47 -0500
In-Reply-To: <20221102231911.3107438-31-seanjc@google.com>
References: <20221102231911.3107438-1-seanjc@google.com>
         <20221102231911.3107438-31-seanjc@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.44.4 (3.44.4-2.fc36) 
MIME-Version: 1.0
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: RHHp999uHGQe6ZCvMSlBReRcUeSiiV8m
X-Proofpoint-GUID: DuaePqxTnOnEid3ZLdZuErIqRkSISZr5
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-11-07_09,2022-11-07_02,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1015 mlxlogscore=793
 phishscore=0 impostorscore=0 lowpriorityscore=0 mlxscore=0 malwarescore=0
 bulkscore=0 spamscore=0 adultscore=0 suspectscore=0 priorityscore=1501
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2210170000
 definitions=main-2211070152
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, 2022-11-02 at 23:18 +0000, Sean Christopherson wrote:
> Drop kvm_arch_check_processor_compat() and its support code now that
> all
> architecture implementations are nops.
>=20
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
> =C2=A0arch/arm64/kvm/arm.c=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 |=C2=A0 7 =
+------
> =C2=A0arch/mips/kvm/mips.c=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 |=C2=A0 7 =
+------
> =C2=A0arch/powerpc/kvm/book3s.c=C2=A0 |=C2=A0 2 +-
> =C2=A0arch/powerpc/kvm/e500.c=C2=A0=C2=A0=C2=A0 |=C2=A0 2 +-
> =C2=A0arch/powerpc/kvm/e500mc.c=C2=A0 |=C2=A0 2 +-
> =C2=A0arch/powerpc/kvm/powerpc.c |=C2=A0 5 -----
> =C2=A0arch/riscv/kvm/main.c=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 |=C2=A0 7 +----=
--
> =C2=A0arch/s390/kvm/kvm-s390.c=C2=A0=C2=A0 |=C2=A0 7 +------
> =C2=A0arch/x86/kvm/svm/svm.c=C2=A0=C2=A0=C2=A0=C2=A0 |=C2=A0 4 ++--
> =C2=A0arch/x86/kvm/vmx/vmx.c=C2=A0=C2=A0=C2=A0=C2=A0 |=C2=A0 4 ++--
> =C2=A0arch/x86/kvm/x86.c=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 =
|=C2=A0 5 -----
> =C2=A0include/linux/kvm_host.h=C2=A0=C2=A0 |=C2=A0 4 +---
> =C2=A0virt/kvm/kvm_main.c=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 | 24 =
+-----------------------
> =C2=A013 files changed, 13 insertions(+), 67 deletions(-)

Reviewed-by: Eric Farman <farman@linux.ibm.com>	# s390
