Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AB36D55A0C7
	for <lists+kvm@lfdr.de>; Fri, 24 Jun 2022 20:29:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231150AbiFXSRw (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 24 Jun 2022 14:17:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45476 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230397AbiFXSRv (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 24 Jun 2022 14:17:51 -0400
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2041.outbound.protection.outlook.com [40.107.236.41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5A19A52519;
        Fri, 24 Jun 2022 11:17:48 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=JEvtVIBlu5vGlPr8WHa5T0CrBZZN+PClovq5sbQmDM+s9Gqr1OK3NY5kl5gKQXjDG+q9944jTf1AwLR1UiO3q0doS2/Etuaw+IneQmUdTZ6P030ykBM9rch7hS/tKBr1fEddrKVDODcM/1dtgVuEDYGjJAK1Hxj9BD9UCmc0K0vcZd08bxIsy3IihAzWPF0R+rc5sNnTh5gz/9T1Xh3O3pNNc2Bq4IEZGbqrZAh0yESPvWYX9SRLKPZjqNLZqKcUD2tCNe/Pb+wYcpzcB8Lqv2fdHyDUNERGsKKoAjZ2VzXclGMFBVKPCOgDd37O0X4Fdzz2AEprMBtTWsxq058yHQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=OQhLk1HLPAb0Y22vL0AwflOAaq6VId6lfiAjUdLluIY=;
 b=KTqbtjO5A1HyBlSXo4aE+T1kn4d4isHTiynBs6OakuWDsQZhJ8JG8VRRnNPPp9+yfkX0EXs4qtWLbGpgaFE2Dploss5Jgy/dUJYv+ibMbRXJnuO8c4gHXn5k1Z9uUpYxQNJ06UAsA6KP844KEysB8+Mbjq8qa0ZpzTeIhCjJzn0IzxQVuA1xs2ZC5uczNfhUt/zbvAi5TZ0pr0zeivsZTW8x3YFRcjF0s6tpfiVrztslGuMz2cbpa4dOZOAIkWlDs3OU8yO5sbdfKPfPYOzzhnqwKYPQ1hpIJzv+ujTMnxK/m2MzeIxzlBdw45AkTSBu40URnmi+EBK/fNLXld0//A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=OQhLk1HLPAb0Y22vL0AwflOAaq6VId6lfiAjUdLluIY=;
 b=MJ21JMSYiUPae9CrpMcUVVikZreRIMcayi7mqOD5+dxvmJZJtkQiNM82Eft5UfoUbxMCxPj1sRvByHDIRDL35wx3odpWbfVXuueBhSnaBDy3zHn2kB7yqoFzarU0Gqy3IDM40ZzOPZaisfc0+Q6yF+D0tSr7dfrkhHK+E+rpUIw=
Received: from SN6PR12MB2767.namprd12.prod.outlook.com (2603:10b6:805:75::23)
 by BN9PR12MB5384.namprd12.prod.outlook.com (2603:10b6:408:105::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5373.17; Fri, 24 Jun
 2022 18:17:45 +0000
Received: from SN6PR12MB2767.namprd12.prod.outlook.com
 ([fe80::8953:6baa:97bb:a15d]) by SN6PR12MB2767.namprd12.prod.outlook.com
 ([fe80::8953:6baa:97bb:a15d%7]) with mapi id 15.20.5373.015; Fri, 24 Jun 2022
 18:17:45 +0000
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
Subject: RE: [PATCH Part2 v6 24/49] KVM: SVM: Add KVM_SEV_SNP_LAUNCH_START
 command
Thread-Topic: [PATCH Part2 v6 24/49] KVM: SVM: Add KVM_SEV_SNP_LAUNCH_START
 command
Thread-Index: AQHYh9i1LEqt/x/AxkuVpnOlpv0O7q1e3FyA
Date:   Fri, 24 Jun 2022 18:17:45 +0000
Message-ID: <SN6PR12MB27670876B5EA34D00281950F8EB49@SN6PR12MB2767.namprd12.prod.outlook.com>
References: <cover.1655761627.git.ashish.kalra@amd.com>
 <6d5c899030b113755e6c093e8bb9ad123280edc6.1655761627.git.ashish.kalra@amd.com>
 <CAMkAt6rV0GMuMwz35fEd19Z-mxXiiO6f2pF23QxTBD70Hzxf0Q@mail.gmail.com>
In-Reply-To: <CAMkAt6rV0GMuMwz35fEd19Z-mxXiiO6f2pF23QxTBD70Hzxf0Q@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: MSIP_Label_4342314e-0df4-4b58-84bf-38bed6170a0f_Enabled=true;
 MSIP_Label_4342314e-0df4-4b58-84bf-38bed6170a0f_SetDate=2022-06-24T18:12:56Z;
 MSIP_Label_4342314e-0df4-4b58-84bf-38bed6170a0f_Method=Standard;
 MSIP_Label_4342314e-0df4-4b58-84bf-38bed6170a0f_Name=General;
 MSIP_Label_4342314e-0df4-4b58-84bf-38bed6170a0f_SiteId=3dd8961f-e488-4e60-8e11-a82d994e183d;
 MSIP_Label_4342314e-0df4-4b58-84bf-38bed6170a0f_ActionId=70492cba-463e-4db4-b337-0ac5ed11cfad;
 MSIP_Label_4342314e-0df4-4b58-84bf-38bed6170a0f_ContentBits=1
msip_label_4342314e-0df4-4b58-84bf-38bed6170a0f_enabled: true
msip_label_4342314e-0df4-4b58-84bf-38bed6170a0f_setdate: 2022-06-24T18:17:43Z
msip_label_4342314e-0df4-4b58-84bf-38bed6170a0f_method: Standard
msip_label_4342314e-0df4-4b58-84bf-38bed6170a0f_name: General
msip_label_4342314e-0df4-4b58-84bf-38bed6170a0f_siteid: 3dd8961f-e488-4e60-8e11-a82d994e183d
msip_label_4342314e-0df4-4b58-84bf-38bed6170a0f_actionid: 911fc746-b331-416d-80e8-7a35a07663b5
msip_label_4342314e-0df4-4b58-84bf-38bed6170a0f_contentbits: 0
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 35e12a6f-c433-4a78-02d6-08da560dd61b
x-ms-traffictypediagnostic: BN9PR12MB5384:EE_
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 5MLmSIHZOnzR8EQrJaNjFVmMN2jdjHBnaEn3QPNYD5dKf66ss8U9OLGouPz4m1o11XETug0E2MqEYKXWNKOJ1wwBqW98OIUDXZNHNcWwUq7Qy+oagh2kn0Ib+aaulp1HpOBuZJYSL6n2QTww3ADGP1qr4aGDsZGY72eD5fcrAO7iNgaj7Lm5JKcTUrSedBcZUnFobfTdExqiSUzvJuaItaSxWKzPYCtbynduP1CSE8INRo1pcx5mslqssfdHQWcLUGsYFxnnnXRLZqOzqUpxByRkATnP5vtZ9GRy5cIdqFH7UNc85QUTdbXNMGipC/YUlx9WRFDNGWM++dfeZo5aU0H0baTOOq+bRUETWMxO2YsBKCJ+9ttl1tmpNkTOApvDsF59f4rar0RSg9bsd3cXN3QbH+Lzoq4hjLbifmwLsnG/0voYoYFiQb3Ogyk8xrUDO0OZMyzPriTrVUpwezSqVgqZ7rmGF7LMBMsixTkoLpaSgljWGmYagidPfEm17OXL/te5z0u2+/lhEJS3ZS/wmjoYa0vYZsjY1GW9As2nczKwXa/eflI9wMi03Nf7Aw4guGQlecStxM0hZx5sajW6XNflZsKaL98+EJ06oFZJC+oIIeTF1pmvrOjH8/9G16/w4eBEp1qXMT4uQZM1chgx7OKWD1LSVEZjvbgkPkCYV+38C26DkAGiNc67f4JaiODUMWR0hbYaAx6drWUIyyylabPxudEoOx8LuOhUcDk9XfqweW0MBbA8/aa1U+Vn4EoK7dAPuwi5+VlF3FuGpkkuNZT0X/60oLfBdqMQ58d7+ho=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR12MB2767.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(136003)(39860400002)(346002)(376002)(396003)(366004)(76116006)(66556008)(6916009)(38100700002)(64756008)(71200400001)(66946007)(33656002)(4326008)(66476007)(66446008)(8676002)(38070700005)(52536014)(8936002)(54906003)(5660300002)(316002)(86362001)(122000001)(26005)(83380400001)(41300700001)(186003)(9686003)(478600001)(6506007)(7696005)(55016003)(2906002)(7416002)(7406005);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?QVNtZVg3RGZ5eDEzRCtXUnhUcGJLT2JuTUYwMTY3K0FzY1Z1RDRVYjdmTUh2?=
 =?utf-8?B?K0F6a3NRUjAwanFLdFlZdExMK2d6SmJmb3JlY09oY1V3WnFpalpTUkRWeU1J?=
 =?utf-8?B?dHdWTFBya0o5cmhRQU1WSzJRcFhuKzRMKy9kQnF3cEYxUGRGVzRyaXZheUk0?=
 =?utf-8?B?YmFoMkppWEZkckxROWJsUUNIZEhLcjZmeS91cFhGUlJTS25FTE8wY01QeGMz?=
 =?utf-8?B?allkUUUxQTVHU2VKcjlWZ0kzUXJINWxrS08rWVB5UDN0ZzJwK2p6YXNnYWtw?=
 =?utf-8?B?U2NpWllLNUZaY2I1SE5RMGM3Y0tsOWZCZmsxNldZSU5LaUdQV3FrcWhyNE1O?=
 =?utf-8?B?Y0FKT3dJNFZXdDJyZFo4Zk1aN3c1NkJmK3hGMkFVaER2VzlDZ2VBMWlVVHd3?=
 =?utf-8?B?SVpKQVhRbENoMGVDMlpwTExadUpxbENIU1ZyeERLNG02QkhUcFpSWEZKTWFB?=
 =?utf-8?B?d1crd3dSaDAzZDhlYzF0WUswbUJoVkRSUmFtVnNTUmVLVHFvNDBrcWRmVkho?=
 =?utf-8?B?WTkyY0xDbEp5bmNmVTROeTdpZGtYUGh5dU9GRFJOYU9sSTNibEk4RHU4U0dy?=
 =?utf-8?B?dE9LTEVEcS9KNHFRNEMvd1JBaXhuTXR6eEZJUndGRkcyKzVGMjdhSFlHY2di?=
 =?utf-8?B?cG1nYzRuOFEyVkZQU0crcG9QS2VBNEJNOVlzZEhRMTYzZlp1MTJMQ0duTjc3?=
 =?utf-8?B?eVpOWDJkM3p4ZlN5aGZ4cUVMcGpFRS9CbVpqczgvYXF4L2cwUFBDL3pJMURM?=
 =?utf-8?B?SDZvajkyYmFWelhTMnJ2VEtsY0RMVklXcmpadnIxbnRRKzRvd1VGZjdDMUZS?=
 =?utf-8?B?MmZDdm5vVlFCVk1vMi8rc2lQLzBvME5QVFpLOFgxdklaZ2tkL280NVF6N0tV?=
 =?utf-8?B?Rnh4c3I2MUtTVWdndXBKQkdRencvQ1ZxZjN2NEk3WDJJOWZCUXhPMVVIYXZU?=
 =?utf-8?B?bXA3aENVeGlXRjZDMWVCdHN0MWdwb1RvVW80VkpzajBtL2Rpck90Q3ZiTitV?=
 =?utf-8?B?enJUVzlxUmxBL1YyMHdwQ0tSQ2lrZTJxQ29kbXNYUmVMRmxLYjZ1anBkYUo0?=
 =?utf-8?B?UzhmMzFBUlhWT1RPeVVQOHkydVRsNWVpRXZhVC9WbmxhYTE0dDlIOTJwdG9I?=
 =?utf-8?B?enZrdHlBRHEraGZmcDR1am9lV092SkY3Z3BwakZ4L3E1L2NnMFlNNXl5SFNB?=
 =?utf-8?B?djBaVU85OGptaVJkenZ4YjlyOWZrSGFDRXVpeTZLVkowOVNwbTFNOVlWc1By?=
 =?utf-8?B?MTIvbWxpcnMyNWp1L2c2YUE0OTdReE5vUGZCeWY1MEpCTVNncjZVR1NmeHdw?=
 =?utf-8?B?Z0UxdlJDL2tDKzlCdjArU2wwb0RibUY4Vm9VeTBJeEZFWlV1bmtuT25mM2xx?=
 =?utf-8?B?TnRMdng4aGV6ZkQ2Rkg4T0Exd1d6QjUxa1ZvYlRKSnB0MzBoZ0h1eUJaTGNC?=
 =?utf-8?B?Z2JqU1pYbUNHdWZzb0NydlEzL3lYM2NLYU4wUnNXMEY3TVFtODRiVTJrUjdN?=
 =?utf-8?B?SGdmWjR5Mnc5cjZNank1a3hkWjdaWGFmQzlFWnFlU3R2RDFUWUg4Q0lKejFs?=
 =?utf-8?B?elBkbGVzQk5zQTB6MmJvckVRb2dldUdFa0N1WWNUTnhpWkV1d3RrNkZwa01J?=
 =?utf-8?B?dEVDeThQUnFzNzhHQ3FwOXIyM1dHUVdBQlY4WEs5eVhKcWtOMVRpUS8zZmlH?=
 =?utf-8?B?RE5ITzcyS1FJS1lPM01TZi93USs2YlczTWpXdDJrajRqd0diOEhnV0VVUHd6?=
 =?utf-8?B?Q2pjOXhPbEovRkVteUs4NmZXaHlOdDIyRFlmZm5Kd0k0QmFCbkYzKzlpR3pW?=
 =?utf-8?B?TUUrcmtGWHpkQmtCUkxQNm5panNSQlZJblJjemhZeEF4KzBsY25Bc0VHNk1Q?=
 =?utf-8?B?SXQwbURnUHN1L2loOHZaekF1VFcvK3FGT1kxNGJHWXZMQ1RPRXdFYnIvSGwr?=
 =?utf-8?B?OENBd1lweWFNL0dlcndrc2EyQWUyb1J3b1hqTU1IVFgzQlBDSHBUcEJpdlQz?=
 =?utf-8?B?akZWUnRDRkdiZllNUnJ0SHl6d3RjamNNeUxhOXdadjJWcFZIa3VRZGV2dTZv?=
 =?utf-8?B?OVo0SUE2aSs0M3VKWUpEUGQzUTZOOWlyVHNKR0FSdEJwVjhCWU5rUURtdjNE?=
 =?utf-8?Q?kh98=3D?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SN6PR12MB2767.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 35e12a6f-c433-4a78-02d6-08da560dd61b
X-MS-Exchange-CrossTenant-originalarrivaltime: 24 Jun 2022 18:17:45.2379
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 6iJiaIWkikRBrypBftW2mO/k0PD1l6hT5QyrIpRoFmRaIt7BcNrPYUL8KUW02LCo75/yHUH65DVVfQhqngLxtw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN9PR12MB5384
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

W0FNRCBPZmZpY2lhbCBVc2UgT25seSAtIEdlbmVyYWxdDQoNCj4+ICtzdGF0aWMgaW50IHNucF9k
ZWNvbW1pc3Npb25fY29udGV4dChzdHJ1Y3Qga3ZtICprdm0pIHsNCj4+ICsgICAgICAgc3RydWN0
IGt2bV9zZXZfaW5mbyAqc2V2ID0gJnRvX2t2bV9zdm0oa3ZtKS0+c2V2X2luZm87DQo+PiArICAg
ICAgIHN0cnVjdCBzZXZfZGF0YV9zbnBfZGVjb21taXNzaW9uIGRhdGEgPSB7fTsNCj4+ICsgICAg
ICAgaW50IHJldDsNCj4+ICsNCj4+ICsgICAgICAgLyogSWYgY29udGV4dCBpcyBub3QgY3JlYXRl
ZCB0aGVuIGRvIG5vdGhpbmcgKi8NCj4+ICsgICAgICAgaWYgKCFzZXYtPnNucF9jb250ZXh0KQ0K
Pj4gKyAgICAgICAgICAgICAgIHJldHVybiAwOw0KPj4gKw0KPj4gKyAgICAgICBkYXRhLmdjdHhf
cGFkZHIgPSBfX3NtZV9wYShzZXYtPnNucF9jb250ZXh0KTsNCj4+ICsgICAgICAgcmV0ID0gc25w
X2d1ZXN0X2RlY29tbWlzc2lvbigmZGF0YSwgTlVMTCk7DQoNCj5EbyB3ZSBoYXZlIGEgc2ltaWxh
ciByYWNlIGxpa2UgaW4gc2V2X3VuYmluZF9hc2lkKCkgd2l0aCBERUFDVElWQVRFIGFuZCBXQklO
VkQvREZfRkxVU0g/IFRoZSBTTlBfREVDT01NSVNTSU9OIHNwZWMgbG9va3MgcXVpdGUgc2ltaWxh
ciB0byBERUFDVElWQVRFLg0KDQpZZXMsIFNOUF9ERUNPTU1JU0lPTiBhbHNvIG1hcmtzIHRoZSBB
U0lEIGFzIGludmFsaWQgYW5kIHJlcXVpcmUgYSBXQklOVkQvREZfRkxVU0ggYmVmb3JlIHRoZSBB
U0lEIGlzIHJlLXVzZWQvcmUtY3ljbGVkLCBzbyB3ZSBuZWVkIHRvIHByZXZlbnQgYWdhaW5zdA0K
REVDT01NSVNJT04gYW5kIEFTSUQgcmUtY3ljbGluZyBoYXBwZW5pbmcgYXQgdGhlIHNhbWUgdGlt
ZS4gQ2FuIHJldXNlIHRoZSBzYW1lIFJXU0VNIChzZXZfZGVhY3RpdmF0ZV9sb2NrKSBoZXJlIHRv
by4NCg0KVGhhbmtzLA0KQXNoaXNoDQoNCj4gKyAgICAgICBpZiAoV0FSTl9PTkNFKHJldCwgImZh
aWxlZCB0byByZWxlYXNlIGd1ZXN0IGNvbnRleHQiKSkNCj4gKyAgICAgICAgICAgICAgIHJldHVy
biByZXQ7DQo+ICsNCj4gKyAgICAgICAvKiBmcmVlIHRoZSBjb250ZXh0IHBhZ2Ugbm93ICovDQo+
ICsgICAgICAgc25wX2ZyZWVfZmlybXdhcmVfcGFnZShzZXYtPnNucF9jb250ZXh0KTsNCj4gKyAg
ICAgICBzZXYtPnNucF9jb250ZXh0ID0gTlVMTDsNCj4gKw0KPiArICAgICAgIHJldHVybiAwOw0K
PiArfQ0KPiArDQo+ICB2b2lkIHNldl92bV9kZXN0cm95KHN0cnVjdCBrdm0gKmt2bSkNCj4gIHsN
Cj4gICAgICAgICBzdHJ1Y3Qga3ZtX3Nldl9pbmZvICpzZXYgPSAmdG9fa3ZtX3N2bShrdm0pLT5z
ZXZfaW5mbzsNCg==
