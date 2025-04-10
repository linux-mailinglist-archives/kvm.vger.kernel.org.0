Return-Path: <kvm+bounces-43116-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 4F5F6A84FE1
	for <lists+kvm@lfdr.de>; Fri, 11 Apr 2025 00:55:51 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 534FE7B5E2B
	for <lists+kvm@lfdr.de>; Thu, 10 Apr 2025 22:54:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C6FA120FA81;
	Thu, 10 Apr 2025 22:55:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="lTPcsApX"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F29A172767;
	Thu, 10 Apr 2025 22:55:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.7
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744325739; cv=fail; b=eiBomzlaPf5AK1kACnWko9YIcbvL4i4K/FQEaHWX3JXR46UKbsEWsS+0sGG5/KJ6n1RU9EL0MQVYXDg/lGQAwQKJoa0Na++h7+9A7HxMojiK1cb/syB8QzK4zKpG8Gj1Mtn5MD3dz45vecgW1IKS1KadlAcCDatSpxDIFmoaP+4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744325739; c=relaxed/simple;
	bh=HvJNP4zW9Q103WdumRbJID45/Bh86QydKmXCpi+nqvA=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=rZ8m1NsvhOXtfb+gIYJ3u1S9MIyookRvrRKe7h3jf/uTkn5FL7jYE3aUaOZUbzCkN9IgdadDcwOCFtlbDrrsJe/dZCPbJpkZN0pLlIyuHq6scoeQbvoL0F6jjJNzTD/jdmNnBCcq3zISWNCkduM95xxHCqKEtsoN2SljgN0LIDo=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=lTPcsApX; arc=fail smtp.client-ip=192.198.163.7
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1744325737; x=1775861737;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=HvJNP4zW9Q103WdumRbJID45/Bh86QydKmXCpi+nqvA=;
  b=lTPcsApXMlBs2MRZGKXsnDxRnhPNJA/waqUvXXBQXLcuaCiW39CtRgAj
   n+c8tFwYpuW3iIqap3hrza+Z+R2ZiCLuCChXS4cbM5t/x8nONeFWBbNGy
   kT//lPwRFkYHk/6R6wx81gBfOn6X5vPCGGDB9zV+3b/MfnOzCqMtnokLa
   QMbLFw2BD/rS1NI9yNBrJmoga1wjOcRl/IJNogFgAR0HRaYhT6YwIPErW
   JSlQUUYKoaYjjVZkmDECUuTN7UcIHdMtWv9FXTH4R0yL1Wfdnc4tE0zYE
   eazQV1pmJ326CY9Xjml75+DhFs7ZzH+ewF7CYO1ClEb7U+2exJvb5I24+
   w==;
X-CSE-ConnectionGUID: puO6b7QXT/qPegf21dYbBw==
X-CSE-MsgGUID: t2agTgRORz6xun3v8TjObg==
X-IronPort-AV: E=McAfee;i="6700,10204,11400"; a="71256910"
X-IronPort-AV: E=Sophos;i="6.15,203,1739865600"; 
   d="scan'208";a="71256910"
Received: from fmviesa008.fm.intel.com ([10.60.135.148])
  by fmvoesa101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Apr 2025 15:55:37 -0700
X-CSE-ConnectionGUID: gfNCX207Q/maPvM9+c9ICQ==
X-CSE-MsgGUID: 07lDpbe7RYKs9YREXoE2QA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.15,203,1739865600"; 
   d="scan'208";a="129365617"
Received: from orsmsx901.amr.corp.intel.com ([10.22.229.23])
  by fmviesa008.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Apr 2025 15:55:36 -0700
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14; Thu, 10 Apr 2025 15:55:36 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14 via Frontend Transport; Thu, 10 Apr 2025 15:55:36 -0700
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (104.47.55.49) by
 edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.44; Thu, 10 Apr 2025 15:55:36 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=PGrr9Du0IsoCRKxaphDUiLuzQfd7aQvx4GwhVP2cieMvbnjmVz0MIHH4m4YstibUEgFXG/ql1KwMIQvDoyVkyG8cjXBOqFc7Z54ahZTvv3oHGO1WgTWHet29Si8S0YPu84IgbyucdbX1NA4h/tkoN02Y2Y4n9xXC3vDguRVfDUEzGHnlDv71XNHSiFGASTCAYucfAVN61WOwGzogs8ABzDcjy0UV66zaFZBSH4HaAv/rMsvcQO/RkSZjR0hXsTlJwVbHgBPHc+eAutHIut4uQeVqSTEjsyDK4aiO6tP2mBJSXtAxEYkAuPjf8sutTld88DYlYEJ2D0DbJgrCJTzx2w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=2ir3klhIY4RJg4yttUVNuQetmvm3aT3GeeY9176a8Ro=;
 b=cqYBev3hyEbL1spXmPgB/CvfIzPK3A/Ee+y/H9I7mNw199I3PLhGjO1QJgpafvxkhnJARTDmn5Uof05l8gMwNx+jH83cyaTFHYR0OpfQtBrhLBHZZ/4CN9RdXTk3/6iQ2yvOvN9+Fn64vhojnVRHshq/Vt4ureF5stMkhsEEJDwqO3ux4LybmWGC/osHCm2HiiUGkN7mYYRKE1eXQ95z7YyGFFSgFQ5bEW7oT5FJbOI5j1NGSLvmndefZ5fYs6bCZPNa8UoJIEf5f9odZEB8UwSGpi+h2uO82urCVyWcrgibtDzGbjfDpePRw7Eiy2z37qWH1A50BV/vdrasMsegQw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from BL1PR11MB5978.namprd11.prod.outlook.com (2603:10b6:208:385::18)
 by CH3PR11MB8139.namprd11.prod.outlook.com (2603:10b6:610:157::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8632.22; Thu, 10 Apr
 2025 22:55:21 +0000
Received: from BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::fdb:309:3df9:a06b]) by BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::fdb:309:3df9:a06b%6]) with mapi id 15.20.8606.033; Thu, 10 Apr 2025
 22:55:20 +0000
Message-ID: <0abe7616-0ef4-4098-bf55-8003ab958067@intel.com>
Date: Fri, 11 Apr 2025 10:55:14 +1200
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 1/3] KVM: x86: Isolate edge vs. level check in
 userspace I/O APIC route scanning
To: Sean Christopherson <seanjc@google.com>
CC: "pbonzini@redhat.com" <pbonzini@redhat.com>, "kvm@vger.kernel.org"
	<kvm@vger.kernel.org>, "xuyun_xy.xy@linux.alibaba.com"
	<xuyun_xy.xy@linux.alibaba.com>, "zijie.wei@linux.alibaba.com"
	<zijie.wei@linux.alibaba.com>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>
References: <20250304013335.4155703-1-seanjc@google.com>
 <20250304013335.4155703-2-seanjc@google.com>
 <5ca74373f6bd09f1f0a4deff8867cfb07ffe430d.camel@intel.com>
 <Z_hKP7iw_d3JgHbI@google.com>
Content-Language: en-US
From: Kai Huang <kai.huang@intel.com>
In-Reply-To: <Z_hKP7iw_d3JgHbI@google.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BY1P220CA0024.NAMP220.PROD.OUTLOOK.COM
 (2603:10b6:a03:5c3::9) To BL1PR11MB5978.namprd11.prod.outlook.com
 (2603:10b6:208:385::18)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL1PR11MB5978:EE_|CH3PR11MB8139:EE_
X-MS-Office365-Filtering-Correlation-Id: 20543251-3cde-4f2f-09cd-08dd7882c543
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|1800799024|366016|7053199007;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?dmgxckhyV3hJQjc5L1EzMVl0MDlYdmVtUEh0eURRTEY3ZVdpVnVxRWtOajRY?=
 =?utf-8?B?bmdib3RnWTZPM2ptL3lXZVBCc2EyREJBSjlBTEg1QzE1L0I1aUR2UGxHSXU4?=
 =?utf-8?B?L2U4OFRKL0FKK1c5eWg3RTRVUGI4VDRLT0IwaTRUOEFlaXhPRWFTbHEwQ0hN?=
 =?utf-8?B?Y1hlOWdFaHBDTlBLdnBsQ1czUnRIcWtwemduaU9vWWZ1ZGE0RW9yN0w0akpS?=
 =?utf-8?B?L2JMT3QxVy82T2VzSkF0TldmSUc2dk5xaEROR05BWHBEUVo0OW1oVEpOb2FF?=
 =?utf-8?B?ZDRNWHIrbjk5eEpRN0NWMVZnb0ordmlKZkxuMnFZSk1qZVhBVUFQaDk2NnRY?=
 =?utf-8?B?SVpLSENrTUNzQmxVNVUvWi84VmlmVkRuS29WbXI3UnIxdUtpVDVRVGJjTk82?=
 =?utf-8?B?UTNRT1g4a0lEaWNIa0tsU0ZtNlVVVzRBSW91R2cyOVdJKysxd0lPNkFaVWNG?=
 =?utf-8?B?MGFoQXJSTXpZU0tmYm5kUWErZG1xaGZQVnFTcEZlbzZsbG9udGdrbzY0NDZo?=
 =?utf-8?B?TlN2Q3FJVGZJdjEyWkJ5OW9xNS83eDJJRnFLWnI2Z0JFY1dhdHRJL2E5YmlZ?=
 =?utf-8?B?VC9MQ3MxME5HRlNwL0xUdjU5WUhwUC91MFNKK0d3eTVDTGJRamJsck9RWmdC?=
 =?utf-8?B?RGJob1NteEllY2hLZG9wQjk0clJhWkpSZFRYMjE4U0orWWsrN2ExQ2JnWCtI?=
 =?utf-8?B?VFZtbVp4RlBIR3BQUmVLeFdyYzk5ditMekpMNnpKSkJRUzdDVGMvVW9SeTZH?=
 =?utf-8?B?TkhkNE10UnpUcU83Y0xhd3RMYnB1cjduSFdvWXIyWXpmTHVKeFk3RXVGT3dh?=
 =?utf-8?B?ME9pM0tBWTh1bmZET0FHQVkzMkM3WjF2NGRtcG5SZ0xmclpqOE44Y212TkRl?=
 =?utf-8?B?YjY2SXRGWGZ0K0pDMG9FRWhkdVA1QUFNUk80bkZkcWllMnZxUjZ4Wlc5SDNu?=
 =?utf-8?B?bkQ4MUFHZ0kvditKSXN5ZzBsNSsxQzNudEFyaFM3WHB0K0tKNklpOWs5Ky83?=
 =?utf-8?B?bURmTVVIWmMzMzU4ZWloV3h6WS9VMzljNW8reUVVQzF3YkYrTkNtdXNhb2tr?=
 =?utf-8?B?NzZSU3N2QXk2K3M2TmIzOUJrK2o3MEtZcWo5RnNBb29xdXA1QzVTRE9ZbUYr?=
 =?utf-8?B?UmY0bEVRYmVYeTRIbVpuaElYSVM4SEJ3RnZwWVhNSityQ0JoREloaGRiaUcy?=
 =?utf-8?B?cHV2UldaeS9FVVhiSVZIazVETVV5TUhrazJMZ29hVjhSU2NXQks2SEZlejVl?=
 =?utf-8?B?ZGtYRmVqbittemtnTEx5bXNrY0pMVndDRTV6dEMreTZuSzVONDFtMHBOc0ZO?=
 =?utf-8?B?VG5GdVNzL1RWWlFKRUwxY290Q1N4bmhVVE8vV3BYVG1rQWU2eW04eTdGUkZH?=
 =?utf-8?B?dTNxT1Noem9saGpNaDVjUmF0eC8xUFowR1dNMlBzRjF3cEpvNVBvVjdCSHpG?=
 =?utf-8?B?eE5aN290NzZBQ0pZQTJXc3M1aEZXS3EwYW1FZHd3YmxsM0hRQWYrTVlNaStj?=
 =?utf-8?B?U0NFdEkvVEo3SUZEemhMb0xHcDQ3TVBVWmFORXh6M2lpMEQvdFV6OGg5UmND?=
 =?utf-8?B?M1JBS2ZCb1JOT2lPYlRMRC9zMkFXZ0VGeERBN0F0a1VkSUVsSVByTGJKaC9a?=
 =?utf-8?B?TXAwRCtHMDJ4UEtJZ2hJY05ZenZKdHBqUVo5cU1zQkdsZ1UvY0daSzlpVFAw?=
 =?utf-8?B?ZHNBVisrQlJBVFo3NUtwdlZmNTFLcUIxdUF5cTFZeWt3cEx6eUI3NXdtVXdF?=
 =?utf-8?B?UVhwakRneDNlZThINDFkaktxeVQvYzU3SVlLSnBYcFJUbHI2SVpkTFM3V1Rl?=
 =?utf-8?B?eXAva00yMnFNckxDNkhGb1EyMzN1WGdaaC9ubmxhTmZGVWVJQnBxMHhaSGU3?=
 =?utf-8?B?aVBNNUwyL2g5d3RkRUh6SjQvb2hjaGJkTkdnY05uL05ZMVZmakVRaWlZQ2tK?=
 =?utf-8?Q?Ion1GmujPok=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5978.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?blp4bkN0SnpIclpJOC9VYW9zaW5NbXpNZExYQWYvMVRlaG1xK0xEemFNSmRy?=
 =?utf-8?B?dXRUcTJTaElmOTdFUEs5WG1PM0hwOHRaQ2NOR1RKbnR5MW9vbG0zaW5peHdt?=
 =?utf-8?B?U0tlOFh1RU5XUjhQb2d4WW9pWHRaNnFoQVJ3bGZScjBxTm1RKzFaZkRVNEFC?=
 =?utf-8?B?YndRb3djVTJCUjVNL2t0dHBHNUlscGluNUpOdEFxelgyZkdja2pHV3pscU9L?=
 =?utf-8?B?YU40Y0o1dzl5NlY4RGt4OW5PMEhBNldOWks4U0dST3lXYTdwRVNXYVlBSndn?=
 =?utf-8?B?V0FwQkNoeENYenZVNnd4NnU3NHA1NEgrQU14SFZubzYwcHN4V3NyeDViZE5U?=
 =?utf-8?B?Y25EV0tYdHVEeUxhZmJxK3Q4L3RHdGNaekZ4YllUU3VSR0RTV1BrbFFoQW1p?=
 =?utf-8?B?cStOOGtmcHlzRlFDNDg0Uy80cmRzM0h4czFMZUowZjZyZ3hYdHVjRGFidE5z?=
 =?utf-8?B?Qm9OR3lLbTlTc0J5My85UWN1aHVDOTZhWURhME90OHlUSkc2UVNuZzBPcVYr?=
 =?utf-8?B?bjhad1dCTGpQdFcyNmVRMkpiZldLT3dCSE1RQmdUb2dOUk1zNEF6Y0l0djZn?=
 =?utf-8?B?TU9heEIxNUFzSFZMUEp1c3c2YWgyZkFxMy95OWdRUzU4M3RnNzFOeVVybk9h?=
 =?utf-8?B?K3crYlVzc2piMDBoNXhVTGRuVUZmNnQ0WmlqTTUrYmRnZHVaa3dpWXhReDlR?=
 =?utf-8?B?OXlPMnQ0T1p4RVFLR3hJTjlFUGlQS3pyUXNsaWZjaW94RFp3dGQrenM2b281?=
 =?utf-8?B?RTlvVDhMaXlwa3k0MWRBZHYyeUpWdXI5S3NnekQ3cjhHUWFCcFJiNEwxZXhW?=
 =?utf-8?B?d1FHanZNMVc0NUVscVg2SzJmTTNGeEhoWnZZL0NYSkRkUTNZRStacEh4emZL?=
 =?utf-8?B?Y2grRUszdjJ0d2dNMkVVRjlFUlFhVnRwdlFvUE5CQ1BxZ3MyWnd2eDlxeFVL?=
 =?utf-8?B?Tm5xMjdxM3JzdUFqN2lCdkpNc3MxSmljRXh1aWl6dGs3ZTU1V0wzNk1GSGlu?=
 =?utf-8?B?cUMzYkpXYXUyWnFaZU85ZVVTQWFPVnR1RmxJLzV4dlpOS0syRVFSN2d5dFBT?=
 =?utf-8?B?VE1qM3VkZ3dKZnRQVlE4RmF2SDB2dUhrdzZOdzgwR1E2c3dJblJ1NEFxM2Qy?=
 =?utf-8?B?QU9ZbjNCS0M3YTErWnF3MndpKzhNVTM1ZXF2VmFaN0lTcEs5ekM5ZXBRMGFy?=
 =?utf-8?B?K3dvMGZlWVJCeWFnbmkyWW5URlFZa2phVmtkYisxVVNCb2dYQWNRUHJvYVFC?=
 =?utf-8?B?bVVtMjRaUVRIQmY1TXZjam9HVEhxQjMwK1FwRmlyYzhNbTFJZWdhVEtENnBu?=
 =?utf-8?B?c1FHdDVMK283cEZSWDB1b2pGRDdneXFSS0pkbFpHMElrdUcvRnltd0FKZmpZ?=
 =?utf-8?B?cjJWVVByUitRQ0tGbUpXdGVDMUttZUc4ZmlGaGxxZktoSnZkUW5OSjh3VUJ0?=
 =?utf-8?B?czI1Wms0dkVNcnZjWFhDZHd0MjJYNXJaQU5uTEF5elBpNWVadnlIK1R5Smpo?=
 =?utf-8?B?NGhNakFmQUNadXkvZVpCK1hYdXJlTW9MUDdld3hURjVVZnpXS0dOVk5KN09l?=
 =?utf-8?B?N0RUMlZoZkp1TnJ5a05JY2Iwa0hCZzAyc0ZmcFp5NVlvVXg0WVZmVmtSRGsv?=
 =?utf-8?B?eVJxVHoxVGVVK3JULzM1UDVTRFdvYk0xL2FlODNLU2cvdkJrd1ZNYVJxbmJD?=
 =?utf-8?B?RlIxVlQ2R09PZ0FCRW9XalovSGxvTDRmWFhYZXlONFhOWHkwdGdIelRKelNp?=
 =?utf-8?B?NHEvbjRMbDNzUW1YWC9uWFpsRW9LZ3I3Mll4M0RHdkxGdVhDUkpQSVFUL0lj?=
 =?utf-8?B?Rzk1MGs4Q3JOaTlpdHo4VVZKZXJkdjR0WnRuVUZmbVZsQU1wSm9mTnNFWFV6?=
 =?utf-8?B?YjJGUzNYWjJ1bGJITXhjVUhwUFlIaFh5UVVNaU9TVmlsbzM2ZFBkK2swbDQ3?=
 =?utf-8?B?YjVaRkJ6K1FiMWptQ3Yxdm12RzJlOXJtbkdQOHJsVXdiSUh4ZGd3QXNaTkw5?=
 =?utf-8?B?aDZMaXJrcnRjNEZmWVVjWE9RdVZMYmY4RjNQNTZvSzY2VWpLUVpwVVRZUlNO?=
 =?utf-8?B?U2VwVzhIL09DMWVLR2YybjNnRjB1em9HTFhjci96WUY0VCtMQ05nUzk1ZmZn?=
 =?utf-8?Q?PoWwuKRpPpdGE2aUNAcb+FLGW?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 20543251-3cde-4f2f-09cd-08dd7882c543
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5978.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Apr 2025 22:55:20.8486
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: AjB+/01iHqsJPUSzb4tqomfhpo23SQA5Zocgf318e56HyRBbf+gS3du2X5ZLrwttyiMoUL8ZkHomM4bNx2MSiA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR11MB8139
X-OriginatorOrg: intel.com

On 11/04/25 10:46, Sean Christopherson wrote:
> On Tue, Mar 04, 2025, Kai Huang wrote:
>> On Mon, 2025-03-03 at 17:33 -0800, Sean Christopherson wrote:
>>> Extract and isolate the trigger mode check in kvm_scan_ioapic_routes() in
>>> anticipation of moving destination matching logic to a common helper (for
>>> userspace vs. in-kernel I/O APIC emulation).
>>>
>>> No functional change intended.
>>>
>>> Signed-off-by: Sean Christopherson <seanjc@google.com>
>>
>> Reviewed-by: Kai Huang <kai.huang@intel.com>
>>
>>> ---
>>>   arch/x86/kvm/irq_comm.c | 10 ++++++----
>>>   1 file changed, 6 insertions(+), 4 deletions(-)
>>>
>>> diff --git a/arch/x86/kvm/irq_comm.c b/arch/x86/kvm/irq_comm.c
>>> index 8136695f7b96..866f84392797 100644
>>> --- a/arch/x86/kvm/irq_comm.c
>>> +++ b/arch/x86/kvm/irq_comm.c
>>> @@ -424,10 +424,12 @@ void kvm_scan_ioapic_routes(struct kvm_vcpu *vcpu,
>>>   
>>>   			kvm_set_msi_irq(vcpu->kvm, entry, &irq);
>>>   
>>> -			if (irq.trig_mode &&
>>> -			    (kvm_apic_match_dest(vcpu, NULL, APIC_DEST_NOSHORT,
>>> -						 irq.dest_id, irq.dest_mode) ||
>>> -			     kvm_apic_pending_eoi(vcpu, irq.vector)))
>>> +			if (!irq.trig_mode)
>>> +				continue;
>>
>> Perhaps take this chance to make it explicit?
>>
>> 			if (irq.trig_mode != IOAPIC_LEVEL_TRIG)
>> 				continue;
>>
>> kvm_ioapic_scan_entry() also checks against IOAPIC_LEVEL_TRIG explicitly.
> 
> Hmm, I'm leaning "no".  kvm_set_msi_irq() isn't I/O APIC specific (and obviously
> neither is "struct kvm_lapic_irq").  The fact that it sets irq.trig_mode to '0'
> or '1', and that the '1' value in particular happens to match IOAPIC_LEVEL_TRIG
> is somewhat of a coincidence.
> 
> kvm_ioapic_scan_entry() on the other operates on a "union kvm_ioapic_redirect_entry"
> object, in which case trig_mode is guaranteed to be '0' or '1', i.e. is exactly
> IOAPIC_EDGE_TRIG or IOAPIC_LEVEL_TRIG.
> 
> 	u8 trig_mode:1;

This makes sense.  Thanks for clarifying.

> 
> So as much as I advocate for consistency, I think in this case it makes sense to
> be consistent with __apic_accept_irq(), which only cares about zero vs. non-zero.

Yeah LGTM.


