Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6E3BD5AB58F
	for <lists+kvm@lfdr.de>; Fri,  2 Sep 2022 17:45:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237326AbiIBPpl (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 2 Sep 2022 11:45:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48770 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233647AbiIBPpJ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 2 Sep 2022 11:45:09 -0400
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2067.outbound.protection.outlook.com [40.107.92.67])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3171D72850;
        Fri,  2 Sep 2022 08:33:24 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=A3mO5H+sSL5Bxybnm4hpSDsQdpBZLCXyeEuViUXtXpsYkwtdSx9l9mQSXlKz0u6/lbHhf/bN+Hj/lZdViLVlpznhRpWCuY+ljIcIX0+vi15dqjCiPLKLZil6kE4BLJZrowosRAkv21ZN/kjnHo7HBsVn2cVEKYlrELY3CVo+dpwKl7AIWa5+bcoFu0mEAaVo7gH99MuXl8RtcaolhfcmEqELf2wvgBT/fADO1I66eyUuH331soRskIpDAvoy/Diir40gqq+Rqkp9sE4RaBOSxMVThw1RyYgq4STf/lTVJoUsO6Jq4kv2PWGqXTlrYYV+4rxiAGA6o7fgc5sofL4cHQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=/e/MaCYgDSWDukAEScyZSLIWknf9kIUVITgOO/qLFuo=;
 b=QQ+B69RDCviyIWJnUI7obiXhpMPfREJpiAksxFB+g/PJIr6B+qp5fms494SFiVZtwt4lC+U1qYwhGfGHBmyjY0/tssMCYzn7B7v3k8KFiW1BmDoTcMCWpJsyvWR3mqsnkI5KGjdgVr4dJbCIJvYibXe6Qqs2i+s3KL77NhdB6+/MW7hAbmIhUoDRVFbh6ypYMHCzh1n3kv+CzJQD+CRtkMPZoWtN8CpWLzLPwrvqad8zakAOoHz4SAvEo0zwS6/IKdte4HM1P3Euvs76cgsKGwrecg+bKj3VqiAxfJlA4N+PhqH1B6oqYWjRq7rEeKquN6VFX/RmxOhtITBmBf0JGA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/e/MaCYgDSWDukAEScyZSLIWknf9kIUVITgOO/qLFuo=;
 b=RjW2e554Y7UvWhIwyB7sWfn84TvLdI0qyWqPBXNfAtodXBaybchqQxCyVmei/Gt4Jwj6UDOqBEz/KCQOnrP53zCPxYaeF7tB9xYlahg7viSyRcVtUFOod7/zpLplXHl80npHD5cH+mkfMHjZt86mpBKBNO+PKgMThQMkz8rCVqU=
Received: from SN6PR12MB2767.namprd12.prod.outlook.com (2603:10b6:805:75::23)
 by MN0PR12MB6200.namprd12.prod.outlook.com (2603:10b6:208:3c3::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5588.12; Fri, 2 Sep
 2022 15:33:20 +0000
Received: from SN6PR12MB2767.namprd12.prod.outlook.com
 ([fe80::e47d:1a95:23d5:922c]) by SN6PR12MB2767.namprd12.prod.outlook.com
 ([fe80::e47d:1a95:23d5:922c%7]) with mapi id 15.20.5588.010; Fri, 2 Sep 2022
 15:33:20 +0000
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
Thread-Index: AQHYrBDc30zm/ve2UUW13wSedLDd3a2nIMnggADB+gCAAMFX8IAieiDAgAC6pgCAAI/o0A==
Date:   Fri, 2 Sep 2022 15:33:20 +0000
Message-ID: <SN6PR12MB2767E95BA3A99A6263F1F9AE8E7A9@SN6PR12MB2767.namprd12.prod.outlook.com>
References: <cover.1655761627.git.ashish.kalra@amd.com>
 <0ecb0a4781be933fcadeb56a85070818ef3566e7.1655761627.git.ashish.kalra@amd.com>
 <YvKRjxgipxLSNCLe@zn.tnic>
 <SN6PR12MB2767322F8C573EDFA1C20AD78E659@SN6PR12MB2767.namprd12.prod.outlook.com>
 <YvN9bKQ0XtUVJE7z@zn.tnic>
 <SN6PR12MB2767A87F12B8E704EB80CC458E659@SN6PR12MB2767.namprd12.prod.outlook.com>
 <SN6PR12MB27672B74D1A6A6E920F364A78E7B9@SN6PR12MB2767.namprd12.prod.outlook.com>
 <YxGoBzOFT+sfwr4w@nazgul.tnic>
In-Reply-To: <YxGoBzOFT+sfwr4w@nazgul.tnic>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: MSIP_Label_4342314e-0df4-4b58-84bf-38bed6170a0f_Enabled=true;
 MSIP_Label_4342314e-0df4-4b58-84bf-38bed6170a0f_SetDate=2022-09-02T15:27:05Z;
 MSIP_Label_4342314e-0df4-4b58-84bf-38bed6170a0f_Method=Standard;
 MSIP_Label_4342314e-0df4-4b58-84bf-38bed6170a0f_Name=General;
 MSIP_Label_4342314e-0df4-4b58-84bf-38bed6170a0f_SiteId=3dd8961f-e488-4e60-8e11-a82d994e183d;
 MSIP_Label_4342314e-0df4-4b58-84bf-38bed6170a0f_ActionId=1b63f12e-da75-4303-81ba-b5284f0d9a11;
 MSIP_Label_4342314e-0df4-4b58-84bf-38bed6170a0f_ContentBits=1
msip_label_4342314e-0df4-4b58-84bf-38bed6170a0f_enabled: true
msip_label_4342314e-0df4-4b58-84bf-38bed6170a0f_setdate: 2022-09-02T15:33:19Z
msip_label_4342314e-0df4-4b58-84bf-38bed6170a0f_method: Standard
msip_label_4342314e-0df4-4b58-84bf-38bed6170a0f_name: General
msip_label_4342314e-0df4-4b58-84bf-38bed6170a0f_siteid: 3dd8961f-e488-4e60-8e11-a82d994e183d
msip_label_4342314e-0df4-4b58-84bf-38bed6170a0f_actionid: a761bc18-0f72-408a-a4c9-f96c88c60444
msip_label_4342314e-0df4-4b58-84bf-38bed6170a0f_contentbits: 0
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: b56adab4-e3e4-4686-2578-08da8cf8770e
x-ms-traffictypediagnostic: MN0PR12MB6200:EE_
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: Z4d4C7HS1ql1sACIuxX2/HGgjaGS3czWPVqtBcrDHQOLeDsr1ifId05oIxffsllzLrK/MizFkhIzMWrPcYEic/C/jbAq7l9ShOP2+9gDAfdsbiqDdVF7UdokMYttzcIeHOPLTzFTQ+2wTSkb66Qhp7gleVF5bfkTUyYtd1EOUTmxPnQn2dDOiKYIgs4Vhy+I5VZSAd1Lf9l1mJcNcShn3hd6zR/c1M7jHJ+pwdtT4iFGXjG/xcj6GbwtXie/bmJ8GZTY7WCoNoAqgL+gYfM8U8P/FFi/VEg0HwZn1R+5mWu1nKvQHJKw5JjzxGhoSuv+xv3SGMirVqY86Jq4ZDRy6jhwQulFraS9l1QOjBoVHN54Nq2WXMEWYr0q5Xdg240gaB2+1qaR9Mhw/yOjaw+q+7hTUJo959KrTw1pPZX9Gwlm3YB2GJW0gvfLiqcr7+4Q5csbFosJ1aAnMvv2Q+5NfU4qEiOK2OJyGsECdOh0buD+1Gk17eudE42o+uHq0K+Z3yl21WLQQcaAlwQw47wpspywHMANOUXhCqrQKciwoviHDqwpdSQNHxShV7t2fPSmhfnfEvubOwwnYHmPhaVBZ01bNEK/P3EZ/21LaYmnqIMChS5ET0byynuigKImPxxWojVEoYFcbMieigheia3mt2QvTHSfdIBCdFCWtfpO0p8iHz8kwBiCurssp7wdA4r5h8GHbzMsklQ49XREU7m1o30KeCk3213jY3G88sLYtMstmsn2FSROsHKKfF/O3uSny+Ld1YtpNO9qhEItu9tcGw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR12MB2767.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(346002)(376002)(396003)(136003)(39860400002)(366004)(122000001)(5660300002)(7406005)(7416002)(38070700005)(38100700002)(41300700001)(52536014)(71200400001)(6916009)(316002)(54906003)(7696005)(86362001)(2906002)(186003)(55016003)(26005)(8936002)(33656002)(66556008)(66946007)(6506007)(8676002)(64756008)(4326008)(76116006)(66476007)(478600001)(66446008)(9686003);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?1Xo1iQ3qri1NDgXPk+AdCY4TAXBKjPFLR+QqfccFU5kB4wilK2SRIz6817RS?=
 =?us-ascii?Q?tTf9kaJrSXSoGrDrRtr3dvjqe0dO2X41Sj0Msx/HIAKUpoEB0KRscQ4ZgBfm?=
 =?us-ascii?Q?Rj4JJ68U8Dh92ASzTwo1b8GkQMR45t8jxN/tERs/fHENYC0/QQIFHmI2kmhc?=
 =?us-ascii?Q?0LwO6PBPID+FBOowyY0zyIrrp7fXMiD/eZ6wZkHX4iZpCPSaNbJK0oUYVawy?=
 =?us-ascii?Q?BKnQlgGwhOXK+JfGYEQ5ReXJWVZ3VXXdweTvr5DjJMLHuwrN0yCVgwxfhd7B?=
 =?us-ascii?Q?RVcA8OgcyeQYpFGlDdyo3DKK9C6oJrrkDJ/4Z5RDpLJaUZCy9kMU4M8EDSiO?=
 =?us-ascii?Q?IkIE71ZgQS/1p+D3V/ZpSZYs7NNC27UoCVEHjgqO8vlpJCgJf9PR6n0rxBaw?=
 =?us-ascii?Q?PrV057TkA8YtdupUnzXRm2bLpiITBlyZG5e2HtkTYdRpu7Ak34Mq5sMZfvRI?=
 =?us-ascii?Q?ouNBxJdhSX1+kiRoZ3AvjlcEgQvgbElQ5OFKa9PkL5bVbQcuAIzsX0i/bSWr?=
 =?us-ascii?Q?o7/JbsloGkyGIyy2NmsHvpMeS+GENWnizay6aCt8vSDssXQVLTXPLRf9e71o?=
 =?us-ascii?Q?o0FXrid24vLhPJXEbNHrEeVlci9qV76GvFB9IKAMjY+qTVshC/2Hvq9wvnaF?=
 =?us-ascii?Q?ofnfsgVgsyy4qXpKCgS0STgsOg93oKkjFWAwD+8K6mDVLVilQji0B3SSOgYh?=
 =?us-ascii?Q?VMa7lvLshEUgZ8XVhPsdRXMpTp3kF9bcOnCQB2vpQPWrrzV0wkdRzTYbqqm/?=
 =?us-ascii?Q?TMcvjzRYfu2QLeZqOhDbON5XVtn7MvPd3BTjQZJcZQtGfKJOLjoXXXrg2iKj?=
 =?us-ascii?Q?KAYUDvUonUM6JEXKorm8SKyCjVD1J4MdbPS8NCSSFmcqw4i7BhCYSZ1iTxMd?=
 =?us-ascii?Q?hMhHv77pxwfxfSvpW6GxK68LUhGylRHeLtRGQMZaEINK9Hy2YvjdM0xkNC/U?=
 =?us-ascii?Q?ag+DYSC4WY+TLnGyxmfJY15f/SX/JPw+6zMJcXIzwL8lJsmOjw1ok9yAnb5Q?=
 =?us-ascii?Q?0O8HabrjQjGe4h1JTN63U0ZlzAVZBVH8+meLwdeLn9EvvjHupYYQ+shDDdXk?=
 =?us-ascii?Q?jDRjGHIyd328rCUzCh319iTrk6zrZ5G38WK+4wq9eFbaXoEFuWqb7E+9x+nK?=
 =?us-ascii?Q?Cr1geq5eV1kawnB5VjOc2aLCnKS8NEfV/iiKlDRnogWeQwYOD2tITmcsPfoh?=
 =?us-ascii?Q?kC+pc2TemVfnTNPOTMo1EFXPpf4FPY1rmGSIif8STc/hY2YrpyCs0MpiDk8j?=
 =?us-ascii?Q?xu2z0HnPqevUjhv4MzNKWlQnEXNbwS7eoul8fffx9xoOR7JxT0YKBDUBkyv2?=
 =?us-ascii?Q?DqxK+CrKYAGr6O8AY8dA3Q5a3Ubhjh0cPAdw8iNl7GHopeoLiys+ksoAWQmh?=
 =?us-ascii?Q?YRC6s6m9UPC5NBRKUVa1OvEXTCuEU1vwDGEkHCv5O7LZqbzakC3hACFmOQ+/?=
 =?us-ascii?Q?dxXwi9GuIRVhvGtRggMQXXHZdFhanMUTQSKs60kLudARK5mNaDaaSVxyYaAI?=
 =?us-ascii?Q?s3ZBG9d8TRgLBakVr6Lb7FEXAnjO+puT8GVChaX+K8cBzCQLNyvyN5pLdeJW?=
 =?us-ascii?Q?iocCeESssmuzn2Cse4Q=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SN6PR12MB2767.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b56adab4-e3e4-4686-2578-08da8cf8770e
X-MS-Exchange-CrossTenant-originalarrivaltime: 02 Sep 2022 15:33:20.2915
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: P5E/0gi+kOkWH+iVfRt146LJT8NBv7f82RGhqCNpWohbGWtnwh+oMz1WPZQqSPtffCXCJacfpTW9tOFGmuKQgA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN0PR12MB6200
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

>> As I mentioned earlier, this is computing an index into a 4K page=20
>> within a hugepage mapping, therefore, though pte_index() works for 2M=20
>> pages, but pmd_index() will not work for 1G pages.

>Why not? What exactly do you need to get here?

>So the way I understand it is, you want to map the faulting address to a R=
MP entry. And that is either the 2M PMD entry when the page is a 1G one and=
 the 4K PTE entry when the page is a 2M one?

>Why doesn't pmd_index() work?

Yes we want to map the faulting address to a RMP entry, but hugepage entrie=
s in RMP table are basically subpage 4K entries. So it is a 4K entry when t=
he page is a 2M one=20
and also a 4K entry when the page is a 1G one.

That's why the computation to get a 4K page index within a 2M/1G hugepage m=
apping is required.

>Also, why isn't the lookup function's signature:

>int snp_lookup_rmpentry(unsigned long address, int *level)

>and all that logic to do the conversion to a PFN also not in it?

Thanks,
Ashish
