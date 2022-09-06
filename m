Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 069895AEE2F
	for <lists+kvm@lfdr.de>; Tue,  6 Sep 2022 16:56:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242190AbiIFOwh (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 6 Sep 2022 10:52:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40978 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240980AbiIFOwN (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 6 Sep 2022 10:52:13 -0400
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (mail-sn1anam02on20603.outbound.protection.outlook.com [IPv6:2a01:111:f400:7ea9::603])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AC7E67F0BE;
        Tue,  6 Sep 2022 07:08:55 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=b/nrVG/lTm3hi3oLL3vhm+Ggdx96UBJNkj7ay8JYQgLuxuW2YldPO8mAMCZzoxDMYfYZ73nVJzgaGk6WqHLmk8OJnFLRO5Y3xkuwYZ8guMJDy77H9mcKOS7MoYVjPa6AV3dS2BLjWhpvRT5AH7P/1c4Xy95ASSS4YATHO2Kw/IopyTeGOCaN5HZpUq+rjPnUyrUTbylSM2PvT0cfK33Th/NL/sjanVrBHPlb5J8fwDqIqChWcCx26MpKHHyW4ZJ58HaDyRxfdIm7PT284BF9EoC5kAz6xvhJt0LuIpSrDzCy2oE1VFeHY+h0WG6/vF7hkOrFGkn9ycttvtlQj2gQiA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=xTbrZXcJ+qB+2Q4r9UBqkotlHP2w2pf8RARGovVhmKU=;
 b=VFu0u8glikQJvdkLuGj9MjKWAz3cI5iskwOq0rrSSoi8GyncSQsnqr9Hd1Ik+rz6xxbcqhd1AyCgnhQ2PYTJqn9Pn3k6K9foAju+VP4cmm/2aoGSVmlbZKyJNV2BxSGQp4UoxAEtzJW8jZEncQB6XRc95K3jfYrMl0rbFIVyRvaI48UgzxosIinL1zQJfytYsgBFIHHsAq4pZpL6FQrqA6EXvkbD8asFraAtXimXYyU3JWmSml6r68D+wMAk2SmQUHF/J78x2QlhdW9hXPqeyNSY/M1ZmHSv4CWRZqgtYR9HKc8M9QCbF1oCMM9gExJIeUvhPdIYGTb7WEmdXpHobQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xTbrZXcJ+qB+2Q4r9UBqkotlHP2w2pf8RARGovVhmKU=;
 b=GzDHsV1RVf1Dl42QUMWmrRYm/+goqJ99Iiiqg2npxj9xCOZ4tUk6z+ubwr+p/noRpv+Kvbp70PucjxrJqZ28nLTcS2zgNfsCzAo3jVe4a3RSVR58/9LTWbl2bac7gql/ZhAUULxH762g8h/n66UKlCNsTsYn33+3XqPCR8TW1g0=
Received: from SN6PR12MB2767.namprd12.prod.outlook.com (2603:10b6:805:75::23)
 by DM4PR12MB5040.namprd12.prod.outlook.com (2603:10b6:5:38b::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5588.10; Tue, 6 Sep
 2022 14:06:03 +0000
Received: from SN6PR12MB2767.namprd12.prod.outlook.com
 ([fe80::e47d:1a95:23d5:922c]) by SN6PR12MB2767.namprd12.prod.outlook.com
 ([fe80::e47d:1a95:23d5:922c%7]) with mapi id 15.20.5588.018; Tue, 6 Sep 2022
 14:06:03 +0000
From:   "Kalra, Ashish" <Ashish.Kalra@amd.com>
To:     Borislav Petkov <bp@alien8.de>
CC:     "x86@kernel.org" <x86@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "rientjes@google.com" <rientjes@google.com>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "linux-coco@lists.linux.dev" <linux-coco@lists.linux.dev>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "slp@redhat.com" <slp@redhat.com>,
        "peterz@infradead.org" <peterz@infradead.org>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "hpa@zytor.com" <hpa@zytor.com>,
        "ak@linux.intel.com" <ak@linux.intel.com>,
        "Lendacky, Thomas" <Thomas.Lendacky@amd.com>,
        "alpergun@google.com" <alpergun@google.com>,
        "jroedel@suse.de" <jroedel@suse.de>,
        "dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>,
        "seanjc@google.com" <seanjc@google.com>,
        "pgonda@google.com" <pgonda@google.com>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "srinivas.pandruvada@linux.intel.com" 
        <srinivas.pandruvada@linux.intel.com>,
        "ardb@kernel.org" <ardb@kernel.org>,
        "dovmurik@linux.ibm.com" <dovmurik@linux.ibm.com>,
        "tobin@ibm.com" <tobin@ibm.com>,
        "Roth, Michael" <Michael.Roth@amd.com>,
        "jmattson@google.com" <jmattson@google.com>,
        "kirill@shutemov.name" <kirill@shutemov.name>,
        "vkuznets@redhat.com" <vkuznets@redhat.com>,
        "tony.luck@intel.com" <tony.luck@intel.com>,
        "vbabka@suse.cz" <vbabka@suse.cz>,
        "sathyanarayanan.kuppuswamy@linux.intel.com" 
        <sathyanarayanan.kuppuswamy@linux.intel.com>,
        "luto@kernel.org" <luto@kernel.org>,
        "dgilbert@redhat.com" <dgilbert@redhat.com>,
        "marcorr@google.com" <marcorr@google.com>,
        "jarkko@kernel.org" <jarkko@kernel.org>
Subject: RE: [PATCH Part2 v6 09/49] x86/fault: Add support to handle the RMP
 fault for user address
Thread-Topic: [PATCH Part2 v6 09/49] x86/fault: Add support to handle the RMP
 fault for user address
Thread-Index: AQHYrBDc30zm/ve2UUW13wSedLDd3a2nIMnggADB+gCAAMFX8IAieiDAgAC6pgCAAI/o0IAA2YMAgAAD/sCAACPGEIAAHNeAgAA8pvCAATXUAIACMz5g
Date:   Tue, 6 Sep 2022 14:06:03 +0000
Message-ID: <SN6PR12MB2767515C5FAD80BCC54BD5348E7E9@SN6PR12MB2767.namprd12.prod.outlook.com>
References: <YvN9bKQ0XtUVJE7z@zn.tnic>
 <SN6PR12MB2767A87F12B8E704EB80CC458E659@SN6PR12MB2767.namprd12.prod.outlook.com>
 <SN6PR12MB27672B74D1A6A6E920F364A78E7B9@SN6PR12MB2767.namprd12.prod.outlook.com>
 <YxGoBzOFT+sfwr4w@nazgul.tnic>
 <SN6PR12MB2767E95BA3A99A6263F1F9AE8E7A9@SN6PR12MB2767.namprd12.prod.outlook.com>
 <YxLXJk36EKxldC1S@nazgul.tnic>
 <SN6PR12MB276767FDF3528BC1849EEA0A8E7D9@SN6PR12MB2767.namprd12.prod.outlook.com>
 <SN6PR12MB2767074DEB38477356A3C0F98E7D9@SN6PR12MB2767.namprd12.prod.outlook.com>
 <BC747219-7808-4C39-A17C-A76B35DD6CB3@alien8.de>
 <SN6PR12MB2767C4C296281D25306885A78E7D9@SN6PR12MB2767.namprd12.prod.outlook.com>
 <YxRHfzN1AV7GZf8o@nazgul.tnic>
In-Reply-To: <YxRHfzN1AV7GZf8o@nazgul.tnic>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: MSIP_Label_4342314e-0df4-4b58-84bf-38bed6170a0f_Enabled=true;
 MSIP_Label_4342314e-0df4-4b58-84bf-38bed6170a0f_SetDate=2022-09-05T16:13:04Z;
 MSIP_Label_4342314e-0df4-4b58-84bf-38bed6170a0f_Method=Standard;
 MSIP_Label_4342314e-0df4-4b58-84bf-38bed6170a0f_Name=General;
 MSIP_Label_4342314e-0df4-4b58-84bf-38bed6170a0f_SiteId=3dd8961f-e488-4e60-8e11-a82d994e183d;
 MSIP_Label_4342314e-0df4-4b58-84bf-38bed6170a0f_ActionId=26405023-8bd4-401b-808d-f03b2b1c0cc8;
 MSIP_Label_4342314e-0df4-4b58-84bf-38bed6170a0f_ContentBits=1
msip_label_4342314e-0df4-4b58-84bf-38bed6170a0f_enabled: true
msip_label_4342314e-0df4-4b58-84bf-38bed6170a0f_setdate: 2022-09-06T14:06:00Z
msip_label_4342314e-0df4-4b58-84bf-38bed6170a0f_method: Standard
msip_label_4342314e-0df4-4b58-84bf-38bed6170a0f_name: General
msip_label_4342314e-0df4-4b58-84bf-38bed6170a0f_siteid: 3dd8961f-e488-4e60-8e11-a82d994e183d
msip_label_4342314e-0df4-4b58-84bf-38bed6170a0f_actionid: 174628b5-9a1c-4f7c-8fcb-843f440f10d9
msip_label_4342314e-0df4-4b58-84bf-38bed6170a0f_contentbits: 0
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 35c2f62d-8008-42f2-8652-08da9010ef32
x-ms-traffictypediagnostic: DM4PR12MB5040:EE_
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: MGcKZVHFmK0U2ZfOd0+Zfe7MAAFKAkxDLB4Uaz1A0+Banv2T6vH19w7H0YOGluP0HxTqo5L5lyCk9/kxSbqYa9ynUZ3tJVkLkGRd3VGuYg5D+bFfg+5ojTv37Ge1zMV+l9to2lyni+ImmJxkEwRzUyYgNTWugMs2MN6gbw8cM2pQ8nGA1gN2B6c0feipdSiGXqTmKBm9PKpb6Wfu07veXcg9LSl1um4n4r4gFEH8oZKwUd5YXWcuyI+YePLCEY7zDAo3z5NC1msWuf+dwvzXbWxLU4CZp1pD7wyGfG+oq8H0ae+7CCFJBliF3Aa6j8NsjgamIdnSvEGJ9oXZojo/h7JAyS9wSJK6596103L0yWDkjBNqSAZq9hwVx4t+p9onkb+45rcOQDk8dKbKJYOosi+IPOVPTMUZj2+LLIuXv3rDDmBvxvwb58wfcZcwd81BfsFecZtUffZM78aUCv9QAmq76EKVvY/n+bmnx5uKZRNS2IBN4FuPMTIlA8Dks/7r9qmSGnjfFJdOW75XmYZ639xB6slbUbCs+cxSCUwPjfm603iTZAbdl39GpLSSglR7mcXUifaOn753Ocl5NNyeyibxxICsX1RcZKZ2ukfxTshsgN8KMTbvvxGzpsgDI0pKRsABAKMTcIi/8zxizeM8WmRBdDFi+qHYfh5KDcgWVIBpZgE/mZ34XztehZw+V/0oL/jnQ9yEXGxBjFd7V+vE1ZVZisRPsIpk7ZGET7hbyLKjSOapKCeyk9ltwVcECvwF3WT9OgJjHIBhSztgJiDAhQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR12MB2767.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(396003)(366004)(346002)(39860400002)(376002)(136003)(41300700001)(186003)(52536014)(83380400001)(9686003)(2906002)(6916009)(7416002)(7406005)(55016003)(5660300002)(86362001)(33656002)(7696005)(71200400001)(8936002)(6506007)(478600001)(26005)(122000001)(38100700002)(38070700005)(66946007)(76116006)(66556008)(4326008)(8676002)(64756008)(66446008)(66476007)(316002)(54906003);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?JpgoQ4HXRK/5k1FEmDYTbtyLUjhVFODmpfnzzEDdeKs8ZkxYW4BXQWejD4zd?=
 =?us-ascii?Q?3xu3Fd8EinZEWNoHG7l8elipwk2afIgq2v3yhOWVog2/kR5Sev/vNc9taJKp?=
 =?us-ascii?Q?J4ijO9HgM5HhitCpC2DcNuhX+63SMPAZUhpNJory2moCGURb++XngWwkxeVQ?=
 =?us-ascii?Q?vd03h382b/TzTVDrjtORP9fMqeYNVkJfdSakbv1BIx+6ueQtwbg/uHv+umWR?=
 =?us-ascii?Q?q07oFrM5BNvx9BcMxCjNZKIR0B33G0XL3W5aT2wOZVfhlNCHcwQSkVuscqMo?=
 =?us-ascii?Q?mKsgE9ICTERbBgYHY9eKn30os+msj14S/YUNkILljlhPusuIUE3sgbxNAcRL?=
 =?us-ascii?Q?AeGJN6OTn8aKfkOH14W+cBkA/0NXXpekyViOGA5BdZBg0W7Txk0+4C8cXTPv?=
 =?us-ascii?Q?5FLxAY+W7N1Iq0BykCsTDaVSoheZ9aGLczwcLz1nCTLLliw9oRdK+qdVPscj?=
 =?us-ascii?Q?0KIZr7lBEtayvJWMOYilAhNVhWApKyQXRTy9J5lGmxWcxQiFpXRRSIu9prrM?=
 =?us-ascii?Q?Fh+PJDsdl2mZwF8ww0ZjK4EucNKYtvfQkf/EuFXCB5feIxfIzhj8qg8AemC+?=
 =?us-ascii?Q?863l8CVn6/uXQXd3FzU2TFIQp8sHAzhLtUrK62h1tZ6PRskqHLJFCH1RMdya?=
 =?us-ascii?Q?g+PakRLxUvZf8o1sJxSjLqAfgmOpLOxGH9By+WcTIzuy+QYtYL08hhrptvQp?=
 =?us-ascii?Q?xcO6hC6Drs9kEWUke4soR7+jEYjfiIH+WRaIV0hJYzhKKm/kpdYMK4SDiGtb?=
 =?us-ascii?Q?8/vjPOGzOdh0e/1WNK9O/ZRTnC3zrQkMHbG17OMjXl/g42Av4OrnHdsGNAEG?=
 =?us-ascii?Q?i3vTmq3i7OcjUz+TvNoNo4pIb+is0E9QcKyCuJhbadgxV4QNpHbQR02A0VXH?=
 =?us-ascii?Q?U5/aMFspykD1j43YjRUbg12m+4z1Bp5mmO47q+dwed6k0UjLT/bMFQIEeE5H?=
 =?us-ascii?Q?8yemQpg40x78cILSjt9SflLcfqfO/xyixGAi+H4/l4VaNs7wQ1BNJ0tAM/3/?=
 =?us-ascii?Q?S6L0ibJ+xE8sc+ueVz2CDZhBKr8y0QwEGfuGW8v/aBjjRBVN+0db/8+a2hEH?=
 =?us-ascii?Q?KZelJMRzS4iri5+qSmaJJ+fbVB1ASjl0W8rZYzWZIi0I2ILi6yLr+nkLKklF?=
 =?us-ascii?Q?L+qEeUp618i1cKte0hu3RvGw5nbDDxyqCU3uld5Xxi4GXwRT6zt9yb8f0Sr3?=
 =?us-ascii?Q?BYoWu0o/Y/w0S8zSUCAWiZU+HpO0rwmqV0Sp9ScVPs+7GNQHYa2OLfR2G8Mp?=
 =?us-ascii?Q?7BDq2+eI8tvvn8LO1vZjvjNYwH6jaOrfbFEr8Y/2/+kl824B75xooPbZ7IjZ?=
 =?us-ascii?Q?f7vCZKxl9MeLXPZUripj+ftkI45z+vGrGpPNFmESkQo8yJF+JBlEcbQ4b6Pz?=
 =?us-ascii?Q?bHS4aJR5Y6TG4jYHhcDvXxrkgJTtB4b6WuF43a0VaOqZvjZApa7qCMNUyQRh?=
 =?us-ascii?Q?xOVKs6J3fZpRp7HFw4T7AtWV/erfcg+YdHyD3LCp3A1sz4FTXoGgRjloeSnK?=
 =?us-ascii?Q?ZgeJMyigbq13rz2BH2aRwkmZ4m7SCtrP1Fg3n6H2S/mjQckdMzDC3tMdK+IP?=
 =?us-ascii?Q?hoqkMHUY94VyN7nlPJs=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SN6PR12MB2767.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 35c2f62d-8008-42f2-8652-08da9010ef32
X-MS-Exchange-CrossTenant-originalarrivaltime: 06 Sep 2022 14:06:03.2663
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: YW5KOre2nyGFmodG7hCbyT+xdCW3WuYiVuCxWVM6TYGe2NMoWxNgs08I8IT3tSva7yXyIQpmd5hiGJAtDrfuhg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB5040
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

[AMD Official Use Only - General]

Hello Boris,

>> There is 1 64-bit RMP entry for every physical 4k page of DRAM, so=20
>> essentially every 4K page of DRAM is represented by a RMP entry.

>Before we get to the rest - this sounds wrong to me. My APM has:

>"PSMASH	Page Smash

>Expands a 2MB-page RMP entry into a corresponding set of contiguous 4KB-pa=
ge RMP entries. The 2MB page's system physical address is specified in the =
RAX register. The new entries inherit the attributes of the original entry.=
 Upon completion, a >return code is stored in EAX.
>rFLAGS bits OF, ZF, AF, PF and SF are set based on this return code..."

>So there *are* 2M entries in the RMP table.

> So even if host page is 1G and underlying (smashed/split) RMP entries=20
> are 2M, the RMP table entry has to be indexed to a 4K entry=20
> corresponding to that.

>So if there are 2M entries in the RMP table, how does that indexing with 4=
K entries is supposed to work?

>Hell, even PSMASH pseudocode shows how you go and write all those 512 4K e=
ntries using the 2M entry as a template. So *before* you have smashed that =
2M entry, it *is* an *actual* 2M entry.

>So if you fault on a page which is backed by that 2M RMP entry, you will g=
et that 2M RMP entry.

> If it was simply a 2M entry in the RMP table, then pmd_index() will=20
> work correctly.

>Judging by the above text, it *can* *be* a 2M RMP entry!

>By reading your example you're trying to tell me that a RMP #PF will alway=
s need to work on 4K entries. Which would then need for a 2M entry as above=
 to be PSMASHed in order to get the 4K thing. But that would be silly - RMP=
 PFs will this way >gradually break all 2M pages and degrage performance fo=
r no real reason.

>So this still looks real wrong to me.

Please note that RMP table entries have only 2 page size indicators 4k and =
2M, so it covers a max physical address range of 2MB.
In all cases, there is one RMP entry per 4K page and the index into the RMP=
 table is basically address /PAGE_SIZE, and that does
not change for hugepages. Therefore we need to capture the address bits (fr=
om address) so that we index into the=20
4K entry in the RMP table.=20

An important point to note here is that RMPUPDATE instruction sets the Assi=
gned bit for all the sub-page entries for
a hugepage mapping in RMP table, so we will get the correct "assigned" page=
 information when we index into the 4K entry
in the RMP table and additionally,  __snp_lookup_rmpentry() gets the 2MB al=
igned entry in the RMP table to get the correct Page size.
(as below)

static struct rmpentry *__snp_lookup_rmpentry(u64 pfn, int *level)
{
         ..
        /* Read a large RMP entry to get the correct page level used in RMP=
 entry. */
        large_entry =3D rmptable_entry(paddr & PMD_MASK);
        *level =3D RMP_TO_X86_PG_LEVEL(rmpentry_pagesize(large_entry));
        ..

Therefore, the 2M entry and it's subpages in the RMP table will always exis=
t because of the RMPUPDATE instruction even
without smashing/splitting of the hugepage, so we really don't need the 2MB=
 entry to be PSMASHed in order to get the 4K thing.=20

Thanks,
Ashish
