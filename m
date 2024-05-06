Return-Path: <kvm+bounces-16725-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id C9D5C8BCF4D
	for <lists+kvm@lfdr.de>; Mon,  6 May 2024 15:42:01 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 776CE285087
	for <lists+kvm@lfdr.de>; Mon,  6 May 2024 13:42:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 52CA97C090;
	Mon,  6 May 2024 13:36:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="hauXzkOq"
X-Original-To: kvm@vger.kernel.org
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2067.outbound.protection.outlook.com [40.107.237.67])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AFE367C085
	for <kvm@vger.kernel.org>; Mon,  6 May 2024 13:36:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.237.67
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715002616; cv=fail; b=tIDetGY827Ga/kJL2WXDITSlHQK+SWBn/VPeMIh1VfaHMfp6f0rfu68COpZsaApHS0CT9IDCPrHaOOg92xaspnnncpyhY16ts13JTgXvPN2y4S4IP1Tge3lbrfv0UzjlZkpruAh+fVU35pP6MXbaGw4qTrZwFPZUPkDRD5Ogfi8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715002616; c=relaxed/simple;
	bh=EZNJ1Bi0ATlbqu8CE2sbtw5G4mKMZAfGsebBoh/igN0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=AjkMLWPA9Ib6xg6zYolia5M0PlF9S0ymsmpPw7EjaurZv38uOmrL0wlb+zQARCFZXh6VurpWu2FnWlcN0kU2KHjCGuAmQdPWzr7DqVQhcER+56Owhl1sGvMjXWasMRS9PZbSGOm8RBo1GpPDtYyWZcG8uvOs35YddYNvVOO0Euo=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=hauXzkOq; arc=fail smtp.client-ip=40.107.237.67
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=TrNvAjVnSb5Fu5ZdUplLs+lmjdK4/E/6ctYd+xpGkJLxl87fguMMP+kYRyU7GwqEFzYKO623WB/wTfKrD4MyuuLsK+gBhau5wXx8nRWhcoOkoO1LoHSICvsH76EI2bn848p8Qug0bj+X36WGcTsb6RxH2C7E2/aj+4F01a8m+hIqk1jJ8VFNIORZYQiIzvHdMux8HMPYSfM5FAV1X9X54dHM+Cflv0C1Zd1HCh1b1BUilbk9d1AL5WU7BhVYmTnujvY2zFPwUfYVl26t1Cez8oETXml1jpFQyLJcw1Q6hAa+ZI5zRV5aNrHiF9NqYgin2oVEBAmNS7rYLhlaUbe1DQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=pFphkzHl9PWf6PedtJyM5/Ea+G5STbuZc2t769Y6mUE=;
 b=lKRWu9elx9NAnZ0oK2Dvfbkq6WFNUhrjIW3h5CNLebODfOs5fnffNh6ks1hh1t4oWZ9+KRMqOSZEHZfBcqc+vNC3FbpILBIXZi+WOxRWuXpYhd3yyuV7FnYkotFLcXhPK1Jzp+ALH4JB9z8lQ2IN/FVBH3X0ImJfl0sWGtiOOkbeQhsoByLNTyH4rm0HvYbrzppxRKmk08KA+wjtxbBIl2S+S8FgzJGu/jk7IgUMXobamDpiVuOq9jpDoZy9gKJoFQ+vHSukaTirnV+jzT1diy15TaMwof3b21ZgHL5vAtxqm5Cj1hGbv9Dt0ISQZBr6rtctKudFgYJzn8fp+SFCRg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=pFphkzHl9PWf6PedtJyM5/Ea+G5STbuZc2t769Y6mUE=;
 b=hauXzkOqe/IO/bSn/bU3tf4hQpDcj6cAeW4/GCPtaf0HzV30kWsXuZSR53YPdGZaUSJyWWKxPIX/22iolLKElmruItivP6jUsnBVK463ZiXhd4aShFTkcL7AkfLPXzZ2VLWPxRCWXzZN9eZCw/PJY9M7UWFcZTWH2mg/VYWRFkVnR6R5wY1bKLfQbci4n41yAGpl3WWdkGo7R3yRjWghlC32W1NCdg9vw0eHPAP1pcgyJJip7tVYtKaKuuB+d08d16Q9P/DcNngxZsCMpUK8L2RnZaXwI6h0cbQyphYtaeIYfNj5X0ZjE1a9QS0WBWZkv/5opAQlptd4oYmhn/IsHg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from DM6PR12MB3849.namprd12.prod.outlook.com (2603:10b6:5:1c7::26)
 by CH3PR12MB9343.namprd12.prod.outlook.com (2603:10b6:610:1c0::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7544.41; Mon, 6 May
 2024 13:36:37 +0000
Received: from DM6PR12MB3849.namprd12.prod.outlook.com
 ([fe80::c296:774b:a5fc:965e]) by DM6PR12MB3849.namprd12.prod.outlook.com
 ([fe80::c296:774b:a5fc:965e%3]) with mapi id 15.20.7544.041; Mon, 6 May 2024
 13:36:37 +0000
Date: Mon, 6 May 2024 10:36:35 -0300
From: Jason Gunthorpe <jgg@nvidia.com>
To: Baolu Lu <baolu.lu@linux.intel.com>
Cc: Yi Liu <yi.l.liu@intel.com>, "Tian, Kevin" <kevin.tian@intel.com>,
	"joro@8bytes.org" <joro@8bytes.org>,
	"alex.williamson@redhat.com" <alex.williamson@redhat.com>,
	"robin.murphy@arm.com" <robin.murphy@arm.com>,
	"eric.auger@redhat.com" <eric.auger@redhat.com>,
	"nicolinc@nvidia.com" <nicolinc@nvidia.com>,
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	"chao.p.peng@linux.intel.com" <chao.p.peng@linux.intel.com>,
	"iommu@lists.linux.dev" <iommu@lists.linux.dev>,
	"Duan, Zhenzhong" <zhenzhong.duan@intel.com>,
	"Pan, Jacob jun" <jacob.jun.pan@intel.com>
Subject: Re: [PATCH v2 12/12] iommu/vt-d: Add set_dev_pasid callback for
 nested domain
Message-ID: <20240506133635.GJ3341011@nvidia.com>
References: <20240412081516.31168-1-yi.l.liu@intel.com>
 <20240412081516.31168-13-yi.l.liu@intel.com>
 <BN9PR11MB5276E97AECE1A58D9714B0C38C0F2@BN9PR11MB5276.namprd11.prod.outlook.com>
 <d466eb97-8c2b-4262-8213-b6a9987f59ea@intel.com>
 <b4fe7b7c-d988-4c71-a34c-6e3806327b27@linux.intel.com>
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <b4fe7b7c-d988-4c71-a34c-6e3806327b27@linux.intel.com>
X-ClientProxiedBy: SN6PR08CA0008.namprd08.prod.outlook.com
 (2603:10b6:805:66::21) To DM6PR12MB3849.namprd12.prod.outlook.com
 (2603:10b6:5:1c7::26)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR12MB3849:EE_|CH3PR12MB9343:EE_
X-MS-Office365-Filtering-Correlation-Id: d9ef7151-e429-486c-7638-08dc6dd18d76
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230031|366007|7416005|376005|1800799015;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?ZlVTaWk3U3BtZmFDdmZHbmFHRkg0bW5hSVNNc1RVc1FrOFFkRFVXVWxYRjFU?=
 =?utf-8?B?L2lFbndaRGN4UjdjU1R4emI3WVZVVEljNlJhazJPV2h1akJKak5ET3VINWdv?=
 =?utf-8?B?a2JZNVNMZU1PR3VwbG8wYmkzN2N1d2svY2VGYTA0TitFSmhHdDFNSHFOZEl2?=
 =?utf-8?B?R2w0U3lzWG5pQStLTU1RL1hWajEyNGx1RldQRk95aWhGOEJ1dXZOVkkvamZI?=
 =?utf-8?B?MmEzVkxwVzNmQnpiNVNDQ2dRS0xyS1pLWmRQdmRINW91TDQ1bnk2UHZqS1JT?=
 =?utf-8?B?d0tadUY4MlFRNVhiaUZNRDNIYkNpMG1ZOHBBN2tJZ0RRRS9TcXUwT0lQRERC?=
 =?utf-8?B?T3BMb2J3S01GZFV4Wnk4dkozT2lPeGQ1TW9yNFMydWNlalUwOTJsMzJxcXZZ?=
 =?utf-8?B?bVlLUHFQZE14WFlYZnZaL1UrVTVVOWJmZytFYlNFV294Y09NM1BBNjV5RkMr?=
 =?utf-8?B?N3pJS1ZyWmpWMFMzWWcrSVMxaXA4VG5hUUtHbnU3Wnk3WlFYakUzdU1DTlU5?=
 =?utf-8?B?L0I2UXZHQjF3bGVIc1Q5WEJRQjFDNXhTSGUzZWV1NTkzYWlHSG9ObnAwN0cz?=
 =?utf-8?B?UGZQbDVVZFhUOXNLRjJmS08wZjEwWkpXNUN1Tms4bk1yYTM3TFhTSnhSVTZl?=
 =?utf-8?B?V3N4a1VwZHpJcXhkSWliNVRwUlFsaU1UY3V3NG53YjJObDFuUThKTEpNZXJz?=
 =?utf-8?B?QXoxeFpQWW5WWkJaNG9tRFdsVFVmcVVaZWd6aXJCclFnSVUxM3FMSW9OYXNp?=
 =?utf-8?B?K1c3cTFJeUg1S3VSWGdwZ0VGTDk2NExDcE5DNE8wd1JZMXhBeUpRNGxSMUFo?=
 =?utf-8?B?TzRySGlMYnNyZFQ1Q3RlaU9HMTdrZ2t1dUFqaktqMkVmMmJHMU1DUVFFSU9m?=
 =?utf-8?B?QWVYUDE3RGN1Z0doUWRNRU53OUx5S3E1Rm9jS1dwMkcwQUNYSHlhdHFoSmk3?=
 =?utf-8?B?eHVad3dDTnRVWEFlSUVpY01zUzRycEI3UWRwbnBaN1VGYnlydUQ5RHJiNTB3?=
 =?utf-8?B?UW1BaWljTXhyZkhCWDFHZTNpUGVXNFRzSzk3S3RmdW94SFRrbU42UVRUci94?=
 =?utf-8?B?UWg0NjBvbitSZFVVNHA5U29PcThiKy95T0RjZlZ6OE9WQVlTeVQ5cytHV2Zh?=
 =?utf-8?B?NkpXWlpUdXhDaklnWE0ya1NpbHBMSXpTblBJS3NTeG94VmxaZjNiV3pJcFBX?=
 =?utf-8?B?MjdGV1JOenVhQ0NTTjNTWnZPaTNpMzNabHZjQzZ5MGEvZ0hnMHNUalhSMlVE?=
 =?utf-8?B?TmdsNk5SMVNldHZrb3VrRWxzV2JreFpqVisxNkhqYmFHT2RWUEgwbW9ZREJG?=
 =?utf-8?B?Zmg2YjB2WlRmTXJsTXJKdU82K1ZhMjZaZFJBQUR3czFTWjNuRzZRcS8zWDE3?=
 =?utf-8?B?aVllbVBJZ05pQzFKZ1pCMkM1KzhXNm5lYktYaXBsVXBPVEgvTFlTVGkxdVUw?=
 =?utf-8?B?MkMyNnV2WTRmRER3WWl5R2hGUWl3cjcwOW96bW9oS1dMRDNXQ29zeHI2WGJO?=
 =?utf-8?B?YXd3WVRwSFFsbVB5MVJpY3RrbVZ2a1luYVRaK241RkRzdWkzMk5HT2hkdjlM?=
 =?utf-8?B?VzlKekR3di93WEV1MUNrcnhwbFFqeDhlQTg1WVNsNm1Mdm1kRlBac3VsbXNm?=
 =?utf-8?B?d0J6ZEpETGhZbDZLOUR5aDVPamtIWi81R0RMeEdjTEZDY1BqVEVYVm5sSTV2?=
 =?utf-8?B?S0RjVVF4VCsvOXNBT3F4TnV5QUFHOXhxUFVzbERQdGZ1dHQyQW1odEFnPT0=?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB3849.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(366007)(7416005)(376005)(1800799015);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?NFRzQlNwNUROemR3VGlxV29LNFkwRTdsdVlwaTRBdFVsbTI4Yk01TENIQzJU?=
 =?utf-8?B?V21kcE13M0oySkF1eG00R1RFVWx2OHkwQnZnL1NwTDEvWkJiUXZCbTFVR0xB?=
 =?utf-8?B?dmpYcWtWWC9EZEQwbW1ycW1zd3dBUWljT1FpQ1ROTlduUE5kaUFUOWkxZmdZ?=
 =?utf-8?B?RktwSldIZTBpOUNESWpWcEp3aDFxY0E0U0NuL2dRT3oySWEzVGlNN3EwVG5F?=
 =?utf-8?B?d3FSUnBVVnpvNTNpRmhFUHRCZFZoWmNwOW96UXVNRlZXd0tBRHpsdFJRbjcr?=
 =?utf-8?B?dllqdFhTWmc4YnVhRmc1YkpraGcwendkSlc1UUFkd2ZVR214aEhFQzhiTGFB?=
 =?utf-8?B?clFtTW5TN1dTc2F0VDFMNFZVK1BVVUI0Mk9HUkpEUDBkMkFIenF0UmtsMy95?=
 =?utf-8?B?YkRmdjhhUDZZMXN1VUZEMTE4dVE0Snd4M21GY2p3aW1vK1BIL2ZnZUJjZith?=
 =?utf-8?B?a29mT2R4REVnM0dUQWtvTkVqc0Y0U003MW5qdSs2VjBKNk1yckdxWXB2YkFl?=
 =?utf-8?B?OCtvTnJlc1o4c2pDS0hGb3ByZ2NkUmdGVktVc0ZVVmQ4bzVac0d0bGNaK2hu?=
 =?utf-8?B?dCs2MXBsOGpQMDNyUGFXYlo3UUlWU1VkS1dOYTdMSTQ4TFVnNGw1TDU1Zlo0?=
 =?utf-8?B?M0puZHNadkJsY1M5djZKaHhZZ2VTRXhCNTdGZEJVWklLSjRaZlptS2pRUkh2?=
 =?utf-8?B?c05MYjRXc1NRM29SMklMK1RwR0RybXJsMEx6dVV4WVFuWDdjb2xQYUdUeUh4?=
 =?utf-8?B?ZE01UlVuTWdBTGxoUlZSYVQ3RklLOWRub09PZ04rTkRiQWx5aXRlQlNZNnl5?=
 =?utf-8?B?WEhYNzI3K1lZSld0Nk0yWEUwSXVJMVJlL0hhaFpua3R6eGcxdjFJdDVpc0kv?=
 =?utf-8?B?RS9UNTdmR0prUkpvV201aTBZdjJ4eWFiNDhneENGZStOOTN4cE4yZzIyU2ta?=
 =?utf-8?B?U2tleWNKbUxCS1lGSWNmYUR2RmF0R09HL0JaWkxhZGhKajY1TFhPeFU1dDRZ?=
 =?utf-8?B?WDNSaWUzVFE4WnJsY3JSZ2tNdE56Vi9FTFBFQkQ4ZW5VSVBhWFJuclFaUTF3?=
 =?utf-8?B?R0U5TmdRMDVER1BjQnFYQUFyUllCaXN2bTJ2K1Z3cmJVeEhQem9UWWxwTm9R?=
 =?utf-8?B?RTVLZHk0TE83bkJEUW85Y21JazFMQmpzaHVxSkZTc09RbmorbFdHd0ZaM1Vo?=
 =?utf-8?B?QndCTUFkT1dtcnlqWmczNll0MmVqaUY2UUZxUEYwVlpqK3JoZVZOY2thVk1L?=
 =?utf-8?B?L0VYanZRVldCcHo5Mnp5RXpzTTA3KzZSZ3JhL2NkTjJwL3RWUU5iNG9KSXhC?=
 =?utf-8?B?ekRxeVl3YTU2dmRXeUxoU1dZNjA4dnBmNkRoQ3ZsaGhIaFlXMkFkWDBlSjhX?=
 =?utf-8?B?M01wN1VrNmxqQTh2TWwrQVl6RTB4ZDhVRnBJUk1MUWh2OVBFb01ta3Z4RjZU?=
 =?utf-8?B?WENOUVFrbGZ0dTl3cXRtdlhkdHJzUTRKUTNmVURTSGZpbWlEeGtDbmRVMUdU?=
 =?utf-8?B?K0JqRUlmazZ2a1B6MGVBVDgydWVtZWErTG9xakFRZXpmcEVRQ1l2Z3QxMGVW?=
 =?utf-8?B?M1RpbGxaNytJdVVISlVVU2pFMVRWcXdyNkNrTnpjTWhoTEptNFpDRlBMQTlL?=
 =?utf-8?B?VVNqYUZNQnB0bEo5TDA1TmdUTXU3VGZmejdwaEhEMnFkeUxTcDBoMlpRcTRw?=
 =?utf-8?B?UGhCakFmTlltejQ1eVd2L0RrZnBpOCswaTdEeks2b3dmZE5mU1NZd0NqcURy?=
 =?utf-8?B?ODRsK0FUc2NVYWtrSWoyK2V3eTlYQ2lMVjJuTW9hT3lSeWg2Q2FRbklhV0pG?=
 =?utf-8?B?WU9hb2h0UGorZDJIRG16MmcyR2dMTlVUb2N1YnVUTnAxUG5Zc2VyZEhPMzBa?=
 =?utf-8?B?WnNaMm0xRDk0Y3hlSFE2MS9Yc24xblVJOUNkMnk1SDFpZVZRV29pSkQ0aWR4?=
 =?utf-8?B?Z3pWcDEyQlZxZlNpVXZhT01oc0VEbFZXQ2VaUXlBNnNxMDM5SjJqc2UxUVlK?=
 =?utf-8?B?MHBLcE9ZNmZzcCtCTXFDUFdaeVJaZWs1dWt2WnNKTVdjUFhkdWtSVW5yV2xa?=
 =?utf-8?B?bmYyVXloVS9uZGdwc3NFeWdjZGphMXdERFJpSktxNEJ6OGpXejM2czNuSzdB?=
 =?utf-8?Q?tw8XSS6EX1muswsKV0RnIGyFK?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d9ef7151-e429-486c-7638-08dc6dd18d76
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB3849.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 May 2024 13:36:37.0098
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 1Fauyz2AP45datvLPuHYxqQ3mel/bW0ZM7n5Y8uo44RD1sYlv7TY4sWlScOGImOR
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR12MB9343

On Mon, May 06, 2024 at 03:42:21PM +0800, Baolu Lu wrote:
> On 2024/4/30 17:19, Yi Liu wrote:
> > On 2024/4/17 17:25, Tian, Kevin wrote:
> > > > From: Liu, Yi L <yi.l.liu@intel.com>
> > > > Sent: Friday, April 12, 2024 4:15 PM
> > > > 
> > > > From: Lu Baolu <baolu.lu@linux.intel.com>
> > > > 
> > > > This allows the upper layers to set a nested type domain to a PASID of a
> > > > device if the PASID feature is supported by the IOMMU hardware.
> > > > 
> > > > The set_dev_pasid callback for non-nested domain has already be
> > > > there, so
> > > > this only needs to add it for nested domains. Note that the S2
> > > > domain with
> > > > dirty tracking capability is not supported yet as no user for now.
> > > 
> > > S2 domain does support dirty tracking. Do you mean the specific
> > > check in intel_iommu_set_dev_pasid() i.e. pasid-granular dirty
> > > tracking is not supported yet?
> > 
> > yes. We may remove this check when real usage comes. e.g. SIOV.
> > 
> > > > +static int intel_nested_set_dev_pasid(struct iommu_domain *domain,
> > > > +                      struct device *dev, ioasid_t pasid,
> > > > +                      struct iommu_domain *old)
> > > > +{
> > > > +    struct device_domain_info *info = dev_iommu_priv_get(dev);
> > > > +    struct dmar_domain *dmar_domain = to_dmar_domain(domain);
> > > > +    struct intel_iommu *iommu = info->iommu;
> > > > +
> > > > +    if (iommu->agaw < dmar_domain->s2_domain->agaw)
> > > > +        return -EINVAL;
> > > > +
> > > 
> > > this check is covered by prepare_domain_attach_device() already.
> > 
> > This was added to avoid modifying the s2_domain's agaw. I'm fine to remove
> > it personally as the existing attach path also needs to update domain's
> > agaw per device attachment. @Baolu, how about your opinion?
> 
> We still need something to do before we can safely remove this check.
> All the domain allocation interfaces should eventually have the device
> pointer as the input, and all domain attributions could be initialized
> during domain allocation. In the attach paths, it should return -EINVAL
> directly if the domain is not compatible with the iommu for the device.

Yes, and this is already true for PASID.

I feel we could reasonably insist that domanis used with PASID are
allocated with a non-NULL dev.

If so it means we need to fixup the domain allocation in iommufd as
part of the pasid series, and Intel will have to implement
alloc_domain_paging().

Jason

