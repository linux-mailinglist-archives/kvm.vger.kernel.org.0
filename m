Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 756F56BC3FE
	for <lists+kvm@lfdr.de>; Thu, 16 Mar 2023 03:52:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229751AbjCPCwb (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 15 Mar 2023 22:52:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49802 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229482AbjCPCw3 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 15 Mar 2023 22:52:29 -0400
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 05593CC312;
        Wed, 15 Mar 2023 19:52:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1678935147; x=1710471147;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=zJ/gNJYVAtt6P+L++s93h3igd3jARFiF/uA7kXShLxE=;
  b=epSSdTmhLNWnsWklHozrLiXzK5GCCkpdqXDbIEEp4SORHBz0oGbao9yz
   THDA6WhLz4QbwrZCIUayLd0c9U+GchE9HByTns6QCYZ2d8RBKxs1f9XMg
   peOBrrBsx+ne5ba3SiM6Ee5pS32XMC3fjrnJsdmBTLy2HlqNQhVq/gzgA
   lm9OtyDICQGMfUVH6cE3mfvJrF1KC9G1pQ7khMmWF+19TagxgQnGoHbaf
   a6k1YrUUc3esLmq3IXm+RHtF9MO6HOIMqk5clJ7BQiXfp5OSxu8lNxY2u
   vLTzDiwPSk2980Z84tyrwz+6O29I+dqHPoZDBZTQ5CxQitwA2XlYlBgUV
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10650"; a="317524440"
X-IronPort-AV: E=Sophos;i="5.98,264,1673942400"; 
   d="scan'208";a="317524440"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Mar 2023 19:52:27 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10650"; a="748684434"
X-IronPort-AV: E=Sophos;i="5.98,264,1673942400"; 
   d="scan'208";a="748684434"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by fmsmga004.fm.intel.com with ESMTP; 15 Mar 2023 19:52:27 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Wed, 15 Mar 2023 19:52:26 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Wed, 15 Mar 2023 19:52:26 -0700
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21 via Frontend Transport; Wed, 15 Mar 2023 19:52:26 -0700
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (104.47.66.41) by
 edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.21; Wed, 15 Mar 2023 19:52:26 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=MrVWXQvLPtSuMleQh4iiIMR6BlCnzIWB0Xc3xq8tx1PMNuPhfBHHPu65H0Es3fEfadLVB14CV9XdUYacuKxYuVLDSE5UikDV8lo5EwcZilZJASYIjUU16IHxRae1ki65q3DM7J0gNySSjDrxD9rP0P/V1Y5B0XSRWB167bwV2rhIF7LGNdmfrDRW6UCo3SWQB3aohs2ehMFdKsf7t2YR+jKuLfk4Wj+6ExhfokPDTZZlPrBZkDgEyUySKr+e/hoQ9AXxlpLVLL2bmFcqWkXqDeCwn/VUgEZ1NAjy5A3C3df55qJI2jrDpMvC7Vn7+wo1QtS2PU90iVHZcti28mniHQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=zJ/gNJYVAtt6P+L++s93h3igd3jARFiF/uA7kXShLxE=;
 b=HPotj8rGHp4mX5Amoz1pGIQygnygnw51qtnaYys84M6PHeLTOTovbqFQg8WRFQZWmZg2ffKSE+ABd1+TEjiAr8+nHMcbXSlzfiXciSd1u9NzTD2sKysUmuNsG/lpR3iLvpzR9JgDS5r9njWINdNLi0HrM0PGXx7w8x03gyb9ebUmJBBobkPd2EsqDDalUrSou9wgU0kKKf5hQxlZP5JvZMaHKa1036Y60UE6153DDkOiyj414UiQPxeRCJ4ASwJH+f1XjlXqMJunBw+v32ldGgpn6RjYqDeUzr0ZFnznGd3P6eLjCaXPtjMX2faGbJZz83ZWFZ8Cb0Ep3lJde87aTg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5978.namprd11.prod.outlook.com (2603:10b6:208:385::18)
 by PH8PR11MB6832.namprd11.prod.outlook.com (2603:10b6:510:22c::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.24; Thu, 16 Mar
 2023 02:52:24 +0000
Received: from BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::f403:a0a2:e468:c1e9]) by BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::f403:a0a2:e468:c1e9%5]) with mapi id 15.20.6178.024; Thu, 16 Mar 2023
 02:52:24 +0000
From:   "Huang, Kai" <kai.huang@intel.com>
To:     "isaku.yamahata@gmail.com" <isaku.yamahata@gmail.com>
CC:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "bagasdotme@gmail.com" <bagasdotme@gmail.com>,
        "Hansen, Dave" <dave.hansen@intel.com>,
        "Luck, Tony" <tony.luck@intel.com>,
        "david@redhat.com" <david@redhat.com>,
        "ak@linux.intel.com" <ak@linux.intel.com>,
        "Wysocki, Rafael J" <rafael.j.wysocki@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Christopherson,, Sean" <seanjc@google.com>,
        "Chatre, Reinette" <reinette.chatre@intel.com>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "kirill.shutemov@linux.intel.com" <kirill.shutemov@linux.intel.com>,
        "Yamahata, Isaku" <isaku.yamahata@intel.com>,
        "peterz@infradead.org" <peterz@infradead.org>,
        "Shahar, Sagi" <sagis@google.com>,
        "imammedo@redhat.com" <imammedo@redhat.com>,
        "Gao, Chao" <chao.gao@intel.com>,
        "Brown, Len" <len.brown@intel.com>,
        "sathyanarayanan.kuppuswamy@linux.intel.com" 
        <sathyanarayanan.kuppuswamy@linux.intel.com>,
        "Huang, Ying" <ying.huang@intel.com>,
        "Williams, Dan J" <dan.j.williams@intel.com>
Subject: Re: [PATCH v10 05/16] x86/virt/tdx: Add skeleton to enable TDX on
 demand
Thread-Topic: [PATCH v10 05/16] x86/virt/tdx: Add skeleton to enable TDX on
 demand
Thread-Index: AQHZUDU50M/RwoyayES+lzw7MeI2g678nMEAgAAlggCAAAH6gA==
Date:   Thu, 16 Mar 2023 02:52:23 +0000
Message-ID: <dfc6dd51ee07f75fedb5d0ee99402a33168954ae.camel@intel.com>
References: <cover.1678111292.git.kai.huang@intel.com>
         <f150316b975b5ca22c6c4016ffd90db79d657bbf.1678111292.git.kai.huang@intel.com>
         <20230316003102.GB197448@ls.amr.corp.intel.com>
         <20230316024516.GA259042@ls.amr.corp.intel.com>
In-Reply-To: <20230316024516.GA259042@ls.amr.corp.intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.46.4 (3.46.4-1.fc37) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR11MB5978:EE_|PH8PR11MB6832:EE_
x-ms-office365-filtering-correlation-id: 40ae4275-18f3-43ba-039d-08db25c9782c
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: HxikGBBE2RgDup01os4nMTWO+yU2/GbSIQ/gjCAtgpvNINk6TPX2eb+Ilx/K0caNM2Z/Dhh4GNGW4pxvtpno4ctfgevzqeePNnKcp3KnoFWTICyw07UVBl2wEkIihBMbNEVNeNcMUGsWmTXMAusHEIC0XG9U48uaF7NLCbWtkzc4YsTsgt2yxn7g+R2WXjKkiEteAuLLQ7mdNK/T1tD6SiYgMWGodxsfb4UcZFffzuiG3Lz/3XLVv9fcd4YvlHEAfCIJLKfhj3NDtRXch2espM4RxFuy1cGvvFXO6Ldsz8DZxpkhAJstLMvHNZJTaN7lMDVi/RwgokiuLhpv88E8mub0ulmpWtRWBrlGU8CGHqRJajq6SagIFZ0f8dYCqSkaQrXAMCxPwN91AODsS3miafjk6AQdSIZ31VLqH3khAIl1Pk390fSkt3Ldi98fPk0XVoxHmdjifpA9M6Zgkgf6EtTa5bCS0XD50BETdiXrmoXhyVLH6KjLcTPjSd7uJ8voV9zjiDHoig7tesui93sU9dbRlzd0dX4HOnyOd7ejGxTTiCakS2AuDpuZ6wgmztSBGbBTY6AAH4US8v144uD3zEaad8c4D1+VoWh3psEkemxyC9bQyiM9ITswhf+aBZbYIj9u+B+M+clpiZ9ynaIKr5CWfFmzYLjI5tAzp1OqwX6JpQ7UJMqDnCbg97HftVd11Ph4CDTwjYrBNbjT21WfKQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5978.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(396003)(346002)(376002)(39860400002)(136003)(366004)(451199018)(186003)(2616005)(7416002)(6512007)(26005)(6506007)(83380400001)(8936002)(8676002)(82960400001)(38100700002)(5660300002)(6486002)(38070700005)(4744005)(4326008)(64756008)(66556008)(66476007)(66446008)(76116006)(2906002)(71200400001)(41300700001)(91956017)(122000001)(54906003)(6916009)(36756003)(478600001)(86362001)(66946007)(316002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?VlVIdzJOQ2NmdEFWR015YUt1TmNmOHVLOFZ3ZmtSeXdiT2NWdkd3STY3MXlM?=
 =?utf-8?B?V25TdzNYMlVJblFLajNSRTRqcUk5cWg3UzBFVjhMY2YxV0diZHBaZUZSYUhu?=
 =?utf-8?B?QjJndStkWFJPb1Excm5BZEVTU1hGbW1TK2hzUHpKUy9zbWE5NUhXZktQdGVT?=
 =?utf-8?B?bzdxckNCSnRRNVp1d2dSU29yc1d1WjVqSlMyczFndm1JS1FESDJDQi8rUmZJ?=
 =?utf-8?B?blF5V0tsRWIzdFBKQTduOExTUnZKdjAvNnBleXUwR1lXYWVQRlE2QVVDK1VK?=
 =?utf-8?B?OElPWm9LODdjNmY5MDkzcjhYRTl5ZVRJRFlZZ0lESnZmVkVnN2JKTDZ5ejli?=
 =?utf-8?B?aE1LNlVHc3ozZUN1VzBoWkNFUVlWcUNrZkExMENRa2xDNmFmRWRxU1B3VGNs?=
 =?utf-8?B?cXBDL0dVbG82N1N1WXZwTGFUUEJ4ZVpvRWhSSERYVjI4cXRaYmhuQlFhT1RJ?=
 =?utf-8?B?UUVGdnMvOC8ySnNPY2J5bHZuYjVIYUFYQmttZ2JMR1NYb2xzVCticEJ4T3JI?=
 =?utf-8?B?YmdPL21PSmgzUTQ3T2MxalBJOXlCTUsvYS9zUnBJRTZnOXZySkQxb1NWM1dT?=
 =?utf-8?B?RHVzTFpWSEVOdVdRUWEwbmlUMXZlN1dZblNvSWhFMXhlZm43Z1VySVgrblA3?=
 =?utf-8?B?Z3IvS01QRGFUZUk4UHNIcHJvZ2hvdExTQmxQY21IOTFtTzF3MXBqOElKbmlD?=
 =?utf-8?B?SkQ2RUptZ28zTXE1R1JVdHFURDBkZ3V3YUFQajRqWm9JckxHcHlRN2FmWU5n?=
 =?utf-8?B?MGZHSm9JcW0yM0lUN2w5NDFyUGhmRDVQeVorV1V6SmRMMXFYblFpSzNUaXdi?=
 =?utf-8?B?T01xbWVUVXpmZlJOQkVHdktJd0FEVktVS2c0NTRUSDlSVFhDYmw5NFZCOW9D?=
 =?utf-8?B?MjBzaEZBSkVKK1RDRmF5aGRsdjR2TXZodlQvK3NXWVNuS2F4YzdHZTNqNTBT?=
 =?utf-8?B?Z25TdFNzQUtYbDNOaWFzbHNJSU5NSjJIdXVsd2dyTDhQY29lWEF2bGNkZThC?=
 =?utf-8?B?RlJSV01oRHoydzFpQzE5dzhPbWg5d2k2cnpURHhGZG1tM2w3UUpFM0d0cmVF?=
 =?utf-8?B?RktsUGpOKyt2S3FaWlhFQlFUSmZkeU56QlZuOUt5UnRsSXJUeXgxTFRRZis0?=
 =?utf-8?B?U2hra2pEMjVlUE9Ld0NPYXVNZFYrSVd0OGRYaXVqclZPZU5oNzBDVzlnZGlz?=
 =?utf-8?B?Z0poNldEWGJKQ0x6VzV3eTF3aWs4dFNXQmNpbTRhSUdTNDllQUtZaTBWWUJu?=
 =?utf-8?B?eE9UMVZhbHdDMEtMblk0NFlyTXF6aWRaQXRwQjZhVHlFQmlXMkdrcVBlWUlL?=
 =?utf-8?B?bGJ3ZzFjRjZWaGVPOXpKRDRwRjJEeEFyNVZBNDFQZWlJQ0RZWHpqelZXcnVX?=
 =?utf-8?B?bUhVMzE3YzFEdm5tTlhIbkpCQTVZRnZ1YnB5WlliRDhvYnRldGVXNDBISEc1?=
 =?utf-8?B?b0RlZDhPd1JHa3EzUGdmUTBocXhHTXh1ZEpRVFpqdUlJNUZ4UVA1NmRsNDAr?=
 =?utf-8?B?WXhLd3g4VzZQU3hIWTdhcVpBbUNzQmRla3BRQWdUUTJoaUg5eGJpZXE1Y2tI?=
 =?utf-8?B?cFd0bXBHbmdETW94b1QzcVBkM2MzOHRaQy9mejl1bGV5SmFYQWtPVmFZaU12?=
 =?utf-8?B?eTRpbzcyaXRJOFJ1MzM3ZC9RcE1PVDE2VUhQZ0ZEZEdaTU9XZmhjR1l2eTBN?=
 =?utf-8?B?VXQ0c01NOENaVG9hZ0VWRHY2TmxCQzdrcGFNMWJkVjdRbWZHQmdPK0ZxMkQz?=
 =?utf-8?B?ZGVrT3lwd2dyc1FTaU5qSmFKMXgreGttcG9ya1pRV1hsRlNvdnVXL2ozOXdy?=
 =?utf-8?B?Njh0Rjc0bXNPUzBvSXRpQ2J1bFJzK2hXS3FYVzdjVWI4RG9wa05rQ09ZV2xp?=
 =?utf-8?B?Ti8vc284S2JsVlpTWVQ5TTRnV2tnN2QzMVdBTU4xbkd5V0M1TkFXTHRTcXFJ?=
 =?utf-8?B?VGlaZUdCZUwveU1HNnRpZk9Rd09EMXlrYWdFVEdXenhmMTZBemgveEF1ZnJj?=
 =?utf-8?B?UDExNFNjSVhlVEZGUnlOcHB0ZStqS3lGZjduYmttWkdKTWpuNWxGeTQwZGQr?=
 =?utf-8?B?MnNjOGtoK04rNkFrU2g5YVJtQ3F4U2dvZlcxZFVSVk9ER2Z4UVNaZ2l5UDNG?=
 =?utf-8?B?d2FUL2RjRzVCWlpXNTF0VENmNkxrcE1OUVdIaGN0MWYybGRBbVF1NVNRVm9J?=
 =?utf-8?B?Qnc9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <8F913A0B5E7F1941BA07BD151DCC10B7@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5978.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 40ae4275-18f3-43ba-039d-08db25c9782c
X-MS-Exchange-CrossTenant-originalarrivaltime: 16 Mar 2023 02:52:23.7705
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 1KEWAc+7SXOSvmxtxFtjceF5hoKqj9OHC6gdbcBComYT20If+gyMlK3Qu8S2cIIbjtLjs4LbhtVPdCeWM/KxVA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH8PR11MB6832
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

DQo+ID4gIA0KPiA+IEBAIC0zNTYsNyArMzU3LDcgQEAgc3RhdGljIGludCB0cnlfaW5pdF9tb2R1
bGVfZ2xvYmFsKHZvaWQpDQo+ID4gIAkgKiBUaGUgVERYIG1vZHVsZSBnbG9iYWwgaW5pdGlhbGl6
YXRpb24gb25seSBuZWVkcyB0byBiZSBkb25lDQo+ID4gIAkgKiBvbmNlIG9uIGFueSBjcHUuDQo+
ID4gIAkgKi8NCj4gPiAtCXNwaW5fbG9jaygmdGR4X2dsb2JhbF9pbml0X2xvY2spOw0KPiA+ICsJ
cmF3X3NwaW5fbG9ja19pcnFzYXZlKCZ0ZHhfZ2xvYmFsX2luaXRfbG9jaywgZmxhZ3MpOw0KPiAN
Cj4gQXMgaGFyZHdhcmVfZW5hYmxlX2FsbCgpIHVzZXMgY3B1c19yZWFkX2xvY2soKSwgaXJxc2F2
ZSBpc24ndCBuZWVkZWQuDQo+IHRoaXMgbGluZSBzaG91bGQgYmUgcmF3X3NwaW5fbG9jaygpLg0K
PiANCg0KT0suICBJIG1pc3NlZCB0aGF0IGluIFBSRUVNUFRfUlQga2VybmVsIHRoZSBzcGlubG9j
ayBpcyBjb252ZXJ0ZWQgdG8gc2xlZXBpbmcNCmxvY2suICBTbyBJJ2xsIGNoYW5nZSB0byB1c2Ug
cmF3X3NwaW5fbG9jaygpIGFzIHdlIHRhbGtlZC4gIFRoYW5rcy4NCg0K
