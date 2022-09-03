Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6E58B5ABD8C
	for <lists+kvm@lfdr.de>; Sat,  3 Sep 2022 08:57:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232089AbiICG54 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 3 Sep 2022 02:57:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42538 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229603AbiICG5y (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 3 Sep 2022 02:57:54 -0400
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2071.outbound.protection.outlook.com [40.107.243.71])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 585ADDB071;
        Fri,  2 Sep 2022 23:57:53 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Rx7mFnDb1d4KND+5dMpxylANC6B0nJf0PXcVRIbXX496S/1/KM8t4IRceLtCjjRzhoxFevmMXL+3vs68f9TMVllD3oZw2p0x03eSvANs7R0F0oVtxZnjQXOkWVOOUDjJbhyRB2vGF2unFk0HIhtjGRPnfnM+bNH2m2zaNg4R3amivhtaZY6dqioo8pa6gNn+tCyK1a5ufMKe0PIQAR100M7YP5ZT/mCQgKSXUUUgNgZO4e0V1uazl4zgQbL6LK73459zXOeZCxO7se7l9pK6hI00QOVdocfhadxPB+9T4H8Ku6PllZGmzc2YG9fgrgA/wfmLfKzEh33mYGkcJ+MhqQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=xSTnuBXBTo0ixf6m5pMz225K55b8AnLUT3WCrTOqxL0=;
 b=J5go0XvBcYijv/IU8VlKoDXoxrFLFtG+pnLwTzNCMNt3MfvTutu2daoTLnA9WOZ40fyAUj4ZFQuhFS2LUPe0aKlOf16bJ0yFDaYjBkCtigkz27HTY6MkcOQMRG4gUf2juNUI3fQH2XXzqYUc1n5QGwpt4AUIh6nJQVo3oNNbtFpuMxN3e6xNVn7Xr6TMWz76aNMJND8mxj1KTxzGmjsX0mqIprk1rYqex59r/ED2/Y1AqSQ1bhQo/Rcj2FmzR+R+A77vx6waPVp/cy9a3x4AEhTEaMgVNo5aEc6GpevcPyVswdJCYSZf/JEehYHwAdVSxO3RHzNFdoV1vkJ2TPNNYw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xSTnuBXBTo0ixf6m5pMz225K55b8AnLUT3WCrTOqxL0=;
 b=VO+waheNiOE5tRLnC/2zMx7GOOag7joyhTcudJBrn3NeSHzQWYCylyh1zE7hiqDcfMDFGkRAnawgM39w4wg0OBpE01jdnhTk8s/cjtcBtLlHNVIAkUuqY6BrI7dpoknZfHIZ/C9ekzdzSnL32C4m580k3h8BmoMLT+wig+xSVMg=
Received: from SN6PR12MB2767.namprd12.prod.outlook.com (2603:10b6:805:75::23)
 by CH2PR12MB4907.namprd12.prod.outlook.com (2603:10b6:610:68::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5588.10; Sat, 3 Sep
 2022 06:57:51 +0000
Received: from SN6PR12MB2767.namprd12.prod.outlook.com
 ([fe80::e47d:1a95:23d5:922c]) by SN6PR12MB2767.namprd12.prod.outlook.com
 ([fe80::e47d:1a95:23d5:922c%7]) with mapi id 15.20.5588.010; Sat, 3 Sep 2022
 06:57:51 +0000
From:   "Kalra, Ashish" <Ashish.Kalra@amd.com>
To:     Borislav Petkov <bp@alien8.de>
CC:     "x86@kernel.org" <x86@kernel.org>,
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
Subject: RE: [PATCH Part2 v6 09/49] x86/fault: Add support to handle the RMP
 fault for user address
Thread-Topic: [PATCH Part2 v6 09/49] x86/fault: Add support to handle the RMP
 fault for user address
Thread-Index: AQHYrBDc30zm/ve2UUW13wSedLDd3a2nIMnggADB+gCAAMFX8IAieiDAgAC6pgCAAI/o0IAA2YMAgAAD/sCAACPGEA==
Date:   Sat, 3 Sep 2022 06:57:51 +0000
Message-ID: <SN6PR12MB2767074DEB38477356A3C0F98E7D9@SN6PR12MB2767.namprd12.prod.outlook.com>
References: <cover.1655761627.git.ashish.kalra@amd.com>
 <0ecb0a4781be933fcadeb56a85070818ef3566e7.1655761627.git.ashish.kalra@amd.com>
 <YvKRjxgipxLSNCLe@zn.tnic>
 <SN6PR12MB2767322F8C573EDFA1C20AD78E659@SN6PR12MB2767.namprd12.prod.outlook.com>
 <YvN9bKQ0XtUVJE7z@zn.tnic>
 <SN6PR12MB2767A87F12B8E704EB80CC458E659@SN6PR12MB2767.namprd12.prod.outlook.com>
 <SN6PR12MB27672B74D1A6A6E920F364A78E7B9@SN6PR12MB2767.namprd12.prod.outlook.com>
 <YxGoBzOFT+sfwr4w@nazgul.tnic>
 <SN6PR12MB2767E95BA3A99A6263F1F9AE8E7A9@SN6PR12MB2767.namprd12.prod.outlook.com>
 <YxLXJk36EKxldC1S@nazgul.tnic>
 <SN6PR12MB276767FDF3528BC1849EEA0A8E7D9@SN6PR12MB2767.namprd12.prod.outlook.com>
In-Reply-To: <SN6PR12MB276767FDF3528BC1849EEA0A8E7D9@SN6PR12MB2767.namprd12.prod.outlook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: MSIP_Label_4342314e-0df4-4b58-84bf-38bed6170a0f_Enabled=true;
 MSIP_Label_4342314e-0df4-4b58-84bf-38bed6170a0f_SetDate=2022-09-03T04:39:53Z;
 MSIP_Label_4342314e-0df4-4b58-84bf-38bed6170a0f_Method=Standard;
 MSIP_Label_4342314e-0df4-4b58-84bf-38bed6170a0f_Name=General;
 MSIP_Label_4342314e-0df4-4b58-84bf-38bed6170a0f_SiteId=3dd8961f-e488-4e60-8e11-a82d994e183d;
 MSIP_Label_4342314e-0df4-4b58-84bf-38bed6170a0f_ActionId=1c6ccf56-f98c-4d76-9ac2-26a3a8c29d20;
 MSIP_Label_4342314e-0df4-4b58-84bf-38bed6170a0f_ContentBits=1
msip_label_4342314e-0df4-4b58-84bf-38bed6170a0f_enabled: true
msip_label_4342314e-0df4-4b58-84bf-38bed6170a0f_setdate: 2022-09-03T06:57:48Z
msip_label_4342314e-0df4-4b58-84bf-38bed6170a0f_method: Standard
msip_label_4342314e-0df4-4b58-84bf-38bed6170a0f_name: General
msip_label_4342314e-0df4-4b58-84bf-38bed6170a0f_siteid: 3dd8961f-e488-4e60-8e11-a82d994e183d
msip_label_4342314e-0df4-4b58-84bf-38bed6170a0f_actionid: e6b3cb5a-4cff-4e33-89b2-32f2348ae9d3
msip_label_4342314e-0df4-4b58-84bf-38bed6170a0f_contentbits: 0
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: de446a82-db50-425c-8798-08da8d799e32
x-ms-traffictypediagnostic: CH2PR12MB4907:EE_
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: MQMlNnnLSfJmzBAxUC+j8NpJIKB2I8bMEhnced6STIvGVY+K8Lqmh5n4PeEDWA9waFP67E+XxmKzT2zbl6zerWwZYXaoCG4X3qBr5MIv2qFhTMdBQ5lkyYC7mIjJCmoJX0Cg4n/LMnCNHbYoxpWQjJkbyNB/K1mJHNQtrPU3TgSXSNTvhH4lr30Fna7fjQlLd1fvUxuUKZjKjGHES70WsPHuC08FI5kcIR5ejMPeDIqWiqNtO5JwHpFUs60AkqQno10T+LqxqgEZDCmpCX4Bnl7Po4RKrGjzt8MKRokDehQBWPMFSkNrs+YLgieveAm57lZTpD2TqGJecx3jgwWfJka3hoEGLKay65oiHEQf7F3HJcn6FPxzioaxsC/A0zNpZK2zpySfHa4IepllfnqAMstnWALDy4tHcA74vVYSHU2A5f/7qCE1MvErKqzZhsizTkBX4+9+ORlyXRZAJUAMHtWlKqPITRN5ax7U2w4wc9gZBMkYyk61e0NEv0Y9WMjaYyMVR86ASeRHlFNgCzyErUz8x2bqaiZ6ewrSs4/fVdBssub5wLRYbxDJQKxSgdZRD3r9KejFJnYgrfQobmX5YV3V01iHJt7gYJpotdHHLW+SZkBRAOWdP4jWzf/bX/eQs2QI7ls+9JpAFn7zBzDHaG4gzSmC3tNrdTtRzSdFUEgkA6pQhk6uivJATeS3GXTOffEZkfMyZ1Lx01mFr38Uah02iOJVzkljQj4UcgCdVdKDSJqAvsnlcS1dn2pSthb6+tmX0siyPBITms7kYECrTQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR12MB2767.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(39860400002)(366004)(396003)(376002)(346002)(136003)(38070700005)(38100700002)(122000001)(55016003)(4326008)(8676002)(66946007)(66556008)(66476007)(66446008)(64756008)(76116006)(316002)(54906003)(6916009)(2906002)(7416002)(7406005)(5660300002)(52536014)(8936002)(83380400001)(53546011)(26005)(2940100002)(9686003)(186003)(71200400001)(7696005)(6506007)(478600001)(41300700001)(33656002)(86362001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?s+CvDkW19+ZKuwdO48N20tBHVfz4Ifx1TfMOhYGYJXlC4z83seq63ta0UF87?=
 =?us-ascii?Q?bAiWoSHQL2MF8JSXiFbT68V38hiLH3SyhAFdnbr30WyE8X/vOYledQFBuhKw?=
 =?us-ascii?Q?e4GLLsiv1oKcnsUbLkcr/+Hd/3pO0D5IR0SUQ/c0CekrfD89oC1b3YD0x2SN?=
 =?us-ascii?Q?GSrrL3h27J581noTRXboRo+PgMkPlWDdp1j6dX3wS+mmxQir4mkVvFHRAlt+?=
 =?us-ascii?Q?Dg37/Uo3l/zZo3xQsbajClAp2GHjiYhS0TD7Dg7tVmTC3O4A/CD7LbS7g3L0?=
 =?us-ascii?Q?jM9bz5IQD7whMNU7RPVeFcURfTvNwPkq64pG4Rn+Sw9Y4l8W7wzlM+Ps1hY/?=
 =?us-ascii?Q?4UDDeHaotiMghhoGhD283JpnQlbTyXqGr4DPJ2MLpJo8si8CxJyEWA9aVhBo?=
 =?us-ascii?Q?KpxUvOKpJ2watZTwQaOeL5vyzQyGsa+pnE4hJDIqTZXST9Ee7+fDEvv9ZI9M?=
 =?us-ascii?Q?AV8vNKesIEHcmiazzV7BT01Falv7M0eoBqz/LaENmJ7NNm4yS+0gmO/nu/Ul?=
 =?us-ascii?Q?0+ifFwjEeVJi1cio/8ZGWXoXT9cjfVBvW6ZMYbcaijchG3hrJAHJUPS+B+nA?=
 =?us-ascii?Q?gDUnHo/YxlZ6+1hLNZGYbKs9VKL1rp013qICtOTeHWxN0XqkNezoOilFE7Yw?=
 =?us-ascii?Q?1XkvDc1FrB5ARfqNgfictf7dv/U8vcG+JnOzgn9qvrgJyHeNYhPyRj4j23v2?=
 =?us-ascii?Q?e7AMr2LezbYjYiotJEY0fABnrJwoUOnmlNpYNRTzBH+aOYPk5O8+Z8lSf/aC?=
 =?us-ascii?Q?h/qaZVQDq00a2U4i0DO+6gnuvXnN5vzsccmaZilQffdfoWe3Hy9Mzf4PTnTl?=
 =?us-ascii?Q?qtDnRRF+KdERVXJysgly9q8wE2Rb8vBKPL5f4yAtN7Ev4Jny99uSGbXvTszt?=
 =?us-ascii?Q?5WttalZnT03h/Rf/Z3m1Ghe4WELP2Z9hIG3dlIBdjvMcaLSfAroyg0aFY4hp?=
 =?us-ascii?Q?bY8xsNHetTdN9mVUtjN/eB+JK0eMUpyrHDMRTY8ldxfJGzhiweHuxzP/cA0s?=
 =?us-ascii?Q?rmkdfzBHBPvzry7UE1PP8TxikE1fZKOcpp9oBpwOZ45fGeJtJrOWT3BEMwOv?=
 =?us-ascii?Q?ZEyypwdO9Ds+lexltHBiI0S52X2wjAXBrMjPmMEAQW1t5dqV3YfKlKwG0Gn/?=
 =?us-ascii?Q?a+P/eZie4PpjfchYyiMuOExjw4rIWkb+HGMoDwEOfqVv/wuH4QWT8WUbP4zA?=
 =?us-ascii?Q?642iEmxuY8sDJNqDIckza/MyAtCZ2ISm5RyUCK0UXSvUXTCX2Xd7XUyKkM4V?=
 =?us-ascii?Q?eAOTucIXC/kKCsat4+FMBy3+gRuoITHHc84ob5BpPKk5B5LXH60nHixa4hdj?=
 =?us-ascii?Q?LFr3A6cIEQtugalOUwldmUTtfMZHSPB4GpdrpKYj5BUFsdnPbj3QYPR5Qa9y?=
 =?us-ascii?Q?iv6vKzR6RQG5JExkilbPbjVs1ToXxvfxuOLq3hwrpMJx7YHtd8Nz0bIsvTPG?=
 =?us-ascii?Q?782ttJrzS54/U2K7JTGqsD6B9ljjMVzkVjVP7CvuRAvWXagiAh9MzPiOVi/R?=
 =?us-ascii?Q?Q30kHZcizUUywEiHmJwQpfleIcFVthataMmwZWbS0n1Vd0i1gGE+7K/r5wf3?=
 =?us-ascii?Q?TR0ANNfm0gyqEFlC2To=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SN6PR12MB2767.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: de446a82-db50-425c-8798-08da8d799e32
X-MS-Exchange-CrossTenant-originalarrivaltime: 03 Sep 2022 06:57:51.0704
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Iy8wgMzkBKr9z8wjl+JPSHSEmHJXFhpGc1kI/pqgGRQA+ChhObUe1RK68mkcwJ11nLU3UvhC4/BdImGUq+QxUA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR12MB4907
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

[AMD Official Use Only - General]

So essentially we want to map the faulting address to a RMP entry, consider=
ing the fact that a 2M host hugepage can be mapped as=20
4K RMP table entries and 1G host hugepage can be mapped as 2M RMP table ent=
ries.

Hence, this mask computation is done as:
mask =3D pages_per_hpage(level) - pages_per_hpage(level -1);

and the final faulting pfn is computed as:
pfn |=3D (address >> PAGE_SHIFT) & mask;
     =20
Thanks,
Ashish   =20

-----Original Message-----
From: Kalra, Ashish=20
Sent: Saturday, September 3, 2022 12:51 AM
To: Borislav Petkov <bp@alien8.de>
Cc: x86@kernel.org; linux-kernel@vger.kernel.org; kvm@vger.kernel.org; linu=
x-coco@lists.linux.dev; linux-mm@kvack.org; linux-crypto@vger.kernel.org; t=
glx@linutronix.de; mingo@redhat.com; jroedel@suse.de; Lendacky, Thomas <Tho=
mas.Lendacky@amd.com>; hpa@zytor.com; ardb@kernel.org; pbonzini@redhat.com;=
 seanjc@google.com; vkuznets@redhat.com; jmattson@google.com; luto@kernel.o=
rg; dave.hansen@linux.intel.com; slp@redhat.com; pgonda@google.com; peterz@=
infradead.org; srinivas.pandruvada@linux.intel.com; rientjes@google.com; do=
vmurik@linux.ibm.com; tobin@ibm.com; Roth, Michael <Michael.Roth@amd.com>; =
vbabka@suse.cz; kirill@shutemov.name; ak@linux.intel.com; tony.luck@intel.c=
om; marcorr@google.com; sathyanarayanan.kuppuswamy@linux.intel.com; alpergu=
n@google.com; dgilbert@redhat.com; jarkko@kernel.org
Subject: RE: [PATCH Part2 v6 09/49] x86/fault: Add support to handle the RM=
P fault for user address

[AMD Official Use Only - General]

Hello Boris,

>> Yes we want to map the faulting address to a RMP entry, but hugepage=20
>> entries in RMP table are basically subpage 4K entries. So it is a 4K=20
>> entry when the page is a 2M one and also a 4K entry when the page is=20
>> a 1G one.

>Wait, what?!

>APM v2 section "15.36.11 Large Page Management" and PSMASH are then for wh=
at exactly?

This is what exactly PSMASH is for, in case the 2MB RMP entry needs to be s=
mashed if guest PVALIDATES a 4K page, the HV will need to PSMASH the 2MB RM=
P entry to corresponding 4K RMP entries during #VMEXIT(NPF).

What I meant above is that 4K RMP table entries need to be available in cas=
e the 2MB RMP entry needs to be smashed.=20

>> That's why the computation to get a 4K page index within a 2M/1G=20
>> hugepage mapping is required.

>What if a guest RMP-faults on a 2M page and there's a corresponding 2M RMP=
 entry? What do you need the 4K entry then for?

There is no fault here, if guest pvalidates a 2M page that is backed by a 2=
MB RMP entry.
We need the 4K entries in case the guest pvalidates a 4K page that is mappe=
d by a 2MB RMP entry.

>Hell, __snp_lookup_rmpentry() even tries to return the proper page level..=
.

>/me looks in disbelief in your direction...

Thanks,
Ashish
