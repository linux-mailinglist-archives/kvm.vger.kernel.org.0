Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CFBE66A6469
	for <lists+kvm@lfdr.de>; Wed,  1 Mar 2023 01:49:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229804AbjCAAtR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 28 Feb 2023 19:49:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50190 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229510AbjCAAtP (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 28 Feb 2023 19:49:15 -0500
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BB89B22003;
        Tue, 28 Feb 2023 16:49:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1677631754; x=1709167754;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=i6xdXO4agZJhDvaXNdtD50rjoXHOXOnUe0SOOroiOHU=;
  b=nnuUiFrZI4RERGMrhB3F41PgF5GLrvIJAkUE8Pb+EfJosJPDyVZwHz9+
   5cFioAxiKCN9ISmtiJdu5UHfjHHL44zLCUcIXlfq93/QH9+mQp86129cO
   +RVE4JciWhFIi65pHXXo3021LFBRv6NwCtbsO2V6EB/nxTtarM9z6BRw3
   kIEIIpj5FSilcKW/u3sewzQe5dTOx0YROXI0aGsSAd2PI6jWPbtDhI2bN
   U28qFEs+gFbxi1sIMWYn2XT5TdDg17jlyo3Bu8kmmyQu10tG4mr/+GeAH
   DgOhTCUWkIWJXUKeKrclN+G2olt9FN56NujuZ6Bxzw1KjQqB/RRdzRq4l
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10635"; a="318086697"
X-IronPort-AV: E=Sophos;i="5.98,223,1673942400"; 
   d="scan'208";a="318086697"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Feb 2023 16:49:13 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10635"; a="817320379"
X-IronPort-AV: E=Sophos;i="5.98,223,1673942400"; 
   d="scan'208";a="817320379"
Received: from orsmsx601.amr.corp.intel.com ([10.22.229.14])
  by fmsmga001.fm.intel.com with ESMTP; 28 Feb 2023 16:49:12 -0800
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Tue, 28 Feb 2023 16:49:12 -0800
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Tue, 28 Feb 2023 16:49:11 -0800
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21 via Frontend Transport; Tue, 28 Feb 2023 16:49:11 -0800
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (104.47.56.177)
 by edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Tue, 28 Feb 2023 16:49:10 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=VEOTRpd/vDcFP/CW/+OZ2mzpdvUyFdDYhWpqu77LOEtq06Q8oPfhS+tcqP46QR1zzajmJlU5t+ibwtA0B/wQLKXEN9tAxl6YZ7R5JPmVhJ4h6gfI1RivohytaGz7X+BSaihDX6K7lcOsak+R68FxWmC3bHAcAsF7mjGQ3roUdEBLGsqU+6ZEAI/HA8HsJlnb6WuUL/qi1zZ0z5mBKU6Kx9dbasAsOdKNd4Rp2yeL96HVDz1TcATj8R9+lT/Icy/wgiEEuhDQq7E4PFRBe4S435Ry5ShRddeEbWUfsyUDXTxw+YWpqzw/2YcJJCEBbUzGwEBJWjCuXRrpa6YE4hBeMg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=i6xdXO4agZJhDvaXNdtD50rjoXHOXOnUe0SOOroiOHU=;
 b=SjRDciuU6dbWVTtH6db6NIts10koJLE/bSZ6OpiapIHVNPPLYMknmZxWVfaaXAtoMm+1+xIMkUpro4Q7ujfUCuMkCHLeUL7unn8i5uIu7yjlqeZyafBjtRCEG7ZaDtS3cKlIqMDEhTWP8cz5YbiyeiXVJ6zkuFr/kpbAl8ggyaB0/XJ/IoAwvrp9EilGeQTYwamqrWkTMEOQHfP1fM+mdnx/ZuCGQ5YNE//pQul74vcNucfdAqsi/H1tawumJVECZ9Lp77JRGl6r4KxmnqRPVhXZusOw+Nga31dyezK4vcWSzvJf3ddiOonNhUC3CQ6gZsgjIyU+0xstGrJkSMqq0g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5978.namprd11.prod.outlook.com (2603:10b6:208:385::18)
 by SA3PR11MB7628.namprd11.prod.outlook.com (2603:10b6:806:312::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6134.29; Wed, 1 Mar
 2023 00:49:06 +0000
Received: from BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::f403:a0a2:e468:c1e9]) by BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::f403:a0a2:e468:c1e9%4]) with mapi id 15.20.6134.029; Wed, 1 Mar 2023
 00:49:06 +0000
From:   "Huang, Kai" <kai.huang@intel.com>
To:     "isaku.yamahata@gmail.com" <isaku.yamahata@gmail.com>
CC:     "Christopherson,, Sean" <seanjc@google.com>,
        "Shahar, Sagi" <sagis@google.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Aktas, Erdem" <erdemaktas@google.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "Yamahata, Isaku" <isaku.yamahata@intel.com>,
        "dmatlack@google.com" <dmatlack@google.com>
Subject: Re: [PATCH v11 023/113] KVM: TDX: allocate/free TDX vcpu structure
Thread-Topic: [PATCH v11 023/113] KVM: TDX: allocate/free TDX vcpu structure
Thread-Index: AQHZJqT+Gmb2zZevo06P/V36G5cIjK6k8UOAgD+K4ACAAAz4gIAAjWEAgAAZMQCAAC5mAIAAA94A
Date:   Wed, 1 Mar 2023 00:49:06 +0000
Message-ID: <033e4e9c870046027e51f5811aa6c2ac64389987.camel@intel.com>
References: <cover.1673539699.git.isaku.yamahata@intel.com>
         <db53b2c6c7718df7df89bb36b83257a2588b58e1.1673539699.git.isaku.yamahata@intel.com>
         <76cd219cadf3f5e06eb10b592de121ed0db056eb.camel@intel.com>
         <20230228110632.GV4175971@ls.amr.corp.intel.com>
         <7dd3b2a9406bdfd574ae12f0f4651e3fe6c4b82a.camel@intel.com>
         <20230228201858.GY4175971@ls.amr.corp.intel.com>
         <a455c53dc1cdf81790f2996056cdd13cff482d9b.camel@intel.com>
         <20230301003512.GA3852341@ls.amr.corp.intel.com>
In-Reply-To: <20230301003512.GA3852341@ls.amr.corp.intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.46.3 (3.46.3-1.fc37) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR11MB5978:EE_|SA3PR11MB7628:EE_
x-ms-office365-filtering-correlation-id: ae0a6d66-ee17-4041-c842-08db19eec2a3
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: /Zw0hNoTs8J9UMVETarBrf9x2iNChzR4r08PynngkAs7rHmupEtQlhhbdStbZvhTosiGJ01J3q4l+FXdChAebLEZVnRbkEtra3aSpX2XGczfgIgSAPS9rhUUfIuL8wlpJBDgqVxmIr/4e8pnuIAyYN5mCPY7qJloOv19Dq7k2OzkzLo38TUKNFI10fgo1vW1jHm2O9KU1WVe7LGEREawIc5afsSnECzRMnt+u6EWygmrF2oodei4ie/QCBEVFavtAs7TvckktS92ITuM4eGDJxfrW5BAe7e6K/VXqAbi6U+ZD/5Vx1S720N3OM/Wpy6GMrWP8rnWqblDID3sEU5xLWVxg/I+P66ipldSH/NWb0xlt4GDrECoj/URpec/6wVEf2lj+dC6XZrnWiJLfXitdjxH2SQ7//1dvcnAI/ZfazQtqq3QAkjorVUKanPBqMmf5VrR0Er+m5wEwHPuTJIxUcJJyzb/UheGsvQHpjix7NRX9kVA6osUhzsJS8HRwBzdBWOQ4B9HclaL5paFQVCSZU76gzWEoPA70dSb2OD1o1vARs9Tqv9z0A4aHXlBgc/CjToxQQ03Hj/kH2wyCJOHhEBOQkuPCL4JK4cqMQlpRX4KBwN/hFcyMhDOamdIaAuSeGIAOzF1Gc6Hfh1jegjJZLefgOibehPfijs8D5c7fDyf/i5Zc+W65dEvoKsEf7sfYS2PycLNFD1NUd/NKNl/cw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5978.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(39860400002)(376002)(346002)(136003)(366004)(396003)(451199018)(54906003)(36756003)(316002)(478600001)(5660300002)(86362001)(8936002)(2906002)(6486002)(71200400001)(66446008)(91956017)(64756008)(6916009)(4326008)(76116006)(66946007)(8676002)(41300700001)(66556008)(122000001)(82960400001)(66476007)(38070700005)(26005)(186003)(6506007)(83380400001)(2616005)(6512007)(38100700002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?T2RxN1VpOVBBbElUdHdjVHhPWkF4andqekxxRHFZVVZXVDdLRWZ3QVdoc3dJ?=
 =?utf-8?B?b2lzREFJMGp5ZkFyUW5rN1ZFeE13alVlODVlaGZVZG5GR2FuOWtxN1pzN2Fi?=
 =?utf-8?B?TUJuVWZuc1ZidExNMk1kVHMzekRIOTlEVjRvNnkwVjN3ZVZjeERvMUQ0aXZL?=
 =?utf-8?B?RER0cS9OUm1zd2hMdGZpQnBZWm5wQlRQR1JocVU1T3hOOXFVOXMrbFZZcXVQ?=
 =?utf-8?B?NjU5d1IxZERXc3p4aTVaQ01mVFFQdm9WWXNuWjlZaTg1Q3Zmd1FYaWd5Yysz?=
 =?utf-8?B?aE91ZDhzazdjMVBvOXlqZHdyVkRuck9qR2lPWjFFNkJKYXJmNVVacmUwbGRl?=
 =?utf-8?B?KzBMMHpkQ3hqcGh6L2EzaWdrMmRCY1RxNWFLalpWTHlVeFM0TlBTbXQyZlZL?=
 =?utf-8?B?MUZ1cEg0eXlZUmpTUVJLdERTSFpyNHAvaDhpbk5UbTEyNWloTHJvUGJTeTN5?=
 =?utf-8?B?TEhSaEdEcy9UV2pScjVjbGtuQlpHam1VU1hKNXdsL3AxMnVIUW5xS3dNZ3Zn?=
 =?utf-8?B?R0RNQ2xad0EvMkV4N1VQbVhrWnNtTEZFYW16MC9wT2NPbExBNitGQURVSGdK?=
 =?utf-8?B?Q0FNNnVKVjlnd2g5R0FRSTBGdG9BakI4WUxzckEydVZodlB4QWJERGVoTHlT?=
 =?utf-8?B?ZnFrOU5WdERLcFVqbVovT2hsZVNTbzA0R3BmUS9xM3lKYmZYemVyaUdzS2p3?=
 =?utf-8?B?MTRzcm02Z0xzdU05RHVtL0FYMDlBYWRydkpNRWt6WTVGL3JHMUc5d3lhZ1Iv?=
 =?utf-8?B?b1ZyV1AvMktpMkxDUE5qbldYOGtEaWhvTWVMUy9mT1IvZmdMVUxFbHVXVkpk?=
 =?utf-8?B?ak8rNjRDN0QrUHc3T1JIMGxiN3h5Y1BDV04zSXYvU0FXdzZwQzBLbEIvSmhj?=
 =?utf-8?B?NTNXK3haYkdSVmJYdEsrKzhnTXJNczI1ZE1keEdVbitpdm1lUkc3YUpBT0l3?=
 =?utf-8?B?L2c1V25yRUVlSVJEb09sajFLaEVxNzhmdjMxN1Y4SnI2eTlYS2lJN0ovOFdT?=
 =?utf-8?B?SVRVQjhDakQ3OS9QYW1IdVBOT01ZZ0pCcDc3TW15VnM4R1dNZ0xhallwTnY2?=
 =?utf-8?B?L25aVVVQQkt3NnVWbE9YOWtCejBPbDYzMkoyaHFvaEFSZ1AydmdOSW9qTmRJ?=
 =?utf-8?B?TERPTU05cDFDcVIyZVZKOXFneUlXTlFITmhpWXBPelYxNWtpakF3bmpoK294?=
 =?utf-8?B?b0pjTDZsVm1pTzZyTUQzMVhJVytwWXNZRFJFYVI5MGtJa0dVUzhKRU9KSHNI?=
 =?utf-8?B?MEEyaFRNU3VVT0xCUGxVcGxlV0lkZktNc0pCZlhIVk1aUGZPNkxEdDhvdHRO?=
 =?utf-8?B?VWpuajUrWHNqQzkvVU5Zc1I4RUJwN3k0cm1kaGRST3ovR0hpZng4TFZUTXJw?=
 =?utf-8?B?anlnVEp6NUhlTzZQUTN5Z2FPWXJaZFhqL2ZBdm45N2JyTU5iL25DKzV1RzFr?=
 =?utf-8?B?WmVma0k4V05ZTEVKNml1czdaVEoyQlIrNWl5UGtROWRVQ1YvY2dkQVozY0xT?=
 =?utf-8?B?dmRwTnczZlFOaEZQNnYyeGZKcWZPL3Y5S3FhUS9VaW8zNzkwSlc4ZEgwbUNK?=
 =?utf-8?B?UDNiZERTUk1LcGZVVFZQWEc2QWhYbHUwdk5QWlVHNm84QXU2ZUY1NWZwNEIw?=
 =?utf-8?B?Z25NTS93WmZnYlQxSlFpS2dUeUE3akxnanMvSFhra1F2OWdpdTVzbGVFcU1k?=
 =?utf-8?B?MVY1THAwZC90WWpDUGFRRmFKNmoydkdWdzh2N01ySnJuSG8rN2o2a1ZtSWpB?=
 =?utf-8?B?WW5iQmpEUTd2eVZ0U1l4d0cwZTRTWXZabnhSUWpnNnhSaDlhbHJYZkMyaDlj?=
 =?utf-8?B?NWp1bHZSQ3FpZUFMbVpIQlJYVGg1MWhHOUhxeDhWWHh4YTJVL3Y0cXdmaEpo?=
 =?utf-8?B?R0dZekROSGJoNmhDSFZic3cvNDdnVjQ2MkpXeFRwRlZRdldnOXNyOTZINk5s?=
 =?utf-8?B?MVhMbUZnZzcrUVlDdDQ5Rnd1dGpiRUFZTXpzQUtwVWdhb2t0dEVFTEpEdjZN?=
 =?utf-8?B?WXFFak9vYm5UcGRKUXloMkdPUE40MzV0cHJzLzMrZ1NpNUJrRGhNSjA5bjZr?=
 =?utf-8?B?dStnRi9Yc3BmSEhxOVhrUGRCZmY5bTZnMHI2OWN6QXRXcy9aZmo1VHVyUGdj?=
 =?utf-8?B?U0Z5TTJJWFVCUjJFQk41QXVqRmtXVnVOYTlRcldzd0lOUVpGc1lZa3hmTHF0?=
 =?utf-8?B?SlE9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <CB61EF8FC8809B48BD74A58A44D553AE@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5978.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ae0a6d66-ee17-4041-c842-08db19eec2a3
X-MS-Exchange-CrossTenant-originalarrivaltime: 01 Mar 2023 00:49:06.0856
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: A6yOAEEPCIupL/z2OkBzTsC6DbePuChvHlOCiKc/rhBkm5tMoM1LeLX2xHu8Zp3PhfNL1Y5TKzfHRHlhhtmktg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA3PR11MB7628
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

T24gVHVlLCAyMDIzLTAyLTI4IGF0IDE2OjM1IC0wODAwLCBJc2FrdSBZYW1haGF0YSB3cm90ZToN
Cj4gT24gVHVlLCBGZWIgMjgsIDIwMjMgYXQgMDk6NDk6MTBQTSArMDAwMCwNCj4gIkh1YW5nLCBL
YWkiIDxrYWkuaHVhbmdAaW50ZWwuY29tPiB3cm90ZToNCj4gDQo+ID4gT24gVHVlLCAyMDIzLTAy
LTI4IGF0IDEyOjE4IC0wODAwLCBJc2FrdSBZYW1haGF0YSB3cm90ZToNCj4gPiA+IE9uIFR1ZSwg
RmViIDI4LCAyMDIzIGF0IDExOjUyOjU5QU0gKzAwMDAsDQo+ID4gPiAiSHVhbmcsIEthaSIgPGth
aS5odWFuZ0BpbnRlbC5jb20+IHdyb3RlOg0KPiA+ID4gDQo+ID4gPiA+IE9uIFR1ZSwgMjAyMy0w
Mi0yOCBhdCAwMzowNiAtMDgwMCwgSXNha3UgWWFtYWhhdGEgd3JvdGU6DQo+ID4gPiA+ID4gPiA+
ICsJaWYgKCFlKQ0KPiA+ID4gPiA+ID4gPiArCQlyZXR1cm4gLUVOT01FTTsNCj4gPiA+ID4gPiA+
ID4gKwkqZcKgID0gKHN0cnVjdCBrdm1fY3B1aWRfZW50cnkyKSB7DQo+ID4gPiA+ID4gPiA+ICsJ
CS5mdW5jdGlvbiA9IDEsCS8qIEZlYXR1cmVzIGZvciBYMkFQSUMgKi8NCj4gPiA+ID4gPiA+ID4g
KwkJLmluZGV4ID0gMCwNCj4gPiA+ID4gPiA+ID4gKwkJLmVheCA9IDAsDQo+ID4gPiA+ID4gPiA+
ICsJCS5lYnggPSAwLA0KPiA+ID4gPiA+ID4gPiArCQkuZWN4ID0gMVVMTCA8PCAyMSwJLyogWDJB
UElDICovDQo+ID4gPiA+ID4gPiA+ICsJCS5lZHggPSAwLA0KPiA+ID4gPiA+ID4gPiArCX07DQo+
ID4gPiA+ID4gPiA+ICsJdmNwdS0+YXJjaC5jcHVpZF9lbnRyaWVzID0gZTsNCj4gPiA+ID4gPiA+
ID4gKwl2Y3B1LT5hcmNoLmNwdWlkX25lbnQgPSAxOw0KPiA+ID4gPiA+ID4gDQo+ID4gPiA+ID4g
PiBBcyBtZW50aW9uZWQgYWJvdmUsIHdoeSBkb2luZyBpdCBoZXJlPyBXb24ndCBiZSB0aGlzIGJl
IG92ZXJ3cml0dGVuIGxhdGVyIGluDQo+ID4gPiA+ID4gPiBLVk1fU0VUX0NQVUlEMj8NCj4gPiA+
ID4gPiANCj4gPiA+ID4gPiBZZXMsIHVzZXIgc3BhY2UgVk1NIGNhbiBvdmVyd3JpdGUgY3B1aWRb
MHgxXSBhbmQgQVBJQyBiYXNlIE1TUi7CoCBCdXQgaXQNCj4gPiA+ID4gPiBkb2Vzbid0DQo+ID4g
PiA+ID4gbWF0dGVyIGJlY2F1c2UgaXQncyBhIGJ1ZyBvZiB1c2VyIHNwYWNlIFZNTS4gdXNlciBz
cGFjZSBWTU0gaGFzIHRvIGtlZXAgdGhlDQo+ID4gPiA+ID4gY29uc2lzdGVuY3kgb2YgY3B1aWQg
YW5kIE1TUnMuDQo+ID4gPiA+ID4gQmVjYXVzZSBURFggbW9kdWxlIHZpcnR1YWxpemVzIGNwdWlk
WzB4MV0ueDJhcGljIHRvIGZpeGVkIDEsIEtWTSB2YWx1ZSBkb2Vzbid0DQo+ID4gPiA+ID4gbWF0
dGVyIGFmdGVyIHZjcHUgY3JlYXRpb24uDQo+ID4gPiA+ID4gQmVjYXVzZSBLVk0gdmlydHVhbGl6
ZXMgQVBJQyBiYXNlIGFzIHJlYWQgb25seSB0byBndWVzdCwgY3B1aWRbMHgxXS54MmFwaWMNCj4g
PiA+ID4gPiBkb2Vzbid0IG1hdHRlciBhZnRlciB2Y3B1IGNyZWF0aW9uIGFzIGxvbmcgYXMgdXNl
ciBzcGFjZSBWTU0ga2VlcHMgS1ZNIEFQSUMNCj4gPiA+ID4gPiBCQVNFDQo+ID4gPiA+ID4gdmFs
dWUuDQo+ID4gPiA+ID4gDQo+ID4gPiA+IA0KPiA+ID4gPiBDb250cmFyeSwgY2FuIHdlIGRlcGVu
ZCBvbiB1c2Vyc3BhY2UgVk1NIHRvIHNldCB4MkFQSUMgaW4gQ1BVSUQsIGJ1dCBub3QgZG8gdGhp
cw0KPiA+ID4gPiBpbiBLVk0/ICBJZiB1c2Vyc3BhY2UgZG9lc24ndCBkbyBpdCwgd2UgdHJlYXQg
aXQgYXMgdXNlcnNwYWNlJ3MgYnVnLg0KPiA+ID4gPiANCj4gPiA+ID4gUGx1cywgdXNlcnNwYWNl
IGFueXdheSBuZWVkcyB0byBzZXQgeDJBUElDIGluIENQVUlEIHJlZ2FyZGxlc3Mgd2hldGhlciB5
b3UgaGF2ZQ0KPiA+ID4gPiBkb25lIGFib3ZlIGhlcmUsIGNvcnJlY3Q/DQo+ID4gPiA+IA0KPiA+
ID4gPiBJIGRvbid0IHNlZSB0aGUgcG9pbnQgb2YgZG9pbmcgYWJvdmUgaW4gS1ZNIGJlY2F1c2Ug
eW91IGFyZSBuZWl0aGVyIGVuZm9yY2luZw0KPiA+ID4gPiBhbnl0aGluZyBpbiBLVk0sIG5vciB5
b3UgYXJlIHJlZHVjaW5nIGVmZm9ydCBvZiB1c2Vyc3BhY2UuDQo+ID4gPiANCj4gPiA+IEdvb2Qg
aWRlYS4gSSBjYW4gZHJvcCBjcHVpZCBwYXJ0IGZyb20gdGR4X3ZjcHVfY3JlYXRlKCkgYW5kIGFw
aWMgYmFzZSBwYXJ0IGZyb20NCj4gPiA+IHRkeF92Y3B1X3Jlc2V0KCkuIEl0IG5lZWRzIHRvIG1v
ZGlmeSB0ZHhfaGFzX2VtdWxhdGVkX21zcigpIHRvIGFsbG93IHVzZXIgc3BhY2UNCj4gPiA+IFZN
TSB0byB1cGRhdGUgQVBJQyBCQVNFIE1TUi4NCj4gPiANCj4gPiBNeSBwZXJzb25hbCBwcmVmZXJl
bmNlIHdvdWxkIGJlOg0KPiA+IA0KPiA+IDEpIEluIEtWTV9TRVRfQ1BVSUQyLCB3ZSBkbyBzYW5p
dHkgY2hlY2sgb2YgQ1BVSURzIHByb3ZpZGVkIGJ5IHVzZXJzcGFjZSwgYW5kDQo+ID4gcmV0dXJu
IGVycm9yIGlmIG5vdCBtZXQgKGkuZSBYMkFQSUMgaXNuJ3QgYWR2ZXJ0aXNlZCkuICBXZSBhbHJl
YWR5IGhhdmUgY2FzZXMNCj4gPiB0aGF0IEtWTV9TRVRfQ1BVSUQyIGNhbiBmYWlsLCBzbyBleHRl
bmRpbmcgdG8gZG8gVERYLXNwZWNpZmljIGNoZWNrIHNlZW1zDQo+ID4gcmVhc29uYWJsZSB0byBt
ZSB0b28uDQo+IA0KPiBUaGlzIGlzIG1vb3QuIFRoZSBjdXJyZW50IGNoZWNrIGRvZXMgb25seSBj
aGVjayBtYXhwaHlzIGFkZHJlc3MgYml0IHNpemUgYW5kDQo+IHNwZWNpZmllZCB4ZmVhdHVyZXMg
YXJlIHN1cHBvcnRlZCBieSBob3N0LiAgSXQncyBiYXJlIG1pbmltdW0gZm9yIGt2bSB0byB3b3Jr
Lg0KPiBJdCBkb2Vzbid0IHRyeSB0byBjaGVjayBjb25zaXN0ZW5jeS4NCj4gDQo+IA0KPiA+IDIp
IEZvciBBUElDX0JBU0UsIHlvdSBjYW4ganVzdCBpbml0aWFsaXplIHRoZSBNU1IgaW4gdGR4X3Zj
cHVfcmVzZXQoKSBhbmQgaWdub3JlDQo+ID4gYW55IHVwZGF0ZSAoK3ByX3dhcm4oKT8pIHRvIE1T
Ul9JQTMyX0FQSUNfQkFTRS4NCj4gDQo+IFRoZSB4ODYgY29tbW9uIGNvZGUgZm9yIEtWTV9DUkVB
VEVfVkNQVSwga3ZtX2FyY2hfdmNwdV9jcmVhdGUoKSwgY2FsbHMgdmNwdV9jcmVhdGUsDQo+IGNy
ZWF0ZXMgbGFwaWMsIGFuZCBjYWxscyB2Y3B1X3Jlc2V0KCkuIA0KPiANCj4gU2V0dGluZyBBQ1BJ
IEJBU0UgTVNSIHdpdGggWDJBUElDIGVuYWJsZWQsIGNoZWNrcyBpZiBjcHVpZCB4MmFwaWMgYml0
IGlzIHNldC4NCj4gUGxlYXNlIG5vdGljZSBndWVzdF9jcHVpZF9oYXModmNwdSwgWDg2X0ZFQVRV
UkVfWDJBUElDKSBpbiBrdm1fc2V0X2FwaWNfYmFzZSgpLg0KPiBUbyB3b3JrIGFyb3VuZCBpdCwg
b25lIHdheSBpcyBzZXQgY3B1aWQgYXJ0aWZpY2lhbGx5IGluIGNyZWF0ZSBtZXRob2QgYXMgdGhp
cw0KPiBwYXRjaCBkb2VzLiAgT3RoZXIgd2F5IHdvdWxkIGJlIHRvIGludHJvZHVjZSBhbm90aGVy
IHZlcnNpb24gb2YNCj4ga3ZtX3NldF9hcGljX2Jhc2UoKSB0aGF0IGRvZXNuJ3QgY2hlY2sgY3B1
aWQgZGVkaWNhdGVkIGZvciB0aGlzIHB1cnBvc2UuDQo+IFRoZSB0aGlyZCBvcHRpb24gaXMgdG8g
bWFrZSBpdCB1c2VyIHNwYWNlIHJlc3BvbnNpYmlsaXR5IHRvIHNldCBpbml0aWFsIHJlc2V0DQo+
IHZhbHVlIG9mIEFQSUMgQkFTRSBNU1IuDQo+IA0KPiBXaGljaCBvcHRpb24gZG8geW91IHByZWZl
cj8NCj4gDQoNCkkganVzdCByZWNhbGwgeW91IGhhdmUgYWxyZWFkeSBzZXQgYWxsIENQVUlEcyB2
aWEgdGR4X3RkX2luaXQoKS4gIEkgd291bGQgZG8NCmJlbG93Og0KDQoxKSBrZWVwIGFsbCBDUFVJ
RHMgaW4gdGR4X3RkX2luaXQoKSwgYW5kIG1ha2UgdmNwdS0+Y3B1aWQgcG9pbnQgdG8gdGhhdC4N
CjIpIElnbm9yZSBLVk1fU0VUX0NQVUlEMiBmb3IgVERYIGd1ZXN0ICgrIHByX3dhcm4oKSwgZXRj
KS4NCjMpIFNldCBURFgtZml4ZWQgQ1BVIHJlZ2lzdGVycy9tc3JzLCBldGMgaW4gcmVzZXRfdmNw
dSgpLg0KDQoNCg==
