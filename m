Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9F0AD62CEF4
	for <lists+kvm@lfdr.de>; Thu, 17 Nov 2022 00:42:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233716AbiKPXmx (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 16 Nov 2022 18:42:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60718 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238998AbiKPXmg (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 16 Nov 2022 18:42:36 -0500
Received: from JPN01-TYC-obe.outbound.protection.outlook.com (mail-tycjpn01on2059.outbound.protection.outlook.com [40.107.114.59])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 78ED168697;
        Wed, 16 Nov 2022 15:41:53 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=DpfbhEG3A4Y9asLnpwJSzs+ZoSDJmFlycWvUY7IFPRiB0I4K/hHHl8xYPLk0EprhIc5iEhoZLbVEL7jDYIuALh/i5DDnng1SD6IbwmRtyDDNKHNfG+AO2OI0OSn3cc3hBjJO5UqIUYgN6QxwK5b64j8nj+pDdc6VH1ysEZdEP1bR+GjGMaWeX+oYlM+90zZBrI78oo8JHAtHP5/TIfdNnd6oWiTnE6OMnGUcpxMW+roRWnTmFrmocHQRPAUktOqpUPvcefDfOPkHrJ8eajeJcN6gWWPeNOR2yHvGA6jguo0Fqhm4q89NrGpG2Z8/kJYo+FkhL5IC7WKHd/mCVdQv0w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=3sqla0WmeW/nXyd4btL2nLeqghpEeXdGKxIFdLiWUn8=;
 b=P9IFXPQn8a4sQo/iRENiw+vZkl/ijacwnYa6zz7oagC2Mza8IX/nLrPMocZ7/llbPcdPHEV6WqAJo4vDBeHBBZFESkFDJS+m5GH2iPnpN5vIAz0B6AQjjcavutlV2favbA/xn3AeSo0S5iSv46hNyoHcg4WSTX1gOQnV0U31GlG1r5lmyzex8/st+DZChnlmW51TfFEsu3AcN4/Q6lQMLzoNHPzSlRgb2Vqf1roZZqoK/XtgSEV8Yh0rZ6sysnMfI2/gCEmUj7QhxzTSzw60sqQH17ZWlWV04ZaFXKrQmUIDutIJG/RCdKWoNnslO5MdzGU4tLm9zlhtbIN4pDxbTw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nec.com; dmarc=pass action=none header.from=nec.com; dkim=pass
 header.d=nec.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nec.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3sqla0WmeW/nXyd4btL2nLeqghpEeXdGKxIFdLiWUn8=;
 b=jqxRSIsooA0faZ3c8C786/+HiQLqY+iKggzzdisH+WqNsiPkHJA0ycfyZx2GZ7teznqRxd9pzsWyji1po+UqEcLmgS8NA8ic8d70SQCBeTgH0A81ij/b9pwBIUxUgC+BDKvFRbcbtVk58LrWmExjxygdD16vyP6LRuILcs0ioKE=
Received: from TYWPR01MB8591.jpnprd01.prod.outlook.com (2603:1096:400:13c::10)
 by OSZPR01MB8878.jpnprd01.prod.outlook.com (2603:1096:604:1c4::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5813.19; Wed, 16 Nov
 2022 23:41:35 +0000
Received: from TYWPR01MB8591.jpnprd01.prod.outlook.com
 ([fe80::9f34:8082:cd2f:589c]) by TYWPR01MB8591.jpnprd01.prod.outlook.com
 ([fe80::9f34:8082:cd2f:589c%7]) with mapi id 15.20.5813.019; Wed, 16 Nov 2022
 23:41:35 +0000
From:   =?utf-8?B?SE9SSUdVQ0hJIE5BT1lBKOWggOWPo+OAgOebtOS5nyk=?= 
        <naoya.horiguchi@nec.com>
To:     "Kalra, Ashish" <ashish.kalra@amd.com>
CC:     Vlastimil Babka <vbabka@suse.cz>, Borislav Petkov <bp@alien8.de>,
        "x86@kernel.org" <x86@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-coco@lists.linux.dev" <linux-coco@lists.linux.dev>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "jroedel@suse.de" <jroedel@suse.de>,
        "thomas.lendacky@amd.com" <thomas.lendacky@amd.com>,
        "hpa@zytor.com" <hpa@zytor.com>,
        "ardb@kernel.org" <ardb@kernel.org>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "seanjc@google.com" <seanjc@google.com>,
        "vkuznets@redhat.com" <vkuznets@redhat.com>,
        "jmattson@google.com" <jmattson@google.com>,
        "luto@kernel.org" <luto@kernel.org>,
        "dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>,
        "slp@redhat.com" <slp@redhat.com>,
        "pgonda@google.com" <pgonda@google.com>,
        "peterz@infradead.org" <peterz@infradead.org>,
        "srinivas.pandruvada@linux.intel.com" 
        <srinivas.pandruvada@linux.intel.com>,
        "rientjes@google.com" <rientjes@google.com>,
        "dovmurik@linux.ibm.com" <dovmurik@linux.ibm.com>,
        "tobin@ibm.com" <tobin@ibm.com>,
        "michael.roth@amd.com" <michael.roth@amd.com>,
        "kirill@shutemov.name" <kirill@shutemov.name>,
        "ak@linux.intel.com" <ak@linux.intel.com>,
        "tony.luck@intel.com" <tony.luck@intel.com>,
        "marcorr@google.com" <marcorr@google.com>,
        "sathyanarayanan.kuppuswamy@linux.intel.com" 
        <sathyanarayanan.kuppuswamy@linux.intel.com>,
        "alpergun@google.com" <alpergun@google.com>,
        "dgilbert@redhat.com" <dgilbert@redhat.com>,
        "jarkko@kernel.org" <jarkko@kernel.org>,
        "Kaplan, David" <David.Kaplan@amd.com>,
        Miaohe Lin <linmiaohe@huawei.com>,
        Oscar Salvador <osalvador@suse.de>
Subject: Re: [PATCH Part2 v6 14/49] crypto: ccp: Handle the legacy TMR
 allocation when SNP is enabled
Thread-Topic: [PATCH Part2 v6 14/49] crypto: ccp: Handle the legacy TMR
 allocation when SNP is enabled
Thread-Index: AQHY+QUKixDhQnL6BEGWafa4FSvWmK5BA+sAgABWS4CAAN2ogA==
Date:   Wed, 16 Nov 2022 23:41:35 +0000
Message-ID: <20221116234131.GA871021@hori.linux.bs1.fc.nec.co.jp>
References: <380c9748-1c86-4763-ea18-b884280a3b60@amd.com>
 <Y1e5oC9QyDlKpxZ9@zn.tnic> <6511c122-d5cc-3f8d-9651-7c2cd67dc5af@amd.com>
 <Y2A6/ZwvKhpNBTMP@zn.tnic> <dc89b2f4-1053-91ac-aeac-bb3b25f9ebc7@amd.com>
 <Y2JS7kn8Q9P4rXso@zn.tnic> <c2ce6317-aa51-2a2b-2d75-ad1fd269f3fa@amd.com>
 <7882353e-2b13-d35a-b462-cef35ee56f51@suse.cz>
 <20221116051920.GA821796@hori.linux.bs1.fc.nec.co.jp>
 <db100e84-4adb-d661-fe1b-f6bb34247fa2@amd.com>
In-Reply-To: <db100e84-4adb-d661-fe1b-f6bb34247fa2@amd.com>
Accept-Language: ja-JP, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nec.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: TYWPR01MB8591:EE_|OSZPR01MB8878:EE_
x-ms-office365-filtering-correlation-id: 02520624-4f5b-4889-bf45-08dac82c1929
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: Notevoya4YER7x1XwGIqt8MjgMUSGEG0X/OkB83QWyi1vmbsd8vCPwjetYdP6gu5ykbvTpv2BdXtczmHx/Mm+jUxydN3igO0Dl7skvS2JRpTHYszr16PNHO58rZnZ33xDcRN3Daprd04DMxByM7kEL3lCXpwE1XR7+bU3U7XcAeL6E2hJBlzn52uzEkr2RCnLctdxl6hpmLib//MAgBPmgCk3kjKr6U7lDI/EdA9ekKhCj3CVSDVPICzCWn6n3oIHywJU0DdxUBNu+irh50EkpuwCILywA3eiFSIN2B82xC1lFDiwKouu8SQ8tl4B4Y0fIPNvWL6sXMLm10veh2OhRH3mG51xxWnVWo/d/VV2FfG83W5b8MUlCn08OiOhmxdSbJV0Ll5Y0mxtXAWdP0YioamPfsFBssTl7ffWhBapeoWLsZh2vOvh8j6GCDU6P8Oduvovqugr2TyXGzWWNfi5JSyWod6HZ/zNtYWZwD4aBe6jW2qSGoadyTsrgWCHRx3b8MRgsklqgXo7py6TE11K84IDK5wtyRUnEka+ldJFRXWtqHRZVcjOrQj8cO3OpTNN0VZgeSAvIUP4Dpi5fAfgIJ2y3kyAz83QSLDDss10sSSa5Vz1F3ltiiP9D5H2lP7yjMrTXqKFz2NyKrEdOXRx53ban9Wf1cP6x4pKAyi8vSFcY9soirBU7YTzHaEck2i2/zfLVGgKVIH95fi4n4HFf3w8M1U1gEROyjvf0+qwdaC74Rr5ZLl7nKqH1G9OOZ23YkmkgDdd+xpsJlGj/CkSuKEwI117M/DEnQ5T/z+1ww=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:TYWPR01MB8591.jpnprd01.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(39860400002)(366004)(346002)(396003)(376002)(136003)(451199015)(53546011)(6916009)(54906003)(6506007)(6512007)(9686003)(26005)(71200400001)(45080400002)(6486002)(966005)(478600001)(41300700001)(66476007)(66946007)(66556008)(66446008)(76116006)(64756008)(8676002)(4326008)(8936002)(7406005)(186003)(7416002)(5660300002)(2906002)(83380400001)(1076003)(86362001)(85182001)(38070700005)(316002)(33656002)(122000001)(38100700002)(82960400001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?cy9zczRVVFRIbnF6dnNvOXltWTZqenRBdWJvREQ0TjR3czMxbldseE5ieGVs?=
 =?utf-8?B?Z2tpYWVyeG5rcFVsYXNSc1JmWlBNZmlsNlF3bTRiMFNDdFNwT0k1dE5yMlJR?=
 =?utf-8?B?TzYxRzJHcWZiQ1J4L0p0Y0phT3RLUFN6eUxIY3NGd3lsVHV0YTB5QU5Memwy?=
 =?utf-8?B?bnhDRFFsbEJKazZvbkU2ZW1ZMXJpZUN5WTVvcXliQVJTbklGS25Rc3JSd041?=
 =?utf-8?B?OXNrakdxVjFKbW5zVncxZzUzMm9ZMGRMNUlUOUR5VkxMeE5ydmFnKzYwM0pC?=
 =?utf-8?B?djZDWVB5RDlRSWx2UmRtbTVxV2Z2NFVGNURtNk9GYksyaEpqL3dRZUNoeVpx?=
 =?utf-8?B?NmdpV0NkbUV1ejhCY0EzUEtjM2ZCdi9ubXczRnBWWWU2OVVVL3VRSFJXejBo?=
 =?utf-8?B?UFkrRHdFVDc3NExIQzBFLzdwZ1AvZFovdHhMdWViV1lHdDFjZmg5VjVpUDhp?=
 =?utf-8?B?bHlJaXVETlBUcTRIdXlJSDUyZExOOVlacC9SRTFGRjFDdDJxcnJZVVRHVzJi?=
 =?utf-8?B?TFhJd2JlclRGTGJYRGsreVdVNDVjZzRBczlzOTdvZU50Z0VybVhRcVFHaHRJ?=
 =?utf-8?B?dzZCN1dHQ3hZVmxYbnBzZnYwOXZ1dEZYb0xmNjJ1dXBKejVRQTBLUGFmQldu?=
 =?utf-8?B?MHdQem9TWjdOeGkvMmx0UnpqZ3RWL2pDNVExQURmaWQrKy9PR1dGTTYvVzlD?=
 =?utf-8?B?akErdWd1SzVodUNqQ2lyN1F2Z3hsVm5UV2xSNThmODlXOTFFdnBzSVdpcUxR?=
 =?utf-8?B?akNDWlI2TCs2a25TUHl5K1BxS1dlRjFaVm5DdVlWekxPTytYM2NjWGsrUW43?=
 =?utf-8?B?RjF2OUdYZTJ6MldyaTdDZmRZWFNha1NoOVRuc3ExTVR5dDkxSjQxZGJvQmRO?=
 =?utf-8?B?aTdiU3ZVZFUzdUtMK2dhU2k4anM5a0pRc3phZGkyTy95SFFWa2I4UThvc2Za?=
 =?utf-8?B?SGtHdzEyUk1lRTdzdjZ0NU9nd3RaNmxSWWtMM1FRcU9ZYk1UUjJwSlJVeFNM?=
 =?utf-8?B?SG9BeVZIamMxZi9OZTNPS0pSYndMNlhUbmRwOXJZVitscTNTZ1JKZ1NicDht?=
 =?utf-8?B?ZkpqSXB5b3o5YjFucGNYV0pOWWMrWlN5c2VTN3FHVFM1ZDJvTzg1c1R6WVVK?=
 =?utf-8?B?dFU0Y0FTU05wVzRUQ2tlRGgxeTV3cWhXZG5JYW13eHlmYWRjR04zZFVhMmZD?=
 =?utf-8?B?WEJBWmwrK1Y0QkcyUk8xbVN6ZWJIbzYzNUdYQmhEQWdCNTIzYXpIUzVMMlNv?=
 =?utf-8?B?ZXhXNk1vcER3bGwzVGdwNVlPczdIZ3lURC9tMXQwR1c2WGJrWFI5WXdKbUpW?=
 =?utf-8?B?Qi82V0J2cHBKRENCV3hEMDV0OUIyMmVpYzFXa2lOTHlQd1I2eExNTjBjZXRG?=
 =?utf-8?B?ZTFJTW56TDhWN0VUWm84QitvQW1ScEJMZko0cGhST3IxUmlRK3FOdGdRVGIy?=
 =?utf-8?B?RTM0YWtHS28xaXRGV3o3blAyTG92ZU5YVzM0cUxFV0MvUWVZd2M3Y3pJL0VJ?=
 =?utf-8?B?ZGF3c0Y5d3FsRmZielRKK0ZRQWs5QyttTTRWeVB4ZDA0cW1CUVB4b0hZNi81?=
 =?utf-8?B?alEwRXkyUVAxcVJDVm9YR0g2a0hWZkZWaGduMCtLMU5nUnV1c1V3R0ZIblN4?=
 =?utf-8?B?RmFPaFFHZEtiTE9hREZuaWZiZVhCbW9QcktrRmFsbDNpM2dDenJzTEdDZFpt?=
 =?utf-8?B?TUp4WHVkenRuNnh4cXJFZDNuMWVOdEh6bWZGV0oxOU5IVElGa0x5RVBUeFQ3?=
 =?utf-8?B?eWdvZkF0cjgzQkgyZDlpWko4b3hENzRudDBzUlhoem9DQW4yUUdHeDNOd29k?=
 =?utf-8?B?eEJFTWp3OTJHeUxMemE1cnlVV2FlYzMvdW1qZUUrbXdQMXlxczRmREZZK1g4?=
 =?utf-8?B?SGRDdHk1eEduaUJxY1FLVkxtaDdIMHVlU1F4TjhCaUZpUkVvdTRNV3NjRUMv?=
 =?utf-8?B?ZjY0RnhGaXJpSkxWd3QvVU41d1lKbG1ic0dadTZhaFN1SW5NMk5rdUpBbFlT?=
 =?utf-8?B?K3dhVytUNmgrRkhpVFFHaGZqOHY1amFPeXlXdjMyL1RBSVhtNzIyNXk0aGo3?=
 =?utf-8?B?MWlNUm41WkRFUWdVc2tiWVVrMVRPakxVUkw2TThWOWlaWldoZlErb0JsdkVE?=
 =?utf-8?B?U2lMRXpZRm5oSEd6VURoWEhOVitaR3M2OWlEd1IzaW5DaGIvQlBIcXRZRVdF?=
 =?utf-8?B?Vnc9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <E4FE0CC6E48A834B82A71E43C8CA0088@jpnprd01.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: nec.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: TYWPR01MB8591.jpnprd01.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 02520624-4f5b-4889-bf45-08dac82c1929
X-MS-Exchange-CrossTenant-originalarrivaltime: 16 Nov 2022 23:41:35.2004
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: e67df547-9d0d-4f4d-9161-51c6ed1f7d11
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: jonjJ2+wtpbM+asf5nCWH2R63tjrlNWHrGmYv0+6CYzNZfVn1JQuMx0MGGwoORBdM4JXg5JzQYpaOlnvBUXcMQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: OSZPR01MB8878
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

T24gV2VkLCBOb3YgMTYsIDIwMjIgYXQgMDQ6Mjg6MTFBTSAtMDYwMCwgS2FscmEsIEFzaGlzaCB3
cm90ZToNCj4gT24gMTEvMTUvMjAyMiAxMToxOSBQTSwgSE9SSUdVQ0hJIE5BT1lBKOWggOWPoyDn
m7TkuZ8pIHdyb3RlOg0KPiA+IE9uIFR1ZSwgTm92IDE1LCAyMDIyIGF0IDA0OjE0OjQyUE0gKzAx
MDAsIFZsYXN0aW1pbCBCYWJrYSB3cm90ZToNCj4gPiA+IENjJ2luZyBtZW1vcnkgZmFpbHVyZSBm
b2xrcywgdGhlIGJlaW5uaW5nIG9mIHRoaXMgc3VidGhyZWFkIGlzIGhlcmU6DQo+ID4gPiANCj4g
PiA+IGh0dHBzOi8vbmFtMTEuc2FmZWxpbmtzLnByb3RlY3Rpb24ub3V0bG9vay5jb20vP3VybD1o
dHRwcyUzQSUyRiUyRmxvcmUua2VybmVsLm9yZyUyRmFsbCUyRjNhNTE4NDBmNmE4MGM4N2IzOTYz
MmRjNzI4ZGJkOWI1ZGQ0NDRjZDcuMTY1NTc2MTYyNy5naXQuYXNoaXNoLmthbHJhJTQwYW1kLmNv
bSUyRiZhbXA7ZGF0YT0wNSU3QzAxJTdDYXNoaXNoLmthbHJhJTQwYW1kLmNvbSU3QzdiMmQzOWQ2
ZTI1MDRhOGY5MjM2MDhkYWM3OTIyMjRiJTdDM2RkODk2MWZlNDg4NGU2MDhlMTFhODJkOTk0ZTE4
M2QlN0MwJTdDMCU3QzYzODA0MTcyNzg3OTEyNTE3NiU3Q1Vua25vd24lN0NUV0ZwYkdac2IzZDhl
eUpXSWpvaU1DNHdMakF3TURBaUxDSlFJam9pVjJsdU16SWlMQ0pCVGlJNklrMWhhV3dpTENKWFZD
STZNbjAlM0QlN0MzMDAwJTdDJTdDJTdDJmFtcDtzZGF0YT1LQkpMS2hQUVAyM3ZtdlklMkZObmJq
WnM4d1RKcyUyRnJGJTJCaVU1NFNkYzRMZHg0JTNEJmFtcDtyZXNlcnZlZD0wDQo+ID4gPiANCj4g
PiA+IE9uIDExLzE1LzIyIDAwOjM2LCBLYWxyYSwgQXNoaXNoIHdyb3RlOg0KPiA+ID4gPiBIZWxs
byBCb3JpcywNCj4gPiA+ID4gDQo+ID4gPiA+IE9uIDExLzIvMjAyMiA2OjIyIEFNLCBCb3Jpc2xh
diBQZXRrb3Ygd3JvdGU6DQo+ID4gPiA+ID4gT24gTW9uLCBPY3QgMzEsIDIwMjIgYXQgMDQ6NTg6
MzhQTSAtMDUwMCwgS2FscmEsIEFzaGlzaCB3cm90ZToNCj4gPiA+ID4gPiA+ICDCoMKgwqDCoMKg
IGlmIChzbnBfbG9va3VwX3JtcGVudHJ5KHBmbiwgJnJtcF9sZXZlbCkpIHsNCj4gPiA+ID4gPiA+
ICDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqAgZG9fc2lnYnVzKHJlZ3MsIGVycm9yX2NvZGUsIGFk
ZHJlc3MsIFZNX0ZBVUxUX1NJR0JVUyk7DQo+ID4gPiA+ID4gPiAgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgIHJldHVybiBSTVBfUEZfUkVUUlk7DQo+ID4gPiA+ID4gDQo+ID4gPiA+ID4gRG9lcyB0
aGlzIGlzc3VlIHNvbWUgaGFsZndheSB1bmRlcnN0YW5kYWJsZSBlcnJvciBtZXNzYWdlIHdoeSB0
aGUNCj4gPiA+ID4gPiBwcm9jZXNzIGdvdCBraWxsZWQ/DQo+ID4gPiA+ID4gDQo+ID4gPiA+ID4g
PiBXaWxsIGxvb2sgYXQgYWRkaW5nIG91ciBvd24gcmVjb3ZlcnkgZnVuY3Rpb24gZm9yIHRoZSBz
YW1lLCBidXQgdGhhdCB3aWxsDQo+ID4gPiA+ID4gPiBhZ2FpbiBtYXJrIHRoZSBwYWdlcyBhcyBw
b2lzb25lZCwgcmlnaHQgPw0KPiA+ID4gPiA+IA0KPiA+ID4gPiA+IFdlbGwsIG5vdCBwb2lzb25l
ZCBidXQgUEdfb2ZmbGltaXRzIG9yIHdoYXRldmVyIHRoZSBtbSBmb2xrcyBhZ3JlZSB1cG9uLg0K
PiA+ID4gPiA+IFNlbWFudGljYWxseSwgaXQnbGwgYmUgaGFuZGxlZCB0aGUgc2FtZSB3YXksIG9m
Yy4NCj4gPiA+ID4gDQo+ID4gPiA+IEFkZGVkIGEgbmV3IFBHX29mZmxpbWl0cyBmbGFnIGFuZCBh
IHNpbXBsZSBjb3JyZXNwb25kaW5nIGhhbmRsZXIgZm9yIGl0Lg0KPiA+ID4gDQo+ID4gPiBPbmUg
dGhpbmcgaXMsIHRoZXJlJ3Mgbm90IGVub3VnaCBwYWdlIGZsYWdzIHRvIGJlIGFkZGluZyBtb3Jl
IChleGNlcHQNCj4gPiA+IGFsaWFzZXMgZm9yIGV4aXN0aW5nKSBmb3IgY2FzZXMgdGhhdCBjYW4g
YXZvaWQgaXQsIGJ1dCBhcyBCb3JpcyBzYXlzLCBpZg0KPiA+ID4gdXNpbmcgYWxpYXMgdG8gUEdf
aHdwb2lzb24gaXQgZGVwZW5kcyB3aGF0IHdpbGwgYmVjb21lIGNvbmZ1c2VkIHdpdGggdGhlDQo+
ID4gPiBhY3R1YWwgaHdwb2lzb24uDQo+ID4gDQo+ID4gSSBhZ3JlZSB3aXRoIHRoaXMuIEp1c3Qg
ZGVmaW5pbmcgUEdfb2ZmbGltaXRzIGFzIGFuIGFsaWFzIG9mIFBHX2h3cG9pc29uDQo+ID4gY291
bGQgYnJlYWsgY3VycmVudCBod3BvaXNvbiB3b3JrbG9hZC4gIFNvIGlmIHlvdSBmaW5hbGx5IGRl
Y2lkZSB0byBnbw0KPiA+IGZvcndhcmQgaW4gdGhpcyBkaXJlY3Rpb24sIHlvdSBtYXkgYXMgd2Vs
bCBoYXZlIHNvbWUgaW5kaWNhdG9yIHRvDQo+ID4gZGlzdGluZ3Vpc2ggdGhlIG5ldyBraW5kIG9m
IGxlYWtlZCBwYWdlcyBmcm9tIGh3cG9pc29uZWQgcGFnZXMuDQo+ID4gDQo+ID4gSSBkb24ndCBy
ZW1lbWJlciBleGFjdCB0aHJlYWQsIGJ1dCBJJ3ZlIHJlYWQgc29tZW9uZSB3cml0aW5nIGFib3V0
IHNpbWlsYXINCj4gPiBraW5kIG9mIHN1Z2dlc3Rpb24gb2YgdXNpbmcgbWVtb3J5X2ZhaWx1cmUo
KSB0byBtYWtlIHBhZ2VzIGluYWNjZXNzaWJsZSBpbg0KPiA+IG5vbi1tZW1vcnkgZXJyb3IgdXNl
Y2FzZS4gIEkgZmVlbCB0aGF0IGl0IGNvdWxkIGJlIHBvc3NpYmxlIHRvIGdlbmVyYWxpemUNCj4g
PiBtZW1vcnlfZmFpbHVyZSgpIGFzIGdlbmVyYWwtcHVycG9zZSBwYWdlIG9mZmxpbmluZyAoYnkg
cmVuYW1pbmcgaXQgd2l0aA0KPiANCj4gQnV0LCBkb2Vzbid0IG1lbW9yeV9mYWlsdXJlKCkgYWxz
byBtYXJrIHRoZSBwYWdlcyBhcyBQR19od3BvaXNvbiwgYW5kIHRoZW4NCj4gdXNpbmcgaXQgZm9y
IHRoZXNlIGxlYWtlZCBwYWdlcyB3aWxsIGFnYWluIGNhdXNlIGNvbmZ1c2lvbiB3aXRoIGFjdHVh
bA0KPiBod3BvaXNvbiA/DQoNClllcywgc28gd2UgbWlnaHQgbmVlZCBtb2RpZmljYXRpb24gb2Yg
bWVtb3J5X2ZhaWx1cmUgY29kZSBmb3IgdGhpcyBhcHByb2FjaA0KbGlrZSByZW5hbWluZyBQR19o
d3BvaXNvbiB0byBtb3JlIGdlbmVyaWMgb25lIChhbHRob3VnaCBzb21lIHBvc3NpYmxlIG5hbWVz
DQpsaWtlIFBhZ2VPZmZsaW5lIGFuZCBQYWdlSXNvbGF0ZWQgYXJlIGFscmVhZHkgdXNlZCkgYW5k
L29yIHNvbWVob3cgc2hvd2luZw0KIndoaWNoIGtpbmQgb2YgbGVha2VkIHBhZ2VzIiBpbmZvLg0K
DQpUaGFua3MsDQpOYW95YSBIb3JpZ3VjaGk=
