Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 70B7AF7744
	for <lists+kvm@lfdr.de>; Mon, 11 Nov 2019 16:00:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727053AbfKKPAE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 11 Nov 2019 10:00:04 -0500
Received: from userp2120.oracle.com ([156.151.31.85]:43808 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726889AbfKKPAE (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 11 Nov 2019 10:00:04 -0500
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xABEmWGv112053;
        Mon, 11 Nov 2019 14:58:58 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2019-08-05;
 bh=1jnX9HpcVQknCfLmGyOsenv7IEm66pdG6vlcej/LMVs=;
 b=cxZDrUzlGrCFvkwBf0SfMOnz3JYfaCnhGNZ33AmIOawW3qu7+bM+2A81ituwLEPzhMFH
 qCkXbuJ3tQ1FEp8oPxq57ZlN3pyprbe7I/2aLmXCyTXmRnZHvE2KZLXYpNvHljt2ogOh
 j2XP11b21aLqzYCPMI4iyztvSQUsc4o8WvTeyjTGBaOUm9+WbL3QXRmNeqJz3NnbZgzj
 l8Tjt2EafCggUsG8RAs+DCJG2kQieJPE6v5Fw/2E0ot2oRXGQ/2Kk9cFTQ6InugByuFx
 2fK7bTNqY9f0ShL0p+Q0keiKBQrx4xdduEpkrtGfKm9TpF6TPlhApwPjYelzaZfoMkTH nA== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2120.oracle.com with ESMTP id 2w5p3qfbdx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 11 Nov 2019 14:58:58 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xABEmYsv125174;
        Mon, 11 Nov 2019 14:56:57 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserp3020.oracle.com with ESMTP id 2w66yxx0bg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 11 Nov 2019 14:56:57 +0000
Received: from abhmp0002.oracle.com (abhmp0002.oracle.com [141.146.116.8])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id xABEutqc027298;
        Mon, 11 Nov 2019 14:56:55 GMT
Received: from [10.175.169.52] (/10.175.169.52)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 11 Nov 2019 14:56:55 +0000
Subject: Re: [PATCH v1 2/3] KVM: VMX: Do not change PID.NDST when loading a
 blocked vCPU
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        =?UTF-8?B?UmFkaW0gS3LEjW3DocWZ?= <rkrcmar@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Liran Alon <liran.alon@oracle.com>,
        Jag Raman <jag.raman@oracle.com>
References: <20191106175602.4515-1-joao.m.martins@oracle.com>
 <20191106175602.4515-3-joao.m.martins@oracle.com>
 <15c8c821-25ff-eb62-abd3-8d7d69650744@redhat.com>
 <314a4120-036c-e954-bc9f-e57dee3bbb7c@oracle.com>
 <49912d14-1f79-2658-9471-4193807ad667@redhat.com>
From:   Joao Martins <joao.m.martins@oracle.com>
Message-ID: <b61dc2b2-14be-4d4f-f512-5280010d930a@oracle.com>
Date:   Mon, 11 Nov 2019 14:56:50 +0000
MIME-Version: 1.0
In-Reply-To: <49912d14-1f79-2658-9471-4193807ad667@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9437 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=2 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=981
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1910280000 definitions=main-1911110137
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9437 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=2 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1910280000
 definitions=main-1911110137
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 11/11/19 2:50 PM, Paolo Bonzini wrote:
> On 11/11/19 15:48, Joao Martins wrote:
>>>>
>>>> Fixes: c112b5f50232 ("KVM: x86: Recompute PID.ON when clearing PID.SN")
>>>> Signed-off-by: Joao Martins <joao.m.martins@oracle.com>
>>>> Signed-off-by: Liran Alon <liran.alon@oracle.com>
>>> Something wrong in the SoB line?
>>>
>> I can't spot any mistake; at least it looks chained correctly for me. What's the
>> issue you see with the Sob line?
> 
> Liran's line after yours is confusing.  Did he help with the analysis or
> anything like that?
> 
He was initially reviewing my patches, but then helped improving the problem
description in the commit messages so felt correct to give credit.

	Joao
