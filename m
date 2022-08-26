Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 61BE05A2F6D
	for <lists+kvm@lfdr.de>; Fri, 26 Aug 2022 20:58:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345416AbiHZS5W (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 26 Aug 2022 14:57:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51338 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344628AbiHZS5G (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 26 Aug 2022 14:57:06 -0400
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2052.outbound.protection.outlook.com [40.107.93.52])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 91ECFE992A;
        Fri, 26 Aug 2022 11:54:18 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=kwyKXSAf6QciXywyKla37NH02WqNYzeDjVYAqK7iR7UL3qTQ4OmBnlaBQoZa81bZQ8Kk3jbBKqjHXDC3r/VVm+ATDakVUcZSJhFxvRRap5lR+HUAEFLpKb/7Pu6fNw4Yz8RQF/xhbb78WDA+00OzgpuVUsHiJwn2/qgGJBmyh+YE2XmMYhJcBus/vWFbvFkK78KszOB/QsM6byymKoojgFs2lmQKAoUDLo70LjtK1hl2MjPywk39zLCRPbI7G54YFpfs8DfgMnGRdCVkDamV8/1G0vzL6EopyCCjnl73FXxQIoezzYZ/okoDS8vsp+jzxmSmds0PsZ9XS4JVnMKsYQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=gneMpFXbSfSSGxFzBh6BzQ8YVboIqIR9/wGD3KPAYGI=;
 b=fm2uGlp+plueiGUoDnmIInFAu7bxKzYdwydLfu44Wowj3KSaEgU3tB7h2q+Z90cbAp1pvtbpRIW3xm67m0W3N8qYlAsMAx+hlgn19TXciCP+08QH96LAci2OBXeFRYPoQmAO8cS4qyZx3AFRb1e1UOKDVDx3LKQRNk1v/6/O5qP6PX8L6xQfSPfEIthdzZi2rZEhhOOq2CFw7NQNhc68YOj6hjiCJseDLQ9h4biNDYxl399/Vo2WS7YYjTPQ8T+jap4YEzQp3Yzi58iYQRTQXeT9s5xMn6teT5GxhSVLesnAObyK7VyWzf8nZ1k63eCrmoyG8PiTmODuhA148qc0Sw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=gneMpFXbSfSSGxFzBh6BzQ8YVboIqIR9/wGD3KPAYGI=;
 b=tY/cFMmXGrMVLcDki9VsR+cpnqO8Ahkk1DksgG7j6IFKQgA63ia78HXGi5wDb9XrHjom/qJPHTreAGbrXdeYOUQozAPhN6QldlI3K3n8X0mrU51ZOGdCFiIjGF7XNuPAN6S0+tq7fMJJMpwaWfBsIz0LBIC2lzRnfElm39HjH0I=
Received: from SN6PR12MB2767.namprd12.prod.outlook.com (2603:10b6:805:75::23)
 by BL1PR12MB5334.namprd12.prod.outlook.com (2603:10b6:208:31d::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5566.15; Fri, 26 Aug
 2022 18:54:16 +0000
Received: from SN6PR12MB2767.namprd12.prod.outlook.com
 ([fe80::fc65:3a28:fdd0:ce9f]) by SN6PR12MB2767.namprd12.prod.outlook.com
 ([fe80::fc65:3a28:fdd0:ce9f%7]) with mapi id 15.20.5566.015; Fri, 26 Aug 2022
 18:54:16 +0000
From:   "Kalra, Ashish" <Ashish.Kalra@amd.com>
To:     Jarkko Sakkinen <jarkko@kernel.org>,
        Peter Gonda <pgonda@google.com>
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
        "Dr. David Alan Gilbert" <dgilbert@redhat.com>
Subject: RE: [PATCH Part2 v6 02/49] iommu/amd: Introduce function to check
 SEV-SNP support
Thread-Topic: [PATCH Part2 v6 02/49] iommu/amd: Introduce function to check
 SEV-SNP support
Thread-Index: AQHYhYN//Jq12JdNiEyvNHxMVTEAQ61aILsggAADK4CAZRTwgIAAAKeAgAK0CKA=
Date:   Fri, 26 Aug 2022 18:54:16 +0000
Message-ID: <SN6PR12MB27678E2944605E11B37267CC8E759@SN6PR12MB2767.namprd12.prod.outlook.com>
References: <cover.1655761627.git.ashish.kalra@amd.com>
 <12df64394b1788156c8a3c2ee8dfd62b51ab3a81.1655761627.git.ashish.kalra@amd.com>
 <CAMkAt6r+WSYXLZj-Bs5jpo4CR3+H5cpND0GHjsmgPacBK1GH_Q@mail.gmail.com>
 <SN6PR12MB2767A51D40E7F53395770DE58EB39@SN6PR12MB2767.namprd12.prod.outlook.com>
 <CAMkAt6qorwbAXaPaCaSm0SC9o2uQ9ZQzB6s1kBkvAv2D4tkUug@mail.gmail.com>
 <YwbQKeDRQF0XGWo7@kernel.org> <YwbQtaaCkBwezpB+@kernel.org>
In-Reply-To: <YwbQtaaCkBwezpB+@kernel.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: MSIP_Label_4342314e-0df4-4b58-84bf-38bed6170a0f_Enabled=true;
 MSIP_Label_4342314e-0df4-4b58-84bf-38bed6170a0f_SetDate=2022-08-26T18:47:21Z;
 MSIP_Label_4342314e-0df4-4b58-84bf-38bed6170a0f_Method=Standard;
 MSIP_Label_4342314e-0df4-4b58-84bf-38bed6170a0f_Name=General;
 MSIP_Label_4342314e-0df4-4b58-84bf-38bed6170a0f_SiteId=3dd8961f-e488-4e60-8e11-a82d994e183d;
 MSIP_Label_4342314e-0df4-4b58-84bf-38bed6170a0f_ActionId=01131e74-f26b-4805-aa08-cfbb5956557d;
 MSIP_Label_4342314e-0df4-4b58-84bf-38bed6170a0f_ContentBits=1
msip_label_4342314e-0df4-4b58-84bf-38bed6170a0f_enabled: true
msip_label_4342314e-0df4-4b58-84bf-38bed6170a0f_setdate: 2022-08-26T18:54:14Z
msip_label_4342314e-0df4-4b58-84bf-38bed6170a0f_method: Standard
msip_label_4342314e-0df4-4b58-84bf-38bed6170a0f_name: General
msip_label_4342314e-0df4-4b58-84bf-38bed6170a0f_siteid: 3dd8961f-e488-4e60-8e11-a82d994e183d
msip_label_4342314e-0df4-4b58-84bf-38bed6170a0f_actionid: 29ebba62-13a9-4b86-8b1b-a974f6f5188d
msip_label_4342314e-0df4-4b58-84bf-38bed6170a0f_contentbits: 0
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: fc5bf462-8a5f-4767-6e92-08da87946010
x-ms-traffictypediagnostic: BL1PR12MB5334:EE_
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: Jthyv26BinNazs79ZmJ5P8A58XuiV68hlnvcWLUb9YPe0/j8jN/OCKhSW5m2ub1Yi/xWj/x/D5NFU2ai6YBmmq0ftcgqidwB/e3SLteBfBNOpDFjE7E7/WBH8VGJbRfX2XeOxsiam8lRqBeKCMWkMtQwuHhlRt7R+nj11FVuPn7HfyNj7Pop6t20ndBaoQRFsyHPqUm5LQS96tHtUhsxv5d4IlouQiI+p9yT1pApQRsz3+btiv2Too+zTjJC1VPpemolo5rHtXKP6ZW1sI2NgOkGVvaDB/TFpvYYuRETmylW9OzHQ3VCtCE3sZsA9cfwlNG7jR0VWfQre/A6ylUrqrPaTl6kwJN5otk/iWtLzNVb5jGZTd5T0bI3PLbDNmsWdY0XAf+lkn27GWRkEsKdQ3Q9wy9wNZfX+4oba1IWS5zAtLZXyc1fNMomxXSCmmOCDDsWgwJ7gRvaKbayivm6Z/xLdjYDRLA173WVsh2ap8F2dSx7+0078xC3mEtpbq7HHrv6cmN8umz20eZZSRKfaov1D4i2PP5yRt1xPCCzlZ9THL9VyZlFBvcGF650fMhxxyHpxe0u5Lj+O+zvbl9MkLI/eLd1EjH5AuvbiJ6V8uCR20tsKuePI0N08SBDKoBZHu9Xn8DN7iVRevS7Pq54kI1HytIXbU/FhrQf0V4IRijXfD9o8a0irsPUgwITuTTLtj2FniS/ohb8OyTPkxO0fjdrXGVIDD9SK7M6BTZe06P/BdAmXFFpYXQASIiXx0L3GF4uHiwKyYQ5HPvJazsSiA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR12MB2767.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(346002)(366004)(39860400002)(376002)(136003)(396003)(86362001)(38070700005)(122000001)(54906003)(316002)(110136005)(76116006)(52536014)(38100700002)(186003)(2906002)(7416002)(7406005)(66946007)(66556008)(66476007)(66446008)(64756008)(8676002)(4326008)(5660300002)(83380400001)(478600001)(55016003)(71200400001)(6506007)(26005)(9686003)(7696005)(41300700001)(8936002)(33656002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?lR8URrnwzDvQxGRI+gqh5IjjdsASRCFUZvwqNMJOZWakYWJ2RX9G7vQIwB4R?=
 =?us-ascii?Q?wmEOhFRNUx0ziSLQ+PxGDDGaL0YCN7q5Y8rTuxesns+BHt1ICRqCgrY94FBy?=
 =?us-ascii?Q?zHj+wVny1XjytwXNGwl7cPP/kA8Aqg03fbV/nloqd0e7wEb/dYFMFAWkdeDk?=
 =?us-ascii?Q?OObASgkdsCi3KPMgGEdyNgTBf1BWOWIRDRQzNhgWGy3oMmDXUDHMvTe62skK?=
 =?us-ascii?Q?F7fD3o9oLcOZMGApQ49OJ0ZuZYZOWTDMvVZS52I3VQZFyCRinPM6oORXBnQW?=
 =?us-ascii?Q?d9XovvO6ELzYDw5d8gDCrRrZ/kETppC0ZJcAcZMaZHeJyt0FH1aZYYEJWjiu?=
 =?us-ascii?Q?vIIgv9yk1CWWW/zkFVq8Naj/JwkE965+UfF6nNqYjBy8UgY6+ndfXWqw3poq?=
 =?us-ascii?Q?bPT90NL0jSRZqQNEixoRa7IN6cjkbYmuBWrcmt4MuY6K6roXVRGJBZWZ9LcD?=
 =?us-ascii?Q?NFIYqMDKsZnkxrjaonsAKYFYD+ItuetZRzkHSxXjRd8aeB67KHafhxUB5wDM?=
 =?us-ascii?Q?v0exyxM9Itvnbwbts0XHS07mvxwo3Yi2hhuEsFg4YaEw9I6JDkAdYYd9CwAC?=
 =?us-ascii?Q?H72kfcMRKk0RsIXrwifvDS8MbI1OGuNF6hNaAA66CgAg8XxFWZrfkd5BxmbI?=
 =?us-ascii?Q?K8X1i3Y3KGjwNonkAern6k/OImYXi9tw8olKJK77QxSHaCWtl48bB+d3yN1X?=
 =?us-ascii?Q?B1yFdAMHlypXaHkb4Djf2cQtpRHo5W7JJIakDfVpiRBcyh95LOLJzT6AEpa/?=
 =?us-ascii?Q?bJubg7to5VyBXPks0iEJrlkc8jWF/hwAKlyVXzrNujm6M69TMqJ4cYZBKHm4?=
 =?us-ascii?Q?412XWS8SNczXCuhn11Sg1f9TB3roiwKGWsM2hxj36xwGUTkc58VVCYv4lvKJ?=
 =?us-ascii?Q?C7aklXUEYWW+5SoVVqJVYJT0opyOObvlmSxTrtO8eL/OJ2kEsEKJfQ1MNaXl?=
 =?us-ascii?Q?mH7YdYDpVGMPPZGQJUrwV4oygSnyCqabnVEcsJFHwMusqCcKLkCYxsf0BESG?=
 =?us-ascii?Q?QMftIUehCVfxUzx4QWvx3c+uy3qUAGCD7sKG9QF9iFEQhfZxUoD0/QQgWd8m?=
 =?us-ascii?Q?AsnTeqa4Q29wx6bay0qGPgtsYegRq8xrMYvGgktjXl6aGCLZ1CxXrFv8ev/l?=
 =?us-ascii?Q?zcq1LAIao0i8/AkH0WpVmlrnMF0ItWL2+c98RSpSdQOzeToccVunSD4MyXZs?=
 =?us-ascii?Q?6bQ/5PHzUadJdYZsgm1F7kNJschN4OrWXooNlkIpPmWLlSBN5pzqVGSvX/Qy?=
 =?us-ascii?Q?gN9Q1TI4dAtgERMdRN+ACG61HHRvVOy2VLpFJCcVrcyidUIayowqdtcYHm5T?=
 =?us-ascii?Q?UQSB/jRRXq5s8k4hVL00ltajBxAaa52bLtTfm3Low95DhrqTHE9CiY3wrfHi?=
 =?us-ascii?Q?G6wjycdA2n6dHWO/IRSxJyVYIecJejzT0NntdON3qq5jP2FEecnW73Vn61K6?=
 =?us-ascii?Q?oAx2vdatZa3kxb7n+mwyqmhpXh9vXaz34WBrO0XEgX2bcvZEsWSyR3pYmhrv?=
 =?us-ascii?Q?yJlxp5LmoIMG3RBaAAMSIZqHYKA4xU47iXaNYwLC9kVMCh+RlGzCqIRinjo/?=
 =?us-ascii?Q?2ur3BTwpSJZfvasUw0k=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SN6PR12MB2767.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fc5bf462-8a5f-4767-6e92-08da87946010
X-MS-Exchange-CrossTenant-originalarrivaltime: 26 Aug 2022 18:54:16.2633
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: UroD/I0WsGYZZCb/6XOqTlndwb1wq8INQAVry840mSLb/8eVTaNiimKyz1DOsagqBzdIqaEPtEGYiq5EUX0U9g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR12MB5334
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

Hello Jarkko,

>>=20
>> It really should be, in order to have any practical use:
>>=20
>> 	if (no_iommu) {
>> 		pr_err("SEV-SNP: IOMMU is disabled.\n");
>> 		return false;
>> 	}
>>=20
>> 	if (iommu_default_passthrough()) {
>> 		pr_err("SEV-SNP: IOMMU is configured in passthrough mode.\n");
>> 		return false;
>> 	}
>>=20
>> The comment is *completely* redundant, it absolutely does not serve=20
>> any sane purpose. It just tells what the code already clearly stating.
>>=20
>> The combo error message on the other hand leaves you to the question=20
>> "which one was it", and for that reason combining the checks leaves=20
>> you to a louse debugging experience.

>Also, are those really *errors*? That implies that there is something wron=
g.

>Since you can have a legit configuration, IMHO they should be either warn =
or info. What do you think?

>They are definitely not errors

Yes, they can be warn or info, but as I mentioned above this patch is now p=
art of IOMMU + SNP series,
so these comments are now relevant for that.

Thanks,
Ashish
