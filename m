Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 75FB96E01CF
	for <lists+kvm@lfdr.de>; Thu, 13 Apr 2023 00:29:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229597AbjDLW27 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 12 Apr 2023 18:28:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37022 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229451AbjDLW25 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 12 Apr 2023 18:28:57 -0400
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E7B1E4228;
        Wed, 12 Apr 2023 15:28:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1681338536; x=1712874536;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=TCK4u+aKO+ZD+5a2bgcHy7RJtZg+Katmj//5NGboEBY=;
  b=ctfb3H9yBhFyLqgCJplUliBMknDOYiN2k1ErvxMm3xy9owOvtOgKcCaq
   Ji42f190z6c8HxGvKK2868lqqgnPMVQIJKO2l4nz6IfXWD4ttitAOPU9Q
   1DNBtOfTY2Bo4+Ma8cGgXqoTNBN/NE/y6EFJG80lfTsnTybK81Vk3NoPz
   vAPpG/Ii5EnjVpzTxfXDz1/NYZHVM4csG0ncr+Kj9Kxg5WsrG2khyxqrO
   bM388ZX/3rUYXFSRscJaakRJb0VDUh3gHBeFNh3lpRTF+yWAd0V+VEbx2
   9c31T8S4+0imia+aP36GGjkrB0yzgb7K4V8JvRj9zA4PsoZzQ0Gqok2rH
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10678"; a="344035461"
X-IronPort-AV: E=Sophos;i="5.98,339,1673942400"; 
   d="scan'208";a="344035461"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Apr 2023 15:28:56 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10678"; a="778468975"
X-IronPort-AV: E=Sophos;i="5.98,339,1673942400"; 
   d="scan'208";a="778468975"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by FMSMGA003.fm.intel.com with ESMTP; 12 Apr 2023 15:28:56 -0700
Received: from fmsmsx612.amr.corp.intel.com (10.18.126.92) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Wed, 12 Apr 2023 15:28:56 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx612.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Wed, 12 Apr 2023 15:28:55 -0700
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23 via Frontend Transport; Wed, 12 Apr 2023 15:28:55 -0700
Received: from NAM02-DM3-obe.outbound.protection.outlook.com (104.47.56.41) by
 edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.23; Wed, 12 Apr 2023 15:28:55 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ZHA2eWWdTeD71h7K6uC+VsrZU7wts2Yl7D9PW9SS3+vlsezmavwlD9zUKVLCgnawYspT6pTXE+fH3sNU/LAXYl+9dzt1tJvNGQ5xiXUHnps1HZ2DYmSCwyU1L8BnFoXbSeP5LL7kA71z/Fx0OeCpluElP4ElqERT/U91CCDZfjvMhu4g80yeLIyC5eE/81KbTx6GPLoFB2Jdj4Bi5XW1OCHbEvr6Fe8hROpORo+epjIu8wC7W6+/F8+JvM8T3X55XXnjMZDxsVLWdBGyflrqE+0/zjTzYcL51LR0vunQMMaPXGCAFGMekeh54Df/2h1Dh2LPkBdz5FI4I/5mn1NXZw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=TCK4u+aKO+ZD+5a2bgcHy7RJtZg+Katmj//5NGboEBY=;
 b=bJK5B2KsDOM14LK0Pt7icMzP4q+MScXPZPnkiV8UhQ5cX4RXQy61t+Ydri8FdRF7ViDdXLEmtUfCiMRbyFIW5Fml1mykfkmQncel1c56CSzoUajcnzZfzf+6pEK9xpvmY+gfZStQxJKmk8hHy94rty/afFWYbkBY9Js8HZWFNwjB2armNf+Z+w8Ru15jb9LQoNcql7KIGp3ZA9CWV/Y8Ms5OLpb3DGcLEyvg6UPXveJ32DPdGOekhpv/sGWiLsA5vR7E8UpHrmaxtcmKo928O3DNbM3c/YRdcrlgN331NQDIBe8yV+ajQPoB43mFwGCs3RqHuhx6tiX1HPhe2/hMgg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5978.namprd11.prod.outlook.com (2603:10b6:208:385::18)
 by PH7PR11MB6954.namprd11.prod.outlook.com (2603:10b6:510:205::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6277.35; Wed, 12 Apr
 2023 22:28:53 +0000
Received: from BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::3c9e:36da:562b:f1f5]) by BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::3c9e:36da:562b:f1f5%3]) with mapi id 15.20.6277.034; Wed, 12 Apr 2023
 22:28:53 +0000
From:   "Huang, Kai" <kai.huang@intel.com>
To:     "Christopherson,, Sean" <seanjc@google.com>
CC:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "binbin.wu@linux.intel.com" <binbin.wu@linux.intel.com>
Subject: Re: [PATCH 2/2] KVM: VMX: Inject #GP, not #UD, if SGX2 ENCLS leafs
 are unsupported
Thread-Topic: [PATCH 2/2] KVM: VMX: Inject #GP, not #UD, if SGX2 ENCLS leafs
 are unsupported
Thread-Index: AQHZaBjVaqwUToI390GQi+QIa02Ixq8eASCAgACSBQCACPzaAIAAOLcAgACDZwA=
Date:   Wed, 12 Apr 2023 22:28:52 +0000
Message-ID: <bb6cef9876f000313cde81fcbd059c4810ca42c9.camel@intel.com>
References: <20230405234556.696927-1-seanjc@google.com>
         <20230405234556.696927-3-seanjc@google.com>
         <03504796e42badbb39d34b9e99c62ac4c2bb9b6f.camel@intel.com>
         <ZC8IsP5ehaJXQOnu@google.com>
         <5d537415da25ac654b332db64b4018dca0bae6a7.camel@intel.com>
         <ZDbCaEUboTrvtwda@google.com>
In-Reply-To: <ZDbCaEUboTrvtwda@google.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.46.4 (3.46.4-1.fc37) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR11MB5978:EE_|PH7PR11MB6954:EE_
x-ms-office365-filtering-correlation-id: 60876f12-625d-4145-a2a1-08db3ba54bc6
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: SYKq7LovQOaDBUbf6VAW2FYhuRLs3tQnv2VnPGTudSPVLCGKEuZD/BpRxZPPgAVaUuoginLIPz9c/35wkxoLDjVQ/i4nm6CMGjbwajvNokRo6s8Ihc4F5yWeF5+dcXQeNaPdmjz7zYWQVcbgFRHHBWnjV3t/rQuDsTILsW3ZobB7IamSjMe2Xewruemlq5qRJ2248sL3Bum9j2+ACqJNpVYZQ4M4LT9jnO5CAOeWSbSdz3Jm3EqN7Eqldf5dm6Ui9XjG5Y6NdBvDHC6cgXyBXHG6b4oJkuiNtnsuhd+qfHFw8YMrpJKqlrYjlUwbIGBtOzqrjYvvJiZP9DOgGZ2ryX8uuAF5Kyr6IW+ggyO0lWQ7BSKwa9+Z4Yybz83RjxKUjii76Qo00HXPtZuk3PbeRVp0bPno+mOp4fDZiNitKL8t8cr6kWxAMYeh9fvM1DPKACYfNrpt2Mawg6O5gocDk7QTit0e9QTuJ0lT68BsuImrRdIKJY7Td9xSJZnqjFRbXWWYdefoB/Rma+9GNQUJeArPorsI/l0EJElIp27mTks59UFx1WShjuzQcRCrie5ZY9GuHILzhWouBIGuZRxJpFzzH/oUuBwfk/yyik2uI8dO3xkQ/v5cAVugzgwm9BDm
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5978.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(396003)(366004)(346002)(136003)(39860400002)(376002)(451199021)(6486002)(66946007)(64756008)(6916009)(66446008)(66476007)(478600001)(316002)(4326008)(66556008)(54906003)(71200400001)(8676002)(91956017)(76116006)(41300700001)(36756003)(86362001)(2616005)(6506007)(26005)(6512007)(83380400001)(8936002)(5660300002)(186003)(2906002)(122000001)(82960400001)(38070700005)(38100700002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?K3lqWlphNDhZdWJRZGZtK0pMTzN3WlBMZ1hvRGdNTExBUVJyMTJNZDVaTjh2?=
 =?utf-8?B?V3hhWHR0RG52Und4bXhyYnB1eDhXMDN2NEVnWklsSnE2cGp2T2lPblJNTjlY?=
 =?utf-8?B?M2xOSzRrVVVkb0JlOEZheDEwNFJZMVZpVndISW1XUFRHTDFyRzUxd2M1QjBu?=
 =?utf-8?B?N0NaM3E4dnZyOE5Na082NFRzR2FzbEx1ejhyeWNha3FCUjJpZU9YVVpzVFI4?=
 =?utf-8?B?Mm81YldZSE1VcGYzMEE3MHhxY2JJaUwzVWVkVkpXQm9QL1dybXpSQ3ZpalhL?=
 =?utf-8?B?OWx2RFZCbzVBdlU3NnpSYWxMeWNnbndXcnZxSzdwbGVtQ28zWlF5L3BmZ0lK?=
 =?utf-8?B?VVltR2I2V2xCWVAvTGVRK0J6bkMzVmllRnhKb1RtY2NmRWtvSnhRZXRLdmc1?=
 =?utf-8?B?RnZDUlRkWE9VU3MvUGRKS0VpTHc1ckZ6UDlLN3U2K3hFeFNlYVAvODVZOElX?=
 =?utf-8?B?S3NSZWFmNzRzOXBrL1BYYW5ra293QlRuOEkrMHhKVzFhcnVadjYwMVByYXR2?=
 =?utf-8?B?UlJJdjFpZG1kTGZnbDlSMy8rbWdCTlNvUkJDWlNZYzZlTk91NGNaSEF4WGt1?=
 =?utf-8?B?QnFxYVlLeFJzazZZSzUwMXd6RUpnUExQSUtXbG50VE9kOGxDRkNSV3hWS0tp?=
 =?utf-8?B?bG1IRUxxQzF5dHVqZ2RzU05hREpUUDVZRmw2amNoZWppSGxlVzhZMWdHb2E4?=
 =?utf-8?B?YllCelN5T2Q1eFZrUVhFNFRvQ29GVitJS0M3TGdqalg5WCs1aEZTdHhsVUZN?=
 =?utf-8?B?MmJKRSt5K2M4Q0RobEJmL0ZiRDR4SnFHSCttUnZPKzMwV0MwcGZaVlhKbjNX?=
 =?utf-8?B?b0ZVYi9YY2ludTh3NFRRVnpISHFPd2RCYlpmQzNGK2I3bzZyQStXM1RXWkFV?=
 =?utf-8?B?SEh0T05LckV4RHV5RWRQTWNDYUY5clY2SHNObVhjdWFVNk1LN3puR0o1U1VX?=
 =?utf-8?B?SVJjTDllWWhpZjdLa2IzZG51dDNsb2NJcmRJUHhFbWFjUXlIZUJLZVlrdXhJ?=
 =?utf-8?B?Y1VIVTQwekpJaTZ2Ym52Ump6UzNMNytjOXBXcDlhT2ZOQUZQeUJRamhid1BR?=
 =?utf-8?B?UEZiQXN4N2FCU3hkVTZ0ejFZNDVNTmdDc2lnbm5zU1dFb2R0LytjVmpaQ2V2?=
 =?utf-8?B?RDh6clhGMG1rVnk5VGd5RHNHVk81YjcwR1hLbUFyTDlMRnlmYjFBRVl5K0Fv?=
 =?utf-8?B?M1VYalNBN05iVHAwU1RoWUo5MjVLc2xLWEs2bmdSWDJTbkVZR1pmR3I5UTVx?=
 =?utf-8?B?TUN4d0Z6cjJkVC9FRzd0ZzV4WE5aWjZXQ3haaHdIYTlhS2h2NkhtT1Vkd0Nr?=
 =?utf-8?B?YlpRQWNnSVRkWDBkSFlzV2Jia3BnanNIdG13TmZIa3kxc2pSVHI3anFML1RJ?=
 =?utf-8?B?czBFZGN2TjRNRkxndXhwREhhaDlFTGVJKzY0TXh3VHhHM0RrV0VZRDdMQ2xC?=
 =?utf-8?B?MklqS0pTK04xYVV4bEJWbXBQYlVrYTh6ejZqVGZIT0FmU040dVFPNUZ1Zjhh?=
 =?utf-8?B?TjEvY1BpanpJNHVyOUljSUp1UnN3RmJRRGVJblMrelpjbVEycVBqaWIvcFRM?=
 =?utf-8?B?S05mbVk5NnBEaWRYRnVNeHFOd2hZaFdYeE9lS2VhM0RYQlE2T3hua3FiNXgv?=
 =?utf-8?B?UGhqdmx4WGpTL0dEbiticW1CMzhJWUhOV3RSZWsxV0dRNFZ6ZU94UkRzdVI3?=
 =?utf-8?B?WmVrMUlDd2kyTXZTTGhLcDdET1p6aTIvVnZyRTU0YjhHeDJXdlplUjkzOGdp?=
 =?utf-8?B?TTQzTEt3djN0NnFyUDhZWEhaWmlhUjVwbHM2Vm51QS9oYTRpK1dJQ0Jwb0V0?=
 =?utf-8?B?K1ZFZW9KMDg2UDFwYThzcXM5T3dSOHQzZHNxNlF1dGQwVjBLdXF5VXNWajlT?=
 =?utf-8?B?KzRHeDNXUll1T2dlM0xkZ3Vac3lNRU93d0ordk01T2d5c1ZQUXcxRUpOcjVs?=
 =?utf-8?B?eEZnN0o2YWpnM241TG9GRHBGYkN4a0lvSGxhY1dyYVJFWnpsOUN0TXZSVldQ?=
 =?utf-8?B?Ri93cXd4YWtkMTRFcURmQTBoQUlvTm5MczgwNDRoWm5iQ0hsTWJVaDZrc0pm?=
 =?utf-8?B?VkJnZ0d5UWxHWWNsL3lkMGtXUHk4M2ZNaDlpN1B1dXUwazl2bElFUGlzUWtv?=
 =?utf-8?B?L0NaL3pjRDNlQXhyS1ZPT3E0TDNkOTQ2K0k0cit6Z0pyRDJIYmZqZDVuWDNt?=
 =?utf-8?B?MlE9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <B83625018DA1E84F87F4A0E74BAE535E@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5978.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 60876f12-625d-4145-a2a1-08db3ba54bc6
X-MS-Exchange-CrossTenant-originalarrivaltime: 12 Apr 2023 22:28:52.9430
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: r4GdCfj8HeGp6roajI/Pqv8OuEDE+1oOTgV4vZgbCRFXRWAs0u139nxrQZ+326OXFZFA1RLn9seMonDWk+qjxg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR11MB6954
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

T24gV2VkLCAyMDIzLTA0LTEyIGF0IDA3OjM4IC0wNzAwLCBTZWFuIENocmlzdG9waGVyc29uIHdy
b3RlOg0KPiBPbiBXZWQsIEFwciAxMiwgMjAyMywgS2FpIEh1YW5nIHdyb3RlOg0KPiA+IE9uIFRo
dSwgMjAyMy0wNC0wNiBhdCAxMTowMCAtMDcwMCwgU2VhbiBDaHJpc3RvcGhlcnNvbiB3cm90ZToN
Cj4gPiA+IE9uIFRodSwgQXByIDA2LCAyMDIzLCBIdWFuZywgS2FpIHdyb3RlOg0KPiA+ID4gPiBP
biBXZWQsIDIwMjMtMDQtMDUgYXQgMTY6NDUgLTA3MDAsIFNlYW4gQ2hyaXN0b3BoZXJzb24gd3Jv
dGU6DQo+ID4gPiA+ID4gUGVyIEludGVsJ3MgU0RNLCB1bnN1cHBvcnRlZCBFTkNMUyBsZWFmcyBy
ZXN1bHQgaW4gYSAjR1AsIG5vdCBhICNVRC4NCj4gPiA+ID4gPiBTR1gxIGlzIGEgc3BlY2lhbCBz
bm93Zmxha2UgYXMgdGhlIFNHWDEgZmxhZyBpcyB1c2VkIGJ5IHRoZSBDUFUgYXMgYQ0KPiA+ID4g
PiA+ICJzb2Z0IiBkaXNhYmxlLCBlLmcuIGlmIHNvZnR3YXJlIGRpc2FibGVzIG1hY2hpbmUgY2hl
Y2sgcmVwb3J0aW5nLCBpLmUuDQo+ID4gPiA+ID4gaGF2aW5nIFNHWCBidXQgbm90IFNHWDEgaXMg
ZWZmZWN0aXZlbHkgIlNHWCBjb21wbGV0ZWx5IHVuc3VwcG9ydGVkIiBhbmQNCj4gPiA+ID4gPiBh
bmQgdGh1cyAjVURzLg0KPiA+ID4gPiANCj4gPiA+ID4gSWYgSSByZWNhbGwgY29ycmVjdGx5LCB0
aGlzIGlzIGFuIGVycmF0dW0gd2hpY2ggY2FuIGNsZWFyIFNHWDEgaW4gQ1BVSUQgd2hpbGUNCj4g
PiA+ID4gdGhlIFNHWCBmbGFnIGlzIHN0aWxsIGluIENQVUlEPw0KPiA+ID4gDQo+ID4gPiBOb3Bl
LCBub3QgYW4gZXJyYXR1bSwgYXJjaGl0ZWN0dXJhbCBiZWhhdmlvci4NCj4gPiANCj4gPiBJIGZv
dW5kIHRoZSByZWxldmFudCBzZWN0aW9uIGluIFNETToNCj4gPiANCj4gPiBBbGwgc3VwcG9ydGVk
IElBMzJfTUNpX0NUTCBiaXRzIGZvciBhbGwgdGhlIG1hY2hpbmUgY2hlY2sgYmFua3MgbXVzdCBi
ZSBzZXQNCj4gPiBmb3IgSW50ZWwgU0dYIHRvIGJlIGF2YWlsYWJsZSAoQ1BVSUQuU0dYX0xlYWYu
MDpFQVhbU0dYMV0gPT0gMSkuIEFueSBhY3Qgb2YNCj4gPiBjbGVhcmluZyBiaXRzIGZyb20gJzEg
dG8gJzAgaW4gYW55IG9mIHRoZSBJQTMyX01DaV9DVEwgcmVnaXN0ZXIgbWF5IGRpc2FibGUNCj4g
PiBJbnRlbCBTR1ggKHNldCBDUFVJRC5TR1hfTGVhZi4wOkVBWFtTR1gxXSB0byAwKSB1bnRpbCB0
aGUgbmV4dCByZXNldC4NCj4gPiANCj4gPiBMb29raW5nIGF0IHRoZSBjb2RlLCBpdCBzZWVtcyBj
dXJyZW50bHkgS1ZNIHdvbid0IGNsZWFyIFNHWDEgYml0IGluIENQVUlEIHdoZW4NCj4gPiBndWVz
dCBkaXNhYmxlcyBJQTMyX01DaV9DVEwgKHdyaXRpbmcgMCkuICBTaG91bGQgd2UgZG8gdGhhdD8N
Cj4gDQo+IE5vLCB0aGUgYmVoYXZpb3IgaXNuJ3Qgc3RyaWN0bHkgcmVxdWlyZWQ6IGNsZWFyaW5n
IGJpdHMgKm1heSogZGlzYWJsZSBJbnRlbCBTR1guDQo+IEFuZCB0aGVyZSBpcyB6ZXJvIGJlbmVm
aXQgdG8gdGhlIGd1ZXN0LCB0aGUgYmVoYXZpb3IgZXhpc3RzIGluIGJhcmUgbWV0YWwgcHVyZWx5
DQo+IHRvIGFsbG93IHRoZSBDUFUgdG8gcHJvdmlkZSBzZWN1cml0eSBndWFyYW50ZWVzLiAgT24g
dGhlIGZsaXAgc2lkZSwgZW11bGF0aW5nIHRoZQ0KPiBkaXNhYmxpbmcgb2YgU0dYIHdpdGhvdXQg
Y2F1c2luZyBwcm9ibGVtcywgZS5nLiB3aGVuIHVzZXJzcGFjZSBzZXRzIE1TUnMsIHdvdWxkIGJl
DQo+IHF1aXRlIHRyaWNreS4NCg0KWWVhaCBteSB0aGlua2luZyB0b28uICBBZ3JlZWQuDQo=
