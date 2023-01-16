Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 12A4766B6BA
	for <lists+kvm@lfdr.de>; Mon, 16 Jan 2023 05:45:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231864AbjAPEpc (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 15 Jan 2023 23:45:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60012 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231935AbjAPEpH (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 15 Jan 2023 23:45:07 -0500
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E4A6A9EC7;
        Sun, 15 Jan 2023 20:45:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1673844306; x=1705380306;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=Cnr6orN5ATxm18/sDKJwCXVqqs+xy/hh5ppSoIoKEDc=;
  b=i7dwN5F3ND6wY9uvJCC4kwM6Xu1SFTF2qlu1LYR3cdedURJJ6lwdlTWT
   xyW6jQ8hsAKJXLv67cPU7cD52r15F88IGWig5pDizRF7oDurvOqZ/5pn2
   yaix24e8VMRrnbQLjRIRGKziTrfJgcuXZcr5nPk+v48KbJzEZ2/4RWcvq
   KGMsrI7kF+KZH35MXPqt7Um+CLe73k5cDNJsxc6jUo2PJ5m3fPRQfd8A/
   HxQQZ050n4YFo++J6chuFFuSyXxjwqjgGYEqb1ZiOX/OTSeRY26gpEaey
   feBEcSmc4gClBS8WOLAWYika24zsUIDIOqVYaOXuUaXaqLdrWnef0Xtzf
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10591"; a="351627824"
X-IronPort-AV: E=Sophos;i="5.97,219,1669104000"; 
   d="scan'208";a="351627824"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Jan 2023 20:44:26 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10591"; a="689363810"
X-IronPort-AV: E=Sophos;i="5.97,219,1669104000"; 
   d="scan'208";a="689363810"
Received: from fmsmsx603.amr.corp.intel.com ([10.18.126.83])
  by orsmga008.jf.intel.com with ESMTP; 15 Jan 2023 20:44:25 -0800
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Sun, 15 Jan 2023 20:44:25 -0800
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Sun, 15 Jan 2023 20:44:24 -0800
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Sun, 15 Jan 2023 20:44:24 -0800
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (104.47.57.176)
 by edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Sun, 15 Jan 2023 20:44:24 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=nyxjq59+l3FfHHBcF5As7adx2zr8e6QiyOFvhcXhQktproT8J2Iihm2zI3be6AgeGACWA5g2ROCzkGvnT6YSBodVjf6l+xKRKrAvxWCOK4VwD7eaUgtkSUAxDku/CthWplcH3i4jvrvJT+qiH+mmQirOdmUkAZSpn0/R0cU9cb2SF1Kt5u0voRX4PVLFPhb0d7cASvz4Lxszs/3tG3em8VFMlKepM0l9ZVSMZs9voVcKEWX6sHiInFpA87fIAHT1MsmcR2dk5nwiQJHIvZx02ZPR+ykDJlQy0YCfhmjbKJI/G0RI/vVv59qGoPqCEvG+08b1Xmwmy26pWwx85PoSSg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Cnr6orN5ATxm18/sDKJwCXVqqs+xy/hh5ppSoIoKEDc=;
 b=bu2URrMneUQdR2TufU4UXxvJFdf+qlJkSL6srGDM2Vjqaywv2TtQyVO28W6zHYbQ94r0959T5eE/FzRifQPCbqsxek/K6yxjqRCoc+E1DKW4r2KlJmIo3NibMD4b2jEkb+a1cNVkKp+T6T7NGm96QTltFT7U1mKjiClwKFGFyKFB+hhbhulvEITxeUPFcJgIH3LqzNt7GxlUZo11WOCPnDw7foWqhZpB/pT5wjBqnqYs0TcjdnPqQB/uYPz1BR4c+900HXHJJIXBO6Hz6cLr296cf8xp7RQ4+dAXFxXAwZ2rflFt8DfnQvTcJOvQq2mCdcioqkbTGRMtvfGUz2Qddg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5978.namprd11.prod.outlook.com (2603:10b6:208:385::18)
 by DS7PR11MB7907.namprd11.prod.outlook.com (2603:10b6:8:ec::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5986.19; Mon, 16 Jan
 2023 04:44:22 +0000
Received: from BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::3f19:b226:ebf1:b04a]) by BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::3f19:b226:ebf1:b04a%6]) with mapi id 15.20.5986.019; Mon, 16 Jan 2023
 04:44:21 +0000
From:   "Huang, Kai" <kai.huang@intel.com>
To:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Yamahata, Isaku" <isaku.yamahata@intel.com>
CC:     "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "Shahar, Sagi" <sagis@google.com>,
        "Aktas, Erdem" <erdemaktas@google.com>,
        "isaku.yamahata@gmail.com" <isaku.yamahata@gmail.com>,
        "dmatlack@google.com" <dmatlack@google.com>,
        "Christopherson,, Sean" <seanjc@google.com>
Subject: Re: [PATCH v11 017/113] KVM: Support KVM_CAP_MAX_VCPUS for
 KVM_ENABLE_CAP
Thread-Topic: [PATCH v11 017/113] KVM: Support KVM_CAP_MAX_VCPUS for
 KVM_ENABLE_CAP
Thread-Index: AQHZJqToZY0zv6U9WUWWlCjhFfl4aa6gfRqA
Date:   Mon, 16 Jan 2023 04:44:21 +0000
Message-ID: <5f9870acec07c47de5bab460c8c0d4a2c0db08fc.camel@intel.com>
References: <cover.1673539699.git.isaku.yamahata@intel.com>
         <01e061779b88ce4d32bbe483ed2bd3224cd8e330.1673539699.git.isaku.yamahata@intel.com>
In-Reply-To: <01e061779b88ce4d32bbe483ed2bd3224cd8e330.1673539699.git.isaku.yamahata@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.46.3 (3.46.3-1.fc37) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR11MB5978:EE_|DS7PR11MB7907:EE_
x-ms-office365-filtering-correlation-id: 3bfdc13f-7b17-4f66-876c-08daf77c55e6
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: ZwjZiH2DWmZ6Dw0QSIqJnXZ+JInHk78VfVE0b29p0n3dOAxm5gtGRxQWOL7LSrdJuJiKPmqH7JmRA4l9ST3JpK3m6Zv2gNkNZa5oBzrYFFctITdTwpIIGS5SlsfuPY9E9YorDxdeq3czxLfh9DZ+AtmBTXXsvZ4NyfE+A/VOTX6MSQU8fQRxV9n3IKdMeTOmqzD46EBoVRhpugx73UEqV0m/AEia8qyE04OJNNZ1QRj31MAyXFAiNJBalM7+uHP30xe43V+GmcNxXx+a3EC5AuYDn0GDlurhkhJCcSsj8EGA5A+cwZCmGBMxQEoN26LxaW/2vXq71emSub/ILwZt/MBMpU8FRCZfPzmqVOQ+oROvOP3F9ICkv/BZbpVrHgftDfX2oNS4oEJPshgfi7m8lc67khpxo4Q8ytx1ktViPySuGY25P47UAf9Dbr0pJdd7Pug8DbPUQMNncVdKtpqhrM8WE9OaNwCRPgIN7udg4d9uHlRRMVy7cwZImeN2Jf4MDah40yv2InD6fmioVCFeA8BxZsHY9gUunVn9kN4KodjVaWhOn+w9Xb5djkOpVAE579TTtqqslaeoUpfSqOYkofYCF+kIjQJ+nbTuEwfF2cDwa0Xjb2TrLolAITbmQ1bcdv/eLiBM4mNyzNKoNnA+2Ts0IAYgiop3JR3XBPuB5MIbu2uadst8QfYqjFETIt3bapUEpvh4LD4rkyyg3snDyw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5978.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(376002)(346002)(39860400002)(366004)(396003)(136003)(451199015)(82960400001)(38070700005)(38100700002)(8936002)(122000001)(5660300002)(478600001)(6486002)(86362001)(41300700001)(8676002)(36756003)(66446008)(316002)(64756008)(66476007)(66946007)(76116006)(4326008)(66556008)(91956017)(83380400001)(54906003)(6636002)(2906002)(2616005)(110136005)(71200400001)(6506007)(26005)(6512007)(186003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?U2VlTHZaeU5CdXkremRtSVZLeUt2ZEhoYy90SGFNV2I5WkJnMUxza2NwYmE2?=
 =?utf-8?B?WHRzWURVNGdjMUJQbjVVanA1R3UyUmNLN0NMeHVhR0M0N2l5RzVndUlNVUYy?=
 =?utf-8?B?aFdrU0p2cncyV0JwZ0NOd0MvMDBxc0I1ZWt5YU95V3FHcjRPL2pZcXAzNERM?=
 =?utf-8?B?eHJteGw1dWpvSHB2WmN0a0lNODFaZEhtQXJiRDN0MHdlS3dwMmZaS2hhcVdt?=
 =?utf-8?B?WFRYaU92dE5hbWQ0VTd0SDgrNE1RQkttTXF4aVV2WW1VWWVveHZaS0I1OGxC?=
 =?utf-8?B?OWNaRnoxTHBadXdFUVJrSHBYVjNsS2RveUFIQjBWSHl3T3ErNmFaMHl5TUxU?=
 =?utf-8?B?VVQrNWRSQkRrNVdnMFdBVHY3UDlQRUxtdlg1RG9FbUNPaUNvb3FZRmcxV2xy?=
 =?utf-8?B?Wmx1eERHUGJOYXFjd20xZkt5ZUtUelVlVHJubEJBUUY1TUFwWDc4Y1h6MVUv?=
 =?utf-8?B?b1d2ekx5SEdBNFpCYkhnYUJOWG1ycWhRUEZkRjVCYVZJSWNnczFJeDhHSkpI?=
 =?utf-8?B?SjZlRzFPU3Rqc1FyR0drL05xSVEyQjZCVU9neWV5M1l3dmF1aThuRm96VnE5?=
 =?utf-8?B?UjFZc1VsUys1Y3NHNk5kZ0xnb1dxMTlTekV2L0Jwa3paUTVZaHI1SWJGdFk5?=
 =?utf-8?B?UnR5YkFpQjNjUzM0QnlYRDA0QWdIcVhNZzVFY3ZJS3YzR0QxVmZxa1BmYXlN?=
 =?utf-8?B?UjN5dk9TVUcyNWhxdklPUjFCclhjMFVHMmtKbUlpblEzSThyRjVOSFhCMkFN?=
 =?utf-8?B?VWZnZy8vSnhkTDRwbmdBS2VQcHpEM0wyVkVrZVl0MkU5MHl4UmdMd2FFZUlX?=
 =?utf-8?B?SU9QMWlGZWtaVXdMVVpKOGFwQlk3S3dOZDhoWTNvTURvYlJJRDY1VGFsZnJl?=
 =?utf-8?B?aTJVTW9qRVpRbXEzS0RPOFJ4Y1VSUittTjVwbGQ4NFR3MDV0cGJyVUxXdkZ0?=
 =?utf-8?B?ZGZFeWxPSzhIQzlkWUo3YkdMYis2NzU1ZlEzaFZUZGp0SWhhTStmUE94TDNt?=
 =?utf-8?B?Q2RoNDJpOXBFa1hoRHNyOStjUjcvUjF0UnZaL1FYUksvZXZWc1RXeXVHaWtz?=
 =?utf-8?B?Q1ZSajJvbWVPdjdySDlWTEQ5V0FkUWdKcFY1d3Bnb1JHOUR2U21GMUNDUWRN?=
 =?utf-8?B?cmo0eVpOMEJsZVkxZDVVNzRzUElzazFsbEliakZpUWhnaTFvaldGVWRJTXdB?=
 =?utf-8?B?TDJ5MjgyWFZwMCtsRkppbzFFc1VMNkRZdHBBVHNodUxlc3Z2QlpmREJ1S1BR?=
 =?utf-8?B?QW0zQVQxUEpXYjQyYW84TWxlWE85TzRUeDJ6VXJqcHpQa0xiT2FScGRZcEFX?=
 =?utf-8?B?TmFmR0IvNkF5ZGVhRVo1UkdVWWIxUkpJdXNKSi8xaGs0aGFLcXJWSDljN3c4?=
 =?utf-8?B?cVU2SFBoUGVYWTJxNzhSa0s2c3NaNTI1THFWZmZHWjg5Z3huYnpHQ3dkcEJC?=
 =?utf-8?B?Vmxrb0tJZVlhTHFvUUpFNXdJNCtZVEJUS1MwdXlqLzZlc3NNMlBFVjJ6QUdR?=
 =?utf-8?B?RlZUY2VzcmRWMFIxZ0RNNGdqYjROUUhxM28zcHMxSjI1aGVNa3RnKzVXbnN4?=
 =?utf-8?B?b2hxdVZFNFBvWGpLS0xmOW9lWXBRdGRiSGxJdVpTbFBNOXNmQmFrYUl3bDRz?=
 =?utf-8?B?K1R3MTRGb1B5R0xHWEJPUE5zc3p4ZU5qSnZXMGpGV1VhOG5iN1RySkppMmFo?=
 =?utf-8?B?K0R4V0ZyK1NpUy9LQjRiRlZHQjkzTkNmQVVBQzB4cFpyb3VEcHY2KzAySmdY?=
 =?utf-8?B?U29ocitOMFdhb21FMk1MT2VGUlZoeXI0N01PRHJnY1ZUZGh3VXhacVpqc3Qr?=
 =?utf-8?B?WmZSOU9JeUY5Q096S2pjaXZpSnFEdGl3N1JRQXo1czBmMkRvYm1KR2lSbXVC?=
 =?utf-8?B?TlJUblNwT0tmbW1tczVTZE1BbkxTZy9xVGNqQUpsZmJrSU5UV08wUG5pdTFv?=
 =?utf-8?B?R2JTN1FlYW1relhqQm5pQnR5S1huTGxJSDN4V3ZmVjhsYmkyekhjeXNVTWVi?=
 =?utf-8?B?bDEvVC8zbXBOMFZFc0lyeTk4MjB3RW5zOVdCOFdrcURaeUpYRVl5QWVNZncx?=
 =?utf-8?B?TjZSWW5CMkF5Um1mcU1JWjFMMXFnTndwbFhOSFlCOWZWZTBQSUVoM0piWFh2?=
 =?utf-8?B?VVFoVmx4aThVaERkTEFYbHA2OFVzUFYyVG9QcXhDT3dUMzlYNWpId2gwdWsw?=
 =?utf-8?B?aXc9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <683E159B0BB7894D9A07B0A84F41BF66@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5978.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3bfdc13f-7b17-4f66-876c-08daf77c55e6
X-MS-Exchange-CrossTenant-originalarrivaltime: 16 Jan 2023 04:44:21.5366
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: CccHgfFVf/C9r0arF6MIUFidP9AOEhKkZe0xO2X2XiPsd5kMxjlNcSyY20A9fwS4IXtEDo2gnA8RAO4e+vvUkg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR11MB7907
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

T24gVGh1LCAyMDIzLTAxLTEyIGF0IDA4OjMxIC0wODAwLCBpc2FrdS55YW1haGF0YUBpbnRlbC5j
b20gd3JvdGU6DQo+IEZyb206IElzYWt1IFlhbWFoYXRhIDxpc2FrdS55YW1haGF0YUBpbnRlbC5j
b20+DQo+IA0KPiBURFggYXR0ZXN0YXRpb24gaW5jbHVkZXMgdGhlIG1heGltdW0gbnVtYmVyIG9m
IHZjcHUgdGhhdCB0aGUgZ3Vlc3QgY2FuDQo+IGFjY29tbW9kYXRlLiDCoA0KPiANCg0KSSBkb24n
dCB1bmRlcnN0YW5kIHdoeSAiYXR0ZXN0YXRpb24iIGlzIHRoZSByZWFzb24gaGVyZS4gIExldCdz
IHNheSBURFggaXMgdXNlZA0Kdy9vIGF0dGVzdGF0aW9uLCBJIGRvbid0IHRoaW5rIHRoaXMgcGF0
Y2ggY2FuIGJlIGRpc2NhcmRlZD8NCg0KSU1ITyB0aGUgdHJ1ZSByZWFzb24gaXMgVERYIGhhcyBp
dCdzIG93biBjb250cm9sIG9mIG1heGltdW0gbnVtYmVyIG9mIHZjcHVzLA0KaS5lLiBhc2tpbmcg
eW91IHRvIHNwZWNpZnkgdGhlIHZhbHVlIHdoZW4gY3JlYXRpbmcgdGhlIFRELiAgVGhlcmVmb3Jl
LCB0aGUNCmNvbnN0YW50IEtWTV9NQVhfVkNQVVMgZG9lc24ndCB3b3JrIGZvciBURFggZ3Vlc3Qg
YW55bW9yZS4NCg0KIA0KPiBGb3IgdGhhdCwgdGhlIG1heGltdW0gbnVtYmVyIG9mIHZjcHUgbmVl
ZHMgdG8gYmUgc3BlY2lmaWVkDQo+IGluc3RlYWQgb2YgY29uc3RhbnQsIEtWTV9NQVhfVkNQVVMu
ICBNYWtlIEtWTV9FTkFCTEVfQ0FQIHN1cHBvcnQNCj4gS1ZNX0NBUF9NQVhfVkNQVVMuDQo+IA0K
PiBTdWdnZXN0ZWQtYnk6IFNhZ2kgU2hhaGFyIDxzYWdpc0Bnb29nbGUuY29tPg0KPiBTaWduZWQt
b2ZmLWJ5OiBJc2FrdSBZYW1haGF0YSA8aXNha3UueWFtYWhhdGFAaW50ZWwuY29tPg0KPiAtLS0N
Cj4gIHZpcnQva3ZtL2t2bV9tYWluLmMgfCAyMCArKysrKysrKysrKysrKysrKysrKw0KPiAgMSBm
aWxlIGNoYW5nZWQsIDIwIGluc2VydGlvbnMoKykNCj4gDQo+IGRpZmYgLS1naXQgYS92aXJ0L2t2
bS9rdm1fbWFpbi5jIGIvdmlydC9rdm0va3ZtX21haW4uYw0KPiBpbmRleCBhMjM1YjYyOGIzMmYu
LjFjZmE3ZGE5MmFkMCAxMDA2NDQNCj4gLS0tIGEvdmlydC9rdm0va3ZtX21haW4uYw0KPiArKysg
Yi92aXJ0L2t2bS9rdm1fbWFpbi5jDQo+IEBAIC00OTQ1LDcgKzQ5NDUsMjcgQEAgc3RhdGljIGlu
dCBrdm1fdm1faW9jdGxfZW5hYmxlX2NhcF9nZW5lcmljKHN0cnVjdCBrdm0gKmt2bSwNCj4gIAkJ
fQ0KPiAgDQo+ICAJCW11dGV4X3VubG9jaygma3ZtLT5zbG90c19sb2NrKTsNCj4gKwkJcmV0dXJu
IHI7DQo+ICsJfQ0KPiArCWNhc2UgS1ZNX0NBUF9NQVhfVkNQVVM6IHsNCj4gKwkJaW50IHI7DQo+
ICANCj4gKwkJaWYgKGNhcC0+ZmxhZ3MgfHwgY2FwLT5hcmdzWzBdID09IDApDQo+ICsJCQlyZXR1
cm4gLUVJTlZBTDsNCj4gKwkJaWYgKGNhcC0+YXJnc1swXSA+ICBrdm1fdm1faW9jdGxfY2hlY2tf
ZXh0ZW5zaW9uKGt2bSwgS1ZNX0NBUF9NQVhfVkNQVVMpKQ0KPiArCQkJcmV0dXJuIC1FMkJJRzsN
Cj4gKw0KPiArCQltdXRleF9sb2NrKCZrdm0tPmxvY2spOw0KPiArCQkvKiBPbmx5IGRlY3JlYXNp
bmcgaXMgYWxsb3dlZC4gKi8NCg0KV2h5Pw0KDQo+ICsJCWlmIChjYXAtPmFyZ3NbMF0gPiBrdm0t
Pm1heF92Y3B1cykNCj4gKwkJCXIgPSAtRTJCSUc7DQo+ICsJCWVsc2UgaWYgKGt2bS0+Y3JlYXRl
ZF92Y3B1cykNCj4gKwkJCXIgPSAtRUJVU1k7DQo+ICsJCWVsc2Ugew0KPiArCQkJa3ZtLT5tYXhf
dmNwdXMgPSBjYXAtPmFyZ3NbMF07DQo+ICsJCQlyID0gMDsNCj4gKwkJfQ0KPiArCQltdXRleF91
bmxvY2soJmt2bS0+bG9jayk7DQo+ICAJCXJldHVybiByOw0KPiAgCX0NCj4gIAlkZWZhdWx0Og0K
DQpBbHNvLCBJSVVDIHRoaXMgY2hhbmdlIGlzIG1hZGUgdG8gdGhlIGdlbmVyaWMga3ZtX21haW4u
Yywgd2hpY2ggbWVhbnMgb3RoZXINCmFyY2hzIGFyZSAgYWZmZWN0ZWQgdG9vLiAgSXMgdGhpcyBP
SyB0byBvdGhlciBhcmNocz8gIFdoeSBzdWNoIGNoYW5nZSBjYW5ub3QNClREWC1zcGVjaWZpYyAo
b3IsIGF0IGxlYXN0IHg4Niwgb3Igdm14IHNwZWNpZmljKT8gDQo=
