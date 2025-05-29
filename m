Return-Path: <kvm+bounces-47969-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 6931EAC7D79
	for <lists+kvm@lfdr.de>; Thu, 29 May 2025 13:57:45 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id E537A4E0A08
	for <lists+kvm@lfdr.de>; Thu, 29 May 2025 11:57:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B498F22256F;
	Thu, 29 May 2025 11:57:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="WkGUscrK"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3DDF9202F6D;
	Thu, 29 May 2025 11:57:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.16
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748519855; cv=fail; b=OnrMIzCEsnR85Bc3X6nbd3/Tx6lsx+p6FyBorSfVZabX9Y3jobT67DVpXVsLwQOMOdCiwYtaKeP54QQ0nDx+kDM+4b9W18Nx2uZ8VdxiVHu3VVUBI8GdrZAdnNTElYiv8yIhVsounKJBXsUuO/JBPq8wgYN4qANavMif/jKdsro=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748519855; c=relaxed/simple;
	bh=dxITCJMn2RzNrkzUViBeoNnjTbWVNTGfmdzHau/65GA=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=Avi3GO6RBe4zA63ThVZ82kqf/sIrYFVIV0XDkyEWAWtn4WYG7BExdv7xXkotPX/wgKvTLVdPUTiBw8UxkNZTbmHjNT7kq2nS/26HWiSBers9ldXUM4QyCG2EfYcg5J/F9cmTm4xlHAYfO1Xv1IDDOhJ4P3nW9MUJwhbm4NtyKb8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=WkGUscrK; arc=fail smtp.client-ip=198.175.65.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1748519854; x=1780055854;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=dxITCJMn2RzNrkzUViBeoNnjTbWVNTGfmdzHau/65GA=;
  b=WkGUscrKcf0J0Ju+X7iDdLVjjH8xddCVt54IhY2m7PHxPNXOEJg3gZN7
   IdzIF5tGXKvb07dJC6lgv5vQAhqD0G0dWIAy3jEXX6gHikqPchumCpSly
   foHWOI3S3BUIGSS0l7ceR/CEQvi+hoXM8H4fH5TzuRrMsv9k3atZuvuON
   oeA2MdRjOgUyCbhn4l72xNNxJ+OB3D3FnkISDWXKHmoyAHxw1zYi3uXlK
   iYeP3RPlnuikEgpP1m6oPGf7VNi957JEfbHHU00zih1l21EUHWH2SM1wr
   rm4305WQsl3Au58xQ05QQHJxjB56Y6D6WuLbBXgHfD58iH/I98l29ZtbU
   g==;
X-CSE-ConnectionGUID: V08J9sO/Sz6lMUXZwnT3Jw==
X-CSE-MsgGUID: v7hwBf7hTamIB72jlxRz4w==
X-IronPort-AV: E=McAfee;i="6700,10204,11448"; a="50631017"
X-IronPort-AV: E=Sophos;i="6.16,192,1744095600"; 
   d="scan'208";a="50631017"
Received: from fmviesa010.fm.intel.com ([10.60.135.150])
  by orvoesa108.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 May 2025 04:57:34 -0700
X-CSE-ConnectionGUID: F7e+FrA8TjGOybnUDK0+ow==
X-CSE-MsgGUID: /a/zm/wYQPup6fAhB0xodw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,192,1744095600"; 
   d="scan'208";a="144009649"
Received: from orsmsx901.amr.corp.intel.com ([10.22.229.23])
  by fmviesa010.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 May 2025 04:57:33 -0700
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Thu, 29 May 2025 04:57:32 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25 via Frontend Transport; Thu, 29 May 2025 04:57:32 -0700
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (40.107.236.59)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.55; Thu, 29 May 2025 04:57:31 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=VFSQtceaa2eAJcHCSsC/54kS0awjVJnciZ9PwFvcYwJIva71yZnnBj6+S9/nmL51vfIZ7RA9GsQ/hHDg1aJXqs59WfMXmDbsoKwQ+ykyQGsXennWT07X78u6qGL/QnP9Z8oSWO2LmcJS38iJfW+jveOf4ZJPANTk9KsfJANUI2ymoT2ckaLpbZht0RzDRh9n2w+XAvUL8mGohW8RGn6+KD/Vi1wgfozYaTNjIUB/uXTKmPJRndjn+FaYDIKfantpDuiA2wmhoe+ezWBOQ0pUVjDNIgYbRHfXUpPD6pfgsYHaCeuEghXG72BsbhRxvE/k9C2zpX9iPy9sk8djjtpvdA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=dxITCJMn2RzNrkzUViBeoNnjTbWVNTGfmdzHau/65GA=;
 b=cy1RWZfPLxBCTnnt5egqmbpAgsI2yrlnpmdgizESaGyfGT5sBx+HL0w1Z2d6yr4Mup+GFuDvTqE/BT/0tHqaZxAse+KbcDgBsIXfey1MsETzBjmivF0uqo/kuBVK2Dz+EvkzLk1eJVk534C4f2VGztG0XC+28VfTqpzn0p9b7RovToNamGB8/UCqNoMpJ65Brlehb0NzZx/ItieUxdfiiYtMGnayTsPYYD3KHjR7QKPL9YTPItX2YxuaUv9NQuPOJL7I87ZJ2K+aeWJk9lIGQ9UXfd7tG4DmVbmWJUHdXytJLnzffUc7pXz5xaSO+BsZQDpvKRDZMXyXlBx1VNwu5Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5525.namprd11.prod.outlook.com (2603:10b6:208:31f::10)
 by PH7PR11MB6401.namprd11.prod.outlook.com (2603:10b6:510:1fb::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8769.26; Thu, 29 May
 2025 11:57:02 +0000
Received: from BL1PR11MB5525.namprd11.prod.outlook.com
 ([fe80::1a2f:c489:24a5:da66]) by BL1PR11MB5525.namprd11.prod.outlook.com
 ([fe80::1a2f:c489:24a5:da66%5]) with mapi id 15.20.8769.029; Thu, 29 May 2025
 11:57:02 +0000
From: "Huang, Kai" <kai.huang@intel.com>
To: "pbonzini@redhat.com" <pbonzini@redhat.com>, "seanjc@google.com"
	<seanjc@google.com>, "vkuznets@redhat.com" <vkuznets@redhat.com>
CC: "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 11/15] KVM: x86: Add CONFIG_KVM_IOAPIC to allow disabling
 in-kernel I/O APIC
Thread-Topic: [PATCH 11/15] KVM: x86: Add CONFIG_KVM_IOAPIC to allow disabling
 in-kernel I/O APIC
Thread-Index: AQHbyRYxNH/GJBJvrUmF7CZUp+ur/rPpjuOAgAAAgIA=
Date: Thu, 29 May 2025 11:57:02 +0000
Message-ID: <019c1023c26e827dc538f24d885ec9a8530ad4af.camel@intel.com>
References: <20250519232808.2745331-1-seanjc@google.com>
		 <20250519232808.2745331-12-seanjc@google.com>
	 <d131524927ffe1ec70300296343acdebd31c35b3.camel@intel.com>
In-Reply-To: <d131524927ffe1ec70300296343acdebd31c35b3.camel@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.56.1 (3.56.1-1.fc42) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR11MB5525:EE_|PH7PR11MB6401:EE_
x-ms-office365-filtering-correlation-id: eb036618-19e6-4f1b-1118-08dd9ea7eca3
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|366016|376014|1800799024|38070700018;
x-microsoft-antispam-message-info: =?utf-8?B?YXNsTW1rUXoyRTBjTnVJaDRhaFR3UlloNkZJL0ltRjltT0JNd1BLZXNPNkxw?=
 =?utf-8?B?QSt0OW81NC9OQVlDcWNJV2JvTXNjWE1PT0NEVEtxbkFESVJEeC9DVlNDSlJM?=
 =?utf-8?B?ZzJBRHNCQnp5aHlxR29sakFiM1gxdDVIZjlqTGw5ZjZaTTIyK2xzKzFaaUU2?=
 =?utf-8?B?OUk5czVhZHlxYWJaY0JON0lBcmI4TTM0MURKL3Y0NHpXUVJGL1dQaHZUWm9z?=
 =?utf-8?B?ZVg5YXlDYi80VVVFU0MwZzZpVnpJdlFhSWNXVm8rcmljd0Fad0NCVGZhN1J2?=
 =?utf-8?B?RmhpQUtlSjluSHVPSVNyVFZQdDRINHZIdUx2L0FiSzVVVFVLNjNuVnh6U0FT?=
 =?utf-8?B?enczR2FIN0gvWjZEUTluMU11RTNLa1NsYXpmOUhyZmJHVlAvREk4N0ZZMlRO?=
 =?utf-8?B?VFRoSTdvZHR0TURTSGl2UGo1WTVXRU9wbkZBczRLalJDRGJLZmt6U3UwMmxE?=
 =?utf-8?B?bUR0eGNwMjk2dSt4amlGbWJqZ1F6WFlDT0picE1pYjhKRjVaV3dWY3FyaEk2?=
 =?utf-8?B?RUFnWTlheURmT3JFNkdzeS9HNFE4VVhMeW11V1VmeUllMFp5UHpMN216WTZy?=
 =?utf-8?B?dFlvdU8wZTBjL2hpNXU5K1R0WDRLZGhuVytUaXJkcjRqRmN2MDVnMFEyV01V?=
 =?utf-8?B?elpIMW1VdTNyTjJsMThxTi9MaFp6OWR2NXcvOGh2V2MxQ1o3YUxkd0xqUzFp?=
 =?utf-8?B?M1NIdnk5dktnbWhFU0I0dnJrbzUyZWRQek0vVHB3WGE2L0ZZcUtzcS8wSGN5?=
 =?utf-8?B?UEJuQzVPV2RzVzlQbmdQSHM4cEY5MUNFL3ZwT1BFZ2VJS2dLUGtaYVJuMzd3?=
 =?utf-8?B?Y04rb1A4QTBjN0JnUTYyYUJZTUkveXlXYmRnbVpLaEttNTVCc3l5NjFVd2Zu?=
 =?utf-8?B?M3NRSmRvelJTZ0hXdm9qcFd4SS8zSkNHemh6Z0RLdkNTT1BMKzM1RmVJTDky?=
 =?utf-8?B?cnhTakVUQTlkRVJaakhoemdtQXRDeWpKeC9kay83NjBCS0h0am1NeGtRQjB5?=
 =?utf-8?B?UmZyemZ6R1MyTEFtMHVPWG9RS3RlUk9sNTErWmtOTTdjci82eEhDQ04yZzhG?=
 =?utf-8?B?dS9yaVpNVGNQVlhaSnVOclM1cS9QTUhyZTRNaGp3dTB2cnlyc3VHdmwrMzhm?=
 =?utf-8?B?UGU4d3JVbWk5ckhJN1lzM2d4NkExVUJ5ZXhTbXVPQjcrSmswOVZuSFFaWDg2?=
 =?utf-8?B?SC9XMFhRb0MwOXNIZnY3aGhjTCthaFdsa29YdFkxRUk2T244ZVpSV3liZklq?=
 =?utf-8?B?eDdyTVNrYWVWZGw3Rm1Ld0JGTmViOWQ3TTR3TXVHOEZVVU8zb0l1RTl4T0Fu?=
 =?utf-8?B?eGdnQyswNlRYNHNsQ2Fhc1BGMTVxeE9IRC9uRHhxQ2pFbWdYYU1iS0h4Ukd6?=
 =?utf-8?B?T3RqSGdxRmZUbzVBUlgyd050aHpPcFJnNjNaNExaUkFYUU9ubW1qOU5sbWRx?=
 =?utf-8?B?cHc0VUl5R09Wam1PU1BCT2JpOVNONjFCOTdrZXVUMG5vMjVYY0dSK2FHUDQ4?=
 =?utf-8?B?cG1VRCtKandqdnEzamhxQlhZVXJKTTlFSzI0SXFuZDZMV1EyWTZOaUo2TVp4?=
 =?utf-8?B?akk2OUlNM0xIb1d6am95K2tkOGd6VzdKNE01T2JuZEZDREI0N2U4UU1iTkxC?=
 =?utf-8?B?SmYva2MrTGc3NURMMUdDY3ZwQStFRHBiSERYRDg0S0RzTW1CaTFSSTM1SjBH?=
 =?utf-8?B?VU45QWVuT3hGYUd0cHlLSkNsVGgwSnFMc0pmbXRtREV4cnRzTFJHN010ekM4?=
 =?utf-8?B?eEJodlFGUTRubTNobmdta2pjc05YSHlGeDhoL2RTWmNuR1ZzR0k3aGIyNzFV?=
 =?utf-8?B?UnBNallwNHVkY3VUditlbkRvdVVKN0pwN0xNZVEycllSYWs0Q0x4U2Y3dmJC?=
 =?utf-8?B?elNYSCtuL3J6UGhaT3Q1NllxZmJ1WS8zbVMxWjlYU3pRa2hIWjZ6TFZvRkpC?=
 =?utf-8?B?N3VRNXhoVzhIOVN6TUhZM3lnRS9GR0Q3T2FTRnFodldEaThrdG5jVTdTejBi?=
 =?utf-8?B?SCs1d0psUlNRPT0=?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5525.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?bXZtQUtsYXZGM0ppblJmN2F1RVNpKzU3cmtObWJpY2dMYStINENRbUhDelBt?=
 =?utf-8?B?bzZUVkJWakVIN0s4eDU3cUZ6M1d3L2NML2RGWjZWOGpERHF5N0Q4RlpNMyt5?=
 =?utf-8?B?YjlEZkRJRTVIZmJGTThpeHo5R21BaERteWUxNndXbUthbFR5bVovZEZzTnZV?=
 =?utf-8?B?OG82R1FnM09Ga0NBK2kzU2t0T0tKMXk1dFZJYnpZNGozVGRrUzdZY3M3T2Jw?=
 =?utf-8?B?aUVvZVJDWnVFS3FNcnFYdGR1bUxBRjFwQmhwczF5ejUyajhXTFRjc0FMWmU4?=
 =?utf-8?B?OFp0aGF4Zm1yUWFsTDRXbG5jU3U0bXpPU1VSbVF2MGtxaEVsT2FKZWh2TitX?=
 =?utf-8?B?WEZncnNybU53M2VJcHJNdGpTa0VvWHBpWWNTQ3R1QzQxWStQL3FsN0crYmRB?=
 =?utf-8?B?UnMrWXJXUEc1RGRmT3E4VjFiUVRwd2dQbVBRbGkzMlVyVVZBbnRrcEdUWTFD?=
 =?utf-8?B?cXN1ZHQ1Y0NJQkg4UkM0UDFkdWpXWUlFdXhCSzNxM1ZKQ2svaEtXTEZqb1l4?=
 =?utf-8?B?NHRBdkd3QlN6RmR4Q2ZjSWR1VnlEMlJzRDdDUzg4SmlhT1ZVbVJOVjJuejhZ?=
 =?utf-8?B?S1JDVWxRTzlNeFVReElhNVZuUjU1ajZxdHhJbzRYWGkrVGV0WXNtdGZjRjZ4?=
 =?utf-8?B?cCs1VDFmeU9neWwxc1JKc3lFS3ltWDFSMDFaT05yWDZRcVlvN2dJL2tDcEYx?=
 =?utf-8?B?YUlEY0RpTU50bThVaFVMejBVd1dsQW41VlU5WW1yajZlNEZpR1RNVXoydGdQ?=
 =?utf-8?B?M3pNTU9vdlR5S3FjdWJTWVlxdlhONmxVRFh3bVRRM0FmN0Z1dkFlR1RRWnZH?=
 =?utf-8?B?MWs1REZXZEZPSGltZDlzdCtDcnRzWTR6NWQvUkNDNzlxckJtLzhPTlQybGpU?=
 =?utf-8?B?YkIwSy9GZlVLVkN3bkJSV3IxVDl5TnQ0RkVuTDdNbkdidjZHVmZ4cVJyeFAv?=
 =?utf-8?B?TC94TDFXZHV4NmcwaWRSclkzOXYvdDFjeHFmTXgyOUdXQVA1ci94dzBReFB2?=
 =?utf-8?B?Z3JWWXkySWt5dzJTNTAwVTl0Y2kxSExoUWhJTTQySlQxM20zNUFlZWJlYXFx?=
 =?utf-8?B?b25qYUhhVXgwekVSZDc0bUpidTZkWHpEWWtqdnVrOUVRVENjbENWdXg2VnIr?=
 =?utf-8?B?aDZPZDB2M2M3YVB3a0lXVFhwQ0xpMlp3QUgzZ3Arb0FWOVZoM3JaMXFyaVVS?=
 =?utf-8?B?K3RjNjk4T1diOGVyZFpkUWlaSkRQRnR6cWEzNldsQzliNXhJT1ZLV0pQTmh3?=
 =?utf-8?B?RHRHaFNvVFphcjBCaC9zQlZXaE50bndhODBENGpXQlovMVNvQ013L04ybHdy?=
 =?utf-8?B?OTJsK3YzeWlwQW5xZFRwTDlkNXVMUnU5NWh6enl3RWM1SnVYdmtTbE05cnZO?=
 =?utf-8?B?TFJqVkdrazluYWdPbDdwejlUYTNBdEkwQWVVanVtclpXWTFuNGNTblBQR3ZK?=
 =?utf-8?B?WCs5amhaNmR2Z1lCazU5RVpDY2t4WWE5elJkSk51VUlCRmJ6QzFYa1YyaGNW?=
 =?utf-8?B?bnhYUGNDam1rUzdCZTdBeEplNDA5WWZGZE1RdHo2cTdxTHFCcWNUdWlJbzBF?=
 =?utf-8?B?ZTFpR1NTWDdKYUNVWUZwZFJPT3JkZzlDajNJL09WRTFwSmVnYlBxREtaTVgx?=
 =?utf-8?B?Q3R6Y3hRU3dJQkJhMTFIQkp3NmZOdEtuamd1bmdFTEZTV25Ub0d2R2xxYjU5?=
 =?utf-8?B?dmo5bEc5UlV6NTB6TC9uME9RdFZURm93SzdueE81M0tXM1Jjdm52Rkx1amZM?=
 =?utf-8?B?QWJENGJwQ09acENZbHdyRVJBQ2FqeGRMdjJsVzdEZE1ubyt0NUVCeTRNeXZU?=
 =?utf-8?B?Wm13aWZjU2ZyZXk3UEpTV0JLYStjRDBzSnFwcnBhSE5oSnhtclhTeEp0clV3?=
 =?utf-8?B?bjNIZ3hYUURLbFNJS2FTc2NVcjcrc0ZvaE44SVhuQUgwaWcyb1ZhblZoaUlU?=
 =?utf-8?B?M3RjaTNIeWxNV0V2T0RCMmkzaFNrRllkcERsS2hSYndqbGNUVWtWamlVdk4v?=
 =?utf-8?B?S1dIUmZCQkFZMDcwaTlCeDhGWDlBdVlML2FsbnBRMDhmZjRaVTRMU21WS2Ur?=
 =?utf-8?B?MXc2S1I2QTJwbHJ0VWM3dFJTYzhlK0lqUlNlYkRPTFFqQllFYjlVdkl0aW42?=
 =?utf-8?Q?t/CIBP0M7zzblHxGJkWOYabVC?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <996A964F273C584782D5EA395DB3D1A2@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5525.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: eb036618-19e6-4f1b-1118-08dd9ea7eca3
X-MS-Exchange-CrossTenant-originalarrivaltime: 29 May 2025 11:57:02.3094
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 6BpJb7A2VkymyutXnAg71DzLZozEnbMxBFYmbLFwrmIviLepTrQ3wRgf1ENwBurKAkeYKsqCNseFvNK8vIU3Ag==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR11MB6401
X-OriginatorOrg: intel.com

T24gVGh1LCAyMDI1LTA1LTI5IGF0IDIzOjU1ICsxMjAwLCBLYWkgSHVhbmcgd3JvdGU6DQo+IE9u
IE1vbiwgMjAyNS0wNS0xOSBhdCAxNjoyOCAtMDcwMCwgU2VhbiBDaHJpc3RvcGhlcnNvbiB3cm90
ZToNCj4gPiBBZGQgYSBLY29uZmlnIHRvIGFsbG93aW5nIGJ1aWxkaW5nIEtWTSB3aXRob3V0IHN1
cHBvcnQgZm9yIGVtdWxhdGluZyBhbg0KPiAJCSAgIF4NCj4gCQkgICBhbGxvdw0KPiANCj4gPiBJ
L08gQVBJQywgUElDLCBhbmQgUElULCB3aGljaCBpcyBkZXNpcmFibGUgZm9yIGRlcGxveW1lbnRz
IHRoYXQgZWZmZWN0aXZlbHkNCj4gPiBkb24ndCBzdXBwb3J0IGEgZnVsbHkgaW4ta2VybmVsIElS
USBjaGlwLCBpLmUuIG5ldmVyIGV4cGVjdCBhbnkgVk1NIHRvDQo+ID4gY3JlYXRlIGFuIGluLWtl
cm5lbCBJL08gQVBJQy4gwqANCj4gPiANCj4gDQo+IERvIHlvdSBoYXBwZW4gdG8ga25vdyB3aGF0
IGRldmVsb3BtZW50cyBkb24ndCBzdXBwb3J0IGEgZnVsbCBpbi1rZXJuZWwgSVJRIGNoaXA/DQo+
IA0KPiBEbyB0aGV5IG9ubHkgc3VwcG9ydCB1c2Vyc3BhY2UgSVJRIGNoaXAsIG9yIG5vdCBzdXBw
b3J0IGFueSBJUlEgY2hpcCBhdCBhbGw/DQoNCkZvcmdvdCB0byBhc2s6DQoNClNpbmNlIHRoaXMg
bmV3IEtjb25maWcgb3B0aW9uIGlzIG5vdCBvbmx5IGZvciBJT0FQSUMgYnV0IGFsc28gaW5jbHVk
ZXMgUElDIGFuZA0KUElULCBpcyBDT05GSUdfS1ZNX0lSUUNISVAgYSBiZXR0ZXIgbmFtZT8NCg==

