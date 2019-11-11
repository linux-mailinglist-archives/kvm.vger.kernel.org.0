Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A06DFF79EF
	for <lists+kvm@lfdr.de>; Mon, 11 Nov 2019 18:29:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726928AbfKKR3B (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 11 Nov 2019 12:29:01 -0500
Received: from userp2130.oracle.com ([156.151.31.86]:48548 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726845AbfKKR3A (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 11 Nov 2019 12:29:00 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xABHPVFe077366;
        Mon, 11 Nov 2019 17:28:09 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2019-08-05;
 bh=WlxVxKiBr49y4SsqPlWfm5cHZY1cE9jd8M0a28PEqNk=;
 b=Mz5fSnaVVh/Jxse98mVsZB+d77X0IfUciewQJcCvtqcMCnsXDWDz+7BAkafki3Ob/LSF
 cIc0Lq+XWBuB4GiPn+PsiTPxwaAQyhe2P0wjz5xdFSf/+d+J7DRASqceeS/tj8wL3fk/
 YWUkvZ1WbU3BgLPuGaRGe6oqDPpDHnBbgmayHxxT7oE9avpM65sRgigvWVRtBUyxb2Zx
 +sVCqPFxqZ7NPU1+f5pIAQuBGOvSr6fBEUyNLfY28uxN9B1b4Bz+3U9+WTASm0yfuqLr
 +AW0pl/vHFA1440Py+jSOTSy9lj2aG2F40Cchd380ZMZCa3ra/2G+lV6WvJ+JPI3dKIw qg== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2130.oracle.com with ESMTP id 2w5mvtg7vs-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 11 Nov 2019 17:28:09 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xABHEp6p067937;
        Mon, 11 Nov 2019 17:28:08 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userp3030.oracle.com with ESMTP id 2w66wmfwbg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 11 Nov 2019 17:28:08 +0000
Received: from abhmp0017.oracle.com (abhmp0017.oracle.com [141.146.116.23])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id xABHS51e023060;
        Mon, 11 Nov 2019 17:28:05 GMT
Received: from [10.175.169.52] (/10.175.169.52)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 11 Nov 2019 09:28:05 -0800
Subject: Re: [PATCH v1 2/3] KVM: VMX: Do not change PID.NDST when loading a
 blocked vCPU
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     Liran Alon <liran.alon@oracle.com>,
        Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        =?UTF-8?B?UmFkaW0gS3LEjW3DocWZ?= <rkrcmar@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Jag Raman <jag.raman@oracle.com>
References: <20191106175602.4515-1-joao.m.martins@oracle.com>
 <20191106175602.4515-3-joao.m.martins@oracle.com>
 <15c8c821-25ff-eb62-abd3-8d7d69650744@redhat.com>
 <314a4120-036c-e954-bc9f-e57dee3bbb7c@oracle.com>
 <49912d14-1f79-2658-9471-4193807ad667@redhat.com>
 <b61dc2b2-14be-4d4f-f512-5280010d930a@oracle.com>
 <4E05E5FC-0064-47DE-B4B2-B3BDAF23C072@oracle.com>
 <20191111155349.GA11725@linux.intel.com>
From:   Joao Martins <joao.m.martins@oracle.com>
Message-ID: <946be6b4-3b8b-e89d-c3e5-18fd7b714a7f@oracle.com>
Date:   Mon, 11 Nov 2019 17:27:57 +0000
MIME-Version: 1.0
In-Reply-To: <20191111155349.GA11725@linux.intel.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9438 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=2 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=904
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1910280000 definitions=main-1911110155
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9438 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=2 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=971 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1910280000
 definitions=main-1911110155
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 11/11/19 3:53 PM, Sean Christopherson wrote:
> On Mon, Nov 11, 2019 at 04:59:20PM +0200, Liran Alon wrote:
>>
>>
>>> On 11 Nov 2019, at 16:56, Joao Martins <joao.m.martins@oracle.com> wrote:
>>>
>>> On 11/11/19 2:50 PM, Paolo Bonzini wrote:
>>>> On 11/11/19 15:48, Joao Martins wrote:
>>>>>>>
>>>>>>> Fixes: c112b5f50232 ("KVM: x86: Recompute PID.ON when clearing PID.SN")
>>>>>>> Signed-off-by: Joao Martins <joao.m.martins@oracle.com>
>>>>>>> Signed-off-by: Liran Alon <liran.alon@oracle.com>
>>>>>> Something wrong in the SoB line?
>>>>>>
>>>>> I can't spot any mistake; at least it looks chained correctly for me. What's the
>>>>> issue you see with the Sob line?
>>>>
>>>> Liran's line after yours is confusing.  Did he help with the analysis or
>>>> anything like that?
>>>>
>>> He was initially reviewing my patches, but then helped improving the problem
>>> description in the commit messages so felt correct to give credit.
>>>
>>> 	Joao
>>
>> I think proper action is to just remove me from the SoB line.
> 
> Use Co-developed-by to attribute multiple authors.  Note, the SoB ordering
> should show the chronological history of the patch when possible, e.g. the
> person sending the patch should always have their SoB last.
> 
> Documentation/process/submitting-patches.rst and 
> Documentation/process/5.Posting.rst have more details.
> 
The Sob chain on the first two patches were broken (regardless of any use of
Co-developed-by). Fixed it up on v2, alongside the rest of the comments.

Cheers,
	Joao
