Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 091A96FE9E1
	for <lists+kvm@lfdr.de>; Thu, 11 May 2023 04:42:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232958AbjEKCm1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 10 May 2023 22:42:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53482 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229500AbjEKCm0 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 10 May 2023 22:42:26 -0400
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8A1A049F7;
        Wed, 10 May 2023 19:42:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1683772942; x=1715308942;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=oz6QLCCbElWa7aIvq+HMn2gn0ofkaGtLNcdctjfhf+I=;
  b=dA3z6xxxcM7a7SXUd3mh9pfIFPwz2dZVj2U9BepXfqciUFtoTMnB7Mpm
   OvfqIpQSVK+3EQZh5NfeKAM0u5/F+WP1u0Q1/sXmba9TUzDMzFMgxN/hh
   VnPeXXTiokc+Uk9lWkInIoAcIX9FCozT5Hm2oe0OZ7ZR0PLEi51ErwF72
   O7SMdvCIqF9Gu1wbXU8sgcP2/XNekY0cfPa7MmsOkl4WXT4BsmXiKe4mu
   unCn3rtcAByGRynC7Kdp4SLkft+eoXbdon8JuZ7TsMgh0brJ9f/j+jV0u
   g9FZtQB7Hl9XyWcAZ+ltBomcRvdOUV2HgPaxRGePwu9x14WnMeA8wiOQV
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10706"; a="334850204"
X-IronPort-AV: E=Sophos;i="5.99,266,1677571200"; 
   d="scan'208";a="334850204"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 May 2023 19:42:22 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10706"; a="649965958"
X-IronPort-AV: E=Sophos;i="5.99,266,1677571200"; 
   d="scan'208";a="649965958"
Received: from fmsmsx603.amr.corp.intel.com ([10.18.126.83])
  by orsmga003.jf.intel.com with ESMTP; 10 May 2023 19:42:21 -0700
Received: from fmsmsx611.amr.corp.intel.com (10.18.126.91) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Wed, 10 May 2023 19:42:21 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx611.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Wed, 10 May 2023 19:42:21 -0700
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23 via Frontend Transport; Wed, 10 May 2023 19:42:21 -0700
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (104.47.66.49) by
 edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.23; Wed, 10 May 2023 19:42:21 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=nHQfvz6fkPyacXuQQNl/bpXXHMp8I/B+cU+4cVnijxkEvArxj8Jy5sq35n5BCmWSrK9b1i9CGZyYaj1eYh03SDjDuyu5WrCp104w+duiI4k0HHL28voCTD6FiBaDa7IRdmUzWz/P079yGADIZEJgy9vJHG9uhQbA3cmG3PHUI1wSNzmJxUsBAh/VQfNGj0guHwPmbguwAgcxOMEIkCR7tr/hcudckKyuK4dGL6Gv1cnPXn79JBvl2cs8AbsXzh5YswYUHfZ7gosMGFv32yaao4LyRpRxl5GMJ3uBNnqDkezxhT1IlEY7K+QXX3VKm0thpm0Dv7NJPHxySfHVqBjg4Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=oz6QLCCbElWa7aIvq+HMn2gn0ofkaGtLNcdctjfhf+I=;
 b=PwfKlp7rH1ykywYs++USGLycR/NGniCI6SpJhQin1akryJ7Fi2VJ/0Waxacv0r4PjI4hmlG7+xas4qzjajzwzkK2soWyn4gQEVAsvC9Xpo0P6x2tHVxJ8u68gutwpHZMYLUJCOjWUZpGMU1HE46MYz8XarrGqFWrQbO+Pehhpim2P9TAf8eFe6KaOV0lyajM57xRvAtzaeCdU74O0WGinqtHu+LVXply0Oxoy9wREDppPHlfmG7ULvBQVO8OKiLz22ugolZi4wjbUofE5lI6WvUWlJBa5QRss3GXSRzh/+O57lT7CVz6zvowtuD54dOnRnpnS3aHTDwqnk4NDouBJQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5978.namprd11.prod.outlook.com (2603:10b6:208:385::18)
 by SJ0PR11MB8294.namprd11.prod.outlook.com (2603:10b6:a03:478::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6363.32; Thu, 11 May
 2023 02:42:14 +0000
Received: from BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::3a8a:7ef7:fbaa:19e2]) by BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::3a8a:7ef7:fbaa:19e2%5]) with mapi id 15.20.6363.033; Thu, 11 May 2023
 02:42:13 +0000
From:   "Huang, Kai" <kai.huang@intel.com>
To:     "Zhao, Yan Y" <yan.y.zhao@intel.com>
CC:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Gao, Chao" <chao.gao@intel.com>,
        "Christopherson,, Sean" <seanjc@google.com>
Subject: Re: [PATCH v2 3/6] KVM: x86/mmu: only zap EPT when guest MTRR changes
Thread-Topic: [PATCH v2 3/6] KVM: x86/mmu: only zap EPT when guest MTRR
 changes
Thread-Index: AQHZgoDvHvtjWxAbgUSEtQq61PPuVa9S/o2AgAAndwCAADCnAIAA38GAgAAo8AA=
Date:   Thu, 11 May 2023 02:42:13 +0000
Message-ID: <077fbb11f0a74850fb46abe4fda31414db66539a.camel@intel.com>
References: <20230509134825.1523-1-yan.y.zhao@intel.com>
         <20230509135143.1721-1-yan.y.zhao@intel.com> <ZFsuDWwoKRA0W2/j@chao-email>
         <ZFtPKLvblLcxPvZQ@yzhao56-desk.sh.intel.com>
         <99c982ed53f0dd7e0723f566b5527091b7e4e54c.camel@intel.com>
         <ZFwzq/833QX3n9xc@yzhao56-desk.sh.intel.com>
In-Reply-To: <ZFwzq/833QX3n9xc@yzhao56-desk.sh.intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.48.1 (3.48.1-1.fc38) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR11MB5978:EE_|SJ0PR11MB8294:EE_
x-ms-office365-filtering-correlation-id: fe9df1a7-2f15-4d43-a6b5-08db51c95351
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: oEVVAEZSfbPap87OeQ7SVZvUAVSH93c8/ytcMyHvPhp3SJp7fopPFLTZqh1EZ+KGreIX7P7IArvmjP/O9flNfIBuVyg1z7L7RVne9wF5oC2AfQwVdU3Z3mAO4GXSPN9jYB81AA7CWc6HxKy5scYjoWO4TBg8MmCR3Au3QRm+qIIk8YAhmPRLNOFvDTpHoS06FHD+4//pSvJzCqpGEiU1rhyQqdPpLC2uWKx3BDYOCEyDB+Ed4dfghhQe3GUQukTDmMM1tztWyUQvsjVRGiBU+m3jD22ZLMzRpKGLboiWkH9zXklxKRDWbMcKBJbJ/e11NTGH9jP/PGA9fq9jDA9ljEXL+mle9VqZaTZEf9iXKSnFWMTxToOFZPDwkjgf+Gcvzi/NGLdEi1lYO4bI8E6KDjvA3l7b+U0sK1eCfxPn37ReJ8SRCN1jEnrIE+9Q4Azfdof/07MGVyPGjES6CJ4lpYeRnKiH0/Kffj3fxAwoCQiVr0AXslr9HP8kf79dTaYSpw4iGf58BLwLc7tO7dPqi9b5RFjiPSKTmPH6T/bMj0maZnlrRrlrAik8i86iQB1MdkNf6KqDBB4LTu3w18V3PVv70/OuL4iI2zAdgD0rNjk6VoLgFLULnvuGJNVfTBA7
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5978.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(346002)(39860400002)(396003)(366004)(136003)(376002)(451199021)(6512007)(26005)(6506007)(186003)(6486002)(2616005)(36756003)(38070700005)(122000001)(86362001)(83380400001)(82960400001)(37006003)(478600001)(41300700001)(66446008)(8676002)(2906002)(38100700002)(54906003)(66556008)(5660300002)(4326008)(66476007)(64756008)(8936002)(6636002)(6862004)(316002)(91956017)(76116006)(66946007)(71200400001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?L2g3cVRUa2VVVmRJSEw2RGRvMmN5QlU1Mmx2UGZNRC9KWXllSzNwWWovTFd6?=
 =?utf-8?B?M2FlN3ZpQzRsQzhzZTRqS200b0ZrMjc5OW9IMXRCVDlvWUhyNEdrYTlMOVl3?=
 =?utf-8?B?R2p5eVVJZUxtQUNrWlRNQzV1S2s0UFdLNE5aaS9rcEpjUFA4eVdTRFo3TmhG?=
 =?utf-8?B?aFNYaXJkUWNtZllvaXU3M2plQnk5ZFhwMXYyK3I1bi9CcXBrMGREZTlaQ3dw?=
 =?utf-8?B?NEZZRjl4TS9ObDJHRkJnZlZWc3lEZDYzY3VuOThNbDM2enNjNkFkYWpiL05F?=
 =?utf-8?B?TUFFVzlpcHkvaGtmQmQzRnZVc3J0dXFhVFJMMkFiV25zWERhWk5ETk9YU3Y0?=
 =?utf-8?B?Z1B6NFpsNVBFRmlTODIvRkFqUkRsTUVUWUFNRUlqSTFLSXYvMWt2Ky9XaHlR?=
 =?utf-8?B?ZEt0ck54SWg4Rm03bHlzRXFFcGxGU0Z3bUZBM0pqcTEyOXZJS2pZRSsxVEgz?=
 =?utf-8?B?OFQ0aGsxcmVWL1lGOXVTWk91L24rcUhBTHEwcGRDOXRoMlhPZmZtN3krZThp?=
 =?utf-8?B?S2plTk1aZTFPSXJTOGJCelpZUEZDeEVjdmJSWWxFRkRTZTFBNmZ4TitkOUpG?=
 =?utf-8?B?RGxxY2VYWkViWXdNelBIditnaU9RSGIybWE5ZkFrcmt1dUcxd3FPNFlMOTVq?=
 =?utf-8?B?NGI3SVNFNVpLVHp4QnhyMWdQeUxtNFlsRTR1QlNqRjExVFRzTHoydi9HMCtl?=
 =?utf-8?B?a2lJclRkN3kwSXNic2N6aGdpM3dJWlB5eEVjTklGMHNvanhmN0poYms4NmdK?=
 =?utf-8?B?b21FSnZ3RlV4Zm8wM3puV0xCOFczZmhYaUFGRzBTbDlsRlk1MHFsdGZuQzhQ?=
 =?utf-8?B?WjdCNkUvWG1zbTZ4dlNTeDQ4OUJ4QkE4RWpwa2UwVVNERjh5Sno5K2RYMmxs?=
 =?utf-8?B?UEZ5eW56dGZBbkFlazkzb0c1eDNrekxrcDFLMk0raGhUK0h0aVBpMGdOTnI3?=
 =?utf-8?B?Nlc1NHBNTG54ZUdJY1NOaStKWWQzUGo5VmJKN3JuRVR4bDFyZFNjbHpzSnFn?=
 =?utf-8?B?bGdPaHR5MzRMSFhrTUxKSVczM0JNUVMzbFdYWmVLOWNzTk5henQ5dHNQOUIr?=
 =?utf-8?B?RVFSbmJSL0Nlc3dkckV6TlNheDFneEFZUG1BdVEzK1RyNVpJdU5SSVBkUFJC?=
 =?utf-8?B?YStTdTRDL3dOdjZQaXRjek9jcEdoZ0h5a21ySnNyTXJtSHY1QkNORk9Od2VR?=
 =?utf-8?B?aTNqU2lSMzZaR0txdjRVYzVSS09BQ2pLSW44TFVseFk4VUpCT0JtR3lEb1Zl?=
 =?utf-8?B?aVIvUXRtMVAxOWVXV1YxNTJaWDZtajJ3REhvc2xKaEpzYUQ4TVpKaU9qczBJ?=
 =?utf-8?B?d1hMdTJwb2xtRk8xTERUSm54L0RPTnFJcjBFRThYbjByNVR2TnRSaGw3Tnhm?=
 =?utf-8?B?Z01rbEZJOTdlak56RWY2dXM3MnNqVlhaQ3ZheFF0VGNRWVcxdHoyMlhoYkx4?=
 =?utf-8?B?TnhFdk90ZEVxTVpRTUFVM2xwTXF1b3gvbjROS2RVY0I5UU0zbjh6c0J4TzVw?=
 =?utf-8?B?S2dPcFZZR2RyWWJIa0c4dkR1aGszOUNkSEFXdEh2bndQd2R4VzBOQzBzNys5?=
 =?utf-8?B?eW0xVFc5Z044b1NWUUFPazFTTERJamU4MEZXYndxckV0c1pVUlVXbE5WUFNI?=
 =?utf-8?B?UjFMYmZHamEvNFVXSGR5bk9XOHcxNkdjT0NGSk16UUdaZCtZWlNBcFlFRUhV?=
 =?utf-8?B?YmE1SlFtYzAzZ09Xd1pObWM1dSt4dWFzMzRUN1BzV0lwejlhUS9MeHZuY2t6?=
 =?utf-8?B?NzZYdE1nZzFmU0VKd09hN3BsQ3d2N0ZZdllvc05ydUwybjJac0F6eHV2aDBw?=
 =?utf-8?B?ZEU0S2FCNVRpUjU2dEFkM0dValNEN0prSENJb21lcVdoTEx2L1FCdFc0UW1M?=
 =?utf-8?B?YUtiV2lvQnNkakwrU0NVUXl2cDZRMEVFSzd1RUpQNlZFS1ZTWEVkOXpzREQ2?=
 =?utf-8?B?SUVaek83MHYvR1lzVW0yS2hZZjhtVDA1M2JoZ3NMdXBPd1ljSERsanR6d24r?=
 =?utf-8?B?VndiYXJ3b2NqeXh4MUIxUGZzTzV3UHpaQWJoblA3NDNHZXl5cWQyLzVjcTIz?=
 =?utf-8?B?OHl2YUMxSjVlUm9TdElOcjdJZHBFRmt3aXpKQVlVb2N0ck5mVVZnZkMrRmpZ?=
 =?utf-8?Q?BB44YuK/cGi1jkD9Rkur/RCyd?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <8881DAEAA4C84D4C9B56555CD389AC0C@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5978.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fe9df1a7-2f15-4d43-a6b5-08db51c95351
X-MS-Exchange-CrossTenant-originalarrivaltime: 11 May 2023 02:42:13.1059
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Dm2iO6KsLSTQybIHk5YC2fv8/muOMjTwRM/hfT/pwV7Nz3xLAWqN/CmiPBn1V9OdQexQVQLfXyjIgNKvA1VxhA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR11MB8294
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

PiA+IA0KPiANCj4gSSBhZ3JlZSBzaGFkb3dfbWVtdHlwZV9tYXNrIGlzIHRoZSByaWdodCB2YWx1
ZSB0byBjaGVjayBidXQgaXQncyBpbmRlZWQNCj4gaW50ZXJuYWwgdG8ga3ZtIG1tdS4NCj4gSW5j
bHVkaW5nICJtbXUvc3B0ZS5oIiB3aWxsIGZ1cnRoZXIgaW5jbHVkZSAibW11L21tdV9pbnRlcm5h
bC5oIg0KPiANCj4gV2hhdCBhYm91dCBpbnRyb2R1Y2Uga3ZtX21tdV9tZW10eWVfZWZmZWN0aXZl
KCkgaW5zdGVhZCBhcyBiZWxvdz8NCj4gDQoNClsuLi5dDQoNCj4gIA0KPiArYm9vbCBrdm1fbW11
X21lbXR5ZV9lZmZlY3RpdmUoc3RydWN0IGt2bSAqa3ZtKQ0KPiArew0KPiArICAgICAgIHJldHVy
biBzaGFkb3dfbWVtdHlwZV9tYXNrOw0KPiArfQ0KDQpJIGRvbid0IHRoaW5rIGl0J3MgYSBnb29k
IG5hbWUuICBzaGFkb3dfbWVtdHlwZV9tYXNrIGRvZXNuJ3QgbWVhbiBhbnkgYWN0dWFsDQplZmZl
Y3RpdmUgbWVtdHlwZSwgYnV0IGp1c3QgcmVwcmVzZW50IHRob3NlIGJpdHMgdGhhdCBLVk0gY2Fu
IG1hbmlwdWxhdGUgdG8gZ2V0DQphbiBlZmZlY3RpdmUgbWVtdHlwZSBmb3IgdGhlIGd1ZXN0IGFj
Y2Vzcy4NCg0KSW5zdGVhZCwgaXQgc2hvdWxkIHJlcHJlc2VudCB0aGUgaGFyZHdhcmUgY2FwYWJp
bGl0eSB0byBiZSBhYmxlIHRvIGVtdWxhdGUNCmd1ZXN0J3MgTVRSUiBpbmRlcGVuZGVudCBmcm9t
IGhvc3QncyBNVFJSLiAgU28sIHBlcmhhcHMgc29tZXRoaW5nIGxpa2U6DQoNCglib29sIGt2bV9t
bXVfZ3Vlc3RfbXRycl9lbXVsYXRhYmxlKCk7DQoNCkl0J3MgYmV0dGVyIGlmIFNlYW4gY2FuIHBy
b3ZpZGUgaW5wdXQgaGVyZS4NCg0KKEJ0dywgb2ZmIHRoaXMgdG9waWMsIEkgdGhpbmsgaXQncyBl
dmVuIG1vcmUgcmVhc29uYWJsZSB0byBtYWtlDQpzaGFkb3dfbWVtdHlwZV9tYXNrIG9ubHkgYmUg
bWVhbmluZ2Z1bCB3aGVuIHRkcF9lbmFibGVkIGlzIHRydWUsIGJlY2F1c2UgdGhlDQpjYXBhYmls
aXR5IHRvIG92ZXJyaWRlIGhvc3QgTVRSUiBhbmQgZW11bGF0ZSBndWVzdCBNVFJSIHNob3VsZCBi
ZSBvbmx5IGF2YWlsYWJsZQ0Kd2hlbiBzZWNvbmRhcnkgTU1VIGlzIHR1cm5lZCBvbikuDQogDQo=
