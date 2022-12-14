Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4496064CEAD
	for <lists+kvm@lfdr.de>; Wed, 14 Dec 2022 18:13:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237507AbiLNRNe (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 14 Dec 2022 12:13:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43616 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237366AbiLNRNa (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 14 Dec 2022 12:13:30 -0500
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CED1129834;
        Wed, 14 Dec 2022 09:12:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1671037952; x=1702573952;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=UtxflxNQCzk9x3rCfEv2++vceGcRqA9wA+xii6E4684=;
  b=G8cqaHQzZiNmmZwU9Lzt/JkFwOrYP++oTPjFteJK25cMxhbfKcYipz/E
   /0eEpOEG9krwn6yvBulv7MKb4bfe8e8DIOitI7eZHNR6DbIsVeyaOE9xc
   W0b9xJ7Rp57ufvc2CwZtDwIAZdvBTqh5g9r7YYkyoZFU9q9xcM/CPtYd9
   TNdo1bNFhy6WQf9zfdcoF8Bph0VwtKM0ARlf8wLgdhE/491napMxTZvBa
   +LeD4TjHgBiigcXFDwIWPcMhgdrPczbdg41gxO1PEBC2EWNoKQbuAsRQx
   Hk/7IAem5LACywKLLHDTV1+gZBgSoxPq4aX0htIQC4k3wAMdj5OMdRJxP
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10561"; a="382761224"
X-IronPort-AV: E=Sophos;i="5.96,245,1665471600"; 
   d="scan'208";a="382761224"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Dec 2022 09:09:45 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10561"; a="717669212"
X-IronPort-AV: E=Sophos;i="5.96,245,1665471600"; 
   d="scan'208";a="717669212"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by fmsmga004.fm.intel.com with ESMTP; 14 Dec 2022 09:09:45 -0800
Received: from fmsmsx611.amr.corp.intel.com (10.18.126.91) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Wed, 14 Dec 2022 09:09:45 -0800
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx611.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Wed, 14 Dec 2022 09:09:44 -0800
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Wed, 14 Dec 2022 09:09:44 -0800
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (104.47.59.175)
 by edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Wed, 14 Dec 2022 09:09:43 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=loX0Q0rgMsIq3K7tWUNqIjwQZdaid/+PT6srWMeyegWZiro8nP0qUNL9o3KdrlxQkP4MEyDHV0Vj/UnkkmFSWN+/DEt7QTOVxX8kgeqTzbJ9d7bDyFpzGnSbH72awSt4krSKQq8thiiTl6QcXh3qG+VbFRZIs6ENcaPOy1Id792hAjABCG4BTLlaFY4T/y5sSGmztiKMkkBOJlo3jD9K8Xck3ozisb5qU1vzjqkQbuaeTbcYdQMQ4ri6TLYmCCCDqMRWVYqa90rwCib9+lekI3bQ63Lv5Krw4II6+aHah1OPjKUzthdbezngJVxHC3TnZ/vlMHRS4yieXxWzCEGKbA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=UtxflxNQCzk9x3rCfEv2++vceGcRqA9wA+xii6E4684=;
 b=AuoTK05eVOqud9bKc//kAViQkQdmlKhZlcUbECYFhERecPtyo8KiOdM+m3rQQE1cMhwYt3O+jG6F9pwkUlPEfXPcIfcFnQVoh9MNqemF6/EAAJIps0vJm1Xfcl1wqQykWisPqUWoFFrOzsArnGDuFQTTjl0TT8HXfk9FC/Mv5ZZ37XbAs/mQvwhysDloCwQGi0v7ghcZz5NkUx3wMXmKVikGO8z87kcJiQJOtd0X5pGpPPrGxX5fiMqQOLWdSRpI2zKol74dbDvY/ysCdX0tPPSEbHrK+bpqvwDFKrQqyIHilSNU+KOjsV9MxlCK0t9s+1iq5b6uLwgX2IjXOKJwXg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BN6PR1101MB2161.namprd11.prod.outlook.com
 (2603:10b6:405:52::15) by SJ0PR11MB6768.namprd11.prod.outlook.com
 (2603:10b6:a03:47f::8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5924.11; Wed, 14 Dec
 2022 17:09:41 +0000
Received: from BN6PR1101MB2161.namprd11.prod.outlook.com
 ([fe80::5cbf:a669:456c:e130]) by BN6PR1101MB2161.namprd11.prod.outlook.com
 ([fe80::5cbf:a669:456c:e130%6]) with mapi id 15.20.5924.011; Wed, 14 Dec 2022
 17:09:41 +0000
From:   "Li, Xin3" <xin3.li@intel.com>
To:     "Christopherson,, Sean" <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
CC:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        "Lutomirski, Andy" <luto@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: RE: [PATCH 0/7] KVM: VMX: Handle NMI VM-Exits in noinstr section
Thread-Topic: [PATCH 0/7] KVM: VMX: Handle NMI VM-Exits in noinstr section
Thread-Index: AQHZDrl/1BljPxmiqUeeDW9Xymc1LK5tn1lQ
Date:   Wed, 14 Dec 2022 17:09:41 +0000
Message-ID: <BN6PR1101MB216100DFFC7ACA0B63C2F40BA8E09@BN6PR1101MB2161.namprd11.prod.outlook.com>
References: <20221213060912.654668-1-seanjc@google.com>
In-Reply-To: <20221213060912.654668-1-seanjc@google.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BN6PR1101MB2161:EE_|SJ0PR11MB6768:EE_
x-ms-office365-filtering-correlation-id: 02c44366-a6fb-43fc-ddc4-08daddf5fd3d
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: UdwwEJEnxcHqsrhbhIeL2UDt89+Z+w+zBEYTKaftDLx4GFVEJxF9ZTw2l/C6A0xg1GthAo2uxXtWex/z4DwdnhvrWBzXJpySp729ik/tr1/cazWcEW6hzL2NaW8RTyLhz9NbPAaSxgy2n2bUKizIgnKVGw3HHLgKBGVlBkfY4oh7zWNcwg2awJkigruJJcFq1NgIS7yNIYlitsVAT5rOs6TkjRYRBaGHb0q65bSwIB89fp7yvsfdeBcDZtYOQqvWygrIAchEm0sw/+5x4CUoaETMRmk7oF+Fadt/4k458EkKMjMgXLFpHPCI0Mwzo/m3SWPl92rVj0G45i6wJ3BAOJZ/qwUhAleFakOqkEbb9AYAA1xRNXzWeqpVYZOI3u/3K47aY9WTeQ+SwdKphGGb+n49tKb1u1wUKYERfICASf6T4/AYJFK9L4w0350oJg+unrXkj6Zqm/RsGiizRtS/W2kvgLw3ZxMK5MiCzD3QPmAYSf9ffh8yfAtZoXmjn3pibtjItmmWO+2vX98DMDe44OLvxq7LuLsltH1HFh8dl9aFMepkJ8KjcxG4Gu+d7lxLacaAUcwVo8tW5xZMVZeE48NgjQVmf0U7ibRJKh3rvleBgc0MeeMcKogaYJN8albzVNwWr3G/Fq/xyP/XSAollZ28HejcaPp4N2MmQxD6iDcYyGf+IIvBl++1DOH4Xf2F31ygGS9btmJ2Lz/JkrW9sw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN6PR1101MB2161.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(136003)(366004)(396003)(39860400002)(346002)(376002)(451199015)(8676002)(41300700001)(82960400001)(122000001)(38100700002)(86362001)(4326008)(38070700005)(33656002)(4744005)(8936002)(2906002)(71200400001)(54906003)(316002)(64756008)(66446008)(76116006)(66556008)(66946007)(66476007)(52536014)(5660300002)(9686003)(26005)(6506007)(7696005)(186003)(110136005)(478600001)(55016003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?bm5leGFiR0FPeStMa3BoOTBMZVhpa1EvWU1JSlRGY3VGL3dwOElWd09VMlV6?=
 =?utf-8?B?c0dvOUMyU3N4NmFhcEhFakQ3UTMxRlpkcXhsQ0FxM3l5RVd6eStNaE82Q3k1?=
 =?utf-8?B?T0lOMFBpOUVQaVlHR3hZR0o5TEN5ajM4cHNpS3U3TUF0NTVnUWpVV1JHMGVG?=
 =?utf-8?B?eTRNY29hWWlJZFFxLzU0cnRpYjJrUlFPZmtPVHM0MnVDVURWaG1Bd1Z0Q0c2?=
 =?utf-8?B?UDNHamxoTkMyYjVmL1dQd2xzRkNpQU1tUkFlMlFBNFJ6RFFPbnBvb25aTzVH?=
 =?utf-8?B?UHRyRFl0TEdQeDNaN3dFN05jMFNvMUk5UGtlRGcvS0NVcEh2OTlYOGYwVzR4?=
 =?utf-8?B?RlNRZWNsZmpyRlllUERBK3REMHJRZjdHL2c5cDhrS1l5Ym91dDg4TjRpSFNs?=
 =?utf-8?B?cW5QZmdqdWx6NDVRNmJXNXpscm5oYVFVbUFUUnJmK3hYWFJIQzNUVGlLR1lL?=
 =?utf-8?B?V2xuZzgrNG1sajJlcklpUlAwOEdnRVhVbklnRTdyeWpVLy9tRytsS3hlQWh0?=
 =?utf-8?B?S3M1cVI0UGJzUFpLMnk3dlJCQmNZb3IzTnJMRFJQVm96K3FmTGdMMkpVZ2gr?=
 =?utf-8?B?cHBSOUdqSGRqMnEyNGIyZlpHMmp1cWcrN2ZNSkxqbmgwOW9iNWRqcUhKdTJN?=
 =?utf-8?B?Y3cyZmR4eUxBdjdUQzhrUEpoTkNRaUt2VjdCSXRuZkFJUWNSYjd1SW9yUlIv?=
 =?utf-8?B?NmRDU1pGY2hjVWRZdFZ5WlArVXovNzdRUzUyN2hJOFBCcEI5VjQ1T1JUeVpx?=
 =?utf-8?B?MFZKTFZGbjl2RWR0NVhHNUNQQ3lxS0tVNDNTWnZWVDk1dkhOVGw4ODF0N2V2?=
 =?utf-8?B?NGZreGxORXVrcW0rT01kWHVzYy9EQjJadm1ZaEl4a2tpOHhraUEvait5NXUy?=
 =?utf-8?B?bmt4YUZ2L3huZXZ1WGx0bENEM013aG5CQ2ZoeDl3TUFjcGxFNE9EQlRGT1pL?=
 =?utf-8?B?UTNkckI0UU8wa3diSzVhTGQwVCs5OGJjczFGYnoxbmFwYjZXamNMS1Z0Qm9Q?=
 =?utf-8?B?MHZTRDJxRmVoZzdWZVgvK2pQOVpISUFVNGxNRi9NVzBpMzVBbXo0RDQrdS9o?=
 =?utf-8?B?NFV3QlFBeTF4RkZVZENCRzJ2SWxQWnlwZnNtNVpjWjZoSGp3NVg2dlBnWmw5?=
 =?utf-8?B?WmIrZ3lFS0NHelhaUE10VTFZNzhrbjU5QjcvSG9EZ2tmakpLdlI5b2JBSFFs?=
 =?utf-8?B?WEdxaUh6N2tOQkpBRlpoekcwR01NVno2aE5tN1ZHWDVoYzJrTEJqRnVjb2d2?=
 =?utf-8?B?VFJsWE1adEVWV1BTaHlueThWWkRqUkIvNzBFNldRVkNNOUhod2RHcHRpUDJM?=
 =?utf-8?B?UWxYVjhtcDJNV0xmOUhXcUljMzh0bHVHSDBsbVFrNUJibDRrK21uV05DcmVD?=
 =?utf-8?B?N2MxZkVVYkhvcjZNcHRzSmR4Nkd0dHUzblZFZGJqVFRlOU5hYkZjYnNodG9n?=
 =?utf-8?B?RmIxN3BuUmV5aGFUd2hVZWZCQmsvUXV1dmxUR2hwaEdHVUQxUk1IZVdmL1BL?=
 =?utf-8?B?Q3JqSWFuOFdNb3ljeDZSOVIwNGV2ZEpVaVFvY2RjYWxPWTUzQVJiOE9HVTN1?=
 =?utf-8?B?emhpSTdWTVRpVTl3Tm8yVG81MVVpaXhLMW1UdnJGL0xOUkVxVkphdlNkL0Uy?=
 =?utf-8?B?YkVPZEZYNHMvNzl3SkRXeFhMUS9VZmt3UVRCUldkMWZpYktQSVU2Y1pPZ2NV?=
 =?utf-8?B?MkN5RkZhcHhhUzNrUi95bDJSMWRDNjJpRlo0ejZ0anhVN1Z6OEcvZXFkYWtH?=
 =?utf-8?B?NDVRNUoxeFZsUHdmVDMvMG9RelZZTHhGelRZeGxZVU9mQXpYQm8xMm1rU3Y5?=
 =?utf-8?B?UTlzaEVDelp5QVV2Qlp6eUYxdWhIWUNiWUpzOFMvNTQranBOTnh0YktoWFJL?=
 =?utf-8?B?N3duZGt4aUtITVlUUW5FS2hGZnpqWEt4ckd3SHRKWDJESnhNNVVMMlRubm5Z?=
 =?utf-8?B?Q3hGT1dwQTU4aXRpSFFEQ3pWUE5SM2tKcVdtWHhxSkgxdTFLc0ZNT0ZzWFdW?=
 =?utf-8?B?OXV5Qy9rd1JwRmlXZXN3SU9pcmlSSkJLcEQrV2FZaWZ3UlQzN3lubXlKTnda?=
 =?utf-8?B?cWlTS3NIRytEVGc1UXh0WTdSSEVLMGZZSkt0ZHFRVDdIM0RJdmRrSEdqQ25G?=
 =?utf-8?Q?SIBI7jJovMhkff1xuSjgsbFjt?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN6PR1101MB2161.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 02c44366-a6fb-43fc-ddc4-08daddf5fd3d
X-MS-Exchange-CrossTenant-originalarrivaltime: 14 Dec 2022 17:09:41.1293
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: pv++BPMxVFK9j3M3LbrYEMfCoxUmTAK7t6p4wGler8S4d9Sb4osDMAwaPtzGp4d4YKM4Hdi+DeIEWS4edGeXfQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR11MB6768
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

PiBJIGtlcHQgdGhlIHVzZSBvZiBhIGRpcmVjdCBjYWxsIHRvIGEgZGVkaWNhdGVkIGVudHJ5IHBv
aW50IGZvciBOTUlzDQo+IChkb3VibGVkIGRvd24gcmVhbGx5KS4gIEFGQUlDVCwgdGhlcmUgYXJl
IG5vIGlzc3VlcyB3aXRoIHRoZSBkaXJlY3QgY2FsbA0KPiBpbiB0aGUgY3VycmVudCBjb2RlLCBh
bmQgSSBkb24ndCBrbm93IGVub3VnaCBhYm91dCBGUkVEIHRvIGtub3cgaWYgdXNpbmcNCj4gSU5U
ICQyIHdvdWxkIGJlIGJldHRlciBvciB3b3JzZSwgaS5lLiBsZXNzIGNodXJuIHNlZW1lZCBsaWtl
IHRoZSB3YXkgdG8NCj4gZ28uICBBbmQgaWYgcmV2ZXJ0aW5nIHRvIElOVCAkMiBpbiB0aGUgZnV0
dXJlIGlzIGRlc2lyYWJsZSwgc3BsaXR0aW5nIE5NSQ0KPiBhbmQgSVJRIGhhbmRsaW5nIG1ha2Vz
IGl0IHF1aXRlIGVhc3kgdG8gZG8gc28gYXMgYWxsIHRoZSByZWxldmFudCBjb2RlDQo+IHRoYXQg
bmVlZHMgdG8gYmUgcmlwcGVkIG91dCBpcyBpc29sYXRlZC4NCg0KVGhhbmtzIGZvciBtYWtpbmcg
dGhpcyBjaGFuZ2UuDQoNClRoZXJlIGlzIG5vIGJpZyBkaWZmZXJlbmNlIGJldHdlZW4gImludCAk
MiIgYW5kIGNhbGxpbmcgdGhlIE5NSSBoYW5kbGVyIGV4cGxpY2l0bHkuDQoNClhpbg0K
