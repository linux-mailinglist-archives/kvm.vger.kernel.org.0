Return-Path: <kvm+bounces-18083-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 106428CDC6A
	for <lists+kvm@lfdr.de>; Thu, 23 May 2024 23:53:51 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 3418D1C245CE
	for <lists+kvm@lfdr.de>; Thu, 23 May 2024 21:53:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0312D127E35;
	Thu, 23 May 2024 21:53:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="nug2YzR2"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 71893127E24;
	Thu, 23 May 2024 21:53:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.9
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716501186; cv=fail; b=pObypzoQ7jAzyA+XgzNPM6S6BirZH1gCwGq3usrIBrdxWplSEEt77CV6wc5IitKjGdp21Dx5Siao1Bs3pHIpoGmUfJBoPLUx3cPvf+xMRpUJMDxpA2nxBOshO9mmaF98JI61iv+51JsULDKrZiLFaJLDs0Lhm3nuXR9tx/qsC4g=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716501186; c=relaxed/simple;
	bh=AoBwdosOuUXhMIA/VLiHQG2Y2oShV2sIHgPp4RCWHBw=;
	h=Message-ID:Date:Subject:From:To:CC:References:In-Reply-To:
	 Content-Type:MIME-Version; b=mQGin+DozkdNsDdLq5OUtRM9+T0vwuLk0Wadddaxrur+SskUn1cQp8+usxVSgVH8UmlKHBB1F9CFaorsYThPK1paEXTaPlEz6sXO6zhSIcYzo5KGXcbQwQpxrZzoF/tSeCMrmQ6c06Afvyjm02eYVOOKN+MZexvrEWV8UhvYWDo=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=nug2YzR2; arc=fail smtp.client-ip=192.198.163.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1716501184; x=1748037184;
  h=message-id:date:subject:from:to:cc:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=AoBwdosOuUXhMIA/VLiHQG2Y2oShV2sIHgPp4RCWHBw=;
  b=nug2YzR2hNNkvFFJSEP63ktm3i+hYTzhCKnkprl8KdpE6FWzhcTzOADl
   ycgUcOUYghst49wRp6EBOOfQK+QVaqhW1yk1bi/8cO9Ilwt2m0Ri7Ny0d
   W+fY28016fGIGRk/30CyeS6+4xM4jHpCjpXdV4MlNbywTn9JvdVRuqSv7
   dbq0/2wpjdGr6vcchWHb1wV+GlZqtbtMxrKjeY7Aq89dxsuZB0dflorPz
   wv11tWLtmiIaW4h2fdcTgYix1wKOFzLnLyu72OYMMHp5gah5y8+L6WYyT
   YjW5FHM2HkgGDYA9QApgcKmWU88jkWq6Cp922M9ylvgG5Jqip+566LlT8
   g==;
X-CSE-ConnectionGUID: BkNoT5BATd+a+h3WXF3TXg==
X-CSE-MsgGUID: o1k0CwBTTl22hVHBGMopDQ==
X-IronPort-AV: E=McAfee;i="6600,9927,11081"; a="23523639"
X-IronPort-AV: E=Sophos;i="6.08,183,1712646000"; 
   d="scan'208";a="23523639"
Received: from fmviesa005.fm.intel.com ([10.60.135.145])
  by fmvoesa103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 May 2024 14:53:01 -0700
X-CSE-ConnectionGUID: 788+XmAIR2aslU3UC2wnpw==
X-CSE-MsgGUID: RszIB5dHSwS+VPdyCl7K/g==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.08,183,1712646000"; 
   d="scan'208";a="38218809"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by fmviesa005.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 23 May 2024 14:53:01 -0700
Received: from fmsmsx602.amr.corp.intel.com (10.18.126.82) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Thu, 23 May 2024 14:53:01 -0700
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Thu, 23 May 2024 14:53:01 -0700
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (104.47.66.40) by
 edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Thu, 23 May 2024 14:53:00 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=OZ8zeoAGUGQ3K6mH4pRJfO3wJcohrCoE9qS5AVCc75M+ABvlsbAExmIqw/lOvynRG7OlPzyxsGNOsstyIsfZ8CxEV0iwKL7nfUDAjGU+4mc/Dfrwwu8MHNnt5sMnvOKYIoYvze9xiG5e/wviMCInoNmaADEDal9MN0ssvChlCjoQmILEYFkMa0EummBBvFHQMKiJtsrGvf7yBR1MsuQyBItjEKhAqEq639rPHvxqFFGpdZuMbLtI5BOnvZF3hgqv7lVspBwZpC7Ie7L3fS4XDCNeHKfcs/bmTZ9sKrNjaFNzTpVDKpMptxtjKrvicawyX747JeEdMhwKTzdAEEKIYQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=3DLK+dhbgHWOvGfPni5jzecNHjTZ1dz76HKZE6kN0hY=;
 b=dmDkZg7pTjrdQz2nAj9g/4akx0qbSovWX+ZcDvw6a29qF2WPNHxaBFOZwaJG4wGoO0kHHJIoq0YoGCTz7r01xzFb06SMNfUG8aFQKF0pELy8WcFXFjBP2NYpPcYekjomsvYEqNDHbrMZX6JdmY5OxcAyWREkFOOgUOIlS210+BkYUtVOvjzXVVxyjs4UXKN2eb6jaU0NB+iuT/lq/+9AZu79gg+EmOTpTJiNEUvrh7+qze4ZLOTXgm2A/0anGwO4gT+3m5PZvUtgPbIjlj4D6LL05BmrSMxMnaXDWw6TWaXDJaXeiOjXSK7lDdlIGMg3tHURrpe6hnQDixDer4kBew==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from BYAPR11MB2535.namprd11.prod.outlook.com (2603:10b6:a02:be::32)
 by LV8PR11MB8486.namprd11.prod.outlook.com (2603:10b6:408:1e8::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7611.20; Thu, 23 May
 2024 21:52:54 +0000
Received: from BYAPR11MB2535.namprd11.prod.outlook.com
 ([fe80::391:2d89:2ce4:a1c7]) by BYAPR11MB2535.namprd11.prod.outlook.com
 ([fe80::391:2d89:2ce4:a1c7%5]) with mapi id 15.20.7587.035; Thu, 23 May 2024
 21:52:53 +0000
Message-ID: <be2c357e-5314-42d2-a085-a211d8a12c5f@intel.com>
Date: Thu, 23 May 2024 14:52:50 -0700
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 2/3] vfio/pci: Support 8-byte PCI loads and stores
From: Ramesh Thomas <ramesh.thomas@intel.com>
To: "Tian, Kevin" <kevin.tian@intel.com>, Gerd Bayer <gbayer@linux.ibm.com>,
	Alex Williamson <alex.williamson@redhat.com>, Jason Gunthorpe <jgg@ziepe.ca>,
	Niklas Schnelle <schnelle@linux.ibm.com>
CC: "kvm@vger.kernel.org" <kvm@vger.kernel.org>, "linux-s390@vger.kernel.org"
	<linux-s390@vger.kernel.org>, Ankit Agrawal <ankita@nvidia.com>, Yishai Hadas
	<yishaih@nvidia.com>, Halil Pasic <pasic@linux.ibm.com>, Julian Ruess
	<julianr@linux.ibm.com>, Ben Segal <bpsegal@us.ibm.com>
References: <20240425165604.899447-1-gbayer@linux.ibm.com>
 <20240425165604.899447-3-gbayer@linux.ibm.com>
 <d29a8b0d-37e6-4d87-9993-f195a5b7666c@intel.com>
 <BN9PR11MB5276194485E102747890C54D8CE92@BN9PR11MB5276.namprd11.prod.outlook.com>
 <a0acd183-a3b9-45cb-b0cb-4c7f0ec0b380@intel.com>
Content-Language: en-US
In-Reply-To: <a0acd183-a3b9-45cb-b0cb-4c7f0ec0b380@intel.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: MW3PR06CA0002.namprd06.prod.outlook.com
 (2603:10b6:303:2a::7) To BYAPR11MB2535.namprd11.prod.outlook.com
 (2603:10b6:a02:be::32)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BYAPR11MB2535:EE_|LV8PR11MB8486:EE_
X-MS-Office365-Filtering-Correlation-Id: c75218ed-aacd-4548-5dd7-08dc7b72b2e8
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230031|366007|7416005|376005|1800799015;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?NGdkYWs4dWcxY3NRSWdEcEFCc1ZTT1MxZzNOcUh2bjVlSEkrTWVwSjhyNktv?=
 =?utf-8?B?ZmVCL1ROd1o0UzN3d2ZCWTBOa3Zzd2ZtZXRjdFBVOWVqN0ZLc05pR05Eb3Z3?=
 =?utf-8?B?Z3Q1ZFUybkp2LzhmYUt0R2JESTNhN1dQazVSRkRwSHlVNWEzaWtMU1VGM3Zj?=
 =?utf-8?B?Vm51Sms0THBmR2lJWlhXYTNFcHI1WndxSHEycjVzYWZDdXQ3ZkoxaEdad0E0?=
 =?utf-8?B?bFl3Q3daYjhoeEw1R1JETGk1N0JMMGxxVjR2OWp1bzFKWG0xSHdaOG10cm84?=
 =?utf-8?B?L2k5TGxRWWtGbUE2dXkxcFFUVlZGaGRrNW9kdlA4a1lLejRsMzJPaUc0aDFF?=
 =?utf-8?B?RURHcSs0MEIwaDh5YUdZaWppcjdjL0lhaU1nOGV4bDhVR2pyeko5c2MvYU85?=
 =?utf-8?B?aEtBVzVCZ0ZXWUJodXFZc08wTW1TWHZmMnhnZCtidTNpdHZBeUJzYkpSZi9R?=
 =?utf-8?B?NkZ5empmRFBSYUs5alE5Q1ZUOThXbFRaeElDOTdiOEdDcGszbFFyVDJzTTMx?=
 =?utf-8?B?L0I0cVNlcFJBZmxXQmNMT3NQR1BtM3ZSdm5OUHVLTk1Vc21JVXdaTzJCYnhC?=
 =?utf-8?B?ZDducGhLeXVRUFZvRHFNYjdaU2JGQ1dKN1hkcHh0NXZySFRaM21oQXpnRmlZ?=
 =?utf-8?B?SHhoM0JVRnF2aGIzSjhxZ05EMS85OUczV2dFSVdiQStjYlNJbHpwSlJGZi9l?=
 =?utf-8?B?ZWlnL3hKMUp0Z0JUSjZDSFlIVFYxQXNkalh0ZklNdDU0WDNkTVJVb0liRHZs?=
 =?utf-8?B?NnIrNnFlK2RrdHY4cWhjR29zekF0QjlKbEV3ZGFzWERuK2JlSi9QR2RzWXds?=
 =?utf-8?B?V0RzUndYdkNtT3hiZDZmZWVKUk1rSTN3MWM2SmN0M0h5VWIrZVNoelNhQzMx?=
 =?utf-8?B?dFlFZXRacERvQjgzcjk1Zm9pUnBWcXpyV0h2Um1uYlJ4WWhaWnM5UUVTWUNr?=
 =?utf-8?B?VEZObkVZaVlLSkVYSjZiTU9RYW5mOU9QRWhLQ21PcXVLMUJ6ajZxbEkrb3J3?=
 =?utf-8?B?WDdldTVhS3NORzViYUtTMmtmWmdlUEs5QlplT1Vjay91V2xwMFpjYXlENFZP?=
 =?utf-8?B?dnZPcVNSbzhxN2J2ZVMwVXBSdlNtaGdYUU1UcTQzRE9UL053TVVVd0pKNFNq?=
 =?utf-8?B?dUdVVUtIbEpZS2kzN1Z3R3BRdXM4QzFOc0c2NXdNUG0yUkNnUktjQ2dHamRW?=
 =?utf-8?B?UnlJR29Rbmc0YkZ4MERWZTRYZU8vaDF4OFVKS1p1UUxPL0hSTXh0a3RxdFYx?=
 =?utf-8?B?MzAxWXFTejlXYkp3S05YczltcGpCOWtQTVhYdnRPcGtMRm1xeEIwaEtaNGNG?=
 =?utf-8?B?bTBNRlRUMXg1M2l3bVNvc2d4a0lwU0ZzVzdPdnpiNmh0ejFLbm9sQ2g0TGgr?=
 =?utf-8?B?U21RZ3ZRa0RNQ1VxZ2RZTkRzYzhxVWl0Q005TWdETzQ1Q1J4K2Q5RE45OTlW?=
 =?utf-8?B?dm5MRW8xY1R5K0NheEw0Rm9qYTRmSVJVZ05hZXZncHc5TnU5d3IydlRHaDJj?=
 =?utf-8?B?eWs2R25KbWdReEphUzRrRFFmdWVqSDZ4ZTRZVStpY3NaRUpGbTdCWGZ4anQw?=
 =?utf-8?B?RnZvcmJyRkZ5cEk5bmErVUNWaXFTWmZRajVPNCtDNDd6Z0JxeDlzOFJGcytm?=
 =?utf-8?B?dmRvVlNyWHZZc2FaL1hBWTVVSjRpcWpTVWZEczV1KzlCb044aS9QUDgrRm9q?=
 =?utf-8?B?cStHZzN5bWRQVHFDVVMwV2t2MkFlYlhOVlU4QzE0UFozVlJRajBMMTVBPT0=?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR11MB2535.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(366007)(7416005)(376005)(1800799015);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?VUxPc2xQUXA2ekF1SkxGd3JubSt5a00wR0duUncxN1BJalIzZk4zL2xvTEJo?=
 =?utf-8?B?U2E0aWZQL3d1TlBOV3BUYm54VnpKb1BuWTZTYUpGLzJpRjhBUEs1OFEzWFZQ?=
 =?utf-8?B?bUYxdXo4dTZQQTZpZXFFSnc2Sy9PcGYvMW1NcCs0c2RUcHlvalFUL2h5YUVp?=
 =?utf-8?B?YytrbW1SK0hQUTBuTHEwQURtSnQyRTFpUklCRWdWdE9xMEFEY0xnalZHYmg5?=
 =?utf-8?B?SlFXR3FvOXcxT2duMGpKcmpObmQvVzluMzBldG5tQUlIMWsrU1o4UlJsSXlI?=
 =?utf-8?B?SXJlNTNmZmNIS29sWC85TmNHS0dPWFd0VGhMakpxSGtQZzl1OVhmaHMrOU54?=
 =?utf-8?B?aWlsNjJ6M21tRkRrVHdYZm9yL2V4UmltY0JSd3IzVGpMM0Q4MEMwTkdYenI2?=
 =?utf-8?B?SXBIaytqdzBJd3E3cGpkQ1lBbDlScXB2a3B4RGVLS2VVR2YrenBKcmdBVzVF?=
 =?utf-8?B?MXZpS3BBWXFRaml0QUkwN2lwTkI1T2ZHWjRCcU1xTEg3TDZrL3dmcXJWNHY0?=
 =?utf-8?B?Ym1RelZWdjFPNFVLR0ZtM21FWFNWTTBlaXB3WlZ1SUNKV3hBcm54cTA3Y0pq?=
 =?utf-8?B?ay83Y25FRzdDU1VRZUpDTnNMZ1JKcXN4djZkQmFxYzRVZC9KMHp4UGowbkRE?=
 =?utf-8?B?enIvQUNNNU11RVRuSk9ZNmErdnNKekpFMCtNeGo5eVJDbk5YbDRSWTN3bHFV?=
 =?utf-8?B?bklqY1M2WERqeXR0cmJtcTJXUUdzbndVTEVKTXJNRyt1cUlxRUtibWJKNEJP?=
 =?utf-8?B?Q2lpWWFwVEtlZkFSYkRZM0wvKy9iS0UxcmNWRU5DdUxhZnJXUkpwUEkxcEN2?=
 =?utf-8?B?SU1CSE9oOXNhTTJZeWtaL3RCOXhVN09aWm4zYk5aalFGWGVZUWtMWGxMOFpr?=
 =?utf-8?B?WEY4MHltV3Z3eFRhdWxnS1dKcm9VYWw4UWUwOUsybk5pMXN3UlczR2VWN01U?=
 =?utf-8?B?MnhHWXJLVWVWZ0U5WWJFWjFCcENjRXluejk0SDl6SEZqOHB5VGN4cmNjcXF6?=
 =?utf-8?B?YXp0ZEJtN2VoT3Btczh1bC9hd2xxMVJSbTh5TFlIRm5IQ25OcXJoV2trUkR4?=
 =?utf-8?B?ekRobzNKS3c3UkRJcFdISE1ka0ZyS1ZnTFA5UHhmMXJsdDVEZXE4ZHNPTGMw?=
 =?utf-8?B?MklJN21lL3lYRjJpSGxmS003SjJLTTE5b3RXQ0E3ZzIyZU80cS9GRmI5YVJo?=
 =?utf-8?B?U2ZMdEN3Y3I0Y1NLMk8vbExvdlNJRVhXcnRIdXhlZzNNYkFjaVlHWGJ3WUUz?=
 =?utf-8?B?VFJQQUFpaEhpc000VFR4YytnL3V1R1NBS2RnTlh3b0dhL2RORStxdytuTmFr?=
 =?utf-8?B?TzNhZFZSUmtEMjEzcVRWcUZXS09tQVBYNmZMbjV6cGNUWThvTk8xc2NVQ3Jy?=
 =?utf-8?B?V3haaDNKUE9lRExyWDhWaU5IVW5Lc3BOZ1hUUUtFUE56cUJpQWVKSnJhWnM1?=
 =?utf-8?B?RHFySWFyQ2RVSENGWUEyTGRKTzRUSVVQYkkwaXZwcnBzb1FpenFjUnNxeTBk?=
 =?utf-8?B?anF4ZXE5UUdLclo4eURXYnhtZ1ZoaTZ5ajRYOVhRUE5kczYyak5keW54Nlpr?=
 =?utf-8?B?K2Z1RURKU0lNbjd6MGdNZjhneXk1M1lyLys1Uk9xVjNRZDcvZ1J1T2d2KzJz?=
 =?utf-8?B?M29NdXoyZDNiaWQrY3lGVnh0QStPWFpka1V3MkROSlR6blhSKyt6Zjd6UE8v?=
 =?utf-8?B?aDJjQ05pT2ZGTnRLb2RQaU1ESVgySlJrN2p2bjF4cEtBRGkvRUpFYjN0Qk9z?=
 =?utf-8?B?d0N0cG54ZG9zRTZMRnJPMHdqY0hpc0F0QmdIN2RZY2hSc0N5ZUV4M2NRNjd6?=
 =?utf-8?B?Nmd2WnhpRWNTZ3B4RmtTeVQ2UzJ5dm8yYTFPVVFHeHVDN1pTMjZpb2hWY0lO?=
 =?utf-8?B?MmtTdlhYZ2ExZHVDOUpXd2hscVk2dG1SWUxxdjZHRE56M3VVNVdaaU1Td2dV?=
 =?utf-8?B?ZzE5YUJkQUZSV2o5TW1JdnEzWVBiMEdLNVQ4bVJ5L2hzNHY0aEk0VlBpeEE0?=
 =?utf-8?B?NVhQaHR2bjZYNHdyQjlnTWQyV2habUZNdDVwN2xwZk9uTHZEMGdFVWswK2tY?=
 =?utf-8?B?MGRqQlJmek1nbHlicFpEbUJDRStobVZkWjRxNzQzQTM2MXF1Slo0WlBEeXM4?=
 =?utf-8?Q?oKSPj4R6wYuJjF+zKfPEFidGE?=
X-MS-Exchange-CrossTenant-Network-Message-Id: c75218ed-aacd-4548-5dd7-08dc7b72b2e8
X-MS-Exchange-CrossTenant-AuthSource: BYAPR11MB2535.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 May 2024 21:52:53.9182
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: fHSGD9COoCxKLXVZZINIgB+F7YhM6ZxfHtGc+LPcHNY9PU/vs69a5kiyM/bhPs1l1TAFcey1NIU0b1mizu78vw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV8PR11MB8486
X-OriginatorOrg: intel.com

On 5/22/2024 5:11 PM, Ramesh Thomas wrote:
> On 5/20/2024 2:02 AM, Tian, Kevin wrote:
>>> From: Ramesh Thomas <ramesh.thomas@intel.com>
>>> Sent: Friday, May 17, 2024 6:30 PM
>>>
>>> On 4/25/2024 9:56 AM, Gerd Bayer wrote:
>>>> From: Ben Segal <bpsegal@us.ibm.com>
>>>>
>>>> @@ -148,6 +155,15 @@ ssize_t vfio_pci_core_do_io_rw(struct
>>> vfio_pci_core_device *vdev, bool test_mem,
>>>>            else
>>>>                fillable = 0;
>>>>
>>>> +#if defined(ioread64) && defined(iowrite64)
>>>
>>> Can we check for #ifdef CONFIG_64BIT instead? In x86, ioread64 and
>>> iowrite64 get declared as extern functions if CONFIG_GENERIC_IOMAP is
>>> defined and this check always fails. In include/asm-generic/io.h,
>>> asm-generic/iomap.h gets included which declares them as extern 
>>> functions.
>>>
>>> One more thing to consider io-64-nonatomic-hi-lo.h and
>>> io-64-nonatomic-lo-hi.h, if included would define it as a macro that
>>> calls a function that rw 32 bits back to back.
>>
>> I don't see the problem here. when the defined check fails it falls
>> back to back-to-back vfio_pci_core_iordwr32(). there is no need to
>> do it in an indirect way via including io-64-nonatomic-hi-lo.h.
> 
> The issue is iowrite64 and iowrite64 was not getting defined when 
> CONFIG_GENERIC_IOMAP was not defined, even though the architecture 

Sorry, I meant they were not getting defined when CONFIG_GENERIC_IOMAP 
*was defined*. The only definitions of ioread64 and iowrite64 in the 
code path are in asm/io.h where they are surrounded by #ifndef 
CONFIG_GENERIC_IOMAP

> implemented the 64 bit rw functions readq and writeq. 
> io-64-nonatomic-hi-lo.h and io-64-nonatomic-lo-hi.h define them and map 
> them to generic implementations in lib/iomap.c. The implementation calls 
> the 64 bit rw functions if present, otherwise does 32 bit back to back 
> rw. Besides it also has sanity checks for port numbers in the iomap 
> path. I think it is better to rely on this existing generic method than 
> implementing the checks at places where iowrite64 and ioread64 get 
> called, at least in the IOMAP path.


