Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2E66F554034
	for <lists+kvm@lfdr.de>; Wed, 22 Jun 2022 03:44:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355755AbiFVBoo (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 21 Jun 2022 21:44:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51458 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230152AbiFVBom (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 21 Jun 2022 21:44:42 -0400
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2056.outbound.protection.outlook.com [40.107.237.56])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 92E0B2FFFF;
        Tue, 21 Jun 2022 18:44:37 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Bam0Z076k9hRrt8/9nskWj0OeWJewTTdokzGYppA6yvQtss+q2gWMH+uYzujlv/u0f5iNtS4NjpTjn7RY404wfoXDqQN6X5Ypk62EJi7w7DTiFd8a58Ds3pFfStgnPtyaHVehMOm5AHqroU0j3B5FZ289uOb2p6lt8RLbIaYIhx6B2vnxQcIgIaAQvtzMX30tx0ko6o78GsQbeTN3i/M2N4AkrFIZblWvZ65a6yqLXplpJh5Jer6Whi2NKQLk1SzQ365CWzddzx7xg0a2A2ruA0/72D7RVPmeMJ9cRqQCdMwyzltZzPYE7yBjUB+AvhKSXb6Tg9pWWG+8NkPOD+VaA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=QvRNvZtMHidqU3pQoiffFbGPXGgO46ZI2meEr7s5phU=;
 b=JqdO2CkfncVoU6q+IIYcLfT7tm3RvXuaEPsZ3A2dXgYDxr74MFLTXR99D57h0pFajnaltaPmQjosXCnqOrzQnCtnYbmJPLFwqSeqY7e5iqAVXg3B6U1A5QQg/9w2nYCr4uEiUDLmgLUHWxKRx5pkwLApZLvOjlW7Za2cNAueV2NtdpDVd+9XmoFFnxh1sBrNMxX9CLRwm8VF/gkGIsebYfEMpmdoETFEZRB3yjNeXjDF12VPXhlxdcpmKPZDCU5wXjGJgS5bZnQVi2xMAnPaZP8fXF6+fguL7V23EGlazXp3sGPUnih5Tuc/zvK8Jd7u2Wk0EvsLN9K+m6H3W84lGQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=QvRNvZtMHidqU3pQoiffFbGPXGgO46ZI2meEr7s5phU=;
 b=QndjA6/Vyq9iPGp4/TGfBY0WwpGr4XEjrgmqLtTb5vLi8B/1bxWU06h171Pw9Rha6bJB66o4jZRLZWNzEEC8AeXFUM1/J3PYN4hAxDGDH/KMoG6twRx57fKwtmEA0VeJAftM33BZrLT2PKr87EDTAs8DOs/1GECqFF+slq/zl4s=
Received: from BYAPR12MB2759.namprd12.prod.outlook.com (2603:10b6:a03:61::32)
 by MW5PR12MB5622.namprd12.prod.outlook.com (2603:10b6:303:198::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5353.15; Wed, 22 Jun
 2022 01:44:34 +0000
Received: from BYAPR12MB2759.namprd12.prod.outlook.com
 ([fe80::a0be:c49b:ef2c:e588]) by BYAPR12MB2759.namprd12.prod.outlook.com
 ([fe80::a0be:c49b:ef2c:e588%5]) with mapi id 15.20.5353.022; Wed, 22 Jun 2022
 01:44:34 +0000
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
Subject: RE: [PATCH Part2 v6 13/49] crypto:ccp: Provide APIs to issue SEV-SNP
 commands
Thread-Topic: [PATCH Part2 v6 13/49] crypto:ccp: Provide APIs to issue SEV-SNP
 commands
Thread-Index: AQHYhbf34Juks83jB0yfjCsoLH1Lj61apf5w
Date:   Wed, 22 Jun 2022 01:44:34 +0000
Message-ID: <BYAPR12MB2759F72D5FB87F1B552BBF4E8EB29@BYAPR12MB2759.namprd12.prod.outlook.com>
References: <cover.1655761627.git.ashish.kalra@amd.com>
 <a63de5e687c530849312099ee02007089b67e92f.1655761627.git.ashish.kalra@amd.com>
 <CAMkAt6qL_p8Fp=ED5hER665GHzQn=nwZQhFg4MwHt7QanS4wVw@mail.gmail.com>
In-Reply-To: <CAMkAt6qL_p8Fp=ED5hER665GHzQn=nwZQhFg4MwHt7QanS4wVw@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: MSIP_Label_d4243a53-6221-4f75-8154-e4b33a5707a1_Enabled=true;
 MSIP_Label_d4243a53-6221-4f75-8154-e4b33a5707a1_SetDate=2022-06-22T01:44:04Z;
 MSIP_Label_d4243a53-6221-4f75-8154-e4b33a5707a1_Method=Privileged;
 MSIP_Label_d4243a53-6221-4f75-8154-e4b33a5707a1_Name=Public-AIP 2.0;
 MSIP_Label_d4243a53-6221-4f75-8154-e4b33a5707a1_SiteId=3dd8961f-e488-4e60-8e11-a82d994e183d;
 MSIP_Label_d4243a53-6221-4f75-8154-e4b33a5707a1_ActionId=4beb408b-2408-41a2-bf3d-69242e1cf6db;
 MSIP_Label_d4243a53-6221-4f75-8154-e4b33a5707a1_ContentBits=1
msip_label_d4243a53-6221-4f75-8154-e4b33a5707a1_enabled: true
msip_label_d4243a53-6221-4f75-8154-e4b33a5707a1_setdate: 2022-06-22T01:44:32Z
msip_label_d4243a53-6221-4f75-8154-e4b33a5707a1_method: Privileged
msip_label_d4243a53-6221-4f75-8154-e4b33a5707a1_name: Public-AIP 2.0
msip_label_d4243a53-6221-4f75-8154-e4b33a5707a1_siteid: 3dd8961f-e488-4e60-8e11-a82d994e183d
msip_label_d4243a53-6221-4f75-8154-e4b33a5707a1_actionid: 045cbbb9-554a-412e-b7bd-06ec210d71ed
msip_label_d4243a53-6221-4f75-8154-e4b33a5707a1_contentbits: 0
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: ecd4abf4-a232-4396-1b57-08da53f0c269
x-ms-traffictypediagnostic: MW5PR12MB5622:EE_
x-microsoft-antispam-prvs: <MW5PR12MB562284A18EA88546816825BB8EB29@MW5PR12MB5622.namprd12.prod.outlook.com>
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: wbRobliec/iEJUE2sM1xbVRR1PowlX0fY4rTy9qA4sDUQncPeFF65rZudJXV5e9va3tL6UbzwZlL069KaouodiXZpLUtozxdNZn8aVT++HtWE9OycuUK3Fv3/RWazFrSvdnZa81fQ8ask4Ugx7E4jnQAdJoHjzIsD8ZcHfer26BdlatHIQMeQSRPEdT2Vb0AUurPQzcPbSj3580Jh/yZHLgIQdxOlt58WH35HurPIXv1c5HYus2co+yfnrKuiX3C6bLYC4k7nP/1KEznG0iwiRvEGCDLZe8KDYfcy96ugLZtl5E8kYiosOTtwP6Z5Xx7l09cR4pporoI3Mh8hbyj5PtcflErdt6xeFuXPLWZfBYAW2vvsp/kCC3KhrzpirDV0sFLDJW3dZSNiJxKO5Y3Wk/2kwldgB5iQ/lAbgOWmtyO+ch4qJozT0P2FrLXH6Wmqdl98G4rHOQyPRFrYKuVeJth6TOWQIEZK2rqRiRW3eIi/q8PgOsfNaRsTTLgT/12NMiwP8gGKmjtyWzq/dkhHRqge7vu4Q4uMoyRbP+Xgva/M3nMjMQuiWi2O/dS3HrBkJoYyij1Dl7caWVpQP38k9cIq/UuI2CYeYcbmFrOJYELVCCbhDiqHWpvTvVbifQq9OsOdaLo6ZtLT2csbh80BrCxVJGsD+bLUw05SKeTR9MUQaEgwJjl6hGK+GSFpiVHmFQh4K1y1+0D0tZgyJD+wg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR12MB2759.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(396003)(346002)(39860400002)(376002)(366004)(136003)(478600001)(316002)(9686003)(38070700005)(7696005)(54906003)(186003)(26005)(2906002)(55016003)(8936002)(6506007)(71200400001)(52536014)(33656002)(8676002)(4326008)(66556008)(4744005)(41300700001)(86362001)(76116006)(66476007)(66946007)(6916009)(5660300002)(7416002)(7406005)(122000001)(64756008)(38100700002)(66446008);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?cFptc1M5UFI0dUlpZXNvSldxSnkwa1NvS3R0T2RjZkNWejJWdWlJb2lpb2NT?=
 =?utf-8?B?ZFZ0QUhrUTBGS2hYaUZ0N3NIUXFiYlZnT2tOSTVrTlNWem5qTytMd2RKMHNK?=
 =?utf-8?B?Z0pQL3lES3dnOStnemdWQUdTSGRnV0owVFRWc3VDRFJDdkR2dG1ScDdlODJa?=
 =?utf-8?B?QXpTQWdlZUNaU013eTk2RlBNYTlKVGFUTkdDVUQxNGdTN2pwb0g0S3NNdG5w?=
 =?utf-8?B?UkhBMzVTNHJzNjU1SVJMQXphRENKYXoyWFpINjdMNzB5K0pYaDhCV0U0cXF0?=
 =?utf-8?B?ZWxTaHVsKzBXcm04Q2Y1R1JyWkRTcmZpQVpBTjhlc3oyZGVObFVVMGdtYjB2?=
 =?utf-8?B?SUpEbmtUTzlTUzBPeERnSGh0MEsxQUwwclZoSWVKQldncytqMXRvOUdQbU1k?=
 =?utf-8?B?NWJFdFhITmc4ZHl2Njk1SGlyQlhhR0owNzRhQTFIUkFwN2JzREY0LzRuQ25Z?=
 =?utf-8?B?UDdzd2JUd3hxWmlYdmlkcm11SS9BL0J3U3p4UWdQTVJ0d2FYRm1STTNjblJz?=
 =?utf-8?B?MFMvd0d1bjYrUVRuZXU2bDl1NWRtQ2hPQzBuTmhOa2g1WmxtMW8vRmttbGlS?=
 =?utf-8?B?UjBobXd2Z1hqVThydndRSDVpYVZXZUNuWmtDUy9WWHdYaVFHVGVkMEpRUmRY?=
 =?utf-8?B?TVh5NmZmb1h0L3FxZ0V6TGlMeHhLWE1HRXVWVkhRRVVyNlBBVkdJeG1TU09l?=
 =?utf-8?B?ZHVqN3FVcGFvVloxQ0FTY2NJWUxDY1M3OUVHS0FwSzdqeFBaVHBTcWFYcUsv?=
 =?utf-8?B?ZEc1bDRzYndpcGg4TmdqQjBrdkNWK2paOXVBd1N4R29QY0JsdGRXQUJYMExn?=
 =?utf-8?B?VitEM0ptbkhxeVhiUElkV1R1b3pCdG5Kcy9VTXd3Y1BIV0hFalBUcWlJUUUz?=
 =?utf-8?B?K0pBaGNmdEp3UDZweEV2S3lUcjM0Y3duK203bzFPQW9rV05VRjZpbTNNT2xk?=
 =?utf-8?B?c24yclludFArd2s1RTI5L1ZzaVFkLzZkNE5sSmtNMGZ2alpLYlNxT3Bid2Zp?=
 =?utf-8?B?cDVtQXY2QWI1Tmx4WkhOc3R4L3l2WjR5dURtYXlRa1B3Q3FNZWMxeTBna2s3?=
 =?utf-8?B?SjIyUWtNY1Y1MXhxcHRhOWJXZnlWVmw3aHp1SjhmWXBvR084VUJYRlhCR2V1?=
 =?utf-8?B?MkE5ejEzOUNRUzVRa0ZuekZtakh6R21JMFdlVFUrWkh1VFBSUC9SZ0hJQkJD?=
 =?utf-8?B?aEIvZTdxdXZRMWZOUkM2TndOMXpWeDY1TXJqUWtwbkQzVG9XK2VQY1J0WnVV?=
 =?utf-8?B?VXM5cnFCRXVWVEd4ZlEvRSszakZuSTdHdUExUWpjYnVHL0E1cHFwV1RzaWdX?=
 =?utf-8?B?WTZiMkNyc0FEdGxldFpiY0pobWl5NWY1WXdJNFhkS0NFZjJvbzRiSVM1Tzd1?=
 =?utf-8?B?eTFya0h3c1NIZGhrcm1wZUVZRENMWlJFVGpSdjJpZmZwQVZxSlljdncwSFI2?=
 =?utf-8?B?bjFEb1FuNUhaTFAvcWg1a2tVNlRUYmFPV1Q2Qkx6QXFreVRRV3JHV2hVUkxl?=
 =?utf-8?B?MFIvaTd2dS9jcVp1UndDNmswWm5EUFQyQUdNU3liczBwM3hPcVpZVkU2Tmlw?=
 =?utf-8?B?cU53bk5VMVJOSWdSLzlNODQrMzEvVWR2M2tHUWZ2VnNOQllVQ1kvVzNUUytV?=
 =?utf-8?B?cmtSQXFEYXNta2E5cWxTb0xpNzNhbCtxNVhQL3FRRlNiMU9mVmZTU2VrbU96?=
 =?utf-8?B?Ym8zb0Uza1pTS0l4enB0cTNBQlB3akJGeDNHWkQxeWo5cU9vbmorOHZTbU9Q?=
 =?utf-8?B?bkh2UmlnMHlKMFRuMzcvOGEyMnlGV2hJaXFIcmJxLzlwUHF2Sm1jWWVnbFVI?=
 =?utf-8?B?aXhqeW9iUm5sTEZmT3hWQmRIY1JjMVI4bUQ0MFhXSG5MVmVRY25MOXp0VFhP?=
 =?utf-8?B?SWVMb3hUZ0h4RGZubERacGRUTXY2UjRVbFgwdnBmelpSN3Q4R1BoSWE5blNU?=
 =?utf-8?B?MVNhdHFTVzJVS05RaWN6UTd0OE1zZ2hPNVhQQ1hIaTRJZEJWSkN4L2wyMXJ5?=
 =?utf-8?B?NjJVV2s5TVVuNVFsRC9WblRiQm9iQW52YWd3LzhvdXFUamVlZ2JWM0ZzMEVz?=
 =?utf-8?B?VkxrZDROdE96SU5TL2haTlY3TWVPRStFUlVzc0JRT2RHU3NzTGNvWVVLalNp?=
 =?utf-8?B?d3lOR01SdSsySHdTajByeE9obk5JMFFFNGxMK2t0RldtREFDKzNTMjBJbG1B?=
 =?utf-8?B?cFVzYUw2R0xyMjRacVp0OG5xMzVaZ3IzWnZZUFBqUHZuWWUvTUVhQnZENjRH?=
 =?utf-8?B?enlQQld0ODZNTHhIZk5LTERiMnBQSWJ2Y1VOeThCdmtxcmtHL21Hdk1GMmZX?=
 =?utf-8?Q?cpVWQ/pP1VetsHGs83?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BYAPR12MB2759.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ecd4abf4-a232-4396-1b57-08da53f0c269
X-MS-Exchange-CrossTenant-originalarrivaltime: 22 Jun 2022 01:44:34.4646
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: dk7CMenaxlds5UkLZEvSWyuc8vRssA6YvpU+FxsA8gkViGhIKlr8Yierb2U49GWXJpSlyRwjUDcZMyxCwmeZFQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW5PR12MB5622
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

W1B1YmxpY10NCg0KPj4gK0VYUE9SVF9TWU1CT0xfR1BMKHNucF9ndWVzdF9kZWNvbW1pc3Npb24p
Ow0KPj4gKw0KPj4gK2ludCBzbnBfZ3Vlc3RfZGZfZmx1c2goaW50ICplcnJvcikNCj4+ICt7DQo+
PiArICAgICAgIHJldHVybiBzZXZfZG9fY21kKFNFVl9DTURfU05QX0RGX0ZMVVNILCBOVUxMLCBl
cnJvcik7IH0gDQo+PiArRVhQT1JUX1NZTUJPTF9HUEwoc25wX2d1ZXN0X2RmX2ZsdXNoKTsNCg0K
PldoeSBub3QgaW5zdGVhZCBjaGFuZ2Ugc2V2X2d1ZXN0X2RmX2ZsdXNoKCkgdG8gYmUgU05QIGF3
YXJlPyBUaGF0IHdheSBjYWxsZXJzIGdldCB0aGUgcmlnaHQgYmVoYXZpb3Igd2l0aG91dCBoYXZp
bmcgdG8ga25vdyBpZiBTTlAgaXMgZW5hYmxlZCBvciBub3QuDQoNCkl0IGNhbiBiZSBkb25lLCBh
bmQgYWN0dWFsbHkgYm90aCBERl9GTFVTSCAgY29tbWFuZHMgZG8gZXhhY3RseSB0aGUgc2FtZSB0
aGluZy4NCg0KQnV0IGFzIHdpdGggb3RoZXIgQVBJIGludGVyZmFjZXMgaGVyZSwgSSB0aGluayBp
dCBpcyBiZXR0ZXIgdG8gZGlmZmVyZW50aWF0ZSBiZXR3ZWVuIHNucCBhbmQgc2V2IEFQSSBpbnRl
cmZhY2VzIGFuZCB0aGUgY2FsbGVycyBiZSBhd2FyZSBvZiB3aGljaA0KaW50ZXJmYWNlIHRoZXkg
YXJlIGludm9raW5nLg0KDQpUaGFua3MsDQpBc2hpc2gNCg==
