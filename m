Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BEA1458737B
	for <lists+kvm@lfdr.de>; Mon,  1 Aug 2022 23:45:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234882AbiHAVpL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 1 Aug 2022 17:45:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40158 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233927AbiHAVpJ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 1 Aug 2022 17:45:09 -0400
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2087.outbound.protection.outlook.com [40.107.92.87])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C23E42A421;
        Mon,  1 Aug 2022 14:45:07 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=fCZ4t8H9wu2PtheIuapXviQVwb/ZoMRGZKyQ5RsxnkWrXw2l8X+yjT1hSJ6e01CNhe4qu0lOJYwc25oMYQlPvp6QyPcJh9pO/Y8DZ2kjx4IobinOu9VIQlVTzVfq9mHZycUj8oQthq+b62GHIjglJ7SKGbgLJ3Rywq9n3RS904R7PPlEVlWe2pzdWpQMFNOHQkCZsRJVLlNRJkrMD8MugF5bykthAdQSOHOS/EdQIqiF2FrVdmGEX586/NrqVS+jECU35I3JCFQefr4/J1rHnQ5aUMWTO3+owgpothv9PTkrwVSrAt3Af7AdZR9M3B+fMS3HKnNw9kboCKfwdT74Dg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=SZDFLcmPcokXeWeZX2f4kyjmDX6JsuHFuayq1dl49Zk=;
 b=ISxpskfyZ4nCMv8KgkCHLMJ4mGUiqHLB8aSNT2CR4iwGAx7JYraBGUYUjbL1RSrAC19+kKx1fkX9zo0CjYljSMNZVriIVLcvIqhdI/hLMeKgP23t3nYEvfaHsJ/9TuttM0mqwmPI+AGcZzS25zpIBKFRhqAvo9Bwm5I3zWZXLtdgQNVPG7JemB9ZoL/i/DD7c297DhyMJ1i3FVUNA5T4nDrBQ7+yW8tv9E926ogg8JLAjSHTSwubHIkvfAAVNUuH1OTFIwvgUcw0s5zVxOA7VvP7ps2Qn65uYrr+MtZpqmP6LqmUKEVxTYQWcPotHhrj7qdyba+hn1wpnpAb0QWu0g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=SZDFLcmPcokXeWeZX2f4kyjmDX6JsuHFuayq1dl49Zk=;
 b=v9V4TQ1OPFfo2VrsR8UtIq4y3m1LvnZDG/71+KStV0l3dz6+BHuba1E+gHa/v6mJcPvr1nK5xZIrn2bcANAOuyyJhURknogXysWlW2Vc1/sc3NWy/fMlh8t/75JhzyPvAMFhDyHsx5J93XBs0583oGPGcLfKdqqf90l2YDGn3+w=
Received: from SN6PR12MB2767.namprd12.prod.outlook.com (2603:10b6:805:75::23)
 by MN2PR12MB4270.namprd12.prod.outlook.com (2603:10b6:208:1d9::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5482.11; Mon, 1 Aug
 2022 21:45:05 +0000
Received: from SN6PR12MB2767.namprd12.prod.outlook.com
 ([fe80::8953:6baa:97bb:a15d]) by SN6PR12MB2767.namprd12.prod.outlook.com
 ([fe80::8953:6baa:97bb:a15d%7]) with mapi id 15.20.5482.016; Mon, 1 Aug 2022
 21:45:05 +0000
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
Subject: RE: [PATCH Part2 v6 05/49] x86/sev: Add RMP entry lookup helpers
Thread-Topic: [PATCH Part2 v6 05/49] x86/sev: Add RMP entry lookup helpers
Thread-Index: AQHYncBDEjVRVcpx502HVSPCQUlAqK2anZgw
Date:   Mon, 1 Aug 2022 21:45:05 +0000
Message-ID: <SN6PR12MB27678B39305C23A97F3FF6098E9A9@SN6PR12MB2767.namprd12.prod.outlook.com>
References: <cover.1655761627.git.ashish.kalra@amd.com>
 <8f63961f00fd170ba0e561f499292175f3155d26.1655761627.git.ashish.kalra@amd.com>
 <YtqNYudg6uj6Rlem@zn.tnic>
In-Reply-To: <YtqNYudg6uj6Rlem@zn.tnic>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: MSIP_Label_4342314e-0df4-4b58-84bf-38bed6170a0f_Enabled=true;
 MSIP_Label_4342314e-0df4-4b58-84bf-38bed6170a0f_SetDate=2022-08-01T21:20:39Z;
 MSIP_Label_4342314e-0df4-4b58-84bf-38bed6170a0f_Method=Standard;
 MSIP_Label_4342314e-0df4-4b58-84bf-38bed6170a0f_Name=General;
 MSIP_Label_4342314e-0df4-4b58-84bf-38bed6170a0f_SiteId=3dd8961f-e488-4e60-8e11-a82d994e183d;
 MSIP_Label_4342314e-0df4-4b58-84bf-38bed6170a0f_ActionId=ce0fefe0-e438-4441-83c3-525901d1790b;
 MSIP_Label_4342314e-0df4-4b58-84bf-38bed6170a0f_ContentBits=1
msip_label_4342314e-0df4-4b58-84bf-38bed6170a0f_enabled: true
msip_label_4342314e-0df4-4b58-84bf-38bed6170a0f_setdate: 2022-08-01T21:45:04Z
msip_label_4342314e-0df4-4b58-84bf-38bed6170a0f_method: Standard
msip_label_4342314e-0df4-4b58-84bf-38bed6170a0f_name: General
msip_label_4342314e-0df4-4b58-84bf-38bed6170a0f_siteid: 3dd8961f-e488-4e60-8e11-a82d994e183d
msip_label_4342314e-0df4-4b58-84bf-38bed6170a0f_actionid: 63b01440-1cd6-4643-8397-240f75eba59b
msip_label_4342314e-0df4-4b58-84bf-38bed6170a0f_contentbits: 0
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 411d3af6-d8e3-45db-c588-08da740718d1
x-ms-traffictypediagnostic: MN2PR12MB4270:EE_
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: v6GUskep+TiyJUh06vlL5Mfaf8NYlZBgP0LMxZajrfoS9VUsDsFbrzGXQSc8buf+sajrqqCP12QKg6fLsMPm8F+4cCN8UcCYxbxbW7CrUSi8a9Bj6whhZv8NbVVK9EJon1p8ls1bxvgItghMn34s+KgyB5oDOGbu1u28ccad/KOcw5mZmMUYokA2U3rZnGE8EV7MumzmjK+MMs2E7wrqVC3n7nMUURsBUd4C2X7SncmUIb4Dp8DiDmT14BKq/ThbyDhDx+4zI+4mvP2VG0N1pBkR8s653l3E8QXJuAhPV7mM4zA4G6QXCclLwCM/wYRxYxav6ODeTlcDzuBwI/o39+vuik2OYdDEM6RfMWB911guxvPCDeUNsOFdEEsrWxzEZn9XJdRONUSyfgn7o/LuUroWE1zRbSC6wSjxN0xGUpowAkZOfhfLo5xG544hK9xjAujPK3uB6XHG2CmXG47FDeII+ogsi5ihn5QF6saOF80qyYAzH32/zsFGFjquw/eqQe0HMv6g1FdepjmGy4zeRAWcdqJLzENpQ5iZ1bPxU4NRWIH7RXFuq6pavXt2gaEHPz5R9JqLDR8K+bnkNdW53Hw08nkUrArim5Rwde4xsE8RAI99NnwpvPI0UWKXAWKxe2p1CBYcMU4zhbh9+duLu8AkkgE3YYzo+87W/+olO26TZhXLfp0kGqxs0b2aSVgs7SZYrDvR9/I2ZfwOOIkNPsH7PGRXUbygG0Z3904mKAhXEvfbUJYjPREX8cFLRtX25+mYTsv+5JduNYx5eK8AcrYoiqoxKvG8ozGQrSqDIw+r5S9HSRMJnJk3YODle9Rp
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR12MB2767.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(346002)(396003)(39860400002)(366004)(376002)(136003)(8676002)(38100700002)(8936002)(54906003)(66476007)(4326008)(316002)(64756008)(478600001)(76116006)(52536014)(122000001)(71200400001)(66556008)(7416002)(7406005)(66946007)(6916009)(66446008)(5660300002)(41300700001)(9686003)(26005)(186003)(33656002)(6506007)(7696005)(2906002)(38070700005)(55016003)(86362001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?G9AMIyGvKmkCzvCeUqHTyJn7cw9s0xk4NsmHplVMzDRrds8TgkBiy/2t6ZYM?=
 =?us-ascii?Q?jptr7D7eUxaYjn4jUx6XrHTxyZLWsUyk4lztJoHQ4MP4mIUFK2/JxmKQd98P?=
 =?us-ascii?Q?Co1sk3Txkd+wTe2San3YYmZVuG/al5OnHToCyZN7bmDqvoAGG2EVOuQvSW9R?=
 =?us-ascii?Q?pl0qzdCFIV7IutSrcvUtVQtP9C1jPStrd4hCHjgVghdVpsuTimNsxWIOpbFm?=
 =?us-ascii?Q?aOCc7hWjaRNp0sTg2xauwL/5EpkWc4fxvXB1ERKJWWinpX82rRWf5KOTQxRX?=
 =?us-ascii?Q?Hbj+r6abHvhUVdhNRiAiw4IWjhIkdmmx6QY3BqoqfygVFloECzR6Yw7nE+3v?=
 =?us-ascii?Q?ShFPjipGjHt1bE74fIknyqY2f1atWIpD1SqjVcZYbkUknVPuRVgbXq3IIOrn?=
 =?us-ascii?Q?xITwh3ljy7DJBpsWR/D2kdTgfxpp9kHxircCpHJorxFRLFvy4T193h4IO7go?=
 =?us-ascii?Q?2SiF0/9gU+OYbTBEVAuDKwQ9gjEwzLERpIkXfAdQdnSUR293LUfVzgYBTNZJ?=
 =?us-ascii?Q?cD0Z6FMdkobIEJ9bkJYYf7YfD7bGe4Bxk1mtqYfPAU6jWW7M7F4uPZvrT9kA?=
 =?us-ascii?Q?jFhngtOERQJI+29n+sPDbgAzfLrk13LqGy3bHsS+PEgEKpL42Rrer8QO58+W?=
 =?us-ascii?Q?z3Yj0wKVWBEUd6LHZAY9zF4PQH/t2m5ovsF71gxK/Xjwn/5VwGAHzx8+M9Xb?=
 =?us-ascii?Q?P5lWhwYyA5R+ZwMK685AaXttbI24P+WVp2pqtfyVSfcfy5MmWE9PMUdRZEFK?=
 =?us-ascii?Q?ffPY/FO9VdKl7uViuwDcdCEzaMkESSARC2yudUySljbZrpWJlrnVFv7kDgCs?=
 =?us-ascii?Q?e292qbh30V8hgNSy1a6V7SQWWOUhxT7HW4s5mzYuQUQUw2XI7CB5pizEro6D?=
 =?us-ascii?Q?845KVusXXdQGRB7ezoDLlQE/ojSN2hSAfDjFH6tPxdMX1NrcDUXhkXmTSG0+?=
 =?us-ascii?Q?4GMyuEcPVy42LILvs7vqe5HagfogwMt1pv5fzHuV2gIV9BQUd4BcJ/b6J2AX?=
 =?us-ascii?Q?R96mFEa7/Vp9ahXoCscbZBgAXC35AXwcLV2sGg1S3T9hwrjb2TJmnYc0PEg8?=
 =?us-ascii?Q?Aj0K3HDVBMpRVIBXVv0y4su4fXZkJxIRd2G/CJDpDxIEXmDnSwEFoaiEUCNj?=
 =?us-ascii?Q?8K0oZ/DNJ/mt7CzyYpfJkGfndiLkTkwnpkWcgiGKNFs2MLWm1ALHMxCpZbPK?=
 =?us-ascii?Q?xnnbRq6eLHzGo475w87oNY75pJAi3yvPrKTSw8VRHqq2b8lYnFdc9fxijDi7?=
 =?us-ascii?Q?e0GC6box1CqaDywVAU73Vyo9qFOATatx1p4hXuMNc7BIJLaGMdTNFbd+B0nP?=
 =?us-ascii?Q?/mvT3Hdcgm5FIntBThZfuByZldKI1t6a+qmk6t0dCS/zBN4q5t9w5ULEnNzX?=
 =?us-ascii?Q?ZpPS6RgVk2Et14NVjpcqp1xw0gQByql0bDE1r7NJzKqmRldVdsgZuXMQeYCR?=
 =?us-ascii?Q?2uoGnkTFqkdZuQcdPHhUmCvtWMgfqTlY8WojnnizswKHLkeScU9OJ8Vhacxr?=
 =?us-ascii?Q?Vwf/TxS4wbYPIZxIQP5o+mpQyi5Vb2pJveQPSHsrAv6zEOsK7VepJGk7PTEq?=
 =?us-ascii?Q?3Q2+q5/BIGRn3LhrcMw=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SN6PR12MB2767.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 411d3af6-d8e3-45db-c588-08da740718d1
X-MS-Exchange-CrossTenant-originalarrivaltime: 01 Aug 2022 21:45:05.5871
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Tw3kmuUEhfVh2DPd/FeKItcI1tNjSDFYvGy/k6I2d+GWwRiJAKMxu984ZcJXcQl5mAz7VVUfyL1Kzf67yTY/0g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR12MB4270
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

>> +static struct rmpentry *__snp_lookup_rmpentry(u64 pfn, int *level) {
>> +	unsigned long vaddr, paddr =3D pfn << PAGE_SHIFT;
>> +	struct rmpentry *entry, *large_entry;
>.> +
>> +	if (!pfn_valid(pfn))
>> +		return ERR_PTR(-EINVAL);
>> +
>> +	if (!cpu_feature_enabled(X86_FEATURE_SEV_SNP))
>> +		return ERR_PTR(-ENXIO);

>That test should happen first.
Ok.

>> +	vaddr =3D rmptable_start + rmptable_page_offset(paddr);

>Wait, what does that macro do?

>It takes the physical address and gives the offset from the beginning of t=
he RMP table in VA space?

>So why don't you do

>	entry =3D rmptable_entry(paddr)

>instead which simply gives you directly the entry in the RMP table with wh=
ich you can work further?

>Instead of this macro doing half the work and then callers having to add t=
he RMP start address and cast.

>And make it small function so that you can have typechecking too, while at=
 it.

Ok, I will add a new corresponding rmptable_entry() function here, should b=
e usable for getting the large
RMP entry below too.

>> +	if (unlikely(vaddr > rmptable_end))
>> +		return ERR_PTR(-ENXIO);
>> +
>> +	entry =3D (struct rmpentry *)vaddr;
>> +
>> +	/* Read a large RMP entry to get the correct page level used in RMP en=
try. */
>> +	vaddr =3D rmptable_start + rmptable_page_offset(paddr & PMD_MASK);
>> +	large_entry =3D (struct rmpentry *)vaddr;
>> +	*level =3D RMP_TO_X86_PG_LEVEL(rmpentry_pagesize(large_entry));
>> +
>> +	return entry;
>> +}
>> +
>> +/*
>> diff --git a/include/linux/sev.h b/include/linux/sev.h new file mode=20
>> 100644 index 000000000000..1a68842789e1
>> --- /dev/null
>> +++ b/include/linux/sev.h

>Why is this header in the linux/ namespace and not in arch/x86/ ?

>All that stuff in here doesn't have any meaning outside of x86...

Yes, makes sense to move it to arch/x86.

Thanks,
Ashish
