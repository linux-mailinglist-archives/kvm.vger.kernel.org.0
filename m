Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A0C2369978B
	for <lists+kvm@lfdr.de>; Thu, 16 Feb 2023 15:36:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229966AbjBPOgR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 16 Feb 2023 09:36:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46228 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229674AbjBPOgQ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 16 Feb 2023 09:36:16 -0500
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CD1CC22A2E
        for <kvm@vger.kernel.org>; Thu, 16 Feb 2023 06:36:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1676558175; x=1708094175;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=arPStZi6P2F6Cn09+QJ0VPOpmU9hcpKNFOuCXoVQj6s=;
  b=idKFVm+WOigPH5PJAzOsnXvut0+KfPOhov1cb9PAWLDyzChlVWCwS5Mc
   W/3gwTRh0Xsfn5N1WHvCuL5CxhniLbkKMeRI1oRV3ifoSgDdxf0PpJysI
   qj5ByBBIWOli2NHXLU0c0ISFYhmj1xNiJmcPbWn4cBE6QrxZckpuxyAHu
   v7yUT8K2Hhjo9U1mULat4RPqWxi2qx6ZeOsa4Bg1VvFQ3zRkcxyQY3gf+
   JCBn6k8mhGUGA2aFssbprHs/pySdFWup0SJZ7KYlolBYbccjr+vNtPdm7
   emXQYNyp9NztFaeTYLlCmsYuFdQ9nsPHB6OcHDcvZuhlr/iqggCL7ETjF
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10623"; a="331726016"
X-IronPort-AV: E=Sophos;i="5.97,302,1669104000"; 
   d="scan'208";a="331726016"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Feb 2023 06:36:15 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10623"; a="672171445"
X-IronPort-AV: E=Sophos;i="5.97,302,1669104000"; 
   d="scan'208";a="672171445"
Received: from fmsmsx603.amr.corp.intel.com ([10.18.126.83])
  by fmsmga007.fm.intel.com with ESMTP; 16 Feb 2023 06:36:15 -0800
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Thu, 16 Feb 2023 06:36:14 -0800
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Thu, 16 Feb 2023 06:36:14 -0800
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Thu, 16 Feb 2023 06:36:14 -0800
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (104.47.58.168)
 by edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Thu, 16 Feb 2023 06:36:14 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=X1LnobMijV679nZP+Jjgg547KBeF4QV317zMEeXdabuiAfg2+CRKdtiyV4ktkULl6zPzlKk2Jd7C5WFFxDLqmrs2ynfNDwf2q2lZZv/NbCRgaUrPEh98P2IuaNBN2m1u1Y4f6beddXUqhKr1j90ph0BhPkj2BAV66dmIiv5Vce1YkOizFFB8NtVDjIBabTnyagBdgynbuFD59pZvmrUP28vpMnsuFO4VAxwNoRNOK8q5UqQ2IQDsNezPM+AjgreY2Df/jk4pOm/jsMeaJ/TaE1VJ2V43N0MRXl6CiFhZHpGjOMx5PochQHQNQMd26BJcroSKiR2YzoX9Lzn2ZHCRIA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=arPStZi6P2F6Cn09+QJ0VPOpmU9hcpKNFOuCXoVQj6s=;
 b=mwFrqPtsgPLTu9axJQdluGRpCFCd4gUG8S4Bd6zlxHqGf40VPqTD/IP/M6spnxuFjewtAW0JTxgBdpyJsvftIxI5VRnQs3JYTVI7mwTC0C8aMy6cS/4l4zcEKdiwqnsBDsu7YFV/AiudvjR7yH5lyEZTSpiXKlwKvasegRHyJBqXZkplTlh5nv7YgT44hJ+sKgjdUtqrS/r+yL0Z61I1OQl08QRAJq07maDhOFIDzJFsznGHPxEIxHLdhlS4MwrAFYb1xUwV1GAooCRipf4tWPPdW7G2jGRABa/v0XeranmwVboQ+Wt7CkP+ViEmGmlvIygItVw8SOAXtFF64s496w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from DS0PR11MB6373.namprd11.prod.outlook.com (2603:10b6:8:cb::20) by
 SN7PR11MB7511.namprd11.prod.outlook.com (2603:10b6:806:347::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6111.13; Thu, 16 Feb
 2023 14:36:12 +0000
Received: from DS0PR11MB6373.namprd11.prod.outlook.com
 ([fe80::cf29:418d:2ed1:c1b9]) by DS0PR11MB6373.namprd11.prod.outlook.com
 ([fe80::cf29:418d:2ed1:c1b9%5]) with mapi id 15.20.6086.026; Thu, 16 Feb 2023
 14:36:12 +0000
From:   "Wang, Wei W" <wei.w.wang@intel.com>
To:     "quintela@redhat.com" <quintela@redhat.com>,
        =?utf-8?B?QWxleCBCZW5uw6ll?= <alex.bennee@linaro.org>
CC:     Paolo Bonzini <pbonzini@redhat.com>,
        Pavel Dovgalyuk <pavel.dovgaluk@ispras.ru>,
        "qemu-devel@nongnu.org" <qemu-devel@nongnu.org>,
        Richard Henderson <richard.henderson@linaro.org>,
        Mark Burton <mburton@qti.qualcomm.com>,
        Bill Mills <bill.mills@linaro.org>,
        Marco Liebel <mliebel@qti.qualcomm.com>,
        Alexandre Iooss <erdnaxe@crans.org>,
        "Mahmoud Mandour" <ma.mandourr@gmail.com>,
        Emilio Cota <cota@braap.org>, kvm-devel <kvm@vger.kernel.org>,
        =?utf-8?B?UGhpbGlwcGUgTWF0aGlldS1EYXVkw6k=?= <f4bug@amsat.org>
Subject: RE: Future of icount discussion for next KVM call?
Thread-Topic: Future of icount discussion for next KVM call?
Thread-Index: AQHZQfDqI9tbGvRklkm/jIyMCFf6BK7RmTE6gAABVpA=
Date:   Thu, 16 Feb 2023 14:36:12 +0000
Message-ID: <DS0PR11MB637307EE325932FC2F1AE7CFDCA09@DS0PR11MB6373.namprd11.prod.outlook.com>
References: <87bklt9alc.fsf@linaro.org>
        <CAHDbmO3QSbpKLWKt9uj+2Yo_fT-dC-E4M1Nb=iWHqMSBw35-3w@mail.gmail.com>
 <875yc1k92c.fsf@secure.mitica>
In-Reply-To: <875yc1k92c.fsf@secure.mitica>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DS0PR11MB6373:EE_|SN7PR11MB7511:EE_
x-ms-office365-filtering-correlation-id: 7a8580a3-fc89-46c1-bdfc-08db102b26ce
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: idaM7fCGMltvRNEtNOW3s8vz1039Ysi07I2jhgBobiD3cxvxUJ+oD8f3hvS5u0g21+9CF/7SJYWpg6dTSFQsA3mCNCCRd3R+J/G8JGX2yr5bw7FsjfjgECa+2TtABulGUHBFs0UfjdjA5A00GuIGSjgpCOGPlJhmGvkQa3W9a9XU6m0lHTQ8X2KxWj9vbWYBkeO89fZv090pZhBL5d7MeL6ev6RioNmJGG9d5BB7gSFyMT8GcQJoApYRoS2fmxVP1CzkhIUEfxasChq0o43wSlXCMRhgmmGrqHs+vdn9c7BhX3AtheDsCz2rV4FFBxm7gLPgRs/fM3bzynuhPQGPkTTj34gwTkCRVmW+uO1gsPdKvE3bQyfUAvFH/XgcNTsak0LoedI+fcJheg63nzTwLPIHgEHgeJXr/HeIu+BOHCQqBJrDIwdmK+HCwu1M648A9Tl0D0F6ZRM3eBn4D3g1keLMINUWPCtP9ON5XrmeKSacwovA6PaDmqbiLzF7dtqK7bUSBrUCnp8wM+1z0vb/4R1eQMVUnw9d330x81CzB+mvUvBLh0TxOI3wYphwLamtQCxqk/xMpXKUsJPIuZ9cEvL3wMxCYZjNYdNAmqZRNIkYo2n/Yi69GkbERkXRCOzB3+xfNl5i55KI+444hBihJ4KuFIHZY4PQQRiYDr/Bwoeb6UbceHthtfZEwvBEuEOuf2+Go8KHLJMY3kBZEEcE9w==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR11MB6373.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(366004)(396003)(346002)(136003)(376002)(39860400002)(451199018)(41300700001)(122000001)(6506007)(26005)(53546011)(186003)(38100700002)(9686003)(82960400001)(83380400001)(110136005)(54906003)(33656002)(316002)(55016003)(86362001)(4326008)(64756008)(66476007)(66556008)(76116006)(66446008)(66946007)(478600001)(38070700005)(71200400001)(8676002)(7696005)(2906002)(7416002)(5660300002)(4744005)(52536014)(8936002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?NVAwOW84Y0V4NXBVYUwvUm5pYlVUNnBreTVDemsycERCekNmcE9LQnRBdGtN?=
 =?utf-8?B?WEw4V2Zobk4zM25YNVJXalgxbXdYalRnUWgwa3lvVlV4QWlJbjk3d0hKWWpj?=
 =?utf-8?B?YlpyZG9lSWNmbk1pSWJLWHlrS1dvM0tuSjNrdVJlcDd4N3I5d1pNVS9Pdm51?=
 =?utf-8?B?VXppdmFsNExDNDVEUHVQdkZickw5VHM3N3U0aVVPNHlQdFRNKzNldmtxakR5?=
 =?utf-8?B?UEtmSDdVOU55ckMxUi9PY1hXdXVNVmpQY1BtZ3VQWHdTT2FldjdST05oTk9r?=
 =?utf-8?B?eitwNzc2NnRrclhDdks3QTloN1IxQUZCREU4UmZpMUpCaTlJeTFjakk3eWo3?=
 =?utf-8?B?YjM5d3VLTnF0NitaWkxkYTcvM1IzNDY3YXhuYURyMFI4am1Uek12c3A4QnZy?=
 =?utf-8?B?czdKOFloZUZkbHdVZmtSQnVPSy8vaHhCRmZHSHJuTUNrVzZWMzY4M0Nxcjlp?=
 =?utf-8?B?RDlJODVUWkdVVEJqNENZNlNqbkRJQzMrSlU5UGhOdFRxbUd2WlRLeGIrNERz?=
 =?utf-8?B?VnRVekFIcFY0bWhvYlpMaE83c3ZQZ0NCS1lLR1dpVFdpbXJ0V3BzN2x6c1F1?=
 =?utf-8?B?MlZCK0JSMXk5ZC9iTWxFekQ2bngwQXh4WHRUOXZJWTZ5TVY0ZlgzaUEyeEhy?=
 =?utf-8?B?dkV3dUxNZjN5cGlPVTd5YlFLc2k0TkYvTk03clVwTEJjUG8zSlN6QWdmOVJm?=
 =?utf-8?B?WkFCeUNXWEIyV3ViUlVLTTVweVJRblM4ejB5dktFcmp5dUxXL3NJTHVSSXps?=
 =?utf-8?B?OVVnczFJdHZKRFJJS0FMVkRBMFMrYmhhR0FOMkMwZDd1U1VXT1NCREltcUFB?=
 =?utf-8?B?OS9jbmZjcG5XZDNQcXlIVHFsaWt4WGVrZlJiTjliZmVqNVBnZThBc1p1UGFT?=
 =?utf-8?B?bEpvNzhLVkJoaGcrT0VOVGRGNXNSU2FWU3VlcFc5N3lSTE1FalhFZDJjd2ps?=
 =?utf-8?B?U2VYK29tYVp3U29aVEQ0eTFsZm92Tk5BME4yYzNqSUhsSml5ejZnbzlSUm5Q?=
 =?utf-8?B?NzcxdjVXS2dScncwR0ZGSVdEKzZySCs3NWY0aFpVcUZ1RDhMQzQzbnV1dHVt?=
 =?utf-8?B?cExZWkFyRVJmUFVuVDVvYXBJSy9DMG5qbS9UK2ZzZHQ0eklhd1dreUNEK3ll?=
 =?utf-8?B?c3JFb0pUTzZsR1lTYmNPN0dUNlFuckltTW9jZW1MMXEvUXJNYTV6MkdJWG5X?=
 =?utf-8?B?NHZzbnlqWUNBRG9LUEgwQXRzb0VxdndnQXlZYmJQcmE1SGRPZUJNU3psOGhV?=
 =?utf-8?B?Z3c5T2Y3NWlXZWtxTGxTRUNUQzhXeHVib0NuMUs2eGoveHEzVlpzSm5PVHZP?=
 =?utf-8?B?NHBEc3RTNGtTQXE0SFRJSk9salVFQ1dhV09wWHFiSVVibnZWSmxpV05vaWNJ?=
 =?utf-8?B?OVRHUDlZcGVaUEltaS9xdDFGUEVWcVBxUVZYc05KelNVZEt3eFAzZjZsY1g0?=
 =?utf-8?B?WGJyVEt5WjdiMDBHM1dIZ2ZBVDgreVdNZ3g4bzdJZUEvQkorTVhjY3BjL0xC?=
 =?utf-8?B?bHc0SDVLQVM4YWF6SmIwK0V2cGwxOXZaOTF4cm0vOHV6bHdPSnlVKzNLWTJY?=
 =?utf-8?B?NkgrUlZvc1R0Nm9iaWtEOEJsMitSMWVORmlNNmRKUEhUQWZORklndklHZ0JD?=
 =?utf-8?B?ZXVsVXp0VE9nb0hjYzBRV29Dd2hJczVjTGl2TkVNS3hSaVdaaW45YjdkYjRE?=
 =?utf-8?B?Qzc2S05Wb3pNRUhuZk9nOGYwVG5PV2s4UHhSbGNzN2FlNm5SczU0a1ViYmN1?=
 =?utf-8?B?Q094Y3lLQk9ub0EzTVMyT0x0QzhJYnJpbS92anJXd0dETk5ZZk5XY05xQkZ2?=
 =?utf-8?B?dFI3dlI4eFVwa3dXL2tmN2JHaW82RDF5dndnNFQ4bFA2N2lXNlhwZmd0TGlj?=
 =?utf-8?B?bGFkQStwRVFJa0VpazVGZE51SFNzNHczS0RjUmVKWXRqWmx6dHZGMzhmRWRK?=
 =?utf-8?B?R2ZFYit3cjdpSG9tanJML25naWU3TjJKSnI5VHJjT0dJWFdXSVk2Z1VZb2tI?=
 =?utf-8?B?dnBSWEJhNkczS3huY1FMenNrcTNjYmRnejVGRis0ZGNLNEQ3L1prOXk5enVi?=
 =?utf-8?B?TGRYTVJWMzhsNStKYWJMUmIwNlNib1dzYmtzNlNGaUFGcEVtVGl1d1NiMWMr?=
 =?utf-8?Q?7FCuqejfDYoF6B1zOjTuWiRZI?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DS0PR11MB6373.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7a8580a3-fc89-46c1-bdfc-08db102b26ce
X-MS-Exchange-CrossTenant-originalarrivaltime: 16 Feb 2023 14:36:12.3622
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: rOzwRekuwCLOGRrgUZFWTqvgAaC+TnDFBmpph+MGbuc6W7Zv/uEGTOWZ2aug7CKle9zLbI7TXyFCLwnN5OgM/w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR11MB7511
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

T24gVGh1cnNkYXksIEZlYnJ1YXJ5IDE2LCAyMDIzIDk6NTcgUE0sIEp1YW4gUXVpbnRlbGEgd3Jv
dGU6DQo+IEp1c3QgdG8gc2VlIHdoYXQgd2UgYXJlIGhhdmluZyBub3c6DQo+IA0KPiAtIHNpbmds
ZSBxZW11IGJpbmFyeSBtb3ZlZCB0byBuZXh0IHNsb3QgKG1vdmVkIHRvIG5leHQgd2Vlaz8pDQo+
ICAgUGhpbGxpcGUgcHJvcG9zYWwNCj4gLSBURFggbWlncmF0aW9uOiB3ZSBoYXZlIHRoZSBzbGlk
ZXMsIGJ1dCBubyBjb2RlDQo+ICAgU28gSSBndWVzcyB3ZSBjYW4gbW92ZSBpdCB0byB0aGUgZm9s
bG93aW5nIHNsb3QsIHdoZW4gd2UgaGF2ZSBhIGNoYW5jZQ0KPiAgIHRvIGxvb2sgYXQgdGhlIGNv
ZGUsIFdlaT8NCg0KSXQncyBvayB0byBtZSB0byBjb250aW51ZSB0aGUgZGlzY3Vzc2lvbiBvbiBl
aXRoZXIgRmViIDIxc3Qgb3IgTWFyY2ggN3RoLCBhbmQgSSBwbGFuIHRvIGZpbmlzaCBzb21lIHVw
ZGF0ZSBhbmQgc2hhcmUgdGhlIGNvZGUgYmVmb3JlIGVuZCBvZiBuZXh0IHdlZWsuDQoNClRoYW5r
cywNCldlaQ0K
