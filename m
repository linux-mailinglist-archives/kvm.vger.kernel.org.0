Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 270995AF148
	for <lists+kvm@lfdr.de>; Tue,  6 Sep 2022 18:56:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233513AbiIFQzf (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 6 Sep 2022 12:55:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46208 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238538AbiIFQxR (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 6 Sep 2022 12:53:17 -0400
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2058.outbound.protection.outlook.com [40.107.94.58])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EBDF41B797;
        Tue,  6 Sep 2022 09:39:42 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jhzp1NRXCKK3MCFWsiolJjIOgE7ZdCRSNsplZ8af7dlBhC08bfxBzEe1B7T66EdcxNXzs1abRbDia9+ZZf9Eg3poFlW5QqFAOhsqUwgmq7uxNHdJL/B2KbZVDaACT/n6KEGoDMprQwFFkpEPbi1m5vTzLwtM92/OZ7O+YX9HESzUIEizvLg9HuPwNfgjbH90YhF39bxb3FPfAq+UoDwz5Ib7Ckg3oWAtaXeS4nSHi9XTSPSSl2GsaWxMX8R7SI+bOg/ClZGcfYn0QQY3dA81pTS1TFA41Ktyo9s9MSipaNu/B6TzsZFa2FkBn25QUkGMRrBb2QmFMjXW0iUivoogbA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=oWmlWHLEg3dzHYgNCLuruYnq9LNBymW1q3ShnzxhKNQ=;
 b=Y5hh6ZofAkSu2L6ru17LosoKxJ1ekefS5Hgypf/wvEfxYAritDFLLle766ctCNfMk5L5Z925zro6lrxROGXclhEStGt6BGJoHPHbPQsHdUuYa0Xc7Y7g/s6tsHoEicLKXdpvU3GV06S1PV4Q2B/YIWu28uB/3DHQqUOre4yFSpIUuiFfUIxwOcxLptZQWuKXEp9lGs0kQ3zHQwOqH6QlcHVwBcrrBS/eCRCY9100qD24I2o7Qe0tflRteCe1ZAtQTZvLX++NJKHt6o37DvEo/CRq1L4S3SoH/ghJMnbbEazmAnVFjDJzkxdvxzYF18rVH1+E16tHCCbvcTjC9Ltn9g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=oWmlWHLEg3dzHYgNCLuruYnq9LNBymW1q3ShnzxhKNQ=;
 b=qgyVMGNPuuMspJV/hvgsFzs4GkmoytGe8CDxpoLnyMGkYMRr+GdHSoRGfxSFI3cW8qmVMgWwYyi5CU954+5RUpIK4+FhARM/MW2gkLJBLD4LVdpezjNx0enbow1U5ZYgnFEq1dmNNgyTOpKhiQ4cL9yRwRCmmicjKGVZHGAKUoY=
Received: from SN6PR12MB2767.namprd12.prod.outlook.com (2603:10b6:805:75::23)
 by SJ1PR12MB6028.namprd12.prod.outlook.com (2603:10b6:a03:489::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5588.16; Tue, 6 Sep
 2022 16:39:39 +0000
Received: from SN6PR12MB2767.namprd12.prod.outlook.com
 ([fe80::e47d:1a95:23d5:922c]) by SN6PR12MB2767.namprd12.prod.outlook.com
 ([fe80::e47d:1a95:23d5:922c%7]) with mapi id 15.20.5588.018; Tue, 6 Sep 2022
 16:39:39 +0000
From:   "Kalra, Ashish" <Ashish.Kalra@amd.com>
To:     "Roth, Michael" <Michael.Roth@amd.com>
CC:     Marc Orr <marcorr@google.com>, Jarkko Sakkinen <jarkko@kernel.org>,
        Borislav Petkov <bp@alien8.de>, x86 <x86@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        kvm list <kvm@vger.kernel.org>,
        "linux-coco@lists.linux.dev" <linux-coco@lists.linux.dev>,
        Linux Memory Management List <linux-mm@kvack.org>,
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
        Sergio Lopez <slp@redhat.com>, Peter Gonda <pgonda@google.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>,
        David Rientjes <rientjes@google.com>,
        Dov Murik <dovmurik@linux.ibm.com>,
        Tobin Feldman-Fitzthum <tobin@ibm.com>,
        Vlastimil Babka <vbabka@suse.cz>,
        "Kirill A . Shutemov" <kirill@shutemov.name>,
        Andi Kleen <ak@linux.intel.com>,
        Tony Luck <tony.luck@intel.com>,
        Sathyanarayanan Kuppuswamy 
        <sathyanarayanan.kuppuswamy@linux.intel.com>,
        Alper Gun <alpergun@google.com>,
        "Dr . David Alan Gilbert" <dgilbert@redhat.com>
Subject: RE: [PATCH Part2 v6 09/49] x86/fault: Add support to handle the RMP
 fault for user address
Thread-Topic: [PATCH Part2 v6 09/49] x86/fault: Add support to handle the RMP
 fault for user address
Thread-Index: AQHYrBDc30zm/ve2UUW13wSedLDd3a3SXbsAgAA6ggCAAANnoIAAEL2AgAATsRA=
Date:   Tue, 6 Sep 2022 16:39:38 +0000
Message-ID: <SN6PR12MB276774A14FEBFF4E98AC07238E7E9@SN6PR12MB2767.namprd12.prod.outlook.com>
References: <cover.1655761627.git.ashish.kalra@amd.com>
 <0ecb0a4781be933fcadeb56a85070818ef3566e7.1655761627.git.ashish.kalra@amd.com>
 <YvKRjxgipxLSNCLe@zn.tnic> <YxcgAk7AHWZVnSCJ@kernel.org>
 <CAA03e5FgiLoixmqpKtfNOXM_0P5Y7LQzr3_oQe+2Z=GJ6kw32g@mail.gmail.com>
 <SN6PR12MB2767ABA4CEFE4591F87968AD8E7E9@SN6PR12MB2767.namprd12.prod.outlook.com>
 <20220906150635.mhfvtl2xgdbzr7a5@amd.com>
In-Reply-To: <20220906150635.mhfvtl2xgdbzr7a5@amd.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: MSIP_Label_4342314e-0df4-4b58-84bf-38bed6170a0f_Enabled=true;
 MSIP_Label_4342314e-0df4-4b58-84bf-38bed6170a0f_SetDate=2022-09-06T16:17:04Z;
 MSIP_Label_4342314e-0df4-4b58-84bf-38bed6170a0f_Method=Standard;
 MSIP_Label_4342314e-0df4-4b58-84bf-38bed6170a0f_Name=General;
 MSIP_Label_4342314e-0df4-4b58-84bf-38bed6170a0f_SiteId=3dd8961f-e488-4e60-8e11-a82d994e183d;
 MSIP_Label_4342314e-0df4-4b58-84bf-38bed6170a0f_ActionId=d193e0ba-f1fb-4923-ae60-0e3235e310fc;
 MSIP_Label_4342314e-0df4-4b58-84bf-38bed6170a0f_ContentBits=1
msip_label_4342314e-0df4-4b58-84bf-38bed6170a0f_enabled: true
msip_label_4342314e-0df4-4b58-84bf-38bed6170a0f_setdate: 2022-09-06T16:39:37Z
msip_label_4342314e-0df4-4b58-84bf-38bed6170a0f_method: Standard
msip_label_4342314e-0df4-4b58-84bf-38bed6170a0f_name: General
msip_label_4342314e-0df4-4b58-84bf-38bed6170a0f_siteid: 3dd8961f-e488-4e60-8e11-a82d994e183d
msip_label_4342314e-0df4-4b58-84bf-38bed6170a0f_actionid: a7704ebc-47eb-4048-890b-f70b5e9f3f6c
msip_label_4342314e-0df4-4b58-84bf-38bed6170a0f_contentbits: 0
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: cf5a1174-dba4-4f32-c692-08da90266435
x-ms-traffictypediagnostic: SJ1PR12MB6028:EE_
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: Q10jA8J1/rvPuEjFbHmf5KVhblQndyrRa8kGGPqDRJIPc310cYqy1VECszemtOtaMJfuHxLhyu7Z3p55uPvejp490JYFAsfLDfcFdwcMInOly5mtBeBGR3LGE34dQkZCoqEkAe7dJWibGCrUCr0YcHnFp4/3RbhITgBzc4wN5y6SnxwNQVft8ards5tGD+E2u3O9dEz4Jo/ud3T+bbrG40aLhpcvpGlWkhpgiGaoB7dJDjNwCAPQAdf5XIbV8ff9rMfrVRPMMQQOQb071xjNJhvS97VbEbvFYgOrxNoDWxlztdJWG/TcOYkW6UnvkjheYo+urWubCgj4BmCzWdEY5lmOr/DpiXNir9VCipw7UAYy5rBxKwbsttNgJVSiJNlB+cMYLzFvoMaqZsDN7LxJJM6PpRB0UbVJwkNhZbd3hiTTIqThJr+kRCY4MZwTd8MdZD6MFiLmayQfYHMfPT7+UxXVFfa1NGD/8dnKWMlJbbdYwqMt9uMUc2IDZhiL4kK8PFZfe103vJhQ+jUD1yQnIvKtN1HiSUJ4zCwGA5sKibFo5smb4j9Zk6fCKfRyXkkcUwSbBky4kbn9ERo277hovOl33OpZD9SGsKzrY5omZ85KMxgSuj6c5HifeSd8vlyIkxNCOgxicQcHGFtpuqpKxpHBebmz+8lAoISyxQx2k8sOdDIVwR+ApRkK5jYraeXGSXxB7TeUt01GqapnTG2qiBjStlvHafvooLfopuQTBNatEYRoDhWoUuwVlGPd1+GIaToPG1nFd4jh0lpUUbnUKg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR12MB2767.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(396003)(366004)(136003)(346002)(39860400002)(376002)(38070700005)(41300700001)(38100700002)(122000001)(66446008)(66556008)(4326008)(66946007)(6636002)(64756008)(66476007)(316002)(76116006)(54906003)(8676002)(83380400001)(52536014)(55016003)(5660300002)(7416002)(2906002)(6862004)(9686003)(26005)(7406005)(8936002)(186003)(478600001)(33656002)(71200400001)(6506007)(86362001)(7696005);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?Qz14V5W797Hw4rld/KVIb8DnSCY39zEw5TqAe318X/nRtOrZ/vXzBeIK8HiL?=
 =?us-ascii?Q?tUKe2WeDZf7mYVSfszFCcfTu/nCgsHocBSsahYXJuc+A5N2uQF2FjjuqLbwk?=
 =?us-ascii?Q?Qq8hqobQh7IHLIbCTEGEkC4ZVr+OrYmjCXOknPtOoyHlp0arpsqdz3KxuJY4?=
 =?us-ascii?Q?Y5xAoSWykUUSuaXsHEkud+4Mdqvqsxhuyk/u/M2BoyLS6ZfBZ5Xyg7DsWqsW?=
 =?us-ascii?Q?8vKGJPwa6DADavkxZc/WE/DDWolXoyPDCnkb1qnNsQRncalpk7BcXGEmhqlr?=
 =?us-ascii?Q?w7c+/ue7P/rzey11C1L033og31gCu0Ra0JYwZJ0uNELl8IQYduYkN22FHOuH?=
 =?us-ascii?Q?sckyWr/rEb2o/bu2oSxIpPY32HqmKUzFVrhhyeNNam8JWs1O3P4ST/6n8t/o?=
 =?us-ascii?Q?byCiFZbz2NRSxx368mTXKOUCaFuKOBWxVchegncjOMEWfyv3wL56zm7Gn8g0?=
 =?us-ascii?Q?VWR3bAr8d3/qASqcS5GNqFnB8jHF8MH0cCxrAjsw3B0pUMb5PNZG3E4/j/v+?=
 =?us-ascii?Q?JbPYG1CW1K185St4z7G635kOEvByrt3wbakmAIiOtYyWWoppqaIjnSMMsNYr?=
 =?us-ascii?Q?x3ebVgegsVwQfCuJckQsk57x0FoYFlpM36WyV9LhyiojNw4TLpr5sMjARCVe?=
 =?us-ascii?Q?RnTwaSQMkEyEuCnQgul8+YoSbV2Hko56d/z61d+19d6c6UAu3B52emelh8YX?=
 =?us-ascii?Q?wUHmlDICddy/T+ZNDkjfEXb/0Izr2X3QaXxC1wYXkuSywe9nQuyTuQgr93f8?=
 =?us-ascii?Q?3T/v6aSE6ZjW90QPddt2P93Vfx022Dsf9Oav7jO9wqcPtKezQgSA95jXQwzk?=
 =?us-ascii?Q?1EjOQyQHG/nqN7mGjV0GXF3CYDcdArX6TsuqXXj14CGwARmIX6fOsvg1JdKL?=
 =?us-ascii?Q?GHaxLqoht4lPcGHEz3Bq9R7Q2zM//JGR9cRB1xVi86xkCoA+cFb7rpncwAqz?=
 =?us-ascii?Q?4SasKUWvcz6DkKqh0kBmfVogJIZR9LxF9HOxpw1d6tGFNXMFqbfVHeX///VO?=
 =?us-ascii?Q?Yi1icinvBfenyMgljr44+RbL5Iz8iDOT0aNjnqJSl0lYQT31DjpfhieSYpBk?=
 =?us-ascii?Q?9Bwqe52BInkMtKz1YFvrvakmLeALR+9uKMj5SUKQm3bZgJii+C/gSJ7zUwQq?=
 =?us-ascii?Q?hD4LbNuJC2JpjCHD5rh2nwTiBj3GEwhy+geOVZIlPqNK2UxxXpoU1dKfawLe?=
 =?us-ascii?Q?yeQB9k4nb7h8Vbm90/wLSxaq4mEmP1Dp/Q+8quaTxpm9izEK8OEgJhD1NRU6?=
 =?us-ascii?Q?MrOmWlwlk98l13D/04D4DJTO0cg7zLR/NX1WLWtNXBJrIQTj1FxAH0L2vWyw?=
 =?us-ascii?Q?sFSCf9mNVzrxyzUHMx01OfvvmoVEWR7CwxWajz2p2qSCwjiIHgxdoeJmjF29?=
 =?us-ascii?Q?91FRf0OHta8Da+3xy7iHgfdw5MQLM9+TFWY1DZLj2sDsFcdCKeuEDuUGQRRS?=
 =?us-ascii?Q?JllQZVKWk7VQLbBKeCR737BnT8o2o97w/MliF6IHQdppdWCmxEbaoxgq/4cR?=
 =?us-ascii?Q?PAG9uJiFfVvW2Vr5PONPUmJOzZRmxvbXban7fCL2ZqB/uNnoT3Y03ZGFtsO+?=
 =?us-ascii?Q?Rnmidv3+pcUy+hoAGi8=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SN6PR12MB2767.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: cf5a1174-dba4-4f32-c692-08da90266435
X-MS-Exchange-CrossTenant-originalarrivaltime: 06 Sep 2022 16:39:39.0280
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: E7VOdRQNpzWQ8PJystqyf7pUrGZVj0DUWSt1TvW3TTU5zLLRldj9/GqSkLguxajxvHJDtKwfN7mZOJPviZQJbQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ1PR12MB6028
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

>> >Actually, I don't think they're the same. I think Jarkko's version is c=
orrect. Specifically:
>> >- For level =3D PG_LEVEL_2M they're the same.
>> >- For level =3D PG_LEVEL_1G:
>> >The current code calculates a garbage mask:
>> >mask =3D pages_per_hpage(level) - pages_per_hpage(level - 1); translate=
s to:
>> >>> hex(262144 - 512)
>> >'0x3fe00'
>>=20
>> No actually this is not a garbage mask, as I explained in earlier=20
>> responses we need to capture the address bits to get to the correct 4K i=
ndex into the RMP table.
>> Therefore, for level =3D PG_LEVEL_1G:
>> mask =3D pages_per_hpage(level) - pages_per_hpage(level - 1) =3D> 0x3fe0=
0 (which is the correct mask).

>That's the correct mask to grab the 2M-aligned address bits, e.g:

>  pfn_mask =3D 3fe00h =3D 11 1111 1110 0000 0000b
 =20
>  So the last 9 bits are ignored, e.g. anything PFNs that are multiples
>  of 512 (2^9), and the upper bits comes from the 1GB PTE entry.

> But there is an open question of whether we actually want to index using =
2M-aligned or specific 4K-aligned PFN indicated by the faulting address.

>>=20
>> >But I believe Jarkko's version calculates the correct mask (below), inc=
orporating all 18 offset bits into the 1G page.
>> >>> hex(262144 -1)
>> >'0x3ffff'
>>=20
>> We can get this simply by doing (page_per_hpage(level)-1), but as I ment=
ioned above this is not what we need.

>If we actually want the 4K page, I think we would want to use the 0x3ffff =
mask as Marc suggested to get to the specific 4K RMP entry, which I don't t=
hink the current code is trying to do. But maybe that *should* be what we s=
hould be doing.

Ok, I agree to get to the specific 4K RMP entry.

>Based on your earlier explanation, if we index into the RMP table using 2M=
-aligned address, we might find that the entry does not have the page-size =
bit set (maybe it was PSMASH'd for some reason).=20

I believe that PSMASH does update the 2M-aligned RMP table entry to the sma=
shed page size.
It sets all the 4K intermediate/smashed pages size to 4K and changes the pa=
ge size of the base RMP table (2M-aligned) entry  to 4K.

>If that's the cause we'd then have to calculate the index for the specific=
 RMP entry for the specific 4K address that caused the fault, and then chec=
k that instead.

>If however we simply index directly in the 4K RMP entry from the start,
>snp_lookup_rmpentry() should still tell us whether the page is private or =
not, because RMPUPDATE/PSMASH are both documented to also update the assign=
ed bits for each 4K RMP entry even if you're using a 2M RMP entry and setti=
ng the page-size >bit to cover the whole 2M range.

I think it does make sense to index directly into the 4K RMP entry, as we s=
hould be indexing into the most granular entry in the RMP table, and that w=
ill have the page "assigned" information as both RMPUPDATE/PSMASH would upd=
ate
the assigned bits for each 4K RMP entry even if we using a 2MB RMP entry (t=
his is an important point to note).

>Additionally, snp_lookup_rmpentry() already has logic to also go check the=
 2M-aligned RMP entry to provide an indication of what level it is mapped a=
t in the RMP table, so we can still use that to determine if the host mappi=
ng needs to be split or >not.

Yes.

>One thing that could use some confirmation is what happens if you do an RM=
PUPDATE for a 2MB RMP entry, and then go back and try to RMPUPDATE a sub-pa=
ge and change the assigned bit so it's not consistent with 2MB RMP entry. I=
 would assume >that would fail the instruction, but we should confirm that =
before relying on this logic.

I agree.

Thanks,
Ashish
