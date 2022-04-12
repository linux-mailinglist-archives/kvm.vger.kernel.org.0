Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 43CF14FE2D4
	for <lists+kvm@lfdr.de>; Tue, 12 Apr 2022 15:38:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353911AbiDLNjI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 12 Apr 2022 09:39:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45344 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348499AbiDLNjG (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 12 Apr 2022 09:39:06 -0400
Received: from mx0b-002c1b01.pphosted.com (mx0b-002c1b01.pphosted.com [148.163.155.12])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5EC1E2D1CB;
        Tue, 12 Apr 2022 06:36:49 -0700 (PDT)
Received: from pps.filterd (m0127843.ppops.net [127.0.0.1])
        by mx0b-002c1b01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 23C9aoeK015673;
        Tue, 12 Apr 2022 06:36:30 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nutanix.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-id : content-transfer-encoding : mime-version;
 s=proofpoint20171006; bh=DmGB4ICjZxrwO/3O/C/NYMSKZ5nCYhyG10cDKg84418=;
 b=BwiN9DBqGoyAOPIgGO/1WEgRkSxprTpwbS2A8IVCxxQpd2RLdh8s7EGU6i0x4PM9tIi9
 C++aVxArwQR9vRgbEauk7N7ckbzpiTqdrHUInf454es8QbnBmGFzSuJOPplT7eBk1l51
 YGv1/PhsNUsK9KLfviqd3AB1bQC92669iGxfhYjvfYngY4zABmaOD8cZwLjfr8vtog7B
 JODKejD4xOE/odbq5AurEYE4vu0jC94o4s7jX6kOHX/c4XzWSbHPXZF/N4kZNQV3r7vS
 8mq+VzzVLjZLOglDztrm6YBcfSdP3slWhu7zZMM7oBDRx/xIUMwONSzvBkl4SomofGZa 0Q== 
Received: from nam04-dm6-obe.outbound.protection.outlook.com (mail-dm6nam08lp2040.outbound.protection.outlook.com [104.47.73.40])
        by mx0b-002c1b01.pphosted.com (PPS) with ESMTPS id 3fb88f6b6b-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 12 Apr 2022 06:36:29 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=YewKrBYxtILaotv2DnNuQndhwavDQVQtalgKXZjRWwn4vQVdvH7h7xyXU8hLoiXIFw2UwlK+v7ayah5yADezsJB0UNuWLvl+GkII6BGJQvIhl2TFqi5fNlUrd9zx6GGQ3kXW/ziKxje947P+8hkY8UaiNEIUF2skUfNLbhAJk83SFgOYC23BSlVVEyQAXny2U+nPskf2hsPOvw3oQ7vofi9h1Rr/wulJMCdPjQ4MXjQLsuPTU/nrc6MEvPjE+Vkn4s33mma6UN+bP3QLxE8j8XPPSA6bCy0O/Oh8yfxqqGL6L8EulDOmjeDE5wf2yX74QEReL+JYfRv+Dc4rZU/59Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=DmGB4ICjZxrwO/3O/C/NYMSKZ5nCYhyG10cDKg84418=;
 b=gyUvIX1dBOZTDYHhUF/Kry1ma2k19DtiUNWNzubyeRk/hfppvwqtgvp9qi76pgDPsrqUN/P1syjEKWqs9XRzlZ7TB5Rx4G5pWxCHi7Khia8am/z9d6rX2jCgmo18rQD8Zoc6g6A6cEtwclCdSf+/+srk5RT6deDabOAI11VZkXP8N6LX6JKtU3VhjWe5TBFwf2J90cFYooGnb3jHQ+X79RWL3LlQ/SBrFwKsM2WJvQfd+J/f6vhxZs4Ndl0YGVItDsNTtZJblDqyX0c0lQKnerQ3k4MA9O7UkzI/8bPwDSAUb3tJ9le0lJ1FnTmvMMavpe4swHPAyneukePlwgfYLQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nutanix.com; dmarc=pass action=none header.from=nutanix.com;
 dkim=pass header.d=nutanix.com; arc=none
Received: from BL0PR02MB4579.namprd02.prod.outlook.com (2603:10b6:208:4b::10)
 by BN7PR02MB5217.namprd02.prod.outlook.com (2603:10b6:408:25::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5144.29; Tue, 12 Apr
 2022 13:36:20 +0000
Received: from BL0PR02MB4579.namprd02.prod.outlook.com
 ([fe80::b970:801c:2b4e:d3cf]) by BL0PR02MB4579.namprd02.prod.outlook.com
 ([fe80::b970:801c:2b4e:d3cf%4]) with mapi id 15.20.5144.029; Tue, 12 Apr 2022
 13:36:20 +0000
From:   Jon Kohler <jon@nutanix.com>
To:     Dave Hansen <dave.hansen@intel.com>
CC:     Jon Kohler <jon@nutanix.com>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        "x86@kernel.org" <x86@kernel.org>,
        "H. Peter Anvin" <hpa@zytor.com>, Tony Luck <tony.luck@intel.com>,
        Andi Kleen <ak@linux.intel.com>,
        Pawan Gupta <pawan.kumar.gupta@linux.intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Borislav Petkov <bp@suse.de>,
        Neelima Krishnan <neelima.krishnan@intel.com>,
        "kvm @ vger . kernel . org" <kvm@vger.kernel.org>
Subject: Re: [PATCH] x86/tsx: fix KVM guest live migration for tsx=on
Thread-Topic: [PATCH] x86/tsx: fix KVM guest live migration for tsx=on
Thread-Index: AQHYTc5N3PtRLPD03UaoXnwsq2NUS6zrGJQAgAACcQCAAEXKgIAA6CmA
Date:   Tue, 12 Apr 2022 13:36:20 +0000
Message-ID: <1767A554-CC0A-412D-B70C-12DF0AF4C690@nutanix.com>
References: <20220411180131.5054-1-jon@nutanix.com>
 <41a3ca80-d3e2-47d2-8f1c-9235c55de8d1@intel.com>
 <AE4621FC-0947-4CEF-A1B3-87D4E00C786D@nutanix.com>
 <e800ba74-0ff6-8d98-8978-62c02cf1f8ea@intel.com>
In-Reply-To: <e800ba74-0ff6-8d98-8978-62c02cf1f8ea@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3693.40.0.1.81)
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: dc4c4c95-f2c5-4173-069f-08da1c896df0
x-ms-traffictypediagnostic: BN7PR02MB5217:EE_
x-microsoft-antispam-prvs: <BN7PR02MB5217DA9B322289AE774A617BAFED9@BN7PR02MB5217.namprd02.prod.outlook.com>
x-proofpoint-crosstenant: true
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: JgH3npAQybIHBXpheuAHmsgyV0JNXVY6ZangMroSBfcev5j05vHdn57BTr2pNdAkrpp0xeUE2WrV/0e+T9hg2yLvLxIuS6X2v5LrdAa4IxX1ITLqaS9rJcj6fyQoX+z0MGNWArtucsMIQ0fRUzQhfZDQwOuLYsZDN+3kTdGeRa+IgFUZxKOSE1lTko0WaurhU7ZQ2eKVexUKUV2RBUjAYdMQEYJZvk99xBXvzHy/NUgorK5V2D1v9sV/+VHkWq4b2iklUG1ctbk/1FrBPgoKaRW2odPzScY4OfeSdjB6kkhh+LQ9bmGOpMGjhDlm2kkq1zAgbpyP/HGVJ9NkWpasWVDnIsQD/6kw7rZU03OGQYVMpdridLn32gkqSokqqBsi1heh2tbbOrszQq5R0h8H4Diz/21hFQA1+m+A88edhtreSeItTqTyuLqofYxdBqlMobHMebdm4T8wZE+54tAx7TcIy7tP585mYoL7UId0bTYXRiNMjejC8LlklotfmeUHdpDDITdqr/ZyE4AAnrS3RjWBkYZJMQ3+9+Enyj6g4HKa4tt0AYl21MGn0s/xBV1axUpvbNgQLp4jxX1KQ8LJubOOOZ+BEFFvJXIt4iibAjf1suJmfr9jF3Ei4c/lD+zfR5AUmL8YZhQB8i7AliTXlbYhEHg/2AXMcrsC1T9XMzSRqEhgvrKzJj/RJEfzSIguHxBKvYTuFFd5YtGTsyrccrZ5A1mXIO2nKCslWiawr/Rxkhqep6JmVCkC5b1g9yAV
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL0PR02MB4579.namprd02.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(508600001)(6506007)(4326008)(6512007)(8936002)(38070700005)(5660300002)(71200400001)(122000001)(7416002)(86362001)(36756003)(8676002)(186003)(76116006)(91956017)(66946007)(66556008)(66476007)(66446008)(316002)(38100700002)(6916009)(6486002)(54906003)(2906002)(64756008)(33656002)(53546011)(2616005)(45980500001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 2
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?S2lETVVOcldrV0lna29YcXRteTRKeTl3ZGZhdEgxdmtxYkRCTzJCWHlxbDYx?=
 =?utf-8?B?UVJ3bHpXSVFXL2ZndHVsRWtxV0VITW9ReWp2cXdYYkVwbG9CYXZhZWc2aXNu?=
 =?utf-8?B?YjhsUTYvU1ZRN2JpUGNXcDFBeUtzQ2UxS21SUDJTdy9lMW8vVUg4QjE0ZGhQ?=
 =?utf-8?B?MGtISHRwNFZYU1o4WHc4NlBVVjN6QTI0K1dwZFluaXZZUHBGeURrNCtLdDlY?=
 =?utf-8?B?WFBRbmNsakJuUUI2ZlRhZWUyVXhGN3NwTVo3RlVEOXFERC9abDhCSm9ZM3E3?=
 =?utf-8?B?RlZiaHpvMEo2a2lNTm1ZVmR5b3FuYXE2TzBMTUU3YU9CTCtZc2tqczlsb2Er?=
 =?utf-8?B?akU3TlpaS2lYL0tUV1lBWkQ0YUgrMERzR3U2Mld1NEl1bEtVN2U0VUJUSGth?=
 =?utf-8?B?NEJrOXNxdll1V0RwM3d4TmZPaEJ2UzNmWkx0M2VlaytFcFBiOWFOMktGUTdR?=
 =?utf-8?B?bGVQZWhqSGJTSnF5MjNPWmxCUUtmajhmbldaRE9GYjVrdWdTYm8yNUhiZUVP?=
 =?utf-8?B?Ly8wV2J2UWJyTDRnTjZjNC9ZMXoyVUQwSlRta1hnUXhNeDc3eU5tL3JrN1hi?=
 =?utf-8?B?aExWdFBsR1M5ekN4YnpFNWlOSGtHdkJndTRyWGZRNHRHNlBaMW04NkRwQ2N6?=
 =?utf-8?B?eGFBRTJUUjdYdm80UUFQSkhhY01UVklPRHQwcUtqeUU1eFIzaVZMSUpwNG1u?=
 =?utf-8?B?aStDa3RnblptZlN4cFMvbVN0ZnNnVUdVWFU4aEY3ZVNGVlBmVlJmM1h0UnN2?=
 =?utf-8?B?TG9kak4vcEJObVk3Z2lxOFlmTnQ4WW4rR3ZaY3hCYnRpK1dGN0hpMS9hT2pR?=
 =?utf-8?B?ZzBKL3VpMUlJengvYkV5UmpYS3NUajZkelhjT0NTSTNqcCtja09kc3FMSVRm?=
 =?utf-8?B?cVB6bTF5Sk0yUEpHYWNYbE9MM2RxYXFKMzRjcTNHb0lFM3U0Y2FZL3RHZnI0?=
 =?utf-8?B?MlpZenBQSTkxbWZvOU1OZ0RTVjl1TjVJTy90SGFvcUdKMXNaU0N1ZXhhVGxw?=
 =?utf-8?B?UjlJUEZETkovUGNIeUZVa0hnZ1RGUGRQK3dmUGx2TlR1YkNla0pzeWorRW9W?=
 =?utf-8?B?cDM5YjZhdTNVbElFL091ZlFVR0dBUkFZYVdYYW1jQ25FbklkbFhRR3BFcTVF?=
 =?utf-8?B?eXVQT3ptSGprY2Ruelk3MmR3T2hQUHR4TlQ5eTZMeEIwWkpWNDNDZGI0QTMz?=
 =?utf-8?B?Z1ltRzUzclVmWC9iN3dZQlYwTk5vL3pNVzVJV1ZobytSZzZoaDZoNUdTcGda?=
 =?utf-8?B?bTJmR21XbXpwYkE1U3VRU1FadmdGbUxHZ1N6OTZod1ROY2dmUTdMM2lneER6?=
 =?utf-8?B?RW9iYXlsaUNScHFTT1ozWVRHN0duNis0NHhzQjBvNHhjUGdIc2paU0tiY3Qr?=
 =?utf-8?B?cGtQNEhiMnpXOTVkSGREYUxBWkxaZFNNaVB2RzhkZC9ueFl6R0F2bFFEWkQr?=
 =?utf-8?B?T0xmaE55b0RWTnBIdGhCUEN2d05Gd2hpc2RMZ0ZQN2kzem8zeVJrWjExRUs0?=
 =?utf-8?B?U1pWQ00rVHpVUDJSVDhxSHI0QXdOUEpGSzlUbHNHUmZDZGJ1dHhMUk40b1Rk?=
 =?utf-8?B?Ym9HRG44STlUTTlYcWszS0xZNzdwd0N1MXA3UWI4UlVNWlV1clpjcEVRa0Vq?=
 =?utf-8?B?am5vNUZ5YjNxZzIyMmNiSmh3UkJweitIYUEwbm81QlRHWXFrMVZ0QkpOV1ht?=
 =?utf-8?B?cmlZdG1kYXg0aFprb0dFSTVnUVl3MmYySzc0Zzh1bDYzNmt2YnpFQkxmaUV4?=
 =?utf-8?B?VVdZUVJudElpejMwQXhGU2FiRDNZb2NuUmx5N2p2a0hwalFoZ3dyNHVjVFRN?=
 =?utf-8?B?cGQwU2l4QUpGbWM3QmMxaXRndlNFUTFsQmtoTFJaZThsdWMwazJEb3NBOWRM?=
 =?utf-8?B?MGJPM3ZDNWd2RHVGaEx6Rm8vQXV5eE1ucWdJeVQwSGFEc2dmSWRFTW85aUdr?=
 =?utf-8?B?Z3V0NEJmNWJxdndKVitUaFlzZW1EREUxZ1JoOS83NnFSUzRqcHRLdTdBUGZn?=
 =?utf-8?B?WS96RTYvUkJoR1l4anBhb2paRDEyUndVYXJlSmk2Q2RIOXZzUEJhcnQrOEhP?=
 =?utf-8?B?aUxVZ3hyQ3l1RVZ3ZzNEbzZiME12WkVDU3ZTSlhqaFRMRmZSc3JYWDYxaEgv?=
 =?utf-8?B?d1hHMnBialRka0hsMXlBMUE5UWh4YUdzQzZUUzdUd3QvU1FRVjZaZktweHZS?=
 =?utf-8?B?V0Y0UmVGSDk1MG54RlpaUmExUjUwRVpTOTlDSlN6bXZ0WlF1T0VwL0xZUFF0?=
 =?utf-8?B?Y2ZIWFl1VE51WnMrSExRNFNleWw5U3pjVXFIalQ4dHU1VDM1L0trb05Sa2I5?=
 =?utf-8?B?bzdPZEI1UGFROTk3cUtwanFPbXp4WitzRWxqdk8zRG9sUVUrb0hvMzFyQ1dR?=
 =?utf-8?Q?ykJiAwAD/FSdazNokELi20vOM1IPvTVv4B2/ZsiALJNv0?=
x-ms-exchange-antispam-messagedata-1: srIBkuruf3DuPm1VsgaTcf0Dfiiobld9AHN36dRCUMdPTZ+8JodQdBAm
Content-Type: text/plain; charset="utf-8"
Content-ID: <1EE15EDCA45F294BA3E8C093775850B5@namprd02.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: nutanix.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL0PR02MB4579.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: dc4c4c95-f2c5-4173-069f-08da1c896df0
X-MS-Exchange-CrossTenant-originalarrivaltime: 12 Apr 2022 13:36:20.5953
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: bb047546-786f-4de1-bd75-24e5b6f79043
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: HZUROLiIuJI8/+iq7SgMuW5HjZs7byAQNhAfoTquMc8YXR+WOehyKl5dhk7YVUgR5CCQDLSmkSVmxwfIddZeoCs6vFTzwVO7q1rrnqveNdQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN7PR02MB5217
X-Proofpoint-ORIG-GUID: -A-2d-sTlJOQhmcB6_iTwzLq7wZ6w0PI
X-Proofpoint-GUID: -A-2d-sTlJOQhmcB6_iTwzLq7wZ6w0PI
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.858,Hydra:6.0.486,FMLib:17.11.64.514
 definitions=2022-04-12_05,2022-04-12_02,2022-02-23_01
X-Proofpoint-Spam-Reason: safe
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

DQoNCj4gT24gQXByIDExLCAyMDIyLCBhdCA3OjQ1IFBNLCBEYXZlIEhhbnNlbiA8ZGF2ZS5oYW5z
ZW5AaW50ZWwuY29tPiB3cm90ZToNCj4gDQo+IE9uIDQvMTEvMjIgMTI6MzUsIEpvbiBLb2hsZXIg
d3JvdGU6DQo+PiBBbHNvLCB3aGlsZSBJ4oCZdmUgZ290IHlvdSwgSeKAmWQgYWxzbyBsaWtlIHRv
IHNlbmQgb3V0IGEgcGF0Y2ggdG8gc2ltcGx5DQo+PiBmb3JjZSBhYm9ydCBhbGwgdHJhbnNhY3Rp
b25zIGV2ZW4gd2hlbiB0c3g9b24sIGFuZCBqdXN0IGJlIGRvbmUgd2l0aA0KPj4gVFNYLiBOb3cg
dGhhdCB3ZeKAmXZlIGhhZCB0aGUgcGF0Y2ggdGhhdCBpbnRyb2R1Y2VkIHRoaXMgZnVuY3Rpb25h
bGl0eQ0KPj4gSeKAmW0gcGF0Y2hpbmcgZm9yIHJvdWdobHkgYSB5ZWFyLCBjb21iaW5lZCB3aXRo
IHRoZSBtaWNyb2NvZGUgZ29pbmcNCj4+IG91dCwgaXQgc2VlbXMgbGlrZSBUU1jigJlzIG51bWJl
cmVkIGRheXMgaGF2ZSBjb21lIHRvIGFuIGVuZC4gDQo+IA0KPiBDb3VsZCB5b3UgZWxhYm9yYXRl
IGEgbGl0dGxlIG1vcmUgaGVyZT8gIFdoeSB3b3VsZCB3ZSBldmVyIHdhbnQgdG8gZm9yY2UNCj4g
YWJvcnQgdHJhbnNhY3Rpb25zIHRoYXQgZG9uJ3QgbmVlZCB0byBiZSBhYm9ydGVkIGZvciBzb21l
IHJlYXNvbj8NCg0KU3VyZSwgSSdtIHRhbGtpbmcgc3BlY2lmaWNhbGx5IGFib3V0IHdoZW4gdXNl
cnMgb2YgdHN4PW9uIChvcg0KQ09ORklHX1g4Nl9JTlRFTF9UU1hfTU9ERV9PTikgb24gWDg2X0JV
R19UQUEgQ1BVIFNLVXMuIEluIHRoaXMgc2l0dWF0aW9uLA0KVFNYIGZlYXR1cmVzIGFyZSBlbmFi
bGVkLCBhcyBhcmUgVEFBIG1pdGlnYXRpb25zLiBVc2luZyBvdXIgb3duIHVzZSBjYXNlDQphcyBh
biBleGFtcGxlLCB3ZSBvbmx5IGRvIHRoaXMgYmVjYXVzZSBvZiBsZWdhY3kgbGl2ZSBtaWdyYXRp
b24gcmVhc29ucy4NCg0KVGhpcyBpcyBmaW5lIG9uIFNreWxha2UgKGJlY2F1c2Ugd2UncmUgc2ln
bmVkIHVwIGZvciBNRFMgbWl0aWdhdGlvbiBhbnlob3cpDQphbmQgZmluZSBvbiBJY2UgTGFrZSBi
ZWNhdXNlIFRBQV9OTz0xOyBob3dldmVyIHRoaXMgaXMgd2lja2VkIHBhaW5mdWwgb24NCkNhc2Nh
ZGUgTGFrZSwgYmVjYXVzZSBNRFNfTk89MSBhbmQgVEFBX05PPTAsIHNvIHdlJ3JlIHN0aWxsIHNp
Z25lZCB1cCBmb3INClRBQSBtaXRpZ2F0aW9uIGJ5IGRlZmF1bHQuIE9uIENMWCwgdGhpcyBoaXRz
IHVzIG9uIGhvc3Qgc3lzY2FsbHMgYXMgd2VsbCBhcw0Kdm1leGl0cyB3aXRoIHRoZSBtZHMgY2xl
YXIgb24gZXZlcnkgb25lIDooDQoNClNvIHRzeD1vbiBpcyB0aGlzIG9kZGJhbGwgZm9yIHVzLCBi
ZWNhdXNlIGlmIHdlIHN3aXRjaCB0byBhdXRvLCB3ZSdsbCBicmVhaw0KbGl2ZSBtaWdyYXRpb24g
Zm9yIHNvbWUgb2Ygb3VyIGN1c3RvbWVycyAoYnV0IFRBQSBvdmVyaGVhZCBpcyBnb25lKSwgYnV0
DQppZiB3ZSBsZWF2ZSB0c3g9b24sIHdlIGtlZXAgdGhlIGZlYXR1cmUgZW5hYmxlZCAoYnV0IG5v
IG9uZSBsaWtlbHkgdXNlcyBpdCkNCmFuZCBzdGlsbCBoYXZlIHRvIHBheSB0aGUgVEFBIHRheCBl
dmVuIGlmIGEgY3VzdG9tZXIgZG9lc24ndCB1c2UgaXQuDQoNClNvIG15IHRoZW9yeSBoZXJlIGlz
IHRvIGV4dGVuZCB0aGUgbG9naWNhbCBlZmZvcnQgb2YgdGhlIG1pY3JvY29kZSBkcml2ZW4NCmF1
dG9tYXRpYyBkaXNhYmxlbWVudCBhcyB3ZWxsIGFzIHRoZSB0c3g9YXV0byBhdXRvbWF0aWMgZGlz
YWJsZW1lbnQgYW5kDQpoYXZlIHRzeD1vbiBmb3JjZSBhYm9ydCBhbGwgdHJhbnNhY3Rpb25zIG9u
IFg4Nl9CVUdfVEFBIFNLVXMsIGJ1dCBsZWF2ZQ0KdGhlIENQVSBmZWF0dXJlcyBlbnVtZXJhdGVk
IHRvIG1haW50YWluIGxpdmUgbWlncmF0aW9uLg0KDQpUaGlzIHdvdWxkIHN0aWxsIGxlYXZlIFRT
WCB0b3RhbGx5IGdvb2Qgb24gSWNlIExha2UgLyBub24tYnVnZ3kgc3lzdGVtcy4NCg0KSWYgaXQg
d291bGQgaGVscCwgSSdtIHdvcmtpbmcgdXAgYW4gUkZDIHBhdGNoLCBhbmQgd2UgY291bGQgZGlz
Y3VzcyB0aGVyZT8NCg0KSW4gdGhlIG1lYW4gdGltZSwgSSBkaWQgc2VuZCBvdXQgYSB2MiBwYXRj
aCBmb3IgdGhpcyBzZXJpZXMgYWRkcmVzc2luZyB5b3VyDQpjb21tZW50cy4NCg0KVGhhbmtzIGFn
YWluLA0KSm9u
