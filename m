Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 766025F343D
	for <lists+kvm@lfdr.de>; Mon,  3 Oct 2022 19:11:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229612AbiJCRLS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 3 Oct 2022 13:11:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39068 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229730AbiJCRLL (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 3 Oct 2022 13:11:11 -0400
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2051.outbound.protection.outlook.com [40.107.243.51])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 97EAC326D9;
        Mon,  3 Oct 2022 10:11:07 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=B0d/+qZ8CvTo5oJzx6hfjzOuSURAhCkVB0k/2W7BuH0R8fMRDo79cDPm/Rp8XBhDqqlG/7YIzxbspnAEVqijeiLFb6wLNNx6I9qf8PhgwGM7oAugNktv5x7knGVgwEjjO6pJedEPbI8Av7WPNKF9X4L5Fr3swq+SCbDbtFEWedt6CPxTtN/eYn5AT67YfZjJX0MSBc3u150ZG2jy5u2PH/KyHllhEXJuuYdOKsEwnmApuGs0isuf6zRKoJiV0KFGVX5hb2hIO1frKokR5YoG2ALWfDMN6f00gFG7EyXCCZueQRtC38SX8+mPvC9KE3HdiUgTrgG0Y90EA8VCevC6Kw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=/+QHiJat/9QoWg+U1vqEeOeQNW19tbz8TVALRdXsnBk=;
 b=UVitdE22Hh/kHHUI6VJF3QkjeBoCUI8McsQvsdBYJ7SUqd0HkOfm8zJPCIhvV9JUL/F9MqPxpWzZ7C5YRdUZRH1OeCu7urLkKEArCUrsU4lPv2ZNWygUw6W0U2DFd7piLa3YZ/z8mKpwNvE/VqAqTpHnSkhherHS9SCFh79yXyWxQMysA0yn+Bz59eOeVyNX8/4YVmdIpj5K+ls5vuz2cFS3pcfuGHXjwgVgLYgx9U8lnJKDJlK0zgxZ249GP0tfrWmyzf/+mikdCbkNX4AEBm9RF5KAj1LFPrV5HtaUAx6I1ppCBT/TtDT26DvwBuERArjJhwGbCwbwDExptlzA4Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/+QHiJat/9QoWg+U1vqEeOeQNW19tbz8TVALRdXsnBk=;
 b=eLOHhs6qDua1Oo1BXes1Lbf7HuNprFiSHWvUcDQ73mIWPxM0A9N7c4VOQJLFLzxutBVedWhs/GzgbixMWlP7aImpAGaKCXVzM/M04LZhLCvU2zDxs1BSP8AXpjOodopzQwTc8b8Lfjgzg5RXI3sLlRQ9zqETHooTwYW7P1AV/Qc=
Received: from SN6PR12MB2767.namprd12.prod.outlook.com (2603:10b6:805:75::23)
 by MN2PR12MB4519.namprd12.prod.outlook.com (2603:10b6:208:262::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5676.28; Mon, 3 Oct
 2022 17:11:05 +0000
Received: from SN6PR12MB2767.namprd12.prod.outlook.com
 ([fe80::8588:d2f4:2eb9:7021]) by SN6PR12MB2767.namprd12.prod.outlook.com
 ([fe80::8588:d2f4:2eb9:7021%4]) with mapi id 15.20.5676.024; Mon, 3 Oct 2022
 17:11:05 +0000
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
Subject: RE: [PATCH Part2 v6 13/49] crypto:ccp: Provide APIs to issue SEV-SNP
 commands
Thread-Topic: [PATCH Part2 v6 13/49] crypto:ccp: Provide APIs to issue SEV-SNP
 commands
Thread-Index: AQHY1dLd4Juks83jB0yfjCsoLH1Lj638u9DQgAAfqQCAAA0/0A==
Date:   Mon, 3 Oct 2022 17:11:05 +0000
Message-ID: <SN6PR12MB276753083B811B1055FDE6408E5B9@SN6PR12MB2767.namprd12.prod.outlook.com>
References: <cover.1655761627.git.ashish.kalra@amd.com>
 <a63de5e687c530849312099ee02007089b67e92f.1655761627.git.ashish.kalra@amd.com>
 <YzigaOHddWU706H5@zn.tnic>
 <SN6PR12MB2767062CAD241C0BAFB7FAD98E5B9@SN6PR12MB2767.namprd12.prod.outlook.com>
 <YzsK+szsWoAlMsrR@zn.tnic>
In-Reply-To: <YzsK+szsWoAlMsrR@zn.tnic>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: MSIP_Label_4342314e-0df4-4b58-84bf-38bed6170a0f_Enabled=true;
 MSIP_Label_4342314e-0df4-4b58-84bf-38bed6170a0f_SetDate=2022-10-03T17:04:24Z;
 MSIP_Label_4342314e-0df4-4b58-84bf-38bed6170a0f_Method=Standard;
 MSIP_Label_4342314e-0df4-4b58-84bf-38bed6170a0f_Name=General;
 MSIP_Label_4342314e-0df4-4b58-84bf-38bed6170a0f_SiteId=3dd8961f-e488-4e60-8e11-a82d994e183d;
 MSIP_Label_4342314e-0df4-4b58-84bf-38bed6170a0f_ActionId=0f60104c-ea94-440a-bbd0-e104c7a35760;
 MSIP_Label_4342314e-0df4-4b58-84bf-38bed6170a0f_ContentBits=1
msip_label_4342314e-0df4-4b58-84bf-38bed6170a0f_enabled: true
msip_label_4342314e-0df4-4b58-84bf-38bed6170a0f_setdate: 2022-10-03T17:11:02Z
msip_label_4342314e-0df4-4b58-84bf-38bed6170a0f_method: Standard
msip_label_4342314e-0df4-4b58-84bf-38bed6170a0f_name: General
msip_label_4342314e-0df4-4b58-84bf-38bed6170a0f_siteid: 3dd8961f-e488-4e60-8e11-a82d994e183d
msip_label_4342314e-0df4-4b58-84bf-38bed6170a0f_actionid: 2f36f64f-a384-45a7-b24b-7ce1cbdedfaf
msip_label_4342314e-0df4-4b58-84bf-38bed6170a0f_contentbits: 0
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SN6PR12MB2767:EE_|MN2PR12MB4519:EE_
x-ms-office365-filtering-correlation-id: 2600d402-72c8-4233-4808-08daa562418e
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: bRkaG5MVa3SJ+9JSo8wEdG+0PZrTzlQhvgc3U4IILnOR5qZTQKiFhfuiBdQM+g9qvis952qH6/MiUKXXpZKtTzG3Z6lK2a8qE6PftedZYzlJvVygTgrNnxHJL0Cf/7yppRbBGBH1RAGnWx5G4MPb/jEIbSe7NdurX9ng/gdkvUpaPa4hsrOWs3/zqWUkPlo9BzwMbyRJNvojtua/UvwAcTmmWlduEcgs5wsT0PwZcAUUxNQ/I26OfhuumUixbpaFibqNiZIFE3akkn6ZCy0S0QSdcbjEWmn+ZlOAfb380dieeZ5kNVQ0o6oMpz+hoo3jlL0sRWCFn4ImaaYRM882nXCNkOQkBKZd6WgGs6wkToGyVmbdYZeJt3kr9mTPXmm5TEETDavVv0pJUgYr7VUkdvyxTzzQWeHvXNDd/jP4CWTui5daKv+TXpa2vEWDRk0gQ3iPX8alVftV/Jw4C99fyC1yo9avWQ1X/qn4buzjCZxZxAVZIq+hq9e3b/XbOsCAZi/aiRYK1+EHKHlWwalW2koZzX/xqlkwpQbsj0z2WZ8rUvI73vJiY+Bg4J/GI2ZWdN6vjIpmEdAWuxbw/el8dCz1bgDBwQUhcBIwpROzj7jBfJFvsmJneANT4+Mre6cNKqbbPQKgpWCzGufhSwSxw8bY1nL1RV0CT+4FRb4dZwmnPb9cq4NC8+nI2KHcI6SyFmqDn0JMs5IkNVBxBUdrI3nCsD8XNihD2+V2qz4UojDQ59IlS9mF65H6+A46nQIWChRTP4clRj1mWh/jjTsrF9tRN/KkXYoo3s0nGtH4TpU=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR12MB2767.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(376002)(346002)(39860400002)(396003)(366004)(136003)(451199015)(33656002)(86362001)(55016003)(38070700005)(54906003)(38100700002)(6916009)(316002)(8676002)(122000001)(71200400001)(64756008)(8936002)(7406005)(7416002)(5660300002)(52536014)(66476007)(66446008)(66556008)(66946007)(76116006)(2906002)(41300700001)(478600001)(66574015)(7696005)(6506007)(186003)(4326008)(966005)(9686003)(26005);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?iso-8859-2?Q?ah2S6xRDI/Gh6Dho1IkXk56eit1eWbr5DC8ukzsO9hkcodchWAL17VpQa5?=
 =?iso-8859-2?Q?2cfT5vPuTm/JNOhoA+znZHF1FEP+k8iXXKesluRmYKIiHQmm7xepF+dDBz?=
 =?iso-8859-2?Q?XQcY0qFJ4btft3o5f0HRUPublUPpupf4WhoFHF3YLTmo3451BGCTVt+K0x?=
 =?iso-8859-2?Q?lkzxFkA0aNmwWrbHaPyRp4W1YVslcFT1fTJYUMNMFRNvsXP6sdOFBHFUIE?=
 =?iso-8859-2?Q?UWkYRq+099iS3QTEZsGTSHCOvm7SWPSDO4nVUV295XPFRpa7Q/yZpobS6U?=
 =?iso-8859-2?Q?yhHFttT8j+ZZXXFJ5WucgOD35paxIcBcriqp3C0JxWMNsXD7EIo9Ra7dnO?=
 =?iso-8859-2?Q?N3K6TLdQJP+JVuuoddwfrh3uCQWbEI9RDIWqNhutr4RNn0kZAr3LD1Cc5X?=
 =?iso-8859-2?Q?GP0v2LzzzUTeQ9etwfvRRWwGX43O3WJbXBiQ7L3RR5s/dFkTWN32H0Tfoz?=
 =?iso-8859-2?Q?oz7iUC5B8l0BfuFfppmisEdiyqJ6pjmDGg6um6cOLb1SosPH6lQTkSJ7Y3?=
 =?iso-8859-2?Q?zCy4RMGKIcKH5+pPh9+wkzXYqzwOKWPwhxX9maE5ZgPDu0lO3zLOgJt+4w?=
 =?iso-8859-2?Q?4vhGlCoR+eLYXWs29ikrtq9p2ZH1S24MGC3YZPOUK/R1gs03bYgT0Nhh1t?=
 =?iso-8859-2?Q?HNC5i5a+/Je3J0OWsGyDZemd/K21jHyIG1Nb9avAvnXLj+Lqir9oxZcjhS?=
 =?iso-8859-2?Q?t7py9MNKgkiP5j5NxBfJ5C/cwLwCbtkYhy42UB1sxBTbiQXJYFxOFuEDyh?=
 =?iso-8859-2?Q?omKvSIn73enIYC2hzAImbrjChPxVDwiXybRT6R1rnF+omXX9lxCKXqVola?=
 =?iso-8859-2?Q?dcy4bEdR55QyUCglyiz32g6Bm8wgUi8K7vVSN+i0nz80O8zYUR5PX/G690?=
 =?iso-8859-2?Q?4hVTUHKseIiT8WTd8wrgXJFBy9CuCqHpq9tM4nJtdE5KKaH1qG6rut4zNU?=
 =?iso-8859-2?Q?r0b5OVUOW6OUPKT0TayALmk+iIT6StZ6yQYos3T3ZlOkHbPCLk+bthn+gP?=
 =?iso-8859-2?Q?M1iASrpjLLOT2m7vEIQPCF2GlbtYKr1PKlRcqxS0rjuMyeyKWHj6Gv6JZt?=
 =?iso-8859-2?Q?FaKtRoiDweEq75SZxbRUwSPZkasXz5x2y2khlTxE90e0DooRX0iEFDdJQa?=
 =?iso-8859-2?Q?2PVmFl6Qg9ue7knMbLwXLLfIlP7pIr9kQBk0yzQCSmHHFJU53a5m99buGG?=
 =?iso-8859-2?Q?MRrmNgyE4FBnmiyFXVVUIit6KG/sdPp4nPLvV+T0peRhalxYsTQyiJKrLp?=
 =?iso-8859-2?Q?h/B+FI3IUHuchiPKmmMUIF0tmwrBfjiOxS4fll3gtG2zDf6w3vF7KTRrHy?=
 =?iso-8859-2?Q?9ogqe0j3kJYIV/NPYbVj+jWFw6YquU9gZATLJStl2w0FJYNlljE7ruKxQX?=
 =?iso-8859-2?Q?SuAHmTsCAnv/GOYdPuCFKdi560uQyKQFvgRQ3DNFU5ZPcz5gVTzCRYbiIB?=
 =?iso-8859-2?Q?5K9xzYOUvqCaavkEBKd6gHk/KZOW+YHcPoXG9fWnJLNCTxceQ65qbWf4at?=
 =?iso-8859-2?Q?19ejp6zoLh9d6n8ltui8084m16rdX27JtdGrKrNsYRq3QJWMn19LRok+rp?=
 =?iso-8859-2?Q?//5ud4qdJdoufiNVJoxVhaguQNqgfcDP6GTAk65OPX5v6cp7Jsiclu+9qb?=
 =?iso-8859-2?Q?yCUylGHYAVy20=3D?=
Content-Type: text/plain; charset="iso-8859-2"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SN6PR12MB2767.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2600d402-72c8-4233-4808-08daa562418e
X-MS-Exchange-CrossTenant-originalarrivaltime: 03 Oct 2022 17:11:05.0943
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: GmKeL5kGdpx+7turGCQ+HqyTrMU4GaBlprFdABPouMC7eLOenlHpmPmmieGwTx8GW1M8RvzeCWjN1vDYtOAvUg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR12MB4519
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

>> There are actually only 8 functions

>Only 8?

>Lemme ask it differently then: what is the point of the wrappers at all?

They are basically providing the APIs for the hypervisor to manage a SNP gu=
est.

And this is the original commit for the API to manage the SEV guest:

commit 200664d5237f3f8cd2a2f9f5c5dea08502336bd1
Author: Brijesh Singh <brijesh.singh@amd.com>
Date:   Mon Dec 4 10:57:28 2017 -0600

    crypto: ccp: Add Secure Encrypted Virtualization (SEV) command support
   =20
    AMD's new Secure Encrypted Virtualization (SEV) feature allows the
    memory contents of virtual machines to be transparently encrypted with =
a
    key unique to the VM. The programming and management of the encryption
    keys are handled by the AMD Secure Processor (AMD-SP) which exposes the
    commands for these tasks. The complete spec is available at:
   =20
    http://support.amd.com/TechDocs/55766_SEV-KM%20API_Specification.pdf
   =20
    Extend the AMD-SP driver to provide the following support:
   =20
     - an in-kernel API to communicate with the SEV firmware. The API can b=
e
       used by the hypervisor to create encryption context for a SEV guest.
   =20
     - a userspace IOCTL to manage the platform certificates.
   =20
    Cc: Paolo Bonzini <pbonzini@redhat.com>
    Cc: "Radim Kr=E8m=E1=F8" <rkrcmar@redhat.com>
    Cc: Borislav Petkov <bp@suse.de>
    Cc: Herbert Xu <herbert@gondor.apana.org.au>
    Cc: Gary Hook <gary.hook@amd.com>
    Cc: Tom Lendacky <thomas.lendacky@amd.com>
    Cc: linux-crypto@vger.kernel.org
    Cc: kvm@vger.kernel.org
    Cc: linux-kernel@vger.kernel.org
    Improvements-by: Borislav Petkov <bp@suse.de>
    Signed-off-by: Brijesh Singh <brijesh.singh@amd.com>


Thanks,
Ashish
