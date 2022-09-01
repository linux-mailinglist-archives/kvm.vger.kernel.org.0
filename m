Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EAEB95AA0ED
	for <lists+kvm@lfdr.de>; Thu,  1 Sep 2022 22:32:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234544AbiIAUcl (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 1 Sep 2022 16:32:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46570 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231443AbiIAUck (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 1 Sep 2022 16:32:40 -0400
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2082.outbound.protection.outlook.com [40.107.244.82])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1DA377961B;
        Thu,  1 Sep 2022 13:32:38 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=NCHntLMJeSicaMAY0wH/JqRXECod3GdYxCSwbCJRzb44u4EcaXcs7dCm7WQCge5H4C+Ixik4c2O8a2Gb0lEx0B4+c96+YJ2lg9Xd1aCGXjhsqfpAKpsiMDIC3oezq6l9pqjgh6q34ksYi7EDkpLxzJwXQ/3H5dVsKT31eqg/WsgU8RCNxJDdCmxjIG385X/8qLky+xEoyivrJspqPXlr3E6JsiBcZGcWRDww1cr/VKgifB7HfSCvvgmUtD80h6baYLgZNWAYXW9/cYef2oSUI+LBIRwZyikz0l8LcN4CzIypFTL0+suWp3Nk8IeDMJeC2sL/lYdFI+mAIM+h4WlYDw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=8z39LTGoqPC0gcqHK5cQackmxlAmSNi7bjy1vJ1zQzs=;
 b=RNO0j9Qrr1ElZCYUdKc77DvURnqQlUNCK8FtZE0DWKpMLsZK1wdv8BMuAoCYugMUrFfZR6/EvvQ6PJUQhclbjnDsL7kk6vya6RI7WsFPSN8hiisGTQgLZLywby2Ogzc71IUlRxufenaGSKUNTqS3Hn2AkQPW5gk/Sy41qztDujDr5Rj3dNrjZFllsHiN6+ojQzrdhnvcedenEA6oJKHuFqRbGwd3YSJSrTteZQpvO0htkNTJoklXxncrYdhw2NR998JIp1PAPAa/5+MXNe05tMRgK02ueg9qLoAnRQ4BMAeC+Bik1hUCuHAEv1aAW/zyvMgq0R+0OXwKeVekYdxq6g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8z39LTGoqPC0gcqHK5cQackmxlAmSNi7bjy1vJ1zQzs=;
 b=rMZMq5hi21jdVmbgb9olYx0Ecc7nr9ZPzxogVH9Vps41B0ECF1Bqol91FgC6ErHNQ/TjdNcy89EQDP6L3gDRtUspcQfJn4iNqgN8IJy3EldL6mTVqqbgEEknrfT2y/Wo+kzUGZ6EsEaVJyIRic0zBDOW1EH7Vl7bMeqEbk0l238=
Received: from SN6PR12MB2767.namprd12.prod.outlook.com (2603:10b6:805:75::23)
 by BY5PR12MB4259.namprd12.prod.outlook.com (2603:10b6:a03:202::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5588.10; Thu, 1 Sep
 2022 20:32:36 +0000
Received: from SN6PR12MB2767.namprd12.prod.outlook.com
 ([fe80::e47d:1a95:23d5:922c]) by SN6PR12MB2767.namprd12.prod.outlook.com
 ([fe80::e47d:1a95:23d5:922c%7]) with mapi id 15.20.5588.010; Thu, 1 Sep 2022
 20:32:36 +0000
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
Thread-Index: AQHYrBDc30zm/ve2UUW13wSedLDd3a2nIMnggADB+gCAAMFX8IAieiDA
Date:   Thu, 1 Sep 2022 20:32:35 +0000
Message-ID: <SN6PR12MB27672B74D1A6A6E920F364A78E7B9@SN6PR12MB2767.namprd12.prod.outlook.com>
References: <cover.1655761627.git.ashish.kalra@amd.com>
 <0ecb0a4781be933fcadeb56a85070818ef3566e7.1655761627.git.ashish.kalra@amd.com>
 <YvKRjxgipxLSNCLe@zn.tnic>
 <SN6PR12MB2767322F8C573EDFA1C20AD78E659@SN6PR12MB2767.namprd12.prod.outlook.com>
 <YvN9bKQ0XtUVJE7z@zn.tnic>
 <SN6PR12MB2767A87F12B8E704EB80CC458E659@SN6PR12MB2767.namprd12.prod.outlook.com>
In-Reply-To: <SN6PR12MB2767A87F12B8E704EB80CC458E659@SN6PR12MB2767.namprd12.prod.outlook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: MSIP_Label_4342314e-0df4-4b58-84bf-38bed6170a0f_Enabled=true;
 MSIP_Label_4342314e-0df4-4b58-84bf-38bed6170a0f_SetDate=2022-08-10T21:14:04Z;
 MSIP_Label_4342314e-0df4-4b58-84bf-38bed6170a0f_Method=Standard;
 MSIP_Label_4342314e-0df4-4b58-84bf-38bed6170a0f_Name=General;
 MSIP_Label_4342314e-0df4-4b58-84bf-38bed6170a0f_SiteId=3dd8961f-e488-4e60-8e11-a82d994e183d;
 MSIP_Label_4342314e-0df4-4b58-84bf-38bed6170a0f_ActionId=39eeec9b-b36e-48b8-a410-dbbaae721fe1;
 MSIP_Label_4342314e-0df4-4b58-84bf-38bed6170a0f_ContentBits=1
msip_label_4342314e-0df4-4b58-84bf-38bed6170a0f_enabled: true
msip_label_4342314e-0df4-4b58-84bf-38bed6170a0f_setdate: 2022-09-01T20:32:33Z
msip_label_4342314e-0df4-4b58-84bf-38bed6170a0f_method: Standard
msip_label_4342314e-0df4-4b58-84bf-38bed6170a0f_name: General
msip_label_4342314e-0df4-4b58-84bf-38bed6170a0f_siteid: 3dd8961f-e488-4e60-8e11-a82d994e183d
msip_label_4342314e-0df4-4b58-84bf-38bed6170a0f_actionid: d457c7cb-9ee6-4bed-95ef-d6ce5b1e22bd
msip_label_4342314e-0df4-4b58-84bf-38bed6170a0f_contentbits: 0
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 3bcfb976-df37-4480-1b90-08da8c591b08
x-ms-traffictypediagnostic: BY5PR12MB4259:EE_
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: K3XVUbOYgCU9svDfd26fFZu+348F1R3MMIpX7y0e8QAdO8osFeN9JB30FSRE3Pr/LVymFknB48MCMEW/7pGgs8JeweJaRPXqteC4dU0xOQtONPGooBCId0FQD6mcCphIyDWx8FM+/5z7qsgeJD26gxRKRgC2McOSKE4Iyzh0Aod6Ji0YYIPLutxjqoPfbpzrz9iIL9p6CoEVbzNImgeO6m18ZlBSEjr+Kx4U3iCfJFNcaNKf3T5pZi9qyJ/n9lgP/3q0cw84TYjTYTyvv9+MQj7ft0bfUkunL/QhTTsPiyZlMcTDbudHuzpUqb6kmfCJL4qMSXIXlGEl6+QjZnneSsoOwQiM8KLPqjLn8RSH2FEKbkX7E0cYfYQ9AczhX74yQxDq9QEg+un35udvzlbvkJBgyHjGVc3WFQmh6h3Q0QIZM5KcLDF2JLB0DcwkaXqUWJALhrItz5JQqefYQMuYaLqT4+29mBNYcXR9SntAPPeoahwq/wztndZNMbgpmEcsLiaLZLuz6Jdnh/esCMtNw2IcLcUcNx3Yj4gwTg6CYhIcLbDj+KBOUh63Hua8amqoavt7gsZ2/dVW/0hgGE5E7ny5OgYzNgFOt4/H7NBg+w2aqMbdflgPZ2b7Lch5n8sCtCwjw+S1AwTnQVaIOJBqU0iJGNfCIi+JmlAtsYDds0lYwciPkza2gjayu3vH3jIUTODChyI3q5khqzn7loogN3jqNEbIE+F+FFPtKM3cO+7KkS4TX0K9ofbtjf/YCrTm2gZC2w3wtPQCNRR35RVcmw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR12MB2767.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(346002)(376002)(366004)(136003)(39860400002)(396003)(7406005)(52536014)(8936002)(5660300002)(7416002)(41300700001)(33656002)(76116006)(64756008)(478600001)(8676002)(66946007)(66476007)(66446008)(55016003)(4326008)(186003)(66556008)(86362001)(38070700005)(26005)(71200400001)(2906002)(7696005)(6506007)(9686003)(122000001)(38100700002)(6916009)(54906003)(316002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?qzbav50R4JBChx3ZSz9n8K4iGM05eMCi5Yh7FSTwpyeTHwMIJ/dLxJTp8MoL?=
 =?us-ascii?Q?xKu4ft7fqFlYnv4JvS4iNb5vyuULFiC7cjjVcR6Z2UFRolKbtqtOJtIKjvNL?=
 =?us-ascii?Q?gxf7udF+0e3VfZZXFQNqszyiTwLcYG/iW6pP8iyySOd31Gj0BnHUhP61c+Co?=
 =?us-ascii?Q?2WJipmSotcf74jG0r9niqnB9kI+HLv71iuSKJSn1gafztOjEWwsmsXY8aK/m?=
 =?us-ascii?Q?HghLxMVqUQmxHhXz0g3jJy1Ubzc8a7WmedzUowP1oF9UfwEMLWHXFlHP/63n?=
 =?us-ascii?Q?tLRD+4lb9GY1Neh/EYahhxCBMwz4zNRXse1lcL1ArbvZxMpW4oP9Aa8DJCtf?=
 =?us-ascii?Q?6e1OLJhaWfKHifQyb2s/7pghxb/yMm+JWwpjbgXOYCNAUtq7gjAgopyGGF5M?=
 =?us-ascii?Q?i87cABItmII7D/4K10nclIvBp5AxcFi0OlUADWuBp3Ud/TQDLVSJTQzwOsA/?=
 =?us-ascii?Q?HZ8AIGw6mPotmdhMNbOj7CW0NVJn25mzNHuMUbCY+Wo2lAdto6JMZBkpGjE3?=
 =?us-ascii?Q?N4oYVB6/xHBgRXvj82UBEiEODA8qU6L02EN6HJxI6gqBfAYKl6wPgdbkbwYs?=
 =?us-ascii?Q?O5QIiNekkU5ehZpKnimp5BMLN40sqGqhYzm85dCrgWWMUTSRvoHuvbHNjgW2?=
 =?us-ascii?Q?TnKXo8WpGL166a+Qg+vtp5NPuTBY1RXmbfibMgoeyAK5n6yl3j3REhsE2zFv?=
 =?us-ascii?Q?r2fG4Y9pDfdqZfPnYu1CgGB9NwqzcPCbeQNvyrNYAvghz7ixVOOmWPZF7rfi?=
 =?us-ascii?Q?PrbT54cbQgxJ92ww9eIoQpS7UZwrvW/W9fvXLlHp3gAtdhUv6OHMAyq3Fnxv?=
 =?us-ascii?Q?qXr94VEUGtxppkf5paco8MdCniNYfL9hxY7njSJ4YY1UVX66r3BD5lVyrIhy?=
 =?us-ascii?Q?UPrqrsH0VsfUz+ZH6It6La7/q3M9s0RCgqTiFPs7UXZ05Q3Aihu3Pa8PvGQs?=
 =?us-ascii?Q?RTHVOP0rF4Q+nbKP8joa5bcT32mwqwCIDXDcNXycOe2M8RbCNnAyDbOctsmT?=
 =?us-ascii?Q?ewQPQ5vVDOyW2ty049us6RD94/s46DMY/mCP5wAfU7te6X8jdkeM3OcJPhuH?=
 =?us-ascii?Q?vTv6ieroAyv+VSxGR3T8/iQeYMX9MgRxD662PXZHB6mZ5Q4RiiVATcFiZHUG?=
 =?us-ascii?Q?6mKbRs4fSQampptlQY1UQ6LmmRUrqksBzsRBIfkpQtFV6UgjNi793d5JBtNq?=
 =?us-ascii?Q?RCaMsZGXr6NcANkOR44WXmGTd5t0v9fCc4NUFdD4cjlD2LrzPpB8sPLu8ds5?=
 =?us-ascii?Q?okF1kNRgOQd22rBHSgEPkmyHHIZlHwKCbsCN29G9NL7vvF532UH/BnxuQ84n?=
 =?us-ascii?Q?1u7pntl+XvbTxpO3uBu0v9BP0qZyrHIWksM2FbVPFn89Xeb0Ur3wSavDSYj8?=
 =?us-ascii?Q?DptoPKgSAQhDsr4IX8A+eFmzaxf1gojP/6WSQREIFbRAOrOx16ECJj/LF4ND?=
 =?us-ascii?Q?PpyKPDuP97pMequlmLKTuMQAxHFe7hCQrH0R1zvtsmGaubXmDQ0aHNBERCgP?=
 =?us-ascii?Q?pmoD8O/AZSQ/OpOa9XqeiqSj9oEPeRItH+muV4lOmpLIXKw+SDLMPTgsfprf?=
 =?us-ascii?Q?4dxD/Mf45+j/ZVqB0JQ=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SN6PR12MB2767.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3bcfb976-df37-4480-1b90-08da8c591b08
X-MS-Exchange-CrossTenant-originalarrivaltime: 01 Sep 2022 20:32:35.9215
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: ngY8nOfNxEO+NDJVvLRn4U/sDR7CCkKXwnUqa62XZOOaU44Gq14TeB20zuCRlHFFc8DoaolATWttdbsnuu9eEA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR12MB4259
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

>> It is basically an index into the 4K page within the hugepage mapped=20
>> in the RMP table or in other words an index into the RMP table entry=20
>> for 4K page(s) corresponding to a hugepage.

>So pte_index(address) and for 1G pages, pmd_index(address).

>So no reinventing the wheel if we already have helpers for that.

>Yes that makes sense and pte_index(address) is exactly what is required fo=
r 2M hugepages.

>Will use pte_index() for 2M pages and pmd_index() for 1G pages.=20

Had a relook into this.=20

As I mentioned earlier, this is computing an index into a 4K page within a =
hugepage mapping,
therefore, though pte_index() works for 2M pages, but pmd_index() will not =
work for 1G pages.

We basically need to do :
pfn |=3D (address >> PAGE_SHIFT) & mask;

where mask is the (number of 4K pages per hugepage) - 1

So this still needs the original code but with a fix for mask computation a=
s following :=20

static inline size_t pages_per_hpage(int level)
        return page_level_size(level) / PAGE_SIZE;
 }
       =20
static int handle_user_rmp_page_fault(struct pt_regs *regs, unsigned long e=
rror_code,
                                      unsigned long address)
 {     =20
       ...=20
       pfn =3D pte_pfn(*pte);
       =20
        /* If its large page then calculte the fault pfn */
        if (level > PG_LEVEL_4K) {
+               /*
+                * index into the 4K page within the hugepage mapping
+                * in the RMP table
+                */
                unsigned long mask;
       =20
-               mask =3D pages_per_hpage(level) - pages_per_hpage(level - 1=
);
+              mask =3D pages_per_hpage(level) - 1;
                pfn |=3D (address >> PAGE_SHIFT) & mask;


Thanks,
Ashish
