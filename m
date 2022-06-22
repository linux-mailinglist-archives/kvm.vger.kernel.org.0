Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EFC9F555328
	for <lists+kvm@lfdr.de>; Wed, 22 Jun 2022 20:17:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1377583AbiFVSRi (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 22 Jun 2022 14:17:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43842 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1359064AbiFVSRa (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 22 Jun 2022 14:17:30 -0400
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2054.outbound.protection.outlook.com [40.107.223.54])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 37F103DA73;
        Wed, 22 Jun 2022 11:17:29 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=i2zR65pnt2YCAV4/w+X+YTugAXJ5RBDwPWChJJHslMg9QbEoQziAoW3j2UQaU02DWq3fEEGW7xVXmbpYc1Wqc0UG7CUi3CZHcH28LV8KsFIeOYaYMVwZ0G3BmkUEkwYYg5d9zj8c2GzEvUYzRXBTnONoNILDboMMJQBeP51P/HgSryxwIqjZmJ7XGj9W6xDx10sYkV9MNtcEVux99hBfMPzB+K/4N0vvgfSZ6X0c0Dw5HxlFgjLPL8B+4lL6WxpppfJxCHHCa4v/z4R/xvvMoEqALkBanNkv9HJWEzs3OfpQF4K5RllSxAywiIT2TY3fgMYW6nXRTBbAJOVvIJ+btA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=LrSFiL6VTeyCnURCOmUnLY6cXTtleeTxfnrIHCzs0G0=;
 b=lAtkKEtuMnDoLITelC91bzcZZN+3VrcWCH8dG2C93n/7Mwnz4TN2rdmFoO0tsrYDET5vi0xNIiUQfW05yOenBvB5OLbrJyqZs3/+UvDyU1ZTgazRPh3CwB6i7fuvtS5MLopM0G9WL0UVMSUMwj+hAya4fzHU4wll74UKE4CkJYcLJHZO/x6PmIKyLxpjG/gaIVtrI5CTZM8mp26BpgnsJgT+IDZ4R0zkc8fMWHoGIuxs8YbwKdeOpdSmfSPztdCmDy+M1+g9uOx/h6woe3FF/lu1ClL9vJfsoZyfq/sm4RNTXBBfPXRvkVcJPgogZb3Kjs0RpH189YFtlDB7SGaCTA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=LrSFiL6VTeyCnURCOmUnLY6cXTtleeTxfnrIHCzs0G0=;
 b=aj7v+7q7kC1p4ZR0q/uMRqtE+mRg7x+1zV/tm+wDGKW4qpY57RBU4KtTj/a1M1LhPsm294UH+babCDF7AV8cnC9P6BKd3tdP/pAFeo8F76uTQK+PC27OqsvRPq/jLsY2G3jv+1wjii48tndqAkO/TqdIclSg5ZlGUOGzLpdAMkk=
Received: from BYAPR12MB2759.namprd12.prod.outlook.com (2603:10b6:a03:61::32)
 by MN2PR12MB4334.namprd12.prod.outlook.com (2603:10b6:208:1d1::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5353.14; Wed, 22 Jun
 2022 18:17:27 +0000
Received: from BYAPR12MB2759.namprd12.prod.outlook.com
 ([fe80::a0be:c49b:ef2c:e588]) by BYAPR12MB2759.namprd12.prod.outlook.com
 ([fe80::a0be:c49b:ef2c:e588%5]) with mapi id 15.20.5353.022; Wed, 22 Jun 2022
 18:17:26 +0000
From:   "Kalra, Ashish" <Ashish.Kalra@amd.com>
To:     "Dr. David Alan Gilbert" <dgilbert@redhat.com>
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
        "tobin@ibm.com" <tobin@ibm.com>, "bp@alien8.de" <bp@alien8.de>,
        "Roth, Michael" <Michael.Roth@amd.com>,
        "vbabka@suse.cz" <vbabka@suse.cz>,
        "kirill@shutemov.name" <kirill@shutemov.name>,
        "ak@linux.intel.com" <ak@linux.intel.com>,
        "tony.luck@intel.com" <tony.luck@intel.com>,
        "marcorr@google.com" <marcorr@google.com>,
        "sathyanarayanan.kuppuswamy@linux.intel.com" 
        <sathyanarayanan.kuppuswamy@linux.intel.com>,
        "alpergun@google.com" <alpergun@google.com>,
        "jarkko@kernel.org" <jarkko@kernel.org>
Subject: RE: [PATCH Part2 v6 06/49] x86/sev: Add helper functions for
 RMPUPDATE and PSMASH instruction
Thread-Topic: [PATCH Part2 v6 06/49] x86/sev: Add helper functions for
 RMPUPDATE and PSMASH instruction
Thread-Index: AQHYhY2kulHh/HmbIUq97K70l/FApa1aH19QgAGdtQA=
Date:   Wed, 22 Jun 2022 18:17:26 +0000
Message-ID: <BYAPR12MB2759910E715C69D1027CCE678EB29@BYAPR12MB2759.namprd12.prod.outlook.com>
References: <cover.1655761627.git.ashish.kalra@amd.com>
 <e4643e9d37fcb025d0aec9080feefaae5e9245d5.1655761627.git.ashish.kalra@amd.com>
 <YrH0ca3Sam7Ru11c@work-vm>
 <SN6PR12MB2767FBF0848B906B9F0284D28EB39@SN6PR12MB2767.namprd12.prod.outlook.com>
In-Reply-To: <SN6PR12MB2767FBF0848B906B9F0284D28EB39@SN6PR12MB2767.namprd12.prod.outlook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: MSIP_Label_4342314e-0df4-4b58-84bf-38bed6170a0f_Enabled=true;
 MSIP_Label_4342314e-0df4-4b58-84bf-38bed6170a0f_SetDate=2022-06-21T17:35:04Z;
 MSIP_Label_4342314e-0df4-4b58-84bf-38bed6170a0f_Method=Standard;
 MSIP_Label_4342314e-0df4-4b58-84bf-38bed6170a0f_Name=General;
 MSIP_Label_4342314e-0df4-4b58-84bf-38bed6170a0f_SiteId=3dd8961f-e488-4e60-8e11-a82d994e183d;
 MSIP_Label_4342314e-0df4-4b58-84bf-38bed6170a0f_ActionId=8ea0a6e0-a48a-4e19-99b7-56489206fe63;
 MSIP_Label_4342314e-0df4-4b58-84bf-38bed6170a0f_ContentBits=1
msip_label_4342314e-0df4-4b58-84bf-38bed6170a0f_enabled: true
msip_label_4342314e-0df4-4b58-84bf-38bed6170a0f_setdate: 2022-06-22T18:17:23Z
msip_label_4342314e-0df4-4b58-84bf-38bed6170a0f_method: Standard
msip_label_4342314e-0df4-4b58-84bf-38bed6170a0f_name: General
msip_label_4342314e-0df4-4b58-84bf-38bed6170a0f_siteid: 3dd8961f-e488-4e60-8e11-a82d994e183d
msip_label_4342314e-0df4-4b58-84bf-38bed6170a0f_actionid: 42fb8e92-b5ad-4dd2-8d32-b6dd98232f85
msip_label_4342314e-0df4-4b58-84bf-38bed6170a0f_contentbits: 0
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 41f95eb8-cd41-4576-a80d-08da547b75f4
x-ms-traffictypediagnostic: MN2PR12MB4334:EE_
x-microsoft-antispam-prvs: <MN2PR12MB4334C0AB4F150F22C8A658098EB29@MN2PR12MB4334.namprd12.prod.outlook.com>
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 03Ix7Qv+a122M0HOoJAuakySoTSO25qyyQZsioqkHqrUS4tHn/rusOfKK0d5CWs1hX9I7QIBxy2p0fFOzQoRmk9O4iw7hhig+PlaO+BT7If1cSA/WoYKjJNyItJHpC1VkAYU04sK/6cZ3gTAFrL4oAaGkfFuEIxNWj6I4yMIwH1tKfJUaMfK0Oc3QqmzoyKuBhcJbbrvMgbMpxPslL1DM3F3v5zQTQe+q3pR7AUsc0L8+rkWoGQ5WyNGo7lyTHxIzbRuU69iSzdGG52niV56qChIelKSvTc9bhh05o365SFsL9xBgsEdHgA60Ht2HetGRU+b0CmLQyOvqIR+Mu6FPoPqiE/yKRUqrVdngSSMwbbF6duk9VANIEmfX7wf1r4vXMbSwkYgw/KOpD0uMY/VYppqlQD9Ms7i+SX2XQsYlqYB+mz4XMgo/M0zWeLSmdNm6JUbaY+5hXfbgNbGaSQLRVgVx71fy0dhK4CyKDHGMvoQ9L8AvN7h9PI0m4xnDcUPtYPbSXZGoKp7ZHAuB4Gn9jaW49jPoia1J5cbU9D46I2htwsSxxefizprsS0o7whqLjfxTNp7Y+JcUNAPGUN2ASy2Slt8poAyFBDokDkvN2eajIcnm23uenbRl9USxQLyZdOHf8RohWz06X+vyx9Qfnj9JpI9oW26E8Qzob7knvGkzfIVOlFyrMvhmb6I8vOOtdTz8zP19vj0mYu1j7qrLhZHh0ldAcTCNjqJ0Boy8BE1WoyIYA/s3WLjaH0eNEruXCvFy/kMC7EXqR2EziwFMg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR12MB2759.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(39860400002)(136003)(366004)(396003)(376002)(346002)(7696005)(7416002)(7406005)(83380400001)(52536014)(186003)(122000001)(55016003)(38070700005)(6506007)(26005)(38100700002)(64756008)(9686003)(316002)(5660300002)(4326008)(8936002)(54906003)(478600001)(2906002)(6916009)(8676002)(66556008)(41300700001)(76116006)(66476007)(66446008)(33656002)(66946007)(86362001)(71200400001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?57LRkiiDVM+ffjo3y8qr9HZNF5qhrrW4kDhx6sVTKmnGHJVsdVM3y22SPldF?=
 =?us-ascii?Q?4X4IMQPeOwHP+F9v4+3xbB+01oMV3Mxs/F4gBBfPMyu/az1qjJBa+POVbwnn?=
 =?us-ascii?Q?0W4BmI7/WuZfEXjAFQMKkkOw/V/Rzb40QM4gmOennU6J4xhCg6sITnnya4/R?=
 =?us-ascii?Q?3wG8MIrd8CF+HXAh2K4G9K8Cp73Ec/ls8NITRkvBNdjDyaRGXoyvCdj5Mjop?=
 =?us-ascii?Q?/XpzZks2DFfpD+UxmvRLo1SAHTsuqcIH2Yag1bvqyBJmBoPVTGhFrBBWeZNS?=
 =?us-ascii?Q?l7py36rZ+YV4C26aXVu55lYu+sZ7Hn4g5PitFYCcrsJCD4+LPh6Qm6Io77PJ?=
 =?us-ascii?Q?K0KGX/aRqSKWi29slUKp2R3xagB/Gx7NyQ0I/okSir/iKn9ytFOdQkepQglU?=
 =?us-ascii?Q?CwIeT5dzgtp8HO4/mD9PvAjZhSnIpdpi5WQ38XNuC5gNGH//nchDMd6BUdYk?=
 =?us-ascii?Q?r/ks6NPFA3iJvZlxBDTJtr84QISgyPCdTbDgH81mkgeGjh1iGin0RELPCGOE?=
 =?us-ascii?Q?o2x4z8He8hRAOjkYO831j1p9QvHTi3aVwAFwhu0W0uUJ+i4Tfd/uuk5l+GDz?=
 =?us-ascii?Q?evpfoRZ0SDe+SC0+GBHB5UzAeFKa66wmTkLm4e26ZfHYyKDVMOC8KqXmWJNn?=
 =?us-ascii?Q?phehfhmKX990wn9VyINTX6ywXJmPevJ2bwLqJCLMY+d574cdgfZonJkoqPL0?=
 =?us-ascii?Q?TfjkTc1ac0TahXlNSSC9BMQus/DLSBVvYzOKC0HnsFIHUUBNImgzNO4/POax?=
 =?us-ascii?Q?QA3fJOY8hUgjviCt8xlWjXTocxz7PNxfmgrJSu253sDkvcDsBrY0a+EMYkbY?=
 =?us-ascii?Q?LaIY+cXBWGEXs8LdzOYbW8or3xgDSTsjvbF1x1AQ9uzxOFRZfhW/DgqfD9PS?=
 =?us-ascii?Q?zy4NF/hNllL09EmuVW13Kz5ERRuHEdLkhuZ+0M3xTBgn5lGw9Yz2mzBbe31g?=
 =?us-ascii?Q?CeDXQ3uhb71833oC7HjaE2c30hQMRmj5y4LJrxVkRLJ12mxU3HHvmdw8RmrD?=
 =?us-ascii?Q?jr82OLABAdMU205FfcUMieJK/tSPh0Yz2WSS/g4pnwL8gcYh0hJ+oogbOm2/?=
 =?us-ascii?Q?kb2G4vdzMdpfT7ey9MDP8z+6TECHAHRHXmN+PchI8cXr1aRvk28SRIfBd3CF?=
 =?us-ascii?Q?i/iB/XrrU+lDfKMggf/jhKgsXM0GP06M8fdz4iHt9Lh37A0MJ+sHSyMO+f+n?=
 =?us-ascii?Q?oX9ln0CLyGUtSuVcAQqUegbrKgYwNBC+YQzIUNowFtTcJtrWhzFtvxuJjAr1?=
 =?us-ascii?Q?+bayJEr5SA86J9gFmTfgdMGbpEyMFDP9/4vZQPZ5o7XuZfFBX2serNH6Ap00?=
 =?us-ascii?Q?Rbvs9V9vdRxQjJIsxr17Cy6/dvixGLUjISUiWgvgZ+bN9SxpxGRm5lsZ3VZQ?=
 =?us-ascii?Q?lsaKlO+SzxjCXsCz/VwDNg72s1z9Tl4SnVUlpme7WSEf98W20esMPJoEm3nK?=
 =?us-ascii?Q?VbD3hvw7uxJlXNDFfpDP+qIP7vi+sZzjtKH0UCwmX2X11bs+0brFq27ara1O?=
 =?us-ascii?Q?B85aPfrIi/1+Op25FHyRcXX/d8kVb8zxAPIxjqrkekzd+J6tYtKlALmqb5db?=
 =?us-ascii?Q?CmjD4PTA3LdXW3k+JXuSOTLq+kQqZYnGXotpWGhSYKCcEhYZrJFMgyAAUWT2?=
 =?us-ascii?Q?ImTNhVDpO+YPeJwXG91e80Tf8KipJBGrVb3SIPZLeXKLnSukiBsbV2oN1kSE?=
 =?us-ascii?Q?lv6DvZkdcq0YC7RL47i47yB+GUfCsmO1iWjoOKUqcKdnjVPb?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BYAPR12MB2759.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 41f95eb8-cd41-4576-a80d-08da547b75f4
X-MS-Exchange-CrossTenant-originalarrivaltime: 22 Jun 2022 18:17:26.2712
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: WrR6E3E/AZMm4zuuIansM/+egg1HBomf2Iu9lrblVKtScFvkxVNB3cGxxeSggfiLcCMUqOyO922dhtLReOWdxw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR12MB4334
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

>>>  /*
>>>   * The RMP entry format is not architectural. The format is defined=20
>>> in PPR @@ -126,6 +128,15 @@ struct snp_guest_platform_data {
>>>  	u64 secrets_gpa;
>>>  };
>>> =20
>>> +struct rmpupdate {
>>> +	u64 gpa;
>>> +	u8 assigned;
>>> +	u8 pagesize;
>>> +	u8 immutable;
>>> +	u8 rsvd;
>>> +	u32 asid;
>>> +} __packed;

>>I see above it says the RMP entry format isn't architectural; is this 'rm=
pupdate' structure? If not how is this going to get handled when we have a =
couple >of SNP capable CPUs with different layouts?

>Architectural implies that it is defined in the APM and shouldn't change i=
n such a way as to not be backward compatible.=20
>I probably think the wording here should be architecture independent or mo=
re precisely platform independent.

Some more clarity on this:=20

Actually, the PPR for family 19h Model 01h, Rev B1 defines the RMP entry fo=
rmat as below:

2.1.4.2 RMP Entry Format
Architecturally the format of RMP entries are not specified in APM. In orde=
r to assist software, the following table specifies select portions of the =
RMP entry format for this specific product. Each RMP entry is 16B in size a=
nd is formatted as follows. Software should not rely on any field definitio=
ns not specified in this table and the format of an RMP entry may change in=
 future processors.=20

Architectural implies that it is defined in the APM and shouldn't change in=
 such a way as to not be backward compatible. So non-architectural in this =
context means that it is only defined in our PPR.

So actually this RPM entry definition is platform dependent and will need t=
o be changed for different AMD processors and that change has to be handled=
 correspondingly in the dump_rmpentry() code.=20

Thanks,
Ashish
