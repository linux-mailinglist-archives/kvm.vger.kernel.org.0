Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BB976458BE9
	for <lists+kvm@lfdr.de>; Mon, 22 Nov 2021 10:58:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238944AbhKVKBh (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 22 Nov 2021 05:01:37 -0500
Received: from mail-sn1anam02on2110.outbound.protection.outlook.com ([40.107.96.110]:37558
        "EHLO NAM02-SN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229906AbhKVKBg (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 22 Nov 2021 05:01:36 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Nu1pR/ynFx2B6N/mCgReWH307YJl01t2bExOnqS/HElKtzzDx2BceFzk9Ofwu+0OPKqal2TzNAGkWWjnrcz/76ym3qW9PvqzV4ZCERSXslACRmX+50G20tDW5j7aaaFl9o9DMjt4mFDjY3LGiyWpyl930kpqQFjMT7EBOyFiPLm+785nHJ3PkR/oftMsBfhROBwBvkOiIYPaDPBLISsNSNapP32R5ikUKkMjT32GAnGTT6PZE4CB2OxXo4p2x3Z5KW7sBFijkAzUkbp+GpYquY88AhZijkRaixzKgPTQOFdHK2IYE5KJuDVIxZYwPK5fTaJfzdNN8ysPbyykQ6gQBQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=q6w2twpPnagrSxB5MM4chrn+n0NuzzZQBeRhFxWaAyA=;
 b=lJCXzEp71e8WIV+F+Sdp90amTWzLbO/yP/ud3696jOWFwSSMBJJkl6hexsEluaN8DMv/k+Iu0KvW30+/sjFItvxMGEptK9c1PfbHrseair240lf87SyeEIKxcZVowgU9ZPjB0dSlIjK7SptaFbJcyqCNfgApVTujo3WiX1o2OurL5w7Vdi3RkWp4Sl7TvegO4VCDdZ4js11X65NcBiR0mx4pufABiXl/XGVUwbjOlMIwIpMa+hMGG6Vq/PVlSU5XgKfOqXtJJH71BqVfLSsTpUPSkvomHFar71fucxvdUsTu5qnBav6dGLJ8GE7B1nMdJ6crHN3RJi0cUoGlK/rBlg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=os.amperecomputing.com; dmarc=pass action=none
 header.from=os.amperecomputing.com; dkim=pass
 header.d=os.amperecomputing.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=os.amperecomputing.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=q6w2twpPnagrSxB5MM4chrn+n0NuzzZQBeRhFxWaAyA=;
 b=Lx+Kw6XEqe0mtM1s4YHdEYSNNPTulLe3tuQIoZwDFLmCiL4fCL66lPpuWyZPMd8t4gs5ariP/0AHtehfLqB+NpVk/FVaVEpUibrWGlRgaHZb4tFln1TnZ6dkeBz8ftgXjRAMWqJdvk/TpZt4VxvmM33iPyVIPYiSlKCiHxAaQAc=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=os.amperecomputing.com;
Received: from DM8PR01MB6824.prod.exchangelabs.com (2603:10b6:8:23::24) by
 DM6PR01MB4122.prod.exchangelabs.com (2603:10b6:5:29::27) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4713.22; Mon, 22 Nov 2021 09:58:27 +0000
Received: from DM8PR01MB6824.prod.exchangelabs.com
 ([fe80::ec55:306:a75d:8529]) by DM8PR01MB6824.prod.exchangelabs.com
 ([fe80::ec55:306:a75d:8529%9]) with mapi id 15.20.4713.025; Mon, 22 Nov 2021
 09:58:27 +0000
From:   Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>
To:     maz@kernel.org
Cc:     catalin.marinas@arm.com, will@kernel.org, andre.przywara@arm.com,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        kvm@vger.kernel.org, darren@os.amperecomputing.com,
        d.scott.phillips@amperecomputing.com,
        gankulkarni@os.amperecomputing.com
Subject: [PATCH 0/2] KVM: arm64: nv: Fix issue with Stage 2 MMU init for Nested case.
Date:   Mon, 22 Nov 2021 01:58:01 -0800
Message-Id: <20211122095803.28943-1-gankulkarni@os.amperecomputing.com>
X-Mailer: git-send-email 2.30.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: CH2PR05CA0056.namprd05.prod.outlook.com
 (2603:10b6:610:38::33) To DM8PR01MB6824.prod.exchangelabs.com
 (2603:10b6:8:23::24)
MIME-Version: 1.0
Received: from engdev025.amperecomputing.com (4.28.12.214) by CH2PR05CA0056.namprd05.prod.outlook.com (2603:10b6:610:38::33) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4734.13 via Frontend Transport; Mon, 22 Nov 2021 09:58:25 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: f8814b70-6262-4ec4-58d1-08d9ad9ea110
X-MS-TrafficTypeDiagnostic: DM6PR01MB4122:
X-Microsoft-Antispam-PRVS: <DM6PR01MB412220170FB1C78EB2272D999C9F9@DM6PR01MB4122.prod.exchangelabs.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7219;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 6K4MNWPBxsTHok6z6jAGFfcpyESg8lJvAI9Rxn2QcxzxOI0t7cgRgdpkKRk5Dhqd5luLJMhOw0+ziMEyYk3UVgOOmZDRfiFlNVy48/TfuuvCS6eHSeXRsZM3xDBw1OwHisoNnGw7l7R4FQFPk0r4PNla5ZEIbeomBJLycgMjdqrJaIpdJm0G6AeXjXJ2OZfr7+hWjxEQWCG5Zk+NZselzjdicrKZqLHTqsXMS3l8y7u5OPb0l8U/A3ZqbOODcCfKF9Adu1jjlk+MensUhCZkd7p++xYyzDpAbAB0rp3szFSxyvjqk1IyBAFccHltV8hSY7u6nMaQK8V4xeOulo7WlQn5dZ5XrdBFD1gLUN4YzzkUC2TLNYOk/Cx3d2fBuI/0nl1drHecZxMCGJII9seyhIIhj0uvZV+LYXDd4fvSd6LnMLKxFv/AOebUmu3JlRMEsmDVXKgaWf2gy+zdJ8s/rouftZc2LqFP8UElkkYIijQVqHLtYp2Oq/D6tuIQJQzpITmQmhw1O+5e6PaVgow4ObyG01ueofRv5St6hu7Oy/1I3SVD/GafJytZ1LzUYcYRBMbL+OnCl4bI7KH/OQBLsCh9g+tLGT5kD8MPCch4KfEwbbGWUZg4+AUj/pIphtFTt0wED6UKQEyvTltvfGqKKh7B8opTgmWK+rASTyYZthM1sNSKRv7e7//Nk7VvNLyH30mIuwqCizVOlXA+sPHpBbP68oJrBqLoC3jVywaxQFicMmsDxvT9Js7wAJtNAG3Pw2KCok35yJqXHFCYzH3WyhYZyOrtO+p/cJ+niNvQ5HU=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM8PR01MB6824.prod.exchangelabs.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(4326008)(6512007)(1076003)(8936002)(6486002)(186003)(4744005)(316002)(38350700002)(66556008)(5660300002)(66476007)(83380400001)(8676002)(26005)(966005)(66946007)(6666004)(52116002)(956004)(2616005)(508600001)(2906002)(6916009)(38100700002)(107886003)(86362001)(6506007);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?TJr2xyNU1CvI+E8VSng2SAkYcLsnFmcJw9xkqIVR8km52NKVYDQ1ufBf4QnW?=
 =?us-ascii?Q?4XOLNGqxX0J/VQ5c9gAAhhcRsmUB+xkdHwLMSxey/e1gV7k3Eyx6jV/5VsVa?=
 =?us-ascii?Q?pE4NWJRRY2za4+KUt4Kny0vR+NYrdLqDB/16t+KlV4r2DBI/wDu8YFCl5bVP?=
 =?us-ascii?Q?rVU+i+qb+x17FmcPR5dlMbmHY8p54hS6guAM1RIm2xsqBPUzoQu8IPpgSnn9?=
 =?us-ascii?Q?bjCC1OdIBLZeyP2zMrB2Y+MkMNHcSlnOKzEADf6XZTXzHafmO9zcRIUTMwmi?=
 =?us-ascii?Q?q9XkGzcwkyIU1v26uz5jt3v8osywP87JVS+mcTVbBKWJ6gRzcj8YaGe3cN6U?=
 =?us-ascii?Q?hLGzvj0yvzL6iUrWgQvX8D0l+QtHuFUV4jMQpWTsC+fAxl3jYqnyjTXdpODa?=
 =?us-ascii?Q?WQL59g1qYRzzhuTWH2fxSJXEh2t0+r454/Q2A4oWln7Sq0G4U5A0I/Nzt5W+?=
 =?us-ascii?Q?3iwaHE63Ig+kt1IfLi8OZYQ3xEbIOoTckbfmZe9P7z47alhxPHGc5J+i2L0v?=
 =?us-ascii?Q?jfZ6XWMaGLDX0OUy2hntMJFPGMLgL3rRb+Vfg+EirdFZzDNNmbfNkCuNp841?=
 =?us-ascii?Q?L/FGbndh7kSEIgECz4VzTk+2ttfwP5YatZvugYKF5CI4pthUTi/Dh7fJMoO8?=
 =?us-ascii?Q?OML4afrS/7/5usegQVt8r6IRRjzPWo/ywqJEqOtYLPkH0SPDST2RBiJ2g/D6?=
 =?us-ascii?Q?kg2FyTRUd4ObMkf/i94+Ty5sZwU3pjbXBBfOdgazu8LBE2FoJsAX8i2b2SbH?=
 =?us-ascii?Q?UbBnkIUJ+N74BC2yRVq8pvY8aS8EdOQZ+aQqrNCUAjMm1vVNQL4Dg/837orb?=
 =?us-ascii?Q?r/c4YW5F+WqcbAAr3CSau4yW4xXo/X0A9skhG4oP15Cd98qcUip5TguE+b7b?=
 =?us-ascii?Q?30gHimpe3OnOrhwvQPq/gWgdVYKD6KlXRfqhVaP7U20bNXTYDXLJUjgG4jks?=
 =?us-ascii?Q?yXPeNTX4id04d0bnhnR+OMYqog5moORfpDjApHdhVQWHyUTG8+lkKoHkKOAA?=
 =?us-ascii?Q?QKkyUikBhyaJKopTnRApnEYr1JNcZ8vb/WZxllA7zMsNfVPq+ByhVyqYBCOq?=
 =?us-ascii?Q?rX9lwni1aukcSQxP+5iXBl0ezVbW/rxA6Bg+fihZoYi1ySLGAcXMaHE83CQ/?=
 =?us-ascii?Q?2RqTtVmJNcYkcNj8zOns0I2SuFKnpJ+5V9g6U8yN86DAyq/bqrvl+BKjbuG6?=
 =?us-ascii?Q?SQJ1vwAzDxa1mQvEjeQmGo3ll4JifaOLjCxXvmMaI5Ankmtuishfq/kGPyh6?=
 =?us-ascii?Q?Cnj7+358cJn0psAcbfqeDlw1LEMs1hlDadZHUpZZi92qHZM5In7fYS5lkhfG?=
 =?us-ascii?Q?84liL/Z4a5mi7LXRxZX5lcBZYu7t7Zt3p/YGZbeYJP/g8u35MkntHnZsVymH?=
 =?us-ascii?Q?wg04THRtbAt/LQ/DHMvy9TV0sAAoEtvFBcDlqevccMFnzuJWKw6Zo722ef9g?=
 =?us-ascii?Q?XEwMbOGLUxiZtCsLl4SNLodsO2KB7CIfg/4brMtJHaEDrGSTogljLOjm7t8z?=
 =?us-ascii?Q?zDhpDASLhUZvhqSI1uRcLQ+gVSWDigkwQlXfzI8SYIBhWtERlbiZLYKe4V8Y?=
 =?us-ascii?Q?YSdnJ5Un+ACdUPzpWEDbYqZtdngLms2+NAAaWXW5boZuF2LLs68hdeH5VYp9?=
 =?us-ascii?Q?zg0wTkuDD1BL83OCcSnbvmhL0WNCBpVHgc94v0/UHjoK+6cm1bpbdrTB8aL0?=
 =?us-ascii?Q?H7dJ8y2L2aCG+pEVV6z60eWHzwIqUusBbTU1avQXEQcAHFcr1pFX2ECPuUMh?=
 =?us-ascii?Q?k5+6MjTwvw=3D=3D?=
X-OriginatorOrg: os.amperecomputing.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f8814b70-6262-4ec4-58d1-08d9ad9ea110
X-MS-Exchange-CrossTenant-AuthSource: DM8PR01MB6824.prod.exchangelabs.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Nov 2021 09:58:27.0895
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3bc2b170-fd94-476d-b0ce-4229bdc904a7
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: J9m54DqkzmvPHSUpVShFa4pLHZTHPqAOkIGor0xmb/pVz4mvab7WYvgmqVVjFCVv46Zbd3H+aqEzbovbp1LEiSXhRBe3ufYY6T/iGOgA8piVbmkAcz0yYourzVHYc8uK
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR01MB4122
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The Guest Hypervisor stage 2 mmu table was used while creating map
and subsequent tlb flush for Nested VM. This resulted in unresolvable
stage 2 fault for Nested VM since tlb was invalidated with
Guest-Hypervisor VMID.

Patch 1/2 should be applied before the NV patchset[1].
Patch 2/2 can be squashed in to Commit 1776c91346b6 ("KVM: arm64: nv:
Support multiple nested Stage-2 mmu structures")[2].

[1] https://lore.kernel.org/kvmarm/20210510165920.1913477-1-maz@kernel.org/
[2] https://git.kernel.org/pub/scm/linux/kernel/git/maz/arm-platforms.git/
branch kvm-arm64/nv-5.13

Ganapatrao Kulkarni (2):
  KVM: arm64: Use appropriate mmu pointer in stage2 page table init.
  KVM: arm64: nv: fixup! Support multiple nested Stage-2 mmu structures

 arch/arm64/include/asm/kvm_pgtable.h  | 6 ++++--
 arch/arm64/kvm/hyp/nvhe/mem_protect.c | 2 +-
 arch/arm64/kvm/hyp/pgtable.c          | 3 ++-
 arch/arm64/kvm/mmu.c                  | 2 +-
 arch/arm64/kvm/nested.c               | 9 +++++++++
 5 files changed, 17 insertions(+), 5 deletions(-)

-- 
2.27.0

