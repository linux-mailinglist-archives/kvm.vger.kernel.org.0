Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 48402366552
	for <lists+kvm@lfdr.de>; Wed, 21 Apr 2021 08:22:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235219AbhDUGWg (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 21 Apr 2021 02:22:36 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:24730 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234885AbhDUGWf (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 21 Apr 2021 02:22:35 -0400
Received: from pps.filterd (m0098399.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 13L63DH9156056;
        Wed, 21 Apr 2021 02:20:51 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=k/ieIyBolTpgcqF80f+tfdYQROMaFCUvrc+rfvOenpk=;
 b=gyRTR6kI6iaRS3hLKpw9QsJJOvYcSRxTokbmbA9i2AayY8oTZWRp4Oymmx/GMAsXjS23
 c2AyUJTy2k3XGgcNPMZQNJ8XAWUotby8bohcHdYBzDx+DdkHhyLlsruJ/O6m6LxttpsH
 u/0BIy/teGYUAnWkr01VEydKrQHRvXvjk6s4bPoBUJxWMyW3ee9bRXXmwyv5XTrvYWcJ
 dtbteb1KVihYDK5zAwjHsiym1oyOB8rhQctz05Gd2woe0XLbxD5XqcFFLWfQuZFBHPjq
 saRKKndET+fUT4sSGmQNd/rdZNZ7ROA7mOWegWqVo0sy24DDiRg0u0acgcA0gQgq3hEu 2Q== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3829u3x3fd-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 21 Apr 2021 02:20:51 -0400
Received: from m0098399.ppops.net (m0098399.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 13L63R6L157826;
        Wed, 21 Apr 2021 02:20:51 -0400
Received: from ppma06fra.de.ibm.com (48.49.7a9f.ip4.static.sl-reverse.com [159.122.73.72])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3829u3x3ep-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 21 Apr 2021 02:20:51 -0400
Received: from pps.filterd (ppma06fra.de.ibm.com [127.0.0.1])
        by ppma06fra.de.ibm.com (8.16.0.43/8.16.0.43) with SMTP id 13L6KmQb017957;
        Wed, 21 Apr 2021 06:20:48 GMT
Received: from b06cxnps4074.portsmouth.uk.ibm.com (d06relay11.portsmouth.uk.ibm.com [9.149.109.196])
        by ppma06fra.de.ibm.com with ESMTP id 37ypxh95cj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 21 Apr 2021 06:20:48 +0000
Received: from d06av26.portsmouth.uk.ibm.com (d06av26.portsmouth.uk.ibm.com [9.149.105.62])
        by b06cxnps4074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 13L6KkTY43319570
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 21 Apr 2021 06:20:46 GMT
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 35A90AE056;
        Wed, 21 Apr 2021 06:20:46 +0000 (GMT)
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 4B256AE045;
        Wed, 21 Apr 2021 06:20:42 +0000 (GMT)
Received: from [9.199.37.21] (unknown [9.199.37.21])
        by d06av26.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Wed, 21 Apr 2021 06:20:41 +0000 (GMT)
Subject: Re: [PATCH v5 3/3] ppc: Enable 2nd DAWR support on p10
To:     David Gibson <david@gibson.dropbear.id.au>
Cc:     paulus@samba.org, mpe@ellerman.id.au, mikey@neuling.org,
        pbonzini@redhat.com, mst@redhat.com, clg@kaod.org,
        qemu-ppc@nongnu.org, qemu-devel@nongnu.org, kvm@vger.kernel.org,
        cohuck@redhat.com, groug@kaod.org,
        Ravi Bangoria <ravi.bangoria@linux.ibm.com>
References: <20210412114433.129702-1-ravi.bangoria@linux.ibm.com>
 <20210412114433.129702-4-ravi.bangoria@linux.ibm.com>
 <YH0M1YdINJqbdqP+@yekko.fritz.box>
From:   Ravi Bangoria <ravi.bangoria@linux.ibm.com>
Message-ID: <ca21d852-4b54-01d3-baab-cc8d0d50e505@linux.ibm.com>
Date:   Wed, 21 Apr 2021 11:50:40 +0530
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <YH0M1YdINJqbdqP+@yekko.fritz.box>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: qm7oCdpDo5nWgx59nGfZgRVOX3HoyEP8
X-Proofpoint-ORIG-GUID: 3ZEDxFrrnwHfa3dLMjaN4eAe-b0QXCSY
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.761
 definitions=2021-04-21_02:2021-04-20,2021-04-21 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 phishscore=0 bulkscore=0 lowpriorityscore=0 adultscore=0 clxscore=1015
 spamscore=0 suspectscore=0 mlxscore=0 mlxlogscore=999 malwarescore=0
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104060000 definitions=main-2104210049
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi David,

On 4/19/21 10:23 AM, David Gibson wrote:
> On Mon, Apr 12, 2021 at 05:14:33PM +0530, Ravi Bangoria wrote:
>> As per the PAPR, bit 0 of byte 64 in pa-features property indicates
>> availability of 2nd DAWR registers. i.e. If this bit is set, 2nd
>> DAWR is present, otherwise not. Use KVM_CAP_PPC_DAWR1 capability to
>> find whether kvm supports 2nd DAWR or not. If it's supported, allow
>> user to set the pa-feature bit in guest DT using cap-dawr1 machine
>> capability. Though, watchpoint on powerpc TCG guest is not supported
>> and thus 2nd DAWR is not enabled for TCG mode.
>>
>> Signed-off-by: Ravi Bangoria <ravi.bangoria@linux.ibm.com>
>> Reviewed-by: Greg Kurz <groug@kaod.org>
> 
> So, I'm actually not sure if using an spapr capability is what we want
> to do here.  The problem is that presumably the idea is to at some
> point make the DAWR1 capability default to on (on POWER10, at least).
> But at that point you'll no longer to be able to start TCG guests
> without explicitly disabling it.  That's technically correct, since we
> don't implement DAWR1 in TCG, but then we also don't implement DAWR0
> and we let that slide... which I think is probably going to cause less
> irritation on balance.

Ok. Probably something like this is what you want?

Power10 behavior:
   - KVM does not support DAWR1: Boot the guest without DAWR1
     support (No warnings). Error out only if user tries with
     cap-dawr1=on.
   - KVM supports DAWR1: Boot the guest with DAWR1 support, unless
     user specifies cap-dawr1=off.
   - TCG guest: Ignore cap-dawr1 i.e. boot as if there is only
     DAWR0 (Should be fixed in future while adding PowerPC watch-
     point support in TCG mode)

Power10 predecessor behavior:
   - KVM guest: Boot the guest without DAWR1 support. Error out
     if user tries with cap-dawr1=on.
   - TCG guest: Ignore cap-dawr1 i.e. boot as if there is only
     DAWR0 (Should be fixed in future while adding PowerPC watch-
     point support in TCG mode)

> I'm wondering if we're actually just better off setting the pa feature
> just based on the guest CPU model.  TCG will be broken if you try to
> use it, but then, it already is.  AFAIK there's no inherent reason we
> couldn't implement DAWR support in TCG, it's just never been worth the
> trouble.

Correct. Probably there is no practical usecase for DAWR in TCG mode.

Thanks,
Ravi
