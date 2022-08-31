Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 802CC5A8764
	for <lists+kvm@lfdr.de>; Wed, 31 Aug 2022 22:16:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232212AbiHaUQO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 31 Aug 2022 16:16:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45176 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232114AbiHaUQM (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 31 Aug 2022 16:16:12 -0400
Received: from NAM04-MW2-obe.outbound.protection.outlook.com (mail-mw2nam04on2053.outbound.protection.outlook.com [40.107.101.53])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9FC72E096B
        for <kvm@vger.kernel.org>; Wed, 31 Aug 2022 13:16:11 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=WLTx/EIzRZHxfZwq6QsDHXsNoNpUP184INxgtntZ3DM4HR4IXQhIAqVmc60nGHeKBmdLO/D2k22gwF+THy+bDijakyO+zjBlNYEo0gW67W8ZPKqT9+MO+BmObODdQ/pOKDMEoTYfn1WLCA5dMamyyEghXkO/fatA8grkaZnX2Ys4u73pGRecokQT2yqzLHweoTti9VRRc0u116tiwgBmgCLM++b5AXFV/F8aTCJ35khlwQDxzbMJnskJpO0QI/AoaCxlbN4b/Xq0DIEz3KqAXjtaxS1jfIh8t3k/BUuyTPkWmSBKfpSHCuBJpOfqmuXqmSxHidFdi0UJrO7D8MIB2g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=RVG7gBqvuKdVEVjQCoSCi2ggSEtiRLRRR4hW4PMVIP0=;
 b=Iib5cGSR6jipKdFhyx6u8KPUuooRdbl2EZgA+W7lYyRrwiMQQbOLseIj/InZFYrvhgk0f5XknOy/3R3lgeqrva0xSsWbIwYZsp1YMd2DVvt5vDUY8bMIRMSVcug+xNiLNduUjqTAwRL1VbjXuaoBudULGLhlJe45jIHjKOnCCwJnSnBi4CzCa+22opIlaH5evbB6Kz1sMtsQgwoeLikl+9a4Ij0jravvGp2PDud1Zdk/CVncELE7oJ1hcDClt66IlqQI+J6wyEmQHRvEao8u/3RrASU0YkiGH2ALU/ia+FpFnkGuMkrh2kqBsiujb1bxHwuRska2Gr2zSf4X7H6nig==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=RVG7gBqvuKdVEVjQCoSCi2ggSEtiRLRRR4hW4PMVIP0=;
 b=bTskiwxTbAKVT7HkcIbo/6zbf3TlZOdOiZ49vy4f/yLYqTa62K/MpzQKKkX204eB/7PxjyV4UZojSFi765j+nUaP1Y61t1AiTI2ZeFnSXAX6AMDJ86qBlmgcePRgFVUFbmF6hQoOfSCUbLVfRBQGj6/0z8BTd9dc5nf703/jzYrRDoB9D/qPobJsvVJjTcwxDkpiBI4U08XOSZUr/CmWTebOGq/o3Uq7r1VdlAFtY6/R0ccTiIrRTeWakpd8bbAmnRCM66xVLZR3km+/wdglCzfeP7SUYNKVz9uU/I8d7W9NKWl9v6Iv5r70Z4j/QC3j/nbT2VTWcHXovtOpptxrmA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CH2PR12MB4181.namprd12.prod.outlook.com (2603:10b6:610:a8::16)
 by SJ1PR12MB6316.namprd12.prod.outlook.com (2603:10b6:a03:455::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5566.21; Wed, 31 Aug
 2022 20:16:07 +0000
Received: from CH2PR12MB4181.namprd12.prod.outlook.com
 ([fe80::3d9f:c18a:7310:ae46]) by CH2PR12MB4181.namprd12.prod.outlook.com
 ([fe80::3d9f:c18a:7310:ae46%8]) with mapi id 15.20.5588.010; Wed, 31 Aug 2022
 20:16:07 +0000
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Alex Williamson <alex.williamson@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>, kvm@vger.kernel.org,
        llvm@lists.linux.dev, Nathan Chancellor <nathan@kernel.org>,
        Nick Desaulniers <ndesaulniers@google.com>,
        Tom Rix <trix@redhat.com>
Cc:     Kevin Tian <kevin.tian@intel.com>
Subject: [PATCH v2 5/8] vfio: Fold VFIO_GROUP_GET_DEVICE_FD into vfio_group_get_device_fd()
Date:   Wed, 31 Aug 2022 17:16:00 -0300
Message-Id: <5-v2-0f9e632d54fb+d6-vfio_ioctl_split_jgg@nvidia.com>
In-Reply-To: <0-v2-0f9e632d54fb+d6-vfio_ioctl_split_jgg@nvidia.com>
References: 
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: DM6PR03CA0066.namprd03.prod.outlook.com
 (2603:10b6:5:100::43) To CH2PR12MB4181.namprd12.prod.outlook.com
 (2603:10b6:610:a8::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 136ab6ed-d833-4ec5-a019-08da8b8da219
X-MS-TrafficTypeDiagnostic: SJ1PR12MB6316:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: LZIgQZBZdGkb/tRhKcs3s1tHBdUcjTBDry+VQImWzjPmjKUifhaaDGeblCOf/RbKsG639Z3dvag9muxtktwQpomzk08w9eYVgXXkRAFepFakNgILdUPcsl3CynzhHNWMzTWMt/Ep/ADHDvFBDTYHYHnzG8GRGSV/5Q9neb4GmoT6EcrZ3tWbj3g+q6BBnJ14L3OJ12NaOJTRgo+lxa70HtUgJv4PibyLyWhp6R7bSUc4NI3CUmuudT6me3r7rd4QURqqhJkD6eTl8x81G9bQkfP7I+dyFR05km6SSxHI66kpjMGT4IPIgRNIB7EG26rh3bxUr4KB/yL2UfCOZUajSvJ/0lOerWKZT0kjABQThynKsvTEMEuoTNaLHvb3jSV94AKHFDhtMAJK9z3FhItRlFaxBCjHw9ssKJlNsH+cWLJnmbw9ZYhmDFjb/ocHZLLN/V8Tf/ePCrG2XwpZNx88Onbm6bydYXRfy83XlgLZ14lLmC2AXaIoxk2j1nb6IAUx20fWzJ/vDSJbsSFZ1//EORA9TwZq/Ipn31LfPjvFgp6PTt2CAEfe+U1As7W5iUtiBxP1j/se6Ljgcgayz4aQV20kCWwR/VAJQ1IMw/VJ9Z5+ah6tm97tIPicj7HwNPpNtXjACT6SRwWF2ZtN9r1mXh/7acM853WjPyAdIJsd4Xxe5avHbSJeolZCui8Qq1O/W9JjVJKyTLIN0cWWpJMHT4zk7DDo7oKyzNXzLFKO04xH7hxhFEtj2j7j2MefDvb1
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH2PR12MB4181.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(396003)(376002)(366004)(346002)(39860400002)(136003)(186003)(5660300002)(110136005)(478600001)(66946007)(66556008)(4326008)(66476007)(8676002)(316002)(6486002)(86362001)(36756003)(8936002)(41300700001)(2616005)(6666004)(38100700002)(2906002)(6506007)(83380400001)(6512007)(26005)(4216001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?KvlXlYwhkum6W2WEq0SkHNjET/kbn+H36giLvA4BCzezCptuS7VxP4iugQde?=
 =?us-ascii?Q?mGTxkenEozotUguaSplyVcykuhHHmLe4dmbVi/y2uFZIChtWTC17GMrXgBPl?=
 =?us-ascii?Q?J3sdSDbg2z2p5ebKUchf7vobf9ZYFB/mzG0+cuDifAxSrc6LLrJVLbX76jNF?=
 =?us-ascii?Q?dB0au/PdECRdUPYf34pyLLxQDA5Ddq82znKRA8yE6p7FnhWM9VFz90oeX5nR?=
 =?us-ascii?Q?vJ8jt2SOzx/p8tGxjiGFaPIXsEpF8+iZYhZj2mQWp22lulNw9dW0TgvFzCv3?=
 =?us-ascii?Q?j3x4yyGmiLot4AHTcc8jYiPlh70sCGH2exUm9BAHZ11v8I5Txrj2CGZmWH/Q?=
 =?us-ascii?Q?M9+6Ahq7bXVraGRuC4FjVLfBQmLofxkJT99mVAPh02efWBcj+SFBzL3Ww+2O?=
 =?us-ascii?Q?gs7NA3XBBIrNMbctMFSvz+yvzFJkN8uhsZQlST3aCTPBl3Qc3DUPw41H7Oz8?=
 =?us-ascii?Q?BQTAIkYJ1kCADVHoqbTZpKZTLvz1xQZabfnzzyCwe2TYNzSFrTI4WPzZvWlc?=
 =?us-ascii?Q?JuncZ43nZHaHNmSRcsuNIiVoHGDncNdu6VyY6kKgA/DEWgvKaiEU9o+gDtaI?=
 =?us-ascii?Q?OYZeOz3k1O+lLpinXhJ0eoOR8dHQhEH/lsSFUcAsdGU6bGicu8Gw+XJlRNQn?=
 =?us-ascii?Q?fxLTHi2w67qyzyJvlAdB6Dg2033KkUlxGwAQ5hVu0TLbQHHeOttDHL3Td2ou?=
 =?us-ascii?Q?1WollCD83mZ7iBN14ghOokPVrq7PguGt7LuyDlbIdpDhgGSc0JwKTJ43A7Cu?=
 =?us-ascii?Q?mZHWtrGZ3Ov1Dw0bVfDY5aS9SrnghX9i+994AdOMVl++/asBWNIdgNU8e7As?=
 =?us-ascii?Q?Jb5NH0+YQnaLI0OQZyqNyT5+eiHCGjyR/vNRnHllfimKF+2NZou+5NKLth8m?=
 =?us-ascii?Q?DEh+SAybLtixcwWxyiT41F8s3WsSAwB6sdk5ovyV+hzjxkjUeGjpMgMEkXYn?=
 =?us-ascii?Q?Zjqy1jk6T8ck2WfDa5oakWYX06SE4aEcjwmBl8LVFoRbuTCriHbQAsggoD0G?=
 =?us-ascii?Q?rwkHV2T2GseFoXJfjW/LuI/v1ZlFK/GgDMmNgv8KKFOtjYF4IvKdN3rYV44y?=
 =?us-ascii?Q?4W4lSxooxuDB1QRJ/xQm1Kz9TiuW2jfZRiroATJ1bD/CzYmIijcO3uOTu0OZ?=
 =?us-ascii?Q?GllEF6juHPQcN/eSjTpG+cnkRymmjM/tXvw2qkXYfIhuBqoO+sIyEvIjmDLs?=
 =?us-ascii?Q?mXGdD3DYnDiuUjs+C4x73VDfG6CCdBLGZqfJ3mKipS/GcX9Kul2PwswotlZ5?=
 =?us-ascii?Q?FwcxIfU+SfpRVKsSocy8Yyg7DVaJDzghB+PkcAlDJxftSjnQ77tK9wX9147i?=
 =?us-ascii?Q?ltuMzGiuQAZ1MOuKxblb491AdQzoOac4uGlkWQMdhjYphvbHP7kZ4Uwp0VCQ?=
 =?us-ascii?Q?PHMTOZgNDerErmOLL51KblcuU53ZsN7IdwRvZnxKPdTd2xI4UnpITsom8OcR?=
 =?us-ascii?Q?wzG8YiwIamGntm2F3TyOgq1XNK+Wnu+2FFlMdy9C+sy2SE6OC2HOV+9VT0aU?=
 =?us-ascii?Q?QwMTSteR7SQ9FbUerAJCvpbjyvoqlNFfvWZUU6ve25Kz3JWMTJ1ieI1jd0cL?=
 =?us-ascii?Q?dtdUj3bNERdROG2NBfAXfAw+VCUimM7HHgZvNF+G?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 136ab6ed-d833-4ec5-a019-08da8b8da219
X-MS-Exchange-CrossTenant-AuthSource: CH2PR12MB4181.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 31 Aug 2022 20:16:05.3678
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: n9+wnEqFowRwLBP1aqqhyoSX+p7NXnUxu1iCX+YArzvmLu3yLEBAP1c4CL29jMVK
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ1PR12MB6316
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

No reason to split it up like this, just have one function to process the
ioctl.

Reviewed-by: Kevin Tian <kevin.tian@intel.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 drivers/vfio/vfio_main.c | 24 +++++++++++-------------
 1 file changed, 11 insertions(+), 13 deletions(-)

diff --git a/drivers/vfio/vfio_main.c b/drivers/vfio/vfio_main.c
index 7cb56c382c97a2..3afef45b8d1a26 100644
--- a/drivers/vfio/vfio_main.c
+++ b/drivers/vfio/vfio_main.c
@@ -1178,14 +1178,21 @@ static struct file *vfio_device_open(struct vfio_device *device)
 	return ERR_PTR(ret);
 }
 
-static int vfio_group_get_device_fd(struct vfio_group *group, char *buf)
+static int vfio_group_ioctl_get_device_fd(struct vfio_group *group,
+					  char __user *arg)
 {
 	struct vfio_device *device;
 	struct file *filep;
+	char *buf;
 	int fdno;
 	int ret;
 
+	buf = strndup_user(arg, PAGE_SIZE);
+	if (IS_ERR(buf))
+		return PTR_ERR(buf);
+
 	device = vfio_device_get_from_name(group, buf);
+	kfree(buf);
 	if (IS_ERR(device))
 		return PTR_ERR(device);
 
@@ -1215,9 +1222,12 @@ static long vfio_group_fops_unl_ioctl(struct file *filep,
 				      unsigned int cmd, unsigned long arg)
 {
 	struct vfio_group *group = filep->private_data;
+	void __user *uarg = (void __user *)arg;
 	long ret = -ENOTTY;
 
 	switch (cmd) {
+	case VFIO_GROUP_GET_DEVICE_FD:
+		return vfio_group_ioctl_get_device_fd(group, uarg);
 	case VFIO_GROUP_GET_STATUS:
 	{
 		struct vfio_group_status status;
@@ -1267,18 +1277,6 @@ static long vfio_group_fops_unl_ioctl(struct file *filep,
 		ret = vfio_group_unset_container(group);
 		up_write(&group->group_rwsem);
 		break;
-	case VFIO_GROUP_GET_DEVICE_FD:
-	{
-		char *buf;
-
-		buf = strndup_user((const char __user *)arg, PAGE_SIZE);
-		if (IS_ERR(buf))
-			return PTR_ERR(buf);
-
-		ret = vfio_group_get_device_fd(group, buf);
-		kfree(buf);
-		break;
-	}
 	}
 
 	return ret;
-- 
2.37.2

