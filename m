Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 49CF162BCD6
	for <lists+kvm@lfdr.de>; Wed, 16 Nov 2022 13:01:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233745AbiKPMBv (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 16 Nov 2022 07:01:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48212 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233627AbiKPMBW (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 16 Nov 2022 07:01:22 -0500
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DD578532C1;
        Wed, 16 Nov 2022 03:53:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1668599632; x=1700135632;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=ErpvN5+s2QYWzp9tu4OGFKVLxYiv840zT332Swt3aLE=;
  b=Fjj/t1GbWdNqPco5RgvjxYmDXTaWDy561aKoVszxzb0zpwhZ6it8Ncoh
   c8MHZeRHgwhIJo7bcI3phGffm9oKsBVXSF0y3uW6GNDhtdw+9C8tT6eqa
   JsRlWICHJYmbmugW5GpDih1FjvVZD3TaFw/Wns8H2TlC02wNEfSa1a8dj
   0f9zwkbSCVW0gJiZaER094YhfozI6Xgf+T8VKNdM2ihJ5SsA/lIx6BVYY
   9VuuUVQ52xYWkDfj3bCZcm+L9vpDWcFnffvrxXLY75CspIhQ6FpbJZQ9p
   jBYAlTAU6HrA6UAI/VOPbXz/AF+kk48lxXtEL4qzn8MTQdDeoWirXfETV
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10532"; a="295889693"
X-IronPort-AV: E=Sophos;i="5.96,167,1665471600"; 
   d="scan'208";a="295889693"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Nov 2022 03:53:52 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10532"; a="745024456"
X-IronPort-AV: E=Sophos;i="5.96,167,1665471600"; 
   d="scan'208";a="745024456"
Received: from orsmsx601.amr.corp.intel.com ([10.22.229.14])
  by fmsmga002.fm.intel.com with ESMTP; 16 Nov 2022 03:53:52 -0800
Received: from orsmsx612.amr.corp.intel.com (10.22.229.25) by
 ORSMSX601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Wed, 16 Nov 2022 03:53:51 -0800
Received: from orsmsx601.amr.corp.intel.com (10.22.229.14) by
 ORSMSX612.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Wed, 16 Nov 2022 03:53:51 -0800
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31 via Frontend Transport; Wed, 16 Nov 2022 03:53:51 -0800
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (104.47.55.171)
 by edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2375.31; Wed, 16 Nov 2022 03:53:50 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hFA9pMszQUzJyCk4h6bq2Umna7tQeK9XWXdWjMFRwXZikpZM0QSQyYMgKexrmEoPxXh3LhruPE5xi0TgxB8E3TbSziDndxlwXrExqEYepnBeg1yxh0OcrTGhj27U2QD/gTZOxJEQ/UoukCfXa2hiDC2gVBDVzqdFVulc8wm9PFf/wDj9UZN2FtgmWnqJYzqITAAFeFUJF1glA9Iy9cylGiHvHavTpQ4YDRvhNnF8di8/otQ9YjP4Im3Jr4k2Mpx003vxM4A7gDwrW845RlOHalBB5fLD7+WnKRCyYGdC8sR04i9QKzMXAZPyxryJbWoWW/zwVjfdA1DLrhLDun+QWw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ErpvN5+s2QYWzp9tu4OGFKVLxYiv840zT332Swt3aLE=;
 b=Mlz3iaD5YgT+lkvtfus6AHznxHGY1du44VArPs24jBVdColfRFlZlpDKtmj/vRQYwaLEKVPcUzyD00Yvfue5JvUVhXW/Jz+MjRAhtKhwzbuwAO1J4C/yCxh0keJCKAihwLGyi/jQRI0kbaisCS+6nABs718Zl5c//YnGmGs1hUgOlbwEfJUMdx7hK2O6d/twn+c8c4tBJY80uTgI2N1g3fwbrwLpy5bpRpqO/kneDjmWLUHZnCvUlnnBk1h7lM2FlcFxifHtpjI6gB7FfXcNMuxmXNSoP1aUjLJFTMqXKZf0YojRzkJVMoSd/DFuV7QY25N8yhMaIRXlFJo/1xOOJA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5978.namprd11.prod.outlook.com (2603:10b6:208:385::18)
 by CO1PR11MB5185.namprd11.prod.outlook.com (2603:10b6:303:6e::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5813.19; Wed, 16 Nov
 2022 11:53:48 +0000
Received: from BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::2fb7:be18:a20d:9b6e]) by BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::2fb7:be18:a20d:9b6e%9]) with mapi id 15.20.5813.017; Wed, 16 Nov 2022
 11:53:48 +0000
From:   "Huang, Kai" <kai.huang@intel.com>
To:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Yamahata, Isaku" <isaku.yamahata@intel.com>
CC:     "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "Shahar, Sagi" <sagis@google.com>,
        "Aktas, Erdem" <erdemaktas@google.com>,
        "isaku.yamahata@gmail.com" <isaku.yamahata@gmail.com>,
        "Christopherson,, Sean" <seanjc@google.com>,
        "dmatlack@google.com" <dmatlack@google.com>
Subject: Re: [PATCH v10 045/108] KVM: x86/mmu: Add a private pointer to struct
 kvm_mmu_page
Thread-Topic: [PATCH v10 045/108] KVM: x86/mmu: Add a private pointer to
 struct kvm_mmu_page
Thread-Index: AQHY7CiLoJddw42+PkiEvfawWtRD9q5BdTcAgAAWogA=
Date:   Wed, 16 Nov 2022 11:53:47 +0000
Message-ID: <19527bcd4dcd4667cc863bea1647b5a4a824e216.camel@intel.com>
References: <cover.1667110240.git.isaku.yamahata@intel.com>
         <f2e0790612bb86bf1ebc2d5f5d94d72cc28dd1fd.1667110240.git.isaku.yamahata@intel.com>
         <00fc2a80784f9e007cffa9790c3dbd3109c3bec6.camel@intel.com>
In-Reply-To: <00fc2a80784f9e007cffa9790c3dbd3109c3bec6.camel@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.44.4 (3.44.4-2.fc36) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR11MB5978:EE_|CO1PR11MB5185:EE_
x-ms-office365-filtering-correlation-id: 2addb31e-ee08-4c39-9c97-08dac7c938ae
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: voZ3VAi2N1Q+yOKpaxNHzuC2fhClWqBDNP7/mqcLZmKh9ERveXv5PBZspxnOJXMwCEBgUYxkAv5F/NGfD4+ESYaK1XEcdH+V7UxHVH2J+P9E6bCaZ9/2mSBh0M85gDZ6HG9Xnh1IC2PsAs+JUB77O0QCNzrRzbegvBZrCmR/wtAvTuyM001JdDP3NYuNUtx1OGBIAwDj2pJvd2+tl1DnZ0M5tgeDTSypQ0ZRB0DPNsTgJZp/oN1AQgP3oF2wd0rj7WxRjr2W4ujKeCEpssvgAE1bcAyvfJUHnUcUqfD9zSgXN16tiSFDPh0qKXKJb00OaQGDLA98LR2iCWbvrNlaVzantiX+OuMzWoCtZJsIln7awquNth1RUfUX8j7T03hL520tfg1YalM9e+v1WMa44LAOl8erwNIM05zI7jpbBb/Q+kEoxLXguB0ndiS7LS2idovce07hXkRu0mGkOmYiv8zdKHp1Z03XaWxVZgiGD3V/MC0bCOntkwSmixLQaJGGTEKjSt7way4p8FkzVH6b6JAacb04nIt1OXfpXHaEjm6lB+S6s28yLvzs/sGEP5//UMjd+71HjlpQCYRsbxK3HpBF3nZIc2AGLnsHzrQ1+R+R4C0+s2LqbvO5+vEJFgqoOv8+YLBp6uPNaeXd0jLgESpYaLr5KdbDZ7urQA8r2tI22FRYGDkxn13OTS47zZT8MTc9viBJjqU9MwCuYCIl0j0f5cAipctkWqvNjf5NWXCt0mKEOJrRB9oxpq0dXZzrT1pbjMDdRjVgvWaY92NVxA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5978.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(136003)(39860400002)(396003)(366004)(376002)(346002)(451199015)(83380400001)(86362001)(122000001)(82960400001)(38100700002)(38070700005)(478600001)(71200400001)(6506007)(8676002)(91956017)(4326008)(76116006)(41300700001)(66446008)(64756008)(54906003)(110136005)(316002)(8936002)(66946007)(66556008)(6636002)(186003)(2616005)(6512007)(66476007)(26005)(5660300002)(4001150100001)(36756003)(2906002)(6486002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?MXQ3M2VIYVNScXM4cTJsUWVDVW80NUVFMUtQNkhmdnZ2Z25rWEtBelpQb09x?=
 =?utf-8?B?QU13WUFoeUNKOHIyQnNUb0NVSE41VDNRU1FMODhpa2N6OEJMbjI3RFFGL01z?=
 =?utf-8?B?M29FNWRnTXUyMXFPMHVjVWF4ZUl5YU8wa1pmdUNFN1FSdVg3STZwY0x4UnNq?=
 =?utf-8?B?STkwWm9DRXVIdzVWdXg0eWtlbllueVFIMmtMdmVZa1dKTW02MUwrTWlxRDJ5?=
 =?utf-8?B?dThpclRXY3hxbUZhaFZ3S1h4Vmx6RkVmR0hZOUxjMzNyYnZKQkVVSlZLWlJt?=
 =?utf-8?B?YkdqaTl3MXNUYXk5WFNDNHVQelpIMEdFdGptdnhLT1hkRkI2OW5ORDJMVDJx?=
 =?utf-8?B?M0tCQ21jeDlXUTJ6UzRwcm43cjJzWmFVVzVQU3BNVS9DbnJ2ZUp3bmJGdWhV?=
 =?utf-8?B?b1JUNGxnemJtbXpoYjJvUlkwOGw4ZlNacDlBTXJJMGt4aDltOTBDbE9jVXEr?=
 =?utf-8?B?SXJUSzd4NUM4ZU9SOVRVUFg3eitEMjg0MW5JUUFlUWxxTFJNMnQ1eXZlL0VS?=
 =?utf-8?B?TnEvelcxcnBJNG1MK0FpeWRKd2NnUXFKRm5abGlIQ3AweEo0MCtmTHcxRlB3?=
 =?utf-8?B?ODhlUmtXQm9pMjdRemx2bDg5OGZHd042Q2I1VHdhM0t5Q0x2dXpFWjlGS3I2?=
 =?utf-8?B?clNxRW5Bc0V1blZVbkxpQlZ0cUJPdlJFQnIxWGV2S1FpTk1pQkZzeDBVVDZN?=
 =?utf-8?B?OTRKaWN2OU80bllxR3M4TFQxaXUwZmxzV25oN3hoazhVTU5yb2s5L2N1WVRh?=
 =?utf-8?B?am9mNkZqQzlEMlZJY1lpK0NQbENFRmxtZk9ZWmwzaXFkRzE5R1NKTkdLcndI?=
 =?utf-8?B?VHR6MWczOXhRK3lWenJHS3hWMk5FNWFKTXdzcUIvcjhFT21oSjlqWGFxZVhi?=
 =?utf-8?B?dlVxMW55L3o5cXFVS0lGQmNIc3FtVHFMcW9VZ0xBY3VnWUp5MmlMNlcrYkln?=
 =?utf-8?B?NkREdXVNc3ZiL1JFem5CR1l5eFU0aS9Wc2twZm9oTG9XZFcxdlBlSWh4VlVH?=
 =?utf-8?B?T3ZOM2hIVmFhcHIzcGVKN2VNODY4c29Zd3NGUGZZaEZGTkx5NE10elhQRmR5?=
 =?utf-8?B?V3IrY3pSd0x0UnhrdXVXRHA4MzlHTkZxTzF2ZWhSUjZtYjNzeWo4UFRWL3Rp?=
 =?utf-8?B?VlVtMjIzSVhBTWZoVE5Icjc0aGVwRVIySSsxRkJIYXFBU0hvZStSTzgzNzFa?=
 =?utf-8?B?ZDJYQWN0TzNMeFl1eklhUlNWRGVLOW53NzBnVGpuemVMYlhPRVdORTErdS9o?=
 =?utf-8?B?VFF5NlJjZEVpNlBkaHFab1hnZ3NtR0tRZ0w1QUtrN3NXY1lLcHF3K3EyNmpZ?=
 =?utf-8?B?eWlERXF5d2N5WEhKTWw0d2ZsUDI4RTNRWFJUVzhjSXorNlRPbWpKeThzYk9G?=
 =?utf-8?B?WlJVZjNRSENwZ0tsMmx5aHlqM2lwVTNmMG5wMHpxQmRHQ2Y2aWZLZ2h5WTlF?=
 =?utf-8?B?SGJid0U4MFRFQjNBVHhuUHVUWDljTDliZlRoakoyUVo3YWc5dWNRQ0ZWRXNt?=
 =?utf-8?B?NTFKTWVMYlVxUzNwRXllTFdJTnBGSkpueXl5bUNPdDF5Ri9kUGtjb0R4cndP?=
 =?utf-8?B?NmVSM0w3YmIydkJLRXJyZTlNU0ZYMENCSTdZZjNSNDd1ejhZcU5OSGFuMmp5?=
 =?utf-8?B?WFExQlRxeWZnQm1TSDUvbWtRSko3V213UkxFRGtlVHIrZDNNUEhyRzBId3Fw?=
 =?utf-8?B?emtiRGR5cW1hU1BUbFlSWWNCWTBEbVhhWDlBU25qTjJQWVVjUkhrQ1RIVzQz?=
 =?utf-8?B?Z2NVZEdpaUl5dWlKNVpLbVFkNkpCbkhVWHF3RGhwYldhTmtxWHd2UkxrWDN6?=
 =?utf-8?B?SjF5SHVKaHdNRTcvak5MR0VyUXBRZnZBaDYzNk50MmtyL0I1anR3OXJlSzRI?=
 =?utf-8?B?dDVScjIrVFdtQ24xZzU5QlFHNWNHNVUxWW9nOTQrVk1vTEk2T1VIb3RNbEox?=
 =?utf-8?B?T3F0bXdLSjVlVERGbGFCZTB2eVlNTEJPa21PK0RKR3l4WlI4VzZacnVoaGpo?=
 =?utf-8?B?S0JuUUlTYnV1bFUxdk0zd09wdWNyVk5MZUtFbHdSUnlDMWFtc0R4d0UvNWdR?=
 =?utf-8?B?Y0dqdmdHQXpKS3FqQWZWU2hxUzZwTGphUXNiRThLdFY5SnVrU3lYNjcrSnpt?=
 =?utf-8?B?TnFRd0VHd3QyclM0T0VZY0VmdHk0b0lqUlJxMkNHU2JDWkxuZ1ZZa0pIY05R?=
 =?utf-8?B?UWc9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <E09CF4B18848BA448FF0675BC3775AFD@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5978.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2addb31e-ee08-4c39-9c97-08dac7c938ae
X-MS-Exchange-CrossTenant-originalarrivaltime: 16 Nov 2022 11:53:47.9511
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 3cRor+eB0jOrESK6kojD8LHw6TjQhDrUcfzOAxz05FSQEzaAjOU0G+ICNRZt1I59AtRvuiPn1I2Z5yzDSrD78w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO1PR11MB5185
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

T24gV2VkLCAyMDIyLTExLTE2IGF0IDEwOjMyICswMDAwLCBIdWFuZywgS2FpIHdyb3RlOg0KPiA+
ICsNCj4gPiArc3RhdGljIGlubGluZSB2b2lkIGt2bV9tbXVfYWxsb2NfcHJpdmF0ZV9zcHQoc3Ry
dWN0IGt2bV92Y3B1ICp2Y3B1LA0KPiA+ICsJCQkJCcKgwqDCoMKgIHN0cnVjdCBrdm1fbW11X21l
bW9yeV9jYWNoZQ0KPiA+ICpwcml2YXRlX3NwdF9jYWNoZSwNCj4gPiArCQkJCQnCoMKgwqDCoCBz
dHJ1Y3Qga3ZtX21tdV9wYWdlICpzcCkNCj4gDQo+IFRoaXMgZnVuY3Rpb24gaXMgdmVyeSB3ZWly
ZCBpbiB0aGUgY29udGV4dCBvZiB0aGlzIHBhdGNoLsKgIF9Pbmx5XyBhIG5ldyB2Y3B1LQ0KPiBz
Y29wZSAnbW11X3ByaXZhdGVfc3B0ZV9jYWNoZScgaXMgYWRkZWQgaW4gdGhpcyBwYXRjaCwgYnV0
IGhlcmUgeW91IGFsbG93DQo+IGNhbGxlcg0KPiB0byBwYXNzIGFuIGFkZGl0aW9uYWwgYXJndW1l
bnQgb2YgcHJpdmF0ZV9zcHRfY2FjaGUuwqAgU28gdGhlcmUgbXVzdCBiZSBhbm90aGVyDQo+IGNh
Y2hlIHdoaWNoIGlzIG5vdCBpbnRyb2R1Y2VkIGluIHRoaXMgcGF0Y2g/DQo+IA0KPiA+ICt7DQo+
ID4gKwkvKg0KPiA+ICsJICogdmNwdSA9PSBOVUxMIG1lYW5zIG5vbi1yb290IFNQVDoNCj4gPiAr
CSAqIHZjcHUgPT0gTlVMTCBpcyB1c2VkIHRvIHNwbGl0IGEgbGFyZ2UgU1BUIGludG8gc21hbGxl
ciBTUFQuwqANCj4gPiBSb290IFNQVA0KPiA+ICsJICogaXMgbm90IGEgbGFyZ2UgU1BULg0KPiAN
Cj4gSSBhbSBndWVzc2luZyB0aGlzICJ2Y3B1ID09IE5VTEwiIGNhc2UgaXMgZm9yICJFYWdlciBT
cGxpdHRpbmciPw0KPiANCj4gSWYgc28sIHdoeSBub3QgYWRkaW5nIGEgZ2xvYmFsIE1NVSBjYWNo
ZSBmb3IgcHJpdmF0ZV9zcHQgYWxsb2NhdGlvbiwgYW5kIG1ha2UNCj4gdmNwdS0+YXJjaC5tbXVf
cHJpdmF0ZV9zcHRfY2FjaGUgcG9pbnQgdG8gdGhlIGdsb2JhbCBjYWNoZT/CoCBJbiB0aGlzIGNh
c2UsIGluDQo+IHRoZSBjb250ZXh0IHdoZXJlIHlvdSBvbmx5IGhhdmUgJ2t2bScsIHlvdSBjYW4g
dXNlIHRoZSBnbG9iYWwgY2FjaGUgZGlyZWN0bHkuIA0KPiBBbmQgaW4gdGhlIGNvbnRleHQgd2hl
cmUgeW91IGhhdmUgYSAndmNwdScsIHlvdSBqdXN0IHVzZSB2Y3B1J3MgY2FjaGUuDQoNClNvIEkg
d2VudCB0aHJvdWdoIGFsbCBNTVUgcmVsYXRlZCBwYXRjaGVzIGluIHRoaXMgc2VyaWVzLCBidXQg
SSBjYW5ub3QgZmluZCBhDQpwbGFjZSB3aGVyZSB0aGlzIGZ1bmN0aW9uIGlzIGNhbGxlZCB3aXRo
ICd2Y3B1ID09IE5VTEwnIGFuZCBhIHZhbGlkIGNhY2hlIGlzDQpwYXNzZWQgaW4sIGlmIEkgYW0g
cmVhZGluZyBjb3JyZWN0bHkuDQoNCkFsc28gY2hlY2tlZCB0aGF0ICJFYWdlciBTcGxpdHRpbmci
IHVzZXMgYSBrdm0tc2NvcGUgY2FjaGUgZm9yIGxlZ2FjeSBNTVUsIGJ1dA0KanVzdCB1c2VzIF9f
Z2V0X2ZyZWVfcGFnZSgpIGZvciBURFAgTU1VLiAgQW5kIGluIGxhdGVyIHBhdGNoICJLVk06IHg4
Ni90ZHBfbW11Og0KU3VwcG9ydCBURFggcHJpdmF0ZSBtYXBwaW5nIGZvciBURFAgTU1VIiwgX19n
ZXRfZnJlZV9wYWdlKCkgaXMgYWxzbyB1c2VkIHRvDQphbGxvY2F0ZSB0aGUgcHJpdmF0ZV9zcHQg
KHdoaWNoIGlzIGNvbnNpc3RlbnQgd2l0aCBleGlzdGluZyBlYWdlciBzcGxpdHRpbmcNCmNvZGUp
Lg0KDQpTbyBJSVVDIG9ubHkgbGVnYWN5IE1NVSBjb2RlIHdpbGwgY2FsbCB0aGlzIGZ1bmN0aW9u
IHdpdGggJ3ZjcHUgPT0gTlVMTCcgYW5kIGENCnZhbGlkIGNhY2hlLiAgSW4gdGhpcyBjYXNlLCBw
bGVhc2UgcmVtb3ZlIHRoZSAncHJpdmF0ZV9zcHRfY2FjaGUnIGFyZ3VtZW50IGZvcg0Kbm93LCBh
bmQgbWFrZSB0aGUgZnVuY3Rpb24gYWx3YXlzIGFsbG9jYXRlIGZyb20gdGhlIHZjcHUtDQo+YXJj
aC5tbXVfcHJpdmF0ZV9zcHRfY2FjaGUuIMKgDQoNCllvdSBjYW4gYWRkIHRoZSBhZGRpdGlvbmFs
IGFyZ3VtZW50IHdoZW4gVERYIGdldHMgbGVnYWN5IE1NVSBzdXBwb3J0Lg0KDQpBbHNvLCBJIHRo
aW5rIHlvdSBuZWVkIHRvIG1vdmUgZWFnZXIgc3BsaXR0aW5nIHN1cHBvcnQgcGFydCAod2hldGhl
ciB0aGF0DQpoYW5kbGluZyBpcyBjb3JyZWN0IGlzIGFub3RoZXIgc3RvcnkpIGZyb20gdGhlIGxh
dGVyIHBhdGNoIHRvIHRoaXMgcGF0Y2guIA0KT3RoZXJ3aXNlIHRoaXMgcGF0Y2ggaXMgbm90IGNv
bXBsZXRlLg0KDQoNCj4gwqANCj4gPiArCSAqLw0KPiA+ICsJYm9vbCBpc19yb290ID0gdmNwdSAm
Jg0KPiA+ICsJCXZjcHUtPmFyY2gucm9vdF9tbXUucm9vdF9yb2xlLmxldmVsID09IHNwLT5yb2xl
LmxldmVsOw0KPiA+ICsNCj4gPiArCWlmICh2Y3B1KQ0KPiA+ICsJCXByaXZhdGVfc3B0X2NhY2hl
ID0gJnZjcHUtPmFyY2gubW11X3ByaXZhdGVfc3B0X2NhY2hlOw0KPiA+ICsJS1ZNX0JVR19PTigh
a3ZtX21tdV9wYWdlX3JvbGVfaXNfcHJpdmF0ZShzcC0+cm9sZSksIHZjcHUtPmt2bSk7DQo+ID4g
KwlpZiAoaXNfcm9vdCkNCj4gPiArCQkvKg0KPiA+ICsJCSAqIEJlY2F1c2UgVERYIG1vZHVsZSBh
c3NpZ25zIHJvb3QgU2VjdXJlLUVQVCBwYWdlIGFuZCBzZXQNCj4gPiBpdCB0bw0KPiA+ICsJCSAq
IFNlY3VyZS1FUFRQIHdoZW4gVEQgdmNwdSBpcyBjcmVhdGVkLCBzZWN1cmUgcGFnZSB0YWJsZQ0K
PiA+IGZvcg0KPiA+ICsJCSAqIHJvb3QgaXNuJ3QgbmVlZGVkLg0KPiA+ICsJCSAqLw0KPiA+ICsJ
CXNwLT5wcml2YXRlX3NwdCA9IE5VTEw7DQo+ID4gKwllbHNlIHsNCj4gPiArCQlzcC0+cHJpdmF0
ZV9zcHQgPQ0KPiA+IGt2bV9tbXVfbWVtb3J5X2NhY2hlX2FsbG9jKHByaXZhdGVfc3B0X2NhY2hl
KTsNCj4gPiArCQkvKg0KPiA+ICsJCSAqIEJlY2F1c2UgbW11X3ByaXZhdGVfc3B0X2NhY2hlIGlz
IHRvcHBlZCB1cCBiZWZvcmUNCj4gPiBzdGFyaW5nIGt2bQ0KPiA+ICsJCSAqIHBhZ2UgZmF1bHQg
cmVzb2x2aW5nLCB0aGUgYWxsb2NhdGlvbiBhYm92ZSBzaG91bGRuJ3QNCj4gPiBmYWlsLg0KPiA+
ICsJCSAqLw0KPiA+ICsJCVdBUk5fT05fT05DRSghc3AtPnByaXZhdGVfc3B0KTsNCj4gPiArCX0N
Cj4gPiArfQ0KPiA+ICsNCg0K
