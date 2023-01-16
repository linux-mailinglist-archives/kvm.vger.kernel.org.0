Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5987366BC1A
	for <lists+kvm@lfdr.de>; Mon, 16 Jan 2023 11:45:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230409AbjAPKpq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 16 Jan 2023 05:45:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54530 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230145AbjAPKpn (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 16 Jan 2023 05:45:43 -0500
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DC4F53C12;
        Mon, 16 Jan 2023 02:45:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1673865942; x=1705401942;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=X1AjXfEDCXLxL5EPw69S+ypMrWCPKBkYCDWv5zZZiqA=;
  b=DUlEiz/snQNQA+4oo1XrvkU7OvzHCdfOaqgVSO4Kj49g/1Yw7nRzYM/v
   BIJcyF96s9wJ+6CNnRJl1s9hyXIAT1j3HrYzKy+k+siwa66GZQtCw0wfZ
   KdlRwYZ8L8hxscOBSThL8bwlX7i94XYhnWZJ01qT3JYR7Mk0HH5LXy76F
   hK8H7TuAN+sT8Aq0y7P2Vl6QhIkXvcpNR/nnhl2CUdvoqtUhALchaZsBP
   P4ezzgr3DmnE3NVyIL6NnbbaLrAvMDifO5TqNWPsELSwLhV3veSRi9ASP
   t2wrXNETOPgtgriYeIhrnj0AR6m8pibPasNRSmxCVYc3x/balNpxt5txk
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10591"; a="351684820"
X-IronPort-AV: E=Sophos;i="5.97,220,1669104000"; 
   d="scan'208";a="351684820"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Jan 2023 02:45:42 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10591"; a="747681844"
X-IronPort-AV: E=Sophos;i="5.97,220,1669104000"; 
   d="scan'208";a="747681844"
Received: from fmsmsx603.amr.corp.intel.com ([10.18.126.83])
  by FMSMGA003.fm.intel.com with ESMTP; 16 Jan 2023 02:45:42 -0800
Received: from fmsmsx612.amr.corp.intel.com (10.18.126.92) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Mon, 16 Jan 2023 02:45:42 -0800
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx612.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Mon, 16 Jan 2023 02:45:41 -0800
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Mon, 16 Jan 2023 02:45:41 -0800
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (104.47.66.48) by
 edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Mon, 16 Jan 2023 02:45:41 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=SHDzxe9nfYGlGdNRWgsTNmink9svkbnxGY8u7VDbCXszVAXSw3076s8F7dwS/mk7aAXdM/eE1cq4VVm/eorzFfzjm75lrUUUgTL/yg5OaBKF/cPzwsbPxh5dbvumU0ew5kQluZsP+Da+MymLl8ihO6eBGZ7y/IK1rOTxs6gWrc64eNtTY+ynBcueiltRvQKbyB8+yQszzrAqw8Ksk8bpLELP9bFNd1zNyshMuLPlUmSa7lvpq+M6bB74hAqkSt5uSEls6oKGoxUftYH58+0Zvxh+RqpJ6S3I/OkMlANOSyj13H/QGdYWmJ2rJSbVvWISCbq9PXFrKp6FdhX4xbXDFw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=X1AjXfEDCXLxL5EPw69S+ypMrWCPKBkYCDWv5zZZiqA=;
 b=ZxnRsaqZS0CEH53s4VpT/RZHqOAHLO2s7GNQkDyn5pJMvXx9tatHRtWhKU6l11+1m2ZiW/yQBM1Vt4Tn6CJMhnyvWchpgHMc0S8gV6H+PLrcgFP4ebvnlsr+reySBcUayIxfzU0FCEsIW4L/SRb059I8DC76h+n/Wa4gX0qYRYTsCKTDum/NdnAEbjfpQXHgAE2rPy1uUBCLsv4WXr0Hr5cA5WiS3JiI1MSA8Lga8bnvqAIOkBlyAIDfSnN6sOt8wvxQXfqowXc1RfwoH8Zp5L4CWpYdTNfOpLC1GCHp6LOAjKyve9tyyBaTfhgO6IZgnPTCOxKdWG6q1SvQn6u2dw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5978.namprd11.prod.outlook.com (2603:10b6:208:385::18)
 by DM8PR11MB5701.namprd11.prod.outlook.com (2603:10b6:8:20::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5986.23; Mon, 16 Jan
 2023 10:45:39 +0000
Received: from BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::3f19:b226:ebf1:b04a]) by BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::3f19:b226:ebf1:b04a%6]) with mapi id 15.20.5986.019; Mon, 16 Jan 2023
 10:45:39 +0000
From:   "Huang, Kai" <kai.huang@intel.com>
To:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Yamahata, Isaku" <isaku.yamahata@intel.com>
CC:     "chao.p.peng@linux.intel.com" <chao.p.peng@linux.intel.com>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "Shahar, Sagi" <sagis@google.com>,
        "Aktas, Erdem" <erdemaktas@google.com>,
        "isaku.yamahata@gmail.com" <isaku.yamahata@gmail.com>,
        "dmatlack@google.com" <dmatlack@google.com>,
        "Christopherson,, Sean" <seanjc@google.com>
Subject: Re: [PATCH v11 025/113] KVM: TDX: Use private memory for TDX
Thread-Topic: [PATCH v11 025/113] KVM: TDX: Use private memory for TDX
Thread-Index: AQHZJqT1W9twA85zy0OECuWgQSx4RK6g4goA
Date:   Mon, 16 Jan 2023 10:45:39 +0000
Message-ID: <b8f88a7b9b2ab00379e6b1afd6a7fdb409d35492.camel@intel.com>
References: <cover.1673539699.git.isaku.yamahata@intel.com>
         <4c3f5462852af9fd0957bb7db0b04a6f2d5639ee.1673539699.git.isaku.yamahata@intel.com>
In-Reply-To: <4c3f5462852af9fd0957bb7db0b04a6f2d5639ee.1673539699.git.isaku.yamahata@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.46.3 (3.46.3-1.fc37) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR11MB5978:EE_|DM8PR11MB5701:EE_
x-ms-office365-filtering-correlation-id: b4720223-1a0b-4e67-48dd-08daf7aecf10
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: cztQvZXJqIxU84m32ZBjhDb8hECQKmhqgZhcNCAkY2hfHiIt9bxS8CgVE2bnl4F1eXCOCClrxRtoyvCTgLKEIdv67U+HTLaRcrVyc3MARMkOswR8Sn4BKD6Bq2oSFe/VoC2jdDvP1s/BXulNApp173iMDM+Ardd349s183M4Wqs9en2CM7UW4OP6OaNu66M9Z74g/74EwrwR8JdrunYV5rBT0Zo5Xi79os9jZoXz/8/M7osmxiXZlceBDrg9D1NeJgs7kWs2hnsAiTECxrLiT8EIULjGeNV1ZMsR2pw47EYhFjTQwrSknJDGNz7PkwfprP1+siuQIEBnha3S0ATbB3N9ipVCYJt3TpZgh/VdR/qxp1IuNn1aH+ziwfxOl02RlLatAgqJO9J6HEfMeYaEC6hD/1NKyzMuwfdx3gSJJpeyFyvzo9k30rjcrF4IbPRjp5ZFUqKICWQ8+n9urSKDG5auuuBK267SZAAfW1YvjmJovNUkmXmyeDDshWhzxQhOYovNasgfTdTnaxvMGr5ipt0E0pGsGYTiIJWoeFcHlHa3lUG3pbTB17tIn7wfQrSaCxpa7mM2gh1UXZkfKQJGAvFrJUhR9ZUIAEjdFkOl9OLOfKm+ZlDCIe3nQ1fCPt4ecFSo4XZ4lP2KXswDxFkr0LjernW1OiKNTia9JdlYHtGc31YtRH6z/OSzh7/o7mL+TvAZF7P587GhH7WEiU/srMdqcmWm7lP+G9I5YGN0t4Q=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5978.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(346002)(376002)(396003)(136003)(39860400002)(366004)(451199015)(5660300002)(8936002)(41300700001)(2906002)(6636002)(36756003)(316002)(54906003)(110136005)(66476007)(66556008)(66946007)(71200400001)(66446008)(64756008)(966005)(8676002)(91956017)(6486002)(478600001)(4326008)(76116006)(6506007)(2616005)(122000001)(6512007)(38100700002)(82960400001)(26005)(38070700005)(186003)(86362001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?L3dnREJGQXAvQU5vKzA3ejFXYkhDMjF5YU1SenUxMFVtUGRzSDNDT2lTMzBZ?=
 =?utf-8?B?MnJXR0NJejlzV211KzkzTU1ySVE4dWI0d3ArUThmV3Z0R2NDelBScDljOE1s?=
 =?utf-8?B?UlVxRGhPY3lrRDMvdFhHNmlyTjdvNzM1RWV0UkhtTWMzU0luZjdCU2xLYkY1?=
 =?utf-8?B?RDVnUFZOYmllSXVvR0RFZTVod29heG5LTHhhcmZVaWJMa2s0U3RFUk9KdFdQ?=
 =?utf-8?B?MG55aEpFSlRLQk1KazRySGhLdFJOMTFyL3RacG9zVTc5VmcwdVh6RjlXNmxB?=
 =?utf-8?B?SmJ1REpPdVBiQUpPK0R4UnBmOWMrYW1CZzlkUGdUYzZFRlpjc3RkT21TVGRI?=
 =?utf-8?B?clh0ZUVDVnFhQ3JVWG5nN0hMWmtzSDFCQ2gxQnU0U3lKSEZ3Vi9aVG8vNVY1?=
 =?utf-8?B?M2g5OEF5bU9RSnpCZnV6MmVzMFVrSHVNNXF3N09RQ2Z0cWZWb3lqTit0T1pu?=
 =?utf-8?B?TjJkUDFCakowSzd5Nk1IZkdPVlRMUUF3U0NUR29FMFIrRDlPbUZ4TlBJTkZ1?=
 =?utf-8?B?S1A5UmFoQU1kUlFKK3YvcXhUNGhQWExHTGNtTE1aVlZuOWtENVNDSWo2UnpJ?=
 =?utf-8?B?OFBUaWhDNVg5L3NWcFAvVUNac0FuZ05TZVcrYmRuYXFZOGQwVDRRWml0Rmtt?=
 =?utf-8?B?akdFM3FHVis4R1l1L3JQN0YyMHUycyswbHUya0JBZDJvU3BvcGV0cDhoZ2c3?=
 =?utf-8?B?RkFlMGtOM1lDdDZjS3IvVFVMS096R0k5Ykt3YytNUys0bVdUcDJHeTQ2VEpY?=
 =?utf-8?B?V3loZkdtR2lVMGRoN1V0bjlibEtqRFJlVFd1SGlGVDgwU244UFBMeksrdTNJ?=
 =?utf-8?B?RTVEWGR3WWlzcVRocVVFckcrK1JTRklYRU5UUDdmb2FJQUZVdlZ5Rzh0ODRk?=
 =?utf-8?B?VVBhejlRWHJOdFVFa0l4RUNLbXU1YUM3a0MzUmNBZDByajd3ZjUxelY5bnFh?=
 =?utf-8?B?VlZLZWNnQ3ArcklFcXpTejQvdm9vUEZDZno1Z3h5aTZQdkxqWDNFajlJNnJv?=
 =?utf-8?B?bEprUUlGSTQ5dFA5WjgyMGNtalo2Q3F3OE1OMFVtVnM5SGFHRXdudDU5SnQ0?=
 =?utf-8?B?bnpYK3VldDNGNE9FZERyekYvVWoyNnR1QTUrbW05Sm43ZjZZYmFJWFNJYkJO?=
 =?utf-8?B?ZGtIWHYzUDFmM0U1NnJweGhCR1AzRG9SR0djdFA3TmNueE1JUEgvdis3U3dQ?=
 =?utf-8?B?STRZMHo2WDRneGQ0QlZ5U2trSGtlaVBXeDlKWUthMmhYMktRZXFhWUlwMUYr?=
 =?utf-8?B?VEpJUHoyUWtOUjhMRmR6c29BTHBsNXhMU3E5Q1kxTTgxSUdraG1NVEFZYXBq?=
 =?utf-8?B?ckw2TUtOK1BTajArVTRVOWg4ckJZQXZkd0N4Z0FRVmVXQ2hwRG5YZjZRdUhG?=
 =?utf-8?B?cmRtL2VpWVljd1JDaWtWRkN5SGNuSjJpUFVLa0p1bFh6c0FpYWpvLzFUbmw2?=
 =?utf-8?B?SnhPbHdEeXVUd0JUQm9taGZJbTd4MkczRTdSN3RKWm1NbjZxNzVZSEQwVzd2?=
 =?utf-8?B?SWIyOGJDSWNwSGxNZVhuVExqZmpMclhkMlhKSjBIRjBQMlVKN1AzT3lKaWZT?=
 =?utf-8?B?WUsvdDBHNEk0OTRmMW83MkpJVDZYcjdvZ29vQTNobUw4SnF0VWpUOG5rYk9D?=
 =?utf-8?B?NHZpMHNGOVYrZlRNK0FsYm1TU1JOYkk3Mll2dW1nbi8vODJpZzVnWG1YRy9r?=
 =?utf-8?B?WFl3eVRPUnpRczl1akVpNUcxTnVlaWhVcDFyNnV4KzJjbXp6M2ozR2hlVkNJ?=
 =?utf-8?B?MG1DL09WQVZxMysvOGI2M1pwUG5pM0dwQW1pRmFpU0ZrWlNYZ0Q2VFQxRWdN?=
 =?utf-8?B?YitMVmUwTmtUYnFJRVdtQ245elA1K1lSdjN6MCtJeWFnNjdFUU9yRnRwZnlx?=
 =?utf-8?B?UmFUZVJlWkdzc3hGaysxcWhDRlNCMm5NcW1aY3E3b0hKSmNKUldBUy9JcllY?=
 =?utf-8?B?NnE3bU4wTFV1SjJ4M3pJOUVldXZUQ0RxYmkzSXJIT0hwTHFVOFZxMWQzaXg1?=
 =?utf-8?B?TkJaZitjVUFQb2k1RHUrUGdxZ05TWFYvNWdPSUdYSk5OUElUTWtRVllKQklu?=
 =?utf-8?B?RXZwemd4cmNrYkZmdnk3N25GL3BReVRkY2FYMkN6UXhuMWRRRENZSlVLUEJR?=
 =?utf-8?B?VmU0QXlkVlRCQ2lENUVJTSt0SGpBYWxHanoyZ3BlbzdpbEFEZlI2ak94a2w1?=
 =?utf-8?B?Rnc9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <AF3ECAFE25E3E64094CB5962544F5EA3@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5978.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b4720223-1a0b-4e67-48dd-08daf7aecf10
X-MS-Exchange-CrossTenant-originalarrivaltime: 16 Jan 2023 10:45:39.6198
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: x+D/oyBbdp9xMOXrZnw6eZG3BcwgQgzFLdTB63mNK3fCnMihz+uRH9n+lKH1rTfs09cYkIgRpaBMikZKXBJelQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM8PR11MB5701
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
b20gd3JvdGU6DQo+IEZyb206IENoYW8gUGVuZyA8Y2hhby5wLnBlbmdAbGludXguaW50ZWwuY29t
Pg0KPiANCj4gT3ZlcnJpZGUga3ZtX2FyY2hfaGFzX3ByaXZhdGVfbWVtKCkgdG8gdXNlIGZkLWJh
c2VkIHByaXZhdGUgbWVtb3J5Lg0KPiBSZXR1cm4gdHJ1ZSB3aGVuIGEgVk0gaGFzIGEgdHlwZSBv
ZiBLVk1fWDg2X1REWF9WTS4NCj4gDQo+IFNpZ25lZC1vZmYtYnk6IENoYW8gUGVuZyA8Y2hhby5w
LnBlbmdAbGludXguaW50ZWwuY29tPg0KPiBTaWduZWQtb2ZmLWJ5OiBJc2FrdSBZYW1haGF0YSA8
aXNha3UueWFtYWhhdGFAaW50ZWwuY29tPg0KPiAtLS0NCj4gIGFyY2gveDg2L2t2bS94ODYuYyB8
IDUgKysrKysNCj4gIDEgZmlsZSBjaGFuZ2VkLCA1IGluc2VydGlvbnMoKykNCj4gDQo+IGRpZmYg
LS1naXQgYS9hcmNoL3g4Ni9rdm0veDg2LmMgYi9hcmNoL3g4Ni9rdm0veDg2LmMNCj4gaW5kZXgg
ZDU0OGQzYWY2NDI4Li5hOGI1NTU5MzVmZDggMTAwNjQ0DQo+IC0tLSBhL2FyY2gveDg2L2t2bS94
ODYuYw0KPiArKysgYi9hcmNoL3g4Ni9rdm0veDg2LmMNCj4gQEAgLTEzNDk4LDYgKzEzNDk4LDEx
IEBAIGludCBrdm1fc2V2X2VzX3N0cmluZ19pbyhzdHJ1Y3Qga3ZtX3ZjcHUgKnZjcHUsIHVuc2ln
bmVkIGludCBzaXplLA0KPiAgfQ0KPiAgRVhQT1JUX1NZTUJPTF9HUEwoa3ZtX3Nldl9lc19zdHJp
bmdfaW8pOw0KPiAgDQo+ICtib29sIGt2bV9hcmNoX2hhc19wcml2YXRlX21lbShzdHJ1Y3Qga3Zt
ICprdm0pDQo+ICt7DQo+ICsJcmV0dXJuIGt2bS0+YXJjaC52bV90eXBlID09IEtWTV9YODZfVERY
X1ZNOw0KPiArfQ0KPiArDQoNCkFNRCdzIHNlcmllcyBoYXMgYSBkaWZmZXJlbnQgc29sdXRpb246
DQoNCmh0dHBzOi8vbG9yZS5rZXJuZWwub3JnL2xrbWwvMjAyMjEyMTQxOTQwNTYuMTYxNDkyLTMt
bWljaGFlbC5yb3RoQGFtZC5jb20vDQoNCkkgdGhpbmsgc29tZWhvdyB0aGlzIG5lZWRzIHRvIGdl
dCBhbGlnbmVkLg0KDQpTaW1wbHkgY2hlY2tpbmcgd2hldGhlciBWTSBpcyBURCBjZXJ0YWlubHkg
d29uJ3Qgd29yayBmb3IgQU1ELCBzbyBteSBmaXJzdA0KZ2xhbmNlIHdlIHNob3VsZCB1c2Ugc29t
ZXRoaW5nICBzaW1pbGFyIHRvIEFNRCdzIHNvbHV0aW9uLiAgQnV0IEkgaGF2ZW4ndA0KdGhvdWdo
dCB0aG9yb3VnaGx5IHRoYXQgaXMgYWJzb2x1dGVseSBuZWVkZWQsIGZvciBpbnN0YW5jZSwgcGVy
aGFwcyB3ZSBjYW4gdXNlDQonZ2ZuX3NoYXJlZF9tYXNrJywgZXRjLg0KDQo=
