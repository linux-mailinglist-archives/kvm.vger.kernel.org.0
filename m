Return-Path: <kvm+bounces-5972-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 12D4982923E
	for <lists+kvm@lfdr.de>; Wed, 10 Jan 2024 02:53:46 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 5933D289068
	for <lists+kvm@lfdr.de>; Wed, 10 Jan 2024 01:53:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BCC4C17E4;
	Wed, 10 Jan 2024 01:53:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="eT/IcJm4"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1070B1375
	for <kvm@vger.kernel.org>; Wed, 10 Jan 2024 01:53:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1704851617; x=1736387617;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=KyF8HSWgqOr6eYRaO4eZxypHfhhG/ITzYxutnGnqPfA=;
  b=eT/IcJm4VuAxJDDxigZKmhY7RIDQl3Y/YRCNNDdGLxKnzR7CWFr6UoTG
   xwyZvJPUCqCkqI7BfLuI4+SFVE/zDZBn/oBPNE8TAkpsV5QfwkQFt7gFq
   4z19npAeoKMuJAKqPhDNpssYjdIipFAvrrZrEFG4QfKFMJzhes7ya7V6Q
   Zvk5Zc3Hs2OR7OKgzauLqR/p2UyOXOGVJY3rEuHyiRf6eNagnZbsDVSA/
   iuXvTJid5IA7PpKXc5hLWr01AfszagyAWb7F5xW+gZZdKydjb2BDHMeKG
   YrMhZhCmzKxMfDWDQ2Tm8pxcaF+PKV7n6Wf5tw/Bev+b509FbMTotqUqM
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10947"; a="19879173"
X-IronPort-AV: E=Sophos;i="6.04,184,1695711600"; 
   d="scan'208";a="19879173"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by fmvoesa101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Jan 2024 17:53:30 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10947"; a="775059866"
X-IronPort-AV: E=Sophos;i="6.04,184,1695711600"; 
   d="scan'208";a="775059866"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by orsmga007.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 09 Jan 2024 17:53:27 -0800
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Tue, 9 Jan 2024 17:53:26 -0800
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Tue, 9 Jan 2024 17:53:26 -0800
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35 via Frontend Transport; Tue, 9 Jan 2024 17:53:26 -0800
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (104.47.57.168)
 by edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.35; Tue, 9 Jan 2024 17:53:26 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=PT+1+ONq0T5NTC/dWVBFLrYmRx1BTbAZCCS612qccjO2UYiu3Aq+w+I+od+S91pbi/9Sykwd+yyKCAi3J0Wwnfc5wgDiWwDQNw5VQ7Q7Ij7XIOYTi+rvt1iH5ha3cvbZaYUb2Bf12s+4sdqEyFtdDo83PDflyz2RH3VBML47IY9OYK7EnoMgeFYeX1GXNWA+0Vi9SHEBsYpyjeNlLoiTQpC9aWH1dE9fsvuJ/BCTlORpvAsxbF0IN/z0xQm4bzmin06eIKNQlq7V9jzNWUPxUYV5xkvTInMX2b3c+N27iM9rSMS2U7Tvi1YG1ZtXbyGVoVGER5EoHW+Dsioz1yg0Yg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=KyF8HSWgqOr6eYRaO4eZxypHfhhG/ITzYxutnGnqPfA=;
 b=RwRS91pKc+igOGMWsZIlxGK+smj3R3p1VacZsvW1Dq51oLHHCJJKGxyJoNFehNWdW51DUP2vs0yYN+WgqL2do1oC4V114J5xp9sVXOBk9GNwTOahk+aEMn2nY9e7B8GZT8xj6IaJqvOyyHNgcbRlNQGg2lO+CJy8J0l1VyN2oz4E96p0kfKx2OpsEjx62SaSwEXbsWHECKKCKH8Wx2SGcJQYNV2Ac5wP9EiXxjNqk/WE/GZqY+5tfr+b2KR3m1AEFU80outJERFTOYLZHl2MPlsJn0qZHkaHNb98/tSjHu3oWxljoMoNOTPpUnWhdxpoCi2E7LDU+MHmjwI3UfEbeg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from DS0PR11MB6373.namprd11.prod.outlook.com (2603:10b6:8:cb::20) by
 MW4PR11MB7150.namprd11.prod.outlook.com (2603:10b6:303:213::9) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.7159.23; Wed, 10 Jan 2024 01:53:24 +0000
Received: from DS0PR11MB6373.namprd11.prod.outlook.com
 ([fe80::9ce6:c8d3:248e:448a]) by DS0PR11MB6373.namprd11.prod.outlook.com
 ([fe80::9ce6:c8d3:248e:448a%5]) with mapi id 15.20.7159.020; Wed, 10 Jan 2024
 01:53:23 +0000
From: "Wang, Wei W" <wei.w.wang@intel.com>
To: "Li, Xiaoyao" <xiaoyao.li@intel.com>, Paolo Bonzini <pbonzini@redhat.com>,
	David Hildenbrand <david@redhat.com>, Igor Mammedov <imammedo@redhat.com>,
	"Michael S . Tsirkin" <mst@redhat.com>, Marcel Apfelbaum
	<marcel.apfelbaum@gmail.com>, Richard Henderson
	<richard.henderson@linaro.org>, Peter Xu <peterx@redhat.com>,
	=?utf-8?B?UGhpbGlwcGUgTWF0aGlldS1EYXVkw6k=?= <philmd@linaro.org>, "Cornelia
 Huck" <cohuck@redhat.com>, =?utf-8?B?RGFuaWVsIFAgLiBCZXJyYW5nw6k=?=
	<berrange@redhat.com>, Eric Blake <eblake@redhat.com>, Markus Armbruster
	<armbru@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>
CC: "qemu-devel@nongnu.org" <qemu-devel@nongnu.org>, "kvm@vger.kernel.org"
	<kvm@vger.kernel.org>, Michael Roth <michael.roth@amd.com>, "Sean
 Christopherson" <seanjc@google.com>, Claudio Fontana <cfontana@suse.de>,
	"Gerd Hoffmann" <kraxel@redhat.com>, Isaku Yamahata
	<isaku.yamahata@gmail.com>, "Qiang, Chenyi" <chenyi.qiang@intel.com>
Subject: RE: [PATCH v3 06/70] kvm: Introduce support for memory_attributes
Thread-Topic: [PATCH v3 06/70] kvm: Introduce support for memory_attributes
Thread-Index: AQHaF5O24VxNhOyFz0ifdu/xEp7Ej7Cl0dCggA2oA4CAAEbrQIAAGMwAgAAVlUCAHWBegIAAWXZAgABaugCAAJVo4A==
Date: Wed, 10 Jan 2024 01:53:23 +0000
Message-ID: <DS0PR11MB63734D62ABBDADC229F95526DC692@DS0PR11MB6373.namprd11.prod.outlook.com>
References: <20231115071519.2864957-1-xiaoyao.li@intel.com>
 <20231115071519.2864957-7-xiaoyao.li@intel.com>
 <DS0PR11MB6373D69ABBF4BDF7120438ACDC8EA@DS0PR11MB6373.namprd11.prod.outlook.com>
 <cc568b63-a129-4b23-8ac8-313193ea8126@intel.com>
 <DS0PR11MB63737AFCA458FA78423C0BB7DC95A@DS0PR11MB6373.namprd11.prod.outlook.com>
 <a0289f6d-2008-48d7-95fb-492066c38461@intel.com>
 <DS0PR11MB63730289975875A5B90D078CDC95A@DS0PR11MB6373.namprd11.prod.outlook.com>
 <1bc76559-20e7-4b20-a566-9491711f7a21@intel.com>
 <DS0PR11MB637348501D03A18EE7C394C4DC6A2@DS0PR11MB6373.namprd11.prod.outlook.com>
 <bd2679e7-46af-4875-ba42-b4ea413ec0a1@intel.com>
In-Reply-To: <bd2679e7-46af-4875-ba42-b4ea413ec0a1@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DS0PR11MB6373:EE_|MW4PR11MB7150:EE_
x-ms-office365-filtering-correlation-id: fbf21f69-2c54-4865-0054-08dc117eee2c
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: kfziy83oGjfU+Xp8VTXwA2kvJxwQ1u/eYeWqq8a6s7nSjJrs76LQ/65Tn6sDTBKz4IDxjOMKLk3nUy40EocftxvKscu4Iev5NDAL6bkSgBRin+eOA1o2Cnrg6fDw/UlMjN3atULVWHeDZZT4Ko+P9VWmktXEIoxKP2CdDE6f87BIwnVtomsaFAE98pxAnt8LEm2suCu7fEJGBNF554G4UkPwNuZKt1kECD0vUc+1eZ3ebSsUHRUyMFmNmrOnhzwYYE4sdDV5bXmx9WK14uNxlM4Z1faJuY8kekjrz0FRo3gztQTspj2b/fCBm64HeGE1PXZx5C/b8qL7b5PCOtFWAP83/O0NfD8QuXEQXWT58LtnWLnFYYlq3aK8jUEpYB79qybTZ1o1IAMexvlNXoqNC6IxSMH4tV+d6+RG0Z4aehbrzvEZHmKaOwhwYnWEbpQGNaW4exLKPZH935m1RIsrJWxpxiqHlAsTgnXqfKB2WGdl53zwPI3qJkJDU9xHYi5RnH0GKMUV+W/DBYJNNN4q4yvHeH1jMWAQJf0IejVoX12yQ+E3curQA9U7hxWkd4MFO3QCpnj1KQdcKFUHdZFwFr/180I+rlFiCX3jcfLyqMFOli35zmJXlLDbQDlDAPW00KCmoEOUqXNxA/nUqJAs8w==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR11MB6373.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(39860400002)(376002)(396003)(366004)(136003)(346002)(230922051799003)(451199024)(1800799012)(186009)(64100799003)(7416002)(5660300002)(2906002)(33656002)(6506007)(86362001)(38100700002)(82960400001)(478600001)(53546011)(107886003)(38070700009)(9686003)(122000001)(26005)(71200400001)(7696005)(316002)(8936002)(52536014)(8676002)(76116006)(41300700001)(4326008)(110136005)(54906003)(66946007)(921011)(64756008)(66446008)(66556008)(66476007)(55016003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?azUwQi9xTnd2M0dOcm13b08wUWlEZTdPdGNZNlBVSU90ZFhsMjUxU0dKR2sr?=
 =?utf-8?B?V29vS2ZyTHd0MUlmSnhMVlozRW1ySlBYa2J0TktwK0VJUVdsbmYySXUrVEZv?=
 =?utf-8?B?UHJXZ1NIRVZ4amFnck1iaVgrMmVvNk1lMlJhWks1K0RHZDdwSkpqc0Vjc1JV?=
 =?utf-8?B?SnVhRUN1K1MrWVlJZnQ5aVBrMWcxM0crbFdKcVkzSmNKZFZmWFlXTy9zZzBT?=
 =?utf-8?B?cWZEUGZMUDliYkg4cTBGTm1oMW1KWGxaSFRHR0lxdkZvZlYwN1FQV1NzNWxu?=
 =?utf-8?B?VlVKRnlFdEo0N2RiNEplWHZ6NGZEQ09Na1FOL3dyUlBjYlJleXlnZERKd0Jp?=
 =?utf-8?B?T1JTczgwbU5tRHozaG9wd3IrQ2lpb0JQOEd1d3Y5ZUdoRmhLbEZFYkRIVjBK?=
 =?utf-8?B?UTNpUk9uRUhHWjNPcy93MWxVN21CTXh3OEM0aWx6bmRWSitiNUR2RWw3eEVF?=
 =?utf-8?B?MmJEVzlma293VFpDUFRpWHBHV3pEdExQL2Niak0zL1FxU09DRzZxb2ExNzQ3?=
 =?utf-8?B?RVAwQ3dzOEpEU2tTcmNhaUZnOE5RdlY2emgxNzNrdjFQaWdiYllQTEl3cnBE?=
 =?utf-8?B?TXhQM0ZnUFFIUUZDWlFqU2s4WGVrMTFJMDJ0aTdzVWIrSnVhZzhWMnk3Q1BO?=
 =?utf-8?B?V3MwVk40cXlZbmNnQWRPWGFwbmRSYTJvRFpwTHVUc3drVVY2YTBEZEtUZk5P?=
 =?utf-8?B?Q3JaMitxNDBDMi81MUNLdEg0TlFKS0xNQ0s0NHRLbisrNlAvV3J1aWdDYW80?=
 =?utf-8?B?S1kwR0ttN0pVKzdLQlhYb1ArRUVyZzJML3lia3lxclhhRmJQNWJRS2VaaUVp?=
 =?utf-8?B?Q3pMM1UxQ3ZVS0ZCZkZ4MVRIZDB2ODlicWVJaUcvVW91U1ZKbjJhMlZtVG1h?=
 =?utf-8?B?VFBEa1NVQnBsOFlXTXRvOHhzQWl6U3F4UGNvY2RURTY1YzhNb013OXYxYnZ0?=
 =?utf-8?B?VlNaQkZuQ0tFa2tOemR4RU9Nd1BNYUFLSEVIcGliQy9KY0dudmJYaTlpUjRx?=
 =?utf-8?B?NGRSdm5kSjQ5OFU5M0lNdStLTXlmUkZXTnZKMUttc2hnT0xOSFRwdVB4Skt0?=
 =?utf-8?B?QkIyVXc2alZHeFZzcXAzZW50b2hPZ2lJdWlCbHBmR0g2SFdSaHErVmlhdjdI?=
 =?utf-8?B?L0xYZUVRbXJHK002MW9WTFo1dVRQcjJLczA0ZjJGenNJcXpVQWxLbDNJSnRh?=
 =?utf-8?B?WGJxb1BNK3BLUGpTcFNIVDQ5eUZ5RTMyMTBPUDRueVV6QmY3YkZndzZqQTdn?=
 =?utf-8?B?cVhIYVV4VWYzTWZZbjRmZEVvdGFjcDI5aExkUHZjRnhnTzRuWHQ4U25QcjNS?=
 =?utf-8?B?dGNEaG1uK3ZMRXJKQWpVUDBVUkc1OXJ0aFl0eWJ4cjcwb3RMZXZwcEE2eW02?=
 =?utf-8?B?WHJYbjhuWGpZR29hSHExWWVuQVZyWVVBU0gzZUo1Y1FxWnB1dWlRQkY5MWVS?=
 =?utf-8?B?MHNwajRIV3dYaDhQQjZnV1Rqemg2enkvamJmMDk5aU42eFRKTjk5UjI2Qy9O?=
 =?utf-8?B?Sm1rQlZRZVBJU3pJdGludlkrSkRwYzk4bEd0VzdxOVYxN0I2RG1QWjN6akZH?=
 =?utf-8?B?Um5UamJzS1FrS1ZzcHQwR3ltV1MrMFlVbi91YUF3ZkJoR085RjFleHhiZmxR?=
 =?utf-8?B?aFlEcFU0b092Wm5VMm1PcTJWVDZZeDVIcTdtYzNOU0lsTzVsaGIrZmNOVUhs?=
 =?utf-8?B?dUJhQ3V3NVgwR0xWRUtORFFMSi9QZDhlWStRS2FZa2RGbGV5SUNlWVJGaWRz?=
 =?utf-8?B?Ui9ZczdvdDcxSjZadEE2QTF1Y0RuTEpnaVN5c3lBeU5XazA0SE4raDBDb3Bq?=
 =?utf-8?B?N0ZLVzh0RmxBMHVVbjYwU3pMMGpudmcrUllhMzBnMGo4VlZJL3REYTVkKzdL?=
 =?utf-8?B?MTN2ejM1UmhRTGR6OWQySEhGbHZCWDNGYkxLNzcraWE0NWh0VTZVWDVBbnpX?=
 =?utf-8?B?N0hSOVlMVFdoOTNFYjg5QnFabDRXZE1LcmxMUlFTTSs4eGlFMU5sMENzdHdS?=
 =?utf-8?B?ZVhla2tHTDBnV3RodmduWUEwcS8wQ1Z2S1ZzMTBDd1UrOUo3djNlTTdHa3c4?=
 =?utf-8?B?TmUwQ3lXaVF3UXF1MHhMVDVwN21zc01QcXFNcE0yYUdTbnJxRUtndWpJcjB3?=
 =?utf-8?Q?DaiSx+68ON4MU8WAO9adC7fn7?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DS0PR11MB6373.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fbf21f69-2c54-4865-0054-08dc117eee2c
X-MS-Exchange-CrossTenant-originalarrivaltime: 10 Jan 2024 01:53:23.8584
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: fm+1GnNIWsgvluSyaizNYTHMSJiCf5cvullTzSVQT1Eo9VrKYx/EByYRL4o8cJMmOilJQcKGqT7ZXIEnGaF6qw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR11MB7150
X-OriginatorOrg: intel.com

T24gV2VkbmVzZGF5LCBKYW51YXJ5IDEwLCAyMDI0IDEyOjMyIEFNLCBMaSwgWGlhb3lhbyB3cm90
ZToNCj4gT24gMS85LzIwMjQgMTA6NTMgUE0sIFdhbmcsIFdlaSBXIHdyb3RlOg0KPiA+IE9uIFR1
ZXNkYXksIEphbnVhcnkgOSwgMjAyNCAxOjQ3IFBNLCBMaSwgWGlhb3lhbyB3cm90ZToNCj4gPj4g
T24gMTIvMjEvMjAyMyA5OjQ3IFBNLCBXYW5nLCBXZWkgVyB3cm90ZToNCj4gPj4+IE9uIFRodXJz
ZGF5LCBEZWNlbWJlciAyMSwgMjAyMyA3OjU0IFBNLCBMaSwgWGlhb3lhbyB3cm90ZToNCj4gPj4+
PiBPbiAxMi8yMS8yMDIzIDY6MzYgUE0sIFdhbmcsIFdlaSBXIHdyb3RlOg0KPiA+Pj4+PiBObyBu
ZWVkIHRvIHNwZWNpZmljYWxseSBjaGVjayBmb3IgS1ZNX01FTU9SWV9BVFRSSUJVVEVfUFJJVkFU
RQ0KPiA+PiB0aGVyZS4NCj4gPj4+Pj4gSSdtIHN1Z2dlc3RpbmcgYmVsb3c6DQo+ID4+Pj4+DQo+
ID4+Pj4+IGRpZmYgLS1naXQgYS9hY2NlbC9rdm0va3ZtLWFsbC5jIGIvYWNjZWwva3ZtL2t2bS1h
bGwuYyBpbmRleA0KPiA+Pj4+PiAyZDlhMjQ1NWRlLi42M2JhNzRiMjIxIDEwMDY0NA0KPiA+Pj4+
PiAtLS0gYS9hY2NlbC9rdm0va3ZtLWFsbC5jDQo+ID4+Pj4+ICsrKyBiL2FjY2VsL2t2bS9rdm0t
YWxsLmMNCj4gPj4+Pj4gQEAgLTEzNzUsNiArMTM3NSwxMSBAQCBzdGF0aWMgaW50DQo+IGt2bV9z
ZXRfbWVtb3J5X2F0dHJpYnV0ZXMoaHdhZGRyDQo+ID4+Pj4gc3RhcnQsIGh3YWRkciBzaXplLCB1
aW50NjRfdCBhdHRyKQ0KPiA+Pj4+PiAgICAgICAgIHN0cnVjdCBrdm1fbWVtb3J5X2F0dHJpYnV0
ZXMgYXR0cnM7DQo+ID4+Pj4+ICAgICAgICAgaW50IHI7DQo+ID4+Pj4+DQo+ID4+Pj4+ICsgICAg
aWYgKChhdHRyICYga3ZtX3N1cHBvcnRlZF9tZW1vcnlfYXR0cmlidXRlcykgIT0gYXR0cikgew0K
PiA+Pj4+PiArICAgICAgICBlcnJvcl9yZXBvcnQoIktWTSBkb2Vzbid0IHN1cHBvcnQgbWVtb3J5
IGF0dHIgJWx4XG4iLCBhdHRyKTsNCj4gPj4+Pj4gKyAgICAgICAgcmV0dXJuIC1FSU5WQUw7DQo+
ID4+Pj4+ICsgICAgfQ0KPiA+Pj4+DQo+ID4+Pj4gSW4gdGhlIGNhc2Ugb2Ygc2V0dGluZyBhIHJh
bmdlIG9mIG1lbW9yeSB0byBzaGFyZWQgd2hpbGUgS1ZNDQo+ID4+Pj4gZG9lc24ndCBzdXBwb3J0
IHByaXZhdGUgbWVtb3J5LiBBYm92ZSBjaGVjayBkb2Vzbid0IHdvcmsuIGFuZA0KPiA+Pj4+IGZv
bGxvd2luZyBJT0NUTA0KPiA+PiBmYWlscy4NCj4gPj4+DQo+ID4+PiBTSEFSRUQgYXR0cmlidXRl
IHVzZXMgdGhlIHZhbHVlIDAsIHdoaWNoIGluZGljYXRlcyBpdCdzIGFsd2F5cyBzdXBwb3J0ZWQs
DQo+IG5vPw0KPiA+Pj4gRm9yIHRoZSBpbXBsZW1lbnRhdGlvbiwgY2FuIHlvdSBmaW5kIGluIHRo
ZSBLVk0gc2lkZSB3aGVyZSB0aGUgaW9jdGwNCj4gPj4+IHdvdWxkIGdldCBmYWlsZWQgaW4gdGhh
dCBjYXNlPw0KPiA+Pg0KPiA+PiBJJ20gd29ycnlpbmcgYWJvdXQgdGhlIGZ1dHVyZSBjYXNlLCB0
aGF0IEtWTSBzdXBwb3J0cyBvdGhlciBtZW1vcnkNCj4gPj4gYXR0cmlidXRlIHRoYW4gc2hhcmVk
L3ByaXZhdGUuIEZvciBleGFtcGxlLCBLVk0gc3VwcG9ydHMgUldYIGJpdHMNCj4gPj4gKGJpdCAw
DQo+ID4+IC0gMikgYnV0IG5vdCBzaGFyZWQvcHJpdmF0ZSBiaXQuDQo+ID4NCj4gPiBXaGF0J3Mg
dGhlIGV4YWN0IGlzc3VlPw0KPiA+ICsjZGVmaW5lIEtWTV9NRU1PUllfQVRUUklCVVRFX1JFQUQg
ICAgICAgICAgICAgICAoMVVMTCA8PCAyKQ0KPiA+ICsjZGVmaW5lIEtWTV9NRU1PUllfQVRUUklC
VVRFX1dSSVRFICAgICAgICAgICAgICgxVUxMIDw8IDEpDQo+ID4gKyNkZWZpbmUgS1ZNX01FTU9S
WV9BVFRSSUJVVEVfRVhFICAgICAgICAgICAgICAgICAgKDFVTEwgPDwgMCkNCj4gPg0KPiA+IFRo
ZXkgYXJlIGNoZWNrZWQgdmlhDQo+ID4gImlmICgoYXR0ciAmIGt2bV9zdXBwb3J0ZWRfbWVtb3J5
X2F0dHJpYnV0ZXMpICE9IGF0dHIpIiBzaGFyZWQgYWJvdmUNCj4gPiBpbiBrdm1fc2V0X21lbW9y
eV9hdHRyaWJ1dGVzLg0KPiA+IEluIHRoZSBjYXNlIHlvdSBkZXNjcmliZWQsIGt2bV9zdXBwb3J0
ZWRfbWVtb3J5X2F0dHJpYnV0ZXMgd2lsbCBiZSAweDcuDQo+ID4gQW55dGhpbmcgdW5leHBlY3Rl
ZD8NCj4gDQo+IFNvcnJ5IHRoYXQgSSB0aG91Z2h0IGZvciB3cm9uZyBjYXNlLg0KPiANCj4gSXQg
ZG9lc24ndCB3b3JrIG9uIHRoZSBjYXNlIHRoYXQgS1ZNIGRvZXNuJ3Qgc3VwcG9ydCBtZW1vcnlf
YXR0cmlidXRlLCBlLmcuLA0KPiBhbiBvbGQgS1ZNLiBJbiB0aGlzIGNhc2UsICdrdm1fc3VwcG9y
dGVkX21lbW9yeV9hdHRyaWJ1dGVzJyBpcyAwLCBhbmQgJ2F0dHInIGlzDQo+IDAgYXMgd2VsbC4N
Cg0KSG93IGlzIHRoaXMgZGlmZmVyZW50IGluIHlvdXIgZXhpc3RpbmcgaW1wbGVtZW50YXRpb24/
DQoNClRoZSBvZmZpY2lhbCB3YXkgb2YgZGVmaW5pbmcgYSBmZWF0dXJlIGlzIHRvIHRha2UgYSBi
aXQgKGJhc2VkIG9uIHRoZSBmaXJzdCBmZWF0dXJlLA0KKl9QUklWQVRFLCBkZWZpbmVkKS4gVXNp
bmcgMCBhcyBhbiBhdHRyIGlzIGEgYml0IG1hZ2ljIGFuZCBpdCBwYXNzZXMgYWxsIHRoZSAiJiIg
YmFzZWQgY2hlY2suDQpCdXQgdXNpbmcgaXQgZm9yICpfU0hBUkVEIGxvb2tzIGZpbmUgdG8gbWUg
YXMgc2VtYW50aWNhbGx5IG1lbW9yeSBjYW4gYWx3YXlzIGJlIHNoYXJlZA0KYW5kIHRoZSBpb2N0
bCB3aWxsIHJldHVybiB3aXRoIC1FTk9UVFkgYW55d2F5IGluIHlvdXIgbWVudGlvbmVkIGNhc2Uu
DQo=

