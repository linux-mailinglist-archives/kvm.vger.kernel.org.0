Return-Path: <kvm+bounces-65647-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 33F34CB250B
	for <lists+kvm@lfdr.de>; Wed, 10 Dec 2025 08:44:36 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id DAD7A30B5253
	for <lists+kvm@lfdr.de>; Wed, 10 Dec 2025 07:42:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A938E27FD52;
	Wed, 10 Dec 2025 07:42:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="ljuquDOy"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4C79B2264DC;
	Wed, 10 Dec 2025 07:41:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.11
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765352517; cv=fail; b=sPG+B7OMv77EFcKkbPwh3Do9mYBc2f3DnNjYDQjxMKyRbDECOs+UUsgU36BkAUqSi77/+ozueXDN5NBqqmRQawga3NM+IgC+O/RMy8e1tSJ+tjSW54/uzvAuhIQVjccd6skr7yC1KF97pJ/72GSa0/c+3ir5La0foJWFq4KWNBU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765352517; c=relaxed/simple;
	bh=L7YnH5SMigNJr5JttIDfMga0C0eKMKhnuVP2xOMwpWs=;
	h=From:Date:To:CC:Message-ID:In-Reply-To:References:Subject:
	 Content-Type:MIME-Version; b=qp4QeuExwyBSlyfGg0XlGKYSOgLipc2S6NZ8Yf+ZdJJ9nm+bKrE2WAn1YoAvk7MGJdIyrD9k9FO47+dXN1Sb9zvP5cr0/d8mJZrwo40dNz5B2zG3LY8aUZpcViWuQMzAfzQTk9nP9T1BVNr/p/jhvSDH7dlNvcjETp4IT/F7iD4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=ljuquDOy; arc=fail smtp.client-ip=192.198.163.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1765352513; x=1796888513;
  h=from:date:to:cc:message-id:in-reply-to:references:
   subject:content-transfer-encoding:mime-version;
  bh=L7YnH5SMigNJr5JttIDfMga0C0eKMKhnuVP2xOMwpWs=;
  b=ljuquDOyAO9/yM4GWrpksmw8GC0Jz3LERHonJrma2Rh8ogAn5e87Q2nj
   Pk2KMdizfB10NNsXZhFyRkJ1bb8vNt1HeueDbY8WUxukxOUGfZyRGU4Q3
   I+1qSPYsfWFcFs5hFpFtXiaRCB++gDEI83jws/0dpZvD0gPObZDf5j3aP
   +2ANhLZsuASN90vF/POdDPJPCdJHJ9pzdZRQNQkuZ+wrmRiFW6yCFJAzL
   fakYJHFIsiT2ELrwHajKYbwPr3ED5bIPXx46VMFNUpuceZB7EsvAibA+K
   HoYRsxoiY+BQX5Qxy5AjxEgMahC7444uKex8fAX4cw0NT8e8hHJDHwR5C
   Q==;
X-CSE-ConnectionGUID: NZVZs94WQe6TWDJMeUZWYA==
X-CSE-MsgGUID: SKN2JakYTrmg+ey8tVnQRQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11637"; a="77935999"
X-IronPort-AV: E=Sophos;i="6.20,263,1758610800"; 
   d="scan'208";a="77935999"
Received: from orviesa009.jf.intel.com ([10.64.159.149])
  by fmvoesa105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Dec 2025 23:41:51 -0800
X-CSE-ConnectionGUID: 6BZiu9XwRtyuiZVtms0hNg==
X-CSE-MsgGUID: Iu+ci7RBRk+4Irhp0lEOkw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.20,263,1758610800"; 
   d="scan'208";a="196197551"
Received: from orsmsx903.amr.corp.intel.com ([10.22.229.25])
  by orviesa009.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Dec 2025 23:41:51 -0800
Received: from ORSMSX903.amr.corp.intel.com (10.22.229.25) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29; Tue, 9 Dec 2025 23:41:50 -0800
Received: from ORSEDG903.ED.cps.intel.com (10.7.248.13) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29 via Frontend Transport; Tue, 9 Dec 2025 23:41:50 -0800
Received: from CH4PR04CU002.outbound.protection.outlook.com (40.107.201.53) by
 edgegateway.intel.com (134.134.137.113) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29; Tue, 9 Dec 2025 23:41:50 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=XXaRejdT3JdFUbV9jHsbRhV/y1V/W1kRqj7eoJIQTF04kVebmV5D43Z6BIlDPx4VLr4Fm/B0OG+zi9dBKbb9YWQp5HNax0Dwj9c9OYhaUwf8fHQFD1GIgXbESU6Bkn/AUwdf6wQ6xxZaPe5cpDP1Uejd5UELs3bjDzOqGsCJIl+4q/HpW49ZCNfIsaEAV5Gagxc6lI9yweyOWKfnVT4CHi372ucYLTIl4GriniCy02q7m+SNRs0qRqBNOdbE0NwVNhhlOfY0HXpotH65pCn16Ja1w8Dxe1wlQOfMGJs46W1QlIyNnAj7y/G9VItpY+OLJpk2kdf9zn2ELMS4Y4bQ/g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=YQXu2YtO92Ghv1G7Et0eAIxNjmNB9pBQsyEpaesnSsM=;
 b=rQ6l6Cu7z4nonZv0T0d6PaPgoMmx+XYRtUyvam4Lql9ObIIwAQ4XqGji8vpcyFDWjZvAziIsotHixrFS8Kayp9XgWHfaiR3ohGybEKCP/1cGRnrcs3zAqRoMzIOofxyxuWIQonio3vjpRAZO98hIRwdpnACq/dOV7YN9y0mmPDz4eCtHHYccnHI5OzM2HjCK3J7PfFEvaaI3EBqeUtWV5difTpWNKzvYMUrKVmCm77JHsl+xNSlhYw4XxU0vo7IpMw58um6rMq33KedQS3l9xd7sf6fiHgUjRI8Tzs+bvpWkLf7uJLmy+XUig2sR4+me7xdX6mCCCzzbUjST5fCLPw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from PH8PR11MB8107.namprd11.prod.outlook.com (2603:10b6:510:256::6)
 by SA1PR11MB8325.namprd11.prod.outlook.com (2603:10b6:806:38c::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9412.7; Wed, 10 Dec
 2025 07:41:43 +0000
Received: from PH8PR11MB8107.namprd11.prod.outlook.com
 ([fe80::1ff:1e09:994b:21ff]) by PH8PR11MB8107.namprd11.prod.outlook.com
 ([fe80::1ff:1e09:994b:21ff%4]) with mapi id 15.20.9412.005; Wed, 10 Dec 2025
 07:41:37 +0000
From: <dan.j.williams@intel.com>
Date: Wed, 10 Dec 2025 16:41:33 +0900
To: Sean Christopherson <seanjc@google.com>, <dan.j.williams@intel.com>
CC: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
	Borislav Petkov <bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>,
	<x86@kernel.org>, Kiryl Shutsemau <kas@kernel.org>, Paolo Bonzini
	<pbonzini@redhat.com>, <linux-kernel@vger.kernel.org>,
	<linux-coco@lists.linux.dev>, <kvm@vger.kernel.org>, Chao Gao
	<chao.gao@intel.com>
Message-ID: <6939242dcfff1_20cb5100c3@dwillia2-mobl4.notmuch>
In-Reply-To: <aTiAKG4TlKcZnJnn@google.com>
References: <20251206011054.494190-1-seanjc@google.com>
 <20251206011054.494190-3-seanjc@google.com>
 <69352b2239a33_1b2e100d2@dwillia2-mobl4.notmuch>
 <aTiAKG4TlKcZnJnn@google.com>
Subject: Re: [PATCH v2 2/7] KVM: x86: Extract VMXON and EFER.SVME enablement
 to kernel
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SJ0PR03CA0224.namprd03.prod.outlook.com
 (2603:10b6:a03:39f::19) To PH8PR11MB8107.namprd11.prod.outlook.com
 (2603:10b6:510:256::6)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH8PR11MB8107:EE_|SA1PR11MB8325:EE_
X-MS-Office365-Filtering-Correlation-Id: ab0b1dca-cdef-4e23-4247-08de37bf8c99
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|7416014|366016|1800799024;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?MS9TcFRzQUZsVjFxZHZJaEE1OXh1dys5cFRGZitTY2l0ZWRPeDdDOGp0ODFj?=
 =?utf-8?B?WnpEUldkbUZhWFhYSDduSERpNGN2VTc0QjJYMExzaEdYdnV3WE15Sk8wRE1s?=
 =?utf-8?B?QmJLRENIL2hLMEtGdmhIRHBEbURJNGEzOHhRUFB6ckwycTFML3pmUHg5b25Q?=
 =?utf-8?B?M3M0U2pTWUNuSkZ1L3VmUmJqMzM3UDl3MTBreThudmlrN2JoTTd2K0JqWjRQ?=
 =?utf-8?B?N1lTMFlCcFkyY0UxQThYeE9tQ2VFZjFIUU5FRDBkT3ZycWozMUlDMWtNSmlk?=
 =?utf-8?B?SnZPb0NFeUVYQTRSQjcvb2tSQ3pxeHZTdHl1ODlmOFhjTDU4YitIbDhuVTA3?=
 =?utf-8?B?bVk0SEN6SmpoRDFveC9HM00wcXZ4MHJBbUQwb0p6YmZ1S2U5d2VvWWlBWCty?=
 =?utf-8?B?anJDOVpQZVowZjhLNjlrR0U2YVpVUVNtdWhjV0d5YjRLQUU2QWVyanUrTHRw?=
 =?utf-8?B?MkFzMCtVRlpUL3NnaVlXLzRxbXk4RndkbnJpTmtJbksyNWtJVjR5OEtFcHRt?=
 =?utf-8?B?NVFBOTUzZ01zdG9kTzQ4Y0ZzTUtXN2MyVFVPSkJmQ2hLd3drTnN0Sk45VlRV?=
 =?utf-8?B?Y1hPL1ZGSGgzWDdoRzVxdEdHSEZoVSttd3IrYkE4KzZwSFhvMG9SMStLaHA1?=
 =?utf-8?B?QUZxZXYyS1NQV05aNDg3L2FDTVNQWHhLK2ZIc3RhOUZFb203c2JlRCtlSGg5?=
 =?utf-8?B?QTdYVGhHb1JGQStDNWsrNXlEK3dYVVB5SVh1WWkzMTBBL2dmNmhZQTY3NGY4?=
 =?utf-8?B?Y3BRNEtPMHBkMm9uVmE3S1J3QUh1emd3OGRLa2VUYlNpN1BJc3VHSFY5MktR?=
 =?utf-8?B?Nm1nUkJCRGdCeERSeUFSVG50YmdSc09ZUnNLOEZzSHNYWU8zNWRTeDRpQm9O?=
 =?utf-8?B?ZElSUEwzelZ6RkVOek9xVXFhcGEybEJ5SlRNOEJvSkJHN1dNcE92QzUxZW1W?=
 =?utf-8?B?dlFHWFRwcWhaeHBSZmpiYW1GSHJITnk2ZFFWTjBKbUNEVnZMVzZid1V1cVJr?=
 =?utf-8?B?UHBBRGlSZ2hVY2l6TnhMaDB2bXJDMGdiQWt1Sm5FTUZyVlZSMWo1ZnlIQ0VW?=
 =?utf-8?B?UGErVGtvODVaTUJBZmZUZUdLcGphU3FGMTJZL0R6b3doUUF3ZCtxNmlCVVVW?=
 =?utf-8?B?OXM3YU5CVWl0bjlyZFZpZS9VZFNGRUExR1l5Y3J6YjBRQlhtc2xoKzJHS2JO?=
 =?utf-8?B?NldZSVh2MFFSdGRnbVRLL3prdkVGc01RTi9yM3hkcHdRcmE4WmlBbTVsRXF1?=
 =?utf-8?B?RGJIREF3d0hEWndJeHdDM3dwQUw4UENDU0paRUpOR2t3N0lJam85aUtmYjNH?=
 =?utf-8?B?ODZhNHE1QVlsRFpHdkpFUFRXN2h6aFRSU3E5L0pzVHE2Q3R3ZmVNbkRYbllK?=
 =?utf-8?B?QlcyWDRaa0IzS1FTR25oRnNrU1ByL1ZFQThKc0hoK0ZOZGNvZEovTEFUTkZn?=
 =?utf-8?B?b1FaclBDRXExMzNueXl0Q3ZsOE8yTWx0YjJ0VXJIc2dIV1ZQcUpwNVpxTExX?=
 =?utf-8?B?d2UwU3VYN3NCa3NpUm9ZK2FQeEhuaG9oVDRiV0NjY1ZmcGlJTVhPZzl2U1lL?=
 =?utf-8?B?MWFvUmlMd2Y5U1NEY01sc2dIK09Tam9qV3NvdlNUSFVLeTJoMk5hRC9oaFF6?=
 =?utf-8?B?U2ZaeElheHVzKzlyRzlEaEt5VUNGbjA2ejgwZzIvaUU1SzBpeTNOamJjT2tZ?=
 =?utf-8?B?em4xZ2cvZmhHOGYzQ3RycUh6NFMwRVhSRDgwM1lCZlZSOVVjRzhiZDZHZjYv?=
 =?utf-8?B?V0ozQ2N4eFB2VVczNDdZT0xiWnN0R3cxT21aSE1MK3BaaWhRbWMrQjlzQXVa?=
 =?utf-8?B?S3QvRUNqL0NFSFJrMElLY3NZMkJFVkowZ3pPZDRQOGF1bHBWRVMwZGh6UHNJ?=
 =?utf-8?B?ay9OdStJMVlLaXQ1dS9PT1BxOS9MeGJmeWJXNTZaQjdDNlB3RklwRjNFWWJY?=
 =?utf-8?Q?kxFPCkBFVn9YbAjXRojHeUwy/xJCRLLC?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH8PR11MB8107.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?MzFUclJyeTFXWjJIT25NaVhNU1VwT2V5TVlNRkVteGNGeXNFMHNiMVJQNFFT?=
 =?utf-8?B?bTRQM0I4K1BKdmgxQXRrT0Z0ak9YMTlDUlBYVVJKR1prMncrOTRoMkk5RXFY?=
 =?utf-8?B?Nk0yMGVMMDdTSTRseVJldC9saGVOdFJpN3pOcnkzTGRVNFcyZDZOb2s4Z1VD?=
 =?utf-8?B?VmVwTE9uWVUySDhpZ0VaZGhnZnRqcFRXSmJZYzExdmgwcTZNKy9Ic1BUa1Bv?=
 =?utf-8?B?dmZiTlpRcXZOVExPMnFMVGdpc3hMbzJxR3UzWFRjL2Q0U1lwRjAycjZKN3Bw?=
 =?utf-8?B?NVBvNFdqUXR0aDB6ckNmaU85c0hCeGhDOUtOYkxuUXV0Sk9YNGVBQTczemdX?=
 =?utf-8?B?c1lId2FUTUJlakFMZW9YR04rM1U5aDlic2dpR0ExbjFCT3A3SG9tWWN4bUxU?=
 =?utf-8?B?a2VFREkzbmhkSzE2MDhPeCthTFR0bHNvRElRUVZieThSWEtwNXQ0MkI3Wi9G?=
 =?utf-8?B?ajlCeU5vYkRRdi9hNU1USHp6bmpHNiszRDJ5MGR5NnFlL2YvdUpuRXRkUGZo?=
 =?utf-8?B?a2dJR3k2ZHVYY0RvdlFqeks4czNScnU4blR4b010R0QyMWdCMk1uNWNSTTlT?=
 =?utf-8?B?Z1Zzd244cGdtTFFscXczSU1XZFNheVRyNThMUHVnVDZ2UlhETFJYUm9IZFJD?=
 =?utf-8?B?aElGODRMSnVENzlRSmZaM1NyUDhQWkhUZ3lUZUxPMXZWZnBhcHJjNjRKZE1E?=
 =?utf-8?B?T3lxVmlHRGpPbzNqSlZzNFUyK0FNcEhaZTAySlJmN0xlRXA3eEVSblE2b3Nj?=
 =?utf-8?B?MkVqZFZFZDRHcWxHVlRxZWhPY2ZScVBuck9ZYlAvdVFkckh3bXhvdkRQV295?=
 =?utf-8?B?OG90TmlRb2lqaE45QUE2dUdpbTBKODhlTFI3VlJESHpzamZKNHRkRFkzaVBt?=
 =?utf-8?B?TGFKeUR2YjRuWWs2RUk2aDJkWmpiMEFIeUFodG40SWVLMTAyT2E0dU85R1Na?=
 =?utf-8?B?TlNVT200SldrOUc5d0NWVXF5cE80bDFUZmtOcTh5RHZWOXlMQnJKREcrMlo2?=
 =?utf-8?B?ZFprQjNuVHYzZFEyV0taWVpLU2NDNWRVc3lva0dnaC95dmdIWElEbklYeUJE?=
 =?utf-8?B?MmdUNHp2OUVOWk02YUtHZTJWbG1CR2FETzBYSWFjcnBEWEFzK2lRY29XeFJC?=
 =?utf-8?B?SU1TdWg3eFF2RnRpVjJ2UkRTMENXSEJmejF0dDV3a1kyRlNCbHZJblRBZFpp?=
 =?utf-8?B?dHdmNHpwb0hDNS8wQkxuNjhZclVVR3N1R0syYnM0eFM1VXZmUnYrOUIwYWxE?=
 =?utf-8?B?VXp2L0JhNFA5eGRBaEEwOHJSRGlzc00xRnV4aTVrNzNYUG93dFlETmRXaTU4?=
 =?utf-8?B?NjRlaTRDVjBLaW9XNEJhb2oyRHBKbDhsRE5QWkZleUxBODJEZHliTGZKN25Q?=
 =?utf-8?B?L0YvZTh5VzkxUEsxNmZBVHhiWlBLWnVXT042YjZKMjloVTk0NFRMY1F1ZHNa?=
 =?utf-8?B?RXNwRDFJYkp5WDRkRENYR2MxaktnYXFuM2dEYmlQTTlISEJveFJscmNQS2F4?=
 =?utf-8?B?a3N2OXlFSVROQ3UxaFhHd0hyNHBlUURGVTZOdmtFMUF6ZTBMSFB2TXlLanFJ?=
 =?utf-8?B?czFuRk1JU0toZmcrZS91VEJQeFZaZzBWZEFhVmRVOVZKSEVnZTUvQzZWQ0Ra?=
 =?utf-8?B?ejFoUHhackhWRXErQ0svN3NOc0lndEFick02NGRVNmtmMUdMYi8ySnZybC8w?=
 =?utf-8?B?YlBMZVlHbjFMVldwejFaVkphTkh6Wmw2S3UySnh6WVpyYjM2dWlXemE5R2JR?=
 =?utf-8?B?NURCbWdDSm96ejNyb3BYVzUrdGRPaTFYeVNkVC9EM293dk9YZlA0ekxCdG9O?=
 =?utf-8?B?alRaTUhPR2FvQW16RDZ5UVZDblNlb1M2YnBBWko0ZGpNbXZnV040OURKR1Q2?=
 =?utf-8?B?TC91VTI3QVhqZ3UrK2NvN3JqSjY5WnlQZ0szTm9ya3RIbmZocEN0bEE0QzZS?=
 =?utf-8?B?RHc3UHRnR0I3bFhzOHJhQVh2TFJSNE12NnBWbGNrY1dRUWl5NUJXQmZsNFNJ?=
 =?utf-8?B?cXZQTDlJcUdxUzJmSGdHSVZ5NWpLakJEb1I4NDFLYXFjVVkrS1FKWnFoTEhM?=
 =?utf-8?B?SnlsczBSbFZXT25icTZrempYb1JGNWJlalh6QnVva1dlZi9oMFI2ckVkaXZ1?=
 =?utf-8?B?T0FhaGFyYkplcEJIaGk0dWlPQzBZbExEbkp0VmJBY1VITWlYMFJkYWwyQkVL?=
 =?utf-8?B?Rnc9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: ab0b1dca-cdef-4e23-4247-08de37bf8c99
X-MS-Exchange-CrossTenant-AuthSource: PH8PR11MB8107.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Dec 2025 07:41:37.1928
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: oqiTdJyTd5lJHnmCQQYxgjVqSnN+zORYe0otAb8KqEcQV10Jpb1dNKTAseUrxmXZozyKVoVD7OXunXgH86p9X10CiLhJDQPXU5pgmB5kFkk=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR11MB8325
X-OriginatorOrg: intel.com

Sean Christopherson wrote:
> On Sat, Dec 06, 2025, dan.j.williams@intel.com wrote:
> > Sean Christopherson wrote:
> > > @@ -694,9 +696,6 @@ static void drop_user_return_notifiers(void)
> > >  		kvm_on_user_return(&msrs->urn);
> > >  }
> > >  
> > > -__visible bool kvm_rebooting;
> > > -EXPORT_SYMBOL_FOR_KVM_INTERNAL(kvm_rebooting);
> > 
> > ...a short stay for this symbol in kvm/x86.c? It raises my curiosity why
> > patch1 is separate.
> 
> Because it affects non-x86 architectures.  It should be a complete nop, but I
> wanted to isolate what I could.

Ok.

[..]
> > > +static cpu_emergency_virt_cb __rcu *kvm_emergency_callback;
> > 
> > Hmm, why kvm_ and not virt_?
> 
> I was trying to capture that this callback can _only_ be used by KVM, because
> KVM is the only in-tree hypervisor.  That's also why the exports are only for
> KVM (and will use EXPORT_SYMBOL_FOR_KVM() when I post the next version).

Oh, true, that makes sense.

> > [..]
> > > +#if IS_ENABLED(CONFIG_KVM_INTEL)
> > > +static DEFINE_PER_CPU(struct vmcs *, root_vmcs);
> > 
> > Perhaps introduce a CONFIG_INTEL_VMX for this? For example, KVM need not
> > be enabled if all one wants to do is use TDX to setup PCIe Link
> > Encryption. ...or were you expecting?
> > 
> > #if IS_ENABLED(CONFIG_KVM_INTEL) || IS_ENABLED(...<other VMX users>...)
> 
> I don't think we need anything at this time.  INTEL_TDX_HOST depends on KVM_INTEL,
> and so without a user that needs VMXON without KVM_INTEL, I think we're good as-is.
> 
>  config INTEL_TDX_HOST
> 	bool "Intel Trust Domain Extensions (TDX) host support"
> 	depends on CPU_SUP_INTEL
> 	depends on X86_64
> 	depends on KVM_INTEL

...but INTEL_TDX_HOST, it turns out, does not have any functional
dependencies on KVM_INTEL. At least, not since I last checked. Yes, it
would be silly and result in dead code today to do a build with:

CONFIG_INTEL_TDX_HOST=y
CONFIG_KVM_INTEL=n

However, when the TDX Connect support arrives you could have:

CONFIG_INTEL_TDX_HOST=y
CONFIG_KVM_INTEL=n
CONFIG_TDX_HOST_SERVICES=y

Where "TDX Host Services" is a driver for PCIe Link Encryption and TDX
Module update. Whether such configuration freedom has any practical
value is a separate question.

I am ok if the answer is, "wait until someone shows up who really wants
PCIe Link Encryption without KVM".

