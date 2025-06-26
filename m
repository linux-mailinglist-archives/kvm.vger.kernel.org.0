Return-Path: <kvm+bounces-50879-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id E6BB1AEA760
	for <lists+kvm@lfdr.de>; Thu, 26 Jun 2025 21:53:01 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 8C1767A979E
	for <lists+kvm@lfdr.de>; Thu, 26 Jun 2025 19:51:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A1EFE2EFD91;
	Thu, 26 Jun 2025 19:52:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="LLS2RHwj"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1E2411552FA;
	Thu, 26 Jun 2025 19:52:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.9
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750967568; cv=fail; b=Rokz4pI7AJAUZrhP/UufTSGvaY1kwIUGvR77Ih0oyOOrXRmdHHGw3B/67354PKGFrQzTQReJ5Qe6wiL+9pLjm8EQbAfIGt+aalwXYikiWsWuqnrKBb0uFIhvDVKZdnECu4IZzO5DydX4P5faMiJBM13K+gFH4186eQ1+da8ISc4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750967568; c=relaxed/simple;
	bh=MDwiaKmTob+QNWgzuYY7/ul4Dwi7+6wsf5PQydOaFbA=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=qQavDiMes6gLsXdfc9TQ/0ga6D1fUZVpXvFC7jzgxxjkm7IgklDlm+CBp2ATnxQx7f4tctIw/vRw6eMfos6/kpvNkb0Wdvz0G+ZHThKOnyiG8Obj4LLGFCxKbhuoukHBSx8NmExdkiatLWebO3E1CwyxuVeHVooxrT6kFGkSgXk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=LLS2RHwj; arc=fail smtp.client-ip=192.198.163.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1750967567; x=1782503567;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=MDwiaKmTob+QNWgzuYY7/ul4Dwi7+6wsf5PQydOaFbA=;
  b=LLS2RHwjQbOYYo3u0mVbTWhTV+b//pkPXH+iQRbpqYuWxRaJlum/LBBs
   YDIUltSKqL7ndBgBy9cHIZ742F45ZQuEMUU3l0UxiGiqKKkZhDfLv9I3o
   AN3GYWJuxaRGrx6Q3BvBHE7FMLJzIQo0xy/yCIh2BZe3Q0kq3LEOz4Zgi
   X6SZxQDatIvXVdifuhrAAlhFYVXvJERTiTqdg9mZ5EpsfM57qgeAzlz1/
   oSxtwIyZlgOCdKmBVcF9srA0Fon5sPHvKt+gRILy4DuxXjtdVZmMu3rFq
   lBhC2MT9Us/v09ldee5aqnq4K9g8ZGkcg40kT7yBZapLIRoECS3Y3/qMQ
   Q==;
X-CSE-ConnectionGUID: JUN263PRS/uUNSuw8mBCDw==
X-CSE-MsgGUID: krkK0BtcQfqCzFims6XwXw==
X-IronPort-AV: E=McAfee;i="6800,10657,11476"; a="63964396"
X-IronPort-AV: E=Sophos;i="6.16,268,1744095600"; 
   d="scan'208";a="63964396"
Received: from orviesa006.jf.intel.com ([10.64.159.146])
  by fmvoesa103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Jun 2025 12:52:46 -0700
X-CSE-ConnectionGUID: NlU03bM7T2ixuC+fkmC6CQ==
X-CSE-MsgGUID: ThygiXx+RgeTTJenKa+b8w==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,268,1744095600"; 
   d="scan'208";a="152121549"
Received: from orsmsx903.amr.corp.intel.com ([10.22.229.25])
  by orviesa006.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Jun 2025 12:52:47 -0700
Received: from ORSMSX902.amr.corp.intel.com (10.22.229.24) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Thu, 26 Jun 2025 12:52:45 -0700
Received: from ORSEDG901.ED.cps.intel.com (10.7.248.11) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25 via Frontend Transport; Thu, 26 Jun 2025 12:52:45 -0700
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (40.107.220.41)
 by edgegateway.intel.com (134.134.137.111) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Thu, 26 Jun 2025 12:52:45 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=iV+JljGuxsd1KHqWty2DS0eY2Ctb5s1heWWz8vG6lMk2AuXQ4xQKHkejJjvJwIAHUROmtXZ/7FKwQpsX3sUursjjowsReHsO3h7HXPpd6lCdhuEJAw2VRIhR+X6mAHHrPlHTF4wSSNPUgtUojCqvA0jJ3OpbRXo7T9wvYBYMEHvi3psXTi6SHPHzeZl7bk9motdpYHvrrOPvIQbqZ+/Q763+AvWyUYNZYPphR/Q9CqJQCDgVlRqVvZyExCD533vqNKAYcUs/gJR31T/L/TTgvZvZBteZzAhcqWckBBP++tczSouKYcFjfFQHzsaJkf5GJ6A2cU4f3vCXofdkyZOtgA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Z9B1VJxdUSMni7RyTYGieuaHIkITrmf9FdqfjRTlghU=;
 b=muWIgJpEFBhQK6r3f51vRTXBnv92gvW4RaVReHMUP4ZJRySdH/zqH/GzPUO4AwAdn06Pojc854h9tYtdWPKH4OcLXXZeSLAoAy4b77xho4VjAOfxHaRBZ8wVBO7YD9rj+CwmzQVgFxpXNMLE/wtWooD4SYTlvUNw8tE+6yXEPRfoIEgzY0YH/jbqmTag6ssZPbDKHlRHIZT/XbWR9WwNiIZY+0zs3T6v7USgpjbDAzBYcsUqbpMc7eJYwl0I7cIj7ObjTOmXO9zoIlxcK4bNQ+oNb80s/6dR09sO/MUjkAwyPhOjRNjkYeugAbdRIe03/gBjothhY7zrhMs8i+aZzQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from BN7PR11MB2708.namprd11.prod.outlook.com (2603:10b6:406:a9::11)
 by IA1PR11MB6241.namprd11.prod.outlook.com (2603:10b6:208:3e9::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8857.28; Thu, 26 Jun
 2025 19:52:29 +0000
Received: from BN7PR11MB2708.namprd11.prod.outlook.com
 ([fe80::6790:e12f:b391:837d]) by BN7PR11MB2708.namprd11.prod.outlook.com
 ([fe80::6790:e12f:b391:837d%5]) with mapi id 15.20.8857.026; Thu, 26 Jun 2025
 19:52:29 +0000
Message-ID: <56f1d4fa-1ebe-4ebc-b69e-02ce5c358b89@intel.com>
Date: Thu, 26 Jun 2025 22:52:22 +0300
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH V4 0/1] KVM: TDX: Decrease TDX VM shutdown time
To: Sean Christopherson <seanjc@google.com>
CC: <kvm@vger.kernel.org>, <rick.p.edgecombe@intel.com>,
	<kirill.shutemov@linux.intel.com>, <kai.huang@intel.com>,
	<reinette.chatre@intel.com>, <xiaoyao.li@intel.com>,
	<tony.lindgren@linux.intel.com>, <pbonzini@redhat.com>,
	<binbin.wu@linux.intel.com>, <isaku.yamahata@intel.com>,
	<linux-kernel@vger.kernel.org>, <yan.y.zhao@intel.com>, <chao.gao@intel.com>
References: <20250611095158.19398-1-adrian.hunter@intel.com>
 <175088949072.720373.4112758062004721516.b4-ty@google.com>
 <aF1uNonhK1rQ8ViZ@google.com>
Content-Language: en-US
From: Adrian Hunter <adrian.hunter@intel.com>
Organization: Intel Finland Oy, Registered Address: c/o Alberga Business Park,
 6 krs, Bertel Jungin Aukio 5, 02600 Espoo, Business Identity Code: 0357606 -
 4, Domiciled in Helsinki
In-Reply-To: <aF1uNonhK1rQ8ViZ@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: DB3PR08CA0036.eurprd08.prod.outlook.com (2603:10a6:8::49)
 To BN7PR11MB2708.namprd11.prod.outlook.com (2603:10b6:406:a9::11)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN7PR11MB2708:EE_|IA1PR11MB6241:EE_
X-MS-Office365-Filtering-Correlation-Id: c1540044-cb95-4907-de8e-08ddb4eafb15
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|1800799024|366016;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?QXpCeU1CNWZNRXVYSWxUaEExRUxIUUhNUFphVTlaQlhIQ2U5Y2JsVUU0TXVU?=
 =?utf-8?B?cXpYeDRDcUFLbGFpcXJuSFhtbTlGMEEzVHRTQUxHRXBRYjdpRGc5VVBWdVJT?=
 =?utf-8?B?MXN5QnQyZnRxSlF1czJmNGVYUkk0Q0gyVTludHhVK1YxN2FlazNTVVpUdk1x?=
 =?utf-8?B?MVNXcGVHQnp4MXkvakR1RG9sNTQ0RTdmTEFUOXpyUUhIblFjZGNtTm51K0cv?=
 =?utf-8?B?ZTFJY3JqMkVDRkJmaGJjbnJJS0hrcXNCUVd1cG5Rbk9BNnZaQ3hpQ21Qdlor?=
 =?utf-8?B?cUpXa21DYTlHekxsamxTUG81cEwraUF2SGFIZzBDSmxlMGptNEJybGh0YzRL?=
 =?utf-8?B?c2ZVRVFobS9aYzhVaXNiaEhUUEFRb2UvYUVPVmcwcTJ2cWZUMUMxVDkwUWZG?=
 =?utf-8?B?UTZlMU1JTGlXZzIzQ0ttSmp6VVlZakQ3V1hmOWJQN2dQSXp3ZU9UTysxYWtq?=
 =?utf-8?B?USt0d0NNRzVVM1RETFZ1TGxKeEJIK2UxWTBvN3JsTDdsbU5jL1FCTnZ5ZEVo?=
 =?utf-8?B?ZURidUpIT2syTC92NFJxSzJHOHkvb0tpbDNVRXc5aSt2MmJsYjdXK0xrM2hF?=
 =?utf-8?B?YWI5Kyt6WVc4d3kyS05TdWN0WEtHZ3A2YlV3TGU1cWxnZFR5bnc1dFk2RjZP?=
 =?utf-8?B?VzNHVlgvRWtMQUtWcUJCMks3K1RpM3BXYTZleDR5ZXN2QXFpTHhrYS9KaE9P?=
 =?utf-8?B?TU81VTBIMHB1OE5yOVpGMnVqUkVRTVdrSExvUFFVc01PWUJjcTVLZlpOWnhF?=
 =?utf-8?B?WUVNUUN4TmEwaGxJVzRtRXZtVjNlU09ZZHRDT1h1elRwaTlMOWZ3L3BQRGxN?=
 =?utf-8?B?L0dKa2RuYTcvY2dCZ2dtRmZzN2w1KzNKMTBMNGNSWDlSSHJSZWdHVGkyV2tC?=
 =?utf-8?B?MlkweGRFdExHQ1MwY2o2RnNnQ0ZZTm9UMmg5SHVrUnNXQzBSNkk3RlhBODFz?=
 =?utf-8?B?cnJUNG5BWDIzR0lGRmNSQmY3Wm11RHNiditGLzE0S3hDcy92MWdoUjV2OFlB?=
 =?utf-8?B?Q1ppTy9PaVZiODB5RkNuc3hLdkhkalAyUmZNOU1QcjNWUndyV0xnS05vMTJq?=
 =?utf-8?B?OS9VV0RhelZqbkhjODNoTEl4N1JRVkk3RG5HdmFwUndSRmFyRm9zZHdtNHRR?=
 =?utf-8?B?S2VRdHVHcjdoeEdFNmlSM1FubHlJVFp6bndmaHJST0kwOFI0OFVBWmJpU0hl?=
 =?utf-8?B?VHkzMi9qNTh1bTNIeVd2ZnZ3WC84dHVLYkZQd0RXb2pmQVQ4TDA3R3l3QUgv?=
 =?utf-8?B?cnV4N2xmOTI3a1c4b2h2d3JaV3IvQldNZnJUc3RReEtZUG4ycDc3cDBPVWtH?=
 =?utf-8?B?LzRNTU40YXdNRHNaQW5OTFkzZXFuLy9rTGkwV0JBM2VWYnZ5UDBHOS9HSnlu?=
 =?utf-8?B?Zjc5eXd2cGpMbHdQTDc4QUlkNFhkNkZBTlo5T09YRmYzMmRadHN3N1FyYjg2?=
 =?utf-8?B?cUc0Yy9LZ20yYzMySWRpSlB4Y0Q3ck1FbDc2b2tMaFRiMzZDMDhYdWpTZ29F?=
 =?utf-8?B?UnhrQ1JQNzBJaXZkVXRuRjJManVtUnNQNXo5RVlaOHUrYkZuZWJwbU9kaTBN?=
 =?utf-8?B?KzBtTEVROUMwQlMrRERkWGlnQ3NheWxIY0xleHZHZ1NWVk5qS3ZkQUU1UHFO?=
 =?utf-8?B?elh3YmtNeGZWMHMrdTNhR0pZMjNtVnowYVl3dEhXcG1WMnFNcUx5TGZDZWZs?=
 =?utf-8?B?UUdicklKekV4NU9ZUE9wQ2M0Uzcwd3BNdm5icnZPM3FDU3Q2eFk3dDlLRkta?=
 =?utf-8?B?aDBEK3JqR251QWtwcTV0QnRib0licjhXZzgzcXBDczZvUWFqam5BUEQ2dEFV?=
 =?utf-8?B?TTZBWnNKS2FtYko4d3o1UjhSTEJ5U1Fya2FGWFpvR2NldExYVmF4RE9PbHFo?=
 =?utf-8?B?dzNsVzNEUEZnRVB1TVd3ZGk5K29jUE4rTWhNZnJrSlZ5bWhVbjBRUDdPcDlY?=
 =?utf-8?Q?TtxlHY/sL+w=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN7PR11MB2708.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?Z2ZDWE9HRVdBZUhncWxBRG54bFpwL1ZFSkg3Yyt4TjVFSldYS3Q4NEFydmFE?=
 =?utf-8?B?VlJRWjgyZTFmQkFBNFV4SXJhZmlUblBSYWJKU2VYMC9kTGtaVVVMekcvR3N2?=
 =?utf-8?B?UktrYUZRcWNRekV2dDU3VXIyQXZHWldmdUFhcXB1Rmw2aWpyY1FQODBOTWlH?=
 =?utf-8?B?Y0lnMyt4SGxEVFhYMTB5blNFMnVvN0dVUkZjSkJxVTBnR3JYQXhjY1BLcTl1?=
 =?utf-8?B?bjM4NjRudHJLNzFySHRpb2pxbys2TVMrTVkvZ2NvemNybXlvUEtFcVg0TnQx?=
 =?utf-8?B?aXBWL1krMjJ3T3RQeHowVWpMQnJ5WkdYbnJvbDZ6Szc5K054QXd2TjBESmFC?=
 =?utf-8?B?NXRjTXJGQVhsZDlCYmtmejk3NG1kTlI3TG55bURmS2ZvR2pLWGoreUxvd1hz?=
 =?utf-8?B?RTFJL0cxSTB6ZWUxMTVtYjg5aGtqb05xUmhvb0NMY1lYRmkybTNVL0hYUy82?=
 =?utf-8?B?YlFYS3cya2IrZ0I0WDJRd1BsK1RkbmZldjlnTi9ZK2d4RVZ1TmFtZDhMR21s?=
 =?utf-8?B?dzh5N2NhRnhpVDJndWE2VnQ4Y0h4QkpwTHIyNUVWNU50S0oyUDhiS21rd0ZJ?=
 =?utf-8?B?aklZVElKZjNzQTZVYVFGVjdvZW96RDVQMEI1RWJtUmd3aWdmZ3NzeDNkMEIr?=
 =?utf-8?B?bURDbjA2OHBhZi92WWhISjR1aXhMeUhrTEx6RUNpMnJDek5qeHpnbVdDbVZ2?=
 =?utf-8?B?RjR2NHlSZElqOFhRVDRaSlE4QnlKNGNheXlqZjRoUmF5alR6TWw1Z3dQNVB0?=
 =?utf-8?B?SHR2cXpPa1JXZVFGbm1yNkh2UG1sNE00Ni9RaVhQSHU5bVYyYXIxdWd2WU1y?=
 =?utf-8?B?by9YaUhmdENPeXpramY2M3dzcTBMakFDaDhESUgvdFdsUEw5dkg5MnBqWisw?=
 =?utf-8?B?MkJjRzdRTTBOUk1tUDhDdno5S3plRXVqODhaeU8vN09jQnFmdWgxcGdGUm5T?=
 =?utf-8?B?U2U3Y3BtbmJ0TDhXU2ErdFozcDF6bE1TOS9vb1pzaWRGcTVoWGR3eW0xU1dW?=
 =?utf-8?B?M0RWVzRPenQrcWpmTXhDaFh3ZVJDb0FBbnlBYldGVzJZNkt4bXJEd3VEWXpq?=
 =?utf-8?B?NFdTeTJCVTJFMWpJUXV5UW1DRjB0OVVZMXB5QXF2a01jczVpbmF3MDNnbWhp?=
 =?utf-8?B?RmJTbWwwaWVHVzNBTXBRMXNTRjNsU1ZvM0tVbm9wdDhkb2kzN3FlQkFoVmUz?=
 =?utf-8?B?cWREVjdBQjRudmpOMHF2Y1hQdjBNY0VuNUJmU2hib3FCeXhjVTc1Um0rZDlk?=
 =?utf-8?B?dk9YTXd0MWdWVDUrL0N0MzQzMWJPak1aZktWcTVPT1hQZ3U0clhJZUtIM1VR?=
 =?utf-8?B?SXhTVlkyQm56R2VqaGZEV0J6ai9TcUIxUHQ5QVp0S1U2RWFSVWkyODdrN3RN?=
 =?utf-8?B?Mll0c0M1cXJCWjZRYlB6aUpqV3NiTmRLaWZjbWljRXZBMGh5S1JkODhYNlJr?=
 =?utf-8?B?cC9Ob3BWaURFMmNYdVpZZ2RsaVYzN053Q0NVT3pnbHBCeVFZS3FWem9FN2JD?=
 =?utf-8?B?OFA3Uk9rN0Vpc0VrUk5RTFozbEFFNVFsU1ZPMnkvTGl0RnJqWVZpeFB6aVcz?=
 =?utf-8?B?TkxaSWhGVG1BTHZzcjJEVi8xamNqbXR3MHBvT1kwTE5RZ0RBT3NMekhIREo1?=
 =?utf-8?B?S3RDYTAzS1l5c1NSMVhUYnZmdFhObm11V0dsaW9TWDAyaXBLZDZnRFBvd2lD?=
 =?utf-8?B?UTl4WDRRd0hCaGJHbGc5L2JYN0VrbStmNFkzZTR1cGVabHNHNDVWOXpoVGlp?=
 =?utf-8?B?WTl6QjdITDAwY1QzZktsUTErdkI0b04xVjJLMUNhNzZidDIrenY0Zm5aVXd2?=
 =?utf-8?B?MnVvejdIMDFMbnpyR0pDMGEvMG5xZFJueTZoYTlkclV3YThDUHR4SkZtU2tJ?=
 =?utf-8?B?dzVKeUZUUWZzenFUUTc1dTIzZk14YkdBZ0ZNNlZOV3dsSTJYbk5STWlid1pO?=
 =?utf-8?B?MGt0bEU0M0R5RlFJdTROQjNvbFM3SFdEUUJQRzF0Zm9aMS84RzFCcGFTUG1u?=
 =?utf-8?B?YW9UcXJnNVJxbGtZa0tRdWtJaGZrMVk4U3d3bXNETEllWS84aG4rWVcrcEgz?=
 =?utf-8?B?MWRPY2JTY2xYOFhpNXVlbm10NUE2aEJjVlAyTkdLVjRraWVES0VMS043d1lW?=
 =?utf-8?B?SDBsUEE5MVp6Nms2cU9mTDRUTGZyTTh6ajQ4RGZsWXBKWVdzZ09YN1UrUlIv?=
 =?utf-8?B?VUE9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: c1540044-cb95-4907-de8e-08ddb4eafb15
X-MS-Exchange-CrossTenant-AuthSource: BN7PR11MB2708.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Jun 2025 19:52:29.3852
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 3V7+kWXbbDM/u4foA+GruabI7igvnPddZ0YBlJ9kGc4ER7nQ/6jGnfNiCXjnEBxihOIfVJTBDDFQfeVw7EWVOg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR11MB6241
X-OriginatorOrg: intel.com

On 26/06/2025 18:58, Sean Christopherson wrote:
> On Wed, Jun 25, 2025, Sean Christopherson wrote:
>> On Wed, 11 Jun 2025 12:51:57 +0300, Adrian Hunter wrote:
>>> Changes in V4:
>>>
>>> 	Drop TDX_FLUSHVP_NOT_DONE change.  It will be done separately.
>>> 	Use KVM_BUG_ON() instead of WARN_ON().
>>> 	Correct kvm_trylock_all_vcpus() return value.
>>>
>>> Changes in V3:
>>> 	Refer:
>>>             https://lore.kernel.org/r/aAL4dT1pWG5dDDeo@google.com
>>>
>>> [...]
>>
>> Applied to kvm-x86 vmx, thanks!
>>
>> [1/1] KVM: TDX: Add sub-ioctl KVM_TDX_TERMINATE_VM
>>       https://github.com/kvm-x86/linux/commit/111a7311a016
> 
> Fixed up to address a docs goof[*], new hash:
> 
>       https://github.com/kvm-x86/linux/commit/e4775f57ad51
> 
> [*] https://lore.kernel.org/all/20250626171004.7a1a024b@canb.auug.org.au

Thank you!

