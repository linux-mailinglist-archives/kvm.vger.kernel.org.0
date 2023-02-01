Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4E611686628
	for <lists+kvm@lfdr.de>; Wed,  1 Feb 2023 13:44:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231656AbjBAMoS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 1 Feb 2023 07:44:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54966 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229654AbjBAMoQ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 1 Feb 2023 07:44:16 -0500
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D6A79AD17;
        Wed,  1 Feb 2023 04:44:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1675255440; x=1706791440;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=xxzJEMNs0/ec1UlrWo1MI8dKgd7r48mW9S3mtn4wlTY=;
  b=DluNdO3rrOSaaY1IbMRwG/NCA6fBbZ3/eRGGHnK3KC6GWQqdorn3JE5A
   Wbu6p1/bNZNQ9yrPEFiaEhX9wVlvbKosY1VtqJhHvg5KZO63vS0AXE9TD
   DY3V8Yz3E560JRHJSfB6wKOSGvXH+ziuHkTgUldCt/t0vf4V1d84K+Z3S
   mperERj8bxWiBP5GheAJMPyFTRw1zDLf11AJFkSZghu1hLS/rCahpZ4ZV
   AyN/5Nf1WTkVdKCDMesr2QlokDqOosWBW0D9eCz1LRrrHZLvMHZFqCvy1
   AwxVJeby3s0VHp3/nE9vKIsUHiDhJ5/A2svpJh+knZ0yOsbD2VumNOGsh
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10607"; a="355463302"
X-IronPort-AV: E=Sophos;i="5.97,263,1669104000"; 
   d="scan'208";a="355463302"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Feb 2023 04:43:42 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10607"; a="993678687"
X-IronPort-AV: E=Sophos;i="5.97,263,1669104000"; 
   d="scan'208";a="993678687"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by fmsmga005.fm.intel.com with ESMTP; 01 Feb 2023 04:43:42 -0800
Received: from fmsmsx611.amr.corp.intel.com (10.18.126.91) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Wed, 1 Feb 2023 04:43:42 -0800
Received: from fmsmsx602.amr.corp.intel.com (10.18.126.82) by
 fmsmsx611.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Wed, 1 Feb 2023 04:43:42 -0800
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Wed, 1 Feb 2023 04:43:42 -0800
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (104.47.55.103)
 by edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Wed, 1 Feb 2023 04:43:41 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=IpKVEWj8RLaC9CEWxxrMItTlwkcgUFSXmfyx9CYoRCFF75dt6HxjAXcpLpaoScLsehdLpCgnZRyTJjGGtIfn3S2ABdiuXSNgZmQwLtQcsdeTjLFNqCoy7wi3fqSNpVStwVtN5hc7W7qqYynvKmwAVqW+y89ZzsEC6wOBV359vhm+n24GvCdiNHw7EPo+mOMrGGfB/6Bq+fq+/qaWDIPViGTq6pGm1BY9qvYSXbblcaxQGjvNddwju7eL1tEhcjV63uO+rNbyG6QrjBPMyr07fRaeBXzgfNN4aLI4jO21gO6M/V3vACE/gDzRKxvr47nTmmtvS9Vgv6H7+G/NZ4K1Yw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=xxzJEMNs0/ec1UlrWo1MI8dKgd7r48mW9S3mtn4wlTY=;
 b=ctntcO22mqcS3XG3McoSwMj8NWIdrBnWYiud3MDcWdevBAqnlTxAsA8gyGoGBxgTIOXwxVFw8qbf3DmGvNA4JvX2iv+um8eqWG/NHb8IXQE6AI+DTAgKeFzMpS8VgLsjwjI7h9fMOl2nMtfMHVWxw7SYrCGOYQYREL6tpC8qJLCqEXLPO92tqckJb7em6JwI37qzcjESN4Qdlfxg5DC6NCwjXW25NRpH6HW0TYbt08W7/STKnop4QrAsjzFtKv5eMJN3yWxWo1OvwNic1kbtbYDRLHOmqVLY45B9DIhN8lBX8ttSroA1DS56VNWATK+ri1EFSEgVnbafSJF8bN06ew==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from DS0PR11MB7529.namprd11.prod.outlook.com (2603:10b6:8:141::20)
 by IA1PR11MB6467.namprd11.prod.outlook.com (2603:10b6:208:3a5::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6043.38; Wed, 1 Feb
 2023 12:43:39 +0000
Received: from DS0PR11MB7529.namprd11.prod.outlook.com
 ([fe80::e1fa:abbe:2009:b0a3]) by DS0PR11MB7529.namprd11.prod.outlook.com
 ([fe80::e1fa:abbe:2009:b0a3%4]) with mapi id 15.20.6064.024; Wed, 1 Feb 2023
 12:43:39 +0000
From:   "Liu, Yi L" <yi.l.liu@intel.com>
To:     Jason Gunthorpe <jgg@nvidia.com>,
        Matthew Rosato <mjrosato@linux.ibm.com>
CC:     "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "cohuck@redhat.com" <cohuck@redhat.com>,
        "farman@linux.ibm.com" <farman@linux.ibm.com>,
        "pmorel@linux.ibm.com" <pmorel@linux.ibm.com>,
        "borntraeger@linux.ibm.com" <borntraeger@linux.ibm.com>,
        "frankja@linux.ibm.com" <frankja@linux.ibm.com>,
        "imbrenda@linux.ibm.com" <imbrenda@linux.ibm.com>,
        "david@redhat.com" <david@redhat.com>,
        "akrowiak@linux.ibm.com" <akrowiak@linux.ibm.com>,
        "jjherne@linux.ibm.com" <jjherne@linux.ibm.com>,
        "pasic@linux.ibm.com" <pasic@linux.ibm.com>,
        "zhenyuw@linux.intel.com" <zhenyuw@linux.intel.com>,
        "Wang, Zhi A" <zhi.a.wang@intel.com>,
        "Christopherson,, Sean" <seanjc@google.com>,
        "Tian, Kevin" <kevin.tian@intel.com>,
        "linux-s390@vger.kernel.org" <linux-s390@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "intel-gvt-dev@lists.freedesktop.org" 
        <intel-gvt-dev@lists.freedesktop.org>,
        "intel-gfx@lists.freedesktop.org" <intel-gfx@lists.freedesktop.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH] vfio: fix deadlock between group lock and kvm lock
Thread-Topic: [PATCH] vfio: fix deadlock between group lock and kvm lock
Thread-Index: AQHZNa+RvE0EhcYo6EGu/ai3XoxXDK64+PMAgAERCqA=
Date:   Wed, 1 Feb 2023 12:43:38 +0000
Message-ID: <DS0PR11MB7529D62614A5DFC56920EE96C3D19@DS0PR11MB7529.namprd11.prod.outlook.com>
References: <20230131200635.44227-1-mjrosato@linux.ibm.com>
 <Y9l5OmCRGYZM2nPy@nvidia.com>
In-Reply-To: <Y9l5OmCRGYZM2nPy@nvidia.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DS0PR11MB7529:EE_|IA1PR11MB6467:EE_
x-ms-office365-filtering-correlation-id: 693ca59e-a31e-4217-8371-08db0451f13c
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: flGQnXyMIAxISBs8V+aR49bGnaj82OyntHYlg9oqDLS6Mf53SnrwObNqIUuudX+wfeWiesjWDYtVE2TDEw5LKYxuP8316i9jomw/2eLlmHh5zRC2mwvZSUtc08xW0MnF26htmjFFJu16LoCVR0t+WHgetl0Jre86qd34PyvoSyVtARjKBORkeW+7Q86j2PRZTDq2GhNEXqjKlO211wEleXRlrZR5rirImzKPwJ1p1q8F24emWYxLWNLEZq8vKhy0WNaDijw8+iZ9AdeALgMWeMssoCJ9BRBDAg25dYR4aVwXT0N+ZYgafjAopPJ43E4khH+pj+djvQivR63CbqssQVbYzYPhQ7vUhkZmhr14NdvdXRJiEmBTsSt7ToKPNjNYDvd5qNFA3iQ/UF64l6MeVsRJRhN8HyDT0YJobcUrYea+7zK7NrqXHa+kwANRx9js9nPgzp7X/ODIfWrcc5sF+nM43UhOw/oZyKONeYcAd07BMFBhtq6lHaH+vcnO8W2K4XkvH62Bs0ztPjvDvRC2LaeBanEIhfu1pURf7jtBLvy5KQPVK7myAAKIfnmzRgozeOIcM6PhzE292Q6leOMGsvmdAIMemmcvpR2p1dZ3A8rMZMgb2WgWlQLQ8W3GuhZuA3kGWmK1bWJLhqf1fypvUfycRonFlVHLcKaO9fLjwqnqutHiHaqJBYCCXmOP2xO5FOqL9nYsNUyUugNTuK5tcw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR11MB7529.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(136003)(346002)(39850400004)(366004)(396003)(376002)(451199018)(41300700001)(478600001)(186003)(9686003)(38070700005)(86362001)(26005)(6506007)(66476007)(4326008)(66946007)(66446008)(66556008)(64756008)(76116006)(8676002)(316002)(8936002)(7416002)(54906003)(5660300002)(110136005)(4744005)(71200400001)(33656002)(2906002)(52536014)(7696005)(55016003)(38100700002)(83380400001)(82960400001)(122000001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?c2JwWVFuWVVubk42bjJWYXNpcjZrWVp4OXhSSUpxell2ejR4bmdWUE5BUWg2?=
 =?utf-8?B?TmY3N0FzQjFDVGRuNjhpdkQvQTFpUEFpclJrRDJVb3Era3k2dHFSaFRoRWlE?=
 =?utf-8?B?WUVxYjFMUzNEdGpQTTl4QmZjQ2tka20rSDd3N25ueUlib1g2K1JSUUJ3L1pW?=
 =?utf-8?B?czR2aWRIdHQ5c282cFYyUnNBMkVZTzdJU1R6OFBkOXRiclhWVU9DemppdVYy?=
 =?utf-8?B?MWpEUjVDaG1ONFJkV2pyR2gwc3B5TERwb1IxSmR0REJTRXE1cGREUjFtbkZz?=
 =?utf-8?B?UVFDNEppdi9TTUZGeXAyYmRJRFFXZXlyOUxONjJpNjhmQzVHd1RqRERhNkJN?=
 =?utf-8?B?QmdFVW9SU0tnWlowVXpwekZaRUprb2F3YWRUcUc1RU1wMnQzK0k0clgzby9h?=
 =?utf-8?B?TGdlSk94WENieXlJaXZPb3hnaWNJS2pqbmZxQlFFMU9LTG0rY3gzTkZwSzM1?=
 =?utf-8?B?QWFzUXdrVldmMUVvWFFqQnRHL0gzKzF3eWJKTVJvbDVRMUd0cENDdXRoRDlR?=
 =?utf-8?B?ZXJlTUZZaXJ5dCtFdldwc2t2ejNUcWE0VlgvbjJVK1FCL2ZtWUFaUzEydXg1?=
 =?utf-8?B?NmVSWlJLSUp0WjVKRzlyWWl1dVE3RUp5UlpSV3JnMC9WZXd0VkZ0SStLL0xl?=
 =?utf-8?B?MHExa2c3alBGWkgxZE54elg2MXFMdmwvNlhvdGd3QkR5M1NocnhUMWE1ejFQ?=
 =?utf-8?B?TDcyc21IK0xkcld1eGVrcnZDMklLM3NNRGZrdkFsSEN1K2NoVWh2djRNYVpN?=
 =?utf-8?B?WHM0S0NyQTR6RVR0azRJeHpIUnNsK2tuQTZ6elcwYUJpTzJzODR1ak9yZ1Fh?=
 =?utf-8?B?dmxwYzFQbVp6elVKenI0ZGFKc1p2dFhmOU81RkRjV3RXZms4Q3NVSERyeW9C?=
 =?utf-8?B?cHZvS3BCRUg4YUNxTG85RDl5UVcwRkliWkJ5c05iakY0d3RKOWZ5cWpPdVRm?=
 =?utf-8?B?N25YY29mSUV3RWQ4RjljVk0rdmhoakpzWXNuUlZFUTNQdmhONmdqeFVjTExo?=
 =?utf-8?B?ejdtRFp2WjFuSFJYNE5hd2JTSElxT2R6K3k5SlhlUzJhd01hckxQa0dkbzBU?=
 =?utf-8?B?RFIzL3U4dzBxeGFMSVpNalc2VE9ka25XSzhRTEFpVFNXMXN6Z3AvQzFKbDlu?=
 =?utf-8?B?R0U2cHBCTlRWREIrOWJUMjJ2NDhqb0xzdXVQdDVDL0Z1VDZ5Z1d2MlozSkpE?=
 =?utf-8?B?VllSQWExUHFONVM1OTBrKzB2MDFqbEhvMG9CeEpYV3IzdkwxaEFxb2VueW1w?=
 =?utf-8?B?ODJFY2RUSHByTnpIdTZMOVFxSHlLNGhuR04rZGFocmRnWlMwbzVCOFg5ZW11?=
 =?utf-8?B?S3NGQzJXdExCUHhURTRBSFE4MzV3ZFpQOFBPS3JsMDN4cjlab2d4c01TQU00?=
 =?utf-8?B?RkF0WURISWhOMmVXQjRFSEpjWGxBcGhuWmVaYUdxTFV5M3kzVDhidWZrZ1Zn?=
 =?utf-8?B?SDZpV3JrN0lsRExqTzRHODh2UTZ1ejZEQlArZTV2UVlEcXdJeE1vWkdMMDMx?=
 =?utf-8?B?QlBUUUhxejQwR0JCUGx5MXFORjRIelgrOEthSnRZQ2J4Q0habnFvaEtJV3pQ?=
 =?utf-8?B?Vm1kbjhpQ0lSMWdxK1RXcmh6NHhXakRpU0NxTFEvOUhZUjlldmt5WUVCNXlX?=
 =?utf-8?B?SytRMVc5N3dnZnZBci9BekNKNm9aa1hFdVArUkVpOXFFKyszeFdTRjZTQjBU?=
 =?utf-8?B?OE1VVWFrMGFKU1Q4aGpycUlqMFJkSmZrbUd4RDlFWlpFWUcyOVJhV1ViZHRM?=
 =?utf-8?B?L096eW1LUVFKQ2ZKRTQ3Z0hGQXBULzlmQTF1Mm11ZFA5Q2FlQk90SStWZFRa?=
 =?utf-8?B?cDNOWDBkWnpOdlJEd0QzZ1dhbXBuMTMyTFk1MmNBQTlGVlJEWFBObkdFRFh2?=
 =?utf-8?B?WkprZ3lHcVExdWhWa1d4bjBIYUp2S2xFRnhCMmxmVDBHSTdnSXhVQ0Z3YTZM?=
 =?utf-8?B?RmhnNURaS0x4K1d6OW4yQWlZdDczWW1BbEt6d3gzOUNJQUVBS1hrT2FBS0s4?=
 =?utf-8?B?NWN5WmUvdjl6MnFtWU8wenV5UjduS2NraXF5ZVU3c3NUV1hGU1o2cnFGZS9t?=
 =?utf-8?B?S3pLTS9sZ2NVVTVyVlE5Q0dTVE5LOU1vbDdCUlRiamV4NEk4aUNmRENyMnlu?=
 =?utf-8?Q?RUSjEiPUNxhpyyjalRbLw2Krf?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DS0PR11MB7529.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 693ca59e-a31e-4217-8371-08db0451f13c
X-MS-Exchange-CrossTenant-originalarrivaltime: 01 Feb 2023 12:43:38.8881
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: gpxH37QMJ6NPo9G0eEdenAhXlNzZrT0eoOUpHMinpKc6SJ7Vpa8tOKH5uToiDmARd9gGisrcseEifN6+L0WpGQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR11MB6467
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

PiBGcm9tOiBKYXNvbiBHdW50aG9ycGUgPGpnZ0BudmlkaWEuY29tPg0KPiBTZW50OiBXZWRuZXNk
YXksIEZlYnJ1YXJ5IDEsIDIwMjMgNDoyNiBBTQ0KPiANCj4gT24gVHVlLCBKYW4gMzEsIDIwMjMg
YXQgMDM6MDY6MzVQTSAtMDUwMCwgTWF0dGhldyBSb3NhdG8gd3JvdGU6DQo+ID4gQEAgLTc5OSwx
MyArNzk0LDE0IEBADQo+IEVYUE9SVF9TWU1CT0xfR1BMKHZmaW9fZmlsZV9lbmZvcmNlZF9jb2hl
cmVudCk7DQo+ID4gIHZvaWQgdmZpb19maWxlX3NldF9rdm0oc3RydWN0IGZpbGUgKmZpbGUsIHN0
cnVjdCBrdm0gKmt2bSkNCj4gPiAgew0KPiA+ICAJc3RydWN0IHZmaW9fZ3JvdXAgKmdyb3VwID0g
ZmlsZS0+cHJpdmF0ZV9kYXRhOw0KPiA+ICsJdW5zaWduZWQgbG9uZyBmbGFnczsNCj4gPg0KPiA+
ICAJaWYgKCF2ZmlvX2ZpbGVfaXNfZ3JvdXAoZmlsZSkpDQo+ID4gIAkJcmV0dXJuOw0KPiA+DQo+
ID4gLQltdXRleF9sb2NrKCZncm91cC0+Z3JvdXBfbG9jayk7DQo+ID4gKwlzcGluX2xvY2tfaXJx
c2F2ZSgmZ3JvdXAtPmt2bV9yZWZfbG9jaywgZmxhZ3MpOw0KPiA+ICAJZ3JvdXAtPmt2bSA9IGt2
bTsNCj4gPiAtCW11dGV4X3VubG9jaygmZ3JvdXAtPmdyb3VwX2xvY2spOw0KPiA+ICsJc3Bpbl91
bmxvY2tfaXJxcmVzdG9yZSgmZ3JvdXAtPmt2bV9yZWZfbG9jaywgZmxhZ3MpOw0KPiANCj4gV2Ug
a25vdyB3ZSBhcmUgaW4gYSBzbGVlcGluZyBjb250ZXh0IGhlcmUgc28gdGhlc2UgYXJlIGp1c3QN
Cj4gJ3NwaW5fbG9jaygpJywgc2FtZSB3aXRoIHRoZSBvdGhlciBvbmUNCg0KYSBkdW1iIHF1ZXN0
aW9uLiBXaHkgc3BpbmxvY2sgaXMgcmVxdWlyZWQgaGVyZT8g8J+Yig0KDQpSZWdhcmRzLA0KWWkg
TGl1DQo=
