Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B7FB454B774
	for <lists+kvm@lfdr.de>; Tue, 14 Jun 2022 19:17:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243618AbiFNRRA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 14 Jun 2022 13:17:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37696 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232953AbiFNRQ6 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 14 Jun 2022 13:16:58 -0400
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2059.outbound.protection.outlook.com [40.107.92.59])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 614EC27CE4;
        Tue, 14 Jun 2022 10:16:56 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=WLyJ7ZObwuO0ShsqmMwH3dbUh1SLSnszDbLGN3YTqJaOxWtaDx1LJf0qVMLwUFYNyETPa0rcqQxA96bCg6s5l3fgWcI8LMoXUilxfOkn96XC6I9FHNtcQldX0Tmf+SjH9lkN9xCF5dCU7zoeQrtnhiAd432sZn8axyRMN2lkMm7ym8NBuCrb6xqMsyR81rdC0A7ttGPoW5w5WuqkNc6R3TdcJr4wpGO9w0xkzCWWs5wOS75H9YrmHsguhCh4BvGwZHSoyLz/RiWs7LEIrD24XoEPkvyhOwGu7uoNeR+1VIqWvX44bzdmeeU0TzPYNRZu8onbU2j/JtaPWUOZK05z/Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=S28sLobNZ2Vnj8n3E4MvruyB3klP9KQiPYyYfKlTIlU=;
 b=BKvgxmH6Ldgk7vffT/Xa4GBNpgUtXvLZydT1xUEomDHi5bzok5DzoiA9b0EIQpSeUaExXVziwZoOrwEZhFyv/t110v+dEMaLt1sIT4EA10lJV3G57mRtygZGJgKLozcmXI+nGR+WJNpxUItoOq5do4ghrjqlUfMYYawCoQgjJOdTOZq6fEW+xM24GcGJjKrKlXRp+A1iW7o65dXUJz782N407EFd5iw27GA2E4lfg0tpr26wcpCrNIQvgrtSMMHs41ScRqSVzWrumYCbaHVGg7RgBqw6BUZ+cEPs/bWufxUZH9fNiyx9nZ9KqrbqOWE3MuWO199ooGVc2y1ZaT8zYw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=S28sLobNZ2Vnj8n3E4MvruyB3klP9KQiPYyYfKlTIlU=;
 b=vxqVmFDTlnOdl2ggYLyuZKpkN/3T3ClhtLwktZEAZzGRYBi3U9ia/gETuRU0HwPRXhOKZHg21kMrDUQLqieyuVgw16tPqsILksXVPWi8bT8OJ2GNMLIFqDiKzeAcDgcKZMMSuY11xGfGeUaTyVp0Ix3wNxkP1HnsnKjYqTQGedg=
Received: from SN6PR12MB2767.namprd12.prod.outlook.com (2603:10b6:805:75::23)
 by MWHPR12MB1584.namprd12.prod.outlook.com (2603:10b6:301:a::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5332.14; Tue, 14 Jun
 2022 17:16:53 +0000
Received: from SN6PR12MB2767.namprd12.prod.outlook.com
 ([fe80::810a:e508:3491:1b93]) by SN6PR12MB2767.namprd12.prod.outlook.com
 ([fe80::810a:e508:3491:1b93%2]) with mapi id 15.20.5332.022; Tue, 14 Jun 2022
 17:16:53 +0000
From:   "Kalra, Ashish" <Ashish.Kalra@amd.com>
To:     Peter Gonda <pgonda@google.com>
CC:     Alper Gun <alpergun@google.com>,
        the arch/x86 maintainers <x86@kernel.org>,
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
        Wanpeng Li <wanpengli@tencent.com>,
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
        <sathyanarayanan.kuppuswamy@linux.intel.com>
Subject: RE: [PATCH Part2 v5 23/45] KVM: SVM: Add KVM_SNP_INIT command
Thread-Topic: [PATCH Part2 v5 23/45] KVM: SVM: Add KVM_SNP_INIT command
Thread-Index: AQHYf2hrEdThX7LMOkaW6abY0uhVGK1NpC+AgABZDQCAAA1FAIABAAmAgAAIC4CAAAahAIAACkIw
Date:   Tue, 14 Jun 2022 17:16:53 +0000
Message-ID: <SN6PR12MB276764F83F8849603A2F23478EAA9@SN6PR12MB2767.namprd12.prod.outlook.com>
References: <20210820155918.7518-1-brijesh.singh@amd.com>
 <20210820155918.7518-24-brijesh.singh@amd.com>
 <CABpDEukdrEbXjOF_QuZqUMQndYx=zVM4s2o-oN_wb2L_HCrONg@mail.gmail.com>
 <1cadca0d-c3dc-68ed-075f-f88ccb0ccc0a@amd.com>
 <CABpDEun0rjrNVCGZDXd8SO3tfZi-2ku3mit2XMGLwCsijbF9tg@mail.gmail.com>
 <ee1a829f-9a89-e447-d182-877d4033c96a@amd.com>
 <CAMkAt6q3otA3n-daFfEBP7kzD+ucMQjP=3bX1PkuAUFrH9epUQ@mail.gmail.com>
 <SN6PR12MB27671CDFDAA1E62AD49EC6C68EAA9@SN6PR12MB2767.namprd12.prod.outlook.com>
 <CAMkAt6r0ZsjS_XtVYnazC8-Z9bHQafLZ7QFq2NqcRQ2gZbUyPg@mail.gmail.com>
In-Reply-To: <CAMkAt6r0ZsjS_XtVYnazC8-Z9bHQafLZ7QFq2NqcRQ2gZbUyPg@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: MSIP_Label_4342314e-0df4-4b58-84bf-38bed6170a0f_Enabled=true;
 MSIP_Label_4342314e-0df4-4b58-84bf-38bed6170a0f_SetDate=2022-06-14T17:06:52Z;
 MSIP_Label_4342314e-0df4-4b58-84bf-38bed6170a0f_Method=Standard;
 MSIP_Label_4342314e-0df4-4b58-84bf-38bed6170a0f_Name=General;
 MSIP_Label_4342314e-0df4-4b58-84bf-38bed6170a0f_SiteId=3dd8961f-e488-4e60-8e11-a82d994e183d;
 MSIP_Label_4342314e-0df4-4b58-84bf-38bed6170a0f_ActionId=f8cfa518-506b-4096-8f78-a5e466976f20;
 MSIP_Label_4342314e-0df4-4b58-84bf-38bed6170a0f_ContentBits=1
msip_label_4342314e-0df4-4b58-84bf-38bed6170a0f_enabled: true
msip_label_4342314e-0df4-4b58-84bf-38bed6170a0f_setdate: 2022-06-14T17:16:51Z
msip_label_4342314e-0df4-4b58-84bf-38bed6170a0f_method: Standard
msip_label_4342314e-0df4-4b58-84bf-38bed6170a0f_name: General
msip_label_4342314e-0df4-4b58-84bf-38bed6170a0f_siteid: 3dd8961f-e488-4e60-8e11-a82d994e183d
msip_label_4342314e-0df4-4b58-84bf-38bed6170a0f_actionid: 415278f7-f531-4628-925f-4a81864c61bd
msip_label_4342314e-0df4-4b58-84bf-38bed6170a0f_contentbits: 0
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 82bd6406-50de-4f7c-f10b-08da4e29ad71
x-ms-traffictypediagnostic: MWHPR12MB1584:EE_
x-microsoft-antispam-prvs: <MWHPR12MB15847013690DF6371BF50B5B8EAA9@MWHPR12MB1584.namprd12.prod.outlook.com>
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 1SEcjUeGp/y95iuYoYkthcf4jGxtr+s7yZq7Abe3t3WgSSOH7b6nVW7hBHN+WKPoK2XY1wrbfehCppRygvFPCBXg90/T7nIIrs0Gtw3tILQfBjksT2KqDW/iJXW47mOrF7SC8NycdXFbAmnzptOSk/U3z93isw6qRD1uO2XkIYne1A/lOOaejXnMEkAtjuRT9znWAb2nslN4mqE7atMQ2B5TvxZuD8o5F4FHKHuOzi6YWM+TefPo3pzw7iNRAAN17ZxQL6A97A1aAMAwjqoBO2MEopxV4RgffHdcjRnZyTr3uR3FngtTw5PDuHkKJyaipoozv3oo62ttFH0GA5v9+wLvCdZtnE3aUAtJI1KmDk84hICUWTfQwqbHRkR71HLvOq+VFGGQMYXMTRu+wP1XDltpG/h5cwdeJZYmhou3pU/biRUmMVBfaKv6vIohTBqkkT9WD7fVOna030YbyGXjrJycQyiGMk/sP9FPYl25g07XLGM9Z/Hj6RXUPpy9DZ6rLcra0Bz38ZAaFLwVyJXxCgrnHmtL5WJza+HrGkdlRqRiBHH7dFwpq3Ovfi97pdmTxVscnCj3Nf/4ZGQHKfDXIeRsQw03wrRbm5jzI5iEBzeGkUU7EhKuF/0qFK3qfgdAoeNIfGOwxmrzj1GY7ViYGaH65N2LuHE1Em7ZsWlSWL0L6zeUFnpea1xBqnmcynWDLMb7x28hOePBXaAg04q3xg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR12MB2767.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(366004)(33656002)(55016003)(53546011)(2906002)(83380400001)(26005)(7696005)(186003)(9686003)(6506007)(38070700005)(54906003)(52536014)(122000001)(8936002)(508600001)(5660300002)(7416002)(38100700002)(7406005)(86362001)(66946007)(66446008)(4326008)(71200400001)(8676002)(66476007)(316002)(66556008)(76116006)(6916009)(64756008);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?TVBQZzk2VUFEUjNqazJlUTREN3hXaUQzZGQwVk1oUFJhT1E0YVNSeCtmbVdX?=
 =?utf-8?B?VEV0cnJRSHJ3RTRoYStYVk1XUlVXZlJuTCtXcittUnVIR2d2YlhRaDVUMVZi?=
 =?utf-8?B?VHJaT0lqS0Fsc3Ztd2hyWkhKT3BvK3UrcnZlWmJFOW0zTC9zbEdTUTZwRjc0?=
 =?utf-8?B?L20xa25PdGxXK0JCUk1jZ1U3MzVlTEtubG1JRzdiMkhmVGdtWHpRM2pnaEpY?=
 =?utf-8?B?VmRCNG14M2RadVZEelhXK0VvT2JHNW00cGZtLzJ6REtyYVNiWEpTSjhCUlNJ?=
 =?utf-8?B?SkkvcDVwUDJBUVM0TXBZM2pzbVpJSzBHSURCcTkyMm1heDFaUGpkMkFWOHNO?=
 =?utf-8?B?czRzNVFGaGlNL2VPVVRFS1FwMmMyNytsaG1ScHhMbWEyOHV6bGYzY1NuK0lk?=
 =?utf-8?B?aGZ0dVA4Zk1RUmlvVmF1SE1YNUYxWVNETTEzNHRtcVVrZEF2WU5QNkdYY0gx?=
 =?utf-8?B?KzJ4dDJ4YVdXUExVSHdXcGl1eWZUaEF6NjZFN2JOSGpxUDF1S0h3MWdvSTQ1?=
 =?utf-8?B?TVZvUkNHSFJMZ05kUjZJdHBaU0U2SkgreEUweGdLZjdvRlJuN21zd2NoOW9F?=
 =?utf-8?B?RysrUHBQWFZ4UDJMcDdmWTlyWTZGRGFKU2o5QlVqVnBISDlWcUx1MGU5aVJj?=
 =?utf-8?B?Y3MvZitBTDNMK0pibmErOFFQOGFPM1U0VzhnbFFCMndmUDdOTGNSZFlCRHJI?=
 =?utf-8?B?VG5ubjhiZUpvY2pkd2U2VmFxZHRlMzMrRVFzNXJyQWtzMWM0ZEtsZGl6YXJo?=
 =?utf-8?B?K3NrWm1YN0VtT2x4SXhNUm5OazNSQ3AyeklQODdjaUxpcVAyYi9RV1ZyLzRz?=
 =?utf-8?B?WjB2VmZVUW9rcmI4QTBtRHlORFRqZlFFMjM3TGlnUVRDWHgvVWw0aWppZWh0?=
 =?utf-8?B?UFg0emsvditpZGVsMFJhaEhJcmo4NkMxZGEwY1JwR09IN3EyUkYzRklIN2Rn?=
 =?utf-8?B?TnVWckoybUk5NTFwVjdDOWM2bFYyRWNKcnAzWmF2cEVTWGhraVhZTnBkdnZN?=
 =?utf-8?B?Z21ZUmRPaGlHSjJlcnErZDFPSGVLUFhIaGhNM3ZPNnhaRS9HbHd0TE9TYnRu?=
 =?utf-8?B?dFk4SkFta0R1RmtDT0hkOEFGTlE5VnQ5aExwdnc4N1lpNjFZYk9HYWFhbEJ0?=
 =?utf-8?B?cTFiMkRtSTNkcE5JdjA3MUlEaWFJMHJTak93VHNkbXZEeU5EaFpuNnlTTjR6?=
 =?utf-8?B?SzkwNitXeUg4WlkxT3VTZDdFODVXZy9Qck1pSm93RXF3allmUXFsZ2JPcjVO?=
 =?utf-8?B?RDVUNm1semI1c0U1bG9MRy9iS2RMREZCMmpWMDU4N2luOWdQQ1lSN01rOVJa?=
 =?utf-8?B?QlhCeCtUanhYSDg5aTRsbURpci9wYnhQSW96a3lqVTNvcG14UkFieFdRckhH?=
 =?utf-8?B?SDczUTJ4ZnFEaDZxYkd1ZktrV2tZREJXRWRyVjcxTzJ5QUlNU296eDB3SHNy?=
 =?utf-8?B?d2xuNHZIc1Rlb1NmR3RhaEZhQzVCcHdYVHMwTlVsdDJ2ZGJpQkdFNzNJOTh1?=
 =?utf-8?B?Z1Y3ejZaRkYxMm11WW9pRHpaUllZL3NKanovaSt0ajJSNTJ0SWc3UjRpUWVq?=
 =?utf-8?B?WkZ6SHNjWk9jSDU2emluR2UwcTI3UUx5WVdjNVlEeHBxSkxUN0Y1ZitYK09U?=
 =?utf-8?B?TmV6R2dubHErUUJ0QlZCNFRORVZuelZTcHNHWDRycXh5NWhOckgwM1M0Z0xZ?=
 =?utf-8?B?VlRkQ3N1d0Zpb2VyMC83RFR2ZGtoSmxtMk9janhzT3UvWW13OGVKclJ1OXJU?=
 =?utf-8?B?QWxBcUR3TGxUb0F5MTc2M3d1eC92cjcvQ3RaYTA5UDFRdUw2WUpjb3lXK2M1?=
 =?utf-8?B?UzJLZHlnUDR5aE0xZjJyNFd2NFJZY0Y0NTFHblZGS0g5clR2K1V5M0M4bmxS?=
 =?utf-8?B?TENnYXpXZGFWMjdUeWJVV2pBYVdDc1M0SVVhbTFzY3pFMjdJdXBkRTMvWUtj?=
 =?utf-8?B?WlpGRTJBbnFEK0UvUVZpcm9MRXZHcUJJeWFoK0NTMklPQjdrVnhWU1BqUGNB?=
 =?utf-8?B?RTh6V2E2MXFHQ0RLMDJPSjI2YS9IUjE0V1hqN1hhaEZjaWNHcmdNL2ZEcW1M?=
 =?utf-8?B?TmFYVzBBYVZRTEpHUzZrZkVLank4Q0RtNzNJeFVpZlM3SG5DcG4xQk9NLytW?=
 =?utf-8?B?N21RRkN5blpybW5lZDdBcmcxbThzMXIwVFMvbHRjT2cvZjlCQ3pGMFRTMnBZ?=
 =?utf-8?B?MVhOdGdEM3c4VTlDN3BDZnRKVDdzejFpY2pMSEVNYlJoZE1RMFVKWWZadmhY?=
 =?utf-8?B?RUZnQjRWcnBXK3owTmdQQnl2R29tbndpV1dPdnZyN3VZNGMxT29aQkJxc000?=
 =?utf-8?B?NFBJUC9EeVlQbW9BaHJBYU1Zc0dDR3Z1OFF1Vm1MdzlnVEQxTEJMdz09?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SN6PR12MB2767.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 82bd6406-50de-4f7c-f10b-08da4e29ad71
X-MS-Exchange-CrossTenant-originalarrivaltime: 14 Jun 2022 17:16:53.6585
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: lhiOycfpIkA6D9e1BAxUsQbHJYbrIiilo1yWT5Oc4YjQz+AnVgIdmIyPq+0Y9RCQQ/SWeeUTd/M8eXWwTD94cQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR12MB1584
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

W0FNRCBPZmZpY2lhbCBVc2UgT25seSAtIEdlbmVyYWxdDQoNCkhlbGxvIEFscGVyLCBQZXRlciwN
Cg0KLS0tLS1PcmlnaW5hbCBNZXNzYWdlLS0tLS0NCkZyb206IFBldGVyIEdvbmRhIDxwZ29uZGFA
Z29vZ2xlLmNvbT4gDQpTZW50OiBUdWVzZGF5LCBKdW5lIDE0LCAyMDIyIDExOjMwIEFNDQpUbzog
S2FscmEsIEFzaGlzaCA8QXNoaXNoLkthbHJhQGFtZC5jb20+DQpDYzogQWxwZXIgR3VuIDxhbHBl
cmd1bkBnb29nbGUuY29tPjsgQnJpamVzaCBTaW5naCA8YnJpamVzaC5zaW5naEBhbWQuY29tPjsg
dGhlIGFyY2gveDg2IG1haW50YWluZXJzIDx4ODZAa2VybmVsLm9yZz47IExLTUwgPGxpbnV4LWtl
cm5lbEB2Z2VyLmtlcm5lbC5vcmc+OyBrdm0gbGlzdCA8a3ZtQHZnZXIua2VybmVsLm9yZz47IGxp
bnV4LWNvY29AbGlzdHMubGludXguZGV2OyBsaW51eC1tbUBrdmFjay5vcmc7IExpbnV4IENyeXB0
byBNYWlsaW5nIExpc3QgPGxpbnV4LWNyeXB0b0B2Z2VyLmtlcm5lbC5vcmc+OyBUaG9tYXMgR2xl
aXhuZXIgPHRnbHhAbGludXRyb25peC5kZT47IEluZ28gTW9sbmFyIDxtaW5nb0ByZWRoYXQuY29t
PjsgSm9lcmcgUm9lZGVsIDxqcm9lZGVsQHN1c2UuZGU+OyBMZW5kYWNreSwgVGhvbWFzIDxUaG9t
YXMuTGVuZGFja3lAYW1kLmNvbT47IEguIFBldGVyIEFudmluIDxocGFAenl0b3IuY29tPjsgQXJk
IEJpZXNoZXV2ZWwgPGFyZGJAa2VybmVsLm9yZz47IFBhb2xvIEJvbnppbmkgPHBib256aW5pQHJl
ZGhhdC5jb20+OyBTZWFuIENocmlzdG9waGVyc29uIDxzZWFuamNAZ29vZ2xlLmNvbT47IFZpdGFs
eSBLdXpuZXRzb3YgPHZrdXpuZXRzQHJlZGhhdC5jb20+OyBXYW5wZW5nIExpIDx3YW5wZW5nbGlA
dGVuY2VudC5jb20+OyBKaW0gTWF0dHNvbiA8am1hdHRzb25AZ29vZ2xlLmNvbT47IEFuZHkgTHV0
b21pcnNraSA8bHV0b0BrZXJuZWwub3JnPjsgRGF2ZSBIYW5zZW4gPGRhdmUuaGFuc2VuQGxpbnV4
LmludGVsLmNvbT47IFNlcmdpbyBMb3BleiA8c2xwQHJlZGhhdC5jb20+OyBQZXRlciBaaWpsc3Ry
YSA8cGV0ZXJ6QGluZnJhZGVhZC5vcmc+OyBTcmluaXZhcyBQYW5kcnV2YWRhIDxzcmluaXZhcy5w
YW5kcnV2YWRhQGxpbnV4LmludGVsLmNvbT47IERhdmlkIFJpZW50amVzIDxyaWVudGplc0Bnb29n
bGUuY29tPjsgRG92IE11cmlrIDxkb3ZtdXJpa0BsaW51eC5pYm0uY29tPjsgVG9iaW4gRmVsZG1h
bi1GaXR6dGh1bSA8dG9iaW5AaWJtLmNvbT47IEJvcmlzbGF2IFBldGtvdiA8YnBAYWxpZW44LmRl
PjsgUm90aCwgTWljaGFlbCA8TWljaGFlbC5Sb3RoQGFtZC5jb20+OyBWbGFzdGltaWwgQmFia2Eg
PHZiYWJrYUBzdXNlLmN6PjsgS2lyaWxsIEEgLiBTaHV0ZW1vdiA8a2lyaWxsQHNodXRlbW92Lm5h
bWU+OyBBbmRpIEtsZWVuIDxha0BsaW51eC5pbnRlbC5jb20+OyBUb255IEx1Y2sgPHRvbnkubHVj
a0BpbnRlbC5jb20+OyBNYXJjIE9yciA8bWFyY29yckBnb29nbGUuY29tPjsgU2F0aHlhbmFyYXlh
bmFuIEt1cHB1c3dhbXkgPHNhdGh5YW5hcmF5YW5hbi5rdXBwdXN3YW15QGxpbnV4LmludGVsLmNv
bT47IFBhdmFuIEt1bWFyIFBhbHVyaSA8cGFwYWx1cmlAYW1kLmNvbT4NClN1YmplY3Q6IFJlOiBb
UEFUQ0ggUGFydDIgdjUgMjMvNDVdIEtWTTogU1ZNOiBBZGQgS1ZNX1NOUF9JTklUIGNvbW1hbmQN
Cg0KT24gVHVlLCBKdW4gMTQsIDIwMjIgYXQgMTA6MTEgQU0gS2FscmEsIEFzaGlzaCA8QXNoaXNo
LkthbHJhQGFtZC5jb20+IHdyb3RlOg0KPg0KPiBbQU1EIE9mZmljaWFsIFVzZSBPbmx5IC0gR2Vu
ZXJhbF0NCj4NCj4NCj4gLS0tLS1PcmlnaW5hbCBNZXNzYWdlLS0tLS0NCj4gRnJvbTogUGV0ZXIg
R29uZGEgPHBnb25kYUBnb29nbGUuY29tPg0KPiBTZW50OiBUdWVzZGF5LCBKdW5lIDE0LCAyMDIy
IDEwOjM4IEFNDQo+IFRvOiBLYWxyYSwgQXNoaXNoIDxBc2hpc2guS2FscmFAYW1kLmNvbT4NCj4g
Q2M6IEFscGVyIEd1biA8YWxwZXJndW5AZ29vZ2xlLmNvbT47IEJyaWplc2ggU2luZ2ggDQo+IDxi
cmlqZXNoLnNpbmdoQGFtZC5jb20+OyBLYWxyYSwgQXNoaXNoIDxBc2hpc2guS2FscmFAYW1kLmNv
bT47IHRoZSANCj4gYXJjaC94ODYgbWFpbnRhaW5lcnMgPHg4NkBrZXJuZWwub3JnPjsgTEtNTCAN
Cj4gPGxpbnV4LWtlcm5lbEB2Z2VyLmtlcm5lbC5vcmc+OyBrdm0gbGlzdCA8a3ZtQHZnZXIua2Vy
bmVsLm9yZz47IA0KPiBsaW51eC1jb2NvQGxpc3RzLmxpbnV4LmRldjsgbGludXgtbW1Aa3ZhY2su
b3JnOyBMaW51eCBDcnlwdG8gTWFpbGluZyANCj4gTGlzdCA8bGludXgtY3J5cHRvQHZnZXIua2Vy
bmVsLm9yZz47IFRob21hcyBHbGVpeG5lciANCj4gPHRnbHhAbGludXRyb25peC5kZT47IEluZ28g
TW9sbmFyIDxtaW5nb0ByZWRoYXQuY29tPjsgSm9lcmcgUm9lZGVsIA0KPiA8anJvZWRlbEBzdXNl
LmRlPjsgTGVuZGFja3ksIFRob21hcyA8VGhvbWFzLkxlbmRhY2t5QGFtZC5jb20+OyBILiANCj4g
UGV0ZXIgQW52aW4gPGhwYUB6eXRvci5jb20+OyBBcmQgQmllc2hldXZlbCA8YXJkYkBrZXJuZWwu
b3JnPjsgUGFvbG8gDQo+IEJvbnppbmkgPHBib256aW5pQHJlZGhhdC5jb20+OyBTZWFuIENocmlz
dG9waGVyc29uIA0KPiA8c2VhbmpjQGdvb2dsZS5jb20+OyBWaXRhbHkgS3V6bmV0c292IDx2a3V6
bmV0c0ByZWRoYXQuY29tPjsgV2FucGVuZyANCj4gTGkgPHdhbnBlbmdsaUB0ZW5jZW50LmNvbT47
IEppbSBNYXR0c29uIDxqbWF0dHNvbkBnb29nbGUuY29tPjsgQW5keSANCj4gTHV0b21pcnNraSA8
bHV0b0BrZXJuZWwub3JnPjsgRGF2ZSBIYW5zZW4gDQo+IDxkYXZlLmhhbnNlbkBsaW51eC5pbnRl
bC5jb20+OyBTZXJnaW8gTG9wZXogPHNscEByZWRoYXQuY29tPjsgUGV0ZXIgDQo+IFppamxzdHJh
IDxwZXRlcnpAaW5mcmFkZWFkLm9yZz47IFNyaW5pdmFzIFBhbmRydXZhZGEgDQo+IDxzcmluaXZh
cy5wYW5kcnV2YWRhQGxpbnV4LmludGVsLmNvbT47IERhdmlkIFJpZW50amVzIA0KPiA8cmllbnRq
ZXNAZ29vZ2xlLmNvbT47IERvdiBNdXJpayA8ZG92bXVyaWtAbGludXguaWJtLmNvbT47IFRvYmlu
IA0KPiBGZWxkbWFuLUZpdHp0aHVtIDx0b2JpbkBpYm0uY29tPjsgQm9yaXNsYXYgUGV0a292IDxi
cEBhbGllbjguZGU+OyANCj4gUm90aCwgTWljaGFlbCA8TWljaGFlbC5Sb3RoQGFtZC5jb20+OyBW
bGFzdGltaWwgQmFia2EgDQo+IDx2YmFia2FAc3VzZS5jej47IEtpcmlsbCBBIC4gU2h1dGVtb3Yg
PGtpcmlsbEBzaHV0ZW1vdi5uYW1lPjsgQW5kaSANCj4gS2xlZW4gPGFrQGxpbnV4LmludGVsLmNv
bT47IFRvbnkgTHVjayA8dG9ueS5sdWNrQGludGVsLmNvbT47IE1hcmMgT3JyIA0KPiA8bWFyY29y
ckBnb29nbGUuY29tPjsgU2F0aHlhbmFyYXlhbmFuIEt1cHB1c3dhbXkgDQo+IDxzYXRoeWFuYXJh
eWFuYW4ua3VwcHVzd2FteUBsaW51eC5pbnRlbC5jb20+OyBQYXZhbiBLdW1hciBQYWx1cmkgDQo+
IDxwYXBhbHVyaUBhbWQuY29tPg0KPiBTdWJqZWN0OiBSZTogW1BBVENIIFBhcnQyIHY1IDIzLzQ1
XSBLVk06IFNWTTogQWRkIEtWTV9TTlBfSU5JVCBjb21tYW5kDQo+DQo+IE9uIE1vbiwgSnVuIDEz
LCAyMDIyIGF0IDY6MjEgUE0gQXNoaXNoIEthbHJhIDxhc2hrYWxyYUBhbWQuY29tPiB3cm90ZToN
Cj4gPg0KPiA+DQo+ID4gT24gNi8xMy8yMiAyMzozMywgQWxwZXIgR3VuIHdyb3RlOg0KPiA+ID4g
T24gTW9uLCBKdW4gMTMsIDIwMjIgYXQgNDoxNSBQTSBBc2hpc2ggS2FscmEgPGFzaGthbHJhQGFt
ZC5jb20+IHdyb3RlOg0KPiA+ID4+IEhlbGxvIEFscGVyLA0KPiA+ID4+DQo+ID4gPj4gT24gNi8x
My8yMiAyMDo1OCwgQWxwZXIgR3VuIHdyb3RlOg0KPiA+ID4+PiBzdGF0aWMgaW50IHNldl9ndWVz
dF9pbml0KHN0cnVjdCBrdm0gKmt2bSwgc3RydWN0IGt2bV9zZXZfY21kDQo+ID4gPj4+ICphcmdw
KQ0KPiA+ID4+Pj4gICAgew0KPiA+ID4+Pj4gKyAgICAgICBib29sIGVzX2FjdGl2ZSA9IChhcmdw
LT5pZCA9PSBLVk1fU0VWX0VTX0lOSVQgfHwgDQo+ID4gPj4+PiArIGFyZ3AtPmlkID09IEtWTV9T
RVZfU05QX0lOSVQpOw0KPiA+ID4+Pj4gICAgICAgICAgIHN0cnVjdCBrdm1fc2V2X2luZm8gKnNl
diA9ICZ0b19rdm1fc3ZtKGt2bSktPnNldl9pbmZvOw0KPiA+ID4+Pj4gLSAgICAgICBib29sIGVz
X2FjdGl2ZSA9IGFyZ3AtPmlkID09IEtWTV9TRVZfRVNfSU5JVDsNCj4gPiA+Pj4+ICsgICAgICAg
Ym9vbCBzbnBfYWN0aXZlID0gYXJncC0+aWQgPT0gS1ZNX1NFVl9TTlBfSU5JVDsNCj4gPiA+Pj4+
ICAgICAgICAgICBpbnQgYXNpZCwgcmV0Ow0KPiA+ID4+Pj4NCj4gPiA+Pj4+ICAgICAgICAgICBp
ZiAoa3ZtLT5jcmVhdGVkX3ZjcHVzKSBAQCAtMjQ5LDEyICsyNjksMjIgQEAgc3RhdGljIA0KPiA+
ID4+Pj4gaW50IHNldl9ndWVzdF9pbml0KHN0cnVjdCBrdm0gKmt2bSwgc3RydWN0IGt2bV9zZXZf
Y21kICphcmdwKQ0KPiA+ID4+Pj4gICAgICAgICAgICAgICAgICAgcmV0dXJuIHJldDsNCj4gPiA+
Pj4+DQo+ID4gPj4+PiAgICAgICAgICAgc2V2LT5lc19hY3RpdmUgPSBlc19hY3RpdmU7DQo+ID4g
Pj4+PiArICAgICAgIHNldi0+c25wX2FjdGl2ZSA9IHNucF9hY3RpdmU7DQo+ID4gPj4+PiAgICAg
ICAgICAgYXNpZCA9IHNldl9hc2lkX25ldyhzZXYpOw0KPiA+ID4+Pj4gICAgICAgICAgIGlmIChh
c2lkIDwgMCkNCj4gPiA+Pj4+ICAgICAgICAgICAgICAgICAgIGdvdG8gZV9ub19hc2lkOw0KPiA+
ID4+Pj4gICAgICAgICAgIHNldi0+YXNpZCA9IGFzaWQ7DQo+ID4gPj4+Pg0KPiA+ID4+Pj4gLSAg
ICAgICByZXQgPSBzZXZfcGxhdGZvcm1faW5pdCgmYXJncC0+ZXJyb3IpOw0KPiA+ID4+Pj4gKyAg
ICAgICBpZiAoc25wX2FjdGl2ZSkgew0KPiA+ID4+Pj4gKyAgICAgICAgICAgICAgIHJldCA9IHZl
cmlmeV9zbnBfaW5pdF9mbGFncyhrdm0sIGFyZ3ApOw0KPiA+ID4+Pj4gKyAgICAgICAgICAgICAg
IGlmIChyZXQpDQo+ID4gPj4+PiArICAgICAgICAgICAgICAgICAgICAgICBnb3RvIGVfZnJlZTsN
Cj4gPiA+Pj4+ICsNCj4gPiA+Pj4+ICsgICAgICAgICAgICAgICByZXQgPSBzZXZfc25wX2luaXQo
JmFyZ3AtPmVycm9yKTsNCj4gPiA+Pj4+ICsgICAgICAgfSBlbHNlIHsNCj4gPiA+Pj4+ICsgICAg
ICAgICAgICAgICByZXQgPSBzZXZfcGxhdGZvcm1faW5pdCgmYXJncC0+ZXJyb3IpOw0KPiA+ID4+
PiBBZnRlciBTRVYgSU5JVF9FWCBzdXBwb3J0IHBhdGNoZXMsIFNFViBtYXkgYmUgaW5pdGlhbGl6
ZWQgaW4gdGhlIHBsYXRmb3JtIGxhdGUuDQo+ID4gPj4+IEluIG15IHRlc3RzLCBpZiBTRVYgaGFz
IG5vdCBiZWVuIGluaXRpYWxpemVkIGluIHRoZSBwbGF0Zm9ybSANCj4gPiA+Pj4geWV0LCBTTlAg
Vk1zIGZhaWwgd2l0aCBTRVZfREZfRkxVU0ggcmVxdWlyZWQgZXJyb3IuIEkgdHJpZWQgDQo+ID4g
Pj4+IGNhbGxpbmcgU0VWX0RGX0ZMVVNIIHJpZ2h0IGFmdGVyIHRoZSBTTlAgcGxhdGZvcm0gaW5p
dCBidXQgdGhpcyANCj4gPiA+Pj4gdGltZSBpdCBmYWlsZWQgbGF0ZXIgb24gdGhlIFNOUCBsYXVu
Y2ggdXBkYXRlIGNvbW1hbmQgd2l0aCANCj4gPiA+Pj4gU0VWX1JFVF9JTlZBTElEX1BBUkFNIGVy
cm9yLiBMb29rcyBsaWtlIHRoZXJlIGlzIGFub3RoZXIgDQo+ID4gPj4+IGRlcGVuZGVuY3kgb24g
U0VWIHBsYXRmb3JtIGluaXRpYWxpemF0aW9uLg0KPiA+ID4+Pg0KPiA+ID4+PiBDYWxsaW5nIHNl
dl9wbGF0Zm9ybV9pbml0IGZvciBTTlAgVk1zIGZpeGVzIHRoZSBwcm9ibGVtIGluIG91ciB0ZXN0
cy4NCj4gPiA+PiBUcnlpbmcgdG8gZ2V0IHNvbWUgbW9yZSBjb250ZXh0IGZvciB0aGlzIGlzc3Vl
Lg0KPiA+ID4+DQo+ID4gPj4gV2hlbiB5b3Ugc2F5IGFmdGVyIFNFVl9JTklUX0VYIHN1cHBvcnQg
cGF0Y2hlcywgU0VWIG1heSBiZSANCj4gPiA+PiBpbml0aWFsaXplZCBpbiB0aGUgcGxhdGZvcm0g
bGF0ZSwgZG8geW91IG1lYW4gc2V2X3BjaV9pbml0KCktPnNldl9zbnBfaW5pdCgpIC4uLg0KPiA+
ID4+IHNldl9wbGF0Zm9ybV9pbml0KCkgY29kZSBwYXRoIGhhcyBzdGlsbCBub3QgZXhlY3V0ZWQg
b24gdGhlIGhvc3QgQlNQID8NCj4gPiA+Pg0KPiA+ID4gQ29ycmVjdCwgSU5JVF9FWCByZXF1aXJl
cyB0aGUgZmlsZSBzeXN0ZW0gdG8gYmUgcmVhZHkgYW5kIHRoZXJlIGlzIA0KPiA+ID4gYSBjY3Ag
bW9kdWxlIHBhcmFtIHRvIGNhbGwgaXQgb25seSB3aGVuIG5lZWRlZC4NCj4gPiA+DQo+ID4gPiBN
T0RVTEVfUEFSTV9ERVNDKHBzcF9pbml0X29uX3Byb2JlLCAiIGlmIHRydWUsIHRoZSBQU1Agd2ls
bCBiZSANCj4gPiA+IGluaXRpYWxpemVkIG9uIG1vZHVsZSBpbml0LiBFbHNlIHRoZSBQU1Agd2ls
bCBiZSBpbml0aWFsaXplZCBvbiANCj4gPiA+IHRoZSBmaXJzdCBjb21tYW5kIHJlcXVpcmluZyBp
dCIpOw0KPiA+ID4NCj4gPiA+IElmIHRoaXMgbW9kdWxlIHBhcmFtIGlzIGZhbHNlLCBpdCB3b24n
dCBpbml0aWFsaXplIFNFViBvbiB0aGUgDQo+ID4gPiBwbGF0Zm9ybSB1bnRpbCB0aGUgZmlyc3Qg
U0VWIFZNLg0KPiA+ID4NCj4gPiBPaywgdGhhdCBtYWtlcyBzZW5zZS4NCj4gPg0KPiA+IFNvIHRo
ZSBmaXggd2lsbCBiZSB0byBjYWxsIHNldl9wbGF0Zm9ybV9pbml0KCkgdW5jb25kaXRpb25hbGx5
IGhlcmUgDQo+ID4gaW4gc2V2X2d1ZXN0X2luaXQoKSwgYW5kIGJvdGggc2V2X3NucF9pbml0KCkg
YW5kIHNldl9wbGF0Zm9ybV9pbml0KCkgDQo+ID4gYXJlIHByb3RlY3RlZCBmcm9tIGJlaW5nIGNh
bGxlZCBhZ2Fpbiwgc28gdGhlcmUgd29uJ3QgYmUgYW55IGlzc3VlcyANCj4gPiBpZiB0aGVzZSBm
dW5jdGlvbnMgYXJlIGludm9rZWQgYWdhaW4gYXQgU05QL1NFViBWTSBsYXVuY2ggaWYgdGhleSAN
Cj4gPiBoYXZlIGJlZW4gaW52b2tlZCBlYXJsaWVyIGR1cmluZyBtb2R1bGUgaW5pdC4NCj4NCj4g
PlRoYXQncyBvbmUgc29sdXRpb24uIEkgZG9uJ3Qga25vdyBpZiB0aGVyZSBpcyBhIGRvd25zaWRl
IHRvIHRoZSBzeXN0ZW0gZm9yIGVuYWJsaW5nIFNFViBpZiBTTlAgaXMgYmVpbmcgZW5hYmxlZCBi
dXQgYW5vdGhlciBzb2x1dGlvbiBjb3VsZCBiZSB0byBqdXN0IGRpcmVjdGx5IHBsYWNlIGEgREZf
RkxVU0ggY29tbWFuZCBpbnN0ZWFkIG9mIGNhbGxpbmcgc2V2X3BsYXRmb3JtX2luaXQoKS4NCj4N
Cj4gQWN0dWFsbHkgc2V2X3BsYXRmb3JtX2luaXQoKSBpcyBhbHJlYWR5IGNhbGxlZCBvbiBtb2R1
bGUgaW5pdCBpZiBwc3BfaW5pdF9vbl9wcm9iZSBpcyBub3QgZmFsc2UuIE9ubHkgbmVlZCB0byBl
bnN1cmUgdGhhdCBTTlAgZmlybXdhcmUgaXMgaW5pdGlhbGl6ZWQgZmlyc3Qgd2l0aCBTTlBfSU5J
VCBjb21tYW5kLg0KDQo+IEJ1dCBpZiBwc3BfaW5pdF9vbl9wcm9iZSBpcyBmYWxzZSwgc2V2X3Bs
YXRmb3JtX2luaXQoKSBpc24ndCBjYWxsZWQgZG93biB0aGlzIHBhdGguIEFscGVyIGhhcyBzdWdn
ZXN0ZWQgd2UgYWx3YXlzIGNhbGwgc2V2X3BsYXRmb3JtX2luaXQoKSBidXQgd2UgY291bGQganVz
dCBwbGFjZSBhbiBTRVZfREZfRkxVU0ggY29tbWFuZCBpbnN0ZWFkLiBPciBhbSBJIHN0aWxsIG1p
c3Npbmcgc29tZXRoaW5nPw0KDQo+QWZ0ZXIgU0VWIElOSVRfRVggc3VwcG9ydCBwYXRjaGVzLCBT
RVYgbWF5IGJlIGluaXRpYWxpemVkIGluIHRoZSBwbGF0Zm9ybSBsYXRlLg0KPiBJbiBteSB0ZXN0
cywgaWYgU0VWIGhhcyBub3QgYmVlbiBpbml0aWFsaXplZCBpbiB0aGUgcGxhdGZvcm0gDQo+IHll
dCwgU05QIFZNcyBmYWlsIHdpdGggU0VWX0RGX0ZMVVNIIHJlcXVpcmVkIGVycm9yLiBJIHRyaWVk
IA0KPiBjYWxsaW5nIFNFVl9ERl9GTFVTSCByaWdodCBhZnRlciB0aGUgU05QIHBsYXRmb3JtIGlu
aXQuDQoNCkFyZSB5b3UgZ2V0dGluZyB0aGUgRExGTFVTSF9SRVFVSVJFRCBlcnJvciBhZnRlciB0
aGUgU05QIGFjdGl2YXRlIGNvbW1hbmQgPw0KDQpBbHNvIGRpZCB5b3UgdXNlIHRoZSBTRVZfREZf
RkxVU0ggY29tbWFuZCBvciB0aGUgU05QX0RGX0ZMVVNIIGNvbW1hbmQgPw0KDQpXaXRoIFNOUCB5
b3UgbmVlZCB0byB1c2UgU05QX0RGX0ZMVVNIIGNvbW1hbmQuDQoNClRoYW5rcywNCkFzaGlzaA0K
