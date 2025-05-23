Return-Path: <kvm+bounces-47578-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 21585AC21FD
	for <lists+kvm@lfdr.de>; Fri, 23 May 2025 13:32:30 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 94DD87B3220
	for <lists+kvm@lfdr.de>; Fri, 23 May 2025 11:31:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 36F8F230264;
	Fri, 23 May 2025 11:32:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="ke12R9RA"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D1FEF19DFA7;
	Fri, 23 May 2025 11:32:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.11
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747999936; cv=fail; b=qyelc0M/+HFrLX/UG4ImC8UT3tYi4YuxGZEZtpkpa9AcD0S63WjUqUXdTjhXL9tpglNO4SWZYTM62aOcUkbgZ6Hb4No7zDI5aC+RJ2mP0G2cbR7ErHVht/NTdCntlftfPD+gPDaD8SjHytW7vNqJQ86mpItQkpJJlhLTP4JPT5U=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747999936; c=relaxed/simple;
	bh=FbVLP1ylgpq4neVRxN6+VwqKZ/9GxIDBqI+r0yw69ds=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=t7GXrkWfTl4HBt90GEb4BjyqgC49I+M9X6AiOEhBi/Q/bS66+KTMWfoCUY+D/D4S2TpTv1mfHr8Y0wSYl/iFLjAyLITqRW3x3vhFC0rg/OGTC0UJNeBqBLWY4TK5axQYVyV/k4BY3E4y5MMp2BwVyU9KIrHF51fBKUfxYgNvuoI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=ke12R9RA; arc=fail smtp.client-ip=192.198.163.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1747999935; x=1779535935;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=FbVLP1ylgpq4neVRxN6+VwqKZ/9GxIDBqI+r0yw69ds=;
  b=ke12R9RAPhO4k0H6YX/pYNWxBrrnw9HsUNwQPvEIXoH+wAU6D50MkJ+8
   Wg37WehRrn3aP+J9hRsHUtWK8dsXEjuTrp7PUmsxw4K/ROTqFWrrAb58H
   8UGuR0/vKx6OsK6OqP9Hq+oAG0YHHQ63G4FM8ndR1fAOcm2R3MFA6kDMP
   RU3RlwV/F0gKm5W/iPaohBiYDiNZWX6FFsWN191+2mr3hsA+eSOnjDc6g
   cBtTiRRxKuHmQY/hSt1AEgAO3MsUJwlEpHbaw5aNdQo6QHR43M0LThL5l
   6klSHUnkxa7iodYivWKJHilmeWKKnF15vdZ4xtlkbNQqJPeb/AILLN0A5
   A==;
X-CSE-ConnectionGUID: h1sC+kwHSWeDe9hj22cQxQ==
X-CSE-MsgGUID: KzGvgXtQQhyMcNYNs9vsDQ==
X-IronPort-AV: E=McAfee;i="6700,10204,11441"; a="60690733"
X-IronPort-AV: E=Sophos;i="6.15,308,1739865600"; 
   d="scan'208";a="60690733"
Received: from orviesa006.jf.intel.com ([10.64.159.146])
  by fmvoesa105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 May 2025 04:32:14 -0700
X-CSE-ConnectionGUID: m/Q+FqEpRFGhn16VLz3bZQ==
X-CSE-MsgGUID: erZ677YaSH2DJCgVLqX1cQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.15,308,1739865600"; 
   d="scan'208";a="140985851"
Received: from orsmsx902.amr.corp.intel.com ([10.22.229.24])
  by orviesa006.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 May 2025 04:32:14 -0700
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Fri, 23 May 2025 04:32:13 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25 via Frontend Transport; Fri, 23 May 2025 04:32:13 -0700
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (40.107.244.72)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.55; Fri, 23 May 2025 04:32:13 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=I4zfPhNp8OiIv8EZ08cVC/ZnHrlaihF7RdBhx+mEswiw5OiQp9bj8vBFXlfENuZekqpYIuqwz20giKl9gaHVazPj1HR/eyMznlacSJeRUCPctzohrwUWIMw558qPyByND8TFMaVBhOT3y1sv9z339Xrbl07VTlGAgUlybDG52iYc6XX3FFgO/SmDBpZ588op1NXUqdHw7k8fhIb6RpgLYSiVfIDYE4/O79I5OByTm+kQdgBy2kP3d1wOCANMu2KRep0sjDRMnPZQKh58CtCoWRg/btkcNd3sb/4W7lPYaiYAikb8FMPtMT0iRUWOLVYOjV1KmCuOXb2tj6CQp0tEvA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=FbVLP1ylgpq4neVRxN6+VwqKZ/9GxIDBqI+r0yw69ds=;
 b=T1JkI8vcHtTW+vnHw5Av+GjB3I1n9ScDhv6woH+CxaNVvb5zYDgV82sD1j4EPS9cYLU9jg8cfXjaBlmZYLklwy3OskFxzaHOR16vOSzktiiYJtdYCL6ASq90p7tnFzmSAfVrJXswThoR7EUPAQExtjU1Z6HfTBK1hsskipeRhRG62exc3XCaLCZAnh832MK/mFzI1tYnLW+VRb6qR7Gh5TzrvYinJixwliknkuGdIDrTmJdaXQXgfvVGaDmwfdV9wLBhsgX8JGt6Bv6RxHfJBUlSzhh+9H16slFjaJenMZSCAMU6Nj/bX/MKrspPBtpHRSBF8ZR99ePs3W8ufvyy7Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5525.namprd11.prod.outlook.com (2603:10b6:208:31f::10)
 by PH7PR11MB6697.namprd11.prod.outlook.com (2603:10b6:510:1ab::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8769.21; Fri, 23 May
 2025 11:31:56 +0000
Received: from BL1PR11MB5525.namprd11.prod.outlook.com
 ([fe80::1a2f:c489:24a5:da66]) by BL1PR11MB5525.namprd11.prod.outlook.com
 ([fe80::1a2f:c489:24a5:da66%4]) with mapi id 15.20.8769.021; Fri, 23 May 2025
 11:31:56 +0000
From: "Huang, Kai" <kai.huang@intel.com>
To: "pbonzini@redhat.com" <pbonzini@redhat.com>, "seanjc@google.com"
	<seanjc@google.com>
CC: "kvm@vger.kernel.org" <kvm@vger.kernel.org>, "vipinsh@google.com"
	<vipinsh@google.com>, "jthoughton@google.com" <jthoughton@google.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v4 1/4] KVM: TDX: Move TDX hardware setup from main.c to
 tdx.c
Thread-Topic: [PATCH v4 1/4] KVM: TDX: Move TDX hardware setup from main.c to
 tdx.c
Thread-Index: AQHby3daNQrZ3RHWbkWR5kzEQEmoILPgFaGA
Date: Fri, 23 May 2025 11:31:56 +0000
Message-ID: <18f7a897b3582c086a8f2814f0888f3d486239ba.camel@intel.com>
References: <20250523001138.3182794-1-seanjc@google.com>
	 <20250523001138.3182794-2-seanjc@google.com>
In-Reply-To: <20250523001138.3182794-2-seanjc@google.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.56.1 (3.56.1-1.fc42) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR11MB5525:EE_|PH7PR11MB6697:EE_
x-ms-office365-filtering-correlation-id: f0dedbb6-d911-4014-d85a-08dd99ed6c7b
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|376014|1800799024|366016|38070700018;
x-microsoft-antispam-message-info: =?utf-8?B?c0JQblBsdWwvbHpXZTJWaXYvWnRPcmhlM2o1UkNkTEl6QlRhSVJRcmxvOE1H?=
 =?utf-8?B?UmpUUkFkS0QybFkyYnQzeU5jVkQ5SGFoVnBQTmVwUkVJaU8yLzI5bUpJbzJa?=
 =?utf-8?B?dTRCd016azhxVVdUenAzYlN5cVNQSDZPbFVaNzQyc054enFIVUdocWVMT1Bh?=
 =?utf-8?B?MUo1RWlmOW9yRy9acCtmQUxIdWFBNmgyemVObEtGQmRERE1VZmoyRWhsZUtI?=
 =?utf-8?B?RnE0Q3hTM0tLdkhsVmlPdXRCQk45Y2hhNE4yZ1VWd2hhSlpwcXFDZjNwY3Jw?=
 =?utf-8?B?enhSTXo2Vm04Y2RlUnFYRjMzUTQ0RHNzVnFELzFKNXZpSXNDZ0xlWHdveVk1?=
 =?utf-8?B?emlxU24rdzUvMXVYaEpXbkZ4R1I1ZElnaktzSWNkbG5DQjdYdUFNSFFPRXJi?=
 =?utf-8?B?dmhmRUFaeUE1ZU02MGh4QjF3dlg3OTYya0JxVzVmMEE4YVNLVVdwQW53Z21N?=
 =?utf-8?B?T3NZRGpPY09zQ0NNM3ZMUkpiajVrRStLbHYvKzg5OUtHc3krWEFFTUdKakZC?=
 =?utf-8?B?cmZVbURRRWN6TEpYVXBJYklFZEZ1bjNCNUsvQTV3bnBHLzhHclpMbGN5aW9p?=
 =?utf-8?B?eGtWemhaMWhJbks1RW5rbmp6bHdEaXUrbGhHL3ZYK2JRa1RBYmxQRlRMT2sz?=
 =?utf-8?B?VGNHc3hmLzdPNEZxL3BTVi91THo2S21Nd0dGWnI2UE5CanhSR2VGNlRuYjBj?=
 =?utf-8?B?ZHliaFVsTU05MkpRMmQ1bHdIQW1NelRsNEdPMWZ3MjhPckEwQU9QSFd6YWpi?=
 =?utf-8?B?dyswRjFRTnR0b0ZMRzFta3RWbkN3TlNYdnlDcHQ3TWZoRFF0VmdCQkZPcDYv?=
 =?utf-8?B?NmJZWnNTRnFMSFlWQ1U2Q0FTS2JkbEZ3bWJ0QnpMQ1d3d3lGSHdQY0JMMzdv?=
 =?utf-8?B?TnAzd2tJZkdkSUp1YkQ1K09Rc29PeFJvTTFLd0Z5LzZab1ZtekVYd3FjM1d1?=
 =?utf-8?B?VXI2M3cxWitjMDJla05NWU5WTXRpczNxaGF3MEhSeU43MmJYY1dxM2t6L0RB?=
 =?utf-8?B?WVp5RTZOSlFUQ0VBWWdIVDQrSWpocTQ2RDVkSWx2Q2paQ1d5MW1tUEZUSzg2?=
 =?utf-8?B?bEVYTVdieUt6dTZpczJQSUo0WDFQUlpVaVRGYjNLSlRtb3F5QjNWd0paZW5s?=
 =?utf-8?B?VnkvR1ArUUNDL1FId2VYbEtDaFc4OTRZSDFVNUtkT3JQRzc2SjdOZU5LQm8x?=
 =?utf-8?B?dzJQcXcxQVVFaUlxSFJGN3JtOHhHaW1BSjkzUldnejVVK1NJSWtIcmtKUFZy?=
 =?utf-8?B?VjU4aExnM28zbWxHcE1pZWhwZVIySXU4UW1iOVQ4b0t0TkxkaEw4UkhSazFi?=
 =?utf-8?B?dXJYUkV2bXVseTZsdW8xaFBsdnoyL2ZSVnRmK3hBdkZNQk5OTnJWdXBvbEdQ?=
 =?utf-8?B?MDdjdWtGOWJTZUFDYTh3bU9CU2paQzNnaCtKRTU2V0NkU29RVUc5dG5KS3dv?=
 =?utf-8?B?NENheU1ocnZPYjJXbE93c3BiSjZxajJ4alZlTHFZNDRpL0F0Y1ZRUDZwTnJO?=
 =?utf-8?B?OXFtdFU1amNNa1dLYi9YaU9hR1VCb3JxU1NiR0hab2lUNlRZb2x5aEdhOERr?=
 =?utf-8?B?YnppMDJwVk1mZ0tDaUZ2YTIweGY3eFVJaHVyUUJaUG5CZ091OU5RVWNGcmY1?=
 =?utf-8?B?S2tYNkwzYnlINkQ2Y3NqRlBtVkZGVklxQ0FVUzRIbnEvbUtwczNyOVZBVy9y?=
 =?utf-8?B?ejhRK0phS1pXdDI3amhpS2QxVEpmWWUzNFlVdkxkak9IdzBDYlkxdmpYdGxo?=
 =?utf-8?B?SytISGJpZU1uWWZKTnFIT2dBRWhKK1RzK3A2d0FuSldLaGIyQk9DUUJBelBT?=
 =?utf-8?B?N0VZcE5BYzNJNEJaM0VCSjNzQUxlRTdHUlVHK05hUENBKy8xUnpmQW5RK1F5?=
 =?utf-8?B?SlZVMUlsNGFlaUlFeEVHUjZMVktoNWk4bU1ZRFJCRWdnM2tWaGxWV0V6SFBT?=
 =?utf-8?B?TVZndXhRU1NXRHNkWkNrS29rWGxRYXBzZURmNUZmdkk5WUdITHZEU2Q1YnlG?=
 =?utf-8?B?U2gxSWk5NkJRPT0=?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5525.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?cW1qWmtLQjNNaUhaRTNaNkRvNm5LbUYyeEJCbEdQNVBxQnpnRlV0Ky9randq?=
 =?utf-8?B?Ny8vSFhEQU9LaUludWVnQ0QrWjlXblJzYTRHZFZNUnFyaUwrQ29qdEVTMzFw?=
 =?utf-8?B?cXpEU3VJVndNQ2VRUE9sUW42emYyR241Qy81QS9oZkNnNVFTTSt6WUxuNWxq?=
 =?utf-8?B?OXBJK05RcmVHNXdWT3dYM3crbFg1ZDNHaE5tb1cxcC9TbXhPbkdFU1A4bktF?=
 =?utf-8?B?L0hhL2pBSytaa09rNWY5UTg1SlI4SS80S204Q2ZMY01LSnlRcithSUk0QTV2?=
 =?utf-8?B?ZGV0MUFUOVpmSDNWNmVsKzNNOGNkc3hHS29HSVV3SzBsdU1oS2dmQjFSa0NL?=
 =?utf-8?B?QW4zN1RaYVNhZ3JzbHh3ZXFOZGRaa3UxeTdLcm8zU1V1UmZyRCtXMWVrS3NP?=
 =?utf-8?B?SUkwTUNCVGhhYmNhUmxHa0psQmZUVWZ1c0FucGFOeUxRZ3UyS29kemlUTnJa?=
 =?utf-8?B?bUo5NWw2UHVEYURiTGxRYlBKdmExWXMxQnZXT0gyWStCV0YvOG5CdXRXbEdB?=
 =?utf-8?B?c3I0bVFzUFZlb3cwYTdBZnE2VjFmdEJlQkovM1Zua2FIb21xVGloTTY1dW83?=
 =?utf-8?B?WjNzTnNJblUxNW1kZTF0NWRJOGZGdG9XQU1XOCsxeVBzSmZuWEVzdEY1VnNv?=
 =?utf-8?B?dkNlVStRcWNZS3dkNTZWU201MEdyVmIxZkVId2htei8yR0xXYjFoMVhFb1l6?=
 =?utf-8?B?eTA3elVDaUE2S3ExN1FocjE5V3lVM042TSs1RFpxelVsWENwb01UdWs0LzVj?=
 =?utf-8?B?bUo2dG1pQmViWnhzM3pCMlM4YnFRVzNkM1hja1BFb0JCKzMwaXhmM1VjMGRl?=
 =?utf-8?B?a2xPcEtnM3BBTVZzQnk2MGxNeTVDbjB6Qms0dWRtL1hIanFyQVBoWlBXRzhu?=
 =?utf-8?B?MUowWjBBVzNOSFNVbTNJazNtWmNDM1g5SmFUbzRGdEdqbUcxcXZMd1BFR1lu?=
 =?utf-8?B?SzI4SEErb3JLdW1JZlMrcGJGN2ZMK293ZnYrRUtDaWtQbitwdXRGNmZyckpt?=
 =?utf-8?B?VEJSMmc4c2pxeGFFKzVQRHVYZGYvYXNlQWhPMUpVZnJ2WGxIZTFvOForODli?=
 =?utf-8?B?alV0TUVwdWZVc1RWalkxckJoZW5IWW4vbW9keHA4L2RlQjIxS3NWK3JOWTcx?=
 =?utf-8?B?bzdmOTZDWEcrQnhTWWFmcGw1M3Z1YTdsSkdHWjgxMXRTRk1zeHNUeVJETURr?=
 =?utf-8?B?TlJUM3E4OXdmQlRONitCeDJSSnIrQ1JUQS92bnVvRjh3UUFnbzRnSk5qeDVV?=
 =?utf-8?B?ZjRaandBekpMZWRVd2FRR2NFQ2hPSzd4TVJ0cFc1dkg4eXM1MXYxWVl6bnVE?=
 =?utf-8?B?ekpyb1Jmb3lUL0daRlRXdUNWNmZ4ZEJBeWg3ZkF6UEFKeDRNM09xZWxVNk1v?=
 =?utf-8?B?YkQ3NGk2bnBOV0dlVnA4YTZMN0ZrRTJYWmRuZkZFMmw5cC84RjNyeVd2dFpD?=
 =?utf-8?B?WGhzZmlCUkVua0ZoZ1FEM1RqRFhLSllMdmhNL1ZISlM0azl3eHN0a2drWTA1?=
 =?utf-8?B?QVBSdC9zVGF4NWtQOE1JeitxRGlNa0ZiUFVnNWlJOWRCT0tIajVvSDY4anJP?=
 =?utf-8?B?OUxFZHpkeCtCUmxvbmUzRm1sZU5BMWloZyt5bCtNNlpSU3duTU9ETEdDdkZ1?=
 =?utf-8?B?cHllVWJjT0ZGc0dXSVpoak5XVGZIbmFsZEhQRlJiWmsxT0NKMHpmcFZxNFp2?=
 =?utf-8?B?UzBmU2NVc0Zta3drZ3FaVlhQM3U2Q1pOOUR1MWU0MXZaazhZY211b1hBQmhy?=
 =?utf-8?B?WUNzU0t6WjZlYXpNMTJnNEpaV2VhTGQzV2ZsLzRzNFpjSFAzMFhra2lPeGFk?=
 =?utf-8?B?NXFzbzBuUlptZDFVVTkyZ2hFVkUwc0ZQWWJDaEJEWVI5dXBRcUFGZ2pHZnBC?=
 =?utf-8?B?akMzSHFNSkhZOFpwMTBZczExOTBJZHYzcmw3S3pURUFFNUlmSld4cmYzM29x?=
 =?utf-8?B?b0FlaHR6ZkZ6YlFpWkpjdUx6V1hCanNCWWxNSW9uUmgvUlNJZlRLSG93ZWFH?=
 =?utf-8?B?Y3lsMTdvQjFlREhHVDlEbjVtc0dSdHpOay9TUHlWUnpYRnBYSTltSEJCUStZ?=
 =?utf-8?B?bUpad0lBWTRWT2NkbTNxSHNyWVRVVkl4VXlkSjVidVl2Y2IyZzRHR250R0RU?=
 =?utf-8?Q?/WTL7N9CvpXIXrh2UvXBhh5pX?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <68F1C6B1F4CB7143A8AB87572AC6318D@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5525.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f0dedbb6-d911-4014-d85a-08dd99ed6c7b
X-MS-Exchange-CrossTenant-originalarrivaltime: 23 May 2025 11:31:56.2620
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: G7WclTHvPIPnjWvnZYAHVTNPvkKl1zfmRIdq2NG+K1ZJL+CuygpcX6yeeK1EOWrJHSY1nf0JUIDwySZwzycVvA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR11MB6697
X-OriginatorOrg: intel.com

T24gVGh1LCAyMDI1LTA1LTIyIGF0IDE3OjExIC0wNzAwLCBTZWFuIENocmlzdG9waGVyc29uIHdy
b3RlOg0KPiBNb3ZlIFREWCBoYXJkd2FyZSBzZXR1cCB0byB0ZHguYywgYXMgdGhlIGNvZGUgaXMg
b2J2aW91c2x5IFREWCBzcGVjaWZpYywNCj4gY28tbG9jYXRpbmcgdGhlIHNldHVwIHdpdGggdGR4
X2JyaW5ndXAoKSBtYWtlcyBpdCBlYXNpZXIgdG8gc2VlIGFuZA0KPiBkb2N1bWVudCB0aGUgc3Vj
Y2Vzc19kaXNhYmxlX3RkeCAiZXJyb3IiIHBhdGgsIGFuZCBjb25maWd1cmluZyB0aGUgVERYDQo+
IHNwZWNpZmljIGhvb2tzIGluIHRkeC5jIHJlZHVjZXMgdGhlIG51bWJlciBvZiBnbG9iYWxseSB2
aXNpYmxlIFREWCBzeW1ib2xzLg0KPiANCj4gU2lnbmVkLW9mZi1ieTogU2VhbiBDaHJpc3RvcGhl
cnNvbiA8c2VhbmpjQGdvb2dsZS5jb20+DQo+IA0KDQpSZXZpZXdlZC1ieTogS2FpIEh1YW5nIDxr
YWkuaHVhbmdAaW50ZWwuY29tPg0K

