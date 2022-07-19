Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CC923579184
	for <lists+kvm@lfdr.de>; Tue, 19 Jul 2022 05:56:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235670AbiGSD4a (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 18 Jul 2022 23:56:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48614 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229916AbiGSD43 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 18 Jul 2022 23:56:29 -0400
Received: from NAM04-MW2-obe.outbound.protection.outlook.com (mail-mw2nam04on2070.outbound.protection.outlook.com [40.107.101.70])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A509822505;
        Mon, 18 Jul 2022 20:56:27 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ALmed5h150/wAN0KrBLAp5xMy0SmBo4Bfx+U1GIxQToaAF5N5eGVZ9pW07DgoumvCiDYN5gYlCnl74DIwGLccs3cOrC/9qEWAFZAxGUIVVuchSA8ArXhMGmAejiTKvWKKhr/MF5k4t6WNVYunM2UUWc2aPdUFlqRq8rJrCQ1P+qGbHJQwIxyz8LYsI0g++fZsVZe1vXI3OwFIbCaMdgds0L83Ge3h7j+LNI9SdHkZNxQjlkxcA/9NVwMF48j0W8AKxkukTvHVitbJ5kdqliseAJrnVTmiH1J3ZaGJqyCzu1Ws1wNOAZU7Hpvl00EoCGcknz/Rc2DqD6+uWCIgowVgA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=co/3KiVkXMLfu3IBfKvB8SubVueg6Nx3kYA0JM5vHkA=;
 b=iY8PKP0xVGPSQEEN39mprejbv37jOfR+TPVEtpMxthaY1O0OyUo6PF1LDmpgtjBd48h1qJeYjsS/u3DlSGf4POuVvo0IAawFtyqyQ6nxbL7JqyB8W7TNMh8XM/4cxASdvxKktyBzu6/kcAHYh4tJEPfzdcoaGdG+OXSi5e86+TR1d0hyjfWs1aoWtXFV3g+pUMmMejfY8YhOYNtwktQfQERatf1OO9o1basn/gi2ZYI9MqlehpUTxfBH9mgDDpkK5ycYvhBzJd1+GrdAfpKCRVRNX+Yd+DfT6Y2PAcxt3JyfaMaipxHbJ6ng84DmbuivYPUZCTNTivcUT4JdcEdM6A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=co/3KiVkXMLfu3IBfKvB8SubVueg6Nx3kYA0JM5vHkA=;
 b=A3U8Nf3K+wnsm+DdWoH6CSMEO58Kg4uZLkg9CLVMdk/6pspSdum2WT+1xMR+xxnDNAEH6f5xPxwhuxw7MjerIWc/Qe6WFSsW6pK4AE30pOcoyx3yRycGkAvuKP+GwGrm5PQTF90jn+Xz/g4CDop3wNwvn1RYb4a/F3w9XU6K4z4=
Received: from SN6PR12MB2767.namprd12.prod.outlook.com (2603:10b6:805:75::23)
 by PH0PR12MB5607.namprd12.prod.outlook.com (2603:10b6:510:142::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5438.23; Tue, 19 Jul
 2022 03:56:25 +0000
Received: from SN6PR12MB2767.namprd12.prod.outlook.com
 ([fe80::8953:6baa:97bb:a15d]) by SN6PR12MB2767.namprd12.prod.outlook.com
 ([fe80::8953:6baa:97bb:a15d%7]) with mapi id 15.20.5438.023; Tue, 19 Jul 2022
 03:56:25 +0000
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
Subject: RE: [PATCH Part2 v6 03/49] x86/sev: Add the host SEV-SNP
 initialization support
Thread-Topic: [PATCH Part2 v6 03/49] x86/sev: Add the host SEV-SNP
 initialization support
Thread-Index: AQHYmcRAcxQqbwBTdUCpGH+ovKgAp62Ei1rQ
Date:   Tue, 19 Jul 2022 03:56:25 +0000
Message-ID: <SN6PR12MB27674548A8C8ACF5E53C0DB78E8F9@SN6PR12MB2767.namprd12.prod.outlook.com>
References: <cover.1655761627.git.ashish.kalra@amd.com>
 <8f4eef289aba5067582d0d3535299c22a4e5c4c4.1655761627.git.ashish.kalra@amd.com>
 <YtPeF0r69UbwNTMJ@zn.tnic>
In-Reply-To: <YtPeF0r69UbwNTMJ@zn.tnic>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: MSIP_Label_4342314e-0df4-4b58-84bf-38bed6170a0f_Enabled=true;
 MSIP_Label_4342314e-0df4-4b58-84bf-38bed6170a0f_SetDate=2022-07-18T19:49:08Z;
 MSIP_Label_4342314e-0df4-4b58-84bf-38bed6170a0f_Method=Standard;
 MSIP_Label_4342314e-0df4-4b58-84bf-38bed6170a0f_Name=General;
 MSIP_Label_4342314e-0df4-4b58-84bf-38bed6170a0f_SiteId=3dd8961f-e488-4e60-8e11-a82d994e183d;
 MSIP_Label_4342314e-0df4-4b58-84bf-38bed6170a0f_ActionId=ce5d9670-5f4a-45da-aee9-03296a8a445f;
 MSIP_Label_4342314e-0df4-4b58-84bf-38bed6170a0f_ContentBits=1
msip_label_4342314e-0df4-4b58-84bf-38bed6170a0f_enabled: true
msip_label_4342314e-0df4-4b58-84bf-38bed6170a0f_setdate: 2022-07-19T03:56:23Z
msip_label_4342314e-0df4-4b58-84bf-38bed6170a0f_method: Standard
msip_label_4342314e-0df4-4b58-84bf-38bed6170a0f_name: General
msip_label_4342314e-0df4-4b58-84bf-38bed6170a0f_siteid: 3dd8961f-e488-4e60-8e11-a82d994e183d
msip_label_4342314e-0df4-4b58-84bf-38bed6170a0f_actionid: 6a1d14b5-9990-4a40-97d3-faab27c17c31
msip_label_4342314e-0df4-4b58-84bf-38bed6170a0f_contentbits: 0
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 4f832b28-8b71-4af4-659a-08da693aa6d2
x-ms-traffictypediagnostic: PH0PR12MB5607:EE_
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 6Qe035b6RUHSGMOTN7gojZ/cHIHSsy5PaWyAGDtq7+kv9oxc9FA9JyPGCNL8ODTIa2p9TQr3ovYtB0JwIcqZJo/rhnj/SJx3EkMFIqJurHNe3jyFug+Xi6S2ifX39v1TYqDsWSx8wxuqr7Vz8bChqlCkOJ0mNkxZPwH5gme4tXGwm+elcL6ZtRGq58nrmIO5GYLT5CbSm4jVjSRS8CiPQWZZO6jmRbHREczYLbYHcYtqjB2FOyIGJ9X9tPE14XMQEfPivgEMkkchMTBj73kQFZATRpKW80bJHWfENcFbDt0aV8N2QegK5zZOzlgOo5gj5Ob68kFTCliAtU0HxbBCv7iNy/jwevHIWSNvyTMJJmZSQT4zwtDO+JrO1z/YVnAut1zqT9NX3xlimTdtmaj06GpDo/zryVneB0ht8IPvQJJ0T1fq/XGVTX0amcwwq5tXkyenEZmsw36hoeQ4JoFG9xWZL5Ngw+Z0+LSH78Hv6QBNgaLE6HV4XSfrFEio0xbyOfhdRU3nWfr7ye2sGO91Y2RisxjqDxSo1gOFFmlTEy6e1/2C4+UbGZ3JvLnzF48IdwtuMShCeS4zOW/1cKTIDkOv+dHPSU6yp35mngz9/1It/+SKT4aU+sKoCRpbwaTc79Itf5XuVr0ZKnbVVR81+hwx32dvfHCNnsPu+nHUVXfPHRJZxFcIlxfqcGPssafctN+3grx+YjOYycuHgdYfncj0ou4F/kqtomwbJ7KsyU2CcJ5NxGrqJwXSd+OFHJOAzAWi/Sn62689wrqC29N6ji9Ivce3kLFOrB3zq/WiJlRXN6zYp8pwei4tcV2VSXkn
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR12MB2767.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(39860400002)(376002)(396003)(136003)(346002)(366004)(71200400001)(478600001)(38070700005)(41300700001)(86362001)(6506007)(316002)(186003)(83380400001)(54906003)(6916009)(26005)(7696005)(8676002)(4326008)(66556008)(66476007)(66446008)(7406005)(64756008)(5660300002)(52536014)(8936002)(7416002)(66946007)(2906002)(122000001)(9686003)(38100700002)(55016003)(33656002)(76116006);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?c4ruiZHSohsUtwr8ih81VGbgQZ0yTz9MoqshbPLj8ZmnG9aUNaPB44gA1JSg?=
 =?us-ascii?Q?Ge0Fc6jwJ0wVzupJ9eVnQVcil7typcPLxE7k0IVAnEkz8NmRDokwDql8oy93?=
 =?us-ascii?Q?TCLjQn2L1Si0wTTnRJqv+f+abPywfI3c53oDpVvQv2fGi9EkdJIw/auwQyBv?=
 =?us-ascii?Q?TF5KPf/ICgrPe9v0erukwkGe9qs8JpXpPqLGgk/8aBo7xTLCcr/LSHVPRdps?=
 =?us-ascii?Q?EYCB+NwiFMb7NkLJJBpjXe2uwDSoVFJNsoaKARediimctxL2KRLuSCM6wnKq?=
 =?us-ascii?Q?yfez7tkcMarlZO7GIOt9PaI3PTmAPwnHNgH9vHX6LAdY+rm9wtLdNnzLMItT?=
 =?us-ascii?Q?yIaSjEY48vkp6/sZWMhptksyfMPK4SalYnQs9GX/y7smWVzW3BVH4Ld46wgz?=
 =?us-ascii?Q?H4vHk5sOZTH3Gk7LJHnC3sLPuCjpLfcIt+rHxg41YIV3+zCTtzEXSMYws27+?=
 =?us-ascii?Q?mLkqeC7ovQfEk22rkURmigYz8dfB/RXrG8e5o05JnHPOKgPlhXnXAx8TxTos?=
 =?us-ascii?Q?ILo6ZBFe4ZLl/blf226rGdJjzLBHtl3/mdrBGU0YgoZroGc60IklnOkOz/NJ?=
 =?us-ascii?Q?jlfL+PZO3f1QQZET+WVhS9XkaTxEb2gjv2V2wIeweW4ciAlklibapf5XOCKD?=
 =?us-ascii?Q?Z2dqUJd9G2K8CD5VyGrZ3j5QFmGN5S13eXNWJX/9g8xeeYFwb0Fuu9wrtJW3?=
 =?us-ascii?Q?6txtPJYT5D41Dzv4XBzToy7G/D5+Zg7R3zaElGj4GZdWv67csp2VsXfWy0f2?=
 =?us-ascii?Q?BdwJwLArJgKQlCxIycOrpXBPLsuyBu/2qjkgoe8RfWlI83ugyKvk59Rm8oCA?=
 =?us-ascii?Q?slV0vIDey4ESGQR55nFHJtTSPzqsHqt3uxXSbDAc123UF+uP2Cwjcv1CgJGb?=
 =?us-ascii?Q?nJGvlnMlTIIH6DOADK8zvpRILaLtx5g8cVBmUjtlhSr4X3AR58sz2VFb5FN2?=
 =?us-ascii?Q?EMaDRuf3+70hpq89oVtdv534xTYHG/BkjhtVb6EKEmwHqN9G9xYQ7gJl/ncY?=
 =?us-ascii?Q?bNqPinJ9wrJkNdCRTtXZHrsiNfN7pUrZpG5BGtxIZN8iJ8YXxP1m+++eeEsI?=
 =?us-ascii?Q?GT/4cT+YgmPaVnb+YBUfyjkbXB1o6+18EdmBgzAPrBgYWb9I9SqYePjq3WNn?=
 =?us-ascii?Q?vNa0uzGdohUzc90YTdzLzGqjTmcozBx/TDOqyOTafF+t37vNXvEnw4cABQMK?=
 =?us-ascii?Q?ReHdcl1SAXr7Gzi0ydiMatntgTlKPYJOCGwtPUUonwO6PRYH9tVDM1zOugAA?=
 =?us-ascii?Q?pNZkV9XB+l8zzs8EvyC3hFfiDNBSUwbG1TprPmxDmO6MlRKDNSIRkrKAEtds?=
 =?us-ascii?Q?AVVOdOb6uQKMR1IswI3G8bcbDAigiNBBgqq4FcDOIFTmDqK7fYciZHosfKTL?=
 =?us-ascii?Q?QczaedlGv2TwM2/AAhIT2uYHabEbIZSkmtczcexqI1gmJjFFuFnRsGCrN5UN?=
 =?us-ascii?Q?d0VgNvuD/IUBclwHd3VZcD30707Un1EuhdkLunGEdg7gaTL4tKWMk9kh6co3?=
 =?us-ascii?Q?EmJ6J6U0YAih9Dk8J5AWV44kZgkdDg+HFnWeQfT74BEGAi1hfEcTsMvTj4Iq?=
 =?us-ascii?Q?xM6e0x/WlL31B7G3heE=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SN6PR12MB2767.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4f832b28-8b71-4af4-659a-08da693aa6d2
X-MS-Exchange-CrossTenant-originalarrivaltime: 19 Jul 2022 03:56:25.3860
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: nWB9WlVp7bFCEBxRHdQd3Q24VCJDkhEAPtMI7vxmF9Z0fLW6DsY1oMzF8zQ5XPCrRm/1BQLMdrDe7ntZz4xquw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR12MB5607
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

Hello Boris,

>> +	 * See PPR Family 19h Model 01h, Revision B1 section 2.1.4.2 for more
>> +	 * information on memory requirement.

>That section number will change over time - if you want to refer to some s=
ection just use its title so that people can at least grep for the relevant=
 text.

This will all go into sev.c, instead of the header file, as this is non-arc=
hitectural and per-processor and the structure won't be exposed to the rest
of the kernel.  The above PPR reference and potentially in future an archit=
ectural method of reading the RMP table entries will be moved into it.

>> +	 */
>> +	nr_pages =3D totalram_pages();
>> +	calc_rmp_sz =3D (((rmp_sz >> PAGE_SHIFT) + nr_pages) << 4) +=20
>> +RMPTABLE_CPU_BOOKKEEPING_SZ;

>use totalram_pages() directly and get rid of nr_pages.
Ok.

>> +	 * kexec boot.
>> +	 */
>> +	rdmsrl(MSR_AMD64_SYSCFG, val);
>> +	if (val & MSR_AMD64_SYSCFG_SNP_EN)
>> +		goto skip_enable;
>> +
>> +	/* Initialize the RMP table to zero */
>> +	memset(start, 0, sz);

>Do I understand it correctly that in the kexec case the second, kexec-ed k=
ernel is reusing the previous kernel's RMP table so it should not be cleare=
d?
I believe that with kexec and after issuing the shutdown command, the RMP t=
able needs to be fully initialized, so we should be re-initializing the RMP
table to zero here.

>>
>> +
>> +static int __init snp_rmptable_init(void) {
>> +	if (!boot_cpu_has(X86_FEATURE_SEV_SNP))

>cpu_feature_enabled
Ok.

>> +		return 0;
>> +
>> +	if (!iommu_sev_snp_supported())
>> +		goto nosnp;
>> +
>> +	if (__snp_rmptable_init())
>> +		goto nosnp;
>> +
>> +	cpuhp_setup_state(CPUHP_AP_ONLINE_DYN, "x86/rmptable_init:online",=20
>> +__snp_enable, NULL);
>> +
>> +	return 0;
>> +
>> +nosnp:
>> +	setup_clear_cpu_cap(X86_FEATURE_SEV_SNP);
>> +	return 1;
>> +}
>> +
>> +/*
>> + * This must be called after the PCI subsystem. This is because=20
>> +before enabling
>> + * the SNP feature we need to ensure that IOMMU supports the SEV-SNP fe=
ature.
>> + * The iommu_sev_snp_support() is used for checking the feature, and=20
>> +it is
>> + * available after subsys_initcall().

>I'd much more appreciate here a short formulation explaining why is IOMMU =
needed for SNP rather than the obvious.

Yes, IOMMU is enforced for SNP to ensure that HV cannot program DMA directl=
y into guest private memory. In case of SNP,
the IOMMU makes sure that the page(s) used for DMA are HV owned.

Thanks,
Ashish
