Return-Path: <kvm+bounces-5466-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id C878C82248B
	for <lists+kvm@lfdr.de>; Tue,  2 Jan 2024 23:09:11 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 71024286FBE
	for <lists+kvm@lfdr.de>; Tue,  2 Jan 2024 22:09:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 97D401802A;
	Tue,  2 Jan 2024 22:06:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="LFTUNIgP"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 266D3179AE;
	Tue,  2 Jan 2024 22:06:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1704233197; x=1735769197;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=3AZ7RQ/UaGnQPAdKdGT39AX9H5SWFi3wrLzKiPii1Eg=;
  b=LFTUNIgPBeC9BkvSeNOsPDNSPNfBT38SeHV5caMm28TnI8SF3JxHqpip
   MbsecVgVTH3sxnETnNvG6qGlc0033CiIvO+g9E5hKpRjDMCYPrn5GykIZ
   9IsZba6Q8DxHIDkm/621rJmwWtzBOaFPQ1dQxuNXTux0A5EATPkXt+cQe
   GJZnEPtd+TH6Nfl9MOM94rIgKz01rYV3Oo+b5lG0TDY7Hw7TYzuqLhx9Y
   juA1aJQxl+U+mkQ8a7ZIe5U1yEwsRFZftIbPfPKNZ6S/ridQ6vh/R3+ss
   /i/KR7ErOakAaP9o9xJAynWPORoWKXfFVoSk6hSF6BRvfijtelH9ml8iK
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10941"; a="3741688"
X-IronPort-AV: E=Sophos;i="6.04,326,1695711600"; 
   d="scan'208";a="3741688"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by fmvoesa105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Jan 2024 14:06:36 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10941"; a="779805682"
X-IronPort-AV: E=Sophos;i="6.04,326,1695711600"; 
   d="scan'208";a="779805682"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by orsmga002.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 02 Jan 2024 14:06:36 -0800
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Tue, 2 Jan 2024 14:06:35 -0800
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35 via Frontend Transport; Tue, 2 Jan 2024 14:06:35 -0800
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (104.47.59.169)
 by edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.35; Tue, 2 Jan 2024 14:06:35 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=MKO1m3iK6dfaDwMIMPled7PGT/ILf9fmx8d+bMtAYQr4+SrzxsdwrksckY44UkPuaUzbC6WQmxxZzANQrdT3f4v3/x5m4ilh1dFViPMYUtT7A3aQyiZKslQRbqbYmT4dTaMGlcONh2QF2DgU7vYBsxx7/3R1hnMErKOqZwOvcj32D1qGs5i50kUZk2XyKzfpeK2Pn6+vqro5Z+++EoSerI5IKRm+tEr9oqspxMoxaDPz6f8QlGFgsP4/G2eXAgUPsvS9CPc4nJr27nD2cZ5WwhBAgt14/nX8P2nSslif0bNdyBkMyzxvI8HOEJO2khTS+zP4A1Eyp3Ocrw+Nhfrq+Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=3AZ7RQ/UaGnQPAdKdGT39AX9H5SWFi3wrLzKiPii1Eg=;
 b=XoIl+89taw3wfs9f8rxM0WVnNat3DaV4AqQLc8e5wlIol1OchK9rO+TSqz96mJNEc7x6qIGh60AwhiWW9NqW600A+pIIWJXBW1Nlu+TBfEUecLjn71fXWEKFCQxugUvVyNmyQfeyRzhLLumEn1TkPFUIe8OzbNp3U273LbF0ehitYpBEj27t6NrQM9Pl8+3TSKSUwEaGrfFQhwZPXX5AY1EYl7ijO22GqQr1458iq2PszqwkRsBmTk4/4HkuTKM1fe3Y3mIY80sPvAZ0twRzYg37x1Fk6paseEMGmU5yGv9qGLaKhexVo5Eup3TzLx5+YteOU5TdE1Fb92GlHNX16A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from SA1PR11MB6734.namprd11.prod.outlook.com (2603:10b6:806:25d::22)
 by CH0PR11MB5345.namprd11.prod.outlook.com (2603:10b6:610:b8::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7135.25; Tue, 2 Jan
 2024 22:06:28 +0000
Received: from SA1PR11MB6734.namprd11.prod.outlook.com
 ([fe80::8ccb:4e83:8802:c277]) by SA1PR11MB6734.namprd11.prod.outlook.com
 ([fe80::8ccb:4e83:8802:c277%4]) with mapi id 15.20.7135.023; Tue, 2 Jan 2024
 22:06:27 +0000
From: "Li, Xin3" <xin3.li@intel.com>
To: Borislav Petkov <bp@alien8.de>
CC: "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"linux-edac@vger.kernel.org" <linux-edac@vger.kernel.org>,
	"linux-hyperv@vger.kernel.org" <linux-hyperv@vger.kernel.org>,
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>, "xen-devel@lists.xenproject.org"
	<xen-devel@lists.xenproject.org>, "tglx@linutronix.de" <tglx@linutronix.de>,
	"mingo@redhat.com" <mingo@redhat.com>, "dave.hansen@linux.intel.com"
	<dave.hansen@linux.intel.com>, "x86@kernel.org" <x86@kernel.org>,
	"hpa@zytor.com" <hpa@zytor.com>, "Lutomirski, Andy" <luto@kernel.org>,
	"pbonzini@redhat.com" <pbonzini@redhat.com>, "seanjc@google.com"
	<seanjc@google.com>, "peterz@infradead.org" <peterz@infradead.org>,
	"jgross@suse.com" <jgross@suse.com>, "Shankar, Ravi V"
	<ravi.v.shankar@intel.com>, "mhiramat@kernel.org" <mhiramat@kernel.org>,
	"andrew.cooper3@citrix.com" <andrew.cooper3@citrix.com>,
	"jiangshanlai@gmail.com" <jiangshanlai@gmail.com>, "nik.borisov@suse.com"
	<nik.borisov@suse.com>, "Kang, Shan" <shan.kang@intel.com>
Subject: RE: [PATCH v13 01/35] x86/cpufeatures,opcode,msr: Add the WRMSRNS
 instruction support
Thread-Topic: [PATCH v13 01/35] x86/cpufeatures,opcode,msr: Add the WRMSRNS
 instruction support
Thread-Index: AQHaJ201kUjsNoxyR0GoMj8PcRD1drDG03sAgABsu1A=
Date: Tue, 2 Jan 2024 22:06:27 +0000
Message-ID: <SA1PR11MB67348F79B44BE92FD2C8F12DA861A@SA1PR11MB6734.namprd11.prod.outlook.com>
References: <20231205105030.8698-1-xin3.li@intel.com>
 <20231205105030.8698-2-xin3.li@intel.com>
 <20240102153426.GBZZQtAiWSdGAgKoIL@fat_crate.local>
In-Reply-To: <20240102153426.GBZZQtAiWSdGAgKoIL@fat_crate.local>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SA1PR11MB6734:EE_|CH0PR11MB5345:EE_
x-ms-office365-filtering-correlation-id: 055a227c-2c25-4ce6-0dfb-08dc0bdf114c
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: XObTKZMf0w8tMOeNXIcdsCiizh6S2r8eDXMx4PWH1tlONSiz80t9sdKpC7jGcwK/F1Mb7czGEcsCNfOlKoGL5zTWGoaYX11VYzsxTqM+YwnyJVMXEgv6NGC8+gCOXEoM0CIgkbdbRDWae9F9w5V+Gsj7KM3xNRjehC28N8OQyys/jcG1I6E9Vb27lNf/+b2CDmiut+7Q661zhBvIk7RqQqal0CDaJ75r8MflEa88eIhuxoOVBEMMdX34jkWa/PZZO7y3PYJi5jMNL/hObfFhazn93Enq2H1fTgqDvYlCmV+tMwxRf4HDbYEHyj0f5asSpWvKrepyJf+2Are3KIcVy3n34tgprhJjqNZWtH+x4WRJU+wn7Z+YzIN0mQR+u6LriOszIrwaBv1BiJ9JlAvhNu98Yt3lsW05AAG3hTbgmFkUhuu41vDeftxgjVEUPStAwpA0MCPFypG6TzcwswLH983Bg566kEl0DInXWumj+isVwhd5qw+s4HuXxs8FTo4PGXNseEP+lbl+EkBqz9wlgSEUmhfmbd37ubeiS8WDTrNQsf3wk8fkbQCsKST2y8nfUFxS/5yzOAOA/NPpuusbbo/Iw61wNXEuCerkrDNQXY4u/6kqJ8pp8P+AJkVgK3Oo
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR11MB6734.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(346002)(136003)(39860400002)(366004)(396003)(376002)(230922051799003)(64100799003)(186009)(1800799012)(451199024)(55016003)(33656002)(9686003)(66946007)(64756008)(7696005)(6506007)(66446008)(66556008)(76116006)(38070700009)(86362001)(66476007)(4744005)(122000001)(38100700002)(41300700001)(26005)(83380400001)(2906002)(4326008)(5660300002)(71200400001)(7416002)(478600001)(6916009)(966005)(52536014)(54906003)(316002)(82960400001)(8936002)(8676002)(133343001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?WkNJcUk0YlVhb1IwTktYRDdFd3Rjc0VKUjlwd2FKTE5tenpaM3dQSlZQaWhl?=
 =?utf-8?B?eThvcHpuTGpTOGtxWWhtWlRsU08rS1Bzd01nQ0V2S2YvWGVTSnVJUTJUYlQ2?=
 =?utf-8?B?SjdHZ1dRbnFnYnBVaDh5MkNaLzRwOW5iTGVPUUlyRTFRcEdQQnVNWjRiVUxj?=
 =?utf-8?B?K1R1NitHTHNQcjBOM1ZsVFpjc2cvRzRpTEV1OUkycVZWRUdiR2tkblh3ektC?=
 =?utf-8?B?V0hzbTZ0bTYxR0xLdDJBNVpBSTB1ZFpUdWpDZ1Q1cUZCQitWcVRBLy9qeU4y?=
 =?utf-8?B?Q3V3R2pmLytwRFFuc09vRDdBbVp2MHRCbTNER3g1RFZkZUJhdFlzTjl3Wkt3?=
 =?utf-8?B?cjAyd1RTSnI4QTJCQlhmRFhUSFZzWGs1QW1OWGtzdDZOdTJuWE50TVp4dlVO?=
 =?utf-8?B?NjFmaHEyRCt6K0d2SmdNTFZGTGwwTEhncXJrSkJhZktQVUtCcjBYMUVzRVhO?=
 =?utf-8?B?c24rZnhoT3BzcTBsaEMzb2w0UzREbWV5MXRoMHprODdYY3pRVEJHQjdiTnYy?=
 =?utf-8?B?Uy92V3lrMUhPRVBoMENrUCs3N3hpRFdCcEdhbVlDK0ZNcWZ5MXRDU0xFdVQw?=
 =?utf-8?B?R3ZtUWNoVFA0cDhqQmZwbWIrc1p0ZTVGc29xMWMxZGFxMHRTeHRsQ3pwTTJG?=
 =?utf-8?B?TjBRNURuT3VyQ1NqV0VGOTN2ajUzSzVySnpGYmpCand3alhaN1NpVDdwbkRM?=
 =?utf-8?B?b3pHS1Q3ODY0RXNFOXN3SEdSNWNHTFpEakNPeWp3VHFSSHJkNkx5SFhjaUZY?=
 =?utf-8?B?dy9qaURlU3dEZ0pOUitoYnhvU1ZRVm4zNTNXbFl2L2NYcHNBT1pFWEJXRm8r?=
 =?utf-8?B?dzJDWFFVeVh5VlY5TUdsblNDRUNXZUQ3Vms0ZnZCd0lvay9PbDlvenlVSHAx?=
 =?utf-8?B?TG94aU1XdEgvbm5HVXRvTjJBN2loVlhOVGR4RkM2ejVUT3RoSVlNZ3NlNnBS?=
 =?utf-8?B?cDNsRWVWdEx1cEVXS09mYXE2bjlFbUdxM1RQRC9MOGdLV2ZQMzZ5Tkt4Uk1K?=
 =?utf-8?B?cUcrL2lmR3YvR0t3Y21Tb3pWUGlkZXNlNktsaVRYS2JZM0pCakgrZStreFpq?=
 =?utf-8?B?ZVNBUFNvK0ZUR1BWajk4dlJPRW42SkZYbmNSc2QrZnlKV2hieXordytnUVhU?=
 =?utf-8?B?YlFQVG5palJzOFVBcFZCRDNCQ1hKcC84RTBoRjJuTTd6a2xJbjdJVlFLY3k0?=
 =?utf-8?B?T1krM3BWdzF4T1k0U1MyWEdCMlFKaWk1Z0NUcHdtWjhDc0liTC9UbHFZNzZK?=
 =?utf-8?B?Ykh2ZnIxYWF1NkN0T0J1ZzVZSnhLb3FrbWl6VFlBT2dldlVidGI5UlZJcFJP?=
 =?utf-8?B?aXZTWEU2NXZPOU9oejdzQzlWbUFNWlJuOVBtWmNiZUNQTU05MktST1haOXJS?=
 =?utf-8?B?Yk1IRzd0V2RzRG9NbTBrV1QzZ0NnZVdYc2ZxTHBqNGt3REN3TGdHeG5rOUlG?=
 =?utf-8?B?OTY5M2gzUnY3S1ExeXlEL3F4a3h4VDdwcHU1b0VPRFBnQjkyWjI5NjNtWlFo?=
 =?utf-8?B?ak1JU0YwdlFsMTNBK0Naa0xhYlF3ajdyTDNzamhPMFJhQWovejFUVUswaWxN?=
 =?utf-8?B?STZkY29kdjgvOTBLQ0NHOG4vZEo0N2VxMWdJaFppdWxKOHNxYUZRUTM5bWtX?=
 =?utf-8?B?SWlIWnQxUW50NndFTjNrRFdhN1g0MVFnZTFVaSt1bjVRdStqTnlyUWc0TUox?=
 =?utf-8?B?UlVoVXQyOXkySjVZK1BvOGRhQTFONXV2akJQZ2hybWdTdlRrci9LR2xGVkNX?=
 =?utf-8?B?MGdwbHRScEl5MXJxVjRJRnRNVW5IbVVnMm16cFlHQnhiWGU2UzJqcjROcW55?=
 =?utf-8?B?M1QyaVRycnhKYVp1RTBwelcvUE9LdkV1SDhGaUdrUXFqM1drTU9EVnhuTy95?=
 =?utf-8?B?ak42WWZBMnU5d2lPd3NUY2kzQXhvMmY4b05Ob0RIOXZ4cVpHbmgxMko0MWZo?=
 =?utf-8?B?YUd5UzZrOVdkUEJhb0dkYlZzV0lQUk03eitUa3FxREwrZXJlQ09EaVlFWkJ0?=
 =?utf-8?B?aHlqVHFlM3VzNngzOFVqMXFGNlBFMS9KTHE0ZVk2NXduL2N0eGFWTWRYZWh0?=
 =?utf-8?B?elN3YUNMZG1xeWtOcXQ3VngydTRraVRCdWozK1lOTVd4QllMcG1jcW9NbENM?=
 =?utf-8?Q?YU/k=3D?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SA1PR11MB6734.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 055a227c-2c25-4ce6-0dfb-08dc0bdf114c
X-MS-Exchange-CrossTenant-originalarrivaltime: 02 Jan 2024 22:06:27.5496
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 2AjJwpb/OVe4rVHsbyr5dxOPUeyXaI0feaWWD5AYXJA3lre91Hz6U7sq/zF0zmLa2MsnXZmdPl1RryHjcWY+BQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR11MB5345
X-OriginatorOrg: intel.com

PiA+IFN1YmplY3Q6IFJlOiBbUEFUQ0ggdjEzIDAxLzM1XSB4ODYvY3B1ZmVhdHVyZXMsb3Bjb2Rl
LG1zcjogQWRkIHRoZQ0KPiBXUk1TUk5TIGluc3RydWN0aW9uIHN1cHBvcnQNCj4gDQo+IE9yIHNp
bXBseSAieDg2L2ZyZWQ6IEFkZCAuLi4gIg0KDQpEbyBJIG5lZWQgdG8gc2VuZCBhbiB1cGRhdGVk
IHBhdGNoPw0KDQpPciBqdXN0IGxlYXZlIGl0IHRvIHRoZSBtYWludGFpbmVyIHdobyBpcyBnb2lu
ZyB0byB0YWtlIGNhcmUgb2YgaXQ/DQoNCj4gDQo+IE90aGVyIHRoYW4gdGhhdCwNCj4gDQo+IEFj
a2VkLWJ5OiBCb3Jpc2xhdiBQZXRrb3YgKEFNRCkgPGJwQGFsaWVuOC5kZT4NCg0KVGhhbmtzIGEg
bG90IQ0KICAgIC1YaW4NCg0KPiANCj4gLS0NCj4gUmVnYXJkcy9HcnVzcywNCj4gICAgIEJvcmlz
Lg0KPiANCj4gaHR0cHM6Ly9wZW9wbGUua2VybmVsLm9yZy90Z2x4L25vdGVzLWFib3V0LW5ldGlx
dWV0dGUNCg==

