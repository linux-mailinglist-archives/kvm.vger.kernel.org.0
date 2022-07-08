Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AED9E56BD76
	for <lists+kvm@lfdr.de>; Fri,  8 Jul 2022 18:08:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238930AbiGHP7k (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 8 Jul 2022 11:59:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42702 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238914AbiGHP7j (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 8 Jul 2022 11:59:39 -0400
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2073.outbound.protection.outlook.com [40.107.94.73])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0D50A6D569;
        Fri,  8 Jul 2022 08:59:37 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Z7pcE+KZHdkhtQ7PT1mMHpqO3ao872eS4H3ZqPji6tdlk9Qit1+5h2uxsB+wlDau7esYOxR0LqIBCayBbuH1wBVeo2NUbu9I/WvYT/S8eAdRlq1g84oiQph6tARsPwSpiyuw3TfZVWez9+f1NBRVLmej8D8wuqfJytHRodtwpGcIUv95k4XQBPUXDr+CTZwdKQfuB279h54Q8fQW/07OY1vy4CxR/szAYwLoSCiQWPZ92piigbzfD9c+q8FMO9d8RUIwQRBhwm9MEhx5JOpiSNLmQKyizCtqR93+2Tq2MfqeZ70ggp/4cb9tTFTOk8c64mkddygPpo/ypQlLUf/fOw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=FyjnSQWr2k9z5kjq65GVeHkHLKSloVmqtsse6GTKAd8=;
 b=Ckf57/YvtuvdN/yrQUfDBk5+WULyYy1oUuK4ddw9GO4wJqhSLZbQkubEaiWIbOqKip/9oScYi3FQgNo6EUsEAEeHcXcYr3MaR35zeBHqxo+bvFhPpz2KwYaZKPds+B/2NbYWViB/SPHegopzIdKVD7DmSXqUTBccjFazI8KkB8Cpfc1SRkjcsHZa3Uj3WL1LE5LJLCp57eHQDVcuQdr5Q5jzUohqFTKd5nH/KzqeM4cKIf1X4AcVBXmZc6lr1klzf/pEP+o0Qx/9gSwXfsCRKAwNmo6y84yAhmccR13cQQ0AK8ZXn1Vi1NywIT6vAIGHBNp4PahHshCvEhHACVUZrw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=FyjnSQWr2k9z5kjq65GVeHkHLKSloVmqtsse6GTKAd8=;
 b=Ra07olvB72sqnjAYtxqyorjxa598yzCHeNoFgvI8qaPXSkidx+xVk+spaFHLNYXoyRUB2CrV7nAhMBQo5fzCFyvAAYe+sPUPZs1AE4k+65ax6F9j42a7C/WJcquY4TiEwEBtEflZkPXSLhk7/33D6JbmsvQKkgwCyPGMBNya6jY=
Received: from SN6PR12MB2767.namprd12.prod.outlook.com (2603:10b6:805:75::23)
 by SJ1PR12MB6218.namprd12.prod.outlook.com (2603:10b6:a03:457::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5417.16; Fri, 8 Jul
 2022 15:59:34 +0000
Received: from SN6PR12MB2767.namprd12.prod.outlook.com
 ([fe80::8953:6baa:97bb:a15d]) by SN6PR12MB2767.namprd12.prod.outlook.com
 ([fe80::8953:6baa:97bb:a15d%7]) with mapi id 15.20.5417.016; Fri, 8 Jul 2022
 15:59:33 +0000
From:   "Kalra, Ashish" <Ashish.Kalra@amd.com>
To:     Peter Gonda <pgonda@google.com>
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
        "Dr. David Alan Gilbert" <dgilbert@redhat.com>,
        "jarkko@kernel.org" <jarkko@kernel.org>
Subject: RE: [PATCH Part2 v6 35/49] KVM: SVM: Remove the long-lived GHCB host
 map
Thread-Topic: [PATCH Part2 v6 35/49] KVM: SVM: Remove the long-lived GHCB host
 map
Thread-Index: AQHYh9zZ2YXyQRnTe0iEslSS4jvfv61e+v3wgBRvg4CAAAHU4IABSe8AgAAAYBA=
Date:   Fri, 8 Jul 2022 15:59:33 +0000
Message-ID: <SN6PR12MB276775A947EEE7323B54F63D8E829@SN6PR12MB2767.namprd12.prod.outlook.com>
References: <cover.1655761627.git.ashish.kalra@amd.com>
 <7845d453af6344d0b156493eb4555399aad78615.1655761627.git.ashish.kalra@amd.com>
 <CAMkAt6oGzqoMxN5ws9QZ9P1q5Rah92bb4V2KSYBgi0guMGUKAQ@mail.gmail.com>
 <SN6PR12MB2767CC5405E25A083E76CFFB8EB49@SN6PR12MB2767.namprd12.prod.outlook.com>
 <CAMkAt6pdoMY1yV+kcUzOftD2WKS8sQy-R2b=Aty8wS-gGp-21Q@mail.gmail.com>
 <SN6PR12MB276787F711EE80D3546431848E839@SN6PR12MB2767.namprd12.prod.outlook.com>
 <CAMkAt6oea8CfjupTRBS1CQQogaixNakF1+KjSZ-+bhRBRj3GvQ@mail.gmail.com>
In-Reply-To: <CAMkAt6oea8CfjupTRBS1CQQogaixNakF1+KjSZ-+bhRBRj3GvQ@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: MSIP_Label_4342314e-0df4-4b58-84bf-38bed6170a0f_Enabled=true;
 MSIP_Label_4342314e-0df4-4b58-84bf-38bed6170a0f_SetDate=2022-07-08T15:55:44Z;
 MSIP_Label_4342314e-0df4-4b58-84bf-38bed6170a0f_Method=Standard;
 MSIP_Label_4342314e-0df4-4b58-84bf-38bed6170a0f_Name=General;
 MSIP_Label_4342314e-0df4-4b58-84bf-38bed6170a0f_SiteId=3dd8961f-e488-4e60-8e11-a82d994e183d;
 MSIP_Label_4342314e-0df4-4b58-84bf-38bed6170a0f_ActionId=9f786f9e-54cd-4090-aa6d-7a1f5dc9f53b;
 MSIP_Label_4342314e-0df4-4b58-84bf-38bed6170a0f_ContentBits=1
msip_label_4342314e-0df4-4b58-84bf-38bed6170a0f_enabled: true
msip_label_4342314e-0df4-4b58-84bf-38bed6170a0f_setdate: 2022-07-08T15:59:31Z
msip_label_4342314e-0df4-4b58-84bf-38bed6170a0f_method: Standard
msip_label_4342314e-0df4-4b58-84bf-38bed6170a0f_name: General
msip_label_4342314e-0df4-4b58-84bf-38bed6170a0f_siteid: 3dd8961f-e488-4e60-8e11-a82d994e183d
msip_label_4342314e-0df4-4b58-84bf-38bed6170a0f_actionid: e392fd9b-9141-4d66-8917-d4877bc36f3c
msip_label_4342314e-0df4-4b58-84bf-38bed6170a0f_contentbits: 0
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 6dfe6dac-94e2-4fcf-fbb6-08da60fad9c7
x-ms-traffictypediagnostic: SJ1PR12MB6218:EE_
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: B6mGD2WX7mvbOkcFNhN8Mt0Bsmo8/K3u4KJFvLi80e3t/vTwViom7IqHCA/0SdJ/hQ+Ow2GB73DmK+ayIoRrO0Ge2vnwY0axRQ1nRA9oVngqL9b5g3mVsANDVCRN5OZvwlPquwDtdL8HK3vTKVO4vjaUSXQt4ROdRRiUzQFKx7kLNtHhhrgMLkvpMwZC9LfBAa0rxgWlCefs0MbZCiUICTLqmXO/VFJTRCJ4f4pYchOuonCFoYq79AIXeHghaoOhI3IbMSZ9tZZZY64mhnth7mbOdm8YznXdwSjEh+O/YMYFufZTIpl+jKjeetjDveQc5RGnm/xqPx5IwzlmrF9M18jzfa4QsNSADGPsHKPPARcGy+OUtKRtFmIN3YnQ8q2zq/UI61BcOG90xzERdlr70KbUOnMg3VonriHzWFZukHS4kB4XCWmdiHJpcetOUXHFG5u078fMU/kLw0MIgpy7vrUGhSqqrvyTjqcu6S2DyneSaiTN3SKxNoe4MWNG0BNHQNC76EOOr/er0zUw+asS0I89DuyJfzjtjwGBz+RpY6HcNuYFYSldlE6CzFqufG0A9AywKB6IqvFf6+dja60q1mWSpVAPb+0dcdXHtAdPNK7/k81CblQ5T3AT8hUKfEU6vqSxa2PKLnoWG8IJIp9HwyfT4LYZGqjNg5EwfaYcBAFkghO/QpcKJqbP3ovLa5gsfxZgVV1S2THwCQgMqkFe0JZuSvfCKI/jTJtS9mOb0IOPE3oZPa0jaqRgL6rbgwuRoDCKm8Q+HHFanNP4ASwnGjwR+YsI61a0EaWeF8OdUnro0zPBjMIR/XPTxLTCLlLnnGwULVDuCJsvmt3sKq8pkw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR12MB2767.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(39860400002)(346002)(396003)(376002)(366004)(136003)(84040400005)(5660300002)(478600001)(86362001)(7406005)(8936002)(26005)(38070700005)(52536014)(76116006)(6506007)(7696005)(38100700002)(33656002)(2906002)(41300700001)(7416002)(9686003)(71200400001)(55016003)(122000001)(186003)(54906003)(66946007)(66476007)(66556008)(6916009)(966005)(64756008)(4326008)(8676002)(83380400001)(45080400002)(316002)(66446008);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?mwXl3DTvohucRDv+T04ZtEuxoxfkL+UPMkNKAR7SyDpOEkWjtHLZOsRahhlI?=
 =?us-ascii?Q?WN1341AId2fT7h7i8doBAKmAYBBH0piVDerbSBfP14Aw3+1kA6hLfTCCURaI?=
 =?us-ascii?Q?Iojz3twh+1mwTFF07YBiWExFwr9Tqf3RDPde4ptKW45UWUEhgGHSxzQE4Ifo?=
 =?us-ascii?Q?HCS9p17TswYaD+XqpsuFKlh7heHp2aTOSpZEajzEshdYNcpf4KJrCGWfbl3B?=
 =?us-ascii?Q?ecrAKx8yUQZPAD2qmO4O4oTUEdJnLF+9/j72edVSDAY1NMZqYbdJovmpn9Ii?=
 =?us-ascii?Q?pZQMDdMtzM6oRGhIIVVElUTGuCUjjePXAdm3pDaMVR7vo6TcrodmByio4zar?=
 =?us-ascii?Q?KIOUl7Yg1W0uWl/0+iz4jF7wJIgpsZsM7IsS7D54BT41bV9w72Tdwdem8r4g?=
 =?us-ascii?Q?0u33aHTsSpjgIc3jHOUpiiXreKG+aHDgE2GWmslBJ0WNsF03h66uEXuPY8vI?=
 =?us-ascii?Q?xuQXwQyARvicr5801jFUG6VVpstvVjnY5LmtATDDTvUmi8p18/viL/oOA44I?=
 =?us-ascii?Q?76WDxWW8Pbr14t24yCcxm7pgFyjRQ34LqfJU9EhjTJo4fU21KNLCMWTHXxI3?=
 =?us-ascii?Q?SXMwv9rws03Hl3a8b8JQKEkL6zC3T5D7bL9PmNgfGQeuTE7msGA69n4xC0IX?=
 =?us-ascii?Q?ZMiOZBuELT5K1vDdScmDQtoacYDn/78/qvEHFDzrELOK/vZTl3jAj7fhiV0J?=
 =?us-ascii?Q?7Br6BhqQmzcjvuKc5ruoGQNyPt3FV7j4i5fyr3oAuhlDrGjalAofbcTx8Tdl?=
 =?us-ascii?Q?StciojVZwvzCI6mCjuNDb8wOL9HO1WjI8qqfKPfvsbbogGoZi+q58O5z/UMi?=
 =?us-ascii?Q?n+7uS+PptdJSYdInKkM2b66wlxmdIoxfsYyIofFckQIzGcgqpqVy6C32zYmQ?=
 =?us-ascii?Q?/sBdc2P/1f4wIqFe+hLmPWNk+7sdR/J99iAMMirAFQD9S5uQY54KyS3vVEs5?=
 =?us-ascii?Q?+t1DGz9r12IfIznnbJU0/Otush6zErouYKK4wOTSZx62ES1Tomo1eNOhtIcP?=
 =?us-ascii?Q?GSsaEoKYUoHkd+RGazrbJqphDDxqWL+49bcDKupLRYJp6ChyywhVuGZR1UQs?=
 =?us-ascii?Q?YPgcR3SqqvQO/vH9qZmi8NSzAQsz9Z+W0qsl5L7PZnW67Y+7cm1pr24awjja?=
 =?us-ascii?Q?rNOTHr0dMEMg2lTgshqA2gICkOMP0z44ma5vGB82V1tsxv95XdbFeQEVgIS1?=
 =?us-ascii?Q?HTz3b72l46jUTsFCrB1kLSl14oLc2zQKOQ6OR1/Y9qjCoQKCM1FFh+E1lijy?=
 =?us-ascii?Q?SDtYKMR31JZp5Bw1fvKmVEzjkbP+MXWZzUQTtZ2mcWHVV20oNsr8KkDHjEt4?=
 =?us-ascii?Q?TJYuIESwjss2N/sKunTlvMMXisEvVPIWWrF1iiN+ROIC4oUCyYfhQsyk4qbq?=
 =?us-ascii?Q?lvYDv9mz01FwU8Vpuh2cOrXAs7MxqoRLAWGyirF5E5PXkAi7oDKyKJFiWFDi?=
 =?us-ascii?Q?D8omHrPr+IV0SyIYgHGpMS5WtZnVSJrcgHBNkgL7VNcl3hccysmOERNVCZvh?=
 =?us-ascii?Q?hoYVQu1LvhFoOoiH0HGKWkzldZNHzx4EXoXxG5tfVugibKPp1LQJplz1omMq?=
 =?us-ascii?Q?UQOd9wWcNAYLZKD+2m8=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SN6PR12MB2767.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6dfe6dac-94e2-4fcf-fbb6-08da60fad9c7
X-MS-Exchange-CrossTenant-originalarrivaltime: 08 Jul 2022 15:59:33.7730
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: RraS8h700ljUnzmA6aqfdQ2s+MdjRHgcumP/9mDAGqiG/J0p5JvA6Cx0/00wwZwnHGDmLKGCLXhzL8wBWPj47Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ1PR12MB6218
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

Hello Peter,

>> > I don't see anything mechanism for this patch to add the page state ch=
ange protection discussed. Can't another vCPU still convert the GHCB to pri=
vate?
>>
>> We do have the protections for GHCB getting mapped to private=20
>> specifically, there are new post_{map|unmap}_gfn functions added to veri=
fy if it is safe to map GHCB pages. There is a PSC spinlock added which pro=
tects again page state change for these mapped pages.
>> Below is the reference to this patch:
>> https://nam11.safelinks.protection.outlook.com/?url=3Dhttps%3A%2F%2Flore
>> .kernel.org%2Flkml%2Fcover.1655761627.git.ashish.kalra%40amd.com%2FT%2
>> F%23mafcaac7296eb9a92c0ea58730dbd3ca47a8e0756&amp;data=3D05%7C01%7CAshis
>> h.Kalra%40amd.com%7C647218cdb2a040bf354e08da60fa2968%7C3dd8961fe4884e6
>> 08e11a82d994e183d%7C0%7C0%7C637928924845082803%7CUnknown%7CTWFpbGZsb3d
>> 8eyJWIjoiMC4wLjAwMDAiLCJQIjoiV2luMzIiLCJBTiI6Ik1haWwiLCJXVCI6Mn0%3D%7C
>> 3000%7C%7C%7C&amp;sdata=3Dss8%2F5qualccXQero9phARIG2wvYhtp8SMdve3GglZeU%
>> 3D&amp;reserved=3D0
>>
>> But do note that there is protection only for GHCB pages and there is=20
>> a need to add generic post_{map,unmap}_gfn() ops that can be used to ver=
ify that it's safe to map a given guest page in the hypervisor. This is a T=
ODO right now and probably this is something which UPM can address more cle=
anly.

>Thank you Ashish. I had missed that.

>Can you help me understand why its OK to use kvm_write_guest() for the
>|snp_certs_data| inside of snp_handle_ext_guest_request() in patch
>42/49? I would have thought we'd have the same 2M vs 4K mapping issues.

Preemption is not disabled there, hence the RMP page fault handler can do
the split of 2M to 4K on host pages without any issues.

Thanks,
Ashish
