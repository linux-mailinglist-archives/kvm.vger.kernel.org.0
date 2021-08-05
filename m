Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6157F3E0F53
	for <lists+kvm@lfdr.de>; Thu,  5 Aug 2021 09:35:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232323AbhHEHfh (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 5 Aug 2021 03:35:37 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:15862 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230471AbhHEHfg (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 5 Aug 2021 03:35:36 -0400
Received: from pps.filterd (m0098410.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 1757Wv1E089820;
        Thu, 5 Aug 2021 03:35:19 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : reply-to : references : content-type : in-reply-to
 : mime-version; s=pp1; bh=wJq0ybxY7L2Dl7sNEaUtoMo0Eyb6m2cp1YW6q5Z54gU=;
 b=H0nVLr8LQZypL1kZPu6OSW+wIgOPQGzkEMaVET0BPtRs36rHSVlbDFKDWbMFBRlSKtcs
 BLD3sedJEoTkDaZ79PjX7HngtDImbarPGUHj7KAOe8/kQ2pPrMUz1nri/S/J/sj/P/oH
 Yse/HGmUY93o2A37PjbSvNBR9qWrO5IsfIsbePXz+xw40Z4BF5re15XL1fGNbJ93dHCE
 z8HiRc0ZXu5cE9R/zBKfL0RyCUhRP6BhGrW8YaqIZQno0bqlYtug3IyTV+N+AWG+VaMJ
 0+Pge5rCOKk2lsEbIqmNer1VPjWLlbz9yzQbp07HWCzCAqdfFID7mFB24Eg2846sJIlS wQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3a88k2mphv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 05 Aug 2021 03:35:19 -0400
Received: from m0098410.ppops.net (m0098410.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 1757Ww2T089927;
        Thu, 5 Aug 2021 03:35:19 -0400
Received: from ppma06ams.nl.ibm.com (66.31.33a9.ip4.static.sl-reverse.com [169.51.49.102])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3a88k2mph2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 05 Aug 2021 03:35:19 -0400
Received: from pps.filterd (ppma06ams.nl.ibm.com [127.0.0.1])
        by ppma06ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 1757Rhri027416;
        Thu, 5 Aug 2021 07:35:16 GMT
Received: from b06cxnps3074.portsmouth.uk.ibm.com (d06relay09.portsmouth.uk.ibm.com [9.149.109.194])
        by ppma06ams.nl.ibm.com with ESMTP id 3a4wshtscu-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 05 Aug 2021 07:35:16 +0000
Received: from d06av21.portsmouth.uk.ibm.com (d06av21.portsmouth.uk.ibm.com [9.149.105.232])
        by b06cxnps3074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 1757ZDHR51118428
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 5 Aug 2021 07:35:14 GMT
Received: from d06av21.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 48CA452078;
        Thu,  5 Aug 2021 07:35:13 +0000 (GMT)
Received: from in.ibm.com (unknown [9.102.2.73])
        by d06av21.portsmouth.uk.ibm.com (Postfix) with ESMTPS id E411E52071;
        Thu,  5 Aug 2021 07:35:11 +0000 (GMT)
Date:   Thu, 5 Aug 2021 13:05:05 +0530
From:   Bharata B Rao <bharata@linux.ibm.com>
To:     kvm-ppc@vger.kernel.org, linuxppc-dev@lists.ozlabs.org
Cc:     kvm@vger.kernel.org, aneesh.kumar@linux.ibm.com,
        bharata.rao@gmail.com
Subject: Re: [RFC PATCH v0 0/5] PPC: KVM: pseries: Asynchronous page fault
Message-ID: <YQuUqfn3OV/qDI8U@in.ibm.com>
Reply-To: bharata@linux.ibm.com
References: <20210805072439.501481-1-bharata@linux.ibm.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210805072439.501481-1-bharata@linux.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: dQ4IEPT42jF3YzuN81mh3vm9kpjOAXjI
X-Proofpoint-GUID: 8i40YJ0Hs5Hj8XuZpk9WumIFaqEKVr7D
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.790
 definitions=2021-08-05_02:2021-08-04,2021-08-05 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 spamscore=0 mlxlogscore=911
 clxscore=1015 adultscore=0 bulkscore=0 lowpriorityscore=0 suspectscore=0
 impostorscore=0 mlxscore=0 malwarescore=0 phishscore=0 priorityscore=1501
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2107140000
 definitions=main-2108050044
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Aug 05, 2021 at 12:54:34PM +0530, Bharata B Rao wrote:
> Hi,
> 
> This series adds asynchronous page fault support for pseries guests
> and enables the support for the same in powerpc KVM. This is an
> early RFC with details and multiple TODOs listed in patch descriptions.
> 
> This patch needs supporting enablement in QEMU too which will be
> posted separately.

QEMU part is posted here:
https://lore.kernel.org/qemu-devel/20210805073228.502292-2-bharata@linux.ibm.com/T/#u

Regards,
Bharata.
