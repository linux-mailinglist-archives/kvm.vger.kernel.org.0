Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 57218631C9B
	for <lists+kvm@lfdr.de>; Mon, 21 Nov 2022 10:16:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230108AbiKUJP6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 21 Nov 2022 04:15:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33620 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229633AbiKUJPu (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 21 Nov 2022 04:15:50 -0500
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E0B028D4AF;
        Mon, 21 Nov 2022 01:15:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1669022149; x=1700558149;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=kfb+JdAhY1l0wswFURxMsRuT7BDTkQBWUjD4eqMRAYk=;
  b=lIWgIAwd7nTrvCFZz2CLOqTXaJjZ4MnDgwXLfq4QC7gnm3pZ9JOOS9Qc
   IjuENkqA+YS09NtajDAl6mdRLZjgzyYlpfh1hRLXsTtdVcq8W8rUsKfdm
   5HkKFpnHTLI/erW2iUEEdqLAci4w8CQhPqCnGWRNKzhr5WJ0wZlA6NCfV
   2q7ZKXaocxMLpzwUsEoDt6x7/4kytTp1VSYJHVSxFlBLiMGGtsPfxpob1
   vhDKTaHgo+Lf3DqWXFiKkf5tLr6DXA0qqgyyICTQnKexU8S2w2dDZIzhM
   Qx9PQP8QfwT8jd1X946SlDLQKaVaMgn39vdV1qvRWp5+GXlfXZTdeaZaK
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10537"; a="315334266"
X-IronPort-AV: E=Sophos;i="5.96,180,1665471600"; 
   d="scan'208";a="315334266"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Nov 2022 01:15:49 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10537"; a="704491432"
X-IronPort-AV: E=Sophos;i="5.96,180,1665471600"; 
   d="scan'208";a="704491432"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by fmsmga008.fm.intel.com with ESMTP; 21 Nov 2022 01:15:48 -0800
Received: from fmsmsx612.amr.corp.intel.com (10.18.126.92) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Mon, 21 Nov 2022 01:15:48 -0800
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx612.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Mon, 21 Nov 2022 01:15:48 -0800
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31 via Frontend Transport; Mon, 21 Nov 2022 01:15:48 -0800
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (104.47.70.109)
 by edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2375.31; Mon, 21 Nov 2022 01:15:47 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=L96kZzqnWM8RGSm/s86S3lRvTZHWNEt9vaFKKzkzI1itrjaYhuC1upt5bq2j4QPtecTCL/jlYCraYb9q8VgH4utDJESnAAaUoMfcbTanU0dLm04Xn+32YKouenCLo3Kj+OYChTEBbDymRdQGqcZMQ8IDe/4PWTrYstftPl+glHQxQTX2Hen3GdcARtRXcPel2tYMvrDwgDflRFusCFKs72IAuqidyMFEeFfe7/FDPVvfbfm/1If7fAfsLStK2ZRYEs+qKMNCgqo+K/Ag3BrjaYjJ0zOWYnQWODtTJ1yWJG3/9QwQXIW9zCsBNuIUUm81ShocWXeL/4R1NLua2rn4Zg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=kfb+JdAhY1l0wswFURxMsRuT7BDTkQBWUjD4eqMRAYk=;
 b=KeX+laB2LKz2DgqNHkqRXKGUfl7/IqSP9QiHklh3SQ5x39Ch4fcXBEyL+ONhgURZRCsIqhCbJuYZgAestTX1QLnlvJglqLSIutbYSWmFjrzRmV2gyy6rEsrXSuCP/mgU5PQSC4VTWiUP5PHxzH3SFUwb1tEyK9qc5+M4I4qCZiq+GXf5th8883EntGroweZwKfFKcJEOVkUJxBnLU3mpTgZ0Him2W3qF+MzKw66IC43HdbRb8YaCclzX5n5tke33pUV4gYToYxXsQqIo1c+8X5MgBcRQ/s236AG3XATd8yjlhGXZO+ezF1lMeSYDP5Vy/U2K9AL/L/Ps3KplBNOZuQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5978.namprd11.prod.outlook.com (2603:10b6:208:385::18)
 by SN7PR11MB7140.namprd11.prod.outlook.com (2603:10b6:806:2a3::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5834.11; Mon, 21 Nov
 2022 09:15:45 +0000
Received: from BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::2fb7:be18:a20d:9b6e]) by BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::2fb7:be18:a20d:9b6e%8]) with mapi id 15.20.5834.015; Mon, 21 Nov 2022
 09:15:44 +0000
From:   "Huang, Kai" <kai.huang@intel.com>
To:     "sathyanarayanan.kuppuswamy@linux.intel.com" 
        <sathyanarayanan.kuppuswamy@linux.intel.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
CC:     "Hansen, Dave" <dave.hansen@intel.com>,
        "Luck, Tony" <tony.luck@intel.com>,
        "bagasdotme@gmail.com" <bagasdotme@gmail.com>,
        "ak@linux.intel.com" <ak@linux.intel.com>,
        "Wysocki, Rafael J" <rafael.j.wysocki@intel.com>,
        "kirill.shutemov@linux.intel.com" <kirill.shutemov@linux.intel.com>,
        "Christopherson,, Sean" <seanjc@google.com>,
        "Chatre, Reinette" <reinette.chatre@intel.com>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "Yamahata, Isaku" <isaku.yamahata@intel.com>,
        "peterz@infradead.org" <peterz@infradead.org>,
        "Shahar, Sagi" <sagis@google.com>,
        "imammedo@redhat.com" <imammedo@redhat.com>,
        "Gao, Chao" <chao.gao@intel.com>,
        "Brown, Len" <len.brown@intel.com>,
        "Huang, Ying" <ying.huang@intel.com>,
        "Williams, Dan J" <dan.j.williams@intel.com>
Subject: Re: [PATCH v7 01/20] x86/tdx: Define TDX supported page sizes as
 macros
Thread-Topic: [PATCH v7 01/20] x86/tdx: Define TDX supported page sizes as
 macros
Thread-Index: AQHY/T28NJwJCQ29uEGaaLK5clcXr65IrjeAgABq94A=
Date:   Mon, 21 Nov 2022 09:15:44 +0000
Message-ID: <088c54c9eacefde34c905c813facfceeb4d13b0d.camel@intel.com>
References: <cover.1668988357.git.kai.huang@intel.com>
         <d6c6e664c445e9ccf1528625f0e21bbb8471d35f.1668988357.git.kai.huang@intel.com>
         <2eedfcff-e8c1-79af-63f4-c852af7b7e77@linux.intel.com>
In-Reply-To: <2eedfcff-e8c1-79af-63f4-c852af7b7e77@linux.intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.44.4 (3.44.4-2.fc36) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR11MB5978:EE_|SN7PR11MB7140:EE_
x-ms-office365-filtering-correlation-id: f6034316-f66e-4075-4502-08dacba0f84e
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 3KsErXpoQ54S/ibIBjSmZsB0jhZjFauwLntOVgotKUJUv1TOG9/QHTZcunpcTE6eLhq7hY6r6iFwCwr0j4v4txlQqucNd0A8TA+KylhSD/tljWZXiw8rgm83tqXfWdzTyQy8T3RAtd7OLMyVkhIH3cdlWMrII5g/Bb6chQhuRjLbTcGsxqDUrmel4bPowKcgf+JH7oxn3rxSN3AxHIAg4KvD2FMHJywPR/1qgBzB394rXR+aQR3zmVqAiIfT9Y3FxRp5vXQg65R/ztvO0dWZLmbPVaxtu/sm8KgOhYVz6DkoTfRl5YYgaciqIRNM1YUi9KGZjYLqCKiw7sKc2mAg0bSMDxhbil6bahkdyu5QgnO5JNo/w0/n93158bi0X6IM+7u4nVhOYmOqQ8d7YHzK9c5riRr8ZKUbmYRZpBX3hK2CHc0GNc5WB9rTQ7JaSln+XPZ/g9WyJlaDsP0/ljO1btitHMWGJkkOv7j1Qyk7MbNMe5e8/MKTXKUHA+RgQsKdbusl9yRymVZMrhXVo6Bj+RwhBZGdahNhPXClwuoQkyzjqxe7aXAfZx+SNaaeDBfkIyY5AqMbAelGpTZQgMh/5MhT/Z8IPcj8RxLbG+x6YUx458+dMsdG/PlKyVbZy734sz4at9IH93FAl3JNwQhQvfau9TG72kkY5CP54j4TBwi5uk6BGdYVWfptinFXu7nFeANCO+88N/Slz7WN91WdcCgCkDaQtWxePq/qAcf08jc=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5978.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(39860400002)(376002)(346002)(396003)(136003)(366004)(451199015)(86362001)(2906002)(4001150100001)(6486002)(71200400001)(966005)(6512007)(26005)(54906003)(2616005)(110136005)(53546011)(66476007)(66446008)(316002)(66556008)(66946007)(6506007)(8676002)(64756008)(4326008)(5660300002)(7416002)(91956017)(4744005)(478600001)(36756003)(82960400001)(38100700002)(76116006)(38070700005)(8936002)(186003)(41300700001)(122000001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?b21aSWc3bjk3aTJGb2hrdTUwSkJpRXhhcldYdlNzSzdZd0t4enhmeGcrZHNn?=
 =?utf-8?B?bjI1alN2ZnA0T1F6T3dqeHBJRXN2Q1U0b1pncHR5dlpXaUM5bzIvOGFSRmhD?=
 =?utf-8?B?UjlWZm1WZEc1dk5jcFkwOGQ1ZXVuTmY3czBZenZaaEZJWm85aDFjL1ZjcFkr?=
 =?utf-8?B?QkpHV1Q1bnNFZitFbnZmcUJEckI2bjJLUEh0dUpqOUQzQjgwTC9SaTlNbW53?=
 =?utf-8?B?MjRyRXhaREJkam42cGRDYmQ3ZXgvTFliR1pKeUpNZlZCckZLM0ljMStXbDVX?=
 =?utf-8?B?dXJkemFmd1loWGRWeGdOR08xZStUbzlMdFF1ZmRpUDJPQ20wWkl4djFUVity?=
 =?utf-8?B?SXJHbXAxU3ZlNkpmMFdUWE0wNEgzSlJTV0lUOUJBNjBtc1c5Rk8wUG95c1Ar?=
 =?utf-8?B?TUl0UlM4TkRkdjFwUUdMalBTUUtrR1RmNFR4T0p4TGZwVWFMcis1Y3JDSU0w?=
 =?utf-8?B?Q0R6eStXemtGVVV1STNLY09iL0lVSjFQOER3R0d3RDZyQU9YOEVzdFhkNnhE?=
 =?utf-8?B?TlE3RWpzbVdTNzJZOG8vWndoVDZ6YkxTUzJLNVBzeHVNelZvOGF4cTdxTkw5?=
 =?utf-8?B?ZmtKeUxoZ1FvV0NQSzMyanlGbElvUEV3L0RPc2dUc1FYelVJdytsZjI3UTly?=
 =?utf-8?B?VXlxak9OS3lzc1BXM0RyWjBMTE03dWNtRGNxWEx1aUJ3SnRPNGJkSlI5QUxB?=
 =?utf-8?B?clVjQ3k3QzFvME1qN2FnNDZWYVF5SDVTQ1B6eGxPTjAvS0RPb0JuUEtkME1O?=
 =?utf-8?B?ZXhMVWdyUzM2ZnhRN1RMZFBlNE5lMG9EZW9EalU1MEFpRWRnK1g3czlFRE91?=
 =?utf-8?B?RHZLQ0p1dkRHUXpPNjJxdlhZeEdKNG5xQU41bUxJSTdwbU83S3ZnOWtIdmJQ?=
 =?utf-8?B?N0dlQkt3bVVhRWUrNFhFWWpCc0dMNmdEY3dxdzVKZkl4cDhPNzhGVDkzdVUv?=
 =?utf-8?B?TVdYQkIyM1FLbHNNbGE4VXM3Mms2N0RHVjFQQmRRUkk3ZFErOE5wRzRIb0pW?=
 =?utf-8?B?bURZaEo0TXArMlc5L0h0TmpIUlFXYm1DcDlFOEk0L1N5cHZHWGRWU00yM0tO?=
 =?utf-8?B?bEM3dkhFYnppV0lJNVlTSE1oOWlzWmt0VzR0Y3Z6UWNhb3lnVEdBSGFxZmp5?=
 =?utf-8?B?Sk02UGoxb1ZKTGdSUGhiUEtoeVFWSGNZNnNTc1MyMUgvVER5Q3NyY2UxNlNo?=
 =?utf-8?B?SFo0ZUlMVUpKQWxxWlpRVFJNSjMvS3Nmb01ZZ3RzbmdsamROMDBybXlRenZV?=
 =?utf-8?B?ZGxCdDZzRHdHeGJyUU1MRGJ2UVV1bG85ZHJxVm52cVFYNDZ2aWdTSUxXWFd3?=
 =?utf-8?B?QkNYSHRkWGt1Z3k0bmo4UkhMcHlxNmpDZkx3K3FudDQ1cUowcEkvM04rNWhQ?=
 =?utf-8?B?bjkraUtNUERZcjVHOWdBZGlSV2hGaFBXWCt4SzArQWNLazdpbk50Q1lnNndF?=
 =?utf-8?B?WjNvMW1Ha1ovdVlISWFJUHJIR0hrTThmaEd5aVdRVjVXR0Y5V0JLcGRiTEVp?=
 =?utf-8?B?ZGtwL2IrTzJCUTQxZzRHNVJEOU9wbk0rV1NjMitzSGFUc3pUNzN3QWEyKzNG?=
 =?utf-8?B?U2pqeEZFRDNpLzJTd2szZmhQK0hWbWFhNkFXaGt2Wnk2ZXpqQWRTRHlyU0lt?=
 =?utf-8?B?SktsT04vanlUV1VuaWVVdEhlV2pFOURZb2FQVWdBVVIvcnNURmV5Tjk0eHB6?=
 =?utf-8?B?bVZPZWxSaVZkVm43cHZ6UnQybnZDYmZ6SjI1a2g4YmJCRmZYVlREM2NBbW5j?=
 =?utf-8?B?MWdnK3EzYzRJdVNGSVpSQ29DU0FzUEhOTTFzOE5aOWFxQnZwcVRPTGZvb3VP?=
 =?utf-8?B?M2NpcU4xc2s5a2FaTGJhY0tLcXlDMG1nZGFGWXl5VmZ0WVc0bEtHYmZuaDlF?=
 =?utf-8?B?WTBxS0FQd1VGZ3BlV1NrOVJZS0I5WGJuc1dpMlk2SThNc3lCdCtzblVuV2l2?=
 =?utf-8?B?WCs5ZEo1dTRKcjhYZ21ST1hTWU5yczJzSWFndmpJcWU5MUZMWXV2em0ycVdy?=
 =?utf-8?B?U3VHS1REOEFySjBYdG9remVDSmtCZ2lJVHkzQ3QzeWd5cXZmWEJGdlREa1hX?=
 =?utf-8?B?TXU5dU5leWx3V0hPRCthQ3o1dGZTV1dtb1pGeG1mU1FYcTYxbkZjbS8zVlJy?=
 =?utf-8?B?R1A2UTFXR3AxTmtRaGRMYlJnOEZtSUF5MUlCb3poS3hmQlkxYlJIV2FpOHZa?=
 =?utf-8?B?aEE9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <2256E07AF51201489EC10B5DAA7510E8@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5978.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f6034316-f66e-4075-4502-08dacba0f84e
X-MS-Exchange-CrossTenant-originalarrivaltime: 21 Nov 2022 09:15:44.7118
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 6KZRarubDp2HDtYmER/o11EAcVC60wOJuwBWvXgs3CF0qOsbPU3HZq9+P5YHxIU6dTpf6APyo0Hqh2EwF53xiQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR11MB7140
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

T24gU3VuLCAyMDIyLTExLTIwIGF0IDE4OjUyIC0wODAwLCBTYXRoeWFuYXJheWFuYW4gS3VwcHVz
d2FteSB3cm90ZToNCj4gDQo+IE9uIDExLzIwLzIyIDQ6MjYgUE0sIEthaSBIdWFuZyB3cm90ZToN
Cj4gPiArLyoNCj4gPiArICogVERYIHN1cHBvcnRlZCBwYWdlIHNpemVzICg0Sy8yTS8xRykuDQo+
ID4gKyAqDQo+ID4gKyAqIFRob3NlIHZhbHVlcyBhcmUgcGFydCBvZiB0aGUgVERYIG1vZHVsZSBB
QkkuICBEbyBub3QgY2hhbmdlIHRoZW0uDQo+IA0KPiBJdCB3b3VsZCBiZSBiZXR0ZXIgaWYgeW91
IGluY2x1ZGUgc3BlY2lmaWNhdGlvbiB2ZXJzaW9uIGFuZCBzZWN0aW9uDQo+IHRpdGxlLg0KPiAN
Cg0KU3VjaCBhcyBiZWxvdz8NCg0KIlRob3NlIHZhbHVlcyBhcmUgcGFydCBvZiB0aGUgVERYIG1v
ZHVsZSBBQkkgKHNlY3Rpb24gIlBoeXNpY2FsIFBhZ2UgU2l6ZSIsIFREWA0KbW9kdWxlIDEuMCBz
cGVjKS4gIERvIG5vdCBjaGFuZ2UgdGhlbS4iDQoNCkJ0dywgRGF2ZSBtZW50aW9uZWQgd2Ugc2hv
dWxkIG5vdCBwdXQgdGhlICJzZWN0aW9uIG51bWJlcnMiIHRvIHRoZSBjb21tZW50Og0KDQpodHRw
czovL2xvcmUua2VybmVsLm9yZy9sa21sLzJhMTg4NmU3LWZhNWQtOTllMi1iMWRhLTU1ZWQ3YzBk
MDI0YkBpbnRlbC5jb20vDQoNCkkgd2FzIHRyeWluZyB0byBmb2xsb3cuDQo=
