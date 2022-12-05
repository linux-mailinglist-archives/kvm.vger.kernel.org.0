Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A3B6C642BC5
	for <lists+kvm@lfdr.de>; Mon,  5 Dec 2022 16:31:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232009AbiLEPbC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 5 Dec 2022 10:31:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36438 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232618AbiLEPak (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 5 Dec 2022 10:30:40 -0500
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2066.outbound.protection.outlook.com [40.107.93.66])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C7E82C1E
        for <kvm@vger.kernel.org>; Mon,  5 Dec 2022 07:29:24 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Is74bJXlewoDkHwOeRa0vJJ+vj5T4k2xYFMn+aUZjsfI2u72wgxNGyGXRP2p+6ayiIb70GNp8J6T8BoxjJWGKp6sQGnr4TY/CkaDJY3WIk0+UrCEZurwxq9iGhRF3865tot6ozjRIVSJO/Om05FDBXoNS3W/i1zaD/5pML6Jm3PvsLxjndHFhtQuNzdTMsTzMTVtDPhpJRzV1mQ+lTPK18uVmCvKVNtYpWuO49/q6SMcZV1lwR3HaiaaIZOPvc3snrftfnaHraMRcp1z9SVea5JYlTiQkD5MJ4j+37mBJAYB5RSX/bD6MQGZZidSpX3vNPgGziPsR2TrT//aEXKsXg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=k2haEmn+/nGztSnzmgfdcon0zb5dF7IquMIz9HPLl5A=;
 b=Q5lXduXyxC68uirsnaNtg6pR2ioDP/1QGDZf+V0uAjesK4Tp39hZrScANgBJAQVOQx9XRg7jRJuNQCZzGZjzcXNqsuqhzaUzv3kpTJbKOCU3uta7KCVsXlbebgXTdQPvrKPBDmwJucIKm+BBp5XTPWj6dlzTLUK0M2z88TKBFAoKTbMg977A+vsyNfwYiW580ObuZoBWNdYWBwlNxBXALIpD8G9OSJsaSNUNf40/s2KabTXexmUUc4KpdJkR1fnYCjMa5u9UVZytodJ+jYA1WPZvUkVWT8XXct/BljObP5PsrCIGfJyAULzsTYwpgi+zfbdBzroRYRAnwJXF7uvZ+Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=k2haEmn+/nGztSnzmgfdcon0zb5dF7IquMIz9HPLl5A=;
 b=PMnvq7D056YRkSX/MbTqtxWOIhqeZkxSGBhmcsnlYfkETfcMgbt2jtWt33FLdnDqJZ9eQrV+bm/xRbyaX3zsWl8IoL49nYTMVfo834vrJWzjMyL9Hma3HOou2sFViA+wVs+yzyPr0YJYwgmiVGyDtEbOv+uASbeNxPoQnY3SevtdlS24UK78mlcSlFEe0uwoH55X+7oYpzG80Vuy5sDR8aTxxLket5K8aoDmGXePhd9IYB0US3UIK14CVxeABRRej+JHAbhVeUwA5uNZtKMG+5RGUjIwrl/TxaXRQrL4VWdeql6aXjM3riL3Ubs59N/QAyk5viXcy5+h9rMU57vz8w==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV2PR12MB5869.namprd12.prod.outlook.com (2603:10b6:408:176::16)
 by DM4PR12MB6662.namprd12.prod.outlook.com (2603:10b6:8:bb::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5857.23; Mon, 5 Dec
 2022 15:29:23 +0000
Received: from LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::f8b0:df13:5f8d:12a]) by LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::f8b0:df13:5f8d:12a%9]) with mapi id 15.20.5880.013; Mon, 5 Dec 2022
 15:29:23 +0000
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Alex Williamson <alex.williamson@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>, kvm@vger.kernel.org
Cc:     Christoph Hellwig <hch@lst.de>,
        =?utf-8?q?Philippe_Mathieu-Daud=C3=A9?= <philmd@linaro.org>
Subject: [PATCH v5 2/5] vfio/spapr: Move VFIO_CHECK_EXTENSION into tce_iommu_ioctl()
Date:   Mon,  5 Dec 2022 11:29:17 -0400
Message-Id: <2-v5-fc5346cacfd4+4c482-vfio_modules_jgg@nvidia.com>
In-Reply-To: <0-v5-fc5346cacfd4+4c482-vfio_modules_jgg@nvidia.com>
References: 
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: BYAPR07CA0086.namprd07.prod.outlook.com
 (2603:10b6:a03:12b::27) To LV2PR12MB5869.namprd12.prod.outlook.com
 (2603:10b6:408:176::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV2PR12MB5869:EE_|DM4PR12MB6662:EE_
X-MS-Office365-Filtering-Correlation-Id: 6cfc3abb-32da-4c49-6077-08dad6d57c5d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: orj7DITSAOQq3gTfEiBxFpEXkUf0h5N6qhszhN0RwDEU1XIfMST4qHwDUXAzf2zw/0gDhgYmYfbUiiANEPFpScRUYa0oy2QUYhVp6mTYgfiLn7Zv1z138/UGy93ovyGbskMtt9+rYjRWPUC3ARpV3rBgkLFwAF19INnMSsfPlA4JxXh6T8u6WNWWzbHX2Ti7bKtVSXRuVIrTLCFkkLTAxpILkGzgDapwbKnsqYqZZGqyuQpuNMe/RuOXbE6yvtDdtuS7J5/QQgF4LiQC5/e/SU1S9g2G2Flvr/3Qfn8hPg9c4fr2x1YmAp5L1gh6shCSQgaexCN1OtPfGfk7t2jV/5pZdUwFh2RSM6fvYU34SLraFFCGp7tI3jO4dcgCTDk59a7gcPKa591YmRbqYt9zWDQpRe0LVFKEDNwsaLw25DczFAjX+FTXDmhZMSNCKaP14CXcNoXIv7sCm2hh6bEh1lwyrye0MUpnVuTtw05XVo1x4X9YRAIdSLJMsSUk/Q8vHIj3VB0XW4jlxlgMKJREYg5RWlLNeqVqIn3P17ybUEQXVXToOJ2qp1balYYzqMJneg09+aD9lso6UkpGyw/pWia2JVaDPumkndNIqNWKOJrvSFh/+Bdbtq3JnQPXo2YRgwlnUuSY6gGArOcHYLBuxo2rISMnN5UYl0E0L90ZI5a5oYhCzacmD9d3PCM8iZvZ
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV2PR12MB5869.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(376002)(39860400002)(396003)(366004)(136003)(346002)(451199015)(66476007)(36756003)(38100700002)(2906002)(41300700001)(4326008)(5660300002)(8936002)(83380400001)(86362001)(478600001)(6666004)(66556008)(2616005)(8676002)(54906003)(110136005)(186003)(316002)(6506007)(6486002)(66946007)(6512007)(26005)(4216001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?RG1DUWlVNjZzY083RFB0SDRqcXBVRGdsNWx5SWY5WHdQakdETStLWWR2Y2RY?=
 =?utf-8?B?eEVkd2ZCYXZKZEw2bEVkZC94VDhCSXY1SFhNL01PY2hTN1dqYVlpYU40Vm40?=
 =?utf-8?B?OTFBYXpZUnhEZUYwYzMvdWNTZHErVTlNbHRRZzNsdnF1OGxaTWtUOUVTRUJv?=
 =?utf-8?B?cjRJUU5WTm9US01rRU1aYnZpcTFlSk1OemtKT3BUMVErTDQxandjOGdybGlj?=
 =?utf-8?B?ZmtxdllqSk5Va3RWYmpqMzZxeHJuTU1vN0VFT29pZW55V1BwSHZGUGdobmZn?=
 =?utf-8?B?TEVocXpJQVljaWN0WFl0bjlvVDNMdVg3QXRJMlVLTWZwVkpDanVKWExVTzRN?=
 =?utf-8?B?V2ZOV1hWNjNZRlIvYjgvRHljTFBLVzVYRGd5cGJJUHhPd3NNOWtQdHFmNVF0?=
 =?utf-8?B?NTBmMUZJYmhUeEhWdmlWamRsbzVpb1NlWGY3eXk1KzluK2czMktMZStSQnJq?=
 =?utf-8?B?NTJFb2l5K0hvVS9Bc21HVDV2c0tzU2tFcEhnMDRPRGhhTFFPeGtoZ3ZKcU54?=
 =?utf-8?B?L0w2NGcyMUZSMklHYitFajNOQWltemRoSVhGNkN3dWRocTNrN2NZanBLRS9Y?=
 =?utf-8?B?WTg1YW84MWJ4eTJ4Wm1jcXZlUnhXa1JFeUNIUzNGbmVjcHRjMWJ4L01Udmpy?=
 =?utf-8?B?S3dQQ0hXRDNpcXVhNUdUSlVHbFdJVndOVGV4cGU2SWpJS0t3YzY4YVhCak8y?=
 =?utf-8?B?TnFTZUV5MmR5dERGcHhxUEZ3dlNDdk9KQWNpN0x6YXhvL0xrZVRNVzJORWVa?=
 =?utf-8?B?T3oycHZSTkVEdzdTVWM4QlBYSjN3emROWEJNMDRLeXRKaVNZeldETXZBYTZa?=
 =?utf-8?B?TFRKSGZmdDIxdXVmRFZ3aUhZZnNHbFM5NkVnQzRkR2xML0VaZGdEUVJTczha?=
 =?utf-8?B?UnlSYWQ4VWo3aGU5bldmbmhwTGZkUHovNWV1MTdYUDF4Uzl3WE01QktJcVln?=
 =?utf-8?B?MWV1Z1AwMmcwK0h5SDR2bEVycWVvYW5raXhvWnMwZFJDMFF1V2ExcUxiOFRB?=
 =?utf-8?B?eW11Tyt5TUNDOVNTRk5XNnBWNVY3cnVaUnJKaTloT1k2S2syRWRQdkR0cnRt?=
 =?utf-8?B?MzMyTXZEWS9YamFROGJqdjFiWFFJa0s5RE5OcFRlRW5EcVQ4NTNaN2pJR3V6?=
 =?utf-8?B?ZUZTWmZCcm4rYVFPYU1NRjRhZXVVY3R6UjZYZW9iTlVGQzZaTkd6cmRkVTU4?=
 =?utf-8?B?dDBuYWRYZ3k0allUYklNeUExdkFQUEFWcnlFdlc4VnZqRnE2VXFHQjZxTjNp?=
 =?utf-8?B?eGJHdlZHT0xkbW1pTXBVdWxhS2tRZUtBUVErS3pEK2dvM2NQeEdnWkdRbUR4?=
 =?utf-8?B?NU5rQ0FSUTEyZFpvV3FiT0RFbnFWa3owTUQ2cU9vN2R2dVJHcUxHcjlPZHdz?=
 =?utf-8?B?alg0bGdGYVUyWHRBWHVhSEdTY1ZJa3Z2c1duWVJ3WHk1elE2b3FwNjJNRkNK?=
 =?utf-8?B?TnNJaEVwZmRwZHFzdU1qbEVnS0Z3Wm9wcFdMMjVQOUoyVXlXcFVEcm5yZ1Vv?=
 =?utf-8?B?bFB6aHc0dFdXZ1BLclcrRUYzM2tPZ3pCUmp3VjlSL0h6TVZLYWMwQlo3UWF2?=
 =?utf-8?B?Nm5ydVZiNlY4Sm8rR2s1aFlNZGFsaFFhUHdScWRIMUhKRzhQQmZGZHFVVnMv?=
 =?utf-8?B?a0NoSHBLZHJjRk9lSys2cDVUa3Z6ZW96SXNwWFF3WDJTa01SV2hKeDFrK1hI?=
 =?utf-8?B?YVdZbW4yUGxNUlhXMVcrVDFxWGNJbDNIT2oyODdqOTNnTFZrT0owbVRhVzh1?=
 =?utf-8?B?Tnhuc2h5eEZpK1BKNHJ6K2dEb1VVZkxlVkxlYnMwdFhIbkV1V2VrcmJraG14?=
 =?utf-8?B?eWFxd2hzQ2xYRmd0RmMxSmdZajdoclFKY3UrakRUNmxBcVhoeEk4bzdUa1NF?=
 =?utf-8?B?SXR2VlQ4MzhGVmY3T3BnNVpsNTVoZFBsTjFaR1M4azVZTml6bXlmUlkvQUNa?=
 =?utf-8?B?S3RuVUw3dVorSG54Z1FPN1BQa2daQURyTGFEWFB1VTg1MHNGN3YwSEp0Kzly?=
 =?utf-8?B?TTBvd1VoNzgxK0xobXk1clNKakxiSFpBNmx4eGNqM2JSeGJZcFY2WkU5bFh3?=
 =?utf-8?B?K0tPZXN1VjY3dndhN0I1dUJXT0FNUko0V1VPaG5MdDQwV1dYTlFkRTlHNFlT?=
 =?utf-8?Q?bnXBGgkNAbbYZqDrpaQg6M4NY?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6cfc3abb-32da-4c49-6077-08dad6d57c5d
X-MS-Exchange-CrossTenant-AuthSource: LV2PR12MB5869.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Dec 2022 15:29:23.0468
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: CNwAZw0t2V2/vQEhY/oiUjXT9a7CHMhCsRaw2OFHT+0baQI0XeLmtsDPYDnfm59i
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB6662
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The PPC64 kconfig is a bit of a rats nest, but it turns out that if
CONFIG_SPAPR_TCE_IOMMU is on then EEH must be too:

config SPAPR_TCE_IOMMU
	bool "sPAPR TCE IOMMU Support"
	depends on PPC_POWERNV || PPC_PSERIES
	select IOMMU_API
	help
	  Enables bits of IOMMU API required by VFIO. The iommu_ops
	  is not implemented as it is not necessary for VFIO.

config PPC_POWERNV
	select FORCE_PCI

config PPC_PSERIES
	select FORCE_PCI

config EEH
	bool
	depends on (PPC_POWERNV || PPC_PSERIES) && PCI
	default y

So, just open code the call to eeh_enabled() into tce_iommu_ioctl().

Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Philippe Mathieu-Daudé <philmd@linaro.org>
Reviewed-by: Cornelia Huck <cohuck@redhat.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 drivers/vfio/vfio_iommu_spapr_tce.c | 10 ++++------
 drivers/vfio/vfio_spapr_eeh.c       |  6 ------
 2 files changed, 4 insertions(+), 12 deletions(-)

diff --git a/drivers/vfio/vfio_iommu_spapr_tce.c b/drivers/vfio/vfio_iommu_spapr_tce.c
index 169f07ac162d9c..73cec2beae70b1 100644
--- a/drivers/vfio/vfio_iommu_spapr_tce.c
+++ b/drivers/vfio/vfio_iommu_spapr_tce.c
@@ -785,14 +785,12 @@ static long tce_iommu_ioctl(void *iommu_data,
 		switch (arg) {
 		case VFIO_SPAPR_TCE_IOMMU:
 		case VFIO_SPAPR_TCE_v2_IOMMU:
-			ret = 1;
-			break;
+			return 1;
+		case VFIO_EEH:
+			return eeh_enabled();
 		default:
-			ret = vfio_spapr_iommu_eeh_ioctl(NULL, cmd, arg);
-			break;
+			return 0;
 		}
-
-		return (ret < 0) ? 0 : ret;
 	}
 
 	/*
diff --git a/drivers/vfio/vfio_spapr_eeh.c b/drivers/vfio/vfio_spapr_eeh.c
index c9d102aafbcd11..221b1b637e18b0 100644
--- a/drivers/vfio/vfio_spapr_eeh.c
+++ b/drivers/vfio/vfio_spapr_eeh.c
@@ -24,12 +24,6 @@ long vfio_spapr_iommu_eeh_ioctl(struct iommu_group *group,
 	long ret = -EINVAL;
 
 	switch (cmd) {
-	case VFIO_CHECK_EXTENSION:
-		if (arg == VFIO_EEH)
-			ret = eeh_enabled() ? 1 : 0;
-		else
-			ret = 0;
-		break;
 	case VFIO_EEH_PE_OP:
 		pe = eeh_iommu_group_to_pe(group);
 		if (!pe)
-- 
2.38.1

