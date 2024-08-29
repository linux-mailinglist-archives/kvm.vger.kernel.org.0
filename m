Return-Path: <kvm+bounces-25378-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id DB7E89649E7
	for <lists+kvm@lfdr.de>; Thu, 29 Aug 2024 17:23:26 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id E2064B25B89
	for <lists+kvm@lfdr.de>; Thu, 29 Aug 2024 15:23:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 873701B29AF;
	Thu, 29 Aug 2024 15:23:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="mZ+whSy1"
X-Original-To: kvm@vger.kernel.org
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2053.outbound.protection.outlook.com [40.107.223.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD25514A4DC;
	Thu, 29 Aug 2024 15:23:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.223.53
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724944990; cv=fail; b=A0GpsRdZiWdG+zQkbAO1k7XdWQNVwtD2pk2O3s8Cg4MDZ2nH5eaDTdHhQNBNEmojNoO5mPWwzxzhT9sy/x4fP065JgjPaSbQuNuGW+Wqtmd2GB1IhUb1VhZRKyW5iGmtGmjaLitN+4/BMjQ+OvWGmNM3IObIU8w5ABBKGHA6kqE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724944990; c=relaxed/simple;
	bh=GSoxiiGHrgKYUeN6Gu3/NBdk1ygO/3QMRT5UJi44swY=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=eVF5HvkD4C3i9C3SMbrMLBQF76Gd6T7Rb12NDNX5uBF8ObgcXbHpCAz+knQcZkhylM2lyjHAmYH/HejFs6vu4BgRVjzsfbhuzWrq/2qi+FXsOaktWUX59ndJVecZZyB4p4ZLbMstxJp+HaRecFmdwOpQ9mMnqX+VhD8x7wMWkQE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=mZ+whSy1; arc=fail smtp.client-ip=40.107.223.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=moaH1ei5ZJmib9RZpI6AqXASWplPVrhSKhKHAR4shQfVmi0cmqof43HYdOhTrD0POssFuwOEvTZJ30FDvsSnj/cNGv++TlExllgeJmpJOZxaP1zf+97S1vSV1cIrH/VNirFtXl4tk3qqvTyj7wtzdBL2iSK7iYvr96FRv3+/rmkMa7Xs5pt2HAFiZTxZueDkp9uMuHTxSZK4jK5bReoZ8Nnu5EZFrvZfKgTOqGkFxu5R4NNIpbEsmqiYnO4Pha6FKCSnDAAMye9St2fLuYVRbhduLJ/6INFVrmnHZMuBbHMPge5hZPxTzLHIiQTri9xDJlea4U9XXwqb+7En9p1jvA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=/T/XxjcDKlyHc7R91vg2qusZ7Nc/rb2TSLZnSkuVgIY=;
 b=HLwqTmOCrpaLvRkwbONGc0YJtl2uKWK87TLEz8BMKiRiu9bt9sxONMKs2ram6TVPSbuFMxwoivj5czqRb8xmBi+avUi5a4QnZajQoaQhNebbmBK8KcD8fQvftBAPfGgo5s3SWRlXehFqXRqzn01odW+1HAuNevf/+NtN4aVl+nkNWrGdQPZK3C7Wy85GajT5oNvDweTS0iPo7pHcyxN04bct3ig6oo9PZrE83F2NzrrIfmKEWlXa2vTDySZk+xNPj4igm57uQ0ABFBQC6HfpxTiUMUg/8GABI2tLUmtj2BZX1hw23L7F9A6XzveyVD+C8r0nTw+K8GUioX+wLtpD5g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/T/XxjcDKlyHc7R91vg2qusZ7Nc/rb2TSLZnSkuVgIY=;
 b=mZ+whSy1P82HSioM+NIxyIX05QBg5Eks6Kiz+RBCwaYhlTuSYuihIzSlZq3yhn85B/Qg1/i99dhA1QbpKdLPZ3RtkcaklJTGi2Mk5r7R0K+4iOc02ppd8U7KDkGoJLucw1yKgSLcZoEo0WpKwfPxh/D7pNKj4iKEVCQvMiC2qTkpSTl7A0S5H2estqPl+iBMPT+CTnofP0l7uWP5zcClZPCN50awQEsxD5ND0mRMnHMg43/yY4CZaSLL+Asu6xCCKnL1fZeMPqRwUl43Ana6ah323+r/EUKf7UKu12+C7PSnYVmAacP06Ui7w6me3yWiRe6d7eu8uptzAXXK1c4W1A==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CY8PR12MB8297.namprd12.prod.outlook.com (2603:10b6:930:79::18)
 by DM4PR12MB6159.namprd12.prod.outlook.com (2603:10b6:8:a8::5) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.7897.28; Thu, 29 Aug 2024 15:23:04 +0000
Received: from CY8PR12MB8297.namprd12.prod.outlook.com
 ([fe80::b313:73f4:6e6b:74a4]) by CY8PR12MB8297.namprd12.prod.outlook.com
 ([fe80::b313:73f4:6e6b:74a4%5]) with mapi id 15.20.7897.027; Thu, 29 Aug 2024
 15:23:04 +0000
Message-ID: <bccae5ab-45d3-447e-aed9-d1955da0b109@nvidia.com>
Date: Thu, 29 Aug 2024 17:22:58 +0200
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH vhost 7/7] vdpa/mlx5: Postpone MR deletion
To: Eugenio Perez Martin <eperezma@redhat.com>
Cc: "Michael S . Tsirkin" <mst@redhat.com>, Jason Wang <jasowang@redhat.com>,
 Si-Wei Liu <si-wei.liu@oracle.com>,
 virtualization@lists.linux-foundation.org, Gal Pressman <gal@nvidia.com>,
 kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
 Parav Pandit <parav@nvidia.com>, Xuan Zhuo <xuanzhuo@linux.alibaba.com>,
 Cosmin Ratiu <cratiu@nvidia.com>
References: <20240821114100.2261167-2-dtatulea@nvidia.com>
 <20240821114100.2261167-9-dtatulea@nvidia.com>
 <CAJaqyWfANjzrKk9J=hJrdv6c8xd5Xx81XyigPBvc--AxQQK_gg@mail.gmail.com>
Content-Language: en-US
From: Dragos Tatulea <dtatulea@nvidia.com>
In-Reply-To: <CAJaqyWfANjzrKk9J=hJrdv6c8xd5Xx81XyigPBvc--AxQQK_gg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: FR4P281CA0162.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:ba::16) To CY8PR12MB8297.namprd12.prod.outlook.com
 (2603:10b6:930:79::18)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY8PR12MB8297:EE_|DM4PR12MB6159:EE_
X-MS-Office365-Filtering-Correlation-Id: 6c3f4bd4-d95f-4d31-a1b0-08dcc83e79db
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|376014|366016;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?VEFTcVd1clU5OEhNdEtKc09UM0tHanJiNmRxdGdBWVpWUXhlQ0J3ODRyWHpn?=
 =?utf-8?B?clN1ZWRaczZJVG16dEJOWUhBblB4VmRybmdEUlVQUXpqVXpreFhBT214elpO?=
 =?utf-8?B?cUhpOURQZmlqbzZRTEFaTjh3Skh3cExzZHBRWUpFT1FlOEFBcG1ZTDJIRUpI?=
 =?utf-8?B?REJTbXVCbENxOUQwMGFHbk12RUZnbENLb3RFckFDc3pJaUt0WWhqaWt6bjds?=
 =?utf-8?B?dFg2aWc5cnovc1ljWXpFbG5ka1VIaC84ZWNHbnFtN1MxSVVncmNsa2ZDOEt6?=
 =?utf-8?B?b3VaTlM2TDlGd0ZHVWMzMjJsV2Njc3F3YXpTOFRhMTNLOTdkRzJWT3BwRE9T?=
 =?utf-8?B?bVFmMUtySmFnNEZvVXRQVkxmZDhVdkNsWWMybE9UN1YzNnp3K1VqUTlldEZ3?=
 =?utf-8?B?Z1Q4bVFpak9QRkFJcFVXMkdXOUtrREhwczlFTmhpZUhWS2dWdlRPVitTY2Vh?=
 =?utf-8?B?eHloQTBEVFE4T1NuWXlQa2ZZcy9DOEJLWUJCeTFVSkRqQ0g3SEZGd1UzTThD?=
 =?utf-8?B?RFdqd0xmUjdPYTMzYWNXVFo0TmVub1E4dlo0QjJIL1gvak9QMkN2ZnVsZzl3?=
 =?utf-8?B?TXFETi9TeTRTUG5LeHB4eFRIU3ZNOHJoTERXbFFMT2E5bm1yS1I5RkE4MHZE?=
 =?utf-8?B?MjB4SWxIaUJJVGpsQ2xnWUVzbWZGOHF5Z2hiUlphU0d2enhPZFJ4b3dkRmlr?=
 =?utf-8?B?Z2VVTHNOSzNadi91R2E3enoxOXBYcThGSEpyV0NqQmtCdFUyYzJ3MDhWQ0VP?=
 =?utf-8?B?cGhSeUx1R3JWNjhBeW54bVFXSXdsVVVIbkVqc2tEeW1sZ0M3alhaVCtCSzNu?=
 =?utf-8?B?ZkthL28zNTRiVHJaOXBaeTRqU0xwQlAzS09FRHQwQ1FQSlZVRjJaSFpWRk95?=
 =?utf-8?B?d2hXSEhBK1h2VGtYN21yWGpFU3l5dlJnbldBQmo4TXA4NFI2ZFB1QkR4Y0dT?=
 =?utf-8?B?emErWHljems0ZWRLYVJ2V29TbzcxM013cWpDclBMQjQvQjJIeHRNci9OUkxM?=
 =?utf-8?B?RjVHeFJLbGJRbEEydWxJMDAwN3IxZ1JnMXRXaXI1NlhHS0Y4R090c1hQcXQw?=
 =?utf-8?B?RVFJVGFsYzYyeWo3RTI3Sk1rempXOUV5NjBnMC9aM1UxR1h0RlllZWMzSDRJ?=
 =?utf-8?B?ZWsxNmtaYkZNaUpCRTk3b2lERTllaGUvS0tjZUhwbEg0aDI1VDRFVWYrb3NN?=
 =?utf-8?B?OHpnZTQ0dXpTV210SUU4WHdBeER0d2JHaW9KUnpTck5OcXczZDZFNHMyVTBx?=
 =?utf-8?B?TTVad1M5cnltbE84WHRoMnZMbXl0Y2RJVm4zMWZYUW8vZENBb0R6QmF4a1Rj?=
 =?utf-8?B?cGJxSFBiL2U0RUZrbE1JaVRmSjg4S0U4TzFQdENLcFdKbUxzbEcwN2dtVFBa?=
 =?utf-8?B?dloyc0UxeG1iU3NCSmNwWFJmTWlRRzFwSWV4Tjl2dTRoSGEwTGluaUZTTitI?=
 =?utf-8?B?QzQ0Y1Z6ZUQ3QWw3SFowN0N5a2dYMGJMdXhsRXFyR2xzSDdRbXpiSlZOVkFM?=
 =?utf-8?B?Wlh0ci9zTktDZnF5UFcxYzg5Zlp0Wi9JdUhFd294UjRlTjBwd3cvbHBRRmt4?=
 =?utf-8?B?UWJaOU9BYzVyb3BINGNNTzF3Z0FjS2dUZXJmdm0wMFhXZ2pEeXFLMlF5Ym4r?=
 =?utf-8?B?N1UwYnBrSjZOdmNaOGNRWDNyalVhc2E2dHEwaFV5bHlDZ1NoYS9DT0srSTRz?=
 =?utf-8?B?RWNOcXI0V29LZ3FuQUxjQjluSTlCWncySDEvS0xVTTNCSXJ0eExZelVqOUNV?=
 =?utf-8?B?bm9Wd0FJUisvMmdQVFBEU0VhbEIyeDRXZkpnZ09nWkZydURwOWM0NlhMK1V6?=
 =?utf-8?B?SzAyc0cxbmJrakdIVXVFQT09?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY8PR12MB8297.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?K1VZSVhmRXBlK1g3eFVDSUE2dk9XckJNSlhMN1g3dDhOb2FWWit4amJVUEZN?=
 =?utf-8?B?Mlg4UkZnV3MxUFh1a1gyRk1LNzFBbjY4b2RpdDhzcGlTKzYwSmEwVnkzK2o5?=
 =?utf-8?B?dVFxdmxBbFVHY2VxQ1NMMytWYjEwaDJCVjNwcTB4YWF5NTV3bnU2ZkRuSVF6?=
 =?utf-8?B?K3dWT0ZnU0JBTEdiakt0aVFFaDZqei8rVDZvUmJqdUZpZVBkMGNJaVZQSkdO?=
 =?utf-8?B?a3pYZ0FZaWdOaTNnOVJ1QWlNQjNxSjJSb1VIb3Y5ZFhLUTFBMm11ZitjMExP?=
 =?utf-8?B?WUFpSHg3YUtqaXd3OWZqUjZjbE5LSTVKb3ZGR0grRktIR2NJU1pJVHZwbXJi?=
 =?utf-8?B?WDBadDVHVExUdUMvMEhmdFFOMGorZ2ZSd280Um9DNGVDejFCTFZ1eWNONHRE?=
 =?utf-8?B?WHpsaWtEOTZ0NjBYTTJPaklEWEhOQjd3UHYrTStyUWtKSGVsckhhc2E2bDlj?=
 =?utf-8?B?OXFrcVFQakNCTC9McHlMS0I4dWpldHVZYnhMWjZITmVYUkpCY3R2MEZoSzFY?=
 =?utf-8?B?R2R4Y3lOaytPWmdwYmhFOVFSTEdEcFhTY2gzZk9YbWFpTFh3dlM1bDJGWnRl?=
 =?utf-8?B?ZytMZis3SjFFUGVLd0dCZUlIa1FnUHltMGNjdzRlbnpQLzI0eHFQVlJLWWtl?=
 =?utf-8?B?Q0dMb0syK1ZXdldaZE5JYnhIdzdMblpoSmVCdURsMTBqS1dWeDdBWGdPU3NK?=
 =?utf-8?B?V2JxWm13QmFYanBOaXI4cHptYnFYNEdCZFc5RnBFM1hZOEVGK1l5TWpkTXBK?=
 =?utf-8?B?NFVXZDl3T1BKSlYyUDRDd1dqQnpUMUUwbDB5czBpZ3krRnBBeFEyRnFtS3Zk?=
 =?utf-8?B?M3ZpMXFON2pkeDdTWFVkeTB5WEFTd3NYbTdTS3Z1ckZOcDEvL3VucDM5WVNs?=
 =?utf-8?B?Y015UDhZeVFRTm1BYUJtd0ZKMmRHb1BYdjNuT3RaT1V3czdwVzFRVWRJa3Q4?=
 =?utf-8?B?UnVIc2JCT2hpT0s3ZXRuMmJYeWV6K2M1bTkxZ2RpZlNYYWRiTHdmeGVEdk9Z?=
 =?utf-8?B?bHdFWSt2WE03SHl4V3FTTGNLTTMvZ1hpSzJXdHBieWdhRk1VSUtRdEFFOGd3?=
 =?utf-8?B?UlF3Qmh1TDBXT0k5OVpvQVJRZnc5aXhxT3VmODRvTkNJMitWSk9RckF1ODBQ?=
 =?utf-8?B?cjhOT01oNGVKb0lUUWQ5aTM4TUdQQ1BmTmNsYjNubmhUSm40T21HZlFTN2hr?=
 =?utf-8?B?bm45MFVlYzh3cklvdERHbVh4VTNjMXpZV0QwN3dLdklvRi9yMGNKNDJ0RFJG?=
 =?utf-8?B?dGF4YnV4dmF1N25nN2MvUTdyNnZhbnVBOStXMmVaYXpsNVdBcG1TS2ViM3Zv?=
 =?utf-8?B?bGF2NFpjQnJ0YVhIN1ozNEVsbFhxRENjR3dOcEduelg2NnBodnVwblFvMzZk?=
 =?utf-8?B?Y3A2ZktaempJTWl2OWorTUFiMmpTYmtRMXMzaGFCTWp2VTFMbi9tREk2bEtM?=
 =?utf-8?B?clRrZ3VpdFQxQlNtYi9tdWN6cXJHc3ROOTh5UmFHVHMydEpTUEtUSGg0SFV2?=
 =?utf-8?B?aHdlVUszckd6dksybi9JVVI5dzdwamJxM2JDeklsdGdaUGhOcGpicDR3aTla?=
 =?utf-8?B?ZUVWOE05ZnAvU1J0aUJUQzJ3RmR4L04xR3ltQS9Db2Y2ZEFuVzhNRkdKbWc4?=
 =?utf-8?B?REwwWGxONWo3Q2FFdzNlS0lTOTVSanVFYjcrUm1NYk56SGRpMkJvSVVXSlRU?=
 =?utf-8?B?eHlibWRObnNBeno4MnJQcGZCM0RuYXd3ZGRkYzBvSjd3YkUySXNlcEtDb0JB?=
 =?utf-8?B?bHpTc3IvWmxZT2J1ck1MTFVXSEt4MnM3RVRoZ0U4bVlXUHhUMkVLWEVzeXVV?=
 =?utf-8?B?STdOdnE0YytPR3E5cWErNm9hV0RwdUl2WFFyQmg3NGg2LzhNZ3dWL3ZBS1NS?=
 =?utf-8?B?MmtaeXErOSs1aVV4d3RTL1N0QisydnF2RU1LcGMxMmJjc0pRMXlnSUN5Y0hO?=
 =?utf-8?B?RENYVmtGVVBwekNldmFqRzZvSmVuRklUd2VBWGFXZHJNdWw2dHFnblRVMU83?=
 =?utf-8?B?MVJRMWFMajZ3NGUrenhWelQxOW93eVdNYWNlYStEMmZOWUsrRk5aUFBJcWFC?=
 =?utf-8?B?KzFhRkhpMjNCNXg2azN0RlN6RW9yYUxzcC92RkZ4SXIxUmVBaVdGNzVoVjNO?=
 =?utf-8?Q?Kr1GIIr/oNczWgWJWGhUQoKVH?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6c3f4bd4-d95f-4d31-a1b0-08dcc83e79db
X-MS-Exchange-CrossTenant-AuthSource: CY8PR12MB8297.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Aug 2024 15:23:04.0611
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: teURajm+Nb4bETCARn4XSMrhT2XOmWEInjUehb+/RojVQU7H47ukNSUwA+VmVnto4rENem7WCs/NMiOg8vzPNQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB6159



On 29.08.24 17:07, Eugenio Perez Martin wrote:
> On Wed, Aug 21, 2024 at 1:42 PM Dragos Tatulea <dtatulea@nvidia.com> wrote:
>>
>> Currently, when a new MR is set up, the old MR is deleted. MR deletion
>> is about 30-40% the time of MR creation. As deleting the old MR is not
>> important for the process of setting up the new MR, this operation
>> can be postponed.
>>
>> This series adds a workqueue that does MR garbage collection at a later
>> point. If the MR lock is taken, the handler will back off and
>> reschedule. The exception during shutdown: then the handler must
>> not postpone the work.
>>
>> Note that this is only a speculative optimization: if there is some
>> mapping operation that is triggered while the garbage collector handler
>> has the lock taken, this operation it will have to wait for the handler
>> to finish.
>>
>> Signed-off-by: Dragos Tatulea <dtatulea@nvidia.com>
>> Reviewed-by: Cosmin Ratiu <cratiu@nvidia.com>
>> ---
>>  drivers/vdpa/mlx5/core/mlx5_vdpa.h | 10 ++++++
>>  drivers/vdpa/mlx5/core/mr.c        | 51 ++++++++++++++++++++++++++++--
>>  drivers/vdpa/mlx5/net/mlx5_vnet.c  |  3 +-
>>  3 files changed, 60 insertions(+), 4 deletions(-)
>>
>> diff --git a/drivers/vdpa/mlx5/core/mlx5_vdpa.h b/drivers/vdpa/mlx5/core/mlx5_vdpa.h
>> index c3e17bc888e8..2cedf7e2dbc4 100644
>> --- a/drivers/vdpa/mlx5/core/mlx5_vdpa.h
>> +++ b/drivers/vdpa/mlx5/core/mlx5_vdpa.h
>> @@ -86,8 +86,18 @@ enum {
>>  struct mlx5_vdpa_mr_resources {
>>         struct mlx5_vdpa_mr *mr[MLX5_VDPA_NUM_AS];
>>         unsigned int group2asid[MLX5_VDPA_NUMVQ_GROUPS];
>> +
>> +       /* Pre-deletion mr list */
>>         struct list_head mr_list_head;
>> +
>> +       /* Deferred mr list */
>> +       struct list_head mr_gc_list_head;
>> +       struct workqueue_struct *wq_gc;
>> +       struct delayed_work gc_dwork_ent;
>> +
>>         struct mutex lock;
>> +
>> +       atomic_t shutdown;
>>  };
>>
>>  struct mlx5_vdpa_dev {
>> diff --git a/drivers/vdpa/mlx5/core/mr.c b/drivers/vdpa/mlx5/core/mr.c
>> index ec75f165f832..43fce6b39cf2 100644
>> --- a/drivers/vdpa/mlx5/core/mr.c
>> +++ b/drivers/vdpa/mlx5/core/mr.c
>> @@ -653,14 +653,46 @@ static void _mlx5_vdpa_destroy_mr(struct mlx5_vdpa_dev *mvdev, struct mlx5_vdpa_
>>         kfree(mr);
>>  }
>>
>> +#define MLX5_VDPA_MR_GC_TRIGGER_MS 2000
>> +
>> +static void mlx5_vdpa_mr_gc_handler(struct work_struct *work)
>> +{
>> +       struct mlx5_vdpa_mr_resources *mres;
>> +       struct mlx5_vdpa_mr *mr, *tmp;
>> +       struct mlx5_vdpa_dev *mvdev;
>> +
>> +       mres = container_of(work, struct mlx5_vdpa_mr_resources, gc_dwork_ent.work);
>> +
>> +       if (atomic_read(&mres->shutdown)) {
>> +               mutex_lock(&mres->lock);
>> +       } else if (!mutex_trylock(&mres->lock)) {
> 
> Is the trylock worth it? My understanding is that mutex_lock will add
> the kthread to the waitqueue anyway if it is not able to acquire the
> lock.
> 
I want to believe it is :). I noticed during testing that this can
interfere with the case where there are several .set_map() operations
in quick succession. That's why the work is delayed by such a long
time.

It's not a perfect heuristic but I found that it's better than not
having it.

>> +               queue_delayed_work(mres->wq_gc, &mres->gc_dwork_ent,
>> +                                  msecs_to_jiffies(MLX5_VDPA_MR_GC_TRIGGER_MS));
>> +               return;
>> +       }
>> +
>> +       mvdev = container_of(mres, struct mlx5_vdpa_dev, mres);
>> +
>> +       list_for_each_entry_safe(mr, tmp, &mres->mr_gc_list_head, mr_list) {
>> +               _mlx5_vdpa_destroy_mr(mvdev, mr);
>> +       }
>> +
>> +       mutex_unlock(&mres->lock);
>> +}
>> +
>>  static void _mlx5_vdpa_put_mr(struct mlx5_vdpa_dev *mvdev,
>>                               struct mlx5_vdpa_mr *mr)
>>  {
>> +       struct mlx5_vdpa_mr_resources *mres = &mvdev->mres;
>> +
>>         if (!mr)
>>                 return;
>>
>> -       if (refcount_dec_and_test(&mr->refcount))
>> -               _mlx5_vdpa_destroy_mr(mvdev, mr);
>> +       if (refcount_dec_and_test(&mr->refcount)) {
>> +               list_move_tail(&mr->mr_list, &mres->mr_gc_list_head);
>> +               queue_delayed_work(mres->wq_gc, &mres->gc_dwork_ent,
>> +                                  msecs_to_jiffies(MLX5_VDPA_MR_GC_TRIGGER_MS));
> 
> Why the delay?
> 
See above.

>> +       }
>>  }
>>
>>  void mlx5_vdpa_put_mr(struct mlx5_vdpa_dev *mvdev,
>> @@ -848,9 +880,17 @@ int mlx5_vdpa_init_mr_resources(struct mlx5_vdpa_dev *mvdev)
>>  {
>>         struct mlx5_vdpa_mr_resources *mres = &mvdev->mres;
>>
>> -       INIT_LIST_HEAD(&mres->mr_list_head);
>> +       mres->wq_gc = create_singlethread_workqueue("mlx5_vdpa_mr_gc");
>> +       if (!mres->wq_gc)
>> +               return -ENOMEM;
>> +
>> +       INIT_DELAYED_WORK(&mres->gc_dwork_ent, mlx5_vdpa_mr_gc_handler);
>> +
>>         mutex_init(&mres->lock);
>>
>> +       INIT_LIST_HEAD(&mres->mr_list_head);
>> +       INIT_LIST_HEAD(&mres->mr_gc_list_head);
>> +
>>         return 0;
>>  }
>>
>> @@ -858,5 +898,10 @@ void mlx5_vdpa_destroy_mr_resources(struct mlx5_vdpa_dev *mvdev)
>>  {
>>         struct mlx5_vdpa_mr_resources *mres = &mvdev->mres;
>>
>> +       atomic_set(&mres->shutdown, 1);
>> +
>> +       flush_delayed_work(&mres->gc_dwork_ent);
>> +       destroy_workqueue(mres->wq_gc);
>> +       mres->wq_gc = NULL;
>>         mutex_destroy(&mres->lock);
>>  }
>> diff --git a/drivers/vdpa/mlx5/net/mlx5_vnet.c b/drivers/vdpa/mlx5/net/mlx5_vnet.c
>> index 1cadcb05a5c7..ee9482ef51e6 100644
>> --- a/drivers/vdpa/mlx5/net/mlx5_vnet.c
>> +++ b/drivers/vdpa/mlx5/net/mlx5_vnet.c
>> @@ -3435,6 +3435,8 @@ static void mlx5_vdpa_free(struct vdpa_device *vdev)
>>         free_fixed_resources(ndev);
>>         mlx5_vdpa_clean_mrs(mvdev);
>>         mlx5_vdpa_destroy_mr_resources(&ndev->mvdev);
>> +       mlx5_cmd_cleanup_async_ctx(&mvdev->async_ctx);
>> +
>>         if (!is_zero_ether_addr(ndev->config.mac)) {
>>                 pfmdev = pci_get_drvdata(pci_physfn(mvdev->mdev->pdev));
>>                 mlx5_mpfs_del_mac(pfmdev, ndev->config.mac);
>> @@ -4044,7 +4046,6 @@ static void mlx5_vdpa_dev_del(struct vdpa_mgmt_dev *v_mdev, struct vdpa_device *
>>         destroy_workqueue(wq);
>>         mgtdev->ndev = NULL;
>>
> 
> Extra newline here.
Ack.
> 
>> -       mlx5_cmd_cleanup_async_ctx(&mvdev->async_ctx);
>>  }
>>
>>  static const struct vdpa_mgmtdev_ops mdev_ops = {
>> --
>> 2.45.1
>>
> 


