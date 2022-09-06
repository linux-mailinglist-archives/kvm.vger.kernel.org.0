Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 354365AEE64
	for <lists+kvm@lfdr.de>; Tue,  6 Sep 2022 17:12:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238030AbiIFPMd (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 6 Sep 2022 11:12:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51512 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232795AbiIFPMA (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 6 Sep 2022 11:12:00 -0400
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (mail-sn1anam02on20614.outbound.protection.outlook.com [IPv6:2a01:111:f400:7ea9::614])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EE5DEADCDA;
        Tue,  6 Sep 2022 07:25:34 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Q5BRszhe+o4kWlWAs/0yGzS+HcVrjYsxeUfFncK4hU+/himrKGD/C4b5ZGFs3cbBeDTR3+tXBxyuGyeyHBaqoKKYhhGn7w7IeG9uBV9K/T8pddbL54V9uwjzUAtWy1ZlUm1jTGu/FhAANt7drxAX9q56K+0q1dbiyBT2b/pte8upmv5MVqdCzs++TG6u3z0f+b7V5qex63foSTpz/UqAWuboQjv8WmeTaYpZBb59R6uZoQ7fVW5O5EjdHCVXvww2yPhuxnYBMNa3niVbnGto0PawQ8oztqiJ3SAKUMJ0+RDYBZT6mWDIeTN0vBcvUguD4z8g9kp55dqSgtzGvvfTfg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=zQ/MlFYyodAAguSYuObGbAyCmFB3/08a+4aqOyRG87Q=;
 b=JAfi38XWDfKcz9799OZ+a1G0ckpmku19OnTCHm+X6EbUMaHU4AMepCRhuwMbzAePBCzNl13U883mizxKzM234ucR5ABBqTCAdX9yaBfrh2TxVXpIF/GLOo16IRuxpp6kqkj4MXK8M3OqIp1aPHsrRA3jlWjwM2bcW/8kmHA6PbFM2HguV1WjruGXEzrTgQAOqKBCXWYY6N22XTqPiZLTa4GVtj3T2B3OSSdUEhTKlTjbJQReh6cS/gyV53Lwwbf4s+KhwIn5JP8/MhHsXCX3WtDQOI8dmQV/nd7nOppcSnV/YbqsPx9YgyD43Xj9wh0aZTgWggX+0TyAs5VnhhhBvg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zQ/MlFYyodAAguSYuObGbAyCmFB3/08a+4aqOyRG87Q=;
 b=ktB8Q81PMdZIVh3kg032aWK4wsDaxYNSEJndJu7Z5B8h1kUWsHV4C3Do3AqZ5WjwKE6Mb4uLA7ayhyRlP4Sor5198giUhwdfJpFne1wS7ClKZCNGJf63JQvS7UMu3VJ1a5c7zNT6HvdFx/vri9OH5Hap32qXQN/dfTGBpyrVBu0=
Received: from SN6PR12MB2767.namprd12.prod.outlook.com (2603:10b6:805:75::23)
 by DM6PR12MB4564.namprd12.prod.outlook.com (2603:10b6:5:2a9::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5588.10; Tue, 6 Sep
 2022 14:17:15 +0000
Received: from SN6PR12MB2767.namprd12.prod.outlook.com
 ([fe80::e47d:1a95:23d5:922c]) by SN6PR12MB2767.namprd12.prod.outlook.com
 ([fe80::e47d:1a95:23d5:922c%7]) with mapi id 15.20.5588.018; Tue, 6 Sep 2022
 14:17:15 +0000
From:   "Kalra, Ashish" <Ashish.Kalra@amd.com>
To:     Marc Orr <marcorr@google.com>, Jarkko Sakkinen <jarkko@kernel.org>
CC:     Borislav Petkov <bp@alien8.de>, x86 <x86@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        kvm list <kvm@vger.kernel.org>,
        "linux-coco@lists.linux.dev" <linux-coco@lists.linux.dev>,
        Linux Memory Management List <linux-mm@kvack.org>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Joerg Roedel <jroedel@suse.de>,
        "Lendacky, Thomas" <Thomas.Lendacky@amd.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Ard Biesheuvel <ardb@kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Jim Mattson <jmattson@google.com>,
        Andy Lutomirski <luto@kernel.org>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Sergio Lopez <slp@redhat.com>, Peter Gonda <pgonda@google.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>,
        David Rientjes <rientjes@google.com>,
        Dov Murik <dovmurik@linux.ibm.com>,
        Tobin Feldman-Fitzthum <tobin@ibm.com>,
        "Roth, Michael" <Michael.Roth@amd.com>,
        Vlastimil Babka <vbabka@suse.cz>,
        "Kirill A . Shutemov" <kirill@shutemov.name>,
        Andi Kleen <ak@linux.intel.com>,
        Tony Luck <tony.luck@intel.com>,
        Sathyanarayanan Kuppuswamy 
        <sathyanarayanan.kuppuswamy@linux.intel.com>,
        Alper Gun <alpergun@google.com>,
        "Dr . David Alan Gilbert" <dgilbert@redhat.com>
Subject: RE: [PATCH Part2 v6 09/49] x86/fault: Add support to handle the RMP
 fault for user address
Thread-Topic: [PATCH Part2 v6 09/49] x86/fault: Add support to handle the RMP
 fault for user address
Thread-Index: AQHYrBDc30zm/ve2UUW13wSedLDd3a3SXbsAgAA6ggCAAANnoA==
Date:   Tue, 6 Sep 2022 14:17:15 +0000
Message-ID: <SN6PR12MB2767ABA4CEFE4591F87968AD8E7E9@SN6PR12MB2767.namprd12.prod.outlook.com>
References: <cover.1655761627.git.ashish.kalra@amd.com>
 <0ecb0a4781be933fcadeb56a85070818ef3566e7.1655761627.git.ashish.kalra@amd.com>
 <YvKRjxgipxLSNCLe@zn.tnic> <YxcgAk7AHWZVnSCJ@kernel.org>
 <CAA03e5FgiLoixmqpKtfNOXM_0P5Y7LQzr3_oQe+2Z=GJ6kw32g@mail.gmail.com>
In-Reply-To: <CAA03e5FgiLoixmqpKtfNOXM_0P5Y7LQzr3_oQe+2Z=GJ6kw32g@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: MSIP_Label_4342314e-0df4-4b58-84bf-38bed6170a0f_Enabled=true;
 MSIP_Label_4342314e-0df4-4b58-84bf-38bed6170a0f_SetDate=2022-09-06T14:06:41Z;
 MSIP_Label_4342314e-0df4-4b58-84bf-38bed6170a0f_Method=Standard;
 MSIP_Label_4342314e-0df4-4b58-84bf-38bed6170a0f_Name=General;
 MSIP_Label_4342314e-0df4-4b58-84bf-38bed6170a0f_SiteId=3dd8961f-e488-4e60-8e11-a82d994e183d;
 MSIP_Label_4342314e-0df4-4b58-84bf-38bed6170a0f_ActionId=7eb99206-0068-4541-a803-34a693d9a3c9;
 MSIP_Label_4342314e-0df4-4b58-84bf-38bed6170a0f_ContentBits=1
msip_label_4342314e-0df4-4b58-84bf-38bed6170a0f_enabled: true
msip_label_4342314e-0df4-4b58-84bf-38bed6170a0f_setdate: 2022-09-06T14:17:13Z
msip_label_4342314e-0df4-4b58-84bf-38bed6170a0f_method: Standard
msip_label_4342314e-0df4-4b58-84bf-38bed6170a0f_name: General
msip_label_4342314e-0df4-4b58-84bf-38bed6170a0f_siteid: 3dd8961f-e488-4e60-8e11-a82d994e183d
msip_label_4342314e-0df4-4b58-84bf-38bed6170a0f_actionid: 69caa24a-380f-4409-a410-78c56c332ffb
msip_label_4342314e-0df4-4b58-84bf-38bed6170a0f_contentbits: 0
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: e25bebf1-14a3-4e32-2ec4-08da90127fd9
x-ms-traffictypediagnostic: DM6PR12MB4564:EE_
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: ajGSMcTpX/h7X2uYgIY0Ekc985JqNEe8E+xeBKZYHf/DM7BFn1BcdxODlJzfNgFopD8A2hzrSxGMU6o7IZvz6owfW7kgEKWkJagB5Vm5eh4avZN4RkmhRDm/AcRdozXfo2NO/DezC5hu6DS1Gv49w6WPwPPccJfq/LBJwAza+sqRI4KkUYEsenwT7tjmGBlAjuzSLKV5x82/1GTSat18kAMozjjqEyrTXanTyVOL7KjPnCjmR02fgNExOBrNZ6PWJUZqR5gUZTHuYRAhz2La4efYeob22bvBeDih3hKqKqW1x8SRzuJJbkPdugoaj+JhyMuT7oBm1EqdOG0rBRDXRFZWWsceBYNH/Pr5s+GOEwQnCDET691mVjz2/hq+Mdcs0nqRJSsVy8AktXuyobkTBB8lX71MVzsoaIpxPsSYhjHgnjYrVUDcP36qlJ61bmGq79+xZjp5P8ynbZawZ6xR3+NzQ97tE3f8CqeGKgE1dtXrkVsydpKE3GE7XYob3SqGhWcp3suaLyHgiT4+FVr4YPzpKD9tKneJcoEA64us7XZuQNb5IhN6geHYUiNR7wfva8ghmw6cPNKLeKMIFFgK6w9ygh9UlCJgdGszMa8ewjGg8FFzOEQRIyLXDM4ozk1IYDBFJhHCgiiPQDXhvZy3gtrs7tZ7aGBogf3eu/a723/7iGnsN4UT8YqkewBMsZlrLQcEXln/FE+xd4ESg6CAOXfZ8aiPTwQiIdyxXc7uIjRZJ7wJqp0a9abNUX909atIULq/cyRkuqFaqTE9hEGguQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR12MB2767.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(366004)(136003)(376002)(39860400002)(346002)(396003)(4326008)(66556008)(66446008)(64756008)(66476007)(76116006)(66946007)(316002)(54906003)(8676002)(2906002)(5660300002)(33656002)(52536014)(8936002)(7406005)(7416002)(110136005)(478600001)(6506007)(7696005)(26005)(86362001)(71200400001)(9686003)(186003)(38070700005)(38100700002)(55016003)(41300700001)(122000001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?TmtDV0FhdE9MNEptWmoyWXdjeXBDOUcxTFNLcWIyci9rdml3RWJUcUd1dmdt?=
 =?utf-8?B?Q1pQMkxHeVA2RzhjWmFRaWtvSy9yVmgxemFSTzVtZUVmMnBic3M5MHlwaXdx?=
 =?utf-8?B?ZnNQbHBqMXB1WFhsUGpwVnUxc2FOQS9sdEtJTUE5WHRRWmdjM1JqRHFiKzNr?=
 =?utf-8?B?MkNYRHowbjVkTDNOOElRaElTVkRRKy9KamlGdWUweDV0UUFHR3hGUXFLR2w3?=
 =?utf-8?B?S2hDalMweFNLdHQ5b3BEL1lhZlJhT1hmUWZ4U3BveE80Y3RtcllXRnBXSGJo?=
 =?utf-8?B?SjV2cWs4RlFtejc4dVlBQkNCY3E1MXgxOEMzTzJ0bmpJelBSVlEvVXp4ZnNE?=
 =?utf-8?B?ejhKemttK0JOY1ljWU9BUWcrVjI4RTd1OE9BallsYlAxS01saHpzWkprVkhh?=
 =?utf-8?B?TkloUUxubTFSM2p0cXdkMUxJeHhqY1h4dVRweng2TlJlcERnL0dWcC96dy9I?=
 =?utf-8?B?QU55Q3RZL1JKa3FNcVJzS2JXNnp0eDYvNGgvUmhzV3l4bWptM0ZvdXhibGEz?=
 =?utf-8?B?STB4M1RGRkNlSDZ5YWRYSUdkeHVkczB1VVI1YzRkYWdIS3ZFeXpYUk8vL1lN?=
 =?utf-8?B?ZVVEdHJmTGIzQWJKcGlkN3NHODhhbEpzVkRDUFM4TTFzb0J0TmpGYzFwSjFy?=
 =?utf-8?B?NHdhNGJ0a083Z0phK0F6RjRVOE5UZkJkaXlOUXFJV01oS2NvdTh2NkVGaVcx?=
 =?utf-8?B?ditnQytTT3B1b3V2NHlITzRkSWV1NGlOMTc3dGdWZGMwR2Y5SzhOaEcxaDZk?=
 =?utf-8?B?VkpuWEdhSFVHeUxSM01INWlPQnFDakFGbTdVVzZJOWswaHYwMC82UnhZSlpY?=
 =?utf-8?B?c3J0WnZ3VC9xNWQwd3BxVUhNSFFPMEhka1I4ci80c3BpNDdUMmVDWUszbjlj?=
 =?utf-8?B?RzVZVWJhbUVra1dqTXpPcHJ5c0tpVWs1ckkvSHJsa1NWWlVwQ2hGSnJtZHI5?=
 =?utf-8?B?bmV5M3lHUjZSdjRFTTE2QnhuWnhHcitRazFzVVdSYXMvZDRUc0pEbG5lY0dS?=
 =?utf-8?B?K0t1YlBKdEcwYkJSZnBBUmM5YllhQ1VoeHRHUmozWnlDMnRqU1BjY3ora3d4?=
 =?utf-8?B?eEJtaXI2MmtraHdGRHFZSEJTZFJsQ0R1a2JwbHpzRTBnN2J6QUJ0akFRK29u?=
 =?utf-8?B?dFkzUkR5WTQvYXIzd1FNeGpHZzVJTjFrMnNXaHM3TnJaUjU0R2Z5STJtUnJ2?=
 =?utf-8?B?WmlXbFhMV1ZrWkNLTzdCQ3o1czl5OEhtbkxJV0YzSWdtRkpHYXRySUV0eUpK?=
 =?utf-8?B?K0UvTEx6K21HM3lBY0YxaFZyUlZxak9WWWhESmVDVVpGOXVBZTl1emdpZXVy?=
 =?utf-8?B?WGZtSmNaU3d6b1dKRW1IOEFEY2lBRVBMMGFsK1A5TzJINkhRbXVGcUNlYVU1?=
 =?utf-8?B?Q3lpdEd5aWNMakJaTEgxTUZVMGVwV3FQZHpLbWt1S1Zwdll1L2hoVWFXVEw2?=
 =?utf-8?B?UjZuclUyV3FsVVVHZUExbW94dENmaFFTb0lCQmJldkNiQUx2ZzJ0Wk1qS0R0?=
 =?utf-8?B?S1Vsd1Z2UHR1eVdmODQ1ZlVpWXkzc3dGeldvMVhYSUtSeEwzY1YvOFlzUndR?=
 =?utf-8?B?eEtDRmFES05WNzBrNVVka1ZSTW9aNDBpdEY5c0wxVU4wdDNDMys0amxydHZI?=
 =?utf-8?B?MGdFenk4RVlTckFhZFBuc2JSd2plQlFzR25SenphTHMwQkRrc2JTRzVSclg1?=
 =?utf-8?B?MWZFcVRQWFBrc0dpMFFJck1Pc3hyVHVUV2xSa296MHBGWkZFanZHa1lBOFdm?=
 =?utf-8?B?aHM0VnZPa2luUGUvZGs4RHVZcnVIbXhVNEpMMEp2VHBvem5rNGs1RmtEZ25K?=
 =?utf-8?B?ZWhweHI0cnF6MGlYNzRRZlNweW56SVNtZThZb1hORS9UbXpqMlU1QmF5S2p2?=
 =?utf-8?B?QWZmelJqV21hTFdLL2ZrcDErcEs2eEZXd3dwU0pJTDM5ejJjOGFjMjdnSjFz?=
 =?utf-8?B?emQyUXhRRTNwSFhsV2dNWUkydTA5aTJRbWsxVzFpMVFyZEZ5RUhPeFRuWkdj?=
 =?utf-8?B?NldsQVhUaTVrWFF1QjVEVzNkT2pOT1d6VUYrSzJkeHZWTTRVUFhBcHorbHJy?=
 =?utf-8?B?OWJRTitEYzlKZGRIakwveUpzZjFaRkFPS2lwaE5HaU9XTGs0WFZsZ0pKRngy?=
 =?utf-8?Q?DGcI=3D?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SN6PR12MB2767.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e25bebf1-14a3-4e32-2ec4-08da90127fd9
X-MS-Exchange-CrossTenant-originalarrivaltime: 06 Sep 2022 14:17:15.4472
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Z818de6bu/tbw2Secjzbq8G+16o5o4vApBrx5Wq3i4xC/lnIlirvxeK8EemkLjcEwTtO/EAZjIFc2LESq/qtXg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB4564
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

W0FNRCBPZmZpY2lhbCBVc2UgT25seSAtIEdlbmVyYWxdDQoNCj4+IE9uIFR1ZSwgQXVnIDA5LCAy
MDIyIGF0IDA2OjU1OjQzUE0gKzAyMDAsIEJvcmlzbGF2IFBldGtvdiB3cm90ZToNCj4+ID4gT24g
TW9uLCBKdW4gMjAsIDIwMjIgYXQgMTE6MDM6NDNQTSArMDAwMCwgQXNoaXNoIEthbHJhIHdyb3Rl
Og0KPj4gPiA+ICsgICBwZm4gPSBwdGVfcGZuKCpwdGUpOw0KPj4gPiA+ICsNCj4+ID4gPiArICAg
LyogSWYgaXRzIGxhcmdlIHBhZ2UgdGhlbiBjYWxjdWx0ZSB0aGUgZmF1bHQgcGZuICovDQo+PiA+
ID4gKyAgIGlmIChsZXZlbCA+IFBHX0xFVkVMXzRLKSB7DQo+PiA+ID4gKyAgICAgICAgICAgdW5z
aWduZWQgbG9uZyBtYXNrOw0KPj4gPiA+ICsNCj4+ID4gPiArICAgICAgICAgICBtYXNrID0gcGFn
ZXNfcGVyX2hwYWdlKGxldmVsKSAtIHBhZ2VzX3Blcl9ocGFnZShsZXZlbCAtIDEpOw0KPj4gPiA+
ICsgICAgICAgICAgIHBmbiB8PSAoYWRkcmVzcyA+PiBQQUdFX1NISUZUKSAmIG1hc2s7DQo+PiA+
DQo+PiA+IE9oIGJveSwgdGhpcyBpcyB1bm5lY2Vzc2FyaWx5IGNvbXBsaWNhdGVkLiBJc24ndCB0
aGlzDQo+PiA+DQo+PiA+ICAgICAgIHBmbiB8PSBwdWRfaW5kZXgoYWRkcmVzcyk7DQo+PiA+DQo+
PiA+IG9yDQo+PiA+ICAgICAgIHBmbiB8PSBwbWRfaW5kZXgoYWRkcmVzcyk7DQo+Pg0KPj4gSSBw
bGF5ZWQgd2l0aCB0aGlzIGEgYml0IGFuZCBlbmRlZCB1cCB3aXRoDQo+Pg0KPj4gICAgICAgICBw
Zm4gPSBwdGVfcGZuKCpwdGUpIHwgUEZOX0RPV04oYWRkcmVzcyAmIHBhZ2VfbGV2ZWxfbWFzayhs
ZXZlbCANCj4+IC0gMSkpOw0KPj4NCj4+IFVubGVzcyBJIGdvdCBzb21ldGhpbmcgdGVycmlibHkg
d3JvbmcsIHRoaXMgc2hvdWxkIGRvIHRoZSBzYW1lIChzZWUgDQo+PiB0aGUgYXR0YWNoZWQgcGF0
Y2gpIGFzIHRoZSBleGlzdGluZyBjYWxjdWxhdGlvbnMuDQoNCj5BY3R1YWxseSwgSSBkb24ndCB0
aGluayB0aGV5J3JlIHRoZSBzYW1lLiBJIHRoaW5rIEphcmtrbydzIHZlcnNpb24gaXMgY29ycmVj
dC4gU3BlY2lmaWNhbGx5Og0KPi0gRm9yIGxldmVsID0gUEdfTEVWRUxfMk0gdGhleSdyZSB0aGUg
c2FtZS4NCj4tIEZvciBsZXZlbCA9IFBHX0xFVkVMXzFHOg0KPlRoZSBjdXJyZW50IGNvZGUgY2Fs
Y3VsYXRlcyBhIGdhcmJhZ2UgbWFzazoNCj5tYXNrID0gcGFnZXNfcGVyX2hwYWdlKGxldmVsKSAt
IHBhZ2VzX3Blcl9ocGFnZShsZXZlbCAtIDEpOyB0cmFuc2xhdGVzIHRvOg0KPj4+IGhleCgyNjIx
NDQgLSA1MTIpDQo+JzB4M2ZlMDAnDQoNCk5vIGFjdHVhbGx5IHRoaXMgaXMgbm90IGEgZ2FyYmFn
ZSBtYXNrLCBhcyBJIGV4cGxhaW5lZCBpbiBlYXJsaWVyIHJlc3BvbnNlcyB3ZSBuZWVkIHRvIGNh
cHR1cmUgdGhlIGFkZHJlc3MgYml0cyANCnRvIGdldCB0byB0aGUgY29ycmVjdCA0SyBpbmRleCBp
bnRvIHRoZSBSTVAgdGFibGUuDQpUaGVyZWZvcmUsIGZvciBsZXZlbCA9IFBHX0xFVkVMXzFHOg0K
bWFzayA9IHBhZ2VzX3Blcl9ocGFnZShsZXZlbCkgLSBwYWdlc19wZXJfaHBhZ2UobGV2ZWwgLSAx
KSA9PiAweDNmZTAwICh3aGljaCBpcyB0aGUgY29ycmVjdCBtYXNrKS4NCg0KPkJ1dCBJIGJlbGll
dmUgSmFya2tvJ3MgdmVyc2lvbiBjYWxjdWxhdGVzIHRoZSBjb3JyZWN0IG1hc2sgKGJlbG93KSwg
aW5jb3Jwb3JhdGluZyBhbGwgMTggb2Zmc2V0IGJpdHMgaW50byB0aGUgMUcgcGFnZS4NCj4+PiBo
ZXgoMjYyMTQ0IC0xKQ0KPicweDNmZmZmJw0KDQpXZSBjYW4gZ2V0IHRoaXMgc2ltcGx5IGJ5IGRv
aW5nIChwYWdlX3Blcl9ocGFnZShsZXZlbCktMSksIGJ1dCBhcyBJIG1lbnRpb25lZCBhYm92ZSB0
aGlzIGlzIG5vdCB3aGF0IHdlIG5lZWQuDQoNClRoYW5rcywNCkFzaGlzaA0K
