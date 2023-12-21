Return-Path: <kvm+bounces-5019-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 7E26381B3B9
	for <lists+kvm@lfdr.de>; Thu, 21 Dec 2023 11:36:46 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 0C0131F21909
	for <lists+kvm@lfdr.de>; Thu, 21 Dec 2023 10:36:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F017A697A9;
	Thu, 21 Dec 2023 10:36:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="gzRRTOlS"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.115])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 13A1D6978E
	for <kvm@vger.kernel.org>; Thu, 21 Dec 2023 10:36:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1703154996; x=1734690996;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=M2hm5Bf4+RqHuWRdN5GHSdFcuwJqZatjOdTjDW8MP+k=;
  b=gzRRTOlS3B9X+zSCEKacRGXgtmUVZ21+N1aChTZ3wiItWFputnoIdrqI
   LDvdaooOWZbrTugOlO8zoh40qHGmt0CduB35jfMhhrIUiSm7Ch8DqN601
   8NOAXBNeM02g2Shq7F6BZmp3vwb988OlSi//UDY1sw8VkjkF7P7/H/x7o
   uxSyhWvTMAzu6cyJR1mh/AbtdLLaRmpgrQGXTPk3N1h3vIvFgs2DVvEvK
   qMMaj4CDHspz/wrAvTOwzUTk2h47Vuyug5X6H9znEDgmt95tVXIeEDGR4
   +MMY4hhmad7o8LxIl0wR1OVTq8+hucWU/kCXTXs49una9aiWmP/Yx9qBq
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10930"; a="395682559"
X-IronPort-AV: E=Sophos;i="6.04,293,1695711600"; 
   d="scan'208";a="395682559"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Dec 2023 02:36:35 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10930"; a="769900041"
X-IronPort-AV: E=Sophos;i="6.04,293,1695711600"; 
   d="scan'208";a="769900041"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by orsmga007.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 21 Dec 2023 02:36:30 -0800
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Thu, 21 Dec 2023 02:36:30 -0800
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35 via Frontend Transport; Thu, 21 Dec 2023 02:36:30 -0800
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (104.47.55.169)
 by edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.35; Thu, 21 Dec 2023 02:36:29 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gPo2O86V8r7X20B7isGQcVgYOm2kXj58i3HRDqwrjDcNR98pXZ/0kQcs/lc3QZDKJpr5UfaZT06ht8F18l8+8O/X3qtZgLUEIUoztVCfQ3w2XjKnlWkvD4BjtjRjvd5zumevXiIo4Up6axiSskEwjMwXwfdpr42LxCDne6BYp3fgfYNOSS4R1UppiB5oS2bp2qXwu/g0hf+IbVM/5OXc0L6Cw3jIuiJjQb11GnPskvBEcvtRmjIhC37CVyLwFyIkawBCqbQUBjfsIpXh/6DPg3ilQ+s6UPNiOSoJxbLrp8jREW1I0FT2B+FmzLPTEGIPj+23KZ4oC7RLh+SUuCMu0Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=M2hm5Bf4+RqHuWRdN5GHSdFcuwJqZatjOdTjDW8MP+k=;
 b=cp3qmE/hGqzkPuWQDkS0KCrcL1O7I/ZkpXSUlgXu2jGCan3cqrvFyH2GjizE9DniouTlCsMn6T0HRU16LleVyfZPTXM1mQmKTm3obJstG8PaoD0qyQLQQ1LKVWFd+On88WdeX/7f+aXs15ZJvde8LR8yZrm7woAtVPBDLExinp+MwUbK7Zb9lFxWNtuYpUIUbkAD2ODPIRwSVSIHwixReUhka++UTEkxkT/305TskhIxGJw3BSueqmFTH5lx41Bzv0v/7NeyOdqw9j69oR3K9SLXocyXALV+1UapSX3FKxaOhazu8E2PFujcZcj/+BQQHKew65B2G+tBcRD1Pt8Gag==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from DS0PR11MB6373.namprd11.prod.outlook.com (2603:10b6:8:cb::20) by
 PH7PR11MB6835.namprd11.prod.outlook.com (2603:10b6:510:1ee::9) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.7113.21; Thu, 21 Dec 2023 10:36:27 +0000
Received: from DS0PR11MB6373.namprd11.prod.outlook.com
 ([fe80::9ce6:c8d3:248e:448a]) by DS0PR11MB6373.namprd11.prod.outlook.com
 ([fe80::9ce6:c8d3:248e:448a%4]) with mapi id 15.20.7113.019; Thu, 21 Dec 2023
 10:36:27 +0000
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
 Christopherson" <seanjc@google.com>, Claudio Fontana <cfontana@suse.de>, Gerd
 Hoffmann <kraxel@redhat.com>, Isaku Yamahata <isaku.yamahata@gmail.com>,
	"Qiang, Chenyi" <chenyi.qiang@intel.com>
Subject: RE: [PATCH v3 06/70] kvm: Introduce support for memory_attributes
Thread-Topic: [PATCH v3 06/70] kvm: Introduce support for memory_attributes
Thread-Index: AQHaF5O24VxNhOyFz0ifdu/xEp7Ej7Cl0dCggA2oA4CAAEbrQA==
Date: Thu, 21 Dec 2023 10:36:26 +0000
Message-ID: <DS0PR11MB63737AFCA458FA78423C0BB7DC95A@DS0PR11MB6373.namprd11.prod.outlook.com>
References: <20231115071519.2864957-1-xiaoyao.li@intel.com>
 <20231115071519.2864957-7-xiaoyao.li@intel.com>
 <DS0PR11MB6373D69ABBF4BDF7120438ACDC8EA@DS0PR11MB6373.namprd11.prod.outlook.com>
 <cc568b63-a129-4b23-8ac8-313193ea8126@intel.com>
In-Reply-To: <cc568b63-a129-4b23-8ac8-313193ea8126@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DS0PR11MB6373:EE_|PH7PR11MB6835:EE_
x-ms-office365-filtering-correlation-id: 4ffc3843-d9f6-4204-8a89-08dc0210afa3
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: hR6YcIPRPUvkqmZiwKiLT/gxmUU/LBV3HrZj08fsvjOMfOzM+LJUJ8brlAVQD3OJiwwg5MDC3VHU8RDAEtFeGc2z7Ww4ACKbJsMvVAUmD5wRJ8RzCEtSnQ3TsPhRaOcF0deJgcLoJLTi7Z9hwt80u5NlYRaURKYM8ELZHxfSJ/VlncH7zg+hQJG1S7FC1zJ6ljPa+4liNpb4tBOzAEPgc+IoX7uyq9c8m1TKH+vKyW7iq21YRpA83ogNZrLd3ULD0HrzAb0Ba35qmfYjLtPVF2btg4y5nj+9MivMAy4+hst+sXWGOq9or0pEqUjQtCD6/4WeM3Kjt1cIJccalQkSB8aONCYpEexjFPDNVAJWWX9rbN+6IQ38UgMlxL4VUo+poPce79uujmtpCNBGiNpKmChengT3WEkRGRTSmvc2BB2FFckKLuujEnWBlqene65R7QnBHWhBOE2eJTnXrCcwpE6wCT1XbCFbOzth9qUcPOr2iADQzvj1NosyVmtYYoySL5/qt+8J5ges8EKeoMLO+IxXIXpnrDVtIqwAycoi/9dG8EkdpZBvzmpjn1Z1iwaFIxVfbAogRj2NrK5noQZfxIk7VJbIFOKMlWLOBMChw641zipjit6frezhKfljN4dxqfKpJNLBXmpld6hVDLMmSg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR11MB6373.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(396003)(39860400002)(136003)(346002)(376002)(366004)(230922051799003)(1800799012)(186009)(64100799003)(451199024)(71200400001)(478600001)(54906003)(110136005)(66556008)(66446008)(316002)(64756008)(66476007)(8676002)(8936002)(66946007)(76116006)(9686003)(53546011)(6506007)(7696005)(26005)(107886003)(41300700001)(2906002)(7416002)(52536014)(4326008)(5660300002)(86362001)(38070700009)(921008)(33656002)(55016003)(122000001)(38100700002)(82960400001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?TVJYTUNRMFk1WG5HM1dFRkp0WlhUK3lTdkZqV0ljVVlzOUtaVzdjMUk4aEMr?=
 =?utf-8?B?VlhOVllHY1BkdXVYc01IQkpjOFM2RW5ReFYwbG9OUjFJL2FqZE8vNUZNek92?=
 =?utf-8?B?UnVDOUtQdFJRaXpIaDRIa3BhR0lLc3pablh6MGUyN2RsZ3RYTTZTbERTcHVX?=
 =?utf-8?B?Rk5ZOW9xdGJrMm13OGpBSndMaE5RRWVIbHdsaGlrNnU0MkYzQXlQMkk2ZGpU?=
 =?utf-8?B?aUFLNXRvWGxNU2Y0cWhEdEttR1hITDk5TXNJUjJZK0RSdWp6bGJubjN0Z1lw?=
 =?utf-8?B?NVdxSGk2c1d6QW96VUMxSVpReUhkamtlakhKa0d5Q05CZ2V3N2VjeFVuZWNP?=
 =?utf-8?B?WnpLS3dKRndGa0tCKzBZaE1zbmFZVWhENWpncTdVYVE1RjdEWDdOdmpwa0x5?=
 =?utf-8?B?TS9PclRxcjk3UThnZVFkRkFkZk5YaThhamc2bkQxZjJXNDJ5YmlkYkpXVkFI?=
 =?utf-8?B?V1J3NDZTWWIrdFo4Wlh4Z2dPKzhkYmtJK2xJTFhZMTVNRWJaV09uQzVYdWJD?=
 =?utf-8?B?djRxaUtJclFqUHZ0RVM0c25wZlpoakxmemtHOWxkb2lCb1hmQjVJSkNuYzRQ?=
 =?utf-8?B?bTViRDZCNVVmM0hOcVVwci85RGdZdHo0emNUcktSSnhPNTdlajI0M0I2eDha?=
 =?utf-8?B?ZkY2bXZBT1dwNmNUVFFEVHdkS1hFL3BJWExualZMWjN5dDRXRkF4akVTR1hF?=
 =?utf-8?B?ZnNOaFpQUUs5N1F2WnBUUU1LejdJLzd1a3VTYzJtSTlERkl4dnhFTGdycDQv?=
 =?utf-8?B?RG1ka1JBOGJ1Ym8rMG1CbnEwMU1JNFppa1FwZTBnZXRPeEhncExmVzlhL2JC?=
 =?utf-8?B?Umhwc0hYdEkvQmhXOERodVB6QUtiUjlCN2xGSXYzYXRQRklNWGE0SW43ZCtT?=
 =?utf-8?B?S2svNndDVFBZRHRwdzlmbU12WnFBZ2Q4eVgwYUM3YW5qS3hUR2NSQWJrTFZn?=
 =?utf-8?B?eUlYc0dLTXMvYlMyR0pERVQ1VGN6am1pSTQ3TzFqc2QybUQ1YUt4d3g2bGhx?=
 =?utf-8?B?OGk4dXprR1ZaK245QnoxaTB6eXpnYlA4SzFTMmVVQldzYnB4NnhJY0EzK3lQ?=
 =?utf-8?B?aE9zR1M2MFR0ejRUemxkNkF4R1pTYVlvSTBZOWpBamw0OGNYdHArSHl4UXRs?=
 =?utf-8?B?VE5yRjFDMExOSURJQ0t6dFhaZUdBMjQ3cFNSeDJIY2s4ckZ0K2NHdk1hWHNw?=
 =?utf-8?B?K3NvT2IyYkl5L1ppRStIRFdmS25IWnUrRW9ydzQzY0RkeXBGRE1HcEo3RklF?=
 =?utf-8?B?RzNFY2lTVHcycy9wdktRUkRSc0dKMFBYVkJRQlJIMXExemRVRVI3elF2U3BL?=
 =?utf-8?B?Tlp3Y1h5SWs4WU1abUZEcExzbmpOeEFGZFRCNW1PUUpOT0F6dDFXZFo5ajlS?=
 =?utf-8?B?ZTk2Q3ZGR2YzcUpQZDlaM3Zudk5hc3ZCYi9Xak5TWWUvV2lNbkw0T1F2cmpC?=
 =?utf-8?B?Z0ltbkxORHZvaHJMQUhRTStFOUY5WkpGUXJUWmlGcHpoeDA4c1B0UXpJNlV3?=
 =?utf-8?B?Z3oraVh6VnlrM3c0aWhDbDRhZzU0Z1h3bldJUXAvbDRNUEJlNURWeDIvMElM?=
 =?utf-8?B?Q3JhWDg3YWtYYWs3ZnlPZVhvdENXWkQraWIwYlFERjdZMXNYVVp2QW9KVVdt?=
 =?utf-8?B?QzF6MXNLcm83dStWTDFVL2JLOWNXTG9OS1ZBakI2SDBBNzdqT2x4QmI1ZVdI?=
 =?utf-8?B?eFhrd2VPRzc0dEhaK05leGJRMzVhdXhpR3ljWGpaakpHZVNmWDZ4L01BUVUv?=
 =?utf-8?B?dlpZTzhZMDdxTk1WUmZZUElXZ2FoWFZPbVh0djN0SS9WZk1oNVNFbktqRWxx?=
 =?utf-8?B?YU1JQlFNNVRzSU5RRXJYeGhXTFpkcVN2Nm9KbkxFcHFIbnhVSWV2QWJzYjN5?=
 =?utf-8?B?K2U1VFBZb0oya1dQNjA1SVl3Tmxub2pWZngzTFU1VVFhY3RLcHpuL3NBUW1V?=
 =?utf-8?B?WjEwa1dQbGdiYjBQbGtQODZ5Ukp5a25NeXRKa1p2cEV5V1JXR3ZSOXNhSFlF?=
 =?utf-8?B?V3h6NzNSZnZzZVBKWjh4RUxBanRPU1h3SWxabFFId2dyNmxOOG43UjJ2VURL?=
 =?utf-8?B?OUZVMmlKNG5vOUgrV20ySEoyVDBsWGdrRFQ5YnFZOTdsaklIeGF1emlTL2hz?=
 =?utf-8?Q?C90wodYIvDTimZ8/u4ljQl72Z?=
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
X-MS-Exchange-CrossTenant-Network-Message-Id: 4ffc3843-d9f6-4204-8a89-08dc0210afa3
X-MS-Exchange-CrossTenant-originalarrivaltime: 21 Dec 2023 10:36:26.8702
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: YVp/d8Gg1cZBha204Hwp8ShftO8XZpwzf7SnmjPZLixujTSF/Z11GnDIBxOU+kywKSDLeO2/F83QxpIKJoxEbQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR11MB6835
X-OriginatorOrg: intel.com

T24gVGh1cnNkYXksIERlY2VtYmVyIDIxLCAyMDIzIDI6MTEgUE0sIExpLCBYaWFveWFvIHdyb3Rl
Og0KPiBPbiAxMi8xMi8yMDIzIDk6NTYgUE0sIFdhbmcsIFdlaSBXIHdyb3RlOg0KPiA+IE9uIFdl
ZG5lc2RheSwgTm92ZW1iZXIgMTUsIDIwMjMgMzoxNCBQTSwgWGlhb3lhbyBMaSB3cm90ZToNCj4g
Pj4gSW50cm9kdWNlIHRoZSBoZWxwZXIgZnVuY3Rpb25zIHRvIHNldCB0aGUgYXR0cmlidXRlcyBv
ZiBhIHJhbmdlIG9mDQo+ID4+IG1lbW9yeSB0byBwcml2YXRlIG9yIHNoYXJlZC4NCj4gPj4NCj4g
Pj4gVGhpcyBpcyBuZWNlc3NhcnkgdG8gbm90aWZ5IEtWTSB0aGUgcHJpdmF0ZS9zaGFyZWQgYXR0
cmlidXRlIG9mIGVhY2ggZ3BhDQo+IHJhbmdlLg0KPiA+PiBLVk0gbmVlZHMgdGhlIGluZm9ybWF0
aW9uIHRvIGRlY2lkZSB0aGUgR1BBIG5lZWRzIHRvIGJlIG1hcHBlZCBhdA0KPiA+PiBodmEtIGJh
c2VkIHNoYXJlZCBtZW1vcnkgb3IgZ3Vlc3RfbWVtZmQgYmFzZWQgcHJpdmF0ZSBtZW1vcnkuDQo+
ID4+DQo+ID4+IFNpZ25lZC1vZmYtYnk6IFhpYW95YW8gTGkgPHhpYW95YW8ubGlAaW50ZWwuY29t
Pg0KPiA+PiAtLS0NCj4gPj4gICBhY2NlbC9rdm0va3ZtLWFsbC5jICB8IDQyDQo+ICsrKysrKysr
KysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKw0KPiA+PiAgIGluY2x1ZGUvc3lzZW11
L2t2bS5oIHwgIDMgKysrDQo+ID4+ICAgMiBmaWxlcyBjaGFuZ2VkLCA0NSBpbnNlcnRpb25zKCsp
DQo+ID4+DQo+ID4+IGRpZmYgLS1naXQgYS9hY2NlbC9rdm0va3ZtLWFsbC5jIGIvYWNjZWwva3Zt
L2t2bS1hbGwuYyBpbmRleA0KPiA+PiA2OWFmZWI0N2M5YzAuLjc2ZTI0MDRkNTRkMiAxMDA2NDQN
Cj4gPj4gLS0tIGEvYWNjZWwva3ZtL2t2bS1hbGwuYw0KPiA+PiArKysgYi9hY2NlbC9rdm0va3Zt
LWFsbC5jDQo+ID4+IEBAIC0xMDIsNiArMTAyLDcgQEAgYm9vbCBrdm1faGFzX2d1ZXN0X2RlYnVn
OyAgc3RhdGljIGludA0KPiA+PiBrdm1fc3N0ZXBfZmxhZ3M7IHN0YXRpYyBib29sIGt2bV9pbW1l
ZGlhdGVfZXhpdDsgIHN0YXRpYyBib29sDQo+ID4+IGt2bV9ndWVzdF9tZW1mZF9zdXBwb3J0ZWQ7
DQo+ID4+ICtzdGF0aWMgdWludDY0X3Qga3ZtX3N1cHBvcnRlZF9tZW1vcnlfYXR0cmlidXRlczsN
Cj4gPj4gICBzdGF0aWMgaHdhZGRyIGt2bV9tYXhfc2xvdF9zaXplID0gfjA7DQo+ID4+DQo+ID4+
ICAgc3RhdGljIGNvbnN0IEtWTUNhcGFiaWxpdHlJbmZvIGt2bV9yZXF1aXJlZF9jYXBhYmlsaXRl
c1tdID0geyBAQA0KPiA+PiAtMTMwNSw2DQo+ID4+ICsxMzA2LDQ0IEBAIHZvaWQga3ZtX3NldF9t
YXhfbWVtc2xvdF9zaXplKGh3YWRkciBtYXhfc2xvdF9zaXplKQ0KPiA+PiAgICAgICBrdm1fbWF4
X3Nsb3Rfc2l6ZSA9IG1heF9zbG90X3NpemU7DQo+ID4+ICAgfQ0KPiA+Pg0KPiA+PiArc3RhdGlj
IGludCBrdm1fc2V0X21lbW9yeV9hdHRyaWJ1dGVzKGh3YWRkciBzdGFydCwgaHdhZGRyIHNpemUs
DQo+ID4+ICt1aW50NjRfdCBhdHRyKSB7DQo+ID4+ICsgICAgc3RydWN0IGt2bV9tZW1vcnlfYXR0
cmlidXRlcyBhdHRyczsNCj4gPj4gKyAgICBpbnQgcjsNCj4gPj4gKw0KPiA+PiArICAgIGF0dHJz
LmF0dHJpYnV0ZXMgPSBhdHRyOw0KPiA+PiArICAgIGF0dHJzLmFkZHJlc3MgPSBzdGFydDsNCj4g
Pj4gKyAgICBhdHRycy5zaXplID0gc2l6ZTsNCj4gPj4gKyAgICBhdHRycy5mbGFncyA9IDA7DQo+
ID4+ICsNCj4gPj4gKyAgICByID0ga3ZtX3ZtX2lvY3RsKGt2bV9zdGF0ZSwgS1ZNX1NFVF9NRU1P
UllfQVRUUklCVVRFUywgJmF0dHJzKTsNCj4gPj4gKyAgICBpZiAocikgew0KPiA+PiArICAgICAg
ICB3YXJuX3JlcG9ydCgiJXM6IGZhaWxlZCB0byBzZXQgbWVtb3J5ICgweCVseCslI3p4KSB3aXRo
IGF0dHINCj4gPj4gKyAweCVseA0KPiA+PiBlcnJvciAnJXMnIiwNCj4gPj4gKyAgICAgICAgICAg
ICAgICAgICAgIF9fZnVuY19fLCBzdGFydCwgc2l6ZSwgYXR0ciwgc3RyZXJyb3IoZXJybm8pKTsN
Cj4gPj4gKyAgICB9DQo+ID4+ICsgICAgcmV0dXJuIHI7DQo+ID4+ICt9DQo+ID4+ICsNCj4gPj4g
K2ludCBrdm1fc2V0X21lbW9yeV9hdHRyaWJ1dGVzX3ByaXZhdGUoaHdhZGRyIHN0YXJ0LCBod2Fk
ZHIgc2l6ZSkgew0KPiA+PiArICAgIGlmICghKGt2bV9zdXBwb3J0ZWRfbWVtb3J5X2F0dHJpYnV0
ZXMgJg0KPiA+PiBLVk1fTUVNT1JZX0FUVFJJQlVURV9QUklWQVRFKSkgew0KPiA+PiArICAgICAg
ICBlcnJvcl9yZXBvcnQoIktWTSBkb2Vzbid0IHN1cHBvcnQgUFJJVkFURSBtZW1vcnkgYXR0cmli
dXRlXG4iKTsNCj4gPj4gKyAgICAgICAgcmV0dXJuIC1FSU5WQUw7DQo+ID4+ICsgICAgfQ0KPiA+
PiArDQo+ID4+ICsgICAgcmV0dXJuIGt2bV9zZXRfbWVtb3J5X2F0dHJpYnV0ZXMoc3RhcnQsIHNp
emUsDQo+ID4+ICtLVk1fTUVNT1JZX0FUVFJJQlVURV9QUklWQVRFKTsgfQ0KPiA+PiArDQo+ID4+
ICtpbnQga3ZtX3NldF9tZW1vcnlfYXR0cmlidXRlc19zaGFyZWQoaHdhZGRyIHN0YXJ0LCBod2Fk
ZHIgc2l6ZSkgew0KPiA+PiArICAgIGlmICghKGt2bV9zdXBwb3J0ZWRfbWVtb3J5X2F0dHJpYnV0
ZXMgJg0KPiA+PiBLVk1fTUVNT1JZX0FUVFJJQlVURV9QUklWQVRFKSkgew0KPiA+PiArICAgICAg
ICBlcnJvcl9yZXBvcnQoIktWTSBkb2Vzbid0IHN1cHBvcnQgUFJJVkFURSBtZW1vcnkgYXR0cmli
dXRlXG4iKTsNCj4gPj4gKyAgICAgICAgcmV0dXJuIC1FSU5WQUw7DQo+ID4+ICsgICAgfQ0KPiA+
DQo+ID4gRHVwbGljYXRlIGNvZGUgaW4ga3ZtX3NldF9tZW1vcnlfYXR0cmlidXRlc19zaGFyZWQv
cHJpdmF0ZS4NCj4gPiBXaHkgbm90IG1vdmUgdGhlIGNoZWNrIGludG8ga3ZtX3NldF9tZW1vcnlf
YXR0cmlidXRlcz8NCj4gDQo+IEJlY2F1c2UgaXQncyBub3QgZWFzeSB0byBwdXQgdGhlIGNoZWNr
IGludG8gdGhlcmUuDQo+IA0KPiBCb3RoIHNldHRpbmcgYW5kIGNsZWFyaW5nIG9uZSBiaXQgcmVx
dWlyZSB0aGUgY2FwYWJpbGl0eSBjaGVjay4gSWYgbW92aW5nIHRoZQ0KPiBjaGVjayBpbnRvIGt2
bV9zZXRfbWVtb3J5X2F0dHJpYnV0ZXMoKSwgdGhlIGNoZWNrIG9mDQo+IEtWTV9NRU1PUllfQVRU
UklCVVRFX1BSSVZBVEUgd2lsbCBoYXZlIHRvIGJlY29tZSB1bmNvbmRpdGlvbmFsbHksDQo+IHdo
aWNoIGlzIG5vdCBhbGlnbmVkIHRvIHRoZSBmdW5jdGlvbiBuYW1lIGJlY2F1c2UgdGhlIG5hbWUg
aXMgbm90IHJlc3RyaWN0ZWQgdG8NCj4gc2hhcmVkL3ByaXZhdGUgYXR0cmlidXRlIG9ubHkuDQoN
Ck5vIG5lZWQgdG8gc3BlY2lmaWNhbGx5IGNoZWNrIGZvciBLVk1fTUVNT1JZX0FUVFJJQlVURV9Q
UklWQVRFIHRoZXJlLg0KSSdtIHN1Z2dlc3RpbmcgYmVsb3c6DQoNCmRpZmYgLS1naXQgYS9hY2Nl
bC9rdm0va3ZtLWFsbC5jIGIvYWNjZWwva3ZtL2t2bS1hbGwuYw0KaW5kZXggMmQ5YTI0NTVkZS4u
NjNiYTc0YjIyMSAxMDA2NDQNCi0tLSBhL2FjY2VsL2t2bS9rdm0tYWxsLmMNCisrKyBiL2FjY2Vs
L2t2bS9rdm0tYWxsLmMNCkBAIC0xMzc1LDYgKzEzNzUsMTEgQEAgc3RhdGljIGludCBrdm1fc2V0
X21lbW9yeV9hdHRyaWJ1dGVzKGh3YWRkciBzdGFydCwgaHdhZGRyIHNpemUsIHVpbnQ2NF90IGF0
dHIpDQogICAgIHN0cnVjdCBrdm1fbWVtb3J5X2F0dHJpYnV0ZXMgYXR0cnM7DQogICAgIGludCBy
Ow0KDQorICAgIGlmICgoYXR0ciAmIGt2bV9zdXBwb3J0ZWRfbWVtb3J5X2F0dHJpYnV0ZXMpICE9
IGF0dHIpIHsNCisgICAgICAgIGVycm9yX3JlcG9ydCgiS1ZNIGRvZXNuJ3Qgc3VwcG9ydCBtZW1v
cnkgYXR0ciAlbHhcbiIsIGF0dHIpOw0KKyAgICAgICAgcmV0dXJuIC1FSU5WQUw7DQorICAgIH0N
CisNCiAgICAgYXR0cnMuYXR0cmlidXRlcyA9IGF0dHI7DQogICAgIGF0dHJzLmFkZHJlc3MgPSBz
dGFydDsNCiAgICAgYXR0cnMuc2l6ZSA9IHNpemU7DQpAQCAtMTM5MCwyMSArMTM5NSwxMSBAQCBz
dGF0aWMgaW50IGt2bV9zZXRfbWVtb3J5X2F0dHJpYnV0ZXMoaHdhZGRyIHN0YXJ0LCBod2FkZHIg
c2l6ZSwgdWludDY0X3QgYXR0cikNCg0KIGludCBrdm1fc2V0X21lbW9yeV9hdHRyaWJ1dGVzX3By
aXZhdGUoaHdhZGRyIHN0YXJ0LCBod2FkZHIgc2l6ZSkNCiB7DQotICAgIGlmICghKGt2bV9zdXBw
b3J0ZWRfbWVtb3J5X2F0dHJpYnV0ZXMgJiBLVk1fTUVNT1JZX0FUVFJJQlVURV9QUklWQVRFKSkg
ew0KLSAgICAgICAgZXJyb3JfcmVwb3J0KCJLVk0gZG9lc24ndCBzdXBwb3J0IFBSSVZBVEUgbWVt
b3J5IGF0dHJpYnV0ZVxuIik7DQotICAgICAgICByZXR1cm4gLUVJTlZBTDsNCi0gICAgfQ0KLQ0K
ICAgICByZXR1cm4ga3ZtX3NldF9tZW1vcnlfYXR0cmlidXRlcyhzdGFydCwgc2l6ZSwgS1ZNX01F
TU9SWV9BVFRSSUJVVEVfUFJJVkFURSk7DQogfQ0KDQogaW50IGt2bV9zZXRfbWVtb3J5X2F0dHJp
YnV0ZXNfc2hhcmVkKGh3YWRkciBzdGFydCwgaHdhZGRyIHNpemUpDQogew0KLSAgICBpZiAoIShr
dm1fc3VwcG9ydGVkX21lbW9yeV9hdHRyaWJ1dGVzICYgS1ZNX01FTU9SWV9BVFRSSUJVVEVfUFJJ
VkFURSkpIHsNCi0gICAgICAgIGVycm9yX3JlcG9ydCgiS1ZNIGRvZXNuJ3Qgc3VwcG9ydCBQUklW
QVRFIG1lbW9yeSBhdHRyaWJ1dGVcbiIpOw0KLSAgICAgICAgcmV0dXJuIC1FSU5WQUw7DQotICAg
IH0NCi0NCiAgICAgcmV0dXJuIGt2bV9zZXRfbWVtb3J5X2F0dHJpYnV0ZXMoc3RhcnQsIHNpemUs
IDApOw0KIH0NCg0KTWF5YmUgeW91IGRvbid0IGV2ZW4gbmVlZCB0aGUga3ZtX3NldF9tZW1vcnlf
YXR0cmlidXRlc19zaGFyZWQvcHJpdmF0ZSB3cmFwcGVycy4NCg==

