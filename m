Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0FF63161539
	for <lists+kvm@lfdr.de>; Mon, 17 Feb 2020 15:55:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729288AbgBQOzh (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 17 Feb 2020 09:55:37 -0500
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:49910 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1729256AbgBQOzg (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 17 Feb 2020 09:55:36 -0500
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 01HElXPG029659;
        Mon, 17 Feb 2020 06:55:25 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : content-type :
 mime-version; s=pfpt0818; bh=A5vGDqzgJ2eCh+fVLxCc9iKpBuO+CvMkSobvsGud1gQ=;
 b=db9jY5aFAIbRYd2AeQC/tQZzOKdlWAMRpiIbg01KSPP5PahnyiLCwzRxBmOJHTDd0Reg
 jStdUfCpInN+ra91gXzGC5hteSUSrCM+PgkrMH3NtJCoAxLYxeVoOhtKk7AP9FjLowLa
 1PDRPix/hiJYcoLhEx3lIK/cVvPNTJ17EpPFzf5MtK91mY5MnmYcWrw3MaRzdw+TXmgk
 jvr0t/4VkQUZIpdMZ4fNonRjk1MNK4H1IMuM+mP6PcQ199AJNOaSD6VGZ1CmVS54MGVX
 V5VetNfEMUNslLXoOumwBlJbQLmKBoOZhAFLivxe+ovThXg05reYOfQwVdyBOa3sQzBs sA== 
Received: from sc-exch03.marvell.com ([199.233.58.183])
        by mx0a-0016f401.pphosted.com with ESMTP id 2y6evv7nw4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Mon, 17 Feb 2020 06:55:25 -0800
Received: from DC5-EXCH02.marvell.com (10.69.176.39) by SC-EXCH03.marvell.com
 (10.93.176.83) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Mon, 17 Feb
 2020 06:55:24 -0800
Received: from SC-EXCH01.marvell.com (10.93.176.81) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Mon, 17 Feb
 2020 06:55:23 -0800
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (104.47.58.175)
 by SC-EXCH01.marvell.com (10.93.176.81) with Microsoft SMTP Server (TLS) id
 15.0.1497.2 via Frontend Transport; Mon, 17 Feb 2020 06:55:23 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=G/E96GXKxxLkAAAmkyPRktTfAb3Gt+sPNoS76EtCsil0tC3Cjgvt2PuOobFXpb45C6kMs/fgYm316eYEdi5bB0olXdXV9Mog055zFBwDil+7A6MgpvbgFB+Vz1+JHT9X54tJy/d3ET1zWLQShYVkrdSxxVOUe1E3qFCgIzCqSI6UGRQJdiz4cnuv5WgOSYUYGvCPOZ46e0HqiM8DfjkungRISSotlSLFdTqRUlXQGpzcEFrpm1NBlvP1SiW5aInKeRLedR29/UBi2SiB9d/BRzfVk1lLo3YqfFDvaQwADUaqMGrKMIJckwjvxlOCU/ACFubrFVh4R/w+Phr1QBohnA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=A5vGDqzgJ2eCh+fVLxCc9iKpBuO+CvMkSobvsGud1gQ=;
 b=T9Iitln3vEOhdS+3ajcHiy3sfUu4CkpSrUoAOrgfWIlnXwON/LI/q5Br8p8bMh1HNUldTWaKmn3JZpVrk1zJogJ81Ox+qGs86Cm3iHUDqRs3UmndEKUEx8ABPZutWbsAUE3grTAaJanu36RjABbY/1y7Yat7p5iTYcpA7TiRW9cJsGu6N/u+mU2aVaeCbnT7rKuk7YTslxbEfpMvX+9UFjBzTlCAUYX3+lxiVgtaRS+bEKzSovh2erVQg/UhjzRGflavJI/OWyrhWGEVbDicnFQwmee96bLJevPuL0qb4nJXU++Rc6FHC98LqbmkWTL8KzeaAc/cKqnR4PoZsO/WNA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=marvell.com; dmarc=pass action=none header.from=marvell.com;
 dkim=pass header.d=marvell.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=marvell.onmicrosoft.com; s=selector1-marvell-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=A5vGDqzgJ2eCh+fVLxCc9iKpBuO+CvMkSobvsGud1gQ=;
 b=ZodKCLw5eZHAg9aDrexfOH+4lSyLahmZPOFzotkmgBeamdUAhleg+qALPdml/9HaACEbz7wRQ1al4mrTAk8xqMwVY8uRP75Prcw8TB2rpG4qywkeIZcWxd9IN63WLouZ7i+CpP9G2l4H5P+Vcn/5q1tuKigP8a+3E73RouuKGog=
Received: from DM6PR18MB2969.namprd18.prod.outlook.com (20.179.52.17) by
 DM6SPR01MB0045.namprd18.prod.outlook.com (20.176.120.140) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2729.22; Mon, 17 Feb 2020 14:55:22 +0000
Received: from DM6PR18MB2969.namprd18.prod.outlook.com
 ([fe80::d890:b3b7:629e:352c]) by DM6PR18MB2969.namprd18.prod.outlook.com
 ([fe80::d890:b3b7:629e:352c%6]) with mapi id 15.20.2729.031; Mon, 17 Feb 2020
 14:55:22 +0000
From:   Tomasz Nowicki <tnowicki@marvell.com>
To:     <kvmarm@lists.cs.columbia.edu>,
        <linux-arm-kernel@lists.infradead.org>
CC:     <kvm@vger.kernel.org>, <christoffer.dall@arm.com>,
        <maz@kernel.org>, <james.morse@arm.com>,
        <julien.thierry.kdev@gmail.com>, <gkulkarni@marvell.com>,
        <rrichter@marvell.com>, Tomasz Nowicki <tnowicki@marvell.com>
Subject: [PATCH 2/2] KVM: arm/arm64: Fix htimer setup for emulated timer when irq goes down
Date:   Mon, 17 Feb 2020 15:54:38 +0100
Message-ID: <20200217145438.23289-3-tnowicki@marvell.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200217145438.23289-1-tnowicki@marvell.com>
References: <20200217145438.23289-1-tnowicki@marvell.com>
Content-Type: text/plain
X-ClientProxiedBy: AM6P192CA0037.EURP192.PROD.OUTLOOK.COM
 (2603:10a6:209:82::14) To DM6PR18MB2969.namprd18.prod.outlook.com
 (2603:10b6:5:170::17)
MIME-Version: 1.0
Received: from localhost.localdomain (83.68.95.66) by AM6P192CA0037.EURP192.PROD.OUTLOOK.COM (2603:10a6:209:82::14) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2729.22 via Frontend Transport; Mon, 17 Feb 2020 14:55:20 +0000
X-Mailer: git-send-email 2.17.1
X-Originating-IP: [83.68.95.66]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: dc067636-f96f-428d-6473-08d7b3b969ae
X-MS-TrafficTypeDiagnostic: DM6SPR01MB0045:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM6SPR01MB00453CAE1416AD7869FF44D7D2160@DM6SPR01MB0045.namprd18.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:3173;
X-Forefront-PRVS: 0316567485
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10009020)(4636009)(136003)(39850400004)(366004)(376002)(346002)(396003)(189003)(199004)(69590400006)(4326008)(5660300002)(36756003)(26005)(4744005)(107886003)(478600001)(2906002)(16526019)(186003)(8936002)(52116002)(2616005)(81156014)(8676002)(81166006)(316002)(6666004)(6486002)(86362001)(956004)(66946007)(6512007)(1076003)(6506007)(66476007)(66556008);DIR:OUT;SFP:1101;SCL:1;SRVR:DM6SPR01MB0045;H:DM6PR18MB2969.namprd18.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
Received-SPF: None (protection.outlook.com: marvell.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 3NEty4lkR1mar8yRz00aLQXlmqghaVy/2cMdYlSzOKg+dN1kb8U9Mce6PEp3p1GQj1umwWJLVS/Nkk896Q3VEBcIIySOx7FsruaJtLi2xEkaSM8qsyaBeQ4bi1jNdKSuYO8enDw8aCtkQGIDN6g5px+5MmUfVzvd7jY7xatIIUwS1zt9ye3KWDwPDvriKyeh67Q7QrJCCxG7BEIEuSgfbl0QWydOFUthe+JkQbZ4AToh7VAoryi/bjuUUERXpn41djq5Lb5P7umLTFEyKLosb16ck8eQpcFJbkaliw5s7wyxfQATLA1bVMnQt73koVujWA2yS0NYW5XuBZnAnepbvBhk3nQAy5+jrnfcqpIGyJFytV2deosrjYd8ioCeK8YK2bxKH63jwN3/sO+YdLHrOhpNgjGpyLY0ii943MxGKxHehg6Zk1NCCCqFvBhWbUrMxdgK0s5ID7OCvo7zR8jllV2XDg9U9hqLPhAbhDz3Fqhw6iohgImaaBGxlZ00QkiCPaZyldn4362r4CZyQYm1+l/vd05Z7lhqwWy7NDXMCCw=
X-MS-Exchange-AntiSpam-MessageData: EbFY2x4BlSO8EIhBNovlbFbgFoHUlhZCUjrPl4XahnqFHnQWoXruYjNKl0C1WOfTEuoeNNYUupnzxdYw1/t/7BUW05O+UYl1QP4rbKL3s0L1sq/NdgYJVsSDKhPz4Vp6K9Yfeoiqks4CsNgD8k2DOA==
X-MS-Exchange-CrossTenant-Network-Message-Id: dc067636-f96f-428d-6473-08d7b3b969ae
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Feb 2020 14:55:22.1961
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 70e1fb47-1155-421d-87fc-2e58f638b6e0
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 0ORpYIxMrjlVxgzkpEb1NM6OVl0O3g2D/fT+fUQZrmXjMMfaW0FmmCVRgheRvzxbtn+RJCqko57twIOWq/g/bw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6SPR01MB0045
X-OriginatorOrg: marvell.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.572
 definitions=2020-02-17_08:2020-02-17,2020-02-17 signatures=0
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

We still need to schedule software timer if the line goes down
(should_fire == 0 && should_fire != ctx->irq.level) and
there is still some time to expire again.

Fixes: bee038a674875 ("KVM: arm/arm64: Rework the timer code to use a timer_map")
Signed-off-by: Tomasz Nowicki <tnowicki@marvell.com>
---
 virt/kvm/arm/arch_timer.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/virt/kvm/arm/arch_timer.c b/virt/kvm/arm/arch_timer.c
index f1814f733ef8..de14520c6cc2 100644
--- a/virt/kvm/arm/arch_timer.c
+++ b/virt/kvm/arm/arch_timer.c
@@ -316,10 +316,8 @@ static void timer_emulate(struct arch_timer_context *ctx)
 
 	trace_kvm_timer_emulate(ctx, should_fire);
 
-	if (should_fire != ctx->irq.level) {
+	if (should_fire != ctx->irq.level)
 		kvm_timer_update_irq(ctx->vcpu, should_fire, ctx);
-		return;
-	}
 
 	/*
 	 * If the timer can fire now, we don't need to have a soft timer
-- 
2.17.1

