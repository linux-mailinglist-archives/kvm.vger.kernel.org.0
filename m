Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8240135DA27
	for <lists+kvm@lfdr.de>; Tue, 13 Apr 2021 10:34:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239004AbhDMIej (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 13 Apr 2021 04:34:39 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:53070 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229656AbhDMIei (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 13 Apr 2021 04:34:38 -0400
Received: from pps.filterd (m0098404.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 13D8XDB4071495;
        Tue, 13 Apr 2021 04:33:15 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=pp1;
 bh=H1Y2/bGYlV5wOp/OT6q1ivbSoZaewBAhlcce0EfVJDw=;
 b=hF6Tcce0q1E8/JsKwPEi11yovP5JnZmCCT6MhTHguCXtZ7HFAcCci66mCzkEHBJ98TPS
 1bL0ovKXyId2H4sT8as6eqBZ4gFngfZDlgFRALMyIpkeE5LM1fNNGOo+PydFIEukU7Kb
 iUkzkLzHvkhviArbfORPEBAfqWk49tYahF3Ss2zq/ECsY3f4b9SodN+f961TpwOouEK5
 gk4L/PFOGaP8Omu3GOacpHPg9zwvleL+qm9LZKeZKVpAPX/h3K3+H/PgOfp5+E9Xh9wf
 cDKMOcx/+TKYTkTzNIau20xuPdnVVCnvcRMxjJmgAGVpjDTCt8bk8xGGpsk5UILue+JO pQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 37w76qsawv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 13 Apr 2021 04:33:15 -0400
Received: from m0098404.ppops.net (m0098404.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 13D8XEpW071703;
        Tue, 13 Apr 2021 04:33:14 -0400
Received: from ppma06fra.de.ibm.com (48.49.7a9f.ip4.static.sl-reverse.com [159.122.73.72])
        by mx0a-001b2d01.pphosted.com with ESMTP id 37w76qsat3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 13 Apr 2021 04:33:14 -0400
Received: from pps.filterd (ppma06fra.de.ibm.com [127.0.0.1])
        by ppma06fra.de.ibm.com (8.16.0.43/8.16.0.43) with SMTP id 13D8X28V004312;
        Tue, 13 Apr 2021 08:33:03 GMT
Received: from b06avi18626390.portsmouth.uk.ibm.com (b06avi18626390.portsmouth.uk.ibm.com [9.149.26.192])
        by ppma06fra.de.ibm.com with ESMTP id 37u39h9b0g-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 13 Apr 2021 08:33:02 +0000
Received: from d06av23.portsmouth.uk.ibm.com (d06av23.portsmouth.uk.ibm.com [9.149.105.59])
        by b06avi18626390.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 13D8WcuQ34865494
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 13 Apr 2021 08:32:38 GMT
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 822D0A4053;
        Tue, 13 Apr 2021 08:33:00 +0000 (GMT)
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 9A7E1A404D;
        Tue, 13 Apr 2021 08:32:59 +0000 (GMT)
Received: from oc7455500831.ibm.com (unknown [9.171.28.118])
        by d06av23.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Tue, 13 Apr 2021 08:32:59 +0000 (GMT)
Subject: Re: [PATCH v2 0/3] KVM: Properly account for guest CPU time
To:     Wanpeng Li <kernellwp@gmail.com>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Michael Tokarev <mjt@tls.msk.ru>
References: <1618298169-3831-1-git-send-email-wanpengli@tencent.com>
From:   Christian Borntraeger <borntraeger@de.ibm.com>
Message-ID: <76aa7dcc-ba57-f12d-bf19-880fa71f429f@de.ibm.com>
Date:   Tue, 13 Apr 2021 10:32:59 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.9.0
In-Reply-To: <1618298169-3831-1-git-send-email-wanpengli@tencent.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: 5hr-l3q1hOV6VZnSkK6fZ5ICd8UFpN4g
X-Proofpoint-ORIG-GUID: gr05uOpjtFFEiy3n2Ir3Us5sLnazPonJ
Content-Transfer-Encoding: 7bit
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.761
 definitions=2021-04-13_03:2021-04-13,2021-04-13 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 phishscore=0 mlxscore=0
 malwarescore=0 adultscore=0 bulkscore=0 mlxlogscore=999 impostorscore=0
 clxscore=1015 priorityscore=1501 spamscore=0 suspectscore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104060000 definitions=main-2104130058
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 13.04.21 09:16, Wanpeng Li wrote:
> The bugzilla https://bugzilla.kernel.org/show_bug.cgi?id=209831
> reported that the guest time remains 0 when running a while true
> loop in the guest.
> 
> The commit 87fa7f3e98a131 ("x86/kvm: Move context tracking where it
> belongs") moves guest_exit_irqoff() close to vmexit breaks the
> tick-based time accouting when the ticks that happen after IRQs are
> disabled are incorrectly accounted to the host/system time. This is
> because we exit the guest state too early.
> 
> This patchset splits both context tracking logic and the time accounting
> logic from guest_enter/exit_irqoff(), keep context tracking around the
> actual vmentry/exit code, have the virt time specific helpers which
> can be placed at the proper spots in kvm. In addition, it will not
> break the world outside of x86.
> 
> v1 -> v2:
>   * split context_tracking from guest_enter/exit_irqoff
>   * provide separate vtime accounting functions for consistent
>   * place the virt time specific helpers at the proper splot
> 
> Suggested-by: Thomas Gleixner <tglx@linutronix.de>
> Cc: Thomas Gleixner <tglx@linutronix.de>
> Cc: Sean Christopherson <seanjc@google.com>
> Cc: Michael Tokarev <mjt@tls.msk.ru>
> 
> Wanpeng Li (3):
>    context_tracking: Split guest_enter/exit_irqoff
>    context_tracking: Provide separate vtime accounting functions
>    x86/kvm: Fix vtime accounting
> 
>   arch/x86/kvm/svm/svm.c           |  6 ++-
>   arch/x86/kvm/vmx/vmx.c           |  6 ++-
>   arch/x86/kvm/x86.c               |  1 +
>   include/linux/context_tracking.h | 84 +++++++++++++++++++++++++++++++---------
>   4 files changed, 74 insertions(+), 23 deletions(-)
> 

The non CONFIG_VIRT_CPU_ACCOUNTING_GEN look good.
