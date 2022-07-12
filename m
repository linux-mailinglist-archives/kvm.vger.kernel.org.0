Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EE24F571EF5
	for <lists+kvm@lfdr.de>; Tue, 12 Jul 2022 17:23:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233958AbiGLPXk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 12 Jul 2022 11:23:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54436 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233609AbiGLPXI (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 12 Jul 2022 11:23:08 -0400
Received: from NAM02-DM3-obe.outbound.protection.outlook.com (mail-dm3nam02on2065.outbound.protection.outlook.com [40.107.95.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 468A6237F8;
        Tue, 12 Jul 2022 08:22:10 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=SSMiHWpePlhRbb9VR7EDjHVszbEx6sxxUg71PHmbkEOQXdFf12rOaPbELt/VHMC7Ur7sEkPWp6xga/BLpKyn5ERTDtS/X+fxRag8fn2yug3cu0ZCvoWJzXDT5pYBQXx9my5yIUo+XiVjgKlwt4Ah1IruZ9rwNMM23onrzkB8dl7I+yPNlE2YXQubhjZn42nUGKzeAKjOq397h7cH/eTOuG5v5Qdw+wQdv10H3lO/5iMQL2LvxijxQkLgpjZVIlW/qUx0ll0mSFVwfxVxPma5M7J+Ie9cP37f5NOIR2Sw/antJS4Z481uX7mpnhA9uTMs1fbhFi4SCvjkrWGkdzUYLA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=7ailX+9hOLD6LEmrRHg5AMDnjpSrStIxgwehs6LnXUw=;
 b=cvkamR4RQtmrA77WXkRhw2r4nsgZhXb01cXko7uE7+yXVPiBpCCI5pSX/sR6tLtiK+1kFlio0hQBNGnFIaGQRzI37rNgMd8QHk5V4Db+cRkyNEl5IrJxRze17KBybd0V3Ts7YDst3nbJ/6DTdOf+OcQjoSrb6Zhu6J0y1VOdglafUsnKGjOq39c5n9tMI06i6tu3E9V9EHH2PhO+yB3nt6Lb46tTC44c3YiXhhz/FzwQpReLGN2vhbKoS+qfcZMXb0UcmCwlK36F/XwEcaagxEsx7KS0DVbAF7aMxToH7uIyEL5is121lPYOYQ6OfvAp7C6rNoFifNDddJ1vRBKwdQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7ailX+9hOLD6LEmrRHg5AMDnjpSrStIxgwehs6LnXUw=;
 b=4X2Vf2b1Lf5aRyFeMBti5kGie9FbyJ3af5tMyM5fBMULlANP1SjblXo1+InTJtP6RK92aIoFnJozMFQhe28KlagWEcsxY6xAsXpz5qNR4xmWLQoobTc6I8gKXkTcM7EBXT7a5RENJkD86jwOGM/mbF16tP20NyEhA17/attRGOg=
Received: from SN6PR12MB2767.namprd12.prod.outlook.com (2603:10b6:805:75::23)
 by DM6PR12MB4617.namprd12.prod.outlook.com (2603:10b6:5:35::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5417.16; Tue, 12 Jul
 2022 15:22:08 +0000
Received: from SN6PR12MB2767.namprd12.prod.outlook.com
 ([fe80::8953:6baa:97bb:a15d]) by SN6PR12MB2767.namprd12.prod.outlook.com
 ([fe80::8953:6baa:97bb:a15d%7]) with mapi id 15.20.5417.026; Tue, 12 Jul 2022
 15:22:07 +0000
From:   "Kalra, Ashish" <Ashish.Kalra@amd.com>
To:     Peter Gonda <pgonda@google.com>
CC:     the arch/x86 maintainers <x86@kernel.org>,
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
Subject: RE: [PATCH Part2 v6 28/49] KVM: SVM: Add KVM_SEV_SNP_LAUNCH_FINISH
 command
Thread-Topic: [PATCH Part2 v6 28/49] KVM: SVM: Add KVM_SEV_SNP_LAUNCH_FINISH
 command
Thread-Index: AQHYlS9F8Lv7wrs5NE6SmQ1dqRz5cK15oJ+wgAExBACAAAQscA==
Date:   Tue, 12 Jul 2022 15:22:07 +0000
Message-ID: <SN6PR12MB2767D8C552388D438D9F88268E869@SN6PR12MB2767.namprd12.prod.outlook.com>
References: <cover.1655761627.git.ashish.kalra@amd.com>
 <6a513cf79bf71c479dbd72165faf1d804d77b3af.1655761627.git.ashish.kalra@amd.com>
 <CAMkAt6obGwyiJh7J34Vt8tC+XXMNm8YPrv4gV=TVoF2Xga5GjQ@mail.gmail.com>
 <SN6PR12MB27672AA31E96179256235C338E879@SN6PR12MB2767.namprd12.prod.outlook.com>
 <CAMkAt6ryLr6a5iQnwZQT3hqwEpZpb7bn-T8SDY6=5zYs_5NBow@mail.gmail.com>
In-Reply-To: <CAMkAt6ryLr6a5iQnwZQT3hqwEpZpb7bn-T8SDY6=5zYs_5NBow@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: MSIP_Label_4342314e-0df4-4b58-84bf-38bed6170a0f_Enabled=true;
 MSIP_Label_4342314e-0df4-4b58-84bf-38bed6170a0f_SetDate=2022-07-12T15:00:14Z;
 MSIP_Label_4342314e-0df4-4b58-84bf-38bed6170a0f_Method=Standard;
 MSIP_Label_4342314e-0df4-4b58-84bf-38bed6170a0f_Name=General;
 MSIP_Label_4342314e-0df4-4b58-84bf-38bed6170a0f_SiteId=3dd8961f-e488-4e60-8e11-a82d994e183d;
 MSIP_Label_4342314e-0df4-4b58-84bf-38bed6170a0f_ActionId=c2e7c0e8-63b9-4bfc-bb40-f18ed9570a37;
 MSIP_Label_4342314e-0df4-4b58-84bf-38bed6170a0f_ContentBits=1
msip_label_4342314e-0df4-4b58-84bf-38bed6170a0f_enabled: true
msip_label_4342314e-0df4-4b58-84bf-38bed6170a0f_setdate: 2022-07-12T15:22:05Z
msip_label_4342314e-0df4-4b58-84bf-38bed6170a0f_method: Standard
msip_label_4342314e-0df4-4b58-84bf-38bed6170a0f_name: General
msip_label_4342314e-0df4-4b58-84bf-38bed6170a0f_siteid: 3dd8961f-e488-4e60-8e11-a82d994e183d
msip_label_4342314e-0df4-4b58-84bf-38bed6170a0f_actionid: c4f7944c-c2eb-49e4-893e-afbccb369e7f
msip_label_4342314e-0df4-4b58-84bf-38bed6170a0f_contentbits: 0
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 1a144877-9f88-4091-75c2-08da641a48bb
x-ms-traffictypediagnostic: DM6PR12MB4617:EE_
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 9U0EEVYGoGIHfr5iyjlmJqSgABBzoeQcDhivG179iXKDKVBC3XifN8ASMWny3TfJixCyasjVxn86g91AMJCHw3DGK/SSeG5m+lTBE070lSDZi1lOIVRsFc/GQQ1AcoNXkElIGqlaBNcO2mhvbR6ebtyP+3eY7i+tJ3QgoF/XdGpJ0eIghxp4gJOcbBsLd4Yzi5/mMMjNlHaiEAgRTb0Ib58FaniQF6aP11DiB7XxEtraobe8r9Aabq4tAUUWec4ZJKnrAjv8STKi+938WtoPoCO6fSww796+Gbjp8EaJZmC8P4EP/BXgXn/jipS94qWsdzWDgbG+SNRpy6tjJEsYS4HsVAU0WMfH8DzuZM7LFB1hEEMAlE3Wal7zXg8D/9tIBSTrv+l0EecjqqqZi6TzCvRiQS+CztOtbGh25JmcF/I+I1D/pg4WQSVx3aq1kAJ0/dAQSYVCHz4ixvZJj1LHiWam1GRam1MCGRwQh0itOChrxiHljnZG3PCY8GKs+Z7/bFZF2o1awKxDM50lCTgr79kK2HtijhVXHTbjotZc0vz7BkNbl5NCgFJtziYO6AfV9zJzC6+Jiby/9eR7+Bt5PvB/16qNNi5LiQYKOdQu9X1EpvH5pjxMSLd7lhZ77LF7sNUCRzszUPHt4l3VK7xemxsBTdJ2FLz0Db+IBB8HQyYpZIkfZZ7EvkT/ZvvZULB9hmqH73bfBOYEDSzopthu78xDb76dDi0o3GBPlVnzrxxB3lTpCYBVcjn1EbTibUk4zpiQEmcdjv2iejVatR1NH/SrtDRvMDuM3kbqlcPz1RZeGQ2zgusulq3wOMo9Zs7fQNjlHysURKxapNAwwSop4A==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR12MB2767.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(376002)(136003)(396003)(346002)(366004)(39860400002)(71200400001)(38070700005)(478600001)(33656002)(38100700002)(122000001)(186003)(7696005)(316002)(45080400002)(66556008)(26005)(8676002)(66476007)(86362001)(6916009)(66946007)(66446008)(76116006)(54906003)(4326008)(64756008)(55016003)(6506007)(8936002)(7416002)(7406005)(5660300002)(52536014)(2906002)(83380400001)(9686003)(41300700001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?mVmCjZZXKfF/0QL0NGoWvFznYuGB+E7QYc8VB+CSsh7hcxxdIZhzhP01dA2F?=
 =?us-ascii?Q?SKJv/dH3gvzuVfz6TMWVUPvSw6CQ46SkfAmZjhbdx9pjax9390MiUa/hstn3?=
 =?us-ascii?Q?cAXNCCLtG5VLO9hGug4x3CrSocdFyX6r6p1nsXHPB9wChVTGyI0g82rUxXsU?=
 =?us-ascii?Q?moZ4MJtS+wkNRh6uKZzQ1fdDHSVPbcwgxJ6VH4+dY1crWE7C6Nsbqoq4jwfO?=
 =?us-ascii?Q?+e6AV7I6A/lsrCDUaHEAHiz5sLFEyESC8FRn5l2ru9086Bpc7jrD2jY4tCkx?=
 =?us-ascii?Q?NFuRqL5l58b/QGC72JISGJ2rW3Nd6jO4xYFw2FLSsVNqIO3AlxkpPSYV4vtM?=
 =?us-ascii?Q?S5tRfl+whYSyWNSF1p8uQvjc/zQB3j2ZAlI/ivEzNjMZZLFe/amvWhc5swSE?=
 =?us-ascii?Q?wFnCCNmp3rCYx04l06UGN+Mj9uolGLNHUY/kOhJi/L92uLktq7X5VcPXxWMy?=
 =?us-ascii?Q?ZNI3ZbmwKEEz/ddyZjmAXqVhnXXJlnbR1596biL6CQUI5lzEVcAAQ7jsCjl+?=
 =?us-ascii?Q?jwn/7aFaYiPRkawMzUv3u5BUK5iFKT4kKBduBJsxiZzFepNTN6rqCsSfjjfo?=
 =?us-ascii?Q?xFblqIjll9kf+TivlNvCunM4t8hncy2ywq/aGCeavcfs0fM2w528MGtyPvOn?=
 =?us-ascii?Q?Mu8/MiBC8o0bgieZv7NMqvU7rIfhsPuWkHwygP7ACE8VeguvBiCPvyA/JeGW?=
 =?us-ascii?Q?/aT9EN1ggU6xPQoDJ+Gwbeo8BWMuQpEoNuWb7SsAbGng2KxVAIG6a975JlEX?=
 =?us-ascii?Q?J/hB4QHUf99zGG4vNKkFvmSvggFDr2eIMkqX13WzzoxgnYajNBUegI8w0U8v?=
 =?us-ascii?Q?xLn6EQ4emkJ4fXsSVQTUTOEK59qhoB7eDZIFeSddcpAAUtO1htxh7UsrFQYo?=
 =?us-ascii?Q?x9lIQuM12wUyEMlJu5WV14d64S3JASpIpY7idM3tlJ5etPlIgf7T3a9zleXr?=
 =?us-ascii?Q?HfGjJeLEPAw+ktS4lDZ2Cb9Xu0TURd2hxZntZ+JQ7x22XKkXQ8JQIWX+WDIm?=
 =?us-ascii?Q?t9xELOOczSdn1K3/bbEPSgeF9kOXjmHLwL5EH+u+4OlgnVXsYB+1niL0U6Ms?=
 =?us-ascii?Q?UtHdAdckASiyKcxa/LAzXb56sm9kmISSfMrNDlbyyr9rx/oJQf52PuwzwC48?=
 =?us-ascii?Q?rd+VwssIbtiq42+0/e7tQq52eyWr9dqgh+y7d+YdAo7Zlv9v1k7U/eNMfh+n?=
 =?us-ascii?Q?1na80M0HV5tQq+mSYzy0/FaRzEkrJKaWfcGZsiQTCkeeLb/L6YMQrrWeOLHo?=
 =?us-ascii?Q?Ql9YAKYOTYYOPpPiHi2GtueIdcdfF+dyS2Cvjk/wIq9wuW3H3l1GdbP2wFoI?=
 =?us-ascii?Q?5PsFsJE5eEtEto1mciUYgnoc2MMDFVTBdhP0YHnbnWlHugZTuECVciZcE5hS?=
 =?us-ascii?Q?Thb4bQIKkUuSBmhKVcj+3S3xifAXPVdwMqHapFhXF1NI4EDp7nd1nKZ9z7WJ?=
 =?us-ascii?Q?PA+QC0le8X+3acJNlT2WcLFJRaOWwXm55HkSI5dEaV5vKEcxNVK0pT62c8ag?=
 =?us-ascii?Q?24PGUuiOas9qGLcsWMrpe7TKFDG6JKwTsGZStIt35ZY4nFZx6cvyTPyAI4O+?=
 =?us-ascii?Q?cVtpz5iFwn63u3cYD00=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SN6PR12MB2767.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1a144877-9f88-4091-75c2-08da641a48bb
X-MS-Exchange-CrossTenant-originalarrivaltime: 12 Jul 2022 15:22:07.7893
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: MiPMcGjBzFjPsoUAiGEfWUUtqF5GvJa2AW02yfRL+X3YkkzPQX+ZvptvPja2gqhDNe6YWrX3wbyKo5vePHO6lA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB4617
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

>> >Given the guest uses the SNP NAE AP boot protocol we were expecting tha=
t there would be some option to add vCPUs to the VM but mark them as "pendi=
ng AP boot creation protocol" state. This would allow the LaunchDigest of a=
 VM doesn't change >just because its vCPU count changes. Would it be possib=
le to add a new add an argument to KVM_SNP_LAUNCH_FINISH to tell it which v=
CPUs to LAUNCH_UPDATE VMSA pages for or similarly a new argument for KVM_CR=
EATE_VCPU?
>>
>> But don't we want/need to measure all vCPUs using LAUNCH_UPDATE_VMSA bef=
ore we issue SNP_LAUNCH_FINISH command ?
>>
>> If we are going to add vCPUs and mark them as "pending AP boot creation"=
 state then how are we going to do LAUNCH_UPDATE_VMSAs for them after SNP_L=
AUNCH_FINISH ?

>If I understand correctly we don't need or even want the APs to be LAUNCH_=
UPDATE_VMSA'd. LAUNCH_UPDATEing all the VMSAs causes VMs with different num=
bers of vCPUs to have different launch digests. Its my understanding the SN=
P AP >Creation protocol was to solve this so that VMs with different vcpu c=
ounts have the same launch digest.

>Looking at patch "[Part2,v6,44/49] KVM: SVM: Support SEV-SNP AP Creation N=
AE event" and section "4.1.9 SNP AP Creation" of the GHCB spec. There is no=
 need to mark the LAUNCH_UPDATE the AP's VMSA or mark the vCPUs runnable. I=
nstead we >can do that only for the BSP. Then in the guest UEFI the BSP can=
: create new VMSAs from guest pages, RMPADJUST them into the RMP state VMSA=
, then use the SNP AP Creation NAE to get the hypervisor to mark them runna=
ble. I believe this is all >setup in the UEFI patch:
>https://nam11.safelinks.protection.outlook.com/?url=3Dhttps%3A%2F%2Fwww.ma=
il-archive.com%2Fdevel%40edk2.groups.io%2Fmsg38460.html&amp;data=3D05%7C01%=
7CAshish.Kalra%40amd.com%7Ca40178ac6f284a9e33aa08da64152baa%>7C3dd8961fe488=
4e608e11a82d994e183d%7C0%7C0%7C637932339382401133%7CUnknown%7CTWFpbGZsb3d8e=
yJWIjoiMC4wLjAwMDAiLCJQIjoiV2luMzIiLCJBTiI6Ik1haWwiLCJXVCI6Mn0%3D%7C3000%7C=
%7C%7C&amp;sdata=3DZaiHHo9S24f9BB6E%>2FjexOt5TdKJQXxQDJI5QoYdDDHc%3D&amp;re=
served=3D0.

Yes, I discussed the same with Tom, and this will be supported going forwar=
d, only the BSP will need to go through the LAUNCH_UPDATE_VMSA and at runti=
me the guest can dynamically create more APs using the SNP AP Creation NAE =
event.

Now, coming back to the original question, why do we need a separate vCPU c=
ount argument for SNP_LAUNCH_FINISH, won't the statically created vCPUs in =
kvm->created_vcpus/online_vcpus be sufficient for that, any dynamically cre=
ated
vCPU's won't be part of the initial measurement or LaunchDigest of the VM, =
right ?

Thanks,
Ashish
