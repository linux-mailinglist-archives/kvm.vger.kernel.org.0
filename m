Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D0A965BCD7D
	for <lists+kvm@lfdr.de>; Mon, 19 Sep 2022 15:46:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230217AbiISNqj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 19 Sep 2022 09:46:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55584 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229626AbiISNqh (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 19 Sep 2022 09:46:37 -0400
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 07573303C6;
        Mon, 19 Sep 2022 06:46:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1663595180; x=1695131180;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=qxyZ0b8ZWOtP1L0Ng6ziUcbJGxsENAMfcPoVyTseDjA=;
  b=jlZinuXtHLGXFTh+FsU6z+4GDiu5Iur1eRDPTg4s6jos8UfxRnPBtA5g
   0RQDCbwgGmIUhDUVVcYpn2Jff91J3Hcof8ZqujUHTmOeUtFaxQbQ7cpHs
   Kuy44CVS5yMWnRRJWaS/VW0QFBfi6Aqg4Ax3GQev15mndH6wefd5b81cc
   oTSb7DwhNrt4bBIfMiY7/WPKxsiWYhQG1/NdLLH9kHbwDIlR+/rje1gA0
   pOTLKYsHNLo2PW0YtqYznGFTA+6kcl3Dmv6e9sihd8xNckJphjsgepJgD
   X7oQD1KnC2yI9ST684chAUaRsEgqpkbT6vEEatpMQBvUX9QFPHLdtA9nP
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10475"; a="298129303"
X-IronPort-AV: E=Sophos;i="5.93,327,1654585200"; 
   d="scan'208";a="298129303"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Sep 2022 06:46:19 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.93,327,1654585200"; 
   d="scan'208";a="614001857"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by orsmga007.jf.intel.com with ESMTP; 19 Sep 2022 06:46:19 -0700
Received: from orsmsx612.amr.corp.intel.com (10.22.229.25) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Mon, 19 Sep 2022 06:46:19 -0700
Received: from orsmsx608.amr.corp.intel.com (10.22.229.21) by
 ORSMSX612.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Mon, 19 Sep 2022 06:46:16 -0700
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx608.amr.corp.intel.com (10.22.229.21) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31 via Frontend Transport; Mon, 19 Sep 2022 06:46:16 -0700
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (104.47.58.168)
 by edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2375.31; Mon, 19 Sep 2022 06:46:16 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=RWVx5P1Gfe/gCJbN2i1GY8q1tMaUZ2y0V9PwgnkBsA4NwuLCJIhFxL4MqhHCadVjsGtGKanKVW7b8gInMEvpn6/5AUlGCNGEG0fnhgxAWb5nHOcK/duBPM0QC5agEKze5sP/dkIWhn/tPPd6cMbbj8wLZ4et7zeqE+dhL6vHkqOl5oUGP038w5Wv2oX344n+MDt/205IAIyECgEF/xhlOOSZ8p783zAr3/pKl/jadz9pCUXrK0kTWeYNaXz/axHDQNST18vwoXQ0dt4rXMpEYZyBFWBcWzJuCjS7UOV+wfN59dRSpC+9JElqDq0hV08cYcJfl8CTBHliD9WsAxnaKQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=qxyZ0b8ZWOtP1L0Ng6ziUcbJGxsENAMfcPoVyTseDjA=;
 b=lRBWlMVNVgzcANnRxrbxvwhRXhEAWuZpSTYZjvjKeOSpZWPxjlzMmhBKMS/GlpR6dQAnhWSjQeDDtbULpYB7Ihtry5S9h18IqhNmvmJ0HMEv7Xyw8oFnmvGlUifMTqPn8aCoczJx+S7E37F3dF1h6HTeLlJ7PVg95FDRjJ/I5FdtR2+LKi5YrABxLsjnIyPjtvvv0HYvt44gVSwmZMxY/6X2a9gLczekY0WJJ0amLpxadDEr9lfxa27sDehixkJ2BgULVAvvCu6JEvVOJvOpMobRV7BZIlkfS6sFI09+tRdLOYEDDFxjXPPf817NaRG0UyfVc42oh1T0Kbtw6VwguA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from DS0PR11MB6373.namprd11.prod.outlook.com (2603:10b6:8:cb::20) by
 MN2PR11MB4741.namprd11.prod.outlook.com (2603:10b6:208:26a::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5632.21; Mon, 19 Sep
 2022 13:46:09 +0000
Received: from DS0PR11MB6373.namprd11.prod.outlook.com
 ([fe80::817a:fd68:f270:1ea0]) by DS0PR11MB6373.namprd11.prod.outlook.com
 ([fe80::817a:fd68:f270:1ea0%7]) with mapi id 15.20.5632.018; Mon, 19 Sep 2022
 13:46:09 +0000
From:   "Wang, Wei W" <wei.w.wang@intel.com>
To:     "Liang, Kan" <kan.liang@linux.intel.com>,
        "Li, Xiaoyao" <xiaoyao.li@intel.com>,
        Peter Zijlstra <peterz@infradead.org>,
        "Arnaldo Carvalho de Melo" <acme@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Jiri Olsa <jolsa@kernel.org>,
        Namhyung Kim <namhyung@kernel.org>,
        "Christopherson,, Sean" <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        "Liang, Kan" <kan.liang@intel.com>,
        "Kleen, Andi" <andi.kleen@intel.com>
CC:     "linux-perf-users@vger.kernel.org" <linux-perf-users@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>
Subject: RE: [RFC PATCH 0/2] KVM: VMX: Fix VM entry failure on
 PT_MODE_HOST_GUEST while host is using PT
Thread-Topic: [RFC PATCH 0/2] KVM: VMX: Fix VM entry failure on
 PT_MODE_HOST_GUEST while host is using PT
Thread-Index: AQHYuGCfKwYxaXR4306din/WULaC4K3Fff5wgBjymACAABFugIAA/X4AgABj1pCAAMFbAIAABJpggAAZlICAAKvIEIAAwJ6AgAPziBA=
Date:   Mon, 19 Sep 2022 13:46:08 +0000
Message-ID: <DS0PR11MB63739F4DA17F30B3162837B9DC4D9@DS0PR11MB6373.namprd11.prod.outlook.com>
References: <20220825085625.867763-1-xiaoyao.li@intel.com>
 <CY5PR11MB6365897E8E6D0B590A298FA0DC769@CY5PR11MB6365.namprd11.prod.outlook.com>
 <815586ac-1eaa-5e38-1e08-492c29d0729d@intel.com>
 <CY5PR11MB63659EBEAEA0E64812E96111DC469@CY5PR11MB6365.namprd11.prod.outlook.com>
 <f7cfb391-c38b-84d2-b2fe-5e289d82862c@linux.intel.com>
 <CY5PR11MB6365676799EBF86B3931D336DC499@CY5PR11MB6365.namprd11.prod.outlook.com>
 <ef391316-cde5-3cda-ff0d-980e8ecc9aef@linux.intel.com>
 <CY5PR11MB636535BE57F8CC07B1B2770DDC499@CY5PR11MB6365.namprd11.prod.outlook.com>
 <4c6a5663-778e-a509-638c-92cfd5315274@linux.intel.com>
 <CY5PR11MB6365EE3B1C4BCED02A1E40D8DC489@CY5PR11MB6365.namprd11.prod.outlook.com>
 <da8fe1d8-8cce-7378-18e8-41fd7009ff8d@linux.intel.com>
In-Reply-To: <da8fe1d8-8cce-7378-18e8-41fd7009ff8d@linux.intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-product: dlpe-windows
dlp-reaction: no-action
dlp-version: 11.6.500.17
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DS0PR11MB6373:EE_|MN2PR11MB4741:EE_
x-ms-office365-filtering-correlation-id: baa89b0a-6756-4a80-6ac7-08da9a454eaa
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 4oF2oLQr0WYeGBuq9R2ehLZwMkE+5dGqX+0zi/pkslCEmT6hoepN5Y8bEqhLfQu2+r9Karnc4D2JZBHw0bRZDDNNOxGXyxqQnxFsaVW83CAUlblYu3dtbt5lGHHEnNoI6jf+OhsyEWddhz36A2OK+1EFd6rxDrKd58cXXjsJYjL57a08Rf/v3qOrkZVtzoHsdxAd6tL34zs1IDDObiwi+hAboE7xl4QYD7Hr2vVfea1z4/gRMZGtWowlEdVoc16BqHoUhHDIt53Z0LdQCGqymfaLtpbxyFyWf65KW7iJR/OUL4Xg8DlTqjJsdXQaSyissKB0IYkjSuC9k4E9ZKK9G23wxoZbagV6Vo3wrjf5uFCSOtzIkRsLsk8+Y7rgfwgOdtYeIEBcRG+PAa0LOOh72+Ex+FEzWMGgdIs0hIM7qWJCnMyLsvzz7y/hX4QfsXqX7+ebHscy9pDUGHwl6eYTf55mdXn5zT75Hyxmoj44SAvU+VBmRMjxDa2TVgOKP5o8uJPIgn3uqXxWMzjBAA0gCacg/27WotZTkj6F2b3FD2FW6jUdB3kGEbVg2j3IYZfHqTT3scQv44rkxUD3YhM0qBKoYnSrl0ehy/lajHaKDUgO4aag/mYNhSAyIqnegDQ/xkhHAIpRJYyKNUfQh4llwTMXJ1XUoJBmnCN3itpuo9sGMQAO8O/n1fu6Lqllpk5HNuA+jmqRCBnfud7VDQ7nXKxBJXOU113+hFqvAT/Ly3bOff4Ju7Oq5Pj5Lz2q5AmSn4uRQOTOKrSa2pIxLgRlJA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR11MB6373.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(39860400002)(376002)(346002)(136003)(396003)(366004)(451199015)(110136005)(7416002)(83380400001)(54906003)(5660300002)(6636002)(52536014)(316002)(186003)(53546011)(26005)(55016003)(8936002)(86362001)(38100700002)(76116006)(9686003)(4326008)(6506007)(38070700005)(2906002)(921005)(7696005)(66446008)(71200400001)(478600001)(82960400001)(64756008)(66476007)(33656002)(66556008)(8676002)(66946007)(122000001)(41300700001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?cytDaEI4VldPd0lNUHhqak5GdUF3NHB5RnNvVHh4Y0JZSjJiTVZZcU16RVE5?=
 =?utf-8?B?SDdkTGpEUlpqeHk1NVpaYW43aHg4bkVUaURUQUVXbTFSSXVJUlRaL0ZIa2hW?=
 =?utf-8?B?QXl5UVFIMTMwdFRiWWw3RW1uTGhhOFJZdlJyNmxOL0hjNWwzd0x3YzNIZVlz?=
 =?utf-8?B?R3lBaGZwQzZsMW1tbmpPallDNmVkQUNpYmhrdVdnQUU2OTBoZVp3M2FRTnM3?=
 =?utf-8?B?eDcvc0pVUDJNSXE0cGdwVUtzWExVQzdOZlNoYkhua1NIb3F5V3lINWFGOWM0?=
 =?utf-8?B?VnJkWkk1UzNuVUYzMS9GMDZ2QmUyUTNGdENjMGthMDR1U2JuSDZzOFc5VnRk?=
 =?utf-8?B?Nk9uSUE0MlBoQTNKZU1WcldPbU05cjN5NS8wMk96VkpBNWViNGN1L21vY0Rq?=
 =?utf-8?B?VC9iU0R6VXhBa0ZtOXcyQzBsWFFJSjMxdlhTQk9oNnZLQXFPb2ViNXJzQ0k1?=
 =?utf-8?B?eHV4VUp1SU52WWpHbjJ6NHN1eC9GWlFOeGhmc1R5NkJxamJ4ejF2Zk1TMlpH?=
 =?utf-8?B?NWE2SXRWMkg1c0hGTzV3aE92bWhBYThNM3ROOUlwSkF1QWp2TlJLTDhtVFIy?=
 =?utf-8?B?dGU0VzBGTnpCa2NWbkJpb1pjRFpxRWE5cUZFSU94WUNnUzZ3QXJETFQrdXNJ?=
 =?utf-8?B?RzMxYzhua3ZQSnJycVp1eDZJYWJlcUZ4bm1ZcDMzZ1c1V0VoczA5YXZrRTBB?=
 =?utf-8?B?NkRPZlhkRFRCWVZZVHB5bnFJY05Pb01EWkVXL1BCc2dMOWhXelV5MnF4cHRJ?=
 =?utf-8?B?bmpDVXIrSm5YSCt4YkdMWFpGTVVoSUM3N2FGdWZzeXMrRUIvZXNvSlNYWWVi?=
 =?utf-8?B?K3p2V2JTL25GZVVmeGVEbjc3TkpXTGdpdkZkMHV0ZFJhSUo1S0xBNFJPaUJ2?=
 =?utf-8?B?ZkRUT0kzcWdTK1dRb0svOXFxZko0QVBEWERPT0JKMFdRRFFFdjI4K0hlS3hL?=
 =?utf-8?B?NUx0TlhqYXRzZHpOeFJGdHlGeG9Qem8vWkhOMFg3Vyt6bXFwOThzNkM1SDlW?=
 =?utf-8?B?M1p5VHBtQ2JzWDRCdi8rWmxLTVdoSnF5clRlV2xUT2xTQnFFQU83b0hRYzRj?=
 =?utf-8?B?dWZJNFdxK29OdDl6RC9WSWJhaytmOHRvbXpWb0Jwa1ZHSHNUL3FuRndnM2xo?=
 =?utf-8?B?QmRNd3EwZ0xUcVY3M2c2QllaNlRjTXBsZmV1Z2Y4VnNZcGIxQjB1T0JCdXNm?=
 =?utf-8?B?Q0ZPcVgxVnBxWlFEWExlY3V5ZGVZMTdkaEZKbSs1YktBa1JUNVlRS1paclFh?=
 =?utf-8?B?SVRvWXlER1VQd2xsVnRYbFJZcllQejVnREZEN3BKL2RGTGxldHpEVGxFcVJR?=
 =?utf-8?B?a3NkS2oxQmtxU3VQaDZSTGpLU0xlem8zSkVCK3JiTnpXMmRvZ1puWFc0OUdQ?=
 =?utf-8?B?Um9KMlM3SkdtSExoRGh3TDM5ME54TnR1cjBDZUZCbkFVcUtFdkFDVCt0K2Nn?=
 =?utf-8?B?YVAybXFvaFpFQVZ4eDl3NXFVWWJUTDYvQUYwaFFCOGZvNkkzWG5rT3dURTdu?=
 =?utf-8?B?VkRVL1lVY1NEeW1HUkwyRkozQWFjT21yUXpsdGkrNlFRUE53R05vMFAxc01r?=
 =?utf-8?B?bC9DU2FwOVFWYS9JVVJmYVdmbWQwZjgrb0ZiQ0lZTnJXbHZHRWRmQWpMOTJk?=
 =?utf-8?B?bUV3cDlwenVwL05icUFEY0JhRFo5YVR5Nkw2SGZGOC82UjgwblY4bk9qVlF6?=
 =?utf-8?B?UXVMMHA1MGxrTHVRei9EWTRrOXhsalppOGZqRG1TNlhHYjM4TGh6VXNHdFRK?=
 =?utf-8?B?TVR6YlltbHVwZ1ovQVd1TENSVnluSTFxeHQrWXhTRzFZdEF6K3FKY3pYa2Ux?=
 =?utf-8?B?ajZYdFpiSnloWHFzQU9xMkhJRVFaSmJScEdjcmlHMWlMZW9XV2dqdmtHMzFL?=
 =?utf-8?B?ZHAwU3NDbDhpemp2MHNTdHJoZDAyZVlCWHVwR2VvazZOM2NJdmRmMklxNEpD?=
 =?utf-8?B?d09odnYvOC9JcThvZ3oyMGZqVGc1UllwTkVzeDFGamJETm0veHgxa2lHaWht?=
 =?utf-8?B?aGR6MnhxOXExWUM1ckN4aHhtMHZ5WDJSRXBYZnZONUZHUm9qNTdHSGViUU1U?=
 =?utf-8?B?SEVkbkFWdzJKa0ZkNzhVaVJnYW14NWQrK0F3N2I0cnYzS0FSbFY4UkhqdSs4?=
 =?utf-8?Q?Jji3LC5lSsV8SC9FepIDfQ6zP?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DS0PR11MB6373.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: baa89b0a-6756-4a80-6ac7-08da9a454eaa
X-MS-Exchange-CrossTenant-originalarrivaltime: 19 Sep 2022 13:46:08.9402
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: OMTxJmixih6WXb3gk6Bd379uSWgBQN4ej5rPHUY9P5rYd52taMGlM0s/J+fNyK+EBRhpad9ZIewpMkCtMlzj3w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR11MB4741
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

T24gRnJpZGF5LCBTZXB0ZW1iZXIgMTYsIDIwMjIgOToyNyBQTSwgTGlhbmcsIEthbiB3cm90ZToN
Cj4gPiBEaWQgeW91IG1lYW4gdG8gaGFuZGxlIHRoZSBQVCBldmVudCBpbiB0aGUgcHJvcG9zZWQg
ZHJpdmVyIEFQST8gRXZlbnQNCj4gPiBzdGF0dXMgaXMganVzdCBvbmUgb2YgdGhlIHRoaW5ncy4g
VGhlcmUgYXJlIG90aGVyIHRoaW5ncyBpZiB3ZSB3YW50IHRvDQo+ID4gbWFrZSBpdCBjb21wbGV0
ZSBmb3IgdGhpcywgZS5nLiBldmVudC0+b25jcHUgPSAtMSwgYW5kIGV2ZW50dWFsbHkgc2VlbXMg
d2Ugd2lsbA0KPiByZS1pbXBsZW1lbnQgcGVyZl9ldmVudF9kaXNhYmxlXyouDQo+ID4NCj4gDQo+
IEFzIG15IHVuZGVyc3RhbmQsIHBlcmYgYWx3YXlzIGNoZWNrIHRoZSBzdGF0dXMgZmlyc3QuIElm
IGl0J3MgYSBzdG9wcGVkIG9yDQo+IGluYWN0aXZhdGVkIGV2ZW50LCBJIGRvbid0IHRoaW5rIGV2
ZW50LT5vbmNwdSB3aWxsIGJlIHRvdWNoZWQuIFRoYXQncyB3aHkgSSB0aGluaw0KPiB0aGUgcHJv
cG9zZWQgZHJpdmVyIEFQSSBzaG91bGQgYmUgYWNjZXB0YWJsZS4NCg0KVGhhdCdzIHRoZSBpbXBs
ZW1lbnRhdGlvbiB0aGluZy4gV2UgbmVlZCB0byBtYWtlIGl0IGFyY2hpdGVjdHVyYWxseSBjbGVh
biB0aG91Z2guDQoNCj4gDQo+ID4gQnR3LCBYaWFveWFvIGhhcyBtYWRlIGl0IHdvcmsgd2l0aCBw
ZXJmX2V2ZW50X2Rpc2FibGVfbG9jYWwsIGFuZCBkb27igJl0IGhhdmUNCj4gdGhhdCBtYW55IGNo
YW5nZXMuDQo+ID4gSWYgbmVjZXNzYXJ5LCB3ZSBjYW4gcG9zdCB0aGUgMm5kIHZlcnNpb24gb3V0
IHRvIGRvdWJsZSBjaGVjay4NCj4gPg0KPiANCj4gSSdtIG5vdCB3b3JyeSBhYm91dCB3aGljaCB3
YXlzIChlaXRoZXIgcGVyZl9ldmVudF9kaXNhYmxlX2xvY2FsKCkgb3IgdGhlDQo+IHByb3Bvc2Vk
IFBUIGRyaXZlciBBUEkpIGFyZSBjaG9zZW4gdG8gc3RvcCB0aGUgUFQuIElmIHRoZSBleGlzdGlu
ZyBwZXJmX2V2ZW50DQo+IGludGVyZmFjZXMgY2FuIG1lZXQgeW91ciByZXF1aXJlbWVudCwgdGhh
dCdzIHBlcmZlY3QuDQo+IA0KPiBNeSByZWFsIGNvbmNlcm4gaXMgdGhlIHB0X3NhdmVfbXNyKCkv
cHRfbG9hZF9tc3IoKS4gSSBkb24ndCB0aGluayBpdCdzIGEgam9iIGZvcg0KPiBLVk0uIFNlZSBh
dG9taWNfc3dpdGNoX3BlcmZfbXNycygpLiBJdCBpcyB0aGUgcGVyZiBjb3JlIGRyaXZlciByYXRo
ZXIgdGhhbiBLVk0NCj4gdGhhdCB0ZWxscyB3aGljaCBNU1JzIHNob3VsZCBiZSBzYXZlZC9yZXN0
b3JlZCBpbiBWTUNTLg0KPiBXZSBzaG91bGQgZG8gdGhlIHNhbWUgdGhpbmcgZm9yIFBULiAoQWN0
dWFsbHksIEkgdGhpbmsgd2UgYWxyZWFkeSBlbmNvdW50ZXINCj4gaXNzdWVzIHdpdGggdGhlIGN1
cnJlbnQgS1ZNLWRvbWluYXRlZCBtZXRob2QuIEtWTSBzYXZlcy9yZXN0b3Jlcw0KPiB1bm5lY2Vz
c2FyeSBNU1JzLiBSaWdodD8pDQo+DQoNClJpZ2h0LiBJdCdzIG9uIG15IHBsYW4gdG8gaW1wcm92
ZSB0aGUgY3VycmVudCBQVCB2aXJ0dWFsaXphdGlvbiwgYW5kDQpwbGFuZWQgdG8gYmUgdGhlIG5l
eHQgc3RlcCBhZnRlciB0aGlzIGZpeC4gVGhlIGdlbmVyYWwgcnVsZSBpcyB0aGUgc2FtZTogbWFr
ZSBLVk0gYSB1c2VyDQpvZiBwZXJmLCB0aGF0IGlzLCB3ZSBsZWF2ZSB0aG9zZSBzYXZlL3Jlc3Rv
cmUgd29yayB0byBiZSBjb21wbGV0ZWx5IGRvbmUgYnkgdGhlDQpwZXJmIChkcml2ZXIpIHNpZGUs
IHNvIHdlIHdpbGwgZXZlbnR1YWxseSByZW1vdmUgdGhlIEtWTSBzaWRlIHB0X3NhdmUvbG9hZF9t
c3IuDQpUbyBiZSBtb3JlIHByZWNpc2UsIGl0IHdpbGwgd29yayBhcyBiZWxvdzoNCi0gd2Ugd2ls
bCBjcmVhdGUgYSBndWVzdCBldmVudCwgbGlrZSB3aGF0IHdlIGRpZCBmb3IgbGJyIHZpcnR1YWxp
emF0aW9uDQotIG9uIFZNRW50ZXI6DQogIC0tIHBlcmZfZGlzYWJsZV9ldmVudF9sb2NhbChob3N0
X2V2ZW50KTsNCiAgLS0gcGVyZl9lbmFibGVfZXZlbnRfbG9jYWwoZ3Vlc3RfZXZlbnQpOw0KLSBv
biBWTUV4aXQ6DQogIC0tIHBlcmZfZGlzYWJsZV9ldmVudF9sb2NhbChndWVzdF9ldmVudCk7DQog
IC0tIHBlcmZfZW5hYmxlX2V2ZW50X2xvY2FsKGhvc3RfZXZlbnQpOw0KDQo+IFRvIGRvIHNvLCBJ
IHRoaW5rIHRoZXJlIG1heSBiZSB0d28gd2F5cy4NCj4gLSBTaW5jZSBNU1JzIGhhdmUgdG8gYmUg
c3dpdGNoZWQgZm9yIGJvdGggUFQgYW5kIGNvcmUgZHJpdmVycywgaXQgc291bmRzDQo+IHJlYXNv
bmFibGUgdG8gcHJvdmlkZSBhIG5ldyBnZW5lcmljIGludGVyZmFjZSBpbiB0aGUgcGVyZl9ldmVu
dC4gVGhlIG5ldw0KPiBpbnRlcmZhY2UgaXMgdG8gdGVsbCBLVk0gd2hpY2ggTVNScyBzaG91bGQg
YmUgc2F2ZWQvcmVzdG9yZWQuIFRoZW4gS1ZNIGNhbg0KPiBkZWNpZGUgdG8gc2F2ZS9yZXN0b3Jl
IHZpYSBWTUNTIG9yIGRpcmVjdCBNU1IgYWNjZXNzLiBJIHN1c3BlY3QgdGhpcyB3YXkNCj4gcmVx
dWlyZXMgYmlnIGNoYW5nZSwgYnV0IGl0IHdpbGwgYmVuZWZpdCBhbGwgdGhlIGRyaXZlcnMgd2hp
Y2ggaGF2ZSBzaW1pbGFyDQo+IHJlcXVpcmVtZW50cy4NCj4gLSBUaGUgcHJvcG9zZWQgZHJpdmVy
IEFQSS4gVGhlIE1TUnMgYXJlIHNhdmVkL3Jlc3RvcmVkIGluIHRoZSBQVCBkcml2ZXIuDQoNCkFz
IHNob3duIGFib3ZlLCBubyBuZWVkIGZvciB0aG9zZS4gV2UgY2FuIGNvbXBsZXRlbHkgcmV1c2Ug
dGhlDQpwZXJmIHNpZGUgc2F2ZS9yZXN0b3JlLg0KDQpUaGFua3MsDQpXZWkNCg==
