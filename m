Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E937B5873A0
	for <lists+kvm@lfdr.de>; Mon,  1 Aug 2022 23:54:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235002AbiHAVyI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 1 Aug 2022 17:54:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47350 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230406AbiHAVyG (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 1 Aug 2022 17:54:06 -0400
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2048.outbound.protection.outlook.com [40.107.237.48])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 812363C8DC;
        Mon,  1 Aug 2022 14:54:02 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jegnGl9gBi+J+tQXD25WVk5Jd8d/afO9dD07+w7y2xoqV1gaCTyPCL7NzNqwp2Lf06xSdFLgiStfLoaFcfvXM9UnjRA3rHLLK5okyVMWAQjumT6vtU/+SJR1632fXThuS8wGyn7NM5xiTRmjO26VcnW+JoXUcDMGoedd2Qgr/z+uXvEpPtjYi7ebqESXKsdyz/fUWSsoroc+HUUoS5z5tm+YY7QCg56QQZeokJrykYvwaR56HbcjewYxq/c1fjjWY0xQM0r76rG/Yth0lYb7FPs199bEgJV9SSLLw2Vxh8219u/YvdpD8I0qN7kM5Bytl/yx/OgDDVlSjUlzPODYWg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=J2J8Pr/Q8mLiXZLEJdA45oBr7SrBSlf7YoXkfeVjOrU=;
 b=HVKCLKX90Z1hsatBYIEeuWeurSGunMOInA4fq0uSR5w4lUh5s6gNF3ZEuJUWzq+plPqchATXqnDScJMcogCG3ito1g1ZXmOZz/fqCA2R28aS3iArRK0nKVfmAKzIiAPJEHDWI6G++kS/b/+qyDKcKw6IOIBMpN5q13gcAv9/LTHzwneIImsymxHxyGOMiNqjvGx4eaUKGfBppQl5ufPm8YjdrpkQ6FrXGVwU+ygn3xhKW7B02cxS8pE86oNoGafEruu0B1BMsguaZ3sJqwFFvHe8fAEJWqDA50EqZsvIqaG2mKczXZ8HNQon3+fRRMLvy75aqRRO7E++ewYRw8e9Sw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=J2J8Pr/Q8mLiXZLEJdA45oBr7SrBSlf7YoXkfeVjOrU=;
 b=rMvmKdGWG5zRyV7iDx49JI6XeJUflx0FW6tapBSjN4qr7/TmaUFAY7bq+ilF4qF3SCXAF16c3ryrjtOm6xNEqJLTmsZwxNmEOkbUBm6ZCNjvvSA4j3jZNTyfhlFYvpWgLYIHMGpuCX8U8TxmQ7QvlSkgDcICtpSkCKlewYhoK1g=
Received: from SN6PR12MB2767.namprd12.prod.outlook.com (2603:10b6:805:75::23)
 by MN0PR12MB6343.namprd12.prod.outlook.com (2603:10b6:208:3c0::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5482.15; Mon, 1 Aug
 2022 21:53:59 +0000
Received: from SN6PR12MB2767.namprd12.prod.outlook.com
 ([fe80::8953:6baa:97bb:a15d]) by SN6PR12MB2767.namprd12.prod.outlook.com
 ([fe80::8953:6baa:97bb:a15d%7]) with mapi id 15.20.5482.016; Mon, 1 Aug 2022
 21:53:59 +0000
From:   "Kalra, Ashish" <Ashish.Kalra@amd.com>
To:     Borislav Petkov <bp@alien8.de>,
        Sean Christopherson <seanjc@google.com>
CC:     Dave Hansen <dave.hansen@intel.com>,
        "x86@kernel.org" <x86@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-coco@lists.linux.dev" <linux-coco@lists.linux.dev>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "jroedel@suse.de" <jroedel@suse.de>,
        "Lendacky, Thomas" <Thomas.Lendacky@amd.com>,
        "hpa@zytor.com" <hpa@zytor.com>,
        "ardb@kernel.org" <ardb@kernel.org>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
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
        "Roth, Michael" <Michael.Roth@amd.com>,
        "vbabka@suse.cz" <vbabka@suse.cz>,
        "kirill@shutemov.name" <kirill@shutemov.name>,
        "ak@linux.intel.com" <ak@linux.intel.com>,
        "tony.luck@intel.com" <tony.luck@intel.com>,
        "marcorr@google.com" <marcorr@google.com>,
        "sathyanarayanan.kuppuswamy@linux.intel.com" 
        <sathyanarayanan.kuppuswamy@linux.intel.com>,
        "alpergun@google.com" <alpergun@google.com>,
        "dgilbert@redhat.com" <dgilbert@redhat.com>,
        "jarkko@kernel.org" <jarkko@kernel.org>
Subject: RE: [PATCH Part2 v6 05/49] x86/sev: Add RMP entry lookup helpers
Thread-Topic: [PATCH Part2 v6 05/49] x86/sev: Add RMP entry lookup helpers
Thread-Index: AQHYhkJMEjVRVcpx502HVSPCQUlAqK1bejcAgAACPYCAAD2E8IAAAkWAgAAEHtCAAALbAIAAEKeAgAACGACAAAZmMIABummAgAABGvCALNnqAIAAfWiAgAAF14CAAAOTAIAP3LBQ
Date:   Mon, 1 Aug 2022 21:53:59 +0000
Message-ID: <SN6PR12MB2767B2C4255B583D59F102268E9A9@SN6PR12MB2767.namprd12.prod.outlook.com>
References: <BYAPR12MB27595CF4328B15F0F9573D188EB29@BYAPR12MB2759.namprd12.prod.outlook.com>
 <99d72d58-a9bb-d75c-93af-79d497dfe176@intel.com>
 <BYAPR12MB275984F14B1E103935A103D98EB29@BYAPR12MB2759.namprd12.prod.outlook.com>
 <5db37cc2-4fb1-7a73-c39a-3531260414d0@intel.com>
 <BYAPR12MB2759AA368C8B6A5F1C31642F8EB29@BYAPR12MB2759.namprd12.prod.outlook.com>
 <YrTq3WfOeA6ehsk6@google.com>
 <SN6PR12MB276743CBEAD5AFE9033AFE558EB59@SN6PR12MB2767.namprd12.prod.outlook.com>
 <YtqLhHughuh3KDzH@zn.tnic> <Ytr0t119QrZ8PUBB@google.com>
 <Ytr5ndnlOQvqWdPP@zn.tnic> <Ytr8nCL6pa2Q1kWy@zn.tnic>
In-Reply-To: <Ytr8nCL6pa2Q1kWy@zn.tnic>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: MSIP_Label_4342314e-0df4-4b58-84bf-38bed6170a0f_Enabled=true;
 MSIP_Label_4342314e-0df4-4b58-84bf-38bed6170a0f_SetDate=2022-08-01T21:51:50Z;
 MSIP_Label_4342314e-0df4-4b58-84bf-38bed6170a0f_Method=Standard;
 MSIP_Label_4342314e-0df4-4b58-84bf-38bed6170a0f_Name=General;
 MSIP_Label_4342314e-0df4-4b58-84bf-38bed6170a0f_SiteId=3dd8961f-e488-4e60-8e11-a82d994e183d;
 MSIP_Label_4342314e-0df4-4b58-84bf-38bed6170a0f_ActionId=e0ffee26-f59e-43f5-adda-9679c3b2ebc7;
 MSIP_Label_4342314e-0df4-4b58-84bf-38bed6170a0f_ContentBits=1
msip_label_4342314e-0df4-4b58-84bf-38bed6170a0f_enabled: true
msip_label_4342314e-0df4-4b58-84bf-38bed6170a0f_setdate: 2022-08-01T21:53:57Z
msip_label_4342314e-0df4-4b58-84bf-38bed6170a0f_method: Standard
msip_label_4342314e-0df4-4b58-84bf-38bed6170a0f_name: General
msip_label_4342314e-0df4-4b58-84bf-38bed6170a0f_siteid: 3dd8961f-e488-4e60-8e11-a82d994e183d
msip_label_4342314e-0df4-4b58-84bf-38bed6170a0f_actionid: 6fa08b8c-03c0-4bd2-af5b-2cd5af350371
msip_label_4342314e-0df4-4b58-84bf-38bed6170a0f_contentbits: 0
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 8d26a7f8-da80-4263-bc74-08da740856f5
x-ms-traffictypediagnostic: MN0PR12MB6343:EE_
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: z2nASBrn22dHqS4NQaa72X9TZ/MPmeBXi/NkqIzk/xlg37Dbz8FlDnwO8QCtTFDsP3zxuiCnTRo1YAho7vw3TljTsSANx5AsFYrtkf8GQy9/A32rw8b5xt/gndLKB48GQDts96KZQjWDZUdIFvRAIxQKFeHNRWUWPpm+AxLE3FQ960hb2IrZct/IrrDDNudSoHFgXVbCfy3frQPQq3Bz2+ReHxb/MWxwfY44Ciurl6QERjL6P06A84ANv1KXIC+nTn3oM01WtPmlckFOSSt45feuAST/XO1cYDYFrsKMPqjqc4eTlRhzJYrnRB+jTb50QUVLe9FIGwrn9J9p7ImpDBRNqf7Qu92pMWovHl4fMckKPplgCwuqT5jCMikC7XcTymJxd3otwENLGyCmZq+/GBZO25/DEfS5XbSbXLlQBBl76/4JHX1kuDcQ6TZAW49iUGrMxjayYKGNnKXDPtMQ4CPrr5H6eZtua6+Ovh0+ir+KMhAhnSV99HRBdxxDPNEgY2vS3nY8RHWFrnCVYAQbA2vnZUvwEIEOMjRCjl/p++ojHk9mo1JEQBWaACtEtzHJo+aJ3SmL0nzxK/9J82te0JRd+B1/KEB7nrLDJl6AP+igQIhEeG3Zc4Gbd5CzbuEupoKaFQV1i5IlzMbDuV4Iuj5JrACOJFQR1kAjU/z9zDUx0/flUG61vyFjHnDTyc0Nbvpm4htkQpDm0lX10hoWx8jYywnO9hoLRTXKKpDviBj7NxzhEpzsLBaiQCqyspRjE27qBOz3GNDn5oZfIOOCnx3tc3TUIjqEfc8mUGrfyGKvMSEXl1f0fuRw0wf1wFQFWwRllajU2dYAfp1Nav/D7Q==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR12MB2767.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(346002)(396003)(136003)(39860400002)(376002)(366004)(2906002)(966005)(45080400002)(8676002)(4326008)(55016003)(66446008)(64756008)(86362001)(71200400001)(33656002)(478600001)(26005)(54906003)(6506007)(316002)(41300700001)(66476007)(110136005)(38070700005)(38100700002)(9686003)(53546011)(186003)(66946007)(76116006)(122000001)(52536014)(66556008)(5660300002)(8936002)(7416002)(7406005)(7696005)(83380400001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?MEaNKB/cuHtoize0wubw9N62/8mXA1ET4PLVtxpaCe/O+f4TgXp3mwGSPZmQ?=
 =?us-ascii?Q?G4aP1yM9wJFKM5CBqgvoznplDo+WtZLYTQfRBZfxiIF1Q0A+X9N9zW/jLpO3?=
 =?us-ascii?Q?T64la+UQ+q8Vomse/7Ate/TlsMUqerbkcJuy7Ss/yKgjrA8LxSh/zJAQNfQX?=
 =?us-ascii?Q?ToR0j3P2bfSG1mepL19qj7fh5m8aVVKmFurk6/73MYDVnjqRWO37BaL5X45X?=
 =?us-ascii?Q?jPXOAIXD2NqQ13T33cdEEOzh4v1kheTTNg9OYREwp9CgEOxBCalDGPaw2WZq?=
 =?us-ascii?Q?MghXNd+JYjhDlLU6cSNhqYefDCfIrx83wMH7RtWAu7EeTmBKaML/uy8vZ4ok?=
 =?us-ascii?Q?O0Yx/pd5k4u0xEQGkM3QPPSiZ/tP6P2B0+/ji9lxSpi2NMasy1j45oEe3+NA?=
 =?us-ascii?Q?oafJX304NYr32oMTuvS8AKEm5TQHnr5AGKr+o//A6TL2G45e/hNanQ0A81Te?=
 =?us-ascii?Q?kD+T0nlqq6HaiLq22V8BGpnYoxhisoqif2nh8h++KtnlVbu3namTasZcR6/6?=
 =?us-ascii?Q?4xO8c4r0qSiNseCdhuL/KaHgJYcSW8lmBeNg4gtwBT6tyAAnpuNAwAMA+ZHs?=
 =?us-ascii?Q?79egDD+KSJY2GWg2WSKkIDUsQtv6TBD0AEmGAJQ1YOqkESOHDgFuP9XsprJU?=
 =?us-ascii?Q?VDUjux1nlBnmY2Nx0viTLV066DjhUPZvlQvBLmYUEyjiIH3/9Unl0fZLOcvZ?=
 =?us-ascii?Q?lw3K8sFpYN9KHG9IQAQaZuC6+Rb4eSPMT9eEiNgkYnXKIlhmNuiS1Apj0bue?=
 =?us-ascii?Q?GkO+UOFUEX/S2h9ezOkB8UKD4eaPCE8M8EPnZDoO/Ar3VzGBYmK4EiQmINO9?=
 =?us-ascii?Q?Q23ixmHcsNTwBHpN9Ju5J2yMaGszkQ2h8gF0LKr0lQ+5c8eBgLiJDlOM0Q7r?=
 =?us-ascii?Q?ypp55VD5ONV6Uie9BuUXHbVVxIUwJmGi44qxsjAlwFMHJfTToivQhZWzDJXa?=
 =?us-ascii?Q?nlwaMO8e/gqGSg4u1JC67MRLNmCqPhCsW2iCc4DnYZf1eOFJjF0z87Yv8uCg?=
 =?us-ascii?Q?DeLISrhz/uTjs9fPljQ9pNgxTpnHNvBPTuMBUr5m42pbp7/T5zCzjclomMdO?=
 =?us-ascii?Q?/dFtytYhZgl3wPfXcOjwvQMUnsEUZZej6GtMh3Ik5QbmJFguQtOo+ZMxzeXk?=
 =?us-ascii?Q?ewPsG5wtMlAm46Qz62YGdtFbzNqBvbO/4YmhB7y0QLT6W4i9ySsU/WjWjKSG?=
 =?us-ascii?Q?OtVSH2Jjmog4pzxs9HyZKCDzBJV2WDTRHN6rcrPPcCWMCfa1uOQdRo6CGly7?=
 =?us-ascii?Q?ieHuHEANc2TRa/h1hLuxr080ilTs6lGUsjEUeTJyo4ozwHhjeRJTzSRViXXa?=
 =?us-ascii?Q?BnbkZvppXiq7MkM55HO2a3dGwtP8wuITaymi4ClrAq91SzRN6rTc/pGTrZBp?=
 =?us-ascii?Q?3ORlDPRQgFfgzI1CMyybKce5WO7nhi6pCr1uwKl95Kr6enlloAo0zpd0ExSL?=
 =?us-ascii?Q?M+Mum4V6kyS+bK1hAeNU5k7325sOUczzxNuGwvZBbjRLfqi2rIV6KmJsl+Zx?=
 =?us-ascii?Q?mNS/7E8Z9vm01IvS6ywD42wsLAFkfm0Lakv4Ae/EUcX4xd0sZmyp3J/U2NpS?=
 =?us-ascii?Q?Jb6AUVlV53MYiX7yQwg=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SN6PR12MB2767.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8d26a7f8-da80-4263-bc74-08da740856f5
X-MS-Exchange-CrossTenant-originalarrivaltime: 01 Aug 2022 21:53:59.3383
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: hatC2jMXMVbzpuCz1bO7U5bs5/8daMCKHepkTkbEUgTTsTWQ5xxI34IUJ2Ya7F39qpbtGC29iuRiqkPiHzLpnQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN0PR12MB6343
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

[AMD Official Use Only - General]

As I mentioned before, in the future we will have architectural support to =
read RMP table entries, we will first check for
availability of this feature and use it always if it is supported and enabl=
ed, and only fallback to doing raw RMP table access
if this architectural support is not available.

Thanks,
Ashish

-----Original Message-----
From: Borislav Petkov <bp@alien8.de>=20
Sent: Friday, July 22, 2022 2:38 PM
To: Sean Christopherson <seanjc@google.com>
Cc: Kalra, Ashish <Ashish.Kalra@amd.com>; Dave Hansen <dave.hansen@intel.co=
m>; x86@kernel.org; linux-kernel@vger.kernel.org; kvm@vger.kernel.org; linu=
x-coco@lists.linux.dev; linux-mm@kvack.org; linux-crypto@vger.kernel.org; t=
glx@linutronix.de; mingo@redhat.com; jroedel@suse.de; Lendacky, Thomas <Tho=
mas.Lendacky@amd.com>; hpa@zytor.com; ardb@kernel.org; pbonzini@redhat.com;=
 vkuznets@redhat.com; jmattson@google.com; luto@kernel.org; dave.hansen@lin=
ux.intel.com; slp@redhat.com; pgonda@google.com; peterz@infradead.org; srin=
ivas.pandruvada@linux.intel.com; rientjes@google.com; dovmurik@linux.ibm.co=
m; tobin@ibm.com; Roth, Michael <Michael.Roth@amd.com>; vbabka@suse.cz; kir=
ill@shutemov.name; ak@linux.intel.com; tony.luck@intel.com; marcorr@google.=
com; sathyanarayanan.kuppuswamy@linux.intel.com; alpergun@google.com; dgilb=
ert@redhat.com; jarkko@kernel.org
Subject: Re: [PATCH Part2 v6 05/49] x86/sev: Add RMP entry lookup helpers

Btw,

what could work is to spec only a *version* field somewhere in the HW or FW=
 which says which version the RMP header has.

Then, OS would check that field and if it doesn't support that certain vers=
ion, it'll bail.

I'd need to talk to folks first, though, what the whole story is behind not=
 spec-ing the RMP format...

--
Regards/Gruss,
    Boris.

https://nam11.safelinks.protection.outlook.com/?url=3Dhttps%3A%2F%2Fpeople.=
kernel.org%2Ftglx%2Fnotes-about-netiquette&amp;data=3D05%7C01%7CAshish.Kalr=
a%40amd.com%7Cfc8ed4feddb346bbae8a08da6c19b7d6%7C3dd8961fe4884e608e11a82d99=
4e183d%7C0%7C0%7C637941154968117489%7CUnknown%7CTWFpbGZsb3d8eyJWIjoiMC4wLjA=
wMDAiLCJQIjoiV2luMzIiLCJBTiI6Ik1haWwiLCJXVCI6Mn0%3D%7C3000%7C%7C%7C&amp;sda=
ta=3DkhiE7a%2FAW8C%2B0RilZHWxGvMtnlQkDTlC5UtU8Q3L1Lo%3D&amp;reserved=3D0
