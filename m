Return-Path: <kvm+bounces-59618-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id C9B92BC32AC
	for <lists+kvm@lfdr.de>; Wed, 08 Oct 2025 04:38:16 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 86EF23C3106
	for <lists+kvm@lfdr.de>; Wed,  8 Oct 2025 02:38:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 718D129B8F8;
	Wed,  8 Oct 2025 02:38:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="I668WAgj"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 73A51288513;
	Wed,  8 Oct 2025 02:38:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.10
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759891089; cv=fail; b=QMIignp5zHkM82XpLKtpNI0G7fqTovtcm9ywwcj7A6tXrrsPdGtbQe2fD+5W7pjhGETYv9l6V98q0/IZfIcS3OaPeM8y3UXIvuHDqocPP1ZtH/W6pODjmvP2JsC5P5PdjvtXVZQZji9B0gksCb8c1TjOZTH5jReMXyO8z6Fm+0k=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759891089; c=relaxed/simple;
	bh=av/9q/+5TtQo7ubpH8U9CYI2i0MkaiWQRBbENy7ni6o=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=mKaSJ2cLZ7x+Sdm6kLtYIdWkiOJCruzXQdu3po5IllwGJIXvRMOlLrR0+ub5vuoUJBrOc756QhULAvuDBB36tdjmwtUIYxPLKnpILHGPpS4H4j1GVvM8HxvG6sfRnAkgRLbyaZZnNZ9tYtul/misBiGLLqXm/zYIT7e7LHTrVxw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=I668WAgj; arc=fail smtp.client-ip=192.198.163.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1759891087; x=1791427087;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=av/9q/+5TtQo7ubpH8U9CYI2i0MkaiWQRBbENy7ni6o=;
  b=I668WAgjcDkf6bC52DUgvAylmh8+Km3Kfut7JOyipRW0zAqbFLi5gDUv
   ypnoJhlGr6pKSQWlE1vGfUngC4LNWjnQLRQc77gsljAOlx+Rn1KLlo1H+
   Y6EFWesW0eVoBrrhL8iAV2om/nOQY7rIy3a/PMuj+q44AfKzfGy1AeCxv
   W3LVsexed7oYfUB2bVXxBQML84iH9om3A17/hxtPorUH0AEEI6zyfo24o
   PwcV7kGpWZzI6pmvXpJM/xKg00LV8dAQ8y44kPEe7lkooTlH9kxQ/jHRU
   A3MFrd4a+jGwCvYowRtuG0S3tSFCex7Yhg3bbARPlrrg73VUxDt5j6b4/
   w==;
X-CSE-ConnectionGUID: er7zqWteS6y/EIrTAH03Lg==
X-CSE-MsgGUID: gsqOEp1jQ7iuErDvGdw0rg==
X-IronPort-AV: E=McAfee;i="6800,10657,11575"; a="73424509"
X-IronPort-AV: E=Sophos;i="6.18,322,1751266800"; 
   d="scan'208";a="73424509"
Received: from fmviesa002.fm.intel.com ([10.60.135.142])
  by fmvoesa104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Oct 2025 19:38:07 -0700
X-CSE-ConnectionGUID: Ij0a33aeRSWT1F/AbzwohA==
X-CSE-MsgGUID: i3D3ryNyRmqVnRlEKJBk+A==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.18,322,1751266800"; 
   d="scan'208";a="204043782"
Received: from orsmsx901.amr.corp.intel.com ([10.22.229.23])
  by fmviesa002.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Oct 2025 19:38:06 -0700
Received: from ORSMSX903.amr.corp.intel.com (10.22.229.25) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Tue, 7 Oct 2025 19:38:05 -0700
Received: from ORSEDG901.ED.cps.intel.com (10.7.248.11) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27 via Frontend Transport; Tue, 7 Oct 2025 19:38:05 -0700
Received: from MW6PR02CU001.outbound.protection.outlook.com (52.101.48.65) by
 edgegateway.intel.com (134.134.137.111) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Tue, 7 Oct 2025 19:38:05 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=erPlYa3irwbKdeyeH2KtQ2eFCaEOBGqoNGlKTobmyIdzX8e4AkLreYh7uxHrIhQVvsGVqlKtQDvAP5VSDA3olutTDdUgdlEWkUjKrQtC9dFnSTmZEGc6viNOH+kCO6K/GbGSmYn/glKwzx7uL5CuIB/VJN14DX3f2Vd9xZjLJO65S4EkS2UXvmbFeyaNs1WNjpShzWU1LHhcvK7obbJDeqb2QuwXLYxw6IiskJfv1T10HT6bixbO54Ch1hMh8vZlMJZBRECf7/Gq/BtRYLrc6/WUJUryyJHXUfGjfLta95M021itmvRtb2TZYvv2HBUL/pkjcrVnV624z48C/w8iEQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=O/KcpQ839lFsHv4YLn25udlbwQrdY33AJGqfFhQKhpU=;
 b=L/RYzplDu+f2PivpxlNC7cqw57tiPYUNhRjtrxbn9Iu4r7dR5amp9/B0ZAufbRMBXByrjO4YeVbdz6WAH2jP50QxNXCoUx3Xhpk64v7gq9tfPwZ/bcCPwRiL+9A1KQGKMqbG7b3Zxt6FwS3JqI8iXPQf92Jxh7lVPebeSqH7PQ9pqDa2gNfQMYttGah77j7GMawDFyI3bQvBG6q8LfIpTd4ItT25jzvehdQ5092wzADXkv5LcBZLQP3c6+IvelciDMG2/olGM+siWL0T7T36RCyAj46FeRjoux0bH64Z6qXJPIYKWAYkDObFGkE6F/4x1VdQExk+XcM4Aw5JZWWGfw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com (2603:10b6:a03:4d2::10)
 by SJ0PR11MB5772.namprd11.prod.outlook.com (2603:10b6:a03:422::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9182.16; Wed, 8 Oct
 2025 02:38:04 +0000
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::61a:aa57:1d81:a9cf]) by SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::61a:aa57:1d81:a9cf%3]) with mapi id 15.20.9182.017; Wed, 8 Oct 2025
 02:38:03 +0000
Message-ID: <1315076d-24f9-4e27-b945-51564cadfaed@intel.com>
Date: Tue, 7 Oct 2025 19:38:01 -0700
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] fs/resctrl: Fix MBM events being unconditionally enabled
 in mbm_event mode
To: Babu Moger <bmoger@amd.com>, <babu.moger@amd.com>, <tony.luck@intel.com>,
	<Dave.Martin@arm.com>, <james.morse@arm.com>, <dave.hansen@linux.intel.com>,
	<bp@alien8.de>
CC: <kas@kernel.org>, <rick.p.edgecombe@intel.com>,
	<linux-kernel@vger.kernel.org>, <x86@kernel.org>,
	<linux-coco@lists.linux.dev>, <kvm@vger.kernel.org>
References: <6082147693739c4514e4a650a62f805956331d51.1759263540.git.babu.moger@amd.com>
 <a8f30dba-8319-4ce4-918c-288934be456e@intel.com>
 <b86dca12-bccc-46b1-8466-998357deae69@amd.com>
 <2cdc5b52-a00c-4772-8221-8d98b787722a@intel.com>
 <0cd2c8ac-8dee-4280-b726-af0119baa4a1@amd.com>
Content-Language: en-US
From: Reinette Chatre <reinette.chatre@intel.com>
In-Reply-To: <0cd2c8ac-8dee-4280-b726-af0119baa4a1@amd.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: MW2PR2101CA0022.namprd21.prod.outlook.com
 (2603:10b6:302:1::35) To SJ2PR11MB7573.namprd11.prod.outlook.com
 (2603:10b6:a03:4d2::10)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ2PR11MB7573:EE_|SJ0PR11MB5772:EE_
X-MS-Office365-Filtering-Correlation-Id: 70355921-6e3c-40b9-b21e-08de0613b49f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|7416014|376014;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?MjAwQTFRLzM3T0x5SUN1V29SQ0FBck1RNlZtV3dZbDg2dVlaRjZ5cUFsSTJB?=
 =?utf-8?B?eHdWbDUyZUYrRkkra053STJGYjdOa3RGTTYvdEgrNEFYYlJvdzgxODRqUVUz?=
 =?utf-8?B?MEF3TWZmdTh5OXVMS3o5OWhUT0J3WlQ5UkErOTRVdU5Kb0c4eDlxUmdlWnV1?=
 =?utf-8?B?K2VhYllxYlZ6SHJ3anZKT3kzT2JKc1dZTWs3OXZXL2h1MS93ejhQV0YzT0xl?=
 =?utf-8?B?Z1RhOEdFYlQxTVVTVG4rTmt0ZFRzbDl1OWdrYVVjd1JxQ2JLamNocXNOYld4?=
 =?utf-8?B?U0tOcGw4Q0Y2L2N6a0FEdkhJWnB6eTVicU12MHNya2Nra2s5SmpJUXpaSzdX?=
 =?utf-8?B?SXZXd21LcVV3SGN1aTNjM2ZFOTNEM3BmYllYdXVJcmlqblFVZ1pNeXdVQWsr?=
 =?utf-8?B?bVNJdzRTVkZMalNvQ1k0NTBaTit5RGFDR3B5eXA3SkpmYWdyL2E1Vnd5UFFW?=
 =?utf-8?B?ZUgvRjBnVS9OVXpGaG1jWC9QRU00dnc4bjFkZDVJV3ErcFJET2FCcCtRc0V6?=
 =?utf-8?B?VGFYZXlsd1JFSzBGdHFTMnp2YlpXT0ZkbFZhejJta0VNWktHdjRlOFFTczFO?=
 =?utf-8?B?RFp6a0JtZUt6VCtHdndqZmN0RjFEQ2ZoTlp1Ym9NeGMxdmpDdE5sN2sxR0VT?=
 =?utf-8?B?TW9BeTc0TU9FN2ZsZFFGbVdpYytUcTBzN05IbThKQks4ZHVDa1NlTmpnOU5E?=
 =?utf-8?B?MzRHdVM5MWZGSyt0aGpsajVlNXZkSU1EenUxYmdpM2JEVmYvSWxFaFpOM1E4?=
 =?utf-8?B?M1h5TDVjMDVQSHNUOUVXczRFdFVGYktDVElPZU54M0NsYlJ6bTAvM0pmdUhW?=
 =?utf-8?B?aW1aZ2Jmb2pPRGpXcHE0RlVSOUdxMlQzU3FYZTlxcWRudFpWM0dieHUwYm5M?=
 =?utf-8?B?VFhrbzdtTnlGNUlFb1dKZWtWT1JqTlBHdk1Ja0lRZFowa01oZytxNXBxdmI3?=
 =?utf-8?B?K3FaRlB3L3ExcERYbmpTVHRKSG5Ga09IZjlvQnpTRDdNYzFmZDNTaHhmRmQr?=
 =?utf-8?B?Y3AvWjJmb25waUhCQTd5VFFHbzVONzY3MTZtcnR4MytOUHlYM3ltVFZFUVla?=
 =?utf-8?B?amFSeURKdTE3Q2VUam9UcHJNL0p1bks5S1hFekNzRmNrcVR1ZUt5YStUQmJ1?=
 =?utf-8?B?YmFtUElFUzNUTHo0Y1IxWEpBTWlmQkJpdHZlNXRWNFBsNGsweGRLNEtCVzBs?=
 =?utf-8?B?R0V2Q0dKdVB1eDQ2cnY4MS9VMU9PSUhvZURrdGJabkRZeXk3bFJWUHRIcjcr?=
 =?utf-8?B?S2pTNDg0QTQxMGxBSC9wOG5xRm5WWEVMYW5nN0NSOVJHRjVoZUxWbEQzYWxE?=
 =?utf-8?B?cnI4RVk3WUNtL3FEYThLTWx3NXhFdGNtckh2M2FSTlRvTEZWWDlEbEo3UGpp?=
 =?utf-8?B?NzMyUmRrZTNLN1plVFk3ZWtjaFdIa3p3eEZRZld6b1A3R05ubzJobTF6VEln?=
 =?utf-8?B?Uk96NHZ1WkI5N1UrSks5WWtNUk9INVltWCtocnA3dm1FVTJwMUc4anN3ODhX?=
 =?utf-8?B?c3Rkczg0TFVWTG53RmtvYWsrUVpWUGhqNGl2MWtTbUFpZnZXZzN6YjUrZHBz?=
 =?utf-8?B?Y1RBZWlHbUdRcTJhdHcrRlcyQ1l5c1hOcGxUcTZ6L243WW91RXhpTmZJQjBz?=
 =?utf-8?B?UHEyaVZBZUNIdDRCMnIxT2h1NUlqOEFBTnEreTdvNGNZT2RNcXdCS3lCeWVV?=
 =?utf-8?B?Q3hQalhlUWhhSk05b3RKakJPOEZGWTYwR1ZXR0ZzTkRFSStZbi90NG9kOWtj?=
 =?utf-8?B?bFhNWll6QVJnMEVYcDBrdFRjM2lrZjFsMS9IY1hhaHB5eWJ1TGNhaVJHQTkz?=
 =?utf-8?B?dmdlQVd5dU1sN0I0aTRocUkxTlNVOFQyajVoVDMzQzRyWTQxT0NIY295b1gr?=
 =?utf-8?B?TXN6MWtmSlRONXdxeDE2WDlsTzdBM3JCNU9BUzlIN2lBOUpvZkdERU5LeEZE?=
 =?utf-8?Q?m7egy337xq0xyzUY8tSUR9o/xopMb73P?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ2PR11MB7573.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(7416014)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?V2xESHVzOWh5bjdpSENZcnJsL0xzbkU4dHdBSDlZeFRRWml5T0thSXpnb3ZK?=
 =?utf-8?B?VmVDc1kxYVM2WkIwenYwN2NCeFBacTJPWFc3aEx2eWNUQ0ZGT1FhOEpxUlZk?=
 =?utf-8?B?aDE4K0hFa0tqcFlZQkUva01TSDVVc3k0NEIyRVVSMEpWWDA4YVZEeTNhRHVx?=
 =?utf-8?B?Wi9CbURMTGVydSs5MUcrWWpLQWJNaVFLWWdabXVObUJlc3NkQjRGUXduUzN2?=
 =?utf-8?B?bGhCbnFNNWdBdVJFOGhxejhPQzdTYm5HWXZBQU1hTitXN25Ya3ZpT3ljTElO?=
 =?utf-8?B?Vlp6ZS9wVkNaK1RLa1ZQVUEvMW9IMU9tZytDTGQ1NzBlZjFXSkkyK0w3RXdV?=
 =?utf-8?B?ZExNSFBHM2FqUUJacUkxYzROUEZaQTQzelNxYlpuN0Q4N0dyN2h1WjBGbU1J?=
 =?utf-8?B?Wnd4dUM3ampVb1VWdWxlU0xBWU05Wm9UMElkcTVoQk14RmJCNWUwMXJCMHNv?=
 =?utf-8?B?Y2NQUzUxVUFhZXY5bXVSMFBhNFp0akNsM3NKT3ZnMEN6YkxpZXdZa3ZmTkpZ?=
 =?utf-8?B?NVRkM0JMcGlUM21qS1FxNFVYUGJsV01qUUhSdkxNamxzNWkwZDBJMHJyZW9H?=
 =?utf-8?B?MDJpMjQ2bVNMUndxWCsrd29kdWY2ZUFSand0WldaaFd2dHB4YStvV0FLcFAv?=
 =?utf-8?B?TDN6Rm5IeWRLUW9sWldFdGZwamZoVE55VWxSSDdxeW42RTNUZWtXVm9DdlRo?=
 =?utf-8?B?akp6ckl0RjA5K2cyYlpERzNSY1Y3aC9STGhZb3A0enUveWpSZ2pmNlhZTlVj?=
 =?utf-8?B?TWQvMERrZGhiMDNrNFNjSDlmMEQwd3hOL2dvM3ErTWtvU0V4ZlJ5WUlkbzhY?=
 =?utf-8?B?RzQ4RGtFSEZ4cE9kdzVHVm1QbG94b21BdENNWWkyaTVKak5GTDZCaFVKaXdu?=
 =?utf-8?B?RUFCck9VZXRQSDZZMSszMmdySEZUVDNPQ3I4ZXpVYWVOWURERk1DekFvbWRn?=
 =?utf-8?B?OXJHcE5pbmg0WDlnamF5MWNOS1o2bHZMdjNUd0RIaUlpVitrNW4ySVIxTm1q?=
 =?utf-8?B?bTNkNmZkcnlLMitIYmcxc2ZmNmN4UStpUStpUExqNXVpTE5DVWw3NFJOVHB3?=
 =?utf-8?B?MXZ3eHZ6SDVqVTJibGU5TUpOamlnMkZKbEtKL3NrR0J0dXZPc05FNDMyanBw?=
 =?utf-8?B?eWxtSUFCdjM5bG14UHgycDNTc2J4WGQzeUl6RTZkK0tydFlsc0JZUVZ5Q1Zx?=
 =?utf-8?B?ZFhMZTNONXE0Uk1hR0w0MmYxdWVnTkJGSmVaTk5qWE9kbmdldGtLdXlCekR6?=
 =?utf-8?B?KytVdnBPdnVBMktTRWJDaCtsWlNWaThLeWFrcEY3R0FLSXpDYVdSRGllWlJP?=
 =?utf-8?B?OG9aN1J6cmtBT3VrSEFEU3NVbTI4UkpmNTEwNFlscFQ4UnVPMlJsbFJScThK?=
 =?utf-8?B?R1BQcXc5K0JITU5Fa1dHSlp5czVwL0lBS3lpZGg3M241ZVpBQzVYTnFqMmpZ?=
 =?utf-8?B?NjhnK0VrSFZtdStwQzV6dU1Mc2JKUld1VlN1Y1N1cGV1V05BMGZDeGZUb1V5?=
 =?utf-8?B?anJnMUNlOUVZU016ZTMvQ2hxOXo5ZHFTc3RqMnV1c2ZuMG1qL0pFbnl5VlJG?=
 =?utf-8?B?b1dhMFRuRUd6YTkrV2xwQUxZT2xlclVEd3hHaytoclZuODRMaml3cW5NTXNN?=
 =?utf-8?B?UWhrNkgyYW1ialM1RUE5WFhpeFJFM3FYMmtydTRSSGpnVXBzZklJbCtxS2pp?=
 =?utf-8?B?ZEVOZEFUWnZLbmhnT3NFSVJSbW9ZTjhGQndHNnQxTVkzNzhJSGUvVGRxM212?=
 =?utf-8?B?d1doWnBFelNuc2srZUU0dExTdDYwM1FKQVQ4NWNUQ1gzUXoxTEY0d1BDemQv?=
 =?utf-8?B?K3J6L25vSDU4QnFKTmkxdGFPd0Q4NHF5cVh5QVh0NGlFS05uK0o0Z1dXOWhQ?=
 =?utf-8?B?UUlEN0tWQjlJa09ndXk3RFZoSEdOZjd0dnByREwrU2hhQk45U0hSZEd4RGpD?=
 =?utf-8?B?dGpySG13RXhUZEE2eVc1bGlaN1EzL1MxTk5BcjRSNzl1OVFCZlBPcERrSFky?=
 =?utf-8?B?OVRXbzQvem1RelpPWkQ5elJqc29rbjlwcFdpY1pPTXpLUC9WQUZVdTc1OWNT?=
 =?utf-8?B?MWJRVE8yMFFuUDBVaW9HUUtOT2tWRm5uemlxUzFLVkIzV3p6dU91YTNvbjZM?=
 =?utf-8?B?MjRndnQxVmlsV2FtYVd6eUZ5dEJ5NitLUzBVdWd4NFJqQmxYNmNaaFptdUFu?=
 =?utf-8?B?Wmc9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 70355921-6e3c-40b9-b21e-08de0613b49f
X-MS-Exchange-CrossTenant-AuthSource: SJ2PR11MB7573.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Oct 2025 02:38:03.8977
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: HkW/7m2gRglmaz91EKaArY0iSy0H/hWmih0ovpFC5bipdJoBzcHSp1bNP9GqXArW4HxmOFa4Pxu5+nWGQ7Q/jlBN6k69wA3AcUm5newBxS8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR11MB5772
X-OriginatorOrg: intel.com

Hi Babu,

On 10/7/25 10:36 AM, Babu Moger wrote:
> Hi Reinette,
> 
> On 10/6/25 20:23, Reinette Chatre wrote:
>> Hi Babu,
>>
>> On 10/6/25 1:38 PM, Moger, Babu wrote:
>>> Hi Reinette,
>>>
>>> On 10/6/25 12:56, Reinette Chatre wrote:
>>>> Hi Babu,
>>>>
>>>> On 9/30/25 1:26 PM, Babu Moger wrote:
>>>>> resctrl features can be enabled or disabled using boot-time kernel
>>>>> parameters. To turn off the memory bandwidth events (mbmtotal and
>>>>> mbmlocal), users need to pass the following parameter to the kernel:
>>>>> "rdt=!mbmtotal,!mbmlocal".
>>>>
>>>> ah, indeed ... although, the intention behind the mbmtotal and mbmlocal kernel
>>>> parameters was to connect them to the actual hardware features identified
>>>> by X86_FEATURE_CQM_MBM_TOTAL and X86_FEATURE_CQM_MBM_LOCAL respectively.
>>>>
>>>>
>>>>> Found that memory bandwidth events (mbmtotal and mbmlocal) cannot be
>>>>> disabled when mbm_event mode is enabled. resctrl_mon_resource_init()
>>>>> unconditionally enables these events without checking if the underlying
>>>>> hardware supports them.
>>>>
>>>> Technically this is correct since if hardware supports ABMC then the
>>>> hardware is no longer required to support X86_FEATURE_CQM_MBM_TOTAL and
>>>> X86_FEATURE_CQM_MBM_LOCAL in order to provide mbm_total_bytes
>>>> and mbm_local_bytes.
>>>>
>>>> I can see how this may be confusing to user space though ...
>>>>
>>>>>
>>>>> Remove the unconditional enablement of MBM features in
>>>>> resctrl_mon_resource_init() to fix the problem. The hardware support
>>>>> verification is already done in get_rdt_mon_resources().
>>>>
>>>> I believe by "hardware support" you mean hardware support for
>>>> X86_FEATURE_CQM_MBM_TOTAL and X86_FEATURE_CQM_MBM_LOCAL. Wouldn't a fix like
>>>> this then require any system that supports ABMC to also support
>>>> X86_FEATURE_CQM_MBM_TOTAL and X86_FEATURE_CQM_MBM_LOCAL to be able to
>>>> support mbm_total_bytes and mbm_local_bytes?
>>>
>>> Yes. That is correct. Right now, ABMC and X86_FEATURE_CQM_MBM_TOTAL/
>>> X86_FEATURE_CQM_MBM_LOCAL are kind of tightly coupled. We have not clearly
>>> separated the that.
>>
>> Are you speaking from resctrl side since from what I understand these are
>> independent features from the hardware side?
> 
> It is independent from hardware side. I meant we still use legacy events from "default" mode.

Thank you for confirming. I was wondering if we need to fix it via cpuid_deps[]
and resctrl_cpu_detect() to address a hardware dependency. If hardware self
does not have the dependency then we need to fix it another way.

> 
>>
>>>> This problem seems to be similar to the one solved by [1] since
>>>> by supporting ABMC there is no "hardware does not support mbmtotal/mbmlocal"
>>>> but instead there only needs to be a check if the feature has been disabled
>>>> by command line. That is, add a rdt_is_feature_enabled() check to the
>>>> existing "!resctrl_is_mon_event_enabled()" check?
>>>
>>> Enable or disable needs to be done at get_rdt_mon_resources(). It needs to
>>> be done early in  the initialization before calling domain_add_cpu() where
>>> event data structures (mbm_states aarch_mbm_states) are allocated.
>>
>> Good point. My mistake to suggest the event should be enabled by
>> resctrl fs.
> 
> 
> How about adding another check in get_rdt_mon_resources()?
> 
> if (rdt_cpu_has(X86_FEATURE_CQM_MBM_TOTAL)
>     || rdt_is_feature_enabled(mbmtotal)) {
>                 resctrl_enable_mon_event(QOS_L3_MBM_TOTAL_EVENT_ID);
>                 ret = true;
>         }

Something like this yes. I think it should be in rdt_get_mon_l3_config() though, within
the ABMC feature settings. If not then there may be an issue if the user boots with
rdt=!abmc? I cannot see why the rdt_cpu_has(X86_FEATURE_CQM_MBM_TOTAL) check is needed,
which flow are you addressing?

Before we exchange code I would like to step back a bit just to be clear that we agree
on the current issues and what user space may expect. After this it should be easier to
exchange code. (more below)

> 
> I need to take Tony's patch for this.
> 
>>
>>>
>>>>
>>>> But wait ... I think there may be a bigger problem when considering systems
>>>> that support ABMC but not X86_FEATURE_CQM_MBM_TOTAL and X86_FEATURE_CQM_MBM_LOCAL.
>>>> Shouldn't resctrl prevent such a system from switching to "default"
>>>> mbm_assign_mode? Otherwise resctrl will happily let such a system switch
>>>> to default mode and when user attempts to read an event file resctrl will
>>>> attempt to read it via MSRs that are not supported.
>>>> Looks like ABMC may need something similar to CONFIG_RESCTRL_ASSIGN_FIXED
>>>> to handle this case in show() while preventing user space from switching to
>>>> "default" mode on write()?
>>>
>>> This may not be an issue right now. When X86_FEATURE_CQM_MBM_TOTAL and
>>> X86_FEATURE_CQM_MBM_LOCAL are not supported then mon_data files of these
>>> events are not created.
>>
>> By "right now" I assume you mean the current implementation? I think your statement
>> assumes that no CPUs come or go after resctrl_mon_resource_init() enables the MBM events?
>> Current implementation will enable MBM events if ABMC is supported. When the
>> first CPU of a domain comes online after that then resctrl will create the mon_data
>> files. These files will remain if a user then switches to default mode and if
>> the user then attempts to read one of these counters then I expect problems.
> 
> Yes. It will be a problem in the that case.

Thinking about this more the issue is not about the mon_data files being created since
they are only created if resctrl is mounted and resctrl_mon_resource_init() is run
before creating the mountpoint. From what I can tell current MBM events supported by
ABMC will be enabled at the time resctrl can be mounted so if X86_FEATURE_CQM_MBM_TOTAL
and X86_FEATURE_CQM_MBM_LOCAL are not supported but ABMC is then I believe the
mon_data files will be created.

There is a problem with the actual domain creation during resctrl initialization
where the MBM state data structures are created and depend on the events being
enabled then.
resctrl assumes that if an event is enabled then that event's associated
rdt_mon_domain::mbm_states and rdt_hw_mon_domain::arch_mbm_states exist and if
those data structures are created (or not created) during CPU online and MBM
event comes online later then there will be invalid memory accesses.

The conclusion is the same though ... the events need to be initialized during
resctrl initialization as you note above.

> 
> I am not clear on using config option you mentioned above.

This is more about what is accomplished by the config option than whether it is
a config option that controls the flow. More below but I believe there may be
scenarios where only mbm_event is supported and in that case I expect, even on AMD,
it may be possible that there is no supported "default" mode and thus:
 # cat /sys/fs/resctrl/info/L3_MON/mbm_assign_mode                             
  [mbm_event]

> 
> What about using the check resctrl_is_mon_event_enabled() in
> 
> resctrl_mbm_assign_mode_show() and resctrl_mbm_assign_mode_write() ?
> 

Trying to think through how to support a system that can switch between default
and mbm_event mode I see a couple of things to consider. This is as I am thinking
through the flows without able to experiment. I think it may help if you could sanity
check this with perhaps a few experiments to considering the flows yourself to see where
I am missing things.

When we are clear on the flows to support and how to interact with user space it will
be easier to start exchanging code.

a) MBM state data structures
   As mentioned above, rdt_mon_domain::mbm_states and rdt_hw_mon_domain::arch_mbm_states
   are created during CPU online based on MBM event enabled state. During runtime
   an enabled MBM event is assumed to have state.
   To me this implies that any possible MBM event should be enabled during early
   initialization.
   A consequence is that any possible MBM event will have its associated event file
   created even if the active mode of the time cannot support it. (I do not think
   we want to have event files come and go).
b) Switching between modes.
   From what I can tell switching mode is always allowed as long as system supports
   assignable counters and that may not be correct. Consider a system that supports
   ABMC but does not support X86_FEATURE_CQM_MBM_TOTAL and/or X86_FEATURE_CQM_MBM_LOCAL ...
   should it be allowed to switch to "default" mode? At this time I believe this is allowed
   yet this is an unusable state (as far as MBM goes) and I expect any attempt at reading
   an event file will result in invalid MSR access?
   Complexity increases if there is a mismatch in supported events, for example if mbm_event
   mode supports total and local but default mode only supports one. Should it be allowed
   to switch modes? If so, user can then still read from both files, the check whether assignable
   counters is enabled will fail and resctrl will attempt to read both via the counter MSRs,
   even an unsupported event (continued below).
c) Read of event file
   A user can read from event file any time even if active mode (default or mbm_event) does
   not support it. If mbm_event mode is enabled then resctrl will attempt to use counters,
   if default mode is enabled then resctrl will attempt to use MSRs.
   This currently entirely depends on whether mbm_event mode is enabled or not.
   Perhaps we should add checks here to prevent user from reading an event if the
   active mode does not support it? Alternatively prevent user from switching to a mode
   that cannot be supported.

Look forward to how you view things and thoughts on how user may expect to interact with these
features.

Reinette

