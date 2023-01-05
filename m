Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AF6E565F4A8
	for <lists+kvm@lfdr.de>; Thu,  5 Jan 2023 20:37:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236087AbjAEThD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 5 Jan 2023 14:37:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60304 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235941AbjAETfN (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 5 Jan 2023 14:35:13 -0500
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2084.outbound.protection.outlook.com [40.107.92.84])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 27615178B4;
        Thu,  5 Jan 2023 11:34:04 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=iDRSCUu33YB4KhlXWr3z52n4mg/gkm/76UT8Vsvvmls7O9ENt8u+yyHecJVyiTrUfWKCtP20sMRUS8j0bXmCgU9sGaAJrFzXEJEZpcTy+jQMTIAf1NXBbrBJv7KVND8XpXWHSA8X6jx0LvqauamdLK9ykoYMA/aGJi6MhQQL2KaKcYENUEpGxRymSy719g0jCy8RNPUP06AIcC4mK48NZPGB0IdqkGRT4Jxbu1bmMRqKmVbMif43eVBLmrByuDNy9FD+HcPrjIm4aYw2fj2to+GUXbKOn9g+EaZlPXegHarrhPa6ppMAQNdLjCn3hYqFvT/++SxevIypZEvqDfXc1g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Rsr/lhBcuVU1xrYn8NOic0gYBZ2p5nfAYZZXHfwOpic=;
 b=FdzCnHFunTJkoLhlCXRkcan18ffmoiviemhtJ3CDxOJVRBZxbusWVeI2AVBVejI+d0GxC9SgrcJQ0XmeCCpaxCEovIn9NH56Pik1ACNe8Q1+nh2kkJeJYUGT/Mbqc2S3O8eFNxdS2PuxMQcIQ1A5TLq5AaMZXibbDRR0yJ5WPr1khiD/mKbYMyPrS3p67w18OAVpySazhTl/0IVWB6JO57LDcNy7Wtpe3vWQVqnB4s+RxGXKb7ijAAqTWQtYfnKhnvRHzdE7Wnl+jaX2bxy8x/CUycYEWUOVlqM0T5cz73wgsgB8G/NosMwa1hLDEytLIjJXNnljjkqIgYMElGQbJg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Rsr/lhBcuVU1xrYn8NOic0gYBZ2p5nfAYZZXHfwOpic=;
 b=LJFdR8kjGWYy4pFTODcGZAXQBfW4X/kuaCCxPIF5iWGrs92mLf8fskrAadP8jDDVWsMLerkGGXTEyouYxQA5GOOorfuDFj6H2PKEreK4CV26KTFmSJ8neze56VBp8ZHGXuu8/OaDryJLsdY1Ylk+duYRoFr2vKEeI2VviS0PC5WOEHZAOqR4AaQEJI1eC3DrbRzA2EbbhG82UQC4D2Tqg4QZU3//A3Fwj4zmfHG9maktMB3v8yXd1sn1ruehZGYc+wtwR26AR3fixZ3DLMkhvH/Z09yXxPCKYnpEGVAtNb3fHEo9g5v8RmVIHIHLV8GjHbHeSF2qxyAj/AJ63KDwiA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV2PR12MB5869.namprd12.prod.outlook.com (2603:10b6:408:176::16)
 by SA1PR12MB6776.namprd12.prod.outlook.com (2603:10b6:806:25b::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5944.19; Thu, 5 Jan
 2023 19:33:59 +0000
Received: from LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::f8b0:df13:5f8d:12a]) by LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::f8b0:df13:5f8d:12a%9]) with mapi id 15.20.5944.019; Thu, 5 Jan 2023
 19:33:59 +0000
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Alexander Gordeev <agordeev@linux.ibm.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Lu Baolu <baolu.lu@linux.intel.com>,
        Christian Borntraeger <borntraeger@linux.ibm.com>,
        Cornelia Huck <cohuck@redhat.com>,
        David Woodhouse <dwmw2@infradead.org>,
        Gerald Schaefer <gerald.schaefer@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Heiko Carstens <hca@linux.ibm.com>, iommu@lists.linux.dev,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-s390@vger.kernel.org, Marc Zyngier <maz@kernel.org>,
        Robin Murphy <robin.murphy@arm.com>,
        Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
        Sven Schnelle <svens@linux.ibm.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Will Deacon <will@kernel.org>
Cc:     Bharat Bhushan <bharat.bhushan@nxp.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Eric Auger <eric.auger@redhat.com>,
        Eric Farman <farman@linux.ibm.com>,
        Kevin Tian <kevin.tian@intel.com>,
        Marc Zyngier <marc.zyngier@arm.com>,
        Matthew Rosato <mjrosato@linux.ibm.com>,
        Tomasz Nowicki <tomasz.nowicki@caviumnetworks.com>,
        Will Deacon <will.deacon@arm.com>
Subject: [PATCH iommufd v3 6/9] irq: Rename IRQ_DOMAIN_MSI_REMAP to IRQ_DOMAIN_ISOLATED_MSI
Date:   Thu,  5 Jan 2023 15:33:54 -0400
Message-Id: <6-v3-3313bb5dd3a3+10f11-secure_msi_jgg@nvidia.com>
In-Reply-To: <0-v3-3313bb5dd3a3+10f11-secure_msi_jgg@nvidia.com>
References: 
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MN2PR02CA0019.namprd02.prod.outlook.com
 (2603:10b6:208:fc::32) To LV2PR12MB5869.namprd12.prod.outlook.com
 (2603:10b6:408:176::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV2PR12MB5869:EE_|SA1PR12MB6776:EE_
X-MS-Office365-Filtering-Correlation-Id: fab7249e-502b-4868-08c2-08daef53ca8c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 9VP5BoSG7MJK6t0/1qojK/Q23BvoDSDLs6VFd9er1mFvC33YN7M9+5K1DklrvnjXWXAGlpo14cXc/dsx/j/oZLJ4k9XGnan4f3oMrWl86YrEJ54xhHr1gwKsLgFDty3R1XpaUypyNIbVAq9sybewd8G8gzyvA6JfDOCDa2qdupbUEqr7TzlQrXHTzktyQAJJECfixfKvCphIYo6NpMJN7rezHY76JrPK/et8lTx4mXBF11IbB/qYPzCK8caQtREse+oycxGNB8mMarj4TuB7xgQi4wTEKdiU+IM7gjDXy01rN/b32yiM7jTS7eBbb+k2dyZMedaOBT83RRw27nqr0qJn88PJdrhQPSFIQ9VCWf52UgG4HsQ4aXse086Ud3VwcxW8jeQwIGZsayp8ZGDWOPpij6ohigYdiEIMCWbm2Nj65sFnmT96hqJ1hYmgOGyGyB8NPv3GLgp1XxDWl1oflKQhHILdkuBjFyGEWhTltePOyqIN0Q1K+WF3IXOHbf45ovIUbNU2xWHVtODyazidJHT37tqed8klstdZ9rBc7rNnz0C4L390JnNWJcZsEABngOUatpOlNXyaahAHOrGen6WTFm+sOQJasqe/+FvurE6CrqeoukHuQXLcdFKCL3sZM62GSzYIW/m7vq6Pp7cycSyPbRGNKPyEPa23QTNukAQ5fAswQNJ3RrU+nvZsQVm5g79dmr5QkfIKsHJI22xsxw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV2PR12MB5869.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(136003)(376002)(396003)(346002)(366004)(39860400002)(451199015)(6486002)(6512007)(26005)(186003)(6506007)(7416002)(8936002)(83380400001)(478600001)(54906003)(4326008)(316002)(2616005)(66476007)(8676002)(36756003)(66556008)(6666004)(66946007)(41300700001)(38100700002)(5660300002)(2906002)(110136005)(921005)(86362001)(4216001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?PJX7y66W1Jw8B6ngp7d6VEiS8lgIvs2hG55M2WwewYMTeZJDHAGf9LpRYkRR?=
 =?us-ascii?Q?SxO/AfS87W/Oxi65XYzl2xcmFaMzhOKEr1Z+DbQI+KRJQ9e4Q9XhlhHBowek?=
 =?us-ascii?Q?soN2Gmiij68DK61iBCGc05y6IYxoZz4Ll5NGJ8xbNI7DUVw8oMgLXVcob2cK?=
 =?us-ascii?Q?Op2JBQNNiPUQcxwtbMyUFt3sjVvWQB9NwIPeFhI/MkCH3jTEoyghg6zUKyGk?=
 =?us-ascii?Q?cSSYAhoDndUZs3fgFPP28lRyXWVdfS9Bik0aQWpkeZi5G2c1PJBObvBR1SgE?=
 =?us-ascii?Q?w7/0bEbSGydTcbNa5tL5PrgooADe3PNleKc2/CGnGIkCW31Kv3lHJp4bkCR3?=
 =?us-ascii?Q?q87d8ojWE7mjiGc6MbA6lKCy3ennMUXHtwd+wQZBBWrWH70TRYN1ROAL7Z+P?=
 =?us-ascii?Q?BglIiqYtz9h3glwg4VPBJRx2XvhnXKHGp2JVHq3x9UvYBMPfNDiMQTg1fM+m?=
 =?us-ascii?Q?7gA64mfSgTZGh6VjlUhZKfcHhuVtHUDUdvhagO/FX85N6J6C42b6fHVrc0Im?=
 =?us-ascii?Q?OCnrXaeTX5sIIJXXyhpdyEFqNjV9GBqVl7Ih+sydtRqxPyk7GVoByrzoycVL?=
 =?us-ascii?Q?Lw4ZZNKVdrDtNzPHyf48BzUcOlDphfCMiiJpBnQfOuv06JtlPOGPFgIQs6nq?=
 =?us-ascii?Q?fa1NNtF85upHxdRwNfU/IB6he1l6flTPLsDNqW5zt8Ne8FA0PDIlywHG7dtR?=
 =?us-ascii?Q?yxw0C7nSNZAeItcPDG8Aqk1qyiPzSlOer3fgsatWB37UKY4NyWlwevu+h41c?=
 =?us-ascii?Q?sQbRUcjOxt5UESmDxp9H6c0s2aRdQPflyGrJqjhKaHpVypr/N/qwySDbTzcl?=
 =?us-ascii?Q?1EcN/3jQU4H5rVHbExO+4zM+Qeo9Z/lOB5LzWjHuLtvyzlJiEAhq3a9f7dt6?=
 =?us-ascii?Q?kPhe8jr20WJCkAsykZqvLWvcts6jipMBDRW/hzIE4L3X6OBX9vM0MjpR6h/8?=
 =?us-ascii?Q?zz3SsbGgLETjvjn+LgvTJ9GcdMRmpse4/wBu0zcULMe6+mzWdKudpAdnKiQL?=
 =?us-ascii?Q?iEyfZWWjHb8FAcf7RlaUELeChrOMTNkX73K0JS5lJ49G8b4aCzWWisqQo/bm?=
 =?us-ascii?Q?DOy1zY0rJ7yOBU+gMlXjx0YfKDl3+f7PP7DmxCTeceZvCx2Wx/Ya6oyewtA+?=
 =?us-ascii?Q?AoQf72L7+aXnq6BcrZFDHqAMCiVtLGSSttvq8OYJkwOZK8CO2sADfJYt86tN?=
 =?us-ascii?Q?z6T05gabJqCG+3BOgCOhZNDvjdL4crl+856uueNUf29zxEeUhzVAhV6TmRag?=
 =?us-ascii?Q?B0e1hu8/1lsdrbzfjU0+gIqVRjEg0XOK0ro6JrSaKHUvnysn8PkcwO9SEAbQ?=
 =?us-ascii?Q?8RrpXr5ZNMbbb+02MS0xwBVbL5Q1B/cxdfZ78LCns8A0f8HPJ8WXcN01JqwQ?=
 =?us-ascii?Q?obiGEAXwbajraKJE3szzCC+gjXMfAKHXlpTbVbs8K5dofDSKe1xkTarcPAP2?=
 =?us-ascii?Q?+Wo8ynkClF7JAeV2y8mH/GZSv6gdcSVlnz4s9W7DfGANHyfvN0xm5xCTvKOB?=
 =?us-ascii?Q?YBd24u8qOYxnVZXGkp8vR7Ki5ELPWXkEu+faKsvHPiIUQYzXiBZCA9z/o95L?=
 =?us-ascii?Q?b9D9jb1rkSe2IC9JqIMwKQKmwPDqGHJUn85axLyU?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fab7249e-502b-4868-08c2-08daef53ca8c
X-MS-Exchange-CrossTenant-AuthSource: LV2PR12MB5869.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Jan 2023 19:33:58.8047
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: rrGJxPSyJKEFv56YEavm/K4Bnl6UWRWN/Wy208Me9ZhOO6+lbxCQEvZIKnm/MPI+
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR12MB6776
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

What x86 calls "interrupt remapping" is one way to achieve isolated MSI,
make it clear this is talking about isolated MSI, no matter how it is
achieved. This matches the new driver facing API name of
msi_device_has_isolated_msi()

No functional change.

Tested-by: Matthew Rosato <mjrosato@linux.ibm.com>
Reviewed-by: Kevin Tian <kevin.tian@intel.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 drivers/irqchip/irq-gic-v3-its.c | 4 ++--
 include/linux/irqdomain.h        | 6 ++++--
 kernel/irq/msi.c                 | 2 +-
 3 files changed, 7 insertions(+), 5 deletions(-)

diff --git a/drivers/irqchip/irq-gic-v3-its.c b/drivers/irqchip/irq-gic-v3-its.c
index 973ede0197e36f..b4069f825a9b73 100644
--- a/drivers/irqchip/irq-gic-v3-its.c
+++ b/drivers/irqchip/irq-gic-v3-its.c
@@ -4692,7 +4692,7 @@ static bool __maybe_unused its_enable_quirk_socionext_synquacer(void *data)
 		}
 
 		/* the pre-ITS breaks isolation, so disable MSI remapping */
-		its->msi_domain_flags &= ~IRQ_DOMAIN_FLAG_MSI_REMAP;
+		its->msi_domain_flags &= ~IRQ_DOMAIN_FLAG_ISOLATED_MSI;
 		return true;
 	}
 	return false;
@@ -5074,7 +5074,7 @@ static int __init its_probe_one(struct resource *res,
 	its->cmd_write = its->cmd_base;
 	its->fwnode_handle = handle;
 	its->get_msi_base = its_irq_get_msi_base;
-	its->msi_domain_flags = IRQ_DOMAIN_FLAG_MSI_REMAP;
+	its->msi_domain_flags = IRQ_DOMAIN_FLAG_ISOLATED_MSI;
 
 	its_enable_quirks(its);
 
diff --git a/include/linux/irqdomain.h b/include/linux/irqdomain.h
index b04ce03d3bb69f..0a3e974b7288d0 100644
--- a/include/linux/irqdomain.h
+++ b/include/linux/irqdomain.h
@@ -192,8 +192,10 @@ enum {
 	/* Irq domain implements MSIs */
 	IRQ_DOMAIN_FLAG_MSI		= (1 << 4),
 
-	/* Irq domain implements MSI remapping */
-	IRQ_DOMAIN_FLAG_MSI_REMAP	= (1 << 5),
+	/*
+	 * Irq domain implements isolated MSI, see msi_device_has_isolated_msi()
+	 */
+	IRQ_DOMAIN_FLAG_ISOLATED_MSI	= (1 << 5),
 
 	/* Irq domain doesn't translate anything */
 	IRQ_DOMAIN_FLAG_NO_MAP		= (1 << 6),
diff --git a/kernel/irq/msi.c b/kernel/irq/msi.c
index dfb5d40abac9e8..ac5e224a11b9aa 100644
--- a/kernel/irq/msi.c
+++ b/kernel/irq/msi.c
@@ -1645,7 +1645,7 @@ bool msi_device_has_isolated_msi(struct device *dev)
 	struct irq_domain *domain = dev_get_msi_domain(dev);
 
 	for (; domain; domain = domain->parent)
-		if (domain->flags & IRQ_DOMAIN_FLAG_MSI_REMAP)
+		if (domain->flags & IRQ_DOMAIN_FLAG_ISOLATED_MSI)
 			return true;
 	return false;
 }
-- 
2.39.0

