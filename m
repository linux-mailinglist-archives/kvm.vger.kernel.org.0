Return-Path: <kvm+bounces-7981-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 08D41849687
	for <lists+kvm@lfdr.de>; Mon,  5 Feb 2024 10:34:00 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 79618B22D27
	for <lists+kvm@lfdr.de>; Mon,  5 Feb 2024 09:33:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4C4B312E67;
	Mon,  5 Feb 2024 09:33:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="Lrm6tTSj"
X-Original-To: kvm@vger.kernel.org
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2076.outbound.protection.outlook.com [40.107.237.76])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8C27612E41
	for <kvm@vger.kernel.org>; Mon,  5 Feb 2024 09:33:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.237.76
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707125629; cv=fail; b=WpCapPpdMC2e/9EaM/HLcw22nRpE+faRjGvuqnshTpN/xxgUhLxh0KuswfdQSV2VxXkkGyutxn6p1h4tPnz2MwUf5s7dfYk5R3VKAeoEiATM92sjGXlzVv01plCRGSSrnectsm1e3b4C4GQLJsNn9GA7bM3xfU6Q+tW+hoGuc5E=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707125629; c=relaxed/simple;
	bh=VUAnD6TDI3pOVPs5Wwb2Ma7E7FWynnPVMzf6RfGJ19M=;
	h=Message-ID:Date:MIME-Version:Subject:To:CC:References:From:
	 In-Reply-To:Content-Type; b=YqYmRsr8CcvDthLAY1C70yLEqtA9B1WIX8jye1+V5Lcgpm4eIYl38O2PCifXRCvD9pryZrC93bk/zn29bZHk0+gMngbPnQt9VM9SFt59KKUn1csqxJVm7YUUt1hI1JQV0ohe6x4YmBzHUipIFXXzhMrISQhc6FmzSlTM8MNgQRU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=Lrm6tTSj; arc=fail smtp.client-ip=40.107.237.76
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=SvDD8t3plXn2ULp0cqI8I4cE0mQoygwByIxO1QeVVPvl9U7jEavsslEiLfwUqi0qcj0neSAKiUIoFcv2Jqva/hp0Lfgf3OvXkh+ELfrbxhJCgR7h/d6euqxr2Lenyd7ye8XXz99VHbc9ZFUHmLMHnsms/VuQXpQo44TiBkib1pLKGs0JdZmrR7b7bwpitNSCFcv/fU6kAbZZtBsntynXtWGkM8Dm4MVKfJA36Ude3BHycj31os+ZQQCN5MRG8XqIalUSBmgFgpyIebBTwaH3tMNwSN1V+Eir6nlO6wJNxD2j13gU9cjKcPu3DSZqo6dpSeE1zCFbUPnIFv0MIfF8Zg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=WJWa6ZIAVyDoSzyB6C3/n6yvcu84czm18Ms6/+6K1eE=;
 b=RYHdUjwjlZsqGbYHzsbUw4ocWlmsjlilgyjWqei3DrXr2Q9wmaWhkz4XdQatoEFbiPHsnie4X3iL+PSIHwKOzU4KP+aNadSY7v9qtP596aJ3auMHxDWdq0RTY6c+QPz1sh0kxSh7L7oNR+a3R6/hXQ4WvtR+v7kIBM0QR8keZ7A44sRvKXHl6c7b2q3evLkfDJI8OAYnrlkJOqLACtVt5MB24/uACrN9U/T3F1dq1ZYJ/1VU9lsqe7e3qbNukKWG5IneKwSgzGO4NxcrySz09SB56Yp+0dnpLVp0ef4RSNidQ49U4/OuOkUooM7EAydbMfUO+mqjPlP/DVWL7IAOGg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=intel.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=WJWa6ZIAVyDoSzyB6C3/n6yvcu84czm18Ms6/+6K1eE=;
 b=Lrm6tTSj5CsXJX7nendd1FzElgo+s9U6oOefHe0T0eCkgBERcgeTSwygoUOk13adq4vYHYg8Jni+rk/ujaSHliQ3xy5ShnBcDKqjKKv7Lzygfqvrayy1ZTTam0iEoD5ZIOlvUbaRVJ2y3yISIOHlmXOZtO0N2HOY3PYHwaMcbO02t5Nb/gG5m3o1PXe7yoMw2j+NPDg2W1YGRvPU+K+jnAXVxZl/FmXoruuCWCNRVyPjP+G3SObkxLbMO3s+IiHyrqf+SUmst2mftOBm6Y/6oeksTywtFAPONf0KwIKjykTzfRJNHIyyzoJJjooNQSQ32f8zOe2zcXCpmYsRYqi51Q==
Received: from DS7PR03CA0094.namprd03.prod.outlook.com (2603:10b6:5:3b7::9) by
 SN7PR12MB7369.namprd12.prod.outlook.com (2603:10b6:806:298::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7270.12; Mon, 5 Feb
 2024 09:33:44 +0000
Received: from DS3PEPF000099E2.namprd04.prod.outlook.com
 (2603:10b6:5:3b7:cafe::b6) by DS7PR03CA0094.outlook.office365.com
 (2603:10b6:5:3b7::9) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7249.34 via Frontend
 Transport; Mon, 5 Feb 2024 09:33:44 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.160)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 DS3PEPF000099E2.mail.protection.outlook.com (10.167.17.201) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.7249.19 via Frontend Transport; Mon, 5 Feb 2024 09:33:44 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.41; Mon, 5 Feb 2024
 01:33:33 -0800
Received: from [172.27.58.121] (10.126.230.35) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1258.12; Mon, 5 Feb
 2024 01:33:31 -0800
Message-ID: <aee64214-ef2b-4122-a383-75e3a1a06db7@nvidia.com>
Date: Mon, 5 Feb 2024 11:33:28 +0200
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH vfio 5/5] vfio/mlx5: Let firmware knows upon leaving
 PRE_COPY back to RUNNING
Content-Language: en-US
To: "Tian, Kevin" <kevin.tian@intel.com>, "alex.williamson@redhat.com"
	<alex.williamson@redhat.com>, "jgg@nvidia.com" <jgg@nvidia.com>
CC: "kvm@vger.kernel.org" <kvm@vger.kernel.org>, "joao.m.martins@oracle.com"
	<joao.m.martins@oracle.com>, "leonro@nvidia.com" <leonro@nvidia.com>,
	"maorg@nvidia.com" <maorg@nvidia.com>
References: <20240130170227.153464-1-yishaih@nvidia.com>
 <20240130170227.153464-6-yishaih@nvidia.com>
 <BN9PR11MB5276E2C0F1FF06570C30AD338C472@BN9PR11MB5276.namprd11.prod.outlook.com>
From: Yishai Hadas <yishaih@nvidia.com>
In-Reply-To: <BN9PR11MB5276E2C0F1FF06570C30AD338C472@BN9PR11MB5276.namprd11.prod.outlook.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: rnnvmail202.nvidia.com (10.129.68.7) To
 rnnvmail201.nvidia.com (10.129.68.8)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS3PEPF000099E2:EE_|SN7PR12MB7369:EE_
X-MS-Office365-Filtering-Correlation-Id: cee72f3f-300a-43de-41a0-08dc262d8c14
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	eahk52d1O2avlvuUqq9DVVQaOEvcvSGq6/q/jepYU3kksT4zKvhfzrSjtxqYs58dFiCF2wBLeQzB4xyDr3a6/EbQBrYMcMGnZnlsggsEqEUM9A7Ic9igiDB/cY/1ziKkJ4ThQYNlbS+hQhreU7Io4/Cr8POJnXubUfIblRmXl09MDBa3ia1AxiknsSfJKPh/ezHVxVUsQ7EcFSaK1bOXpnVpysDG0QzTUSEa0IMZBoJWSNnPo4NI/JvzpIx2U0FoKYeJGOJYhg1cvYYxDRPNkL6lQ/+iQIux+h7kVPNAOUSnbuYE/5/IYvjv12cA/dzQAoTJKM3/SRaakZskcE0pK6+xb3CTLZef8jtnlawoe/RHI4DiOZhNqrbu9Nl6DP8lt79Jf0mm7cR99JZqSxEl3qD7I7TqtqZL2ZeekS8CaAfH5dQsKn+avYWdeuTOHq6AJnLB1T4CisqCUfXD8s59wqSHyHQsWF+H2ktsgOfsBbOGt/KpfLvbKFxERS9+e4ot1933C+7FRW+Sjxo5DtlLgxe7siD0/xrhMMGaLED6WUL+2DIvvVEw6mmxUZwNtL8953lYvTmbF78c32s7O74Y0iuhdz0+T4TO/UPKjJpn36b/lkYhFh40BXEl60+I00OiBrLvVRAJ383dcPuD6dGmd3jK/UFzvjBMHdvvNwvHnow4c3W1Jx1xwdTsknLSKsPtZKuFcFAylihqX6Q5x1VTquyq1IvnnRmG6TArPNyWmYDHaOOroM0q3zVa2kIfyNL5AysLGf7JI9MkpjwUkNPFhQ==
X-Forefront-Antispam-Report:
	CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230031)(4636009)(376002)(136003)(396003)(39860400002)(346002)(230922051799003)(451199024)(1800799012)(82310400011)(186009)(64100799003)(46966006)(40470700004)(36840700001)(5660300002)(41300700001)(478600001)(47076005)(2616005)(26005)(16526019)(7636003)(107886003)(426003)(356005)(70586007)(316002)(110136005)(36860700001)(8676002)(6666004)(6636002)(4744005)(16576012)(54906003)(336012)(82740400003)(70206006)(8936002)(2906002)(4326008)(31696002)(86362001)(83380400001)(36756003)(53546011)(40480700001)(31686004)(40460700003)(43740500002);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Feb 2024 09:33:44.3726
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: cee72f3f-300a-43de-41a0-08dc262d8c14
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DS3PEPF000099E2.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR12MB7369

On 05/02/2024 10:14, Tian, Kevin wrote:
>> From: Yishai Hadas <yishaih@nvidia.com>
>> Sent: Wednesday, January 31, 2024 1:02 AM
>>
>> Let firmware knows upon leaving PRE_COPY back to RUNNING as of some
>> error in the target/migration cancellation.
>>
>> This will let firmware cleaning its internal resources that were turned
>> on upon PRE_COPY.
>>
>> The flow is based on the device specification in this area.
>>
>> Signed-off-by: Yishai Hadas <yishaih@nvidia.com>
> 
> if fw internal resource is not cleaned will it lead to an immediate error
> upon next migration attempt or a failure after many attempts until
> internal resources are used up?
> 
> if the former it might worth a 'Fixed' tag.
> 

No, the following migration attempts will succeed.

It just let the firmware to *not* waste some resources to track changes 
upon PRE_COPY, as the state was moved back to RUNNING.

Yishai

