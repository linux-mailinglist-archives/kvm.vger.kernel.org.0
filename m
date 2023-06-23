Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6021473B8BF
	for <lists+kvm@lfdr.de>; Fri, 23 Jun 2023 15:26:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231429AbjFWN0N (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 23 Jun 2023 09:26:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52446 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229958AbjFWN0L (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 23 Jun 2023 09:26:11 -0400
Received: from NAM02-BN1-obe.outbound.protection.outlook.com (mail-bn1nam02on2065.outbound.protection.outlook.com [40.107.212.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 142CB19AF;
        Fri, 23 Jun 2023 06:26:10 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=TtDg7AKY6Yh2jenXSssbkRS8SjVolbuxLB3B2WLSI8qhx0qCBGhPLNw0ZErNfoxymspV8yMh+iE3b66B7WQYeKR/QWWQdOfDAii7RKT9z+rgTXB7/qtUN8GN+IZ0qc3MOXwXch3VMQksqOaPu/ft2iCQLocn5vIXBItuD0VcTJjrpte5telD7lr7EglZd078inryvib2B2PoK4xfeD1fjZSUYV1FQcLUPkeuWgXFazFs/a2aYR4IpX+yPXJxlBEtLX4TPEsdKVnbmFrd6d6aDFAhzsFCvpxngej0K8OJ4kwN+YK0KIlfftzlFpSRbvDfhvtrD8SgCIglpXpAAW1uYg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=8W/+hPePb88MefYVDijPUcEoewwsqtRPAn5mtFXRx3s=;
 b=ZHzSl0lbQ9qRDYfrhlzGtKVZ4nfVAjY9MtFv1NB2JphZErwLPjkE5z2FzZkLBEIf/yF+2xOWsEvd54f0kWV1xiJa+jAS6WBoHLRDljrCOXV+yyhOLE1arL7Hpz4MHrgyWud3LY7WNWxEMDaXgaQIKpUcQkfALnhrPASrKd5wvZhHUxSYC17y/5Hvxmv3FoBWzjeMGMV5EpiVuz0Cj52mLr+bRUm+zGTSTPnwkwueTzjEizZz6F+qCEuusFmfsyiAeBnXGqzXJRg/M+wyT+8s7BXZOKQ2Y4WJ8rJt7OWNzx8YeS+++j2KlTtOqx2IUrigQ/NQ5Or8XEWR3qLAdnMBTg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8W/+hPePb88MefYVDijPUcEoewwsqtRPAn5mtFXRx3s=;
 b=fKf8PO4WtLVvsr4uDkd8GR5CA34optM20NBTypNFUUCNF4OoBRk/sqxq4CKBHaIm9bGsqjGuJ0N/ubNC56TUKGHpBu0BD3FISutEe04uEF1aBplJrFq2/eo2GNcMJa0rg1WTZ1rUO8MjwvN8Unnc4HOwe579LKIjelFKAlTMruGgVAAQfQG6yTem+zqGUC0CcNtrevDYKSxHpH0sKfAckmSY6/UBtOgVKwc+vEQvQi7cKxZ1eIBWM4YedleN7m9oXGp7fUqbwZ/dVQptNDmOsNW2wZtD889aQi2z2EEbDRhtgB+v6q1m5pqGS7V1uXzhb7apfK8cMyIdeAeXKg2vPw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV2PR12MB5869.namprd12.prod.outlook.com (2603:10b6:408:176::16)
 by DM6PR12MB4861.namprd12.prod.outlook.com (2603:10b6:5:1bd::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6521.23; Fri, 23 Jun
 2023 13:26:08 +0000
Received: from LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::f7a7:a561:87e9:5fab]) by LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::f7a7:a561:87e9:5fab%7]) with mapi id 15.20.6521.024; Fri, 23 Jun 2023
 13:26:07 +0000
Date:   Fri, 23 Jun 2023 10:26:05 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     ankita@nvidia.com
Cc:     alex.williamson@redhat.com, aniketa@nvidia.com, cjia@nvidia.com,
        kwankhede@nvidia.com, targupta@nvidia.com, vsethi@nvidia.com,
        acurrid@nvidia.com, apopple@nvidia.com, jhubbard@nvidia.com,
        danw@nvidia.com, kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v4 1/1] vfio/nvgpu: Add vfio pci variant module for grace
 hopper
Message-ID: <ZJWdbbNESp1+6GVN@nvidia.com>
References: <20230622030720.19652-1-ankita@nvidia.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230622030720.19652-1-ankita@nvidia.com>
X-ClientProxiedBy: YT4PR01CA0199.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b01:ad::23) To LV2PR12MB5869.namprd12.prod.outlook.com
 (2603:10b6:408:176::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV2PR12MB5869:EE_|DM6PR12MB4861:EE_
X-MS-Office365-Filtering-Correlation-Id: 2a24ac50-9f3c-41ed-4f6c-08db73ed671b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: /sotJRuOo86wRWWHSmRj60asIC5+3Q+g19Vse0vrsao5nwQYuKQS2S1ERq0biEOhp8+rYak5jXEPurxNzkDeEfbDUCuQeupKvAMO3YPufH+tU/ymZkR6+R4YRdybqt17fd1sA9LR1jAXEeUvxU5ajnjqa9tUMbtFV+b/s+v7SM+VqfbZyeBOG3bDod9gvL4B/j4y7CJpuBgYdLSrHn6xJTh78jMUAoC/NOX6D5sCsRC/I4nng1G9wwpzmwFq4HOEKKbtYmljjxh4U0yknA2s4UARDokeInUi8trXPBXW1NesyNcfZZdTjDSNCTrvS9K7W7urp2Vh5fhf11dlmNjdRVS9MVneRsqqjWrvzbGuS4nE+TSDtV8ykv7m7nkpP78DErv3lPLgMPXpwa3QlFlaZZDODJiV3YujqABtK0Uo/O7EpTq233CvPFarP8P892L9+wO36vD+PiM5Zv9NXhgft/G0AnkO1KErT1x9iqmbIGDZ4nEvXvs68t99zuJlpJExtAs5uxKSVXSv7qUi9z0fP14pHOoDI4aNVZAMP6wHCIaqb+fegyvUv+2EUu8Tvip8YeZPp1BzL/pWdtlnpZraPsD7LGhxmYjGRIHE6maJC+Y=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV2PR12MB5869.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(396003)(346002)(136003)(39860400002)(376002)(366004)(451199021)(37006003)(6636002)(478600001)(4326008)(83380400001)(86362001)(36756003)(2616005)(38100700002)(4744005)(2906002)(6512007)(26005)(186003)(6486002)(6506007)(41300700001)(8676002)(66476007)(66946007)(8936002)(66556008)(34206002)(316002)(5660300002)(67856001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?Qu71bGoB3pn+Fhp9dJYED/zK7bfA1WiWJlfqetxwO8ZPaDOhBdRWxvlf4XVa?=
 =?us-ascii?Q?RKY1aCz9IYcsi+VH5A2jDRFHh8Er83zXUBuUUDMSbRLdDto8L947H96jNmCx?=
 =?us-ascii?Q?8Dk3kFv1wCF5O1U4qcHn2GsPbz28MkjH388Y/PhzKgmL0OfUU8NxsrTK89KF?=
 =?us-ascii?Q?tpcIrTYbOxLNWUt3fioBxKpbZ29Ww7Q8nXtyEOxz96x3zueIq0xeZ2qdlzKc?=
 =?us-ascii?Q?bCFhx4djpFfFTK3vAmYHC+EKyHIwoGE3RDIA9e4PfUvbepZ6VBUNtmTNxdgC?=
 =?us-ascii?Q?TNEmvN4RuCUfORPcunzRW/B+24FjxohAedozUTjwhEaIgOCpf9zPCaeHZYO2?=
 =?us-ascii?Q?hav/WgPv/62Ld/Gd3dYPjLHlCXskVqhVTVKRDPuTok8GULZ8iwT9OYDL0vF5?=
 =?us-ascii?Q?IP8FEzUKOUqYBwFAN2oB/h3A7lV2cfJU0/ku/Jz0woM63DBL0XB3CW4SugkS?=
 =?us-ascii?Q?yTXOIfob/waYzuPPiWn7ZBPcuaj0CTfI4kLj/xqL4gmgJzYDpXQwm44ghP++?=
 =?us-ascii?Q?mYD8c6VZtLer8/u2e5879Ezh9epl39BIOK894N0tm9LLimPoaUwgeaO6rSAG?=
 =?us-ascii?Q?lU2O5P3ItTTwzka/JTBTGDQFbGys8KYcCvicvWJ+ukDATIkgmLJruJtCXifp?=
 =?us-ascii?Q?1/JJB8aSTzEa9PKPsfZWOrNltKyPknovTpjY/rEClWb7I10+nBFFLH+hT8XN?=
 =?us-ascii?Q?hhwI8i/aivfb0LFcFE1cq5nH6Q3p/KcQ3mqQsl081cGWpWasxDoDey7VSPy3?=
 =?us-ascii?Q?5dIRDB9IfuJVThkiWGXXrHabS8nwlkG8JAscnyrBqzbZ8P124lP2qZtlofct?=
 =?us-ascii?Q?hlVxNdeQ4GUHkmrWej7zg2DQVd4OPwDfrD3d7MaJ57FUf0BKskNdibzlmG5d?=
 =?us-ascii?Q?7ZV7bKTyfo6dNixw6RtN9dokgAMQwUEq4qJGTZhbL3Z15MP6AZ+YMOn1j8e/?=
 =?us-ascii?Q?xDbHrJ/VQAgzBlSmqWKyLi7jT3C2QUBe6AWQmSlPR7Shsg3FycaSNs0IMaZY?=
 =?us-ascii?Q?YMgftKr9VcaxW1hUEpMrxwikLdvSifcxwj9lXsNZSn7lN29gdV+XLsH4Kv1n?=
 =?us-ascii?Q?dVC6XKnowr9mUHztqTAybX8iGNZNBDJYN1e7Z2fukZKBRFpydz0p/RguUPii?=
 =?us-ascii?Q?0DcMZy6OJcZ4ZbtPScj1OYoPyBBqEo4J+wOxMlW4k5SBhTG8otWOSTUKp6ck?=
 =?us-ascii?Q?C2K/BZAh4UQPJ0dED5nWB1PAVAyufp9+9bs30a5q5PwJHzV4dnu0xKRZ/t4I?=
 =?us-ascii?Q?TVUnawPloSoZSc9JUOMwPx+jJXHJnQzM+CMDE0BwJUfKAUDmNmsY9hQPr2ch?=
 =?us-ascii?Q?/ZZ6FGU9ShViducDvzNjL53rXiHZI7zhoYGFemecVr4kb+VXmJGKY5jMmI67?=
 =?us-ascii?Q?0GOGimg6xhRUFgvT/+xpdPUZvi5GPZtVxsO1fSuZt0ygn3Ozu39XOMgid/za?=
 =?us-ascii?Q?Kb+JEGoruqYzkdvDzaBRN0EAiC6RrZew+djI24/qm3PIE8y0PLjyArMJZHoO?=
 =?us-ascii?Q?k2oljBG8X63eR0BppR9EqYaPN+dT14Ps007F7MKyCJUWFT+TVnmpaShoDzIL?=
 =?us-ascii?Q?sm5nkp3bbRSuYHxRcEt9QXPY9aPl44GbDDIA49f2?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2a24ac50-9f3c-41ed-4f6c-08db73ed671b
X-MS-Exchange-CrossTenant-AuthSource: LV2PR12MB5869.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Jun 2023 13:26:07.9042
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Btn8GwtvZgDEtY1RQebv0Qal8hEYMDUmO6YzKD0sw/XyH5V+wGDTSObJh6dam7ZE
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB4861
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Jun 21, 2023 at 08:07:20PM -0700, ankita@nvidia.com wrote:
> +			if (caps.size) {
> +				info.flags |= VFIO_REGION_INFO_FLAG_CAPS;
> +				if (info.argsz < sizeof(info) + caps.size) {
> +					info.argsz = sizeof(info) + caps.size;
> +					info.cap_offset = 0;

Shouldn't this be an error if we can't fit the caps into the response?
Silently discarding the caps seems wrong..

> +static ssize_t nvgpu_vfio_pci_read(struct vfio_device *core_vdev,
> +		char __user *buf, size_t count, loff_t *ppos)
> +{
> +	unsigned int index = VFIO_PCI_OFFSET_TO_INDEX(*ppos);
> +
> +	/*
> +	 * Only the device memory present on the hardware is mapped, which may
> +	 * not be power-of-2 aligned. A read to the BAR2 region implies an
> +	 * access outside the available device memory on the hardware.
> +	 */
> +	if (index == VFIO_PCI_BAR2_REGION_INDEX)
> +		return -EINVAL;

What does the qemu do in this case? Crash the VM?

Jason
