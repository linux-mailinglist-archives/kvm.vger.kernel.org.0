Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A4979496C2
	for <lists+kvm@lfdr.de>; Tue, 18 Jun 2019 03:34:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726489AbfFRBeP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 17 Jun 2019 21:34:15 -0400
Received: from mail-eopbgr770054.outbound.protection.outlook.com ([40.107.77.54]:57199
        "EHLO NAM02-SN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725829AbfFRBeP (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 17 Jun 2019 21:34:15 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector1-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vQu2sQH6H1fyvknOYj625IcIkfIAKSs3WBkkOYXP/BA=;
 b=YDOsfmDIOiSwdFMIAKzOX6tGPRPnfqkxKEtA7U/wGztKcTb13Nwlh75kvVWfA5wDpDK3yP4NB7jxQqXkMzs2BV5cZ5klBpvgTQBAk3Ow2wX9MU6TA2fL0J/sFL+JwQ97dgOXdozToSIJ+SLPA3k+2BD+rkOJfChOo1LZ9DwbIak=
Received: from DM6PR12MB3163.namprd12.prod.outlook.com (20.179.104.150) by
 DM6PR12MB4010.namprd12.prod.outlook.com (10.255.175.83) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1987.15; Tue, 18 Jun 2019 01:34:06 +0000
Received: from DM6PR12MB3163.namprd12.prod.outlook.com
 ([fe80::bcaf:86d4:677f:9555]) by DM6PR12MB3163.namprd12.prod.outlook.com
 ([fe80::bcaf:86d4:677f:9555%6]) with mapi id 15.20.1987.014; Tue, 18 Jun 2019
 01:34:06 +0000
From:   "Lendacky, Thomas" <Thomas.Lendacky@amd.com>
To:     Kai Huang <kai.huang@linux.intel.com>,
        Dave Hansen <dave.hansen@intel.com>,
        Andy Lutomirski <luto@kernel.org>
CC:     "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        X86 ML <x86@kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Borislav Petkov <bp@alien8.de>,
        Peter Zijlstra <peterz@infradead.org>,
        David Howells <dhowells@redhat.com>,
        Kees Cook <keescook@chromium.org>,
        Jacob Pan <jacob.jun.pan@linux.intel.com>,
        Alison Schofield <alison.schofield@intel.com>,
        Linux-MM <linux-mm@kvack.org>, kvm list <kvm@vger.kernel.org>,
        "keyrings@vger.kernel.org" <keyrings@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH, RFC 45/62] mm: Add the encrypt_mprotect() system call for
 MKTME
Thread-Topic: [PATCH, RFC 45/62] mm: Add the encrypt_mprotect() system call
 for MKTME
Thread-Index: AQHVBaytkz7iqCERRUG2Tf+Vvry8YKagMWmAgAAF3ICAAAT1AIAALTSAgABck4CAABp5AA==
Date:   Tue, 18 Jun 2019 01:34:06 +0000
Message-ID: <cbbc6af7-36f8-a81f-48b1-2ad4eefc2417@amd.com>
References: <20190508144422.13171-1-kirill.shutemov@linux.intel.com>
 <20190508144422.13171-46-kirill.shutemov@linux.intel.com>
 <CALCETrVCdp4LyCasvGkc0+S6fvS+dna=_ytLdDPuD2xeAr5c-w@mail.gmail.com>
 <3c658cce-7b7e-7d45-59a0-e17dae986713@intel.com>
 <CALCETrUPSv4Xae3iO+2i_HecJLfx4mqFfmtfp+cwBdab8JUZrg@mail.gmail.com>
 <5cbfa2da-ba2e-ed91-d0e8-add67753fc12@intel.com>
 <1560815959.5187.57.camel@linux.intel.com>
In-Reply-To: <1560815959.5187.57.camel@linux.intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: DM5PR13CA0041.namprd13.prod.outlook.com
 (2603:10b6:3:7b::27) To DM6PR12MB3163.namprd12.prod.outlook.com
 (2603:10b6:5:182::22)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=Thomas.Lendacky@amd.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [165.204.77.1]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 2851999b-0ca1-4a5d-2dd3-08d6f38d0d8f
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:DM6PR12MB4010;
x-ms-traffictypediagnostic: DM6PR12MB4010:
x-microsoft-antispam-prvs: <DM6PR12MB40102BE08300DD9535770A1AECEA0@DM6PR12MB4010.namprd12.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-forefront-prvs: 007271867D
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(346002)(366004)(136003)(39860400002)(376002)(396003)(51444003)(189003)(199004)(86362001)(2616005)(316002)(5660300002)(11346002)(446003)(54906003)(4326008)(110136005)(186003)(26005)(25786009)(14454004)(476003)(31696002)(486006)(53936002)(229853002)(72206003)(31686004)(8676002)(8936002)(6512007)(6486002)(99286004)(305945005)(7736002)(64756008)(66476007)(66556008)(256004)(66446008)(66946007)(478600001)(14444005)(7416002)(6246003)(81156014)(73956011)(81166006)(68736007)(71200400001)(53546011)(6116002)(6436002)(71190400001)(2906002)(76176011)(66066001)(6506007)(386003)(102836004)(561944003)(36756003)(52116002)(3846002);DIR:OUT;SFP:1101;SCL:1;SRVR:DM6PR12MB4010;H:DM6PR12MB3163.namprd12.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: amd.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: IPa2vvx4AI7dsGmRXG05UofuDO7D4OR+FJUXbB8zbkDH7b53IcaV9IPBkHL+E5DVRchSJgGwhXsZYmInwpoqixpG27jvqryjpe2goMJsloTaRx8usjaF2xAqQiymMQ3SnGxdVYkyhXOgoKAUB5B2OuZpkhibLsYpponrCQagVLG82Vkzj4SRol1FENt40u8uzkKyMZJJHIGtnbI655kpHFcYG7cow3LPwfSmWmbW68vtcfrB6LJGoWuALolMZibtPctzNq4TWKewwq4V0Be/8MyN5JFAPXmhENn6JSZdMMkFK0OUxY5rKXLYDmC+EjLkqcCN7wngZEUpW4HSxB2AtJ5IE8DSHXXmJH3uRiPurkynpZ/vCM/1zCvq5Qsj7yAOQawOcCwbhxKXnbvl+Eu83ZDlZ5zxyW1fvHkQzPTyOeI=
Content-Type: text/plain; charset="utf-8"
Content-ID: <0F1C32BA00ED3449948EF08A381D1495@namprd12.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2851999b-0ca1-4a5d-2dd3-08d6f38d0d8f
X-MS-Exchange-CrossTenant-originalarrivaltime: 18 Jun 2019 01:34:06.6337
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: tlendack@amd.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB4010
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

T24gNi8xNy8xOSA2OjU5IFBNLCBLYWkgSHVhbmcgd3JvdGU6DQo+IE9uIE1vbiwgMjAxOS0wNi0x
NyBhdCAxMToyNyAtMDcwMCwgRGF2ZSBIYW5zZW4gd3JvdGU6DQo+PiBUb20gTGVuZGFja3ksIGNv
dWxkIHlvdSB0YWtlIGEgbG9vayBkb3duIGluIHRoZSBtZXNzYWdlIHRvIHRoZSB0YWxrIG9mDQo+
PiBTRVY/ICBJIHdhbnQgdG8gbWFrZSBzdXJlIEknbSBub3QgbWlzcmVwcmVzZW50aW5nIHdoYXQg
aXQgZG9lcyB0b2RheS4NCg0KU29ycnksIEknbSB0cmF2ZWxpbmcgdGhpcyB3ZWVrLCBzbyByZXNw
b25zZXMgd2lsbCBiZSBkZWxheWVkLi4uDQoNCj4+IC4uLg0KPj4NCj4+DQo+Pj4+IEkgYWN0dWFs
bHkgZG9uJ3QgY2FyZSBhbGwgdGhhdCBtdWNoIHdoaWNoIG9uZSB3ZSBlbmQgdXAgd2l0aC4gIEl0
J3Mgbm90DQo+Pj4+IGxpa2UgdGhlIGV4dHJhIHN5c2NhbGwgaW4gdGhlIHNlY29uZCBvcHRpb25z
IG1lYW5zIG11Y2guDQo+Pj4NCj4+PiBUaGUgYmVuZWZpdCBvZiB0aGUgc2Vjb25kIG9uZSBpcyB0
aGF0LCBpZiBzeXNfZW5jcnlwdCBpcyBhYnNlbnQsIGl0DQo+Pj4ganVzdCB3b3Jrcy4gIEluIHRo
ZSBmaXJzdCBtb2RlbCwgcHJvZ3JhbXMgbmVlZCBhIGZhbGxiYWNrIGJlY2F1c2UNCj4+PiB0aGV5
J2xsIHNlZ2ZhdWx0IG9mIG1wcm90ZWN0X2VuY3J5cHQoKSBnZXRzIEVOT1NZUy4NCj4+DQo+PiBX
ZWxsLCBieSB0aGUgdGltZSB0aGV5IGdldCBoZXJlLCB0aGV5IHdvdWxkIGhhdmUgYWxyZWFkeSBo
YWQgdG8gYWxsb2NhdGUNCj4+IGFuZCBzZXQgdXAgdGhlIGVuY3J5cHRpb24ga2V5LiAgSSBkb24n
dCB0aGluayB0aGlzIHdvdWxkIHJlYWxseSBiZSB0aGUNCj4+ICJub3JtYWwiIG1hbGxvYygpIHBh
dGgsIGZvciBpbnN0YW5jZS4NCj4+DQo+Pj4+ICBIb3cgZG8gd2UNCj4+Pj4gZXZlbnR1YWxseSBz
dGFjayBpdCBvbiB0b3Agb2YgcGVyc2lzdGVudCBtZW1vcnkgZmlsZXN5c3RlbXMgb3IgRGV2aWNl
DQo+Pj4+IERBWD8NCj4+Pg0KPj4+IEhvdyBkbyB3ZSBzdGFjayBhbm9ueW1vdXMgbWVtb3J5IG9u
IHRvcCBvZiBwZXJzaXN0ZW50IG1lbW9yeSBvciBEZXZpY2UNCj4+PiBEQVg/ICBJJ20gY29uZnVz
ZWQuDQo+Pg0KPj4gSWYgb3VyIGludGVyZmFjZSB0byBNS1RNRSBpczoNCj4+DQo+PiAJZmQgPSBv
cGVuKCIvZGV2L21rdG1lIik7DQo+PiAJcHRyID0gbW1hcChmZCk7DQo+Pg0KPj4gVGhlbiBpdCdz
IGhhcmQgdG8gY29tYmluZSB3aXRoIGFuIGludGVyZmFjZSB3aGljaCBpczoNCj4+DQo+PiAJZmQg
PSBvcGVuKCIvZGV2L2RheDEyMyIpOw0KPj4gCXB0ciA9IG1tYXAoZmQpOw0KPj4NCj4+IFdoZXJl
IGlmIHdlIGhhdmUgc29tZXRoaW5nIGxpa2UgbXByb3RlY3QoKSAob3IgbWFkdmlzZSgpIG9yIHNv
bWV0aGluZw0KPj4gZWxzZSB0YWtpbmcgcG9pbnRlciksIHdlIGNhbiBqdXN0IGRvOg0KPj4NCj4+
IAlmZCA9IG9wZW4oIi9kZXYvYW55dGhpbmc5ODciKTsNCj4+IAlwdHIgPSBtbWFwKGZkKTsNCj4+
IAlzeXNfZW5jcnlwdChwdHIpOw0KPj4NCj4+IE5vdywgd2UgbWlnaHQgbm90ICpkbyogaXQgdGhh
dCB3YXkgZm9yIGRheCwgZm9yIGluc3RhbmNlLCBidXQgSSdtIGp1c3QNCj4+IHNheWluZyB0aGF0
IGlmIHdlIGdvIHRoZSAvZGV2L21rdG1lIHJvdXRlLCB3ZSBuZXZlciBnZXQgYSBjaG9pY2UuDQo+
Pg0KPj4+IEkgdGhpbmsgdGhhdCwgaW4gdGhlIGxvbmcgcnVuLCB3ZSdyZSBnb2luZyB0byBoYXZl
IHRvIGVpdGhlciBleHBhbmQNCj4+PiB0aGUgY29yZSBtbSdzIGNvbmNlcHQgb2Ygd2hhdCAibWVt
b3J5IiBpcyBvciBqdXN0IGhhdmUgYSB3aG9sZQ0KPj4+IHBhcmFsbGVsIHNldCBvZiBtZWNoYW5p
c21zIGZvciBtZW1vcnkgdGhhdCBkb2Vzbid0IHdvcmsgbGlrZSBtZW1vcnkuDQo+Pg0KPj4gLi4u
DQo+Pj4gSSBleHBlY3QgdGhhdCBzb21lIGRheSBub3JtYWwgbWVtb3J5IHdpbGwgIGJlIGFibGUg
dG8gYmUgcmVwdXJwb3NlZCBhcw0KPj4+IFNHWCBwYWdlcyBvbiB0aGUgZmx5LCBhbmQgdGhhdCB3
aWxsIGFsc28gbG9vayBhIGxvdCBtb3JlIGxpa2UgU0VWIG9yDQo+Pj4gWFBGTyB0aGFuIGxpa2Ug
dGhlIHRoaXMgbW9kZWwgb2YgTUtUTUUuDQo+Pg0KPj4gSSB0aGluayB5b3UncmUgZHJhd2luZyB0
aGUgbGluZSBhdCBwYWdlcyB3aGVyZSB0aGUga2VybmVsIGNhbiBtYW5hZ2UNCj4+IGNvbnRlbnRz
IHZzLiBub3QgbWFuYWdlIGNvbnRlbnRzLiAgSSdtIG5vdCBzdXJlIHRoYXQncyB0aGUgcmlnaHQN
Cj4+IGRpc3RpbmN0aW9uIHRvIG1ha2UsIHRob3VnaC4gIFRoZSB0aGluZyB0aGF0IGlzIGltcG9y
dGFudCBpcyB3aGV0aGVyIHRoZQ0KPj4ga2VybmVsIGNhbiBtYW5hZ2UgdGhlIGxpZmV0aW1lIGFu
ZCBsb2NhdGlvbiBvZiB0aGUgZGF0YSBpbiB0aGUgcGFnZS4NCj4+DQo+PiBCYXNpY2FsbHk6IENh
biB0aGUga2VybmVsIGNob29zZSB3aGVyZSB0aGUgcGFnZSBjb21lcyBmcm9tIGFuZCBnZXQgdGhl
DQo+PiBwYWdlIGJhY2sgd2hlbiBpdCB3YW50cz8NCj4+DQo+PiBJIHJlYWxseSBkb24ndCBsaWtl
IHRoZSBjdXJyZW50IHN0YXRlIG9mIHRoaW5ncyBsaWtlIHdpdGggU0VWIG9yIHdpdGgNCj4+IEtW
TSBkaXJlY3QgZGV2aWNlIGFzc2lnbm1lbnQgd2hlcmUgdGhlIHBoeXNpY2FsIGxvY2F0aW9uIGlz
IHF1aXRlIGxvY2tlZA0KPj4gZG93biBhbmQgdGhlIGtlcm5lbCByZWFsbHkgY2FuJ3QgbWFuYWdl
IHRoZSBtZW1vcnkuICBJJ20gdHJ5aW5nIHJlYWxseQ0KPj4gaGFyZCB0byBtYWtlIHN1cmUgZnV0
dXJlIGhhcmR3YXJlIGlzIG1vcmUgcGVybWlzc2l2ZSBhYm91dCBzdWNoIHRoaW5ncy4NCj4+ICBN
eSBob3BlIGlzIHRoYXQgdGhlc2UgYXJlIGEgdGVtcG9yYXJ5IGJsaXAgYW5kIG5vdCB0aGUgbmV3
IG5vcm1hbC4NCj4+DQo+Pj4gU28sIGlmIHdlIHVwc3RyZWFtIE1LVE1FIGFzIGFub255bW91cyBt
ZW1vcnkgd2l0aCBhIG1hZ2ljIGNvbmZpZw0KPj4+IHN5c2NhbGwsIEkgcHJlZGljdCB0aGF0LCBp
biBhIGZldyB5ZWFycywgaXQgd2lsbCBiZSBlbmQgdXAgaW5oZXJpdGluZw0KPj4+IGFsbCBkb3du
c2lkZXMgb2YgYm90aCBhcHByb2FjaGVzIHdpdGggZmV3IG9mIHRoZSB1cHNpZGVzLiAgUHJvZ3Jh
bXMNCj4+PiBsaWtlIFFFTVUgd2lsbCBuZWVkIHRvIGxlYXJuIHRvIG1hbmlwdWxhdGUgcGFnZXMg
dGhhdCBjYW4ndCBiZQ0KPj4+IGFjY2Vzc2VkIG91dHNpZGUgdGhlIFZNIHdpdGhvdXQgc3BlY2lh
bCBWTSBidXktaW4sIHNvIHRoZSBmYWN0IHRoYXQNCj4+PiBNS1RNRSBwYWdlcyBhcmUgZnVsbHkg
ZnVuY3Rpb25hbCBhbmQgY2FuIGJlIEdVUC1lZCB3b24ndCBiZSB2ZXJ5DQo+Pj4gdXNlZnVsLiAg
QW5kIHRoZSBWTSB3aWxsIGxlYXJuIGFib3V0IGFsbCB0aGVzZSB0aGluZ3MsIGJ1dCBNS1RNRSB3
b24ndA0KPj4+IHJlYWxseSBmaXQgaW4uDQo+Pg0KPj4gS2FpIEh1YW5nICh3aG8gaXMgb24gY2Mp
IGhhcyBiZWVuIGRvaW5nIHRoZSBRRU1VIGVuYWJsaW5nIGFuZCBtaWdodCB3YW50DQo+PiB0byB3
ZWlnaCBpbi4gIEknZCBhbHNvIGxvdmUgdG8gaGVhciBmcm9tIHRoZSBBTUQgZm9sa3MgaW4gY2Fz
ZSBJJ20gbm90DQo+PiBncm9ra2luZyBzb21lIGFzcGVjdCBvZiBTRVYuDQo+Pg0KPj4gQnV0LCBt
eSB1bmRlcnN0YW5kaW5nIGlzIHRoYXQsIGV2ZW4gdG9kYXksIG5laXRoZXIgUUVNVSBub3IgdGhl
IGtlcm5lbA0KPj4gY2FuIHNlZSBTRVYtZW5jcnlwdGVkIGd1ZXN0IG1lbW9yeS4gIFNvIFFFTVUg
c2hvdWxkIGFscmVhZHkgdW5kZXJzdGFuZA0KPj4gaG93IHRvIG5vdCBpbnRlcmFjdCB3aXRoIGd1
ZXN0IG1lbW9yeS4gIEkgX2Fzc3VtZV8gaXQncyBhbHNvIGFscmVhZHkNCj4+IGRvaW5nIHRoaXMg
d2l0aCBhbm9ueW1vdXMgbWVtb3J5LCB3aXRob3V0IG5lZWRpbmcgL2Rldi9zbWUgb3Igc29tZXRo
aW5nLg0KPiANCj4gQ29ycmVjdCBuZWl0aGVyIFFlbXUgbm9yIGtlcm5lbCBjYW4gc2VlIFNFVi1l
bmNyeXB0ZWQgZ3Vlc3QgbWVtb3J5LiBRZW11IHJlcXVpcmVzIGd1ZXN0J3MNCj4gY29vcGVyYXRp
b24gd2hlbiBpdCBuZWVkcyB0byBpbnRlcmFjdHMgd2l0aCBndWVzdCwgaS5lLiB0byBzdXBwb3J0
IHZpcnR1YWwgRE1BIChvZiB2aXJ0dWFsIGRldmljZXMNCj4gaW4gU0VWLWd1ZXN0KSwgcWVtdSBy
ZXF1aXJlcyBTRVYtZ3Vlc3QgdG8gc2V0dXAgYm91bmNlIGJ1ZmZlciAod2hpY2ggd2lsbCBub3Qg
YmUgU0VWLWVuY3J5cHRlZA0KPiBtZW1vcnksIGJ1dCBzaGFyZWQgbWVtb3J5IGNhbiBiZSBhY2Nl
c3NlZCBmcm9tIGhvc3Qgc2lkZSB0b28pLCBzbyB0aGF0IGd1ZXN0IGtlcm5lbCBjYW4gY29weSBE
TUENCj4gZGF0YSBmcm9tIGJvdW5jZSBidWZmZXIgdG8gaXRzIG93biBTRVYtZW5jcnlwdGVkIG1l
bW9yeSBhZnRlciBxZW11L2hvc3Qga2VybmVsIHB1dHMgRE1BIGRhdGEgdG8NCj4gYm91bmNlIGJ1
ZmZlci4NCg0KVGhhdCBpcyBjb3JyZWN0LiBhbiBTRVYgZ3Vlc3QgbXVzdCB1c2UgdW4tZW5jcnlw
dGVkIG1lbW9yeSBpZiBpdCB3aXNoZXMNCmZvciB0aGUgaHlwZXJ2aXNvciB0byBiZSBhYmxlIHRv
IHNlZSBpdC4gQWxzbywgdG8gc3VwcG9ydCBETUEgaW50byB0aGUNCmd1ZXN0LCB0aGUgdGFyZ2V0
IG1lbW9yeSBtdXN0IGJlIHVuLWVuY3J5cHRlZCwgd2hpY2ggU0VWIGRvZXMgdGhyb3VnaCB0aGUN
CkRNQSBhcGkgYW5kIFNXSU9UTEIuDQoNClNNRSBtdXN0IGFsc28gdXNlIGJvdW5jZSBidWZmZXJz
IGlmIHRoZSBkZXZpY2UgZG9lcyBub3Qgc3VwcG9ydCA0OC1iaXQNCkRNQSwgc2luY2UgdGhlIGVu
Y3J5cHRpb24gYml0IGlzIGJpdCA0Ny4gQW55IGRldmljZSBzdXBwb3J0aW5nIERNQSBhYm92ZQ0K
dGhlIGVuY3J5cHRpb24gYml0IHBvc2l0aW9uIGNhbiBwZXJmb3JtIERNQSB3aXRob3V0IGJvdW5j
ZSBidWZmZXJzIHVuZGVyDQpTTUUuDQoNCj4gDQo+IEFuZCB5ZXMgZnJvbSBteSByZWFkaW5nIChi
ZXR0ZXIgdG8gaGF2ZSBBTUQgZ3V5cyB0byBjb25maXJtKSBTRVYgZ3Vlc3QgdXNlcyBhbm9ueW1v
dXMgbWVtb3J5LCBidXQgaXQNCj4gYWxzbyBwaW5zIGFsbCBndWVzdCBtZW1vcnkgKGJ5IGNhbGxp
bmcgR1VQIGZyb20gS1ZNIC0tIFNFViBzcGVjaWZpY2FsbHkgaW50cm9kdWNlZCAyIEtWTSBpb2N0
bHMgZm9yDQo+IHRoaXMgcHVycG9zZSksIHNpbmNlIFNFViBhcmNoaXRlY3R1cmFsbHkgY2Fubm90
IHN1cHBvcnQgc3dhcHBpbmcsIG1pZ3JhaXRvbiBvZiBTRVYtZW5jcnlwdGVkIGd1ZXN0DQo+IG1l
bW9yeSwgYmVjYXVzZSBTTUUvU0VWIGFsc28gdXNlcyBwaHlzaWNhbCBhZGRyZXNzIGFzICJ0d2Vh
ayIsIGFuZCB0aGVyZSdzIG5vIHdheSB0aGF0IGtlcm5lbCBjYW4NCj4gZ2V0IG9yIHVzZSBTRVYt
Z3Vlc3QncyBtZW1vcnkgZW5jcnlwdGlvbiBrZXkuIEluIG9yZGVyIHRvIHN3YXAvbWlncmF0ZSBT
RVYtZ3Vlc3QgbWVtb3J5LCB3ZSBuZWVkIFNHWA0KPiBFUEMgZXZpY3Rpb24vcmVsb2FkIHNpbWls
YXIgdGhpbmcsIHdoaWNoIFNFViBkb2Vzbid0IGhhdmUgdG9kYXkuDQoNClllcywgYWxsIHRoZSBn
dWVzdCBtZW1vcnkgaXMgY3VycmVudGx5IHBpbm5lZCBieSBjYWxsaW5nIEdVUCB3aGVuIGNyZWF0
aW5nDQphbiBTRVYgZ3Vlc3QuIFRoaXMgaXMgdG8gcHJldmVudCBwYWdlIG1pZ3JhdGlvbiBieSB0
aGUga2VybmVsLiBIb3dldmVyLA0KdGhlIHN1cHBvcnQgdG8gZG8gcGFnZSBtaWdyYXRpb24gaXMg
YXZhaWxhYmxlIGluIHRoZSAwLjE3IHZlcnNpb24gb2YgdGhlDQpTRVYgQVBJIHZpYSB0aGUgQ09Q
WSBjb21tbWFuZC4gVGhlIENPUFkgY29tbWFubmQgYWxsb3dzIGZvciBjb3B5aW5nIG9mDQphbiBl
bmNyeXB0ZWQgcGFnZSBmcm9tIG9uZSBsb2NhdGlvbiB0byBhbm90aGVyIHZpYSB0aGUgUFNQLiBU
aGUgc3VwcG9ydA0KZm9yIHRoaXMgaXMgbm90IHlldCBpbiB0aGUgTGludXgga2VybmVsLCBidXQg
d2UgYXJlIHdvcmtpbmcgb24gaXQuIFRoaXMNCndvdWxkIHJlbW92ZSB0aGUgcmVxdWlyZW1lbnQg
b2YgaGF2aW5nIHRvIHBpbiB0aGUgZ3Vlc3QgbWVtb3J5Lg0KDQpUaGUgU0VWIEFQSSBhbHNvIHN1
cHBvcnRzIG1pZ3JhdGlvbiBvZiBtZW1vcnkgdmlhIHRoZSBTRU5EXyogYW5kIFJFQ0VJVkVfKg0K
QVBJcyB0byBzdXBwb3J0IGxpdmUgbWlncmF0aW9uLg0KDQpTd2FwcGluZywgaG93ZXZlciwgaXMg
bm90IHlldCBzdXBwb3J0ZWQuDQoNClRoYW5rcywNClRvbQ0KDQo+IA0KPiBGcm9tIHRoaXMgcGVy
c3BlY3RpdmUsIEkgdGhpbmsgZHJpdmVyIHByb3Bvc2FsIGtpbmRhIG1ha2VzIHNlbnNlIHNpbmNl
IHdlIGFscmVhZHkgaGF2ZSBzZWN1cml0eQ0KPiBmZWF0dXJlIHdoaWNoIHVzZXMgbm9ybWFsIG1l
bW9yeSBzb21lIGtpbmQgbGlrZSAiZGV2aWNlIG1lbW9yeSIgKG5vIHN3YXAsIG5vIG1pZ3JhdGlv
biwgZXRjKSwgc28gaXQNCj4gbWFrZXMgc2Vuc2UgdGhhdCBNS1RNRSBqdXN0IGZvbGxvd3MgdGhh
dCAoYWx0aG91Z2ggZnJvbSBIVyBNS1RNRSBjYW4gc3VwcG9ydCBzd2FwLCBwYWdlIG1pZ3JhdGlv
biwNCj4gZXRjKS4gVGhlIGRvd25zaWRlIG9mIGRyaXZlciBwcm9wb3NhbCBmb3IgTUtUTUUgSSB0
aGluayBpcywgbGlrZSBEYXZlIG1lbnRpb25lZCwgaXQncyBoYXJkIChvciBub3QNCj4gc3VyZSB3
aGV0aGVyIGl0IGlzIHBvc3NpYmxlKSB0byBleHRlbmQgdG8gc3VwcG9ydCBOVkRJTU0gKGFuZCBm
aWxlIGJhY2tlZCBndWVzdCBtZW1vcnkpLCBzaW5jZSBmb3INCj4gdmlydHVhbCBOVkRJTU0sIFFl
bXUgbmVlZHMgdG8gY2FsbCBtbWFwIGFnYWluc3QgZmQgb2YgTlZESU1NLg0KPiANCj4gVGhhbmtz
LA0KPiAtS2FpDQo+IA0K
