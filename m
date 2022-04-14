Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7EFCE500829
	for <lists+kvm@lfdr.de>; Thu, 14 Apr 2022 10:19:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240763AbiDNIWP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 14 Apr 2022 04:22:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59880 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240758AbiDNIWN (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 14 Apr 2022 04:22:13 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5FA78E092
        for <kvm@vger.kernel.org>; Thu, 14 Apr 2022 01:19:48 -0700 (PDT)
Received: from pps.filterd (m0098404.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 23E7kdsA012012;
        Thu, 14 Apr 2022 08:19:41 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=pp1;
 bh=e55QwbMZXK91Zj4nMLQrcAMzyrRss+nk5fU2bobMkdo=;
 b=d0BnIVZLuO4SE6tMSceGYagZSXFwefb6shtsrnps1G68xKxH6rbS1WcamSlmWtxYXTK2
 WwXYE/d6EyDITJ75wfHbpn+isZWCN6KCjGbHKDViJg/AVdkahW3w6peBy83HMidBkwPX
 uJFqHYSO5cyTVRtT1BgvQGUzgJoTDPT2ZkWTQ/g5RrY47tlqfh0ZlTnhAzx6y2D3HsIm
 xYpmZEIWYvFhLHqA4BV+fA8xjhP5b8OHuNvjTCF0x0gPxXWMMU84mwlCtHlKqxKbgHPG
 GB8Ml58Oc27MI9uRMaSx7yE3wRxiSy2Xzw55PO//0PN8a1u0yiICMcWSPQ4iJWfQX4W1 3w== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3fefh50hgg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 14 Apr 2022 08:19:41 +0000
Received: from m0098404.ppops.net (m0098404.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 23E7wsSF021872;
        Thu, 14 Apr 2022 08:19:40 GMT
Received: from ppma02dal.us.ibm.com (a.bd.3ea9.ip4.static.sl-reverse.com [169.62.189.10])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3fefh50hg7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 14 Apr 2022 08:19:40 +0000
Received: from pps.filterd (ppma02dal.us.ibm.com [127.0.0.1])
        by ppma02dal.us.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 23E8CBpB024015;
        Thu, 14 Apr 2022 08:19:39 GMT
Received: from b01cxnp22036.gho.pok.ibm.com (b01cxnp22036.gho.pok.ibm.com [9.57.198.26])
        by ppma02dal.us.ibm.com with ESMTP id 3fb1sa7fyg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 14 Apr 2022 08:19:39 +0000
Received: from b01ledav003.gho.pok.ibm.com (b01ledav003.gho.pok.ibm.com [9.57.199.108])
        by b01cxnp22036.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 23E8Jc1D7537370
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 14 Apr 2022 08:19:38 GMT
Received: from b01ledav003.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id C6E7DB2066;
        Thu, 14 Apr 2022 08:19:38 +0000 (GMT)
Received: from b01ledav003.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 2441FB2065;
        Thu, 14 Apr 2022 08:19:37 +0000 (GMT)
Received: from [9.160.177.197] (unknown [9.160.177.197])
        by b01ledav003.gho.pok.ibm.com (Postfix) with ESMTP;
        Thu, 14 Apr 2022 08:19:36 +0000 (GMT)
Message-ID: <462cbf77-432a-c09c-6ec9-91556dc0f887@linux.ibm.com>
Date:   Thu, 14 Apr 2022 11:19:35 +0300
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.0
Subject: Re: adding 'official' way to dump SEV VMSA
Content-Language: en-US
To:     Cole Robinson <crobinso@redhat.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>
Cc:     qemu-devel <qemu-devel@nongnu.org>,
        "Singh, Brijesh" <brijesh.singh@amd.com>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        "Daniel P. Berrange" <berrange@redhat.com>,
        "Dr. David Alan Gilbert" <dgilbert@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Dov Murik <dovmurik@linux.ibm.com>
References: <a713533d-c4c5-2237-58d0-57b812a56ba4@redhat.com>
From:   Dov Murik <dovmurik@linux.ibm.com>
In-Reply-To: <a713533d-c4c5-2237-58d0-57b812a56ba4@redhat.com>
Content-Type: text/plain; charset=UTF-8
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: E1sVJig55v5buFZG-9zx5qt95Jla0gGh
X-Proofpoint-ORIG-GUID: j_f3MH5H-n0LS9WYzrIJXbifu2cbOyTS
Content-Transfer-Encoding: 7bit
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.858,Hydra:6.0.486,FMLib:17.11.64.514
 definitions=2022-04-14_02,2022-04-13_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 suspectscore=0 mlxscore=0
 malwarescore=0 adultscore=0 priorityscore=1501 bulkscore=0 spamscore=0
 clxscore=1011 lowpriorityscore=0 impostorscore=0 phishscore=0
 mlxlogscore=906 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2204140044
X-Spam-Status: No, score=-4.5 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_MSPIKE_H4,
        RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Cole,

On 13/04/2022 16:36, Cole Robinson wrote:
> Hi all,
> 
> SEV-ES and SEV-SNP attestation require a copy of the initial VMSA to
> validate the launch measurement. For developers dipping their toe into
> SEV-* work, the easiest way to get sample VMSA data for their machine is
> to grab it from a running VM.
> 
> There's two techniques I've seen for that: patch some printing into
> kernel __sev_launch_update_vmsa, or use systemtap like danpb's script
> here: https://gitlab.com/berrange/libvirt/-/blob/lgtm/scripts/sev-vmsa.stp
> 
> Seems like this could be friendlier though. I'd like to work on this if
> others agree.
> 
> Some ideas I've seen mentioned in passing:
> 
> - debugfs entry in /sys/kernel/debug/kvm/.../vcpuX/
> - new KVM ioctl
> - something with tracepoints
> - some kind of dump in dmesg that doesn't require a patch
> 
> Thoughts?


Brijesh suggested to me to construct the VMSA without getting any info from
the host (except number of vcpus), because the initial state of the vcpus
is standard and known if you use QEMU and OVMF (but that's open for discussion).

I took his approach (thanks Brijesh!) and now it's how we calculate expected
SNP measurements in sev-snp-measure [1].  The relevant part for VMSA construction
is in [2].

I plan to add SEV-ES and SEV measurements calculation to this 
library/program as well.


[1] https://github.com/IBM/sev-snp-measure
[2] https://github.com/IBM/sev-snp-measure/blob/main/sevsnpmeasure/vmsa.py

-Dov
