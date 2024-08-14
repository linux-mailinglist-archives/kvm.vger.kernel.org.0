Return-Path: <kvm+bounces-24102-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id DC6E29515F4
	for <lists+kvm@lfdr.de>; Wed, 14 Aug 2024 09:58:56 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 90A39282D6C
	for <lists+kvm@lfdr.de>; Wed, 14 Aug 2024 07:58:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5B13913CF8E;
	Wed, 14 Aug 2024 07:58:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="SZ5KyJGE"
X-Original-To: kvm@vger.kernel.org
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2067.outbound.protection.outlook.com [40.107.244.67])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7ADC813C918;
	Wed, 14 Aug 2024 07:58:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.244.67
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723622325; cv=fail; b=f108Sfu3sgy2YKkRuuWGDLrdLKQ2rH4TJlry6uRzJoTntCCfJjqkNZtEJFEe+6OJhWY30sOaOPpVTobb3wBE+iFun1G50BSiEN7llg5NxHtq3f8o5hp6/jh3hOjbHTKRd0SnEg+jrFdYB8OQv3vnrUu98PRbbEil96yFneIv2PQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723622325; c=relaxed/simple;
	bh=+9V2nvWsDLQ5czrRemdgSPdtGafHF5BgyW4HPbmBpac=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=Kl0YWOuonYvdN2NNGi7RQr4OQXLX5j4cn22J+//qOVk7OqrmsAn3zLfsjLnM0eaCIVzSaQaZZMt3MHiVigr37cqL6OUJTmNrt8GLXBl7lBzryO9a1YlgriK13IPMRUkcQXPAvGKWPfrbiITTNfZG/qrSnSDKr5MBaIVmfwLvZac=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=SZ5KyJGE; arc=fail smtp.client-ip=40.107.244.67
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=bzEq4GptIaKcQ5hqsCiP/knJBFU+eDP5QCJXuV6uSbD/D8gR657V/6e3yTkOkRNYqytv5XeJXLzARAw5EyX68lyJE6/diRMVMCV5neR0ParvZgUKZBa8qvmRb/D0Ki4qJqFTRhj1VpDuh+HTBB6RvrQv112EqncJ5QmI2IAvvkgx0jFCn8sRmJnvLikpaMPXFeuUhc9jHQzGA0jijz7H13nVBdE3HGU7DFHrQ8uRcArneCAo9n/gouWhbo/Re0b/UPrCXb8Y1/rOxVS3vC7NCVtZWxKoqyb3ZwlHHdJ434iPjRLTY7neifCeXyVU4VFGLJZa3meGqDrBh6BVFT6B6A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=K7kriZNlyp44Zv0azIsrkSHCNjHf+2EuvNDZJUXNq4o=;
 b=QUA/dLJzBeS+kPzL+lbnt880rjUmSK8njXskvkrB6qOXsrxq0Ziruh2d7WyOq080WZsNuuKh0VNVo5v/m+uhx3LQr+bslUKXJ3+5tqw7OJrEAy3qDWXg0yLO0348DRiZOIBINxHLy5WfmajUIBOGxe9gxe4rXidPePJgEwO06E9b0Igf7xHSbykveV0D6j1Ifq1039utPteHI+uffH1QMVgVTqn/WF2s47M7yVXLPpJc9nc4pEnf1gDIWv8tLaI/n/AAU3gsIir73I1eJHGkTjkfiqWroo45iSouJhdoSs7W43QbPyg572g5AJDTwJXs++5yJWiFzs5bhFfxWKTjfg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=K7kriZNlyp44Zv0azIsrkSHCNjHf+2EuvNDZJUXNq4o=;
 b=SZ5KyJGE2yNFWgHOf6n5SLcj+/ljY0+yNHgBbouIAnf07AHCr8xybh1Kajuwol0oOoU1XPcu3h+RsWWZAXYXwHm+A0GczUUWQd4Zx6r+dkUaGwV+BVUnAd4gFzb8/OnKBZ0uroPBIhHWQLjddT1WWbc4Q3TQVac1KZUdf8AyfkNQnoc6a/06jVmmLMgSLTTWhnZdJOgsHrfjKHtB/LVe/GAO8Ipqkof3+7488WRaF+EwTf6vkhklvr2NMNL3OEyklit06f6b4eKAZt7J7lzr3yjFDdRCgOkcLLMPmVDXLaaFCEwayLvTDmGGm4dIIuziVbcBasNQM7d9JCBifK4ASQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CY8PR12MB8297.namprd12.prod.outlook.com (2603:10b6:930:79::18)
 by PH7PR12MB6665.namprd12.prod.outlook.com (2603:10b6:510:1a7::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7849.19; Wed, 14 Aug
 2024 07:58:40 +0000
Received: from CY8PR12MB8297.namprd12.prod.outlook.com
 ([fe80::b313:73f4:6e6b:74a4]) by CY8PR12MB8297.namprd12.prod.outlook.com
 ([fe80::b313:73f4:6e6b:74a4%4]) with mapi id 15.20.7849.021; Wed, 14 Aug 2024
 07:58:40 +0000
Message-ID: <1431d84b-2d92-4a78-af49-702f005359f9@nvidia.com>
Date: Wed, 14 Aug 2024 09:58:35 +0200
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH] vhost_vdpa: assign irq bypass producer token
 correctly
To: Jason Wang <jasowang@redhat.com>
Cc: mst@redhat.com, lingshan.zhu@intel.com, kvm@vger.kernel.org,
 virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
 linux-kernel@vger.kernel.org
References: <20240808082044.11356-1-jasowang@redhat.com>
 <9da68127-23d8-48a4-b56f-a3ff54fa213c@nvidia.com>
 <CACGkMEshq0=djGQ0gJe=AinZ2EHSpgE6CykspxRgLS_Ok55FKw@mail.gmail.com>
 <CACGkMEvAVM+KLpq7=+m8q1Wajs_FSSfftRGE+HN16OrFhqX=ow@mail.gmail.com>
 <ede5a20f-0314-4281-9100-89a265ff6411@nvidia.com>
 <CACGkMEtVMq83rK9ykrN3OvGDYKg6L1Jnpa2wsnfDEbswpcnM1g@mail.gmail.com>
 <b4c144f8-5941-4bca-afdb-5feeb23b14c1@nvidia.com>
 <CACGkMEs2Sr_uEd+7Ry1e5MOcD5eKuSeCzHDLRodD0RbuweJ0qA@mail.gmail.com>
Content-Language: en-US
From: Dragos Tatulea <dtatulea@nvidia.com>
In-Reply-To: <CACGkMEs2Sr_uEd+7Ry1e5MOcD5eKuSeCzHDLRodD0RbuweJ0qA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: FR3P281CA0186.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:a4::13) To CY8PR12MB8297.namprd12.prod.outlook.com
 (2603:10b6:930:79::18)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY8PR12MB8297:EE_|PH7PR12MB6665:EE_
X-MS-Office365-Filtering-Correlation-Id: 8de1cced-3483-4b24-ce9b-08dcbc36e8e4
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|376014;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?Uk1Sa0dFaGF1V2NzRkFwTm5HMSt5dDVGOU5POHhkUmJleko2M3pMZ2FvL3Yz?=
 =?utf-8?B?eGNhcXMySHRWeGFTM2l5VGZqT3poaFhJSUJSS1A1d25zZlA4d2F0RXBTM1lw?=
 =?utf-8?B?T1NtQTNZZVNuWXh2Y2plZXhkcGdoeHFva1J4cmtUa2tKcXhXRnVxVDVENHlw?=
 =?utf-8?B?MGpOd1czUGZ5NjNxUFFkQkZ3NzJGdFpIaG50RXBrbkpwRDJYMTdhc2FCaWk5?=
 =?utf-8?B?VzcvU3R2SXYrQzVCMVA3L0lPZTljeDczSlpNMHpvaWI4amNGVXdjbmNOZHNp?=
 =?utf-8?B?Rm1MN1B1WTBqaEV2S0dSZmZEWEk1VXVZNmpMTTZVUy9hdEZncG02c3VQdTZ0?=
 =?utf-8?B?N2ZnY3hXbWNDTU84V1VaSUVLNEdkN3Y5aFNvWFk1WGhTcEE2VWkzbWI3N2Mw?=
 =?utf-8?B?U3lCWTkrNU5TT3ZkdnIzQVFBVDl0aW9pL3FUOSs1bUtOMjJCL2NYUWk2aCtl?=
 =?utf-8?B?U3JWTXArS3o1M0FkN0ErVFpWUWpYaENLL1RydzZ6WUsyRlpsM004TVh5blMr?=
 =?utf-8?B?em1PUCttUElpdzVlZGFzSElHRy9KL3NYZ09wblpaWk5qc3pWU1JFa2Vobnk1?=
 =?utf-8?B?VEhOT1dGMWpac0hFTU5UWEtoanlhNmJlQ0RJN2Q3bmxoKzIzWkpkRkhueE9B?=
 =?utf-8?B?TnF5YjNHY1p4ZkRNYUViSE13UjJ5VC9YNnh6WThBWGVHWjNhMUhWaTFDQ3hx?=
 =?utf-8?B?UzZjUldtbzVibVhvbUVqZDBySEZiNDlNbVRwbGkzZVBHYzgxeDVFbUk5Vm1H?=
 =?utf-8?B?eWNBTWttOHBFc0g5aDdUT0l3WENnN3Rsb2NWNDBPU2xpNGxMWW5UM0FZWFo3?=
 =?utf-8?B?VHYxUituLzd2SnlwNnEwM29heFArZ0hCeUxtVDNLWTV5UWxpVVVaSDY3ZEc2?=
 =?utf-8?B?bGFGeVUzTWx0aVRQWWxDWmlwWmpLR21tR1RmTlRiQ2dRTi9oSmJBeURMbWZX?=
 =?utf-8?B?UHczSVNYM3Q2SnJ2dmJLTDd6dXlydmlvYnFGUHd3TTY2QThyOG45WnM1Rzh4?=
 =?utf-8?B?UFRIdngzNTVTS2cvb1lxWUQyL3FNb1dvQU9XK3pFSkN5MWhQYTlkVmFMazJi?=
 =?utf-8?B?bGxEWmtDVTdlRHNaQnRteFZCa2RCMXhhd1gxSEpVbFVqWmIyTlliRWJEdldl?=
 =?utf-8?B?c0lZbzVzNVBPZXBwZ1ZKRDJMd2JwY0Z5RFh3VnRnd3NUODU3YW5vb1A0ck9E?=
 =?utf-8?B?K0c0ZVd6enBJT3h0Rk0yQUxYTExoK1lNMnhIcnpYcjJ3c3BHMXMwa3JQMkYx?=
 =?utf-8?B?a0dvT1R2TjdRMmtLRHNsUHZnTkMvM0Q0NHAwZEJuMGk1K0FMNGxDUWh4WU52?=
 =?utf-8?B?UUw5dnJCMERrVFZLcUhZVlRiUDJ0MWd5TzY5ZGZJbVJ5RXA3bWh5Qm9uSWU1?=
 =?utf-8?B?dnFuNTEyUGw1d0ZyTjRBSUNaRGF5NlhrVTV0REpJOFZTbVZSZGQvUGdmTCt1?=
 =?utf-8?B?VHo2QnNhVUJ4VlQzZ0ZTV3dINGdKNXd4UmE0eGZCaXJCcDhlaEFSK2pVZmsx?=
 =?utf-8?B?TkdzQVJpdHJKb0JUdkNIc1Rua2ExMlhmQnpjK2w1UVAxTVBoLzQvZCt5b0dx?=
 =?utf-8?B?NGI1MWcxMGJraU1kcDlvWGFPdFVyR20zT1lLVzVLcHp6MU8zNVI4SDFLWXhs?=
 =?utf-8?B?aWlZNXU2b3lnTzBtM3hkZEpUZGQ5NXhSRldJbkZXZFk2WGNRK0haS09NRDFw?=
 =?utf-8?B?MWlyVXJVSlRFNFFkLzdjSWtxbkdvaG9mL08yWWlobjh3encvUzhOdGYzOUw5?=
 =?utf-8?B?d3VxRHB0WTNwcnNFVTFSb3RkSXVwdk1YWitSdDJJTTJJbEUrWFViS1FKbHp0?=
 =?utf-8?B?Lzk0UHJsOW5qdk16bWFTZz09?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY8PR12MB8297.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?cW5hQ2hHOEpSNmNsOGpqbTVHYzQ1bmI2WWc2VEVDVWJHRlhJVFhWam5ZZjk5?=
 =?utf-8?B?N29CQUlacUZMWmhaOUs0S0tyWi9IY0kraXdnaFJqQnY3eHdTTFRQY0I1emtH?=
 =?utf-8?B?bS93dFJJd2VXaVZIUUFOeHBmRSt1cUw5R0dGMENyTXlKTDdJdDVhWmNRVWFw?=
 =?utf-8?B?SkhvaVpsOWpFeGZPUitOMHpmd21XSUg0QXVEVzhWZVhLdkNsZWN4M3pSc0Fq?=
 =?utf-8?B?U0VhUGwyVGdlTE0yeFdSTGhmRHFrc1RGZEJ2MjNCRzhhNlgvN3o0MEF2SU5D?=
 =?utf-8?B?OGpocDJqbzRxOUJTdnNla3N1ckl0ZlBPbUQ4bkZPY1FxcDg0MDdQaGtzd1Za?=
 =?utf-8?B?TlVHYldJT1poSHFCQXRWVERnalcwUi91Ly80dlNkZW1XTFNsQmd1THY4U3Ja?=
 =?utf-8?B?Ty9OdGx0VE9SeEo0UnZPaFo1V1diMVdjNG9TWXhjOE1WeDlGYUhrYkZyVjBF?=
 =?utf-8?B?WlMya25WT2RNRkszNjhzaE1ZVys2VEVFVi9lMTduajlyVThqc2psTWNrdTc0?=
 =?utf-8?B?Y1VCR0VXdy9TVzdveVRJNExDRERoa3V5eXR5M0pHbys5aE04cWM3M250bGlH?=
 =?utf-8?B?V1RYcFBWR21DYUQrRktRREZDOHU2RkVvVVNFdWFTTGdWRUV1d3l4dmtxVW5r?=
 =?utf-8?B?TzJyamJNQXMxakRMZ3JVN0h2QzBCMmtlVUk4Ly9ZcFJNaCtwbUZWa01INEFw?=
 =?utf-8?B?QVdZenBSMGNWdFdXeXdRYWFsaG11bHhRQkovMW40VE81L3l6Qnp5UW5ZV1Ro?=
 =?utf-8?B?ZGpGKzBQZS9jR0M2ZnJQcGFwbU81dFQ1ZGlRQkkxeGRnN0hSY2lhamZRbnV0?=
 =?utf-8?B?K0pURURJT0w0SHNESmlqZXdsTUFBZ2xobVk4dUxnb3liajQ0SmtiUFNXL3RU?=
 =?utf-8?B?K2ZJd3MwdDJLdUxUYWRCM0NCVURRMXRvK0hMT1F1OUx0K01PTjhFb01CM3NK?=
 =?utf-8?B?c2ZYU00xNzd6akFKVDNpdG5HU1E4Y1ROSmxrVDRGc1ZqK1VLSk9xZGlpazJ1?=
 =?utf-8?B?bElGNVJKVHFDOTBPRmo1a3JyYW1tZld2akRxMXRrbC9ZMUVDS2Voc1FUcFlz?=
 =?utf-8?B?Ym9wQ0NUZ3JMUzQ5Um1RcnNqT1FIMGpTbjR4NDJPckJnQU9lNkxiNUE2Y3RF?=
 =?utf-8?B?L2ZZNlA5Y0wzK3pZQk4ydzV1cnVxdXZSR0c1SU1hZ09YcktiUExBNmFRRkg3?=
 =?utf-8?B?bEhPcWRkZ0dQTXNRZ0xxMWVXaWRnYitVREUwZUxKUFoxbCtLS2M4bU8vU2g1?=
 =?utf-8?B?cGVuR1l3dEhiajYyWlZvVlNZS0J5TjRlS1JJbVl4VFdDNGFSdTJ6Wm16dXdU?=
 =?utf-8?B?M2IyaWdIdzdqOEM5WVZNdHNuUExNVmtpc0hLd0JyVEtyR2Q2eHl2bmdJLzdV?=
 =?utf-8?B?R2hkTjQ4VFM5NEduVXAydXVIcTJrNVJEbkhuZFpEU0ZQMGJLYzg3TUkzaDJv?=
 =?utf-8?B?TWhMWVZ2elZvWWNZTlRFTXR4UTZlR0doV1UzNGxCbmdMdncrWXVoRHRlREdh?=
 =?utf-8?B?RjVNeTE0STZqSVhSWmJCYzhjbS9YSitFSEVvVC9uTnR4bFdHUDhPcndVM3lJ?=
 =?utf-8?B?WUVkei81dGJ2SVkyelA0UG01OVNkUzQ3NnJLUWgwd2Vyemd5Q25QbzJKdkd0?=
 =?utf-8?B?SFRNcXFPQjU5RmNoaWE4LzVyOWNKYjhzTUU2R0xPVWpuc0txNzcwT2pncEVa?=
 =?utf-8?B?d3RaQVpEVEVZdk5PNHkrUHRQM2p2N2RtdkplcXF3cHNXZUdlK0puczVxS1Yw?=
 =?utf-8?B?dzErcDB6YzY1MGh3QnRMRGYyR1BVMzNZajdsZGF1MlUvdXEzM2pYZHRBRXhv?=
 =?utf-8?B?ZUxvblZrMi9FMlhhUG9JSGZyckRxVmF0Y1JYMFFXdERIeGF6Z2RqdFNFRmly?=
 =?utf-8?B?WTFUMHAxTWJoaUhuOXJZOW14TTIxclJwaUtmc1QwOVhSNTJ2dUltemttM2FM?=
 =?utf-8?B?Uit2eTlHdEhmRXVvZFZHQmZ3WTBOL3lBTVRJNzk1YzArSWFjdjdteEQ5UGFx?=
 =?utf-8?B?ZVJKYllZczlXNkQ2eDc5aCtxd09RUy9LZEZISUpGVzg2RUk1NFBnY0FQWUpF?=
 =?utf-8?B?N0ZKYzF4QkIwR0lzNjFkdmtGdVhVT3VCR0wrQ2NaNkJxS2FRWG5MT0dUem9O?=
 =?utf-8?Q?BMCoXUfXIG4+B/BaScYovVl0+?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8de1cced-3483-4b24-ce9b-08dcbc36e8e4
X-MS-Exchange-CrossTenant-AuthSource: CY8PR12MB8297.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Aug 2024 07:58:40.3255
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 5I0QL2wR19Xy81D3BvrC0vXk095f667zTUefg0lA1UXIAby9yRvhWCIpR2rOg6sL3Fv3B7QXMyaPJbRkejKBPQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB6665



On 14.08.24 07:29, Jason Wang wrote:
> On Tue, Aug 13, 2024 at 8:53 PM Dragos Tatulea <dtatulea@nvidia.com> wrote:
>>
>>
>>
>> On 13.08.24 08:26, Jason Wang wrote:
>>> On Mon, Aug 12, 2024 at 7:22 PM Dragos Tatulea <dtatulea@nvidia.com> wrote:
>>>>
>>>>
>>>>
>>>> On 12.08.24 08:49, Jason Wang wrote:
>>>>> On Mon, Aug 12, 2024 at 1:47 PM Jason Wang <jasowang@redhat.com> wrote:
>>>>>>
>>>>>> On Fri, Aug 9, 2024 at 2:04 AM Dragos Tatulea <dtatulea@nvidia.com> wrote:
>>>>>>>
>>>>>>>
>>>>>>>
>>>>>>> On 08.08.24 10:20, Jason Wang wrote:
>>>>>>>> We used to call irq_bypass_unregister_producer() in
>>>>>>>> vhost_vdpa_setup_vq_irq() which is problematic as we don't know if the
>>>>>>>> token pointer is still valid or not.
>>>>>>>>
>>>>>>>> Actually, we use the eventfd_ctx as the token so the life cycle of the
>>>>>>>> token should be bound to the VHOST_SET_VRING_CALL instead of
>>>>>>>> vhost_vdpa_setup_vq_irq() which could be called by set_status().
>>>>>>>>
>>>>>>>> Fixing this by setting up  irq bypass producer's token when handling
>>>>>>>> VHOST_SET_VRING_CALL and un-registering the producer before calling
>>>>>>>> vhost_vring_ioctl() to prevent a possible use after free as eventfd
>>>>>>>> could have been released in vhost_vring_ioctl().
>>>>>>>>
>>>>>>>> Fixes: 2cf1ba9a4d15 ("vhost_vdpa: implement IRQ offloading in vhost_vdpa")
>>>>>>>> Signed-off-by: Jason Wang <jasowang@redhat.com>
>>>>>>>> ---
>>>>>>>> Note for Dragos: Please check whether this fixes your issue. I
>>>>>>>> slightly test it with vp_vdpa in L2.
>>>>>>>> ---
>>>>>>>>  drivers/vhost/vdpa.c | 12 +++++++++---
>>>>>>>>  1 file changed, 9 insertions(+), 3 deletions(-)
>>>>>>>>
>>>>>>>> diff --git a/drivers/vhost/vdpa.c b/drivers/vhost/vdpa.c
>>>>>>>> index e31ec9ebc4ce..388226a48bcc 100644
>>>>>>>> --- a/drivers/vhost/vdpa.c
>>>>>>>> +++ b/drivers/vhost/vdpa.c
>>>>>>>> @@ -209,11 +209,9 @@ static void vhost_vdpa_setup_vq_irq(struct vhost_vdpa *v, u16 qid)
>>>>>>>>       if (irq < 0)
>>>>>>>>               return;
>>>>>>>>
>>>>>>>> -     irq_bypass_unregister_producer(&vq->call_ctx.producer);
>>>>>>>>       if (!vq->call_ctx.ctx)
>>>>>>>>               return;
>>>>>>>>
>>>>>>>> -     vq->call_ctx.producer.token = vq->call_ctx.ctx;
>>>>>>>>       vq->call_ctx.producer.irq = irq;
>>>>>>>>       ret = irq_bypass_register_producer(&vq->call_ctx.producer);
>>>>>>>>       if (unlikely(ret))
>>>>>>>> @@ -709,6 +707,12 @@ static long vhost_vdpa_vring_ioctl(struct vhost_vdpa *v, unsigned int cmd,
>>>>>>>>                       vq->last_avail_idx = vq_state.split.avail_index;
>>>>>>>>               }
>>>>>>>>               break;
>>>>>>>> +     case VHOST_SET_VRING_CALL:
>>>>>>>> +             if (vq->call_ctx.ctx) {
>>>>>>>> +                     vhost_vdpa_unsetup_vq_irq(v, idx);
>>>>>>>> +                     vq->call_ctx.producer.token = NULL;
>>>>>>>> +             }
>>>>>>>> +             break;
>>>>>>>>       }
>>>>>>>>
>>>>>>>>       r = vhost_vring_ioctl(&v->vdev, cmd, argp);
>>>>>>>> @@ -747,13 +751,14 @@ static long vhost_vdpa_vring_ioctl(struct vhost_vdpa *v, unsigned int cmd,
>>>>>>>>                       cb.callback = vhost_vdpa_virtqueue_cb;
>>>>>>>>                       cb.private = vq;
>>>>>>>>                       cb.trigger = vq->call_ctx.ctx;
>>>>>>>> +                     vq->call_ctx.producer.token = vq->call_ctx.ctx;
>>>>>>>> +                     vhost_vdpa_setup_vq_irq(v, idx);
>>>>>>>>               } else {
>>>>>>>>                       cb.callback = NULL;
>>>>>>>>                       cb.private = NULL;
>>>>>>>>                       cb.trigger = NULL;
>>>>>>>>               }
>>>>>>>>               ops->set_vq_cb(vdpa, idx, &cb);
>>>>>>>> -             vhost_vdpa_setup_vq_irq(v, idx);
>>>>>>>>               break;
>>>>>>>>
>>>>>>>>       case VHOST_SET_VRING_NUM:
>>>>>>>> @@ -1419,6 +1424,7 @@ static int vhost_vdpa_open(struct inode *inode, struct file *filep)
>>>>>>>>       for (i = 0; i < nvqs; i++) {
>>>>>>>>               vqs[i] = &v->vqs[i];
>>>>>>>>               vqs[i]->handle_kick = handle_vq_kick;
>>>>>>>> +             vqs[i]->call_ctx.ctx = NULL;
>>>>>>>>       }
>>>>>>>>       vhost_dev_init(dev, vqs, nvqs, 0, 0, 0, false,
>>>>>>>>                      vhost_vdpa_process_iotlb_msg);
>>>>>>>
>>>>>>> No more crashes, but now getting a lot of:
>>>>>>>  vhost-vdpa-X: vq Y, irq bypass producer (token 00000000a66e28ab) registration fails, ret =  -16
>>>>>>>
>>>>>>> ... seems like the irq_bypass_unregister_producer() that was removed
>>>>>>> might still be needed somewhere?
>>>>>>
>>>> My statement above was not quite correct. The error comes from the
>>>> VQ irq being registered twice:
>>>>
>>>> 1) VHOST_SET_VRING_CALL ioctl gets called for vq 0. VQ irq is unregistered
>>>>    (vhost_vdpa_unsetup_vq_irq() and re-registered (vhost_vdpa_setup_vq_irq())
>>>>    successfully. So far so good.
>>>>
>>>> 2) set status !DRIVER_OK -> DRIVER_OK happens. VQ irq setup is done
>>>>    once again (vhost_vdpa_setup_vq_irq()). As the producer unregister
>>>>    was removed in this patch, the register will complain because the producer
>>>>    token already exists.
>>>
>>> I see. I think it's probably too tricky to try to register/unregister
>>> a producer during set_vring_call if DRIVER_OK is not set.
>>>
>>> Does it work if we only do vhost_vdpa_unsetup/setup_vq_irq() if
>>> DRIVER_OK is set in vhost_vdpa_vring_ioctl() (on top of this patch)?
>>>
>>> diff --git a/drivers/vhost/vdpa.c b/drivers/vhost/vdpa.c
>>> index 388226a48bcc..ab441b8ccd2e 100644
>>> --- a/drivers/vhost/vdpa.c
>>> +++ b/drivers/vhost/vdpa.c
>>> @@ -709,7 +709,9 @@ static long vhost_vdpa_vring_ioctl(struct
>>> vhost_vdpa *v, unsigned int cmd,
>>>                 break;
>>>         case VHOST_SET_VRING_CALL:
>>>                 if (vq->call_ctx.ctx) {
>>> -                       vhost_vdpa_unsetup_vq_irq(v, idx);
>>> +                       if (ops->get_status(vdpa) &
>>> +                           VIRTIO_CONFIG_S_DRIVER_OK)
>>> +                               vhost_vdpa_unsetup_vq_irq(v, idx);
>>>                         vq->call_ctx.producer.token = NULL;
>> I was wondering if it's safe to set NULL also for !DRIVER_OK case,
>> but then I noticed that the !DRIVER_OK transition doesn't set .token to
>> NULL so this is actually beneficial. Did I get it right?
> 
> Yes, actually the reason is that we use eventfd as the token, so the
> life cycle of the token is tied to eventfd itself. If we don't set the
> token to NULL here the vhost_vring_ioctl() may just release it which
> may lead to a use-after-free. So this patch doesn't set a token during
> DRIVER_OK transition but during SET_VRING_CALL.
> 
Ack. Thanks for the explanation.

>>
>>>                 }
>>>                 break;
>>> @@ -752,7 +754,9 @@ static long vhost_vdpa_vring_ioctl(struct
>>> vhost_vdpa *v, unsigned int cmd,
>>>                         cb.private = vq;
>>>                         cb.trigger = vq->call_ctx.ctx;
>>>                         vq->call_ctx.producer.token = vq->call_ctx.ctx;
>>> -                       vhost_vdpa_setup_vq_irq(v, idx);
>>> +                       if (ops->get_status(vdpa) &
>>> +                           VIRTIO_CONFIG_S_DRIVER_OK)
>>> +                               vhost_vdpa_setup_vq_irq(v, idx);
>>>                 } else {
>>>                         cb.callback = NULL;
>>>                         cb.private = NULL;
>>>
>> Yup, this works.
>>
>> I do understand the fix, but I don't fully understand why this is
>> better than setting the .token to NULL in vhost_vdpa_unsetup_vq_irq()
>> and keeping the token logic inside the vhost_vdpa_setup/unsetup_vq_irq()
>> API.
> 
> See the above explanation, hope it clarifies things.
> 
Yes it does.

>>
>> In any case, if you send this fix:
>> Tested-by: Dragos Tatulea <dtatulea@nvidia.com>
FWIW:
Reviewed-by: Dragos Tatulea <dtatulea@nvidia.com>

> 
> Thanks
> 
>>
>> Thanks,
>> Dragos
>>>>
>>>>
>>>>>> Probably, but I didn't see this when testing vp_vdpa.
>>>>>>
>>>>>> When did you meet those warnings? Is it during the boot or migration?
>>>> During boot, on the first 2 VQs only (so before the QPs are resized).
>>>> Traffic does work though when the VM is booted.
>>>
>>> Right.
>>>
>>>>
>>>>>
>>>>> Btw, it would be helpful to check if mlx5_get_vq_irq() works
>>>>> correctly. I believe it should return an error if the virtqueue
>>>>> interrupt is not allocated. After a glance at the code, it seems not
>>>>> straightforward to me.
>>>>>
>>>> I think we're good on that front:
>>>> mlx5_get_vq_irq() returns EOPNOTSUPP if the vq irq is not allocated.
>>>
>>> Good to know that.
>>>
>>> Thanks
>>>
>>>>
>>>>
>>>> Thanks,
>>>> Dragos
>>>>
>>>
>>
> 


