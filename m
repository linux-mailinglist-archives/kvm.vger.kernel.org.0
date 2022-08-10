Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B1F8A58E5E3
	for <lists+kvm@lfdr.de>; Wed, 10 Aug 2022 05:59:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230367AbiHJD7o (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 9 Aug 2022 23:59:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58450 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230261AbiHJD7j (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 9 Aug 2022 23:59:39 -0400
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2081.outbound.protection.outlook.com [40.107.93.81])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 27000E37;
        Tue,  9 Aug 2022 20:59:38 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=nQjep9eoxvaHJ+/zwbtd43Vr8e+x7SONqPsYvJzPvMQXBI50QD9EZamHzaGq5lhhEw8kAmmyp7l8RhIcwySBBRnT8J/tjhG5gXQF3f2k/VKhS9N35k+xBOf+/U94+XEUqOnFJz0E/+hK2KRJi4VyrVC88+QloYasQjMTvfg1fPrSWqd9BBkGOPohp6P3Gkf7eHeg1QN2gTBZe92sxYDs7m9B8Fwq/xm0gRXlzXRR31t5YwJG/++pnLBFCkHLUmlNz5inPEhQuNvqG3jFY3GsmN/TVzLGoZ9WDU7ctyK1JHGx9GUzYGsYhAHy/Zjsyeie4gFS5hC7dLBZEU6U5Rm0uw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=RVyAlXXClJnTOBhhudIbdrmRlbWwQU2uEqf2K9VNDFU=;
 b=AiP9d+q3nI1wd2BqAucBI90Ct3FOXgKVl0Bv1ftVWY++OuQ6uFnxEuIJ7m5DksUmgAFojg0DfwP9a0N4SJnsRcu6u8BtUttSNfh70kDJCE2QX4NnecQtWvH/7YlRw8ETkdWYlPYsE6OrrDeA4FCqGw7aC02TOLSbg2alKTifN99/0uVFwsxrCrOGluqC7H9Gyp2lK4lMy7jrb76fd6TI6ymuokymhleGpgFqMqB/7bxJv4bKFL0rDevym/GMmUt3Ty5LLPwUGS2NsOhrMQYCUfHrCTKU9ke/6oK8BQmNkVEoWBl/m0YBrXtMrW91xRNUupiu8GcOfuHthmjm44PQMQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=RVyAlXXClJnTOBhhudIbdrmRlbWwQU2uEqf2K9VNDFU=;
 b=CKUmnbqelvrhexMbKopZ2nvCbZW2MeRcqZTPmYez88QYnTytfDR3K2Zi7/GdcmLO1NlRAXUGzqdiZrDmzkL3jd6oIJ5sAKGLRH3xwcvgn3sdKCGxUwhVpA8vEUtwD0Ii1MNiDH6s31q4fEWsl6ITS2uloifvrPWv+pImMUz6SY4=
Received: from SN6PR12MB2767.namprd12.prod.outlook.com (2603:10b6:805:75::23)
 by MN0PR12MB6173.namprd12.prod.outlook.com (2603:10b6:208:3c6::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5504.14; Wed, 10 Aug
 2022 03:59:35 +0000
Received: from SN6PR12MB2767.namprd12.prod.outlook.com
 ([fe80::8953:6baa:97bb:a15d]) by SN6PR12MB2767.namprd12.prod.outlook.com
 ([fe80::8953:6baa:97bb:a15d%7]) with mapi id 15.20.5504.020; Wed, 10 Aug 2022
 03:59:34 +0000
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
Thread-Index: AQHYrBDc30zm/ve2UUW13wSedLDd3a2nIMng
Date:   Wed, 10 Aug 2022 03:59:34 +0000
Message-ID: <SN6PR12MB2767322F8C573EDFA1C20AD78E659@SN6PR12MB2767.namprd12.prod.outlook.com>
References: <cover.1655761627.git.ashish.kalra@amd.com>
 <0ecb0a4781be933fcadeb56a85070818ef3566e7.1655761627.git.ashish.kalra@amd.com>
 <YvKRjxgipxLSNCLe@zn.tnic>
In-Reply-To: <YvKRjxgipxLSNCLe@zn.tnic>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: MSIP_Label_4342314e-0df4-4b58-84bf-38bed6170a0f_Enabled=true;
 MSIP_Label_4342314e-0df4-4b58-84bf-38bed6170a0f_SetDate=2022-08-09T22:07:48Z;
 MSIP_Label_4342314e-0df4-4b58-84bf-38bed6170a0f_Method=Standard;
 MSIP_Label_4342314e-0df4-4b58-84bf-38bed6170a0f_Name=General;
 MSIP_Label_4342314e-0df4-4b58-84bf-38bed6170a0f_SiteId=3dd8961f-e488-4e60-8e11-a82d994e183d;
 MSIP_Label_4342314e-0df4-4b58-84bf-38bed6170a0f_ActionId=f0ffc751-fb2e-4796-9437-0d1a55912b87;
 MSIP_Label_4342314e-0df4-4b58-84bf-38bed6170a0f_ContentBits=1
msip_label_4342314e-0df4-4b58-84bf-38bed6170a0f_enabled: true
msip_label_4342314e-0df4-4b58-84bf-38bed6170a0f_setdate: 2022-08-10T03:59:32Z
msip_label_4342314e-0df4-4b58-84bf-38bed6170a0f_method: Standard
msip_label_4342314e-0df4-4b58-84bf-38bed6170a0f_name: General
msip_label_4342314e-0df4-4b58-84bf-38bed6170a0f_siteid: 3dd8961f-e488-4e60-8e11-a82d994e183d
msip_label_4342314e-0df4-4b58-84bf-38bed6170a0f_actionid: ad40b16e-761b-4707-a83d-4907c7d4a2fb
msip_label_4342314e-0df4-4b58-84bf-38bed6170a0f_contentbits: 0
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 06fc8f66-1329-47ad-3f5e-08da7a84bc98
x-ms-traffictypediagnostic: MN0PR12MB6173:EE_
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: ZXNgQ4a0ZAaHDvDNQw0zscYrYL63zpFooAumnFKkgXmjl3lrsg0tUrGBJUudjhvAzpv7o7uyt0x5zSLm+IcqRtfrbmm5ByDbnClEUDfJXdfUTpaNzR+8JFCs1X8XfzbiMVYja0faANwPERbZ4z7eOT2xQaaDSWXUibTf5g7fD7XNvonCebImKoRxelpLqle+T7et147fwBcKzOvoHWDjWto6A+e/J6vfJgSFgkBa8iHalZueMxVsB7b22RCzQIEpARGZhyUw0fvQEU6mSTbIup+mHclK5ErSFF3VcqWoS5ycTX8fzEfo2Y/YND75jVH5eEt1/9g+hA/6FdqDDfG2AEnrAXS5YKALtfIf3fUlYoqgKJqOeO19ssll8nfFbb6UTTU3YLj3MEgMSngrCN2GCoROeENyWPaXAhLcirbyl5oo2IeCZsczhFSCoQkCT+9qLXgjMtD63QvWQ2NBxvv3Bp9sQ+7WkrvESibEXM8bhOtgKc2PeawzhNNBFaWVHmbkCbwJheoPtRmEFlVqpO/BaZbRAocvMEAVVA7Yik/MSj3FQv/hsjiQIgj/eEBW1i5dW5iY1VGCqN2vaIUu8QJ/sVwyJBj8pkNAKijO1FzW8cj2djKOt+og1SfXycE4JODvWFaVdkEdxpfvcgJ2YC3+FHE+3DAoDmq3GBs28EqXHGJA+Nd3vgqYAZYFTG6u0zQjMz6ghe0xmrwac7MJACYr9InoivUq3JHcFy8gkNpaQf55Ej+7fV8G2J92vzYxwjcGDZ8dsgRIbXz3lw5GJgEgP5TRjndFxhRK3s+O8BmhuxxNizd7OHzgF7wEdkZi58UF
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR12MB2767.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(39860400002)(366004)(136003)(376002)(396003)(346002)(55016003)(26005)(7406005)(7416002)(5660300002)(41300700001)(33656002)(9686003)(6506007)(122000001)(186003)(2906002)(83380400001)(7696005)(76116006)(66446008)(71200400001)(6916009)(66476007)(66556008)(8676002)(54906003)(316002)(64756008)(86362001)(478600001)(66946007)(4326008)(38100700002)(52536014)(8936002)(38070700005);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?CN1rolJr8WgodNVdnFtFHmt1sMCZY1H57jgGOsvzg5IeIoeJkIfxGzju2d/G?=
 =?us-ascii?Q?iUobtrHjZll7XNBDJdS3mksCn/j0s10pUzqhYNwT35U7UD6Pn7LZiNi/ArFC?=
 =?us-ascii?Q?dP2KfSm3cBl8s6dVyFEZlwhbMVJDzQKkN08/PgAZEH36HKCIIpgS8wZ7Uhiv?=
 =?us-ascii?Q?GTHEydMM8HELWSmoD1nhsHhRTpxjhkFiAU5LnP6d4MHj3NizIuKOKCaA6Y//?=
 =?us-ascii?Q?qevfzBew53sYJRUzyhMC+PDknGC1nZggVISdkDcKK+1G3/TdmCUOFSFcSC67?=
 =?us-ascii?Q?kGelnNsJ9Vz9nubrHqL2LSPnRo6wh7kAo+DQT/AyHnYOybMLWS5d7KXtLPLe?=
 =?us-ascii?Q?I8p8augFF6vC0NiMssAmGrjR8bPtTbAOAMdisLkGmIn7d1J7KV9tLh8FGnBj?=
 =?us-ascii?Q?ASfuHbtI2lJfHlCJzs/krQ6aI58OkNYMmHgmpROFFx/b/M9Ej+Y1FAut57ad?=
 =?us-ascii?Q?05wOFyVPBJktRUzxqrOO7wd5bCZhA1djZUGnIAs6Or6n4OBMmxSAgX1jZbco?=
 =?us-ascii?Q?jHrl9DsPn/e5Qz3AeLWUInmoL0Ww//qCV9bUcLzg0vgUaBvrT74GsemFal58?=
 =?us-ascii?Q?uK6qFefR3rRLTSh7mPpJvjYGHggFXkJNwS0b1lGZrXEcNqQGs9M347cIlXdo?=
 =?us-ascii?Q?3EksV7UpZbVuGJYu4Qw5vC/1FQRf6FYhM7G3gvSFBg4X56OxkuY/vJ+q9ert?=
 =?us-ascii?Q?smEdkRGt0Enybj4vlMX3eyFwsrUDW4dG6vhCPEKEJrAdHPgZmWp9XhUdp0zx?=
 =?us-ascii?Q?TO03L+MrLI0QBG+5NEDDws4t550Mhf5Rpg9n4KCbsy75bMhXtQojUuoJ6/K+?=
 =?us-ascii?Q?Swj4QHbOP7FA0bf7uAxZuD6Ymecx7Innju9O6DBxX9E5ZLrMurnsz53E7qRR?=
 =?us-ascii?Q?wT2pOLLqpoT4KpCrT4ARe+ACkHT+kj8pWMYkEOp2BY45yl1m6UFsd6ovG3CT?=
 =?us-ascii?Q?s/XUPrTTO0hqpbUnLI0FmvESMFb4HvMtpxXzT4veaZgE72ndl1g19NdIYiyz?=
 =?us-ascii?Q?Ui7W67o0KBerEn7BLpnXq61v00zKhsQRyJgD5sKDfUGl9TbHcr5eqfsy75M7?=
 =?us-ascii?Q?rFWy4Ns8uUfR71qKUCmbzsW0OYh9rV6DvJKN6WBNLW6vRL7gJu3m31DhEBFJ?=
 =?us-ascii?Q?KW6i2FjRGJVubsZC7uFIi9lD33UCdjfWynWWZ5kDnW5esMZIJH5VEJXtdvXx?=
 =?us-ascii?Q?ompYSjK4L7KMppCiCOdmtQLLAfEGEb+mqaJ/A3DfCIGAjxa6VYQ8ZaD3SDMW?=
 =?us-ascii?Q?5dm/XHNjzouXPuxjonts0A91+Csk9qnGSyqBvCuy9bXKqwADquX8hsPEShC6?=
 =?us-ascii?Q?pAlz0+XbUSV7bjFo5g45iFdUBr3zk4IxdbsBtX5+6Ts6ugXla1oAnJvE8CNv?=
 =?us-ascii?Q?0/4vXQKXPsPHpr3sRQuw4JaPcUzzXo/VupsK6FQyO+gage7zxshOB/6zaZzO?=
 =?us-ascii?Q?UK8TNEnBsgx7LDOKY1y3Z36GJ2IXrHe2hpQYU9yWTyPTjQoruN70xiFEHWls?=
 =?us-ascii?Q?oU+axxL4vlvigfWjL5sMf4yhgnWlJeHyc7cm9Br7Fen3uJzqK8rFr+sqKzui?=
 =?us-ascii?Q?2tEJRoMo9APRCxKgvFA=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SN6PR12MB2767.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 06fc8f66-1329-47ad-3f5e-08da7a84bc98
X-MS-Exchange-CrossTenant-originalarrivaltime: 10 Aug 2022 03:59:34.4556
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 7Bo7MCChBTMYfWrBZArApoNVcF160NUE+YrtQL4AIwhwiRAvLDaf7HOn9WFHMKt9STpmrGi/0AC8jq+OA590GQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN0PR12MB6173
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

>> When SEV-SNP is enabled globally, a write from the host goes through=20
>> the

>globally?

>Can SNP be even enabled any other way?

>I see the APM talks about it being enabled globally, I guess this means th=
e RMP represents *all* system memory?

Actually SNP feature can be enabled globally, but SNP is activated on a per=
 VM basis.

From the APM:
The term SNP-enabled indicates that SEV-SNP is globally enabled in the SYSC=
FG=20
MSR. The term SNP-active indicates that SEV-SNP is enabled for a specific V=
M in the=20
SEV_FEATURES field of its VMSA

>> +/*
>> + * Return 1 if the caller need to retry, 0 if it the address need to be=
 split
>> + * in order to resolve the fault.
>> + */

>Magic numbers.

>Pls do instead:

>enum rmp_pf_ret {
>	RMP_PF_SPLIT	=3D 0,
>	RMP_PF_RETRY	=3D 1,
>};

>and use those instead.
Ok.

>> +static int handle_user_rmp_page_fault(struct pt_regs *regs, unsigned lo=
ng error_code,
>> +				      unsigned long address)
>> +{
>> +	int rmp_level, level;
>> +	pte_t *pte;
>> +	u64 pfn;
>> +
>> +	pte =3D lookup_address_in_mm(current->mm, address, &level);
>> +
>> +	/*
>> +	 * It can happen if there was a race between an unmap event and
>> +	 * the RMP fault delivery.
>> +	 */

>You need to elaborate more here: a RMP fault can happen and then the
>page can get unmapped? What is the exact scenario here?

Yes, if the page gets unmapped while the RMP fault was being handled,
will add more explanation here.

>> +	if (!pte || !pte_present(*pte))
>> +		return 1;
>> +
>> +	pfn =3D pte_pfn(*pte);
>> +
>> +	/* If its large page then calculte the fault pfn */
>> +	if (level > PG_LEVEL_4K) {
>> +		unsigned long mask;
>> +
>> +		mask =3D pages_per_hpage(level) - pages_per_hpage(level - 1);
>> +		pfn |=3D (address >> PAGE_SHIFT) & mask;

>Oh boy, this is unnecessarily complicated. Isn't this

>	pfn |=3D pud_index(address);

>or
>	pfn |=3D pmd_index(address);

>depending on the level?

Actually, the above computes an index into the RMP table. It is basically a=
n index into
the 4K page within the hugepage mapped in the RMP table or in other words a=
n index
into the RMP table entry for 4K page(s) corresponding to a hugepage.

So, pud_index()/pmd_index() can't be used for the same.

>I think it is but it needs more explaining.

>In any case, those are two static masks exactly and they don't need to
>be computed for each #PF.

>> diff --git a/mm/memory.c b/mm/memory.c
>> index 7274f2b52bca..c2187ffcbb8e 100644
>> --- a/mm/memory.c
>> +++ b/mm/memory.c
>> @@ -4945,6 +4945,15 @@ static vm_fault_t handle_pte_fault(struct vm_faul=
t *vmf)
>>  	return 0;
>>  }
>>=20
>>. +static int handle_split_page_fault(struct vm_fault *vmf)
>> +{
> >+	if (!IS_ENABLED(CONFIG_AMD_MEM_ENCRYPT))
>> +		return VM_FAULT_SIGBUS;

>Yah, this looks weird: generic code implies that page splitting after a
>#PF makes sense only when SEV is present and none otherwise.

It is mainly a wrapper around__split_huge_pmd() for SNP use case
where the host hugepage is split to be in sync with the RMP table.=20

Thanks,
Ashish
