Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5803A560A2A
	for <lists+kvm@lfdr.de>; Wed, 29 Jun 2022 21:16:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231195AbiF2TPW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 29 Jun 2022 15:15:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57930 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229546AbiF2TPT (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 29 Jun 2022 15:15:19 -0400
Received: from NAM02-BN1-obe.outbound.protection.outlook.com (mail-bn1nam07on2078.outbound.protection.outlook.com [40.107.212.78])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 211153DA70;
        Wed, 29 Jun 2022 12:15:18 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=l2P58wfhXpz0gI8Z8rbvsSxVUbAtS4c8tn1mHEWYoWJNdUhdN+ABy/6+MfYPdW2olZ8ytI4JG0o0cfm0VzHao+UuHbptBaLIJFobw65+3dx3sGNbr7uoa7OabTwZ3KIvPErZnqG/ApAZCJH69dX21u2WAF1lk2ajk/WX4qbaqhU0yhu5DHcuZ+rk74y2y+/k5bEEQGF/o/F12pOFGMarmhUuekCR36NUhPYzfmlKGDTFbn91or2+elaQBv8DCy3M0xWKxIhoMg+Zb4gfQaMBo4RgW9dLbhjz4aXprK99jQRyeiNAlxuYVY/LRvIK/WJ7f6IQ+55nBlJtSUPfJuYHFA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=NrtHPIiP5K8+8DXjsz0QoXY2xWEAjeNzB4suWpJ2pTA=;
 b=Y5OHXVDl6Cu8h8yB1szXPILHDg4jzDzc3MDUt6i7wVVeAdExln52nrcIg9IKduvYeIMenRU8qDGPcSEEvWvayvmlc1t2aPbc1C+NPqGGZHNpUKbZChmSa76djxr1c+JGV8X6xFkiNO8ICgnmX6lchnHP7qmNd8U1zvE817oYn7RNha1W8p5jWdaFTkwtVIoLD98VMhpyShF3wfN71R47LrqCSJnwEtL1iGtYHOFyTz4rnR7f/3QVfKsMo/SAJTECn4bVQWoLCexKYKXeEZ3M2LIhngCwODX6Gc2w4Jj+5Y9NxF7SEs21HZYmWYwhJdzLXq1m3ALGlaTrqwA3U2sUyQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=NrtHPIiP5K8+8DXjsz0QoXY2xWEAjeNzB4suWpJ2pTA=;
 b=KxkAztENZX9/qYv+gMqMIv2aLf5MoECuROxMCEiPvRNpshNAB+YxT/TmousaS7GDs+vZ7Ez53ZKh8Er+U0BC2ALjwABImzQh4E8b4jo6zdZ1twtW+v/j54mgu0r+gQ9wgHSdv9QOZA8fSMY6bHogGUBMX3S5EMTUVHk66kWImPA=
Received: from SN6PR12MB2767.namprd12.prod.outlook.com (2603:10b6:805:75::23)
 by CH0PR12MB5201.namprd12.prod.outlook.com (2603:10b6:610:b8::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5373.17; Wed, 29 Jun
 2022 19:15:15 +0000
Received: from SN6PR12MB2767.namprd12.prod.outlook.com
 ([fe80::8953:6baa:97bb:a15d]) by SN6PR12MB2767.namprd12.prod.outlook.com
 ([fe80::8953:6baa:97bb:a15d%7]) with mapi id 15.20.5395.014; Wed, 29 Jun 2022
 19:15:15 +0000
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
Subject: RE: [PATCH Part2 v6 42/49] KVM: SVM: Provide support for
 SNP_GUEST_REQUEST NAE event
Thread-Topic: [PATCH Part2 v6 42/49] KVM: SVM: Provide support for
 SNP_GUEST_REQUEST NAE event
Thread-Index: AQHYh+cMNQlV87m4pEipOHARRoA6Ra1jjyQQgAM2zNA=
Date:   Wed, 29 Jun 2022 19:15:15 +0000
Message-ID: <SN6PR12MB27675E821D5D1C423F2AF5768EBB9@SN6PR12MB2767.namprd12.prod.outlook.com>
References: <cover.1655761627.git.ashish.kalra@amd.com>
 <5d05799fc61994684aa2b2ddb8c5b326a3279e25.1655761627.git.ashish.kalra@amd.com>
 <CAMkAt6rGzSewSyO1uZehWUD2J6aLtRwP5N-uj-HPG73Pp0=Sjw@mail.gmail.com>
 <SN6PR12MB2767B9F438A0F6413780F73E8EB99@SN6PR12MB2767.namprd12.prod.outlook.com>
In-Reply-To: <SN6PR12MB2767B9F438A0F6413780F73E8EB99@SN6PR12MB2767.namprd12.prod.outlook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: MSIP_Label_d4243a53-6221-4f75-8154-e4b33a5707a1_Enabled=true;
 MSIP_Label_d4243a53-6221-4f75-8154-e4b33a5707a1_SetDate=2022-06-27T18:40:10Z;
 MSIP_Label_d4243a53-6221-4f75-8154-e4b33a5707a1_Method=Privileged;
 MSIP_Label_d4243a53-6221-4f75-8154-e4b33a5707a1_Name=Public-AIP 2.0;
 MSIP_Label_d4243a53-6221-4f75-8154-e4b33a5707a1_SiteId=3dd8961f-e488-4e60-8e11-a82d994e183d;
 MSIP_Label_d4243a53-6221-4f75-8154-e4b33a5707a1_ActionId=5035ad0e-77e3-489b-959f-0789d7268b6d;
 MSIP_Label_d4243a53-6221-4f75-8154-e4b33a5707a1_ContentBits=1
msip_label_d4243a53-6221-4f75-8154-e4b33a5707a1_enabled: true
msip_label_d4243a53-6221-4f75-8154-e4b33a5707a1_setdate: 2022-06-29T19:15:13Z
msip_label_d4243a53-6221-4f75-8154-e4b33a5707a1_method: Privileged
msip_label_d4243a53-6221-4f75-8154-e4b33a5707a1_name: Public-AIP 2.0
msip_label_d4243a53-6221-4f75-8154-e4b33a5707a1_siteid: 3dd8961f-e488-4e60-8e11-a82d994e183d
msip_label_d4243a53-6221-4f75-8154-e4b33a5707a1_actionid: 48557c5b-8945-4454-97cd-5f45a8223356
msip_label_d4243a53-6221-4f75-8154-e4b33a5707a1_contentbits: 0
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 31ed9f2d-ba76-471c-2e82-08da5a03b2d5
x-ms-traffictypediagnostic: CH0PR12MB5201:EE_
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 54ipy6EeA6FygUj5l4+9g0hI8Uu95lgE1yYqGkp5b/qCACqeSWXLTdfzKX4i3zCshTzsmErxR3ZHy8C+9XpalTEpIqg8uKOu/YIzqI0nQxc3Mp1bjbM1EeXMt6brKZL2g1VaMQS+fNfM02vbp+obd3VNXfCqFgJPBsasAOVm4jf3ILbwJOGaPXwbVzymvOt7AwGgWYcPG+Sj6jFMD3kg9BMTFr1a4XOsRe5f7MdQRxBxCXmXDyLKfRJpxyLql1lKqtKOzzEljNPulaBzt/OwcX/sCcLVmGTWlSpwIifhY+7gSC0ZOn7EI3Sq1g4xNZAX3942FFcS+qwip+UKywg7invn9KYIem5duZKRhobUh29s3KcY8FbZQ2otZe+WU90ChC+MO6d1e/ucKpAGsz4p89pGAgq0XxHeWm4uhEEj3Jy9vTV0lGtJ4sAgxJq3YNM1EvbYRQWCOfYGK3ePJgZJdu2Vq7GKHa5LsgpNsexazwB4yhfRXXZakVfamlznbuHYYSIzf6AwrUjxQFIU43Ir+Ro90oIsWgY3VBX0SWFjHQhmXM0O+/1agQ3HJvTlBu6DO1IPVOlnmMexoVbDlwE6fACti7LcNBi65XumyYvgBFzvkxZAWhjwlZ/Nqw+Lb7+yvUW2ojzshPUYTxmxWgieJM+ietRQrYrzkUGTj+a2Dk0PAMKdQSYl4JFH7aBgOxySvHJfkjlDIZMUyY2iM9KkNdk7g7+d15G1oCHdSvR3Gn3+92fgzvIJQwXtG2XpfoACIHmi5RxInAPbuAfZSKyzWJ9Uc8CtwPmbuycDBNE867o=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR12MB2767.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(346002)(376002)(39860400002)(136003)(396003)(366004)(64756008)(38100700002)(52536014)(8676002)(33656002)(2906002)(66476007)(76116006)(54906003)(7416002)(4326008)(5660300002)(8936002)(7406005)(66556008)(7696005)(66946007)(9686003)(26005)(6506007)(83380400001)(38070700005)(316002)(122000001)(478600001)(6916009)(186003)(66446008)(71200400001)(41300700001)(55016003)(86362001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?cUxsODBTSWEzYXptKzExNVYvRjlKRmY3clJkVGc0dDg3blpadERFVkZwTy9v?=
 =?utf-8?B?RWRvbVhHUW5aR1UxZGFkWG90QW1jNk1zcXZRb0ZTUG5XbjlsUStKbTJldHFo?=
 =?utf-8?B?bW41ZDNacG9JUHRLL1dLdE5ZV2ZScXcya2hqT29zS05GMjd6aktWZ1BFa2pr?=
 =?utf-8?B?K3VCcUtFZi9yeEhuZXZUTDVHMDRPOWFDdkJnMnVqWkN6UjRMNnVFYk9UKzUy?=
 =?utf-8?B?UFI0ZU9yOWw5Uk5UUUh2bmEyT2U1YWlxeHZRdzNEZ1JJamNqUHZmeFVtMTlN?=
 =?utf-8?B?TEV1MWg0Mzh0OTR6TkV2cTZwZ2p6SFhxQnFjQmNHbi9wRFNBQnZOOFJLWitv?=
 =?utf-8?B?N3pjdUxGRXVYeCtmcnRpdnlMM3JmSDJrUnhXS0R3bVorUFUveUkycldIVlhq?=
 =?utf-8?B?SzR0NlR2RXB2MUFJeHlJTFFMM3JpUDVpLzZoWnNrUzRpL0wvS01nYStablVK?=
 =?utf-8?B?T1AxVHJLSGV3UEVIYXVxNkJiQkFFdkRyZHJTWTdLMEZKSFVMQVhXY1N2dG9x?=
 =?utf-8?B?OUk0c0hPMEN4Nmo0KzRSclhvaGpWd0s5bGRydkVEZEI0SmllMEZPbnRBMHdF?=
 =?utf-8?B?cm1TRUVUSFcrZzZLYWd2QXdwNXhPQlkxU0p1V2hNMkppVDMyV095K0F3T3k5?=
 =?utf-8?B?YlVLL3RNUDFXRVBXUndXdm5hcUpsMXVMcDlSbitrbGFnSUNuWEN6Z3JCUFc1?=
 =?utf-8?B?Z0ZzTUlrZ3NrL2hzWnlrWHY0YnZsUUNjc2JETWg4c3JwaTdSUlFPamZPN29I?=
 =?utf-8?B?OVUvZGhHc1dJM3A2Y1Bnak9IMHQwV0VRN1VMYjNiWDEyeHpLbnpydS9hVEha?=
 =?utf-8?B?SnlZaU5nRjBHUE9qSUxlM1RpWTR0em10Y1dxVnI5L3V3aUFheXU5QnRML0t3?=
 =?utf-8?B?bjZRblVKWGJWSGJPNWgyU3ZVYkpCb1BhaFRRbnFVcDdqNjN1SnBKcXlXRkRa?=
 =?utf-8?B?c0F4SmlQc01XaCtkak9zYytRT2s0ODN2M05sdnBHYkFEVUF2N1FhN1ZmTm0x?=
 =?utf-8?B?eGhiVWlmUEJXUyt0NjdGN3J4a3hUZ2c1Y0NkLzFZZWl1UjV1ck44NGZHVFFX?=
 =?utf-8?B?ZnZYSmRFRSs3Q2pxNFFqYzkrWmthSWpzZUdvZzhTc3J2cCtxcnI2SERFVWJ4?=
 =?utf-8?B?dnZXL3V0ZzFRaldrWjdkYTI0dHdkMDBRZUxSZjRSRWxYOHdjVEpYZEEwb2k0?=
 =?utf-8?B?SjNpNkovc2tjTktYaldCS3ZrOHFSMkJRSUhDWGRkdzEvT0libDN2Wjg4M1Bh?=
 =?utf-8?B?RFpOSTc3UlFaVVduRnRTMExjU2JXNUdlb2FINkZIM0RIbEJ5RlZFcjZOQ0hT?=
 =?utf-8?B?WnBESlNZWlBteEFObmdBaGpUWURkaTEybkVSWUxEV2lRT3NxTGYwRWU2cHJu?=
 =?utf-8?B?ejRDNUpqRnFSQ2Y1VVdLK3BBREVUUVhZN3lWMlFDMzhoN3pYRkxjUHZDTURj?=
 =?utf-8?B?ZDJCcmRHa0Vtak82NnROUmlkWVVpT1JBcEhIYmdkbkU4aXA4dHE5OUNxRlQw?=
 =?utf-8?B?a3kyWjBTZC9TS2swWG9adnVFZE5kRjZsdTVlbkpjUjBDckpsOHNEcVprWFd0?=
 =?utf-8?B?dDlPK1dadjFFcDlaSFN0dWVRVDdnTEFqb1NheG1wcHdzaWptS0I1Y3BJUU1s?=
 =?utf-8?B?ckhlQ21iVVhHSVRRSlhBZENrQXhTZWVnZGZEZGV5TzdMWHNIVC94dmlXRDVJ?=
 =?utf-8?B?aWk5N1BoT3FnUkF5QzVkQ2ttTnVrUjBWMlRFaTJTOWRJUkpHTG1sUmJpdGNT?=
 =?utf-8?B?cm16aEZsVmJ3aHZ3WDB1R3VhZFdxUVVZa2R1VVRrd0NlYnVudlBxUmwwTE1T?=
 =?utf-8?B?ZEVnTi80c1FSYStYbDRrc2FKSUlraDdPUEQ4K20xTHhPWDBBVmFOWWJHWDlU?=
 =?utf-8?B?Z1BoNmVQYVRJMDFteDFGbHkxZkg3NDBjczc4T0VUUEFoZ2Q3K014NWpPdkRi?=
 =?utf-8?B?TE9qTXJhUXRQRkNvMmpuREtxRFlXaFFRclp3dWgxbTFWSUdkUENhRldoNkx1?=
 =?utf-8?B?QWdySW5qelZOTHdlVTZYTnIrRXFOUi9NUFpOMy81bjNnSlVJSnI2aGpjQmR4?=
 =?utf-8?B?T0tnLzNXek9GOEcvcVVPSms4SFA1MTZKckZGdGVCNHplazUrRDB2MmE0VzVT?=
 =?utf-8?Q?O49A=3D?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SN6PR12MB2767.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 31ed9f2d-ba76-471c-2e82-08da5a03b2d5
X-MS-Exchange-CrossTenant-originalarrivaltime: 29 Jun 2022 19:15:15.7907
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: RoJ/Oal2NGkvgWavVxyjk4BNexjo34skjX9/AsckOa0qpdSgI5jNewPN1uKkatxboPwKM9lTFfY4kXpvxIdSoA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR12MB5201
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

W1B1YmxpY10NCg0KDQo+PiArc3RhdGljIHZvaWQgc25wX2hhbmRsZV9leHRfZ3Vlc3RfcmVxdWVz
dChzdHJ1Y3QgdmNwdV9zdm0gKnN2bSwgZ3BhX3QgDQo+PiArcmVxX2dwYSwgZ3BhX3QgcmVzcF9n
cGEpIHsNCj4+ICsgICAgICAgc3RydWN0IHNldl9kYXRhX3NucF9ndWVzdF9yZXF1ZXN0IHJlcSA9
IHswfTsNCj4+ICsgICAgICAgc3RydWN0IGt2bV92Y3B1ICp2Y3B1ID0gJnN2bS0+dmNwdTsNCj4+
ICsgICAgICAgc3RydWN0IGt2bSAqa3ZtID0gdmNwdS0+a3ZtOw0KPj4gKyAgICAgICB1bnNpZ25l
ZCBsb25nIGRhdGFfbnBhZ2VzOw0KPj4gKyAgICAgICBzdHJ1Y3Qga3ZtX3Nldl9pbmZvICpzZXY7
DQo+PiArICAgICAgIHVuc2lnbmVkIGxvbmcgcmMsIGVycjsNCj4+ICsgICAgICAgdTY0IGRhdGFf
Z3BhOw0KPj4gKw0KPj4gKyAgICAgICBpZiAoIXNldl9zbnBfZ3Vlc3QodmNwdS0+a3ZtKSkgew0K
Pj4gKyAgICAgICAgICAgICAgIHJjID0gU0VWX1JFVF9JTlZBTElEX0dVRVNUOw0KPj4gKyAgICAg
ICAgICAgICAgIGdvdG8gZV9mYWlsOw0KPj4gKyAgICAgICB9DQo+PiArDQo+PiArICAgICAgIHNl
diA9ICZ0b19rdm1fc3ZtKGt2bSktPnNldl9pbmZvOw0KPj4gKw0KPj4gKyAgICAgICBkYXRhX2dw
YSA9IHZjcHUtPmFyY2gucmVnc1tWQ1BVX1JFR1NfUkFYXTsNCj4+ICsgICAgICAgZGF0YV9ucGFn
ZXMgPSB2Y3B1LT5hcmNoLnJlZ3NbVkNQVV9SRUdTX1JCWF07DQo+PiArDQo+PiArICAgICAgIGlm
ICghSVNfQUxJR05FRChkYXRhX2dwYSwgUEFHRV9TSVpFKSkgew0KPj4gKyAgICAgICAgICAgICAg
IHJjID0gU0VWX1JFVF9JTlZBTElEX0FERFJFU1M7DQo+PiArICAgICAgICAgICAgICAgZ290byBl
X2ZhaWw7DQo+PiArICAgICAgIH0NCj4+ICsNCj4+ICsgICAgICAgLyogVmVyaWZ5IHRoYXQgcmVx
dWVzdGVkIGJsb2Igd2lsbCBmaXQgaW4gY2VydGlmaWNhdGUgYnVmZmVyICovDQo+PiArICAgICAg
IGlmICgoZGF0YV9ucGFnZXMgPDwgUEFHRV9TSElGVCkgPiBTRVZfRldfQkxPQl9NQVhfU0laRSkg
ew0KPj4gKyAgICAgICAgICAgICAgIHJjID0gU0VWX1JFVF9JTlZBTElEX1BBUkFNOw0KPj4gKyAg
ICAgICAgICAgICAgIGdvdG8gZV9mYWlsOw0KPj4gKyAgICAgICB9DQo+PiArDQo+PiArICAgICAg
IG11dGV4X2xvY2soJnNldi0+Z3Vlc3RfcmVxX2xvY2spOw0KPj4gKw0KPj4gKyAgICAgICByYyA9
IHNucF9zZXR1cF9ndWVzdF9idWYoc3ZtLCAmcmVxLCByZXFfZ3BhLCByZXNwX2dwYSk7DQo+PiAr
ICAgICAgIGlmIChyYykNCj4+ICsgICAgICAgICAgICAgICBnb3RvIHVubG9jazsNCj4+ICsNCj4+
ICsgICAgICAgcmMgPSBzbnBfZ3Vlc3RfZXh0X2d1ZXN0X3JlcXVlc3QoJnJlcSwgKHVuc2lnbmVk
IGxvbmcpc2V2LT5zbnBfY2VydHNfZGF0YSwNCj4+ICsgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgJmRhdGFfbnBhZ2VzLCAmZXJyKTsNCj4+ICsgICAgICAgaWYgKHJjKSB7
DQo+PiArICAgICAgICAgICAgICAgLyoNCj4+ICsgICAgICAgICAgICAgICAgKiBJZiBidWZmZXIg
bGVuZ3RoIGlzIHNtYWxsIHRoZW4gcmV0dXJuIHRoZSBleHBlY3RlZA0KPj4gKyAgICAgICAgICAg
ICAgICAqIGxlbmd0aCBpbiByYnguDQo+PiArICAgICAgICAgICAgICAgICovDQo+PiArICAgICAg
ICAgICAgICAgaWYgKGVyciA9PSBTTlBfR1VFU1RfUkVRX0lOVkFMSURfTEVOKQ0KPj4gKyAgICAg
ICAgICAgICAgICAgICAgICAgdmNwdS0+YXJjaC5yZWdzW1ZDUFVfUkVHU19SQlhdID0gZGF0YV9u
cGFnZXM7DQo+PiArDQo+PiArICAgICAgICAgICAgICAgLyogcGFzcyB0aGUgZmlybXdhcmUgZXJy
b3IgY29kZSAqLw0KPj4gKyAgICAgICAgICAgICAgIHJjID0gZXJyOw0KPj4gKyAgICAgICAgICAg
ICAgIGdvdG8gY2xlYW51cDsNCj4+ICsgICAgICAgfQ0KPj4gKw0KPj4gKyAgICAgICAvKiBDb3B5
IHRoZSBjZXJ0aWZpY2F0ZSBibG9iIGluIHRoZSBndWVzdCBtZW1vcnkgKi8NCj4+ICsgICAgICAg
aWYgKGRhdGFfbnBhZ2VzICYmDQo+PiArICAgICAgICAgICBrdm1fd3JpdGVfZ3Vlc3Qoa3ZtLCBk
YXRhX2dwYSwgc2V2LT5zbnBfY2VydHNfZGF0YSwgZGF0YV9ucGFnZXMgPDwgUEFHRV9TSElGVCkp
DQo+PiArICAgICAgICAgICAgICAgcmMgPSBTRVZfUkVUX0lOVkFMSURfQUREUkVTUzsNCg0KPj5T
aW5jZSBhdCB0aGlzIHBvaW50IHRoZSBQU1AgRlcgaGFzIGNvcnJlY3RseSBleGVjdXRlZCB0aGUg
Y29tbWFuZCBhbmQgaW5jcmVtZW50ZWQgdGhlIFZNUENLIHNlcXVlbmNlIG51bWJlciBJIHRoaW5r
IHdlIG5lZWQgYW5vdGhlciBlcnJvciBzaWduYWwgaGVyZSBzaW5jZSB0aGlzIHdpbGwgdGVsbCB0
aGUgZ3Vlc3QgdGhlIFBTUCBoYWQgYW4gZXJyb3Igc28gaXQgd2lsbCBub3Qga25vdyBpZiB0aGUg
Vk1QQ0sgc2VxdWVuY2UgPm51bWJlciBzaG91bGQgYmUgaW5jcmVtZW50ZWQuDQoNCj5TaW1pbGFy
bHkgYXMgYWJvdmUsIGFzIHRoaXMgaXMgYW4gZXJyb3IgcGF0aCwgc28gd2hhdCdzIHRoZSBndWFy
YW50ZWUgdGhhdCB0aGUgbmV4dCBndWVzdCBtZXNzYWdlIHJlcXVlc3Qgd2lsbCBzdWNjZWVkIGNv
bXBsZXRlbHksICBpc27igJl0IGl0IGJldHRlciB0byBsZXQgdGhlIA0KPkZXIHJlamVjdCBhbnkg
c3Vic2VxdWVudCBndWVzdCBtZXNzYWdlcyBvbmNlIGl0IGhhcyBkZXRlY3RlZCB0aGF0IHRoZSBz
ZXF1ZW5jZSBudW1iZXJzIGFyZSBvdXQgb2Ygc3luYyA/DQoNCkFsdGVybmF0ZWx5LCB3ZSBwcm9i
YWJseSBjYW4gcmV0dXJuIFNFVl9SRVRfSU5WQUxJRF9QQUdFX1NUQVRFL1NFVl9SRVRfSU5WQUxJ
RF9QQUdFX09XTkVSIGhlcmUsIGJ1dCB0aGF0IHN0aWxsIGRvZXMgbm90IGluZGljYXRlIHRvIHRo
ZSBndWVzdA0KdGhhdCB0aGUgRlcgaGFzIHN1Y2Nlc3NmdWxseSBleGVjdXRlZCB0aGUgY29tbWFu
ZCBhbmQgdGhlIGVycm9yIG9jY3VycmVkIGR1cmluZyBjbGVhbnVwL3Jlc3VsdCBwaGFzZSBhbmQg
aXQgbmVlZHMgdG8gaW5jcmVtZW50IHRoZSBWTVBDSyBzZXF1ZW5jZSBudW1iZXIuIFRoZXJlIGlz
IG5vdGhpbmcgYXMgc3VjaCBkZWZpbmVkIGluIFNOUCBGVyBBUEkgc3BlY3MgdG8gaW5kaWNhdGUg
c3VjaCBraW5kIG9mIGZhaWx1cmVzIHRvIGd1ZXN0LiBBcyBJIG1lbnRpb25lZCBlYXJsaWVyLCB0
aGlzIGlzIHByb2JhYmx5IGluZGljYXRpdmUgb2YNCmEgYmlnZ2VyIHN5c3RlbSBmYWlsdXJlIGFu
ZCBpdCBpcyBiZXR0ZXIgdG8gbGV0IHRoZSBGVyByZWplY3Qgc3Vic2VxdWVudCBndWVzdCBtZXNz
YWdlcy9yZXF1ZXN0cyBvbmNlIGl0IGhhcyBkZXRlY3RlZCB0aGF0IHRoZSBzZXF1ZW5jZSBudW1i
ZXJzIGFyZSBvdXQgb2Ygc3luYy4NCg0KVGhhbmtzLA0KQXNoaXNoDQo=
