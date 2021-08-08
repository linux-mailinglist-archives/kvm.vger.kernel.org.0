Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 260313E3C80
	for <lists+kvm@lfdr.de>; Sun,  8 Aug 2021 21:27:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232411AbhHHT11 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 8 Aug 2021 15:27:27 -0400
Received: from mail-mw2nam12on2086.outbound.protection.outlook.com ([40.107.244.86]:12128
        "EHLO NAM12-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S230169AbhHHT11 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 8 Aug 2021 15:27:27 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=J4XTeGtAd/Y66RNcg2i3n7QDtPGUmculIJ/OJq1qwObgDRgqu+b64apYXj+5LWEwcHz0tXWW3YNNdOK8AhIDljM0eZc9mkT2i++gzWc4hDIiHot4fpPXMw4p86p2OqGEZ+KR1XEPhUKeqgWnZzdaRaEJctpagl9ZQ8hJatSUM92PrSNNf6fM97UxQk0jVuVmC3yQ79je8+o4900/wsW3GgmRdR5CRSQtY7bPpWZf8ykMNThbRbVMASb0AIwU9p7YfFCTB4WD/v0JB6avsARoc207B/BFhWz6fzotEn07PAGA1zhDaaVsNcJhcN8d0+TLcfcNaaFAFwVxlQYwkHrHxw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ocLw+JiqhsoE5x7GEONPt+/XccfOuFDl5HXQenJ9Q+M=;
 b=UqUYBK9WH8sLtqNcL2KEwGnbaIwkzhcgROIpx2zVyLtw8qQwqVbjMdL+bHYcecEdilUzu1zxxhIsYBiff+CpMKj9EEtHjD032YRt1/GVhPRSt2omlhO37dPj4i00i2IMsMdTghHFzYgGvuYfkcCHgVQn6E8lV3CQ1q6Kyvhy3PA3gKMaLC7fM4GvT/cgH4YQYXStIMikFndOl/3yBE/+UTl++qL+HN7c0rsCZXoTw9A9bXlqOtgpQQmMqryCbmj/Kk0E6dF56FpC+SJeDbPxUcDtkjCkmgS4458aHQCFd3DOZAYnqrQ+VS8AsdNebwBvAR5mUK3oFjR6mCceBM6AfQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ocLw+JiqhsoE5x7GEONPt+/XccfOuFDl5HXQenJ9Q+M=;
 b=AVi9W0MH2Dp2qyWTQp5MHVa6zrHv1AQFOxCDsYtrZWZjEx8KzrRYHRhvddaMOLTIBoFJcSMD6qQeXY3RfIvDFX4MP79b88QhRQIuILK7WoLZRfGg2DZDiiWR5jbQvg511poYdEoMpA7E9eLei4PwlL+B6WtQTe4GnHgHl+aiMkg=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=amd.com;
Received: from DM5PR1201MB0201.namprd12.prod.outlook.com (2603:10b6:4:5b::21)
 by DM5PR12MB1434.namprd12.prod.outlook.com (2603:10b6:3:77::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4394.17; Sun, 8 Aug
 2021 19:27:05 +0000
Received: from DM5PR1201MB0201.namprd12.prod.outlook.com
 ([fe80::7410:8a22:1bdb:d24d]) by DM5PR1201MB0201.namprd12.prod.outlook.com
 ([fe80::7410:8a22:1bdb:d24d%6]) with mapi id 15.20.4394.022; Sun, 8 Aug 2021
 19:27:05 +0000
From:   Wei Huang <wei.huang2@amd.com>
To:     kvm@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, pbonzini@redhat.com,
        seanjc@google.com, vkuznets@redhat.com, wanpengli@tencent.com,
        jmattson@google.com, joro@8bytes.org, tglx@linutronix.de,
        mingo@redhat.com, bp@alien8.de, x86@kernel.org, hpa@zytor.com
Subject: [PATCH v2 0/3] SVM 5-level page table support
Date:   Sun,  8 Aug 2021 14:26:55 -0500
Message-Id: <20210808192658.2923641-1-wei.huang2@amd.com>
X-Mailer: git-send-email 2.31.1
Content-Transfer-Encoding: 7bit
Content-Type: text/plain
X-ClientProxiedBy: SN2PR01CA0082.prod.exchangelabs.com (2603:10b6:800::50) To
 DM5PR1201MB0201.namprd12.prod.outlook.com (2603:10b6:4:5b::21)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from weiserver.amd.com (165.204.77.1) by SN2PR01CA0082.prod.exchangelabs.com (2603:10b6:800::50) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4394.15 via Frontend Transport; Sun, 8 Aug 2021 19:27:04 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 9f7bff76-0722-4e21-46f6-08d95aa28189
X-MS-TrafficTypeDiagnostic: DM5PR12MB1434:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM5PR12MB1434BE7411A7E235FF0067C9CFF59@DM5PR12MB1434.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:1332;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: gK/Lr6Yo7327I4YTwNfd4d0UoClvuCCRSU1KfjAmJV9P1HTbqcT4z1luvgJnNyf9qbm2j5Qv/rhXQrPpfl9VRIYStsvnYFqsNEO/6UH7Iwuw6cibcHKiugjcW0wDPKJK3/YdGRdZzdqI5ie49srjkuHvUR6n9vtLpOsgJqlPmIn64jxJCw1K9zeXUop/KMmY3OJqusrbhIKlkTKc9gYVjs8rXAvbI6tGu4nzOJzW8Wzf3Omj0J/RFKDhpUyygXwD8eMvNwyyWTna8DJfJMa/63Rigq1g/0QY6qV/HPTLpc/l0adnrNZdKHtoymqJNhz4OPo+s/Ziid4FmSfPK+KMlTF/H586q9uzmXt5PVJ0KLsvIZNXbycDYXHdnkSZk2a4jT30L0uUlr57SNjWsVTmYwu29+WSzbN5exx6yh4zqnB3N/8PaeVXKG1FUReHTFz4AoP08W+a91343ZKiwGIMGVyUoa5WkYxrddMaH1pY1HFJx1/FbjvJaO0RmysM2GsNaWVdtRktPGbZtPTxqC9j7VOnFuVuGvNzdn0u3ZTbLt8sYO6lnk+CnI9uU/iMJqQPcXhvJ7ofPvEIpaPTIBPsz/QHsg/eDRMRMxTqX0JE2LY+GnsB4Ktr7lh0mzfvA+S8meg9c9x9ygevPO5wgRquq+mo5lYiYJ8c0+bDRVI+tqGBxqYiehKYHJ/i5zFlZZfydx3T7RjEfga5o64OWMfF4g==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR1201MB0201.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(376002)(136003)(396003)(346002)(39860400002)(6666004)(186003)(86362001)(83380400001)(4326008)(7416002)(6916009)(5660300002)(1076003)(8676002)(38350700002)(38100700002)(8936002)(66946007)(2616005)(66556008)(66476007)(52116002)(7696005)(956004)(2906002)(316002)(478600001)(6486002)(36756003)(26005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?fvWRq3LwO0vS4yFsYWszXjVQZHrgecDmjiXY8HRimkjX+Zz68BkoND373CRS?=
 =?us-ascii?Q?aaZtnq5kJdzzpxs6h22063sx9CU+FKNBEWtWOwtRQeGcfFo3gWzZjjHI4zJQ?=
 =?us-ascii?Q?hOcRrKDtm/pztEmWGVcuqZsWwdV5CcqFKTmHXOGliCJyUuKQIsxaOmMElx6j?=
 =?us-ascii?Q?xuAjyy5yPNQNWv2KUt2dqbHsS61Q6lFAFpVW+UDaleP/RNFL1VS/kME3qwUu?=
 =?us-ascii?Q?S/gApgrVm+X25JarYCtX0PDicHP/5gdfdmoZ+fgQ8/odVuyGxWJnNLvf/zRQ?=
 =?us-ascii?Q?cQq/5KTRNfuuhJt+KZh1O4oa4MGfQOycBTUq07CvU+VFIBj9sTRf7ii6rVcj?=
 =?us-ascii?Q?gXYpzvMIqXNnxSlwmgbqoIKCYZlcC1OKKHlQPKZvWk1LFZoULB0fg7+FsvAD?=
 =?us-ascii?Q?b3F2FxfDNcv0kLUT+7Jsxzy6INWcV9nF+BziyXnSuOMNcxjWUB6WJqQUh2lM?=
 =?us-ascii?Q?9+sOEOhOM+f243yn9udrbaeHF4cMt2ItSHvetzrxi7RRCakb5PlZf+d1SStb?=
 =?us-ascii?Q?OOyFdXLYeH3iYF5/3wbhFaLA/XXEg4M1lI9wRHmYOw9OPKJnHDpQifRbGy9I?=
 =?us-ascii?Q?vfU9vFAerNmaHyYJP/HgNH/prERgwpR+UobXth8XiTTSh5BwyOv5MF83HsvI?=
 =?us-ascii?Q?7tFteB/8b48NNMzM88UrwuO575qthsYs0W5quXkucB2eYup/sujxmZV2pJ0t?=
 =?us-ascii?Q?Gm//+2nX2Ht/KLrZJIxpfp0zIVW5Dz1YggMATEf5n96bZm3RWRbnqmU+NkKl?=
 =?us-ascii?Q?LXeLkagvbixYrttLqYhgpc+f42AhTqZZ6wEWBHaAglZDRcDwOaqmojOs+Hao?=
 =?us-ascii?Q?cij0Z/HbG174kkytAQzzvz3mLctI7JzSu+ozb12mNI7LhhLWv8D9mVvimMI1?=
 =?us-ascii?Q?W/9Qm1PyTTuMmecxRRYCWxhBSyjlAb5Kyn/hFkv+jjju7emqERC//59HiYDC?=
 =?us-ascii?Q?UhgA8GjhdH6vyAWVi0B8aJlgvReWEmFOStswO0v8V/F+oNqEMyHsjKzMu1K5?=
 =?us-ascii?Q?5hcgMpP2OTnZQVzGNGRm+VrhjcVAsq2X2blyp+7sbG5sc6lBeC41mnLN6uGE?=
 =?us-ascii?Q?mk6IYXmebzO5KRCUYMc3C9EACGV/7WLSVKKKwqSaQqdO9A0U7SW+/AFXTSY5?=
 =?us-ascii?Q?5b7bkFpbAlqXqWAIa3YIyd2q/b9qrAjdW3RNRia4DsligspNrhsL28KSvAzX?=
 =?us-ascii?Q?fSzerYreGT4OCcYKOT/hxafi1RfLyJoU8cTQIeq7zZbVgibA1ZGG746HsS12?=
 =?us-ascii?Q?eK9gc7MKAq+N7AfEu3KCxtMVaUIIOpUhGUsQrQVm6mCflGMbabdXpBsxWiEG?=
 =?us-ascii?Q?cERs9aiZgLSqvMk3t6nCCIhu?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9f7bff76-0722-4e21-46f6-08d95aa28189
X-MS-Exchange-CrossTenant-AuthSource: DM5PR1201MB0201.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Aug 2021 19:27:05.5884
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: X7GSW0SIvo+Qywzc6KrRsOnITxH+r8EWJTu+zB0NVxgiZSCtI6j/fVBHqMwcvVZg
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR12MB1434
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This patch set adds 5-level page table support for AMD SVM. When the
5-level page table is enabled on host OS, the nested page table for guest
VMs will use the same format as host OS (i.e. 5-level NPT). These patches
were tested with various combination of different settings and test cases
(nested/regular VMs, AMD64/i686 kernels, kvm-unit-tests, etc.)

v1->v2:
 * Remove v1's arch-specific get_tdp_level() and add a new parameter,
   tdp_forced_root_level, to allow forced TDP level (Sean)
 * Add additional comment on tdp_root table chaining trick and change the
   PML root table allocation code (Sean)
 * Revise Patch 1's commit msg (Sean and Jim)

Thanks,
-Wei

Wei Huang (3):
  KVM: x86: Allow CPU to force vendor-specific TDP level
  KVM: x86: Handle the case of 5-level shadow page table
  KVM: SVM: Add 5-level page table support for SVM

 arch/x86/include/asm/kvm_host.h |  6 ++--
 arch/x86/kvm/mmu/mmu.c          | 58 ++++++++++++++++++++++-----------
 arch/x86/kvm/svm/svm.c          | 13 ++++----
 arch/x86/kvm/vmx/vmx.c          |  3 +-
 4 files changed, 50 insertions(+), 30 deletions(-)

-- 
2.31.1

