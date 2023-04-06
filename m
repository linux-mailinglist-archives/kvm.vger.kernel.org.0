Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8B7CC6D9283
	for <lists+kvm@lfdr.de>; Thu,  6 Apr 2023 11:18:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236314AbjDFJSB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 6 Apr 2023 05:18:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58790 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235967AbjDFJSA (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 6 Apr 2023 05:18:00 -0400
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CD6BB1BE6;
        Thu,  6 Apr 2023 02:17:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1680772678; x=1712308678;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=GzSjlkOXKf2+N0HBWckK7TtHxxdEqwvOTEqOaCZACJM=;
  b=KtdVofe36qYwm+YYVcUl3cttBHYWP8fAKoUAw/mNkP60nzPKSJ+KrH0K
   3xmzRsLABOm1i2frKeeBM3j7/GV7p0fGWDMc/t43LPt5y/nlcyqkO+jnp
   5cPAX+LBWUdThcZJ0fJr3Cmxyz/exZHx2dfrisYpMFB9OkrRrPTICHTnj
   NBchCzsCkL3bhOlCp3z0YNG9B6qDuz3h13sGR/FdeVNnK9tydjbVb21rS
   Rb/7vQY29fkRNmpx+E70xhbuXpTzHthK/RT+A+/vsrE1tc2GI4pCuoecK
   2O7vJO33FYtitl1m/rmb5IIeT1FxdISElHsdCRkOg3DYlGXZKVel2oBWU
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10671"; a="345286929"
X-IronPort-AV: E=Sophos;i="5.98,323,1673942400"; 
   d="scan'208";a="345286929"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Apr 2023 02:17:58 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10671"; a="1016805876"
X-IronPort-AV: E=Sophos;i="5.98,323,1673942400"; 
   d="scan'208";a="1016805876"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by fmsmga005.fm.intel.com with ESMTP; 06 Apr 2023 02:17:57 -0700
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Thu, 6 Apr 2023 02:17:57 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Thu, 6 Apr 2023 02:17:57 -0700
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21 via Frontend Transport; Thu, 6 Apr 2023 02:17:57 -0700
Received: from NAM02-DM3-obe.outbound.protection.outlook.com (104.47.56.48) by
 edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.21; Thu, 6 Apr 2023 02:17:56 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jJANFSqktqJsZNsZ22EmukLpYoWGv/wRMGpo2IWNF8wNlqve9ULEutbIp80C99+YGEIE/uIgbMrYHllB6zSqeAeaQ8j3SoqjnUr5Tu1lwhwXNX9yNrHaOenVRS+zYHbP9DtUPM5FvXkzxocUwYInJJc4ENIf8w7lPo+bwsZDDehLWFBFjQ5jAQDZzQZ6qbeljR7IrfYGAg5IyKcubRm3owWOXcuEGwX1k58tqm3+PJ5CclKmqPcShNCFbQYfXjKYbv2/q506/hm+4TbZwfkW/VFof8i11FL94S8YW22XXqODr4SuzUXeA9idDgRH7iUOAbF58h8SAQ/Y6Z22qo3XCw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=GzSjlkOXKf2+N0HBWckK7TtHxxdEqwvOTEqOaCZACJM=;
 b=YNntiOCEw3EyE2M7r+W8RZsK2qmnwFshu+5AJRm0VgpWDfrv3CG2gUm1gHmT2a345xK/4NMQ4oRUChqW2sq2iM+pOMwzVhguoY6fVTewzOwUB/0k/a6k5QEBwrpB7zJcwCEZvC/vFfzFD9ON3I1qG9UuB6pJymOzhy+s2bgU4Jlv/AwQEHevU/lqS7ROD9N1c4ds/YLRsqCRKTpZmmnWY2VzuR95PqVWCag0JBM8VdW+9MDNB7LFWgpKoXv5mImV75USmLCMkWWtYFrYYY4DWZNxHt2+FYCkOfyLqY+E57mjGlC33Am37C/WE0Odf8GHj5O1MvUCaMuOI+Ee3e2MRA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5978.namprd11.prod.outlook.com (2603:10b6:208:385::18)
 by DS0PR11MB7532.namprd11.prod.outlook.com (2603:10b6:8:147::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6254.35; Thu, 6 Apr
 2023 09:17:54 +0000
Received: from BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::f403:a0a2:e468:c1e9]) by BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::f403:a0a2:e468:c1e9%5]) with mapi id 15.20.6254.033; Thu, 6 Apr 2023
 09:17:54 +0000
From:   "Huang, Kai" <kai.huang@intel.com>
To:     "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "Christopherson,, Sean" <seanjc@google.com>
CC:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "binbin.wu@linux.intel.com" <binbin.wu@linux.intel.com>
Subject: Re: [PATCH 2/2] KVM: VMX: Inject #GP, not #UD, if SGX2 ENCLS leafs
 are unsupported
Thread-Topic: [PATCH 2/2] KVM: VMX: Inject #GP, not #UD, if SGX2 ENCLS leafs
 are unsupported
Thread-Index: AQHZaBjVaqwUToI390GQi+QIa02Ixq8eASCA
Date:   Thu, 6 Apr 2023 09:17:54 +0000
Message-ID: <03504796e42badbb39d34b9e99c62ac4c2bb9b6f.camel@intel.com>
References: <20230405234556.696927-1-seanjc@google.com>
         <20230405234556.696927-3-seanjc@google.com>
In-Reply-To: <20230405234556.696927-3-seanjc@google.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.46.4 (3.46.4-1.fc37) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR11MB5978:EE_|DS0PR11MB7532:EE_
x-ms-office365-filtering-correlation-id: ef963a21-8613-4f0c-2f94-08db367fcdd8
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: mldLyNP8nDzVvr0+v5PjKgDkfuTfSyx6D4AZEJbBldJnO/Y8OsRzlDRXId9NnNm+oVNvuXMFzhEka/DfHj31iP6/2ZKC/Tmtex0qC8ZoHyEujcBRYDhQT1oWBdc///8R+VkpE8lOzoE3jfGVKPKJ4Z9aH5o2NZF/UdwFngQ2rC+xGjeoVIQ3hRBLiKB22v0UBtS2NWlHZUGHSg8zSArXqPdOvnz0XsaqkD0tgUFvgZgP9y38iIDn8lvCvRJGC0VsVdzazAeTGpOUG/46LmxoSTx2IGqxc31AtRz3gnZRkbgwfP9/ArCGWhS77tT6dyMCf+h5wzp4SE4V6g5WUIIRXcD9DucBM11GUiaYit7LkbVeOWUrpLJZHrkOX5t7szQ9XSxct0nmcUhDFQYZueETRIuQHBOipqea2dTgSR6GUUmWjNJgaDrtrYw1Igd5G7FOVDUiKGbDiP2nsjogciTJwLwQEZMvPqW6SuDyeKOgD2usc4j3aXX6HY43pG9TnG+tsMcKrzmfbiMRMuC5QoeC5+ruqIEZ9jnxfEmkiUr/fFUIJqShGSxGz+1+h6R7OBXp3JY5I8HKCZC6w6KwD82mkzO0izv9CxoAPz5KHtP3S+odbnhQioF+9xWGecby2vT3
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5978.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(376002)(39860400002)(136003)(346002)(396003)(366004)(451199021)(5660300002)(66556008)(186003)(86362001)(36756003)(316002)(478600001)(6486002)(110136005)(71200400001)(54906003)(38100700002)(91956017)(41300700001)(8676002)(2906002)(8936002)(76116006)(82960400001)(4326008)(66946007)(66446008)(64756008)(38070700005)(26005)(122000001)(66476007)(6512007)(6506007)(83380400001)(2616005);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?Ty9pWWZrcE5Uemt3RVd3TXEzNFQwa3J3WWtna29wbXZyaUovREkxbDJQWDVW?=
 =?utf-8?B?dWRlVkMwUFk1V0xENnloVjhZajZFNTdGWjRmMHUvOTFlN3E1RWtqODRyZDd3?=
 =?utf-8?B?azVjTEZHZEhQY0ZjRVZSUnZiV2NLOURsby9Mb2JuZ3lnYTRYdktPaWs4d1Zs?=
 =?utf-8?B?SGprYWQ0WG9Vd2hiR3FVMkFnamd4eHFOL3RmSUxlNDZZN3MzQy92ZTRKYkpK?=
 =?utf-8?B?RTZTRTBHdlNCUVZ2aWs2NEI5R3Q0UTRWTm9qcmpHOWQ3dHRtSWhOVmUyNllM?=
 =?utf-8?B?bjQwZVY5WGNGNEtaWlZFa0V6Q3dlTEJ0aGliVy9wMk1NcG15RzBGQ29LUC9P?=
 =?utf-8?B?WktEU3pQeFp5QXNTaWtLRnF4SWxJcXoyK3M4c01GOHVHYUo3MUVxSnNnV0NY?=
 =?utf-8?B?QXZWRWdvT3BOUXJSUEZEN3NjRDUrbkhLVXozekttS0lFZkM1OGluYnhaR3Rh?=
 =?utf-8?B?TzJiVkx6Snp0T2M2MjVKd0RBN2RlZ3N5dVJqR0t0ZHJVL2FSZTc4NHRYZUow?=
 =?utf-8?B?QXlXVFNQSm9rWkNMaFNmcHZDYlJ1VHIzeURFSVdJKzF0Zmd0QnZHckNQc1Rk?=
 =?utf-8?B?VFcyeXJQOVM2UGsxNCtQYUpQcnVvRzZJUmhqMUFuRU81ZTZiemkwRUJDUDhq?=
 =?utf-8?B?RVU0aWNSMkw1M0JZTm5yRys3MmJzcnV1V3U2Z043UXhOaFdHdml2cHJnQTQx?=
 =?utf-8?B?dTFVY3RNQ3VKcVhpM1JKQS9FUmZySWhrMmc4djVxRlZhNHl0ZDNXdkJGR3dZ?=
 =?utf-8?B?UTk1MW4xY3lnZzZrbE1hdXJsYUF4VkZwZlJ4c1JKSWIwelNyTDRTT3VSMnNY?=
 =?utf-8?B?dFg5cUpjemx2SmdOU05PeERhWFUrWGdMb1JwcnZ5VTgwNHl2dzlzNVB5dlJS?=
 =?utf-8?B?WCtCYnRBcWlDRk43M0NsbEQ4cFBlTnlNWm1WdFY4Y2NUd1c1VFBWQmYzU2w3?=
 =?utf-8?B?NlErZG9FOXpucUZnNU5QOS9yckRoRHNFMXNHSmNpalpBaXJlN1JRcHhHS0VW?=
 =?utf-8?B?UnlHWUZJSzAwQVNETU1GRHBraklqSDFINEsybFk3by92Q256ZXcxUVhGaEMx?=
 =?utf-8?B?Z3U2NjNueUNqbFVGNVJ1UDBoMlphbFh6a3duVVI5aTJVVDBjeThIYkJBYlBL?=
 =?utf-8?B?Qkt5K1U0Q1lQM1VNUHYzbHBBbmNXRG5wUGhCYWtTek5rZ2x1YnhHd0RFaGlX?=
 =?utf-8?B?L3dxNnYxKzVEZi9UdG5CaUZFYnh4SGR5WkdTUTZtdm1ybDA1VnArdmg1WXpM?=
 =?utf-8?B?OTFXdFdxaGJ3ZTRMZ1I1R21KamhZNmViaitKOVBka2pGUVRZeWh0eGtLNm1U?=
 =?utf-8?B?djhaeGcvTlJ5RjVPU3ZoRmdta3k3Ly9pNlZia0tSV1ZDWlR5TDRSRDNxbXlF?=
 =?utf-8?B?TzJBZG9tUjhrSUc2M3RqczNjUkx1Qnl0OFRqR1E4VWQ4aDVvZFFDd2owM21w?=
 =?utf-8?B?UmNnRFBVZHhxUFlxR1dkak5VV3lnTW5sNnNnNVpXb0ZuVVpiVXBKaUFXaVI2?=
 =?utf-8?B?aVZKZVdqYzdXU0RhY1AwL0NZR0cveHJIdXBjYzBmRWM0c3Q4NExyS3lZR2Zv?=
 =?utf-8?B?L2lZRFBKa2U0d29YMkRCeTJjYVJPbkhMWk1hRU95YjZsUTkrckFUbGJUOGxt?=
 =?utf-8?B?dk1KOU9Cc21XaEI4cEdZZkJZYkhBL0JpNCtGeTlKOW91bVBWR0ExRGhJOFlR?=
 =?utf-8?B?VWY1dmVuaFZXdjh6S044WkxLMVlqV1YzL0k3M09tb1I4a2RtaWt6R2xUdjB0?=
 =?utf-8?B?bnBtLytLQWlRN2EvV2tSMVkrWjlkcG0rZzdRZGp2QjlIOGlYNUkyNFRMTXRm?=
 =?utf-8?B?R0RicFpRZkptQ0NzaGJxWktoY0hDb1hnVlpqaE50SGlKZzIxdjFpL0NLamhR?=
 =?utf-8?B?eXhvWmV5VTdrdUpZNGFWK0l2ZGhaZUhEN3J5SllxRjR3ZFRYMzBPcjdjOEJE?=
 =?utf-8?B?amdsZTUzVE9UVEQ2dHRTMU5hU0k0NnRXV0Y5b0lRdmFZWkV3TVkwTHNwUWtC?=
 =?utf-8?B?QWRRSHFPMVkxVjk1L0JvZEJucytqVjQrTWYvSU5pOG0vb3JPUHJrckhudVh5?=
 =?utf-8?B?QmVaWjRlNWFIaGlzUHdmS2duZ2tPMWFCT2ZVOEZINEZJTVhSR2Z4NGp3S3dG?=
 =?utf-8?Q?vCb2QbFmUi9amENqOUPT9oS8u?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <3673CEDD74814C44AAE50C19A168232F@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5978.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ef963a21-8613-4f0c-2f94-08db367fcdd8
X-MS-Exchange-CrossTenant-originalarrivaltime: 06 Apr 2023 09:17:54.4746
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 8cPvyCbRuRpwbmpPoOKakbty8QvWjgmwt4X2NFXkeL89et11mseW1lIyi8CYd4mVMG+kcno668iFelC30nLhxQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR11MB7532
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

T24gV2VkLCAyMDIzLTA0LTA1IGF0IDE2OjQ1IC0wNzAwLCBTZWFuIENocmlzdG9waGVyc29uIHdy
b3RlOg0KPiBQZXIgSW50ZWwncyBTRE0sIHVuc3VwcG9ydGVkIEVOQ0xTIGxlYWZzIHJlc3VsdCBp
biBhICNHUCwgbm90IGEgI1VELg0KPiBTR1gxIGlzIGEgc3BlY2lhbCBzbm93Zmxha2UgYXMgdGhl
IFNHWDEgZmxhZyBpcyB1c2VkIGJ5IHRoZSBDUFUgYXMgYQ0KPiAic29mdCIgZGlzYWJsZSwgZS5n
LiBpZiBzb2Z0d2FyZSBkaXNhYmxlcyBtYWNoaW5lIGNoZWNrIHJlcG9ydGluZywgaS5lLg0KPiBo
YXZpbmcgU0dYIGJ1dCBub3QgU0dYMSBpcyBlZmZlY3RpdmVseSAiU0dYIGNvbXBsZXRlbHkgdW5z
dXBwb3J0ZWQiIGFuZA0KPiBhbmQgdGh1cyAjVURzLg0KDQpJZiBJIHJlY2FsbCBjb3JyZWN0bHks
IHRoaXMgaXMgYW4gZXJyYXR1bSB3aGljaCBjYW4gY2xlYXIgU0dYMSBpbiBDUFVJRCB3aGlsZQ0K
dGhlIFNHWCBmbGFnIGlzIHN0aWxsIGluIENQVUlEPw0KDQpCdXQgSSBhbSBub3Qgc3VyZSB3aGV0
aGVyIHRoaXMgcGFydCBpcyByZWxldmFudCB0byB0aGlzIHBhdGNoPyAgQmVjYXVzZSBTRE0NCmFs
cmVhZHkgc2F5cyBFTkNMUyBjYXVzZXMgI1VEIGlmIFNHWDEgaXNuJ3QgcHJlc2VudC4gIFRoaXMg
cGF0Y2ggY2hhbmdlcw0KInVuc3VwcG9ydGVkIGxlYWYiIGZyb20gY2F1c2luZyAjVUQgdG8gY2F1
c2luZyAjR1AsIHdoaWNoIGlzIGFsc28gZG9jdW1lbnRlZCBpbg0KU0RNLg0KDQo+IA0KPiBGaXhl
czogOTc5OGFkYmMwNGNmICgiS1ZNOiBWTVg6IEZyYW1lIGluIEVOQ0xTIGhhbmRsZXIgZm9yIFNH
WCB2aXJ0dWFsaXphdGlvbiIpDQo+IENjOiBCaW5iaW4gV3UgPGJpbmJpbi53dUBsaW51eC5pbnRl
bC5jb20+DQo+IENjOiBLYWkgSHVhbmcgPGthaS5odWFuZ0BpbnRlbC5jb20+DQo+IFNpZ25lZC1v
ZmYtYnk6IFNlYW4gQ2hyaXN0b3BoZXJzb24gPHNlYW5qY0Bnb29nbGUuY29tPg0KPiAtLS0NCj4g
IGFyY2gveDg2L2t2bS92bXgvc2d4LmMgfCAxNSArKysrKysrKystLS0tLS0NCj4gIDEgZmlsZSBj
aGFuZ2VkLCA5IGluc2VydGlvbnMoKyksIDYgZGVsZXRpb25zKC0pDQo+IA0KPiBkaWZmIC0tZ2l0
IGEvYXJjaC94ODYva3ZtL3ZteC9zZ3guYyBiL2FyY2gveDg2L2t2bS92bXgvc2d4LmMNCj4gaW5k
ZXggZjg4MWY2ZmY2NDA4Li4xYzA5MmFiODljMzMgMTAwNjQ0DQo+IC0tLSBhL2FyY2gveDg2L2t2
bS92bXgvc2d4LmMNCj4gKysrIGIvYXJjaC94ODYva3ZtL3ZteC9zZ3guYw0KPiBAQCAtMzUwLDEx
ICszNTAsMTIgQEAgc3RhdGljIGludCBoYW5kbGVfZW5jbHNfZWluaXQoc3RydWN0IGt2bV92Y3B1
ICp2Y3B1KQ0KPiAgDQo+ICBzdGF0aWMgaW5saW5lIGJvb2wgZW5jbHNfbGVhZl9lbmFibGVkX2lu
X2d1ZXN0KHN0cnVjdCBrdm1fdmNwdSAqdmNwdSwgdTMyIGxlYWYpDQo+ICB7DQo+IC0JaWYgKCFl
bmFibGVfc2d4IHx8ICFndWVzdF9jcHVpZF9oYXModmNwdSwgWDg2X0ZFQVRVUkVfU0dYKSkNCj4g
LQkJcmV0dXJuIGZhbHNlOw0KPiAtDQo+ICsJLyoNCj4gKwkgKiBFTkNMUyAjVURzIGlmIFNHWDEg
aXNuJ3Qgc3VwcG9ydGVkLCBpLmUuIHRoaXMgcG9pbnQgd2lsbCBiZSByZWFjaGVkDQoNCldoeSAj
VURzIGluc3RlYWQgb2YgI1VEPyAgSXMgI1VEIGEgdmVyYj8NCg0KPiArCSAqIGlmIGFuZCBvbmx5
IGlmIHRoZSBTR1gxIGxlYWZzIGFyZSBlbmFibGVkLg0KPiArCSAqLw0KDQpJcyBpdCBiZXR0ZXIg
dG8gbW92ZSAiRU5DTFMgI1VEcyBpZiBTR1gxIGlzbid0IHN1cHBvcnRlZCIgcGFydCB0byAuLi4N
Cg0KPiAgCWlmIChsZWFmID49IEVDUkVBVEUgJiYgbGVhZiA8PSBFVFJBQ0spDQo+IC0JCXJldHVy
biBndWVzdF9jcHVpZF9oYXModmNwdSwgWDg2X0ZFQVRVUkVfU0dYMSk7DQo+ICsJCXJldHVybiB0
cnVlOw0KPiAgDQo+ICAJaWYgKGxlYWYgPj0gRUFVRyAmJiBsZWFmIDw9IEVNT0RUKQ0KPiAgCQly
ZXR1cm4gZ3Vlc3RfY3B1aWRfaGFzKHZjcHUsIFg4Nl9GRUFUVVJFX1NHWDIpOw0KPiBAQCAtMzcz
LDkgKzM3NCwxMSBAQCBpbnQgaGFuZGxlX2VuY2xzKHN0cnVjdCBrdm1fdmNwdSAqdmNwdSkNCj4g
IHsNCj4gIAl1MzIgbGVhZiA9ICh1MzIpa3ZtX3JheF9yZWFkKHZjcHUpOw0KPiAgDQo+IC0JaWYg
KCFlbmNsc19sZWFmX2VuYWJsZWRfaW5fZ3Vlc3QodmNwdSwgbGVhZikpIHsNCj4gKwlpZiAoIWVu
YWJsZV9zZ3ggfHwgIWd1ZXN0X2NwdWlkX2hhcyh2Y3B1LCBYODZfRkVBVFVSRV9TR1gpIHx8DQo+
ICsJICAgICFndWVzdF9jcHVpZF9oYXModmNwdSwgWDg2X0ZFQVRVUkVfU0dYMSkpIHsNCj4gIAkJ
a3ZtX3F1ZXVlX2V4Y2VwdGlvbih2Y3B1LCBVRF9WRUNUT1IpOw0KDQouLi4gYWJvdmUgaGVyZSwg
d2hlcmUgdGhlIGFjdHVhbCBjb2RlIHJlc2lkZT8NCg0KPiAtCX0gZWxzZSBpZiAoIXNneF9lbmFi
bGVkX2luX2d1ZXN0X2Jpb3ModmNwdSkgfHwgIWlzX3BhZ2luZyh2Y3B1KSkgew0KPiArCX0gZWxz
ZSBpZiAoIWVuY2xzX2xlYWZfZW5hYmxlZF9pbl9ndWVzdCh2Y3B1LCBsZWFmKSB8fA0KPiArCQkg
ICAhc2d4X2VuYWJsZWRfaW5fZ3Vlc3RfYmlvcyh2Y3B1KSB8fCAhaXNfcGFnaW5nKHZjcHUpKSB7
DQo+ICAJCWt2bV9pbmplY3RfZ3AodmNwdSwgMCk7DQo+ICAJfSBlbHNlIHsNCj4gIAkJaWYgKGxl
YWYgPT0gRUNSRUFURSkNCj4gLS0gDQo+IDIuNDAuMC4zNDguZ2Y5MzhiMDkzNjYtZ29vZw0KPiAN
Cg0K
