Return-Path: <kvm+bounces-15948-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id AB4448B26AD
	for <lists+kvm@lfdr.de>; Thu, 25 Apr 2024 18:40:02 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id C98EEB26E59
	for <lists+kvm@lfdr.de>; Thu, 25 Apr 2024 16:39:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7AB2914D71C;
	Thu, 25 Apr 2024 16:39:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="P3Rp749n"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 01E3714D2B7;
	Thu, 25 Apr 2024 16:39:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.16
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714063169; cv=fail; b=MJCnyKh2Ou4eheXPkU9HluRQUp2ooKH+Id1yuFk91vVpxamtGY93kyljacsDwlMx1SzeGRg3yqP2HQ5KXOHGKDf+aEq/QU1InysnHRkhgEUdSmeyuv9XSoQbwk3+1Q0KNiOFw1XVw0bgJFWOzuuiMckRNWV1X77/XqFW0YqRHbE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714063169; c=relaxed/simple;
	bh=pC+3SolQLNvqq2g+ZW+9jRThwVyDtHVAweay2L0m7Os=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=YCi8LyNTPuYbcYrj4GQPuj+avYd7Qs656oBVBUci9bm7pIul0yUQhr2dCzbkAr7olP4KVY+wz5SroHPiILDOrnNIRfq5nXaG7OhBdsIeCcOPXixFeCdTAkazm2ciqA7pEWLvURT1JYRJtnk0r+BsoU1NxLDGWR0sIypX8tpubg4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=P3Rp749n; arc=fail smtp.client-ip=192.198.163.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1714063168; x=1745599168;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=pC+3SolQLNvqq2g+ZW+9jRThwVyDtHVAweay2L0m7Os=;
  b=P3Rp749nuj3RTnZD4Gxocqd3bZ3Hfz4K1qoPM0RRYsPCi1G5UFVSr3u9
   2SptbrxJIlSi3OKNrzJC8O+K5H1tFZMuuNjES5ex3w9v8Ty0CYF3AdpXj
   oQISsQVjQ76dwH1wYHTsEzqwD0q1Y+3pTrnqe24qyOPI/skFzUolQ2Gbf
   LDtiE0nuWehKgGIVFw4FfcREvK4oNyveO6bMq02upO3WPVjE/mi5UVEmG
   f7ZBk7kK/Dl3UZFPBBMa85bPCAtJlzYjfPMGOWOW7Q4zt8wgDzG8+/fEx
   zlYuGHp5+H0SzvAkT/HMxqV9cahyfvRmaKg/G6xRy8y/eHpi5Jd/rfUyb
   Q==;
X-CSE-ConnectionGUID: 4WTL8U2VSAaC0Khwd6Ih+w==
X-CSE-MsgGUID: csEyuurKQluTKVVJ+E92wQ==
X-IronPort-AV: E=McAfee;i="6600,9927,11055"; a="10301291"
X-IronPort-AV: E=Sophos;i="6.07,229,1708416000"; 
   d="scan'208";a="10301291"
Received: from fmviesa002.fm.intel.com ([10.60.135.142])
  by fmvoesa110.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Apr 2024 09:39:25 -0700
X-CSE-ConnectionGUID: 1XmosykUTmOJotT2Dudzqg==
X-CSE-MsgGUID: DDo0URWFRAWYsivXtIMUqw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,229,1708416000"; 
   d="scan'208";a="48378560"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by fmviesa002.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 25 Apr 2024 09:39:25 -0700
Received: from fmsmsx602.amr.corp.intel.com (10.18.126.82) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Thu, 25 Apr 2024 09:39:25 -0700
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35 via Frontend Transport; Thu, 25 Apr 2024 09:39:25 -0700
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (104.47.58.101)
 by edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.35; Thu, 25 Apr 2024 09:39:24 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Lt+lhYQ8Tta4ZFykTv2d2Z0cZ8P5/MNDNV3EG2xJT5fNdu2iH8+nujxdJrYA7cEL/ccvQQ7kwSiVkh6bq+RxMLYBi7y4IcFvdcyXi6VqGKcLDSLbl+0ShXGxXtL+dK12ww/NSimecr4l0ofq/8WdL8btDzUykin3VT7zL8nQX8OzetnLzeWpP2PZDkYsktrBC4njrzhcOdl8lWwJPDBJBh+dm9ah4LyS3/sifuuPT6ALFNF0lwtwUQssDy/2MvCmpJQbfLgU3lPWBQAvCkOX21on1LSvUZgC5QNU4UzH/OphxKv2QD4NRuj8fvl3f/DEov3A/XnbsRhBkjD3pOzFtw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=i9L92papqdsEIBI4bGUeW54/jonRfU6xI0cLq2kH4iw=;
 b=BpV2/tLGknceSG8OUjDc+Br83dDClR+Ff2tirtTmphwhcneRgD1ajoEWiT9recc9dEn0ppbvxikD8Qo2WrmPrwHMVugNI+GWLpMBNIrz/pN2lt0gYuOcoHq6qiMSD1eTurGmy4lNpw943K1Gm/YALx0NwCnOdEIGzfeE5ax/hqzHmC2v6VbWJygtYR6vE0P3UM4S2leKnXzbG1b4O4tWL8NFwt4E9rQ+D4ieI+/HKAE5IpK9X2tH0+oDL/IFJwIuca2zr6Rlb+rDouPZstu1ljdiwx7bKdrjPRRJqv07aFhIeMBMvmuoRfitPZaEatFHZeZPoHcF15rHdsjYntCmig==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com (2603:10b6:a03:4d2::10)
 by MW5PR11MB5929.namprd11.prod.outlook.com (2603:10b6:303:194::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7519.21; Thu, 25 Apr
 2024 16:39:21 +0000
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::d610:9c43:6085:9e68]) by SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::d610:9c43:6085:9e68%7]) with mapi id 15.20.7519.023; Thu, 25 Apr 2024
 16:39:21 +0000
Message-ID: <19752b65-5ea2-4ad4-84e4-6b4694bcf976@intel.com>
Date: Thu, 25 Apr 2024 09:39:18 -0700
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH V4 0/4] KVM: x86: Make bus clock frequency for vAPIC timer
 configurable
To: Sean Christopherson <seanjc@google.com>
CC: Rick P Edgecombe <rick.p.edgecombe@intel.com>, "jmattson@google.com"
	<jmattson@google.com>, Chao Gao <chao.gao@intel.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"vkuznets@redhat.com" <vkuznets@redhat.com>, Vishal Annapurve
	<vannapurve@google.com>, Xiaoyao Li <xiaoyao.li@intel.com>, Erdem Aktas
	<erdemaktas@google.com>, "pbonzini@redhat.com" <pbonzini@redhat.com>,
	"mlevitsk@redhat.com" <mlevitsk@redhat.com>, Isaku Yamahata
	<isaku.yamahata@intel.com>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>
References: <cover.1711035400.git.reinette.chatre@intel.com>
 <6fae9b07de98d7f56b903031be4490490042ff90.camel@intel.com>
 <Ziku9m_1hQhJgm_m@google.com>
 <26073e608fc450c6c0dcfe1f5cb1590f14c71e96.camel@intel.com>
 <ZilAEhUS-mmgjBK8@google.com>
 <ad48dd75-3d14-461c-91e4-bad41c325ae7@intel.com>
 <ZiqCCo9WipMgWy8K@google.com>
Content-Language: en-US
From: Reinette Chatre <reinette.chatre@intel.com>
In-Reply-To: <ZiqCCo9WipMgWy8K@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MW4PR03CA0162.namprd03.prod.outlook.com
 (2603:10b6:303:8d::17) To SJ2PR11MB7573.namprd11.prod.outlook.com
 (2603:10b6:a03:4d2::10)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ2PR11MB7573:EE_|MW5PR11MB5929:EE_
X-MS-Office365-Filtering-Correlation-Id: 23f71fc2-bbfa-4556-facf-08dc65464263
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230031|376005|1800799015|366007;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?d1hTT0tQQk5vZXFEQzhGZVJCSk5kT0tOU245MHNuTHFvK0RsSDJUbEdBL0x2?=
 =?utf-8?B?U3AwSUdjelViNXJhblE5N1Z2LzRseUZ1NEMzNHl3Z0FobHJpZEd0ZnhGSDVD?=
 =?utf-8?B?V1drUG1DMVQrc2QyeERxeTZlUUxIamtzK3UzanFNZHNSNXp1enh3TzU5cHFM?=
 =?utf-8?B?OUg0S3JGK01pRjdwc2hOL2RvNVVJaFFqU2FkY1RKejkzLzVFL2k1Tk9FZjh0?=
 =?utf-8?B?dkZPRVQySC9STm12dlV2M0l3SDRVaE9EY3UrUlBBVXl1cDNQNWh0QVZLaVF4?=
 =?utf-8?B?YU9jQVpWaVNVMHk2SUtpak9oY2I5aFZBR0oyb1U1SEthSDBLNktQaStaT1pD?=
 =?utf-8?B?Z1Y1TTlWL2NTZkUrRDRxekZxTUVqaEEzMDhZckkrdy80eG50ZGRLZnhGZjVH?=
 =?utf-8?B?MkpNci9ORzV5VnlUZTUxckU2MFEvMGllUGg0Y3BUWkM3UUZlc2xHVUZ0N2dK?=
 =?utf-8?B?OFBkODl6V2xDSmNYTDNPVlJxNnY0djJKWmhsV0dQRG8vaUhKVmp5N3Y5NXoy?=
 =?utf-8?B?OWNZaWYzT05sM1p2STk0MlFFTDlXUW5ndFdhb21YejlHRDlzMXhwY0xWRy9U?=
 =?utf-8?B?YmNYVkg3a1o3azVhamVKUlY5Zkx0STdGWXJmMHFBdlhtUzJTc0ZoVW5FelVZ?=
 =?utf-8?B?OE5BbmJuN2V4MDdXMEloRmIyS2ZaaExYR3RRYVFsbUg3akpVVFhXQkJCRE1F?=
 =?utf-8?B?MkpOUXJVdUJqSjBTRlV6VExyaVVNc1RLakhCb1Q1b3BETjB3dHdRK0NwUG1i?=
 =?utf-8?B?ZDlQZzQxNXEwaHNjRGVJbmdrL083QlNBWlczSGFBcmFqd1ROQlJuSnY0bGp1?=
 =?utf-8?B?ak5FOERnNWhDb2tCTmlJalFISmhGWEFwelBTQW1vbTFZZTZZZ08rTnVadkQ5?=
 =?utf-8?B?elc3bjA5SnQ1MHlNRzJKL3ZlZ0RaVklkTkxCSzhnaWZyUVNPWFF5WHhQbUhY?=
 =?utf-8?B?SVp5T04wcnNhYUowZ0U1aG9sQ25tZWVwdm5CSk5MTzZJb2ZmOU5raHN4ZVk4?=
 =?utf-8?B?b3lHL3NhanlYa09wUlpoOVRQZ3lRRVNJR011Y3liZkM2eGZ4K3Fwa3NUd3VP?=
 =?utf-8?B?bGYzRHdlQmhGQ3J3b0NzSzJaMnEzUklkZXg5bGNZOUFzVTFqRy8weGc1UGsv?=
 =?utf-8?B?OS91NW5rMU81aTFMNGhpQzg4RFF5UW5uOVpjMkQ4aldBbjRmOGs2ZGd1TzdV?=
 =?utf-8?B?cjNKSm85UTNXMmM4SzVVVmUzNTFFZVFuQ3l3ZkFUbDFXRGlGdldvaVV1bjYv?=
 =?utf-8?B?dTlQUFRMRVNzb3lmSlhISHZyT2QvT01QRjlvNU5zLzRsTGUraWgvaVNIL1Vn?=
 =?utf-8?B?SHBmWFVsRW5BRm5qN2t6bW8vejQxUWNhM3hFOEhpNEVLakhsL1ZHVVhZY1R6?=
 =?utf-8?B?eThPakdZejZEVVFCcHNTeGFvNVNmMXdpQ1Q4UFJXdkJoLzJxVWQ0SFpZTENq?=
 =?utf-8?B?ZThnMm04QlFRWjRmQTNmWFlYWmlEVGd1NHVkZ3ZPdU11b2RkL3o0NHpCeHhG?=
 =?utf-8?B?TExJQ3lvcmZGaDgyWTBFdHF6K1BRM2hMRDh1anBYL2NESTNLSU9VVkg2NkxZ?=
 =?utf-8?B?VFhnQU9oU1hLeW4xYTdvSUV4TzlYYTFzNitKK3FTT0pTU3d4ZnZEMXovdngy?=
 =?utf-8?B?TzlMUkZCb1k4dy9NUjh3R2RwdDdsVjBIcDcwYkpLbmVhNzByOXI3QkZlVVNt?=
 =?utf-8?B?QnJZWStlMTUycmxGK2FXcnluV21sT012Z3VFbGZielVYWnFTc1ZaczZ3PT0=?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ2PR11MB7573.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(376005)(1800799015)(366007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?bk1acExwS3VpQldra3JybWVac2tBSXV3RGxEZlJpR1l0UDNWK3dKaHJBalJa?=
 =?utf-8?B?MDFsbFh0dzBHK2UyZTF2SGd4MmRVd0tuQmhJT2wvRWNQaFIyR1hhM2x0V2pX?=
 =?utf-8?B?MHpnU3BjL2duL2RnZlczREh0MnVQZDc1NjRDMU5lSENwU1FWVjU5bURhallm?=
 =?utf-8?B?UXJ1ajhISGFzMlF3a1Y2cmxjSVplbEJpZkVJSkNQbHQ0YTY3NGo1YUduQ0d0?=
 =?utf-8?B?bkpabTltY0Nvb1lGb0xGYjlGWFRYV3hjejNvM0g0eDJtTS95NUQzR1VDNzN3?=
 =?utf-8?B?OHNOSjJrUWF2Q1hmNmV4ZTR3YXpzWDRXZjEyNzllNWEvZXpoMHp2L1g1SFBp?=
 =?utf-8?B?RUc1cXFMMXR5c21kWlZwQkZFLzZUdnB6WWt4VjRnRHJpUWgvcUJVUjNlWTZq?=
 =?utf-8?B?UDNxVXkrKzc0UnovZU1UQ2RUT2h0cGV6N3JCNHRPRjMxRjcyZWw1Y1RzS3Jk?=
 =?utf-8?B?RzVJSWZxYWpFckxUcEJkbFkyUXpLWWtET1pBWmMrVUl1YUpIOG1RM1ZnUGV2?=
 =?utf-8?B?N0ErYnhxQ1FPVk5mQytnMk9zS3dOVFdtK0RPVVZqMzlEN2FicUhxQXo4UjI3?=
 =?utf-8?B?SlN2THViajhCYzZzTkxQRW42ZitPaCtMdjVpS0J0MCsxSU5vRWJqc3I1Z3dn?=
 =?utf-8?B?ZzFkNUVqY2p5eEVBTkIvNTFFL3FWTWJLNndOeUR4WHdvN3JkM1J1MllJaURK?=
 =?utf-8?B?Z29NcnZZRnd1WHNHdXBhVHN0SlZwT0hBSUd4Z0I2QUt3T3FVTng4MEtLTE5H?=
 =?utf-8?B?UVVjQjhNS2JhZGNLVWZmYUt6aE1kakVKWmpTM3UzT3I3RFBsa2pYSXdacmwv?=
 =?utf-8?B?dU56bm8ra1BNSHJyUTBUSkVHUm53aytqb3NDNVdjZ2llTWhpSy9hM1FzY1V0?=
 =?utf-8?B?YXo0dGlDV0lrR0NSaFErN1F1MnBZalRMVEMrL0tOUmN3VTJjUUorTzdvNlQ5?=
 =?utf-8?B?S1VyVWRzNzVpWTBoaElSWWw3aVZkYkxadWJYUGdCcGN3eFRyRDYzSklDNVdU?=
 =?utf-8?B?R1UxNytqVmVLbjJxTVRjMXczYnU4dHpIWklCSE9EQll6T2lkL2JkcDl6ODkz?=
 =?utf-8?B?RlplWXdoU0w1VnFWVE9FUTJyNlV1Z2lkVlpHa0M1Ni9pQmxTREdxcC9Xck5s?=
 =?utf-8?B?Q3MzV3FwM1FOeFp2dlI2RzIyWDhGSDI1YU56QitGSE1DVUFrY3dnN1JLbENx?=
 =?utf-8?B?bUtlRmhwbGNLYWFCK1RQSXNWa0F4ZVZMMDVHTnB3U1ZLTFdNUndQWWZkMFE0?=
 =?utf-8?B?WkV5WUFlc3pIeVR3RjR6L1pDUDgvb1I4NW44T29LQnYxRTJLMGhjcmVrWjUw?=
 =?utf-8?B?czA4OGJEUk05TkhKUUJ2WW52VU1yN3c0U2wzbERhRk96OXYyNFJ3QTNaaGlX?=
 =?utf-8?B?eVB5aWVsZURQUXAySHBPazEwcEVlTDNDODZVcFB3ZGhKM0NTMXVqSk1MRDRY?=
 =?utf-8?B?NVdiVlBXS0oyZ1NJcWJFazIydnhJc1lxTmNqRWRkZVNVT3dzYytCYlhpclJw?=
 =?utf-8?B?MjNiZUlocVloenVvcjI3VlJOd2pXZXRKTFhsRkdmR2l4RSsxOHRWSTF4NzM5?=
 =?utf-8?B?VXM4U3Q1T2UrR1hIWXV0SCtiRmdBUGl0WHNFVi94UXQ2UzRiRVV4TEE1eXV1?=
 =?utf-8?B?TTNlNit4a214MklXRmNYZVpNUEZFZFFHUGlURnpxL25SU2JOaTd5SlVNcVlG?=
 =?utf-8?B?STFpcnZNcklCcmpiQ0NNR0Z0dVoxRDNldWYxdElnRHZRWDlQczYzUHdZNy9R?=
 =?utf-8?B?T2V2dEpKaWFYZzRPRi9pa0xtYlQ2MkovSzUvMkkxYjI4TmU5ZGU1K1ZzeC9z?=
 =?utf-8?B?WVB4REJkQjduMG9MR2lRRmxsT1BTYnhHZm9UandlQVp2UUlVMVprbVl2ZnE2?=
 =?utf-8?B?OTJ0Mi8xNmZ4M1BsTmIwbmVYcnltcW1mOEl6R1UvdkQ5Z3lDYzI4OEtnWkJv?=
 =?utf-8?B?T096THZKTWRvKzd4UFR2Yk0zLzhWRmpsaC9JZklkaGtyTHZNOVpSaloreTZs?=
 =?utf-8?B?elpVL2RTLzNRT2ZzZUo4QjVvaTkxUHFVVGtUTFpBSWlJY1ptaUk2SDZFRlk2?=
 =?utf-8?B?K1NBNkVkc1ZIaVUrMUtTMkpHSGtlOHdJWmdLZVFnUVpsMkJpbkdVMjJmbmZK?=
 =?utf-8?B?QmI0MDFNRjFreVFjMTJuSmdPLy8vNGFkUGVKYWd2S3NUQkJhUFo5dmwyWXps?=
 =?utf-8?B?U3c9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 23f71fc2-bbfa-4556-facf-08dc65464263
X-MS-Exchange-CrossTenant-AuthSource: SJ2PR11MB7573.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Apr 2024 16:39:21.7658
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: IdqhQes1OY+B6htdOWazhz7EvcSv7gZyEZicJ4GEUXpnc/WskNp7ffJYDkr+lvmSIeue12sp/hbfNlvU8jRTnl0iCqdnJAJyrADSdycKoAk=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW5PR11MB5929
X-OriginatorOrg: intel.com

Hi Sean,

On 4/25/2024 9:17 AM, Sean Christopherson wrote:
> On Wed, Apr 24, 2024, Reinette Chatre wrote:
>> There was one vote for the capability name to rather be KVM_CAP_X86_APIC_BUS_CYCLES_NS [1] 
>>
>> I'd be happy to resubmit with the name changed but after reading your
>> statement above it is not clear to me what name is preferred:
>> KVM_CAP_X86_APIC_BUS_FREQUENCY as used in this series that seem to meet your
>> approval or KVM_CAP_X86_APIC_BUS_CYCLES_NS.
>>
>> Please let me know what you prefer.
> 
> Both work for me, I don't have a strong preference.

Thank you. I'll resubmit with the capability name changed to
KVM_CAP_X86_APIC_BUS_CYCLES_NS. This is the only planned change.

Reinette

