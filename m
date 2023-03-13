Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 110016B6CD4
	for <lists+kvm@lfdr.de>; Mon, 13 Mar 2023 01:31:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229543AbjCMAb5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 12 Mar 2023 20:31:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57248 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229450AbjCMAbz (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 12 Mar 2023 20:31:55 -0400
Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 62FAC39BAF;
        Sun, 12 Mar 2023 17:31:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1678667514; x=1710203514;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=L/g5oQHNnAekwHaL0QvRMWQn93vaY96mYxYkc86lUZg=;
  b=WdETppblu++FBPcYNy/20LGLaNbblsotKb2gSCkh1FDzWeFSv8ZVkkFx
   u+A38M1xD8urI8ELk4Vqn0GrdGpa35JP5D0rXJ9bIoRyR7CqcguFwU068
   riC0BDDfyAaGmZUyVhLNy7PrXHtiCdHHUYRcwjdxI/9cCeqyQPIGW0TFb
   p9PyfsQMNiP+8Y/Q8flouZBSxiQXiphEoIqY10rufQt7B4Fpe2+FNpri2
   1ntHQCjN4FyDd4ELmu3huw39UWiQ5VazSYvPbFG87E4a8kPZYLe5zIn5T
   A2Hx4vl7vUWUM2OCGSu34NOaW0XZ2eEDIMoTV4PO4gffyfNx/AaS5iNL8
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10647"; a="317421782"
X-IronPort-AV: E=Sophos;i="5.98,254,1673942400"; 
   d="scan'208";a="317421782"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Mar 2023 17:31:54 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10647"; a="788744618"
X-IronPort-AV: E=Sophos;i="5.98,254,1673942400"; 
   d="scan'208";a="788744618"
Received: from fmsmsx603.amr.corp.intel.com ([10.18.126.83])
  by fmsmga002.fm.intel.com with ESMTP; 12 Mar 2023 17:31:53 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Sun, 12 Mar 2023 17:31:53 -0700
Received: from fmsmsx601.amr.corp.intel.com (10.18.126.81) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Sun, 12 Mar 2023 17:31:53 -0700
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21 via Frontend Transport; Sun, 12 Mar 2023 17:31:53 -0700
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (104.47.55.171)
 by edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.21; Sun, 12 Mar 2023 17:31:53 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=W7TEmUcRn+E7oq3ceSVkClMxXm4Hj3umlnUC7uVOaB2UO9WUofpUOgiQo8mANi9QY8rpHNr1wHCisjgI5q0xxViiuqw8aypIiN+ySX5vxOu0GSsye8TIllu4Pqly6aGTpGJaMSUjtRWHaxUNq1U+gAgj5ifM9dFwJzB+soSrieb4UiJPR7+oWoirZNqxNSpNUGiyDLgy1502k3B0oKgrpsRLtY5B/PgYSlitzDIsueB6O4L8CB6WBRIKoMgWi/wgDePJBF6U2GseS1/7zM/5Ps7Eaer5WAysSRuip2B8hNRyvXIoNO1yTKwI1lQjttMUjAtobdkAYKBaSmwMYngcnw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=L/g5oQHNnAekwHaL0QvRMWQn93vaY96mYxYkc86lUZg=;
 b=LupqqEggjFieaLsIdN1SVYg2hsaNklSXbSDTIc9SKGWaZyCYvMkWWirFeF2azF6xDS+Ytgy6TzIMuyDwmkORPhaQBiiozpzwZy7I5HdpxYk2kChFYxf1Hbfr9Y+87JJptpRWpcQP1HFNkLY6LDHyxl/cdaVi8+hp+0bYLPTsMoLNmX4mKUyeW70am5M8jGLK5boIfI/HgBpre/LhMiAtbCXMKuvi/21E1GvGSBFoEkQXxtbrZbzy9totF2j9XUVIT3aqqUWeE+G2+puhq7wIF96o+UFiua91NWCNnJUSv7GNCCRDz21WgXuvGU/4K0k5HbJB99lmhyy7AXqcyAZvDw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5978.namprd11.prod.outlook.com (2603:10b6:208:385::18)
 by SN7PR11MB7995.namprd11.prod.outlook.com (2603:10b6:806:2e2::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.24; Mon, 13 Mar
 2023 00:31:49 +0000
Received: from BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::f403:a0a2:e468:c1e9]) by BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::f403:a0a2:e468:c1e9%5]) with mapi id 15.20.6178.024; Mon, 13 Mar 2023
 00:31:49 +0000
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
Subject: Re: [PATCH v2 02/18] x86/reboot: Expose VMCS crash hooks if and only
 if KVM_INTEL is enabled
Thread-Topic: [PATCH v2 02/18] x86/reboot: Expose VMCS crash hooks if and only
 if KVM_INTEL is enabled
Thread-Index: AQHZU5lISsWrsOG2RkqqMnGPjlbwcq733zCA
Date:   Mon, 13 Mar 2023 00:31:49 +0000
Message-ID: <a3e58e90a6b26019633afeef9162720ef39c5e03.camel@intel.com>
References: <20230310214232.806108-1-seanjc@google.com>
         <20230310214232.806108-3-seanjc@google.com>
In-Reply-To: <20230310214232.806108-3-seanjc@google.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.46.4 (3.46.4-1.fc37) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR11MB5978:EE_|SN7PR11MB7995:EE_
x-ms-office365-filtering-correlation-id: afcce1a8-388f-497a-0926-08db235a55d2
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: QYw1XsSc5B2sYvuw0tkLuXNpMbcRvGp8PkLANRDEpJzvwB+FwyJLxZr22yCEbscrKM8wKJJ9aamhmDwp9RjoylcF5iA7LoviwERhGhnb6F+SiDxWcZ199vYjg4EsmC4ytPg0yTUQQlbmaJ6G49tHPjWGv97OB5WITziDuHmd3r21lkPGs+OW/XjlSNlqDM2BB2PUwqd/06RE9Z4VOAHbEhTgS+3CZPDXhgKJHYa/UYGehm5UqbokTqXw7mrKlrN5JViS4C9NAusH2TSf0IkKszDknDEVf1+X2RzMPRNeUKIaY6cerNidva7SvCQHpOPnZd+YXmGoR1SoRwl70wLgo4nN4eZaWwKwTtdy6mZSpPLbnfa1GeRoeLyVB4fi4EWFzhJPCQm1WO1Mor1zoG/V13h7dtqaG6mZbb3tcnZiDq7sjcB0mA//xWWxMk5UG/unetUdjr6bLxCka7lYlkaQsWHhfOs+Oowq3Mrqi0vt/vRx3g5RVK60JhIZ7oaj9MHhIBiYY4wRD3h157vdgD8tm4QqrHEpB3j4Hu3fJ88XUTLhVj5m/7CXtYVjx/6XsHnwLCLd0lYLK70yUZ8CbArxagD4BBiRSVatgNm9nGfU6sZiMrw1l8kWlR57SDRTUWLqtNB2ZdZVwLZbi4HJn2CAoDupnEbic504FEvRv/RqcnSnrFPLV8Hs4xA7lmET9wbzuG9h4cOB9bV7YqkV8otYFg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5978.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(39860400002)(346002)(396003)(136003)(366004)(376002)(451199018)(6486002)(2906002)(82960400001)(83380400001)(26005)(36756003)(6512007)(6506007)(5660300002)(8936002)(186003)(71200400001)(8676002)(86362001)(41300700001)(91956017)(38070700005)(2616005)(4326008)(7416002)(66446008)(66556008)(76116006)(64756008)(66946007)(66476007)(478600001)(122000001)(110136005)(38100700002)(316002)(54906003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?R1g4bkloalRHTkpsRzA0NGJvL3c5R01IejhmYzZQcU8xK1dsQmdyczlMUHVr?=
 =?utf-8?B?bWJZTnRMMjBuZmtVQXU2cGxhWDIyZHRablE4SExubjc0ZDN1ekIwM2tHU2FS?=
 =?utf-8?B?aThzNnhqUlpxL0FRM1FJOEFhNmpmYzdnQm5SYXcvaTdNNG8xMk50L0JlRlMr?=
 =?utf-8?B?eUMvR0gxTHNRL2R5QlEwTSsrdVNYMVFjRFdNc0pqemh2QWNBN1NjcHR1bXNX?=
 =?utf-8?B?cmhPOTRrUCtoa3lvY21FY0NhbngrZGRaODVYUDVkQWpDMXVWVjhPdFJwajNn?=
 =?utf-8?B?eElDSUFpUmpQU1NyMkRpSXpnMmdaWDFkbyswajhWRWdJYm10TWtDU1dlcGVt?=
 =?utf-8?B?OWU5NjYzTFhRckdCSU4rV3dpUlEyajNHcTN5YUIvT3htQmZ0U2ZwTjRKUERC?=
 =?utf-8?B?UU1uZ2Y0VTVOdGZtRmhTMXFlZ0tFYkNPUUt3OUtqbG03UzlhbjZzYVR3Rjhq?=
 =?utf-8?B?dUkrdXRxT2l6Vm5UaEExUlV5Y0U4S2JJQUYrUnJWZmtESjVHNG5QbXc0Uzhk?=
 =?utf-8?B?UFFPb3F3d0ZHWWlSeENVOW44MG9NMkpMN2dJcjk5bXd6NzNkZEpvekZFMkhn?=
 =?utf-8?B?NmxFTi9KY2ZaNEIyNUZvM3BRaW85RVhITkpTSkpHVGFsRncvb2ZCeUtkNnBP?=
 =?utf-8?B?VEhWUTcybktYcFpqL0hHVVRlS2hlSkF2a0dWL0RxVWVlZldlVXR2ZUlPaDdu?=
 =?utf-8?B?V2FldE85dWFEVThsdWoralZhVGhnaHAyOFNYam4rSEpodFk2Zy91RkpyZnkz?=
 =?utf-8?B?aDVrRUUzZFM1dTcxV3d2NUo2Z2xKS3J1TkV6eUI2WU5ENlB5WGFiOHVIU21p?=
 =?utf-8?B?UDVUeGZ2RHBvMUEyQWtLUGNrVFBYL1V2aUVNVzVxQ1JsTFA3WXoxZVZqTGRW?=
 =?utf-8?B?Y1loZHUzTjlGSEpFMjloemtOT0ZjTmZIUWt3OURYWkViVnIrL2RXQUZsbDF0?=
 =?utf-8?B?TFI1NGFBQyt5d0pIeFZNeVpmMmErSVlxMnFLMDRReThWUWdqODJjdDljM0JO?=
 =?utf-8?B?cVQ3MTBjOUdLek1sRlBNTzNpcnhrOEZoMzB3S3kxbDRITElraEN3OTd6U1Nr?=
 =?utf-8?B?K2RQYlo4RG9yL1JybHhMNGV4OVFQNlJDNm1idVJsL2dRekY0c2h3RS9zZFpO?=
 =?utf-8?B?YnZpbTNpOUNpckxueVFVTmIrOUdib2dmc3RUdmJ0YXNEa0ZzLzd2RHI4UE9Z?=
 =?utf-8?B?dzZVS0VIa3lhQTRFdUVadU91c3BicG5sa0dRVzNjbGQrTW5DbDNqRnZraExD?=
 =?utf-8?B?RU05ZGJjSGx1MUVVdnQ3ZWVMNnhSUjNkRnBESUFVYUtUTkRmTXRpSU16aUho?=
 =?utf-8?B?bFJoblFjdUdCMjYvbFNpOEt3R1FRMDVwblZBY3B2MU5ON1VSUThmVGlZY1pq?=
 =?utf-8?B?Z2dsajBBelFTY3k0U0FiWHRFMTJ5YWJOWVlBbW5BOUZ2UmVScjdOU3AwRkx0?=
 =?utf-8?B?Qm5zQWNNM0JyblBUaDNjaVZUUUUyTHd6ZmNSdWxnUVdyL0R4OU9POXFvWERW?=
 =?utf-8?B?UmtyWGg5UytLQTkwODBTWlNUQ24wRTRpSU5kaTF0OWZLTTQrQXV1c3daYXY0?=
 =?utf-8?B?VmNRcjExazJxbUJJMExuL0RLT1EydVk0QldobVRzenp0a2wwOU03Q2U2bXN5?=
 =?utf-8?B?VzlqaCtSSkpFZkpPS0Z6dWFqTjhLczdNQVBpQisyOWEzOG5VS2RHaVMzWlhD?=
 =?utf-8?B?TVl4QWdUSUp5ZEN5U3VGU09ZcVJyMnlwayt4VEJ6QmRyUXBkZ2dWa09STW9h?=
 =?utf-8?B?OW9sU1loS1JGRHg5ZVNKYkh2TENUNjk0YUhXQ2lXUk5zZUgxOGdOZlhlUlFo?=
 =?utf-8?B?d0xqNUY5d2E2WmxnTk40dnhudGtBRW5Ca09JVDBuZU44UHF3QmpmaSs1bzhr?=
 =?utf-8?B?Tmxob3FBSm5WMFI3MHZ5MkEzNkRtaTQyckJsN25UNm1YVTlLYmdmb3doaGJZ?=
 =?utf-8?B?Y2Y1TGtTcENYVk1hWDIyQnZqczlQVUp5QzRSaHU3alc1L291OTdwbWJTclho?=
 =?utf-8?B?bXBMblFwUDhnYkdBajdTMGx4Q211OEp4QkxFQ0hJdy9oQzdRY2FvcWIyL0JF?=
 =?utf-8?B?S1VHalJHd2RXMyt6aEQ3dkhqOVduWlBWdmU0U21BZTBCZzU0QjZJVWg5TzRy?=
 =?utf-8?B?VGZpakpjeU9tcmhFUVdFVU9Bd0sxNDVaK1ZTQkdmU2tlUFgzQUkwcy9RUTYv?=
 =?utf-8?B?MlE9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <7B65EF9743A11A47BBBE9715FF508B16@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5978.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: afcce1a8-388f-497a-0926-08db235a55d2
X-MS-Exchange-CrossTenant-originalarrivaltime: 13 Mar 2023 00:31:49.6601
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: zRHZIYukxfrdOJimouNoJTecdhuJglHYhAbNasVJCVcqAf7Cpw47q8BtZi3BrP6+r39J+B+J7oubVMl1Vx5NMA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR11MB7995
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

SGkgU2VhbiwNCg0KVGhhbmtzIGZvciBjb3B5aW5nIG1lLg0KDQpPbiBGcmksIDIwMjMtMDMtMTAg
YXQgMTM6NDIgLTA4MDAsIFNlYW4gQ2hyaXN0b3BoZXJzb24gd3JvdGU6DQo+IEV4cG9zZSB0aGUg
Y3Jhc2gvcmVib290IGhvb2tzIHVzZWQgYnkgS1ZNIHRvIGRvIFZNQ0xFQVIrVk1YT0ZGIGlmIGFu
ZA0KPiBvbmx5IGlmIHRoZXJlJ3MgYSBwb3RlbnRpYWwgaW4tdHJlZSB1c2VyLCBLVk1fSU5URUwu
DQo+IA0KPiBTaWduZWQtb2ZmLWJ5OiBTZWFuIENocmlzdG9waGVyc29uIDxzZWFuamNAZ29vZ2xl
LmNvbT4NCj4gLS0tDQo+ICBhcmNoL3g4Ni9pbmNsdWRlL2FzbS9yZWJvb3QuaCB8IDIgKysNCj4g
IGFyY2gveDg2L2tlcm5lbC9yZWJvb3QuYyAgICAgIHwgNCArKysrDQo+ICAyIGZpbGVzIGNoYW5n
ZWQsIDYgaW5zZXJ0aW9ucygrKQ0KPiANCj4gZGlmZiAtLWdpdCBhL2FyY2gveDg2L2luY2x1ZGUv
YXNtL3JlYm9vdC5oIGIvYXJjaC94ODYvaW5jbHVkZS9hc20vcmVib290LmgNCj4gaW5kZXggMjU1
MWJhZWM5MjdkLi4zM2M4ZTkxMWUwZGUgMTAwNjQ0DQo+IC0tLSBhL2FyY2gveDg2L2luY2x1ZGUv
YXNtL3JlYm9vdC5oDQo+ICsrKyBiL2FyY2gveDg2L2luY2x1ZGUvYXNtL3JlYm9vdC5oDQo+IEBA
IC0yNSw4ICsyNSwxMCBAQCB2b2lkIF9fbm9yZXR1cm4gbWFjaGluZV9yZWFsX3Jlc3RhcnQodW5z
aWduZWQgaW50IHR5cGUpOw0KPiAgI2RlZmluZSBNUlJfQklPUwkwDQo+ICAjZGVmaW5lIE1SUl9B
UE0JCTENCj4gIA0KPiArI2lmIElTX0VOQUJMRUQoQ09ORklHX0tWTV9JTlRFTCkNCj4gIHR5cGVk
ZWYgdm9pZCBjcmFzaF92bWNsZWFyX2ZuKHZvaWQpOw0KPiAgZXh0ZXJuIGNyYXNoX3ZtY2xlYXJf
Zm4gX19yY3UgKmNyYXNoX3ZtY2xlYXJfbG9hZGVkX3ZtY3NzOw0KPiArI2VuZGlmDQo+ICB2b2lk
IGNwdV9lbWVyZ2VuY3lfZGlzYWJsZV92aXJ0dWFsaXphdGlvbih2b2lkKTsNCj4gIA0KPiAgdHlw
ZWRlZiB2b2lkICgqbm1pX3Nob290ZG93bl9jYikoaW50LCBzdHJ1Y3QgcHRfcmVncyopOw0KPiBk
aWZmIC0tZ2l0IGEvYXJjaC94ODYva2VybmVsL3JlYm9vdC5jIGIvYXJjaC94ODYva2VybmVsL3Jl
Ym9vdC5jDQo+IGluZGV4IDI5OWI5NzBlNWY4Mi4uNmMwYjE2MzRiODg0IDEwMDY0NA0KPiAtLS0g
YS9hcmNoL3g4Ni9rZXJuZWwvcmVib290LmMNCj4gKysrIGIvYXJjaC94ODYva2VybmVsL3JlYm9v
dC5jDQo+IEBAIC03ODcsNiArNzg3LDcgQEAgdm9pZCBtYWNoaW5lX2NyYXNoX3NodXRkb3duKHN0
cnVjdCBwdF9yZWdzICpyZWdzKQ0KPiAgfQ0KPiAgI2VuZGlmDQo+ICANCj4gKyNpZiBJU19FTkFC
TEVEKENPTkZJR19LVk1fSU5URUwpDQo+ICAvKg0KPiAgICogVGhpcyBpcyB1c2VkIHRvIFZNQ0xF
QVIgYWxsIFZNQ1NzIGxvYWRlZCBvbiB0aGUNCj4gICAqIHByb2Nlc3Nvci4gQW5kIHdoZW4gbG9h
ZGluZyBrdm1faW50ZWwgbW9kdWxlLCB0aGUNCj4gQEAgLTgwNyw2ICs4MDgsNyBAQCBzdGF0aWMg
aW5saW5lIHZvaWQgY3B1X2NyYXNoX3ZtY2xlYXJfbG9hZGVkX3ZtY3NzKHZvaWQpDQo+ICAJCWRv
X3ZtY2xlYXJfb3BlcmF0aW9uKCk7DQo+ICAJcmN1X3JlYWRfdW5sb2NrKCk7DQo+ICB9DQo+ICsj
ZW5kaWYNCj4gIA0KPiAgLyogVGhpcyBpcyB0aGUgQ1BVIHBlcmZvcm1pbmcgdGhlIGVtZXJnZW5j
eSBzaHV0ZG93biB3b3JrLiAqLw0KPiAgaW50IGNyYXNoaW5nX2NwdSA9IC0xOw0KPiBAQCAtODE4
LDcgKzgyMCw5IEBAIGludCBjcmFzaGluZ19jcHUgPSAtMTsNCj4gICAqLw0KPiAgdm9pZCBjcHVf
ZW1lcmdlbmN5X2Rpc2FibGVfdmlydHVhbGl6YXRpb24odm9pZCkNCj4gIHsNCj4gKyNpZiBJU19F
TkFCTEVEKENPTkZJR19LVk1fSU5URUwpDQo+ICAJY3B1X2NyYXNoX3ZtY2xlYXJfbG9hZGVkX3Zt
Y3NzKCk7DQo+ICsjZW5kaWYNCj4gIA0KPiAgCWNwdV9lbWVyZ2VuY3lfdm14b2ZmKCk7DQoNCklu
IHRoZSBjaGFuZ2Vsb2cgeW91IG1lbnRpb25lZCB0byBleHBvc2UgdGhlICpob29rcyogKHBsdXJh
bCkgdXNlZCB0byBkbw0KIlZNQ0xFQVIrVk1YT0ZGIiBvbmx5IHdoZW4gS1ZNX0lOVEVMIGlzIG9u
LCBidXQgaGVyZSBvbmx5ICJWTUNMRUFSIiBpcyBlbWJyYWNlZA0Kd2l0aCBDT05GSUdfS1ZNX0lO
VEVMLiAgU28gZWl0aGVyIHRoZSBjaGFuZ2Vsb2cgbmVlZHMgaW1wcm92ZW1lbnQsIG9yIHRoZSBj
b2RlDQpzaG91bGQgYmUgYWRqdXN0ZWQ/DQoNClBlcnNvbmFsbHksIEkgdGhpbmsgaXQncyBiZXR0
ZXIgdG8gbW92ZSBWTVhPRkYgcGFydCB3aXRoaW4gQ09ORklHX0tWTV9JTlRFTCB0b28sDQppZiB5
b3Ugd2FudCB0byBkbyB0aGlzLg0KDQpCdXQgSSBhbSBub3Qgc3VyZSB3aGV0aGVyIHdlIHdhbnQg
dG8gZG8gdGhpcyAoaGF2aW5nIENPTkZJR19LVk1fSU5URUwgYXJvdW5kIHRoZQ0KcmVsZXZhbnQg
Y29kZSkuICBJbiBsYXRlciBwYXRjaGVzLCB5b3UgbWVudGlvbmVkIHRoZSBjYXNlIG9mIG91dC1v
Zi10cmVlDQpoeXBlcnZpc29yLCBmb3IgaW5zdGFuY2UsIGJlbG93IGluIHRoZSBjaGFuZ2Vsb2cg
b2YgcGF0Y2ggMDQ6DQoNCglUaGVyZSdzIG5vIG5lZWQgdG8gYXR0ZW1wdCBWTVhPRkYgaWYgS1ZN
IChvciBzb21lIG90aGVyIG91dC1vZi10cmVlwqANCgloeXBlcnZpc29yKSBpc24ndCBsb2FkZWQv
YWN0aXZlLi4uDQoNClRoaXMgbWVhbnMgd2Ugd2FudCB0byBkbyBoYW5kbGUgVk1DTEVBUitWTVhP
RkYgaW4gY2FzZSBvZiBvdXQtb2YtdHJlZSBoeXBlcnZpc29yDQp0b28uICBTbywgc2hvdWxkbid0
IHRoZSBob29rcyBhbHdheXMgZXhpc3QgYnV0IG5vdCBvbmx5IGF2YWlsYWJsZSB3aGVuIEtWTV9J
TlRFTA0Kb3IgS1ZNX0FNRCBpcyBvbiwgc28gdGhlIG91dC1vZi10cmVlIGh5cGVydmlzb3IgY2Fu
IHJlZ2lzdGVyIHRoZWlyIGNhbGxiYWNrcz8NCg0KDQo+ICAJY3B1X2VtZXJnZW5jeV9zdm1fZGlz
YWJsZSgpOw0KPiAtLSANCj4gMi40MC4wLnJjMS4yODQuZzg4MjU0ZDUxYzUtZ29vZw0KPiANCg0K
