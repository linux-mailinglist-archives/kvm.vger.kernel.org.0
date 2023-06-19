Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D847373602A
	for <lists+kvm@lfdr.de>; Tue, 20 Jun 2023 01:38:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229595AbjFSXiI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 19 Jun 2023 19:38:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48948 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229521AbjFSXiG (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 19 Jun 2023 19:38:06 -0400
Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 971BFFA;
        Mon, 19 Jun 2023 16:38:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1687217885; x=1718753885;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=fTPWZw3Ehq0kA2Z6J+4upZwtvUicg7esEipfKog0/iw=;
  b=kU1/+nrqqNxUlm406obFuDdModXpWKU5N4zj+jqEyxPJcINZb2hQWknC
   HNaPjh/O1cbmPc2VNNM5ZGmsVWCo6DaSsV3NesCiKWa1KFr4KGYV97sPs
   tld1yoIifw2/wTOeh7XHCuALNQLBb67FNel1GEx15iOWP4IDD9+ys7lkR
   4sUpCIW9LarrID/9l7JTekparyAheSvAq0+e16154hqNT64eFBDKxskvA
   BX8dyb1MO8FLZhdZ5A/W8kIgQ1e0D/mbESx6V2voGYsQzd4BqsJc8ihLk
   mgsBuNAHhW9XYmsCpTSi+rSHduFzcpzTCzGWzvdvg1ZmDttZLk99aJbmY
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10746"; a="340070944"
X-IronPort-AV: E=Sophos;i="6.00,255,1681196400"; 
   d="scan'208";a="340070944"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Jun 2023 16:38:05 -0700
X-IronPort-AV: E=McAfee;i="6600,9927,10746"; a="747788104"
X-IronPort-AV: E=Sophos;i="6.00,255,1681196400"; 
   d="scan'208";a="747788104"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by orsmga001.jf.intel.com with ESMTP; 19 Jun 2023 16:38:04 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Mon, 19 Jun 2023 16:38:04 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Mon, 19 Jun 2023 16:38:03 -0700
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23 via Frontend Transport; Mon, 19 Jun 2023 16:38:03 -0700
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (104.47.70.106)
 by edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.23; Mon, 19 Jun 2023 16:38:03 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=JV6ORycZZ05hG5DfW3O/stJNpl+I+ronyb9343NP9Qa9WSVYKnNd6vjyYZKXraY+rhxmRUnnGMAxUi0lHSh707OCGkvn4D8zIYurSVXwQbyQcWf9PxnyuljybUeh0TpSr+nyNuPS3P9Ybs/CaympMhKzB03aicEGfS7CwKCCindnBfDNMok33+PRO6/zzBHXvuF17WVKw+YkEtUfjjG8tEmfjV3t1GPTDhdWDGASUOLvsbLML/d4WG2ZithOlegApwiPqs64XUx1ao5x5NMTotRJlyIAAyAdYGhyBsdJbNo6K/mQg74ucGZ3Rt3t3ig0qinKgdNyR0O9l9AwqLr3HA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=fTPWZw3Ehq0kA2Z6J+4upZwtvUicg7esEipfKog0/iw=;
 b=nUKpXe4pcwgJ2PDg7KpHp/GJFzgz9Hl28RtfLa7umc2sEe7RXmjp9jQ2ov4Hi7NSEbW0wICfHBpBR4UtReFOCkLKIfxyBFuXY7o5urLqTRf/Pfsag4lvyqK8BtSbgUezDCg0O6gK6fCNB37DfCsETuF8T1KdsDpG8QbEW4kVIFZKeiUIg1fwLDhOOQX4p/OOwoxYkRn/M8ftJL3Szr4Z+WSUX3/bYLp+jv8DfUy18oo8EgwJ7W2bkfsgUuSCDAu3MR8RrLN6GuGfhWi4DJZBqvkOimx1rPfaNo32tM29pgAz9lwmXQgH0EkFvZCG1W/l22pPxKr0BGAP5ykiPyqMCA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5978.namprd11.prod.outlook.com (2603:10b6:208:385::18)
 by SA1PR11MB5874.namprd11.prod.outlook.com (2603:10b6:806:229::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6500.35; Mon, 19 Jun
 2023 23:38:00 +0000
Received: from BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::19b7:466f:32ac:b764]) by BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::19b7:466f:32ac:b764%3]) with mapi id 15.20.6500.036; Mon, 19 Jun 2023
 23:38:00 +0000
From:   "Huang, Kai" <kai.huang@intel.com>
To:     "kirill.shutemov@linux.intel.com" <kirill.shutemov@linux.intel.com>
CC:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "Hansen, Dave" <dave.hansen@intel.com>,
        "david@redhat.com" <david@redhat.com>,
        "bagasdotme@gmail.com" <bagasdotme@gmail.com>,
        "ak@linux.intel.com" <ak@linux.intel.com>,
        "Wysocki, Rafael J" <rafael.j.wysocki@intel.com>,
        "Luck, Tony" <tony.luck@intel.com>,
        "Chatre, Reinette" <reinette.chatre@intel.com>,
        "Christopherson,, Sean" <seanjc@google.com>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "Yamahata, Isaku" <isaku.yamahata@intel.com>,
        "nik.borisov@suse.com" <nik.borisov@suse.com>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "peterz@infradead.org" <peterz@infradead.org>,
        "Shahar, Sagi" <sagis@google.com>,
        "imammedo@redhat.com" <imammedo@redhat.com>,
        "Gao, Chao" <chao.gao@intel.com>,
        "Brown, Len" <len.brown@intel.com>,
        "sathyanarayanan.kuppuswamy@linux.intel.com" 
        <sathyanarayanan.kuppuswamy@linux.intel.com>,
        "Huang, Ying" <ying.huang@intel.com>,
        "Williams, Dan J" <dan.j.williams@intel.com>
Subject: Re: [PATCH v11 15/20] x86/virt/tdx: Configure global KeyID on all
 packages
Thread-Topic: [PATCH v11 15/20] x86/virt/tdx: Configure global KeyID on all
 packages
Thread-Index: AQHZlu+0KAMcPEG9HEOo/5AeWmgUfq+LlEeAgADuFACABcwxAIAAkbwA
Date:   Mon, 19 Jun 2023 23:38:00 +0000
Message-ID: <babf33a99abad29f1e42036bb8e795faf81e97de.camel@intel.com>
References: <cover.1685887183.git.kai.huang@intel.com>
         <30358db4eff961c69783bbd4d9f3e50932a9a759.1685887183.git.kai.huang@intel.com>
         <49bd9f7f-9a2b-8b8c-f408-49b9b5982eb7@suse.com>
         <a60acb9be5bd5b0eb9b32ff11932fc019262dfe0.camel@intel.com>
         <20230619145622.cjyis472geajrmnk@box.shutemov.name>
In-Reply-To: <20230619145622.cjyis472geajrmnk@box.shutemov.name>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.48.2 (3.48.2-1.fc38) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR11MB5978:EE_|SA1PR11MB5874:EE_
x-ms-office365-filtering-correlation-id: 4ae62540-e378-4985-8ad2-08db711e381d
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: pJftA1lVfpW3GpxUQkCCK6LKmHSHcuMgTSLEFA4FUmtQm4uz638GsV5YX0JWp9izrEBH/95kQuJGkFoaMDcSbh2z8QkbhiIiB8v/bV8jgEKySy7bfVcKSFtwCoXsiLgqPBbiHGqIOo9GtplJV1Jfu3iY/M5vr6emOwRoGnqCia/dI8vYBHUkt8JKW2yjEkXjmPtUR9ua9VVl6+H16x0UjHSEZuo9pq9vPsGQFx3ZXRpfLoHKhx0atrtv3t0RrJHdCqZQCmF76epv9qe2BTBeBEdq6ItVE/fiPwpf1bu0m8XvAbJJUFOWp6ZGrJi3JDAKKL3arN8I3HUtDJDnB5NnWoyAK1qyQq2OUWn+R92EipW7Ww2uPzQ0cms4ucxjsddMXHTqLdj7ICDNUOF2RtFW1KeXAmVvC4UBJh5OFQ3mZ+toJoK38laUjOlAn9dPRRyALhvGQzg9Z/bcUnVsigWeA3BLTY2ImPSN4WwlQisQEKT20YH+PCALqCMxojMTfZRcgMEpeDUinzL7rLyjSPGb3mCf9yDei2eJOfKiq2roO7vVFdgp7Z4XWQxTboEzoki9+RE9spVjZ2UoxEPvV3k1bJ4BPNvwKx4z3XvvA0K3byniWeKBkj32TvHeoIU9Dina
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5978.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(136003)(376002)(396003)(366004)(39860400002)(346002)(451199021)(122000001)(7416002)(82960400001)(38100700002)(86362001)(41300700001)(8936002)(38070700005)(8676002)(5660300002)(64756008)(66556008)(66476007)(66446008)(66946007)(6916009)(316002)(2616005)(6506007)(6512007)(26005)(186003)(6486002)(76116006)(478600001)(91956017)(4326008)(54906003)(71200400001)(2906002)(4744005)(36756003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?eERJS0RWeDQvRzhQUU9ydHJSR1pJNHFtQ2xCK1hkWk93b0dLcGdaVFk3U2hU?=
 =?utf-8?B?NXBwSHk0Y1V6K3laY1pDcWJoSWNLRGovZ3pONzNFSTdwOHI3a2YxbWRsdlp3?=
 =?utf-8?B?WnZDR3AwQXU5K0FpWlYxTit3Nkx4b0ZmVWpaZTROQy9PclkxblBEMVdFZmZK?=
 =?utf-8?B?N25vUlNrNWVrVzVCME5rblpMOS8zQ1VrWnRnU3I1dDgwbWVjOU5rTS9pdTFJ?=
 =?utf-8?B?VzAwdzBCUlFZOFJ1SHpYR2tHWVNEcmVPb1pWSGVac1R0aVAvdU9pc29xMDE5?=
 =?utf-8?B?aTRsTXRnWitESm94MHNsOTExa3dEREFuR01RMGo1TFNPY1JiYlFhS3Y5VElv?=
 =?utf-8?B?VXo1RklUbUYxaFQ0YzlDVDdwbVhhTmovelNtUDBoWVRWRDdpeWFBNEpLaEUx?=
 =?utf-8?B?Ym5qWVlLYnRZYnZFWW1YaWZQamtrTzdkNWdJRUNmWVZXUGI3QW0xNUdNR3Q5?=
 =?utf-8?B?T21TTEFXRGxQV0VTNEVtZExmZEJZampxZkxvUFBibFJyemQ0aWJCSDFZUDdG?=
 =?utf-8?B?SlNkSngydTlMV0h4V1p4WDI5WGplWHJGb3Jxd1ZodDd5eGc1N00vazVhUmg5?=
 =?utf-8?B?ZGlHeFAzaDVJVWRNbkdCVFc3STk4MlgvVDdadE8yeVIyb2x5YWJZOW5BMlho?=
 =?utf-8?B?V2tscGJwUml4Q3VzbUJuQXFNV1Q1R2ZKaE50NG00WGV2QUVzYWlNSW1wdThN?=
 =?utf-8?B?QzR1K1UvNmJtdEZ3ZEtJOWlOL1pheTJTQ2xyeCtMVUpLR0xGUVlhM0hUQ1Vh?=
 =?utf-8?B?VU1WczdjNlI3NTB2UGxzeHUvclBoaDNZV2VmMUp4OVFTbXdVbFo1R2UvMloy?=
 =?utf-8?B?Wm9vaGJVWlMvNkxoc0JXcW5rVEhJNEl3c21DSURrN29vRndOUi92SUMyR1oz?=
 =?utf-8?B?MHRXd2xZTmdlekhIaVhEYmJ4aHJGYlY0TWpVSTVpVW5mbks1SEowd0tFcFJI?=
 =?utf-8?B?YnpuSVJreTQvR2NCWDF2UFFJTTVyRlExRm11SGpXMTFRekNzTEh6em85L292?=
 =?utf-8?B?OG1KQk1jRG9RdjFhSFp2MEtjMEFFTFVDUHg5b0lTVGlkVGxmVGhTd3NueVNW?=
 =?utf-8?B?WWcvYjRZTmtXNEdkS09DeHNlRnNmQVE4N1hJaXkwdnNzMGhZanJxK1hwRHk0?=
 =?utf-8?B?bWV2ZlJmeHZMa0lzRWN4dmdJbE5IY1d0NVhWOCt5aTVCaTBsR01FYWZZYm13?=
 =?utf-8?B?RWwrSGZ1QjhaeFIzMXNFZkphWHdGc3IrVnBiZzdWMitlSURNUlJtMEhZYkIv?=
 =?utf-8?B?VzU2ZFY1bmZwdTBvSnI4dE5uUk5yd1gzVnNsMHp3QzVoRFpxREdDVWg2a1RD?=
 =?utf-8?B?K3NoaE0wS3EzUGdpRjF1c0NGcVFsNURQK3JhUkM5RXZLdVVDa1pISHJPZHcw?=
 =?utf-8?B?bnhoaGdRNU0rdE0rbnB4VlgyWVp4aWlSZmhNd3ZxVzF3dFhyUnN6Ymlyczdh?=
 =?utf-8?B?YTZSZC9oY2g1OXMzUEI5Mi9aU2hQSjVEd2dMblVBL3hOS0xhenY4K0xZN0pK?=
 =?utf-8?B?VFlTTmNPZXByYmd0OHE3UDVoaWdmQ3hvbERJZ3hNc1Z1dG1oeFUyLzRmNElt?=
 =?utf-8?B?aXNiMnY1K1NvT05jZHI1NTFZakNQUkhaM29vYjBJaUNHTnNaV3FHenhMNlRm?=
 =?utf-8?B?K3hHWHFUVUh1eTBYNG1QZWgrMWNTQWw2UGFSWjE0VjcwQWltcGxhUkQ1T0pF?=
 =?utf-8?B?ZVZYNG1RR1hOODBRNVRnNUtaMGpiWmlzQVN2OU5OSG9oakFwR3lYUEhuaVJK?=
 =?utf-8?B?Vmx5ZHNnUFUrTkd3ck1qRTE4MWxQRndtNkE3dUxQdENoYmdJUDVGckQyL0sz?=
 =?utf-8?B?aTdreE1OUDQxOTg3MnVzUG1neWJGd3dxdCs4cTZYQ21sVVMrYTRMUVlKaTYv?=
 =?utf-8?B?WityM2drU0UweU9FMFI1L2M5aHBjUG5kT2NpUk5sTVV4eUFVUVJqS0RNMFVL?=
 =?utf-8?B?SEFwYXFETDZlVm82Z0JrU3IxTmRZemxkZXp5eXdJN1Vhbk0rSjIwQTJTSkx5?=
 =?utf-8?B?enNOWmMvci9hd3QrOWErOVRnM3FHVzVqdEY0SERVblJ3NHZONnhjSzBoUHdI?=
 =?utf-8?B?Z3NpMDJPRmtuZGtwUU1YVWJxKzcwYmdEQzlHMCsreDRPVElvYU12djAxblRP?=
 =?utf-8?Q?wXVbIZrFVhcGGBN28NpPC1XYg?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <D4AEB3B62A7BB745BD870864C3824C07@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5978.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4ae62540-e378-4985-8ad2-08db711e381d
X-MS-Exchange-CrossTenant-originalarrivaltime: 19 Jun 2023 23:38:00.7455
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: x8D6aOhg27KnpT3Yy6D+EtKS85HxpSBYG2EYQSK3g/ILBtIf2IuxypA1lKg1z91RWet7gxLmqbyRGfoEYAx2yQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR11MB5874
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

T24gTW9uLCAyMDIzLTA2LTE5IGF0IDE3OjU2ICswMzAwLCBraXJpbGwuc2h1dGVtb3ZAbGludXgu
aW50ZWwuY29tIHdyb3RlOg0KPiBPbiBUaHUsIEp1biAxNSwgMjAyMyBhdCAxMDoyNDoxN1BNICsw
MDAwLCBIdWFuZywgS2FpIHdyb3RlOg0KPiA+IEhpIEtpcmlsbC9EYXZlLA0KPiA+IA0KPiA+IFNp
bmNlIEkgaGF2ZSByZWNlaXZlZCBjb3VwbGUgb2YgdGFncyBmcm9tIHlvdSwgbWF5IEkga25vdyB3
aGljaCB3YXkgZG8geW91DQo+ID4gcHJlZmVyPw0KPiANCj4gSSBhZ3JlZSB3aXRoIE5pa29sYXks
IHJlbW92aW5nIHRoZXNlICJpZiAocmV0KSIgaGVscHMgcmVhZGFiaWxpdHkuDQo+IA0KDQpPSyBJ
J2xsIGNoYW5nZS4gIFRoYW5rcyENCg==
