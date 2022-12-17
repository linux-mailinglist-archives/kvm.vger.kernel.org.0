Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 972EE64F7FC
	for <lists+kvm@lfdr.de>; Sat, 17 Dec 2022 07:42:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230040AbiLQGmJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 17 Dec 2022 01:42:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51222 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230280AbiLQGlc (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 17 Dec 2022 01:41:32 -0500
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0B35EF5B
        for <kvm@vger.kernel.org>; Fri, 16 Dec 2022 22:41:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1671259289; x=1702795289;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=cVlSKuhy2c+QRrdGOzpp3jta+VBcPkyd0skkuyayFA0=;
  b=ghLEkxHBdq2qmU69Uor/h2iXMUNlw+sF0dsWuw1LCzLX4ftR0DVU7Eqk
   126xRJmzC76N1zfNRsUHdHWyh7umhjdn80P2ooi2OksnrIBskmFwJtTbu
   EaEvKLlsDWkdncgE8TUru2ZfwtSBh4/dO9QOduhZbT8wml0R5qDwlyE+i
   arU5mTZruAY7U8BdoNMxqF/RQ6iIWFeHJzwgOi3Noh4ZRy7avRWNtKaax
   5DTwGB0Ao/p6KGMzbuCf/yHPLcEO9VcDNlERi3V0YqUPB70ydMZcSwRfP
   FqWK4CP2a6LyUX5wg/GTKR+t8Ii/Ep+zL8rwwhvybNWK8y/PBbiT6cADQ
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10563"; a="302532418"
X-IronPort-AV: E=Sophos;i="5.96,252,1665471600"; 
   d="scan'208";a="302532418"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Dec 2022 22:41:28 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10563"; a="824343965"
X-IronPort-AV: E=Sophos;i="5.96,252,1665471600"; 
   d="scan'208";a="824343965"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by orsmga005.jf.intel.com with ESMTP; 16 Dec 2022 22:41:28 -0800
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Fri, 16 Dec 2022 22:41:27 -0800
Received: from orsmsx602.amr.corp.intel.com (10.22.229.15) by
 ORSMSX610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Fri, 16 Dec 2022 22:41:27 -0800
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Fri, 16 Dec 2022 22:41:27 -0800
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (104.47.55.174)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Fri, 16 Dec 2022 22:41:27 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=PLMhz3YMT7/OwgsOok1jX5V0O0zeozL2z1ApQ9AQQhtwH6dvDm51lpDvzgYht6DO+OTZ/05fdQF0QLTjI8JKzpznihcJZz0paEX9t/wG15S3KGrRhTVFQfc+OMHVYJMaMbaSyTg+oWA3y9FCwRT5nhnHzntaVeb4vFDYqj3XlsXIkKb+5ZbH738zKhsw7+llEFXOTMgpPLNLB0JHuofAihZ3XJW7bygqU+NrN1dvRHlLvyX6eHNrAc2aboa46ptmq5CcmdxtHnF5yggJxC6uTtXsEosSDyLasrCroRxgaPTYnbV1NX+3z4UzoQURk0B6YFtHldPdATvr47zuF6UifQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=cVlSKuhy2c+QRrdGOzpp3jta+VBcPkyd0skkuyayFA0=;
 b=fSl0M8WppfcSXktohRNdCSl1EBW5WT9w7hO2SRVWR7a8bD/5kSyhdJvZeEYPpg1m3SmGSPlwX+ZQ7ZAJjeQP3ogk2ZmkTa7lyPpfIvL5xJ1qY2ikFvynunbXwvZMB0A99d3wMGaUS4MYdf7kax51Oo0HLN8LsGx9NsB0mQwKNj705T+tDvJL+DaTuEeKO59fn4CpN9xr6R1X8utggu99wdFk99BEZ2NHcClDT3PpfgAfKO1A9E1bngXXVL3Bo7C5KmA+QLaYnCZPM3bGl01ewgM0wiRaDIsOQ1Me/iNgwRdzm7usOVtLlH3EpcyzoXSf9a8qGNQ9p79aMnkIz7hDIA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5978.namprd11.prod.outlook.com (2603:10b6:208:385::18)
 by CH3PR11MB7914.namprd11.prod.outlook.com (2603:10b6:610:12c::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5924.11; Sat, 17 Dec
 2022 06:41:23 +0000
Received: from BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::2fb7:be18:a20d:9b6e]) by BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::2fb7:be18:a20d:9b6e%8]) with mapi id 15.20.5880.019; Sat, 17 Dec 2022
 06:41:22 +0000
From:   "Huang, Kai" <kai.huang@intel.com>
To:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "yu.c.zhang@linux.intel.com" <yu.c.zhang@linux.intel.com>
CC:     "dwmw2@infradead.org" <dwmw2@infradead.org>,
        "Christopherson,, Sean" <seanjc@google.com>,
        "james.morse@arm.com" <james.morse@arm.com>,
        "suzuki.poulose@arm.com" <suzuki.poulose@arm.com>,
        "oliver.upton@linux.dev" <oliver.upton@linux.dev>,
        "catalin.marinas@arm.com" <catalin.marinas@arm.com>,
        "maz@kernel.org" <maz@kernel.org>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "alexandru.elisei@arm.com" <alexandru.elisei@arm.com>,
        "will@kernel.org" <will@kernel.org>, "paul@xen.org" <paul@xen.org>
Subject: Re: [PATCH v4 2/2] KVM: MMU: Make the definition of 'INVALID_GPA'
 common
Thread-Topic: [PATCH v4 2/2] KVM: MMU: Make the definition of 'INVALID_GPA'
 common
Thread-Index: AQHZETPHiVzCWGjYEUKk3ONlvBkZ+q5xor0A
Date:   Sat, 17 Dec 2022 06:41:22 +0000
Message-ID: <e30a3ff562ac7575fe8c197b9ca606aec7586021.camel@intel.com>
References: <20221216085928.1671901-1-yu.c.zhang@linux.intel.com>
         <20221216085928.1671901-3-yu.c.zhang@linux.intel.com>
In-Reply-To: <20221216085928.1671901-3-yu.c.zhang@linux.intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.44.4 (3.44.4-2.fc36) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR11MB5978:EE_|CH3PR11MB7914:EE_
x-ms-office365-filtering-correlation-id: f59d69c1-5900-438c-33b0-08dadff9b64b
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: QQ5Kna0bwCMOHDUCdNjLWEVeT4RG2lgD75GDGJ11utx9ZaA6mtkTb6PQS6SvdP+HEHAcHD1XrzNZb5SO3jndf9uxYsnLI5jXmHSMtVBXGCiCS0rcGgFtIVc45pOSkwvEFkaDDRmQf8CKsmJSpYcZcX9Fa9S0rL4IehhpmaieyjLO2LzDI+kSQlfcab1jq5wPMfUI8s9XKROKp5zerJxYaTGJVPZelYJjkfVznYu4X7ZkshGZABxuTOC4CUAH45TWFXNblh1gRBcn8tWKs0rHQQEVdSa5nKbf8h3Y1uSu0CuUqJgAkv90LaNMh+60IrZME/RP6HurM2LDFDVqfxia6E50tWAxuGQbX6NiSTeeJldw5tIb9PrsgaU/N8fzM5gJpgILnQ0gduCuqdUJ1pcpLHKvItgeRouWw6umc4oVu8bMLoyR80CWqowv1506+XtAKV4tsGfnjhjmVx+GeGKqHaKQoJfU9/wLODAft9ypDy+HM5uUSR7x/x6+WR77p4LB49dupDOZC0NtQmZ0sw37FQiS6nwescvZWGhd9mX0CZsqx+ECB2rnp+l60gvEx3gl+Wly7ufZQMPK1U16TorXUspUtmFZS7be1/u35b50rhtaTWeu6sstosr57AJoAJinVCV0w4pyaZ4v3qZfNYcYf+TsXvLvJJokCi3UGocTnNtFXzDIOd9Zq8DewSabS2GAJqYfBcnw0Q6XEfupOA3XrA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5978.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(366004)(396003)(376002)(346002)(39860400002)(136003)(451199015)(558084003)(91956017)(76116006)(66476007)(66556008)(82960400001)(2616005)(66446008)(122000001)(66946007)(8676002)(64756008)(38100700002)(4326008)(41300700001)(478600001)(26005)(2906002)(5660300002)(186003)(36756003)(6512007)(86362001)(6506007)(6486002)(4001150100001)(38070700005)(110136005)(54906003)(7416002)(8936002)(71200400001)(316002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?ZGVFWi9XSldPT3ljN2R3YkFsdGZYa2hibGV5ei9zY216T20zc0lzbDkySVZv?=
 =?utf-8?B?endGK3A4ek5mbndKL1BZNDR1d0dHQXNvUG5pd1NFNVNCdkp0cVB2eEd2WUYz?=
 =?utf-8?B?Z3pnMnFickV2OXo3UlZvdWJpeUxwamFPVnhFbnVSTENlOWpISHcyN0JxWUNz?=
 =?utf-8?B?MkpwczAzY1F3OUNPeGJwQm45RDQzQ3ZTWGE0Nm0yb3ZDS3JEWEZyaGUxc2dG?=
 =?utf-8?B?bExsVXd6dnNMazY1OVZEeFVpQkFiUE1iVEI1MTdPMzZIOWVHRFRWNU5vVHJ3?=
 =?utf-8?B?SkMxMjdHRzlCOHNNZnh0Y2UvUWcxLzgzWXRocytVU1AvRWtrSHZaelZvMDFU?=
 =?utf-8?B?VS9kRnJteXhSOVNJRU1pYWJ2VFY1ZGZxL3QvMkhCQTF2RHliOWEzOHZJdTVk?=
 =?utf-8?B?cmNzbVVXUEZvRlBnRGdiTnAzVHk3ajlYeDJpTkpqNkJXOTJzK2J0RVRvdDlC?=
 =?utf-8?B?TWpKejlFckIwbUc4Q2lrK1RZWTZyMExwQTIxOEI1cXhPK0Ira3E1VDhjZE9S?=
 =?utf-8?B?Y0d4ZW9iSG5WM0NkUTZCRGNQLzdQZEJTME9keTV2cmRlbU1qbDZITE5FWnlR?=
 =?utf-8?B?SXhMYlJQUUVqSGtOWU1qTDVaVmZhNW9ReTBmOU5NT2kyMjJKM1VsSnRrQnBx?=
 =?utf-8?B?andRVVlKOHdGS1NVRlJxS21VSzRpejdCK0FYQk5rbWlqNU9KSGFZeUNhOURC?=
 =?utf-8?B?R3dOTzNMVjNoN1ptU3dFNklma3kxSUZ2dHJGQ3ZUODlHTnBsQXllRDk1T2dL?=
 =?utf-8?B?MTV4dDdHZWFSdWUyclFOd2JadTNwalZUYnVmVHh5Qkp5QmtBUGdreStJcVpZ?=
 =?utf-8?B?elM3UUZ1WE5zOXF5YzJBcFhxWjhJWUpGRmVTMmsrckRjOWJydUxUaFBiVi9C?=
 =?utf-8?B?YmN0bHVLTlh2aXNqL0N0RzExTlZ2UnV1RTYwMFoyZm9rTk5yWXlUem1nWVMr?=
 =?utf-8?B?dEdlNysrdDJkeVlIU0FTS054Mm1HYW5RTFBjaGlLNmlJdUpvckZXWWpqdDBy?=
 =?utf-8?B?VHcvMWtoYVlzclp2amxDZmV4TzRqRjB5M3FMWEp5TFErYnRzRE9mSUR2ZXY2?=
 =?utf-8?B?Z3VqVmFjZnJ0SVpkRDFTdkkvVytyakZmbDBMN3UyZXFXSFNGeDRVbWV4UkZ5?=
 =?utf-8?B?MDEvdi9mVWF3MVAzRnZ4a2VqUnY2NTdBaVpKdTZsYXJlM1QvbEVqd3BpQUM2?=
 =?utf-8?B?ZDVFbFFrNzFtVEJuWGlyNWFVamZrbldaOXRyV3RGYVF6dWtXakx4VXhxNS91?=
 =?utf-8?B?L1VScjliMGVPb21SVnlYMkFXY3c1RHpsY1g5TzQ1MTQxY29UZkV5M3RlK3Nw?=
 =?utf-8?B?QXgrNVdBZ2VJS2d6aEpUVisyLzIxeExaWXo5UkpncHo4eU5lcy9tQkpNZEIx?=
 =?utf-8?B?L1pnQXYzQzJxbmV2MCsyNlQwdEZFNVF6djFTcVpXcWlCY0gxcStnZFhPT2JO?=
 =?utf-8?B?NFhBNUU1MTVkT2QzZ0hQSk96RzcyWU5kYkRDQXdLUGlkQXhsQjdwV0szZEtD?=
 =?utf-8?B?WVhETVFNOVZWemtveHAxR3hIajBQN3RVUFh5L2hsTlNRVDRYN2k5ZmE5RDl2?=
 =?utf-8?B?bUhaQ0p4dTNuZUNPeHRjWTBQQ2xjNnNVbW9UUkRqa0g4SU5TOVUrdEthZFBx?=
 =?utf-8?B?U01Id2IxV3FHSWVaUitzYWJ1S0VUSVc0OFI4ZkRkSWZxTkR3Rk9jUkFtbUlq?=
 =?utf-8?B?VjNpVTZNT3E3V201NFNvTnpQMkRxZlVJOFVYSHRWNzc5bFlVS3hrZy9YM0R1?=
 =?utf-8?B?ME5zV3dSTWZHZFc1WGZRdVd0RlBKcmdzRDRVRlcvZjFCN0FTTDEvc0Y0Rngw?=
 =?utf-8?B?cDcxQTg3TUh4cWVBTlpSb2Fwa3F6b2dXSXVCVCs0NytVcUJsL1pSYnUzUWEy?=
 =?utf-8?B?Yk4zdWw0VlNwL2ZxWkJUekZmZG5XazNzdHJQMXhEYlRsZ1k1ZFc2bllYcDJO?=
 =?utf-8?B?cTJNbzVMYXhmZityeGc3SW5FKzkrc0VoZTl1UTl6bEsxeWhERlNYSlg4aDBx?=
 =?utf-8?B?YUFtRkd1ZE5YWGU4UjUrelpySlRXWEpXdlJZeGY1bmp6eVM4Z2xYbnhmZFZ2?=
 =?utf-8?B?VXFrOUwxZlFWazlheFZGZGhTNmZLNnR3OEJYTENWY0pjRy85Z050Ny90UFlU?=
 =?utf-8?B?TkZXUkJLNWd1Z0xtRHA2ZnBFTjJWRzAyQzBJaTlaUWJDOEgzeWdRVHlDYnoy?=
 =?utf-8?B?OGc9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <1CB7E9EEAE70BD4C93931DB3010BAB09@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5978.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f59d69c1-5900-438c-33b0-08dadff9b64b
X-MS-Exchange-CrossTenant-originalarrivaltime: 17 Dec 2022 06:41:22.4110
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 0Ncefoz/QdwOGUw1L+VaRf/+ksvdgEpR9j7LwqWhqYmx6LspvRqOAJdZ6Q6jeHXzFpalo7H0gc8IvS5Ebtv/hw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR11MB7914
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

T24gRnJpLCAyMDIyLTEyLTE2IGF0IDE2OjU5ICswODAwLCBZdSBaaGFuZyB3cm90ZToNCj4gQWxz
bywgYWRkIGRlZmluaXRpb24gb2YgJ0lOVkFMSURfR0ZOJyBiZWNhdXNlIGl0IGlzIG1vcmUNCj4g
cHJvcGVyIHRoYW4gJ0lOVkFMSURfR1BBJyBmb3IgR0ZOIHZhcmlhYmxlcy4NCg0KVGhpcyBwZXJo
YXBzIGlzIGEgbGVmdG92ZXIsIHNpbmNlIGl0IGJlbG9uZ3MgdG8gcGF0Y2ggMSA6KQ0K
