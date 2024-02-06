Return-Path: <kvm+bounces-8084-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 2B3D284AF78
	for <lists+kvm@lfdr.de>; Tue,  6 Feb 2024 09:02:27 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 48BEC1F26158
	for <lists+kvm@lfdr.de>; Tue,  6 Feb 2024 08:02:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C05D012AACE;
	Tue,  6 Feb 2024 08:02:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="UWO4t95L"
X-Original-To: kvm@vger.kernel.org
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2059.outbound.protection.outlook.com [40.107.223.59])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4A17212A157
	for <kvm@vger.kernel.org>; Tue,  6 Feb 2024 08:02:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.223.59
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707206535; cv=fail; b=NqWMZEXCe64pH/DGrdxXrHvBLdjTX7MOeTUpozEmTVcV2uv7BaTJPf2qP4xjzwVXrPgPV4Lft+ik+ZJyA+MMoRMbvNTyTvqC7NjKmRuB8rkvg3J//kOzf+ksrAHzpAWa/fYSZf6AUQ33gmC2cFO1eWxa1hVb9OC7DI999f1Zui0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707206535; c=relaxed/simple;
	bh=zVgoE1UEZQ1u86dLyKj4v3TOyslQ+ateblZFZ0x1rpg=;
	h=Message-ID:Date:MIME-Version:Subject:To:CC:References:From:
	 In-Reply-To:Content-Type; b=Ar/Uj//dCx7tLJzg0QUl7FfpoyJTi2sLRWbDEL3P2zqf8tSyOJrI/3VLrY8gFWH0ZnR2dgwQfnUKzErBH+QAE8H9Adu1sjqtzRHD6ALYgSiFUgckkDBuLXfaAH+9s406Z7YmogP9sjQhUtT+gqaXyo9XvN8/boxHW1IHb7oot8I=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=UWO4t95L; arc=fail smtp.client-ip=40.107.223.59
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=nMvk4ATOe9Em2uGohbPBgpQpXq+sP1R1NFUbhnhezSk1iTaYCT+CdczX4Kn1sjJRfwAsvv8lP0cWdg8pJg5OQgvMH8B8LmZIfTon/SyXxcjFGbg8cFsNip6hRZL+z+OjLy/C2hNbbqJyv9ya94jOhgjX99qiNB+5H959W4aeh2tJ/AzrJX7RlZQtx4mGglc7zhs0QcNGtVvC0w4P9tCh0T82qSJ5sKix5Dfwl7y3K/1weRVhZTDX1R/wSeTdxjdvQujzXw8fkqoNve+E+/4OnJsbk4xIUnotV5gvBNUKf6yf3Ad9kEaywVlZ3Lhw1oYOHYdAWJMn8B0VM9S+PcyyOg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=0wdumNiylJ/fZ6koQde5gQrwZyAsahcO0OJ26eT82jI=;
 b=BrHlj5iJGHCYtMvPP5URR8WlWQRln1ptJySUVirE00X7nC8BFB2EwKFi7aCwObxGCi37BUyza+dYya1lZMb8411jE8DgbwNnVM1vNIP2ofn09GBAwC4vfJNqWEoTSrdTENmFdxNR8R4RMz67JVcspDReOmZPqcmb7asysT5PhoZp7P9OrI4TuaBXtro0HWk7MYtXt1PkZFu7JGOzO6xSmIyUP17cdSi+au/euI6S45R0yQp1VI5m+/0U0U5tFwVy5f5xK2GyVQrfDbvEPskgsAQoAwz1p81/FStpX3L2PAViXsatQ5q2eGK2NKef6lOu5+I9+QNDFKOV/sAsxexpjQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=intel.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0wdumNiylJ/fZ6koQde5gQrwZyAsahcO0OJ26eT82jI=;
 b=UWO4t95L9iTCBeshbH18G1sIuzh5Au2QVs9TmTyUukCugEuwoWyRtTRkNmGIi9KZ36fBZIVA4O9umPhZOOgiZ6IgXZeSu/S5gw6gRtAZ51pir2HIq/iHtDQ9K5b35Cf7kqrUxS0a1hnmA5vu78claUmfKmQAFg5gGAWU0nwJKrmOU9M+dF0PB7T2lhBljbTPOEvOsLCUJda2G0V5XYqMgiir3azdveOlZG9Eb4Kn/3oridSSmCsYZQyD7Lv+g0sbVdKYuNM9LJlEP0pXFY3ZwdgEUqblLsjgNNgC83EYaoJxuTiNu0lbqhkjehxTOHnOPLAVNULLBw3ng0Ym39MP6w==
Received: from SJ0PR05CA0094.namprd05.prod.outlook.com (2603:10b6:a03:334::9)
 by DM4PR12MB6112.namprd12.prod.outlook.com (2603:10b6:8:aa::7) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.7270.13; Tue, 6 Feb 2024 08:02:10 +0000
Received: from MWH0EPF000989E5.namprd02.prod.outlook.com
 (2603:10b6:a03:334:cafe::b7) by SJ0PR05CA0094.outlook.office365.com
 (2603:10b6:a03:334::9) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7270.17 via Frontend
 Transport; Tue, 6 Feb 2024 08:02:10 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.161)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 MWH0EPF000989E5.mail.protection.outlook.com (10.167.241.132) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.7249.19 via Frontend Transport; Tue, 6 Feb 2024 08:02:10 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.41; Tue, 6 Feb 2024
 00:01:53 -0800
Received: from [172.27.58.121] (10.126.230.35) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1258.12; Tue, 6 Feb
 2024 00:01:51 -0800
Message-ID: <f3d8fb33-d1ca-4836-9b6c-dd95b17d901b@nvidia.com>
Date: Tue, 6 Feb 2024 10:01:49 +0200
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH vfio 2/5] vfio/mlx5: Add support for tracker object events
Content-Language: en-US
To: "Tian, Kevin" <kevin.tian@intel.com>, "alex.williamson@redhat.com"
	<alex.williamson@redhat.com>, "jgg@nvidia.com" <jgg@nvidia.com>
CC: "kvm@vger.kernel.org" <kvm@vger.kernel.org>, "joao.m.martins@oracle.com"
	<joao.m.martins@oracle.com>, "leonro@nvidia.com" <leonro@nvidia.com>,
	"maorg@nvidia.com" <maorg@nvidia.com>
References: <20240130170227.153464-1-yishaih@nvidia.com>
 <20240130170227.153464-3-yishaih@nvidia.com>
 <BN9PR11MB5276D9B9CA3E4F69D183D94A8C472@BN9PR11MB5276.namprd11.prod.outlook.com>
 <99c9fe4f-1812-440f-8f35-64a714984598@nvidia.com>
 <BN9PR11MB5276795DF79D924246ABEDC88C462@BN9PR11MB5276.namprd11.prod.outlook.com>
From: Yishai Hadas <yishaih@nvidia.com>
In-Reply-To: <BN9PR11MB5276795DF79D924246ABEDC88C462@BN9PR11MB5276.namprd11.prod.outlook.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: rnnvmail203.nvidia.com (10.129.68.9) To
 rnnvmail201.nvidia.com (10.129.68.8)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MWH0EPF000989E5:EE_|DM4PR12MB6112:EE_
X-MS-Office365-Filtering-Correlation-Id: e0b4081a-9480-4494-e599-08dc26e9ebdf
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	Rxz33TFWEzFeybTNf7vpbTPOckz4NyLBmAPojbMhu8utEpIr+PHRcvsf7Ok6jZOKFZnqwNAMYZQy6l9kVXIPKdtoVTtSWV81K9q05ObqgWL11oEIHrvkb7DrQWvfegkLCa1UexfT+wWTXHzMw56Y5Aoy8Ys54rMkJaKai817+rZqlptIJFrgu2UM41w+HEfaujpr33dvs/ZaLeKv2gnFRU7NLUKzNDEwZ88lJ1xjeB5GdYHzKWDdMeK/8sOkz4G8aUsVtyrZ/txvsmnBb9p10P11S/LdKgayXc1x6jxnXZbtjPGbmYqakPHanUBGjC383wMqaoeDi0FAJ08S83GwQKNRERWUlAjx8k8qpyxEKhVFpqnfdhXVnQFpnBjmxY6Q9hVLNgSVU8SX7YPGLPts4eKnQ8tZB9S0s+7lWeGXXHRfXnpwlUpwcntUOTDhhkhD6SHQLBF1woelTYqAkdRbNl4/YeXfYRvB5uCZ6GfPQ5gdHfVDcaSi5Hk0aY0v0uQbC3gm6wWZ1jFVoUB+0LFOu3uN6YHNSo5WZESYR23zlHNzzndyj4Tp4KJbZcPK08z9XLGWfg/d+Ayr+1ccd4Ia5MSuCl5HetfN1CTl1VpIletVfz2ZyWQ95fL5e+w8mfVUhz5y4y7XNw2gLRHN3y85p5bQMPRmUPS+vDUKSG4NJXyCh67Yj+O8MXb6gqdPOmGTZXOo6jDCCDhzZdzZiR6cY0D/XLiasd1yt16/zK6gKSAL/PRq9jO7BSzqFGXKoRjapSVia0Or7nbWfY5/gqOAOA==
X-Forefront-Antispam-Report:
	CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230031)(4636009)(376002)(39860400002)(136003)(396003)(346002)(230922051799003)(64100799003)(82310400011)(186009)(1800799012)(451199024)(40470700004)(36840700001)(46966006)(2906002)(40460700003)(31686004)(40480700001)(478600001)(86362001)(5660300002)(426003)(83380400001)(8676002)(356005)(8936002)(70206006)(6636002)(47076005)(54906003)(4326008)(31696002)(16576012)(53546011)(70586007)(36756003)(2616005)(336012)(36860700001)(16526019)(110136005)(82740400003)(26005)(107886003)(7636003)(316002)(41300700001)(43740500002);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Feb 2024 08:02:10.4916
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: e0b4081a-9480-4494-e599-08dc26e9ebdf
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	MWH0EPF000989E5.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB6112

On 06/02/2024 9:33, Tian, Kevin wrote:
>> From: Yishai Hadas <yishaih@nvidia.com>
>> Sent: Monday, February 5, 2024 5:21 PM
>>
>> On 05/02/2024 10:10, Tian, Kevin wrote:
>>>> From: Yishai Hadas <yishaih@nvidia.com>
>>>> Sent: Wednesday, January 31, 2024 1:02 AM
>>>>
>>>> +static void set_tracker_event(struct mlx5vf_pci_core_device *mvdev)
>>>> +{
>>>> +	mvdev->tracker.event_occur = true;
>>>> +	complete(&mvdev->tracker_comp);
>>>
>>> it's slightly clearer to call it 'object_changed'.
>>
>> Do you refer to the 'event_occur' field ? I can rename it, if you think
>> that it's clearer.
> 
> yes
> 
>>
>>>
>>> and why not setting state->is_err too?
>>
>> No need for an extra code here.
>>
>> Upon mlx5vf_cmd_query_tracker() the tracker->status field will be
>> updated to an error, the while loop will detect that, and do the job.
>>
> 
> except below where tracker->status is not updated:

This is the expected behavior in that case, see below.

> 
> +	err = mlx5_cmd_exec(mdev, in, sizeof(in), out, sizeof(out));
> +	if (err)
> +		return err;

We can't set unconditionally the tracker status to an error without 
getting that information from the firmware.

Upon an error here, we may just go out from the while loop in the caller 
and userspace will get the returned error.

Any further call to mlx5vf_tracker_read_and_clear() if will come, may 
have the chance to start the regular flow.

In case the tracker can't be moved to MLX5_PAGE_TRACK_STATE_REPORTING 
(e.g. as of some previous error) the call will simply fail as expected.

So, it looks OK.

Yishai

