Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9C3DD6F61A4
	for <lists+kvm@lfdr.de>; Thu,  4 May 2023 01:01:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229770AbjECXB2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 3 May 2023 19:01:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50202 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229758AbjECXBY (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 3 May 2023 19:01:24 -0400
Received: from mga06.intel.com (mga06b.intel.com [134.134.136.31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E918C59E0;
        Wed,  3 May 2023 16:01:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1683154880; x=1714690880;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=PtMHHI1xYIPn0SVibZbxEELZXA3CAcx0LvIzH7uz+Dc=;
  b=k8DX3S2InMCAluybLE9+dzYyCHafEWZACMe9/sLHMcvFWGFn/qobzn4E
   htcPdyJXL//cvozBu0XtcRqYkaxvqk7ar6dC7HqjC/i4FQ1LwNhw8l+Fe
   gyRFw/PfuaAnfdskCw2s7eNCu6ST0b3GC+AqBKS3dyt0u4SBf6tl5X03k
   Ku/pQ2VZsvLmgDE2r6FGJQEBwsjHh324Ywt8slEO1tBtZuzsH6ddKKE+E
   Yz3NpS8GbDSd1LqJ0zL81+WUGdz1Xv3fEYJ8/93idozD936k/C3KMMV09
   TuFXgcVoo0LB2ZL2ipJDyMCVEk169NyV6wFavWkweDnX3OTK3GrdL1A0C
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10699"; a="411950160"
X-IronPort-AV: E=Sophos;i="5.99,248,1677571200"; 
   d="scan'208";a="411950160"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 May 2023 16:00:58 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10699"; a="727326936"
X-IronPort-AV: E=Sophos;i="5.99,248,1677571200"; 
   d="scan'208";a="727326936"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by orsmga008.jf.intel.com with ESMTP; 03 May 2023 16:00:58 -0700
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Wed, 3 May 2023 16:00:58 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Wed, 3 May 2023 16:00:58 -0700
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23 via Frontend Transport; Wed, 3 May 2023 16:00:58 -0700
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (104.47.58.168)
 by edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.23; Wed, 3 May 2023 16:00:57 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=iC2rmlR5H4AWosE9z1LBXBGw5T5jYamLy7b43qWUEsyC97H/vOKnnXLTzwU6FU1l8AZaShXpDo+S5QFRbsISfI0RI8u6RO/E/F4Uk0d/IoTp/Oxfwt72GzeYHMOw+WCO9AcO8Gc65kADlM7/5tTs/PrgbXCfReMeTVErOcXFKiFrWS61SVMSOWxXtCrldaXiZtz8ragR3R/SbzcNAVtD0Z1eu9BgsnpPBV5/aoODqwATXiGqBNwm7L5HBTqmjKuleoQ6Jbd5UpbhLZPnk4dsJ78cuWN/3lwUBFmHDerpX/BWUEJZnGE/pG9WVmk+1XGFhAs7Izaw0DfEAAvKVog5VQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=PtMHHI1xYIPn0SVibZbxEELZXA3CAcx0LvIzH7uz+Dc=;
 b=Lbznc1rEg1AxlU6oHkvKi/E4htW4JSNnW9TmVNjubzM4KESjLHTEDwxFMt4RzU2EsHDEkjZqrZXT2u5EozrFuev+zPbDKKy2hf23jBKjNyD1jTczEkYo/yx6yKGy30AHl1iPCvvbFcTex9QV796NrleoLQ+QVKP/PSfYbtL3Ds57tQcH6ujBihRcritHvMojPWrd4uOU+dYbZrk2gg1UKv3+kRmUNpghWVvDgg6EguarjLAw+1/RtFsZZqMEPQh6b89VJOomb5xV1VBnfOe/qjTczvFAnYQCJDK0deZWspkZup5OWYmA40tuOjKvwEwslO+fv7sfuB1iLmU1Q8vUJw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5978.namprd11.prod.outlook.com (2603:10b6:208:385::18)
 by DS7PR11MB5989.namprd11.prod.outlook.com (2603:10b6:8:70::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6363.22; Wed, 3 May
 2023 23:00:54 +0000
Received: from BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::3a8a:7ef7:fbaa:19e2]) by BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::3a8a:7ef7:fbaa:19e2%5]) with mapi id 15.20.6340.031; Wed, 3 May 2023
 23:00:53 +0000
From:   "Huang, Kai" <kai.huang@intel.com>
To:     "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "Christopherson,, Sean" <seanjc@google.com>
CC:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "guoke@uniontech.com" <guoke@uniontech.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "haiwenyao@uniontech.com" <haiwenyao@uniontech.com>
Subject: Re: [PATCH 1/5] KVM: VMX: Open code writing vCPU's PAT in VMX's MSR
 handler
Thread-Topic: [PATCH 1/5] KVM: VMX: Open code writing vCPU's PAT in VMX's MSR
 handler
Thread-Index: AQHZfe1i/BSGT7aWUky/gNTnUH3uoa9JKlgA
Date:   Wed, 3 May 2023 23:00:53 +0000
Message-ID: <56fa0da83203b20c9945e7c82a0eed11f3d31ea5.camel@intel.com>
References: <20230503182852.3431281-1-seanjc@google.com>
         <20230503182852.3431281-2-seanjc@google.com>
In-Reply-To: <20230503182852.3431281-2-seanjc@google.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.46.4 (3.46.4-1.fc37) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR11MB5978:EE_|DS7PR11MB5989:EE_
x-ms-office365-filtering-correlation-id: 705b4268-4f4c-45e1-e406-08db4c2a3f3f
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 7Qs47E/ednzDNbl7EwJxd/IumLPoLGleBGDfKonwfPI0a/+rZJn4ZS9fcEvAmLgItqyQc3XWCmXyCv0UptDcXF5caXbze9uqQ78V+UR0A6mTA+Sgk3O4tuENyNB8bV0m8BP8DcP76JO/o8RJOV0CFbV2WtT7jfDM5TkmK8vq7pHFLDVsReM8A8Cjx3HibPL09dtfOakR2J/rYuT7+5UZ7tIfqHa5UmZvcZ8uEAfAeeQJmK+S+BS/Gj7IOk9VbLaCq2fhCb29o9Oy3MTZX0zvryXpv/8w3673IekO56EClT4sv6pVCPlARoqyKwFkTXhCe2dnhVJBKD0wVU1UjBrFUQ2JXWH5RMIb5vyQ+dpcF4IjV+mpBihkOK9I8q35goBlo/FtIp3kle5Wclve3foRfnrCECvREGzEOv0g7QHZLTXgflmxaqN8L4xhctrIOtvDot6bQS2H74Zhta/cLjZp34Psely1dyP5+y3O/KnamGoSN1NaO4sXzs9Ff9U/EmwEV5s/CIXvJaCy4rijh33dMdn1ztcAm58fIIXNI15rePV3AMYnGln+Y/u1bZbw/XTXDLgVmslFrrgKSF4Dmthi4IKGQE/BOFQOvUKVyav7nr0oYDSaCGjSyJn7j1QqGMiR
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5978.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(136003)(346002)(376002)(366004)(396003)(39860400002)(451199021)(82960400001)(8936002)(5660300002)(8676002)(83380400001)(2616005)(2906002)(122000001)(36756003)(186003)(38070700005)(86362001)(38100700002)(6506007)(26005)(6512007)(41300700001)(71200400001)(91956017)(66446008)(66946007)(76116006)(66556008)(66476007)(4326008)(478600001)(64756008)(316002)(6486002)(110136005)(54906003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?N2VObUVsUERlclp6cFAyUmp0dkM2WHJiTTEvS0Y3LzBxWGdneGFnNGQvb0o2?=
 =?utf-8?B?am9zOE5WTzJ3T3BVYnQxOU0yM0UrbEViUHVyWmhGUmVvYWVrWHR1UGo0ckpj?=
 =?utf-8?B?eDVtTFg1eUlkdk9hNUswd1pEdi84NE9PWlp0eVoyTUs2a3N5bzVDdXRDWS9m?=
 =?utf-8?B?VzZkZEt6STZxM3ExMk5rWGV2N1RvVXpVSTQwNkNxeTNRTDhPTjhvekxiSG1i?=
 =?utf-8?B?clFhK1k5cEUwUHBqRTVudnVCYnU0bE1jZHorR3ZlNWR4bEpyWEZ5TVlweXll?=
 =?utf-8?B?WjJ6WG14UHpxSUdJL3UxOVlUSGpsVncxWTN4TGxMV3Q5RzhMRzRLTVIrVnlw?=
 =?utf-8?B?YVA5QjNESE9NTWtCN3FRb0FTeUd2ZE9XdTEwWlplTHNzN2VoSlplN2Q3UG52?=
 =?utf-8?B?UWtoTWVXa1lqYU1CNUEwRnJqOGdwOUpKaldUMUxwdmxndCs1M3hsU3Z3QmVU?=
 =?utf-8?B?ZE1vckxHUmlubWthMlFCNlB2N2xIRlhWeTJHUUhhcFphOHFCdFpGb1V3SGVp?=
 =?utf-8?B?Q1Z3SVZlcDdpTTFzYWRWbTBWTFFpR3BCOUJHUWE3a2NmbW84aXhmMnQvT24w?=
 =?utf-8?B?WnhkeE1IOGNxUHVwWFM0UjJDQktTdWlNVWxIdjZ5RHBPcmRPYU9yQmZHa09r?=
 =?utf-8?B?VnNBUHJQSW1TT3p0bmMwd3dzR1BVTEk1YTE3K3lwd0hCWjVKRFUxWmlSQnhi?=
 =?utf-8?B?K3haaDVSVGM0OURtNFB1MjZUbmUxay84Wllpc2Q2YmRTc09Dc3hUTjBlZWE0?=
 =?utf-8?B?SVY0TjljbW1rTnlkbHQvUEdveElmaTVUOCtOM1hRS2xzRWQ0ckxmREFWRGRM?=
 =?utf-8?B?cE1tRDZlSlF1TVJ0RmV0TGxqcmJiUjZEbHo2WGdUS3hCQzZXRzZJWFl2SjVY?=
 =?utf-8?B?SFFOUklDdXo1Z0tIczVBaHUxU0lrNWRpUEN5TWRrLzFzdzc5TVl0NTdXakdv?=
 =?utf-8?B?WXV1TzVTeXRBYXpTQ2xFcU94TWU2a3kvQm91bjY0K2xCcGVvclpZWGFwSVl3?=
 =?utf-8?B?emExVjE0UjRjQmc0ZDZXWUl3cjc5Wnl5Wi9MK3hVdkgzWmNiR3lHSHRsWFVs?=
 =?utf-8?B?QlpxMCtOanczYzFrdzlNdExSYy9DTlRheHowaWVJV0pvcWw4THZKUmRQUnUz?=
 =?utf-8?B?ZHZ3UUF3QjUzbE9GV2pzbTQrM2JCSzB3cm1JMUxTNVFQUGNxK0JzYnk0ZTdy?=
 =?utf-8?B?RG00Rk95c0ltT0xDWEx3eTlNU2RaS29WeGNvemNpZHgzb255N1hJWHVjNm9r?=
 =?utf-8?B?NWdyR0JYdllOTVdrUlpjRm5HVEJoT0g5a1lSZ2hXQnpUMVViWHo1Rm4yejJ4?=
 =?utf-8?B?bkZTaERWVDZkdmRwVWVDNDJxeENscjBNRFE1RVovcTIxM3BYU3lWcmY3aHd4?=
 =?utf-8?B?blY3VUdGZnhXcHc5YzEzSU1KOFdWYVV3QkJ5RjZPd3VuemxNQW1BTXROVEVE?=
 =?utf-8?B?ZUVIbU9vbk9QbnhpSDI2OWZXeHEwQlh3OUM2dEJ4ak4wQUxEdDNpSlQrQmc5?=
 =?utf-8?B?Mk0yNlRlcW1oUWhpeXkxR3ViSCt3R3NRdHVLQWE0bmpSeWZWMFVVanVES2xE?=
 =?utf-8?B?V2VIT3N1VTBNdHhCVm1zZFhQSjBRalRhVlJDM25pdTRGVVlXU2pobFBJNEFD?=
 =?utf-8?B?ak90ck5MSHhFbGFQZWtkT0dDUEJLei9keGxFcStIRC9FS3RoQnpxYXdiTldy?=
 =?utf-8?B?SStJTmlaSlg2TStza2FUTTV2QmFXeDVOR25oNTJ2MmZLalZjeWl2OGZpYkU3?=
 =?utf-8?B?T0tFblFOcFg2RXFPR3N0V2U0VmRJUEJsbFZQU21JWldTcitaQ3ZiTkpqY2N0?=
 =?utf-8?B?cDR3UXN2NFJTVzRFT0tpS3BRK3FEbEl0RWQ4QXhSUDNLZ3JkSkZSK1JzTmZq?=
 =?utf-8?B?SzRmUmFZZjRMSlN2QXkvNy9rVnhYWlJnZFlvSGJLQ0dMVmhqSVNVYmRvOTJ4?=
 =?utf-8?B?OHlnamZZVmVWWTFMUW11eEllalNXS0EydGJZYlM4M2xYV2tvRGZ4TlcxY0Nn?=
 =?utf-8?B?aUV1eVEyRWZJZFZnMHhUbTFZMmVhcGZPdzJqWVJ6SVp2MjBXZm5VZXBlK1VV?=
 =?utf-8?B?K1g4WFRTRHZFTzdJdTJuQVltSlc0RFJlbVRBaExsOUhUNlIyN3d5VmZVSGlr?=
 =?utf-8?Q?4iYKB6c3B5iIjqKO4ZjD5wHjx?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <9667C5B544C46641BCA33FB95506CB0B@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5978.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 705b4268-4f4c-45e1-e406-08db4c2a3f3f
X-MS-Exchange-CrossTenant-originalarrivaltime: 03 May 2023 23:00:53.5934
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: b+3McBy2FQ1SFtnc3fwbgxZCkt1Z2/I651NoMZra8vwBB+jiiaR2+DY1ThxJ6Jtj3+PcJCAsVO+7cuJ1wFBMJA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR11MB5989
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

T24gV2VkLCAyMDIzLTA1LTAzIGF0IDExOjI4IC0wNzAwLCBTZWFuIENocmlzdG9waGVyc29uIHdy
b3RlOg0KPiBGcm9tOiBXZW55YW8gSGFpIDxoYWl3ZW55YW9AdW5pb250ZWNoLmNvbT4NCj4gDQo+
IE9wZW4gY29kZSBzZXR0aW5nICJ2Y3B1LT5hcmNoLnBhdCIgaW4gdm14X3NldF9tc3IoKSBpbnN0
ZWFkIG9mIGJvdW5jaW5nDQo+IHRocm91Z2gga3ZtX3NldF9tc3JfY29tbW9uKCkgdG8gZ2V0IHRv
IHRoZSBzYW1lIGNvZGUgaW4ga3ZtX210cnJfc2V0X21zcigpLg0KDQpXaGF0J3MgdGhlIHZhbHVl
IG9mIGRvaW5nIHNvLCBiZXNpZGVzIHNhdmluZyBhIGZ1bmN0aW9uIG9mIGt2bV9zZXRfbXNyX2Nv
bW1vbigpPw0KDQpQQVQgY2hhbmdlIHNob3VsZG4ndCBiZSBzb21ldGhpbmcgZnJlcXVlbnQgc28g
c2hvdWxkbid0IGluIGEgcGVyZm9ybWFuY2UNCmNyaXRpY2FsIHBhdGguICBHaXZlbiB0aGUgUEFU
IGxvZ2ljIG9uIEludGVsIGFuZCBBTUQgYXJlIGJhc2ljYWxseSB0aGUgc2FtZSAsDQppc24ndCBp
dCBiZXR0ZXIgdG8gZG8gaW4ga3ZtX3NldF9tc3JfY29tbW9uKCk/DQoNCkZvciBpbnN0YW5jZSwg
Z2l2ZW4gbXRyciBjb2RlIGlzIGFsc28gaW4gY29tbW9uIHg4NiwgaWYgd2UgZXZlciB3YW50IHRv
IGFkZCBzb21lDQphZGRpdGlvbmFsIGxvZ2ljIHRvLCBpLmUuIGNhbGN1bGF0ZSBlZmZlY3RpdmUg
bWVtdHlwZSwgaXNuJ3QgYmV0dGVyIHRvIGRvIGhhbmRsZQ0KcGF0IGluIGNvbW1vbiBjb2RlIHRv
bz8NCg0KPiANCj4gTm90ZSwgTVNSX0lBMzJfQ1JfUEFUIGlzIDB4Mjc3LCBhbmQgaXMgdmVyeSBz
dWJ0bHkgaGFuZGxlZCBieQ0KPiANCj4gCWNhc2UgMHgyMDAgLi4uIE1TUl9JQTMyX01DMF9DVEwy
IC0gMToNCj4gDQo+IGluIGt2bV9zZXRfbXNyX2NvbW1vbigpLg0KPiANCj4gU2lnbmVkLW9mZi1i
eTogV2VueWFvIEhhaSA8aGFpd2VueWFvQHVuaW9udGVjaC5jb20+DQo+IFtzZWFuOiBtYXNzYWdl
IGNoYW5nZWxvZ10NCj4gU2lnbmVkLW9mZi1ieTogU2VhbiBDaHJpc3RvcGhlcnNvbiA8c2Vhbmpj
QGdvb2dsZS5jb20+DQo+IC0tLQ0KPiAgYXJjaC94ODYva3ZtL3ZteC92bXguYyB8IDggKysrLS0t
LS0NCj4gIDEgZmlsZSBjaGFuZ2VkLCAzIGluc2VydGlvbnMoKyksIDUgZGVsZXRpb25zKC0pDQo+
IA0KPiBkaWZmIC0tZ2l0IGEvYXJjaC94ODYva3ZtL3ZteC92bXguYyBiL2FyY2gveDg2L2t2bS92
bXgvdm14LmMNCj4gaW5kZXggNDRmYjYxOTgwM2I4Li41M2UyNDkxMDk0ODMgMTAwNjQ0DQo+IC0t
LSBhL2FyY2gveDg2L2t2bS92bXgvdm14LmMNCj4gKysrIGIvYXJjaC94ODYva3ZtL3ZteC92bXgu
Yw0KPiBAQCAtMjI5NCwxMiArMjI5NCwxMCBAQCBzdGF0aWMgaW50IHZteF9zZXRfbXNyKHN0cnVj
dCBrdm1fdmNwdSAqdmNwdSwgc3RydWN0IG1zcl9kYXRhICptc3JfaW5mbykNCj4gIAkJICAgIGdl
dF92bWNzMTIodmNwdSktPnZtX2V4aXRfY29udHJvbHMgJiBWTV9FWElUX1NBVkVfSUEzMl9QQVQp
DQo+ICAJCQlnZXRfdm1jczEyKHZjcHUpLT5ndWVzdF9pYTMyX3BhdCA9IGRhdGE7DQo+ICANCj4g
LQkJaWYgKHZtY3NfY29uZmlnLnZtZW50cnlfY3RybCAmIFZNX0VOVFJZX0xPQURfSUEzMl9QQVQp
IHsNCj4gKwkJaWYgKHZtY3NfY29uZmlnLnZtZW50cnlfY3RybCAmIFZNX0VOVFJZX0xPQURfSUEz
Ml9QQVQpDQo+ICAJCQl2bWNzX3dyaXRlNjQoR1VFU1RfSUEzMl9QQVQsIGRhdGEpOw0KPiAtCQkJ
dmNwdS0+YXJjaC5wYXQgPSBkYXRhOw0KPiAtCQkJYnJlYWs7DQo+IC0JCX0NCj4gLQkJcmV0ID0g
a3ZtX3NldF9tc3JfY29tbW9uKHZjcHUsIG1zcl9pbmZvKTsNCj4gKw0KPiArCQl2Y3B1LT5hcmNo
LnBhdCA9IGRhdGE7DQo+ICAJCWJyZWFrOw0KPiAgCWNhc2UgTVNSX0lBMzJfTUNHX0VYVF9DVEw6
DQo+ICAJCWlmICgoIW1zcl9pbmZvLT5ob3N0X2luaXRpYXRlZCAmJg0K
