Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D87155F4967
	for <lists+kvm@lfdr.de>; Tue,  4 Oct 2022 20:48:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229812AbiJDSsU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 4 Oct 2022 14:48:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50930 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229472AbiJDSsR (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 4 Oct 2022 14:48:17 -0400
Received: from na01-obe.outbound.protection.outlook.com (mail-westcentralusazon11010010.outbound.protection.outlook.com [40.93.198.10])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A22C469F69;
        Tue,  4 Oct 2022 11:48:15 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=faXLpyR817QtBcFMKI0+xw3BvO3d9Ve+n3TqY+weBJyLPNH9dd8+4UFDqqmnEL7a/59jXuNGQV67t6uucgJcs/2reRrEiY/KNuNI5i7eXQ16q2g2IMPDI1QL5+45qZSKUzu1GWfn4TX+tQCBvEG4XwwLni7dbh4Vk++DeOIgScdGjBEea9sTExGIAEXUEOaXuepqdCaQ3TDq8voo5A456BBDoQKmjtnigrZqKCsfx6DzYk4cVVt+eaYcsEzy25xeO9fSCJwK2Fex3NX6AclOVfo5TxODuRwtMmZUAVYMX1cAknqS2aDJpuJwzL2nn2OjTxlt3xCqWhJM9G017JggHQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=5LryRDm8y+65OMvtow/u/52xXaCbdUb7ljWmYRrN11k=;
 b=OfaIQ5nFc6q2MHkmmYyc11nktToLIW+x3EkYoXIwzsj2S6lyz8VZrqXssXhFnF5mv04nSJ+W7nXUHYiCPGlveA5E62E7GKWTCRqy93Y1G8NPgEQEoeEgf6I5SbQJQKO/S99liw48Nns5IBwvYX+rasI8wxZbbV/jTkQ4a+1ntCmC09GZVtgFXfQ0+v3d7F+aYkA0qDFZCVdtBluHI6kTXQ9J3Ujim8/jwY5eG7KLfw3XOIqwknYRclh0oF7OkwdNaCglSYehwO6TuMIaC0QK1IJ75NA3zH4Jf5pArjxcIMPfFYzJTFKE6YEFIV4jh1PE+/H/SEjCiNCVmA57PqX31Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=vmware.com; dmarc=pass action=none header.from=vmware.com;
 dkim=pass header.d=vmware.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=vmware.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5LryRDm8y+65OMvtow/u/52xXaCbdUb7ljWmYRrN11k=;
 b=1xYA4yuEn+8487A2sKcqXVys35B9SeN95Ikl7uefkclUxF7R03rRPB623HEtKGzhlHabyPw2KDc6aDF6V00WlZwmtcFiqHUEmkBIq0cu8ARP0P2k2eMMJzM3+xqMfvCaE4HGeEf3t3scDMIPOqHZ8d8lw5TExUek6Pgb21EnjvU=
Received: from BY3PR05MB8531.namprd05.prod.outlook.com (2603:10b6:a03:3ce::6)
 by DM6PR05MB6506.namprd05.prod.outlook.com (2603:10b6:5:126::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5709.3; Tue, 4 Oct
 2022 18:48:11 +0000
Received: from BY3PR05MB8531.namprd05.prod.outlook.com
 ([fe80::942c:7d1b:6b3d:85b6]) by BY3PR05MB8531.namprd05.prod.outlook.com
 ([fe80::942c:7d1b:6b3d:85b6%7]) with mapi id 15.20.5709.009; Tue, 4 Oct 2022
 18:48:11 +0000
From:   Nadav Amit <namit@vmware.com>
To:     Alexander Graf <graf@amazon.com>
CC:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        Ajay Kaher <akaher@vmware.com>,
        "x86@kernel.org" <x86@kernel.org>, "hpa@zytor.com" <hpa@zytor.com>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "rostedt@goodmis.org" <rostedt@goodmis.org>,
        Srivatsa Bhat <srivatsab@vmware.com>,
        "srivatsa@csail.mit.edu" <srivatsa@csail.mit.edu>,
        Alexey Makhalov <amakhalov@vmware.com>,
        Vasavi Sirnapalli <vsirnapalli@vmware.com>,
        "er.ajay.kaher@gmail.com" <er.ajay.kaher@gmail.com>,
        "willy@infradead.org" <willy@infradead.org>,
        "linux-hyperv@vger.kernel.org" <linux-hyperv@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "jailhouse-dev@googlegroups.com" <jailhouse-dev@googlegroups.com>,
        "xen-devel@lists.xenproject.org" <xen-devel@lists.xenproject.org>,
        "helgaas@kernel.org" <helgaas@kernel.org>,
        "bhelgaas@google.com" <bhelgaas@google.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "bp@alien8.de" <bp@alien8.de>,
        "dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>,
        "Michael S. Tsirkin" <mst@redhat.com>
Subject: Re: [PATCH v2] x86/PCI: Prefer MMIO over PIO on all hypervisor
Thread-Topic: [PATCH v2] x86/PCI: Prefer MMIO over PIO on all hypervisor
Thread-Index: AQHYx28G+J2WSwxm3kmFzqoOhSDYUK3dXFQAgBj77YCABouGgIAAKhGAgAD4GgCAAK7iAA==
Date:   Tue, 4 Oct 2022 18:48:11 +0000
Message-ID: <DF8775A4-5332-412C-9359-749E96E83907@vmware.com>
References: <9FEC6622-780D-41E6-B7CA-8D39EDB2C093@vmware.com>
 <87zgf3pfd1.fsf@redhat.com> <B64FD502-E794-4E94-A267-D690476C57EE@vmware.com>
 <87tu4l9cfm.fsf@redhat.com> <04F550C5-786A-4B8E-9A88-EBFBD8872F16@vmware.com>
 <f1a7e603-2e64-fd2a-1100-f2898060e3f7@amazon.com>
In-Reply-To: <f1a7e603-2e64-fd2a-1100-f2898060e3f7@amazon.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3696.120.41.1.1)
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=vmware.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BY3PR05MB8531:EE_|DM6PR05MB6506:EE_
x-ms-office365-filtering-correlation-id: d5d88cfd-0020-437b-20fb-08daa638fcb5
x-ld-processed: b39138ca-3cee-4b4a-a4d6-cd83d9dd62f0,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: yUkOPRZfOWa7TMe9u6E+zE8eWAgB2mNeP+wgcJ+/Yw9ueVfZK6haCABVNj/vlWESgQ4eUqw+gBq4/D3I0ECl3/9kPwrE/R8ubaNv0JiuN2XYndjJy65g9+3VptWD9iwh3zmgwOVoJYysoYXfdOLautz23qldH4Elu7+4raxobFBGQVVk/F71luw3XS8hAlaxfLaF8sn3ZAzb3MVxk0mBQVP+ojLI9FPovukpVSnMYyggXxFDHOhof8y2t0w12dmzRkGkBzfaInec/YW3e1HqN6B7wqeH3a6/tXYxW0GUuDOmhAfCWMK3ZLeRHKS/cW7EEUsnwpQWvGzzwtA6xrS+nZNLpOKpUrEepWOLB+ldYeWfp/bv6qBiOHFAjV2JQGOoeZH1cymF+T1GaUJxvzJ/MecexlUnoXjREwnIVQR0TK/76j/Gj+E8Mq+4OdYjDURF+xf9Ho4vXi3b2j82Xohu7KOWG33WBl70ThFfLXfdDNervkygUW68CDgaSDfKpL/ku3mtSkzxuDZm7nlsK3RSbXKvExPDs6nDo0X5joFgsAgxknPuHfwWwR05pSkoEdDX3twISc9yATqLn/8KJiXRV7k8T78I4PfwWTtCt3hGXRId9dEM0hUtPI0MeSbYmFG90mrTfDvaXJxoy36YR7FoA/Zb15prxv3Rg3Vh1GgtakcgP2kuu7OSWCNOu0SyD1YHdKPMNUbNsJ3L/+9hNJVwjmRSdICwh9Mj6y54Z3jDwvrctPKIsl7s4dAA7X/AKDSodGik0IHcOQ3u0OQEuLZwuX+ONuHm5TRWKWRZNhc1uqRuQZ5+gX4wE3xLo2PfpmJfC46sZ9UHTZLpB9KHRvz6EJyh3HEWw5TGKK3K6D0xpI/MYwYbMTx3+J4UlaaFJlkoDFlIuiBS8mCQmD8mtcCv8x/uW1O3bqqbnoHXaDMk+iUqqNwa8mRCx2AfmtyYsZ78
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY3PR05MB8531.namprd05.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(136003)(346002)(396003)(39860400002)(376002)(366004)(451199015)(2616005)(86362001)(186003)(66476007)(76116006)(66946007)(83380400001)(66446008)(64756008)(38100700002)(66556008)(38070700005)(71200400001)(54906003)(966005)(5660300002)(122000001)(478600001)(4326008)(7416002)(8676002)(41300700001)(8936002)(6916009)(26005)(53546011)(316002)(6512007)(36756003)(2906002)(6506007)(6486002)(33656002)(45980500001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?UkRBVzVtb2cwWFN3ZXp2dnFYaWw2Qmw0L00zaDZFZDBHbjB5T0d1MStnZ1Nj?=
 =?utf-8?B?WkZKM3VqTDNrYW9wR3VGakFKNzhqejNNYmc1TmZ0NEwvRFlGTVpoUHp2UHJj?=
 =?utf-8?B?V3k0b2MyNEV3MXFBMGpJak5INnBjZzJFaTBvZWdOb2tGS3o5SjEyRmQ4cGtk?=
 =?utf-8?B?emF0TmlJSTVxam81VkVXbzdzbnJzV1VaS1FwSWFiNmdydHYwZ1ZvR2U2UXla?=
 =?utf-8?B?eTU2S0JCRTRTNkczRE1QamdhY0VGZWQ0T0p4U0dqUFBaemJQbWN4eXh3RmVB?=
 =?utf-8?B?TWR6Wis3QWJ6KzM3a1JTVFIvTUk4WGV2L0k2bTZYQXBtc1NBcHdQM2VaRFQy?=
 =?utf-8?B?VCszcks5dlpObmNDSXdrVXdiM2RNK2dud1BQZzZhd2NXZElLc2dSN201Rjgw?=
 =?utf-8?B?YWMyTHpQQ0c2RENBWFpodVVXODZYMUhhVkJqdmhpSnBqRUJsRWdCd3JZU1hH?=
 =?utf-8?B?ZTJUN2syZG1wbGhlYnQ1cXZTS3ZDOG5yQXFkTW9VcUd6WHUxbks3bTAzNHB1?=
 =?utf-8?B?SWJ3NlFEcU81KzJMb1J4b0J1bHo4SVh0N0dNNHIveVVmdU9KYTZMUXA2dTUv?=
 =?utf-8?B?QW1MWmY2d3dxOUcvanFWNUpUcXZRbFQwZi9SUExVZ09vN1VRTGQ4S091Z0dn?=
 =?utf-8?B?SllxVmlWRXJSKzErQjRCajRJMXFIRG5TcURGaGQ2dnZ3bUdpZmMvakVZeEJS?=
 =?utf-8?B?S1dIblNyR2RsQXN4TUZpb2xVRERtS0kxaGJOanJUaXJQaVJkT3VCaDExa0xa?=
 =?utf-8?B?TDgvTW9qZ0ZGditLcUpWd3hjQlR1QXRLKy9xMGJsMWNpK3NQL1lmMU5HektW?=
 =?utf-8?B?bDJYOFRhUXNEUWhxaisreGFtZk95bmNJelpyVnpIN2JzYnVlNDg1SFJ2d2lU?=
 =?utf-8?B?dmhYaDg3M0IxQ3drSXdXTU0zbFA0cjR2Y0wzem84S0tRYmZ0anF6YmlRSzB0?=
 =?utf-8?B?RXZ0YnNsVmQySnBzMU9WMXB5RzRQenAydVpTS2ZsWEIyNmovMUpIMVZiWnZK?=
 =?utf-8?B?dVBUOVgyUk5iTi9EejRTR0I3UzQxbGZTdVUybmNGUW9kMHorTFhWMEt5YUNL?=
 =?utf-8?B?eXdvbXhITC9GbDh2QVJOOXBiUXowSi8yM1cxYmdZSjV1cDFMM0V1Slc5M0d2?=
 =?utf-8?B?ekROVDF0MlRpcm03eTdVRThMTlAweUZSczN0TU5nNEpHUjVtNmNwZllWWVhR?=
 =?utf-8?B?a3JYZ3NJQzZ4Tml6TkFuYmhCZmJBV0hrelpIMUJWcm1uRWcrNjhqUmZNNFR1?=
 =?utf-8?B?Zzhhd0ZlUUhEbHlsVEcwanNVTVBZK0h0U1UxSFErS1dpQXhabVIzcTI1Tnkw?=
 =?utf-8?B?ZWd4VW1Bc21tbi9kdjN3dTRpcjZweFB6MXdSNC9oaU8zUFBzYVlmRDNVRS9o?=
 =?utf-8?B?NEtOR1lURThDRG1pMWZpS1gvMmRoYjJ2Uk9HcUluNnl3UkFZeDE4TCtqcHlM?=
 =?utf-8?B?NFR6TVZkczl6T0FmTnY4bWJQeTdUb1dUZW9ucTIwc21PTkppcDJ5emFWa1B2?=
 =?utf-8?B?M3piZExEM2g4b0dwUnRQR2hMc2pvU0FqQ3p3TW8zSC9LeFhla0RDZE1IbGt2?=
 =?utf-8?B?OHBmZ1F2My9Yem9pNFIwc1U3SlgwT1VuUGtqY3NXbGdBUTNhNG1FQmIyYkRX?=
 =?utf-8?B?RnJjYkRJang0QjJEYzJBTzBBdVo5Ky92eDJYRitwTVhxYkhVUGI3ZnhnVlJE?=
 =?utf-8?B?em81MDN3bGRyTWVUbUIyazF2dHB0N1ZqZy9pSytLeHRDWndNOEVwTGJGZlMr?=
 =?utf-8?B?V2p1VjVTdnEzMkJsOWl6K0ZpM0xvVlJpOWtFTTJxdUVhV1FDMjJHTlZSeXlU?=
 =?utf-8?B?K0tBZ1ptREJYVURRaXIrdG1PTFBSd0pQcWcxcTVXczR4K3FqcXlteHNsZk5E?=
 =?utf-8?B?V2JYOUxCSlJjeFhlaTBoOFpENTdLMXZkTjk5UHZINy80QVFCYzIxR2NIZE1K?=
 =?utf-8?B?YmJpRVMrRlNTWE5qVTh4S3U5VzI5TXZ3VHF1Vit2eUNIUFdDTTVoZkFYRTlY?=
 =?utf-8?B?MEhDQTVvY3d2Y2h4d3BBUXRzWXh2UDl4ak1BRVdCQk93UjZYNjRERmR1Z1VS?=
 =?utf-8?B?T04vL2hseHl5NS9JQVFYN0UvRmVwaDVyL3E0UURiWDdYa0FwbVduajc5NHFz?=
 =?utf-8?Q?304/N3MbaDAjuFkXfuYs4BRy/?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <4170C95495E7224CB50BF35570867FBA@namprd05.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: vmware.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BY3PR05MB8531.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d5d88cfd-0020-437b-20fb-08daa638fcb5
X-MS-Exchange-CrossTenant-originalarrivaltime: 04 Oct 2022 18:48:11.3829
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b39138ca-3cee-4b4a-a4d6-cd83d9dd62f0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: nQd9N0EHsEM5bd9MDUlqtEYo78OtJmXmyR3tvUaz61ImDGbTaqnPAv3ScHoCX7bPjEdaH6cWyMLxtcK1MqjfJg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR05MB6506
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,SPF_HELO_PASS,SPF_NONE autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

T24gT2N0IDQsIDIwMjIsIGF0IDE6MjIgQU0sIEFsZXhhbmRlciBHcmFmIDxncmFmQGFtYXpvbi5j
b20+IHdyb3RlOg0KDQo+IOKaoCBFeHRlcm5hbCBFbWFpbA0KPiANCj4gSGV5IE5hZGF2LA0KPiAN
Cj4gT24gMDMuMTAuMjIgMTk6MzQsIE5hZGF2IEFtaXQgd3JvdGU6DQo+PiBPbiBPY3QgMywgMjAy
MiwgYXQgODowMyBBTSwgVml0YWx5IEt1em5ldHNvdiA8dmt1em5ldHNAcmVkaGF0LmNvbT4gd3Jv
dGU6DQo+PiANCj4+PiBOb3QgbXkgYnV0IHJhdGhlciBQQ0kgbWFpbnRhaW5lcidzIGNhbGwgYnV0
IElNSE8gZHJvcHBpbmcgJ2NvbnN0JyBpcw0KPj4+IGJldHRlciwgaW50cm9kdWNpbmcgYSBuZXcg
Z2xvYmFsIHZhciBpcyBvdXIgJ2xhc3QgcmVzb3J0JyBhbmQgc2hvdWxkIGJlDQo+Pj4gYXZvaWRl
ZCB3aGVuZXZlciBwb3NzaWJsZS4gQWx0ZXJuYXRpdmVseSwgeW91IGNhbiBhZGQgYQ0KPj4+IHJh
d19wY2lfZXh0X29wc19wcmVmZXJyZWQoKSBmdW5jdGlvbiBjaGVja2luZyBzb21ldGhpbiB3aXRo
aW4gJ3N0cnVjdA0KPj4+IGh5cGVydmlzb3JfeDg2JyBidXQgSSdtIHVuc3VyZSBpZiBpdCdzIGJl
dHRlci4NCj4+PiANCj4+PiBBbHNvLCBwbGVhc2UgY2hlY2sgQWxleCcgcXVlc3Rpb24vc3VnZ2Vz
dGlvbi4NCj4+IEhlcmUgaXMgbXkgdGFrZSAoYW5kIEFqYXkga25vd3MgcHJvYmFibHkgbW9yZSB0
aGFuIG1lKToNCj4+IA0KPj4gTG9va2luZyBicmllZmx5IG9uIE1DRkcsIEkgZG8gbm90IHNlZSBh
IGNsZWFuIHdheSBvZiB1c2luZyB0aGUgQUNQSSB0YWJsZS4NCj4+IFRoZSB0d28gb3B0aW9ucyBh
cmUgZWl0aGVyIHRvIHVzZSBhIHJlc2VydmVkIGZpZWxkICh3aGljaCB3aG8ga25vd3MsIG1pZ2h0
DQo+PiBiZSB1c2VkIG9uZSBkYXkpIG9yIHNvbWUgT0VNIElELiBJIGFtIGFsc28gbm90IGZhbWls
aWFyIHdpdGgNCj4+IFBDSV9DT01NQU5ELk1FTU9SWT0wLCBzbyBBamF5IGNhbiBob3BlZnVsbHkg
Z2l2ZSBzb21lIGFuc3dlciBhYm91dCB0aGF0Lg0KPj4gDQo+PiBBbnlob3csIEkgdW5kZXJzdGFu
ZCAoYWx0aG91Z2ggbm90IHJlbGF0ZSkgdG8gdGhlIG9iamVjdGlvbiBmb3IgYSBuZXcgZ2xvYmFs
DQo+PiB2YXJpYWJsZS4gSG93IGFib3V0IGV4cGxpY2l0bHkgY2FsbGluZyB0aGlzIGhhcmR3YXJl
IGJ1ZyBhIOKAnGJ1Z+KAnSBhbmQgdXNpbmcNCj4+IHRoZSBwcm9wZXIgaW5mcmFzdHJ1Y3R1cmU/
IENhbGxpbmcgaXQgZXhwbGljaXRseSBhIGJ1ZyBtYXkgZXZlbiBwdXNoIHdob2V2ZXINCj4+IGNh
biB0byByZXNvbHZlIGl0Lg0KPiANCj4gDQo+IEkgYW0gYSBsb3QgbW9yZSBjb25jZXJuZWQgd2l0
aCBob3cgd2UgcHJvcGFnYXRlIGl0IGV4dGVybmFsbHkgdGhhbg0KPiB3aXRoaW4gTGludXguIElm
IHdlIGhhcmQgY29kZSB0aGF0IGFsbCBMaW51eCBrZXJuZWxzIDYuMisgdGhhdCBhcmUNCj4gcnVu
bmluZyBpbiBWTXdhcmUgcHJlZmVyIEVDQU0gb3ZlciBQSU8sIHdlIGxvY2sgb3Vyc2VsdmVzIGlu
dG8gdGhhdA0KPiBzdGFuY2UgZm9yIGJldHRlciBvciB3b3JzZSwgd2hpY2ggbWVhbnM6DQo+IA0K
PiAqIEFsbCBwYXN0IGFuZCBmdXR1cmUgdmVyc2lvbnMgb2YgYW55IFZNd2FyZSBoeXBlcnZpc29y
IHByb2R1Y3QgaGF2ZSB0bw0KPiBhbHdheXMgYWxsb3cgRUNBTSBhY2Nlc3MgZm9yIGFueSBQQ0ll
IGNvbmZpZyBzcGFjZSB3cml0ZQ0KPiAqIE5vIG90aGVyIGh5cGVydmlzb3IgYmVuZWZpdHMgZnJv
bSBhbnkgb2YgdGhpcyB3aXRob3V0IHVwc3RyZWFtIGNvZGUgY2hhbmdlDQo+ICogTm8gcmVhbCBo
YXJkd2FyZSBwbGF0Zm9ybSBiZW5lZml0cyBmcm9tIHRoaXMgd2l0aG91dCB1cHN0cmVhbSBjb2Rl
IGNoYW5nZQ0KPiANCj4gQnkgbW92aW5nIGl0IGludG8gTUNGRywgd2UgY2FuIGNyZWF0ZSBhIHBh
dGggZm9yIHRoZSBvdXRzaWRlIGVudmlyb25tZW50DQo+IHRvIHRlbGwgdGhlIE9TIHdoZXRoZXIg
aXQncyBzYWZlIHRvIHVzZSBFQ0FNIGFsd2F5cy4gVGhpcyBvYnZpb3VzbHkNCj4gZG9lc24ndCB3
b3JrIHdpdGggTUNGRyBhcyBpdCBzdGFuZHMgdG9kYXksIHdlJ2QgaGF2ZSB0byBwcm9wb3NlIGFu
IE1DRkcNCj4gc3BlYyBjaGFuZ2UgdG8gdGhlIFBDSSBTSUcncyAiUENJIEZpcm13YXJlIFNwZWNp
ZmljYXRpb24iIHRvIGFkZCB0aGUNCj4gcmVzcGVjdGl2ZSBmaWVsZC4gRnV0dXJlIFZNd2FyZSB2
ZXJzaW9ucyBjb3VsZCB0aGVuIGFsd2F5cyBleHBvc2UgdGhlDQo+IGZsYWcgLSBhbmQgaWYgeW91
IGZpbmQgaXQgYnJva2VuLCByZW1vdmUgaXQgYWdhaW4uDQo+IA0KPiBQdXR0aW5nIGFsbCBvZiB0
aGUgbG9naWMgb24gd2hpY2ggc3lzdGVtIHBvdGVudGlhbGx5IHByZWZlcnMgRUNBTSBvdmVyDQo+
IFBJTyBjb25maWcgc3BhY2UgYWNjZXNzIGludG8gTGludXggaXMganVzdCBhIGJpZyBoYWNrIHRo
YXQgd2Ugc2hvdWxkDQo+IGF2b2lkIGFzIG11Y2ggYXMgcG9zc2libGUuDQoNClRoYW5rcyBBbGV4
LiBZb3UgcmFpc2UgaW1wb3J0YW50IHBvaW50cy4gTGV0IG1lIHRyeSB0byBicmVhayBkb3duIHlv
dXINCmNvbmNlcm5zIHNsaWdodGx5IGRpZmZlcmVudGx5Og0KDQoxLiBFbmFibGluZyBNTUlPIGFj
Y2VzcyBzaG91bGQgYmUgc2VsZWN0aXZlLCBhbmQgcG90ZW50aWFsbHkgY29udHJvbGxlZCBieQ0K
dGhlIGh5cGVydmlzb3IuIFRoZSB2ZXJ5IGxlYXN0IGEgImNoaWNrZW4tYml04oCdIGlzIG5lZWRl
ZC4NCg0KMi4gUENJIFNJRyB3b3VsZCBjaGFuZ2UgaXRzIHNwZWNpZmljYXRpb25zIHRvIGFkZHJl
c3MgdW5jbGVhciBoYXJkd2FyZSBidWcuDQoNCkkgdGhpbmsgKDEpIG1ha2VzIHNlbnNlIGFuZCB3
ZSBjYW4gZGlzY3VzcyBkaWZmZXJlbnQgd2F5cyBvZiBhZGRyZXNzaW5nIGl0Lg0KQnV0ICgyKSB3
b3VsZCBub3QgaGFwcGVuIGluIGEgcmVhc29uYWJsZSB0aW1lbGluZSBhbmQgc2VlbXMgdG8gbWUg
YXMgYW4NCnVubmVjZXNzYXJ5IGNvbXBsaWNhdGlvbi4NCg0KQnV0IGJlZm9yZSB3ZSBkaXNjdXNz
IGhvdyB0byBhZGRyZXNzIHRoZSBpc3N1ZSwgcGVyaGFwcyB3ZSBuZWVkIHRvIGZpcnN0DQp1bmRl
cnN0YW5kIGl0IGJldHRlci4gSSBhbSBub3Qgc3VyZSB0aGF0IEkgdW5kZXJzdGFuZCB0aGlzIE1N
SU8gYnVnLCBhbmQgc28NCmZhciBub2JvZHkgd2FzIGFibGUgdG8gcHJvdmlkZSBleGFjdCBkZXRh
aWxzLg0KDQpTbyBJIHdlbnQgdG8gaGF2ZSBhIGxvb2suIEl0IG1pZ2h0IG5vdCBiZSBzdXBlciBo
ZWxwZnVsLCBidXQgZm9yIHRoZSByZWNvcmQsDQpoZXJlIGlzIHdoYXQgSSBjb2xsZWN0ZWQuDQoN
CkZpcnN0LCB3ZSBoYXZlIGNvbW1pdCBkNmVjZTU0OTFhZTcxZCAoImkzODYveDg2LTY0IENvcnJl
Y3QgZm9yIGJyb2tlbiBNQ0ZHDQp0YWJsZXMgb24gSzggc3lzdGVtc+KAnSkuIEl0IHRyaWVkIHRv
ICJ0cnkgdG8gZGlzY292ZXIgYWxsIGRldmljZXMgb24gYnVzIDANCnRoYXQgYXJlIHVucmVhY2hh
YmxlIHVzaW5nIE1NIGFuZCBmYWxsYmFjayBmb3IgdGhlbS7igJ0gSW50ZXJlc3RpbmdseSwgaXQN
CnNlZW1zIHNpbWlsYXIgdG8gRnJlZUJTRCBjb2RlIChjb21taXQgMmQxMDU3MGFmZTJiM2UpIHRo
YXQgYWxzbyBtZW50aW9ucyBLOA0KYW5kIGhhcyBzaW1pbGFyIGRldGVjdGlvbiBsb2dpYyBpbiBG
cmVlQlNE4oCZcyBwY2llX2NmZ3JlZ29wZW4oKS4NCg0KVGhlbiBjb21taXQgYTBjYTk5MDk2MDk0
NzAgKCJQQ0kgeDg2OiBhbHdheXMgdXNlIGNvbmYxIHRvIGFjY2VzcyBjb25maWcNCnNwYWNlIGJl
bG93IDI1NiBieXRlc+KAnSkuIFRoZSBjb3JyZXNwb25kZW5jZSBbMV0gbWVudGlvbnMgc29tZSBi
dWdzOiBBVEkNCmNoaXBzZXQsIFZJQSBjaGlwc2V0LCBJbnRlbCAzIFNlcmllcyBFeHByZXNzIGNo
aXBzZXQgZmFtaWx5IGFuZCBzb21lIHJlcG9ydHMNCm9uIE52aWRpYS4gSXQgdHVybmVkIG91dCBz
b21lIGRldmljZXMgaGFkIHByb2JsZW0gcHJvYmluZyAtIHRvIGZpZ3VyZSBvdXQgaWYNCk1NSU8g
aXMgYnJva2VuIC0gdGhlIHdheSB0aGUgcHJldmlvdXMgcGF0Y2ggZGlkLg0KDQpBbGwgb2YgdGhl
c2UgYnVncyBhcmUgY2lyY2EgMjAwOCwgb2YgY291cnNlLiBBbmQgbm90ZSB0aGF0IEZyZWVCU0Qg
ZGlkIG5vdA0KdGFrZSBhIHNpbWlsYXIgcGF0aC4gVGhlIGNvcnJlc3BvbmRlbmNlIGFyb3VuZCBM
aW51eCBwYXRjaCBpcyBlbmRsZXNzLiBJDQphZG1pdCB0aGF0IEkgZGlkIG5vdCB1bmRlcnN0YW5k
IHdoZXRoZXIgZXZlbnR1YWxseSB0aGUgaXNzdWVzIHdlcmUgZm91bmQgdG8NCmJlIHBlci1idXMg
b3IgcGVyLWRldmljZS4NCg0KDQpCYWNrIHRvIHRoZSBtYXR0ZXIgYXQgaGFuZC4gVGhlIGJlbmVm
aXQgb2YgdXNpbmcgdGhlIE1DRkcgYXBwcm9hY2ggdGhhdCB5b3UNCnByb3Bvc2UgaXMgdGhhdCBp
dCBjYW4gZW5hYmxlIG5hdGl2ZSBzeXN0ZW1zIHRvIHVzZSBNTUlPIGFzIHdlbGwuIEhvd2V2ZXIs
DQpzaW5jZSB0aGUgbGlzdCBvZiBidWdzIGlzIHVuY2xlYXIgYW5kIHRoZSBwcm9ibGVtcyBtaWdo
dCBiZSBkZXZpY2Utc3BlY2lmaWMsDQppdCBpcyBub3QgY2xlYXIgd2hhdCBpbmZvcm1hdGlvbiBC
SU9TZXMgaGF2ZSB0aGF0IExpbnV4IGRvZXNu4oCZdC4gSW4gb3RoZXINCndvcmRzLCB0aGUgYmVu
ZWZpdCBvZiBnZXR0aW5nIGl0IGludG8gdGhlIHNwZWNpZmljYXRpb25zIGlzIHF1ZXN0aW9uYWJs
ZSwNCmFuZCB0aGUgY29tcGxleGl0eSt0aW1lIGlzIGhpZ2guDQoNCkNhbiB3ZSBhZ3JlZSB0aGF0
IHRoZSBmZWF0dXJlIHdvdWxkIGJlIGVuYWJsZWQgZXhwbGljaXRseSBieSB0aGUgaHlwZXJ2aXNv
cg0KYW5kIExpbnV4IHdvdWxkIGVuYWJsZSBpdCBiYXNlZCBvbiB0aGUgaHlwZXJ2aXNvciBpbnB1
dCAodGhyb3VnaCBzb21lDQpjaGFubmVsPykNCg0KVGhhbmtzLA0KTmFkYXYNCg0KWzFdIGh0dHBz
Oi8vbG9yZS5rZXJuZWwub3JnL2FsbC8yMDA4MDExMjE0NDAzMC5HQTE5Mjc5QGp1cmFzc2ljLnBh
cmsubXN1LnJ1L1QvI3U=
