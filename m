Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0B65376035E
	for <lists+kvm@lfdr.de>; Tue, 25 Jul 2023 01:57:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230324AbjGXX5J (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 24 Jul 2023 19:57:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49046 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229452AbjGXX5I (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 24 Jul 2023 19:57:08 -0400
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3EFC9E8;
        Mon, 24 Jul 2023 16:57:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1690243027; x=1721779027;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=NAk4oeU+z4HRvh/7y/2c0O4feu3wYzzSqPDgpijhFXA=;
  b=aSoRznejrIMC297hEX2R7ulssR1jnTTHq43E1eXFjpEd4/pa08OSBXeX
   tlM+dFSqKPsUenxzPM3vx9c+vEcUK+pS0msIrA7DINQCPKxurqsh/BaSA
   kQES49KE/Nf4pKJsVvne1jZ1wo2mBc1Vf/4kszsIjvoVRu9kTYTKdE8TQ
   DQkq99xQ7AOFwED09teU3gVPBlE6GOVEhfde6oZGZRu1CTrig28dUUsvo
   2tgAlZKaJ5OhBiqdKm/vwDNjCP/IWN3pESXIpnc4Lzg6BeOAa1kzxbd/K
   922l7De1DZAxugM6pv/cXpzVz3QjdC6QXYyR5UDTB0wgZPmRxTjuwKzB9
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10781"; a="367604092"
X-IronPort-AV: E=Sophos;i="6.01,229,1684825200"; 
   d="scan'208";a="367604092"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Jul 2023 16:57:06 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10781"; a="972456037"
X-IronPort-AV: E=Sophos;i="6.01,229,1684825200"; 
   d="scan'208";a="972456037"
Received: from fmsmsx603.amr.corp.intel.com ([10.18.126.83])
  by fmsmga006.fm.intel.com with ESMTP; 24 Jul 2023 16:57:06 -0700
Received: from fmsmsx611.amr.corp.intel.com (10.18.126.91) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27; Mon, 24 Jul 2023 16:57:06 -0700
Received: from fmsmsx612.amr.corp.intel.com (10.18.126.92) by
 fmsmsx611.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27; Mon, 24 Jul 2023 16:57:06 -0700
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx612.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27 via Frontend Transport; Mon, 24 Jul 2023 16:57:06 -0700
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (104.47.55.104)
 by edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.27; Mon, 24 Jul 2023 16:57:06 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=W03ezlBs7VGwFvdIP29Jnu25U2WuFN8M5/6CoUT3AlCuE9Vc6YuY/duVbRsUu/NtUQqLaIKytfq2IKkkJrS4VxpJz8csNWBN2m38lT3/E9FfMoeQxK2SWvJ1Pl+3uxcuKYGKJNcQa62tKNf4ZrCJhOsauPsWFtouxINFhd4sVPY35EuoCZvcY7f2KhaG/5aU/9AOOygMyVEvXzZbRbxGghwXdzz8kQZCtLT88MVoTlVQOydMEBbEEX/+NXL+CxJEL8ONGFp6EFvJHdWmkhaWHO2vtEInQ6Jsp0taN7povlaIN284+Ihx/FSW+vNI7T2MtT8Hq1lR8vcxBhP3ptYihA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=NAk4oeU+z4HRvh/7y/2c0O4feu3wYzzSqPDgpijhFXA=;
 b=Ee8Q+xSu/awvSKm0B+qyO2uP2bWCokydk3JKeEq2dgG8gxOjDgkusbQX+1q767oLHwZNFZ/ITjxlegM8dNkDZ6wgH7zg37Nz01D4eTJd7BSHBjF+2IPzFYnUUyHNzMkgSRnXkRMv+nlUAdlgGayyVC4Kew2iN6WthSHApP+/Dj0CRkWP5hfM9wT9Bnxz962bTH6Z06X8xWCBaiZdtW+T8ThhKhAc6zm/s1GLs5DDXEd+cKi1VMWmq9IOXXW0QNFBYmuzMnyyqW/WMe+m93IfJDP1mNU7HnR+Bfrji4UKk4mj/Rfzb0u3sO3MRvuIxWPciXOfjjkbsE8t0Q3p66VSTA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5978.namprd11.prod.outlook.com (2603:10b6:208:385::18)
 by SN7PR11MB7439.namprd11.prod.outlook.com (2603:10b6:806:343::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6609.31; Mon, 24 Jul
 2023 23:57:03 +0000
Received: from BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::3729:308d:4f:81c8]) by BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::3729:308d:4f:81c8%3]) with mapi id 15.20.6609.032; Mon, 24 Jul 2023
 23:57:03 +0000
From:   "Huang, Kai" <kai.huang@intel.com>
To:     "tglx@linutronix.de" <tglx@linutronix.de>,
        "x86@kernel.org" <x86@kernel.org>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "Christopherson,, Sean" <seanjc@google.com>,
        "bp@alien8.de" <bp@alien8.de>,
        "dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>
CC:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Gao, Chao" <chao.gao@intel.com>,
        "andrew.cooper3@citrix.com" <andrew.cooper3@citrix.com>
Subject: Re: [PATCH v4 03/19] x86/reboot: KVM: Handle VMXOFF in KVM's reboot
 callback
Thread-Topic: [PATCH v4 03/19] x86/reboot: KVM: Handle VMXOFF in KVM's reboot
 callback
Thread-Index: AQHZvBClpYQHkEUCmUKT9J1PjOag/q/JnPEA
Date:   Mon, 24 Jul 2023 23:57:03 +0000
Message-ID: <10c6abab5143aaacf6783a71808e236bbbd13894.camel@intel.com>
References: <20230721201859.2307736-1-seanjc@google.com>
         <20230721201859.2307736-4-seanjc@google.com>
In-Reply-To: <20230721201859.2307736-4-seanjc@google.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.48.4 (3.48.4-1.fc38) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR11MB5978:EE_|SN7PR11MB7439:EE_
x-ms-office365-filtering-correlation-id: 759a336f-ca8f-4aa3-01dd-08db8ca1ad79
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: Wp+GbLA5O9HNh1IGbgw9hBrsFThHdI+d0YgUEfX5+VRZxu52aadzC/7V4EwxU1kC868Z7+r+SbbKw7REfZRoQJT0pBfnUahEF+o/p3x2EMzTNpbuQUk5Auc3cLDCsqMXmfpz9PtBm+4S62Uhv8G/qoWoFtIDQYEM1TgeDfsffIzY9iWo7ZCDVLc6YXWNp7wYgqtHW1D2SvBxNgP+ob4hSL5VfWldW7YZ9VoLZilU78bkWWgLRHedMPqQSn2k919XE93JNKf9wUkMOWlc0SfwdbP5kmjT2bB/45WfgmqbIvzecpkiXMGFAHeMMIPhVl/Ph/jGX0XPL/Di12aUzbHzCn0iJFFnROY7kL8Q//RqPzmL7/FQfiaICSYdiNdGADg441Sfr8jUPCURXvzblLN6CouQvHb35M4+qTpRo+vSQWilBIxdbczZv45nGSRK3ocx2CLoUzk3vubokOI9uuQqQUESQPGH5TsSqk/1Cs3FFjzy3JiSBvXCdf+Hxt2zyDfnCKaz2kwRikrwFum8qQzaa3xjkTMbm8tQ2PS6uhOn6OHnA85oqs4PenpAVrwywlOmifvoIPDXF4CNztAMNSxWWJz6+vCexfxAr9hVf1usYyDzxU6i/xN4nUrbFnXJBAMo
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5978.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(366004)(346002)(396003)(376002)(39860400002)(136003)(451199021)(82960400001)(86362001)(38100700002)(122000001)(71200400001)(6486002)(6512007)(4744005)(2906002)(2616005)(6506007)(66476007)(186003)(26005)(38070700005)(36756003)(110136005)(5660300002)(66556008)(41300700001)(76116006)(66946007)(91956017)(64756008)(66446008)(316002)(4326008)(478600001)(7416002)(8936002)(54906003)(8676002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?cDUydUNZNUZ2M2pEelhMbC9IYUJFYjhYVXplQlcvYzlBanpoSXJPbzJMM0hG?=
 =?utf-8?B?Z3BSQmE4TTl3K0JjUHRvSFk2S3dTdmhyYlNxcmR5QnNWakc3cCtxamtBUXFW?=
 =?utf-8?B?MEp4dnh0UmhzQXdnZ0FheG5JVjFTNGJLRFRSYVBKRU4yejlSTDJVRk9lRUxD?=
 =?utf-8?B?aU1mNW8yNHl1L2p2SitqeEhLMkJub0d4WWNGREtnK2hrd0EwbUZvSVNhUWxn?=
 =?utf-8?B?YWE3SGR3Q1ozZXZLY1Njd0pSb3dHczNlWll1UXBvdFAxZ3FpbzEyL2pnU3lD?=
 =?utf-8?B?OUtrODlMMEpRL3Uza1pKWS9jK0J2S0tPaE9DYysyNWNzL0JrSGMyeTFac1Rm?=
 =?utf-8?B?b2lSckhIS2JybVMvaWg0RnpDcE80VXdtSk9pNGtOcTloaVlSb3ZINnV5SlNt?=
 =?utf-8?B?N21RcVdabjVsU2REM2doZ0doNE41eDN2TWVQN1d2UElKekw0YmFxaEw0dHY4?=
 =?utf-8?B?N1NqdmFhdnhGQVZyeU05a3RtNk9zOGxSenoyU1YvcFpmRlVrazdEek1UclRU?=
 =?utf-8?B?dnFFOFo3NitzaXc1Uno5N0lxd0tVSDdIOTdjUUc3b1J3ZU92YlhqeDk1MUhz?=
 =?utf-8?B?eks5QVBRNDczZlpwSUtPTTRyUlN2MDhaUDRHWlN6cllFTEI5NmsrR3U1cmxO?=
 =?utf-8?B?ckFlNlljRStuRWJTa0FJdlNSc0tFVXRKWDIwcmJOOGhOb0lzU0tCcnpPenBP?=
 =?utf-8?B?alRjVDk1TWN4czVLQ3RRVGtRS0JvWXdxSEhPMkc0L0VSS2NPaUhEb1MrR1BI?=
 =?utf-8?B?c2dvNWRSZ25YazJucEorTzNZQThTcG9mTkIydTltOHlOYW15cEpYbUFxWVkr?=
 =?utf-8?B?dk5FQ2tPSEZtcjR6S29KdmdrYlRKelR4VHplQzJFRkpwd3RkY092WUJUSHV2?=
 =?utf-8?B?OUxzTzhMeEV3R3g1a2I3d2hJY0FsT0J0R0luNkk2T2JIT2tyUGlhMnNSZmgy?=
 =?utf-8?B?YzFiOVlKd2RoRjg3R2YwVHJpV1BmVXdSQzZsRWo2dVRnTysyQXZhVXZUcFk1?=
 =?utf-8?B?cElyemZwcC9TQ2RKeFRnQWZ6aEtxelZrS1czVk1HbVZTaHpUS2hROSt0SlNU?=
 =?utf-8?B?eHZtT2IvMXB1K0FZa283aXZmazBrcmtrRzZYbENaQWlZM3grYm0vUDREREt6?=
 =?utf-8?B?aGlZdWdQK2JramtQbldKTTFTZWUxS1F3QUZvaTBUck9jemJFL2VQajE1N3JF?=
 =?utf-8?B?Vk95YWdhQVNMWUNFSEpJcHBiUm5PZDBCNVovbDBpY2o1dlVwODhpWUpBRTc4?=
 =?utf-8?B?Ymlxby9HK3dVRlBqajNyZE90aUxrQ1dXeks2NG1MT2VKbnFzVnRrMkROVnNm?=
 =?utf-8?B?T2VpK1J1SVBhWVhEcjFiM3VHNDh6dzg4ZlQxQnFiZlE0RXFEeE5uYWwyK3VN?=
 =?utf-8?B?Y1B1TTdKMDBxbHNjVFZxM2xzdnA5Z3F3SGp2TStqN0ZHYlhxdDFyYWI3TTlN?=
 =?utf-8?B?T0RYTEhNYXZ6S1g5dUY0UjA0Nk1tZ1FSZnFtazVCQW1zOVp1R0VVZS8wSE1U?=
 =?utf-8?B?TVYyQkNJdEVIdnRjQWw3Z1ZPa0xFYVp4UGFzKytTMnBWODlxRlZTY2NWb3Bv?=
 =?utf-8?B?enVmVHE5dnhnVU9FZDlxTTdqWXYxSXd0QzAvaGxKQ0QwSTZJZUhZTElod1No?=
 =?utf-8?B?czVnVlNvUTZvTWdPQmdxSSs1dkNjaG0rWUU1WmcwS21ObGtZUHVTMlV4bzM2?=
 =?utf-8?B?R1VBNS9ZV21vR0NYRmFZTENxdHY2ZC9IdUliVFArM2t1U3NEUlRzaGVIRDNU?=
 =?utf-8?B?VHpuK0U3NWtLakV4OVZQd2RRcm1UazdzMmZYSE9RN3VQcGtQMXVmempDL0FJ?=
 =?utf-8?B?a3JMVnZnY1VDdnZ5Zkg2U0hDTFcwSm13V2E2cG1odURoYWdNRWJOazRETjBC?=
 =?utf-8?B?Z2t0ZWdZbEpTUGh6Wi8wb1hGVGhKOUhLTkdES1k4ZXlyaFNVV0ZHRUZTdGNp?=
 =?utf-8?B?WWduamdEdHczWFRUYkVPWGZEVkhXSzZzT0NxUTRnUDBES2RuUXV2ck5MRnFU?=
 =?utf-8?B?dzdSd0tXdmVkMVh4MGgwM0FBMDU2SFpWRjFhVklrTi9ybHpDdjlVTFoxekdO?=
 =?utf-8?B?UzNYekNpZnhSV3g2Z01VZWdTMllrS1NXMEl5Q1lxM3hUc0IvaDZLZS9SODJp?=
 =?utf-8?Q?vXCUrvWTK3vNU8RLqJWhimS6B?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <80F84D981880C04E81684B06D83BF91E@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5978.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 759a336f-ca8f-4aa3-01dd-08db8ca1ad79
X-MS-Exchange-CrossTenant-originalarrivaltime: 24 Jul 2023 23:57:03.0549
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: kt9pyR27Gv/jlqXr/Ii+7Afc6iUjewZusopYBU6BqnquXNVIXe0UKzzbzI4JxRO6xWeWwoxSvDyZ6m3vcE+6NQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR11MB7439
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

T24gRnJpLCAyMDIzLTA3LTIxIGF0IDEzOjE4IC0wNzAwLCBTZWFuIENocmlzdG9waGVyc29uIHdy
b3RlOg0KPiBVc2UgS1ZNIFZNWCdzIHJlYm9vdC9jcmFzaCBjYWxsYmFjayB0byBkbyBWTVhPRkYg
aW4gYW4gZW1lcmdlbmN5IGluc3RlYWQNCj4gb2YgbWFudWFsbHkgYW5kIGJsaW5kbHkgZG9pbmcg
Vk1YT0ZGLiAgVGhlcmUncyBubyBuZWVkIHRvIGF0dGVtcHQgVk1YT0ZGDQo+IGlmIGEgaHlwZXJ2
aXNvciwgaS5lLiBLVk0sIGlzbid0IGxvYWRlZC9hY3RpdmUsIGkuZS4gaWYgdGhlIENQVSBjYW4n
dA0KPiBwb3NzaWJseSBiZSBwb3N0LVZNWE9OLg0KPiANCj4gU2lnbmVkLW9mZi1ieTogU2VhbiBD
aHJpc3RvcGhlcnNvbiA8c2VhbmpjQGdvb2dsZS5jb20+DQo+IA0KDQpSZXZpZXdlZC1ieTogS2Fp
IEh1YW5nIDxrYWkuaHVhbmdAaW50ZWwuY29tPg0KDQo=
