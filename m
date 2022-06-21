Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 31635553920
	for <lists+kvm@lfdr.de>; Tue, 21 Jun 2022 19:45:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235198AbiFURps (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 21 Jun 2022 13:45:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41898 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232708AbiFURpr (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 21 Jun 2022 13:45:47 -0400
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2067.outbound.protection.outlook.com [40.107.93.67])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5379A1C910;
        Tue, 21 Jun 2022 10:45:46 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=mjgYMbv7VVGGue1qumK/PgoDrZ5lXtgEy+j8EiaszLel1uTjDZWxOSV8gnd/LfuP8IsEmVYr6ZAJwbzeKts4a7hCn5ZekJHyOtCtz3C8Z9bpbkZ3jsHjvSrHjKVuU/DGdXSsqS7xXKAipAyZ0mdKcl0/moBAg4quLiXtZbiYACx7YghWvMJ7sUmN+7A3rjCjWLyg5ZKlW2B2UniU9H5fv8KDpPqCqFse00V4D7yR1EJUBh0RnbPrIJ/05QuyRcNRjRQqCGOB4561TlTfQwJuD6WQCiQty9a70ufnCkrAxxuJZg577+yAtwCivdFUHjeMvsBY8ROjLbf04TTrGMzvuA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=YK0A+VVL44O1Xkem7wSIu5BL3sUByvr9powRjlwkd3U=;
 b=DsAlNuDlk/UQCxMCZyhue6CcbXZIJ2TdDHWKQ4MtHw13Xjz19yWxUMdSUi3i63s9tPAsc2rlbsxVCA3b1qfrs5qclAumIamV0WWn8q2PYdl0rzi9uQuFyfFdomeXQJfBv4lExDw3YzJHPNXQ981+/gEmn1zvizbtySMSgSYKxYO3Aelxg+duEAihdNVJII0LbG7fovnQyeEHpmGiB6PByaIeicgQyRfgKF5DnvOuT+YTcF70oJ3h7PluJrcFE/s/3A2xX1lscRz6eEZtYtXt6BolPHv5NgjF9hqD4gJ7EQshQMxS46aADk/sA/673ArxmpVT8FTcmc7BQL3TXUzX7Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=YK0A+VVL44O1Xkem7wSIu5BL3sUByvr9powRjlwkd3U=;
 b=GT4QhHKNvKvRYOkWnj7CyYqCHw+Fy/3U3PHqkPGXtAEATaitEztTYiPvTliy/0PqIBoRXIRncfXC9GJWJ8OcEcmyAeET0cjUlq8ueB7fcmswX9D0iqb6okSgJVqA+VpAp8DKXXJx+PvC/yVrxoRvNrRaHrGYbJuWvuft5WEtx6U=
Received: from SN6PR12MB2767.namprd12.prod.outlook.com (2603:10b6:805:75::23)
 by BL3PR12MB6425.namprd12.prod.outlook.com (2603:10b6:208:3b4::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5353.15; Tue, 21 Jun
 2022 17:45:43 +0000
Received: from SN6PR12MB2767.namprd12.prod.outlook.com
 ([fe80::810a:e508:3491:1b93]) by SN6PR12MB2767.namprd12.prod.outlook.com
 ([fe80::810a:e508:3491:1b93%2]) with mapi id 15.20.5353.022; Tue, 21 Jun 2022
 17:45:43 +0000
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
        Wanpeng Li <wanpengli@tencent.com>,
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
Subject: RE: [PATCH Part2 v6 02/49] iommu/amd: Introduce function to check
 SEV-SNP support
Thread-Topic: [PATCH Part2 v6 02/49] iommu/amd: Introduce function to check
 SEV-SNP support
Thread-Index: AQHYhYN//Jq12JdNiEyvNHxMVTEAQ61aILsg
Date:   Tue, 21 Jun 2022 17:45:42 +0000
Message-ID: <SN6PR12MB2767A51D40E7F53395770DE58EB39@SN6PR12MB2767.namprd12.prod.outlook.com>
References: <cover.1655761627.git.ashish.kalra@amd.com>
 <12df64394b1788156c8a3c2ee8dfd62b51ab3a81.1655761627.git.ashish.kalra@amd.com>
 <CAMkAt6r+WSYXLZj-Bs5jpo4CR3+H5cpND0GHjsmgPacBK1GH_Q@mail.gmail.com>
In-Reply-To: <CAMkAt6r+WSYXLZj-Bs5jpo4CR3+H5cpND0GHjsmgPacBK1GH_Q@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: MSIP_Label_4342314e-0df4-4b58-84bf-38bed6170a0f_Enabled=true;
 MSIP_Label_4342314e-0df4-4b58-84bf-38bed6170a0f_SetDate=2022-06-21T17:39:38Z;
 MSIP_Label_4342314e-0df4-4b58-84bf-38bed6170a0f_Method=Standard;
 MSIP_Label_4342314e-0df4-4b58-84bf-38bed6170a0f_Name=General;
 MSIP_Label_4342314e-0df4-4b58-84bf-38bed6170a0f_SiteId=3dd8961f-e488-4e60-8e11-a82d994e183d;
 MSIP_Label_4342314e-0df4-4b58-84bf-38bed6170a0f_ActionId=a95cdc77-021b-434d-b0c3-f69e4129156e;
 MSIP_Label_4342314e-0df4-4b58-84bf-38bed6170a0f_ContentBits=1
msip_label_4342314e-0df4-4b58-84bf-38bed6170a0f_enabled: true
msip_label_4342314e-0df4-4b58-84bf-38bed6170a0f_setdate: 2022-06-21T17:45:41Z
msip_label_4342314e-0df4-4b58-84bf-38bed6170a0f_method: Standard
msip_label_4342314e-0df4-4b58-84bf-38bed6170a0f_name: General
msip_label_4342314e-0df4-4b58-84bf-38bed6170a0f_siteid: 3dd8961f-e488-4e60-8e11-a82d994e183d
msip_label_4342314e-0df4-4b58-84bf-38bed6170a0f_actionid: 19c5b713-b4ee-4674-b269-37c60c567ba9
msip_label_4342314e-0df4-4b58-84bf-38bed6170a0f_contentbits: 0
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 93da1c51-3b72-470f-cf96-08da53addd12
x-ms-traffictypediagnostic: BL3PR12MB6425:EE_
x-microsoft-antispam-prvs: <BL3PR12MB6425556FF7ADD002F8390DF78EB39@BL3PR12MB6425.namprd12.prod.outlook.com>
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: uDcUjpt7QgCVhoX4pJWsADm5y6iVgG9yWTqcO3hLtP3HICfNRxt8ukhjd5F42yKIr7JrQo1AOTwK2vBEt/vB12hsseGzxxt49RjqZ3fS4yMRFvhBhRY+FlJK/zl9gRhuVhrqkRHNb3S0Hl8GLTQnpHm4hGDXCGUp4PV/8t8ZyGPrODvyG7AD++v94v+wYRXP25W4j+QKka0fLAilGnhNI5PAd72ddHiunCVAAan6NR0/k3ibJ9iPUsUjTbfX1S2FZKZ2kUY136R6VUJ/KsBZBEQCMHYd6vVV5UgurFgN5RPG+KT4Ho93qJlK8HJEFb4DT+sbi/NfKBbV6Br42Lw/cX4ro5D0ibllGJZYEkk1aBLkaO5S+svoITvsJtxOpLi4RGDg7fNNALedTgB1DnGUGBU5i8G/8y3mq+r6gsoc7foZpPZGIPObDA/IUPn9N9ygQFc51Z7PqHfKJUePE8Gpxg+TL29yZHQi5GxYMQ0dfPN2n0tUDy6amy1oQy95qa3fdB5ALjI3gUC2sc+621vnEB4GGST4WsfIROiVumaWiNcZ2CtA8MXvQ/7Vuow0vExEZVX1iAOWBEUo7WZeDNN0kcRqHeyA2d7hCCnaTRXHAXP13r1/2eydKrk4BMduFR/eTYpjfCmERosDbuxzoiKUGURLlCoRyF/DBCJ+937oRz01yeAjX6dHcsfslruAAWL1i/+KJTaRjPlJVZzBp4LrGQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR12MB2767.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(346002)(376002)(366004)(396003)(39860400002)(136003)(6506007)(38100700002)(7696005)(66946007)(122000001)(4326008)(316002)(55016003)(8676002)(26005)(478600001)(6916009)(76116006)(9686003)(54906003)(66556008)(41300700001)(38070700005)(7406005)(71200400001)(8936002)(86362001)(2906002)(33656002)(83380400001)(64756008)(66446008)(52536014)(66476007)(186003)(5660300002)(7416002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?MVl5cSt4cGt2Y3VFWjdES3k4UFNqcUJFdmdTQzVFT2JKSHVWL1AxKzdYOThs?=
 =?utf-8?B?SlYxNHdOeld5QnhTQUlsT1lLeW9hN2hxOG5IUVNPREFVNFpmb3hFSGR1Sm04?=
 =?utf-8?B?UEc3bWJrU3QveUhMbit5U0x4TVBBNGx4djRHMVJ4REx5WVpTQ3F3RGxOZlVi?=
 =?utf-8?B?SnhlZzBqbmVnV1F3cXRWdHhvL2x2bG9QeVdlZ1QrTkM0STd3cGw0VlRmWDVC?=
 =?utf-8?B?aWI0dGNkV0IrUWkyZ0lNVXNwVGRXN09ra1JmSW4zQmdVNkRydEVJS3g5ak1a?=
 =?utf-8?B?QjR2V085NnJhdVByS2ZYTUFXYTB0L2lTT2VYRlpzcVI3V2crbXJzL0hicU9U?=
 =?utf-8?B?aHlLcm80R2NHZzZJZkF1Zyt6MFh5UzBZZk9wQ3JZQnhkdGlLNkw3MVRIRklr?=
 =?utf-8?B?KzloRC9ycEl1K0JCVnNOTWJTUTRLZEI1R3pLTDZLdDB3MEZXSjhIeDk3SXoy?=
 =?utf-8?B?ZFQzZXFSVitZK0lxZEl6RnpZN2hjeFNuUmlzQ1BuVUtETDE3VXZNb0FaQnk4?=
 =?utf-8?B?bkFZK2ZlY3Jzb0NKc1Z2M1dZbEk2UnoraDFrdkV4YzZrdG9OTWxESDBMMnhy?=
 =?utf-8?B?OUNZd0ZkTlFlTjN0MXBWbE13RWhyR2NKNTJ4d3NSVERqMEN2VUtFSU16OGZR?=
 =?utf-8?B?c3FKamJ4KzJucTVIcWVlbktsQ3czUUNWSktXTXFXYUxrNVhvTUJUMklsaHdI?=
 =?utf-8?B?U3V4K1JxdWdWcnZLQ0FvcTBSOTVxd21BeUpLb2trZjJER08vcXVJdmtxblNi?=
 =?utf-8?B?cW1jelF5dyt1S2w4Vi9FeGtGN0NBa3VrTHZ3ZmRPYnpVV003a2QzSHZBK3Uw?=
 =?utf-8?B?b2xveTJma0ZqR0dWSHZZb1RMVUlCYmFmV3orK3Z0RUpnSmZRV3ZCT285cE16?=
 =?utf-8?B?Q1krY01LUjNMeGJacGNyN0dPbWxJM1FRWEgveTVYTGJET2xJWmI5STJ1MkNk?=
 =?utf-8?B?SHFHdkpWZHhoUDBoKzFES1YyV3B5RmdCNmN0NW43T0hONHR1eU4zNHJCR081?=
 =?utf-8?B?Z0NjeU5PU0dEQ1RkVDRSdTFQa2p4MEMyUlpXK1BVY3hwYUtzVWQzay9HQ3Z4?=
 =?utf-8?B?K0tCQmJLdUNtSDhCR0FUeUlNQ01WNEkrRFFmcVJyK2EyYkd1b2RBZWNVQnBp?=
 =?utf-8?B?RHVpLys2bXZtRjhqcFhQa1Uyb0ZXSTFPOUlBSUJhWlZQb0lNRGd5QUhUeHA3?=
 =?utf-8?B?NXAybnVPektOMjFDTWYwUmFZMk5laWI2OHU5L0lRWTVzVW1xNWZ6YzJ3R3lp?=
 =?utf-8?B?T01NRkVCT2UxVFA1QXkyOGdyYjFLRjVBVHF4a2psZ1ZOazZhbkwvc1p4bHZR?=
 =?utf-8?B?ODl5emJlNEIvMDJCY1JqRlNvT2ROVGI4QmFDV2pobitYZEI4Vld5by9sVmlP?=
 =?utf-8?B?cklud0ZuT1REOXJwa3J2bEZyb0NqaTV4V0tidUFtYUxSd2JsVXVLNnNnUmxF?=
 =?utf-8?B?WGU5S2VQWU5KV1MzVWtuRHo4Q1BmNTBhT0VtWFZVSjdBL01xQ0pLUlJqcWN5?=
 =?utf-8?B?QXpiSVhEVVNnTHFNcnZrVFMvTFFyaE1Vb00yc1YwUmhwNEhPUTlsby9ndWNr?=
 =?utf-8?B?ZUVjRUxmblNnU04zdGh2Rk9BK0hKalA3QW5QTVZFOEQwSlo2WVdGdWlwYUhT?=
 =?utf-8?B?b3YrMlVUQktMS3JNZExGeXZCc1hwZytZSU5nNzBnWFp2Vkt4azZoZlpsRzEx?=
 =?utf-8?B?OGJvdEJLZ1M1bFZFdThiczVHUDh3clY1TmdHMElER0xrZWhHeWFaRTlCdEdo?=
 =?utf-8?B?eTc4amVDUWR5ZmdvL09WQlFyczNTTEZLM3RLT2FLWWt2cjBoYVVjQUM0cUQy?=
 =?utf-8?B?cWNOKyt5WkhDdWMzVHRvSmlqQ0RIVDZtZEFsRUtqcWh4QmEzNTdRMFJRQ00z?=
 =?utf-8?B?Y1JSekZQVUczVC82U3o4bjE2ZHZ0VzFFZ2dleVBJKzhiOWxiQXBLdjZNeDJj?=
 =?utf-8?B?MUg5ZlBBOHNYUURIN0tOTnZ0V1ZES1ZzUVFCRDBFdDhTMHFiNXQrQ1p6YTRC?=
 =?utf-8?B?dmJlWUxiVzdOc3prc0ROUTZEajRQMzlxNjJGa1duVVpKK1Y1cUNvM3JubXk2?=
 =?utf-8?B?VFhJQUNJcTd2U2xVSnF0MENuQ3RzRFRlSkQ1UUtURWg3NjQvTHljS21xcTd6?=
 =?utf-8?B?algwK2N6c0o1Qy9KeEFtWk4xSnlvRmwxUnp4amN5UmlzQmE1SDNBcGZjSUQ1?=
 =?utf-8?B?N2l3cWFXTVBUcmZxS0tWQURXNHZDSWg2bjdxN1VhVUhrY05CdytVSTQ4TUtn?=
 =?utf-8?B?TXZUUVVQVW1iTUFCTVdpVWxrVW5XVUhUSDFyUUNDSGtXcWozeE5rVTlrbjJP?=
 =?utf-8?Q?tG33BxMWl4pvMoIMf0?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SN6PR12MB2767.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 93da1c51-3b72-470f-cf96-08da53addd12
X-MS-Exchange-CrossTenant-originalarrivaltime: 21 Jun 2022 17:45:42.9166
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: ORA2MsQZq1jYE2ZiYo0cCP0Vuxb+Bi/kgmOr3Ckas80cHGNcrRRS0FplA09UzbFJg/MoinAMjA7NSZaDaiw8fA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL3PR12MB6425
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

W0FNRCBPZmZpY2lhbCBVc2UgT25seSAtIEdlbmVyYWxdDQoNCkhlbGxvIFBldGVyLA0KDQo+PiAr
Ym9vbCBpb21tdV9zZXZfc25wX3N1cHBvcnRlZCh2b2lkKQ0KPj4gK3sNCj4+ICsgICAgICAgc3Ry
dWN0IGFtZF9pb21tdSAqaW9tbXU7DQo+PiArDQo+PiArICAgICAgIC8qDQo+PiArICAgICAgICAq
IFRoZSBTRVYtU05QIHN1cHBvcnQgcmVxdWlyZXMgdGhhdCBJT01NVSBtdXN0IGJlIGVuYWJsZWQs
IGFuZCBpcw0KPj4gKyAgICAgICAgKiBub3QgY29uZmlndXJlZCBpbiB0aGUgcGFzc3Rocm91Z2gg
bW9kZS4NCj4+ICsgICAgICAgICovDQo+PiArICAgICAgIGlmIChub19pb21tdSB8fCBpb21tdV9k
ZWZhdWx0X3Bhc3N0aHJvdWdoKCkpIHsNCj4+ICsgICAgICAgICAgICAgICBwcl9lcnIoIlNFVi1T
TlA6IElPTU1VIGlzIGVpdGhlciBkaXNhYmxlZCBvciANCj4+ICsgY29uZmlndXJlZCBpbiBwYXNz
dGhyb3VnaCBtb2RlLlxuIik7DQoNCj4gTGlrZSBiZWxvdyBjb3VsZCB0aGlzIHNheSBzb21ldGhp
bmcgbGlrZSBzbnAgc3VwcG9ydCBpcyBkaXNhYmxlZCBiZWNhdXNlIG9mIGlvbW11IHNldHRpbmdz
Lg0KDQpIZXJlIHdlIG1heSBuZWVkIHRvIGJlIG1vcmUgcHJlY2lzZSB3aXRoIHRoZSBlcnJvciBp
bmZvcm1hdGlvbiBpbmRpY2F0aW5nIHdoeSBTTlAgaXMgbm90IGVuYWJsZWQuDQpQbGVhc2Ugbm90
ZSB0aGF0IHRoaXMgcGF0Y2ggbWF5IGFjdHVhbGx5IGJlY29tZSBwYXJ0IG9mIHRoZSBJT01NVSAr
IFNOUCBwYXRjaCBzZXJpZXMsIHdoZXJlDQphZGRpdGlvbmFsIGNoZWNrcyBhcmUgZG9uZSwgZm9y
IGV4YW1wbGUsIG5vdCBlbmFibGluZyBTTlAgaWYgSU9NTVUgdjIgcGFnZSB0YWJsZXMgYXJlIGVu
YWJsZWQsDQpzbyBwcmVjaXNlIGVycm9yIGluZm9ybWF0aW9uIHdpbGwgYmUgdXNlZnVsIGhlcmUu
DQoNCj4+ICsgICAgICAgICAgICAgICByZXR1cm4gZmFsc2U7DQo+PiArICAgICAgIH0NCj4+ICsN
Cj4+ICsgICAgICAgLyoNCj4+ICsgICAgICAgICogSXRlcmF0ZSB0aHJvdWdoIGFsbCB0aGUgSU9N
TVVzIGFuZCB2ZXJpZnkgdGhlIFNOUFN1cCBmZWF0dXJlIGlzDQo+PiArICAgICAgICAqIGVuYWJs
ZWQuDQo+PiArICAgICAgICAqLw0KPj4gKyAgICAgICBmb3JfZWFjaF9pb21tdShpb21tdSkgew0K
Pj4gKyAgICAgICAgICAgICAgIGlmICghaW9tbXVfZmVhdHVyZShpb21tdSwgRkVBVFVSRV9TTlAp
KSB7DQo+PiArICAgICAgICAgICAgICAgICAgICAgICBwcl9lcnIoIlNOUFN1cCBpcyBkaXNhYmxl
ZCAoZGV2aWQ6IA0KPj4gKyAlMDJ4OiUwMnguJXgpXG4iLA0KDQo+IFNOUFN1cCBtaWdodCBub3Qg
YmUgb2J2aW91cyB0byByZWFkZXJzLCB3aGF0IGFib3V0ICIgU05QIFN1cHBvcnQgaXMgZGlzYWJs
ZWQgLi4uIi4NCg0KWWVzLCB0aGF0IG1ha2VzIHNlbnNlLg0KDQo+IEFsc28gc2hvdWxkIHRoaXMg
aGF2ZSB0aGUgIlNFVi1TTlA6IiBwcmVmaXggbGlrZSB0aGUgYWJvdmUgbG9nPw0KDQpQcm9iYWJs
eSwgd2Ugd2FudCB0byBiZSBtb3JlIGNvbnNpc3RlbnQgd2l0aCB0aGUgU05QIGd1ZXN0IHBhdGNo
ZXMgYW5kIHJlcGxhY2UNClNFVi1TTlAgd2l0aCBTTlAgZXZlcnl3aGVyZSwgaW5jbHVkaW5nIGZ1
bmN0aW9uIG5hbWVzLCBldGMuDQoNClRoYW5rcywNCkFzaGlzaA0K
