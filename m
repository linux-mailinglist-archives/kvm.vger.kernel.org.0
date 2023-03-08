Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0542C6B0035
	for <lists+kvm@lfdr.de>; Wed,  8 Mar 2023 08:50:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229691AbjCHHu5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 8 Mar 2023 02:50:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54930 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229501AbjCHHuz (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 8 Mar 2023 02:50:55 -0500
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 59F3F96F0B;
        Tue,  7 Mar 2023 23:50:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1678261854; x=1709797854;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=fQ0vaLokbJZxYxA+7UzPcHLjiGJIdN1OJ0n/3oYQdC8=;
  b=I7x3n5vmBM/L7ckph2Vara9nhY7LThsVmk+2whReqvSjvWhmgutKIjV1
   xxj22ye5CtrFOcw5imvq2bZsDTW2eVieI/rJ8dpoyQ2chSD73Q7ecEbgj
   SFPQ/ZSDH4p9FfmdFgFUvYDCOX+TZciIuAaKqvbwUCJTrE8G3yeXCUgCL
   BIn8c5JOuK/IyNFeTENzKIZuy4PmZwcQ9dxAGj9DsDgHM3dH9vvnp27nE
   ACO5lUwWQI3aM9MvOVqID8NPsom7GGJwg/Q4ZTShQxIivlfQuVWVBjN6h
   unsW6S7ck9aVeSh0jR2J8tkcybm7alqHfsrICCCeIxX5JdPc1bVKiygMj
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10642"; a="338417938"
X-IronPort-AV: E=Sophos;i="5.98,243,1673942400"; 
   d="scan'208";a="338417938"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Mar 2023 23:50:52 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10642"; a="820102813"
X-IronPort-AV: E=Sophos;i="5.98,243,1673942400"; 
   d="scan'208";a="820102813"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by fmsmga001.fm.intel.com with ESMTP; 07 Mar 2023 23:50:52 -0800
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Tue, 7 Mar 2023 23:50:52 -0800
Received: from orsmsx612.amr.corp.intel.com (10.22.229.25) by
 ORSMSX611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Tue, 7 Mar 2023 23:50:51 -0800
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx612.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21 via Frontend Transport; Tue, 7 Mar 2023 23:50:51 -0800
Received: from NAM02-BN1-obe.outbound.protection.outlook.com (104.47.51.40) by
 edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.21; Tue, 7 Mar 2023 23:50:51 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=mFyTfgOLmmZPq7swNLlaxExXg16rQWF0m24O+JppcQbNs49rTSf31X8uipYv2eQ2aNhcItFK5VrAj7XzOZPPNGd4cSmL53r/IqsXrkyNv49c0kF7qmWam2BXo7fy4fW68hRoRIOrl27DH+wgWiIdWt4GGpIF7pH5H6y39Ila5xl/tqLfCS08aBuUqH9Eo7pl4LJWr0MGi/t5+BUWQ1pLT9WgtG6SfQQG1Q7b3dVnSFltM/tVzAjJnCQIqduchxJwbODz6iEPW3k3zErFYQ5qQhboYrMJUUe10hILihdtSLeee9u82b3YYXCF4crmoIkxuJ5usgw9sOHyjVey2kkypw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=fQ0vaLokbJZxYxA+7UzPcHLjiGJIdN1OJ0n/3oYQdC8=;
 b=JoJPlamxUrZJdCZ5kSQk/YYLcgbtzJYAfl9iHNQDhT1lan+GVkZx+d7sy1FelTiyt/4syqRVnyZw7NGC+/H4yjgVsWaKs+8HixmwRA0ojMrHmF9laJin4IwV71VRnrmYfuGMqG6Ar8ss0f6lDFj4d4mom81VNrKKBcIo9sKAzvhgC5zFOP4L/kA7/8RuxzT8TYO18PkTGTBYek2mMkPA7OA9aR5Md4O+bAu+BvLlEEmBpVUPsdWYiG1JM/S1D6bM9PHz/vpPe+lZs3sk7wXTB/FEaSQgTahOzIuU6aNbwBgE9eTc3WCca356lpdQz3S8y/9hGkqRpV7Elf0mLTozNw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BN9PR11MB5276.namprd11.prod.outlook.com (2603:10b6:408:135::18)
 by IA0PR11MB7751.namprd11.prod.outlook.com (2603:10b6:208:43a::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6156.29; Wed, 8 Mar
 2023 07:50:49 +0000
Received: from BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::1aac:b695:f7c5:bcac]) by BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::1aac:b695:f7c5:bcac%8]) with mapi id 15.20.6156.029; Wed, 8 Mar 2023
 07:50:49 +0000
From:   "Tian, Kevin" <kevin.tian@intel.com>
To:     Alex Williamson <alex.williamson@redhat.com>
CC:     Jason Gunthorpe <jgg@ziepe.ca>,
        "K V P, Satyanarayana" <satyanarayana.k.v.p@intel.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "cohuck@redhat.com" <cohuck@redhat.com>
Subject: RE: [PATCH] vfio/pci: Add DVSEC PCI Extended Config Capability to
 user visible list.
Thread-Topic: [PATCH] vfio/pci: Add DVSEC PCI Extended Config Capability to
 user visible list.
Thread-Index: AQHZTZTPYSblfLFSOUeGl9RPc4dsUa7tzAoAgAEJKbCAASi7gIAAiXrQ
Date:   Wed, 8 Mar 2023 07:50:49 +0000
Message-ID: <BN9PR11MB52769A0011C13309E759A3858CB49@BN9PR11MB5276.namprd11.prod.outlook.com>
References: <20230303055426.2299006-1-satyanarayana.k.v.p@intel.com>
        <ZAXxTiWU489dDssW@ziepe.ca>
        <BN9PR11MB52764ABF8381FCDB8CE0FFF78CB79@BN9PR11MB5276.namprd11.prod.outlook.com>
 <20230307162839.2236640d.alex.williamson@redhat.com>
In-Reply-To: <20230307162839.2236640d.alex.williamson@redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BN9PR11MB5276:EE_|IA0PR11MB7751:EE_
x-ms-office365-filtering-correlation-id: 8c5b1770-790f-4ffd-bb52-08db1fa9d577
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: wNLA1XVAP7XEUXfUrLgAvfGwU7p3Ynm1s5IX/wUvnIjnszlRCFyLdQEY5g2ERJaOFKpCbkJxugPBGz3p70sPma5ZlPkEkyztWSD05YH21ohmjqWJXm5xelg3E+/nkfu+1dYvKpuS7OxZZ/UqCFZ/Vn+K3w6nBD1uMOUlPjSkszGbSORIIIKBgbI4GJDdbDfqyl0LMd1+R8RJv83kS9pfKJJ0+pByT/OvwG3ErmY1E144zCH3KytNwuCDdYxn4Cp9JY/Vb1cNHxgcmum1Lwgqe3DGctwlOPL1Ngvi/34K2Gsbied4gWoxvC6/njSVpqxbWkfX/xgO1198zT/3VZFFRBG7rjEhdl37dXvC7KZnoyGVTr0GrnIz3wYDiRlZrM7Sle6wRSf5gJLPQ27h5YXn6hIwvwg3XSeyu86d5EiTTyih8DfsAn2BizI6/uqSuzkvkpOE/XstbDHYdbZaSFJWw+j7MemwvKHvS2pdI6J1gEPAQopQJ4FD0fEU2ABlamRCqcUYHz2EA8WmqSTYfag7HkVNoEIms4s/kad9HRGQqjNYg92z7ezX9lVJaJyEtQseiKDdIfnETuX6tI9UBeOMuGN+AErDZx9KuO4SVkeV51H4d8kMIS2iHpkc2Vg9DKPE6bEOUicOoRAwFjg7cBlDxBwE/FAyUiufog2/gonfxS2Dh3TGrk2676ulGUQe1cMlYCR7zaHV3siMMyaAD3axVNU+C0t8yBhEvWYzUa1Ow5lIuuY1g0gvHnSZGSbZ1EDX
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5276.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(396003)(136003)(366004)(346002)(376002)(39860400002)(451199018)(5660300002)(52536014)(8676002)(4326008)(64756008)(8936002)(76116006)(6916009)(6506007)(41300700001)(66946007)(2906002)(38070700005)(38100700002)(82960400001)(122000001)(33656002)(66476007)(66556008)(66446008)(86362001)(71200400001)(54906003)(478600001)(55016003)(7696005)(26005)(316002)(83380400001)(186003)(9686003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?T2pIS0tMdU4zWHZkYzR3RTBZUldyNFlIOGI4R1k0NEpCeStpN1VXMWhMam0z?=
 =?utf-8?B?VU9jYW80dHllSUsyWVN4eHlMMzZaaDZQM2VsUjdpNkNSRGNWbTFYUXEzZmZH?=
 =?utf-8?B?QXUydFVsNXRCWEZnV3pHOWpWSUI0R2ViK3pXRUcvVjR5dVlydkFDU29ienA1?=
 =?utf-8?B?L1hBVlhiN3NPTUxTSVlJZ004bzBaWk5uLzgyR3BhdndDbXVib0pMdzhOV3lZ?=
 =?utf-8?B?NHlEYU1LSWFtZnJYR3VUY0ljOHhFMklOTWtXR0thczMwRW1wQ1gvd1JrMFpv?=
 =?utf-8?B?Q056TnJwT09FR3BDRXVtSnhnQTJXRjFQeVpsYWgvclFMd1g5SU9Pd3RlL2NM?=
 =?utf-8?B?aC9zdVpTUnE0WUpkbmtmbVpVNjFUVHlGck10bEVia25ZaHdDOW4wU2xIUkVV?=
 =?utf-8?B?MkZnUlpIL1N0UExwdzNvbHdldlM5dGxTQU4yYnlTL2l1aURhWjAvU1ZwU000?=
 =?utf-8?B?WkczbkQwaHYrVktBVEkzVVpTanlOMUU4UzlYWU1MS252Vis0VDdZaTJEZUpT?=
 =?utf-8?B?dW5FQW1vMmIvbDZtMmxTbFdTcGl3TUhZUGFpekN1VXR2MmpRbU5FSmI4TjBY?=
 =?utf-8?B?blZNRTdGOW1yOENncVJrVDR2SiszTUo3aG9pMUc1d09HWm9jWHIzQ0VjMUtH?=
 =?utf-8?B?MGoycHhRNDhQNnpTQW94Q2xEdDBsNnJaR3ViencycW1CUGtFTHY2dXJmUWlR?=
 =?utf-8?B?bkFOc0t3WWowb29kaE0waURBZWdKYmVTdjVOT0tKNWVQZy9KUHhYckF5amJx?=
 =?utf-8?B?ZFZzRTkwNStRV2pLMFJnWHRtSUh0RUJOUUxmaVZnSDAzbDVTWmVsbDZNWU0x?=
 =?utf-8?B?T1hjQ1NWUjQxVGhvcXFlQjU4WVpqbVRaTHM2ckZLaFREanpTZExzUDY1MU9P?=
 =?utf-8?B?WEFHRm0xYmxYRkJsUHVKSHdKTU9KUjV6NnYrNFh0VGEvN3NMdXRCTVB2ejh6?=
 =?utf-8?B?NEpRZkNhRk11S2toNHpkekFDYVFtcEcxVFRDMlpKU1dvYlV0cFBMRTBYM1ow?=
 =?utf-8?B?OHdPRVVwd29yZjhFNzlXdmtoK0Y1ZGJKSG1RTmtMWnZUVmE4Y2NCL1E5L0Yw?=
 =?utf-8?B?SHNKUlcxaGFrcFViVUF6aU0vbWRObXNoVUxqeTJNSStyaDRiKzlrMHFQYno3?=
 =?utf-8?B?L3EzYUhJa3Q0WTk4T0RFZFQrQVFCck9rMUw5anlEcXhtYXJ1WHB3QjNSc2tz?=
 =?utf-8?B?YVpnY3RGL0dvMUpscGVobGkxeVdLTWRBeDlxUnIreXhrbm9rWDRlM1dwbUtP?=
 =?utf-8?B?Y3BkZUtsOTFjSHQyT0lUQ2JDV3RXVUZOZW05SURmcG5UTzhOZzh2dytpWVds?=
 =?utf-8?B?ZDFXazdJNnorVDk1REloRkNrRU1IcW5LbFFQOHU2RkV1aFpZcW4rQlhROTEw?=
 =?utf-8?B?L0orYmZPM1VSUENpSXpCTjlZOFZ5R2FETDVUYXc2NHBzL0tMd0VQcVV4YjVx?=
 =?utf-8?B?QmZVaTBreGZiQmI0N3VobHFuMkwrVXFCUUYyanhIK3NMektlNWJuZlY3RG96?=
 =?utf-8?B?a2lsVWxIVUJjN2xIOE84MTkwL3lCWmtRN0lLeTFVNjE0d1hFMUlpdmVpK1Y4?=
 =?utf-8?B?R1FwZ2p3K0NjTDIrZ1ZPWGVldmtyQXdSS0QwZGFvWHZBdjRaeFplM1BxRVN5?=
 =?utf-8?B?VzBQUVUyK3I3SnR1L1IrRU5QQ3E3WFV2ZWNsbjBlU1ErNUxwT0doblZRTzZX?=
 =?utf-8?B?NUd3TTFkUEhIL2NtbTZqK1k2VlErR3JqMUVtVVNFbXRET3duWis5QU1URHdt?=
 =?utf-8?B?L1BaT2tuZkZCc1hkVzZna0FkS2s1MG1ZM1M5SW5WVGtidHEwY2ovNlZ0eFI4?=
 =?utf-8?B?L3RSUlRMZlhDM0pHK3kwMy9RTlJOQ1Z4OHFzQ2ptaHJvcERKd2tUcHplSHhZ?=
 =?utf-8?B?YVZnQWMycDA1SHZUc3p6TEEyREQydkt4Sno2U29iRlhCQ051VlEvZ0NMU29V?=
 =?utf-8?B?a1JlRk13Y3dxbzYvS1FvR0d2YTd2UE15Q1FJenp3clZlRGdJUldyOFNKRXRl?=
 =?utf-8?B?RHFLU0pkVFcvajdGallGY1JMd0g3T1I4Uks3QUgvRklSUmR6eXUrN05lMHRj?=
 =?utf-8?B?d3BBWVdmenQrTlRjMi9MbGE1U2FDWGU3NlR0bUlTMVQ2TXFNV01kcXUwT3Jl?=
 =?utf-8?Q?51B85eWEA41raDWVpkDCWOvhI?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN9PR11MB5276.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8c5b1770-790f-4ffd-bb52-08db1fa9d577
X-MS-Exchange-CrossTenant-originalarrivaltime: 08 Mar 2023 07:50:49.4228
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: FIRmG9MDLaNVXr4qBwnbMhBCDHNt22jkHI9dz7eovPxWBY0y1YqUWnCtflWdsfh9isx0IklqA8YR9tJiNaqDjQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA0PR11MB7751
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

PiBGcm9tOiBBbGV4IFdpbGxpYW1zb24gPGFsZXgud2lsbGlhbXNvbkByZWRoYXQuY29tPg0KPiBT
ZW50OiBXZWRuZXNkYXksIE1hcmNoIDgsIDIwMjMgNzoyOSBBTQ0KPiANCj4gT24gVHVlLCA3IE1h
ciAyMDIzIDA1OjU0OjQ2ICswMDAwDQo+ICJUaWFuLCBLZXZpbiIgPGtldmluLnRpYW5AaW50ZWwu
Y29tPiB3cm90ZToNCj4gDQo+ID4gPiBGcm9tOiBKYXNvbiBHdW50aG9ycGUgPGpnZ0B6aWVwZS5j
YT4NCj4gPiA+IFNlbnQ6IE1vbmRheSwgTWFyY2ggNiwgMjAyMyA5OjU4IFBNDQo+ID4gPg0KPiA+
ID4gT24gRnJpLCBNYXIgMDMsIDIwMjMgYXQgMDU6NTQ6MjZBTSArMDAwMCwgSyBWIFAsIFNhdHlh
bmFyYXlhbmEgd3JvdGU6DQo+ID4gPiA+IEludGVsIFBsYXRmb3JtIE1vbml0b3JpbmcgVGVjaG5v
bG9neSAoUE1UKSBzdXBwb3J0IGlzIGluZGljYXRlZCBieQ0KPiA+ID4gcHJlc2VuY2UNCj4gPiA+
ID4gb2YgYW4gSW50ZWwgZGVmaW5lZCBQQ0llIERlc2lnbmF0ZWQgVmVuZG9yIFNwZWNpZmljIEV4
dGVuZGVkDQo+IENhcGFiaWxpdGllcw0KPiA+ID4gPiAoRFZTRUMpIHN0cnVjdHVyZSB3aXRoIGEg
UE1UIHNwZWNpZmljIElELkhvd2V2ZXIgRFZTRUMgc3RydWN0dXJlcw0KPiBtYXkNCj4gPiA+IGFs
c28NCj4gPiA+ID4gYmUgdXNlZCBieSBJbnRlbCB0byBpbmRpY2F0ZSBzdXBwb3J0IGZvciBvdGhl
ciBmZWF0dXJlcy4gVGhlIE91dCBPZiBCYW5kDQo+ID4gPiBNYW5hZ2VtZW50DQo+ID4gPiA+IFNl
cnZpY2VzIE1vZHVsZSAoT09CTVNNKSB1c2VzIERWU0VDIHRvIGVudW1lcmF0ZSBzZXZlcmFsIGZl
YXR1cmVzLA0KPiA+ID4gaW5jbHVkaW5nIFBNVC4NCj4gPiA+ID4NCj4gPiA+ID4gVGhlIGN1cnJl
bnQgVkZJTyBkcml2ZXIgZG9lcyBub3QgcGFzcyBEVlNFQyBjYXBhYmlsaXRpZXMgdG8gdmlydHVh
bA0KPiBtYWNoaW5lDQo+ID4gPiAoVk0pDQo+ID4gPiA+IHdoaWNoIG1ha2VzIGludGVsX3ZzZWMg
ZHJpdmVyIG5vdCB0byB3b3JrIGluIHRoZSBWTS4gVGhpcyBzZXJpZXMgYWRkcw0KPiA+ID4gRFZT
RUMNCj4gPiA+ID4gY2FwYWJpbGl0eSB0byB1c2VyIHZpc2libGUgbGlzdCB0byBhbGxvdyBpdHMg
dXNlIHdpdGggVkZJTy4NCj4gPiA+ID4NCj4gPiA+ID4gU2lnbmVkLW9mZi1ieTogSyBWIFAgU2F0
eWFuYXJheWFuYSA8c2F0eWFuYXJheWFuYS5rLnYucEBpbnRlbC5jb20+DQo+ID4gPiA+IC0tLQ0K
PiA+ID4gPiAgZHJpdmVycy92ZmlvL3BjaS92ZmlvX3BjaV9jb25maWcuYyB8IDggKysrKysrKysN
Cj4gPiA+ID4gIDEgZmlsZSBjaGFuZ2VkLCA4IGluc2VydGlvbnMoKykNCj4gPiA+DQo+ID4gPiBX
YXNuJ3QgdGhlIElEWEQvU0lPViB0ZWFtIHByb3Bvc2luZyB0byB1c2UgdGhlIGZhY3QgdGhhdCBE
VlNFQyBkb2Vzbid0DQo+ID4gPiBwcm9wb2dhdGUgdG8gaW5kaWNhdGUgdGhhdCBJTVMgZG9lc24n
dCB3b3JrPw0KPiA+ID4NCj4gPiA+IERpZCB0aGlzIHBsYW4gZ2V0IGFiYW5kb25lZD8gSXQgc2Vl
bXMgYXQgb2RkcyB3aXRoIHRoaXMgcGF0Y2guDQo+ID4NCj4gPiBOby4gR3Vlc3QgSU1TIHdpbGwg
YmUgaW5kaWNhdGVkIHZpYSBoeXBlcmNhbGwvdklSIGFzIHBsYW5uZWQuDQo+IA0KPiBUaGFuayBn
b29kbmVzcywgYmFzaW5nIGEgZmVhdHVyZSBvbiB0aGUgYWJzZW5jZSBvZiBhIGNhcGFiaWxpdHkg
dGhhdCdzDQo+IHN1YmplY3QgdG8gY2hhbmdlIHdvdWxkIGhhdmUgcmVhbGx5IHB1dCB1cywgb3Ig
SU1TLCBpbiBhIGNvcm5lci4NCj4gDQo+ID4gPiBXaHkgd291bGQgeW91IHVzZSBhICJQbGF0Zm9y
bSBNb25pdG9yaW5nIFRlY2hub2xvZ3kiIGRldmljZSB3aXRoIFZGSU8NCj4gPiA+IGFueWhvdz8N
Cj4gPg0KPiA+IEFjay4gSSBndWVzcyBpdCdzIGEgbW9uaXRvcmluZyBjYXBhYmlsaXR5IHBlciBQ
Q0kgZGV2aWNlIHRvIGZvcm0gYQ0KPiA+IHBsYXRmb3JtLWxldmVsIG1vbml0b3JpbmcgdGVjaG5v
bG9neS4gQnV0IHcvbyBhbGwgdGhvc2UgYmFja2dyb3VuZA0KPiA+IGFuZCB1c2FnZSBkZXNjcmlw
dGlvbiBpdCdzIHJlYWxseSBzdHJhbmdlIHRvIHBhc3MgYSAncGxhdGZvcm0nIGNhcGFiaWxpdHkN
Cj4gPiBpbnRvIGEgZ3Vlc3QuDQo+IA0KPiBJcyB0aGlzIHBlcmhhcHMgZm9yIHZhbGlkYXRpb24g
b2YgdGhlIGRldmljZSwgYmVjYXVzZSB5ZXMsIGFzc2lnbmluZw0KPiBwbGF0Zm9ybSBkZXZpY2Vz
IHRvIGEgVk0gZG9lc24ndCBzZWVtIGxpa2Ugc29tZXRoaW5nIGEgc3lzdGVtIHZlbmRvcg0KPiB3
b3VsZCB0ZW5kIHRvIHByb21vdGUuDQoNCmZyb20gdGhlIGRlc2NyaXB0aW9uIGluIHYyIHNvdW5k
cyBsaWtlIGl0J3MgYSB0ZWxlbWV0cnkvY3Jhc2hsb2cvZXRjLg0KY2FwYWJpbGl0eSBvbiBhIFBD
SSBkZXZpY2UsIHRob3VnaCBpdCdzIGNvbmZ1c2luZ2x5IGNhbGxlZCAncGxhdGZvcm0nLg0KDQo+
IA0KPiA+ID4gSG9uZXN0bHkgSSdtIGEgYml0IHJlbHVjdGFudCB0byBhbGxvdyBhcmJpdGFyeSBj
b25maWcgc3BhY2UsIHNvbWUgb2YNCj4gPiA+IHRoZSBzdHVmZiBwZW9wbGUgcHV0IHRoZXJlIGNh
biBiZSBkYW5nZXJvdXMuDQo+ID4gPg0KPiA+DQo+ID4gUHJvYmFibHkgYW4gYWxsb3dlZCBsaXN0
IHRvIG1hbmFnZSB3aGljaCBEVlNFQyBJRCBjYW4gYmUgZXhwb3NlZA0KPiA+IHRvIHVzZXJzcGFj
ZSB2aWEgdmZpby1wY2ksIGUuZy4gaWYgdGhlIFBNVCBJRCBpbiB0aGlzIHBhdGNoIGlzIHByb3Zl
ZA0KPiA+IHRvIGJlIHNhZmUgZm9yIGEgbWVhbmluZ2Z1bCB1c2FnZT8NCj4gDQo+IFdlbGwsIGxl
dCBtZSB0YWtlIHRoaXMgYSBkaWZmZXJlbnQgZGlyZWN0aW9uIGJlY2F1c2UgdGhlIHN1cHBvcnQN
Cj4gcHJvcG9zZWQgaGVyZSBvbmx5IGFsbG93cyByZWFkLW9ubHkgYWNjZXNzIHRvIHRoZSBEVlNF
QyBjYXBhYmlsaXR5LiAgSXMNCj4gdGhhdCBhY3R1YWxseSB1c2VmdWw/ICBEcml2ZXJzIG1ha2lu
ZyB1c2Ugb2Ygd3JpdGUgYWNjZXNzIHRvIERWU0VDIGFyZQ0KPiBnb2luZyB0byBmYWlsIGluIHVu
cHJlZGljdGFibGUgd2F5cyBpZiB0aGVpciB3cml0ZXMgYXJlIGRyb3BwZWQuICBUaGF0DQo+IHNl
ZW1zIHdvcnNlIHRoYW4gb3VyIGN1cnJlbnQgc3RhdGUgb2YgaGlkaW5nIGl0Lg0KDQpZZXAsIHRo
aXMgaXMgd2VpcmQuIEV2ZW4gd2hlbiBhIHRlbGVtZXRyeS9jcmFzaGxvZyBmZWF0dXJlIGlzIG1v
cmUgZm9yDQpyZWFkaW5nIGRhdGEgZnJvbSB0aGUgZGV2aWNlLCB0aGVyZSBzaG91bGQgYmUgY2Vy
dGFpbiBjb250cm9sIGtub2JzIHRvDQplbmFibGUvZGlzYWJsZSBpdCB0aGVuIHdyaXRlIGFjY2Vz
cyBpcyBhbHNvIHJlcXVpcmVkLg0KDQo+IA0KPiBXZSBhbHJlYWR5IHByb3ZpZGUgcmF3IHdyaXRl
IGFjY2VzcyB0byBib3RoIHRoZSBzdGFuZGFyZCBhbmQgZXh0ZW5kZWQNCj4gdmVuZG9yIHNwZWNp
ZmljIGNhcGFiaWxpdGllcywgd2h5IHdvdWxkbid0IHdlIGJ5IGRlZmF1bHQgZG8gdGhlIHNhbWUN
Cj4gZm9yIERWU0VDPyAgRGV2aWNlcyBhcmVuJ3QgbGltaXRlZCB0byBjb25maWcgc3BhY2UgaWYg
dGhleSB3YW50IHRvIGRvDQoNCm9oLCBJIHdhcyB1bmF3YXJlIG9mIGl0Lg0KDQo+IHNvbWV0aGlu
ZyBkYW5nZXJvdXMsIGF0IHNvbWUgcG9pbnQgd2UgbmVlZCB0byByZWx5IG9uIHBsYXRmb3JtDQo+
IGlzb2xhdGlvbi4NCg0KUHJvYmFibHkgaXQncyBlYXNpZXIgZm9yIEhXIHZlbmRvcnMgdG8gbWFr
ZSBzZWN1cml0eSBtaXN0YWtlIGluIGNvbmZpZw0Kc3BhY2Ugb3RoZXIgdGhhbiBpbiBNTUlPIGJh
ci4g8J+YiiBidXQgSSBhZ3JlZSBpZiBub2JvZHkgY29tcGxhaW5zIA0Kb24gaG93IFZTRUMgaXMg
aGFuZGxlIHRvZGF5IHRoZXJlIGlzIG5vIHJlYXNvbiB3aHkgd2Ugc2hvdWxkIG5vdCBkbw0KdGhl
IHNhbWUgdGhpbmcgZm9yIERWU0VDLg0KDQo+IA0KPiBJZiB0aGVyZSBhcmUgdW5kZXJseWluZyBj
b25jZXJucyBoZXJlLCB0aGVuIHdlIHByb2JhYmx5IG5lZWQgc29tZSBzb3J0DQo+IG9mIG9wdC1p
biBwb2xpY3kgd2hpY2ggcmVzdHJpY3RzIHZmaW8tcGNpIGZyb20gYmluZGluZyB0byBhbnl0aGlu
ZyBidXQNCj4gVkZzLiAgVGhhbmtzLA0KPiANCj4gQWxleA0KDQo=
