Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 450C547A4C4
	for <lists+kvm@lfdr.de>; Mon, 20 Dec 2021 06:57:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235136AbhLTF5w (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 20 Dec 2021 00:57:52 -0500
Received: from mx0a-002c1b01.pphosted.com ([148.163.151.68]:1204 "EHLO
        mx0a-002c1b01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231863AbhLTF5v (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 20 Dec 2021 00:57:51 -0500
Received: from pps.filterd (m0127838.ppops.net [127.0.0.1])
        by mx0a-002c1b01.pphosted.com (8.16.1.2/8.16.1.2) with ESMTP id 1BJJSUNm025889;
        Sun, 19 Dec 2021 21:57:40 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nutanix.com; h=from : to : cc :
 subject : date : message-id : content-transfer-encoding : content-type :
 mime-version; s=proofpoint20171006;
 bh=nRlBrdzi5aY8G4i0swjYxADfBMlFNlY9jRC/kMNulHc=;
 b=jVZnihRFjYjClO7zFUsYR3p/iDmshRQHrQ72YeXiexWso+nSMXRwAlH2JeRhlTwnCHrZ
 dn83kljBWHtUKGeBCYChIllnICqdAy5J9ZnhwFukf9ijSu1oDWvLATqcThx4SfHR08xM
 gdpl0dNTzZzaZ9z1Ml/GISOOFu8Zba+b8QdXMQvjeQYc559JVXqdn4knfl/5sJ2+P19V
 UflTbRrk13OBEBBCsl+4mX8+1QiCC9m2EW1m3DsEaiXAoJc7yD1UlPirJcB4qAhvbkXe
 Kx0xxgKv5GllLqUb5jzZGFVPs06sWIQ7Z7iXHBCAceEPXgaT4sw9kyw3z9TTor65L2Zp qQ== 
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12lp2048.outbound.protection.outlook.com [104.47.66.48])
        by mx0a-002c1b01.pphosted.com (PPS) with ESMTPS id 3d1g32aj56-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Sun, 19 Dec 2021 21:57:39 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=LYxwHbLrarc7c9MbIfPaC/e6sFMe+yRv8t5x/qQK9vOLRBwrsbvgoFh14O4iTZRNBBfQjMIoukf422xFfOQ0P8xnhvLsAzYM8eg2mct86Rd6V+qOkCY5X5a/UiD3WLb1qdkkWW+qCYny0zQtl38rJCHYak6poqm2lnqfXOT3V99Ewp4Fkk/CjJwQoAjpRww7ME1kZdR1qTX+HL/fa79t5wl78dNVz6rb323PxbKVCgEuQ4wxhdXYq+slvAF/wOf+g+j6XvM0qOPMOQ7MitMqGLjRU5ASVqD4k6iqaA+jDmCX1cwD6JgKwTtQqaz55h87kRStMD0woNgyndMBwYlh4A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=nRlBrdzi5aY8G4i0swjYxADfBMlFNlY9jRC/kMNulHc=;
 b=Y6PRe7JdQFoe/5FAZo/3r8xeug2OoJbfqyuoLm+7frdADmPXw+0jTZJm9Zpaz3g6+9L9S1E2cxhB+WRmxo9jElRFPkjHp52OAdmN0epg+eY6GJqZLBguCL58S0f9C3wzCqD/NrdAwCmY6WAcPWSjyk4RVtvkOzlI3Ynx+LkvKPuMbMCT8YG2x4A8BUlHk8ZiKkbNJul7sgXvpTheorWtqXSo0kQB5e4D9eKdgEXORs/pm3FIgnwq678c3GsMGDi1WVyEIgKwiqMo1H0anQ3/2Yxn2SGlif+NXBQmtjt2SbGBeR8QOyIDwEJPdTFeLPk6VXkPHRSyKkw8fLkO0PeIGQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nutanix.com; dmarc=pass action=none header.from=nutanix.com;
 dkim=pass header.d=nutanix.com; arc=none
Received: from CO6PR02MB7555.namprd02.prod.outlook.com (2603:10b6:303:b3::20)
 by MWHPR02MB2415.namprd02.prod.outlook.com (2603:10b6:300:5a::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4801.15; Mon, 20 Dec
 2021 05:57:38 +0000
Received: from CO6PR02MB7555.namprd02.prod.outlook.com
 ([fe80::586c:4e09:69dd:e117]) by CO6PR02MB7555.namprd02.prod.outlook.com
 ([fe80::586c:4e09:69dd:e117%8]) with mapi id 15.20.4801.020; Mon, 20 Dec 2021
 05:57:38 +0000
From:   Shivam Kumar <shivam.kumar1@nutanix.com>
To:     pbonzini@redhat.com
Cc:     kvm@vger.kernel.org, agraf@csgraf.de, seanjc@google.com,
        Shivam Kumar <shivam.kumar1@nutanix.com>
Subject: [PATCH v2 0/1] KVM: Dirty quota-based throttling
Date:   Mon, 20 Dec 2021 05:57:21 +0000
Message-Id: <20211220055722.204341-1-shivam.kumar1@nutanix.com>
X-Mailer: git-send-email 2.22.3
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BYAPR01CA0026.prod.exchangelabs.com (2603:10b6:a02:80::39)
 To CO6PR02MB7555.namprd02.prod.outlook.com (2603:10b6:303:b3::20)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 3d6806c9-6d52-4fbf-bc86-08d9c37da05f
X-MS-TrafficTypeDiagnostic: MWHPR02MB2415:EE_
X-Microsoft-Antispam-PRVS: <MWHPR02MB2415FECC7EE39CA2C32B69B3B37B9@MWHPR02MB2415.namprd02.prod.outlook.com>
x-proofpoint-crosstenant: true
X-MS-Oob-TLC-OOBClassifiers: OLM:5236;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: W6JE5XUwVQyW4glEKu7tsG6yYWudr5UvquBP+ZnzKuQ3kkRbuvyeshtvL4w/X7KF9Vkfl1Mx60MQW1WvDlvkL1yjst8C1971kejoZOqIrzumHrVbr7Z0E86o2Vj5hEBYRSsNoXg+CzHeY4jSa6tCRtjMWIu845E+K6+biE8JwpLnP+1zL/He4zzGy6Rtw1l4ucixFDYivqArF6mMiquzds4iIM2mGQucR5i00OYAgxTVOsoqFMq77d0ol2ku2IVM1fgg0fw7uYueqiXjKNnMGFJBHS3IrFBedp5BCUd06hd+DPOdFU6foxEtdusLlpCbphbEZ+VjlGvtXgZkLcmAUD1/IzNcCw45eAFn/pAvO6KrHn+1TxlC/0Nt8VodOtGhSaugdow0Ch6gB7t79oyQk1UwFazu2CmwuaZklZD8aGtHM6jAKIO670vCltVIaph6b7ZsgCiRhB7y3b0igjRob4OfOIg6yCQjS3aZCSzoD9auWF8mZsxLVQ/vt+CuGbcmz/OCEZIT7Tx8ELBTnsCIFEQ1qTQuvnlmMVbQDPbdgpYs3syZB54g+zbS9sVc6N7n3Bd8OhBj4cAKtvcBHj72gXljv+XU0j/vo5pj6conSv2SHQKBRwPvSHSFmmDBv9isywqRVb57nD7Eb+s3Y2cOdzrulW1XQCpQXr1wF9ktn6gQ+AJjGRObvu4YUtoPCDtxTYViI1l1G7bLkRFERloqfTycmwgQNAtabMOTC3F+9ig+gs6hKgFp8uFIFAOLssZyyeQxqSSXvbNTtqRedgZL+E/PitmQDiRVcEwxSbqGZvJNwwrCDQbe9k/w4uOm90xeLoDWn876Xgfeey6BH5VEFA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO6PR02MB7555.namprd02.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(83380400001)(508600001)(1076003)(6506007)(966005)(8936002)(15650500001)(5660300002)(86362001)(8676002)(2616005)(6512007)(4326008)(36756003)(316002)(52116002)(26005)(6486002)(186003)(38100700002)(38350700002)(6666004)(2906002)(66946007)(107886003)(6916009)(66476007)(66556008)(14143004);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?sy4I/idYa8OIEuIOLNrR69JJzDE9P3V6X31XSYdfyQBZ3KJJy1c/0K43OXmF?=
 =?us-ascii?Q?RK7zAoAzjXVwup2F4I1k4s4pMPQRIXIcMbwA6SCMyo0qJD0tuQDY4wNKvHjr?=
 =?us-ascii?Q?TYJQ0lDVjULc+TkO9ZWo19r8bBkYWRuYAJMPO8DGKhd6oy0R3jKZuw4o5tMh?=
 =?us-ascii?Q?37RXJ1EYfjDty7bHsAlYx8LNiLlA72/fL+ihTbTKkKEnxieUKeWQMnp5fT5y?=
 =?us-ascii?Q?mil9t3Sc0HP+JqjnWK3Fn3Cy2ZeT+WCAhaSd/PetVqsUs4+qkK4n8PePFFAC?=
 =?us-ascii?Q?dnF4mKKrFOnUgtcnRIQPFxbNp9MXfXRBd+7ZZFFB7+cAtYPPG3nqTGhdzB7j?=
 =?us-ascii?Q?XmusBmsQIW1NwNW2ABT1sGhe+2qi2TvEjC7ypILIVOBPU7gQ/8XAA42c8c1V?=
 =?us-ascii?Q?/vt70X4ZL2A8gf3rty3MeMHimyIp7esCijeP5qPESs69vlXrbPfms57tE44h?=
 =?us-ascii?Q?gDCdTY5vp98lCcjYc13sejHtJ1MlClfJ0IDsykaK4CLNGTDRNS5xdbju0AoG?=
 =?us-ascii?Q?knTNOw763emlAt4O0uZO8gB5GRBcj14hOVETMaLPWoMhmVKsl2eR0YFdTkUh?=
 =?us-ascii?Q?gnoEh63ljVeeIGnChMNKbLyCqytgKEXalKPyRiJgSSWTK/DrdSiOqI2Tchey?=
 =?us-ascii?Q?6kKRjNo9jJVifU6b4Zisk+iEyDei6U7qTj+3LqZL/EpBZ/Xo7Ob+3M+osgGx?=
 =?us-ascii?Q?xRwLZj7cFYv/lWenlv4APGd5HghaTaqFYXSZltknyH+7yrHSJZkhRorZYaSG?=
 =?us-ascii?Q?9XhVElcLda71OMtfP8gGCZvn/6IwGEIzpe87VddDIhG2wsofju5H29GlZrwn?=
 =?us-ascii?Q?QNOALxjD/0gM05hQa+u3ObRDDQ3JUxAygk9iU0lpXWWDYjBa7taGTeuz7Z88?=
 =?us-ascii?Q?ivFR21JsKqc7BQ+aoFWsqbjzPYh3vZDWMHOlyecVRKjVJE6SRg6LV8XREpRC?=
 =?us-ascii?Q?LGrPnJY7IYDApuqsWEEBNnJ1lkJuhAAd3bCgC9X0qFftd7/hsGU99L4rcIff?=
 =?us-ascii?Q?bfAav+VgqmRbZi3dzT9LnYi8PATd6wGXL8BFfX1tJzFf7UjVBRkAaX62CRtd?=
 =?us-ascii?Q?aiDIDrOulqNND7LFAtk9RlwG0y/z//IpM0fWDxYNMLL1geqtLEDhUtd3ziQ0?=
 =?us-ascii?Q?V5ULmfYzGAS7M8G6CxNC2Gu4BO/Hn+0DqABRqfAbVR1QMX5qmHWms8aHRgWo?=
 =?us-ascii?Q?UVri2Z8i6pjmx+L+KK2xZzYk6UKysjjuNgf1QYHGR+0IJ8RE2kJlrrT1atOZ?=
 =?us-ascii?Q?FSpFmHTdhfuCj8TXS4PMjiDby5zp8PpGWiHDuWvnykhTPpAjm96yBqSu56nH?=
 =?us-ascii?Q?Sa93hMrnNXMpn2CUXCDTWnOULK7lo7Bzb5lqFtYJGuOORV2+UdqwgTJVQqMc?=
 =?us-ascii?Q?5nraX4TD6omFcV/IIP2KrxlMOTEVlazJj4hvsxOuQxyKkpKywYC0uLCNa5eG?=
 =?us-ascii?Q?aDJNzZg+qEtThhxi4Dzw0cHpPORFoESC686xiiFE6vVxizYv/vf3DWQJ4tHz?=
 =?us-ascii?Q?F2PBZ9pVzgIragyMdEeabTb4w8cLvQDbbsutGdtZ0R2blEVCr+2Nx+ZE9eSy?=
 =?us-ascii?Q?3Uv5K14SimOCHeOgRWhl68OER/n9X3vUjGh+2/dNhS20Ux2lKyCq/RAMBOpy?=
 =?us-ascii?Q?vIFAR675W39oDwCwkLSGNyGs5T6x+4aGxH7S/0xq9Yp+9eXcik6R4c4AEvme?=
 =?us-ascii?Q?pD7c+XXpSQSFooFTZiJ27hW97Z8=3D?=
X-OriginatorOrg: nutanix.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3d6806c9-6d52-4fbf-bc86-08d9c37da05f
X-MS-Exchange-CrossTenant-AuthSource: CO6PR02MB7555.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Dec 2021 05:57:38.0467
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: bb047546-786f-4de1-bd75-24e5b6f79043
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: RMJIQ+ynjI0pduX5dWw6T7ELkdvVA1uhzludPcjLKJSw3qcXg9QJ4TXraFUAtasIQdVR1B0FlP3LR9jM+7px3kkRg/4zx3dtg0qipEjalDw=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR02MB2415
X-Proofpoint-ORIG-GUID: ZpYrvX5b6BpFH2ocHdlrk1dmcRFN2WHN
X-Proofpoint-GUID: ZpYrvX5b6BpFH2ocHdlrk1dmcRFN2WHN
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2021-12-20_03,2021-12-16_01,2021-12-02_01
X-Proofpoint-Spam-Reason: safe
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This is v2 of the dirty quota series, with some fundamental changes in
implementation based on the feedback received. The major changes are listed
below:


i) Squashed the changes into one commit.

Previously, the patchset had six patches but there was a lack of
completeness in individual patches. Also, v2 has much simpler
implementation and so it made sense to squash the changes into just one
commit:
  KVM: Implement dirty quota-based throttling of vcpus


ii) Unconditionally incrementing dirty count of vcpu.

As per the discussion on previous patchset, dirty count can serve purposes
other than just migration, e.g. can be used to estimate per-vcpu dirty
rate. Also, incrementing the dirty count unconditionally can avoid
acquiring and releasing kvm mutex lock in the VMEXIT path for every page
write fault.


iii) Sharing dirty quota and dirty count with the userspace through
kvm_run.

Previously, dirty quota and dirty count were defined in a struct which was
mmaped so that these variables could be shared with userspace. Now, dirty
quota is defined in the kvm_run structure and dirty count is also passed
to the userspace through kvm_run only, to prevent memory wastage.


iv) Organised the implementation to accommodate other architectures in
upcoming patches.

We have added the dirty count to the kvm_vcpu_stat_generic structure so
that it can be used as a vcpu stat for all the architectures. For any new
architecture, we now just need to add a conditional exit to userspace from
the kvm run loop.


v) Removed the ioctl to enable/disable dirty quota: Dirty quota throttling
can be enabled/disabled based on the dirty quota value itself. If dirty
quota is zero, throttling is disabled. For any non-zero value of dirty
quota, the vcpu has to exit to userspace whenever dirty count equals/
exceeds dirty quota. Thus, we don't need a separate flag to enable/disable
dirty quota throttling and hence no ioctl is required.


vi) Naming changes: "Dirty quota migration" has been replaced with a more
reasonable term "dirty quota throttling".


Here's a brief overview of how dirty quota throttling is expected to work:

With dirty quota throttling, memory dirtying is throttled by setting a
limit on the number of pages a vcpu can dirty in given fixed microscopic
size time intervals (dirty quota intervals).


Userspace                                 KVM

[At the start of dirty logging]
Initialize dirty quota to some            
non-zero value for each vcpu.    ----->   [When dirty logging starts]
                                          Start incrementing dirty count
                                          for every dirty by the vcpu.

                                          [Dirty count equals/exceeds
                                          dirty quota]
If the vcpu has already claimed  <-----   Exit to userspace.
its quota for the current dirty           
quota interval, sleep the vcpu
until the next interval starts.

Give the vcpu its share for the
current dirty quota interval.    ----->   Continue dirtying with the newly
                                          received quota.  

[At the end of dirty logging]             
Set dirty quota back to zero
for every vcpu.                 ----->    Throttling disabled.


The userspace can design a strategy to allocate the overall scope of
dirtying for the VM (which it can estimate on the basis of available
network bandwidth and degree of throttling) among the vcpus, e.g.

Equally dividing the available scope of dirtying to all the vcpus can
ensure fairness and selective throttling as the vcpu dirtying extensively
will consume its share very soon and will have to wait for a new share to
continue dirtying without affecting some other vcpu which might be running
mostly-read-workload and thus might not consume its share soon enough.
This ensures that only write workloads are penalised with little effect on
read workloads.

However, there can be skewed cases where a few vcpus might not be dirtying
enough and might be sitting on a huge dirty quota pool. This unused dirty
quota could be used by other vcpus. So, the share of a vcpu, if not
claimed in a given interval, can be added to a common pool which can be
served on a First-Come-First-Basis. This common pool can be claimed by any
vcpu only after it has exhausted its individual share for the given time
interval.


Please find v1 of dirty quota series here:
https://lore.kernel.org/kvm/20211114145721.209219-1-shivam.kumar1@nutanix.com/

Please find the KVM Forum presentation on dirty quota-based throttling
here: https://www.youtube.com/watch?v=ZBkkJf78zFA


Shivam Kumar (1):
  KVM: Implement dirty quota-based throttling of vcpus

 arch/x86/kvm/x86.c        | 17 +++++++++++++++++
 include/linux/kvm_types.h |  5 +++++
 include/uapi/linux/kvm.h  | 12 ++++++++++++
 virt/kvm/kvm_main.c       |  4 ++++
 4 files changed, 38 insertions(+)

-- 
2.22.3

