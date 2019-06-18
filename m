Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 81D3B4973D
	for <lists+kvm@lfdr.de>; Tue, 18 Jun 2019 04:02:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727479AbfFRCCF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 17 Jun 2019 22:02:05 -0400
Received: from mail-eopbgr700076.outbound.protection.outlook.com ([40.107.70.76]:34816
        "EHLO NAM04-SN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726026AbfFRCCD (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 17 Jun 2019 22:02:03 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector1-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=x2wpQ4AhiN7KRVspeIae1sst5lVNYjKBsjHdOpOWzvg=;
 b=mhAG8ElhryKzlq8NJLeAv6nMuRp+RegP0f6mCBYT0LkNCClPd9iHcauNq8qXzhmzU53O+C7fAfwv/ne/DRqViKQanL0HIiwhsZVOeU2sJRkIrvrYloq0ckm3XIsIJIecgyBogTr7bTdgFLgO2zaB044Q5Q9EtMHshiwCz2+5R2g=
Received: from DM6PR12MB3163.namprd12.prod.outlook.com (20.179.104.150) by
 DM6PR12MB3611.namprd12.prod.outlook.com (20.178.199.85) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1987.11; Tue, 18 Jun 2019 02:02:00 +0000
Received: from DM6PR12MB3163.namprd12.prod.outlook.com
 ([fe80::bcaf:86d4:677f:9555]) by DM6PR12MB3163.namprd12.prod.outlook.com
 ([fe80::bcaf:86d4:677f:9555%6]) with mapi id 15.20.1987.014; Tue, 18 Jun 2019
 02:02:00 +0000
From:   "Lendacky, Thomas" <Thomas.Lendacky@amd.com>
To:     Andy Lutomirski <luto@kernel.org>
CC:     Kai Huang <kai.huang@linux.intel.com>,
        Dave Hansen <dave.hansen@intel.com>,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
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
Thread-Index: AQHVBaytkz7iqCERRUG2Tf+Vvry8YKagMWmAgAAF3ICAAAT1AIAALTSAgABck4D//8anAIAAVZ+AgAAF/gA=
Date:   Tue, 18 Jun 2019 02:02:00 +0000
Message-ID: <ac6c02da-5439-1f24-1975-7ba626599d14@amd.com>
References: <20190508144422.13171-1-kirill.shutemov@linux.intel.com>
 <20190508144422.13171-46-kirill.shutemov@linux.intel.com>
 <CALCETrVCdp4LyCasvGkc0+S6fvS+dna=_ytLdDPuD2xeAr5c-w@mail.gmail.com>
 <3c658cce-7b7e-7d45-59a0-e17dae986713@intel.com>
 <CALCETrUPSv4Xae3iO+2i_HecJLfx4mqFfmtfp+cwBdab8JUZrg@mail.gmail.com>
 <5cbfa2da-ba2e-ed91-d0e8-add67753fc12@intel.com>
 <1560815959.5187.57.camel@linux.intel.com>
 <cbbc6af7-36f8-a81f-48b1-2ad4eefc2417@amd.com>
 <CALCETrWq98--AgXXj=h1R70CiCWNncCThN2fEdxj2ZkedMw6=A@mail.gmail.com>
In-Reply-To: <CALCETrWq98--AgXXj=h1R70CiCWNncCThN2fEdxj2ZkedMw6=A@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: DM3PR14CA0137.namprd14.prod.outlook.com
 (2603:10b6:0:53::21) To DM6PR12MB3163.namprd12.prod.outlook.com
 (2603:10b6:5:182::22)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=Thomas.Lendacky@amd.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [165.204.77.1]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 55b38e2f-3409-47ff-530a-08d6f390f307
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:DM6PR12MB3611;
x-ms-traffictypediagnostic: DM6PR12MB3611:
x-microsoft-antispam-prvs: <DM6PR12MB3611ED2007AC594304E8E064ECEA0@DM6PR12MB3611.namprd12.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-forefront-prvs: 007271867D
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(366004)(376002)(346002)(136003)(39860400002)(396003)(199004)(189003)(6512007)(5660300002)(73956011)(86362001)(186003)(25786009)(6116002)(102836004)(4326008)(3846002)(7736002)(53936002)(6916009)(26005)(2906002)(81166006)(81156014)(8676002)(8936002)(68736007)(305945005)(31686004)(54906003)(478600001)(72206003)(66066001)(14444005)(256004)(6486002)(6246003)(229853002)(316002)(36756003)(66946007)(66476007)(64756008)(66446008)(99286004)(52116002)(66556008)(71200400001)(446003)(7416002)(486006)(11346002)(71190400001)(6436002)(76176011)(476003)(2616005)(386003)(6506007)(53546011)(14454004)(31696002);DIR:OUT;SFP:1101;SCL:1;SRVR:DM6PR12MB3611;H:DM6PR12MB3163.namprd12.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: amd.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: mCBZSMfEJuqEOgcFctyscRO40vl/MLZeyxHm+2GZZFFXPLSA1UxLiosr/L8sEV1/698Fd2R/ln03dJuDH4Bt/lKUfH5BQ9tyZDEx5gWC3zJcpsaUkhLFBT/M1TluLanYYyQdeOqm99iBqgJqBK60Pyrxn/IcS7DhUhf5IF2mnoTCyNQ5S+Skkrl7Eb3fK0fAd498+FQliQUfDrO0li69D4lzgu2SDCChB2OdwaIdzX3hlNq6vQ7l35K4B24JXCwkUU40DpPOur39FhTULf/jU5gP5Ji6bRuD7EEHTUPNkCKb4Vmw+OFz8serShUPsya74C2dhuJT+XOoYPGCqYYrmsbJG3P/NBJOx+wz086b8Lv0xmY9MzL8DhQPZadzSyJ7SlxFM+qBpCobm8lxoDN4nxmV/UVuEQhjSSGaAjTBQn8=
Content-Type: text/plain; charset="utf-8"
Content-ID: <A758D81DF226754D84136CBF9C60D751@namprd12.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 55b38e2f-3409-47ff-530a-08d6f390f307
X-MS-Exchange-CrossTenant-originalarrivaltime: 18 Jun 2019 02:02:00.0995
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: tlendack@amd.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB3611
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

T24gNi8xNy8xOSA4OjQwIFBNLCBBbmR5IEx1dG9taXJza2kgd3JvdGU6DQo+IE9uIE1vbiwgSnVu
IDE3LCAyMDE5IGF0IDY6MzQgUE0gTGVuZGFja3ksIFRob21hcw0KPiA8VGhvbWFzLkxlbmRhY2t5
QGFtZC5jb20+IHdyb3RlOg0KPj4NCj4+IE9uIDYvMTcvMTkgNjo1OSBQTSwgS2FpIEh1YW5nIHdy
b3RlOg0KPj4+IE9uIE1vbiwgMjAxOS0wNi0xNyBhdCAxMToyNyAtMDcwMCwgRGF2ZSBIYW5zZW4g
d3JvdGU6DQo+IA0KPj4+DQo+Pj4gQW5kIHllcyBmcm9tIG15IHJlYWRpbmcgKGJldHRlciB0byBo
YXZlIEFNRCBndXlzIHRvIGNvbmZpcm0pIFNFViBndWVzdCB1c2VzIGFub255bW91cyBtZW1vcnks
IGJ1dCBpdA0KPj4+IGFsc28gcGlucyBhbGwgZ3Vlc3QgbWVtb3J5IChieSBjYWxsaW5nIEdVUCBm
cm9tIEtWTSAtLSBTRVYgc3BlY2lmaWNhbGx5IGludHJvZHVjZWQgMiBLVk0gaW9jdGxzIGZvcg0K
Pj4+IHRoaXMgcHVycG9zZSksIHNpbmNlIFNFViBhcmNoaXRlY3R1cmFsbHkgY2Fubm90IHN1cHBv
cnQgc3dhcHBpbmcsIG1pZ3JhaXRvbiBvZiBTRVYtZW5jcnlwdGVkIGd1ZXN0DQo+Pj4gbWVtb3J5
LCBiZWNhdXNlIFNNRS9TRVYgYWxzbyB1c2VzIHBoeXNpY2FsIGFkZHJlc3MgYXMgInR3ZWFrIiwg
YW5kIHRoZXJlJ3Mgbm8gd2F5IHRoYXQga2VybmVsIGNhbg0KPj4+IGdldCBvciB1c2UgU0VWLWd1
ZXN0J3MgbWVtb3J5IGVuY3J5cHRpb24ga2V5LiBJbiBvcmRlciB0byBzd2FwL21pZ3JhdGUgU0VW
LWd1ZXN0IG1lbW9yeSwgd2UgbmVlZCBTR1gNCj4+PiBFUEMgZXZpY3Rpb24vcmVsb2FkIHNpbWls
YXIgdGhpbmcsIHdoaWNoIFNFViBkb2Vzbid0IGhhdmUgdG9kYXkuDQo+Pg0KPj4gWWVzLCBhbGwg
dGhlIGd1ZXN0IG1lbW9yeSBpcyBjdXJyZW50bHkgcGlubmVkIGJ5IGNhbGxpbmcgR1VQIHdoZW4g
Y3JlYXRpbmcNCj4+IGFuIFNFViBndWVzdC4NCj4gDQo+IEljay4NCj4gDQo+IFdoYXQgaGFwcGVu
cyBpZiBRRU1VIHRyaWVzIHRvIHJlYWQgdGhlIG1lbW9yeT8gIERvZXMgaXQganVzdCBzZWUNCj4g
Y2lwaGVydGV4dD8gIElzIGNhY2hlIGNvaGVyZW5jeSBsb3N0IGlmIFFFTVUgd3JpdGVzIGl0Pw0K
DQpJZiBRRU1VIHRyaWVzIHRvIHJlYWQgdGhlIG1lbW9yeSBpcyB3b3VsZCBqdXN0IHNlZSBjaXBo
ZXJ0ZXh0LiBJJ2xsDQpkb3VibGUgY2hlY2sgb24gdGhlIHdyaXRlIHNpdHVhdGlvbiwgYnV0IEkg
dGhpbmsgeW91IHdvdWxkIGVuZCB1cCB3aXRoDQphIGNhY2hlIGNvaGVyZW5jeSBpc3N1ZSBiZWNh
dXNlIHRoZSB3cml0ZSBieSBRRU1VIHdvdWxkIGJlIHdpdGggdGhlDQpoeXBlcnZpc29yIGtleSBh
bmQgdGFnZ2VkIHNlcGFyYXRlbHkgaW4gdGhlIGNhY2hlIGZyb20gdGhlIGd1ZXN0IGNhY2hlDQpl
bnRyeS4gU0VWIHByb3ZpZGVzIGNvbmZpZGVudGlhbGl0eSBvZiBndWVzdCBtZW1vcnkgZnJvbSB0
aGUgaHlwZXJ2aXNvciwNCml0IGRvZXNuJ3QgcHJldmVudCB0aGUgaHlwZXJ2aXNvciBmcm9tIHRy
YXNoaW5nIHRoZSBndWVzdCBtZW1vcnkuDQoNCg0KVGhhbmtzLA0KVG9tDQoNCj4gDQo=
