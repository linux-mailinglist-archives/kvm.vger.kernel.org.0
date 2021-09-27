Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CE5C6418FEE
	for <lists+kvm@lfdr.de>; Mon, 27 Sep 2021 09:23:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233253AbhI0HZW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 27 Sep 2021 03:25:22 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:34930 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233158AbhI0HZQ (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 27 Sep 2021 03:25:16 -0400
Received: from pps.filterd (m0098404.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 18R4fxfu010455;
        Mon, 27 Sep 2021 03:22:59 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=CjOlcnT7iJv79IU4P9/oIQ5aIU66wolcKEh57i1aef0=;
 b=R9Zo6rOi5sEtPF/jz79SMF+QOw8ZsBwnEkicDXMKstc+js70xMLJ5i+agBbUekhLEqLR
 Riq52GuXS7BkoIeatHGqjMJqg6X+sq9GMbrECM5MmPAudfQzUfMLZXqA4WIYz2prPMQi
 NRGyhPAyQzpNenbkr3M8+DmiUtn43GFhQo9zhTdQTTw5exh9yWGEFAmNLDaUbtLpHAGO
 n7KDW8mljRv3Ky4xZfNkkQl1vlezSvjZZfVvB6t91dxhd2ElVmfb9DDcZWzPHA/W2hHr
 Hx+lJOpkpOeJ/VQZISfyjwGRA6TkmASGsdGqJV35YVE7h94QvR6r3uDbww4sDPKbhTIn kA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3bagvqcsrd-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 27 Sep 2021 03:22:59 -0400
Received: from m0098404.ppops.net (m0098404.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 18R5o8Ah007641;
        Mon, 27 Sep 2021 03:22:58 -0400
Received: from ppma05fra.de.ibm.com (6c.4a.5195.ip4.static.sl-reverse.com [149.81.74.108])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3bagvqcsqb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 27 Sep 2021 03:22:58 -0400
Received: from pps.filterd (ppma05fra.de.ibm.com [127.0.0.1])
        by ppma05fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 18R7H9Q4001359;
        Mon, 27 Sep 2021 07:22:55 GMT
Received: from b06cxnps3075.portsmouth.uk.ibm.com (d06relay10.portsmouth.uk.ibm.com [9.149.109.195])
        by ppma05fra.de.ibm.com with ESMTP id 3b9ud8rx63-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 27 Sep 2021 07:22:55 +0000
Received: from d06av21.portsmouth.uk.ibm.com (d06av21.portsmouth.uk.ibm.com [9.149.105.232])
        by b06cxnps3075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 18R7Mp6J42467650
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 27 Sep 2021 07:22:51 GMT
Received: from d06av21.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 4D3E95204F;
        Mon, 27 Sep 2021 07:22:51 +0000 (GMT)
Received: from li-43c5434c-23b8-11b2-a85c-c4958fb47a68.ibm.com (unknown [9.171.4.236])
        by d06av21.portsmouth.uk.ibm.com (Postfix) with ESMTP id ABAD052051;
        Mon, 27 Sep 2021 07:22:49 +0000 (GMT)
Subject: disabling halt polling broken? (was Re: [PATCH 00/14] KVM:
 Halt-polling fixes, cleanups and a new stat)
To:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        David Matlack <dmatlack@google.com>,
        Jon Cargille <jcargill@google.com>,
        Jim Mattson <jmattson@google.com>
Cc:     James Morse <james.morse@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        David Hildenbrand <david@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Joerg Roedel <joro@8bytes.org>,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        linux-mips@vger.kernel.org, kvm@vger.kernel.org,
        kvm-ppc@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jing Zhang <jingzhangos@google.com>,
        Marc Zyngier <maz@kernel.org>,
        Huacai Chen <chenhuacai@kernel.org>,
        Aleksandar Markovic <aleksandar.qemu.devel@gmail.com>,
        Paul Mackerras <paulus@ozlabs.org>,
        Janosch Frank <frankja@linux.ibm.com>
References: <20210925005528.1145584-1-seanjc@google.com>
From:   Christian Borntraeger <borntraeger@de.ibm.com>
Message-ID: <03f2f5ab-e809-2ba5-bd98-3393c3b843d2@de.ibm.com>
Date:   Mon, 27 Sep 2021 09:22:49 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <20210925005528.1145584-1-seanjc@google.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: YhudcLNxmoRTm9--b5hlc8B3xu2hjRt_
X-Proofpoint-GUID: AXC2xKJr4IU02TPnWWKjhfFDtMWQ5xNx
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.182.1,Aquarius:18.0.790,Hydra:6.0.391,FMLib:17.0.607.475
 definitions=2021-09-27_01,2021-09-24_02,2020-04-07_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 spamscore=0
 priorityscore=1501 mlxscore=0 phishscore=0 mlxlogscore=974
 lowpriorityscore=0 impostorscore=0 adultscore=0 clxscore=1015
 suspectscore=0 malwarescore=0 bulkscore=0 classifier=spam adjust=0
 reason=mlx scancount=1 engine=8.12.0-2109230001
 definitions=main-2109270046
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

While looking into this series,

I realized that Davids patch

commit acd05785e48c01edb2c4f4d014d28478b5f19fb5
Author:     David Matlack <dmatlack@google.com>
AuthorDate: Fri Apr 17 15:14:46 2020 -0700
Commit:     Paolo Bonzini <pbonzini@redhat.com>
CommitDate: Fri Apr 24 12:53:17 2020 -0400

     kvm: add capability for halt polling

broke the possibility for an admin to disable halt polling for already running KVM guests.
In past times doing
echo 0 > /sys/module/kvm/parameters/halt_poll_ns

stopped polling system wide.
Now all KVM guests will use the halt_poll_ns value that was active during startup - even those that do not use KVM_CAP_HALT_POLL.

I guess this was not intended?
