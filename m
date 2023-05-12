Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C4EC06FFF11
	for <lists+kvm@lfdr.de>; Fri, 12 May 2023 04:53:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239759AbjELCxD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 11 May 2023 22:53:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41208 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231229AbjELCw7 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 11 May 2023 22:52:59 -0400
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 903FDE63;
        Thu, 11 May 2023 19:52:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1683859977; x=1715395977;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=wuptC22V1solj3Bdm0luIoBwA6DgILy9F8AaTG6V63Q=;
  b=cOReBoawXO7hQ6WccYS+gZKQ3CSPF8WrjRjoRiJ8x7Os55JoX1EnNp94
   B36zvvom4bzZaO1OifzOz8owgOxGNVVaeu6CBg9HRplDj9rxXYPunW2gz
   yAcQa5W+InkTlTsp59eQj2P7g1Mda5c5v9+MMb0oaXs/eS7p3GourQtqR
   ZZCJQFpPklggskjLli8EOegX5qiaU7M3op/0+1rvlcgQ6JIwOVSQGJJJJ
   8H0h+OTgJe+aAS5t7ocVlRAaodWctYcGUW37exrilM/rB41kDyt0HkrMf
   AzoUYNZWYCj68SYpBF+sIscJMO2Fp62/4d+l32G8OXvWYVsBgJAaCJY6W
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10707"; a="378824841"
X-IronPort-AV: E=Sophos;i="5.99,269,1677571200"; 
   d="scan'208";a="378824841"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 May 2023 19:52:57 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10707"; a="650469809"
X-IronPort-AV: E=Sophos;i="5.99,269,1677571200"; 
   d="scan'208";a="650469809"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by orsmga003.jf.intel.com with ESMTP; 11 May 2023 19:52:56 -0700
Received: from fmsmsx611.amr.corp.intel.com (10.18.126.91) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Thu, 11 May 2023 19:52:55 -0700
Received: from fmsmsx601.amr.corp.intel.com (10.18.126.81) by
 fmsmsx611.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Thu, 11 May 2023 19:52:55 -0700
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23 via Frontend Transport; Thu, 11 May 2023 19:52:55 -0700
Received: from NAM02-DM3-obe.outbound.protection.outlook.com (104.47.56.44) by
 edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.23; Thu, 11 May 2023 19:52:55 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=VTYM5G2Il/qC9q8K86yxxLPi/C49DTwlzW2vxfMAesNJAw0ySajxOOx+L369je9vSCw+DjVC5QKAJPOtPeUThQ286F0wETgQlJnPX1LAGpXK3AcylfF4KbqgAJGaJmDExAunsiXTxAwEMUjTPgPHbna73wnwVhjEQluWB+f7SJJHLJ/tSON9lkN5CULsJ4xW5uXoL5wl+voIlbv/X0Z66/oxe+jGs5LtIOcdoEXjxFUW9FQYR1hAbI6Jp8Q7kvW6dkmBkHFMiEnkCiZ2S0KElTZJ2wxnGQt+DJUsQen+f60AucVBLZt4hK2O9gl+n/KqKXoSrKXhr/wS1EW3m0u9sg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=wuptC22V1solj3Bdm0luIoBwA6DgILy9F8AaTG6V63Q=;
 b=NUnaTOWcCvEjk/WJXeWdIMZkMJd90bFndbisRyaJQZoGkMq3aBmilg2xNLEdbRWqNEi0abJn6bBzcIl87TAVamue0LFQw8FAoRjlLdJDYtjrzBcDaEPXFjqMRTNupxMOAo5YoQVt46d1i4QBr5rOMnfVKstGwMNqs/CbCrQmt2ZclRQc0zpy+OVtKyAwK7de+l8WJZC+NG7p5UpVDpf4PbmFhtIjWAF/JtME9sbQZ/lDWjS5lZ0kGpbEOW0zC8+aKlYkyBmdhcBEMfO7NAgEDjcsg6lMwgrFxYdwhmU/ZGc8dfknbkXAJm+kyY0Ecil3DHDu11ABtHU1WEJSSLRB0w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5271.namprd11.prod.outlook.com (2603:10b6:208:31a::21)
 by CYYPR11MB8305.namprd11.prod.outlook.com (2603:10b6:930:c1::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6363.33; Fri, 12 May
 2023 02:52:53 +0000
Received: from BL1PR11MB5271.namprd11.prod.outlook.com
 ([fe80::6f80:cda7:a88f:3cc1]) by BL1PR11MB5271.namprd11.prod.outlook.com
 ([fe80::6f80:cda7:a88f:3cc1%3]) with mapi id 15.20.6387.018; Fri, 12 May 2023
 02:52:53 +0000
From:   "Tian, Kevin" <kevin.tian@intel.com>
To:     Alex Williamson <alex.williamson@redhat.com>
CC:     Jason Gunthorpe <jgg@nvidia.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Liu, Yi L" <yi.l.liu@intel.com>,
        "Nicolin Chen" <nicolinc@nvidia.com>,
        "Lu, Baolu" <baolu.lu@intel.com>
Subject: RE: vPASID capability for VF
Thread-Topic: vPASID capability for VF
Thread-Index: AdmCTgezzTkHY+EMTOCoyMjynB/f5ABFkrqAABzyefAAEd18AAAWEYvQ
Date:   Fri, 12 May 2023 02:52:52 +0000
Message-ID: <BL1PR11MB52712DBEF65D0444B1FCE5828C759@BL1PR11MB5271.namprd11.prod.outlook.com>
References: <BN9PR11MB52764BE569672A02FE2A8CCA8C769@BN9PR11MB5276.namprd11.prod.outlook.com>
        <20230510112449.4d766f6f.alex.williamson@redhat.com>
        <BN9PR11MB52769ABFE779CE1D8838A7A78C749@BN9PR11MB5276.namprd11.prod.outlook.com>
 <20230511094512.11b5bb7e.alex.williamson@redhat.com>
In-Reply-To: <20230511094512.11b5bb7e.alex.williamson@redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR11MB5271:EE_|CYYPR11MB8305:EE_
x-ms-office365-filtering-correlation-id: 17413ce5-9dcf-4298-f74a-08db5293fb10
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 6zVG0NdgrM8TTBgG4knQvcTkUpOngrHPQNbv1jPtYhZzSfF4XBYbBQ2BAkwlI6zxXb4mq0JmMjJCwdBF7PZExPNjHsV6P+EzXRY65JsGlueJ7QZ0SxwzOFZxEjVJo8tm0y7m9AfERgdooWaOny5SA44YSYvioqdtcE8lpGvv455IiIk1dW//Vom2r/IRoQol1yIVFY1BLNq4LB+vl8G1NqymrNSP1p5Ukl308ZFfSqhIBWmPph+YqftsoUAkrqhCTP1lDm8BeKGZkVtEPN+mjYQhAi5ZER2zC55l74JLQQJiARtby/C+T8hHs2x1RDE2ghqdHYt2NzYuJrmUSs44qezVPAcm2JXUFlxJq6NFTZYJnF83LfbpC4nHFbEBGEfPIIs81/vHT2vExpbg7ibWvEe8TvCM2Placvhjg4Bn1lR1NC13IqkpSQLqarlgu61djXpboCPPDVm35OWpe/NMt+9i9zCohaYtY/oPME5nkpcV40IMjE3jX+k/Hobqjvk+av70MwePXzt+OEPUyKtL7SkJkxus4QsJyckrgEtQThzhlYw5/futwKkeQpz70uyU00Zs6MOGKk3eZuf+daE10PPBRWivDLSmdp6vxuPAMiEnBgzx2fUt+Iabs3Jc24SQ
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5271.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(39860400002)(366004)(396003)(376002)(136003)(346002)(451199021)(52536014)(316002)(3480700007)(66476007)(82960400001)(64756008)(66946007)(76116006)(66446008)(4326008)(33656002)(6506007)(6916009)(38070700005)(55016003)(38100700002)(107886003)(8936002)(9686003)(8676002)(54906003)(26005)(122000001)(83380400001)(66556008)(41300700001)(5660300002)(86362001)(186003)(478600001)(2906002)(7696005)(71200400001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?OENXT0N3VTEwL21hTWEyU2NmbGQ0dzlzUnMxLzUxbWNXdkp6bUg5MTFMK1pP?=
 =?utf-8?B?Vit6WkVqWGQ5eWJtMGx2ZS9mUlFRM2F0cGdpK0N6czE2R2xrT0JtVmtVMDB5?=
 =?utf-8?B?Q1ZoSlBMSE1qT1I1bXlXaVRxUjUxNnI0VTZMcjhMaG9Ba0VsdmdCQVN5Zko5?=
 =?utf-8?B?bGZ2UEtrM2dRNVhOYkt6QllqNlVWSzVVQzZLN3ZzQjRjWEZWR0VqMEkwbFd4?=
 =?utf-8?B?ckFkckRKbW5uNGIwVDhpUTZ1NjNieTk5bnJlZFAwM1Vya0pqeTNseFpDZ3dF?=
 =?utf-8?B?NDJTZThsbkVqcytxc0N0dGNLN3VlUjJiTUhobGFMT1g3SkNvZTAvdDlyUU1X?=
 =?utf-8?B?RnljMEhVSUdRYk5EK3RZQ0pjVjFEdXhkVUR3REl5OUNvcFQ0NEd0SjJJSWZK?=
 =?utf-8?B?WEQxOHcwYm0rVTFhbWZvWE9oTGtpdmwvbmJsN0FZRlplMitqclBseW1Bb2pF?=
 =?utf-8?B?MDdKS3gyT3hsWUk2WG9QV3BvOWloMXp0TldydnNyMXRWa2JwWVc2MXMwTGc2?=
 =?utf-8?B?QTRmT3FFNUQ2b05NYllRZy9aeUZvbE1IbmtCMTVqR25aWERocmVTY2RXVENn?=
 =?utf-8?B?eWkzd3lOTjZVYzY0aEdRMmVCbFlmeGp3VXZabGg3MHlsaGhtY2tHOTA4RWU2?=
 =?utf-8?B?eU5xclp4Q296ZStHZXNkZGM1RTJnY3JIUktaOVZEc3V6WWdTWG8yb21vNm5R?=
 =?utf-8?B?N2gyWG90SkVFaWl4U0F6Z21hK1pJU250dHZsZlJHZVhTZGhOVVI2SUFrS3VL?=
 =?utf-8?B?aExHVTY5YmxmSmFTbnRMZG43eTJQMnlPZGRGQ0UwY2tkazFFY3NZZHZpMVl4?=
 =?utf-8?B?WEM4SzlqbXFPNXZKV2ZyV1Q4NHhDc3ZjbXN0SFp3cExIQUVkVTMwajlsV1px?=
 =?utf-8?B?cTYwK3ZDeExoM1NTRG8zYjQzM0hDSEdpQm1NdHZwT29HVEJ2ZjlVVzFxWjdn?=
 =?utf-8?B?T2xTL1dkUzBBQ3JoYjR4eVorOGVpeXNqNXlLeHJaYkFISWRncnBDTU1NdmE3?=
 =?utf-8?B?NnFvWkM5WVhjdGRYSEk5eDFXMVFpQ0dWMnJKbHhuRW1xQnBxTjRadGNzZ0Vl?=
 =?utf-8?B?ZEUzZUM0L25VOEp1U0NSZFE2UVMyQWZ0Mmd1RCtYYWFNZklVbzdMYkxYd0Rp?=
 =?utf-8?B?Q1BNWE9CdTduZ1NvY3Fxc1RaYjRYRFZNb3ZOL2dvR3ZxeitodUg1dWxxYWl6?=
 =?utf-8?B?WFMvUENqeXEyRUl4Y0JNYU9jMzQzQ2I1cHlkM0RlSUNKTjYyQ2xzcmYzdUFs?=
 =?utf-8?B?R2RSZnNXbGFMSlRaR01LUStleVBodk9ZbFQydGdmMUhxKzIvdXUrQkJSSlpV?=
 =?utf-8?B?SEpyNTlBM1NkM1QxNGdMbEIvaHRUejFDMjJmcC9jNklPUHlNVy9ITk05bXhs?=
 =?utf-8?B?WFI4UUR5dmxYZXJEdlpLMGRWOUNrY25nc2huTXpWa1h3aDFJOG9vakxiT2ky?=
 =?utf-8?B?cVAzUkhPTDNGTlBsYng4VEFUTWgwVlVMRElHMjFTMDhoQjNOd1hDekpqUkMy?=
 =?utf-8?B?a0JVMUJwS3pJVXBFc2liVzl6RW5MZWhWQ3hGSy9zVFJqdy9HTmRtSjhmeG5K?=
 =?utf-8?B?N3Exa3F0ZHhjVG13ODUrd0FpVEFxTGI0YUlGR2swM1VGRWszK0JBaWdiR1dt?=
 =?utf-8?B?ZWVkemRTWFplRDNSSWU1SnpBY2ZTd2ZReFQvWXlYZk5aQ0Zyc2JjRWIvRGdF?=
 =?utf-8?B?bnB6SzRNd3UvRS92VnY4aHJ2WkZ4WlR1VEhvWWtPYnVzbEZKQVBxMmMwK2xI?=
 =?utf-8?B?Y1VQWFFuV2ZGZHVpTWJzeHRUbFFpWGFIcUNKRllRVUJHNmJRc0pWOUVyWmFa?=
 =?utf-8?B?ZmlpbS9uK21RM3pseEVXd0xWTW42U2U5S0htUEtQUVJtcHphV1RzK2RhbjV5?=
 =?utf-8?B?ZjBnS0R5UE5WQm4vZWxBWXVkV1ZRaWdSR3NxZFFFQTdyblBEWXR6WnZUeDZL?=
 =?utf-8?B?cWdubTJFTWkrMG9ZRXFJVGVwMjVWbWVISGpEeTNwa3YrNS9kcXk5S1F0WFNK?=
 =?utf-8?B?aHQ3Y212c1VtVm5SdkFsdkw3aUVCdVBNVy9VdlJ4UXpkOXRtOGt2MWZuSDd0?=
 =?utf-8?B?MVBrVGtjK2JhRTdiOVV1ZlBFTlhLeEhlMXJOeUUyR2dDNTJnWTVlQTR5d3Z6?=
 =?utf-8?Q?FEZ6OIZPwnRfBG2d9mbPz+M2Y?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5271.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 17413ce5-9dcf-4298-f74a-08db5293fb10
X-MS-Exchange-CrossTenant-originalarrivaltime: 12 May 2023 02:52:52.8356
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: rea8ZdCtB51hqsVl/skr7uwqmu9UD39HztRYt1v4ct34BozVmiuFPAnZmLMGLg8ov9PzBpU65uSFm82/dwPpEg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CYYPR11MB8305
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

PiBGcm9tOiBBbGV4IFdpbGxpYW1zb24gPGFsZXgud2lsbGlhbXNvbkByZWRoYXQuY29tPg0KPiBT
ZW50OiBUaHVyc2RheSwgTWF5IDExLCAyMDIzIDExOjQ1IFBNDQo+IA0KPiBPbiBUaHUsIDExIE1h
eSAyMDIzIDA3OjI3OjI3ICswMDAwDQo+ICJUaWFuLCBLZXZpbiIgPGtldmluLnRpYW5AaW50ZWwu
Y29tPiB3cm90ZToNCj4gDQo+ID4gPiBGcm9tOiBBbGV4IFdpbGxpYW1zb24gPGFsZXgud2lsbGlh
bXNvbkByZWRoYXQuY29tPg0KPiA+ID4gU2VudDogVGh1cnNkYXksIE1heSAxMSwgMjAyMyAxOjI1
IEFNDQo+ID4gPg0KPiA+ID4gT24gVHVlLCA5IE1heSAyMDIzIDA4OjM0OjUzICswMDAwDQo+ID4g
PiAiVGlhbiwgS2V2aW4iIDxrZXZpbi50aWFuQGludGVsLmNvbT4gd3JvdGU6DQo+ID4gPg0KPiA+
ID4gPiBBY2NvcmRpbmcgdG8gUENJZSBzcGVjICg3LjguOSBQQVNJRCBFeHRlbmRlZCBDYXBhYmls
aXR5IFN0cnVjdHVyZSk6DQo+ID4gPiA+DQo+ID4gPiA+ICAgVGhlIFBBU0lEIGNvbmZpZ3VyYXRp
b24gb2YgdGhlIHNpbmdsZSBub24tVkYgRnVuY3Rpb24gcmVwcmVzZW50aW5nDQo+ID4gPiA+ICAg
dGhlIGRldmljZSBpcyBhbHNvIHVzZWQgYnkgYWxsIFZGcyBpbiB0aGUgZGV2aWNlLiBBIFBGIGlz
IHBlcm1pdHRlZA0KPiA+ID4gPiAgIHRvIGltcGxlbWVudCB0aGUgUEFTSUQgY2FwYWJpbGl0eSwg
YnV0IFZGcyBtdXN0IG5vdCBpbXBsZW1lbnQgaXQuDQo+ID4gPiA+DQo+ID4gPiA+IFRvIGVuYWJs
ZSBQQVNJRCBvbiBWRiB0aGVuIG9uZSBvcGVuIGlzIHdoZXJlIHRvIGxvY2F0ZSB0aGUgUEFTSUQN
Cj4gPiA+ID4gY2FwYWJpbGl0eSBpbiBWRidzIHZjb25maWcgc3BhY2UuIHZmaW8tcGNpIGRvZXNu
J3Qga25vdyB3aGljaCBvZmZzZXQNCj4gPiA+ID4gbWF5IGNvbnRhaW4gVkYgc3BlY2lmaWMgY29u
ZmlnIHJlZ2lzdGVycy4gRmluZGluZyBzdWNoIG9mZnNldCBtdXN0DQo+ID4gPiA+IGNvbWUgZnJv
bSBhIGRldmljZSBzcGVjaWZpYyBrbm93bGVkZ2UuDQo+ID4gPg0KPiA+ID4gQmFja3VwIGZvciBh
IG1vbWVudCwgVkZzIGFyZSBnb3Zlcm5lZCBieSB0aGUgUEFTSUQgY2FwYWJpbGl0eSBvbiB0aGUN
Cj4gPiA+IFBGLiAgVGhlIFBBU0lEIGNhcGFiaWxpdHkgZXhwb3NlcyBjb250cm9sIHJlZ2lzdGVy
cyB0aGF0IGltcGx5IHRoZQ0KPiA+ID4gYWJpbGl0eSB0byBtYW5hZ2UgdmFyaW91cyBmZWF0dXJl
IGVuYWJsZSBiaXRzLiAgVGhlIFZGIG93bmVyIGRvZXMgbm90DQo+ID4gPiBoYXZlIHByaXZpbGVn
ZXMgdG8gbWFuaXB1bGF0ZSB0aG9zZSBiaXRzLiAgRm9yIGV4YW1wbGUsIHRoZSBQQVNJRCBFbmFi
bGUNCj4gPiA+IGJpdCBzaG91bGQgcmVzdHJpY3QgdGhlIGVuZHBvaW50IGZyb20gc2VuZGluZyBU
TFBzIHdpdGggYSBQQVNJRCBwcmVmaXgsDQo+ID4gPiBidXQgdGhpcyBjYW4gb25seSBiZSBjaGFu
Z2VkIGF0IHRoZSBQRiBsZXZlbCBmb3IgYWxsIGFzc29jaWF0ZWQgVkZzLg0KPiA+ID4NCj4gPiA+
IFRoZSBwcm90b2NvbCBzcGVjaWZpZWQgaW4gNy44LjkuMyBkZWZpbmVzIHRoaXMgZW5hYmxlIGJp
dCBhcyBSVy4gIEhvdyBkbw0KPiA+ID4gd2UgdmlydHVhbGl6ZSB0aGF0PyAgRWl0aGVyIGl0J3Mg
dmlydHVhbGl6ZWQgdG8gYmUgcmVhZC1vbmx5IGFuZCB3ZQ0KPiA+ID4gdmlvbGF0ZSB0aGUgc3Bl
YyBvciB3ZSBhbGxvdyBpdCB0byBiZSByZWFkLXdyaXRlIGFuZCBpdCBoYXMgbm8gZWZmZWN0LA0K
PiA+ID4gd2hpY2ggdmlvbGF0ZXMgdGhlIHNwZWMuDQo+ID4gPg0KPiA+DQo+ID4gQ3VycmVudGx5
IHRoZSBQQVNJRCBjYXAgaXMgZW5hYmxlZCBieSBkZWZhdWx0IHdoZW4gYSBkZXZpY2UgaXMgcHJv
YmVkDQo+ID4gYnkgaW9tbXUgZHJpdmVyLiBMZWF2aW5nIGl0IGVuYWJsZWQgaW4gUEYgd2hpbGUg
Z3Vlc3Qgd2FudHMgaXQgZGlzYWJsZWQNCj4gPiBpbiBWRiBpcyBoYXJtbGVzcy4gVy9vIHByb3Bl
ciBzZXR1cCBpbiBpb21tdSBzaWRlIHRoZSBWRiBjYW5ub3QNCj4gPiBkbyByZWFsIHdvcmsgd2l0
aCBQQVNJRC4NCj4gPg0KPiA+IEZyb20gdGhpcyBhbmdsZSBmdWxseSB2aXJ0dWFsaXppbmcgaXQg
aW4gc29mdHdhcmUgbG9va3MgZ29vZCB0byBtZS4NCj4gDQo+IFNvIHlvdSdyZSBzdWdnZXN0aW5n
IHRoYXQgdGhlIElPTU1VIHNldHVwIGZvciB0aGUgVkYgdG8gbWFrZSB1c2Ugb2YNCj4gUEFTSUQg
d291bGQgbm90IG9jY3VyIHVudGlsIG9yIHVubGVzcyBQQVNJRCBFbmFibGUgaXMgc2V0IGluIHRo
ZQ0KPiB2aXJ0dWFsaXplZCBWRiBQQVNJRCBjYXBhYmlsaXR5IGFuZCB0aGF0IHN1cHBvcnQgd291
bGQgYmUgdG9ybiBkb3duDQo+IHdoZW4gUEFTSUQgRW5hYmxlIGlzIGNsZWFyZWQ/DQoNCk5vIHRo
YXQgaXMgbm90IHRoZSBjYXNlLiBUaGUgSU9NTVUgc2V0dXAgaXMgaW5pdGlhdGVkIGJ5IHZJT01N
VQ0KYW5kIG9ydGhvZ29uYWwgdG8gdGhlIFBBU0lEIGNhcCB2aXJ0dWFsaXphdGlvbi4NCg0KRm9s
bG93aW5nIHRoZSBjdXJyZW50IElPTU1VIGJlaGF2aW9yIGFzIEJhb2x1IGRlc2NyaWJlZCB0aGUg
Z3Vlc3QNCndpbGwgYWx3YXlzIGVuYWJsZSB2UEFTSUQgaW4gdGhlIHZJT01NVSBkcml2ZXIuDQoN
CkV2ZW4gaWYgdGhlIGd1ZXN0IGltcGxlbWVudHMgYW4gZHJpdmVyLW9wdCBtb2RlbCBmb3IgdlBB
U0lEIGVuYWJsaW5nLA0KaW4gdHlwaWNhbCBjYXNlIHRoZSBndWVzdCBkcml2ZXIgd2lsbCBub3Qg
cmVxdWVzdCB2SU9NTVUgc2V0dXAgZm9yIFZGDQpQQVNJRHMgaWYgaXQgZG9lc24ndCBpbnRlbmQg
dG8gZW5hYmxlIHZQQVNJRCBjYXAuIEluIHRoaXMgY2FzZSB0aGUNCnBoeXNpY2FsIElPTU1VIGlz
IGxlZnQgYmxvY2tpbmcgVkYgUEFTSURzIGhlbmNlIGxlYXZpbmcgUEYgUEFTSUQgZW5hYmxlZA0K
ZG9lc24ndCBodXJ0Lg0KDQpJZiBhbiBpbnNhbmUgZ3Vlc3QgZHJpdmVyIGRvZXMgdHJ5IHRvIGVu
YWJsZSB2SU9NTVUgUEFTSUQgKHNvIFZGIFBBU0lEcw0KYXJlIGFsbG93ZWQgaW4gcGh5c2ljYWwg
SU9NTVUpIHdoaWxlIGxlYXZpbmcgdlBBU0lEIGRpc2FibGVkIGluIFZGLA0KSSdtIG5vdCBzdXJl
IHdoYXQgd291bGQgYmUgdGhlIGFjdHVhbCBwcm9ibGVtIGxlYXZpbmcgUEYgUEFTSUQgZW5hYmxl
ZC4NClRoZSBndWVzdCBkcml2ZXIga2luZCBvZiB3YW50cyB0byBmb29sIGl0c2VsZiBieSBhbHJl
YWR5IHNldHRpbmcgdXAgdGhlDQpmYWJyaWMgdG8gYWxsb3cgVkYgUEFTSUQgYnV0IHRoZW4gYmxv
Y2sgUEFTSUQgaW4gVkYgaXRzZWxmPw0KDQo+IA0KPiBUaGlzIGlzIHN0aWxsIG5vdCBzdHJpY3Rs
eSBpbiBhZGhlcmVuY2Ugd2l0aCB0aGUgZGVmaW5pdGlvbiBvZiB0aGUNCj4gUEFTSUQgRW5hYmxl
IGJpdCB3aGljaCBzcGVjaWZpZXMgdGhhdCB0aGlzIGJpdCBjb250cm9scyB3aGV0aGVyIHRoZQ0K
PiBlbmRwb2ludCBpcyBhYmxlIHRvIHNlbmQgb3IgcmVjZWl2ZSBUTFBzIHdpdGggdGhlIFBBU0lE
IHByZWZpeCwgd2hpY2gNCj4gY2xlYXJseSB2aXJ0dWFsaXphdGlvbiBpbnRlcmFjdGluZyB3aXRo
IHRoZSBJT01NVSB0byBibG9jayBvciBhbGxvdw0KPiBQQVNJRHMgZnJvbSB0aGUgVkYgUklEIGNh
bm5vdCBjaGFuZ2UuICBJcyBpdCBzdWZmaWNpZW50Pw0KPiANCj4gRm9yIGV4YW1wbGUgd2UgY2Fu
J3QgdXNlIHRoZSB2UEFTSUQgY2FwYWJpbGl0eSB0byBtYWtlIGFueSBndWFyYW50ZWVzDQo+IGFi
b3V0IGluLWZsaWdodCBQQVNJRCBUTFBzIHdoZW4gc2VxdWVuY2luZyBJT01NVSBvcGVyYXRpb25z
IHNpbmNlIHdlDQo+IGNhbid0IGFjdHVhbGx5IHByZXZlbnQgVkZzIHVzaW5nIFBBU0lEIHNvIGxv
bmcgYXMgUEFTSUQgRW5hYmxlIGlzIHNldA0KPiBvbiB0aGUgUEYuDQoNCklPTU1VIGNhcmVzIGFi
b3V0IGluLWZsaWdodCBQQVNJRCBUTFBzIG9ubHkgd2hlbiBpdCdzIHVuYmxvY2tlZC4NCg0KSWYg
aXQncyBhbHJlYWR5IGJsb2NrZWQgdGhlbiBpdCBkb2Vzbid0IG1hdHRlciB3aGV0aGVyIFZGIGlz
IHNlbmRpbmcgUEFTSUQNClRMUCBvciBub3QuDQoNCmJ0dyB0aGluayBhYm91dCB0aGUgY3VycmVu
dCBzaXR1YXRpb24uIEV2ZW4gaWYgdmZpby1wY2kgZG9lc24ndCBleHBvc2UNClBBU0lEIGNhcCB0
b2RheSwgaXQncyBwaHlzaWNhbGx5IGVuYWJsZWQgYnkgaW9tbXUgZHJpdmVyIGFscmVhZHkuIFRo
ZW4NCnRoZSBndWVzdCBpcyBhbHJlYWR5IGFibGUgdG8gcHJvZ3JhbSB0aGUgZGV2aWNlIHRvIHNl
bmQgUEFTSUQgVExQJ3MuDQoNCmZ1bGx5IHZpcnR1YWxpemluZyB2UEFTSUQgY2FwIGp1c3QgYWxp
Z25zIHdpdGggdGhpcyBmYWN0LiDwn5iKDQoNCj4gDQo+ID4gSW4gYW5vdGhlciB0aHJlYWQgaXQn
cyBzdWdnZXN0ZWQgdGhhdCBlbmFibGluZyB0aGUgUEFTSUQgY2FwIHNob3VsZCBiZQ0KPiA+IG9w
dGVkIGluIGJ5IGRldmljZSBkcml2ZXIgaW5zdGVhZCBvZiBieSBpb21tdSBkcml2ZXIuDQo+ID4N
Cj4gPiBJZiB0aGF0IGhhcHBlbnMgdGhlbiB2ZmlvLXBjaSBtYXkgd2FudCB0byBjYWxsIGludG8g
dGhlIFBGIGRyaXZlcg0KPiA+IHdoZW4gdGhlIHZQQVNJRCBjYXAgaXMgZW5hYmxlZCBpbiBWRi4g
SWYgdGhlIHBoeXNpY2FsIFBBU0lEIGNhcCBpbiBQRg0KPiA+IGhhc24ndCBiZWVuIGVuYWJsZWQg
dGhlbiBlbmFibGUgaXQuIFRoZSBQRiBkcml2ZXIgd2lsbCB0cmFjayB3aGljaCBWRidzDQo+ID4g
b3IgaXRzIG93biBjbGllbnRzIHJlcXVpcmUgdGhlIFBBU0lEIGNhcCBhbmQga2VlcCBpdCBlbmFi
bGVkIHVudGlsDQo+ID4gbm8gb25lIHdhbnRzIGl0Lg0KPiANCj4gV2h5IHdvdWxkbid0IHdlIGp1
c3QgcmVxdWlyZSBQQVNJRCBzdXBwb3J0IHRvIGJlIGVuYWJsZWQgYW5kIHJlbWFpbg0KPiBlbmFi
bGVkIG9uIHRoZSBQRiBvciBlbHNlIHdlIGRvbid0IGV4cG9zZSB0aGUgdmlydHVhbGl6ZWQgUEFT
SUQNCj4gY2FwYWJpbGl0eSBvbiB0aGUgVkY/DQo+IA0KPiBJIGRvbid0IHBhcnRpY3VsYXJseSBs
aWtlIHRoZSBpZGVhIG9mIGFsbG93aW5nIHVzZXJzcGFjZSBWRiBkcml2ZXJzIHRvDQo+IHZvdGUg
b24gdGhlIFBBU0lEIEVuYWJsZSBzdGF0ZSBvZiB0aGUgUEYgZHJpdmVyLiAgVGhlIFBGIGRyaXZl
ciBzaG91bGQNCj4gYmUgYWJsZSB0byBjb250cm9sIHRoZSBwb2xpY3kgd2hldGhlciBQQVNJRCBz
dXBwb3J0IGlzIGVuYWJsZWQsDQo+IGVzcGVjaWFsbHkgZ2l2ZW4gdGhlIGludGVyYWN0aW9uIHdp
dGggQVRTLCBhcyBub3RlZCBieSBCYW9sdS4gIFRoYW5rcywNCj4gDQoNCnRoYXQncyBmaW5lLiBQ
cm9iYWJseSBJIHdhcyBvdmVyLXRoaW5raW5nIHRoZSB3b3JsZCB3aGVyZSB0aGUgUEFTSUQNCmNh
cCBpcyBkeW5hbWljYWxseSBvcHRlZCBieSBkcml2ZXIuDQoNCmUuZy4gZXZlbiBqdXN0IHRhbGtp
bmcgYWJvdXQgUEYgYXNzaWdubWVudCBpdHNlbGYgd291bGQgd2Ugd2FudCB2ZmlvLXBjaQ0KdG8g
a2VlcCB0aGUgUEFTSUQgY2FwIGRpc2FibGVkIHVudGlsIHRoZSB1c2VyIHJlcXVlc3RzIHRvIGVu
YWJsZSBpdD8NCg0Kb2YgY291cnNlIGl0J3MgYW4gaW52YWxpZCBvcGVuIGlmIHdlIHRoaW5rIHRo
ZSBjdXJyZW50IHBvbGljeSBoYXZpbmcgUEFTSUQNCmVuYWJsZWQgYnkgZGVmYXVsdCBpbiBpb21t
dSBkcml2ZXIgY29udGludWVzIHRvIHdvcmsuDQoNClRoYW5rcw0KS2V2aW4NCg==
