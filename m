Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3544A72F115
	for <lists+kvm@lfdr.de>; Wed, 14 Jun 2023 02:42:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241500AbjFNAm0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 13 Jun 2023 20:42:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58072 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229554AbjFNAmY (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 13 Jun 2023 20:42:24 -0400
Received: from mga06.intel.com (mga06b.intel.com [134.134.136.31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CC9D81989;
        Tue, 13 Jun 2023 17:42:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1686703340; x=1718239340;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=87+aX8snJlGt+BndnLYPfg+xl5T+sainhealzXzjL3Q=;
  b=U6217uCQo9cCPWGZHraHmdq+B19m13/VUHNKAvw7Sb6KcAqPxnVHoRUL
   f1WwKnUyc6xN4DcPwIFlz0bWG4Ey5GFMwLgRKbtr3grv8suvHKp+tCCkZ
   42LedOCIMOVBGEDmjVM6940b+XzHb3jaThasASJciPyc+C53lO4Tnhc75
   /2wtUGKpmbIo9AxVXKBEvFzuDv8uZxZhzDLqNN59VAOdh53+UlldHFGS4
   ljMnyaC2VhIj3wG7lyQJ26CcBZgeMy1dZwkSWcJPVZMvLJT/FDzdMI7v3
   p5BC2Sn3C4kBlZj3DcLkcUS3PGsa5G44OJ+MERadJYtz5OwtuqvSc5DvA
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10740"; a="422085371"
X-IronPort-AV: E=Sophos;i="6.00,241,1681196400"; 
   d="scan'208";a="422085371"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Jun 2023 17:42:20 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10740"; a="1041975826"
X-IronPort-AV: E=Sophos;i="6.00,241,1681196400"; 
   d="scan'208";a="1041975826"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by fmsmga005.fm.intel.com with ESMTP; 13 Jun 2023 17:42:19 -0700
Received: from fmsmsx611.amr.corp.intel.com (10.18.126.91) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Tue, 13 Jun 2023 17:42:19 -0700
Received: from fmsmsx612.amr.corp.intel.com (10.18.126.92) by
 fmsmsx611.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Tue, 13 Jun 2023 17:42:19 -0700
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx612.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23 via Frontend Transport; Tue, 13 Jun 2023 17:42:19 -0700
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (104.47.66.45) by
 edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.23; Tue, 13 Jun 2023 17:42:19 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gFI+5J+eqmgO6O6o6pR5w5muevXOQ9tREObRpRitlNPrZJEGsSJU2HMIvVYPlx01/R+xUxQvPhQ3Lnykb2PjdsAFAXLajYuA7fHNaUZlEAijnsEkPSQs3x1cKv3XfWcvuojxfQq8z0ZQnGMuoz2jdAsfZO7xFn8E5jcK3hjqEU8ea6J1TERjx+y7SMWeiZxoMDmGlT8QhkvKSqChhGZir8ym9GPnh6xKBs+grQox4AmJWZpK4xJykfCnQ72n13V/5+WT7EAjRrOpJ+HQm+knrOSXriKQw5TtD1owukgWmGiDfhE59jYBbSK3etZXYV9g6VyfwE5DFX55CSqODAKABw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=87+aX8snJlGt+BndnLYPfg+xl5T+sainhealzXzjL3Q=;
 b=HjIsuJv1uurJC02IBS7QCbsnOCQFZbwBa3VZnCZ7kOIfeId1Q2iQbMDK48kOrW2hkecVwGCfMc4M2pMZjDb0joLRIp91QKka18T84Pos4wrX9zQK1EWi7Zr87Hz9i2TcLHZmmWRsLjYH9Pa2Bk898rU/ts4NOdBQH3Mb60wHfpv8ZJxmiSg36cgtevaeizKqzKP1TD3/FB/j0gAlPwsJK1tEnI3Xu/so4K84sm+SCIV2bv4Jh6v0VTc3dFU3BItbq33RaOKtrQnRT7JVvVWOJYJjnImszGdMDYA9XBPlUS34O1lKZGB71HByKYGqxq7QNeSxiIOnht/eHRNauOQOHw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5978.namprd11.prod.outlook.com (2603:10b6:208:385::18)
 by MW4PR11MB6737.namprd11.prod.outlook.com (2603:10b6:303:20d::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6455.38; Wed, 14 Jun
 2023 00:42:16 +0000
Received: from BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::19b7:466f:32ac:b764]) by BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::19b7:466f:32ac:b764%3]) with mapi id 15.20.6455.043; Wed, 14 Jun 2023
 00:42:16 +0000
From:   "Huang, Kai" <kai.huang@intel.com>
To:     "kirill.shutemov@linux.intel.com" <kirill.shutemov@linux.intel.com>,
        "Hansen, Dave" <dave.hansen@intel.com>
CC:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "Luck, Tony" <tony.luck@intel.com>,
        "david@redhat.com" <david@redhat.com>,
        "bagasdotme@gmail.com" <bagasdotme@gmail.com>,
        "ak@linux.intel.com" <ak@linux.intel.com>,
        "Wysocki, Rafael J" <rafael.j.wysocki@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Chatre, Reinette" <reinette.chatre@intel.com>,
        "Christopherson,, Sean" <seanjc@google.com>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "Yamahata, Isaku" <isaku.yamahata@intel.com>,
        "Shahar, Sagi" <sagis@google.com>,
        "peterz@infradead.org" <peterz@infradead.org>,
        "imammedo@redhat.com" <imammedo@redhat.com>,
        "Gao, Chao" <chao.gao@intel.com>,
        "Brown, Len" <len.brown@intel.com>,
        "sathyanarayanan.kuppuswamy@linux.intel.com" 
        <sathyanarayanan.kuppuswamy@linux.intel.com>,
        "Huang, Ying" <ying.huang@intel.com>,
        "Williams, Dan J" <dan.j.williams@intel.com>
Subject: Re: [PATCH v11 18/20] x86: Handle TDX erratum to reset TDX private
 memory during kexec() and reboot
Thread-Topic: [PATCH v11 18/20] x86: Handle TDX erratum to reset TDX private
 memory during kexec() and reboot
Thread-Index: AQHZlu+7CCb5RYnzE0SLr6ZWSpg4cK+CfSeAgAQK0ICAAFGDAIAAKbAAgAA3uQCAALmTAIAA45EAgACUsYCAABKwAIAAA9CAgAABB4A=
Date:   Wed, 14 Jun 2023 00:42:16 +0000
Message-ID: <d36f33b3ee24de3f96b38841bf8f32ad0d61c257.camel@intel.com>
References: <cover.1685887183.git.kai.huang@intel.com>
         <5aa7506d4fedbf625e3fe8ceeb88af3be1ce97ea.1685887183.git.kai.huang@intel.com>
         <20230609132301.uvvp27yr5kpenl6f@box.shutemov.name>
         <58f34b4b81b6d6b37d3386dec0f073e6eb7a97ff.camel@intel.com>
         <20230612075830.jbrdd6ysz4qq7wdf@box.shutemov.name>
         <4c7effc3abe71aa1cbee41f3bd46b97aed40be26.camel@intel.com>
         <48d5a29a-878c-665d-6ac2-6f0563bf6f3c@intel.com>
         <3bbb6b384ba89dfaa13be01654ad27e41d779fba.camel@intel.com>
         <6fb1ec2f-8713-8191-fd31-751b1a663b0b@intel.com>
         <1542a26c0501cb9f7fc330d8aa27e565c81b969c.camel@intel.com>
         <6e3ae1bd-c6e4-b7cb-ab4c-50849ffbc237@intel.com>
         <2ddb8858ad995904654379ee57a5949dee3f696b.camel@intel.com>
In-Reply-To: <2ddb8858ad995904654379ee57a5949dee3f696b.camel@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.48.2 (3.48.2-1.fc38) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR11MB5978:EE_|MW4PR11MB6737:EE_
x-ms-office365-filtering-correlation-id: a8bc8664-9aeb-45c8-39b5-08db6c7033cb
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 5bmsnexuU1f6W70+kdmF/ZKQXlPupX/Xlpb/k4VurDnMpZSRIH483tDJ+OtrUMJnjnExE3GvjUIzB6mDJidoD4XaS+c1OClfvwS5cVB1nWy7m4AGGN/+Idv/ZFQsP6HoSyqtsYJBoNarvHnGpfyeIUs1opP0Cy7zLCyVpunADJjfuqyvqGFI2kFkibwA6Lz283tAeA36U/5NQxyeTA6GbbM0eARtxmI3Bjxct0o51wNPbKaTEhubCliZmO3Pme51/8A0uRpRE9UMMabz7DCXGs+P2uLoM8HoxcgYRsRQrB6XiDlx5aSZioCz4c7geBaqqbxZXprltDsL9GykGaAtNyhCfWO9JOHjQbBcnbo9+GTlcwd8cDuCVlkLy9BZZ1FYQAQHPJbQYm1Jr1aXY5BX6WkWG9poXlRm0WB1A6vXOQ9V+/8cGjUcrmF50fND10ariWIle9xOgTwfGKNLjMEIbLyveE1S+LZ2dWl4GUBSGmK0jbM2e/KABUWq55Jq1cw4MSBTtTaMlL4YrUXhrNzZypXXs7Qmmhv1jafmIpvTUmKkY/5KE77cf2uufA3GF/9GXAQcazWiMw4NRxxetf+tkp9Vj5y8whE6CKrBY8jRAdfegrjOFGHT1UxQKxUKBL6r
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5978.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(346002)(366004)(396003)(39860400002)(376002)(136003)(451199021)(83380400001)(7416002)(478600001)(38100700002)(36756003)(82960400001)(8676002)(8936002)(86362001)(66476007)(66946007)(41300700001)(316002)(6636002)(91956017)(66446008)(66556008)(76116006)(4326008)(122000001)(38070700005)(64756008)(5660300002)(2906002)(71200400001)(110136005)(6486002)(54906003)(186003)(6506007)(26005)(53546011)(2616005)(6512007);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?alJJMVhKbnVhY3gzOUhNeTRRNkdQRytjdWtGelhoeWhmUE14Q3FEeVo4Tkkx?=
 =?utf-8?B?bzVnVllVMXA1VGFlbWJYU3huVTg1bnd6ZXJJNFNOZFN6YitPQURMQVZKMXE5?=
 =?utf-8?B?UHdSS0VXaXVIbEZCZlFINFhxRW5IV2txT05SdjVmSmVYRTVqOTlpK3p6V1BR?=
 =?utf-8?B?ekNXWmVrL0dmOHdaM1BlWUhSZXNGTE5GNkNqS2RuYVlaZjVNZXd6N3doMUYy?=
 =?utf-8?B?RGk2MzcwWFRaL1N3ZWdYNjZuQld1b1BGMGtWdEpoeXpDakUyM3dITDVHMmxa?=
 =?utf-8?B?eEI4a3JUWE9VQmU3WGptbUdpc29TUmpueGN6TzlUV3FrRC9LcHJtTjdvZll5?=
 =?utf-8?B?R1JmOHhieGk3UFV4b3ZxRFVFZHRORXpvQU5hTElYdUxOZzFZSy91NnVLSGhk?=
 =?utf-8?B?Mzh3THFrVUxGWG1HZHhRQ2FpSU1hbi83UHVGcmxycGRYRHF0amxVTzdwQ3l1?=
 =?utf-8?B?eml0R2szTGJieXFtVG1oRmdGVXlaM2xRVitwTUNtakxEa2FtSXBGWFhUaGpO?=
 =?utf-8?B?N1pncnRyaERHUFZ6TkQ5WnA0NzlEWGExTHJNcThvVzVZenpZekNSVmNQZXlX?=
 =?utf-8?B?QWllZ1RhMzJKRnR3VWZKb2wvQjdWd3JXcG5kNUlpVEsxb1M0T29tTWQrcUYv?=
 =?utf-8?B?a00valpoN1ZVMDJOTnAwTHg3eWR3dlJiV2pPbm5odlYwTUVySVpqYncremNO?=
 =?utf-8?B?aEJmdmRqaEZWOWZzNExFSHU4QWZmaFpCN3k4aTBobENUcFhqK0xBZnlMdHFP?=
 =?utf-8?B?TkZHN2xhMlNSS0xGMUhIQndvRWFJU2t0aW43QS9uRkJpZVdMNjBoR2owNjl0?=
 =?utf-8?B?dURHZlNFbkI3ZU9CbW1oQ1NUbnBnbExXaURmcSthSGxqU00zZko5V1ZxOWJD?=
 =?utf-8?B?R3BGT25JU01CSFByTkFzeG1DZXg5VTAyRFcxdVRkakVRbEprcFB0UDZqT3RK?=
 =?utf-8?B?c0FFSkpsUHZBTzBvcFkzRXZDeGFFSEQxYnBxMVVLbURXbEdHUW8wS0REMXNq?=
 =?utf-8?B?WGhoczA2TmNYNU9tanlRRjI2YlNLVUpXOFN0NEZKaXdOdkdBNmJIZmQ2RmE2?=
 =?utf-8?B?VTBRa3A5YzZHTENPbC81c0QyZ0xxV0VOY3NveHg2S1NoWmg5Wnd5L3AzWWpE?=
 =?utf-8?B?ZTcyQmxsbHlJai82cUdOTHFLeDZWYUR0QlFtSk5FVTBqRWlCdm1DcXIzVWVZ?=
 =?utf-8?B?SkE5cEZoUW41TnVZYlZneURnRmtJdGdXWnQ1bXM0U3BSblg1dEE5WjVPNWpo?=
 =?utf-8?B?Y0lnSXZvY1NiZm11TkFzTE0vY1RSTnRlbTV6VFlrYjVKRlUybC9HSXk5UjlF?=
 =?utf-8?B?ckFEckYvdXZJcjhaYVlNc0pLU0lGMFJyTER2NHhwQitDWUZQOWJGWmNvUHFu?=
 =?utf-8?B?Um45bGZyMjdkRGVYQ3UvQ2hmLzZPbWxNUnBvZ3R0a2NVeElsL2tWMjZPSWxJ?=
 =?utf-8?B?eCthbjBRNTlkWW5Dd0c3NlZ2TFV0OTh0NzYvc1Q2eU1xNm1PVlNMMEpEd3pY?=
 =?utf-8?B?djRkR09zK2c4YUg0ZmFOTU45UTArRUR1QkNUbEgzVWVJS0EzRHJEV3RGdm5t?=
 =?utf-8?B?VzVudEdqaHd2M1NBeG11TnlRUkx1MVhXUHl1L2hqTU5XdVZVYmdoRTA1Qk1o?=
 =?utf-8?B?dElNTzN6VHozbDBDM240UFQxaTloRmZhUGEzQnJEUGxVQjFkRTJIK0Q4N0pY?=
 =?utf-8?B?ajBMNkFaRURsYjU3TEZLMUYxYUg5Zlhab1V3UXI5eUU4bFVBVHpDMGdZaWNS?=
 =?utf-8?B?dUtqVWFKZ2pmaEZRWmpXWE02UWJoUVk2UlpvUWg1SnVpcHBqWmJROVYwRTV2?=
 =?utf-8?B?cEx1MXpBbVErN3k0Y3ErVm1SU0NsL1VFVkRZbElHOUYvL0NTVDRGbDhjN0Mr?=
 =?utf-8?B?Sm0zc2ZCMDFwcnJXVUlRQUpXMmNxYUpnOTVUREhob3dub25xTGpyUngrY0RP?=
 =?utf-8?B?dEdRcTNYankvcXJZUXlyd2s2ZUk2OEEzTExVTXZFTm9DbUIwcHh3Y0FDL21G?=
 =?utf-8?B?RkZITlRsM0t4M2xoTmJvclVJLzVEb1g5S3BoOG9nK1l2dkJQdWkyRFV5ZTE0?=
 =?utf-8?B?K1VjbnNraWR6di9KdDRLUHdydGxmNUgrNGs1NjNqYk12Yjl6b2FUS3ppY2t2?=
 =?utf-8?Q?iu4g8wpd8P1uzxDmPAAOCppp8?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <A30876B0D195EC4DA978C463A490B84C@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5978.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a8bc8664-9aeb-45c8-39b5-08db6c7033cb
X-MS-Exchange-CrossTenant-originalarrivaltime: 14 Jun 2023 00:42:16.3762
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: mnqeBLbIsW5giILCIYOEWthv78p2caD24+j9w3YJ0xTqUrMvuDcFKcLtVOGn104ZAYmQvbB/zPZuZwdW0ou4mw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR11MB6737
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

T24gV2VkLCAyMDIzLTA2LTE0IGF0IDAwOjM4ICswMDAwLCBIdWFuZywgS2FpIHdyb3RlOg0KPiBP
biBUdWUsIDIwMjMtMDYtMTMgYXQgMTc6MjQgLTA3MDAsIERhdmUgSGFuc2VuIHdyb3RlOg0KPiA+
IE9uIDYvMTMvMjMgMTY6MTgsIEh1YW5nLCBLYWkgd3JvdGU6DQo+ID4gPiBPbiBUdWUsIDIwMjMt
MDYtMTMgYXQgMDc6MjUgLTA3MDAsIEhhbnNlbiwgRGF2ZSB3cm90ZToNCj4gPiA+ID4gT24gNi8x
Mi8yMyAxNzo1MSwgSHVhbmcsIEthaSB3cm90ZToNCj4gPiA+ID4gPiBJZiB3ZSBpbnRyb2R1Y2Ug
YSBoZWxwZXIgdG8gbWFyayBhIHBhZ2UgYXMgVERYIHByaXZhdGUgcGFnZSwNCj4gPiA+ID4gTGV0
IG1lIGdldCB0aGlzIHJpZ2h0OiB5b3UgaGF2ZSB3b3JraW5nLCBmdW5jdGlvbmFsIGNvZGUgZm9y
IGENCj4gPiA+ID4gaGlnaGx5LXVubGlrZWx5IHNjZW5hcmlvIChrZXJuZWwgYnVncyBvciBldmVu
IG1vcmUgcmFyZSBoYXJkd2FyZQ0KPiA+ID4gPiBlcnJvcnMpLiAgQnV0LCB5b3Ugd2FudCB0byBv
cHRpbWl6ZSB0aGlzIHN1cGVyLXJhcmUgY2FzZT8gIEl0J3Mgbm90IGZhc3QNCj4gPiA+ID4gZW5v
dWdoPw0KPiA+ID4gPiANCj4gPiA+ID4gSXMgdGhlcmUgYW55IG90aGVyIG1vdGl2YXRpb24gaGVy
ZSB0aGF0IEknbSBtaXNzaW5nPw0KPiA+ID4gPiANCj4gPiA+IE5vIGl0J3Mgbm90IGFib3V0IHNw
ZWVkLiAgVGhlIG1vdGl2YXRpb24gaXMgdG8gaGF2ZSBhIGNvbW1vbiBjb2RlIHRvIHlpZWxkIGxl
c3MNCj4gPiA+IGxpbmUgb2YgY29kZSwgdGhvdWdoIEkgZG9uJ3QgaGF2ZSBjbGVhciBudW1iZXIg
b2YgaG93IG1hbnkgTG9DIGNhbiBiZSByZWR1Y2VkLg0KPiA+IA0KPiA+IE9LLCBzbyAuLi4gYmFs
bHBhcmsuICBIb3cgbWFueSBsaW5lcyBvZiBjb2RlIGFyZSB3ZSBnb2luZyB0byBfc2F2ZV8gZm9y
DQo+ID4gdGhpcyBzdXBlci1yYXJlIGNhc2U/ICAxMD8gIDEwMD8gIDEwMDA/DQo+IA0KPiB+NTAg
TG9DIEkgZ3Vlc3MsIGNlcnRhaW5seSA8IDEwMC4NCj4gDQo+ID4gDQo+ID4gVGhlIHVwc2lkZSBp
cyBzYXZpbmcgWCBsaW5lcyBvZiBjb2RlIC4uLiBzb21ld2hlcmUuICBUaGUgZG93bnNpZGUgaXMN
Cj4gPiBhZGRpbmcgWSBsaW5lcyBvZiBjb2RlIC4uLiBzb21ld2hlcmUgZWxzZSBhbmQgbWF5YmUg
YnJlYWtpbmcgdGhpbmdzIGluDQo+ID4gdGhlIHByb2Nlc3MuDQo+ID4gDQo+ID4gWW91J3ZlIGV2
aWRlbnRseSBkb25lIF9zb21lXyBraW5kIG9mIGNhbGN1bHVzIGluIHlvdXIgaGVhZCB0byBtYWtl
IHRoaXMNCj4gPiB0cmFkZW9mZiB3b3J0aHdoaWxlLiAgSSdkIGxvdmUgdG8gaGVhciB3aGF0IHlv
dXIgY2FsY3VsdXMgaXMsIGV2ZW4gaWYNCj4gPiBpdCdzIGp1c3QgYSBndXQgZmVlbC4NCj4gPiAN
Cj4gPiBDb3VsZCB5b3Ugc2hhcmUgeW91ciBsb2dpYyBoZXJlLCBwbGVhc2U/DQo+IA0KPiBUaGUg
bG9naWMgaXMgdGhlIHdob2xlIHRkeF9pc19wcml2YXRlX21lbSgpIGZ1bmN0aW9uIGluIHRoZSBu
ZXh0IHBhdGNoICgjTUMNCj4gaGFuZGxpbmcgb25lKSBjYW4gYmUgc2lnbmlmaWNhbnRseSByZWR1
Y2VkIGZyb20gMTAwIC0+IH4xMCwgYW5kIHdlIHJvdWdobHkgbmVlZHMNCj4gc29tZSBtb3JlIGNv
ZGUgKDw1MCBMb0MpIHRvIG1hcmsgUEFNVCBhcyBwcml2YXRlLg0KPiANCg0KQXBvbG9naXplLCBz
aG91bGQgYmUgIndlIHJvdWdobHkgbmVlZCBzb21lIG1vcmUgY29kZSAoPDUwIExvQykgdG8gbWFy
ayBQQU1UIGFuZA0KU2VjdXJlLUVQVCBhbmQgVERYIGd1ZXN0IHByaXZhdGUgcGFnZXMgYXMgVERY
IHByaXZhdGUgcGFnZXMiLiAgQnV0IG5vdyB3ZSBvbmx5DQpoYXZlIFBBTVQuDQoNCg==
