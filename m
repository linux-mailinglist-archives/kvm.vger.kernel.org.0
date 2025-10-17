Return-Path: <kvm+bounces-60296-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 4B791BE8197
	for <lists+kvm@lfdr.de>; Fri, 17 Oct 2025 12:41:27 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 0ABF419A0003
	for <lists+kvm@lfdr.de>; Fri, 17 Oct 2025 10:41:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C06E83128D3;
	Fri, 17 Oct 2025 10:41:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="H1fyA4Su"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.8])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2B63D366;
	Fri, 17 Oct 2025 10:41:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.8
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760697669; cv=fail; b=jFTtjX17dLeAagWlu2ziyXNTnMu8iehUJvIFxGDTh1lWlIKiLTUsEsBcqufTQO65FmMzvICGfZ8U7YF7Nq+ySU1sXOaT1/pMifDtSFLZUOHo+M/jv3IrX3O5Ueze8NwOGIXdkuIagkyPklN7JZLGkDQyg/eLmIN9EW4Sv7Yb1xM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760697669; c=relaxed/simple;
	bh=UIYZb2sjSiYn5XjesCaqhZNX9D0Gzd1d4+XwslnwSkI=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=l8kKwpPKB/07tbT1ImdrjvP8HoXOwIr0cLR7csz0xIaYQ27gLqIJZCVKGfvtvUUn9VK6MIgvJF+nGHYy/wfyO61dO7SQJiLUgVnHYrdC82FJY0/sIllw9Y/qwFR84NGYA1ZTEFtPCT4Cyf7TR2qJCYjUZ4tnsapALC7S1DouyUo=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=H1fyA4Su; arc=fail smtp.client-ip=192.198.163.8
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1760697664; x=1792233664;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=UIYZb2sjSiYn5XjesCaqhZNX9D0Gzd1d4+XwslnwSkI=;
  b=H1fyA4SumqmbCIL+RjQJyz3SXb4f+M0X6LCVOl1As1bjY87rdmZffKt1
   TWOlxQnFtn3F+zdrZe+zybNez24rw3yLm/+Bo9osXFiDvZn6z9YVUgUu8
   lohG9yeKds/H3FYCPG6KwFtqXk+/XWNf/Hedm9vrvb/zoigOA4E6TkBKd
   7DQnc7B9JS1cTskUDwqIaum4nPuyRjChwp51yNC4mh37zTqJI2H41sIgf
   Qqkt0MY6DNfyapda850Yz4v8B6L9DKDRJ0sqPSbBfi0vyQN7BewXLNpSx
   lveT5nE7mVO3Ivb1NI/HvtniRbWFkAV6QLqyWyRh8aslyjXRq+ijfsA0a
   Q==;
X-CSE-ConnectionGUID: gO/uyuoaSdC8lE9dCV9tqw==
X-CSE-MsgGUID: PXkC5tSpTPqIX4L9FvUn5g==
X-IronPort-AV: E=McAfee;i="6800,10657,11584"; a="80537623"
X-IronPort-AV: E=Sophos;i="6.19,236,1754982000"; 
   d="scan'208";a="80537623"
Received: from fmviesa005.fm.intel.com ([10.60.135.145])
  by fmvoesa102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Oct 2025 03:41:03 -0700
X-CSE-ConnectionGUID: xaJmr5xhSr27ftT5oyi4gQ==
X-CSE-MsgGUID: VYgsJEahQaO+Z2spwmdI/Q==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.19,236,1754982000"; 
   d="scan'208";a="187101880"
Received: from orsmsx902.amr.corp.intel.com ([10.22.229.24])
  by fmviesa005.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Oct 2025 03:41:03 -0700
Received: from ORSMSX903.amr.corp.intel.com (10.22.229.25) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Fri, 17 Oct 2025 03:41:02 -0700
Received: from ORSEDG902.ED.cps.intel.com (10.7.248.12) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27 via Frontend Transport; Fri, 17 Oct 2025 03:41:02 -0700
Received: from PH7PR06CU001.outbound.protection.outlook.com (52.101.201.67) by
 edgegateway.intel.com (134.134.137.112) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Fri, 17 Oct 2025 03:41:02 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=d0l94UoqI8wD3Q8VTXQodfj1PsIBBkQjH0R1bsQy22zHEZe4DNVrP3Lj/AUNDI6hSZbMdz05uONXhJAmUnzR5KzSiTAReDML52tAL6hEpTf48/pjK5VJA3aMIw6HnLRwO7+rQR3UaOSqRgoir2TUhosfY8VR+JIEapvxsA8niuwFr/cF6SnA4KzqXsbm5T7VC52hThhhbZnf7BvEeFMKpiUNXaTcpVNzLC+PQb9A4KkLarEqfMekjHzSygRZ//QZ/yoSoZcBPOwknLVbVjyyxW9thPmsFP3v4ZoaIUtFOvv9LiXSvWsGA4HqddNLVhzhnnJI2bHvQpf3KEXmZ3LcHA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=UIYZb2sjSiYn5XjesCaqhZNX9D0Gzd1d4+XwslnwSkI=;
 b=BPZg6t5GWF4HRPLoYN7G/98yEzgybLwuns9SpXP04rb0ByGcQ+PeOI6csIqSH8b8U4Ldpyxc2WDQxi15PnXX9LExdHW2RCBvAMoGtyr07xrulO0q3YMwuBsJEPseZWwy2zhh6TD5l9KFr/oiJ6CvdHOKG+HCROuRvqbKmbGENLn7djb++rmRTjJTk1J1XG1rdzukNXfi62LCz8GXp7Zo00nsgJOe91UnDj7LizK6inW7Z4TCnrANQ9FLvbcRYTwaVkKC1nuFkt7T6drpGXFvnuQMyd8OfU9LyqNQjZ42x1SgWSqsgVoSxn68+6TC7ZU5MQ7gf5/JLU8rC7++Ppsayg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5525.namprd11.prod.outlook.com (2603:10b6:208:31f::10)
 by IA0PR11MB7694.namprd11.prod.outlook.com (2603:10b6:208:409::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9228.11; Fri, 17 Oct
 2025 10:40:51 +0000
Received: from BL1PR11MB5525.namprd11.prod.outlook.com
 ([fe80::1a2f:c489:24a5:da66]) by BL1PR11MB5525.namprd11.prod.outlook.com
 ([fe80::1a2f:c489:24a5:da66%6]) with mapi id 15.20.9228.011; Fri, 17 Oct 2025
 10:40:50 +0000
From: "Huang, Kai" <kai.huang@intel.com>
To: "pbonzini@redhat.com" <pbonzini@redhat.com>, "seanjc@google.com"
	<seanjc@google.com>
CC: "Li, Xiaoyao" <xiaoyao.li@intel.com>, "kvm@vger.kernel.org"
	<kvm@vger.kernel.org>, "Williams, Dan J" <dan.j.williams@intel.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "Edgecombe,
 Rick P" <rick.p.edgecombe@intel.com>, "binbin.wu@linux.intel.com"
	<binbin.wu@linux.intel.com>
Subject: Re: [PATCH v2 2/2] KVM: TDX: WARN if a SEAMCALL VM-Exit makes its way
 out to KVM
Thread-Topic: [PATCH v2 2/2] KVM: TDX: WARN if a SEAMCALL VM-Exit makes its
 way out to KVM
Thread-Index: AQHcPsnJasRrDnCPH0SaPtwK/HwoHLTGJ2uA
Date: Fri, 17 Oct 2025 10:40:50 +0000
Message-ID: <46eb76240a29cb81b6a8aa41016466810abef559.camel@intel.com>
References: <20251016182148.69085-1-seanjc@google.com>
	 <20251016182148.69085-3-seanjc@google.com>
In-Reply-To: <20251016182148.69085-3-seanjc@google.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.56.2 (3.56.2-2.fc42) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR11MB5525:EE_|IA0PR11MB7694:EE_
x-ms-office365-filtering-correlation-id: 3fef1b66-2633-45c9-99dc-08de0d69a41b
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|1800799024|376014|366016|38070700021;
x-microsoft-antispam-message-info: =?utf-8?B?ampWRzVqZ051Ui83b1Vwb1Fib3pDODNmRVFTQmZSRzlNaG5TYmdXdmZQRERr?=
 =?utf-8?B?NmtGb1VyeC8zMVZ0UUNvRFhDZHV0NU9wcTVFemkyZHJMRUE0ZkdkQk5wOXoz?=
 =?utf-8?B?dE5Cb0ZKRlh3aDNXdWhUZE1yS2VxUFpIZmNPbVZmeURCeGl6YnIzeXIrZ0FU?=
 =?utf-8?B?SEdHM0w4ZUZyQlZVN01Rb294VG53VXVlTDlpWG5XMmoyMytxYzY3RERJcUhy?=
 =?utf-8?B?aFZWdm1jVk4raXpTMnFGakFZUm93WTZVTXhrRmRvczEzNUJxNEFQN1Y4MS9O?=
 =?utf-8?B?YmJMQnhLemUreWN1SVErd0M3OE85QTQ4NlExNGpyQThLclpMZDBWNkU3Tk9D?=
 =?utf-8?B?NXBlaU04ai8vdDdlZ09FNXZUSG91djJlWUlGUzQ2OGZOQTh3ZWs2MFE2Wm1E?=
 =?utf-8?B?eldqaGlSa0kvSVN3ZDdZTVhVbmVOYityNGpKMnZ0MlJlSVl3Ykp6bzM3aHRG?=
 =?utf-8?B?Rjh4UWJQYVVMQ0d0NFRnM0xEOFZ2dTRDSXNxVEMyRzBjTkF6NCtqcXpESDBJ?=
 =?utf-8?B?ek5iaDhDMkljMTMxVjVRWWpYNE56MVBCYmZ2bUNSb2E2VTBVZmlPR09zdWpi?=
 =?utf-8?B?MWJoajc0RVJJcXhSbzAzeWNNalF0L05sSmlIK3BwdElZd0FBUlBnNjZUeVZY?=
 =?utf-8?B?TS9iblEwRFJZLzF3VVlyY3lGZEJBb0txWmJUNXhvTFdIT015Vkhzc3REL0RC?=
 =?utf-8?B?OWllZ2loTzREM001aTVHTm5aclpwVEZXaUZSSXowOTNsa0oycmZwT0hjTjc3?=
 =?utf-8?B?RmZMMnlRQ0NPblEzTjNVYWVPVm1iUm9LS2QyZ1htN2k1OGREYXJzczVLWnBy?=
 =?utf-8?B?UUhucXNoaVhDM1ZaZXRPWG1uWW9aNjhjZkhBR1h1WFVTMWVjNVBmUy85Mkly?=
 =?utf-8?B?cUo2SmNyeWRwMjZIZjZJYURmd2RZbHRDcjBRekFkTlN4ckVyNDYzQW5mWWZt?=
 =?utf-8?B?SVNPK2NKczNONFY0WkRvMFVEV0xFZkRTQmxCWHl2STdla2wyOVNPanN3QndQ?=
 =?utf-8?B?aUlRY2g2R2ZhMmlQSGNtcmF5V05FLzBkdEJPZjlsMERzQWNlQW5yelROTUow?=
 =?utf-8?B?U1JUUW8zbmhteVpGZXBnSysvQTBHaXZCZGZ4azRSdkVmWjlGZ2grNGVtSjBS?=
 =?utf-8?B?SXRDVFBUUzFndTF3Nmlrd1FZS0FSbUJwMXVxa20xUi9yTFlmR0tMR2Rvb3lZ?=
 =?utf-8?B?d01EOElQbFVVUkVJcGs5OWxiVldCdVNQcWEwMi9WOUxma0xjLzVReWQ4MmRZ?=
 =?utf-8?B?K0tiTElLVDdyQVFqNU5tUFNEOWw0V1AvdnhhM0J4QjNLZlBqaVcrdWdFdkJ4?=
 =?utf-8?B?cndWL1JNTFA5andOMDFNRm94cW5tbEJLK3ROemMra0FaRTQvYmhmZEpva1Ix?=
 =?utf-8?B?MzU1Qk8yZTdlclB3cFp5UElKRlBwTlgzWHlxUWVrRkZxUFh3SHFmSUJ1T0xk?=
 =?utf-8?B?SnR0NjBvMUpQaVh2ZjlnaTVEQlVDallJVEYzM1hPTVlDNGxaKzBqK1BpUEN6?=
 =?utf-8?B?TkVEeXk5TVh1ZTllTndQajA3dDNGL2dvMk9GV0o0YkZLMmNGaFBLUER0TU1D?=
 =?utf-8?B?dEJETDBkTWJaNnNEZ0hLNVBsUmRZS1Q4UlcvUTF6Uk5yQ2NMMTRjMlVIV1hv?=
 =?utf-8?B?WDlocEF2OUJkVjI2Vk95Mzhpczl6QTJpYzFwT0Vjbm5RR1FKdlJVZ3E3NjJY?=
 =?utf-8?B?WE95c25SajRQbHAvYTlESC9zVnJZSG9DVWx3ZStmOEtqQ0tIUERpbTVlQTRH?=
 =?utf-8?B?enVVZHQ4aDhtN1MreUpvT21FRDNyaTZEUVA0b3NRUE9QQllWR3Fkc2dGclF4?=
 =?utf-8?B?VnlKSFBVQldMMUN6OFEzam96czNNS2xjQlhsYzNUVUhBdENsYU9pS3BudXVr?=
 =?utf-8?B?dlFaMTFkbHRNTlhVL3ZIR20rQTlPMWNSNTU2dnJCZFdaeS9Ld0JRTGtINlFR?=
 =?utf-8?B?QmV0RVRQMGRwV01tK0RJdlQzMG5PTC8zNThWdnZCWnRNajNySFBnSEt5UDEw?=
 =?utf-8?B?aHZzSVlCQjhWUDA3Mm51bjE3bi9kaXUzYkE1VTNPUTArMy8wOUtrWVlUa3Bu?=
 =?utf-8?Q?jtug8s?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5525.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016)(38070700021);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?dmJLeWQvSGdEMXBSTDVxQU1Dd2Q4dWFzeU5kdUZ0SmQ3cTZhYnlJejl3TURU?=
 =?utf-8?B?QkZSSVdCVHNaL2lwTkFteGpOMHIxVklXQzFadzRObDBNcFJSUUJnbnZwTHk1?=
 =?utf-8?B?MnZxamJzY2Z0czNYVng3U0dOS1kzVTA4R3NzeW9hb01UM0ZHSjRuZ1N5UFJy?=
 =?utf-8?B?b0lDMzg1ekFLNjZpU2NEbUJTQmdCSnh2UjZwUW4yVWVLRE5Wc1ZtUC93VGxG?=
 =?utf-8?B?bjllQmlTL3ZNeXZmeWg3UFp1VnIxUTIzSzNwcEcvR3hJYmgrU2tGay9BMmZi?=
 =?utf-8?B?TUo4STFKVnRZU2w0c2kvMzhNcVdmb3FSSGpzLzYrdzk3b0d3cFNVUkhJdlJB?=
 =?utf-8?B?Y0hLUmtxTWFJTGJRRVF6N2QvUStTWStSSm5BNTFUVWhHWUxBS1orVFJ3RFRh?=
 =?utf-8?B?Y25oWWVxU25tKzhDemRlSXhqb3lQKzJWaVp0WExydmx2RUlSbW5JaDV2eXh1?=
 =?utf-8?B?d2E4ai9id0p5ZGg1YWZYbm1OSlUrcEE0VDRLWld2QTMydEdDL3gybS9GeEUv?=
 =?utf-8?B?NUlvbEt4N0N2elRTRXBoR2pZSWdVZDVzTG14bGRFVWthSTl2aEt2WnJpRmJ4?=
 =?utf-8?B?Sld4Znc1SG5TWDgvMGExcE15d2dTM3hDUlhreWkvbFlobWlpVzVKdWJucFVp?=
 =?utf-8?B?UE1vMWRlR1RDdWdvbWZhUDg4VU9sUTdoSkduVEJSa0hXK1pQRXBpUlBtbHNS?=
 =?utf-8?B?M2lnQVBacW9Xa3VPVVNPcEg5NXlna2RabEs2Z2JNclZBVnYrbHgxeXdCZFpv?=
 =?utf-8?B?QkJUMmVPMWVPK2pPNWtyMHdxT2hlNWNQWWlxV0phZmRMbHpva2FaaUZ4UEtU?=
 =?utf-8?B?MnFRNTNVMkduL2hlOXU4TFpqS2lnaEgzenFjcDJWVHlnUXhkbUd5T3hSdFRL?=
 =?utf-8?B?OWNLSjVXRlBLa0VldGd5dkcxNmM5UjVySEluSzk4Zlg5R2hPVzJJc0xZUVVi?=
 =?utf-8?B?U1g3eVJMZUdBSlo5Nm1IMjJBUE9QUXcyc3l6Nm1WNHRWd2trY2ptNXlXYzVm?=
 =?utf-8?B?Y1RBWm1DNEs1eUxBOFZSU0V1bjQ3OGVyLzFkOENPUTdZYzRVRTJhdDNmbXV6?=
 =?utf-8?B?eHJZSk9RWklHTnpqekhhMEVBZEdRM3V6R2RtLzE0eVRjL0lYS3I2YkRBZE1v?=
 =?utf-8?B?NVJZbktHbk05VVNPU2xlUUFSTXcvZi92YUhtS3pwZnhENGQyb3FzdHAxcy9p?=
 =?utf-8?B?N3haM09WTTQzWmRtT2wvT084b3U5WnUwOTU4ZXptTnUvZFdoWkdDcVJLdEFY?=
 =?utf-8?B?Z0pjQlZTTS96MHhnNGhmVnptdEpaa3VRblMydDdSU3ZvUUJUVndzaTIwNVVG?=
 =?utf-8?B?MWV5bWxBT3crVXp3T2Y5Ym1telVmcmNzNlpHMWQxa016Z0VrZnFRd05tUnUy?=
 =?utf-8?B?ajZTdFhnQXYwSFJiSk9YNHZEUWlFeDBRemQxS3hLUjVXbHEvU1J6eGtoQ0hj?=
 =?utf-8?B?V0JuVkM3Z3dIWXZ4MmJmVk92MXdmZER3eHdUWVBEU2lucG0vNzl2bCtkK0Ro?=
 =?utf-8?B?bUpaUFhxNHZDbExpZXpLazNZVFJXTDRieS8raVlwb2gzQkVWMGFuL0FZQXZ2?=
 =?utf-8?B?emZaMnI5bmNza3lPUldHM0RXT0JUdDNkWS96TXlzNnhrZlU4V2FWeEgvZDV6?=
 =?utf-8?B?UGJFelE4TGhkNVQyWmMrcEVEVG9qSnVDcXVjREphYjV3OTVGREJKdjRja3Ev?=
 =?utf-8?B?OSt1Q2NheHN5U1BGT2tJQStqNlQxb2U5SFZnUVhzTGRvaGNDL3FZWnBpR20z?=
 =?utf-8?B?WjhrUVpESmpPeFMxUEpRMVhXUzR3MEtxUm9QRnlVTW5hWFJ4bVBBREJINktQ?=
 =?utf-8?B?V3VhSG5lU3ZXQkVNTlpyTStpZ0NkWm9mQjkrZUJIeE02cThxODNzdW14NUhi?=
 =?utf-8?B?QXV5SXc2aVhiWVgzdGsxd0xBVWlxdzhtSnYrV1QzNzNrMjNBcWovUlgyOUVr?=
 =?utf-8?B?RXlvTGNZbC9DNmtrT3pnODczcjdmRVBwUlh6dlBuaWgvbVhlTFR6bE1sbzYy?=
 =?utf-8?B?RmwrTmRDbnRGR3BpWHlLbHB5V3R6VHhDSzh6RkZ6TE9zRVc3ZCs2M2lyeGVo?=
 =?utf-8?B?WGJPbE15bW5HTE9iVS8xWFJoWFVaMXljc3lsckcvNGUvL3R1Zm50UnAzblha?=
 =?utf-8?Q?wQjwMQm2Hy3+qlGIKVR0tUbAQ?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <BC80D701E55E7340988B7B518746177C@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5525.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3fef1b66-2633-45c9-99dc-08de0d69a41b
X-MS-Exchange-CrossTenant-originalarrivaltime: 17 Oct 2025 10:40:50.8970
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: UjF0ZTVfchSliXrnhAF8RDYlltvwIOkH27KRhrCSyhgANQCo7SGc4cJsb66cS9ZPYFZMgRbuecECY1KdcF0Oow==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA0PR11MB7694
X-OriginatorOrg: intel.com

T24gVGh1LCAyMDI1LTEwLTE2IGF0IDExOjIxIC0wNzAwLCBTZWFuIENocmlzdG9waGVyc29uIHdy
b3RlOg0KPiBXQVJOIGlmIEtWTSBvYnNlcnZlcyBhIFNFQU1DQUxMIFZNLUV4aXQgd2hpbGUgcnVu
bmluZyBhIFREIGd1ZXN0LCBhcyB0aGUNCj4gVERYLU1vZHVsZSBpcyBzdXBwb3NlZCB0byBpbmpl
Y3QgYSAjVUQsIHBlciB0aGUgIlVuY29uZGl0aW9uYWxseSBCbG9ja2VkDQo+IEluc3RydWN0aW9u
cyIgc2VjdGlvbiBvZiB0aGUgVERYLU1vZHVsZSBiYXNlIHNwZWNpZmljYXRpb24uDQo+IA0KPiBS
ZXBvcnRlZC1ieTogWGlhb3lhbyBMaSA8eGlhb3lhby5saUBpbnRlbC5jb20+DQo+IFNpZ25lZC1v
ZmYtYnk6IFNlYW4gQ2hyaXN0b3BoZXJzb24gPHNlYW5qY0Bnb29nbGUuY29tPg0KPiAtLS0NCj4g
IGFyY2gveDg2L2t2bS92bXgvdGR4LmMgfCAzICsrKw0KPiAgMSBmaWxlIGNoYW5nZWQsIDMgaW5z
ZXJ0aW9ucygrKQ0KPiANCj4gZGlmZiAtLWdpdCBhL2FyY2gveDg2L2t2bS92bXgvdGR4LmMgYi9h
cmNoL3g4Ni9rdm0vdm14L3RkeC5jDQo+IGluZGV4IDA5NzMwNGJmMWUxZC4uZmZjZmU5NWYyMjRm
IDEwMDY0NA0KPiAtLS0gYS9hcmNoL3g4Ni9rdm0vdm14L3RkeC5jDQo+ICsrKyBiL2FyY2gveDg2
L2t2bS92bXgvdGR4LmMNCj4gQEAgLTIxNDgsNiArMjE0OCw5IEBAIGludCB0ZHhfaGFuZGxlX2V4
aXQoc3RydWN0IGt2bV92Y3B1ICp2Y3B1LCBmYXN0cGF0aF90IGZhc3RwYXRoKQ0KPiAgCQkgKiAt
IElmIGl0J3Mgbm90IGFuIE1TTUksIG5vIG5lZWQgdG8gZG8gYW55dGhpbmcgaGVyZS4NCj4gIAkJ
ICovDQo+ICAJCXJldHVybiAxOw0KPiArCWNhc2UgRVhJVF9SRUFTT05fU0VBTUNBTEw6DQo+ICsJ
CVdBUk5fT05fT05DRSgxKTsNCj4gKwkJYnJlYWs7DQo+IA0KDQpXaGlsZSB0aGlzIGV4aXQgc2hv
dWxkIG5ldmVyIGhhcHBlbiBmcm9tIGEgVERYIGd1ZXN0LCBJIGFtIHdvbmRlcmluZyB3aHkNCndl
IG5lZWQgdG8gZXhwbGljaXRseSBoYW5kbGUgdGhlIFNFQU1DQUxMPyAgRS5nLiwgcGVyICJVbmNv
bmRpdGlvbmFsbHkNCkJsb2NrZWQgSW5zdHJ1Y3Rpb25zIiBFTkNMUy9FTkNMViBhcmUgYWxzbyBs
aXN0ZWQsIHRoZXJlZm9yZQ0KRVhJVF9SRUFTT05fRUxDTFMvRU5DTFYgc2hvdWxkIG5ldmVyIGNv
bWUgZnJvbSBhIFREWCBndWVzdCBlaXRoZXIuDQo=

