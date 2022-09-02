Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 924D15AB259
	for <lists+kvm@lfdr.de>; Fri,  2 Sep 2022 15:57:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237959AbiIBN5J (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 2 Sep 2022 09:57:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35708 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238454AbiIBN4r (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 2 Sep 2022 09:56:47 -0400
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.153.233])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0311213D65;
        Fri,  2 Sep 2022 06:30:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1662125429; x=1693661429;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=urIbbtvhnA3dR3pUc/D2C9wT7I6D568A6XeHBLGvU2I=;
  b=LRRY4/yRQXMpm8FEKBflHZp8KvgyRggIra034Izbwb6eaxdNKeYMhGGX
   Y8RnN05DSYxaYklQyjVM2ODw3Eb5qa+RpUyqqWG9FDXS8uKFefIlusHfl
   3PZIdg/4xDG1QrUAgJzUCDkkIRlCLFNX6r4s8mRjfzKv05ldejJDGo/95
   G+Ioifp1wq/ao5u5LlFcljkYGNKKSMjuKGpi30MdDVeVQhSfsSSoyRoYn
   M+J3U1EkbmDzdIi/I7CxcBmvcrNv+PIgAgGsrNJQeYEtBraSgnT41goCb
   XRcAVNr84JR8CeLZvszTCAilssnsH2oDgnRnTH4PfKUFSPtjkt2njo8Kj
   Q==;
X-IronPort-AV: E=Sophos;i="5.93,283,1654585200"; 
   d="scan'208";a="178801944"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa5.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 02 Sep 2022 06:29:29 -0700
Received: from chn-vm-ex01.mchp-main.com (10.10.85.143) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.12; Fri, 2 Sep 2022 06:29:28 -0700
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (10.10.215.89) by
 email.microchip.com (10.10.87.71) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.12 via Frontend
 Transport; Fri, 2 Sep 2022 06:29:28 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=bRfkZEQi3fVG1EtjZhg/C3JjddEj3ZplVcGgd2GqkHjGbkKa55LoZBwr5sY/Zi0SnfV39OX8A7XSHQchIBN4n5bygp8PAbTsByrGlujgzu/3U39V5ThXt1I5y8B4QvRD4rnkWadK4/DC2d3e+UW1twMcvt2vroJ97TvsOZu+5wLy27EN3zGJGTiK8VoOdqAyPCNZ+fsiA7ByG0TrTyjPg2vTs/7KK0DV9r3t3XG4b83Wjylxl4n0DK9kjbAw59HZpLnBOajSGPpAHuIZM867ap79radFjvvPryicX3O5BsXc42LGhxrWgjEMBUACcAleNoTgQf75clRaqow/DiRHUw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=urIbbtvhnA3dR3pUc/D2C9wT7I6D568A6XeHBLGvU2I=;
 b=bbp8cdMf54O2FzEIP9zxp1st0U3MFkUIFMMOgY6+aEMJ5nAW2D1pQmjdIrPyx45ToNFudnpl5T6nmPUg5yeRpyTlR67wxNp26BSOUXkUJOXIb2xGdeZv4FStYhawvaFhbqrTMRThwjKqwqvOjK2KH7vVL1NlYE1D919s71u0FR/WC8hInD+yeA+uI7bTIJKayyn9tLU7WQyrArvs6xqm1O7oGpB8SGByU9xoFbCCn/xSerLIuoWpUfvQ+xJID/bKj6IcJ7rXhgm9WFBuEc0W6QjVHBj9ukli3nvATpYhdMMcsBBGmAWZLtX78LCO1qLpOiRN6mcNuFXXfTlnMYK02Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microchip.com; dmarc=pass action=none
 header.from=microchip.com; dkim=pass header.d=microchip.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=microchiptechnology.onmicrosoft.com;
 s=selector2-microchiptechnology-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=urIbbtvhnA3dR3pUc/D2C9wT7I6D568A6XeHBLGvU2I=;
 b=XdadAopKaa3DcJTDKkqk2lK87YQ2b7WoZ9o+5sgnvbn/Yb3ba/WK4c7J3zxcIPJFlj1esl8+HDrr/eXd18RnFltfULrLGh8OZUNZSeAOICRHV5/bg2r1SX/reAX8XRM7zgp/xOZ+KOAAMeK0n+TMMIKavGl5IFoeaITn6lR1O+s=
Received: from CO1PR11MB5154.namprd11.prod.outlook.com (2603:10b6:303:99::15)
 by SN6PR11MB2768.namprd11.prod.outlook.com (2603:10b6:805:62::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5566.15; Fri, 2 Sep
 2022 13:29:23 +0000
Received: from CO1PR11MB5154.namprd11.prod.outlook.com
 ([fe80::545a:72f5:1940:e009]) by CO1PR11MB5154.namprd11.prod.outlook.com
 ([fe80::545a:72f5:1940:e009%3]) with mapi id 15.20.5588.016; Fri, 2 Sep 2022
 13:29:23 +0000
From:   <Conor.Dooley@microchip.com>
To:     <jszhang@kernel.org>
CC:     <paul.walmsley@sifive.com>, <palmer@dabbelt.com>,
        <aou@eecs.berkeley.edu>, <anup@brainfault.org>,
        <atishp@atishpatra.org>, <bigeasy@linutronix.de>,
        <tglx@linutronix.de>, <rostedt@goodmis.org>,
        <linux-riscv@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        <kvm@vger.kernel.org>, <kvm-riscv@lists.infradead.org>
Subject: Re: [PATCH v2 0/5] riscv: add PREEMPT_RT support
Thread-Topic: [PATCH v2 0/5] riscv: add PREEMPT_RT support
Thread-Index: AQHYvWTJWdidtLbFYESs6cM+7jS71q3KyLAAgAFXEYCAAAVoAA==
Date:   Fri, 2 Sep 2022 13:29:23 +0000
Message-ID: <ea5cdba4-7a79-56b3-f8d7-7785569dedd6@microchip.com>
References: <20220831175920.2806-1-jszhang@kernel.org>
 <4488b1ec-aa34-4be5-3b9b-c65f052f5270@microchip.com>
 <YxIAmT2X9TU1CZhC@xhacker>
In-Reply-To: <YxIAmT2X9TU1CZhC@xhacker>
Accept-Language: en-IE, en-US
Content-Language: en-IE
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.12.0
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=microchip.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 136e0cdf-abdf-439d-c1e6-08da8ce72678
x-ms-traffictypediagnostic: SN6PR11MB2768:EE_
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: b/nlzkcl+sH6V5RArFzImrRy0ueeiTgnxCiBz1c8xoBYK8wKCvt3eVHph7czh1lVq4p5xpWUCzB5gDuBoJtCnkcOpB6sd9cJgk0+kupCBPRt6NtO9gIiDLokG6l8UDTpbrZt+QpYhNne7zi/xlgW9/SzURfJbYOP/SLKFh6PFxH2z5eUhBX8TgSOPe1sp1a9KoNfrNJ9ClvvTa8QMZ5NQ5ZaFK3/oFTDYa632caNSo9UXsf77sVOlpmQ43UM4IQXE0paYIOZlghEI4nREqSMDlbEMTmYNYhEcuE973KA5ATPQKwpBTce9S9jo13uLFZ50GrZbw3GcmDKX6VBiLOgvY0HBySN78vDoor3SP7RBsl+gi6XmWTUHvr/4W2cFezZYU5sUxxSMNeu4cRbL7/saWcCnD0bOOOAKoIS8Y1jpV4g4Mr3AaJNqgcZmZ6OcvAq9pKSKqZJLhDal+cShwTkgEGmJuDgle85OAyT65Ky1ft+Ag8rSDN7G9GMX3I0TJphNvDlhWv/BLO5py0JsxhOC2lpYUaF78uq/D3VZaLPXDmv4TIxN/Qj1t43UtHJsq18GDhAxyLkpvl9vy6vrjFXULck9tnHKYYqQ0RPKDFre670x7OkJuHknQ80+xksRTVEbXhGESzKluV8h/YtOIi1mUyOUuxpFqxEuNld2R0RZoWpnmkCEHyomU7lacr5FJWlVeJKqGy4rEQgnJSB3xvVKiIItt+25AOw/TPmoVu8vTLiyApDKy+D/XXm0u54G39Mrhyu3U9/wZHw64jErtPFSqUcx6dqgJtaVObKBWu6YA37eXi57YAXkcax/BpC1+QlvQjdQl/JK/sVIvhYmY771rUK9xYgV9MlK9uCEmPxdPs=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO1PR11MB5154.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(346002)(376002)(366004)(396003)(136003)(39860400002)(966005)(66556008)(2906002)(6486002)(66446008)(66946007)(4326008)(41300700001)(64756008)(478600001)(91956017)(66476007)(5660300002)(7416002)(8676002)(8936002)(83380400001)(6916009)(76116006)(26005)(6506007)(6512007)(54906003)(53546011)(38070700005)(316002)(71200400001)(31686004)(186003)(31696002)(122000001)(38100700002)(86362001)(2616005)(36756003)(43740500002)(45980500001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?ZWY3RWo5d1lnRGpIMVJXdlJKQmw1aFNway9TNVo2NGdNaGpMajROUU43cTdS?=
 =?utf-8?B?a3JVZ1hZdmFVbTFBZnc1OWhtQndGYmJ1NzNNTUhjbFN6MjJCTWJvMjZPcERB?=
 =?utf-8?B?Y3dGMUJxVStCeG5UWkRnZGUzZzQzcmg2aEZpVHJ1VzVRTlh5QkVkcFJWdEVW?=
 =?utf-8?B?bzhhZXM3Mk9oWHRsSXkycmJiYy85WFI1OU0xOTNwSEhyaFpPSWRFYkNsQlEx?=
 =?utf-8?B?SkoyMHBGamllMTVhRkFUMFdZWWJKUEZPZmhKYUdmd0dNUitsM2JZemNRLzly?=
 =?utf-8?B?L3FGK3VGUWRrWFJFRnVFVTZHclhzMWpMOUNjcWFJRzE0Y3VnSEVKTUtOYnZz?=
 =?utf-8?B?ZnpkWm1CUmM5bDJ3NU10MGVGcWZCdVp0OVBMdWlrdUYzL3RNL2Y4dHYrbkxm?=
 =?utf-8?B?K1hRZXpIblVRMzM3V2tYc1FIMHdITzBvN2RkclJJTFhyaEFxZllDOTByVUpr?=
 =?utf-8?B?cGoxVDR1R0hJRWIyV3FiVjlyZ1dqL3gxejYxd25qT3dyZ3RvdEM3bk80WTM4?=
 =?utf-8?B?RkhqTDdjeS9qdW5EV1FHTk9DdEN1THo5OE9ZeHVKbFpBQnVtTW1UL0wwdU1F?=
 =?utf-8?B?VkY5bDQwUkIzbHRETU5JM2hpSUR4SlNLeUxHSVJrSElESHJJTEpDa29oaG1w?=
 =?utf-8?B?RG82TkhGSFdSMzhPdU1iNmR1N09XZWJxVXo5MUZXdEw0SElJNHRneDZKaVZ0?=
 =?utf-8?B?cG1wUHhKYWFkZjFrWWRBTkRteFFzWVcrbmIwK0Y5T0hTYjFnb0MvWXoweEJN?=
 =?utf-8?B?eG5iVUR1L0JmT1BYOEI5bldsREVxaUF2RjdHbnR4WDRJSEJxMGtSZDE5TWhE?=
 =?utf-8?B?M09BUkEycWp6SEJ4Wnc3dmU2WmtUbnV3ZW9IRzg4ekZDZjEza0tDVU1NRDFs?=
 =?utf-8?B?bTBObzZWaE53bkRySHIwU1dTZzQ0N0x2N1U5b1kzNkhFeDE4K0Q2bURYQU4r?=
 =?utf-8?B?bXJxR3ZEMnMzQlR3am9KaWUzV01HbEMxNm5KTW11aFA5ZVl3cEVyeDV5aU44?=
 =?utf-8?B?Q0FKZVlWVzlvS0xIYlBzOVpHSVZZMmJFSitwMkcxWkRYRkNUK3BFbEJvVUFB?=
 =?utf-8?B?RWl5ZkZNenI1eWJPbnlHWDBhVlZzZVl1UHhKWlZ3cFdTQ0M4V1UwMU1HU3ZR?=
 =?utf-8?B?ODI0M3dZdUtWU08rWHBaaTJzM1FZWWdUZjl5WXBnVDNRbFRrSGQ2aHhJZllR?=
 =?utf-8?B?cE82cllQR2d4TWpENDdzaGN5RkhET0ZlbHEzOFdKOUdaQjczYVhnWVVGQ2xC?=
 =?utf-8?B?aEZFUklwaDlUTElBNHJkS0hmb0NvZHFhd2dIZkdBL292MWVHYmNIcVlnUTBh?=
 =?utf-8?B?RElSRjl4VjlpNzZ6d2NETU9RZ2wzZDZkUWc3NXdCYzlMdWtiM0dWNCsrL2xF?=
 =?utf-8?B?bXlYWU1UUDE0K2lvMlF5L2tQR2F2YWtZSnBRK0o4Yy9lMGNZMHp3NkZNNWl5?=
 =?utf-8?B?dW5MT0xzdjZQdXo3TWQ2RmdyTzZhRlVIdno4Q0lscHdOSzFlOE56Nml1NGs0?=
 =?utf-8?B?ZnVvQlBJNjZyaTdXQVdUZlpuMFdUbFJuNndvUEhsdzk4cXFlZFpvQ2VKL2J2?=
 =?utf-8?B?SXE5UkpscENSNUJJbHN6ZytoZUg0SVoyNGdBS2duWVJRSzU1TGVYWEFOazJ5?=
 =?utf-8?B?Nk5uekdpdDJlNkZWVzRwWVdHUmJxRy9IRzVqMk13cndDTjhlSk51ZHNpLzJm?=
 =?utf-8?B?S1g2REl6bkQzWHU4MlcxbTZpaWJEajhOSlNhdERqUUFidUgwN0IyNDBHVEhr?=
 =?utf-8?B?b3V3UFRja1JCU1hEMmY3TDlldmFqR0k0c3JDdGU3c0NzVHN0dC9xYklVUEho?=
 =?utf-8?B?QTlhbGdvd3RHK0lyT0dQMHUvVGJxMEVDV2dOK0tZdDVWUWtxdnNveTZBa0JW?=
 =?utf-8?B?bnZIcHJpZWdLb2Q2TnpmS0VFVGh5Z2FVQ0c3ZEVLWUJDQkk2djlHUkcvUzh4?=
 =?utf-8?B?T28yY1BRS0sxL011SEpGSDZxWkF6YnROUU1VR0dYOTRQREJ3bitSZkZZMnRH?=
 =?utf-8?B?WlhQdGd1REp4SHVIZEEyK2d0YWJTcDA5RUlvdlRxakFaMjdIczJkOHgvZkVD?=
 =?utf-8?B?VHhyYzMwTmhpMlc3TTk3T1IwQ3FXWUpIVnJjQmgrSmhndnluc20xSDU4VlNw?=
 =?utf-8?Q?tidhlLV+es7Zw0+HiygjQnfL+?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <0B6CD9E4A441894FADBB459D05ABA956@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: CO1PR11MB5154.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 136e0cdf-abdf-439d-c1e6-08da8ce72678
X-MS-Exchange-CrossTenant-originalarrivaltime: 02 Sep 2022 13:29:23.6816
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3f4057f3-b418-4d4e-ba84-d55b4e897d88
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: AdUjXeogYqJGx1WjN4j8CpbxgUNkhCzYVNCgk+lfazDhYeGXfmgvxt7lV7rPzpzWm2GvtqVFnf4KQ8gMX6jL9A3FkMUdF7STjXdJpDaFlFw=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR11MB2768
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

T24gMDIvMDkvMjAyMiAxNDowOSwgSmlzaGVuZyBaaGFuZyB3cm90ZToNCj4gRVhURVJOQUwgRU1B
SUw6IERvIG5vdCBjbGljayBsaW5rcyBvciBvcGVuIGF0dGFjaG1lbnRzIHVubGVzcyB5b3Uga25v
dyB0aGUgY29udGVudCBpcyBzYWZlDQo+IA0KPiBPbiBUaHUsIFNlcCAwMSwgMjAyMiBhdCAwNDo0
MTo1MlBNICswMDAwLCBDb25vci5Eb29sZXlAbWljcm9jaGlwLmNvbSB3cm90ZToNCj4+IE9uIDMx
LzA4LzIwMjIgMTg6NTksIEppc2hlbmcgWmhhbmcgd3JvdGU6DQo+Pj4gRVhURVJOQUwgRU1BSUw6
IERvIG5vdCBjbGljayBsaW5rcyBvciBvcGVuIGF0dGFjaG1lbnRzIHVubGVzcyB5b3Uga25vdyB0
aGUgY29udGVudCBpcyBzYWZlDQo+Pj4NCj4+PiBUaGlzIHNlcmllcyBpcyB0byBhZGQgUFJFRU1Q
VF9SVCBzdXBwb3J0IHRvIHJpc2N2Og0KPj4+IHBhdGNoMSBhZGRzIHRoZSBtaXNzaW5nIG51bWJl
ciBvZiBzaWduYWwgZXhpdHMgaW4gdkNQVSBzdGF0DQo+Pj4gcGF0Y2gyIHN3aXRjaGVzIHRvIHRo
ZSBnZW5lcmljIGd1ZXN0IGVudHJ5IGluZnJhc3RydWN0dXJlDQo+Pj4gcGF0Y2gzIHNlbGVjdCBI
QVZFX1BPU0lYX0NQVV9USU1FUlNfVEFTS19XT1JLIHdoaWNoIGlzIGEgcmVxdWlyZW1lbnQgZm9y
DQo+Pj4gUlQNCj4+PiBwYXRjaDQgYWRkcyBsYXp5IHByZWVtcHQgc3VwcG9ydA0KPj4+IHBhdGNo
NSBhbGxvd3MgdG8gZW5hYmxlIFBSRUVNUFRfUlQNCj4+Pg0KPj4NCj4+IFdoYXQgdmVyc2lvbiBv
ZiB0aGUgcHJlZW1wdF9ydCBwYXRjaCBkaWQgeW91IHRlc3QgdGhpcyB3aXRoPw0KPiANCj4gdjYu
MC1yYzEgKyB2Ni4wLXJjMS1ydCBwYXRjaA0KPiANCj4+DQo+PiBNYXliZSBJIGFtIG1pc3Npbmcg
c29tZXRoaW5nLCBidXQgSSBnYXZlIHRoaXMgYSB3aGlybCB3aXRoDQo+PiB2Ni4wLXJjMyArIHY2
LjAtcmMzLXJ0NSAmIHdhcyBtZWFudCBieSBhIGJ1bmNoIG9mIGNvbXBsYWludHMuDQo+PiBJIGFt
IG5vdCBmYW1pbGlhciB3aXRoIHRoZSBwcmVlbXB0X3J0IHBhdGNoLCBzbyBJIGFtIG5vdCBzdXJl
IHdoYXQNCj4+IGxldmVsIG9mIEJVRygpcyBvciBXQVJOSU5HKClzIGFyZSB0byBiZSBleHBlY3Rl
ZCwgYnV0IEkgc2F3IGEgZmFpcg0KPj4gZmV3Li4uDQo+IA0KPiBDb3VsZCB5b3UgcGxlYXNlIHBy
b3ZpZGUgY29ycmVzcG9uZGluZyBsb2c/IFVzdWFsbHksIHRoaXMgbWVhbnMgdGhlcmUncw0KPiBh
IGJ1ZyBpbiByZWxhdGVkIGRyaXZlcnMsIHNvIGl0J3MgYmV0dGVyIHRvIGZpeCB0aGVtIG5vdyBy
YXRoZXIgdGhhbg0KPiB3YWl0IGZvciBSVCBwYXRjaGVzIG1haW5saW5lZC4NCg0KSSB0cmllZCBp
dCBvbiBQb2xhckZpcmUgU29DLiBJIGtub3cgdGhhdCBhdCBsZWFzdCBvbmUgb2YgdGhlIHByb2Js
ZW1zDQpJIGZvdW5kIGlzIGRvd24gdG8gZHJpdmVycyAtIHNwZWNpZmljYWxseSB0aGUgc3lzdGVt
IGNvbnRyb2xsZXIgJiBod3JuZy4NCg0KVGhlIGZpcnN0IGlzc3VlIHRoYXQgY29tZXMgdXAgaXMg
aW4gZWFybHkgc21wIHNldHVwIGNvZGUgLSB3ZSBjYWxsIG91dA0KdG8gdXBkYXRlX3NpYmxpbmdz
X21hc2tzKCkgd2hpY2ggZG9lcyBhbiBhbGxvYyB3aXRoIHByZWVtcHRpb24uIEl0J3MNCnRoZSBz
YW1lIGJhY2t0cmFjZSBmcm9tIGhlcmU6DQoNCmh0dHBzOi8vbG9yZS5rZXJuZWwub3JnL2FsbC8w
YWJkMGFjZi03MGExLWQ1NDYtYTUxNy0xOWVmZTYwMDQyZDFAbWljcm9jaGlwLmNvbS8NCg0KSSds
bCBnaXZlIGl0IGEgcnVuIHRocm91Z2ggdG9uaWdodCBvciB0b21vcnJvdyAmIGdpdmUgeW91IGEg
ZnVsbCBsb2cNCm9mIHdoYXQgSSBzYXcuIFRoZXJlJ3Mgc29tZSBzcGxhdHMgYWxsIG92ZXIgdGhl
IHBsYWNlIGZvciBtZSwgYnV0IEkNCmNhbid0IHRlbGwgaWYgdGhhdCdzIGp1c3Qga25vY2stb24g
ZnJvbSB0aGUgb3RoZXIgaXNzdWVzLg0KDQpUaGFua3MsDQpDb25vci4NCg0KDQo=
