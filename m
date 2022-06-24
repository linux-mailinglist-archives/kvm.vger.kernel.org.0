Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 84303559ECF
	for <lists+kvm@lfdr.de>; Fri, 24 Jun 2022 18:46:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230227AbiFXQoZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 24 Jun 2022 12:44:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40738 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229478AbiFXQoS (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 24 Jun 2022 12:44:18 -0400
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2088.outbound.protection.outlook.com [40.107.220.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B3A4745078;
        Fri, 24 Jun 2022 09:44:16 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=HVcdPPX7HIPtC/bIzBbMAC1QQuhendhOeoINyFczGPUiUGWCRIIkIExSPzYdSZkr33VDcCr1f4MkIy7hjt2eGRcvvT5ZK41WZDobuvBkBE6QaRdI+ur96CRYY4OL+ZITTtmO37MuPJS0/9TfIIfNlgEn7DAznIArBdDSeO56iIoPm6GB6OwbEDeE05HUyHMzkmtUk5/8de4GdSFNkZUqpMnW1bxcRvjNMt9Ufc+pUmJttedB9khWTlqek8+n0dlztuLB0SXgUEKfFC2E82dXxFLzClQGgUUpTnTG3j50hkjv5pcuJ4jwdgTDFM5AVHc8+NFM8A5xWhU4Cg0HpTjt+w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=qtXuFOvEBRmPnRUhlHqFFQDM0ydTE1DbLyYgQOU8s9Q=;
 b=Gnn/mSZiG0SFAH420yYrT4NL6cd4yPUOEb4TM+3fCkB/eqzTiW9hN/Rn5gpQQ4WRlHP3/yvikP9aCSxScT0U2zPRbIlaRX1pubfMmTGF8JMZzmcTDAGCTfPvfyKXTv3qkDi04w2I15WtYQtkblDFLPSEEob+T6APiZnonDR9m0RSBxPbHleOt9XvsbTULeYClR0dDyt3GRBtgMyaRNAFZTw8jwerGaQTUGMMXqfmsuhDUFKsIg56z4tA2S3DYGH/oe/j4y8ig2rXtvZTRbyCsi3YOxUoxOaOuPT41CKrSBKUMPsGaPtxWMXxlT16N6cn3SpAKudStlSUJ/6f3aykdQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qtXuFOvEBRmPnRUhlHqFFQDM0ydTE1DbLyYgQOU8s9Q=;
 b=BLBnN0Nzl9vdjqeZ/brCeUdNfbFbHLZMk4IIEHxk5Z6ujC0/CsDAsutrgj33YLOoGcAmPc7Lb+mK++nQoH/K19ydC7tFT2wUZfei7b+iwBcg6XtATz1M6/sYUAFEOu0xZATptS+c0wwRfLMsUYZ7DZyRJtVdiPAE1OoAkCCL9wY=
Received: from SN6PR12MB2767.namprd12.prod.outlook.com (2603:10b6:805:75::23)
 by DM6PR12MB3338.namprd12.prod.outlook.com (2603:10b6:5:11f::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5373.15; Fri, 24 Jun
 2022 16:44:14 +0000
Received: from SN6PR12MB2767.namprd12.prod.outlook.com
 ([fe80::8953:6baa:97bb:a15d]) by SN6PR12MB2767.namprd12.prod.outlook.com
 ([fe80::8953:6baa:97bb:a15d%7]) with mapi id 15.20.5373.015; Fri, 24 Jun 2022
 16:44:14 +0000
From:   "Kalra, Ashish" <Ashish.Kalra@amd.com>
To:     Peter Gonda <pgonda@google.com>
CC:     the arch/x86 maintainers <x86@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        kvm list <kvm@vger.kernel.org>,
        "linux-coco@lists.linux.dev" <linux-coco@lists.linux.dev>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
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
        Sergio Lopez <slp@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>,
        David Rientjes <rientjes@google.com>,
        Dov Murik <dovmurik@linux.ibm.com>,
        Tobin Feldman-Fitzthum <tobin@ibm.com>,
        Borislav Petkov <bp@alien8.de>,
        "Roth, Michael" <Michael.Roth@amd.com>,
        Vlastimil Babka <vbabka@suse.cz>,
        "Kirill A . Shutemov" <kirill@shutemov.name>,
        Andi Kleen <ak@linux.intel.com>,
        Tony Luck <tony.luck@intel.com>, Marc Orr <marcorr@google.com>,
        Sathyanarayanan Kuppuswamy 
        <sathyanarayanan.kuppuswamy@linux.intel.com>,
        Alper Gun <alpergun@google.com>,
        "Dr. David Alan Gilbert" <dgilbert@redhat.com>,
        "jarkko@kernel.org" <jarkko@kernel.org>
Subject: RE: [PATCH Part2 v6 47/49] *fix for stale per-cpu pointer due to
 cond_resched during ghcb mapping
Thread-Topic: [PATCH Part2 v6 47/49] *fix for stale per-cpu pointer due to
 cond_resched during ghcb mapping
Thread-Index: AQHYh+iH+PG++B4EZ0iZwp1WHU+AG61ewa9w
Date:   Fri, 24 Jun 2022 16:44:14 +0000
Message-ID: <SN6PR12MB27675A06ABFCAB1C999264D98EB49@SN6PR12MB2767.namprd12.prod.outlook.com>
References: <cover.1655761627.git.ashish.kalra@amd.com>
 <1dbc14735bbc336c171ef8fefd4aef39ddf95816.1655761627.git.ashish.kalra@amd.com>
 <CAMkAt6o7jjZ9baQfTUO-r8+u0doJVqPm=fz88nQwuxh6qpBS_Q@mail.gmail.com>
In-Reply-To: <CAMkAt6o7jjZ9baQfTUO-r8+u0doJVqPm=fz88nQwuxh6qpBS_Q@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: MSIP_Label_4342314e-0df4-4b58-84bf-38bed6170a0f_Enabled=true;
 MSIP_Label_4342314e-0df4-4b58-84bf-38bed6170a0f_SetDate=2022-06-24T16:37:54Z;
 MSIP_Label_4342314e-0df4-4b58-84bf-38bed6170a0f_Method=Standard;
 MSIP_Label_4342314e-0df4-4b58-84bf-38bed6170a0f_Name=General;
 MSIP_Label_4342314e-0df4-4b58-84bf-38bed6170a0f_SiteId=3dd8961f-e488-4e60-8e11-a82d994e183d;
 MSIP_Label_4342314e-0df4-4b58-84bf-38bed6170a0f_ActionId=564aeb91-b709-4f47-8c9f-da4f95f53ef1;
 MSIP_Label_4342314e-0df4-4b58-84bf-38bed6170a0f_ContentBits=1
msip_label_4342314e-0df4-4b58-84bf-38bed6170a0f_enabled: true
msip_label_4342314e-0df4-4b58-84bf-38bed6170a0f_setdate: 2022-06-24T16:44:12Z
msip_label_4342314e-0df4-4b58-84bf-38bed6170a0f_method: Standard
msip_label_4342314e-0df4-4b58-84bf-38bed6170a0f_name: General
msip_label_4342314e-0df4-4b58-84bf-38bed6170a0f_siteid: 3dd8961f-e488-4e60-8e11-a82d994e183d
msip_label_4342314e-0df4-4b58-84bf-38bed6170a0f_actionid: 0a2378d2-1477-42ba-9e8f-a4f331dfb7f6
msip_label_4342314e-0df4-4b58-84bf-38bed6170a0f_contentbits: 0
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: e5bdc423-6e49-4092-0ad5-08da5600c5e3
x-ms-traffictypediagnostic: DM6PR12MB3338:EE_
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: Qp8OuVJupCa+xNQOGhdTip87ux1iutFV6u8A1PUUHXSFtb9tql84Tz1jOhuDbNvlYn2Ul/DnaXvLCx9T8am6ng4sT+nZuE98XFAMYLFKChZnX08385y/p0t+aH7JZ8zikBtKVU4gOu37bBDejvnSY5xO0d0edJ+iFnUxfIvLeRSNOQNUvMf4VmIbbFHnq0/immqDawaukzp5sQJgRWBYMlfQ7pPReQHeLc4M3BgnaPjVpdfIyybEwmRklIxyE238t6WmIGCBdY0M9LiSCBsl1oTL+NPMmSv12Bt2fHsJeI9ee5CxgoZ67FlgKYAjMQVKpRMiBe0WUBMBMW8iZv0h2CJ80HmT0VL+72f10mVAKmV+MWR04OaOvR6WcTSrslqaVS6Jfts0akJKjXHjUFKOtmZ3IUQAtCbxs4tNVSNCNSBU4q1yA5XfSCtc1rlpa/ttNmbigl3eWSn6plc9/gwu5/p3IxoXhggdNZVmg+Fu0jpcPx9l+x9n9itc8e82oGYEC3pp8+iZk9jw6lWluQ5spfAjuHn6lhfW1q5Wf6VkPbEZDtOH66YqKWNwWys/PX0nmMfhO3D65ETFRrQKNP8wbqBPS55kmx7al5IplcFqNyi8RXHTRRaxmxi5OQ4DXzkWLCxujdEbfHbA9EwNrjJTIowUxgBT0WzD2CbWVAnqjdsO43q1VPpA/2eT6w+HIKuHJBcMW9xFiEePxQlipEFAZdmemDGFx7XlSZn4tWrf8dsj/YtQSfmm41pEN6FfEJGzfuyZfilmgMS4FIbrYMe+lmG/sGrZUixDXFDZr85x+Zw=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR12MB2767.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(376002)(136003)(396003)(346002)(39860400002)(366004)(52536014)(2906002)(4326008)(55016003)(76116006)(66556008)(33656002)(66446008)(478600001)(8936002)(64756008)(8676002)(7416002)(66946007)(41300700001)(86362001)(66476007)(9686003)(71200400001)(122000001)(5660300002)(7406005)(38100700002)(26005)(54906003)(6916009)(83380400001)(6506007)(7696005)(316002)(38070700005)(186003);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?T3lhMkgyS0NKbWRTOHQ3OWF0Vnc5MDY5TWN3c0RHaE9IaHEwZXNzbXZzOHFu?=
 =?utf-8?B?eWZMR2d3RDJIb1hqdDBKeUhQcEJud0xZN2lPQVBmNmFJL3AvYmJLdlBaQVRL?=
 =?utf-8?B?N3VwZ3FjYnYwb1VRbC9nNFdNaXMyYktXYmVPaWpZMk9UU2FkM1BTdThjcmNW?=
 =?utf-8?B?N0tteTBuYStOODNHT2JaZmI5MENab1hJUmxscmk4aVZTUHA1bzNHQkJ5czBR?=
 =?utf-8?B?Wkovbk9NWEZwRUZneG4xMTZ1Q3Z1Wk12aklyM2dKRkRQYVZaeENsRGlqU25B?=
 =?utf-8?B?YmE3eWdPMVR5RFlSditMN2o4ZUg0NDByeS9ESHM3V1pkVWxPeUltVm9QT2dZ?=
 =?utf-8?B?dU1kTEZ2Vkp6SE13RmU2cHlUVUxsT1RYN3JNbXB3Qjl3WFA4ejBiQmJaWGVF?=
 =?utf-8?B?aUJ3RlY5aDVJZE1NWjNydnVuWnd1VDBsRDRaTHZ0cUVvUTlDQ2wxNitCKzZT?=
 =?utf-8?B?TmFBUHdncHhITmlIb2ovcVNTU3RCSStDVkNPZ04zU2xSc3c3cFRyKytLRGFx?=
 =?utf-8?B?clB3em5EckxoS09EQXNqTzhLdzRqQlRYRjAwZ2c1R2NHTmcrWHhyYXFmUWxH?=
 =?utf-8?B?RUUvT0ltUnV4SVh4TldoMmRNRE1vTGdmUGM5UG13RVlhYUErNi9jU2xndGxh?=
 =?utf-8?B?bHFxb3lvL2JHSHJpWGx1ZFB5OWRITjNtZU1hV0VpSVBtZU1WYjdvaDJuUkhB?=
 =?utf-8?B?ak9oOVRlaURKMWNmOTQxWmt4Zng2amdSNkdpS3VOQUpNSHBHUkJUakhEVjNr?=
 =?utf-8?B?TGg4ZHh5cDVXNHRYMkdzQjFuRDRRTi9wV0h4S0tXM3NRV0g0K2tCY2MrNkRK?=
 =?utf-8?B?V3NBbzU2RkVUVjBBY0duUXR2ZHI1OVJ6eU9EUVRaSzBlUnFYbkpWdmhJT2NO?=
 =?utf-8?B?UzBQdlhCNGdqL2RUNVM2dldOVklQUVluckZUeHNWaVlWL3I5aVlCdXhvZ0Nj?=
 =?utf-8?B?ak9pT0UzeU5RNFFDRk1KKzhEbi9jTTM1Zk9PKzZzNWVDeVFReCt6eGpXQkxE?=
 =?utf-8?B?anhwYmlyS2JqQmtvcDE1eGs2dmdCbmdKaXlxb0lrWDRjZXZ3RlZnYk42ZDFw?=
 =?utf-8?B?Qk9HRzE4cXQxQ3ZVNkx0ZWlBMko5SFdCamMrQmFRMTI5eXdkSGNzNzZsRlZr?=
 =?utf-8?B?U2hWQVRvbmR1aDROYnpjNXZ2TmxuTEF3Q0tYMFpVK0NHVHZmY2o0Q3QrYjRZ?=
 =?utf-8?B?SStES3V1ODZaWkV2S204cVdBRWFvajNYSXdJZ3h0M3hIQTdTOWxqbk9ZcHZj?=
 =?utf-8?B?M3JLVlVpZHVBWDgyVEVrdVVRMFZoK2lEaG9tS2VkZjYrSFB1Mk9IbEVuN2Jh?=
 =?utf-8?B?dUwxRklkNWQyaEtHMURzWTlQUW9rYU5wUFNFeFdPZUxwTFlldVVacE53RXJx?=
 =?utf-8?B?Q3NsRkdMNkpvYkkvVXBrQnVXWm1OWW55Q1BweEtQQXFzTG5CNXB6UzFYdHov?=
 =?utf-8?B?YnlqbjZhMVRTcjNlRGZKKzRxaXZEV0NCT0llbEsrYUpvK1Z6bURzWFMxRHhX?=
 =?utf-8?B?UW90eWpKcncybk1tQ0dWRXcvZFZMNWJ5Y3FyazMreXdhNk9uT3A3V2oxQ1hi?=
 =?utf-8?B?RERBVWsvOVZkcWg5S2FXckhPOFlSUEs5eTByVStOZ2tRN2VLZnppbzE1OVpL?=
 =?utf-8?B?MlFNd1ZjWnVoMG9Da0crK3pjSlVBaXE0SXpmNC9saDRkKzVyQ0JabXplUmlO?=
 =?utf-8?B?cnQrY2FvT2x6WGFRKy84R05KK2lpMXJuOVZrcmNHakdyNGxPUjBhZlVJd21z?=
 =?utf-8?B?S1RSY0plTERuWDFDWVlWREhrNGVKR3RxQ2xkSXliVDYva0hFMFVMcCtYNGhD?=
 =?utf-8?B?Q3Z0STVIYnpSQ1BzNWNFWFUrK0dEc2MweUlFSVdXdWp2T2hrNkpKTEpzQ2hT?=
 =?utf-8?B?bllObXVyTDN4cXlibnZNRGtmNnpWRk5nTmNQc3gvaVNIZGJYb0hSRWRTVkp6?=
 =?utf-8?B?aGtqK2traVJVTGs2cEhSYnEvWis5MEVDenk4S0JCRjhaazZENkJSUFdoaFhS?=
 =?utf-8?B?cnFrdzBzYUJXR2FEQ1I3bUFFbmR4d1oxMzdJdnByc0poRkpiT2ltWTFEd2lJ?=
 =?utf-8?B?R1BlcDAyRmN5N1pvOUpzeHlUS2xndEd1cnBMV0pQMmpmUFY0NGZ6WExDcGhy?=
 =?utf-8?Q?lYT8=3D?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SN6PR12MB2767.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e5bdc423-6e49-4092-0ad5-08da5600c5e3
X-MS-Exchange-CrossTenant-originalarrivaltime: 24 Jun 2022 16:44:14.6169
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: xRb34E42ANjyfr2LhmbDDQbacmpEWLEEGP1oavWpbflqDaCNbSGbZUZW11Ylbm3IsP2wDem3ga7XAb+AlxoY8g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB3338
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

W0FNRCBPZmZpY2lhbCBVc2UgT25seSAtIEdlbmVyYWxdDQoNCkhlbGxvIFBldGVyLA0KPj4NCj4+
IEZyb206IE1pY2hhZWwgUm90aCA8bWljaGFlbC5yb3RoQGFtZC5jb20+DQo+Pg0KPj4gU2lnbmVk
LW9mZi1ieTogTWljaGFlbCBSb3RoIDxtaWNoYWVsLnJvdGhAYW1kLmNvbT4NCg0KPkNhbiB5b3Ug
YWRkIGEgY29tbWl0IGRlc2NyaXB0aW9uIGhlcmU/IElzIHRoaXMgYSBmaXggZm9yIGV4aXN0aW5n
IFNFVi1FUyBzdXBwb3J0IG9yIHNob3VsZCB0aGlzIGJlIGluY29ycG9yYXRlZCBpbnRvIGEgcGF0
Y2ggaW4gdGhpcyBzZXJpZXMgd2hpY2ggYWRkcyB0aGlzIGlzc3VlPw0KDQpUaGlzIGFjdHVhbGx5
IGZpeGVzIGlzc3VlcyBjYXVzZWQgZHVlIHRvIHByZWVtcHRpb24gaGFwcGVuaW5nIGluIHN2bV9w
cmVwYXJlX3N3aXRjaF90b19ndWVzdCgpIHdoZW4ga3ZtX3ZjcHVfbWFwKCkgaXMgY2FsbGVkIHRv
IG1hcCBpbiB0aGUgR0hDQiBiZWZvcmUNCmVudGVyaW5nIHRoZSBndWVzdC4gDQoNClRoaXMgaXMg
YSB0ZW1wb3JhcnkgZml4IGFuZCB3aGF0IHdlIG5lZWQgdG8gZG8gaXMgdG8gcHJldmVudCBnZXR0
aW5nIHByZWVtcHRlZCBhZnRlciB2Y3B1X2VudGVyX2d1ZXN0KCkgaGFzIGRpc2FibGVkIHByZWVt
cHRpb24sIGhhdmUgc29tZSBpZGVhcyBhYm91dA0KdXNpbmcgZ2ZuX3RvX3Bmbl9jYWNoZSgpIGlu
ZnJhc3RydWN0dXJlIHRvIHJlLXVzZSB0aGUgYWxyZWFkeSBtYXBwZWQgR0hDQiBhdCBndWVzdCBl
eGl0LCBzbyB0aGF0IHdlIGNhbiBhdm9pZCBjYWxsaW5nIGt2bV92Y3B1X21hcCgpIHRvIHJlLW1h
cCB0aGUgDQpHSENCLg0KDQpUaGFua3MsDQpBc2hpc2gNCg0KPiAtLS0NCj4gIGFyY2gveDg2L2t2
bS9zdm0vc3ZtLmMgfCA2ICsrKysrLQ0KPiAgMSBmaWxlIGNoYW5nZWQsIDUgaW5zZXJ0aW9ucygr
KSwgMSBkZWxldGlvbigtKQ0KPg0KPiBkaWZmIC0tZ2l0IGEvYXJjaC94ODYva3ZtL3N2bS9zdm0u
YyBiL2FyY2gveDg2L2t2bS9zdm0vc3ZtLmMgaW5kZXggDQo+IGZjZWQ2ZWE0MjNhZC4uZjc4ZTNi
MWJkZTBlIDEwMDY0NA0KPiAtLS0gYS9hcmNoL3g4Ni9rdm0vc3ZtL3N2bS5jDQo+ICsrKyBiL2Fy
Y2gveDg2L2t2bS9zdm0vc3ZtLmMNCj4gQEAgLTEzNTIsNyArMTM1Miw3IEBAIHN0YXRpYyB2b2lk
IHN2bV92Y3B1X2ZyZWUoc3RydWN0IGt2bV92Y3B1ICp2Y3B1KSAgDQo+IHN0YXRpYyB2b2lkIHN2
bV9wcmVwYXJlX3N3aXRjaF90b19ndWVzdChzdHJ1Y3Qga3ZtX3ZjcHUgKnZjcHUpICB7DQo+ICAg
ICAgICAgc3RydWN0IHZjcHVfc3ZtICpzdm0gPSB0b19zdm0odmNwdSk7DQo+IC0gICAgICAgc3Ry
dWN0IHN2bV9jcHVfZGF0YSAqc2QgPSBwZXJfY3B1KHN2bV9kYXRhLCB2Y3B1LT5jcHUpOw0KPiAr
ICAgICAgIHN0cnVjdCBzdm1fY3B1X2RhdGEgKnNkOw0KPg0KPiAgICAgICAgIGlmIChzZXZfZXNf
Z3Vlc3QodmNwdS0+a3ZtKSkNCj4gICAgICAgICAgICAgICAgIHNldl9lc191bm1hcF9naGNiKHN2
bSk7IEBAIC0xMzYwLDYgKzEzNjAsMTAgQEAgc3RhdGljIA0KPiB2b2lkIHN2bV9wcmVwYXJlX3N3
aXRjaF90b19ndWVzdChzdHJ1Y3Qga3ZtX3ZjcHUgKnZjcHUpDQo+ICAgICAgICAgaWYgKHN2bS0+
Z3Vlc3Rfc3RhdGVfbG9hZGVkKQ0KPiAgICAgICAgICAgICAgICAgcmV0dXJuOw0KPg0KPiArICAg
ICAgIC8qIHNldl9lc191bm1hcF9naGNiKCkgY2FuIHJlc2NoZWQsIHNvIGdyYWIgcGVyLWNwdSBw
b2ludGVyIGFmdGVyd2FyZC4gKi8NCj4gKyAgICAgICBiYXJyaWVyKCk7DQo+ICsgICAgICAgc2Qg
PSBwZXJfY3B1KHN2bV9kYXRhLCB2Y3B1LT5jcHUpOw0KPiArDQo+ICAgICAgICAgLyoNCj4gICAg
ICAgICAgKiBTYXZlIGFkZGl0aW9uYWwgaG9zdCBzdGF0ZSB0aGF0IHdpbGwgYmUgcmVzdG9yZWQg
b24gVk1FWElUIChzZXYtZXMpDQo+ICAgICAgICAgICogb3Igc3Vic2VxdWVudCB2bWxvYWQgb2Yg
aG9zdCBzYXZlIGFyZWEuDQo+IC0tDQo+IDIuMjUuMQ0KPg0K
