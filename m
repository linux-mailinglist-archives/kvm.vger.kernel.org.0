Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6E74E1AE923
	for <lists+kvm@lfdr.de>; Sat, 18 Apr 2020 03:29:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725843AbgDRB3b (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 17 Apr 2020 21:29:31 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:54656 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725784AbgDRB3b (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 17 Apr 2020 21:29:31 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 03I1S87m078957;
        Sat, 18 Apr 2020 01:29:26 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=fRKzVoHlrp/00MU8+Qn8FpMqHdC34U+t7K9AVT5e0pk=;
 b=ICIxTuNew7eMYoF16Tus9PE3zeuxbr3P6g88xZNMuR68CXrgBBS6PGBGeC8LR3/sdMci
 U7dgNfrmXcw/nSr1470sR4ONVAKUYN6rCXEFCFxa5ZZ7mSVs0Er2pPqTxl8ZkIwB1Rw4
 M+y7yxRDu0sKpi/XHtKlbqQZGSJJHN4GAPSfhQnC9RHXJ49a5PEF5Lh1UpqdMHt6s3Dd
 jU0lmgjMpqwdGVye6Iubl7KOgKVNkFO8mcJiuIASodq/UKCURnFQQw6VOvqvoMchQ7eT
 S0yIrxuWzlmXZ3FQCjTva2BT97RP9t1zBmNGy4XYfxVX7LCeju+6SEMNvS4VAZERsAMq SQ== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2120.oracle.com with ESMTP id 30emejspsg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 18 Apr 2020 01:29:25 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 03I1RvUg110486;
        Sat, 18 Apr 2020 01:29:25 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userp3030.oracle.com with ESMTP id 30fpnqmqu7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 18 Apr 2020 01:29:25 +0000
Received: from abhmp0017.oracle.com (abhmp0017.oracle.com [141.146.116.23])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 03I1TO2c015184;
        Sat, 18 Apr 2020 01:29:24 GMT
Received: from localhost.localdomain (/10.159.153.74)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Fri, 17 Apr 2020 18:29:24 -0700
Subject: Re: [PATCH 1/2 v2] KVM: nVMX: KVM needs to unset "unrestricted guest"
 VM-execution control in vmcs02 if vmcs12 doesn't set it
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Jim Mattson <jmattson@google.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     kvm list <kvm@vger.kernel.org>
References: <20200415183047.11493-1-krish.sadhukhan@oracle.com>
 <20200415183047.11493-2-krish.sadhukhan@oracle.com>
 <20200415193016.GF30627@linux.intel.com>
 <CALMp9eRvZEzi3Ug0fL=ekMS_Weni6npwW+bXrJZjU8iLrppwEg@mail.gmail.com>
 <0b8bd238-e60f-b392-e793-0d88fb876224@redhat.com>
From:   Krish Sadhukhan <krish.sadhukhan@oracle.com>
Message-ID: <d49ce960-92f9-85eb-4cfb-d533a956223e@oracle.com>
Date:   Fri, 17 Apr 2020 18:29:23 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.0
MIME-Version: 1.0
In-Reply-To: <0b8bd238-e60f-b392-e793-0d88fb876224@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9594 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 adultscore=0
 suspectscore=0 phishscore=0 spamscore=0 mlxlogscore=999 bulkscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2004180006
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9594 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 impostorscore=0
 mlxscore=0 suspectscore=0 lowpriorityscore=0 spamscore=0 mlxlogscore=999
 bulkscore=0 adultscore=0 phishscore=0 clxscore=1015 priorityscore=1501
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2003020000
 definitions=main-2004180006
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


On 4/16/20 2:18 AM, Paolo Bonzini wrote:
> On 15/04/20 22:18, Jim Mattson wrote:
>>> Has anyone worked through all the flows to verify this won't break any
>>> assumptions with respect to enable_unrestricted_guest?  I would be
>>> (pleasantly) surprised if this was sufficient to run L2 without
>>> unrestricted guest when it's enabled for L1, e.g. vmx_set_cr0() looks
>>> suspect.
>> I think you're right to be concerned.
> Thirded, but it shouldn't be too hard.  Basically,
> enable_unrestricted_guest must be moved into loaded_vmcs for this to
> work.  It may be more work to write the test cases for L2 real mode <->
> protected mode switch, which do not entirely fit into the vmx_tests.c
> framework (but with the v2 tests it should not be hard to adapt).


OK, I will move enable_unrestricted_guest  to loaded_vmcs.

I also see that enable_ept controls the setting of 
enable_unrestricted_guest. Perhaps both need to be moved to loaded_vmcs ?

About testing, I am thinking the test will first vmlaunch L2 in real 
mode or in protected mode, then vmexit on vmcall and then vmresume in 
the other mode. Is that how the test should flow ?

>
> Paolo
>
