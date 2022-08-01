Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 94095587396
	for <lists+kvm@lfdr.de>; Mon,  1 Aug 2022 23:50:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233981AbiHAVun (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 1 Aug 2022 17:50:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45296 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234715AbiHAVul (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 1 Aug 2022 17:50:41 -0400
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2060.outbound.protection.outlook.com [40.107.94.60])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 796CB33E3F;
        Mon,  1 Aug 2022 14:50:39 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Jb3E60nfh8SExVy1Rq2aYucRrY4XBH9p5RitY35zrY6nbnqYs98k0dnGarTIaeR9i3lULYzm5K6Qj0KvsOC462Yund7S3QFP4Orfz21BtI6rzq1c2YuKg9w8V7CkxiZvYq4b0vh/Y/QC7M6EKuvHZZmvmo7uvq7LbUtdA0HxzFs9hOIX/pGo+si0ChwFy9vqN/jp1+g7QQU2yQmOjpWNNCXk0XX69MWVvHiB/OeJ47ElZccvl3QBOGa26SjiWEapOTZgEf5i5beCYrEaX5cSD9BApV0MQ0eBhuP9cxYm4EXjBn2uSH8niH8hVDi2XC9PC4OUcgh10K1iK16DeXdrDw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=mUWrBzUIUdIg+XNRO5/LQ0VTPvePzzxnBUzg4ipYhXI=;
 b=j2TZUJyk2XhzLjn9hwEPKaBpyHLTxb+Ym2NrC1NNtLWWfnN7QdFCzvcoqcvTKeWpU+dpVG0LcO1fj7NkwR2/Xf5Ujv+2W7UqE1pJUwsU/IjtUh+03xktNdOsVJ36h3IEFU5xiTGI0nXlMTlCuhvXHUsLBmR1MxMOqi8ShqHKVerTLTFAyWtlVXcz0IfylmMSf8gHKyeNbUBeDE9X+XEqihqXAZxkLQYO66O/w+vfhwP0SwPui/VmAqeSOgxyRW5n6euvXlczbFZS2Q/ME7YYRBidn4KumwoSxFBavX9FhWvLdBOD5sdYmfJTV0paz1E/qIrrlnC3ZyMpif3P/JeIag==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=mUWrBzUIUdIg+XNRO5/LQ0VTPvePzzxnBUzg4ipYhXI=;
 b=XXcYuUDAVB+wKrUqSGGj1V59yBJxh2W4K9M4SPPafCVdcPbiFWHY4XRh0Oara9K3JNPiXgT9JLjmMjFX+54sxFr36MeBeFrLZqhcUANo/sQlcV6tb8QT/sqBeZPU1mbHhalYwtBe02D0TSXbI+hRqQHs+MnfpsikFKkhcKUjaMs=
Received: from SN6PR12MB2767.namprd12.prod.outlook.com (2603:10b6:805:75::23)
 by CY4PR12MB1941.namprd12.prod.outlook.com (2603:10b6:903:11a::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5482.14; Mon, 1 Aug
 2022 21:50:37 +0000
Received: from SN6PR12MB2767.namprd12.prod.outlook.com
 ([fe80::8953:6baa:97bb:a15d]) by SN6PR12MB2767.namprd12.prod.outlook.com
 ([fe80::8953:6baa:97bb:a15d%7]) with mapi id 15.20.5482.016; Mon, 1 Aug 2022
 21:50:37 +0000
From:   "Kalra, Ashish" <Ashish.Kalra@amd.com>
To:     Borislav Petkov <bp@alien8.de>,
        Sean Christopherson <seanjc@google.com>
CC:     Dave Hansen <dave.hansen@intel.com>,
        "x86@kernel.org" <x86@kernel.org>,
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
Thread-Index: AQHYhkJMEjVRVcpx502HVSPCQUlAqK1bejcAgAACPYCAAD2E8IAAAkWAgAAEHtCAAALbAIAAEKeAgAACGACAAAZmMIABummAgAABGvCALNnqAIAAfWiAgAAF14CAD98qkA==
Date:   Mon, 1 Aug 2022 21:50:37 +0000
Message-ID: <SN6PR12MB2767658F1A362C82922FB2DB8E9A9@SN6PR12MB2767.namprd12.prod.outlook.com>
References: <681e4e45-eff1-600c-9b81-1fa9bdf24232@intel.com>
 <BYAPR12MB27595CF4328B15F0F9573D188EB29@BYAPR12MB2759.namprd12.prod.outlook.com>
 <99d72d58-a9bb-d75c-93af-79d497dfe176@intel.com>
 <BYAPR12MB275984F14B1E103935A103D98EB29@BYAPR12MB2759.namprd12.prod.outlook.com>
 <5db37cc2-4fb1-7a73-c39a-3531260414d0@intel.com>
 <BYAPR12MB2759AA368C8B6A5F1C31642F8EB29@BYAPR12MB2759.namprd12.prod.outlook.com>
 <YrTq3WfOeA6ehsk6@google.com>
 <SN6PR12MB276743CBEAD5AFE9033AFE558EB59@SN6PR12MB2767.namprd12.prod.outlook.com>
 <YtqLhHughuh3KDzH@zn.tnic> <Ytr0t119QrZ8PUBB@google.com>
 <Ytr5ndnlOQvqWdPP@zn.tnic>
In-Reply-To: <Ytr5ndnlOQvqWdPP@zn.tnic>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: MSIP_Label_4342314e-0df4-4b58-84bf-38bed6170a0f_Enabled=true;
 MSIP_Label_4342314e-0df4-4b58-84bf-38bed6170a0f_SetDate=2022-08-01T21:47:54Z;
 MSIP_Label_4342314e-0df4-4b58-84bf-38bed6170a0f_Method=Standard;
 MSIP_Label_4342314e-0df4-4b58-84bf-38bed6170a0f_Name=General;
 MSIP_Label_4342314e-0df4-4b58-84bf-38bed6170a0f_SiteId=3dd8961f-e488-4e60-8e11-a82d994e183d;
 MSIP_Label_4342314e-0df4-4b58-84bf-38bed6170a0f_ActionId=d59a5693-f5fd-4e04-b216-e51b70cd444b;
 MSIP_Label_4342314e-0df4-4b58-84bf-38bed6170a0f_ContentBits=1
msip_label_4342314e-0df4-4b58-84bf-38bed6170a0f_enabled: true
msip_label_4342314e-0df4-4b58-84bf-38bed6170a0f_setdate: 2022-08-01T21:50:35Z
msip_label_4342314e-0df4-4b58-84bf-38bed6170a0f_method: Standard
msip_label_4342314e-0df4-4b58-84bf-38bed6170a0f_name: General
msip_label_4342314e-0df4-4b58-84bf-38bed6170a0f_siteid: 3dd8961f-e488-4e60-8e11-a82d994e183d
msip_label_4342314e-0df4-4b58-84bf-38bed6170a0f_actionid: f3da2763-b53b-4cb3-a9f3-25a4b2069d66
msip_label_4342314e-0df4-4b58-84bf-38bed6170a0f_contentbits: 0
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 4667e8fe-5c0c-4621-2e5b-08da7407de68
x-ms-traffictypediagnostic: CY4PR12MB1941:EE_
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: nZrFlDdDbA48lupu0mMl821rjtqJjYLI/DKlOIEYIgnhVXZjBDG66TD4wR0IUXJ/AHYnk1zyyurF/iS4QyE9KDM818Gn+CDZ68D7/VhRUHuU2nrcy74EOnyOS/bLF6vYSzaAGmZdhtDZ23sbDIvbfBq6fLdTAt2A9b/t6sumVnDxJggO02LQiydeeHgF+0FZ7qpyRMlUkUi0pT4ulOkCk7mtCqW3mscaaV5Jo9ssB/tvk+RpzUaVjBkpt357PcQO9eGVXf46iozkmcQCnFncBjMyzbVegXodWgdmfql+3wQhsf4/j5IckS/RcnRi8VyuvP/MDJKV/zYQAADviEs8DEJ5upeZoHgDnzwRSSrVSvOedxtxcIMyFYOoG51HPquhFM5pFCPIpkyo2OEAytyhH2D91SQ8q5DQy/78fuPi+Fmsd0wQxVj/yIvgFlv8boN6WyJrE5x7wEYRAk9OMYZoOV3bPScf+NR3GYI0AgULykoyx9DHG+0uNkZVEEn8txABHmNT7y/6o2okaEvF4rgeXeOeLV/5G2E3ML80BW//CJ+0+41SIjOtlK4PMGfJ8QLKXwGpz/9rtMqs3E7iljVTtczFpw7RbXY3+6nBPI1t+QfNp3LBM8k65zTvRawntvKJfpHM5eEabPhZBXtZ517wkxd0DcEmXZHGA3YnyKDD/Z8F2AE5NuM/+KOVYqL5gGlJoXSC3hXskdL66K/BuQNqfFXpv4ih8HvlSI4UcTfPSSFkodUajDZJkDKeXl9nxyBRN3omnFn27AhBD+dm/tpoLGaypGWEEfRFyDGgHLdRRM2OL9lXlnDxEFNx7qKyo7cY
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR12MB2767.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(39860400002)(396003)(136003)(366004)(346002)(376002)(66476007)(66946007)(26005)(41300700001)(9686003)(66446008)(66556008)(64756008)(7696005)(6506007)(8936002)(478600001)(316002)(186003)(110136005)(54906003)(52536014)(71200400001)(83380400001)(4326008)(8676002)(76116006)(33656002)(38100700002)(122000001)(86362001)(55016003)(38070700005)(2906002)(7406005)(7416002)(4744005)(5660300002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?JoePGJw5cUwu9BxopF034vMDM0qsASzMRjloBkGcWAS4l67VDv0cSRNsjLX7?=
 =?us-ascii?Q?6cwBR6I8MpD0aeMQG3Sx7iV3U4bQe5h7+Wz5M49Ypb9+x6gZfrVy39ebfvBS?=
 =?us-ascii?Q?sy16117bLeuIu4fO4BAcpvoJ7x3L72h5KNaTuGKpwmoXYr6CiIqs6Yb1NVqH?=
 =?us-ascii?Q?rmpj9n6GE+t/M97wItqQH1jOanQoIUW4gd02hXTs2qAd7VYs/nhtigUEWmYR?=
 =?us-ascii?Q?DGwZjNBRGzvT/yvcEhpNkziQO/VK4NjI+gFKE6hQUERLtpNyEr4l44kp00Q0?=
 =?us-ascii?Q?x981726/wSrfMwKVPDTlQN4Qm+OBwO4IWCf/PKWrnWY7xvC2Rfa9AGjZJ0Hi?=
 =?us-ascii?Q?vQvtnV3inYmlep7S5wuQwAtqrIPwNcUMa4xHzo3R9uhgLRxNemhFTCOrH6Wm?=
 =?us-ascii?Q?gi9jCoE5OavFacLQYLr80YxvK391fGP/a+xWQ3zzQOXjIhB2uk7xk2D+wF6N?=
 =?us-ascii?Q?bb1JoP4MC8rAKzwx7WH9uUDciQGF0Uwx6khskVSG7IAGUt6NoLErjH8gBnlz?=
 =?us-ascii?Q?9YLNF43Efuww1g6Wwy7gDa8m8CQfeym465d/00oxLBc2gH7QmH8OIEfh+ffS?=
 =?us-ascii?Q?fiV27oED9HNFkVSTkesz84wAnXrHWqgMlJx+bcIjvVCsV9ut7vipx+KfAnwi?=
 =?us-ascii?Q?3x1itCgxJ+cLBjf2vDasvWJtjR0Anr7lqTtfwlx40YJUaFgJD7GBqK50tHej?=
 =?us-ascii?Q?EkTD2/nAFGbt0eqQqqC1DEFU7JSBJUjuxhaG4MrdQHUobEEMPoSboi49WjQa?=
 =?us-ascii?Q?2sz9JSNbyGxoIZ52pK85XyOsY9VGON+vUktuiH5Fnkos5w4kdQPmBdYzMcmC?=
 =?us-ascii?Q?piuzPP6x5F6SOO/nfmbgvaZK1jbkAIxO5NRqCh7MpV2RnlEiqtab+dCZlclX?=
 =?us-ascii?Q?0bXXpyXx7IqkSbbrYZwHVo4xUpX/fUWwxiU3Xgu/TxmATPRHP15EUyQMMN9Y?=
 =?us-ascii?Q?ecLMvT2cl07kZ/VgjQOsEjDOhUn5nxZQzAcMH75CjrjitFCIq5rzQ6e1gs5H?=
 =?us-ascii?Q?7CiFgORO4qX8r6FY/5/fWfq4f2Ur2m6hRmprWC9Bs06IpgW5MU4mvGKjo6/g?=
 =?us-ascii?Q?+upNLDCG105fipz98gphX9GBqAeGa3LpLPSZdwfCXBbTpLZh0NdPiZEKJJWv?=
 =?us-ascii?Q?Eq8icaFZXOppU0mKQOQUCdc9U8XcqdqMfskv62YvSFuvH9QYGzHh1YXglaRk?=
 =?us-ascii?Q?n+3GTSIaWCjRsK1woqfajPBGZUOYCNJfS0StfZBiamIXLU19iJ+ddeNAyqFx?=
 =?us-ascii?Q?rZO34H3aogVeboq1ykxlkN3fm8Q3I4KMW2qsfgW9Smmx/sTDXzQbculq/UFu?=
 =?us-ascii?Q?qMDULMgsy/utrwcsMk6mC7i3wWJaFtwuRojBbrymQLPT6nRzPuyfyQjQ7XpW?=
 =?us-ascii?Q?1Zfy/1NQ6wpy+7V7YhmVJWz98PfYIErCkPDiX6s/spDPzF/mE5aHuRTGGCH3?=
 =?us-ascii?Q?JaHVWBxBWbptGa47pN4qX0SFO4IfcdlFCsTN3uF+AxTDP4ntZbh5htDu18YZ?=
 =?us-ascii?Q?Puem7U/5cbPiCZCQoqcTjnWCkp5CPfdJ1mgdUFbGejgoxykPG2aL5xTKcKhc?=
 =?us-ascii?Q?HI5Ksljzft+Qf5MNdH4=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SN6PR12MB2767.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4667e8fe-5c0c-4621-2e5b-08da7407de68
X-MS-Exchange-CrossTenant-originalarrivaltime: 01 Aug 2022 21:50:37.0684
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: hPP0mf5N8vk9V9w7FgbVrx5k0emK/PpIPxbGPNyvMRUBsT8ksoE3WHTqNA2Zpgs9WQJ4rZjx6UrfFIOr7Nz+IQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR12MB1941
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

>> I disagree.  Running an old kernel on new hardware with a different=20
>> RMP layout should refuse to use SNP, not read/write garbage and likely=20
>> corrupt the RMP and/or host memory.

>See my example below.

> And IMO, hiding the non-architectural RMP format in SNP-specific code=20
> so that we don't have to churn a bunch of call sites that don't _need_=20
> access to the raw RMP format is a good idea regardless of whether we=20
> want to be optimistic or pessimistic about future formats.

>I don't think I ever objected to that.

I agree with what Sean is recommending to do.=20

As I mentioned earlier, in the long term and with respect to future platfor=
ms, we are going to add architectural support
to read RMP table entries, so this structure will exist only for older plat=
form support.

Thanks,
Ashish
