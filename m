Return-Path: <kvm+bounces-7979-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 225D6849652
	for <lists+kvm@lfdr.de>; Mon,  5 Feb 2024 10:21:28 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 8CCD61F25313
	for <lists+kvm@lfdr.de>; Mon,  5 Feb 2024 09:21:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 41A5112B6C;
	Mon,  5 Feb 2024 09:20:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="Os7+2ynd"
X-Original-To: kvm@vger.kernel.org
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2077.outbound.protection.outlook.com [40.107.243.77])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB26E125D1
	for <kvm@vger.kernel.org>; Mon,  5 Feb 2024 09:20:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.243.77
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707124853; cv=fail; b=WxRe//qqAb80fHy9n2ZGuif4xahEkVS1eFJCbLW0goiNYz42cxbFUro8eG+mtR1cYJ+M2asOpmBdgNx8Jt08gcm8KLmxJhuXFD+Nt8MYdxcHG8buavzyUCYfAMQAOxwf19bhFFcTsnAnW2Hny5LoCHAv24DhSY91AFVvIF8S9VM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707124853; c=relaxed/simple;
	bh=fWAmn4E7N7W1C7UJ09UZGk+6bN9rWotIGG3f+gEcoWc=;
	h=Message-ID:Date:MIME-Version:Subject:To:CC:References:From:
	 In-Reply-To:Content-Type; b=AIvtcZYEjAgwKLTRGi1NB6IW40hmVxkSLIq1Uic/GWqyn/2bEeX9zfcyiN2mcS5qVLqB/Sff8k56eRs5kqV2oKQBw8caqL84DB5ifcChQhvH9JJMBincaa9WXI5PEPkoTj7cI/T24QmZ8K4WPN93Xz3lu2kA5T6aPLniququiYE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=Os7+2ynd; arc=fail smtp.client-ip=40.107.243.77
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Z72VW4b0nXQzxWOmPT1WnzHwJ172QGCUyrL71ey3mRPDyECgQxXA6aGZbuMSUg7x+ZJOtEKk0wCem7V7GoncMsmAjo7+OAaIlMstgrFWDzvxAhVyeD20FgPbhbckD3ek9/NTbiAkxtGPYCb3HmdCakQ0zFhdbVkD7gIaUnvDERiV7N5o0pgNtmHxxMFtDM2ieo5ymZTCRI9AHRbYnwR90MP0E5Dn+Ig5gDLZ/8YA+QMe6NL9Yca1oR+4X2b0Gd+S1TKT7SPD+nE/gS07H4NA8/aAV8Ymkb3kcJf/Nk3W/PrVMQucOKLlrOs5AQY2Db549vDtfOn3dA2rL6QoBxgv6A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=elnuqFtPwYenzU/kSnPVoABW7KXKdn+tedaRSzqiqyk=;
 b=LEvcRyXKonx2HRYtzj+dOepfjIdcjTNDBYuAEtl+g6yNLUWYDsGDf2ttaYwghydpKO17xn1JDfdmtqPKfmGTGmX3Oe9P52xTcgW3+5Tu2xIbNQKJX1StefVhtl+jTb0Rh1ZaaBtyekDHwiNjsvUY9cpkL9M6NQO34tnNITCYdGDW+FBglAyuDzKsWTxLuR3sberPlN7ODqbr9nUC5//GNRpGJrSAY4B3CJv9YFeOXPvHOc6pcBM3P09vEC1pcC1JovoNe5byN6WRKPNKUkK4smg1oJKBrVhaPJn0P+lCYjJxqr0J9A6UQaqkqsjuZ+aI1MSr9sSSMG6FWKzib5q9hw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=intel.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=elnuqFtPwYenzU/kSnPVoABW7KXKdn+tedaRSzqiqyk=;
 b=Os7+2yndkPrtyAG7rqy0aDOEcHZ4Els1dEXC1iJllNo7yCMke0ZkKFT9PNM31JJ/HkkzPEo2KtWVrFN5TYNxccHlQBiZ0ajzHksIQ5/VuEPSciFizjI/SNSyqecZHxM6CNa+1t92Q/X8sh9Fpw1d8jzy1XnQ0HkL0q0OmmKnpkSSw+eJ/D7u0eYxprM2EYVOnhy6aqgddz7xetqQGbcRYoRnM1v9xaNKtBHseF6g7A9H0C8AGWBeywcYybF6VVmwYMlN1MlI10Kiuw+J3OPiO+7ppKsp8zBWXSHmFcnbCEc4SJoqHv6ydRc1ujXPKNfbS8KPFF8ZeLU3nMC0p5Ze7g==
Received: from CY5PR14CA0025.namprd14.prod.outlook.com (2603:10b6:930:2::6) by
 DM6PR12MB4074.namprd12.prod.outlook.com (2603:10b6:5:218::11) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.7270.15; Mon, 5 Feb 2024 09:20:49 +0000
Received: from CY4PEPF0000E9CF.namprd03.prod.outlook.com
 (2603:10b6:930:2:cafe::d7) by CY5PR14CA0025.outlook.office365.com
 (2603:10b6:930:2::6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7249.36 via Frontend
 Transport; Mon, 5 Feb 2024 09:20:49 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.160)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 CY4PEPF0000E9CF.mail.protection.outlook.com (10.167.241.142) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.7249.19 via Frontend Transport; Mon, 5 Feb 2024 09:20:48 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.41; Mon, 5 Feb 2024
 01:20:35 -0800
Received: from [172.27.58.121] (10.126.230.35) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1258.12; Mon, 5 Feb
 2024 01:20:33 -0800
Message-ID: <99c9fe4f-1812-440f-8f35-64a714984598@nvidia.com>
Date: Mon, 5 Feb 2024 11:20:31 +0200
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH vfio 2/5] vfio/mlx5: Add support for tracker object events
To: "Tian, Kevin" <kevin.tian@intel.com>, "alex.williamson@redhat.com"
	<alex.williamson@redhat.com>, "jgg@nvidia.com" <jgg@nvidia.com>
CC: "kvm@vger.kernel.org" <kvm@vger.kernel.org>, "joao.m.martins@oracle.com"
	<joao.m.martins@oracle.com>, "leonro@nvidia.com" <leonro@nvidia.com>,
	"maorg@nvidia.com" <maorg@nvidia.com>
References: <20240130170227.153464-1-yishaih@nvidia.com>
 <20240130170227.153464-3-yishaih@nvidia.com>
 <BN9PR11MB5276D9B9CA3E4F69D183D94A8C472@BN9PR11MB5276.namprd11.prod.outlook.com>
Content-Language: en-US
From: Yishai Hadas <yishaih@nvidia.com>
In-Reply-To: <BN9PR11MB5276D9B9CA3E4F69D183D94A8C472@BN9PR11MB5276.namprd11.prod.outlook.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: rnnvmail202.nvidia.com (10.129.68.7) To
 rnnvmail201.nvidia.com (10.129.68.8)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY4PEPF0000E9CF:EE_|DM6PR12MB4074:EE_
X-MS-Office365-Filtering-Correlation-Id: bb57cb17-571f-4d95-7f81-08dc262bbde3
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	/Ae6/BvVIOhA43IMzBbkDDTEmeK08zUvnd1kw5U28Tn+dKrvcofB4/TE5yv8wjCk9iaR/epzuzcB8faQDzTRw74HhWqhhHqAf6a7Y92Umv8CaC2P/LYjArH0WyB9tLlVXKZMNVLxQ0wdxa7onPbFIF8+RifvzoQCx3NV3Sg0n/I5bDykbrBFPhuXyoWucZVWYKU2NFW7jBmwqBOrtLIpNBe9xsgEAFtYCqvgy7jzXs7dnhnvv8ycc+idPOf8hdxNKQrOQCdEeWG6ZaSycbXH2/gQzWZc6UQqiATVJBOgm59EGk/wZsllF76oVyqxPAwAGJUT7nrLt/5qCZaXWKjwDoiSHkbwq2maVmpI6kVkIPXRor3VWs5icBGQC2hA5J0B+k8VnDHlBycTCsZTpmP9N6mbZh/4k2aP8PhVHD3xSdVrgvdSrM7QpZwN0W/i75U22hWKTeQgoM64ViUmqdSpS7cApTb7LPXXfIN88VvC/lPO/wRm9IrE86a6gANOxou02lImfWYKqc0ocWdw0+5twcJTwdv3VqFvjTv+NxO9Kqemxub5udClj4K1msqP9hW/ouDfrn0aTk4G5GxxMBnTDhSQfpa4j9ZA2hdFEjjtdUC9tAm6tnlo8aiO3Wj4BrSuAxLlT5gfE5dlBH2lfJdRIHVrj9WUMCGVgBQPuqhwDuRFM6P9WibxKNijT68OLXckbdmOpAkcO5ShagvQ2wGEEufts0cuWBh4tGYc+216t4uuZVfxgDliuH/3mhLE2gzxKBzce4i0SBmew7YknsJqIQ==
X-Forefront-Antispam-Report:
	CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230031)(4636009)(346002)(136003)(376002)(39860400002)(396003)(230922051799003)(64100799003)(186009)(82310400011)(1800799012)(451199024)(46966006)(40470700004)(36840700001)(7636003)(110136005)(54906003)(16576012)(316002)(82740400003)(6636002)(83380400001)(356005)(31686004)(2616005)(26005)(16526019)(53546011)(2906002)(70206006)(86362001)(31696002)(5660300002)(70586007)(478600001)(336012)(107886003)(47076005)(4326008)(8676002)(426003)(8936002)(36756003)(40480700001)(40460700003)(36860700001)(41300700001)(43740500002);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Feb 2024 09:20:48.9926
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: bb57cb17-571f-4d95-7f81-08dc262bbde3
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CY4PEPF0000E9CF.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB4074

On 05/02/2024 10:10, Tian, Kevin wrote:
>> From: Yishai Hadas <yishaih@nvidia.com>
>> Sent: Wednesday, January 31, 2024 1:02 AM
>>
>> +static void set_tracker_event(struct mlx5vf_pci_core_device *mvdev)
>> +{
>> +	mvdev->tracker.event_occur = true;
>> +	complete(&mvdev->tracker_comp);
> 
> it's slightly clearer to call it 'object_changed'.

Do you refer to the 'event_occur' field ? I can rename it, if you think 
that it's clearer.

> 
>> @@ -1634,6 +1671,11 @@ int mlx5vf_tracker_read_and_clear(struct
>> vfio_device *vdev, unsigned long iova,
>>   		goto end;
>>   	}
>>
>> +	if (tracker->is_err) {
>> +		err = -EIO;
>> +		goto end;
>> +	}
>> +
> 
> this sounds like a separate improvement? i.e. if the tracker is already
> in an error state then exit early. if yes better put it in a separate patch.
> 

As it's just an early exit, I don't think that it worth a separate patch.

However, I can add one statement about that in the commit log.

>> @@ -1652,6 +1694,12 @@ int mlx5vf_tracker_read_and_clear(struct
>> vfio_device *vdev, unsigned long iova,
>>   						      dirty, &tracker->status);
>>   			if (poll_err == CQ_EMPTY) {
>>   				wait_for_completion(&mvdev-
>>> tracker_comp);
>> +				if (tracker->event_occur) {
>> +					tracker->event_occur = false;
>> +					err =
>> mlx5vf_cmd_query_tracker(mdev, tracker);
>> +					if (err)
>> +						goto end;
>> +				}
> 
> this implies that the error notified by tracker event cannot be queried
> by mlx5vf_cq_poll_one() otherwise the next iteration will get the error
> state anyway. 

Right, in that case, no CQE will be delivered, so, this is the way to 
detect that firmware moved the object to an error state, following the 
device specification.

> possibly add a comment to clarify.

OK, I'll add a note in the commit log.

> 
> and why not setting state->is_err too?

No need for an extra code here.

Upon mlx5vf_cmd_query_tracker() the tracker->status field will be 
updated to an error, the while loop will detect that, and do the job.

Yishai


