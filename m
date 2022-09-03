Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 108AA5ABD43
	for <lists+kvm@lfdr.de>; Sat,  3 Sep 2022 07:51:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231826AbiICFvR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 3 Sep 2022 01:51:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58664 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229508AbiICFvP (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 3 Sep 2022 01:51:15 -0400
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2077.outbound.protection.outlook.com [40.107.94.77])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A8AF1D87E0;
        Fri,  2 Sep 2022 22:51:13 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=QhDYPEiCpPvNdW096q3kpZMCyQaxMtF/CMfvX1qh878j7LZNwEi6sf7Fjbt31NjXd7W8ubgTnAyC+mYryib0goX4PzPAY1GMWWOZsXoC2FbeQ2Q0SYAaLDLZOYxOsZVXDgJfhXANrOAhzzIxmnF1+ErcTEuN+gNrjVcMu1L2GaeyVqPqo466Fv2joRyytxBz6NIo2neRyDtdbK+rKT+m3BRg+xKmtjcMGk2zpgOcPmtendOSoktO7llA1Vr6OAZDQLKX7Dimm2aGQQ6ncAwOw1gRu5EKtYhcBhEEf4QT958B2e1LfOmXUlpt+3TRc1yBPMD2d+vmIZkwVcMHXmIZRg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=4XC79xKrEaVTdldtRNHQm4aRDgIe4cLkKUxzPfntKE4=;
 b=ChE0661hnwNAB3PuS9qmhV2L9ez2iwP/3KkJl18CIW32/6s2oBE4SO8hp5SblANYAyvXCrUGKIvJjGfT8dKH1R+j/LrRqP7SPOiyJ3CBM0jWxmiTK0LEno/wFoXiQnrtJC41gvk8JaX/fu8Wki8wAFsVJwsyXxbQJa66oApdQp/hPNx8CZmwd06XQMbKa6kzRKCpRVHc5CuURsw+tLBz2gJoK7yB9dGLOrEIBeZxYP9lhGo8Ej6T1dfMBalau2oeRLEct+8G95ZaMn65ATdkej6M/CJY8eZg7uykIwsOeh4UoiLVho7Pi1G07IHpQF3gF8a1YZQjX9oJTUzlIX+n2A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4XC79xKrEaVTdldtRNHQm4aRDgIe4cLkKUxzPfntKE4=;
 b=S9PPTy72yyCX0IXwVdm04zjmbKgyGi+WeZxDGs4xCvqbIdnfhQJKa8RlUhgVzC7ZIWL7ckAIDaeplEY1HTjZCt8qnsCXu03Q9GJYNffqFbeVYCGaxHhFBigqUOjh1RkSCBmn9dUD9/PAowNCpf0gdj9ilcCaeg/H5Ofowp1iAww=
Received: from SN6PR12MB2767.namprd12.prod.outlook.com (2603:10b6:805:75::23)
 by CY8PR12MB7337.namprd12.prod.outlook.com (2603:10b6:930:53::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5588.10; Sat, 3 Sep
 2022 05:51:10 +0000
Received: from SN6PR12MB2767.namprd12.prod.outlook.com
 ([fe80::e47d:1a95:23d5:922c]) by SN6PR12MB2767.namprd12.prod.outlook.com
 ([fe80::e47d:1a95:23d5:922c%7]) with mapi id 15.20.5588.010; Sat, 3 Sep 2022
 05:51:09 +0000
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
Thread-Index: AQHYrBDc30zm/ve2UUW13wSedLDd3a2nIMnggADB+gCAAMFX8IAieiDAgAC6pgCAAI/o0IAA2YMAgAAD/sA=
Date:   Sat, 3 Sep 2022 05:51:09 +0000
Message-ID: <SN6PR12MB276767FDF3528BC1849EEA0A8E7D9@SN6PR12MB2767.namprd12.prod.outlook.com>
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
In-Reply-To: <YxLXJk36EKxldC1S@nazgul.tnic>
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
msip_label_4342314e-0df4-4b58-84bf-38bed6170a0f_setdate: 2022-09-03T05:51:06Z
msip_label_4342314e-0df4-4b58-84bf-38bed6170a0f_method: Standard
msip_label_4342314e-0df4-4b58-84bf-38bed6170a0f_name: General
msip_label_4342314e-0df4-4b58-84bf-38bed6170a0f_siteid: 3dd8961f-e488-4e60-8e11-a82d994e183d
msip_label_4342314e-0df4-4b58-84bf-38bed6170a0f_actionid: 82970b96-21e4-42b1-b350-9e9f02535140
msip_label_4342314e-0df4-4b58-84bf-38bed6170a0f_contentbits: 0
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 16627afb-6534-4a30-9f7e-08da8d704d28
x-ms-traffictypediagnostic: CY8PR12MB7337:EE_
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: StDrBywIZmUATk3rO9KaJTdV0pSfR6+glp1GHmnbT/i2NA23Y2YVKbXiB6l94lOvQG4cHofF7+X1qRVoGAhhaVtdao9GMFrQF1TU1MCC3uA/zvBnjrcMg1f3T+eiiwihG0X+YIPUlcYw10JIoPggfSLGpUJ2ARCsOi5GjT/vgHPkxY4fEZpQa8SSAiM9sheFiszcGyUlF4fQLZUUPF77nPCGllkchFf9sr3DaydLCaAy6tqCuXVfEiCEzl9czWZKdu2dDxPOVXueKXCqk02E9klTogbVnQT2Xio7O7bfr8XEyTPyco0xDLb7PM9h3vJbdhAiQOzqVu3J2xE3aR1njbfwFDqR08zT2s7zUnzqxULw/dE2QT7xQ8mWc7sNolFrd78fumsu/7y/nv77U5nT1hY3JO4jRYzwQhXGEk2LedtERiFSPT1F7NkifgG3E81GlKpFRdyFefY83hEVZ5iJy53Amv3/e0i0V4FZ5g1TM7T3UvJWBGrYkn3FM3riWcRahf2F4iiGeYWdA+ETKklTTjUThQ06FtFPsQWBe17yFOG3CzajxABO/n2geH/kncFl/N7yRNUw6BjUvohfFuQz+WD1IGYEG1I2t1ttVLJ4qA0za8fqsHiIYL7QRqlT/crYbWj6SuTpEAN3/twzh1USLT5y1NdlfYir6O2DDDEGsjn4GSWn8RGFB2BKYzTN6HgPgX5eXbSDLXu1mwT2vfPugiISp+RRlyULBRPBeM7ul1Wvg9o5puhY3YvkTVZELLOJMZ9409N0AzBxhkr4V/cXuQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR12MB2767.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(396003)(346002)(366004)(39860400002)(136003)(376002)(66946007)(76116006)(66556008)(71200400001)(64756008)(4326008)(8676002)(7406005)(33656002)(6916009)(52536014)(8936002)(7416002)(66446008)(316002)(122000001)(38070700005)(38100700002)(66476007)(5660300002)(9686003)(55016003)(54906003)(2906002)(7696005)(6506007)(186003)(26005)(41300700001)(478600001)(86362001)(83380400001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?HGJRhbP7RSaC53AZM/XPTnbj96CfJasbbUCrGtarcB0rJo3zOSTWY65sy0Yw?=
 =?us-ascii?Q?bp6QK584jwujcVRl7XPlhRWq7Hcp/G5xGu3Ct3ywF3AOF6hMY39yOI0jktJd?=
 =?us-ascii?Q?ze5of88yW6PXO1aUUvqLjpoBAZh4qJ5XvdbK190b4HJZ48kPW6pLnaRcsUSR?=
 =?us-ascii?Q?cSP5dfg2zbZeF5aZZPB/aR38vss2ciPPXCVeN9gTUTVmt8og7Jll/TNyg84L?=
 =?us-ascii?Q?Oi7WEWOC1G4YDgxYL8UDDO4mp83o2QzesEp4N4behsY7Vx/HLXU3X5S3P1rt?=
 =?us-ascii?Q?N9sh8D/0eUgDIWHhxJqgaE7UvFHB8RCSyj1fc4nyIKuc9y76LTw80fziJsPA?=
 =?us-ascii?Q?m0eceHWBivphPmXXh4b2Fkq3yDCnomNodeepgMlYhLBBVzDQ77Fr9cfiFp14?=
 =?us-ascii?Q?b3AB8jZT9xv78RWiShT5aSU+of3Ul2h1ENJZcmCIYeXYj78JQKvHxuDZ7tbj?=
 =?us-ascii?Q?ddC5c8goUvlqHL6uwC46bcvsubGA86gVmV3FPpKDG/R7JLcqXeWqUUmSfvGC?=
 =?us-ascii?Q?5xEpBYgHoNOgeHDw8KO2SFQ5awmnMJirSH8VqArTk2Dqp6Pl2Bjyg48WdrNK?=
 =?us-ascii?Q?4KGwS08b82KcqXzu3fkNW2T4qEJqf7EzPjCRHjmC6y0oDNz6hN5Ocqvip2dF?=
 =?us-ascii?Q?br+Ncjins2hCwIEpk8ThMCuoSgujYJCsWR1tRpE2TSFgwsNtMlGcU4JEfZRw?=
 =?us-ascii?Q?6S2topGf7H6WjCgqRA6zXyjdkWpDs/l0Aldfw6eWVD5r979PxwxQavea0esv?=
 =?us-ascii?Q?Uy4d85JFpUNM5mbkfEYhLLVy77HqBvuOhMPjZABhN1x+vwYZLO9cxU2hRtiC?=
 =?us-ascii?Q?OMJ/PHKE8Y/91yhia7Kc9uIeWuZ5FwXg43P+NYuSZdQC0XI/O5Xe9L09JRy8?=
 =?us-ascii?Q?Hyk40WC5rKa+E47uHl78yLZJTwtLU9KpiPI7UwRDBsT7dX+vraMGQAhDGYX2?=
 =?us-ascii?Q?FqzeI9qJmjK+OvKo0qh2Vve5C4jASYxxuSdmhnJMKDixYGvHusPsOQNbFD3w?=
 =?us-ascii?Q?4zjRxvBnziiicScyM8BLpCufAGAQpDsst/2V79vZj6TgCbyG33DIuwWYm9dl?=
 =?us-ascii?Q?UuhsPr491XNlWsvIVcL2o5NrAeDfnorSpl+AzwpCuucHyAZwIHQ2U5U8LhxZ?=
 =?us-ascii?Q?rsw6B9UUcW1yFON3KMv7P/KofUbcsst7SfDshw3IqYlt9RCsl6NJlC9oaJQn?=
 =?us-ascii?Q?Eo4TN8FyXzavIoY+dyGd+3rvq8WEJFP+xWDR4+wYAYAosIDeQJqVaDW9FqYd?=
 =?us-ascii?Q?VS5y18n8KonjDaVfklx4D9rk2Ttf8umo4kO2yTd69nIktAp0F3AIsLLXEoV1?=
 =?us-ascii?Q?6tiUS1VTwSyw1FoXr3bWtH8iqoNzsMT/NmvFAp6Q1+ptPLbXfmelFUxIQqtj?=
 =?us-ascii?Q?znElyC/24SXczcA1YSna8tPFtRVp8fD00c/ll+9qxTQESN/NEjlnV/yTNPuy?=
 =?us-ascii?Q?CyQWWWE/gaPzKqECKa4yAnj13AtkvhRyK+f/xAcwMjiuRl/8amfVgxcLzwWV?=
 =?us-ascii?Q?Hje9hWVp+zch4Y8tAx1qZ/AFI4nN/W3b+NdZp4y01JFgFFBXEqhUz/RJEuG3?=
 =?us-ascii?Q?UN4tprVGVSAZ/BDY23o=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SN6PR12MB2767.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 16627afb-6534-4a30-9f7e-08da8d704d28
X-MS-Exchange-CrossTenant-originalarrivaltime: 03 Sep 2022 05:51:09.6551
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: jALXDZECamuqinOYjBjoZDZQDR9GpQcIH8kW3V9u335CxZLtxeU74B7qUFew3fNbrcBN+tYOxAPmoisWW3NyJA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR12MB7337
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

Hello Boris,

>> Yes we want to map the faulting address to a RMP entry, but hugepage=20
>> entries in RMP table are basically subpage 4K entries. So it is a 4K=20
>> entry when the page is a 2M one and also a 4K entry when the page is a=20
>> 1G one.

>Wait, what?!

>APM v2 section "15.36.11 Large Page Management" and PSMASH are then for wh=
at exactly?

This is what exactly PSMASH is for, in case the 2MB RMP entry needs to be s=
mashed if guest PVALIDATES a 4K page,
the HV will need to PSMASH the 2MB RMP entry to corresponding 4K RMP entrie=
s during #VMEXIT(NPF).

What I meant above is that 4K RMP table entries need to be available in cas=
e the 2MB RMP entry needs to be
smashed.=20

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
