Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7C0B8358B97
	for <lists+kvm@lfdr.de>; Thu,  8 Apr 2021 19:43:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232377AbhDHRoA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 8 Apr 2021 13:44:00 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:42272 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S231566AbhDHRn7 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 8 Apr 2021 13:43:59 -0400
Received: from pps.filterd (m0098416.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 138HXY9U106869;
        Thu, 8 Apr 2021 13:43:45 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : subject :
 from : reply-to : to : cc : date : in-reply-to : references : content-type
 : mime-version : content-transfer-encoding; s=pp1;
 bh=kqLUOibyhUwhuOKheUsaVeuC3WX6qO/UlKgURP8z3mU=;
 b=EGs51LcpoKr9wZ4w/fdAPtf9PGdG3YGtHNsidPuY0nQ7jFCYD7IjVbqrCYKdUZCE7H8f
 wKMbagkILbwV8V5LgeFCYdWEIr1Ld1/sXQXVT2XJrRezb3lzz/T3yBRBDlTZQKQwEpc4
 gnD0IphqtUnOtwMw8g2miUdIUdCjfohJN+a76k/x5+BebjUpF700uT0k56b1ZJtHyDGO
 5Jl6n2DJExGDVSOZ5EFW6D3EukdPan7PpcgCZpqd4H4nmgKiXHnTOUTaKu/ZEYqhTmpL
 jxQW7g3u8r+1y3bo70MjQ8y/CnjcEURaXlq7VGqdPAYOcTFn4x40OTh1KhI6HTMLHkKf Sw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 37rwf1qcrx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 08 Apr 2021 13:43:45 -0400
Received: from m0098416.ppops.net (m0098416.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 138HXbjb107039;
        Thu, 8 Apr 2021 13:43:45 -0400
Received: from ppma04dal.us.ibm.com (7a.29.35a9.ip4.static.sl-reverse.com [169.53.41.122])
        by mx0b-001b2d01.pphosted.com with ESMTP id 37rwf1qcrk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 08 Apr 2021 13:43:45 -0400
Received: from pps.filterd (ppma04dal.us.ibm.com [127.0.0.1])
        by ppma04dal.us.ibm.com (8.16.0.43/8.16.0.43) with SMTP id 138Hhipd006738;
        Thu, 8 Apr 2021 17:43:44 GMT
Received: from b03cxnp07027.gho.boulder.ibm.com (b03cxnp07027.gho.boulder.ibm.com [9.17.130.14])
        by ppma04dal.us.ibm.com with ESMTP id 37rvc4aaxh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 08 Apr 2021 17:43:44 +0000
Received: from b03ledav004.gho.boulder.ibm.com (b03ledav004.gho.boulder.ibm.com [9.17.130.235])
        by b03cxnp07027.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 138Hhgli23658798
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 8 Apr 2021 17:43:42 GMT
Received: from b03ledav004.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id A087E7805E;
        Thu,  8 Apr 2021 17:43:42 +0000 (GMT)
Received: from b03ledav004.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 3EDC17805C;
        Thu,  8 Apr 2021 17:43:39 +0000 (GMT)
Received: from jarvis.int.hansenpartnership.com (unknown [9.85.189.52])
        by b03ledav004.gho.boulder.ibm.com (Postfix) with ESMTP;
        Thu,  8 Apr 2021 17:43:39 +0000 (GMT)
Message-ID: <936fa1e7755687981bdbc3bad9ecf2354c748381.camel@linux.ibm.com>
Subject: Re: [RFC v2] KVM: x86: Support KVM VMs sharing SEV context
From:   James Bottomley <jejb@linux.ibm.com>
Reply-To: jejb@linux.ibm.com
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Ashish Kalra <ashish.kalra@amd.com>,
        Nathan Tempelman <natet@google.com>
Cc:     thomas.lendacky@amd.com, x86@kernel.org, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, srutherford@google.com,
        seanjc@google.com, rientjes@google.com, brijesh.singh@amd.com,
        dovmurik@linux.vnet.ibm.com, lersek@redhat.com, frankeh@us.ibm.com
Date:   Thu, 08 Apr 2021 10:43:37 -0700
In-Reply-To: <87bdd3a6-f5eb-91e4-9442-97dfef231640@redhat.com>
References: <20210316014027.3116119-1-natet@google.com>
         <20210402115813.GB17630@ashkalra_ubuntu_server>
         <87bdd3a6-f5eb-91e4-9442-97dfef231640@redhat.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.34.4 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: 9p72LhukfUR3FxXlfP-qIRKLLGEn7zHs
X-Proofpoint-ORIG-GUID: Ozv8vcGwL_F7LkToS5aTi5Rbk6Gft_mR
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.761
 definitions=2021-04-08_04:2021-04-08,2021-04-08 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1011 bulkscore=0
 malwarescore=0 impostorscore=0 phishscore=0 suspectscore=0
 lowpriorityscore=0 priorityscore=1501 mlxlogscore=999 mlxscore=0
 spamscore=0 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104060000 definitions=main-2104080117
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, 2021-04-02 at 16:20 +0200, Paolo Bonzini wrote:
> On 02/04/21 13:58, Ashish Kalra wrote:
> > Hi Nathan,
> > 
> > Will you be posting a corresponding Qemu patch for this ?
> 
> Hi Ashish,
> 
> as far as I know IBM is working on QEMU patches for guest-based 
> migration helpers.

Yes, that's right, we'll take on this part.

> However, it would be nice to collaborate on the low-level (SEC/PEI) 
> firmware patches to detect whether a CPU is part of the primary VM
> or the mirror.  If Google has any OVMF patches already done for that,
> it would be great to combine it with IBM's SEV migration code and
> merge it into upstream OVMF.

We've reached the stage with our prototyping where not having the OVMF
support is blocking us from working on QEMU.  If we're going to have to
reinvent the wheel in OVMF because Google is unwilling to publish the
patches, can you at least give some hints about how you did it?

Thanks,

James


