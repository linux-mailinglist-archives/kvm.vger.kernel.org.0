Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3A938B40DF
	for <lists+kvm@lfdr.de>; Mon, 16 Sep 2019 21:13:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387635AbfIPTM6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 16 Sep 2019 15:12:58 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:45744 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727826AbfIPTM5 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 16 Sep 2019 15:12:57 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x8GJ42KZ107360;
        Mon, 16 Sep 2019 19:12:34 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2019-08-05;
 bh=gvt9vaL0HhwDCG2hWsQ5OG4dj5Awj7JnO+aUu1HeGcc=;
 b=UZX0dRCa1dFiepvUvbmGc95pSbXcXmq/YRdRCXz62hxeYoS9RsUN6sTChXYTHyHql+2p
 SnavCWmCXuGP+GsJ+zq10ra+xWVkrV3LG3Rl9G3paER1VeM5Blx9iUavNt4cTmzarP/7
 +yvQ14tkY+yo2qPzbHJz63Pp5M1iNHv7pACSwJxLbaFCQnk4AkaDLw5JBIvLMYTbXTxm
 cc1T4AaK1q5Yf7GA8jX3Sa6fdjg/PtGg5GsRtDDMD8VSv+BPPwo0hEUgAAfCDb1VS3iM
 sJydcO86o3YUZLnSXMqN1QVFViKh+bl98Su/uKLQIFbhwA1DyGiPfNYJDRgDwLHpbKz4 Wg== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2120.oracle.com with ESMTP id 2v0ruqhhaa-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 16 Sep 2019 19:12:34 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x8GJ8wh3041491;
        Mon, 16 Sep 2019 19:12:33 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userp3030.oracle.com with ESMTP id 2v0nb57j51-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 16 Sep 2019 19:12:33 +0000
Received: from abhmp0010.oracle.com (abhmp0010.oracle.com [141.146.116.16])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x8GJCWM1003338;
        Mon, 16 Sep 2019 19:12:32 GMT
Received: from dhcp-10-132-91-76.usdhcp.oraclecorp.com (/10.132.91.76)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 16 Sep 2019 12:12:31 -0700
Subject: Re: [PATCH 3/4] kvm-unit-test: nVMX: __enter_guest() should not set
 "launched" state when VM-entry fails
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     kvm@vger.kernel.org, rkrcmar@redhat.com, pbonzini@redhat.com,
        jmattson@google.com
References: <20190829205635.20189-1-krish.sadhukhan@oracle.com>
 <20190829205635.20189-4-krish.sadhukhan@oracle.com>
 <20190904154231.GB24079@linux.intel.com>
 <a2268863-e554-4547-5196-3509bda3ace3@oracle.com>
 <20190913210645.GA14482@linux.intel.com>
From:   Krish Sadhukhan <krish.sadhukhan@oracle.com>
Message-ID: <eb89a9f8-125f-79c6-e9f3-b59187ea3a35@oracle.com>
Date:   Mon, 16 Sep 2019 12:12:31 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:52.0) Gecko/20100101
 Thunderbird/52.4.0
MIME-Version: 1.0
In-Reply-To: <20190913210645.GA14482@linux.intel.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9382 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=3 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1908290000 definitions=main-1909160186
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9382 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=3 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1908290000
 definitions=main-1909160186
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 09/13/2019 02:06 PM, Sean Christopherson wrote:
> On Fri, Sep 13, 2019 at 01:37:55PM -0700, Krish Sadhukhan wrote:
>> On 9/4/19 8:42 AM, Sean Christopherson wrote:
>>> On Thu, Aug 29, 2019 at 04:56:34PM -0400, Krish Sadhukhan wrote:
>>>> Bit# 31 in VM-exit reason is set by hardware in both cases of early VM-entry
>>>> failures and VM-entry failures due to invalid guest state.
>>> This is incorrect, VMCS.EXIT_REASON is not written on a VM-Fail.  If the
>>> tests are passing, you're probably consuming a stale EXIT_REASON.
>> In vmx_vcpu_run(),
>>
>>          if (vmx->fail || (vmx->exit_reason &
>> VMX_EXIT_REASONS_FAILED_VMENTRY))
>>                  return;
>>
>>          vmx->loaded_vmcs->launched = 1;
>>
>> we return without setting "launched" whenever bit# 31 is set in Exit Reason.
>> If VM-entry fails due to invalid guest state or due to errors in VM-entry
>> MSR-loading area, bit#31 is set.  As a result, L2 is not in "launched" state
>> when we return to L1.  Tests that want to VMRESUME L2 after fixing the bad
>> guest state or the bad MSR-loading area, fail with VM-Instruction Error 5,
>>
>>          "Early vmresume failure: error number is 5. See Intel 30.4."
> Yes, a VMCS isn't marked launched if it generates a VM-Exit due to a
> failed consistency check.  But as that code shows, a failed consistency
> check results in said VM-Exit *or* a VM-Fail.  Cosnsitency checks that
> fail early, i.e. before loading guest state, generate VM-Fail, any check
> that fails after the CPU has started loading guest state manifests as a
> VM-Exit.  VMCS.EXIT_REASON isn't touched in the VM-Fail case.
>
> E.g. in CHECKS ON VMX CONTROLS AND HOST-STATE AREA, the SDM states:
>
>    VM entry fails if any of these checks fail.  When such failures occur,
>    control is passed to the next instruction, RFLAGS.ZF is set to 1 to
>    indicate the failure, and the VM-instruction error field is loaded with
>    an error number that indicates whether the failure was due to the
>    controls or the host-state area (see Chapter 30).

The fix done by Marc Orr in

         "[kvm-unit-tests PATCH v2] x86: nvmx: test max atomic switch MSRs"

fixes this problem.
